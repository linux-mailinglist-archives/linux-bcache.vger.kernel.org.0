Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE7B437B9
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Jun 2019 17:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732576AbfFMPAr (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 13 Jun 2019 11:00:47 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:28067 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732943AbfFMPAo (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 13 Jun 2019 11:00:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560438044; x=1591974044;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DoBGRhewgNmovFqTGu8stJENDg0b73ZhN+6fsPSmUI8=;
  b=T8/5m2dBJEqkuU4QMlSiER1HWfIjiMn1Vg/z+77vNjKFMPOy3pGUVX6O
   rxbW1CoH+t57AIS85k5sqG+6YT6hJTM9tKGmHNCpgHbQtyINF5j7Tf6FG
   yER4vh7GVzZqM5QfQt8agS1PjoNiuvJiTLLUKIBO+WjKFT7/QGY+s+wfj
   uQJsMpjvNW3+ie/FFm3Q55tYXS1lApRKKHRrW7feB68GX69osFYGC85k/
   QHKPS+knKcV61xi0aePE7PEVyrBbwvHK+1U6pr235i05lwSt51pLs00iW
   lFyTNrJlhC/n3O/ZyAVv5hS3325A1VTTE93+AIAmmN3f07KCjG7tBrfAp
   A==;
X-IronPort-AV: E=Sophos;i="5.63,369,1557158400"; 
   d="scan'208";a="110477993"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jun 2019 23:00:43 +0800
IronPort-SDR: AENcPtSl5QXKYVgSyYPN0ett3/DwXmCJgpHL2V4fciUgOSHsJS54ljjvgdr4e6ojii5jir+tP6
 1zjHN0IZPsCXDYgDmdiKVYbC8OPN5qyt/9CBYKwfVmt+j3ZH7jS5osLjVhS6c8sfDrg/8pxP2I
 MtKTeTiRR6TUU7WcnEGixx5p+ekdPgEvLxXe40UpUONwT2A8yIRvYwFyhEJ35bqPm798bkzbpV
 Xu0Tb2l4DimZi/9S0/8WFqIp5n9GEeyPrfPhAO7Xjv925G8qAmqN/TPngDA5+KMpOr9gld5Vh1
 e0162sjXDMcop/btGyKVxa41
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP; 13 Jun 2019 08:00:27 -0700
IronPort-SDR: HdXhwhVFHJ/3YmppU2XrTWFWGN+w45Th/1CzVBjqxDbs6kqOiTr1AH/oo75WxkwJypW0fUKTuf
 6H3WJMcesJLrgDL/W9CxMRft+C3zvMYK5okwUE0rtwxwk1v1tZKEX7Ui87RSUi6/WxbiDuBnWW
 93l0C5PWf+wVW+AzIL0pSURMKkHAN+eHE/Sf2IGxlrVd4zirTgBlXsHF5g7beGE2KBZAe3siUw
 2FiUAvPpDLZ5Q1chXiLT0CXSdW2m1XEDIKMJ9FEAvIKEBdKW3aHFX6AacRV/ZP+viDnZ4fkksV
 KeA=
Received: from cmercuryqemu.hgst.com ([10.202.65.32])
  by uls-op-cesaip01.wdc.com with ESMTP; 13 Jun 2019 08:00:43 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-btrace@vger.kernel.org,
        kent.overstreet@gmail.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [COMPILE TESTED PATCH 7/8] f2fs: use helper in init_blkz_info()
Date:   Thu, 13 Jun 2019 07:59:54 -0700
Message-Id: <20190613145955.4813-8-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190613145955.4813-1-chaitanya.kulkarni@wdc.com>
References: <20190613145955.4813-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch updates the init_blkz_info() with newly introduced helper
function to read the nr_sects from block device's hd_parts with the
help if part_nr_sects_read() protected by appropriate locking.

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

