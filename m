Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 903B6723A22
	for <lists+linux-bcache@lfdr.de>; Tue,  6 Jun 2023 09:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236738AbjFFHos (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 6 Jun 2023 03:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236670AbjFFHnV (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 6 Jun 2023 03:43:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCF91BC9;
        Tue,  6 Jun 2023 00:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ipA6E6PjFwn9EQKQAyZEVl0PLPdTLG96IzNuBLnYaLI=; b=Mz26LqLtxMwuSjhlwz27X/9eMb
        L0Br/ZqAKPO4imnbeirvoBJPYYAMyDJNknsHiL4UFZJPQRsMh+WZN2F3Ne1P3lNOfZiFN6P6gq8LJ
        bYIWhNJfcWgGoVJJPVFOgq+HLsWUx9WOYZBlWNrT/Z/pkUhQqr7w0ap4SNjXzba1ela+ejYmGkqSD
        3yR/4wXCh4CBqqhO1mtDf9LisGEjNdzwP37TpjAeu2ofgDWEhUT5nT4e7a0dIH1RFr4F6jdmNxeP2
        YQKbpbUs33CbKPfXlwABUpCruoGh4XcDkam0H7mPJXa4VYofyUC5PMYdlMwCHRTO4EKYN8ixN67bo
        kXAstIoA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1q6RJd-000ZwB-0Y;
        Tue, 06 Jun 2023 07:41:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Richard Weinberger <richard@nod.at>,
        Josef Bacik <josef@toxicpanda.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Coly Li <colyli@suse.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-um@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org,
        linux-btrfs@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH 26/31] block: move a few internal definitions out of blkdev.h
Date:   Tue,  6 Jun 2023 09:39:45 +0200
Message-Id: <20230606073950.225178-27-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230606073950.225178-1-hch@lst.de>
References: <20230606073950.225178-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

All these helpers are only used in core block code, so move them out of
the public header.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk.h            | 23 +++++++++++++++++++++--
 include/linux/blkdev.h | 27 ---------------------------
 2 files changed, 21 insertions(+), 29 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index 9582fcd0df4123..6910220aa030f1 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -394,10 +394,27 @@ static inline struct bio *blk_queue_bounce(struct bio *bio,
 #ifdef CONFIG_BLK_DEV_ZONED
 void disk_free_zone_bitmaps(struct gendisk *disk);
 void disk_clear_zone_settings(struct gendisk *disk);
-#else
+int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
+		unsigned int cmd, unsigned long arg);
+int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
+		unsigned int cmd, unsigned long arg);
+#else /* CONFIG_BLK_DEV_ZONED */
 static inline void disk_free_zone_bitmaps(struct gendisk *disk) {}
 static inline void disk_clear_zone_settings(struct gendisk *disk) {}
-#endif
+static inline int blkdev_report_zones_ioctl(struct block_device *bdev,
+		fmode_t mode, unsigned int cmd, unsigned long arg)
+{
+	return -ENOTTY;
+}
+static inline int blkdev_zone_mgmt_ioctl(struct block_device *bdev,
+		fmode_t mode, unsigned int cmd, unsigned long arg)
+{
+	return -ENOTTY;
+}
+#endif /* CONFIG_BLK_DEV_ZONED */
+
+struct block_device *bdev_alloc(struct gendisk *disk, u8 partno);
+void bdev_add(struct block_device *bdev, dev_t dev);
 
 int blk_alloc_ext_minor(void);
 void blk_free_ext_minor(unsigned int minor);
@@ -449,6 +466,8 @@ extern struct device_attribute dev_attr_events_poll_msecs;
 
 extern struct attribute_group blk_trace_attr_group;
 
+int truncate_bdev_range(struct block_device *bdev, fmode_t mode, loff_t lstart,
+		loff_t lend);
 long blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg);
 long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 97803603902076..6b65623e447c02 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -318,7 +318,6 @@ typedef int (*report_zones_cb)(struct blk_zone *zone, unsigned int idx,
 void disk_set_zoned(struct gendisk *disk, enum blk_zoned_model model);
 
 #ifdef CONFIG_BLK_DEV_ZONED
-
 #define BLK_ALL_ZONES  ((unsigned int)-1)
 int blkdev_report_zones(struct block_device *bdev, sector_t sector,
 			unsigned int nr_zones, report_zones_cb cb, void *data);
@@ -328,33 +327,11 @@ extern int blkdev_zone_mgmt(struct block_device *bdev, enum req_op op,
 			    gfp_t gfp_mask);
 int blk_revalidate_disk_zones(struct gendisk *disk,
 			      void (*update_driver_data)(struct gendisk *disk));
-
-extern int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
-				     unsigned int cmd, unsigned long arg);
-extern int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
-				  unsigned int cmd, unsigned long arg);
-
 #else /* CONFIG_BLK_DEV_ZONED */
-
 static inline unsigned int bdev_nr_zones(struct block_device *bdev)
 {
 	return 0;
 }
-
-static inline int blkdev_report_zones_ioctl(struct block_device *bdev,
-					    fmode_t mode, unsigned int cmd,
-					    unsigned long arg)
-{
-	return -ENOTTY;
-}
-
-static inline int blkdev_zone_mgmt_ioctl(struct block_device *bdev,
-					 fmode_t mode, unsigned int cmd,
-					 unsigned long arg)
-{
-	return -ENOTTY;
-}
-
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 /*
@@ -1493,11 +1470,7 @@ void blkdev_put(struct block_device *bdev, void *holder);
 struct block_device *blkdev_get_no_open(dev_t dev);
 void blkdev_put_no_open(struct block_device *bdev);
 
-struct block_device *bdev_alloc(struct gendisk *disk, u8 partno);
-void bdev_add(struct block_device *bdev, dev_t dev);
 struct block_device *I_BDEV(struct inode *inode);
-int truncate_bdev_range(struct block_device *bdev, fmode_t mode, loff_t lstart,
-		loff_t lend);
 
 #ifdef CONFIG_BLOCK
 void invalidate_bdev(struct block_device *bdev);
-- 
2.39.2

