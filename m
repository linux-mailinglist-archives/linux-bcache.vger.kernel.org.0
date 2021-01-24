Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8301301B21
	for <lists+linux-bcache@lfdr.de>; Sun, 24 Jan 2021 11:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbhAXKHd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 24 Jan 2021 05:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbhAXKGu (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 24 Jan 2021 05:06:50 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC0FC06178A;
        Sun, 24 Jan 2021 02:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=9dvHhrrno1DX55m574Oz4o3Hcha8MLLAL2ubC+yKuJ4=; b=PWPcZ0yPsTcGtoe0lFSHoF+YWQ
        XojI6QaEJk1cpNtrN661jXr42nmqh83efiIVhP0o/PF9e0fbd8151qw59YHqB95YU6oNEUnsmfkGD
        HAMJfyJpfPwY8TRCe4mk4rQxHSwMsWleX4bBqJqP6C09Cmbt7VHWDZHLNAXmPacpKCLyAaPKV/3TQ
        AL0ae4WRbeNzllRAs4+u7EPw0jYbfJjaDkp0zH/8+CfyL9ExYIJl+d1SnZdMelnWOktIj8O6oQQxa
        9Ou2ITda+N3mAhMi/rkM7n1hoQqMW7RxrcqklOpp9TI8zSQvbc/b8LODT49rI1YrKnr4ndP3gEDsR
        VLX2HQtg==;
Received: from [2001:4bb8:188:1954:a3b3:627f:702b:2136] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l3cHI-002qAG-D5; Sun, 24 Jan 2021 10:05:53 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 08/10] block: add a disk_uevent helper
Date:   Sun, 24 Jan 2021 11:02:39 +0100
Message-Id: <20210124100241.1167849-9-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210124100241.1167849-1-hch@lst.de>
References: <20210124100241.1167849-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Add a helper to call kobject_uevent for the disk and all partitions, and
unexport the disk_part_iter_* helpers that are now only used in the core
block code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/genhd.c             | 27 ++++++++++++++-------------
 drivers/s390/block/dasd.c | 26 +++++---------------------
 include/linux/genhd.h     |  2 ++
 3 files changed, 21 insertions(+), 34 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index e46de616a19e59..7094612c7510a8 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -203,7 +203,6 @@ void disk_part_iter_init(struct disk_part_iter *piter, struct gendisk *disk,
 
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL_GPL(disk_part_iter_init);
 
 /**
  * disk_part_iter_next - proceed iterator to the next partition and return it
@@ -266,7 +265,6 @@ struct block_device *disk_part_iter_next(struct disk_part_iter *piter)
 
 	return piter->part;
 }
-EXPORT_SYMBOL_GPL(disk_part_iter_next);
 
 /**
  * disk_part_iter_exit - finish up partition iteration
@@ -283,7 +281,6 @@ void disk_part_iter_exit(struct disk_part_iter *piter)
 		bdput(piter->part);
 	piter->part = NULL;
 }
-EXPORT_SYMBOL_GPL(disk_part_iter_exit);
 
 /**
  * disk_has_partitions
@@ -555,6 +552,18 @@ static char *bdevt_str(dev_t devt, char *buf)
 	return buf;
 }
 
+void disk_uevent(struct gendisk *disk, enum kobject_action action)
+{
+	struct disk_part_iter piter;
+	struct block_device *part;
+
+	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_PART0);
+	while ((part = disk_part_iter_next(&piter)))
+		kobject_uevent(bdev_kobj(part), action);
+	disk_part_iter_exit(&piter);
+}
+EXPORT_SYMBOL_GPL(disk_uevent);
+
 static void disk_scan_partitions(struct gendisk *disk)
 {
 	struct block_device *bdev;
@@ -572,8 +581,6 @@ static void register_disk(struct device *parent, struct gendisk *disk,
 			  const struct attribute_group **groups)
 {
 	struct device *ddev = disk_to_dev(disk);
-	struct disk_part_iter piter;
-	struct block_device *part;
 	int err;
 
 	ddev->parent = parent;
@@ -616,15 +623,9 @@ static void register_disk(struct device *parent, struct gendisk *disk,
 
 	disk_scan_partitions(disk);
 
-	/* announce disk after possible partitions are created */
+	/* announce the disk and partitions after all partitions are created */
 	dev_set_uevent_suppress(ddev, 0);
-	kobject_uevent(&ddev->kobj, KOBJ_ADD);
-
-	/* announce possible partitions */
-	disk_part_iter_init(&piter, disk, 0);
-	while ((part = disk_part_iter_next(&piter)))
-		kobject_uevent(bdev_kobj(part), KOBJ_ADD);
-	disk_part_iter_exit(&piter);
+	disk_uevent(disk, KOBJ_ADD);
 
 	if (disk->queue->backing_dev_info->dev) {
 		err = sysfs_create_link(&ddev->kobj,
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index c7eb9a10c680d2..28c04a4efa66f2 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -428,23 +428,15 @@ static int dasd_state_unfmt_to_basic(struct dasd_device *device)
 static int
 dasd_state_ready_to_online(struct dasd_device * device)
 {
-	struct gendisk *disk;
-	struct disk_part_iter piter;
-	struct block_device *part;
-
 	device->state = DASD_STATE_ONLINE;
 	if (device->block) {
 		dasd_schedule_block_bh(device->block);
 		if ((device->features & DASD_FEATURE_USERAW)) {
-			disk = device->block->gdp;
-			kobject_uevent(&disk_to_dev(disk)->kobj, KOBJ_CHANGE);
+			kobject_uevent(&disk_to_dev(device->block->gdp)->kobj,
+					KOBJ_CHANGE);
 			return 0;
 		}
-		disk = device->block->bdev->bd_disk;
-		disk_part_iter_init(&piter, disk, DISK_PITER_INCL_PART0);
-		while ((part = disk_part_iter_next(&piter)))
-			kobject_uevent(bdev_kobj(part), KOBJ_CHANGE);
-		disk_part_iter_exit(&piter);
+		disk_uevent(device->block->bdev->bd_disk, KOBJ_CHANGE);
 	}
 	return 0;
 }
@@ -455,9 +447,6 @@ dasd_state_ready_to_online(struct dasd_device * device)
 static int dasd_state_online_to_ready(struct dasd_device *device)
 {
 	int rc;
-	struct gendisk *disk;
-	struct disk_part_iter piter;
-	struct block_device *part;
 
 	if (device->discipline->online_to_ready) {
 		rc = device->discipline->online_to_ready(device);
@@ -466,13 +455,8 @@ static int dasd_state_online_to_ready(struct dasd_device *device)
 	}
 
 	device->state = DASD_STATE_READY;
-	if (device->block && !(device->features & DASD_FEATURE_USERAW)) {
-		disk = device->block->bdev->bd_disk;
-		disk_part_iter_init(&piter, disk, DISK_PITER_INCL_PART0);
-		while ((part = disk_part_iter_next(&piter)))
-			kobject_uevent(bdev_kobj(part), KOBJ_CHANGE);
-		disk_part_iter_exit(&piter);
-	}
+	if (device->block && !(device->features & DASD_FEATURE_USERAW))
+		disk_uevent(device->block->bdev->bd_disk, KOBJ_CHANGE);
 	return 0;
 }
 
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index a62ccbfac54b48..670eaef0e87622 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -213,6 +213,8 @@ static inline dev_t disk_devt(struct gendisk *disk)
 	return MKDEV(disk->major, disk->first_minor);
 }
 
+void disk_uevent(struct gendisk *disk, enum kobject_action action);
+
 /*
  * Smarter partition iterator without context limits.
  */
-- 
2.29.2

