Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF625D57B
	for <lists+linux-bcache@lfdr.de>; Tue,  2 Jul 2019 19:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfGBRna (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 2 Jul 2019 13:43:30 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:21415 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfGBRna (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Jul 2019 13:43:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1562089410; x=1593625410;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=QJX4vVEET/cgf8iBmo/HOlI2NJ0ZitkZSdSK+c4gaYI=;
  b=Ds9yEL1m57Tp/N9JW6/jKMUOimCqaSTSztTJjgCBLNCojecV3rBS+Y0p
   dhbSP1o/kd1LnVpYvTJ9GEXwwcRZ04EFQP72BldfhJdLxYQYX1h5qW2HX
   GtSyrBEfMuXSFFRz3D4xZUKW6RPiW8aj7igHGPB4+f9jV11J+wA5yzt86
   m3kBByZ0TKbpt0LYmwul9gP14DB8JmviWCj3oM+PaBVJY6g8jfjaXDlAY
   +/o5fiKAeNwiazUtI902gy1+1N7vctK5D/Z4QsDaKyezBD3doszMNw6Vl
   LlYKEEmCYIY+YdqoOnjaWLucqIcGqgyqZaFc9h50FV3sNyKR6IdlNTZCY
   A==;
IronPort-SDR: UwgeHm2R3MiMULKtv5Y5QpMGuabKFrO6bXge9afRhJSuh5mRHPqCTq1ORT+//6ngIZ0Hps0gP7
 p8U5oEoaOVeCVb6zSoHD6CcdRVAGwYCI27EUQok/cQeUCDBBfzYrpAaI2E7i1CKqk1jOzcfyL+
 ZXwE2ZUhDsUG2LragyJnNai7UJt9C5uopMBB2CdJkLZamQWNZMVKB3Otwah0Z/zvPxiBYFMsbo
 UDmTWjMxS/152B2Wr9TKTmjos7Iz8eKF5/NI7oaa8hPiXD1hANXYg8hO0sykm2BGnTV1Qf4r/E
 Nmg=
X-IronPort-AV: E=Sophos;i="5.63,444,1557158400"; 
   d="scan'208";a="113690603"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2019 01:43:30 +0800
IronPort-SDR: uYwWl4Wp5ZhOkwclXMFGJOK/FE+Ay3BJ8VIQn03vEyKRpet/9UeXwRC9TuoMLKET0+0Yu8NoDp
 Pu3utZ31SIvGxBaRm0aF8I4A0JWZkVcsSvq5SqcYwu5GnE6c8JSc1pnvksRyQs0FH5Qh2Vy+vA
 HEhtH5NmGV51HI1mEjd/kD+Pk/gB3W428heEaqlzEU9Kctit8JpJy8bcsmlQPVw5lq5K/xlpa0
 iiBTxrDftLHP9IYbU5BIGw7JmSot+xIRi1mi0lgsslf5GkqafBUSZx94yAZbhc3nh2U1QnKVKH
 gRpbEjILGVZQ7zWLdHvcXHJ0
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP; 02 Jul 2019 10:42:31 -0700
IronPort-SDR: ssIi3J7cwArdcczUeEkcZs9ezBQgj3OwOLdLv88ozquc48L2yozLcD/FTp4rI+DlfYhQ2ig1nZ
 qfMH2sJn0PhKKSsZPZW7HXsPijWKL2zjyuKifOuL2vyMBwlFx/+OH8+GiF/hJcNhoXFnzc8Bwu
 Jvdu1GD12g+loQ+0d9RR2EtmcKzyWs4g+mWjX0KWARasXSVKim51O5L2Bzl3UZjOKsMqooggHr
 fiZjAFF7OxS4tB0pB39LHvxUDr47KJ8bPRthGzl8Q34b0q2drY7f9KPoZtYIW7lTI9y++cqaME
 zdw=
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Jul 2019 10:43:29 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V3 6/9] f2fs: use helper in init_blkz_info()
Date:   Tue,  2 Jul 2019 10:42:32 -0700
Message-Id: <20190702174236.3332-7-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
References: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
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
2.19.1

