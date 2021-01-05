Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8020D2EA58B
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Jan 2021 07:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbhAEGn1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 5 Jan 2021 01:43:27 -0500
Received: from mga03.intel.com ([134.134.136.65]:20320 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbhAEGn1 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 5 Jan 2021 01:43:27 -0500
IronPort-SDR: y/PdLRih4YXdVe3365Lv5gjxjYsy0JFOTi1TTVXgNw+Ckw49ZjU9ILg+p+4goqPrLV1nOimamY
 DAunC6ndn3/g==
X-IronPort-AV: E=McAfee;i="6000,8403,9854"; a="177161897"
X-IronPort-AV: E=Sophos;i="5.78,476,1599548400"; 
   d="scan'208";a="177161897"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 22:42:33 -0800
IronPort-SDR: g9lUxXg6zox9NtfX1Lr2uQFDT1AMpW24P2rcJqAlfJgBTtsZU2ztoB2Bhv9Ppc4Q/PgWaBMUmI
 yJrnrTg3Rpzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,476,1599548400"; 
   d="scan'208";a="350250078"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by fmsmga008.fm.intel.com with ESMTP; 04 Jan 2021 22:42:32 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Jianpeng Ma <jianpeng.ma@intel.com>, linux-bcache@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [RFC PATCH v3 5/8] bcache: bch_nvm_free_pages() of the buddy
Date:   Tue,  5 Jan 2021 09:22:15 -0500
Message-Id: <20210105142218.56508-6-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210105142218.56508-1-qiaowei.ren@intel.com>
References: <20210105142218.56508-1-qiaowei.ren@intel.com>
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
index e6690a8365c1..e7d948a40662 100644
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
index b198e8fd5816..05673d129797 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -78,7 +78,7 @@ struct bch_nvm_namespace *bch_register_namespace(const char *dev_path);
 int bch_nvm_init(void);
 void bch_nvm_exit(void);
 void *bch_nvm_alloc_pages(int order, const char *owner_uuid);
-
+void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid);
 #else
 
 static inline struct bch_nvm_namespace *bch_register_namespace(const char *dev_path)
@@ -96,6 +96,8 @@ static inline void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
 	return NULL;
 }
 
+static inline void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid) { }
+
 #endif /* CONFIG_BCACHE_NVM_PAGES */
 
 #endif /* _BCACHE_NVM_PAGES_H */
-- 
2.17.1

