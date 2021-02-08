Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4644312AE0
	for <lists+linux-bcache@lfdr.de>; Mon,  8 Feb 2021 07:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbhBHGqP (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 8 Feb 2021 01:46:15 -0500
Received: from mga07.intel.com ([134.134.136.100]:44129 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229623AbhBHGqP (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Feb 2021 01:46:15 -0500
IronPort-SDR: W24a6coYx1vCHSL4XLBMh/EnWMCwycmELw3V8boXQ8hiyEOphXGem+EHc44XY2Cq6d6F1Fm45t
 hRnUKQTKSFvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9888"; a="245738708"
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="245738708"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2021 22:45:21 -0800
IronPort-SDR: EmkD4O8CBwssRoH0CEeEq5NVC62Igx0l/cM6lv31Bd5Zdgizva5/mRCy9Oh27moVs6f+toV3UJ
 8cBdRHgT59Ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="418127574"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Feb 2021 22:45:20 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        linux-bcache@vger.kernel.org
Subject: [RFC PATCH v6 3/7] bcache: initialization of the buddy
Date:   Mon,  8 Feb 2021 09:26:17 -0500
Message-Id: <20210208142621.76815-4-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210208142621.76815-1-qiaowei.ren@intel.com>
References: <20210208142621.76815-1-qiaowei.ren@intel.com>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

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
Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
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
2.17.1

