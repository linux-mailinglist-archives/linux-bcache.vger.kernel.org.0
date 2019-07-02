Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 939125D56F
	for <lists+linux-bcache@lfdr.de>; Tue,  2 Jul 2019 19:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfGBRmz (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 2 Jul 2019 13:42:55 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:57058 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfGBRmy (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Jul 2019 13:42:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1562089375; x=1593625375;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=R+PqGxeqtQ6qQlCqmBxy6Ky2+ZJ1BGLcrhWr65kK1ko=;
  b=Nk0MmSHvjecX3Dg0MS9g5MxEQO8YIvrC1HUmc5u80UNcdYLvowX41r//
   B0qbrsRxY1rvcMnGcxtcYWhqj9Dg17KtyY3ZWluLmNrMUJmd/qUd5wSH+
   R+zm6545AHu5VgHTfiMJ+NBHtH/X9AAaCJKHqTo5QEL46moO5i+HLHQqX
   XAWLNiwfrdFqa1/NzXebO512TdFqQ8YIx1E9wMjR4V/61LZeZIjVe+SRY
   2+dmsG0WoqMgU5gq/LBvQWy8ibN/rR4fo3IuC1T6WPQFgV+RkHS+sXk8X
   X/u4qgIFKwx/sMSj4WP0ByGa+B7HTLPoLI+bMUy3okMCXgFhOeVXz8/Kg
   A==;
IronPort-SDR: IDGft9eKMXwgXRA9P3Dq6/291xeROOric5MHVIdOyKt5SfnL7wJzwdNefmbLmZs7Cpk+7IbkAI
 R/soPCR7FPAWfp3J/VagPWYzN9DgsSu43SzGKiWXE45KE0NV8+KV3PFgdFzRFTjO+kvVuoVJen
 AwWx/i030+GqaBKNVdGASVgOWjNMG1ZcTh4nhjDWRfYIU81DfkBR+SVqSSKM3VQ0ejV/Vj69qR
 L5TADGeUJmCrh0wvSEwuxTWL/oLV3zJ7DZAILlAyg5xHvvBv+EpICM0eIvujT499z9UbwcE7qO
 0H0=
X-IronPort-AV: E=Sophos;i="5.63,444,1557158400"; 
   d="scan'208";a="113269817"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2019 01:42:55 +0800
IronPort-SDR: lmuBmyIRvo9NeemR/f16gCh9AsIDPgtmbZob1S8+gONIM9POu0jxc2FXDTXf2L2gVzvbaSQn4U
 UkWUmfUKT554L65RZ4KD0UJ7rdcy4qnD0PEvEdWH3yjLXBK6CxtRS+7rXu0NvvG3OE+vY6bTnY
 buUL9ab0LgPukoze1DZVXqH5lUt+XxF7ydeS6oMVcUVe/7GVAotigC1/EfyXyUQJypNLX3Qheu
 /lrf6lPgnj3zz5/YwSgXbo87hKGhxy8cSXpSjC5RB9/JBq6r875mTNvqht0MUfXunGI5Wzo/7n
 lrYm4GeMQtwx8SgRCMPnECLS
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP; 02 Jul 2019 10:41:56 -0700
IronPort-SDR: G/uLmRGIhR1LMbBkSR/mZvxOZKkvqJRNN5K3dh9qNmMM1fa2KZc+jFQU7q7JOv6WNW6g48l0Kn
 5v4QxUuHBwr5SzPEAtkc7OyRSK3XTRauZGm59j5ahpw5wmr6DYzqxjFPVdJrrQidjtsBYyV0uM
 yF9FYqoQuzI3uhdGfMdue9EbSVG3fRedIz8rowF8JYCI1n/lvifOaIQVoyvpk1+8dBIPd3rMmT
 MA2y2MtsCtTSTxq5XBpfxTUQW0NqoTMAaz3gHx+pwkKc4o/2IB/j6m8UfbKqKaS/cMputBrwok
 22Q=
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Jul 2019 10:42:53 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V3 2/9] blk-zoned: update blkdev_nr_zones() with helper
Date:   Tue,  2 Jul 2019 10:42:28 -0700
Message-Id: <20190702174236.3332-3-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
References: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
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

