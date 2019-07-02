Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0B285D571
	for <lists+linux-bcache@lfdr.de>; Tue,  2 Jul 2019 19:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfGBRnD (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 2 Jul 2019 13:43:03 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:35981 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfGBRnD (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Jul 2019 13:43:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1562089383; x=1593625383;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=KhPmEM2AXyHo6PBofKblkM2Y3DIiKG3VMw18OQzTeBk=;
  b=Ug4TLqxC0KGVG08uDgbCrr0hexkMv+2w6c9iobsMfSX4QGa8UrH7CrhD
   jfHtfuh0BBR42AWQHfvywigpYiZ7ptFqL8LLwIfWLjqbbE8M94lPrZd/J
   ib/SjfRnoC/tpFVfFF1BV0GFDOtwESfLSNJmr/EtXlMJdVMca7MkK7Wur
   1Ukc0UMYAIBo38qxHoNjsR6mAOxf1bigGMSGkOlrNw7nqC0UUEoZEIQM3
   iVdssbQsigrUSH+wmGhEXhRu6M5JBeD4/SpW7C1sWPyijtaqs82cCoO+J
   RJxwGI6nRZRmPbaqqv82F3zBOCAJVXElqCa2ok7eHUAXXtfCo/2s/fRvf
   w==;
IronPort-SDR: Yjl9CEGFlkZmOZDGAJ6xa26XG05CCTsozXp47lNOPXuOdX9nVsmLVl2//7kZQSE1CeVVrrpTPX
 mBDyVf2mWrkH3+WvTgO+gjzB12XV5e8/M2U9o6pOd3s1dq30PfFs73c05JKdghRdc3uv4D6Ulc
 aNRcKJopq7vMx+7V0jz/ju9/lMqHNiXnUuC4GwhVONXfvfagfFHIrgdNAwdwlLcMvNsIwl5dfF
 OA/ijN1vx/nPPCgjHqdtuJteWw5S6z9l4sEyy9Kn28A2FDboiSxr5c3yHh6aJPelty0Jbfgi9N
 TTQ=
X-IronPort-AV: E=Sophos;i="5.63,444,1557158400"; 
   d="scan'208";a="112068337"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2019 01:43:03 +0800
IronPort-SDR: fNa+i1iDFsNKXiyxjUp+ceLJnaKP5KTzBav/XIz9Q8xbn73GG8hrVSNxAjzHYVcd0rkcCJxFcW
 kes2Mqb5NEbtIDxT5SNeFQRm3BiKD5oSpr8hvvW2v1qo3dMTRAgc0qMtuK0Kcf3S+I+ZDD6aFR
 tzss84GsayDNozEoaqBvfG8A9M1qlAhMetKgqKHPvsogAWwngjHCKzZONVqupRHv2g0QvbDWv1
 BnDU61wfFBXQ44/DDDTwP8yYuqOQNvp98kSsK9jBBQfiW8NaEnOZNv1Ja0KcDcAmfhDWfzoave
 EJ8SgroiDx4vzR527pHVaZG4
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP; 02 Jul 2019 10:42:05 -0700
IronPort-SDR: 6aWxaTBrk+Kvq4wIRr/d70nXsFtKx/h2jTgYTYDzRuzGUwI1dcEHM6gt3ZHnktHhEjb4/JCped
 7e+xcGWb4ezwmmGHsb8fy4es9zxYPMfyLKqFtHBs89QcpmRPHcClv/6L9uTwE25km1MSTeHUNh
 QXgH2y1PN79zjwD/6RQNH5TySuXd3fIM+krOne5dzLallo/yzl5xKvgKrBEtFd2qULXFTmMcoJ
 4llbiUV8AaOXSwXTCZ4YfFaNEH7P4FlfrSIC/kH4vx7TiGF3X84yZ+VK0d22WjDH7jZa8SWEP6
 qVo=
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Jul 2019 10:43:02 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V3 3/9] blk-zoned: update blkdev_report_zone() with helper
Date:   Tue,  2 Jul 2019 10:42:29 -0700
Message-Id: <20190702174236.3332-4-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
References: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
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

