Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22252A14A6
	for <lists+linux-bcache@lfdr.de>; Sat, 31 Oct 2020 10:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbgJaJSA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 31 Oct 2020 05:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726499AbgJaJSA (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 31 Oct 2020 05:18:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3E8C0613D5;
        Sat, 31 Oct 2020 02:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=QiPy3Lgic6nDpUFxJOfw2mawJ5uhHq47Zrqs9uu41iQ=; b=gsAsqe/HGXmFvNBDIcqnTyqeSv
        /+fW7OH+gdIj4TucEQO+LoO2ozVQ+EVh7iYOD7kLiyplBB1e430DA3owtMUjzhWEGI0GX2oArMOP/
        AdvpDzoM3UZUYfwicg85oLsBgjfn7bGXJrWHXfCjHSAfIVOQvReCvVgL/Afwn5SZdqoKHn+ZMpL8n
        8tgIxQFnMCFvDXOLSz/5Wtye7yWjLtbi+RHFWWSX2Utw9cxWuQfgZf+T08/ZxUXdTOIu8gj5kuVbn
        hq+cIJdBMTO7KHleVianKloWF7X6KmM8BnNOFU+GWyYLaWHYkLjmIulGD9G3dZPNMDPOw5c/deflw
        T80Bh1wg==;
Received: from 089144193201.atnat0002.highway.a1.net ([89.144.193.201] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kYn1G-00080G-Kq; Sat, 31 Oct 2020 09:17:55 +0000
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
Subject: [PATCH 08/11] block: don't call into the driver for BLKROSET
Date:   Sat, 31 Oct 2020 09:58:07 +0100
Message-Id: <20201031085810.450489-9-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201031085810.450489-1-hch@lst.de>
References: <20201031085810.450489-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Now that all drivers that want to hook into setting or clearing the
read-only flag use the set_read_only method this code can be removed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/ioctl.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index a6fa16b9770593..96cb4544736468 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -346,26 +346,6 @@ static int blkdev_pr_clear(struct block_device *bdev,
 	return ops->pr_clear(bdev, c.key);
 }
 
-/*
- * Is it an unrecognized ioctl? The correct returns are either
- * ENOTTY (final) or ENOIOCTLCMD ("I don't know this one, try a
- * fallback"). ENOIOCTLCMD gets turned into ENOTTY by the ioctl
- * code before returning.
- *
- * Confused drivers sometimes return EINVAL, which is wrong. It
- * means "I understood the ioctl command, but the parameters to
- * it were wrong".
- *
- * We should aim to just fix the broken drivers, the EINVAL case
- * should go away.
- */
-static inline int is_unrecognized_ioctl(int ret)
-{
-	return	ret == -EINVAL ||
-		ret == -ENOTTY ||
-		ret == -ENOIOCTLCMD;
-}
-
 static int blkdev_flushbuf(struct block_device *bdev, fmode_t mode,
 		unsigned cmd, unsigned long arg)
 {
@@ -384,9 +364,6 @@ static int blkdev_roset(struct block_device *bdev, fmode_t mode,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	ret = __blkdev_driver_ioctl(bdev, mode, cmd, arg);
-	if (!is_unrecognized_ioctl(ret))
-		return ret;
 	if (get_user(n, (int __user *)arg))
 		return -EFAULT;
 	if (bdev->bd_disk->fops->set_read_only) {
-- 
2.28.0

