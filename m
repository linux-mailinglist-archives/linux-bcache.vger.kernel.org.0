Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E512A1459
	for <lists+linux-bcache@lfdr.de>; Sat, 31 Oct 2020 10:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgJaJEx (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 31 Oct 2020 05:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgJaJEx (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 31 Oct 2020 05:04:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC892C0613D5;
        Sat, 31 Oct 2020 02:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ccFP0prAIqmawhHUijWCb+7+0K8IzQR5e/dvexyFO7w=; b=Ym5ZpzHKJJlJDCRVypUAPGA7II
        66cevz7I1EwaypqqFcVa4mhtzXPSi14G+BSzgrfzXjomstRfmzNHCsxM5hd29idZSqhKB1/O4HyWG
        cI6qz9Lwu++xOvn9i+X8tPtN8trZ9oJtLj76lZSWkXb3ZLGYjohpW/C91ZUiGJDWAilob25tuOxU8
        wWmbGMxU1XT1LIZmT1gjKko1SC7eCo8YP6MVaFj8XbUPgjJpMHk0q7JXRlJcdwutx3Bh5cFR0nxhS
        jV54N+PYZt0wvKMUO99H8jx8u1/OuX1wJitqfVVZIpjpCZ/SAnQ8ifL/aOAbUP72QXrCbKu6iqTeH
        +dYElAMg==;
Received: from 089144193201.atnat0002.highway.a1.net ([89.144.193.201] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kYmoY-00076g-4q; Sat, 31 Oct 2020 09:04:46 +0000
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
Subject: [PATCH 02/11] mtip32xx: return -ENOTTY for all unhanled ioctls
Date:   Sat, 31 Oct 2020 09:58:01 +0100
Message-Id: <20201031085810.450489-3-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201031085810.450489-1-hch@lst.de>
References: <20201031085810.450489-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

-ENOTTY is the convention for "driver does not support this ioctl".
Use it properly in mtip32xx instead of the bogys -EINVAL.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/mtip32xx/mtip32xx.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 153e2cdecb4d40..893be95eceb34e 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -2029,7 +2029,7 @@ static int mtip_hw_ioctl(struct driver_data *dd, unsigned int cmd,
 	}
 
 	default:
-		return -EINVAL;
+		return -ENOTTY;
 	}
 	return 0;
 }
@@ -3215,12 +3215,7 @@ static int mtip_block_ioctl(struct block_device *dev,
 	if (unlikely(test_bit(MTIP_DDF_REMOVE_PENDING_BIT, &dd->dd_flag)))
 		return -ENOTTY;
 
-	switch (cmd) {
-	case BLKFLSBUF:
-		return -ENOTTY;
-	default:
-		return mtip_hw_ioctl(dd, cmd, arg);
-	}
+	return mtip_hw_ioctl(dd, cmd, arg);
 }
 
 #ifdef CONFIG_COMPAT
@@ -3254,8 +3249,6 @@ static int mtip_block_compat_ioctl(struct block_device *dev,
 		return -ENOTTY;
 
 	switch (cmd) {
-	case BLKFLSBUF:
-		return -ENOTTY;
 	case HDIO_DRIVE_TASKFILE: {
 		struct mtip_compat_ide_task_request_s __user *compat_req_task;
 		ide_task_request_t req_task;
-- 
2.28.0

