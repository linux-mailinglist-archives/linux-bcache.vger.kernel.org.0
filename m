Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D146E477A4
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2019 03:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727532AbfFQB2x (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 16 Jun 2019 21:28:53 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:7477 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727515AbfFQB2x (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 16 Jun 2019 21:28:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560734932; x=1592270932;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w3BrX382ONqjIyv6voYA3PkjU3CP+ICuSqh91zwGnoI=;
  b=KXTMPM8glMlNioM4uR4HZAE/K/6umkIQu2hHYPSjkuhYxQW8wIOLXcWj
   2Mh3R2nMfhFv+ypjD5+2NMjq9sD9DSqVsQooV8cps9CGmQyu+waSx0vRn
   0Rk/zrM9hnOW4AdB5DX4wmB8B6YlbVB7SC4ERr9AOik0wUnD0EjaVRqYG
   Zini6D1Lb+xbn96lXLgyD6NJ0tC4EE8qVBMZisCmTL1NdfpM/3RzY2Zy7
   3VRLj8k/udhd2+8/ItdujIG3Rhz09xkjXw1CpXFTx6VodnsBuKgjYRQId
   sZMM7uZL2+cU8x1ui/hsOqcAvl5+GJ2gRczZLhrjpJpuTLVw2IsJSTfaI
   A==;
X-IronPort-AV: E=Sophos;i="5.63,383,1557158400"; 
   d="scan'208";a="112362947"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jun 2019 09:28:52 +0800
IronPort-SDR: +p6jlVWxPMzC3aaKtaO5HCUCkJVzFk14K3BqZeyg+kNORoCv/hGlyQKYQt9lv+TbnJBVJy8D3T
 PbCVyWXcUcJWFGzPm/J9GYJvRHUh8bfv2qPLnvZhkJGUgB+fuFUZBJK52jnfAHL67ikCZ3anPK
 Xt+ciGdiBhWe17ZLVVhxp/+9omneQCgyoSGmt3zN4phlU8o/iM7m37aThvQSvRRi6kZX5nV/GU
 X84ZVJwmCQEToX56vKt7lEG+GgDDSax4YlUhicbdLdh8W0AMFjdSflaWWR5ET6X9q5W+zvvbvj
 xXIeZed+wTq4BuHpcjuRHJrj
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP; 16 Jun 2019 18:28:30 -0700
IronPort-SDR: IfovImoA+4EY5/NblvO2tIpoYAEUdMS5cjLbSWsTG6tAM/VwLo4pRUOFcJlpG1M1X/s1KRZvCc
 FViDhiB5ulqJYx3EvhpAXPb9LF3ewt89KWiCdN5NjmW+bRtnfSJeIh0gIQo28U4Ic6Cb/IBev0
 DiRwNG+TRVQl1Pdgdnn1DGg5I2c29KacTy97iYofsoKE/E3rgP/CNSWvDFR65nuOJUCz9zYGf6
 4efGNV5Ug0ftnrfoPQGSHrqcqlQwn/7qMh053FnmHg/zTZc13jaG39OLZOhAai1RA5ZSVeD55T
 0Co=
Received: from cmercuryqemu.hgst.com ([10.202.65.32])
  by uls-op-cesaip01.wdc.com with ESMTP; 16 Jun 2019 18:28:52 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, kent.overstreet@gmail.com,
        jaegeuk@kernel.org, damien.lemoal@wdc.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V2 4/7] blk-zoned: update blkdev_reset_zones() with helper
Date:   Sun, 16 Jun 2019 18:28:29 -0700
Message-Id: <20190617012832.4311-5-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190617012832.4311-1-chaitanya.kulkarni@wdc.com>
References: <20190617012832.4311-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch updates the blkdev_reset_zones() with newly introduced
helper function to read the nr_sects from block device's hd_parts with
the help of part_nr_sects_read().

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 block/blk-zoned.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 9faf4488339d..e7f2874b5d37 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -229,7 +229,7 @@ int blkdev_reset_zones(struct block_device *bdev,
 	if (bdev_read_only(bdev))
 		return -EPERM;
 
-	if (!nr_sectors || end_sector > bdev->bd_part->nr_sects)
+	if (!nr_sectors || end_sector > bdev_nr_sects(bdev))
 		/* Out of range */
 		return -EINVAL;
 
@@ -239,7 +239,7 @@ int blkdev_reset_zones(struct block_device *bdev,
 		return -EINVAL;
 
 	if ((nr_sectors & (zone_sectors - 1)) &&
-	    end_sector != bdev->bd_part->nr_sects)
+	    end_sector != bdev_nr_sects(bdev))
 		return -EINVAL;
 
 	blk_start_plug(&plug);
-- 
2.19.1

