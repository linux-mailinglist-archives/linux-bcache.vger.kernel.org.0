Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1B82A976D
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Nov 2020 15:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgKFOIX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 6 Nov 2020 09:08:23 -0500
Received: from verein.lst.de ([213.95.11.211]:51694 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726812AbgKFOIX (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Nov 2020 09:08:23 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 59BF668B02; Fri,  6 Nov 2020 15:08:18 +0100 (CET)
Date:   Fri, 6 Nov 2020 15:08:17 +0100
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
        linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org,
        martin.petersen@oracle.com
Subject: [PATCH, RFC 11/10] block: propagate BLKROSET to all partitions
Message-ID: <20201106140817.GA23557@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


When setting the whole device read-only (or clearing the read-only
state), also update the policy for all partitions.  The s390 dasd
driver has awlways been doing this and it makes a lot of sense.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/ioctl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 6b785181344fe1..22f394d118c302 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -354,7 +354,10 @@ static int blkdev_roset(struct block_device *bdev, fmode_t mode,
 		if (ret)
 			return ret;
 	}
-	bdev->bd_part->policy = n;
+	if (bdev_is_partition(bdev))
+		bdev->bd_part->policy = n;
+	else
+		set_disk_ro(bdev->bd_disk, n);
 	return 0;
 }
 
-- 
2.28.0

