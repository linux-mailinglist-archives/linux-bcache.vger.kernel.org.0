Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C162EA58A
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Jan 2021 07:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725822AbhAEGnY (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 5 Jan 2021 01:43:24 -0500
Received: from mga03.intel.com ([134.134.136.65]:20313 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbhAEGnY (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 5 Jan 2021 01:43:24 -0500
IronPort-SDR: xPCajazI+E1HAJCV2BGdj4LIt1UH3gvJ5YcEtTvFh3EClu+oJ3IvUyBCH7LNPsJ6Cp8iu6iJk4
 OurgQZEY9NgA==
X-IronPort-AV: E=McAfee;i="6000,8403,9854"; a="177161890"
X-IronPort-AV: E=Sophos;i="5.78,476,1599548400"; 
   d="scan'208";a="177161890"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 22:42:31 -0800
IronPort-SDR: HjMtTN7qUIBn65yKfvU550vV/v3FQKrT0ydpbpmPKkwgCwV/tMQJ354Qg+u0+91zXJ6IEK6xEW
 EJHWK7oMFe9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,476,1599548400"; 
   d="scan'208";a="350250068"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by fmsmga008.fm.intel.com with ESMTP; 04 Jan 2021 22:42:30 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Jianpeng Ma <jianpeng.ma@intel.com>, linux-bcache@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [RFC PATCH v3 3/8] bcache: initialization of the buddy
Date:   Tue,  5 Jan 2021 09:22:13 -0500
Message-Id: <20210105142218.56508-4-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210105142218.56508-1-qiaowei.ren@intel.com>
References: <20210105142218.56508-1-qiaowei.ren@intel.com>
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
 drivers/md/bcache/nvm-pages.c | 82 +++++++++++++++++++++++++++++++++--
 drivers/md/bcache/nvm-pages.h |  4 ++
 2 files changed, 83 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index 250a93831823..1c090bc2c9f1 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -74,8 +74,10 @@ static void release_nvm_namespaces(struct bch_nvm_set *nvm_set)
 {
 	int i;
 
-	for (i = 0; i < nvm_set->total_namespaces_nr; i++)
+	for (i = 0; i < nvm_set->total_namespaces_nr; i++) {
+		kfree(nvm_set->nss[i]->pages_bitmap);
 		kfree(nvm_set->nss[i]);
+	}
 
 	kfree(nvm_set->nss);
 }
@@ -92,6 +94,17 @@ static void *nvm_pgoff_to_vaddr(struct bch_nvm_namespace *ns, pgoff_t pgoff)
 	return ns->kaddr + ns->pages_offset + (pgoff << PAGE_SHIFT);
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
@@ -146,6 +159,8 @@ static int init_owner_info(struct bch_nvm_namespace *ns)
 					extent->kaddr = nvm_pgoff_to_vaddr(extents->ns, rec->pgoff);
 					extent->nr = rec->nr;
 					list_add_tail(&extent->list, &extents->extent_head);
+					/*remove already alloced space*/
+					remove_owner_space(extents->ns, rec->pgoff, rec->nr);
 
 					extents->ns->free -= rec->nr;
 				}
@@ -166,6 +181,54 @@ static int init_owner_info(struct bch_nvm_namespace *ns)
 	return 0;
 }
 
+static void init_nvm_free_space(struct bch_nvm_namespace *ns)
+{
+	unsigned int start, end, i;
+	struct page *page;
+	unsigned int pages;
+	pgoff_t pgoff_start;
+
+	bitmap_for_each_clear_region(ns->pages_bitmap, start, end, 0, ns->pages_total) {
+		pgoff_start = start;
+		pages = end - start;
+
+		while (pages) {
+			for (i = BCH_MAX_ORDER - 1; i >= 0 ; i--) {
+				if ((start % (1 << i) == 0) && (pages >= (1 << i)))
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
+	bitmap_for_each_set_region(ns->pages_bitmap, start, end, 0, ns->pages_total) {
+		pages = end - start;
+		pgoff_start = start;
+
+		while (pages) {
+			for (i = BCH_MAX_ORDER - 1; i >= 0 ; i--) {
+				if ((start % (1 << i) == 0) && (pages >= (1 << i)))
+					break;
+			}
+
+			page = nvm_vaddr_to_page(ns, nvm_pgoff_to_vaddr(ns, pgoff_start));
+			page->index = pgoff_start;
+			page->private = i;
+
+			pgoff_start += 1 << i;
+			pages -= 1 << i;
+		}
+	}
+}
+
 static bool dev_dax_supported(struct block_device *bdev)
 {
 	char buf[BDEVNAME_SIZE];
@@ -234,7 +297,7 @@ static bool attach_nvm_set(struct bch_nvm_namespace *ns)
 struct bch_nvm_namespace *bch_register_namespace(const char *dev_path)
 {
 	struct bch_nvm_namespace *ns;
-	int err;
+	int i, err;
 	pgoff_t pgoff;
 	char buf[BDEVNAME_SIZE];
 	struct block_device *bdev;
@@ -292,6 +355,15 @@ struct bch_nvm_namespace *bch_register_namespace(const char *dev_path)
 	ns->bdev = bdev;
 	ns->nvm_set = only_set;
 
+	ns->pages_bitmap = bitmap_zalloc(ns->pages_total, GFP_KERNEL);
+	if (!ns->pages_bitmap) {
+		err = -ENOMEM;
+		goto free_ns;
+	}
+
+	for (i = 0; i < BCH_MAX_ORDER; i++)
+		INIT_LIST_HEAD(&ns->free_area[i]);
+
 	mutex_init(&ns->lock);
 
 	if (ns->sb->this_namespace_nr == 0) {
@@ -299,12 +371,16 @@ struct bch_nvm_namespace *bch_register_namespace(const char *dev_path)
 		err = init_owner_info(ns);
 		if (err < 0) {
 			pr_info("init_owner_info met error %d\n", err);
-			goto free_ns;
+			goto free_bitmap;
 		}
+		/* init buddy allocator */
+		init_nvm_free_space(ns);
 	}
 
 	return ns;
 
+free_bitmap:
+	kfree(ns->pages_bitmap);
 free_ns:
 	kfree(ns);
 bdput:
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
index 79143f9db04d..33d849528fb3 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -34,6 +34,7 @@ struct bch_owner_list {
 	struct bch_nvm_alloced_recs **alloced_recs;
 };
 
+#define BCH_MAX_ORDER 11
 struct bch_nvm_namespace {
 	void *kaddr;
 
@@ -44,6 +45,9 @@ struct bch_nvm_namespace {
 	u64 pages_total;
 	pfn_t start_pfn;
 
+	unsigned long *pages_bitmap;
+	struct list_head free_area[BCH_MAX_ORDER];
+
 	struct dax_device *dax_dev;
 	struct block_device *bdev;
 	struct bch_nvm_pages_sb *sb;
-- 
2.17.1

