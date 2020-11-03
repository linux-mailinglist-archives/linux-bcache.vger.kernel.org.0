Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98DFC2A414E
	for <lists+linux-bcache@lfdr.de>; Tue,  3 Nov 2020 11:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbgKCKLV (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 3 Nov 2020 05:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgKCKLU (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 3 Nov 2020 05:11:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A612AC0613D1;
        Tue,  3 Nov 2020 02:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=d6eXOjuXpEGh4QV0WzAZm1B65GVluoutmLV75dqvSwg=; b=dJZlq2TQbBfbRH7MzgtHND3PrW
        gQAy+tyQdsTI+RCqnQSfA2sHN7UvV6SpNQPi1ZKCWOyyMkaihDGG7JDVVl1cgOoV+7VhBYajIz9d/
        XD0fCvpVGpLgqeM1K6zpSXZqe7UZ3xqfej+VG00ntzEeJ2CLIINjitIDN1EasKATrOu4TrWbR8893
        k6ywySR9quGWeXnrOLSYCdYVs6SksBreoXlJNFolPr9FD+BrD10T4tvCorMrF5BAnG+T7BvsOtNnf
        JoANNOXvyhhlKJYlIgmpV4aVERKbZzviYmKwzEVPVkxV0pZ6A3tXYgE8ZWT5cBttvemZw8N1uzo4+
        gu1f+o5Q==;
Received: from 089144208145.atnat0017.highway.a1.net ([89.144.208.145] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kZtHX-0000em-5z; Tue, 03 Nov 2020 10:11:15 +0000
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
Subject: [PATCH 04/10] rbd: implement ->set_read_only to hook into BLKROSET processing
Date:   Tue,  3 Nov 2020 11:00:12 +0100
Message-Id: <20201103100018.683694-5-hch@lst.de>
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
Acked-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 40 ++++------------------------------------
 1 file changed, 4 insertions(+), 36 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index f84128abade319..671733e459cf47 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -692,12 +692,9 @@ static void rbd_release(struct gendisk *disk, fmode_t mode)
 	put_device(&rbd_dev->dev);
 }
 
-static int rbd_ioctl_set_ro(struct rbd_device *rbd_dev, unsigned long arg)
+static int rbd_set_read_only(struct block_device *bdev, bool ro)
 {
-	int ro;
-
-	if (get_user(ro, (int __user *)arg))
-		return -EFAULT;
+	struct rbd_device *rbd_dev = bdev->bd_disk->private_data;
 
 	/*
 	 * Both images mapped read-only and snapshots can't be marked
@@ -710,43 +707,14 @@ static int rbd_ioctl_set_ro(struct rbd_device *rbd_dev, unsigned long arg)
 		rbd_assert(!rbd_is_snap(rbd_dev));
 	}
 
-	/* Let blkdev_roset() handle it */
-	return -ENOTTY;
-}
-
-static int rbd_ioctl(struct block_device *bdev, fmode_t mode,
-			unsigned int cmd, unsigned long arg)
-{
-	struct rbd_device *rbd_dev = bdev->bd_disk->private_data;
-	int ret;
-
-	switch (cmd) {
-	case BLKROSET:
-		ret = rbd_ioctl_set_ro(rbd_dev, arg);
-		break;
-	default:
-		ret = -ENOTTY;
-	}
-
-	return ret;
-}
-
-#ifdef CONFIG_COMPAT
-static int rbd_compat_ioctl(struct block_device *bdev, fmode_t mode,
-				unsigned int cmd, unsigned long arg)
-{
-	return rbd_ioctl(bdev, mode, cmd, arg);
+	return 0;
 }
-#endif /* CONFIG_COMPAT */
 
 static const struct block_device_operations rbd_bd_ops = {
 	.owner			= THIS_MODULE,
 	.open			= rbd_open,
 	.release		= rbd_release,
-	.ioctl			= rbd_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl		= rbd_compat_ioctl,
-#endif
+	.set_read_only		= rbd_set_read_only,
 };
 
 /*
-- 
2.28.0

