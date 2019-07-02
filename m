Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F57F5D574
	for <lists+linux-bcache@lfdr.de>; Tue,  2 Jul 2019 19:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbfGBRnN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 2 Jul 2019 13:43:13 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:21381 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfGBRnN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Jul 2019 13:43:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1562089393; x=1593625393;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=w3BrX382ONqjIyv6voYA3PkjU3CP+ICuSqh91zwGnoI=;
  b=d2XsBQObSu2aqhe0KXX8g4JZ00dUjCzRB4d4cOeK6Joa7WddQ4tHLRRe
   uhtvKFx/h8CrkrV58RauT77oXlGK4uf2yI/r6SdaNDpR5ax8tN9qH9lbQ
   z9H/k+dZcfK0GFTvs1c719MkEHP29kzq4dNXi2+TgcPlA8bqCjwXMKaa7
   Ah1wzRXhgnKep2ZdDq9FqRbXf8RQnl9UXoEEgjoDP+RE5yRXcdJ28NqD0
   /q+wclz4g3nNslG1FTrULdcLzOaqWQ9B6hjDogkofimh+RC68PiZCBQ5k
   JsN0bDdVAfzXxmtXAj/nsKR8S9KVsWZd+jMgCJFCswfIPrRm739hMLO1K
   w==;
IronPort-SDR: kQHWdR6+BzXWiMW45h0wwNnqiKWik8ExH/krQ93rCqgbX8JJDEKiY+6HcOGSX9KhDZ2y2HGaba
 KWgHlN8QOpzyhUsRnXpJbcIK3SEdUJ0031yFZDJZKhEfsEdgGQKccGoMLlCO6KxUI3cjTBVsqY
 PA1p6w6MtnICQT2RttMX1pn8gHIeFwRXUmG6eJkZKx/oyrY+OdEqOgylVxSJhew7s9182o6CUf
 HfXgBQ/4T+godoXJiYLsoyng/yLLswPW9H/q01zNfWxv24zvDd1ADs85qN1PeT7ZorX04mxShP
 WY8=
X-IronPort-AV: E=Sophos;i="5.63,444,1557158400"; 
   d="scan'208";a="113690575"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2019 01:43:13 +0800
IronPort-SDR: wv0T8P+g9Sk6hQpSfIyh4vRWZSmesrOA6O5zLHDLHCABJpMYxI1Uf1nOFyMLolISxYeNFdn15H
 ftCsHuPzKDaZXsUTIVmoAjHk+1gyX7iXFJVyd/dFbhS4aTgx5MWEeZryQttKO2WmT6eDYmxUZX
 aZ4AbF6HYQBtKNoF2Y9NvWQFSYvkgGE5j5wBz06Q7T1aYzpRByeff+F6o1MwluI3n7AZmtHu2F
 FJJqOX6He5GO2d3eT6LwOn4H+EcuFPZgXUmguLJK1oTgfDHaoHIrTq+qlNzu1jfVCOlB4Vb/Qq
 VKFGVDXAmQW0TJLjZzYxSrrj
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP; 02 Jul 2019 10:42:14 -0700
IronPort-SDR: bTE73XoebtSY9BFEdgIbFq66JMRK553Gy4nlPM/489RzJLQKSuFC647ZNCgK6Pe5K2acESKa/v
 GSyMegt22LTGo7l8BRZPNNAHwyUWFfcwLZUe3SLCb0DC8tf1ksFmAOjIdeAxS0flNdl1Vpk0Gh
 lMrR6oroo8tPU1xiW0Zj+Yxt+Jry2cgDdCY4nPBcevgpALqZulp9n3CuGosdEVbiHNDUItK2WP
 v3BZh8J6bSN6Ou8vYXB9xka6wKDRw21EZx8JHyPMbb3NO9B1CD5BW+/c8McPByloJrrt7CVnbS
 N1c=
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Jul 2019 10:43:12 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V3 4/9] blk-zoned: update blkdev_reset_zones() with helper
Date:   Tue,  2 Jul 2019 10:42:30 -0700
Message-Id: <20190702174236.3332-5-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
References: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
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

