Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92DA5477A0
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2019 03:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbfFQB2r (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 16 Jun 2019 21:28:47 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:7477 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727382AbfFQB2q (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 16 Jun 2019 21:28:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560734926; x=1592270926;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R+PqGxeqtQ6qQlCqmBxy6Ky2+ZJ1BGLcrhWr65kK1ko=;
  b=m10+Nbuzf9ZEnwdiIBUaujQFJY7/eYNaebeBc/962JdjT9aiG1j4gca3
   FDz3UQbZqy5cinEP6feA1br9mjkblYNvGTY/i5z+sASy3ORBhWqMcMHs2
   ivlnCzvKoWCtM/EXTqE32U2H8D+JfY9DYIbcBu+qLRibwW0sADCDe5sBj
   x/Iab/S+IJFhbjbXlQQnxL+XeERN8dhgUL64An/XVSXss8P/I1KfQ6Zq1
   1eYCpNr0r6rl6HfOzyJq7IL7pQEbsME3YB7fUliL2smXzlDB3XB1eflZo
   eJH9s07oYIhKMPt84TmYfjcHd5OdiSdWtxoRbW2tyneT+dIDMSpL2px1/
   A==;
X-IronPort-AV: E=Sophos;i="5.63,383,1557158400"; 
   d="scan'208";a="112362944"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jun 2019 09:28:46 +0800
IronPort-SDR: O1jidwzc4TrTxTF8uM7hCTAbkgG0wlIB5kqXu5WphI0z2ttJ8rBht3Qwv7cng0Z79guaHBgFn8
 xWzAa5SX+ebxYfyNlnzpReFjRGGRkBhXt/VI7a04Iy8SAtBQAX2WgXbqanI6SgCm9mtqs6omun
 4TTT9fL+plMIOZ/luuPWLDWpz7SB33llC6wjYPyIVIosGrpssAQY1f07lPd/FzI+3zw16yvYIJ
 7Z4GSn57Q60d3TsZfQRAZxv739niUIJaNm/ytUIJr+7W4p6Tei73eQMqKPiKERIw0QdF9TDdrB
 r7KYNZ0BlLIQnojkijIucwSZ
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP; 16 Jun 2019 18:28:23 -0700
IronPort-SDR: XRn28JfatW/CrG2aj6GCIkFawG/X3TvPiaS45UR6r+0wh6pbrhAyDjRJ4Yr7xk6NEEAJlWlPod
 4WEpd5B1V8WfMXLCxZj/iLNjxUoA3C5b+1Qm6uSKCp6kHdwx+65awmsBWogo0iMRvzlhkDDvYY
 QbY2bWSevaTA2unLb8ZMhVwmz64hhVDe7E2cOD8gxKQ00IM4198e0TnoRRB06TPhbGLKqm80BR
 rcFA/8BKC5AS8SqNLwROjNmKP6iK5ZkJyogPDEYLbE4hieCe9lJaZlDkqBJbe19ewNaCLN7gKN
 Nvg=
Received: from cmercuryqemu.hgst.com ([10.202.65.32])
  by uls-op-cesaip01.wdc.com with ESMTP; 16 Jun 2019 18:28:46 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, kent.overstreet@gmail.com,
        jaegeuk@kernel.org, damien.lemoal@wdc.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V2 2/7] blk-zoned: update blkdev_nr_zones() with helper
Date:   Sun, 16 Jun 2019 18:28:27 -0700
Message-Id: <20190617012832.4311-3-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190617012832.4311-1-chaitanya.kulkarni@wdc.com>
References: <20190617012832.4311-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch updates the blkdev_nr_zones() with newly introduced helper
function to read the nr_sects from block device's hd_parts with the
help if part_nr_sects_read().

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 block/blk-zoned.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index ae7e91bd0618..5051db35c3fd 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -90,7 +90,7 @@ unsigned int blkdev_nr_zones(struct block_device *bdev)
 	if (!blk_queue_is_zoned(q))
 		return 0;
 
-	return __blkdev_nr_zones(q, bdev->bd_part->nr_sects);
+	return __blkdev_nr_zones(q, bdev_nr_sects(bdev));
 }
 EXPORT_SYMBOL_GPL(blkdev_nr_zones);
 
-- 
2.19.1

