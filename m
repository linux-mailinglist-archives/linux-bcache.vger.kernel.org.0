Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C386315EA9
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Feb 2021 06:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhBJFJe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Feb 2021 00:09:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:40750 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230418AbhBJFJ3 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Feb 2021 00:09:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 53C16B08C;
        Wed, 10 Feb 2021 05:08:18 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>, Coly Li <colyli@suse.de>
Subject: [PATCH 09/20] bcache: initialization of the buddy
Date:   Wed, 10 Feb 2021 13:07:31 +0800
Message-Id: <20210210050742.31237-10-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210210050742.31237-1-colyli@suse.de>
References: <20210210050742.31237-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Jianpeng Ma <jianpeng.ma@intel.com>

This nvm pages allocator will implement the simple buddy to manage the
nvm address space. This patch initializes this buddy for new namespace.

the unit of alloc/free of the buddy is page. DAX device has their
struct page(in dram or PMEM).

	struct {        /* ZONE_DEVICE pages */
		/** @pgmap: Points to the hosting device page map. */
		struct dev_pagemap *pgmap;
		void *zone_device_data;
		/*
		 * ZONE_DEVICE private pages are counted as being
		 * mapped so the next 3 words hold the mapping, index,
		 * and private fields from the source anonymous or
		 * page cache page while the page is migrated to device
		 * private memory.
		 * ZONE_DEVICE MEMORY_DEVICE_FS_DAX pages also
		 * use the mapping, index, and private fields when
		 * pmem backed DAX files are mapped.
		 */
	};

ZONE_DEVICE pages only use pgmap. Other 4 words[16/32 bytes] don't use.
So the second/third word will be used as 'struct list_head ' which list
in buddy. The fourth word(that is normal struct page::index) store pgoff
which the page-offset in the dax device. And the fifth word (that is
normal struct page::private) store order of buddy. page_type will be used
to store buddy flags.

Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Co-authored-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/nvm-pages.c | 75 ++++++++++++++++++++++++++++++++++-
 drivers/md/bcache/nvm-pages.h |  5 +++
 2 files changed, 78 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index 4fa8e2764773..7efb99c0fc07 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -93,6 +93,7 @@ static void release_nvm_namespaces(struct bch_nvm_set *nvm_set)
 	int i;
 
 	for (i = 0; i < nvm_set->total_namespaces_nr; i++) {
+		kvfree(nvm_set->nss[i]->pages_bitmap);
 		blkdev_put(nvm_set->nss[i]->bdev, FMODE_READ|FMODE_WRITE|FMODE_EXEC);
 		kfree(nvm_set->nss[i]);
 	}
@@ -112,6 +113,17 @@ static void *nvm_pgoff_to_vaddr(struct bch_nvm_namespace *ns, pgoff_t pgoff)
 	return ns->kaddr + (pgoff << PAGE_SHIFT);
 }
 
+static struct page *nvm_vaddr_to_page(struct bch_nvm_namespace *ns, void *addr)
+{
+	return virt_to_page(addr);
+}
+
+static inline void remove_owner_space(struct bch_nvm_namespace *ns,
+					pgoff_t pgoff, u32 nr)
+{
+	bitmap_set(ns->pages_bitmap, pgoff, nr);
+}
+
 static int init_owner_info(struct bch_nvm_namespace *ns)
 {
 	struct bch_owner_list_head *owner_list_head;
@@ -129,6 +141,8 @@ static int init_owner_info(struct bch_nvm_namespace *ns)
 	only_set->owner_list_size = owner_list_head->size;
 	only_set->owner_list_used = owner_list_head->used;
 
+	remove_owner_space(ns, 0, ns->pages_offset/ns->page_size);
+
 	for (i = 0; i < owner_list_head->used; i++) {
 		owner_head = &owner_list_head->heads[i];
 		owner_list = alloc_owner_list(owner_head->uuid, owner_head->label,
@@ -162,6 +176,8 @@ static int init_owner_info(struct bch_nvm_namespace *ns)
 
 			do {
 				struct bch_pgalloc_rec *rec;
+				int order;
+				struct page *page;
 
 				for (k = 0; k < nvm_pgalloc_recs->used; k++) {
 					rec = &nvm_pgalloc_recs->recs[k];
@@ -172,7 +188,17 @@ static int init_owner_info(struct bch_nvm_namespace *ns)
 					}
 					extent->kaddr = nvm_pgoff_to_vaddr(extents->ns, rec->pgoff);
 					extent->nr = rec->nr;
+					WARN_ON(!is_power_of_2(extent->nr));
+
+					/*init struct page: index/private */
+					order = ilog2(extent->nr);
+					page = nvm_vaddr_to_page(ns, extent->kaddr);
+					set_page_private(page, order);
+					page->index = rec->pgoff;
+
 					list_add_tail(&extent->list, &extents->extent_head);
+					/*remove already alloced space*/
+					remove_owner_space(extents->ns, rec->pgoff, rec->nr);
 				}
 				extents->nr += nvm_pgalloc_recs->used;
 
@@ -197,6 +223,36 @@ static int init_owner_info(struct bch_nvm_namespace *ns)
 	return 0;
 }
 
+static void init_nvm_free_space(struct bch_nvm_namespace *ns)
+{
+	unsigned int start, end, i;
+	struct page *page;
+	long long pages;
+	pgoff_t pgoff_start;
+
+	bitmap_for_each_clear_region(ns->pages_bitmap, start, end, 0, ns->pages_total) {
+		pgoff_start = start;
+		pages = end - start;
+
+		while (pages) {
+			for (i = BCH_MAX_ORDER - 1; i >= 0 ; i--) {
+				if ((pgoff_start % (1 << i) == 0) && (pages >= (1 << i)))
+					break;
+			}
+
+			page = nvm_vaddr_to_page(ns, nvm_pgoff_to_vaddr(ns, pgoff_start));
+			page->index = pgoff_start;
+			set_page_private(page, i);
+			__SetPageBuddy(page);
+			list_add((struct list_head *)&page->zone_device_data, &ns->free_area[i]);
+
+			pgoff_start += 1 << i;
+			pages -= 1 << i;
+		}
+	}
+
+}
+
 static bool attach_nvm_set(struct bch_nvm_namespace *ns)
 {
 	bool rc = true;
@@ -261,7 +317,7 @@ static int read_nvdimm_meta_super(struct block_device *bdev,
 struct bch_nvm_namespace *bch_register_namespace(const char *dev_path)
 {
 	struct bch_nvm_namespace *ns;
-	int err;
+	int i, err;
 	pgoff_t pgoff;
 	char buf[BDEVNAME_SIZE];
 	struct block_device *bdev;
@@ -357,6 +413,16 @@ struct bch_nvm_namespace *bch_register_namespace(const char *dev_path)
 	ns->bdev = bdev;
 	ns->nvm_set = only_set;
 
+	ns->pages_bitmap = kvcalloc(BITS_TO_LONGS(ns->pages_total),
+					sizeof(unsigned long), GFP_KERNEL);
+	if (!ns->pages_bitmap) {
+		err = -ENOMEM;
+		goto free_ns;
+	}
+
+	for (i = 0; i < BCH_MAX_ORDER; i++)
+		INIT_LIST_HEAD(&ns->free_area[i]);
+
 	mutex_init(&ns->lock);
 
 	if (ns->sb.this_namespace_nr == 0) {
@@ -364,12 +430,17 @@ struct bch_nvm_namespace *bch_register_namespace(const char *dev_path)
 		err = init_owner_info(ns);
 		if (err < 0) {
 			pr_info("init_owner_info met error %d\n", err);
-			goto free_ns;
+			goto free_bitmap;
 		}
+		/* init buddy allocator */
+		init_nvm_free_space(ns);
 	}
 
 	kfree(path);
 	return ns;
+
+free_bitmap:
+	kvfree(ns->pages_bitmap);
 free_ns:
 	kfree(ns);
 bdput:
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
index 1b10b4b6db0f..ed3431daae06 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -34,6 +34,7 @@ struct bch_owner_list {
 	struct bch_nvm_alloced_recs **alloced_recs;
 };
 
+#define BCH_MAX_ORDER 20
 struct bch_nvm_namespace {
 	struct bch_nvm_pages_sb sb;
 	void *kaddr;
@@ -45,6 +46,10 @@ struct bch_nvm_namespace {
 	u64 pages_total;
 	pfn_t start_pfn;
 
+	unsigned long *pages_bitmap;
+	struct list_head free_area[BCH_MAX_ORDER];
+
+
 	struct dax_device *dax_dev;
 	struct block_device *bdev;
 	struct bch_nvm_set *nvm_set;
-- 
2.26.2

