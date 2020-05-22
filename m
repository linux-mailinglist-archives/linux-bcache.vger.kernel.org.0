Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0969A1DE6A6
	for <lists+linux-bcache@lfdr.de>; Fri, 22 May 2020 14:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729847AbgEVMSw (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 22 May 2020 08:18:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:52390 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728772AbgEVMSv (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 22 May 2020 08:18:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2F168AF01;
        Fri, 22 May 2020 12:18:52 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [RFC PATCH v4 1/3] bcache: export bcache zone information for zoned backing device
Date:   Fri, 22 May 2020 20:18:35 +0800
Message-Id: <20200522121837.109651-2-colyli@suse.de>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200522121837.109651-1-colyli@suse.de>
References: <20200522121837.109651-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

When using a zoned device e.g. SMR hard drive as the backing device,
if bcache can export the zoned device information then it is possible
to help the upper layer code to accelerate hot READ I/O requests.

This patch adds the report_zones method for the bcache device which has
zoned device as backing device. Now such bcache device can be treated as
a zoned device, by configured to writethrough, writearound mode or none
mode, zonefs can be formated on top of such bcache device.

Here is a simple performance data for read requests via zonefs on top of
bcache. The cache device of bcache is a 4TB NVMe SSD, the backing device
is a 14TB host managed SMR hard drive. The formatted zonefs has 52155
zone files, 523 of them are for convential zones (1 zone is reserved
for bcache super block and not reported), 51632 of them are for
sequential zones.

First run to read first 4KB from all the zone files with 50 processes,
it takes 5 minutes 55 seconds. Second run takes 12 seconds only because
all the read requests hit on cache device.

29 times faster is as expected for an ideal case when all READ I/Os hit
on NVMe cache device.

Besides providing report_zones method of the bcache gendisk structure,
this patch also initializes the following zoned device attribution for
the bcache device,
- zones number: the total zones number minus reserved zone(s) for bcache
  super block.
- zone size: same size as reported from the underlying zoned device
- zone mode: same mode as reported from the underlying zoned device
Currently blk_revalidate_disk_zones() does not accept non-mq drivers, so
all the above attribution are initialized mannally in bcache code.

This patch just provides the report_zones method only. Handling all zone
management commands will be addressed in following patches.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
Changelog:
v4: the version without any generic block layer change.
v3: the version depends on other generic block layer changes.
v2: an improved version for comments.
v1: initial version.
 drivers/md/bcache/bcache.h  | 10 ++++
 drivers/md/bcache/request.c | 69 ++++++++++++++++++++++++++
 drivers/md/bcache/super.c   | 96 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 174 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 74a9849ea164..0d298b48707f 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -221,6 +221,7 @@ BITMASK(GC_MOVE, struct bucket, gc_mark, 15, 1);
 struct search;
 struct btree;
 struct keybuf;
+struct bch_report_zones_args;
 
 struct keybuf_key {
 	struct rb_node		node;
@@ -277,6 +278,8 @@ struct bcache_device {
 			  struct bio *bio, unsigned int sectors);
 	int (*ioctl)(struct bcache_device *d, fmode_t mode,
 		     unsigned int cmd, unsigned long arg);
+	int (*report_zones)(struct bch_report_zones_args *args,
+			    unsigned int nr_zones);
 };
 
 struct io {
@@ -748,6 +751,13 @@ struct bbio {
 	struct bio		bio;
 };
 
+struct bch_report_zones_args {
+	struct bcache_device *bcache_device;
+	sector_t sector;
+	void *orig_data;
+	report_zones_cb orig_cb;
+};
+
 #define BTREE_PRIO		USHRT_MAX
 #define INITIAL_PRIO		32768U
 
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 71a90fbec314..34f63da2338d 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1233,6 +1233,30 @@ static int cached_dev_ioctl(struct bcache_device *d, fmode_t mode,
 	if (dc->io_disable)
 		return -EIO;
 
+	/*
+	 * All zoned device ioctl commands are handled in
+	 * other code paths,
+	 * - BLKREPORTZONE: by report_zones method of bcache_ops.
+	 * - BLKRESETZONE/BLKOPENZONE/BLKCLOSEZONE/BLKFINISHZONE: all handled
+	 *   by bio code path.
+	 * - BLKGETZONESZ/BLKGETNRZONES:directly handled inside generic block
+	 *   ioctl handler blkdev_common_ioctl().
+	 */
+	switch (cmd) {
+	case BLKREPORTZONE:
+	case BLKRESETZONE:
+	case BLKGETZONESZ:
+	case BLKGETNRZONES:
+	case BLKOPENZONE:
+	case BLKCLOSEZONE:
+	case BLKFINISHZONE:
+		pr_warn("Zoned device ioctl cmd should not be here.\n");
+		return -EOPNOTSUPP;
+	default:
+		/* Other commands  */
+		break;
+	}
+
 	return __blkdev_driver_ioctl(dc->bdev, mode, cmd, arg);
 }
 
@@ -1261,6 +1285,50 @@ static int cached_dev_congested(void *data, int bits)
 	return ret;
 }
 
+/*
+ * The callback routine to parse a specific zone from all reporting
+ * zones. args->orig_cb() is the upper layer report zones callback,
+ * which should be called after the LBA conversion.
+ * Notice: all zones after zone 0 will be reported, including the
+ * offlined zones, how to handle the different types of zones are
+ * fully decided by upper layer who calss for reporting zones of
+ * the bcache device.
+ */
+static int cached_dev_report_zones_cb(struct blk_zone *zone,
+				      unsigned int idx,
+				      void *data)
+{
+	struct bch_report_zones_args *args = data;
+	struct bcache_device *d = args->bcache_device;
+	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
+	unsigned long data_offset = dc->sb.data_offset;
+
+	/* Zone 0 should not be reported */
+	BUG_ON(zone->start < data_offset);
+
+	/* convert back to LBA of the bcache device*/
+	zone->start -= data_offset;
+	zone->wp -= data_offset;
+
+	return args->orig_cb(zone, idx, args->orig_data);
+}
+
+static int cached_dev_report_zones(struct bch_report_zones_args *args,
+				   unsigned int nr_zones)
+{
+	struct bcache_device *d = args->bcache_device;
+	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
+	/* skip zone 0 which is fully occupied by bcache super block */
+	sector_t sector = args->sector + dc->sb.data_offset;
+
+	/* sector is real LBA of backing device */
+	return blkdev_report_zones(dc->bdev,
+				   sector,
+				   nr_zones,
+				   cached_dev_report_zones_cb,
+				   args);
+}
+
 void bch_cached_dev_request_init(struct cached_dev *dc)
 {
 	struct gendisk *g = dc->disk.disk;
@@ -1268,6 +1336,7 @@ void bch_cached_dev_request_init(struct cached_dev *dc)
 	g->queue->backing_dev_info->congested_fn = cached_dev_congested;
 	dc->disk.cache_miss			= cached_dev_cache_miss;
 	dc->disk.ioctl				= cached_dev_ioctl;
+	dc->disk.report_zones			= cached_dev_report_zones;
 }
 
 /* Flash backed devices */
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index d98354fa28e3..d5da7ad5157d 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -679,10 +679,36 @@ static int ioctl_dev(struct block_device *b, fmode_t mode,
 	return d->ioctl(d, mode, cmd, arg);
 }
 
+static int report_zones_dev(struct gendisk *disk,
+			    sector_t sector,
+			    unsigned int nr_zones,
+			    report_zones_cb cb,
+			    void *data)
+{
+	struct bcache_device *d = disk->private_data;
+	struct bch_report_zones_args args = {
+		.bcache_device = d,
+		.sector = sector,
+		.orig_data = data,
+		.orig_cb = cb,
+	};
+
+	/*
+	 * only bcache device with backing device has
+	 * report_zones method, flash device does not.
+	 */
+	if (d->report_zones)
+		return d->report_zones(&args, nr_zones);
+
+	/* flash dev does not have report_zones method */
+	return -EOPNOTSUPP;
+}
+
 static const struct block_device_operations bcache_ops = {
 	.open		= open_dev,
 	.release	= release_dev,
 	.ioctl		= ioctl_dev,
+	.report_zones	= report_zones_dev,
 	.owner		= THIS_MODULE,
 };
 
@@ -817,6 +843,7 @@ static void bcache_device_free(struct bcache_device *d)
 
 static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 			      sector_t sectors, make_request_fn make_request_fn)
+
 {
 	struct request_queue *q;
 	const size_t max_stripes = min_t(size_t, INT_MAX,
@@ -1307,6 +1334,67 @@ static void cached_dev_flush(struct closure *cl)
 	continue_at(cl, cached_dev_free, system_wq);
 }
 
+static inline int cached_dev_data_offset_check(struct cached_dev *dc)
+{
+	if (!bdev_is_zoned(dc->bdev))
+		return 0;
+
+	/*
+	 * If the backing hard drive is zoned device, sb.data_offset
+	 * should be aligned to zone size, which is automatically
+	 * handled by 'bcache' util of bcache-tools. If the data_offset
+	 * is not aligned to zone size, it means the bcache-tools is
+	 * outdated.
+	 */
+	if (dc->sb.data_offset & (bdev_zone_sectors(dc->bdev) - 1)) {
+		pr_err("data_offset %llu is not aligned to zone size %llu, please update bcache-tools and re-make the zoned backing device.\n",
+			dc->sb.data_offset, bdev_zone_sectors(dc->bdev));
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * Initialize zone information for the bcache device, this function
+ * assumes the bcache device has a cached device (dc != NULL), and
+ * the cached device is zoned device (bdev_is_zoned(dc->bdev) == true).
+ *
+ * The following zone information of the bcache device will be set,
+ * - zoned mode, same as the mode of zoned backing device
+ * - zone size in sectors, same as the zoned backing device
+ * - zones number, it is zones number of zoned backing device minus the
+ *   reserved zones for bcache super blocks.
+ */
+static int bch_cached_dev_zone_init(struct cached_dev *dc)
+{
+	struct request_queue *d_q, *b_q;
+	enum blk_zoned_model mode;
+
+	if (!bdev_is_zoned(dc->bdev))
+		return 0;
+
+	/* queue of bcache device */
+	d_q = dc->disk.disk->queue;
+	/* queue of backing device */
+	b_q = bdev_get_queue(dc->bdev);
+
+	mode = blk_queue_zoned_model(b_q);
+	if (mode != BLK_ZONED_NONE) {
+		d_q->limits.zoned = mode;
+		blk_queue_chunk_sectors(d_q, b_q->limits.chunk_sectors);
+		/*
+		 * (dc->sb.data_offset / q->limits.chunk_sectors) is the
+		 * zones number reserved for bcache super block. By default
+		 * it is set to 1 by bcache-tools.
+		 */
+		d_q->nr_zones = b_q->nr_zones -
+			(dc->sb.data_offset / d_q->limits.chunk_sectors);
+	}
+
+	return 0;
+}
+
 static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
 {
 	int ret;
@@ -1333,6 +1421,10 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
 
 	dc->disk.stripe_size = q->limits.io_opt >> 9;
 
+	ret = cached_dev_data_offset_check(dc);
+	if (ret)
+		return ret;
+
 	if (dc->disk.stripe_size)
 		dc->partial_stripes_expensive =
 			q->limits.raid_partial_stripes_expensive;
@@ -1355,7 +1447,9 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
 
 	bch_cached_dev_request_init(dc);
 	bch_cached_dev_writeback_init(dc);
-	return 0;
+	ret = bch_cached_dev_zone_init(dc);
+
+	return ret;
 }
 
 /* Cached device - bcache superblock */
-- 
2.25.0

