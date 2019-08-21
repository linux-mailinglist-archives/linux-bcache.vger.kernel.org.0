Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4075F97207
	for <lists+linux-bcache@lfdr.de>; Wed, 21 Aug 2019 08:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbfHUGOy (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 21 Aug 2019 02:14:54 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:34533 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbfHUGOy (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Aug 2019 02:14:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566368094; x=1597904094;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=dNQR+/WArddUJx9huMcsBlSubmN9JNdoAJJzC4US2gU=;
  b=O1RAlnrqTa23+EExriBZd/Ie66s0TTz+kcVcerKbEmRK4q04pL6n0Fvv
   LOMisZ8WpGklLxwVLqHd4NYnNVD2noFkxcqRYTnnb5FCNLJvdQ9kyl6Fh
   BI5+1Rw6fhkmNU74Q4dTsdYOA8i1Wy4763q66f6VLY5CfWAoP8avgg5+K
   stu3WHV+9XlEoYcMB5mr3yErMzWucbyuXyFcEPdvgJ3ZuRT/P67Ze1ANg
   CSjXIjUvNrC4FjnKL3l+xE2GuXeFNSGymxFKvNT2THK00zalrPp5ab0rc
   eQK6RF9cf12N0vFLwyEYtbV2lL8549GbMYwR16M1xP3ntjAtlJlReA63J
   g==;
IronPort-SDR: QtPJnJEUbx9FyxTGFGOQ+28+nywff34iJ50uyvjsSM+dAALCLhx1YBAwKxW480va++DJow71/H
 5BXDvhm2akWvLtP2cvfGftQCXA2jAAzBuVyrQkycVQKRZYSw47OH1AMCeHKzSbTlD9uVpHGOVP
 sZpFJtu2vLIfeYZ3buMyaUwRBFtjaZEmQkj2635fo2//8AZo5QxzecPrFXPnCMwr3vvGKg0B9n
 FqoSAD9kLE65nBH7gfax/absNpiF5G7NVDq3I7rnA1HtfhW73i1mU49EfNM6ll5YxxrCnoOqf9
 250=
X-IronPort-AV: E=Sophos;i="5.64,411,1559491200"; 
   d="scan'208";a="117904699"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Aug 2019 14:14:54 +0800
IronPort-SDR: RsDDRzmt1V+Zcx9sYmP64LDNWh4yP++YbAbng+qoqCtH/U84XJhiwvY0WSwveCSDF/B+cnZ9V/
 k05dyuClQfjODaNUzqbvYaupvO0LGN7GofrgiXs7yrHH6PcGYLAnuzrv6De/vfjD76Uw2IPaTV
 ZG1D3T0p0QVfqkxmIS3h+uNLFSWW+HPJZsWuzxzHbozzxcIPjwadX9OakhC3PAT27RK40fz550
 wLnYTJbSn+XWPeBMDuCucgb/cAL9Qlt1B9s9T+MKeH09gewmhjD6R7RvOSnNPKgtdKYZGgywOW
 09yrW0DMcrrXeVQ7QKDW15LI
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 23:12:15 -0700
IronPort-SDR: WGDSV7zozYwbRlbZcH9Vsh+dYPGAeQLVyYHbXF8UemtuqeBj1gbc3L2/qhUPOCHpvgps3+qYTw
 6KCzf/ZLXk78xFV6cdmLogFtTGmboLlw3XK2ceoI6b2c+M7ALIPJEQThmicDSyitL7i3yOytT1
 v+4Y82D+aKvlSZujII8U7Id+Kevc5LUiaZ6XBwmp2zgzzCpxiE2eRE2BNPGklnoPiudQmcQiOV
 UcqacoGyWtWWVgxu10FPvyFGi3BggvrpIAb2Pyel4K/An3TBhmBU9rAfhfEJ4/GlAyYSvjR3bp
 +mc=
WDCIronportException: Internal
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip01.wdc.com with ESMTP; 20 Aug 2019 23:14:53 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V5 4/9] blk-zoned: update blkdev_reset_zones() with helper
Date:   Tue, 20 Aug 2019 23:14:18 -0700
Message-Id: <20190821061423.3408-5-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190821061423.3408-1-chaitanya.kulkarni@wdc.com>
References: <20190821061423.3408-1-chaitanya.kulkarni@wdc.com>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch updates the blkdev_reset_zones() with newly introduced
helper function to read the nr_sects from block device's hd_parts with
the help of part_nr_sects_read().

Reviewed-by: Minwoo Im <minwoo.im.dev@gmail.com>
Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 block/blk-zoned.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 7e0c0b54d194..53f9df376cfb 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -267,7 +267,7 @@ int blkdev_reset_zones(struct block_device *bdev,
 	if (bdev_read_only(bdev))
 		return -EPERM;
 
-	if (!nr_sectors || end_sector > bdev->bd_part->nr_sects)
+	if (!nr_sectors || end_sector > bdev_nr_sects(bdev))
 		/* Out of range */
 		return -EINVAL;
 
@@ -280,7 +280,7 @@ int blkdev_reset_zones(struct block_device *bdev,
 		return -EINVAL;
 
 	if ((nr_sectors & (zone_sectors - 1)) &&
-	    end_sector != bdev->bd_part->nr_sects)
+	    end_sector != bdev_nr_sects(bdev))
 		return -EINVAL;
 
 	blk_start_plug(&plug);
-- 
2.17.0

