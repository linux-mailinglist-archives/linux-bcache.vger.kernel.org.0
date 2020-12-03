Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F072CCD15
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Dec 2020 04:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgLCDLP (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 2 Dec 2020 22:11:15 -0500
Received: from mga07.intel.com ([134.134.136.100]:1946 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726977AbgLCDLP (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 2 Dec 2020 22:11:15 -0500
IronPort-SDR: qBqx9zmnhY87Sy6wctSo9IYK7uVLUX7K8BhpiKIYa4WlsQKiIwMjlFe8r5BxElCIVItuKBxZ+K
 XwFVu+3gi+Nw==
X-IronPort-AV: E=McAfee;i="6000,8403,9823"; a="237248549"
X-IronPort-AV: E=Sophos;i="5.78,388,1599548400"; 
   d="scan'208";a="237248549"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2020 19:10:23 -0800
IronPort-SDR: mGY/DXTqaBzEmaT1s9mNfjkq9BPPLLhgiTUUCXA89kZrqNlNKfaMbKp+F9ak2EdX0zNGakF3ol
 3E70BxsKm95Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,388,1599548400"; 
   d="scan'208";a="481801539"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by orsmga004.jf.intel.com with ESMTP; 02 Dec 2020 19:10:21 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>
Subject: [RFC PATCH 5/8] bcache: nvm_free_pages() of the buddy
Date:   Thu,  3 Dec 2020 05:53:34 -0500
Message-Id: <20201203105337.4592-6-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201203105337.4592-1-qiaowei.ren@intel.com>
References: <20201203105337.4592-1-qiaowei.ren@intel.com>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch implements the nvm_free_pages() of the buddy.

Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/nvm-pages.c | 142 ++++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvm-pages.h |   2 +
 2 files changed, 144 insertions(+)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index 2cde62081c4f..16b65a866041 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -173,6 +173,148 @@ static void add_extent(struct nvm_alloced_recs *alloced_recs, void *addr, int or
 	}
 }
 
+static inline void *nvm_end_addr(struct nvm_namespace *ns)
+{
+	return ns->kaddr + ns->pages_offset + (ns->pages_total << PAGE_SHIFT);
+}
+
+static inline bool in_nvm_range(struct nvm_namespace *ns,
+		void *start_addr, void *end_addr)
+{
+	return (start_addr >= ns->kaddr) && (end_addr <= nvm_end_addr(ns));
+}
+
+static struct nvm_namespace *find_nvm_by_addr(void *addr, int order)
+{
+	int i;
+	struct nvm_namespace *ns;
+
+	for (i = 0; i < only_set->total_namespaces_nr; i++) {
+		ns = only_set->nss[i];
+		if ((ns != NULL) && in_nvm_range(ns, addr, addr + (1 << order)))
+			return ns;
+	}
+	return NULL;
+}
+
+static int remove_extent(struct nvm_alloced_recs *alloced_recs, void *addr, int order)
+{
+	struct list_head *list = alloced_recs->extent_head.next;
+	struct extent *extent;
+	void *end_addr = addr + ((1 << order) << PAGE_SHIFT);
+
+	while (list != &alloced_recs->extent_head) {
+		extent = container_of(list, struct extent, list);
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
+				struct extent *e = kzalloc(sizeof(struct extent), GFP_KERNEL);
+
+				e->kaddr = end_addr;
+				e->nr = (pgoff_t)(extent_end_addr(extent) - end_addr) >> PAGE_SHIFT;
+				list_add(&e->list, list);
+				alloced_recs->size++;
+			}
+			extent->nr = (addr - extent->kaddr) >> PAGE_SHIFT;
+		}
+		break;
+	}
+	return (list == &alloced_recs->extent_head) ? -ENOENT : 0;
+}
+
+static void __free_space(struct nvm_namespace *ns, void *addr, int order)
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
+	ns->free += add_pages;
+}
+
+void nvm_free_pages(void *addr, int order, const char *owner_uuid)
+{
+	struct nvm_namespace *ns;
+	struct owner_list *owner_list;
+	struct nvm_alloced_recs *alloced_recs;
+	int r;
+
+	mutex_lock(&only_set->lock);
+
+	ns = find_nvm_by_addr(addr, order);
+	if (ns == NULL) {
+		pr_info("can't find nvm_dev by kaddr %p\n", addr);
+		goto unlock;
+	}
+
+	owner_list = find_owner_list(owner_uuid, false);
+	if (owner_list == NULL) {
+		pr_info("can't found owner(uuid=%s)\n", owner_uuid);
+		goto unlock;
+	}
+
+	alloced_recs = find_nvm_alloced_recs(owner_list, ns, false);
+	if (alloced_recs == NULL) {
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
+EXPORT_SYMBOL_GPL(nvm_free_pages);
+
 void *nvm_alloc_pages(int order, const char *owner_uuid)
 {
 	void *kaddr = NULL;
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
index 95b7fa4b7dd0..1e435ce0ddf4 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -78,6 +78,7 @@ extern int bch_nvm_init(void);
 extern void bch_nvm_exit(void);
 
 extern void *nvm_alloc_pages(int order, const char *owner_uuid);
+extern void nvm_free_pages(void *addr, int order, const char *owner_uuid);
 
 #else
 
@@ -92,6 +93,7 @@ static inline int bch_nvm_init(void)
 static inline void bch_nvm_exit(void) { }
 
 static inline void *nvm_alloc_pages(int order, const char *owner_uuid) { }
+static inline void nvm_free_pages(void *addr, int order, const char *owner_uuid) { }
 
 #endif /* CONFIG_BCACHE_NVM_PAGES */
 
-- 
2.17.1

