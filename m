Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8C75180BAD
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Mar 2020 23:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgCJWfa (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 10 Mar 2020 18:35:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48693 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727749AbgCJWfa (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 10 Mar 2020 18:35:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583879728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+eyiaZTyQIcQ/KNzYAXeKGfkFej/IHvp5P/4xpsQi4g=;
        b=B41RWHfZrr3frb6glpX9n/V0TwfDx2Aa4+igocDrQlEsNOUKj0qAUIwMka52dHh92tXEVF
        q0Va/X4A1cMbq+zOVfTG9MFcikIr+/t2RerTcfIZhj2tcQ0VdXa/Mum6gUwnYdiiVjLADx
        OyUUpdrYz1LqJpjV6mFSLkFfP6oPhC0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-_3dcsa-xOS-TIrWeTeJ85A-1; Tue, 10 Mar 2020 18:35:26 -0400
X-MC-Unique: _3dcsa-xOS-TIrWeTeJ85A-1
Received: by mail-wr1-f71.google.com with SMTP id v6so5001140wrg.22
        for <linux-bcache@vger.kernel.org>; Tue, 10 Mar 2020 15:35:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+eyiaZTyQIcQ/KNzYAXeKGfkFej/IHvp5P/4xpsQi4g=;
        b=PewYMuAXsc6vHU+Ne79M/5zfftMCB/EhYj+Mu9qJz43ChghSGW24itautfhiQ1hQ/Y
         BtNmtNbwmUkotDrfIOpb29sw2+GP5kykgOJ3a9iz2/M9DmrpLrziEXX+CynsIn/mn18q
         6ZSrdIt26qAdU+BPNpY6MKaqt7WrNXrWrALZrMO6bWoyDW/OIGh1VPRMwczcmGqnOO7Z
         KNa+0UE8ujNIGUQFj6Q4rjhMXGMIWXxA2HxDg5E/uAGPQfwiieeY40/uyQ2zD0/wmbNh
         dfeVL1lI46vpE58WIMdb2/iUh7HWUiocuTRCOPr2azUAtrYDjrkuROOtuPFYpVvbwek0
         rTiA==
X-Gm-Message-State: ANhLgQ0xv5gXVNbOOJGjizt5sydoxI1EWBny15MnwywwMuxJzF/J8jdG
        Y+dq4DRmSy20gxc0nE89ot2Jbi4dy3ExTLDoABUmHFg43Qh+CpNpT30eCVKN51KD8eHAhcWBrrl
        vXg28cu5UK51DuTLkZ6XIpLuV
X-Received: by 2002:a7b:ce0d:: with SMTP id m13mr4038672wmc.135.1583879725383;
        Tue, 10 Mar 2020 15:35:25 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vu8tA8wuEvPHHQ5TUxwPNFy5Jjp28qjGxduDuBBBLqHAWSLKUgeXurgzudExdP3uioTitEPoA==
X-Received: by 2002:a7b:ce0d:: with SMTP id m13mr4038648wmc.135.1583879724854;
        Tue, 10 Mar 2020 15:35:24 -0700 (PDT)
Received: from raver.teknoraver.net (net-93-144-9-178.cust.vodafonedsl.it. [93.144.9.178])
        by smtp.gmail.com with ESMTPSA id k133sm6029548wma.11.2020.03.10.15.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 15:35:24 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org,
        linux-nfs@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Song Liu <song@kernel.org>
Subject: [PATCH v2] block: refactor duplicated macros
Date:   Tue, 10 Mar 2020 23:35:16 +0100
Message-Id: <20200310223516.102758-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The macros PAGE_SECTORS, PAGE_SECTORS_SHIFT and SECTOR_MASK are defined
several times in different flavours across the whole tree.
Define them just once in a common header.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
v2:
As Dan Williams suggested:

 #define PAGE_SECTORS_MASK            (~(PAGE_SECTORS - 1))

 block/blk-lib.c                  |  2 +-
 drivers/block/brd.c              |  3 ---
 drivers/block/null_blk_main.c    | 14 +++++---------
 drivers/block/zram/zram_drv.c    |  8 ++++----
 drivers/block/zram/zram_drv.h    |  2 --
 drivers/dax/super.c              |  2 +-
 drivers/md/bcache/util.h         |  2 --
 drivers/md/dm-bufio.c            |  6 +++---
 drivers/md/dm-integrity.c        | 10 +++++-----
 drivers/md/md.c                  |  4 ++--
 drivers/md/raid1.c               |  2 +-
 drivers/mmc/core/host.c          |  3 ++-
 drivers/scsi/xen-scsifront.c     |  4 ++--
 fs/iomap/buffered-io.c           |  2 +-
 fs/nfs/blocklayout/blocklayout.h |  2 --
 include/linux/blkdev.h           |  4 ++++
 include/linux/device-mapper.h    |  1 -
 17 files changed, 31 insertions(+), 40 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 5f2c429d4378..f5e705d307e0 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -260,7 +260,7 @@ static int __blkdev_issue_write_zeroes(struct block_device *bdev,
  */
 static unsigned int __blkdev_sectors_to_bio_pages(sector_t nr_sects)
 {
-	sector_t pages = DIV_ROUND_UP_SECTOR_T(nr_sects, PAGE_SIZE / 512);
+	sector_t pages = DIV_ROUND_UP_SECTOR_T(nr_sects, PAGE_SECTORS);
 
 	return min(pages, (sector_t)BIO_MAX_PAGES);
 }
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 220c5e18aba0..33e2cbe11400 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -25,9 +25,6 @@
 
 #include <linux/uaccess.h>
 
-#define PAGE_SECTORS_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
-#define PAGE_SECTORS		(1 << PAGE_SECTORS_SHIFT)
-
 /*
  * Each block ramdisk device has a radix_tree brd_pages of pages that stores
  * the pages containing the block device's contents. A brd page's ->index is
diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index 16510795e377..b5ebde97bf0b 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -11,10 +11,6 @@
 #include <linux/init.h>
 #include "null_blk.h"
 
-#define PAGE_SECTORS_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
-#define PAGE_SECTORS		(1 << PAGE_SECTORS_SHIFT)
-#define SECTOR_MASK		(PAGE_SECTORS - 1)
-
 #define FREE_BATCH		16
 
 #define TICKS_PER_SEC		50ULL
@@ -721,7 +717,7 @@ static void null_free_sector(struct nullb *nullb, sector_t sector,
 
 	root = is_cache ? &nullb->dev->cache : &nullb->dev->data;
 	idx = sector >> PAGE_SECTORS_SHIFT;
-	sector_bit = (sector & SECTOR_MASK);
+	sector_bit = (sector & PAGE_SECTORS_MASK);
 
 	t_page = radix_tree_lookup(root, idx);
 	if (t_page) {
@@ -792,7 +788,7 @@ static struct nullb_page *__null_lookup_page(struct nullb *nullb,
 	struct radix_tree_root *root;
 
 	idx = sector >> PAGE_SECTORS_SHIFT;
-	sector_bit = (sector & SECTOR_MASK);
+	sector_bit = (sector & PAGE_SECTORS_MASK);
 
 	root = is_cache ? &nullb->dev->cache : &nullb->dev->data;
 	t_page = radix_tree_lookup(root, idx);
@@ -967,7 +963,7 @@ static int copy_to_nullb(struct nullb *nullb, struct page *source,
 		if (null_cache_active(nullb) && !is_fua)
 			null_make_cache_space(nullb, PAGE_SIZE);
 
-		offset = (sector & SECTOR_MASK) << SECTOR_SHIFT;
+		offset = (sector & PAGE_SECTORS_MASK) << SECTOR_SHIFT;
 		t_page = null_insert_page(nullb, sector,
 			!null_cache_active(nullb) || is_fua);
 		if (!t_page)
@@ -979,7 +975,7 @@ static int copy_to_nullb(struct nullb *nullb, struct page *source,
 		kunmap_atomic(dst);
 		kunmap_atomic(src);
 
-		__set_bit(sector & SECTOR_MASK, t_page->bitmap);
+		__set_bit(sector & PAGE_SECTORS_MASK, t_page->bitmap);
 
 		if (is_fua)
 			null_free_sector(nullb, sector, true);
@@ -1001,7 +997,7 @@ static int copy_from_nullb(struct nullb *nullb, struct page *dest,
 	while (count < n) {
 		temp = min_t(size_t, nullb->dev->blocksize, n - count);
 
-		offset = (sector & SECTOR_MASK) << SECTOR_SHIFT;
+		offset = (sector & PAGE_SECTORS_MASK) << SECTOR_SHIFT;
 		t_page = null_lookup_page(nullb, sector, false,
 			!null_cache_active(nullb));
 
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 1bdb5793842b..725bd33f302d 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1548,9 +1548,9 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
 	struct bio_vec bvec;
 	struct bvec_iter iter;
 
-	index = bio->bi_iter.bi_sector >> SECTORS_PER_PAGE_SHIFT;
+	index = bio->bi_iter.bi_sector >> PAGE_SECTORS_SHIFT;
 	offset = (bio->bi_iter.bi_sector &
-		  (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
+		  PAGE_SECTORS_MASK) << SECTOR_SHIFT;
 
 	switch (bio_op(bio)) {
 	case REQ_OP_DISCARD:
@@ -1643,8 +1643,8 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
 		goto out;
 	}
 
-	index = sector >> SECTORS_PER_PAGE_SHIFT;
-	offset = (sector & (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
+	index = sector >> PAGE_SECTORS_SHIFT;
+	offset = (sector & PAGE_SECTORS_MASK) << SECTOR_SHIFT;
 
 	bv.bv_page = page;
 	bv.bv_len = PAGE_SIZE;
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index f2fd46daa760..12309175d55e 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -21,8 +21,6 @@
 
 #include "zcomp.h"
 
-#define SECTORS_PER_PAGE_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
-#define SECTORS_PER_PAGE	(1 << SECTORS_PER_PAGE_SHIFT)
 #define ZRAM_LOGICAL_BLOCK_SHIFT 12
 #define ZRAM_LOGICAL_BLOCK_SIZE	(1 << ZRAM_LOGICAL_BLOCK_SHIFT)
 #define ZRAM_SECTOR_PER_LOGICAL_BLOCK	\
diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 0aa4b6bc5101..7f7672f72085 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -92,7 +92,7 @@ bool __generic_fsdax_supported(struct dax_device *dax_dev,
 		return false;
 	}
 
-	last_page = PFN_DOWN((start + sectors - 1) * 512) * PAGE_SIZE / 512;
+	last_page = PFN_DOWN((start + sectors - 1) * 512) * PAGE_SECTORS;
 	err = bdev_dax_pgoff(bdev, last_page, PAGE_SIZE, &pgoff_end);
 	if (err) {
 		pr_debug("%s: error: unaligned partition for dax\n",
diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index c029f7443190..55196e0f37c3 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -15,8 +15,6 @@
 
 #include "closure.h"
 
-#define PAGE_SECTORS		(PAGE_SIZE / 512)
-
 struct closure;
 
 #ifdef CONFIG_BCACHE_DEBUG
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 2d519c223562..f4496ce0d598 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -384,7 +384,7 @@ static void *alloc_buffer_data(struct dm_bufio_client *c, gfp_t gfp_mask,
 	    gfp_mask & __GFP_NORETRY) {
 		*data_mode = DATA_MODE_GET_FREE_PAGES;
 		return (void *)__get_free_pages(gfp_mask,
-						c->sectors_per_block_bits - (PAGE_SHIFT - SECTOR_SHIFT));
+						c->sectors_per_block_bits - PAGE_SECTORS_SHIFT);
 	}
 
 	*data_mode = DATA_MODE_VMALLOC;
@@ -422,7 +422,7 @@ static void free_buffer_data(struct dm_bufio_client *c,
 
 	case DATA_MODE_GET_FREE_PAGES:
 		free_pages((unsigned long)data,
-			   c->sectors_per_block_bits - (PAGE_SHIFT - SECTOR_SHIFT));
+			   c->sectors_per_block_bits - PAGE_SECTORS_SHIFT);
 		break;
 
 	case DATA_MODE_VMALLOC:
@@ -597,7 +597,7 @@ static void use_bio(struct dm_buffer *b, int rw, sector_t sector,
 	unsigned vec_size, len;
 
 	vec_size = b->c->block_size >> PAGE_SHIFT;
-	if (unlikely(b->c->sectors_per_block_bits < PAGE_SHIFT - SECTOR_SHIFT))
+	if (unlikely(b->c->sectors_per_block_bits < PAGE_SECTORS_SHIFT))
 		vec_size += 2;
 
 	bio = bio_kmalloc(GFP_NOWAIT | __GFP_NORETRY | __GFP_NOWARN, vec_size);
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index b225b3e445fa..4e60cda465cc 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -652,7 +652,7 @@ static void page_list_location(struct dm_integrity_c *ic, unsigned section, unsi
 
 	sector = section * ic->journal_section_sectors + offset;
 
-	*pl_index = sector >> (PAGE_SHIFT - SECTOR_SHIFT);
+	*pl_index = sector >> PAGE_SECTORS_SHIFT;
 	*pl_offset = (sector << SECTOR_SHIFT) & (PAGE_SIZE - 1);
 }
 
@@ -951,7 +951,7 @@ static void rw_journal_sectors(struct dm_integrity_c *ic, int op, int op_flags,
 		return;
 	}
 
-	pl_index = sector >> (PAGE_SHIFT - SECTOR_SHIFT);
+	pl_index = sector >> PAGE_SECTORS_SHIFT;
 	pl_offset = (sector << SECTOR_SHIFT) & (PAGE_SIZE - 1);
 
 	io_req.bi_op = op;
@@ -1072,7 +1072,7 @@ static void copy_from_journal(struct dm_integrity_c *ic, unsigned section, unsig
 
 	sector = section * ic->journal_section_sectors + JOURNAL_BLOCK_SECTORS + offset;
 
-	pl_index = sector >> (PAGE_SHIFT - SECTOR_SHIFT);
+	pl_index = sector >> PAGE_SECTORS_SHIFT;
 	pl_offset = (sector << SECTOR_SHIFT) & (PAGE_SIZE - 1);
 
 	io_req.bi_op = REQ_OP_WRITE;
@@ -3343,7 +3343,7 @@ static int create_journal(struct dm_integrity_c *ic, char **error)
 	ic->commit_ids[3] = cpu_to_le64(0x4444444444444444ULL);
 
 	journal_pages = roundup((__u64)ic->journal_sections * ic->journal_section_sectors,
-				PAGE_SIZE >> SECTOR_SHIFT) >> (PAGE_SHIFT - SECTOR_SHIFT);
+				PAGE_SIZE >> SECTOR_SHIFT) >> PAGE_SECTORS_SHIFT;
 	journal_desc_size = journal_pages * sizeof(struct page_list);
 	if (journal_pages >= totalram_pages() - totalhigh_pages() || journal_desc_size > ULONG_MAX) {
 		*error = "Journal doesn't fit into memory";
@@ -4075,7 +4075,7 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 			spin_lock_init(&bbs->bio_queue_lock);
 
 			sector = i * (BITMAP_BLOCK_SIZE >> SECTOR_SHIFT);
-			pl_index = sector >> (PAGE_SHIFT - SECTOR_SHIFT);
+			pl_index = sector >> PAGE_SECTORS_SHIFT;
 			pl_offset = (sector << SECTOR_SHIFT) & (PAGE_SIZE - 1);
 
 			bbs->bitmap = lowmem_page_address(ic->journal[pl_index].page) + pl_offset;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 469f551863be..b28f9390608f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1734,7 +1734,7 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 		__le64 *bbp;
 		int i;
 		int sectors = le16_to_cpu(sb->bblog_size);
-		if (sectors > (PAGE_SIZE / 512))
+		if (sectors > PAGE_SECTORS)
 			return -EINVAL;
 		offset = le32_to_cpu(sb->bblog_offset);
 		if (offset == 0)
@@ -8733,7 +8733,7 @@ void md_do_sync(struct md_thread *thread)
 	/*
 	 * Tune reconstruction:
 	 */
-	window = 32 * (PAGE_SIZE / 512);
+	window = 32 * PAGE_SECTORS;
 	pr_debug("md: using %dk window, over a total of %lluk.\n",
 		 window/2, (unsigned long long)max_sectors/2);
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index cd810e195086..37a0b571903a 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2129,7 +2129,7 @@ static void process_checks(struct r1bio *r1_bio)
 	int vcnt;
 
 	/* Fix variable parts of all bios */
-	vcnt = (r1_bio->sectors + PAGE_SIZE / 512 - 1) >> (PAGE_SHIFT - 9);
+	vcnt = (r1_bio->sectors + PAGE_SECTORS - 1) >> (PAGE_SHIFT - 9);
 	for (i = 0; i < conf->raid_disks * 2; i++) {
 		blk_status_t status;
 		struct bio *b = r1_bio->bios[i];
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index c8768726d925..4a23fb9d5642 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -18,6 +18,7 @@
 #include <linux/export.h>
 #include <linux/leds.h>
 #include <linux/slab.h>
+#include <linux/blkdev.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
@@ -427,7 +428,7 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
 
 	host->max_req_size = PAGE_SIZE;
 	host->max_blk_size = 512;
-	host->max_blk_count = PAGE_SIZE / 512;
+	host->max_blk_count = PAGE_SECTORS;
 
 	host->fixed_drv_type = -EINVAL;
 	host->ios.power_delay_ms = 10;
diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index f0068e96a177..e6b29e54d07a 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -852,7 +852,7 @@ static int scsifront_probe(struct xenbus_device *dev,
 	host->max_id      = VSCSIIF_MAX_TARGET;
 	host->max_channel = 0;
 	host->max_lun     = VSCSIIF_MAX_LUN;
-	host->max_sectors = (host->sg_tablesize - 1) * PAGE_SIZE / 512;
+	host->max_sectors = (host->sg_tablesize - 1) * PAGE_SECTORS;
 	host->max_cmd_len = VSCSIIF_MAX_COMMAND_SIZE;
 
 	err = scsi_add_host(host, &dev->dev);
@@ -1073,7 +1073,7 @@ static void scsifront_read_backend_params(struct xenbus_device *dev,
 			 host->sg_tablesize, nr_segs);
 
 	host->sg_tablesize = nr_segs;
-	host->max_sectors = (nr_segs - 1) * PAGE_SIZE / 512;
+	host->max_sectors = (nr_segs - 1) * PAGE_SECTORS;
 }
 
 static void scsifront_backend_changed(struct xenbus_device *dev,
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 7c84c4c027c4..60505fc156c5 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -29,7 +29,7 @@ struct iomap_page {
 	atomic_t		read_count;
 	atomic_t		write_count;
 	spinlock_t		uptodate_lock;
-	DECLARE_BITMAP(uptodate, PAGE_SIZE / 512);
+	DECLARE_BITMAP(uptodate, PAGE_SECTORS);
 };
 
 static inline struct iomap_page *to_iomap_page(struct page *page)
diff --git a/fs/nfs/blocklayout/blocklayout.h b/fs/nfs/blocklayout/blocklayout.h
index 716bc75e9ed2..22407751e0fd 100644
--- a/fs/nfs/blocklayout/blocklayout.h
+++ b/fs/nfs/blocklayout/blocklayout.h
@@ -40,8 +40,6 @@
 #include "../pnfs.h"
 #include "../netns.h"
 
-#define PAGE_CACHE_SECTORS (PAGE_SIZE >> SECTOR_SHIFT)
-#define PAGE_CACHE_SECTOR_SHIFT (PAGE_SHIFT - SECTOR_SHIFT)
 #define SECTOR_SIZE (1 << SECTOR_SHIFT)
 
 struct pnfs_block_dev;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 053ea4b51988..98b2cbd0299a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -910,6 +910,10 @@ static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
 #define SECTOR_SIZE (1 << SECTOR_SHIFT)
 #endif
 
+#define PAGE_SECTORS_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
+#define PAGE_SECTORS		(1 << PAGE_SECTORS_SHIFT)
+#define PAGE_SECTORS_MASK	(~(PAGE_SECTORS - 1))
+
 /*
  * blk_rq_pos()			: the current sector
  * blk_rq_bytes()		: bytes left in the entire request
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 475668c69dbc..c98a533f8ffa 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -141,7 +141,6 @@ typedef long (*dm_dax_direct_access_fn) (struct dm_target *ti, pgoff_t pgoff,
 		long nr_pages, void **kaddr, pfn_t *pfn);
 typedef size_t (*dm_dax_copy_iter_fn)(struct dm_target *ti, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *i);
-#define PAGE_SECTORS (PAGE_SIZE / 512)
 
 void dm_error(const char *message);
 
-- 
2.24.1

