Return-Path: <linux-bcache+bounces-527-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 908759030A3
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 07:26:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17DEF1F27AB4
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 05:26:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF16917C20F;
	Tue, 11 Jun 2024 05:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hy3Il6hU"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A4317166A;
	Tue, 11 Jun 2024 05:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718083243; cv=none; b=f80lVjob8Gel5yglLLI9UtPYknJelPiL764dPpcNykv5DsQswS3KCpADqg5oPHCX7xh7kgMHhBqg1cg7lZlP/UD86+vBbRNivpkYHCjXf1k8dOuZS/WRWS+QDj4pSiaXLsaCj6RRpcFAOa3J2o34NnUlVPIMUvxVck483RWTXVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718083243; c=relaxed/simple;
	bh=i5ZSqfpZP0FYGprdRybfpR3G9dcShFLuzb9BmlCvrVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fA4o7+8v1nsMseOQ4/tsVX0CgsdgWHsgWToHGiYK//UC/bLAM7trzSYEz3xhg0PcnILrVASKBF/dBS7M3QZAoe2q7mlpJkvWHpthydnzUUf57ToiePyW7hcG2SiJI0/RuBygu+/4XEAvo3jToOudGRGqP/124dzVR2/DyTEbmTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hy3Il6hU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=DgqWvoasERFRGuaCM+34rIUlXtPEepp99/7axWusXVI=; b=hy3Il6hUt6KqrOBQKKM8CUO3v+
	Mpo2qrQ6tRt5yXvoXLX8c/7qQJhPWZlEEG4tzuq8l2ohCB9gTJ/YcHMFRigpuEsWcFWwfDO6ZJ/cf
	o212GgxfQY+Ob2IFb8hv+EeZk58OyRrCiwaOiS0wyHKzLe74X4AWtScXMSTEJy5aGx4XFiCogybQV
	GFSIG6PVwRQf+1ujQ7y4zlHamOxPmlsMqbrOjGpgW6cQZ52UcXYU75vAybSksE5qfQbMHMcAdIBUb
	cH9YlxIMwbPYf5TcJdJZ3DC4jhlrTTAYwo5X/aRhV5iPfmcdGbCzukB6CsVrVyBGTV3ln8cnYw9b/
	TJsyHOTQ==;
Received: from 2a02-8389-2341-5b80-cdb4-8e7d-405d-6b77.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:cdb4:8e7d:405d:6b77] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sGtvl-00000007RO6-3vhP;
	Tue, 11 Jun 2024 05:20:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Richard Weinberger <richard@nod.at>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Ming Lei <ming.lei@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-m68k@lists.linux-m68k.org,
	linux-um@lists.infradead.org,
	drbd-dev@lists.linbit.com,
	nbd@other.debian.org,
	linuxppc-dev@lists.ozlabs.org,
	ceph-devel@vger.kernel.org,
	virtualization@lists.linux.dev,
	xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: [PATCH 18/26] block: move the synchronous flag to queue_limits
Date: Tue, 11 Jun 2024 07:19:18 +0200
Message-ID: <20240611051929.513387-19-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240611051929.513387-1-hch@lst.de>
References: <20240611051929.513387-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move the synchronous flag into the queue_limits feature field so that it
can be set atomically and all I/O is frozen when changing the flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq-debugfs.c        | 1 -
 drivers/block/brd.c           | 2 +-
 drivers/block/zram/zram_drv.c | 4 ++--
 drivers/nvdimm/btt.c          | 3 +--
 drivers/nvdimm/pmem.c         | 4 ++--
 include/linux/blkdev.h        | 7 ++++---
 6 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index eb73f1d348e5a9..957774e40b1d0c 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -85,7 +85,6 @@ static const char *const blk_queue_flag_name[] = {
 	QUEUE_FLAG_NAME(SAME_COMP),
 	QUEUE_FLAG_NAME(FAIL_IO),
 	QUEUE_FLAG_NAME(NOXMERGES),
-	QUEUE_FLAG_NAME(SYNCHRONOUS),
 	QUEUE_FLAG_NAME(SAME_FORCE),
 	QUEUE_FLAG_NAME(INIT_DONE),
 	QUEUE_FLAG_NAME(POLL),
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index b25dc463b5e3a6..d77deb571dbd06 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -335,6 +335,7 @@ static int brd_alloc(int i)
 		.max_hw_discard_sectors	= UINT_MAX,
 		.max_discard_segments	= 1,
 		.discard_granularity	= PAGE_SIZE,
+		.features		= BLK_FEAT_SYNCHRONOUS,
 	};
 
 	list_for_each_entry(brd, &brd_devices, brd_list)
@@ -366,7 +367,6 @@ static int brd_alloc(int i)
 	strscpy(disk->disk_name, buf, DISK_NAME_LEN);
 	set_capacity(disk, rd_size * 2);
 	
-	blk_queue_flag_set(QUEUE_FLAG_SYNCHRONOUS, disk->queue);
 	blk_queue_flag_set(QUEUE_FLAG_NOWAIT, disk->queue);
 	err = add_disk(disk);
 	if (err)
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index f8f1b5b54795ac..efcb8d9d274c31 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2208,7 +2208,8 @@ static int zram_add(void)
 #if ZRAM_LOGICAL_BLOCK_SIZE == PAGE_SIZE
 		.max_write_zeroes_sectors	= UINT_MAX,
 #endif
-		.features			= BLK_FEAT_STABLE_WRITES,
+		.features			= BLK_FEAT_STABLE_WRITES |
+						  BLK_FEAT_SYNCHRONOUS,
 	};
 	struct zram *zram;
 	int ret, device_id;
@@ -2246,7 +2247,6 @@ static int zram_add(void)
 
 	/* Actual capacity set using sysfs (/sys/block/zram<id>/disksize */
 	set_capacity(zram->disk, 0);
-	blk_queue_flag_set(QUEUE_FLAG_SYNCHRONOUS, zram->disk->queue);
 	ret = device_add_disk(NULL, zram->disk, zram_disk_groups);
 	if (ret)
 		goto out_cleanup_disk;
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index e474afa8e9f68d..e79c06d65bb77b 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1501,6 +1501,7 @@ static int btt_blk_init(struct btt *btt)
 		.logical_block_size	= btt->sector_size,
 		.max_hw_sectors		= UINT_MAX,
 		.max_integrity_segments	= 1,
+		.features		= BLK_FEAT_SYNCHRONOUS,
 	};
 	int rc;
 
@@ -1518,8 +1519,6 @@ static int btt_blk_init(struct btt *btt)
 	btt->btt_disk->fops = &btt_fops;
 	btt->btt_disk->private_data = btt;
 
-	blk_queue_flag_set(QUEUE_FLAG_SYNCHRONOUS, btt->btt_disk->queue);
-
 	set_capacity(btt->btt_disk, btt->nlba * btt->sector_size >> 9);
 	rc = device_add_disk(&btt->nd_btt->dev, btt->btt_disk, NULL);
 	if (rc)
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 501cf226df0187..b821dcf018f6ae 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -455,7 +455,8 @@ static int pmem_attach_disk(struct device *dev,
 		.logical_block_size	= pmem_sector_size(ndns),
 		.physical_block_size	= PAGE_SIZE,
 		.max_hw_sectors		= UINT_MAX,
-		.features		= BLK_FEAT_WRITE_CACHE,
+		.features		= BLK_FEAT_WRITE_CACHE |
+					  BLK_FEAT_SYNCHRONOUS,
 	};
 	int nid = dev_to_node(dev), fua;
 	struct resource *res = &nsio->res;
@@ -546,7 +547,6 @@ static int pmem_attach_disk(struct device *dev,
 	}
 	pmem->virt_addr = addr;
 
-	blk_queue_flag_set(QUEUE_FLAG_SYNCHRONOUS, q);
 	if (pmem->pfn_flags & PFN_MAP)
 		blk_queue_flag_set(QUEUE_FLAG_DAX, q);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index db14c61791e022..4d908e29c760da 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -301,6 +301,9 @@ enum {
 
 	/* don't modify data until writeback is done */
 	BLK_FEAT_STABLE_WRITES			= (1u << 5),
+
+	/* always completes in submit context */
+	BLK_FEAT_SYNCHRONOUS			= (1u << 6),
 };
 
 /*
@@ -566,7 +569,6 @@ struct request_queue {
 #define QUEUE_FLAG_SAME_COMP	4	/* complete on same CPU-group */
 #define QUEUE_FLAG_FAIL_IO	5	/* fake timeout */
 #define QUEUE_FLAG_NOXMERGES	9	/* No extended merges */
-#define QUEUE_FLAG_SYNCHRONOUS	11	/* always completes in submit context */
 #define QUEUE_FLAG_SAME_FORCE	12	/* force complete on same CPU */
 #define QUEUE_FLAG_INIT_DONE	14	/* queue is initialized */
 #define QUEUE_FLAG_POLL		16	/* IO polling enabled if set */
@@ -1315,8 +1317,7 @@ static inline bool bdev_nonrot(struct block_device *bdev)
 
 static inline bool bdev_synchronous(struct block_device *bdev)
 {
-	return test_bit(QUEUE_FLAG_SYNCHRONOUS,
-			&bdev_get_queue(bdev)->queue_flags);
+	return bdev->bd_disk->queue->limits.features & BLK_FEAT_SYNCHRONOUS;
 }
 
 static inline bool bdev_stable_writes(struct block_device *bdev)
-- 
2.43.0


