Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB4F4379E
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Jun 2019 17:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732872AbfFMPAY (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 13 Jun 2019 11:00:24 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:28024 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732868AbfFMPAX (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 13 Jun 2019 11:00:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560438023; x=1591974023;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DOgy94QccoYOl8BNrpBpMwTFlXUNeTceno4ux0l31BQ=;
  b=IIPp6kS1rDY+KqzdkI8nAI8s3o6IlnNHGnft6juWeQYJeg0PXAkyYdBI
   oYt22vr0hD//Fnphqv8pVT0WKgb6MbGOaybQXBO9/U0ZaQK0FJfeGRTv4
   uFRIRAPlywQUJtJNG7pjpQBw0f4DQAi1H1KCpdrqyUC0z3fMHBbQ/nxYc
   OKsLc9+V0zaDiIYuRi6Jr3gwFPjOWy2Mu2WNC0zkp6gZmeyw6f9AATPhs
   5BJwSN73OVqgQfeiDGI+phvFc7a1aggLQ/L4olXa14pgd1Htg556A6iih
   d85vSEvXBlC3CMqCJIOYGEL+GylSDwmnS9kOmSHIeBMYBfi67noLHN7va
   Q==;
X-IronPort-AV: E=Sophos;i="5.63,369,1557158400"; 
   d="scan'208";a="110477889"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jun 2019 23:00:23 +0800
IronPort-SDR: 3ZBSMsUX0zBe91YtOrCB/G5mlw4tbTYHipvQDOFnKy8F++xtPSnZiW0yY/tXBKKO/h131RhtCy
 o6X8HpVoq8af/oBKGX2uHg13zhJ0t/yLKH9km4hdgzqc1C3uYac10oMMLhGMjGou+FtgT3fWfj
 qERXqJh0DUXbuCC56tEQ4hBWorJ3QlbwD4L62pKnOvNNgJxS5KLIp3G7OnTIZYSbVSB6G4/+i9
 yuMfwIbUTTSJkvhHNkN2eiL9anse9lY9utnY0h3Uizd27KjSAttj5J1RYCA0igULT45yG+3V2F
 NbJSybk0Jelwr6MR2XdVLnIc
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP; 13 Jun 2019 08:00:06 -0700
IronPort-SDR: pbpA2y6HwE3tNh1R1zJZ30pgpN39RHued4F1JDg3vRN64piaUZfAcH7khujOnx9Mgk5aiSFyGZ
 4IZCY88eF5mjNj8CYyAuyiX9WSXJw92BTbpZI1UPpNKseJJ7L1ZYzCIQfukozUSCmxUajmbUtE
 qWFfmDyJFdr6v5lDecHIOnvMJU3uHRts7c/F+vaj/Y5riUJ8iQ8wACBy0OCOYyChSkZ/7dV9jB
 QjdQBr+PTQEhMepxFwsSU9sMvxqUQIgLyz5qTMCUysvMK6Nw21IKHhbnVOv37ZniVHtz7AY2Uw
 BqA=
Received: from cmercuryqemu.hgst.com ([10.202.65.32])
  by uls-op-cesaip01.wdc.com with ESMTP; 13 Jun 2019 08:00:22 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-btrace@vger.kernel.org,
        kent.overstreet@gmail.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 4/8] blk-zoned: update blkdev_reset_zones() with helper
Date:   Thu, 13 Jun 2019 07:59:51 -0700
Message-Id: <20190613145955.4813-5-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190613145955.4813-1-chaitanya.kulkarni@wdc.com>
References: <20190613145955.4813-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch updates the blkdev_reset_zones() with newly introduced
helper function to read the nr_sects from block device's hd_parts with
the help of part_nr_sects_read() protected by appropriate locking.

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

