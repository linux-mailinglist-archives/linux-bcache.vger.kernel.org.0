Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 064CD2CCD13
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Dec 2020 04:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbgLCDLN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 2 Dec 2020 22:11:13 -0500
Received: from mga07.intel.com ([134.134.136.100]:1942 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727776AbgLCDLN (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 2 Dec 2020 22:11:13 -0500
IronPort-SDR: OfsuQSI4qQMlkvdwD+pqGMtzCNzZUUVRENurZMrY+nIx4sGPrDMbNF7T3aQUb4cU7A0oMnpyme
 W13IAzTuWZwg==
X-IronPort-AV: E=McAfee;i="6000,8403,9823"; a="237248542"
X-IronPort-AV: E=Sophos;i="5.78,388,1599548400"; 
   d="scan'208";a="237248542"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2020 19:10:20 -0800
IronPort-SDR: gmraLc4H6GKZi/J8pfse3g01KX5pxwk08iX+8aXLCFcQ2xq6tr2QeEJdDNBgIaPSfD/qa7SOsq
 ZnbEz+OzAjZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,388,1599548400"; 
   d="scan'208";a="481801515"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by orsmga004.jf.intel.com with ESMTP; 02 Dec 2020 19:10:19 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>
Subject: [RFC PATCH 3/8] bcache: initialization of the buddy
Date:   Thu,  3 Dec 2020 05:53:32 -0500
Message-Id: <20201203105337.4592-4-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201203105337.4592-1-qiaowei.ren@intel.com>
References: <20201203105337.4592-1-qiaowei.ren@intel.com>
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
 drivers/md/bcache/nvm-pages.c | 68 ++++++++++++++++++++++++++++++++++-
 drivers/md/bcache/nvm-pages.h |  3 ++
 2 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index 841616ea3267..7ffbfbacaf3f 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -84,6 +84,17 @@ static void *nvm_pgoff_to_vaddr(struct nvm_namespace *ns, pgoff_t pgoff)
 	return ns->kaddr + ns->pages_offset + (pgoff << PAGE_SHIFT);
 }
 
+static struct page *nvm_vaddr_to_page(struct nvm_namespace *ns, void *addr)
+{
+	return virt_to_page(addr);
+}
+
+static inline void remove_owner_space(struct nvm_namespace *ns,
+		pgoff_t pgoff, u32 nr)
+{
+	bitmap_set(ns->pages_bitmap, pgoff, nr);
+}
+
 static void init_owner_info(struct nvm_namespace *ns)
 {
 	struct owner_list_head *owner_list_head;
@@ -126,6 +137,8 @@ static void init_owner_info(struct nvm_namespace *ns)
 					extent->nr = rec->nr;
 					list_add_tail(&extent->list, &extents->extent_head);
 
+					remove_owner_space(extents->ns, rec->pgoff, rec->nr);
+
 					extents->ns->free -= rec->nr;
 				}
 				extents->size += nvm_pgalloc_recs->size;
@@ -143,6 +156,54 @@ static void init_owner_info(struct nvm_namespace *ns)
 	mutex_unlock(&only_set->lock);
 }
 
+static void init_nvm_free_space(struct nvm_namespace *ns)
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
+			for (i = MAX_ORDER - 1; i >= 0 ; i--) {
+				if ((start % (1 << i) == 0) && (pages >= (1 << i)))
+					break;
+			}
+
+			page = nvm_vaddr_to_page(ns, nvm_pgoff_to_vaddr(ns, pgoff_start));
+			page->index = pgoff_start;
+			page->private = i;
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
+			for (i = MAX_ORDER - 1; i >= 0 ; i--) {
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
@@ -204,7 +265,7 @@ static bool attach_nvm_set(struct nvm_namespace *ns)
 struct nvm_namespace *register_namespace(const char *dev_path)
 {
 	struct nvm_namespace *ns;
-	int err;
+	int i, err;
 	pgoff_t pgoff;
 	char buf[BDEVNAME_SIZE];
 	struct block_device *bdev;
@@ -262,12 +323,17 @@ struct nvm_namespace *register_namespace(const char *dev_path)
 	ns->bdev = bdev;
 	ns->nvm_set = only_set;
 
+	ns->pages_bitmap = bitmap_zalloc(ns->pages_total, GFP_KERNEL);
+	for (i = 0; i < MAX_ORDER; i++)
+		INIT_LIST_HEAD(&ns->free_area[i]);
+
 	mutex_init(&ns->lock);
 
 	if (ns->sb->this_namespace_nr == 0) {
 		pr_info("only first namespace contain owner info\n");
 		init_owner_info(ns);
 	}
+	init_nvm_free_space(ns);
 
 	return ns;
 
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
index 1a24af6cb5a9..d91352496af1 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -44,6 +44,9 @@ struct nvm_namespace {
 	u64 pages_total;
 	pfn_t start_pfn;
 
+	unsigned long *pages_bitmap;
+	struct list_head free_area[MAX_ORDER];
+
 	struct dax_device *dax_dev;
 	struct block_device *bdev;
 	struct nvm_pages_sb *sb;
-- 
2.17.1

