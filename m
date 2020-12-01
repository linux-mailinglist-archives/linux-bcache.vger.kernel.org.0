Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58DA02CA8F8
	for <lists+linux-bcache@lfdr.de>; Tue,  1 Dec 2020 17:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391017AbgLAQzx (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 1 Dec 2020 11:55:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389890AbgLAQzw (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 1 Dec 2020 11:55:52 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21893C061A49;
        Tue,  1 Dec 2020 08:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=z3TR4SOfklo1NSy0jtxTf0pSxLrXpFRU8wpKn7XHbfk=; b=mGO3VelM/ewo5WYpjtgCX3bjfv
        8vnom8zhT/A/o7byWs7Ix1KsjQe+Z6nigJ/guo0w6qBpswJ3B5lMYjz5IpyR/bXrrch3QdlA8QP/B
        K8HcIkiqnS1q4H/YZ+r3oxt36iYFJm3A8rz3T8CNLLqAULpXzhLDA0m3GyZgxm0KuHhUdSihDJdnV
        iHvjw1818nstRL0Qkm4pzvGObVp7A18JkXI/13PGWM940BAqrO2tbFn4Y/NMTo7GMaHNUgfXlWMT2
        LEkVb55C1Y5EVxByfD/4kiFZa4rw9dAiUUGbZ4HfTVqV+NfqfvEn29eCozsElsD0yGLJPvVIxt/wX
        F4Sk4fJg==;
Received: from [2001:4bb8:184:6389:bbd8:a1c2:99e0:f58a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kk8vC-0005Zm-Ud; Tue, 01 Dec 2020 16:54:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 7/9] block: add a disk_uevent helper
Date:   Tue,  1 Dec 2020 17:54:22 +0100
Message-Id: <20201201165424.2030647-8-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201165424.2030647-1-hch@lst.de>
References: <20201201165424.2030647-1-hch@lst.de>
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
---
 block/genhd.c             | 27 ++++++++++++++-------------
 drivers/s390/block/dasd.c | 26 +++++---------------------
 include/linux/genhd.h     |  2 ++
 3 files changed, 21 insertions(+), 34 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 3b9cd766d95228..65dba32df5474f 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -201,7 +201,6 @@ void disk_part_iter_init(struct disk_part_iter *piter, struct gendisk *disk,
 
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL_GPL(disk_part_iter_init);
 
 /**
  * disk_part_iter_next - proceed iterator to the next partition and return it
@@ -261,7 +260,6 @@ struct block_device *disk_part_iter_next(struct disk_part_iter *piter)
 
 	return piter->part;
 }
-EXPORT_SYMBOL_GPL(disk_part_iter_next);
 
 /**
  * disk_part_iter_exit - finish up partition iteration
@@ -278,7 +276,6 @@ void disk_part_iter_exit(struct disk_part_iter *piter)
 		bdput(piter->part);
 	piter->part = NULL;
 }
-EXPORT_SYMBOL_GPL(disk_part_iter_exit);
 
 /**
  * disk_has_partitions
@@ -550,6 +547,18 @@ static char *bdevt_str(dev_t devt, char *buf)
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
@@ -567,8 +576,6 @@ static void register_disk(struct device *parent, struct gendisk *disk,
 			  const struct attribute_group **groups)
 {
 	struct device *ddev = disk_to_dev(disk);
-	struct disk_part_iter piter;
-	struct block_device *part;
 	int err;
 
 	ddev->parent = parent;
@@ -611,15 +618,9 @@ static void register_disk(struct device *parent, struct gendisk *disk,
 
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
index 1825fa8d05a780..bb0c63fbdabc01 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -430,23 +430,15 @@ static int dasd_state_unfmt_to_basic(struct dasd_device *device)
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
@@ -457,9 +449,6 @@ dasd_state_ready_to_online(struct dasd_device * device)
 static int dasd_state_online_to_ready(struct dasd_device *device)
 {
 	int rc;
-	struct gendisk *disk;
-	struct disk_part_iter piter;
-	struct block_device *part;
 
 	if (device->discipline->online_to_ready) {
 		rc = device->discipline->online_to_ready(device);
@@ -468,13 +457,8 @@ static int dasd_state_online_to_ready(struct dasd_device *device)
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
index 809aaa32d53cba..191f5e4ae4e93b 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -212,6 +212,8 @@ static inline dev_t disk_devt(struct gendisk *disk)
 	return MKDEV(disk->major, disk->first_minor);
 }
 
+void disk_uevent(struct gendisk *disk, enum kobject_action action);
+
 /*
  * Smarter partition iterator without context limits.
  */
-- 
2.29.2

