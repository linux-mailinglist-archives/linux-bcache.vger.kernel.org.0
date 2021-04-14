Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEC235EC5D
	for <lists+linux-bcache@lfdr.de>; Wed, 14 Apr 2021 07:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347444AbhDNFrh (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 14 Apr 2021 01:47:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:43158 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347436AbhDNFre (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 14 Apr 2021 01:47:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7269BB036;
        Wed, 14 Apr 2021 05:47:12 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        jianpeng.ma@intel.com, qiaowei.ren@intel.com,
        Coly Li <colyli@suse.de>
Subject: [PATCH 03/13] bcache: initialization of the buddy
Date:   Wed, 14 Apr 2021 13:46:38 +0800
Message-Id: <20210414054648.24098-4-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210414054648.24098-1-colyli@suse.de>
References: <20210414054648.24098-1-colyli@suse.de>
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
 drivers/md/bcache/nvm-pages.c   | 142 +++++++++++++++++++++++++++++++-
 drivers/md/bcache/nvm-pages.h   |   6 ++
 include/uapi/linux/bcache-nvm.h |  12 ++-
 3 files changed, 153 insertions(+), 7 deletions(-)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index d4e458f00155..f02407406479 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -34,6 +34,10 @@ static void release_nvm_namespaces(struct bch_nvm_set *nvm_set)
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
@@ -48,17 +52,122 @@ static void release_nvm_set(struct bch_nvm_set *nvm_set)
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
+	/* remove used space */
+	remove_owner_space(ns, 0, ns->pages_offset/ns->page_size);
+
+	sys_recs = ns->kaddr + BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET;
+	/* suppose no hole in array */
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
+				/* recs array can has hole */
+				for (k = 0; k < pgalloc_recs->size; k++) {
+					struct bch_pgalloc_rec *rec = &pgalloc_recs->recs[k];
+
+					if (rec->pgoff) {
+						BUG_ON(rec->pgoff <= offset);
+
+						/* init struct page: index/private */
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
@@ -123,7 +232,7 @@ static int read_nvdimm_meta_super(struct block_device *bdev,
 struct bch_nvm_namespace *bch_register_namespace(const char *dev_path)
 {
 	struct bch_nvm_namespace *ns;
-	int err;
+	int i, err;
 	pgoff_t pgoff;
 	char buf[BDEVNAME_SIZE];
 	struct block_device *bdev;
@@ -238,18 +347,43 @@ struct bch_nvm_namespace *bch_register_namespace(const char *dev_path)
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
index 87a0d2c46788..e08864af96a0 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -16,6 +16,7 @@
  * to which owner. After reboot from power failure, they will be initialized
  * based on nvm pages superblock in NVDIMM device.
  */
+#define BCH_MAX_ORDER 20
 struct bch_nvm_namespace {
 	struct bch_nvm_pages_sb *sb;
 	void *kaddr;
@@ -27,6 +28,11 @@ struct bch_nvm_namespace {
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
index 3e67e731a49d..c3f6be2ddb70 100644
--- a/include/uapi/linux/bcache-nvm.h
+++ b/include/uapi/linux/bcache-nvm.h
@@ -116,6 +116,8 @@ struct bch_pgalloc_rec {
 	__u64	reserved:6;
 };
 
+#define BCH_PGOFF_TO_KVADDR(pgoff) ((void *)((unsigned long)pgoff << PAGE_SHIFT))
+
 struct bch_nvm_pgalloc_recs {
 union {
 	struct {
@@ -132,11 +134,15 @@ union {
 };
 };
 
-#define BCH_MAX_RECS					\
-	((sizeof(struct bch_nvm_pgalloc_recs) -		\
-	 offsetof(struct bch_nvm_pgalloc_recs, recs)) /	\
+#define BCH_MAX_RECS							\
+	((sizeof(struct bch_nvm_pgalloc_recs) -				\
+	 offsetof(struct bch_nvm_pgalloc_recs, recs)) /			\
 	 sizeof(struct bch_pgalloc_rec))
 
+#define BCH_MAX_PGALLOC_RECS						\
+	((BCH_NVM_PAGES_OFFSET - BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET) /	\
+	 sizeof(struct bch_nvm_pgalloc_recs))
+
 struct bch_nvm_pages_owner_head {
 	unsigned char			uuid[16];
 	unsigned char			label[BCH_NVM_PAGES_LABEL_SIZE];
-- 
2.26.2

