Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3376A2F2AB6
	for <lists+linux-bcache@lfdr.de>; Tue, 12 Jan 2021 10:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388433AbhALJEV (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 12 Jan 2021 04:04:21 -0500
Received: from mga05.intel.com ([192.55.52.43]:6869 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392497AbhALJEG (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 12 Jan 2021 04:04:06 -0500
IronPort-SDR: C2rQMFMPYtmLkmgW/2WUQSxDKNcHVIHI8F0oGXFjSkDav2aCIWX8RDYwsMUTj9ozJU1YZqW0Rm
 IMYyyn+uESKQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9861"; a="262793382"
X-IronPort-AV: E=Sophos;i="5.79,341,1602572400"; 
   d="scan'208";a="262793382"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 01:03:12 -0800
IronPort-SDR: bs0ozLz/k6UKPIrT9bIgLkx1mDNkRldk5rd8o01W2+5XJ6UgY9h4brMPzIPeCNOTCUG+/JLjcE
 yigIHTiGtq4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,341,1602572400"; 
   d="scan'208";a="352948952"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by fmsmga008.fm.intel.com with ESMTP; 12 Jan 2021 01:03:10 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        linux-bcache@vger.kernel.org
Subject: [RFC PATCH v4 4/8] bcache: bch_nvm_alloc_pages() of the buddy
Date:   Tue, 12 Jan 2021 11:45:01 -0500
Message-Id: <20210112164505.68228-5-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210112164505.68228-1-qiaowei.ren@intel.com>
References: <20210112164505.68228-1-qiaowei.ren@intel.com>
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
index f25cfdd8b87f..4dcde4ea7556 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -119,6 +119,141 @@ static inline void remove_owner_space(struct bch_nvm_namespace *ns,
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
+		for (i = order; i < BCH_MAX_ORDER; i++) {
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
 	struct bch_owner_list_head *owner_list_head;
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
index 33d849528fb3..b198e8fd5816 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -77,6 +77,7 @@ extern struct bch_nvm_set *only_set;
 struct bch_nvm_namespace *bch_register_namespace(const char *dev_path);
 int bch_nvm_init(void);
 void bch_nvm_exit(void);
+void *bch_nvm_alloc_pages(int order, const char *owner_uuid);
 
 #else
 
@@ -90,6 +91,11 @@ static inline int bch_nvm_init(void)
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

