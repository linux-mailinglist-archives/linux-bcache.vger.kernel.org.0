Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF298628A1
	for <lists+linux-bcache@lfdr.de>; Mon,  8 Jul 2019 20:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388793AbfGHSrw (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 8 Jul 2019 14:47:52 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:20324 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbfGHSrw (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Jul 2019 14:47:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1562611672; x=1594147672;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=ZoXNFKbL1AElJNl2xVVOKPlcS+hzkE1sUFGwmoc7aEE=;
  b=jbRG2QcL+Fp5jFnzjcQdAUnYW1CqKjw6ZOkIXJsIkT0s9TX9useZwce9
   sEsx8Kn0rUWNNukXBxSuHk77jvK+6WlrREclWLQC9GMMPFJfdYIclTpTP
   6c4WzZkvsONFv7BnVKWDkbJkf2DvfHysIsh8GZlW3uR8nMXGO8RXHs6W8
   BaiddTTv3baHbfzXdnQKDRyoCi8Oz4H50brYghGdC4TNG/79Ce9EYrp0D
   M1iBbK4GdIhkyeC7BruOdl3ZUJtr3SzkDO64ox7AYpe5sMJq3rC4zZ2Rq
   Kb6uJHWhtEPiBm+GXsgSX9AYeEcnDru2TaWPu9vmW/6hZQ/ckNFCyU/rB
   Q==;
IronPort-SDR: 9nXA8Pgj2A5n0AiVpNibIK9TuP7rbC50L0xv80/l1IZ7+vSYGlKtefeBOoFTUaNRTUyVuPb0iE
 ZAPM5j/Aq/cfZPC2P7+DGnX/4lJRIE0Bo6h9h73L8sSkC1lV7w58XwgVRZy847/vO4vkMJ/su3
 fYQvCYHTweMpzYdPGyk7nERgP17ogCg3dyPdJwo45I+AjZtbujkACp7dYK1z7JBNMBIghFYqv6
 DIJWoADKi/VsvRr4bmqzGH4v58YHx6Hs8jv1H3sDQdB9PGV1h8AXlGmcE7iUYLY9cFr1TiZ9X9
 WlQ=
X-IronPort-AV: E=Sophos;i="5.63,466,1557158400"; 
   d="scan'208";a="218874425"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jul 2019 02:47:51 +0800
IronPort-SDR: dfYI6parzq7gukJNBbhfs/X2xKEGav0slIKsU8sNolk6WAJno7fm357PtEFOZLthng7Zve/hCW
 952nYZRzmHXU5UyjGJGsi1K5YgXWZc7zQAEi/SFa1cY4r95ZdeDVpHosZCxtx4ExCVGEwHp8jB
 1VEThFmVodm6KblZ2Tm3KBpzVywO4hZMgZQn4wO0qTjik4FNDLgtI6XtzU4hL8dOxFL595ONyy
 Iuw+DyyrB+bWQx8G2/9tT3VD/xBYTcIfRlazwwshl7kAk3aO6pcINerwxwSRl6LtWat+iGaihQ
 437cbfMB3tTtBzBkL5S7+bP1
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP; 08 Jul 2019 11:46:40 -0700
IronPort-SDR: kecyraaTh4dfkJYr6JIVW0Suuw0udo/w+uOixco2i06qP7L/SWcmvqt/OPQcFYibEwQdrOi0nK
 enRpRX7ANej55ctxwPbFJYb7fqRPzb9iUsQ+X5ZNEUrTgNq9FFFFtCk8Uw0GOXwADBWlxronSY
 Svt1NhhCrvFTzjTb0NAJyLkYX8DO4fah1yOc1ieVyunDXipVwQlvdQUxQXLaXQ7YfMQ8I6zuux
 LMBm49s+scu5jetOVTy2vWOk4WWISLi0ojSm1PhlAA0xRc/M8yQejIviSzITpm3H1FBND+zGZZ
 tNo=
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Jul 2019 11:47:51 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V4 6/9] f2fs: use helper in init_blkz_info()
Date:   Mon,  8 Jul 2019 11:47:08 -0700
Message-Id: <20190708184711.2984-7-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
References: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch updates the init_blkz_info() with newly introduced helper
function to read the nr_sects from block device's hd_parts with the
help of part_nr_sects_read().

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 fs/f2fs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 6b959bbb336a..24e2848afcf5 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2798,7 +2798,7 @@ static int init_percpu_info(struct f2fs_sb_info *sbi)
 static int init_blkz_info(struct f2fs_sb_info *sbi, int devi)
 {
 	struct block_device *bdev = FDEV(devi).bdev;
-	sector_t nr_sectors = bdev->bd_part->nr_sects;
+	sector_t nr_sectors = bdev_nr_sects(bdev);
 	sector_t sector = 0;
 	struct blk_zone *zones;
 	unsigned int i, nr_zones;
-- 
2.17.0

