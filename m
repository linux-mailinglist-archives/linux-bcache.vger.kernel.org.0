Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D38C3E405A
	for <lists+linux-bcache@lfdr.de>; Mon,  9 Aug 2021 08:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbhHIGnf (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 9 Aug 2021 02:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233335AbhHIGne (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Aug 2021 02:43:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9F2C0613CF;
        Sun,  8 Aug 2021 23:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=qljGBqxspb9Ty7e7fZsBd9W3oiFekYWvN5zsUVM+9TE=; b=lin8/grSar9gaxlcUtlh5vQ/i4
        rF99mDVV8+RQZGsbHltD9r3yLnazh05xquJ17XdSM4sy00XrnxDQ6WT+fi3cnx7S0oWbZ/3SgEMDM
        SaxpH/6a+vxC0lSUHbQGTgC2Gig6vZMC1KJAO1XyET1adBiX5WKxqdEsHAdfNqRAj2Oo4AbDBgvIv
        O3VGVzltwacY/9FpNpt30Dp3NKj6wSKasWFKn5RRXIxozWhhYD5VoaachIZsoB1B2oZ+vVLOb6AQD
        XqzJcQQo4MPlTMY7xtZkOsdWnS4KghcvavjM+qG2C/xdyXyB3B4HJbWQfD2X3SIyR3Hm9X3BVVMU/
        gS1e6TQQ==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mCyyq-00AibA-C8; Mon, 09 Aug 2021 06:42:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Coly Li <colyli@suse.de>, Song Liu <song@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: [PATCH 1/8] mmc: block: let device_add_disk create disk attributes
Date:   Mon,  9 Aug 2021 08:40:21 +0200
Message-Id: <20210809064028.1198327-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210809064028.1198327-1-hch@lst.de>
References: <20210809064028.1198327-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Pass the attribute group for the attributes on the gendisk to
device_add_disk so that they are created atomically with the
disk creation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/mmc/core/block.c | 102 +++++++++++++++++----------------------
 1 file changed, 45 insertions(+), 57 deletions(-)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index ce8aed562929..4ac3e1b93e7e 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -128,8 +128,6 @@ struct mmc_blk_data {
 	 * track of the current selected device partition.
 	 */
 	unsigned int	part_curr;
-	struct device_attribute force_ro;
-	struct device_attribute power_ro_lock;
 	int	area_type;
 
 	/* debugfs files (only in main mmc_blk_data) */
@@ -281,6 +279,9 @@ static ssize_t power_ro_lock_store(struct device *dev,
 	return count;
 }
 
+static DEVICE_ATTR(ro_lock_until_next_power_on, 0,
+		power_ro_lock_show, power_ro_lock_store);
+
 static ssize_t force_ro_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
@@ -313,6 +314,44 @@ static ssize_t force_ro_store(struct device *dev, struct device_attribute *attr,
 	return ret;
 }
 
+static DEVICE_ATTR(force_ro, 0644, force_ro_show, force_ro_store);
+
+static struct attribute *mmc_disk_attrs[] = {
+	&dev_attr_force_ro.attr,
+	&dev_attr_ro_lock_until_next_power_on.attr,
+	NULL,
+};
+
+static umode_t mmc_disk_attrs_is_visible(struct kobject *kobj,
+		struct attribute *a, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct mmc_blk_data *md = mmc_blk_get(dev_to_disk(dev));
+	umode_t mode = a->mode;
+
+	if (a == &dev_attr_ro_lock_until_next_power_on.attr &&
+	    (md->area_type & MMC_BLK_DATA_AREA_BOOT) &&
+	    md->queue.card->ext_csd.boot_ro_lockable) {
+		mode = S_IRUGO;
+		if (!(md->queue.card->ext_csd.boot_ro_lock &
+				EXT_CSD_BOOT_WP_B_PWR_WP_DIS))
+			mode |= S_IWUSR;
+	}
+
+	mmc_blk_put(md);
+	return mode;
+}
+
+static const struct attribute_group mmc_disk_attr_group = {
+	.is_visible	= mmc_disk_attrs_is_visible,
+	.attrs		= mmc_disk_attrs,
+};
+
+static const struct attribute_group *mmc_disk_attr_groups[] = {
+	&mmc_disk_attr_group,
+	NULL,
+};
+
 static int mmc_blk_open(struct block_device *bdev, fmode_t mode)
 {
 	struct mmc_blk_data *md = mmc_blk_get(bdev->bd_disk);
@@ -2644,15 +2683,8 @@ static void mmc_blk_remove_req(struct mmc_blk_data *md)
 		 * from being accepted.
 		 */
 		card = md->queue.card;
-		if (md->disk->flags & GENHD_FL_UP) {
-			device_remove_file(disk_to_dev(md->disk), &md->force_ro);
-			if ((md->area_type & MMC_BLK_DATA_AREA_BOOT) &&
-					card->ext_csd.boot_ro_lockable)
-				device_remove_file(disk_to_dev(md->disk),
-					&md->power_ro_lock);
-
+		if (md->disk->flags & GENHD_FL_UP)
 			del_gendisk(md->disk);
-		}
 		mmc_cleanup_queue(&md->queue);
 		mmc_blk_put(md);
 	}
@@ -2679,51 +2711,6 @@ static void mmc_blk_remove_parts(struct mmc_card *card,
 	}
 }
 
-static int mmc_add_disk(struct mmc_blk_data *md)
-{
-	int ret;
-	struct mmc_card *card = md->queue.card;
-
-	device_add_disk(md->parent, md->disk, NULL);
-	md->force_ro.show = force_ro_show;
-	md->force_ro.store = force_ro_store;
-	sysfs_attr_init(&md->force_ro.attr);
-	md->force_ro.attr.name = "force_ro";
-	md->force_ro.attr.mode = S_IRUGO | S_IWUSR;
-	ret = device_create_file(disk_to_dev(md->disk), &md->force_ro);
-	if (ret)
-		goto force_ro_fail;
-
-	if ((md->area_type & MMC_BLK_DATA_AREA_BOOT) &&
-	     card->ext_csd.boot_ro_lockable) {
-		umode_t mode;
-
-		if (card->ext_csd.boot_ro_lock & EXT_CSD_BOOT_WP_B_PWR_WP_DIS)
-			mode = S_IRUGO;
-		else
-			mode = S_IRUGO | S_IWUSR;
-
-		md->power_ro_lock.show = power_ro_lock_show;
-		md->power_ro_lock.store = power_ro_lock_store;
-		sysfs_attr_init(&md->power_ro_lock.attr);
-		md->power_ro_lock.attr.mode = mode;
-		md->power_ro_lock.attr.name =
-					"ro_lock_until_next_power_on";
-		ret = device_create_file(disk_to_dev(md->disk),
-				&md->power_ro_lock);
-		if (ret)
-			goto power_ro_lock_fail;
-	}
-	return ret;
-
-power_ro_lock_fail:
-	device_remove_file(disk_to_dev(md->disk), &md->force_ro);
-force_ro_fail:
-	del_gendisk(md->disk);
-
-	return ret;
-}
-
 #ifdef CONFIG_DEBUG_FS
 
 static int mmc_dbg_card_status_get(void *data, u64 *val)
@@ -2919,12 +2906,13 @@ static int mmc_blk_probe(struct mmc_card *card)
 
 	dev_set_drvdata(&card->dev, md);
 
-	ret = mmc_add_disk(md);
+	device_add_disk(md->parent, md->disk, mmc_disk_attr_groups);
 	if (ret)
 		goto out;
 
 	list_for_each_entry(part_md, &md->part, part) {
-		ret = mmc_add_disk(part_md);
+		device_add_disk(part_md->parent, part_md->disk,
+				mmc_disk_attr_groups);
 		if (ret)
 			goto out;
 	}
-- 
2.30.2

