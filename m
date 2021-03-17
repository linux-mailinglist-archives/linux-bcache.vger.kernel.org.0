Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607BB33EA92
	for <lists+linux-bcache@lfdr.de>; Wed, 17 Mar 2021 08:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhCQHbP (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 17 Mar 2021 03:31:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:61940 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229472AbhCQHas (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 17 Mar 2021 03:30:48 -0400
IronPort-SDR: Fzys0qNhWIz52d1A+GlKs678XdXW541eIQOqBNqpc/7RsbZqR8KXBGrDQcOQvuiSG/pYcKmOmj
 TAO35ss0zYog==
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="189500611"
X-IronPort-AV: E=Sophos;i="5.81,255,1610438400"; 
   d="scan'208";a="189500611"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 00:30:47 -0700
IronPort-SDR: IuOf03/T/GjN9XPhtgXYUwQ/PQAOQ/cS7kLP/x6+I1xsCzX4/rpEVM+fYrv0gUoD51PZBRGX8Q
 OSH+wS3F4ajw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,255,1610438400"; 
   d="scan'208";a="602130317"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by fmsmga006.fm.intel.com with ESMTP; 17 Mar 2021 00:30:46 -0700
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        linux-bcache@vger.kernel.org
Subject: [bch-nvm-pages v7 3/6] bcache: initialization of the buddy
Date:   Wed, 17 Mar 2021 11:10:26 -0400
Message-Id: <20210317151029.40735-4-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210317151029.40735-1-qiaowei.ren@intel.com>
References: <20210317151029.40735-1-qiaowei.ren@intel.com>
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
---
 drivers/md/bcache/nvm-pages.c   | 142 +++++++++++++++++++++++++++++++-
 drivers/md/bcache/nvm-pages.h   |   6 ++
 include/uapi/linux/bcache-nvm.h |   8 ++
 3 files changed, 152 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index 9335371c9d91..1f99965920a1 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -41,6 +41,10 @@ static void release_nvm_namespaces(struct bch_nvm_set *nvm_set)
 	for (i = 0; i < nvm_set->total_namespaces_nr; i++) {
 		ns = nvm_set->nss[i];
 		if (ns) {
+			kvfree(ns->pages_bitmap);
+			if (ns->pgalloc_recs_bitmap)
+				bitmap_free(ns->pgalloc_recs_bitmap);
+
 			blkdev_put(ns->bdev, FMODE_READ|FMODE_WRITE|FMODE_EXEC);
 			kfree(ns);
 		}
@@ -55,17 +59,122 @@ static void release_nvm_set(struct bch_nvm_set *nvm_set)
 	kfree(nvm_set);
 }
 
+static struct page *nvm_vaddr_to_page(struct bch_nvm_namespace *ns, void *addr)
+{
+	return virt_to_page(addr);
+}
+
+static void *nvm_pgoff_to_vaddr(struct bch_nvm_namespace *ns, pgoff_t pgoff)
+{
+	return ns->kaddr + (pgoff << PAGE_SHIFT);
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
 	struct bch_owner_list_head *owner_list_head = ns->sb->owner_list_head;
+	struct bch_nvm_pgalloc_recs *sys_recs;
+	int i, j, k, rc = 0;
 
 	mutex_lock(&only_set->lock);
 	only_set->owner_list_head = owner_list_head;
 	only_set->owner_list_size = owner_list_head->size;
 	only_set->owner_list_used = owner_list_head->used;
+
+	/*remove used space*/
+	remove_owner_space(ns, 0, ns->pages_offset/ns->page_size);
+
+	sys_recs = ns->kaddr + BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET;
+	// suppose no hole in array
+	for (i = 0; i < owner_list_head->used; i++) {
+		struct bch_nvm_pages_owner_head *head = &owner_list_head->heads[i];
+
+		for (j = 0; j < BCH_NVM_PAGES_NAMESPACES_MAX; j++) {
+			struct bch_nvm_pgalloc_recs *pgalloc_recs = head->recs[j];
+			unsigned long offset = (unsigned long)ns->kaddr >> PAGE_SHIFT;
+			struct page *page;
+
+			while (pgalloc_recs) {
+				u32 pgalloc_recs_pos = (unsigned long)(pgalloc_recs - sys_recs);
+
+				if (memcmp(pgalloc_recs->magic, bch_nvm_pages_pgalloc_magic, 16)) {
+					pr_info("invalid bch_nvm_pages_pgalloc_magic\n");
+					rc = -EINVAL;
+					goto unlock;
+				}
+				if (memcmp(pgalloc_recs->owner_uuid, head->uuid, 16)) {
+					pr_info("invalid owner_uuid in bch_nvm_pgalloc_recs\n");
+					rc = -EINVAL;
+					goto unlock;
+				}
+				if (pgalloc_recs->owner != head) {
+					pr_info("invalid owner in bch_nvm_pgalloc_recs\n");
+					rc = -EINVAL;
+					goto unlock;
+				}
+
+				// recs array can has hole
+				for (k = 0; k < pgalloc_recs->size; k++) {
+					struct bch_pgalloc_rec *rec = &pgalloc_recs->recs[k];
+
+					if (rec->pgoff) {
+						BUG_ON(rec->pgoff <= offset);
+
+						/*init struct page: index/private */
+						page = nvm_vaddr_to_page(ns,
+							BCH_PGOFF_TO_KVADDR(rec->pgoff));
+
+						set_page_private(page, rec->order);
+						page->index = rec->pgoff - offset;
+
+						remove_owner_space(ns,
+							rec->pgoff - offset,
+							1 << rec->order);
+					}
+				}
+				bitmap_set(ns->pgalloc_recs_bitmap, pgalloc_recs_pos, 1);
+				pgalloc_recs = pgalloc_recs->next;
+			}
+		}
+	}
+unlock:
 	mutex_unlock(&only_set->lock);
 
-	return 0;
+	return rc;
+}
+
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
 }
 
 static bool attach_nvm_set(struct bch_nvm_namespace *ns)
@@ -130,7 +239,7 @@ static int read_nvdimm_meta_super(struct block_device *bdev,
 struct bch_nvm_namespace *bch_register_namespace(const char *dev_path)
 {
 	struct bch_nvm_namespace *ns;
-	int err;
+	int i, err;
 	pgoff_t pgoff;
 	char buf[BDEVNAME_SIZE];
 	struct block_device *bdev;
@@ -245,18 +354,43 @@ struct bch_nvm_namespace *bch_register_namespace(const char *dev_path)
 	ns->nvm_set = only_set;
 	mutex_init(&ns->lock);
 
+	ns->pages_bitmap = kvcalloc(BITS_TO_LONGS(ns->pages_total),
+					sizeof(unsigned long), GFP_KERNEL);
+	if (!ns->pages_bitmap) {
+		err = -ENOMEM;
+		goto clear_ns_nr;
+	}
+
+	if (ns->sb->this_namespace_nr == 0) {
+		ns->pgalloc_recs_bitmap = bitmap_zalloc(BCH_MAX_PGALLOC_RECS, GFP_KERNEL);
+		if (ns->pgalloc_recs_bitmap == NULL) {
+			err = -ENOMEM;
+			goto free_pages_bitmap;
+		}
+	}
+
+	for (i = 0; i < BCH_MAX_ORDER; i++)
+		INIT_LIST_HEAD(&ns->free_area[i]);
+
 	if (ns->sb->this_namespace_nr == 0) {
 		pr_info("only first namespace contain owner info\n");
 		err = init_owner_info(ns);
 		if (err < 0) {
 			pr_info("init_owner_info met error %d\n", err);
-			only_set->nss[ns->sb->this_namespace_nr] = NULL;
-			goto free_ns;
+			goto free_recs_bitmap;
 		}
+		/* init buddy allocator */
+		init_nvm_free_space(ns);
 	}
 
 	kfree(path);
 	return ns;
+free_recs_bitmap:
+	bitmap_free(ns->pgalloc_recs_bitmap);
+free_pages_bitmap:
+	kvfree(ns->pages_bitmap);
+clear_ns_nr:
+	only_set->nss[ns->sb->this_namespace_nr] = NULL;
 free_ns:
 	kfree(ns);
 bdput:
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
index 3b723a775b7b..c158033e24f0 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -14,6 +14,7 @@
  * to which owner. After reboot from power failure, they will be initialized
  * based on nvm pages superblock in NVDIMM device.
  */
+#define BCH_MAX_ORDER 20
 struct bch_nvm_namespace {
 	struct bch_nvm_pages_sb *sb;
 	void *kaddr;
@@ -25,6 +26,11 @@ struct bch_nvm_namespace {
 	u64 pages_total;
 	pfn_t start_pfn;
 
+	unsigned long *pages_bitmap;
+	struct list_head free_area[BCH_MAX_ORDER];
+
+	unsigned long *pgalloc_recs_bitmap;
+
 	struct dax_device *dax_dev;
 	struct block_device *bdev;
 	struct bch_nvm_set *nvm_set;
diff --git a/include/uapi/linux/bcache-nvm.h b/include/uapi/linux/bcache-nvm.h
index 8bd5e8f96cf5..5d78ab70071b 100644
--- a/include/uapi/linux/bcache-nvm.h
+++ b/include/uapi/linux/bcache-nvm.h
@@ -104,6 +104,8 @@ struct bch_pgalloc_rec {
 	__u64			order:12;
 };
 
+#define BCH_PGOFF_TO_KVADDR(pgoff) ((void *)((unsigned long)pgoff << PAGE_SHIFT))
+
 struct bch_nvm_pgalloc_recs {
 union {
 	struct {
@@ -119,11 +121,17 @@ union {
 	__u8	pad[8192];
 };
 };
+
 #define BCH_MAX_REC					\
 	((sizeof(struct bch_nvm_pgalloc_recs) -		\
 	 offsetof(struct bch_nvm_pgalloc_recs, recs)) /	\
 	 sizeof(struct bch_pgalloc_rec))
 
+#define BCH_MAX_PGALLOC_RECS					     \
+	((BCH_NVM_PAGES_OFFSET - BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET) \
+	/ sizeof(struct bch_nvm_pgalloc_recs))
+
+
 struct bch_nvm_pages_owner_head {
 	__u8			uuid[16];
 	char			label[BCH_NVM_PAGES_LABEL_SIZE];
-- 
2.25.1

