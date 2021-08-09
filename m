Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C043E407B
	for <lists+linux-bcache@lfdr.de>; Mon,  9 Aug 2021 08:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbhHIGuP (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 9 Aug 2021 02:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233267AbhHIGuP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Aug 2021 02:50:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB69C0613CF;
        Sun,  8 Aug 2021 23:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=K2Uv5ue006I47lu2IjgV56o9UA3rTDZwUcup9SB25L4=; b=bJQHL3JhvOvIxfkQZMTpV7hYpq
        Grk9Z1xhJ9w5VWJKwcyvoUaTM69dIAqHEJ+BK7Wb0p9LfpsqI7erQbkX2hPSRWHGUdhpYSDwnHqJk
        yCqXDUTbJEPuC43nPVsKPmJ7+MEjQgmHW31YP38WuxXposcZl52+csW9QqErysbxgD1txY4bewrOx
        9l6/QA/e2FVfN5TOTUdxAD1MDAHv7XeOGak6r+0pr22Y/j8sLcUnhYUoapWRZbpfSAAbYmIxya+MV
        lEk6IdN+JdvtsbIXGNvtij+tsbqzEoR4wmw4YmQiaMTpg1RDn1UrUexEweJj3owqltZLkhKRqPs5l
        xGqD4wAw==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mCz50-00Aj2V-Co; Mon, 09 Aug 2021 06:48:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Coly Li <colyli@suse.de>, Song Liu <song@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: [PATCH 8/8] block: remove GENHD_FL_UP
Date:   Mon,  9 Aug 2021 08:40:28 +0200
Message-Id: <20210809064028.1198327-9-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210809064028.1198327-1-hch@lst.de>
References: <20210809064028.1198327-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Just check inode_unhashed on the whole device bdev inode instead,
and provide a helper to check for that information.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c            | 6 ++----
 block/partitions/core.c  | 4 ++--
 drivers/md/md.h          | 4 +---
 drivers/nvme/host/core.c | 2 +-
 fs/block_dev.c           | 2 +-
 include/linux/genhd.h    | 9 +++++----
 6 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index a4817e42f3a3..9021c8ce3869 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -77,7 +77,8 @@ bool set_capacity_and_notify(struct gendisk *disk, sector_t size)
 	 * initial capacity during probing.
 	 */
 	if (size == capacity ||
-	    (disk->flags & (GENHD_FL_UP | GENHD_FL_HIDDEN)) != GENHD_FL_UP)
+	    !disk_live(disk) ||
+	    (disk->flags & GENHD_FL_HIDDEN))
 		return false;
 
 	pr_info("%s: detected capacity change from %lld to %lld\n",
@@ -519,8 +520,6 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
 		disk->flags |= GENHD_FL_EXT_DEVT;
 	}
 
-	disk->flags |= GENHD_FL_UP;
-
 	disk_alloc_events(disk);
 
 	if (disk->flags & GENHD_FL_HIDDEN) {
@@ -604,7 +603,6 @@ void del_gendisk(struct gendisk *disk)
 
 	mutex_lock(&disk->open_mutex);
 	remove_inode_hash(disk->part0->bd_inode);
-	disk->flags &= ~GENHD_FL_UP;
 	blk_drop_partitions(disk);
 	mutex_unlock(&disk->open_mutex);
 
diff --git a/block/partitions/core.c b/block/partitions/core.c
index fb3a556cacce..c6738ccbcee5 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -459,7 +459,7 @@ int bdev_add_partition(struct block_device *bdev, int partno,
 	int ret;
 
 	mutex_lock(&disk->open_mutex);
-	if (!(disk->flags & GENHD_FL_UP)) {
+	if (!disk_live(disk)) {
 		ret = -ENXIO;
 		goto out;
 	}
@@ -669,7 +669,7 @@ int bdev_disk_changed(struct gendisk *disk, bool invalidate)
 
 	lockdep_assert_held(&disk->open_mutex);
 
-	if (!(disk->flags & GENHD_FL_UP))
+	if (!disk_live(disk))
 		return -ENXIO;
 
 rescan:
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 832547cf038f..4c96c36bd01a 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -764,9 +764,7 @@ struct md_rdev *md_find_rdev_rcu(struct mddev *mddev, dev_t dev);
 
 static inline bool is_mddev_broken(struct md_rdev *rdev, const char *md_type)
 {
-	int flags = rdev->bdev->bd_disk->flags;
-
-	if (!(flags & GENHD_FL_UP)) {
+	if (!disk_live(rdev->bdev->bd_disk)) {
 		if (!test_and_set_bit(MD_BROKEN, &rdev->mddev->flags))
 			pr_warn("md: %s: %s array has a missing/failed member\n",
 				mdname(rdev->mddev), md_type);
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index e24a0143fd87..cb12d8b94e82 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1822,7 +1822,7 @@ static void nvme_update_disk_info(struct gendisk *disk,
 static inline bool nvme_first_scan(struct gendisk *disk)
 {
 	/* nvme_alloc_ns() scans the disk prior to adding it */
-	return !(disk->flags & GENHD_FL_UP);
+	return !disk_live(disk);
 }
 
 static void nvme_set_chunk_sectors(struct nvme_ns *ns, struct nvme_id_ns *id)
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 6658f40ae492..ab50428b328b 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1374,7 +1374,7 @@ struct block_device *blkdev_get_by_dev(dev_t dev, fmode_t mode, void *holder)
 
 	mutex_lock(&disk->open_mutex);
 	ret = -ENXIO;
-	if (!(disk->flags & GENHD_FL_UP))
+	if (!disk_live(disk))
 		goto abort_claiming;
 	if (bdev_is_partition(bdev))
 		ret = blkdev_get_part(bdev, mode);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 849486de81c6..ddd02def1ed4 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -60,9 +60,6 @@ struct partition_meta_info {
  * device.
  * Affects responses to the ``CDROM_GET_CAPABILITY`` ioctl.
  *
- * ``GENHD_FL_UP`` (0x0010): indicates that the block device is "up",
- * with a similar meaning to network interfaces.
- *
  * ``GENHD_FL_SUPPRESS_PARTITION_INFO`` (0x0020): don't include
  * partition information in ``/proc/partitions`` or in the output of
  * printk_all_partitions().
@@ -97,7 +94,6 @@ struct partition_meta_info {
 /* 2 is unused (used to be GENHD_FL_DRIVERFS) */
 /* 4 is unused (used to be GENHD_FL_MEDIA_CHANGE_NOTIFY) */
 #define GENHD_FL_CD				0x0008
-#define GENHD_FL_UP				0x0010
 #define GENHD_FL_SUPPRESS_PARTITION_INFO	0x0020
 #define GENHD_FL_EXT_DEVT			0x0040
 #define GENHD_FL_NATIVE_CAPACITY		0x0080
@@ -175,6 +171,11 @@ struct gendisk {
 	u64 diskseq;
 };
 
+static inline bool disk_live(struct gendisk *disk)
+{
+	return !inode_unhashed(disk->part0->bd_inode);
+}
+
 /*
  * The gendisk is refcounted by the part0 block_device, and the bd_device
  * therein is also used for device model presentation in sysfs.
-- 
2.30.2

