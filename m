Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921862C54F5
	for <lists+linux-bcache@lfdr.de>; Thu, 26 Nov 2020 14:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390047AbgKZNHs (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 26 Nov 2020 08:07:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390039AbgKZNHq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 26 Nov 2020 08:07:46 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42534C061A47;
        Thu, 26 Nov 2020 05:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=BQcek4m3yWABZ+dx/WiWy+1fJw3es+Bc+lvaZ4inu9c=; b=ObNpBS6e3dv1B+pEgGrY5Ta9DN
        Q3qYUXZyTruHkEGafQUJ1CalZAd5EtsTd7ybHljioFm8OxKdkAQ8f8uSHN3n1GRp9F2+AORR9L9fr
        QQLST7btmRc45KSAQf0X9/kQkAbiWsefqO2U7rFUzLI/g1nf3xU2IvbjuDOMaCWytE/K/XeEYBlJm
        z599ZkH4fXMPwG+mC9a5t0bVJy9MopskGhs7CbNpx5XACAX7Tv4sqYyE8vwz9ObAA+c0d1mcZvPGm
        d3bVigMlXA1CXjFRziU+MGWeB2AlpLhyy1w5AX8Bbwx6+sRkCLkAU80qkVHfIQJUQ4qy5bjpevjsz
        yVrruxwg==;
Received: from [2001:4bb8:18c:1dd6:27b8:b8a1:c13e:ceb1] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kiGzp-0004E3-Vf; Thu, 26 Nov 2020 13:07:38 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
        Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jan Kara <jack@suse.cz>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        dm-devel@redhat.com, Jan Kara <jack@suse.com>,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 44/44] block: stop using bdget_disk for partition 0
Date:   Thu, 26 Nov 2020 14:04:22 +0100
Message-Id: <20201126130422.92945-45-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201126130422.92945-1-hch@lst.de>
References: <20201126130422.92945-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

We can just dereference the point in struct gendisk instead.  Also
remove the now unused export.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c                   |  1 -
 drivers/block/nbd.c             |  4 +---
 drivers/block/xen-blkfront.c    | 20 +++++---------------
 drivers/block/zram/zram_drv.c   | 14 ++------------
 drivers/md/dm.c                 | 16 ++--------------
 drivers/s390/block/dasd_ioctl.c |  5 ++---
 fs/block_dev.c                  |  2 +-
 7 files changed, 13 insertions(+), 49 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index af76c2fff40d31..01876a162f5813 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -920,7 +920,6 @@ struct block_device *bdget_disk(struct gendisk *disk, int partno)
 
 	return bdev;
 }
-EXPORT_SYMBOL(bdget_disk);
 
 /*
  * print a full list of all partitions - intended for places where the root
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 014683968ce174..92f84ed0ba9eb6 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1488,12 +1488,10 @@ static int nbd_open(struct block_device *bdev, fmode_t mode)
 static void nbd_release(struct gendisk *disk, fmode_t mode)
 {
 	struct nbd_device *nbd = disk->private_data;
-	struct block_device *bdev = bdget_disk(disk, 0);
 
 	if (test_bit(NBD_RT_DISCONNECT_ON_CLOSE, &nbd->config->runtime_flags) &&
-			bdev->bd_openers == 0)
+			disk->part0->bd_openers == 0)
 		nbd_disconnect_and_put(nbd);
-	bdput(bdev);
 
 	nbd_config_put(nbd);
 	nbd_put(nbd);
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 79521e33d30ed5..188e0b47534bcf 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -2153,7 +2153,7 @@ static void blkfront_closing(struct blkfront_info *info)
 	}
 
 	if (info->gd)
-		bdev = bdget_disk(info->gd, 0);
+		bdev = bdgrab(info->gd->part0);
 
 	mutex_unlock(&info->mutex);
 
@@ -2518,7 +2518,7 @@ static int blkfront_remove(struct xenbus_device *xbdev)
 
 	disk = info->gd;
 	if (disk)
-		bdev = bdget_disk(disk, 0);
+		bdev = bdgrab(disk->part0);
 
 	info->xbdev = NULL;
 	mutex_unlock(&info->mutex);
@@ -2595,19 +2595,11 @@ static int blkif_open(struct block_device *bdev, fmode_t mode)
 static void blkif_release(struct gendisk *disk, fmode_t mode)
 {
 	struct blkfront_info *info = disk->private_data;
-	struct block_device *bdev;
 	struct xenbus_device *xbdev;
 
 	mutex_lock(&blkfront_mutex);
-
-	bdev = bdget_disk(disk, 0);
-
-	if (!bdev) {
-		WARN(1, "Block device %s yanked out from us!\n", disk->disk_name);
+	if (disk->part0->bd_openers)
 		goto out_mutex;
-	}
-	if (bdev->bd_openers)
-		goto out;
 
 	/*
 	 * Check if we have been instructed to close. We will have
@@ -2619,7 +2611,7 @@ static void blkif_release(struct gendisk *disk, fmode_t mode)
 
 	if (xbdev && xbdev->state == XenbusStateClosing) {
 		/* pending switch to state closed */
-		dev_info(disk_to_dev(bdev->bd_disk), "releasing disk\n");
+		dev_info(disk_to_dev(disk), "releasing disk\n");
 		xlvbd_release_gendisk(info);
 		xenbus_frontend_closed(info->xbdev);
  	}
@@ -2628,14 +2620,12 @@ static void blkif_release(struct gendisk *disk, fmode_t mode)
 
 	if (!xbdev) {
 		/* sudden device removal */
-		dev_info(disk_to_dev(bdev->bd_disk), "releasing disk\n");
+		dev_info(disk_to_dev(disk), "releasing disk\n");
 		xlvbd_release_gendisk(info);
 		disk->private_data = NULL;
 		free_info(info);
 	}
 
-out:
-	bdput(bdev);
 out_mutex:
 	mutex_unlock(&blkfront_mutex);
 }
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index dc8957d173d37c..b0701bae6e9800 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1760,15 +1760,12 @@ static ssize_t reset_store(struct device *dev,
 		return -EINVAL;
 
 	zram = dev_to_zram(dev);
-	bdev = bdget_disk(zram->disk, 0);
-	if (!bdev)
-		return -ENOMEM;
+	bdev = zram->disk->part0;
 
 	mutex_lock(&bdev->bd_mutex);
 	/* Do not reset an active device or claimed device */
 	if (bdev->bd_openers || zram->claim) {
 		mutex_unlock(&bdev->bd_mutex);
-		bdput(bdev);
 		return -EBUSY;
 	}
 
@@ -1779,7 +1776,6 @@ static ssize_t reset_store(struct device *dev,
 	/* Make sure all the pending I/O are finished */
 	fsync_bdev(bdev);
 	zram_reset_device(zram);
-	bdput(bdev);
 
 	mutex_lock(&bdev->bd_mutex);
 	zram->claim = false;
@@ -1965,16 +1961,11 @@ static int zram_add(void)
 
 static int zram_remove(struct zram *zram)
 {
-	struct block_device *bdev;
-
-	bdev = bdget_disk(zram->disk, 0);
-	if (!bdev)
-		return -ENOMEM;
+	struct block_device *bdev = zram->disk->part0;
 
 	mutex_lock(&bdev->bd_mutex);
 	if (bdev->bd_openers || zram->claim) {
 		mutex_unlock(&bdev->bd_mutex);
-		bdput(bdev);
 		return -EBUSY;
 	}
 
@@ -1986,7 +1977,6 @@ static int zram_remove(struct zram *zram)
 	/* Make sure all the pending I/O are finished */
 	fsync_bdev(bdev);
 	zram_reset_device(zram);
-	bdput(bdev);
 
 	pr_info("Removed device: %s\n", zram->disk->disk_name);
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 176adcff56b380..ed7e836efbcdbc 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2375,16 +2375,11 @@ struct dm_table *dm_swap_table(struct mapped_device *md, struct dm_table *table)
  */
 static int lock_fs(struct mapped_device *md)
 {
-	struct block_device *bdev;
 	int r;
 
 	WARN_ON(test_bit(DMF_FROZEN, &md->flags));
 
-	bdev = bdget_disk(md->disk, 0);
-	if (!bdev)
-		return -ENOMEM;
-	r = freeze_bdev(bdev);
-	bdput(bdev);
+	r = freeze_bdev(md->disk->part0);
 	if (!r)
 		set_bit(DMF_FROZEN, &md->flags);
 	return r;
@@ -2392,16 +2387,9 @@ static int lock_fs(struct mapped_device *md)
 
 static void unlock_fs(struct mapped_device *md)
 {
-	struct block_device *bdev;
-
 	if (!test_bit(DMF_FROZEN, &md->flags))
 		return;
-
-	bdev = bdget_disk(md->disk, 0);
-	if (!bdev)
-		return;
-	thaw_bdev(bdev);
-	bdput(bdev);
+	thaw_bdev(md->disk->part0);
 	clear_bit(DMF_FROZEN, &md->flags);
 }
 
diff --git a/drivers/s390/block/dasd_ioctl.c b/drivers/s390/block/dasd_ioctl.c
index 304eba1acf163c..9f642440894655 100644
--- a/drivers/s390/block/dasd_ioctl.c
+++ b/drivers/s390/block/dasd_ioctl.c
@@ -220,9 +220,8 @@ dasd_format(struct dasd_block *block, struct format_data_t *fdata)
 	 * enabling the device later.
 	 */
 	if (fdata->start_unit == 0) {
-		struct block_device *bdev = bdget_disk(block->gdp, 0);
-		bdev->bd_inode->i_blkbits = blksize_bits(fdata->blksize);
-		bdput(bdev);
+		block->gdp->part0->bd_inode->i_blkbits =
+			blksize_bits(fdata->blksize);
 	}
 
 	rc = base->discipline->format_device(base, fdata, 1);
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 58fd6625966511..4edb9f23092285 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1295,7 +1295,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode)
 			if (ret)
 				return ret;
 		} else {
-			struct block_device *whole = bdget_disk(disk, 0);
+			struct block_device *whole = bdgrab(disk->part0);
 
 			mutex_lock_nested(&whole->bd_mutex, 1);
 			ret = __blkdev_get(whole, mode);
-- 
2.29.2

