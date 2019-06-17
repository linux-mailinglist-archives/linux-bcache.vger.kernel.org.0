Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05F43477A3
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2019 03:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbfFQB2u (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 16 Jun 2019 21:28:50 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:7477 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727515AbfFQB2t (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 16 Jun 2019 21:28:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560734929; x=1592270929;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KhPmEM2AXyHo6PBofKblkM2Y3DIiKG3VMw18OQzTeBk=;
  b=p/AjXauHmoHQ8GlciRjHf9eduSj09HAoPh/EQe+V0m6pfrQTSkxB5+KH
   wA+1FrMBNAthC6JVneWExcxE+7xkVS5EpsREPxENXNhP55nfWgu/bJYM2
   YAwtvHQlBV6qvHU3zZoCvThR/jMXnzz6+ANTnyq374uE+joWQJ35acuH5
   G7Phj2r6a/1yN9wnEzj8wadYkYiPaIx+NiJ1m7spoKDSvzggFnBcJzX80
   x1oacLh200Sa9S0e4LhBzdIcZcqeIJCFjLmg/YjGyA5r46fxFmx02QTYZ
   dRFw2+R2sP0Z4k6v5bD63XiLFNne3hfrnyLK/AfT/90K9Yd02q8FYM6JX
   A==;
X-IronPort-AV: E=Sophos;i="5.63,383,1557158400"; 
   d="scan'208";a="112362945"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jun 2019 09:28:49 +0800
IronPort-SDR: aXZvKjR6SSoiaxdFXxhdqHUTYNO7UkgLUyfHyyhkvUUKagonSaeuQb4Rjn+EWEs4TnU6xjZ3PZ
 uOEGQ+1GDxk4Sx7i5sk4wFfPg6d8BrOHnLiTKTn7vsryHSqRo/wRTilDXXK+N+tZ9p3ioqtDrH
 +RhRqHDmmtx2zw0PcNkRgy9BPURsY0bQbpmJ3rwRv1CIZul21k0E8h0SdwUlOdXikI/yYCaO2l
 rgjoMo3u0r6ko9Efjeu1eJ3PGseUjuqFDNgyHyOZR3OAJoYh18T+uPYqnhUH5y+44GkJR+byEW
 ufIsGw9zO7jkvD4XIz67Uhr0
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP; 16 Jun 2019 18:28:27 -0700
IronPort-SDR: EoDfZ5yRhfY2S7HtrBxRI1Q1pviY36/tFP7YZzy69c5lph5Vg25HaWLKqm6vdDH2VLA1HakPr2
 qBv8h2jsCA6CZUHreZtBaD3cVgRXwGpApkm9mW+p31cheR4jprmPDN2vB8+lcdqxXXQJqyEEF+
 YsLoBlPRAZ3dp1Wz+xU323klVGFr+q9LNavWYHRo0ZyjhNR5t8MsNni8M2Y+4m+R90nEA6XgV+
 UW/YhCevq9Pjn2FSCt3pLrM6RnvxpS7NrryGUYwwqJ3mnOFOIcShRqWb9el61hcvQGYDIlEAN3
 HKc=
Received: from cmercuryqemu.hgst.com ([10.202.65.32])
  by uls-op-cesaip01.wdc.com with ESMTP; 16 Jun 2019 18:28:49 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, kent.overstreet@gmail.com,
        jaegeuk@kernel.org, damien.lemoal@wdc.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V2 3/7] blk-zoned: update blkdev_report_zone() with helper
Date:   Sun, 16 Jun 2019 18:28:28 -0700
Message-Id: <20190617012832.4311-4-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190617012832.4311-1-chaitanya.kulkarni@wdc.com>
References: <20190617012832.4311-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
2.19.1

