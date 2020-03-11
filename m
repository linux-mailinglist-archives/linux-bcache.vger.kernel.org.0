Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 059E0180CC3
	for <lists+linux-bcache@lfdr.de>; Wed, 11 Mar 2020 01:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbgCKAXM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 10 Mar 2020 20:23:12 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45978 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727591AbgCKAXM (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 10 Mar 2020 20:23:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583886190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=AF0phWtBzaybkf0W4o0XLko38kCzMiwJ9FW0oNdt4Ec=;
        b=XupwqhtYX8wga71UnuF0BxeyHsOIK2ozqlMir3QLoUj0ywqV7KjnxH5M16YLw7BXI99DPb
        VgLtKA1q1Sg3qY1Wqkm/JuuTEHJ2NxR2chVAeE6YiUYRIl8+ejSHa68FTTflEhL80vlzJB
        T/wIUtvLt9Uvp3WKbYHcSQUNO3X7YdU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-858t0JqANOCgTF9SJtmEOQ-1; Tue, 10 Mar 2020 20:23:08 -0400
X-MC-Unique: 858t0JqANOCgTF9SJtmEOQ-1
Received: by mail-wm1-f71.google.com with SMTP id y7so173624wmd.4
        for <linux-bcache@vger.kernel.org>; Tue, 10 Mar 2020 17:23:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AF0phWtBzaybkf0W4o0XLko38kCzMiwJ9FW0oNdt4Ec=;
        b=qKQRbHwfVhY02XMQDuRVnbnHqqlap7u9nItvzNXaqTjkJi7v1edzAbh5gn1cpGm3fx
         EgKh9s232Y4YeU6c5oLbtP7a4xAQSLAccDVuR7wd1nNZXqKZXybJT6ULTwhP32p3To4b
         uyai9z1NuxLQ7xOMCvInXq0/hbY6mWJn9wnv2Y33JA9kO8CXs2kVXHBnv9OFa8P4oPiJ
         qOF0qCSw5KVGCPVjYpJ2goMHhM2lFD83Kst5ilLDkfSmXqHjFt2e4c4tEUe9RsdtIcgs
         S2hFAFaJpd80iS+rFaNGgAPTdcQULgEE0Tjq1jg0f3Sm2iLOLeMcWUIYb9xfJfykdbsz
         XJAQ==
X-Gm-Message-State: ANhLgQ2GBtFJKRsQiHc9OtehseJoKYBDZmyYwImZa1W4tCB2rUNgNWc1
        IIGyZrBXBEdSUnRBDQQUmiQZRKNFtvXm7Oxt5rrKUhEaikjjRZCh4oG6E1GCR/ZhjXb4gBmKO2k
        QOeXEY6axXQfhf45UxifbBt0k
X-Received: by 2002:a05:600c:24b:: with SMTP id 11mr135690wmj.1.1583886186684;
        Tue, 10 Mar 2020 17:23:06 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vskya3VIJ2O35SM2qD5qkRNEFkTaIMR/iZ1Olb+WBpvswMPPj2jGybAw7/Dtv1byE5BePKdLg==
X-Received: by 2002:a05:600c:24b:: with SMTP id 11mr135633wmj.1.1583886186002;
        Tue, 10 Mar 2020 17:23:06 -0700 (PDT)
Received: from raver.teknoraver.net (net-93-144-9-178.cust.vodafonedsl.it. [93.144.9.178])
        by smtp.gmail.com with ESMTPSA id c2sm6285481wma.39.2020.03.10.17.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 17:23:05 -0700 (PDT)
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
        Song Liu <song@kernel.org>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH v3] block: refactor duplicated macros
Date:   Wed, 11 Mar 2020 01:22:54 +0100
Message-Id: <20200311002254.121365-1-mcroce@redhat.com>
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

While at it, replace replace "PAGE_SHIFT - 9" with "PAGE_SECTORS_SHIFT" too
and rename SECTOR_MASK to PAGE_SECTORS_MASK.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
v3:
As Guoqing Jiang suggested, replace "PAGE_SHIFT - 9" with "PAGE_SECTORS_SHIFT"

v2:
As Dan Williams suggested:

 #define PAGE_SECTORS_MASK            (~(PAGE_SECTORS - 1))

 block/blk-lib.c                  |  2 +-
 block/blk-settings.c             |  4 ++--
 block/partition-generic.c        |  2 +-
 drivers/block/brd.c              |  3 ---
 drivers/block/null_blk_main.c    | 14 +++++---------
 drivers/block/zram/zram_drv.c    |  8 ++++----
 drivers/block/zram/zram_drv.h    |  2 --
 drivers/dax/super.c              |  2 +-
 drivers/md/bcache/util.h         |  2 --
 drivers/md/dm-bufio.c            |  6 +++---
 drivers/md/dm-integrity.c        | 10 +++++-----
 drivers/md/dm-table.c            |  2 +-
 drivers/md/md.c                  |  4 ++--
 drivers/md/raid1.c               |  2 +-
 drivers/md/raid10.c              |  2 +-
 drivers/md/raid5-cache.c         | 10 +++++-----
 drivers/md/raid5.h               |  2 +-
 drivers/mmc/core/host.c          |  3 ++-
 drivers/nvme/host/fc.c           |  2 +-
 drivers/nvme/target/loop.c       |  2 +-
 drivers/scsi/xen-scsifront.c     |  4 ++--
 fs/erofs/internal.h              |  2 +-
 fs/ext2/dir.c                    |  2 +-
 fs/iomap/buffered-io.c           |  2 +-
 fs/libfs.c                       |  2 +-
 fs/nfs/blocklayout/blocklayout.h |  2 --
 fs/nilfs2/dir.c                  |  2 +-
 include/linux/blkdev.h           |  4 ++++
 include/linux/device-mapper.h    |  1 -
 mm/page_io.c                     |  4 ++--
 mm/swapfile.c                    | 12 ++++++------
 31 files changed, 56 insertions(+), 65 deletions(-)

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
diff --git a/block/blk-settings.c b/block/blk-settings.c
index c8eda2e7b91e..e29933581ac0 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -186,7 +186,7 @@ void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_hw_secto
 	unsigned int max_sectors;
 
 	if ((max_hw_sectors << 9) < PAGE_SIZE) {
-		max_hw_sectors = 1 << (PAGE_SHIFT - 9);
+		max_hw_sectors = 1 << PAGE_SECTORS_SHIFT;
 		printk(KERN_INFO "%s: set to minimum %d\n",
 		       __func__, max_hw_sectors);
 	}
@@ -195,7 +195,7 @@ void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_hw_secto
 	max_sectors = min_not_zero(max_hw_sectors, limits->max_dev_sectors);
 	max_sectors = min_t(unsigned int, max_sectors, BLK_DEF_MAX_SECTORS);
 	limits->max_sectors = max_sectors;
-	q->backing_dev_info->io_pages = max_sectors >> (PAGE_SHIFT - 9);
+	q->backing_dev_info->io_pages = max_sectors >> PAGE_SECTORS_SHIFT;
 }
 EXPORT_SYMBOL(blk_queue_max_hw_sectors);
 
diff --git a/block/partition-generic.c b/block/partition-generic.c
index 564fae77711d..5f06b7a6c119 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -612,7 +612,7 @@ unsigned char *read_dev_sector(struct block_device *bdev, sector_t n, Sector *p)
 		if (PageError(page))
 			goto fail;
 		p->v = page;
-		return (unsigned char *)page_address(page) +  ((n & ((1 << (PAGE_SHIFT - 9)) - 1)) << 9);
+		return (unsigned char *)page_address(page) +  ((n & ((1 << PAGE_SECTORS_SHIFT) - 1)) << 9);
 fail:
 		put_page(page);
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
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 0a2cc197f62b..56000202492e 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1964,7 +1964,7 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 #endif
 
 	/* Allow reads to exceed readahead limits */
-	q->backing_dev_info->io_pages = limits->max_sectors >> (PAGE_SHIFT - 9);
+	q->backing_dev_info->io_pages = limits->max_sectors >> PAGE_SECTORS_SHIFT;
 }
 
 unsigned int dm_table_get_num_targets(struct dm_table *t)
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
index cd810e195086..fd70fc62ad11 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2129,7 +2129,7 @@ static void process_checks(struct r1bio *r1_bio)
 	int vcnt;
 
 	/* Fix variable parts of all bios */
-	vcnt = (r1_bio->sectors + PAGE_SIZE / 512 - 1) >> (PAGE_SHIFT - 9);
+	vcnt = (r1_bio->sectors + PAGE_SECTORS - 1) >> PAGE_SECTORS_SHIFT;
 	for (i = 0; i < conf->raid_disks * 2; i++) {
 		blk_status_t status;
 		struct bio *b = r1_bio->bios[i];
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ec136e44aef7..889c4b7c1c35 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2029,7 +2029,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	fbio->bi_iter.bi_idx = 0;
 	fpages = get_resync_pages(fbio)->pages;
 
-	vcnt = (r10_bio->sectors + (PAGE_SIZE >> 9) - 1) >> (PAGE_SHIFT - 9);
+	vcnt = (r10_bio->sectors + (PAGE_SIZE >> 9) - 1) >> PAGE_SECTORS_SHIFT;
 	/* now find blocks with errors */
 	for (i=0 ; i < conf->copies ; i++) {
 		int  j, d;
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 9b6da759dca2..ad5470c12bb3 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -833,7 +833,7 @@ static void r5l_append_payload_meta(struct r5l_log *log, u16 type,
 	payload->header.type = cpu_to_le16(type);
 	payload->header.flags = cpu_to_le16(0);
 	payload->size = cpu_to_le32((1 + !!checksum2_valid) <<
-				    (PAGE_SHIFT - 9));
+				    PAGE_SECTORS_SHIFT);
 	payload->location = cpu_to_le64(location);
 	payload->checksum[0] = cpu_to_le32(checksum1);
 	if (checksum2_valid)
@@ -1042,7 +1042,7 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 
 	mutex_lock(&log->io_mutex);
 	/* meta + data */
-	reserve = (1 + write_disks) << (PAGE_SHIFT - 9);
+	reserve = (1 + write_disks) << PAGE_SECTORS_SHIFT;
 
 	if (log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_THROUGH) {
 		if (!r5l_has_free_space(log, reserve)) {
@@ -2053,7 +2053,7 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l_log *log,
 						  le32_to_cpu(payload->size));
 			mb_offset += sizeof(struct r5l_payload_data_parity) +
 				sizeof(__le32) *
-				(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
+				(le32_to_cpu(payload->size) >> PAGE_SECTORS_SHIFT);
 		}
 
 	}
@@ -2199,7 +2199,7 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 
 		mb_offset += sizeof(struct r5l_payload_data_parity) +
 			sizeof(__le32) *
-			(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
+			(le32_to_cpu(payload->size) >> PAGE_SECTORS_SHIFT);
 	}
 
 	return 0;
@@ -2916,7 +2916,7 @@ int r5c_cache_data(struct r5l_log *log, struct stripe_head *sh)
 
 	mutex_lock(&log->io_mutex);
 	/* meta + data */
-	reserve = (1 + pages) << (PAGE_SHIFT - 9);
+	reserve = (1 + pages) << PAGE_SECTORS_SHIFT;
 
 	if (test_bit(R5C_LOG_CRITICAL, &conf->cache_state) &&
 	    sh->log_start == MaxSector)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index f90e0704bed9..49dfd8a9544a 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -473,7 +473,7 @@ struct disk_info {
 
 #define NR_STRIPES		256
 #define STRIPE_SIZE		PAGE_SIZE
-#define STRIPE_SHIFT		(PAGE_SHIFT - 9)
+#define STRIPE_SHIFT		PAGE_SECTORS_SHIFT
 #define STRIPE_SECTORS		(STRIPE_SIZE>>9)
 #define	IO_THRESHOLD		1
 #define BYPASS_THRESHOLD	1
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
diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 5a70ac395d53..3401e82ea323 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2674,7 +2674,7 @@ nvme_fc_create_association(struct nvme_fc_ctrl *ctrl)
 		goto out_disconnect_admin_queue;
 
 	ctrl->ctrl.max_hw_sectors =
-		(ctrl->lport->ops->max_sgl_segments - 1) << (PAGE_SHIFT - 9);
+		(ctrl->lport->ops->max_sgl_segments - 1) << PAGE_SECTORS_SHIFT;
 
 	blk_mq_unquiesce_queue(ctrl->ctrl.admin_q);
 
diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index 4df4ebde208a..d43ac4b2ebef 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -382,7 +382,7 @@ static int nvme_loop_configure_admin_queue(struct nvme_loop_ctrl *ctrl)
 		goto out_cleanup_queue;
 
 	ctrl->ctrl.max_hw_sectors =
-		(NVME_LOOP_MAX_SEGMENTS - 1) << (PAGE_SHIFT - 9);
+		(NVME_LOOP_MAX_SEGMENTS - 1) << PAGE_SECTORS_SHIFT;
 
 	blk_mq_unquiesce_queue(ctrl->ctrl.admin_q);
 
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
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index c4c6dcdc89ad..210ca148cc0c 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -189,7 +189,7 @@ static inline int erofs_wait_on_workgroup_freezed(struct erofs_workgroup *grp)
 #define LOG_BLOCK_SIZE		PAGE_SHIFT
 
 #undef LOG_SECTORS_PER_BLOCK
-#define LOG_SECTORS_PER_BLOCK	(PAGE_SHIFT - 9)
+#define LOG_SECTORS_PER_BLOCK	PAGE_SECTORS_SHIFT
 
 #undef SECTORS_PER_BLOCK
 #define SECTORS_PER_BLOCK	(1 << SECTORS_PER_BLOCK)
diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 13318e255ebf..5014a6fc5c6e 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -385,7 +385,7 @@ struct ext2_dir_entry_2 *ext2_find_entry (struct inode *dir,
 		if (++n >= npages)
 			n = 0;
 		/* next page is past the blocks we've got */
-		if (unlikely(n > (dir->i_blocks >> (PAGE_SHIFT - 9)))) {
+		if (unlikely(n > (dir->i_blocks >> PAGE_SECTORS_SHIFT))) {
 			ext2_error(dir->i_sb, __func__,
 				"dir %lu size %lld exceeds block count %llu",
 				dir->i_ino, dir->i_size,
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
diff --git a/fs/libfs.c b/fs/libfs.c
index c686bd9caac6..00ca96752fcb 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -30,7 +30,7 @@ int simple_getattr(const struct path *path, struct kstat *stat,
 {
 	struct inode *inode = d_inode(path->dentry);
 	generic_fillattr(inode, stat);
-	stat->blocks = inode->i_mapping->nrpages << (PAGE_SHIFT - 9);
+	stat->blocks = inode->i_mapping->nrpages << PAGE_SECTORS_SHIFT;
 	return 0;
 }
 EXPORT_SYMBOL(simple_getattr);
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
diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 81394e22d0a0..77c06e999828 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -368,7 +368,7 @@ nilfs_find_entry(struct inode *dir, const struct qstr *qstr,
 		if (++n >= npages)
 			n = 0;
 		/* next page is past the blocks we've got */
-		if (unlikely(n > (dir->i_blocks >> (PAGE_SHIFT - 9)))) {
+		if (unlikely(n > (dir->i_blocks >> PAGE_SECTORS_SHIFT))) {
 			nilfs_error(dir->i_sb,
 			       "dir %lu size %lld exceeds block count %llu",
 			       dir->i_ino, dir->i_size,
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
 
diff --git a/mm/page_io.c b/mm/page_io.c
index 76965be1d40e..9e3376ad60f5 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -38,7 +38,7 @@ static struct bio *get_swap_bio(gfp_t gfp_flags,
 
 		bio->bi_iter.bi_sector = map_swap_page(page, &bdev);
 		bio_set_dev(bio, bdev);
-		bio->bi_iter.bi_sector <<= PAGE_SHIFT - 9;
+		bio->bi_iter.bi_sector <<= PAGE_SECTORS_SHIFT;
 		bio->bi_end_io = end_io;
 
 		bio_add_page(bio, page, PAGE_SIZE * hpage_nr_pages(page), 0);
@@ -266,7 +266,7 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
 
 static sector_t swap_page_sector(struct page *page)
 {
-	return (sector_t)__page_file_index(page) << (PAGE_SHIFT - 9);
+	return (sector_t)__page_file_index(page) << PAGE_SECTORS_SHIFT;
 }
 
 static inline void count_swpout_vm_event(struct page *page)
diff --git a/mm/swapfile.c b/mm/swapfile.c
index b2a2e45c9a36..1cf3c80295d2 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -177,8 +177,8 @@ static int discard_swap(struct swap_info_struct *si)
 
 	/* Do not discard the swap header page! */
 	se = first_se(si);
-	start_block = (se->start_block + 1) << (PAGE_SHIFT - 9);
-	nr_blocks = ((sector_t)se->nr_pages - 1) << (PAGE_SHIFT - 9);
+	start_block = (se->start_block + 1) << PAGE_SECTORS_SHIFT;
+	nr_blocks = ((sector_t)se->nr_pages - 1) << PAGE_SECTORS_SHIFT;
 	if (nr_blocks) {
 		err = blkdev_issue_discard(si->bdev, start_block,
 				nr_blocks, GFP_KERNEL, 0);
@@ -188,8 +188,8 @@ static int discard_swap(struct swap_info_struct *si)
 	}
 
 	for (se = next_se(se); se; se = next_se(se)) {
-		start_block = se->start_block << (PAGE_SHIFT - 9);
-		nr_blocks = (sector_t)se->nr_pages << (PAGE_SHIFT - 9);
+		start_block = se->start_block << PAGE_SECTORS_SHIFT;
+		nr_blocks = (sector_t)se->nr_pages << PAGE_SECTORS_SHIFT;
 
 		err = blkdev_issue_discard(si->bdev, start_block,
 				nr_blocks, GFP_KERNEL, 0);
@@ -240,8 +240,8 @@ static void discard_swap_cluster(struct swap_info_struct *si,
 		start_page += nr_blocks;
 		nr_pages -= nr_blocks;
 
-		start_block <<= PAGE_SHIFT - 9;
-		nr_blocks <<= PAGE_SHIFT - 9;
+		start_block <<= PAGE_SECTORS_SHIFT;
+		nr_blocks <<= PAGE_SECTORS_SHIFT;
 		if (blkdev_issue_discard(si->bdev, start_block,
 					nr_blocks, GFP_NOIO, 0))
 			break;
-- 
2.24.1

