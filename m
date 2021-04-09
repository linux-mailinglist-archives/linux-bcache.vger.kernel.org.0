Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375E335A3B4
	for <lists+linux-bcache@lfdr.de>; Fri,  9 Apr 2021 18:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbhDIQo3 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 9 Apr 2021 12:44:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:34842 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233896AbhDIQo2 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Apr 2021 12:44:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5DAABB10B;
        Fri,  9 Apr 2021 16:44:14 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-nvdimm@lists.01.org,
        axboe@kernel.dk, jianpeng.ma@intel.com, qiaowei.ren@intel.com,
        hare@suse.com, jack@suse.cz, dan.j.williams@intel.com
Subject: [PATCH v7 04/16] bcache: bch_nvm_alloc_pages() of the buddy
Date:   Sat, 10 Apr 2021 00:43:31 +0800
Message-Id: <20210409164343.56828-5-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210409164343.56828-1-colyli@suse.de>
References: <20210409164343.56828-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Jianpeng Ma <jianpeng.ma@intel.com>

This patch implements the bch_nvm_alloc_pages() of the buddy.

Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Co-authored-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/nvm-pages.c | 157 ++++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvm-pages.h |   6 ++
 2 files changed, 163 insertions(+)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index fef497c7acb3..6bdc7d3773de 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -21,6 +21,7 @@
 #include <linux/pagemap.h>
 #include <linux/bitmap.h>
 #include <linux/blkdev.h>
+#include <linux/bcache-nvm.h>
 
 #ifdef CONFIG_BCACHE_NVM_PAGES
 
@@ -68,6 +69,162 @@ static inline void remove_owner_space(struct bch_nvm_namespace *ns,
 	bitmap_set(ns->pages_bitmap, pgoff, nr);
 }
 
+/* If not found, it will create if create == true */
+static struct bch_nvm_pages_owner_head *find_owner_head(const char *owner_uuid, bool create)
+{
+	struct bch_owner_list_head *owner_list_head = only_set->owner_list_head;
+	int i;
+
+	for (i = 0; i < only_set->owner_list_used; i++) {
+		if (!memcmp(owner_uuid, owner_list_head->heads[i].uuid, 16))
+			return &(owner_list_head->heads[i]);
+	}
+
+	if (create) {
+		int used = only_set->owner_list_used;
+
+		BUG_ON(only_set->owner_list_size == used);
+		memcpy(owner_list_head->heads[used].uuid, owner_uuid, 16);
+		only_set->owner_list_used++;
+
+		owner_list_head->used++;
+		return &(owner_list_head->heads[used]);
+	} else
+		return NULL;
+}
+
+static struct bch_nvm_pgalloc_recs *find_empty_pgalloc_recs(void)
+{
+	unsigned int start;
+	struct bch_nvm_namespace *ns = only_set->nss[0];
+	struct bch_nvm_pgalloc_recs *recs;
+
+	start = bitmap_find_next_zero_area(ns->pgalloc_recs_bitmap, BCH_MAX_PGALLOC_RECS, 0, 1, 0);
+	if (start > BCH_MAX_PGALLOC_RECS) {
+		pr_info("no free struct bch_nvm_pgalloc_recs\n");
+		return NULL;
+	}
+
+	bitmap_set(ns->pgalloc_recs_bitmap, start, 1);
+	recs = (struct bch_nvm_pgalloc_recs *)(ns->kaddr + BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET)
+		+ start;
+	return recs;
+}
+
+static struct bch_nvm_pgalloc_recs *find_nvm_pgalloc_recs(struct bch_nvm_namespace *ns,
+		struct bch_nvm_pages_owner_head *owner_head, bool create)
+{
+	int ns_nr = ns->sb->this_namespace_nr;
+	struct bch_nvm_pgalloc_recs *prev_recs = NULL, *recs = owner_head->recs[ns_nr];
+
+	// If create=false, we return recs[nr]
+	if (!create)
+		return recs;
+
+	// If create=true, it mean we need a empty struct bch_pgalloc_rec
+	// So we should find non-empty struct bch_nvm_pgalloc_recs or alloc
+	// new struct bch_nvm_pgalloc_recs. And return this bch_nvm_pgalloc_recs
+	while (recs && (recs->used == recs->size)) {
+		prev_recs = recs;
+		recs = recs->next;
+	}
+
+	// Found empty struct bch_nvm_pgalloc_recs
+	if (recs)
+		return recs;
+	// Need alloc new struct bch_nvm_galloc_recs
+	recs = find_empty_pgalloc_recs();
+	if (recs) {
+		recs->next = NULL;
+		recs->owner = owner_head;
+		strncpy(recs->magic, bch_nvm_pages_pgalloc_magic, 16);
+		strncpy(recs->owner_uuid, owner_head->uuid, 16);
+		recs->size = BCH_MAX_RECS;
+		recs->used = 0;
+
+		if (prev_recs)
+			prev_recs->next = recs;
+		else
+			owner_head->recs[ns_nr] = recs;
+	}
+
+	return recs;
+}
+
+static void add_pgalloc_rec(struct bch_nvm_pgalloc_recs *recs, void *kaddr, int order)
+{
+	int i;
+
+	for (i = 0; i < recs->size; i++) {
+		if (recs->recs[i].pgoff == 0) {
+			recs->recs[i].pgoff = (unsigned long)kaddr >> PAGE_SHIFT;
+			recs->recs[i].order = order;
+			recs->used++;
+			break;
+		}
+	}
+	BUG_ON(i == recs->size);
+}
+
+void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
+{
+	void *kaddr = NULL;
+	struct bch_nvm_pgalloc_recs *pgalloc_recs;
+	struct bch_nvm_pages_owner_head *owner_head;
+	int i, j;
+
+	mutex_lock(&only_set->lock);
+	owner_head = find_owner_head(owner_uuid, true);
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
+				set_page_private(buddy_page, i - 1);
+				buddy_page->index = page->index + (1 << (i - 1));
+				__SetPageBuddy(buddy_page);
+				list_add((struct list_head *)&buddy_page->zone_device_data,
+					&ns->free_area[i - 1]);
+				i--;
+			}
+
+			set_page_private(page, order);
+			__ClearPageBuddy(page);
+			ns->free -= 1 << order;
+			kaddr = nvm_pgoff_to_vaddr(ns, page->index);
+			break;
+		}
+
+		if (i != BCH_MAX_ORDER) {
+			pgalloc_recs = find_nvm_pgalloc_recs(ns, owner_head, true);
+			// ToDo: handle pgalloc_recs==NULL
+			add_pgalloc_rec(pgalloc_recs, kaddr, order);
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
 	struct bch_owner_list_head *owner_list_head = ns->sb->owner_list_head;
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
index c158033e24f0..b2c0e0cfac20 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -60,6 +60,7 @@ extern struct bch_nvm_set *only_set;
 struct bch_nvm_namespace *bch_register_namespace(const char *dev_path);
 int bch_nvm_init(void);
 void bch_nvm_exit(void);
+void *bch_nvm_alloc_pages(int order, const char *owner_uuid);
 
 #else
 
@@ -72,6 +73,11 @@ static inline int bch_nvm_init(void)
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
2.26.2

