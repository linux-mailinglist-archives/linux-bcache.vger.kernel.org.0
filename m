Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560EE2A412F
	for <lists+linux-bcache@lfdr.de>; Tue,  3 Nov 2020 11:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbgKCKHC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 3 Nov 2020 05:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgKCKHB (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 3 Nov 2020 05:07:01 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29AFC0613D1;
        Tue,  3 Nov 2020 02:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=i7wqZZpXCL5ORZNGUa3zoAoYso4IoJJ/DeaKvkfVUtI=; b=tCS6bAGllZPJdXICZFJzRDE8P7
        S/mHuEnABdA65SmkJblCu1ugMqDXnOf2cfEIQWnp0W82NZdkZHxR9qQSs0kPgyepufB0elGqTMHO7
        6Cw7sMajjx6y2dyD6+gfflMK7HncupbkudXO9WZU0J9Gu3cgWexvBZ8ZGpzV9b64ZPObhmsxfqcNc
        8mEryycCUva/FkZUuIxD/5JChl7o3KyngNa1Tr/Dmxk53TyHgs6nFUpen7n8Ztsizq7W7qbb7n2v+
        0IXGVLSzDkGk+LEbHyPtQ6HU9AsSRDn2VWyZwJXc7A+o1WxPHSRNh3BAkqXBAePujgWblAFKoTzzO
        KwQjGucA==;
Received: from 089144208145.atnat0017.highway.a1.net ([89.144.208.145] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kZtDJ-0000Ms-0z; Tue, 03 Nov 2020 10:06:53 +0000
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
Subject: [PATCH 02/10] block: don't call into the driver for BLKFLSBUF
Date:   Tue,  3 Nov 2020 11:00:10 +0100
Message-Id: <20201103100018.683694-3-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103100018.683694-1-hch@lst.de>
References: <20201103100018.683694-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

BLKFLSBUF is entirely contained in the block core, and there is no
good reason to give the driver a hook into processing it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/ioctl.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 3fbc382eb926d4..c6d8863f040945 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -369,15 +369,8 @@ static inline int is_unrecognized_ioctl(int ret)
 static int blkdev_flushbuf(struct block_device *bdev, fmode_t mode,
 		unsigned cmd, unsigned long arg)
 {
-	int ret;
-
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
-
-	ret = __blkdev_driver_ioctl(bdev, mode, cmd, arg);
-	if (!is_unrecognized_ioctl(ret))
-		return ret;
-
 	fsync_bdev(bdev);
 	invalidate_bdev(bdev);
 	return 0;
-- 
2.28.0

