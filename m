Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F39A38C09A
	for <lists+linux-bcache@lfdr.de>; Fri, 21 May 2021 09:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbhEUHV3 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 21 May 2021 03:21:29 -0400
Received: from mga04.intel.com ([192.55.52.120]:16559 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230427AbhEUHV2 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 21 May 2021 03:21:28 -0400
IronPort-SDR: UQKtIF4n1ma+ZD2W6EEECI9v/+xqqWWmM38YPGBJLAmry4OxN5yfOYovo7uZDdf5yUtoxdn9TB
 YLrlnCWotedA==
X-IronPort-AV: E=McAfee;i="6200,9189,9990"; a="199484338"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="199484338"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 00:20:06 -0700
IronPort-SDR: 1dYVy6Jq4oEsB1xIGLD/jpaXP6ziJ909Nu1EU6KE+SdJI0DNgCEMag6o+asomY35JkxqdisM2g
 efxRvPkRafyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="440817170"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by orsmga008.jf.intel.com with ESMTP; 21 May 2021 00:20:04 -0700
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     linux-bcache@vger.kernel.org
Cc:     qiaowei.ren@intel.com, jianpeng.ma@intel.com, colyli@suse.de,
        rdunlap@infradead.oom
Subject: [bch-nvm-pages v10 5/6] bcache: bch_nvm_free_pages() of the buddy
Date:   Fri, 21 May 2021 10:57:25 -0400
Message-Id: <20210521145726.154276-6-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210521145726.154276-1-qiaowei.ren@intel.com>
References: <20210521145726.154276-1-qiaowei.ren@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Jianpeng Ma <jianpeng.ma@intel.com>

This patch implements the bch_nvm_free_pages() of the buddy.

The difference between this and page-buddy-free:
it need owner_uuid to free owner allocated pages.And must
persistent after free.

Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Co-developed-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/nvm-pages.c | 164 ++++++++++++++++++++++++++++++++--
 drivers/md/bcache/nvm-pages.h |   3 +-
 2 files changed, 159 insertions(+), 8 deletions(-)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index 5b767fc7e952..755f3727a468 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -50,7 +50,7 @@ static void release_nvm_set(struct bch_nvm_set *nvm_set)
 	kfree(nvm_set);
 }
 
-static struct page *nvm_vaddr_to_page(struct bch_nvm_namespace *ns, void *addr)
+static struct page *nvm_vaddr_to_page(void *addr)
 {
 	return virt_to_page(addr);
 }
@@ -181,6 +181,155 @@ static void add_pgalloc_rec(struct bch_nvm_pgalloc_recs *recs, void *kaddr, int
 	BUG_ON(i == recs->size);
 }
 
+static inline void *nvm_end_addr(struct bch_nvm_namespace *ns)
+{
+	return ns->kaddr + (ns->pages_total << PAGE_SHIFT);
+}
+
+static inline bool in_nvm_range(struct bch_nvm_namespace *ns,
+		void *start_addr, void *end_addr)
+{
+	return (start_addr >= ns->kaddr) && (end_addr < nvm_end_addr(ns));
+}
+
+static struct bch_nvm_namespace *find_nvm_by_addr(void *addr, int order)
+{
+	int i;
+	struct bch_nvm_namespace *ns;
+
+	for (i = 0; i < only_set->total_namespaces_nr; i++) {
+		ns = only_set->nss[i];
+		if (ns && in_nvm_range(ns, addr, addr + (1L << order)))
+			return ns;
+	}
+	return NULL;
+}
+
+static int remove_pgalloc_rec(struct bch_nvm_pgalloc_recs *pgalloc_recs, int ns_nr,
+				void *kaddr, int order)
+{
+	struct bch_nvm_pages_owner_head *owner_head = pgalloc_recs->owner;
+	struct bch_nvm_pgalloc_recs *prev_recs, *sys_recs;
+	u64 pgoff = (unsigned long)kaddr >> PAGE_SHIFT;
+	struct bch_nvm_namespace *ns = only_set->nss[0];
+	int i;
+
+	prev_recs = pgalloc_recs;
+	sys_recs = ns->kaddr + BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET;
+	while (pgalloc_recs) {
+		for (i = 0; i < pgalloc_recs->size; i++) {
+			struct bch_pgalloc_rec *rec = &(pgalloc_recs->recs[i]);
+
+			if (rec->pgoff == pgoff) {
+				WARN_ON(rec->order != order);
+				rec->pgoff = 0;
+				rec->order = 0;
+				pgalloc_recs->used--;
+
+				if (pgalloc_recs->used == 0) {
+					int recs_pos = pgalloc_recs - sys_recs;
+
+					if (pgalloc_recs == prev_recs)
+						owner_head->recs[ns_nr] = pgalloc_recs->next;
+					else
+						prev_recs->next = pgalloc_recs->next;
+
+					pgalloc_recs->next = NULL;
+					pgalloc_recs->owner = NULL;
+
+					bitmap_clear(ns->pgalloc_recs_bitmap, recs_pos, 1);
+				}
+				goto exit;
+			}
+		}
+		prev_recs = pgalloc_recs;
+		pgalloc_recs = pgalloc_recs->next;
+	}
+exit:
+	return pgalloc_recs ? 0 : -ENOENT;
+}
+
+static void __free_space(struct bch_nvm_namespace *ns, void *addr, int order)
+{
+	unsigned long add_pages = (1L << order);
+	pgoff_t pgoff;
+	struct page *page;
+
+	page = nvm_vaddr_to_page(addr);
+	WARN_ON((!page) || (page->private != order));
+	pgoff = page->index;
+
+	while (order < BCH_MAX_ORDER - 1) {
+		struct page *buddy_page;
+
+		pgoff_t buddy_pgoff = pgoff ^ (1L << order);
+		pgoff_t parent_pgoff = pgoff & ~(1L << order);
+
+		if ((parent_pgoff + (1L << (order + 1)) > ns->pages_total))
+			break;
+
+		buddy_page = nvm_vaddr_to_page(nvm_pgoff_to_vaddr(ns, buddy_pgoff));
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
+	page = nvm_vaddr_to_page(nvm_pgoff_to_vaddr(ns, pgoff));
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
+	struct bch_nvm_pages_owner_head *owner_head;
+	struct bch_nvm_pgalloc_recs *pgalloc_recs;
+	int r;
+
+	mutex_lock(&only_set->lock);
+
+	ns = find_nvm_by_addr(addr, order);
+	if (!ns) {
+		pr_err("can't find nvm_dev by kaddr %px\n", addr);
+		goto unlock;
+	}
+
+	owner_head = find_owner_head(owner_uuid, false);
+	if (!owner_head) {
+		pr_err("can't found bch_nvm_pages_owner_head by(uuid=%s)\n", owner_uuid);
+		goto unlock;
+	}
+
+	pgalloc_recs = find_nvm_pgalloc_recs(ns, owner_head, false);
+	if (!pgalloc_recs) {
+		pr_err("can't find bch_nvm_pgalloc_recs by(uuid=%s)\n", owner_uuid);
+		goto unlock;
+	}
+
+	r = remove_pgalloc_rec(pgalloc_recs, ns->sb->this_namespace_nr, addr, order);
+	if (r < 0) {
+		pr_err("can't find bch_pgalloc_rec\n");
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
@@ -215,7 +364,7 @@ void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
 			list_del(list);
 
 			while (i != order) {
-				buddy_page = nvm_vaddr_to_page(ns,
+				buddy_page = nvm_vaddr_to_page(
 					nvm_pgoff_to_vaddr(ns, page->index + (1L << (i - 1))));
 				set_page_private(buddy_page, i - 1);
 				buddy_page->index = page->index + (1L << (i - 1));
@@ -299,7 +448,7 @@ static int init_owner_info(struct bch_nvm_namespace *ns)
 						BUG_ON(rec->pgoff <= offset);
 
 						/* init struct page: index/private */
-						page = nvm_vaddr_to_page(ns,
+						page = nvm_vaddr_to_page(
 							BCH_PGOFF_TO_KVADDR(rec->pgoff));
 
 						set_page_private(page, rec->order);
@@ -338,11 +487,12 @@ static void init_nvm_free_space(struct bch_nvm_namespace *ns)
 					break;
 			}
 
-			page = nvm_vaddr_to_page(ns, nvm_pgoff_to_vaddr(ns, pgoff_start));
+			page = nvm_vaddr_to_page(nvm_pgoff_to_vaddr(ns, pgoff_start));
 			page->index = pgoff_start;
 			set_page_private(page, i);
-			__SetPageBuddy(page);
-			list_add((struct list_head *)&page->zone_device_data, &ns->free_area[i]);
+
+			/* in order to update ns->free */
+			__free_space(ns, nvm_pgoff_to_vaddr(ns, pgoff_start), i);
 
 			pgoff_start += 1L << i;
 			pages -= 1L << i;
@@ -533,7 +683,7 @@ struct bch_nvm_namespace *bch_register_namespace(const char *dev_path)
 	ns->page_size = ns->sb->page_size;
 	ns->pages_offset = ns->sb->pages_offset;
 	ns->pages_total = ns->sb->pages_total;
-	ns->free = 0;
+	ns->free = 0; /* increase by __free_space() */
 	ns->bdev = bdev;
 	ns->nvm_set = only_set;
 	mutex_init(&ns->lock);
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
index 4fd5205146a2..918aee6a9afc 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -63,6 +63,7 @@ struct bch_nvm_namespace *bch_register_namespace(const char *dev_path);
 int bch_nvm_init(void);
 void bch_nvm_exit(void);
 void *bch_nvm_alloc_pages(int order, const char *owner_uuid);
+void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid);
 
 #else
 
@@ -79,7 +80,7 @@ static inline void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
 {
 	return NULL;
 }
-
+static inline void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid) { }
 
 #endif /* CONFIG_BCACHE_NVM_PAGES */
 
-- 
2.25.1

