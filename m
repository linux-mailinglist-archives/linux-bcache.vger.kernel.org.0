Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4FA437A8
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Jun 2019 17:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732582AbfFMPAb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 13 Jun 2019 11:00:31 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:28031 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732901AbfFMPAa (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 13 Jun 2019 11:00:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560438030; x=1591974030;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dPhUA1+cc13a48v9hC5jFZOu/fNuKpP1r0BY+977toE=;
  b=TtC2JPv89mwKfznCzrNa6iXc0sfMHC5RgOEq8MHmjdBH6cf9giFS4x0A
   h2kqI194vbbUK3nNvKfLiWdI8cyMo8S3ghcwbBoRZeMPnweTNk/je00+L
   EjIOaLUbIkmVh8YGFKbgbuQ/87w2Gph9qBHoxkoJLobE2ooFS7XxRjpMa
   HWlYSOgzR5fcM8uR5PfZqjb0Q70/fkvMduW10Hb9H09GjO9OW1/88qV1B
   nEeYNu5G/b+Ouw4WLWQpEcdEY3IfzlXiGVh+t1zr9f5hOLKvQEiGcQiYH
   hQmQY8KMcdcSrlixOz6LCBSkHtgcluAsh5O/Ri5wCeJwEZAzFcM1aIBJG
   A==;
X-IronPort-AV: E=Sophos;i="5.63,369,1557158400"; 
   d="scan'208";a="110477927"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jun 2019 23:00:30 +0800
IronPort-SDR: 5FoQPSooDdZfaEzgVHwrNyHKUERLDa8BbmKJySmBJyxmDfflSV9r5CNkQcJ4VtlHvBth0pk/kj
 rhGJwEbTh7YwnHkdjaZ/QnLGsYfvOIXyby5PhyHxAbomBzc1rRDYihmbyLbyzSO+pkRFQqqxwA
 7CySiSSpgL3MPJibXNq060rlxLxUvl6YljMDghtd7a6n/H+AWLsgBcUZ24JFi4lGkPcDcYZIBp
 dwExuyCmBdYYyhwG/X8Q9iZs171r85/atnsPJkHaHQO/9krBt1X9M2PZeqcUTseyJQPNNiqkiY
 w4fzj3NXB5OPjdZxaXCJUjcn
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP; 13 Jun 2019 08:00:13 -0700
IronPort-SDR: LMUwsamurQJ27M9W1XdZRzdaCX62e6fvBH48L5GtZmtaP5/Cfr7XkPolh0Ovj7TECZYOmHmCSe
 WaZKa3XZP+9Zqx4j+h/dW3Kh/UGLXfDzNsVgPFufk4rj59Wecn+VMK1SwGe0Mfdcvbd639u8xV
 tTejOOrYQXnXK7jyHMcURl1TEjTI7nDT+jWqifhYNMkbnLbjCOBZGHoQIgJuSgLfpmdS9sdo/+
 RWeH0JkgKC6NgjsavVjQ/Js98NRhXPhA2vlDi/jR2E6Ag3J8WxewFyry/kjz48krJeV+b+qS0G
 uQg=
Received: from cmercuryqemu.hgst.com ([10.202.65.32])
  by uls-op-cesaip01.wdc.com with ESMTP; 13 Jun 2019 08:00:29 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-btrace@vger.kernel.org,
        kent.overstreet@gmail.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 5/8] bcache: update cached_dev_init() with helper
Date:   Thu, 13 Jun 2019 07:59:52 -0700
Message-Id: <20190613145955.4813-6-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190613145955.4813-1-chaitanya.kulkarni@wdc.com>
References: <20190613145955.4813-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In the bcache when initializing the cached device we don't actually
use any sort of locking when reading the number of sectors from the
part. This patch updates the cached_dev_init() with newly introduced
helper function to read the nr_sects from block device's hd_parts with
the help if part_nr_sects_read() protected by appropriate locking.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/md/bcache/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 1b63ac876169..6a29ba89dae1 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1263,7 +1263,7 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
 			q->limits.raid_partial_stripes_expensive;
 
 	ret = bcache_device_init(&dc->disk, block_size,
-			 dc->bdev->bd_part->nr_sects - dc->sb.data_offset);
+			 bdev_nr_sects(dc->bdev) - dc->sb.data_offset);
 	if (ret)
 		return ret;
 
-- 
2.19.1

