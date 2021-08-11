Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF243E9670
	for <lists+linux-bcache@lfdr.de>; Wed, 11 Aug 2021 19:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhHKREW (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 11 Aug 2021 13:04:22 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:48304 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbhHKREV (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 11 Aug 2021 13:04:21 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id AF3A32222E;
        Wed, 11 Aug 2021 17:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628701436; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+mPewLOx0a1S8ZBMqH74ffluZMDAnu2uA7uLvLv6L7M=;
        b=DX7jTXwYTTqXLq3s63WskLN5neUaghjIx4RB9RunvkEY7H7+89CktyqpLc1pbK8jgjMcVR
        JlRCx215CeOUrS3Mf7jyzhXaUTxmUs0n5LRn36a4xspablVQlatzpkpnZCcBspH+Ued6ru
        hctEh1fJQm1MVwyyrK4RZNo4FlX7dZk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628701436;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+mPewLOx0a1S8ZBMqH74ffluZMDAnu2uA7uLvLv6L7M=;
        b=hWQWdCyA5eVmdcVOpPYQMf7qx8VQpGpLSiUL8tHA4lB05vD4o8U3UZ6PviN4s862nkeLm6
        E6cZOjAhN+1Zb1Bg==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id A9B44A3D58;
        Wed, 11 Aug 2021 17:03:32 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-nvdimm@lists.linux.dev,
        axboe@kernel.dk, hare@suse.com, jack@suse.cz,
        dan.j.williams@intel.com, hch@lst.de, ying.huang@intel.com,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v12 03/12] bcache: initialization of the buddy
Date:   Thu, 12 Aug 2021 01:02:15 +0800
Message-Id: <20210811170224.42837-4-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210811170224.42837-1-colyli@suse.de>
References: <20210811170224.42837-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Jianpeng Ma <jianpeng.ma@intel.com>

This nvm pages allocator will implement the simple buddy allocator to
anage the nvm address space. This patch initializes this buddy allocator
for new namespace.

the unit of alloc/free of the buddy allocator is page. DAX device has
their struct page(in dram or PMEM).

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

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Co-developed-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
---
 drivers/md/bcache/nvm-pages.c | 212 +++++++++++++++++++++++++++++++++-
 drivers/md/bcache/nvm-pages.h |  12 ++
 2 files changed, 221 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index 6184c628d9cc..677fdb62f737 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -50,6 +50,36 @@ unsigned long bch_nvmpg_ptr_to_offset(struct bch_nvmpg_ns *ns, void *ptr)
 	return BCH_NVMPG_OFFSET(ns_id, offset);
 }
 
+static struct page *bch_nvmpg_va_to_pg(void *addr)
+{
+	return virt_to_page(addr);
+}
+
+static void *bch_nvmpg_pgoff_to_ptr(struct bch_nvmpg_ns *ns, pgoff_t pgoff)
+{
+	return ns->base_addr + (pgoff << PAGE_SHIFT);
+}
+
+static void *bch_nvmpg_rec_to_ptr(struct bch_nvmpg_rec *r)
+{
+	struct bch_nvmpg_ns *ns = global_nvmpg_set->ns_tbl[r->ns_id];
+	pgoff_t pgoff = r->pgoff;
+
+	return bch_nvmpg_pgoff_to_ptr(ns, pgoff);
+}
+
+static inline void reserve_nvmpg_pages(struct bch_nvmpg_ns *ns,
+				       pgoff_t pgoff, u64 nr)
+{
+	while (nr > 0) {
+		unsigned int num = nr > UINT_MAX ? UINT_MAX : nr;
+
+		bitmap_set(ns->pages_bitmap, pgoff, num);
+		nr -= num;
+		pgoff += num;
+	}
+}
+
 static void release_ns_tbl(struct bch_nvmpg_set *set)
 {
 	int i;
@@ -58,6 +88,10 @@ static void release_ns_tbl(struct bch_nvmpg_set *set)
 	for (i = 0; i < BCH_NVMPG_NS_MAX; i++) {
 		ns = set->ns_tbl[i];
 		if (ns) {
+			kvfree(ns->pages_bitmap);
+			if (ns->recs_bitmap)
+				bitmap_free(ns->recs_bitmap);
+
 			blkdev_put(ns->bdev, FMODE_READ|FMODE_WRITE|FMODE_EXEC);
 			set->ns_tbl[i] = NULL;
 			set->attached_ns--;
@@ -75,10 +109,73 @@ static void release_nvmpg_set(struct bch_nvmpg_set *set)
 	kfree(set);
 }
 
+static int validate_recs(int ns_id,
+			 struct bch_nvmpg_head *head,
+			 struct bch_nvmpg_recs *recs)
+{
+	if (memcmp(recs->magic, bch_nvmpg_recs_magic, 16)) {
+		pr_err("Invalid bch_nvmpg_recs magic\n");
+		return -EINVAL;
+	}
+
+	if (memcmp(recs->uuid, head->uuid, 16)) {
+		pr_err("Invalid bch_nvmpg_recs uuid\n");
+		return -EINVAL;
+	}
+
+	if (recs->head_offset !=
+	    bch_nvmpg_ptr_to_offset(global_nvmpg_set->ns_tbl[ns_id], head)) {
+		pr_err("Invalid recs head_offset\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int reserve_nvmpg_recs(struct bch_nvmpg_recs *recs)
+{
+	int i, used = 0;
+
+	for (i = 0; i < recs->size; i++) {
+		struct bch_nvmpg_rec *r = &recs->recs[i];
+		struct bch_nvmpg_ns *ns;
+		struct page *page;
+		void *addr;
+
+		if (r->pgoff == 0)
+			continue;
+
+		ns = global_nvmpg_set->ns_tbl[r->ns_id];
+		addr = bch_nvmpg_rec_to_ptr(r);
+		if (addr < ns->base_addr) {
+			pr_err("Invalid recorded address\n");
+			return -EINVAL;
+		}
+
+		/* init struct page: index/private */
+		page = bch_nvmpg_va_to_pg(addr);
+		set_page_private(page, r->order);
+		page->index = r->pgoff;
+
+		reserve_nvmpg_pages(ns, r->pgoff, 1L << r->order);
+		used++;
+	}
+
+	if (used != recs->used) {
+		pr_err("used %d doesn't match recs->used %d\n",
+		       used, recs->used);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /* Namespace 0 contains all meta data of the nvmpg allocation set */
 static int init_nvmpg_set_header(struct bch_nvmpg_ns *ns)
 {
 	struct bch_nvmpg_set_header *set_header;
+	struct bch_nvmpg_recs *sys_recs;
+	int i, j, used = 0, rc = 0;
 
 	if (ns->ns_id != 0) {
 		pr_err("unexpected ns_id %u for first nvmpg namespace.\n",
@@ -92,9 +189,83 @@ static int init_nvmpg_set_header(struct bch_nvmpg_ns *ns)
 	global_nvmpg_set->set_header = set_header;
 	global_nvmpg_set->heads_size = set_header->size;
 	global_nvmpg_set->heads_used = set_header->used;
+
+	/* Reserve the used space from buddy allocator */
+	reserve_nvmpg_pages(ns, 0, div_u64(ns->pages_offset, ns->page_size));
+
+	sys_recs = ns->base_addr + BCH_NVMPG_SYSRECS_OFFSET;
+	for (i = 0; i < set_header->size; i++) {
+		struct bch_nvmpg_head *head;
+
+		head = &set_header->heads[i];
+		if (head->state == BCH_NVMPG_HD_STAT_FREE)
+			continue;
+
+		used++;
+		if (used > global_nvmpg_set->heads_size) {
+			pr_err("used heads %d > heads size %d.\n",
+			       used, global_nvmpg_set->heads_size);
+			goto unlock;
+		}
+
+		for (j = 0; j < BCH_NVMPG_NS_MAX; j++) {
+			struct bch_nvmpg_recs *recs;
+
+			recs = bch_nvmpg_offset_to_ptr(head->recs_offset[j]);
+
+			/* Iterate the recs list */
+			while (recs) {
+				rc = validate_recs(j, head, recs);
+				if (rc < 0)
+					goto unlock;
+
+				rc = reserve_nvmpg_recs(recs);
+				if (rc < 0)
+					goto unlock;
+
+				bitmap_set(ns->recs_bitmap, recs - sys_recs, 1);
+				recs = bch_nvmpg_offset_to_ptr(recs->next_offset);
+			}
+		}
+	}
+unlock:
 	mutex_unlock(&global_nvmpg_set->lock);
+	return rc;
+}
 
-	return 0;
+static void bch_nvmpg_init_free_space(struct bch_nvmpg_ns *ns)
+{
+	unsigned int start, end, pages;
+	int i;
+	struct page *page;
+	pgoff_t pgoff_start;
+
+	bitmap_for_each_clear_region(ns->pages_bitmap,
+				     start, end, 0, ns->pages_total) {
+		pgoff_start = start;
+		pages = end - start;
+
+		while (pages) {
+			void *addr;
+
+			for (i = BCH_MAX_ORDER - 1; i >= 0; i--) {
+				if ((pgoff_start % (1L << i) == 0) &&
+				    (pages >= (1L << i)))
+					break;
+			}
+
+			addr = bch_nvmpg_pgoff_to_ptr(ns, pgoff_start);
+			page = bch_nvmpg_va_to_pg(addr);
+			set_page_private(page, i);
+			page->index = pgoff_start;
+			__SetPageBuddy(page);
+			list_add((struct list_head *)&page->zone_device_data,
+				 &ns->free_area[i]);
+
+			pgoff_start += 1L << i;
+			pages -= 1L << i;
+		}
+	}
 }
 
 static int attach_nvmpg_set(struct bch_nvmpg_ns *ns)
@@ -199,7 +370,7 @@ struct bch_nvmpg_ns *bch_register_namespace(const char *dev_path)
 	char buf[BDEVNAME_SIZE];
 	struct block_device *bdev;
 	pgoff_t pgoff;
-	int id, err;
+	int id, i, err;
 	char *path;
 	long dax_ret = 0;
 
@@ -303,13 +474,48 @@ struct bch_nvmpg_ns *bch_register_namespace(const char *dev_path)
 
 	mutex_init(&ns->lock);
 
+	/*
+	 * parameters of bitmap_set/clear are unsigned int.
+	 * Given currently size of nvm is far from exceeding this limit,
+	 * so only add a WARN_ON message.
+	 */
+	WARN_ON(BITS_TO_LONGS(ns->pages_total) > UINT_MAX);
+	ns->pages_bitmap = kvcalloc(BITS_TO_LONGS(ns->pages_total),
+				    sizeof(unsigned long), GFP_KERNEL);
+	if (!ns->pages_bitmap) {
+		err = -ENOMEM;
+		goto clear_ns_nr;
+	}
+
+	if (ns->sb->this_ns == 0) {
+		ns->recs_bitmap =
+			bitmap_zalloc(BCH_MAX_PGALLOC_RECS, GFP_KERNEL);
+		if (ns->recs_bitmap == NULL) {
+			err = -ENOMEM;
+			goto free_pages_bitmap;
+		}
+	}
+
+	for (i = 0; i < BCH_MAX_ORDER; i++)
+		INIT_LIST_HEAD(&ns->free_area[i]);
+
 	err = init_nvmpg_set_header(ns);
 	if (err < 0)
-		goto free_ns;
+		goto free_recs_bitmap;
+
+	if (ns->sb->this_ns == 0)
+		/* init buddy allocator */
+		bch_nvmpg_init_free_space(ns);
 
 	kfree(path);
 	return ns;
 
+free_recs_bitmap:
+	bitmap_free(ns->recs_bitmap);
+free_pages_bitmap:
+	kvfree(ns->pages_bitmap);
+clear_ns_nr:
+	global_nvmpg_set->ns_tbl[sb->this_ns] = NULL;
 free_ns:
 	kfree(ns);
 bdput:
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
index 827cff695608..2116086c4d01 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -10,6 +10,8 @@
  * Bcache NVDIMM in memory data structures
  */
 
+#define BCH_MAX_ORDER 20
+
 /*
  * The following three structures in memory records which page(s) allocated
  * to which owner. After reboot from power failure, they will be initialized
@@ -27,6 +29,11 @@ struct bch_nvmpg_ns {
 	unsigned long pages_total;
 	pfn_t start_pfn;
 
+	unsigned long *pages_bitmap;
+	struct list_head free_area[BCH_MAX_ORDER];
+
+	unsigned long *recs_bitmap;
+
 	struct dax_device *dax_dev;
 	struct block_device *bdev;
 	struct bch_nvmpg_set *set;
@@ -68,6 +75,11 @@ struct bch_nvmpg_set {
 /* Indicate which field in bch_nvmpg_sb to be updated */
 #define BCH_NVMPG_TOTAL_NS	0	/* total_ns */
 
+#define BCH_MAX_PGALLOC_RECS						\
+	(min_t(unsigned int, 64,					\
+	       (BCH_NVMPG_START - BCH_NVMPG_SYSRECS_OFFSET) /		\
+	       sizeof(struct bch_nvmpg_recs)))
+
 void *bch_nvmpg_offset_to_ptr(unsigned long offset);
 unsigned long bch_nvmpg_ptr_to_offset(struct bch_nvmpg_ns *ns, void *ptr);
 
-- 
2.26.2

