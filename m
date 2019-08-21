Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F207C971FE
	for <lists+linux-bcache@lfdr.de>; Wed, 21 Aug 2019 08:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbfHUGOf (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 21 Aug 2019 02:14:35 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:34498 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727766AbfHUGOf (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Aug 2019 02:14:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566368074; x=1597904074;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=YxWj03mIGVcVbYKOln1UBPzCaYS0qRuFrw+e6W6O8fU=;
  b=MaMiwGfRcNgMb7+ytBS3Va8PMKEOCH0BlzZE0NcmTMppBfMs2a4eL9Yt
   LlqUkKVBkbdNaoCydPT9PzeCKEg7W0HHsQdchztkdxCLGbO0zNddy+MHN
   rC4VzB3J0JOQnZmEzVY2CEZxpazoPaY1QQJjkimpfxqCbMHTFFAkHHeC0
   tM8atciSbm2GmRE/y8rLcsbhLYdDHzZN7SN9TBNMQUd8788htt4hFGIY2
   k6pBiHt2SR8SLc05p2kqdIifHyGTf6hOqQTQDpnsl13ys9O0QFjkoBc4M
   BdX+qJWkkPJcBIv7hGasdC1WM/BuQSoDmFbhxizu+c8hhiLHwW6vUsuW+
   Q==;
IronPort-SDR: CgKU5uQFZOtXSnflEOa9Wxs+RJ2H0l+YiQq04NIRRiPSANXRhk4mzH4dB/m3raj2w44GTjkm4P
 a/crukhRhFmiZcz8klbtG2imv91wSvGz+HJ3PKo51XZ17g+rRh1ClTO2EHTpt7Aaee6z70c45U
 bcq022hcHPMPXjDOKRC4Ng4SlgJ9N3Bpy3v4W5y3AzgI/hCo52nprmQPTilc/66Ky8DbaXQRDa
 GvXMqLUdeMNeEO/EIdCPghc7zsfqzSxYTOnlhDjorSvktcKnhLxHPtBTb/wFqWhM6NNF7pof0Q
 Kn8=
X-IronPort-AV: E=Sophos;i="5.64,411,1559491200"; 
   d="scan'208";a="117904641"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Aug 2019 14:14:32 +0800
IronPort-SDR: enE0E3BSbWZ0lvkP1xxRNohhL4LJHuEUalT42vk5hP124w4r4S3JRwtN3HrwfLSDL0Ftv8a6By
 xpv4wuPtxypizvxVauvlYHuhmbJbnUAQ2+tUppy+naNEKGyOo5ZJdCkJ2RHH+N8dMakO0b4oH8
 K1q9Jbmc7aX5KRCcpR1ctYV6EUKHGM3PGGxWp4vIXvwwDFxZY0jRlpy4Dm2SwC8D9v4FcY+qGD
 x9Iz5yoJsSruk9FLMaPPScNpzYPEXrn7pwBibknNp1xOWPVzkEHOIM+iyfjM8aKaImOJjt0n3K
 3vVqLFTPT5mD6ElPXOvL/fQe
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 23:11:54 -0700
IronPort-SDR: J1I/5bgiTFIAu8nNl9kv6CSGMFr4yg0TlUcqLzMJdDy8EZZg8n4rfy/XPfR/JjpgmOnfkVltBx
 ssjiOGwNssK5XXLGHSuoQGzY72APilAq4AuufFX7XHX3TUf6fMAFSvIG+S4BOIvcE8H6g4FFk4
 w6w8aEGbtPr28z7XjcaeIOJwLHNeebOJOnfEd1HlWA5+RnjTkgiUj/gkJ7B08lWbk1QlQ2RUaA
 iYA9zikhwLYCTW/T6a0mIofhJVPKp5ODf79l+YclGUXbyljEgCoXjsbem9ACoYAnj3ly4+ysyD
 mtk=
WDCIronportException: Internal
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip01.wdc.com with ESMTP; 20 Aug 2019 23:14:32 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V5 1/9] block: add a helper function to read nr_setcs
Date:   Tue, 20 Aug 2019 23:14:15 -0700
Message-Id: <20190821061423.3408-2-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190821061423.3408-1-chaitanya.kulkarni@wdc.com>
References: <20190821061423.3408-1-chaitanya.kulkarni@wdc.com>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch introduces helper function to read the number of sectors
from struct block_device->bd_part member. For more details Please refer
to the comment in the include/linux/genhd.h for part_nr_sects_read().

Reviewed-by: Minwoo Im <minwoo.im.dev@gmail.com>
Reviewed-by: Martin K. Petersen <martin.petersen@xxxxxxxxxx>
Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 include/linux/blkdev.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4798bb25f1ee..aa5801c8ff73 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1468,6 +1468,11 @@ static inline void put_dev_sector(Sector p)
 	put_page(p.v);
 }
 
+static inline sector_t bdev_nr_sects(struct block_device *bdev)
+{
+	return part_nr_sects_read(bdev->bd_part);
+}
+
 int kblockd_schedule_work(struct work_struct *work);
 int kblockd_schedule_work_on(int cpu, struct work_struct *work);
 int kblockd_mod_delayed_work_on(int cpu, struct delayed_work *dwork, unsigned long delay);
-- 
2.17.0

