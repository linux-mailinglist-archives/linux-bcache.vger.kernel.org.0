Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA3DC97201
	for <lists+linux-bcache@lfdr.de>; Wed, 21 Aug 2019 08:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbfHUGOs (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 21 Aug 2019 02:14:48 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:20504 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727481AbfHUGOr (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Aug 2019 02:14:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566368116; x=1597904116;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=fAftc0jXLF+PYgBKMR7sJr2letplG8FiARgg+iOt4Mk=;
  b=kPHet30HfrnzDMW2pcjrC2T1a7czFNn7aTCRU33dtJ1jXIRv6s+/MqHv
   o6xg5VCIKrxR1wR4wMTwqP13v0ty2puNFECEnIk2SXcGi1MTKQB9cQZTk
   +J0UZICLwrFeGV3vimQjTf32CjTQD8otI4B6/dmvz55ulV7OQ9DNlD1pJ
   9lKE0KAwrW8YvnnVE/13vBeNwraFBlMN9Gm5nXckQdQnmZ1VVk1rb7gXF
   yxdz5AotKrJkdWUcVV6W5Gs2+/8eCYfORNIlZLAG8lMDmV3ovNBDZhyyp
   i7mY/AJhBF5zGTMN/CDGuLwLJkEm3+z5S/jkEMXdvF7juZ3YqmS4o27N1
   w==;
IronPort-SDR: 8T22Y9rgiAC6W1kZwtmuWZNBPuma1XW5LZasuTnmeuLpIrqQW8n/8hHfq9OYUK52t7cq9pDaIq
 IaDXrjn1RsCxh0OEZM4L4gCsQYSSI7g/sdXmV6h5BOQLIontqJ+FvCN2ltfOqp3pzeon1AwhdF
 JXdXRT2JWVoqF+p96xAphfi6z4lRmuMVBhncHak+GxeHrH8NZlaGiUn0ZjVoxaAncIKRhK/pfY
 MvY4NbLZ7+SfWMTiGv646IFhj9vd1HLXbkjQvAr1Yd0bsUcDNwiHcX/ehZBBBO34LfucQf/gDk
 +6c=
X-IronPort-AV: E=Sophos;i="5.64,411,1559491200"; 
   d="scan'208";a="216721083"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Aug 2019 14:15:15 +0800
IronPort-SDR: BNUaaEfCWLEk1cprItBV73tnJNQuJC3CZosVgRYFUeUfk3LCNJiCfff42GFeu5TVDHE5AP43yH
 rDVkEtbZbN9DR1s3ruTNFcbjxBENdRDHSTei0YDZmnucWqVb4olQolFFONROmU/yDhrsEE+T+y
 QxgJoGW1oPLWluAuePh8d5231fmy8XxM24g7qw1mXh4G2XtHQ0u2mP+X/J/cRiUpexLjdHHESz
 2ogoS6HDjUJ2/N7RArr1xX77gAlGfMz1+XWapPmTH6uMNZojftgMfBO8ILsPqvzs2KhOzxx8IE
 qRZaiX5T0RpfV4VwIEM0P1fJ
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 23:12:08 -0700
IronPort-SDR: 5VdlNZVMNPdB4YJKi8PvEuaTgpLYyJfh2G/rBJ/AFXXZQlCBvtiNoYa7ESeeEq6JoKhDakQyQ3
 bzj4rf3rS5gKcHvy0LSRr1h325MA8E4vMf0unZpmXiHbj6LGx2U6Y9bgmSHdFLKdRjPf4RGA9+
 HwIzbBlZS6rNLPIocY2VAP2a1yR7H1bp99zjaHM6EqIEWm1ysT1yq9XJYu1XdiXk7/3pAgpb4V
 uRKAxSzSii+HX5bHYsNUptuuDX0oQ0jdvrOp+F5m95Slc4aGqzUCOtNlfEJhQ7uyeuvqUB4rIT
 KXg=
WDCIronportException: Internal
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip01.wdc.com with ESMTP; 20 Aug 2019 23:14:47 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V5 3/9] blk-zoned: update blkdev_report_zone() with helper
Date:   Tue, 20 Aug 2019 23:14:17 -0700
Message-Id: <20190821061423.3408-4-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190821061423.3408-1-chaitanya.kulkarni@wdc.com>
References: <20190821061423.3408-1-chaitanya.kulkarni@wdc.com>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch updates the blkdev_report_zone(s)() with newly introduced
helper function to read the nr_sects from block device's hd_parts with
the help of part_nr_sects_read().

Reviewed-by: Minwoo Im <minwoo.im.dev@gmail.com>
Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 block/blk-zoned.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 3f5e9bf03486..7e0c0b54d194 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -109,7 +109,7 @@ static bool blkdev_report_zone(struct block_device *bdev, struct blk_zone *rep)
 		return false;
 
 	rep->start -= offset;
-	if (rep->start + rep->len > bdev->bd_part->nr_sects)
+	if (rep->start + rep->len > bdev_nr_sects(bdev))
 		return false;
 
 	if (rep->type == BLK_ZONE_TYPE_CONVENTIONAL)
@@ -178,13 +178,13 @@ int blkdev_report_zones(struct block_device *bdev, sector_t sector,
 	if (WARN_ON_ONCE(!bdev->bd_disk->fops->report_zones))
 		return -EOPNOTSUPP;
 
-	if (!*nr_zones || sector >= bdev->bd_part->nr_sects) {
+	if (!*nr_zones || sector >= bdev_nr_sects(bdev)) {
 		*nr_zones = 0;
 		return 0;
 	}
 
 	nrz = min(*nr_zones,
-		  __blkdev_nr_zones(q, bdev->bd_part->nr_sects - sector));
+		  __blkdev_nr_zones(q, bdev_nr_sects(bdev) - sector));
 	ret = blk_report_zones(bdev->bd_disk, get_start_sect(bdev) + sector,
 			       zones, &nrz);
 	if (ret)
-- 
2.17.0

