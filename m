Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD68738BE0D
	for <lists+linux-bcache@lfdr.de>; Fri, 21 May 2021 07:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbhEUFxN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 21 May 2021 01:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234242AbhEUFxJ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 21 May 2021 01:53:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB86C061763;
        Thu, 20 May 2021 22:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=EkLd0nYnyLCmBXUO0GObaMtosm7d26bg6Wbjy71f0gk=; b=H16lnaBVNTx3ZSC9sj1cvZgwUY
        5wtcjGkslusA/lPPGRK00Zg5f+ektzZtdlNvpnt/DvdW93zHAi1Xm7UKhy0ZlRMevF0euZFYFtf+0
        HYPcCnoxUdyzg1EP5GMzj4i08ZcFl7CRQMVETjJPCKSCauZfWFZJm0cC8ECVWhdayO3bieBEpUVZO
        2YTQLWauA09cDW+g23ZVJ40RX1QYgL6hKJECzmbUZZBG8B7p9v2PaTEM8Tqz5KS59aUypSCP2j5Wh
        7aNm83AH7YV9Y6e8rccM1df8RQG5SBihr9nfbP1ZD0oX8KqQRBeFKmecZSO6T/3wQultej6dRPy5U
        5ltNPdDg==;
Received: from [2001:4bb8:180:5add:4fd7:4137:d2f2:46e6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1ljy4A-00Gpwn-Ii; Fri, 21 May 2021 05:51:23 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jim Paris <jim@jtan.com>,
        Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.ibm.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Matias Bjorling <mb@lightnvm.io>, Coly Li <colyli@suse.de>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Alex Dubov <oakad@yahoo.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
        drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mmc@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org
Subject: [PATCH 01/26] block: refactor device number setup in __device_add_disk
Date:   Fri, 21 May 2021 07:50:51 +0200
Message-Id: <20210521055116.1053587-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210521055116.1053587-1-hch@lst.de>
References: <20210521055116.1053587-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Untangle the mess around blk_alloc_devt by moving the check for
the used allocation scheme into the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk.h             |  4 +-
 block/genhd.c           | 96 ++++++++++++++++-------------------------
 block/partitions/core.c | 15 +++++--
 3 files changed, 49 insertions(+), 66 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index 8b3591aee0a5..cba3a94aabfa 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -343,8 +343,8 @@ static inline void blk_queue_free_zone_bitmaps(struct request_queue *q) {}
 static inline void blk_queue_clear_zone_settings(struct request_queue *q) {}
 #endif
 
-int blk_alloc_devt(struct block_device *part, dev_t *devt);
-void blk_free_devt(dev_t devt);
+int blk_alloc_ext_minor(void);
+void blk_free_ext_minor(unsigned int minor);
 char *disk_name(struct gendisk *hd, int partno, char *buf);
 #define ADDPART_FLAG_NONE	0
 #define ADDPART_FLAG_RAID	1
diff --git a/block/genhd.c b/block/genhd.c
index 39ca97b0edc6..2c00bc3261d9 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -335,52 +335,22 @@ static int blk_mangle_minor(int minor)
 	return minor;
 }
 
-/**
- * blk_alloc_devt - allocate a dev_t for a block device
- * @bdev: block device to allocate dev_t for
- * @devt: out parameter for resulting dev_t
- *
- * Allocate a dev_t for block device.
- *
- * RETURNS:
- * 0 on success, allocated dev_t is returned in *@devt.  -errno on
- * failure.
- *
- * CONTEXT:
- * Might sleep.
- */
-int blk_alloc_devt(struct block_device *bdev, dev_t *devt)
+int blk_alloc_ext_minor(void)
 {
-	struct gendisk *disk = bdev->bd_disk;
 	int idx;
 
-	/* in consecutive minor range? */
-	if (bdev->bd_partno < disk->minors) {
-		*devt = MKDEV(disk->major, disk->first_minor + bdev->bd_partno);
-		return 0;
-	}
-
 	idx = ida_alloc_range(&ext_devt_ida, 0, NR_EXT_DEVT, GFP_KERNEL);
-	if (idx < 0)
-		return idx == -ENOSPC ? -EBUSY : idx;
-
-	*devt = MKDEV(BLOCK_EXT_MAJOR, blk_mangle_minor(idx));
-	return 0;
+	if (idx < 0) {
+		if (idx == -ENOSPC)
+			return -EBUSY;
+		return idx;
+	}
+	return blk_mangle_minor(idx);
 }
 
-/**
- * blk_free_devt - free a dev_t
- * @devt: dev_t to free
- *
- * Free @devt which was allocated using blk_alloc_devt().
- *
- * CONTEXT:
- * Might sleep.
- */
-void blk_free_devt(dev_t devt)
+void blk_free_ext_minor(unsigned int minor)
 {
-	if (MAJOR(devt) == BLOCK_EXT_MAJOR)
-		ida_free(&ext_devt_ida, blk_mangle_minor(MINOR(devt)));
+	ida_free(&ext_devt_ida, blk_mangle_minor(minor));
 }
 
 static char *bdevt_str(dev_t devt, char *buf)
@@ -501,8 +471,7 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
 			      const struct attribute_group **groups,
 			      bool register_queue)
 {
-	dev_t devt;
-	int retval;
+	int ret;
 
 	/*
 	 * The disk queue should now be all set with enough information about
@@ -513,23 +482,29 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
 	if (register_queue)
 		elevator_init_mq(disk->queue);
 
-	/* minors == 0 indicates to use ext devt from part0 and should
-	 * be accompanied with EXT_DEVT flag.  Make sure all
-	 * parameters make sense.
+	/*
+	 * If the driver provides an explicit major number it also must provide
+	 * the number of minors numbers supported, and those will be used to
+	 * setup the gendisk.
+	 * Otherwise just allocate the device numbers for both the whole device
+	 * and all partitions from the extended dev_t space.
 	 */
-	WARN_ON(disk->minors && !(disk->major || disk->first_minor));
-	WARN_ON(!disk->minors &&
-		!(disk->flags & (GENHD_FL_EXT_DEVT | GENHD_FL_HIDDEN)));
-
-	disk->flags |= GENHD_FL_UP;
+	if (disk->major) {
+		WARN_ON(!disk->minors);
+	} else {
+		WARN_ON(disk->minors);
+		WARN_ON(!(disk->flags & (GENHD_FL_EXT_DEVT | GENHD_FL_HIDDEN)));
 
-	retval = blk_alloc_devt(disk->part0, &devt);
-	if (retval) {
-		WARN_ON(1);
-		return;
+		ret = blk_alloc_ext_minor();
+		if (ret < 0) {
+			WARN_ON(1);
+			return;
+		}
+		disk->major = BLOCK_EXT_MAJOR;
+		disk->first_minor = MINOR(ret);
 	}
-	disk->major = MAJOR(devt);
-	disk->first_minor = MINOR(devt);
+
+	disk->flags |= GENHD_FL_UP;
 
 	disk_alloc_events(disk);
 
@@ -543,14 +518,14 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
 	} else {
 		struct backing_dev_info *bdi = disk->queue->backing_dev_info;
 		struct device *dev = disk_to_dev(disk);
-		int ret;
 
 		/* Register BDI before referencing it from bdev */
-		dev->devt = devt;
-		ret = bdi_register(bdi, "%u:%u", MAJOR(devt), MINOR(devt));
+		dev->devt = MKDEV(disk->major, disk->first_minor);
+		ret = bdi_register(bdi, "%u:%u",
+				   disk->major, disk->first_minor);
 		WARN_ON(ret);
 		bdi_set_owner(bdi, dev);
-		bdev_add(disk->part0, devt);
+		bdev_add(disk->part0, dev->devt);
 	}
 	register_disk(parent, disk, groups);
 	if (register_queue)
@@ -1129,7 +1104,8 @@ static void disk_release(struct device *dev)
 
 	might_sleep();
 
-	blk_free_devt(dev->devt);
+	if (MAJOR(dev->devt) == BLOCK_EXT_MAJOR)
+		blk_free_ext_minor(MINOR(dev->devt));
 	disk_release_events(disk);
 	kfree(disk->random);
 	xa_destroy(&disk->part_tbl);
diff --git a/block/partitions/core.c b/block/partitions/core.c
index dc60ecf46fe6..504297bdc8bf 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -260,7 +260,8 @@ static const struct attribute_group *part_attr_groups[] = {
 
 static void part_release(struct device *dev)
 {
-	blk_free_devt(dev->devt);
+	if (MAJOR(dev->devt) == BLOCK_EXT_MAJOR)
+		blk_free_ext_minor(MINOR(dev->devt));
 	bdput(dev_to_bdev(dev));
 }
 
@@ -379,9 +380,15 @@ static struct block_device *add_partition(struct gendisk *disk, int partno,
 	pdev->type = &part_type;
 	pdev->parent = ddev;
 
-	err = blk_alloc_devt(bdev, &devt);
-	if (err)
-		goto out_put;
+	/* in consecutive minor range? */
+	if (bdev->bd_partno < disk->minors) {
+		devt = MKDEV(disk->major, disk->first_minor + bdev->bd_partno);
+	} else {
+		err = blk_alloc_ext_minor();
+		if (err < 0)
+			goto out_put;
+		devt = MKDEV(BLOCK_EXT_MAJOR, err);
+	}
 	pdev->devt = devt;
 
 	/* delay uevent until 'holders' subdir is created */
-- 
2.30.2

