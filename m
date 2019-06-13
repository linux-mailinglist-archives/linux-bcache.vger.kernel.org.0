Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0676943799
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Jun 2019 17:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732851AbfFMPAS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 13 Jun 2019 11:00:18 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:40654 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732593AbfFMPAR (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 13 Jun 2019 11:00:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560438018; x=1591974018;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wytOX56Llp9R5Ix3gmRA1mJrjb5IFGndC3dWCSN9gqw=;
  b=CSf94yE/LqyLoGlHolaDjC3Ejo4T/sKcVR9mJq7p8HOXhurYtwNcz2q0
   lFNfhaaSJzqksse40XT65jtkgHGYllv3IkSe63Mm59XjYVu3wINCnPSjd
   t5HbIpPZWYiItjAG/cH+665ogIvg9xmz0JwgPmdD3/HWUGdjPPF+MiF5W
   54bwBFu64UqT/6SKiHQstQHX3LlK2O10SJVIfYiCF+MWM1iUkFglGkvDq
   OgbqTe7LsmFpWuvh5nBJy2iyrN7ctvK238PVgbHGiuvb5jgEgGBTrdmjL
   GqwkzGcAL3dSNHIpzvb/msmUNyV6x3c3vFJt8cPzq0IWtpqCMvOmpETLY
   g==;
X-IronPort-AV: E=Sophos;i="5.63,369,1557158400"; 
   d="scan'208";a="115418364"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jun 2019 23:00:17 +0800
IronPort-SDR: ckkFWwonagJQN6zgOClvBDRPOhKsXo0lAZp6tAvcSLXHqkbfOFw57PbxREDWw9LEUqIHYg0TnH
 jPhRYs7T5m1uZEmUJmVlCpqAGd3DQNrFOxxLJ3NWBscmNYhzi8yfhpU16mbU/rD5WiVcqzHVG3
 EBDwHfWbuxlZ9892qlOOukmsmy2HCduB8XAymK4LyP0ZtrIUcqzUmgw5Zo4bzWAT8/OpHv3/3R
 CerhOWvTo7xoFSEwsQgBeS5gbMBDUh9dZUiOg10sq5LSEJT6KcFYka4AtDd6/ht0ngZ8dJtaMo
 I8dMyZ95xYa8MHbXlm/TOXD7
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP; 13 Jun 2019 08:00:00 -0700
IronPort-SDR: 1nJW5aoBERQkIvJHOBaJModWGHLvHv3vgNgcRiAJIvPKseZfoNvls22FiZyso6lAZ/l2xj6so5
 tguAjAWysrzL6gsqdqjIe/0+fMQP8wSLxDbnaZiApzOFZUjHeiSKE921qR0B9eAHiupuFlgkVt
 BWdlcOn48mSWg4t4NCwgETJDmOBVbi3jMjZavjgoVLWdJIVjG5LxWvSdVDTt4FfInTXvOJrSNQ
 D6z9ugnvobWx8jw3zScv/3IVW1YehiPJpj+9A5x2yxEkLo1dUiTYM9cUZ3mmaWp3e8YVpvxInz
 PA4=
Received: from cmercuryqemu.hgst.com ([10.202.65.32])
  by uls-op-cesaip01.wdc.com with ESMTP; 13 Jun 2019 08:00:16 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-btrace@vger.kernel.org,
        kent.overstreet@gmail.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 3/8] blk-zoned: update blkdev_report_zone() with helper
Date:   Thu, 13 Jun 2019 07:59:50 -0700
Message-Id: <20190613145955.4813-4-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190613145955.4813-1-chaitanya.kulkarni@wdc.com>
References: <20190613145955.4813-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch updates the blkdev_report_zone(s)() with newly introduced
helper function to read the nr_sects from block device's hd_parts with
the help of part_nr_sects_read() protected by appropriate locking.

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

