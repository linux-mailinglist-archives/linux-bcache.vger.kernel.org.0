Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3924862891
	for <lists+linux-bcache@lfdr.de>; Mon,  8 Jul 2019 20:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388037AbfGHSrW (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 8 Jul 2019 14:47:22 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:31778 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbfGHSrW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Jul 2019 14:47:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1562611642; x=1594147642;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=ynS3SVE1xBuxWEb/5le/J5u09MnENI/7CT28vcHZjn8=;
  b=BfudsQEwRVLnbiVYUzG4TSf7ipub3330pzAtrJCpJzxW27M+CekGs5ml
   KqtkSxTVSNnyYBJaR0Y51s1o/9Ho1jjp2BVv86Ehd2CzxMirooE8C7oMA
   hzo1Ik9e1BAAFdizoJVfwe4WMR9LjAMlRQfBh3jKDwLZnM1XO35AdMAaT
   amn5Vxd53uCW/ZY2YKIGYRCNiodO59mfllGTGo1V6OpZmMGI8Mv9fIa8H
   1VRjbaGkDryKyKtehfCxEPLh4lToOhANi1xiM+DH4uxenU4VYsvsgya7k
   qwmy8kNzY2N8SiCrE6e8ONRPdaPmY0deuQlNSFyPLtIAZUyyTsOZA74/B
   g==;
IronPort-SDR: RDp8cmOXNGuAroY1U/Plvg3UM+2c+l4kMMyUVpemoLRjcHT2owIhEoYG4tVrjkGDXlK6NNnIAc
 m6osBCXpn43dr9SXKSPZ3sHOYfm39DR9Ze7xlABprMFkPvCXsHqQMHg2/1WtrxU8SM00JT2bJz
 LkcXmxQKjfeTu8Pdr0wnYYDqWl4ulW20czHFk92lgiQ+tLgjmcsGZNcoTgbXJw72pNJW357z7i
 WcEje3Z7HWfNoTJukDKRNkW79vDZ3pt7xtWGS/Kf21cCOzNXdqq7KfmEBeDb2WsIuS1uADGAby
 ufA=
X-IronPort-AV: E=Sophos;i="5.63,466,1557158400"; 
   d="scan'208";a="117296105"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jul 2019 02:47:22 +0800
IronPort-SDR: iQyLP/CmEyYtBcUBapNh08zdOHv5eE5PpNUGdP/EaAu6733X/POlF4azMDZwBGDko9lRQ+yWFJ
 pIlS37rcgEZYxlCzT/WDwsg1t0bKxRtGWCPuLy1NkPTnt99emua7gbaITXkWTcHcWPPvg7U19n
 IG50Y8S2Wjji3qOix5lDvuk4xTn6crYCki5LOQRKZXHYGXn9+gQt8GS36U2rHkfhSCNpxlnarH
 0gzEpzrnMW7dtSzvxhEWoOdgARMY65BaXr9OQVQDtLLr/BJ52/AdRfdXSlVz7NPs7Qxg0mYo41
 Wmx6HRa3fMrOIgoCmgvP21F5
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP; 08 Jul 2019 11:46:10 -0700
IronPort-SDR: XdrWNX/tHtwcbFCNAB6UtpjebhDmq2dIv5jQgtYneGZQJU5abS18Xxpst5IKOao5xF9DCI0hfE
 xaNjjXfl7Gy+wJkpahPgBFEUFq0XxSkv0wuJyr5ATn74oeIFo5FlSPmRmUkSaDm6J4qhHKgvbj
 fCx5bhYCef4cpXOOhHrym3RKYWASi8n2UtTD0M6qXFVWYaJt0b3P0NNZ/V/Th9cTV6+fg3R8cP
 bGRKiR96Ui7ZbwZSEA4GoKxvYPky8Mm2Rk9rD/6gna+OoY7JIG6rdt9GtjZ7CveE6MEpnuLfkT
 GXg=
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Jul 2019 11:47:21 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V4 1/9] block: add a helper function to read nr_setcs
Date:   Mon,  8 Jul 2019 11:47:03 -0700
Message-Id: <20190708184711.2984-2-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
References: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch introduces helper function to read the number of sectors
from struct block_device->bd_part member. For more details Please refer
to the comment in the include/linux/genhd.h for part_nr_sects_read().

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 include/linux/blkdev.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0c482371c8b3..578383712093 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1464,6 +1464,11 @@ static inline void put_dev_sector(Sector p)
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

