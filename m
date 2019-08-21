Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFC49720B
	for <lists+linux-bcache@lfdr.de>; Wed, 21 Aug 2019 08:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbfHUGPB (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 21 Aug 2019 02:15:01 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:20530 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbfHUGPB (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Aug 2019 02:15:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566368136; x=1597904136;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=TWIY4zyMbnSdbPfWCQisLpNGsxuN7LEVg7rZifVilrc=;
  b=EA+LZTQsBYVP8k4p2DwByQf0hKjkf/qjFji+709zpUiveLzuYnp3hyvF
   cNxrl/wJaP48sNjPQRZxno4FxfEFeB3eRgKVSZz5nxnc0gMslTGNE4jXS
   69LFUhVkhM7sAQTqXNl+X47Hx9zhl5hGEvoF1a3L6Yc4c5YtB79BKd5Ef
   cAusdRJRx2tMnxN5E3tZOE7DzM8K4LvnOzhupyqAUTZJ2ZPWMdhXDF4FP
   I+GbOeGG3/BlpNtwXp27dHkCXOjuGrV2nohdTLf+cB36JgKQ/WmEd/jTe
   52c137Y2CNJzF6/PRDUIgZ5Hy/gYglAPAEi7Hz/fHip+SArBdio4u3c4Y
   A==;
IronPort-SDR: AkOcSXb1xSHhsvdm+qxBgRS7q0NlKRZ1PjV1vMAS3yr+1dxEc7hL8D0IaFjRXE25pcEVQad2gi
 MaMU/bF+ITqtRboULOeGGhZf97kTb/6cPpRdNHFGv7Dgj/3bq+2ehtOShFnnQnlIXs+KQbm9QP
 WovmWYQJ5aWowUklvbjON4pHBpIh512KxCn/KJGw7U/7QCye0OHwNgBSCJOGOKg+8AEmQAu5Id
 ta9YWFnDGnoZ6AJGk+2z+MtZ0heGCqMZLtLPlgjEz+Us+Pn009fJvTEZRrZFyeCm40fvimoHj6
 Z4c=
X-IronPort-AV: E=Sophos;i="5.64,411,1559491200"; 
   d="scan'208";a="216721093"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Aug 2019 14:15:35 +0800
IronPort-SDR: 1Y5OOr7YVnhPcXqFLuyOgw7Es/7E49v4sq5KtU2m/dzvojM4H9rDcTnFjXDGwUKkwoq6PYdujW
 N+27bWzLQ2yXIksho1/JXA28HyGf2RR3C0kApePj9ag7rP7Fn9nOd9yO/GVZM5NFGgQWrHPMhl
 XF5m6xBu9W4dt3I1UdPt/mIigMMuV/AqeAkFLKRonkTX1nmGvmIqmHDcGbt0otjZirsyz0jB2R
 Ah8pPoGAorDFRFruCgQNetUJfygHDfJMy+lLegw7dIjysRtnRXoD9OPMPt6S72lEbNWEVXWDbe
 VJsoKFmy9SD23+cyvxcWX21q
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 23:12:22 -0700
IronPort-SDR: 5/S77yaPX7vIPc8Ykudto5lXNWJHWMf9k8eRp3VA22ShuUnIWyO7HBQ+5tzxRnuB/rl895d70I
 86QpiaX1uJ/JbLojGMgXm9WeY140bDRfoabDuUfUsNls8qwqFznkr5GENwDhjTPYv9YElxi/x5
 5nW/zc6pDo9no7FW7MUum92rzmL3Z3p7aRGH12FMJl75j77cAWHqi4J3a7DmFbACMIS2GPs3g5
 uX4v7+k8k0zwseAE//uhMbrgJlegwYblO909AXAa1Kdxm8kkfVOoN1UvJESvG3Wy20saiTR79E
 CZ4=
WDCIronportException: Internal
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip01.wdc.com with ESMTP; 20 Aug 2019 23:15:00 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V5 5/9] bcache: update cached_dev_init() with helper
Date:   Tue, 20 Aug 2019 23:14:19 -0700
Message-Id: <20190821061423.3408-6-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190821061423.3408-1-chaitanya.kulkarni@wdc.com>
References: <20190821061423.3408-1-chaitanya.kulkarni@wdc.com>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In the bcache when initializing the cached device we don't actually
use any sort of locking when reading the number of sectors from the
part. This patch updates the cached_dev_init() with newly introduced
helper function to read the nr_sects from block device's hd_parts with
the help of part_nr_sects_read().

Acked-by: Coly Li <colyli@suse.de>
Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/md/bcache/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 20ed838e9413..79c848fa5912 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1305,7 +1305,7 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
 			q->limits.raid_partial_stripes_expensive;
 
 	ret = bcache_device_init(&dc->disk, block_size,
-			 dc->bdev->bd_part->nr_sects - dc->sb.data_offset);
+			 bdev_nr_sects(dc->bdev) - dc->sb.data_offset);
 	if (ret)
 		return ret;
 
-- 
2.17.0

