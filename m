Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 308FE477A6
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2019 03:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbfFQB24 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 16 Jun 2019 21:28:56 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:7477 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727515AbfFQB24 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 16 Jun 2019 21:28:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560734936; x=1592270936;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Po0y7wi7jBwNRRxhDvOMwQBHOw0QeZhHy5S/KsHyCxI=;
  b=mEOK4UB2YBaizUvcS7Mgx5BIGPCH+4LAXKyfKeL54aefhMl7q+mJX7Rz
   NHi9l/Q7YjJHKjcchqZPg8ExIbJ3XtICvKN5uE7qSXIlzpQErkq1xcOZo
   q+dnsMm3NMsj4ZLsp33gbxMWGWUW+9GgLZG7ru/AniAHMgA566a6geboc
   EHnQoADTSEN8Q0lCKVX2Ut0d8jXvQPkfmWWLrFiWD4L8+HAO2fWxrd260
   VLSbQ18Jpw95mSQPqUhMUI8mmsifB4qOdp+aupQTe/56F0sYtYKasAHc1
   ZYEO9YBDuPfaGfIj7MKtW9wcrXmxUhnCC4b8PtkIFV78y2L9LShb/eQul
   w==;
X-IronPort-AV: E=Sophos;i="5.63,383,1557158400"; 
   d="scan'208";a="112362951"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jun 2019 09:28:55 +0800
IronPort-SDR: E/Ud+an33LhPCR7Yzf3N/3jEkjaZFxxpYEH+KzHtgDeS1JAnepxlHWKq4ftn0eSZFo9zCIr7Lp
 tPkyI+6xXJoggT1tEbqmKhAvL+iyjmFrSXmUkceGrR4KsFgR8y/iYeswXHviTx4xAl0t9y303J
 /MaPaXeE/r25U4fBRcfxDHeVFsUe8AiGlv94AbBmgs1BGnGyusSNqFgoydUmGRbkrf4QvaOpVW
 bxIYjUs41zQRsXnYAawR9mcWw/yqKy4aJ6XKeW2c0ZBlRQS3F83RqJMdPs6uWbAyu0c3Ytyp3+
 crt5/QaGGM68jvqqK/HqS4LY
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP; 16 Jun 2019 18:28:33 -0700
IronPort-SDR: wpns3c4kKsnbhvcIRUAjqJE/TCZH+cA8O1jQ7RcEkN05WL4rNnDu7rMopee44SQ5O1H1L2+GOS
 OqRwdB8hxq5Qyn6TyFUWVupa6coyBVcNxRrl/zn8tiPH/D8q0vjND/Go7pte1rs5njH9H/6lms
 TY66eCzLUPXXhI1Tlu8yvcEHUPx+HwupofYw7KvQpRewyd2yKBkXuy68ySB7yirt9KhTi3GySa
 8jmgyn81krAdGXQmqyX4eWNC5ye84nFNM3ucQVmW44+QnUgKJ32bcYDGsLgHMX5cxYmaR6+Z1j
 /EY=
Received: from cmercuryqemu.hgst.com ([10.202.65.32])
  by uls-op-cesaip01.wdc.com with ESMTP; 16 Jun 2019 18:28:56 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, kent.overstreet@gmail.com,
        jaegeuk@kernel.org, damien.lemoal@wdc.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V2 5/7] bcache: update cached_dev_init() with helper
Date:   Sun, 16 Jun 2019 18:28:30 -0700
Message-Id: <20190617012832.4311-6-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190617012832.4311-1-chaitanya.kulkarni@wdc.com>
References: <20190617012832.4311-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In the bcache when initializing the device we don't actually use any
sort of locking when reading the number of sectors from the part. This
patch updates the cached_dev_init() with newly introduced helper
function to read the nr_sects from block device's hd_parts with the help
of part_nr_sects_read().

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

