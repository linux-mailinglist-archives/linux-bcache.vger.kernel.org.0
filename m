Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F84D62893
	for <lists+linux-bcache@lfdr.de>; Mon,  8 Jul 2019 20:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388367AbfGHSr2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 8 Jul 2019 14:47:28 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:33559 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbfGHSr2 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Jul 2019 14:47:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1562611648; x=1594147648;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=BLEYyqiHt/Wv6nLWVBfIZztbC5fI1sQcHli3j0z2Rjw=;
  b=qjhaFsekgVu0cRARq3vV6acEL8US66ReUsmNN/nT4kJhL4pFBFyf2Wgf
   q4yrG9Qe1eTCmAMAnVG2WaKvccbuq73vzHEtPe86ff47QCNrgTOGkAQN3
   qftNplTw/79ba9LQJ1ZCj275T1anyyD/YuzBud878meS7XbqKH64rurli
   oY8McbazFnPA+6NtoaUhFEqSbqwuV1hINc4rHurTjo3NfDnLjhLNkxFL4
   grNPm22FKatmk1sUJJvBD91lK/TQ/W9vAZHXuIeJhdJtO5PgWYD5hiuae
   HZPDIhcYCwAkRvQguJo9YiRD726oX2aBZBsMZquZ77oIJ/dhd+ok+IO3F
   g==;
IronPort-SDR: QbPiQpAGhH93y+VlpxHVE627bpUli33APC+x7ek8a/Ev2YaYMx7a7GulDdh02ae9UhciDv0zfE
 sSSxuhDqGzVCe10ergPEm4cwwbDiAu6N7gLE1Qq+bOt75zyU5GDgLRjeg106PpTMajSlEeT2sW
 asgmsWgqQyA9jpEQx4cHs9ZHg2/JeZ6w0RfWF+KiHtaag4D5AzggkJI+/cVmUSC/TkgRKH0Bo+
 sd6+TEmd+i/HvzUk4yrJHUmfAa3rM6M44IYcZ/URODwi+L/uH3SATZvnKPavRVK1oZPycYVaz5
 Evs=
X-IronPort-AV: E=Sophos;i="5.63,466,1557158400"; 
   d="scan'208";a="114094080"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jul 2019 02:47:28 +0800
IronPort-SDR: E6L2P1FXIRezsyTNejzLazahkgMrcwlrXo+Sp3KZSgcN++52GVUDDmGMphtUYPN7wRl+IRp3gl
 O3Lb2lYogKLOa6Xk6YNpQgOz9w9ZXUP8hSSjITbEff0fqU15rS1Yiou5LLkQ4Np19ST6Qz6DE2
 x68C3ssJA/xh0wsQkGm6H/ndKvnVAMhSskGm3a2qpcFK+Xje6FFev2W0uIGVs4n2vWjBch+zUO
 xpPp3a7gfYPXAR/l7wM3MpP68RHKp9crmJflHl2ngtyd3F0VXJdPwnrU72Xjc7m6wY6MbrXZLP
 gB6NiShcUe9K5GqjMVdBrXLL
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP; 08 Jul 2019 11:46:16 -0700
IronPort-SDR: YRRx/EURyyId2rAn63ItMGwUJucXOYj/rfVXRkkyVSj/PtgC9c92Thdp63KOL6fYEaXTRbz/kU
 1mfBfPgUOnEpRMI0FiaKN+4XSPY3ldYWJMZobspJSp2ODImnKlumR4tmOV5PAQQ9SRk3E9POWF
 VPn16WelTwmPiXdpUSqS8jeH0LDODQfnndrN7Ms33RFBa41zXzdS74G4tpcHX6MAZ8OgbHv1yL
 vhfCazKm6xZfVAQUDl0uXtbCaC0Nxr3Nufc6fjTg69fyi/C5Z3rd6iqUXjZe0g0eJdugYt0WSc
 KC0=
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Jul 2019 11:47:26 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V4 2/9] blk-zoned: update blkdev_nr_zones() with helper
Date:   Mon,  8 Jul 2019 11:47:04 -0700
Message-Id: <20190708184711.2984-3-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
References: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
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
2.17.0

