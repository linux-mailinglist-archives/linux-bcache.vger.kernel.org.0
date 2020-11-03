Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCD162A4172
	for <lists+linux-bcache@lfdr.de>; Tue,  3 Nov 2020 11:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgKCKPq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 3 Nov 2020 05:15:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728066AbgKCKPp (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 3 Nov 2020 05:15:45 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D10DC0613D1;
        Tue,  3 Nov 2020 02:15:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Varo6jriPIgUuzbDsXbdYpkIn84a9RY13C55YdYZcpg=; b=EaqQVwLMEgIvlLoCt0slTsgr2M
        7Ja8KuaA5NnyuaytfIBLmbZvwmc7N9lbWB8ue/vcyCUR7DUikGqP3wHmZVpat2tK8FLIpo/i0/9PI
        vicLgjzqXIS0/u5yUtSRaVgxvCxOzNZ8w/S0jsyVJEIckGFOi3cY8VztXm5e9FIU225Fma9zNHscc
        UWTJdHbP1qDHbZbKxjalFFpJf+eVcxSy2/WegTt0z2L3cOZsWCJHEHszgcNBWnGloMySpKtixt6+K
        /edelb0jToYqbPoPd7SSHumGeBNnC0XXcgsVwycwkL4EIyZx0PvHl0WN+39wOjq69RJ/ztzbl+k7Q
        BTaXfESQ==;
Received: from 089144208145.atnat0017.highway.a1.net ([89.144.208.145] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kZtLl-00010H-Aq; Tue, 03 Nov 2020 10:15:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ilya Dryomov <idryomov@gmail.com>, Song Liu <song@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org
Subject: [PATCH 06/10] dasd: implement ->set_read_only to hook into BLKROSET processing
Date:   Tue,  3 Nov 2020 11:00:14 +0100
Message-Id: <20201103100018.683694-7-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103100018.683694-1-hch@lst.de>
References: <20201103100018.683694-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Implement the ->set_read_only method instead of parsing the actual
ioctl command.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/s390/block/dasd.c       |  1 +
 drivers/s390/block/dasd_int.h   |  3 ++-
 drivers/s390/block/dasd_ioctl.c | 27 +++++++++------------------
 3 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index eb17fea8075c6f..db24e04ee9781e 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -3394,6 +3394,7 @@ dasd_device_operations = {
 	.ioctl		= dasd_ioctl,
 	.compat_ioctl	= dasd_ioctl,
 	.getgeo		= dasd_getgeo,
+	.set_read_only	= dasd_set_read_only,
 };
 
 /*******************************************************************************
diff --git a/drivers/s390/block/dasd_int.h b/drivers/s390/block/dasd_int.h
index fa552f9f166671..c59a0d63b506e6 100644
--- a/drivers/s390/block/dasd_int.h
+++ b/drivers/s390/block/dasd_int.h
@@ -844,7 +844,8 @@ int dasd_scan_partitions(struct dasd_block *);
 void dasd_destroy_partitions(struct dasd_block *);
 
 /* externals in dasd_ioctl.c */
-int  dasd_ioctl(struct block_device *, fmode_t, unsigned int, unsigned long);
+int dasd_ioctl(struct block_device *, fmode_t, unsigned int, unsigned long);
+int dasd_set_read_only(struct block_device *bdev, bool ro);
 
 /* externals in dasd_proc.c */
 int dasd_proc_init(void);
diff --git a/drivers/s390/block/dasd_ioctl.c b/drivers/s390/block/dasd_ioctl.c
index cb6427fb9f3d16..3359559517bfcf 100644
--- a/drivers/s390/block/dasd_ioctl.c
+++ b/drivers/s390/block/dasd_ioctl.c
@@ -532,28 +532,22 @@ static int dasd_ioctl_information(struct dasd_block *block, void __user *argp,
 /*
  * Set read only
  */
-static int
-dasd_ioctl_set_ro(struct block_device *bdev, void __user *argp)
+int dasd_set_read_only(struct block_device *bdev, bool ro)
 {
 	struct dasd_device *base;
-	int intval, rc;
+	int rc;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
+	/* do not manipulate hardware state for partitions */
 	if (bdev_is_partition(bdev))
-		// ro setting is not allowed for partitions
-		return -EINVAL;
-	if (get_user(intval, (int __user *)argp))
-		return -EFAULT;
+		return 0;
+
 	base = dasd_device_from_gendisk(bdev->bd_disk);
 	if (!base)
 		return -ENODEV;
-	if (!intval && test_bit(DASD_FLAG_DEVICE_RO, &base->flags)) {
-		dasd_put_device(base);
-		return -EROFS;
-	}
-	set_disk_ro(bdev->bd_disk, intval);
-	rc = dasd_set_feature(base->cdev, DASD_FEATURE_READONLY, intval);
+	if (!ro && test_bit(DASD_FLAG_DEVICE_RO, &base->flags))
+		rc = -EROFS;
+	else
+		rc = dasd_set_feature(base->cdev, DASD_FEATURE_READONLY, ro);
 	dasd_put_device(base);
 	return rc;
 }
@@ -633,9 +627,6 @@ int dasd_ioctl(struct block_device *bdev, fmode_t mode,
 	case BIODASDPRRST:
 		rc = dasd_ioctl_reset_profile(block);
 		break;
-	case BLKROSET:
-		rc = dasd_ioctl_set_ro(bdev, argp);
-		break;
 	case DASDAPIVER:
 		rc = dasd_ioctl_api_version(argp);
 		break;
-- 
2.28.0

