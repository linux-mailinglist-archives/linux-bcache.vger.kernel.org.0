Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6129011437C
	for <lists+linux-bcache@lfdr.de>; Thu,  5 Dec 2019 16:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbfLEPZx (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 5 Dec 2019 10:25:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:43228 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729145AbfLEPZx (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 5 Dec 2019 10:25:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F2CC2B2AE;
        Thu,  5 Dec 2019 15:25:50 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.com>
Subject: [RFC PATCH] bcache: enable zoned device support
Date:   Thu,  5 Dec 2019 23:25:43 +0800
Message-Id: <20191205152543.73885-1-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This is a very basic zoned device support. With this patch, bcache
device is able to,
- Export zoned device attribution via sysfs
- Response report zones request, e.g. by command 'blkzone report'
But the bcache device is still NOT able to,
- Response any zoned device management request or IOCTL command

Here are the testings I have done,
- read /sys/block/bcache0/queue/zoned, content is 'host-managed'
- read /sys/block/bcache0/queue/nr_zones, content is number of zones
  including all zone types.
- read /sys/block/bcache0/queue/chunk_sectors, content is zone size
  in sectors.
- run 'blkzone report /dev/bcache0', all zones information displayed.
- run 'blkzone reset /dev/bcache0', operation is rejected with error
  information: "blkzone: /dev/bcache0: BLKRESETZONE ioctl failed:
  Operation not supported"
- Sequential writes by dd, I can see some zones' write pointer 'wptr'
  values updated.

All of these are very basic testings, if you have better testing
tools or cases, please offer me hint.

Thanks in advance for your review and comments.

Signed-off-by: Coly Li <colyli@suse.de>
CC: Damien Le Moal <damien.lemoal@wdc.com>
CC: Hannes Reinecke <hare@suse.com>
---
 drivers/md/bcache/bcache.h  | 10 ++++++
 drivers/md/bcache/request.c | 74 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/bcache/super.c   | 41 +++++++++++++++++++++++--
 3 files changed, 122 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 9198c1b480d9..77c2040c99ee 100644
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
@@ -743,6 +746,13 @@ struct bbio {
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
index 7555e4a93145..d82425300383 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1162,6 +1162,19 @@ static blk_qc_t cached_dev_make_request(struct request_queue *q,
 		}
 	}
 
+	/*
+	 * zone management request may change the data layout and content
+	 * implicitly on backing device, which introduces unacceptible
+	 * inconsistency between the backing device and the cache device.
+	 * Therefore all zone management related request will be denied here.
+	 */
+	if (op_is_zone_mgmt(bio->bi_opf)) {
+		pr_err_ratelimited("zoned device management request denied.");
+		bio->bi_status = BLK_STS_NOTSUPP;
+		bio_endio(bio);
+		return BLK_QC_T_NONE;
+	}
+
 	generic_start_io_acct(q,
 			      bio_op(bio),
 			      bio_sectors(bio),
@@ -1205,6 +1218,24 @@ static int cached_dev_ioctl(struct bcache_device *d, fmode_t mode,
 	if (dc->io_disable)
 		return -EIO;
 
+	/*
+	 * zone management ioctl commands may change the data layout
+	 * and content implicitly on backing device, which introduces
+	 * unacceptible inconsistency between the backing device and
+	 * the cache device. Therefore all zone management related
+	 * ioctl commands will be denied here.
+	 */
+	switch (cmd) {
+	case BLKRESETZONE:
+	case BLKOPENZONE:
+	case BLKCLOSEZONE:
+	case BLKFINISHZONE:
+		return -EOPNOTSUPP;
+	default:
+		/* Other commands fall through*/
+		break;
+	}
+
 	return __blkdev_driver_ioctl(dc->bdev, mode, cmd, arg);
 }
 
@@ -1233,6 +1264,48 @@ static int cached_dev_congested(void *data, int bits)
 	return ret;
 }
 
+static int cached_dev_report_zones_cb(struct blk_zone *zone,
+				      unsigned int idx,
+				      void *data)
+{
+	struct bch_report_zones_args *args = data;
+	struct bcache_device *d = args->bcache_device;
+	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
+	unsigned long data_offset = dc->sb.data_offset;
+
+	if (zone->start >= data_offset) {
+		zone->start -= data_offset;
+		zone->wp -= data_offset;
+	} else {
+		/*
+		 * Normally the first zone is conventional zone,
+		 * we don't need to worry about how to maintain
+		 * the write pointer.
+		 * But the zone->len is special, because the
+		 * sector 0 on bcache device is 8KB offset on
+		 * backing device indeed.
+		 */
+		zone->len -= data_offset;
+	}
+
+	return args->orig_cb(zone, idx, args->orig_data);
+}
+
+static int cached_dev_report_zones(struct bch_report_zones_args *args,
+				   unsigned int nr_zones)
+{
+	struct bcache_device *d = args->bcache_device;
+	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
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
@@ -1241,6 +1314,7 @@ void bch_cached_dev_request_init(struct cached_dev *dc)
 	g->queue->backing_dev_info->congested_fn = cached_dev_congested;
 	dc->disk.cache_miss			= cached_dev_cache_miss;
 	dc->disk.ioctl				= cached_dev_ioctl;
+	dc->disk.report_zones			= cached_dev_report_zones;
 }
 
 /* Flash backed devices */
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 77e9869345e7..7222fcafaf50 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -672,10 +672,32 @@ static int ioctl_dev(struct block_device *b, fmode_t mode,
 	return d->ioctl(d, mode, cmd, arg);
 }
 
+
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
+	if (d->report_zones)
+		return d->report_zones(&args, nr_zones);
+
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
 
@@ -808,7 +830,9 @@ static void bcache_device_free(struct bcache_device *d)
 	closure_debug_destroy(&d->cl);
 }
 
-static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
+static int bcache_device_init(struct cached_dev *dc,
+			      struct bcache_device *d,
+			      unsigned int block_size,
 			      sector_t sectors)
 {
 	struct request_queue *q;
@@ -882,6 +906,17 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 
 	blk_queue_write_cache(q, true, true);
 
+	/*
+	 * If this is for backing device registration, and it is an
+	 * zoned device (e.g. host-managed S.M.R. hard drive), set
+	 * up zoned device attribution properly for sysfs interface.
+	 */
+	if (dc && bdev_is_zoned(dc->bdev)) {
+		q->limits.zoned = bdev_zoned_model(dc->bdev);
+		q->nr_zones = blkdev_nr_zones(dc->bdev);
+		q->limits.chunk_sectors = bdev_zone_sectors(dc->bdev);
+	}
+
 	return 0;
 
 err:
@@ -1328,7 +1363,7 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
 		dc->partial_stripes_expensive =
 			q->limits.raid_partial_stripes_expensive;
 
-	ret = bcache_device_init(&dc->disk, block_size,
+	ret = bcache_device_init(dc, &dc->disk, block_size,
 			 dc->bdev->bd_part->nr_sects - dc->sb.data_offset);
 	if (ret)
 		return ret;
@@ -1445,7 +1480,7 @@ static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
 
 	kobject_init(&d->kobj, &bch_flash_dev_ktype);
 
-	if (bcache_device_init(d, block_bytes(c), u->sectors))
+	if (bcache_device_init(NULL, d, block_bytes(c), u->sectors))
 		goto err;
 
 	bcache_device_attach(d, c, u - c->uuids);
-- 
2.16.4

