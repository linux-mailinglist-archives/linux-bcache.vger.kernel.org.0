Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6771D62896
	for <lists+linux-bcache@lfdr.de>; Mon,  8 Jul 2019 20:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731260AbfGHSre (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 8 Jul 2019 14:47:34 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:53018 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbfGHSrd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Jul 2019 14:47:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1562611676; x=1594147676;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=/pc9L2crAxHB7hq+ujlWtvkrNrky6qYpFgcsaAJbQKc=;
  b=XDhUjm7ARMF9mIOlWFqiSlNvlT3Gn/qwEhpPfm39QDqFQBR2fk5zmWAD
   204hrAGCWfu5ECYRHJNo15iSc02HhqXRO9Bvz4/iO8B4Ex2e2WmBALWCS
   wxbDMG4x7+POxh5y7Oeu7oH9n/kf7P+8XMcHqeXRRDSaXr9EEKsrH5HBW
   mc8jUU7TI654b40zS7OgudErXexvU3sovAujKm4OOcVs1IffoG2mtCaQi
   sEv/WcSHjtVJCHtDXANus0rkLaTNX7bGEfmGBAwIBI9okh6kp/MpuIYZh
   ZqGRS17FUIEGFcNaVRgBHslLx1NDC53TQ6Lzc1wyQJkJ7gbFIh7IybKHc
   Q==;
IronPort-SDR: +YoqlgSn+nVgeprFGrFWPEjgc3vh4ceAPdDE8HEYzdSeZtVqSUN1Ttxc1vW9daizoRyOpfFDlZ
 nEi/IvvwTCK3PCWgQJiSAG6kOAyhOIlhlpau/FTIvymDWxQOk1KYwwEHIY9pbU69PUI1Hg0i4v
 puogyiseGfyupGZie3Xh2gdm2ZU4g2jkiMlZnvbZA0x+U6efvyGL0QxAsH6TwZJkIgsMBSVJxM
 TIEifvGav6ey7UyvtTUTEF/4JZMc6WQc2OHueBPQDW1u+LwiRFKaqmHbAljHfPpCkYFSEHutnP
 21Q=
X-IronPort-AV: E=Sophos;i="5.63,466,1557158400"; 
   d="scan'208";a="212364709"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jul 2019 02:47:56 +0800
IronPort-SDR: WALF5Wta2uM0vvSzAZjy62hfnofdTsrZH95OoeU7J2apaoqYpV60biSvUInU2Ao/meqhgZkyYC
 uE9TK5p56wnAR/YTpF/vGvBH5vGGSudFiE5D9ycxU0/B+bkqOwOT6NzeTIg5I6Zl+E3QbTJNbw
 nHao0UbIY7xyM6atnDU2zGROSZM5s5kewEgFCikxXklAjNes9dlXRElXHB8pWhUaqEh4WgVl7O
 lYiDcRVLmf0Sh037oMKpkVs0UmDLUWAjoPd6v4E4Vy5CP9gCIxegJcrUPMzAWFl2kIAt6X9GA6
 Otq6Eo+9oZTbSVQXRnaiJUmC
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP; 08 Jul 2019 11:46:22 -0700
IronPort-SDR: jWdfh5Z5t7pjUC0B9fFgAyqOLuJnVq8Y8Vuwuw3p7a+MWysaGbZwoaQwzshB2rHxKcfqUwLipY
 XVsaf4oWX0EjvpBNWkaZZfPekQOryyganAT5TONr5hleW1fklSNaogTOGJf93qqApcdI8fz9mz
 KfZHtl2vopgSzLQ1sb5TTaY8qXUFTJ18FRvM4b3y9NCSYdEddF3MpV9glHcmCofAwi4dZkmIVC
 gaihu23gkcHfYLTnJNU0ZelUPMn6wHyW13Dx7Ze2Ij6N6zfOw7fSaRbNf+nH3JXFZwBS4Rrg8p
 HLQ=
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Jul 2019 11:47:33 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V4 3/9] blk-zoned: update blkdev_report_zone() with helper
Date:   Mon,  8 Jul 2019 11:47:05 -0700
Message-Id: <20190708184711.2984-4-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
References: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch updates the blkdev_report_zone(s)() with newly introduced
helper function to read the nr_sects from block device's hd_parts with
the help of part_nr_sects_read().

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 block/blk-zoned.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 5051db35c3fd..9faf4488339d 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -106,7 +106,7 @@ static bool blkdev_report_zone(struct block_device *bdev, struct blk_zone *rep)
 		return false;
 
 	rep->start -= offset;
-	if (rep->start + rep->len > bdev->bd_part->nr_sects)
+	if (rep->start + rep->len > bdev_nr_sects(bdev))
 		return false;
 
 	if (rep->type == BLK_ZONE_TYPE_CONVENTIONAL)
@@ -176,13 +176,13 @@ int blkdev_report_zones(struct block_device *bdev, sector_t sector,
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
 			       zones, &nrz, gfp_mask);
 	if (ret)
-- 
2.17.0

