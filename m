Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 517554779E
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2019 03:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfFQB2n (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 16 Jun 2019 21:28:43 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:7477 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727382AbfFQB2n (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 16 Jun 2019 21:28:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560734923; x=1592270923;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AA2LnVOPOxYe1k/Pufd+B/cqBzOmythSvNDNfOGknn0=;
  b=ezVUULwjWv/hSJlDlMFykyPy6BzUjisQH9avGGxUTgZ0/5r+2KCexU12
   uYdTA/JtMGC4FIvV1Z/zYUP0tr5tfBgHJUOmTBZt72za014162Ct33Hwn
   LlhMtnZviOEHqZzbUgjdamFDTazFi6l+34TcJ+GE5VK4dwgeFqTwXqvgW
   N5smyJYlXmI2g3FRXVFMYRGKxlQJ6zIk+dR+BzEIP485R42s4Rpmw9EyY
   Qyg/ywrbUiKWCA5TsKehpFbrObychGrMmvedA4LB+j7MonPncqjz964wg
   0wHcYc3sic3eQVRhVY/JFyHjvCNdE2Xiutol4/iv32l1RwixvzeJbC6nr
   Q==;
X-IronPort-AV: E=Sophos;i="5.63,383,1557158400"; 
   d="scan'208";a="112362943"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jun 2019 09:28:42 +0800
IronPort-SDR: aIBPsXjF4qrgs/AUo1mVZbEE2nM8R4mHGPCjNowDIDKNgNR3jOZltO/TSx1VEVJ3ucCiTD903V
 CfeWGs9zTEt2A+4jyfs78wv0/L2KK4WLvokvvfQ9tS2t9/XbzXAXVuhS15bo6RWJaZb5uQddR5
 WFIx+/bQCCND9l8Hd1GSHOatSYHcHHZ/LRhV5AmMw8Ibz7ybmFIsRJ1VfwXF1L6Ji+iE7Lg7PW
 9A0qArmmqf2CvB/tXVWEnrU2TdwsGDDwmucuvtUrn0q2OIlIfgzUGqf2pDil5z4w0sG1SkPOAb
 gpS4gj/wJwCf1qHH+222W6f5
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP; 16 Jun 2019 18:28:20 -0700
IronPort-SDR: vZG/+aMDeXK4QjVguvCY9Andpcz01RKE5tRvsxPIa52ZyiUUHuPVTEOqVqFmJoGaDZh9NArBYo
 4h6Ulq4/l0T1Ls1SY/Bk/8HF90YmM2MXhdHporrF0OUVkvNCighn7lyHqsMGdwNhxZ5E7CNWAk
 VR/2NmlHNMvlfeyv+fPD9axEOGvjjwznKv858ovqtt+zUKPXOe97BpllpBgv/K8fpiCD90tIW1
 WWQcbuABsaBW3smE37sXpz1m297ieYm4W7/vLDEUcKiGmybjDjJOGtUnDVeWR3fof345Agz9FK
 Ifw=
Received: from cmercuryqemu.hgst.com ([10.202.65.32])
  by uls-op-cesaip01.wdc.com with ESMTP; 16 Jun 2019 18:28:43 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, kent.overstreet@gmail.com,
        jaegeuk@kernel.org, damien.lemoal@wdc.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V2 1/7] block: add a helper function to read nr_setcs
Date:   Sun, 16 Jun 2019 18:28:26 -0700
Message-Id: <20190617012832.4311-2-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190617012832.4311-1-chaitanya.kulkarni@wdc.com>
References: <20190617012832.4311-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch introduces helper function to read the number of sectors
from struct block_device->bd_part member. For more details Please refer
to the comment in the include/linux/genhd.h for part_nr_sects_read().

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 include/linux/blkdev.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 592669bcc536..2ef1de20fd22 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1475,6 +1475,16 @@ static inline void put_dev_sector(Sector p)
 	put_page(p.v);
 }
 
+/* Helper function to read the bdev->bd_part->nr_sects */
+static inline sector_t bdev_nr_sects(struct block_device *bdev)
+{
+	sector_t nr_sects;
+
+	nr_sects = part_nr_sects_read(bdev->bd_part);
+
+	return nr_sects;
+}
+
 int kblockd_schedule_work(struct work_struct *work);
 int kblockd_schedule_work_on(int cpu, struct work_struct *work);
 int kblockd_mod_delayed_work_on(int cpu, struct delayed_work *dwork, unsigned long delay);
-- 
2.19.1

