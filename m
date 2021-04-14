Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6456A35EC61
	for <lists+linux-bcache@lfdr.de>; Wed, 14 Apr 2021 07:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347456AbhDNFrk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 14 Apr 2021 01:47:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:43200 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347452AbhDNFrj (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 14 Apr 2021 01:47:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BB35FB038;
        Wed, 14 Apr 2021 05:47:17 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        jianpeng.ma@intel.com, qiaowei.ren@intel.com,
        Coly Li <colyli@suse.de>
Subject: [PATCH 05/13] bcache: bch_nvm_free_pages() of the buddy
Date:   Wed, 14 Apr 2021 13:46:40 +0800
Message-Id: <20210414054648.24098-6-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210414054648.24098-1-colyli@suse.de>
References: <20210414054648.24098-1-colyli@suse.de>
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
Co-authored-by: Qiaowei Ren <qiaowei.ren@intel.com>
[colyli: fix typo in commit log]
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/nvm-pages.c | 158 +++++++++++++++++++++++++++++++++-
 drivers/md/bcache/nvm-pages.h |   3 +-
 2 files changed, 156 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index 003244b7b797..eaa6e18f3cad 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -176,6 +176,155 @@ static void add_pgalloc_rec(struct bch_nvm_pgalloc_recs *recs, void *kaddr, int
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
+	struct bch_nvm_pages_owner_head *owner_head;
+	struct bch_nvm_pgalloc_recs *pgalloc_recs;
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
+	owner_head = find_owner_head(owner_uuid, false);
+	if (!owner_head) {
+		pr_info("can't found bch_nvm_pages_owner_head by(uuid=%s)\n", owner_uuid);
+		goto unlock;
+	}
+
+	pgalloc_recs = find_nvm_pgalloc_recs(ns, owner_head, false);
+	if (!pgalloc_recs) {
+		pr_info("can't find bch_nvm_pgalloc_recs by(uuid=%s)\n", owner_uuid);
+		goto unlock;
+	}
+
+	r = remove_pgalloc_rec(pgalloc_recs, ns->sb->this_namespace_nr, addr, order);
+	if (r < 0) {
+		pr_info("can't find bch_pgalloc_rec\n");
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
@@ -318,7 +467,7 @@ static void init_nvm_free_space(struct bch_nvm_namespace *ns)
 {
 	unsigned int start, end, i;
 	struct page *page;
-	long long pages;
+	u64 pages;
 	pgoff_t pgoff_start;
 
 	bitmap_for_each_clear_region(ns->pages_bitmap, start, end, 0, ns->pages_total) {
@@ -334,8 +483,9 @@ static void init_nvm_free_space(struct bch_nvm_namespace *ns)
 			page = nvm_vaddr_to_page(ns, nvm_pgoff_to_vaddr(ns, pgoff_start));
 			page->index = pgoff_start;
 			set_page_private(page, i);
-			__SetPageBuddy(page);
-			list_add((struct list_head *)&page->zone_device_data, &ns->free_area[i]);
+
+			/* in order to update ns->free */
+			__free_space(ns, nvm_pgoff_to_vaddr(ns, pgoff_start), i);
 
 			pgoff_start += 1 << i;
 			pages -= 1 << i;
@@ -515,7 +665,7 @@ struct bch_nvm_namespace *bch_register_namespace(const char *dev_path)
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
2.26.2

