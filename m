Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487D92E192F
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Dec 2020 08:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbgLWHBH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Dec 2020 02:01:07 -0500
Received: from mga18.intel.com ([134.134.136.126]:58035 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727314AbgLWHBH (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Dec 2020 02:01:07 -0500
IronPort-SDR: 2KBEM4CM1JOIh+jq3+KIBvDWsIaP7pKyrzHVk5R7PzoMHyDfW0QmIVbAF8sppke1RbhkTEQNUc
 xc3VZi0X1tng==
X-IronPort-AV: E=McAfee;i="6000,8403,9843"; a="163695085"
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="163695085"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2020 23:00:12 -0800
IronPort-SDR: CqCzGOWuFo/HKJNPbkv5KYLlfzMnPilWzwCD8NaEiz8TR2Qr4NROrynsHmKn7W/kfo36BrKOS3
 pqG7mo9S6z0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="344924258"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by fmsmga008.fm.intel.com with ESMTP; 22 Dec 2020 23:00:11 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        linux-bcache@vger.kernel.org
Subject: [PATCH 4/8] bcache: nvm_alloc_pages() of the buddy
Date:   Wed, 23 Dec 2020 09:41:32 -0500
Message-Id: <20201223144136.24966-5-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201223144136.24966-1-qiaowei.ren@intel.com>
References: <20201223144136.24966-1-qiaowei.ren@intel.com>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch implements the nvm_alloc_pages() of the buddy.

Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/nvm-pages.c | 136 ++++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvm-pages.h |   4 +
 2 files changed, 140 insertions(+)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index 7ffbfbacaf3f..2cde62081c4f 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -95,6 +95,142 @@ static inline void remove_owner_space(struct nvm_namespace *ns,
 	bitmap_set(ns->pages_bitmap, pgoff, nr);
 }
 
+/* If not found, it will create if create == true */
+static struct owner_list *find_owner_list(const char *owner_uuid, bool create)
+{
+	struct owner_list *owner_list;
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
+static struct nvm_alloced_recs *find_nvm_alloced_recs(struct owner_list *owner_list,
+		struct nvm_namespace *ns, bool create)
+{
+	int position = ns->sb->this_namespace_nr;
+
+	if (create && !owner_list->alloced_recs[position]) {
+		struct nvm_alloced_recs *extents =
+			kzalloc(sizeof(struct nvm_alloced_recs), GFP_KERNEL);
+
+		extents->ns = ns;
+		INIT_LIST_HEAD(&extents->extent_head);
+		owner_list->alloced_recs[position] = extents;
+		return extents;
+	} else
+		return owner_list->alloced_recs[position];
+}
+
+static inline void *extent_end_addr(struct extent *extent)
+{
+	return extent->kaddr + (extent->nr << PAGE_SHIFT);
+}
+
+static void add_extent(struct nvm_alloced_recs *alloced_recs, void *addr, int order)
+{
+	struct list_head *list = alloced_recs->extent_head.next;
+	struct extent *extent;
+	void *end_addr = addr + ((1 << order) << PAGE_SHIFT);
+
+	while (list != &alloced_recs->extent_head) {
+		extent = container_of(list, struct extent, list);
+		if (end_addr == extent->kaddr) {
+			extent->kaddr = addr;
+			extent->nr += 1 << order;
+			break;
+		} else if (extent_end_addr(extent) == addr) {
+			extent->nr += 1 << order;
+			break;
+		} else if (end_addr < extent->kaddr) {
+			struct extent *e = kzalloc(sizeof(struct extent), GFP_KERNEL);
+
+			e->kaddr = addr;
+			e->nr = 1 << order;
+			list_add_tail(&e->list, &extent->list);
+			alloced_recs->size++;
+			break;
+		}
+		list = list->next;
+	}
+
+	if (list == &alloced_recs->extent_head) {
+		struct extent *e = kzalloc(sizeof(struct extent), GFP_KERNEL);
+
+		e->kaddr = addr;
+		e->nr = 1 << order;
+		list_add(&e->list, &alloced_recs->extent_head);
+		alloced_recs->size++;
+	}
+}
+
+void *nvm_alloc_pages(int order, const char *owner_uuid)
+{
+	void *kaddr = NULL;
+	struct owner_list *owner_list;
+	struct nvm_alloced_recs *alloced_recs;
+	int i, j;
+
+	mutex_lock(&only_set->lock);
+	owner_list = find_owner_list(owner_uuid, true);
+
+	for (j = 0; j < only_set->total_namespaces_nr; j++) {
+		struct nvm_namespace *ns = only_set->nss[j];
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
+EXPORT_SYMBOL_GPL(nvm_alloc_pages);
+
 static void init_owner_info(struct nvm_namespace *ns)
 {
 	struct owner_list_head *owner_list_head;
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
index d91352496af1..95b7fa4b7dd0 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -77,6 +77,8 @@ extern struct nvm_namespace *register_namespace(const char *dev_path);
 extern int bch_nvm_init(void);
 extern void bch_nvm_exit(void);
 
+extern void *nvm_alloc_pages(int order, const char *owner_uuid);
+
 #else
 
 static inline struct nvm_namespace *register_namespace(const char *dev_path)
@@ -89,6 +91,8 @@ static inline int bch_nvm_init(void)
 }
 static inline void bch_nvm_exit(void) { }
 
+static inline void *nvm_alloc_pages(int order, const char *owner_uuid) { }
+
 #endif /* CONFIG_BCACHE_NVM_PAGES */
 
 #endif /* _BCACHE_NVM_PAGES_H */
-- 
2.17.1

