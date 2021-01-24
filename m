Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97F1301B26
	for <lists+linux-bcache@lfdr.de>; Sun, 24 Jan 2021 11:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbhAXKHw (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 24 Jan 2021 05:07:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbhAXKHN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 24 Jan 2021 05:07:13 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B3EC061574;
        Sun, 24 Jan 2021 02:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=9I81iBrysDpKvLVPSP45uyF3rYOQKV1cSlXBdnJRdqg=; b=Q0FRErA6m/bdd+7uTO1gwxHq5F
        Jh7JehPNN3aVpT5wmXDXI7IaJJmgSK0butMYZeCOmwh5USNv2bMNcVYKr2PiiVmZsyt/6YVB6AgD6
        gkuGsC/hgNu3kjuA3GuJYyBgP7M20LUFC0FWJxaegWDjL5HQ9W7QpfUtFCs551NENA3hhbmYr2FOr
        22Vf48lRbu4KIyGEoir2u+VIkqb5qFYDm3o6X0uCk/FMqf/j+1WxWu8ch+dRFiWxgNIsSNTQoJo5p
        qEdLvnGw99gn4hQqq2z1G+yLAqDLBJmviNEcRV8nETfxI8vr7KfS950AIl9y21eE7KKd5tdjg+5zu
        toiMNlPw==;
Received: from [2001:4bb8:188:1954:a3b3:627f:702b:2136] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l3cHQ-002qAo-TX; Sun, 24 Jan 2021 10:06:03 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 10/10] block: use an xarray for disk->part_tbl
Date:   Sun, 24 Jan 2021 11:02:41 +0100
Message-Id: <20210124100241.1167849-11-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210124100241.1167849-1-hch@lst.de>
References: <20210124100241.1167849-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Now that no fast path lookups in the partition table are left, there is
no point in micro-optimizing the data structure for it.  Just use a bog
standard xarray.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/blk-settings.c    |   2 +-
 block/blk.h             |   1 -
 block/genhd.c           | 163 +++-------------------------------------
 block/partitions/core.c |  31 ++------
 include/linux/genhd.h   |  18 +----
 5 files changed, 22 insertions(+), 193 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 43990b1d148b87..4c974340f1a992 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -865,7 +865,7 @@ void blk_queue_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
 		 * we do nothing special as far as the block layer is concerned.
 		 */
 		if (!IS_ENABLED(CONFIG_BLK_DEV_ZONED) ||
-		    disk_has_partitions(disk))
+		    !xa_empty(&disk->part_tbl))
 			model = BLK_ZONED_NONE;
 		break;
 	case BLK_ZONED_NONE:
diff --git a/block/blk.h b/block/blk.h
index d965cacc5bdaa1..ab0aaf958553bc 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -345,7 +345,6 @@ int bdev_add_partition(struct block_device *bdev, int partno,
 int bdev_del_partition(struct block_device *bdev, int partno);
 int bdev_resize_partition(struct block_device *bdev, int partno,
 		sector_t start, sector_t length);
-int disk_expand_part_tbl(struct gendisk *disk, int target);
 
 int bio_add_hw_page(struct request_queue *q, struct bio *bio,
 		struct page *page, unsigned int len, unsigned int offset,
diff --git a/block/genhd.c b/block/genhd.c
index 1832add5c73849..d3ef29fbc53639 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -161,15 +161,6 @@ static void part_in_flight_rw(struct block_device *part,
 		inflight[1] = 0;
 }
 
-static struct block_device *__disk_get_part(struct gendisk *disk, int partno)
-{
-	struct disk_part_tbl *ptbl = rcu_dereference(disk->part_tbl);
-
-	if (unlikely(partno < 0 || partno >= ptbl->len))
-		return NULL;
-	return rcu_dereference(ptbl->part[partno]);
-}
-
 /**
  * disk_part_iter_init - initialize partition iterator
  * @piter: iterator to initialize
@@ -204,41 +195,26 @@ void disk_part_iter_init(struct disk_part_iter *piter, struct gendisk *disk,
  */
 struct block_device *disk_part_iter_next(struct disk_part_iter *piter)
 {
-	struct disk_part_tbl *ptbl;
+	struct block_device *part;
+	unsigned long idx;
 
 	/* put the last partition */
 	disk_part_iter_exit(piter);
 
-	/* get part_tbl */
 	rcu_read_lock();
-	ptbl = rcu_dereference(piter->disk->part_tbl);
-
-	/* iterate to the next partition */
-	for (; piter->idx != ptbl->len; piter->idx += 1) {
-		struct block_device *part;
-
-		part = rcu_dereference(ptbl->part[piter->idx]);
-		if (!part)
-			continue;
-		piter->part = bdgrab(part);
-		if (!piter->part)
-			continue;
+	xa_for_each_start(&piter->disk->part_tbl, idx, part, piter->idx) {
 		if (!bdev_nr_sectors(part) &&
 		    !(piter->flags & DISK_PITER_INCL_EMPTY) &&
 		    !(piter->flags & DISK_PITER_INCL_EMPTY_PART0 &&
-		      piter->idx == 0)) {
-			bdput(piter->part);
-			piter->part = NULL;
+		      piter->idx == 0))
 			continue;
-		}
 
 		piter->part = bdgrab(part);
 		if (!piter->part)
 			continue;
-		piter->idx += 1;
+		piter->idx = idx + 1;
 		break;
 	}
-
 	rcu_read_unlock();
 
 	return piter->part;
@@ -260,42 +236,6 @@ void disk_part_iter_exit(struct disk_part_iter *piter)
 	piter->part = NULL;
 }
 
-/**
- * disk_has_partitions
- * @disk: gendisk of interest
- *
- * Walk through the partition table and check if valid partition exists.
- *
- * CONTEXT:
- * Don't care.
- *
- * RETURNS:
- * True if the gendisk has at least one valid non-zero size partition.
- * Otherwise false.
- */
-bool disk_has_partitions(struct gendisk *disk)
-{
-	struct disk_part_tbl *ptbl;
-	int i;
-	bool ret = false;
-
-	rcu_read_lock();
-	ptbl = rcu_dereference(disk->part_tbl);
-
-	/* Iterate partitions skipping the whole device at index 0 */
-	for (i = 1; i < ptbl->len; i++) {
-		if (rcu_dereference(ptbl->part[i])) {
-			ret = true;
-			break;
-		}
-	}
-
-	rcu_read_unlock();
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(disk_has_partitions);
-
 /*
  * Can be deleted altogether. Later.
  *
@@ -858,7 +798,7 @@ struct block_device *bdget_disk(struct gendisk *disk, int partno)
 	struct block_device *bdev = NULL;
 
 	rcu_read_lock();
-	bdev = __disk_get_part(disk, partno);
+	bdev = xa_load(&disk->part_tbl, partno);
 	if (bdev && !bdgrab(bdev))
 		bdev = NULL;
 	rcu_read_unlock();
@@ -1248,83 +1188,6 @@ static const struct attribute_group *disk_attr_groups[] = {
 	NULL
 };
 
-/**
- * disk_replace_part_tbl - replace disk->part_tbl in RCU-safe way
- * @disk: disk to replace part_tbl for
- * @new_ptbl: new part_tbl to install
- *
- * Replace disk->part_tbl with @new_ptbl in RCU-safe way.  The
- * original ptbl is freed using RCU callback.
- *
- * LOCKING:
- * Matching bd_mutex locked or the caller is the only user of @disk.
- */
-static void disk_replace_part_tbl(struct gendisk *disk,
-				  struct disk_part_tbl *new_ptbl)
-{
-	struct disk_part_tbl *old_ptbl =
-		rcu_dereference_protected(disk->part_tbl, 1);
-
-	rcu_assign_pointer(disk->part_tbl, new_ptbl);
-
-	if (old_ptbl) {
-		rcu_assign_pointer(old_ptbl->last_lookup, NULL);
-		kfree_rcu(old_ptbl, rcu_head);
-	}
-}
-
-/**
- * disk_expand_part_tbl - expand disk->part_tbl
- * @disk: disk to expand part_tbl for
- * @partno: expand such that this partno can fit in
- *
- * Expand disk->part_tbl such that @partno can fit in.  disk->part_tbl
- * uses RCU to allow unlocked dereferencing for stats and other stuff.
- *
- * LOCKING:
- * Matching bd_mutex locked or the caller is the only user of @disk.
- * Might sleep.
- *
- * RETURNS:
- * 0 on success, -errno on failure.
- */
-int disk_expand_part_tbl(struct gendisk *disk, int partno)
-{
-	struct disk_part_tbl *old_ptbl =
-		rcu_dereference_protected(disk->part_tbl, 1);
-	struct disk_part_tbl *new_ptbl;
-	int len = old_ptbl ? old_ptbl->len : 0;
-	int i, target;
-
-	/*
-	 * check for int overflow, since we can get here from blkpg_ioctl()
-	 * with a user passed 'partno'.
-	 */
-	target = partno + 1;
-	if (target < 0)
-		return -EINVAL;
-
-	/* disk_max_parts() is zero during initialization, ignore if so */
-	if (disk_max_parts(disk) && target > disk_max_parts(disk))
-		return -EINVAL;
-
-	if (target <= len)
-		return 0;
-
-	new_ptbl = kzalloc_node(struct_size(new_ptbl, part, target), GFP_KERNEL,
-				disk->node_id);
-	if (!new_ptbl)
-		return -ENOMEM;
-
-	new_ptbl->len = target;
-
-	for (i = 0; i < len; i++)
-		rcu_assign_pointer(new_ptbl->part[i], old_ptbl->part[i]);
-
-	disk_replace_part_tbl(disk, new_ptbl);
-	return 0;
-}
-
 /**
  * disk_release - releases all allocated resources of the gendisk
  * @dev: the device representing this disk
@@ -1348,7 +1211,7 @@ static void disk_release(struct device *dev)
 	blk_free_devt(dev->devt);
 	disk_release_events(disk);
 	kfree(disk->random);
-	disk_replace_part_tbl(disk, NULL);
+	xa_destroy(&disk->part_tbl);
 	bdput(disk->part0);
 	if (disk->queue)
 		blk_put_queue(disk->queue);
@@ -1501,7 +1364,6 @@ dev_t blk_lookup_devt(const char *name, int partno)
 struct gendisk *__alloc_disk_node(int minors, int node_id)
 {
 	struct gendisk *disk;
-	struct disk_part_tbl *ptbl;
 
 	if (minors > DISK_MAX_PARTS) {
 		printk(KERN_ERR
@@ -1519,11 +1381,9 @@ struct gendisk *__alloc_disk_node(int minors, int node_id)
 		goto out_free_disk;
 
 	disk->node_id = node_id;
-	if (disk_expand_part_tbl(disk, 0))
-		goto out_bdput;
-
-	ptbl = rcu_dereference_protected(disk->part_tbl, 1);
-	rcu_assign_pointer(ptbl->part[0], disk->part0);
+	xa_init(&disk->part_tbl);
+	if (xa_insert(&disk->part_tbl, 0, disk->part0, GFP_KERNEL))
+		goto out_destroy_part_tbl;
 
 	disk->minors = minors;
 	rand_initialize_disk(disk);
@@ -1532,7 +1392,8 @@ struct gendisk *__alloc_disk_node(int minors, int node_id)
 	device_initialize(disk_to_dev(disk));
 	return disk;
 
-out_bdput:
+out_destroy_part_tbl:
+	xa_destroy(&disk->part_tbl);
 	bdput(disk->part0);
 out_free_disk:
 	kfree(disk);
diff --git a/block/partitions/core.c b/block/partitions/core.c
index 168d5906077cfd..b1cdf88f96e236 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -287,13 +287,7 @@ struct device_type part_type = {
  */
 void delete_partition(struct block_device *part)
 {
-	struct gendisk *disk = part->bd_disk;
-	struct disk_part_tbl *ptbl =
-		rcu_dereference_protected(disk->part_tbl, 1);
-
-	rcu_assign_pointer(ptbl->part[part->bd_partno], NULL);
-	rcu_assign_pointer(ptbl->last_lookup, NULL);
-
+	xa_erase(&part->bd_disk->part_tbl, part->bd_partno);
 	kobject_put(part->bd_holder_dir);
 	device_del(&part->bd_device);
 
@@ -325,7 +319,6 @@ static struct block_device *add_partition(struct gendisk *disk, int partno,
 	struct device *ddev = disk_to_dev(disk);
 	struct device *pdev;
 	struct block_device *bdev;
-	struct disk_part_tbl *ptbl;
 	const char *dname;
 	int err;
 
@@ -347,12 +340,7 @@ static struct block_device *add_partition(struct gendisk *disk, int partno,
 		break;
 	}
 
-	err = disk_expand_part_tbl(disk, partno);
-	if (err)
-		return ERR_PTR(err);
-	ptbl = rcu_dereference_protected(disk->part_tbl, 1);
-
-	if (ptbl->part[partno])
+	if (xa_load(&disk->part_tbl, partno))
 		return ERR_PTR(-EBUSY);
 
 	bdev = bdev_alloc(disk, partno);
@@ -405,8 +393,10 @@ static struct block_device *add_partition(struct gendisk *disk, int partno,
 	}
 
 	/* everything is up and running, commence */
+	err = xa_insert(&disk->part_tbl, partno, bdev, GFP_KERNEL);
+	if (err)
+		goto out_del;
 	bdev_add(bdev, devt);
-	rcu_assign_pointer(ptbl->part[partno], bdev);
 
 	/* suppress uevent if the disk suppresses it */
 	if (!dev_get_uevent_suppress(ddev))
@@ -612,7 +602,7 @@ static bool blk_add_partition(struct gendisk *disk, struct block_device *bdev,
 int blk_add_partitions(struct gendisk *disk, struct block_device *bdev)
 {
 	struct parsed_partitions *state;
-	int ret = -EAGAIN, p, highest;
+	int ret = -EAGAIN, p;
 
 	if (!disk_part_scan_enabled(disk))
 		return 0;
@@ -660,15 +650,6 @@ int blk_add_partitions(struct gendisk *disk, struct block_device *bdev)
 	/* tell userspace that the media / partition table may have changed */
 	kobject_uevent(&disk_to_dev(disk)->kobj, KOBJ_CHANGE);
 
-	/*
-	 * Detect the highest partition number and preallocate disk->part_tbl.
-	 * This is an optimization and not strictly necessary.
-	 */
-	for (p = 1, highest = 0; p < state->limit; p++)
-		if (state->parts[p].size)
-			highest = p;
-	disk_expand_part_tbl(disk, highest);
-
 	for (p = 1; p < state->limit; p++)
 		if (!blk_add_partition(disk, bdev, state, p))
 			goto out_free_state;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 51609133c9a347..f364619092cca0 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -32,6 +32,7 @@ extern struct class block_class;
 #include <linux/string.h>
 #include <linux/fs.h>
 #include <linux/workqueue.h>
+#include <linux/xarray.h>
 
 #define PARTITION_META_INFO_VOLNAMELTH	64
 /*
@@ -116,13 +117,6 @@ enum {
 	DISK_EVENT_FLAG_UEVENT			= 1 << 1,
 };
 
-struct disk_part_tbl {
-	struct rcu_head rcu_head;
-	int len;
-	struct block_device __rcu *last_lookup;
-	struct block_device __rcu *part[];
-};
-
 struct disk_events;
 struct badblocks;
 
@@ -148,12 +142,7 @@ struct gendisk {
 	unsigned short events;		/* supported events */
 	unsigned short event_flags;	/* flags related to event processing */
 
-	/* Array of pointers to partitions indexed by partno.
-	 * Protected with matching bdev lock but stat and other
-	 * non-critical accesses use RCU.  Always access through
-	 * helpers.
-	 */
-	struct disk_part_tbl __rcu *part_tbl;
+	struct xarray part_tbl;
 	struct block_device *part0;
 
 	const struct block_device_operations *fops;
@@ -225,7 +214,7 @@ void disk_uevent(struct gendisk *disk, enum kobject_action action);
 struct disk_part_iter {
 	struct gendisk		*disk;
 	struct block_device	*part;
-	int			idx;
+	unsigned long		idx;
 	unsigned int		flags;
 };
 
@@ -233,7 +222,6 @@ extern void disk_part_iter_init(struct disk_part_iter *piter,
 				 struct gendisk *disk, unsigned int flags);
 struct block_device *disk_part_iter_next(struct disk_part_iter *piter);
 extern void disk_part_iter_exit(struct disk_part_iter *piter);
-extern bool disk_has_partitions(struct gendisk *disk);
 
 /* block/genhd.c */
 extern void device_add_disk(struct device *parent, struct gendisk *disk,
-- 
2.29.2

