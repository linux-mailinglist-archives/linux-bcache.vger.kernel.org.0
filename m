Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04D02A144F
	for <lists+linux-bcache@lfdr.de>; Sat, 31 Oct 2020 10:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgJaJCn (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 31 Oct 2020 05:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbgJaJCn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 31 Oct 2020 05:02:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1FDC0613D5;
        Sat, 31 Oct 2020 02:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=hHOl61qo6rBfBiBYCMvJ6RFdITg0MzJ2jIHmO3/tMTY=; b=IXCjpCSbArfkkVwV/sbws2MJLR
        1KEv2An+Ui8D2gZSuwsJm5zTmBx5/Jdg0oLouZz2dmaigA2EXqzLpcGbkyaCGTasjmBVMX8Bzmz8b
        HMJEZti/1o2EDvlpPXIvAVUGIqZovHUdWXmkaOdmxGZIridagqgR+n/GKNMSFlCyUjq/wJN+ZB5Qr
        PlCvm7jXxyYhw2CDp2mAzDgYwwqO2w/NCBqafjG0ke4C7Q1oVH7Kb1+bzlLF6mBeUsU0ht7XH7Mla
        q/zVw/CxLXFMwD9QR0d9GvnEeO9wXKIDplPh+2MKT7BAL8eG8psTAhle2YGupi5iCFIFlyxf+/D5l
        D83PKzNg==;
Received: from 089144193201.atnat0002.highway.a1.net ([89.144.193.201] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kYmmO-0006zD-Vo; Sat, 31 Oct 2020 09:02:33 +0000
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
Subject: [PATCH 01/11] mtd_blkdevs: don't override BLKFLSBUF
Date:   Sat, 31 Oct 2020 09:58:00 +0100
Message-Id: <20201031085810.450489-2-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201031085810.450489-1-hch@lst.de>
References: <20201031085810.450489-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

BLKFLSBUF does not actually send a flush command to the device, but
teard down buffer cache structures.  Remove the mtd_blkdevs
implementation and just use the default semantics instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/mtd/mtd_blkdevs.c | 28 ----------------------------
 1 file changed, 28 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 0c05f77f9b216e..fb8e12d590a13a 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -298,38 +298,10 @@ static int blktrans_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return ret;
 }
 
-static int blktrans_ioctl(struct block_device *bdev, fmode_t mode,
-			      unsigned int cmd, unsigned long arg)
-{
-	struct mtd_blktrans_dev *dev = blktrans_dev_get(bdev->bd_disk);
-	int ret = -ENXIO;
-
-	if (!dev)
-		return ret;
-
-	mutex_lock(&dev->lock);
-
-	if (!dev->mtd)
-		goto unlock;
-
-	switch (cmd) {
-	case BLKFLSBUF:
-		ret = dev->tr->flush ? dev->tr->flush(dev) : 0;
-		break;
-	default:
-		ret = -ENOTTY;
-	}
-unlock:
-	mutex_unlock(&dev->lock);
-	blktrans_dev_put(dev);
-	return ret;
-}
-
 static const struct block_device_operations mtd_block_ops = {
 	.owner		= THIS_MODULE,
 	.open		= blktrans_open,
 	.release	= blktrans_release,
-	.ioctl		= blktrans_ioctl,
 	.getgeo		= blktrans_getgeo,
 };
 
-- 
2.28.0

