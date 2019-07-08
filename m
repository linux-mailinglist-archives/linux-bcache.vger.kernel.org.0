Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 264A06289A
	for <lists+linux-bcache@lfdr.de>; Mon,  8 Jul 2019 20:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388703AbfGHSrk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 8 Jul 2019 14:47:40 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:33586 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbfGHSrk (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Jul 2019 14:47:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1562611660; x=1594147660;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=TRJ5mIHEpUFUMoE20YZUADV3tKY+JE58H4HrPBkkQ1M=;
  b=RRemQHUudUe9qclr4zzg/Lb7ptwYbqk5TfKSYFkWEs55hkaPDPZpL7lS
   26krxYahP7DQKKEij8rfG2AQzRDZX+vAG6hJgcSDg4JYIWSEbrE7XdTmX
   l1K3hukRf66zf0HxA35EnA0CpWSIKiv3pQExJwiy2wd7Q/X85FOUPR8ju
   czuTlLHWcBaNmi/peJhCEmCgvR9E5R6JvNlAIH/wUuAe1J3dwK/kHYklz
   prwwJVloT1ek3K9eEqD+6E/5ZwUBsHw9lkhFpzVQSHgnWfI1HEjO0d68I
   pCLz08nHw8etjMEcxmCJdMEcuwNt+aT94pWIN6Y8xUA5B36+0M6b6figD
   A==;
IronPort-SDR: DfrIdr7QJ6OzXXCwjrQqqEU+6tlfn9a7aBPVaF++1ZxdPP17MGD0fELYVbrZkxdKKeY2XccfnD
 hqSpDxOrxisPUq9TF8KAqoS0Kpb4FST26Aq267Y+qcgxleVqZTgA6Ol55LkvboO62ZjZrp0mhj
 yb0wwXVmVPHM9iRQpGyzDqmpr0EE7zLtND2mhiSvvE04pInYuHFIPBuHbLgNyNieMP8Bv825ET
 oKgIF/pTnYKDDxOypuYq4BfZ8DejQekDtGrfzhGOVAcRFk17ARal7GQIrKFsJB//tUztPqjkRI
 87U=
X-IronPort-AV: E=Sophos;i="5.63,466,1557158400"; 
   d="scan'208";a="114094107"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jul 2019 02:47:40 +0800
IronPort-SDR: lGIQObP1a+qmj+55abIf0fPEnQjtC9d9i9VdvH5p4YQuhlt6/0h7eN4GvOtfGaRpxxUEYkrqOl
 6X+agu3Ntxrb7OM4h1GDtMNYnBrajlqvQUBW1dcLl6CsUHI87wvVX1WN3lgopOuyEiJu5sqtUF
 jMsXQhYsAcGQqiq6JMF8XvEBQMqeqa/kPG3RSNbqZctvSLmnjoirLESKKx3volDKXCaqWDNsOT
 /JjF9VLi5jhjbE9JMCFEKd20zw5JjCmW4Uf4B2eG7ARcmbs3uR4M5tHsLgp+tbCxHzwePri/DA
 bHR/PwDoA9YtR3UMzCVy1wIz
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP; 08 Jul 2019 11:46:28 -0700
IronPort-SDR: e+wnXG2Mz3gtPkzW6JVqDomjkR+WsCClgTYVA68ZPRVD1/JbzvZKAnfiawuajy721alH/4cYAz
 83R6mt/izAcA3wYqxabLbqAjyVd0jNtKCxpgAgTCPzpasYEs7lbnvuC3N4aFMecDj6sBrnSifF
 82Ij40bI/YXlgLYOhl/4Oh93z3ngwfXd/OnW7O5HcGk/NS0jd+rAtkLqTzWO6jaL9i1E18+AqJ
 7S99xr7IczGeGB6g7ryoF5o2/SFFru90R9W1IEnAhWc+kyfKs7iZ6KzcqN/cZ5rpgMFzYrCS1q
 EiI=
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Jul 2019 11:47:39 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V4 4/9] blk-zoned: update blkdev_reset_zones() with helper
Date:   Mon,  8 Jul 2019 11:47:06 -0700
Message-Id: <20190708184711.2984-5-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
References: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
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
2.17.0

