Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDD739720F
	for <lists+linux-bcache@lfdr.de>; Wed, 21 Aug 2019 08:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfHUGPH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 21 Aug 2019 02:15:07 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:47070 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfHUGPG (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Aug 2019 02:15:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566368106; x=1597904106;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=PRIc+qImYQi0sq4kI43ZLo0IJMblnfPTP0QUTy0nhdQ=;
  b=GQISnMNeNMuW041BmfLoBVsft8JFH02FZJMfh2boo2rCfD3iM6LA8MO6
   MZ5Do/9y2FQxXPD3CYWQlzOjj6ObEogXbusBxsMcaMyi5BuYbLzNQoc5L
   +Esgjxjz6CPtVzt31hWjktJzAbd+T/fZR/UC6YAtmPF2eNGCGWb7yU6qs
   zS1VQLAkhz2a8tFXFw6zZjdE2dSi8uHkdNms3gQGBTb/Z98/8NLijys6n
   LK2J8iE6ZEgovFGdtmqWHuYuir8GKJqewnayI5s91nuh0BmKyOaNsJTMs
   DkX+yQKx75c7nja9kO5hnw+Gctmi1o9PeV3yGRqaUZNnnGPIHLuPxfE4N
   A==;
IronPort-SDR: 8/A2c3tJUGm/VoBAofwLkUD3No5LVQQ+6VdhnPChhOGTfSvOi7iRPPQHE5Mda40M1mwHJtpHlH
 MlYB9A04CGLyu8tS0W4k89ByHmfVcinTLMz5FSEzl7l19MpQReqM8coqX6GM7zPmr3lvA/1IK5
 l5nb7pxZcHemf2Sp0EEl/3iaQFbQr/Np3tDPNizAtj+qmLQKe+KNDhpGzoeFh4mUhZjgMxiz7y
 h0d3VA7WnIwH/qvsyPoYUf4nxxYMxldqQXNGhk/pM7D6gFaSnvpdKqpxFDahEFnzBrh8E5ip8I
 Dyk=
X-IronPort-AV: E=Sophos;i="5.64,411,1559491200"; 
   d="scan'208";a="222880836"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Aug 2019 14:15:06 +0800
IronPort-SDR: RFlkttASNNJpBMKKScjnW+y6mLIrc1+zu/C9ygjzVwAZZaimZBPdBlA3G+HHdC3T6JJPw5fsej
 bzb0+9tjE8JO7+ctVmlsB/PJRsXzI3Da4gp9VzJZj0pjVdMBRyxzhcUXmaAxOpjeSCEN39JRmD
 s8bGZaZYL1+mvJpAZo6JuiFfZylFjn834jxvXxA8+yPL3dU8nWqS6CMMSsZAoSu4+aeYIm6Ilt
 d+rLWxPERou0CIPsr5WTPApbqHToqkC17YPyRXZ7jXMLYOWDSLEQZxSxkh7IwKIo6w+KeE4fR5
 Yt3xLXnIgWes+AoiDWNt5XQi
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 23:12:28 -0700
IronPort-SDR: 5OITIcW+05bA5Z40gygWOJU1w9CIPQ11BCkLaBNmFn3P/VNeT0sYheeUS/i1HqpgVD2aksn/0T
 0jmTG7ojAxndIs1tRyw00R3Gt8qcdicEt+6yTPu8vzUU0i4fpKYySbuvVoWZd8g+Abko1qujuu
 j4MC7leRfkA7azGPBOWylw7p7ZKglYFk9SHsW8rLlacSj/f7OCusSE3BCYeePrmX6TOsUVfbkX
 bPUoBBhF6ojUMTV6YAgSaZKf0Yh8+8iUQCm0hYI5wPdi5onYmHP4f2i3PqgeIT3YLVaSFNafh4
 3zA=
WDCIronportException: Internal
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip01.wdc.com with ESMTP; 20 Aug 2019 23:15:06 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V5 6/9] f2fs: use helper in init_blkz_info()
Date:   Tue, 20 Aug 2019 23:14:20 -0700
Message-Id: <20190821061423.3408-7-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190821061423.3408-1-chaitanya.kulkarni@wdc.com>
References: <20190821061423.3408-1-chaitanya.kulkarni@wdc.com>
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
index 78a1b873e48a..78f8f834aa44 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2775,7 +2775,7 @@ static int init_percpu_info(struct f2fs_sb_info *sbi)
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

