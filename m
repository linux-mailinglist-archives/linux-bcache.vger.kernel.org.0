Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4664F2E193C
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Dec 2020 08:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgLWHFK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Dec 2020 02:05:10 -0500
Received: from mga04.intel.com ([192.55.52.120]:26597 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727046AbgLWHFK (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Dec 2020 02:05:10 -0500
IronPort-SDR: 1jPYR4AgHevYx/QfkS/IUElVR6XDZv2RGnCi0s4jSPdgyuVxJZamfrHUsoH7Q6hoCLIfQW1MGh
 2/QESqKmj5sA==
X-IronPort-AV: E=McAfee;i="6000,8403,9843"; a="173405197"
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="173405197"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2020 23:03:42 -0800
IronPort-SDR: 8FsKRQL9Atwih1gmH9Xyc8KvUTi1TKAGWVSpDPBwNPdju3EH/idBH+R8sPzJ9tmI6yB0yWb7hw
 mla3RoKLta+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="565083523"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by fmsmga005.fm.intel.com with ESMTP; 22 Dec 2020 23:03:41 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Jianpeng Ma <jianpeng.ma@intel.com>, linux-bcache@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [RFC PATCH v2 5/8] bcache: bch_nvm_free_pages() of the buddy
Date:   Wed, 23 Dec 2020 09:44:59 -0500
Message-Id: <20201223144502.25029-6-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201223144502.25029-1-qiaowei.ren@intel.com>
References: <20201223144502.25029-1-qiaowei.ren@intel.com>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch implements the bch_nvm_free_pages() of the buddy.

Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/nvm-pages.c | 142 ++++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvm-pages.h |   4 +-
 2 files changed, 145 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index 2e91e1c8536f..1dcb5012eccf 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -182,6 +182,148 @@ static void add_extent(struct bch_nvm_alloced_recs *alloced_recs, void *addr, in
 	}
 }
 
+static inline void *nvm_end_addr(struct bch_nvm_namespace *ns)
+{
+	return ns->kaddr + ns->pages_offset + (ns->pages_total << PAGE_SHIFT);
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
+	void *end_addr = addr + ((1 << order) << PAGE_SHIFT);
+
+	while (list != &alloced_recs->extent_head) {
+		extent = container_of(list, struct bch_extent, list);
+
+		if (addr < extent->kaddr || end_addr > extent_end_addr(extent)) {
+			list = list->next;
+			continue;
+		}
+
+		if (addr == extent->kaddr) {
+			if (extent->nr == (1 << order)) {
+				list_del(list);
+				kfree(extent);
+				alloced_recs->size--;
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
+				alloced_recs->size++;
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
+	WARN_ON(page->private != order);
+	pgoff = page->index;
+
+	while (order < MAX_ORDER - 1) {
+		struct page *buddy_page;
+
+		pgoff_t buddy_pgoff = pgoff ^ (1 << order);
+		pgoff_t parent_pgoff = pgoff & ~(1 << order);
+
+		if ((parent_pgoff + (1 << (order + 1)) > ns->pages_total))
+			break;
+
+		buddy_page = nvm_vaddr_to_page(ns, nvm_pgoff_to_vaddr(ns, buddy_pgoff));
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
+	list_add((struct list_head *)&page->zone_device_data, &ns->free_area[order]);
+	page->index = pgoff;
+	page->private = order;
+	__SetPageBuddy(page);
+	ns->free = add_pages;
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
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
index e470c21b3075..6a56dd4a2ffc 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -77,7 +77,7 @@ struct bch_nvm_namespace *bch_register_namespace(const char *dev_path);
 int bch_nvm_init(void);
 void bch_nvm_exit(void);
 void *bch_nvm_alloc_pages(int order, const char *owner_uuid);
-
+void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid);
 #else
 
 static inline struct bch_nvm_namespace *bch_register_namespace(const char *dev_path)
@@ -95,6 +95,8 @@ static inline void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
 	return NULL;
 }
 
+static inline void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid) { }
+
 #endif /* CONFIG_BCACHE_NVM_PAGES */
 
 #endif /* _BCACHE_NVM_PAGES_H */
-- 
2.17.1

