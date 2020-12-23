Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5102E193B
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Dec 2020 08:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbgLWHFB (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Dec 2020 02:05:01 -0500
Received: from mga04.intel.com ([192.55.52.120]:26566 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727050AbgLWHFB (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Dec 2020 02:05:01 -0500
IronPort-SDR: G/A2rXXwoKIyO5rhc29z+Nb73WInNvUYMjk0vceFwksvPtq+bN6/IU+VuTp2/6PPb9I3ESQFaS
 Opzee1l35+sQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9843"; a="173405194"
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="173405194"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2020 23:03:41 -0800
IronPort-SDR: 2DIlnPeEJCxNzqopY4t1ik9ohJYlDpmIiyRbd2KxoGN2ugvUDS8UPRNKgVNGBR46mbM0CCtUwH
 zmSJeHvUInAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="565083503"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by fmsmga005.fm.intel.com with ESMTP; 22 Dec 2020 23:03:40 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Jianpeng Ma <jianpeng.ma@intel.com>, linux-bcache@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [RFC PATCH v2 4/8] bcache: bch_nvm_alloc_pages() of the buddy
Date:   Wed, 23 Dec 2020 09:44:58 -0500
Message-Id: <20201223144502.25029-5-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201223144502.25029-1-qiaowei.ren@intel.com>
References: <20201223144502.25029-1-qiaowei.ren@intel.com>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch implements the bch_nvm_alloc_pages() of the buddy.

Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/nvm-pages.c | 135 ++++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvm-pages.h |   6 ++
 2 files changed, 141 insertions(+)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index ea36994b5b00..2e91e1c8536f 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -105,6 +105,141 @@ static inline void remove_owner_space(struct bch_nvm_namespace *ns,
 	bitmap_set(ns->pages_bitmap, pgoff, nr);
 }
 
+/* If not found, it will create if create == true */
+static struct bch_owner_list *find_owner_list(const char *owner_uuid, bool create)
+{
+	struct bch_owner_list *owner_list;
+	int i;
+
+	for (i = 0; i < only_set->owner_list_size; i++) {
+		if (!memcmp(owner_uuid, only_set->owner_lists[i]->owner_uuid, 16))
+			return only_set->owner_lists[i];
+	}
+
+	if (create) {
+		owner_list = alloc_owner_list(owner_uuid, NULL, only_set->total_namespaces_nr);
+		only_set->owner_lists[only_set->owner_list_size++] = owner_list;
+		return owner_list;
+	} else
+		return NULL;
+}
+
+static struct bch_nvm_alloced_recs *find_nvm_alloced_recs(struct bch_owner_list *owner_list,
+		struct bch_nvm_namespace *ns, bool create)
+{
+	int position = ns->sb->this_namespace_nr;
+
+	if (create && !owner_list->alloced_recs[position]) {
+		struct bch_nvm_alloced_recs *alloced_recs =
+			kzalloc(sizeof(*alloced_recs), GFP_KERNEL|__GFP_NOFAIL);
+
+		alloced_recs->ns = ns;
+		INIT_LIST_HEAD(&alloced_recs->extent_head);
+		owner_list->alloced_recs[position] = alloced_recs;
+		return alloced_recs;
+	} else
+		return owner_list->alloced_recs[position];
+}
+
+static inline void *extent_end_addr(struct bch_extent *extent)
+{
+	return extent->kaddr + (extent->nr << PAGE_SHIFT);
+}
+
+static void add_extent(struct bch_nvm_alloced_recs *alloced_recs, void *addr, int order)
+{
+	struct list_head *list = alloced_recs->extent_head.next;
+	struct bch_extent *extent, *tmp;
+	void *end_addr = addr + ((1 << order) << PAGE_SHIFT);
+
+	while (list != &alloced_recs->extent_head) {
+		extent = container_of(list, struct bch_extent, list);
+		if (end_addr == extent->kaddr) {
+			extent->kaddr = addr;
+			extent->nr += 1 << order;
+			break;
+		} else if (extent_end_addr(extent) == addr) {
+			extent->nr += 1 << order;
+			break;
+		} else if (end_addr < extent->kaddr) {
+			tmp = kzalloc(sizeof(*tmp), GFP_KERNEL|__GFP_NOFAIL);
+			tmp->kaddr = addr;
+			tmp->nr = 1 << order;
+			list_add_tail(&tmp->list, &extent->list);
+			alloced_recs->size++;
+			break;
+		}
+		list = list->next;
+	}
+
+	if (list == &alloced_recs->extent_head) {
+		struct bch_extent *e = kzalloc(sizeof(*e), GFP_KERNEL);
+
+		e->kaddr = addr;
+		e->nr = 1 << order;
+		list_add(&e->list, &alloced_recs->extent_head);
+		alloced_recs->size++;
+	}
+}
+
+void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
+{
+	void *kaddr = NULL;
+	struct bch_owner_list *owner_list;
+	struct bch_nvm_alloced_recs *alloced_recs;
+	int i, j;
+
+	mutex_lock(&only_set->lock);
+	owner_list = find_owner_list(owner_uuid, true);
+
+	for (j = 0; j < only_set->total_namespaces_nr; j++) {
+		struct bch_nvm_namespace *ns = only_set->nss[j];
+
+		if (!ns || (ns->free < (1 << order)))
+			continue;
+
+		for (i = order; i < MAX_ORDER; i++) {
+			struct list_head *list;
+			struct page *page, *buddy_page;
+
+			if (list_empty(&ns->free_area[i]))
+				continue;
+
+			list = ns->free_area[i].next;
+			page = container_of((void *)list, struct page, zone_device_data);
+
+			list_del(list);
+
+			while (i != order) {
+				buddy_page = nvm_vaddr_to_page(ns,
+					nvm_pgoff_to_vaddr(ns, page->index + (1 << (i - 1))));
+				buddy_page->private = i - 1;
+				buddy_page->index = page->index + (1 << (i - 1));
+				__SetPageBuddy(buddy_page);
+				list_add((struct list_head *)&buddy_page->zone_device_data,
+					&ns->free_area[i - 1]);
+				i--;
+			}
+
+			page->private = order;
+			__ClearPageBuddy(page);
+			ns->free -= 1 << order;
+			kaddr = nvm_pgoff_to_vaddr(ns, page->index);
+			break;
+		}
+
+		if (i != MAX_ORDER) {
+			alloced_recs = find_nvm_alloced_recs(owner_list, ns, true);
+			add_extent(alloced_recs, kaddr, order);
+			break;
+		}
+	}
+
+	mutex_unlock(&only_set->lock);
+	return kaddr;
+}
+EXPORT_SYMBOL_GPL(bch_nvm_alloc_pages);
+
 static int init_owner_info(struct bch_nvm_namespace *ns)
 {
 	struct owner_list_head *owner_list_head;
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
index 15aa0f15760f..e470c21b3075 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -76,6 +76,7 @@ extern struct bch_nvm_set *only_set;
 struct bch_nvm_namespace *bch_register_namespace(const char *dev_path);
 int bch_nvm_init(void);
 void bch_nvm_exit(void);
+void *bch_nvm_alloc_pages(int order, const char *owner_uuid);
 
 #else
 
@@ -89,6 +90,11 @@ static inline int bch_nvm_init(void)
 }
 static inline void bch_nvm_exit(void) { }
 
+static inline void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_BCACHE_NVM_PAGES */
 
 #endif /* _BCACHE_NVM_PAGES_H */
-- 
2.17.1

