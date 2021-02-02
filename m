Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA8230B56B
	for <lists+linux-bcache@lfdr.de>; Tue,  2 Feb 2021 03:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbhBBCoE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 1 Feb 2021 21:44:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:47751 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229822AbhBBCoD (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 1 Feb 2021 21:44:03 -0500
IronPort-SDR: O9gCQFzNsznhKy7QLGQT70LaslvPBqXm8q+4XkM8Q0NXB4x/b/YLPMiuBN6HSyuHjcwXtuRZRE
 8QVUHAExccdg==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="167893404"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="167893404"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 18:43:04 -0800
IronPort-SDR: 6j6Q4PacB24DkeI/rSX6c44i1zp7wN9VhDF161CVVqn3u/4TEsSSfoccFciqCyM3lbSXf58cYc
 EjGPnPLMpVAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="370226426"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by fmsmga008.fm.intel.com with ESMTP; 01 Feb 2021 18:43:03 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        linux-bcache@vger.kernel.org
Subject: [RFC PATCH v5 5/8] bcache: bch_nvm_free_pages() of the buddy
Date:   Tue,  2 Feb 2021 05:23:49 -0500
Message-Id: <20210202102352.4833-6-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210202102352.4833-1-qiaowei.ren@intel.com>
References: <20210202102352.4833-1-qiaowei.ren@intel.com>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch implements the bch_nvm_free_pages() of the buddy.

Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/nvm-pages.c | 157 ++++++++++++++++++++++++++++++++--
 drivers/md/bcache/nvm-pages.h |   4 +-
 2 files changed, 154 insertions(+), 7 deletions(-)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index cdf1594bfd0e..1b72266d0619 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -221,6 +221,153 @@ static void add_extent(struct bch_nvm_alloced_recs *alloced_recs, void *addr, in
 	}
 }
 
+static inline void *nvm_end_addr(struct bch_nvm_namespace *ns)
+{
+	return ns->kaddr + (ns->pages_total << PAGE_SHIFT);
+}
+
+static inline bool in_nvm_range(struct bch_nvm_namespace *ns,
+		void *start_addr, void *end_addr)
+{
+	return (start_addr >= ns->kaddr) && (end_addr <= nvm_end_addr(ns));
+}
+
+static struct bch_nvm_namespace *find_nvm_by_addr(void *addr, int order)
+{
+	int i;
+	struct bch_nvm_namespace *ns;
+
+	for (i = 0; i < only_set->total_namespaces_nr; i++) {
+		ns = only_set->nss[i];
+		if (ns && in_nvm_range(ns, addr, addr + (1 << order)))
+			return ns;
+	}
+	return NULL;
+}
+
+static int remove_extent(struct bch_nvm_alloced_recs *alloced_recs, void *addr, int order)
+{
+	struct list_head *list = alloced_recs->extent_head.next;
+	struct bch_extent *extent, *tmp;
+	void *end_addr = addr + (((u64)1 << order) << PAGE_SHIFT);
+
+	while (list != &alloced_recs->extent_head) {
+		extent = container_of(list, struct bch_extent, list);
+
+		if (addr < extent->kaddr)
+			return -ENOENT;
+
+		if (addr > extent_end_addr(extent)) {
+			list = list->next;
+			continue;
+		}
+
+		if (addr == extent->kaddr) {
+			if (extent->nr == (1 << order)) {
+				list_del(list);
+				kfree(extent);
+				alloced_recs->nr--;
+			} else {
+				extent->kaddr = end_addr;
+				extent->nr -= 1 << order;
+			}
+		} else {
+			if (extent_end_addr(extent) > end_addr) {
+				tmp = kzalloc(sizeof(*tmp), GFP_KERNEL|__GFP_NOFAIL);
+
+				tmp->kaddr = end_addr;
+				tmp->nr = (extent_end_addr(extent) - end_addr) >> PAGE_SHIFT;
+				list_add(&tmp->list, list);
+				alloced_recs->nr++;
+			}
+			extent->nr = (addr - extent->kaddr) >> PAGE_SHIFT;
+		}
+		break;
+	}
+	return (list == &alloced_recs->extent_head) ? -ENOENT : 0;
+}
+
+static void __free_space(struct bch_nvm_namespace *ns, void *addr, int order)
+{
+	unsigned int add_pages = (1 << order);
+	pgoff_t pgoff;
+	struct page *page;
+
+	page = nvm_vaddr_to_page(ns, addr);
+	WARN_ON((!page) || (page->private != order));
+	pgoff = page->index;
+
+	while (order < BCH_MAX_ORDER - 1) {
+		struct page *buddy_page;
+
+		pgoff_t buddy_pgoff = pgoff ^ (1 << order);
+		pgoff_t parent_pgoff = pgoff & ~(1 << order);
+
+		if ((parent_pgoff + (1 << (order + 1)) > ns->pages_total))
+			break;
+
+		buddy_page = nvm_vaddr_to_page(ns, nvm_pgoff_to_vaddr(ns, buddy_pgoff));
+		WARN_ON(!buddy_page);
+
+		if (PageBuddy(buddy_page) && (buddy_page->private == order)) {
+			list_del((struct list_head *)&buddy_page->zone_device_data);
+			__ClearPageBuddy(buddy_page);
+			pgoff = parent_pgoff;
+			order++;
+			continue;
+		}
+		break;
+	}
+
+	page = nvm_vaddr_to_page(ns, nvm_pgoff_to_vaddr(ns, pgoff));
+	WARN_ON(!page);
+	list_add((struct list_head *)&page->zone_device_data, &ns->free_area[order]);
+	page->index = pgoff;
+	set_page_private(page, order);
+	__SetPageBuddy(page);
+	ns->free += add_pages;
+}
+
+void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid)
+{
+	struct bch_nvm_namespace *ns;
+	struct bch_owner_list *owner_list;
+	struct bch_nvm_alloced_recs *alloced_recs;
+	int r;
+
+	mutex_lock(&only_set->lock);
+
+	ns = find_nvm_by_addr(addr, order);
+	if (!ns) {
+		pr_info("can't find nvm_dev by kaddr %p\n", addr);
+		goto unlock;
+	}
+
+	owner_list = find_owner_list(owner_uuid, false);
+	if (!owner_list) {
+		pr_info("can't found owner(uuid=%s)\n", owner_uuid);
+		goto unlock;
+	}
+
+	alloced_recs = find_nvm_alloced_recs(owner_list, ns, false);
+	if (!alloced_recs) {
+		pr_info("can't find alloced_recs(uuid=%s)\n", ns->uuid);
+		goto unlock;
+	}
+
+	r = remove_extent(alloced_recs, addr, order);
+	if (r < 0) {
+		pr_info("can't find extent\n");
+		goto unlock;
+	}
+
+	__free_space(ns, addr, order);
+
+unlock:
+	mutex_unlock(&only_set->lock);
+}
+EXPORT_SYMBOL_GPL(bch_nvm_free_pages);
+
 void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
 {
 	void *kaddr = NULL;
@@ -306,11 +453,9 @@ static int init_owner_info(struct bch_nvm_namespace *ns)
 			mutex_unlock(&only_set->lock);
 			return -ENOMEM;
 		}
-
 		for (j = 0; j < only_set->total_namespaces_nr; j++) {
 			if (!only_set->nss[j] || !owner_head->recs[j])
 				continue;
-
 			nvm_pgalloc_recs = (struct bch_nvm_pgalloc_recs *)
 					((long)owner_head->recs[j] + ns->kaddr);
 			if (memcmp(nvm_pgalloc_recs->magic, bch_nvm_pages_pgalloc_magic, 16)) {
@@ -374,7 +519,7 @@ static void init_nvm_free_space(struct bch_nvm_namespace *ns)
 {
 	unsigned int start, end, i;
 	struct page *page;
-	long long pages;
+	u64 pages;
 	pgoff_t pgoff_start;
 
 	bitmap_for_each_clear_region(ns->pages_bitmap, start, end, 0, ns->pages_total) {
@@ -390,8 +535,8 @@ static void init_nvm_free_space(struct bch_nvm_namespace *ns)
 			page = nvm_vaddr_to_page(ns, nvm_pgoff_to_vaddr(ns, pgoff_start));
 			page->index = pgoff_start;
 			set_page_private(page, i);
-			__SetPageBuddy(page);
-			list_add((struct list_head *)&page->zone_device_data, &ns->free_area[i]);
+			/* in order to update ns->free */
+			__free_space(ns, nvm_pgoff_to_vaddr(ns, pgoff_start), i);
 
 			pgoff_start += 1 << i;
 			pages -= 1 << i;
@@ -574,7 +719,7 @@ struct bch_nvm_namespace *bch_register_namespace(const char *dev_path)
 	ns->page_size = ns->sb.page_size;
 	ns->pages_offset = ns->sb.pages_offset;
 	ns->pages_total = ns->sb.pages_total;
-	ns->free = 0;
+	ns->free = 0; /* increased by __free_space() */
 	ns->bdev = bdev;
 	ns->nvm_set = only_set;
 
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
index 10157d993126..0523be433daa 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -80,7 +80,7 @@ struct bch_nvm_namespace *bch_register_namespace(const char *dev_path);
 int bch_nvm_init(void);
 void bch_nvm_exit(void);
 void *bch_nvm_alloc_pages(int order, const char *owner_uuid);
-
+void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid);
 #else
 
 static inline struct bch_nvm_namespace *bch_register_namespace(const char *dev_path)
@@ -98,6 +98,8 @@ static inline void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
 	return NULL;
 }
 
+static inline void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid) { }
+
 #endif /* CONFIG_BCACHE_NVM_PAGES */
 
 #endif /* _BCACHE_NVM_PAGES_H */
-- 
2.17.1

