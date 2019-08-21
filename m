Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEA0997216
	for <lists+linux-bcache@lfdr.de>; Wed, 21 Aug 2019 08:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbfHUGPZ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 21 Aug 2019 02:15:25 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:37713 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727818AbfHUGPZ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Aug 2019 02:15:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566368125; x=1597904125;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uCmqVTMs+9n224hBF85AnzvmEf4HCe67ga81BlS6HHI=;
  b=MhoLzyal7MPK3ctpoS9qPOM+HyTdph2/v2awfa8qpYPLcpSYATVrcy5q
   twrsrWHD9zoBZJWwRqvB2m4NGOfg8LQS3h6o4zrLTZPz+l9F5dEnDKgUN
   24EKwsldxhKr1Kv722M28/YTC9ddECMfuaiGM8RvbrG/h/djpL0p+hIB8
   sd2unZLNqXzKVwtFFSrpCDtRhLLHOYOqtKwv/swIuOcQIwvjtdMJa+KdF
   C7lxYTENDYscA1QfyIbZypb3fsCZGDS4jaDrGrELFDNrV0KiRdsPX9NLh
   TbfN0rb1qT0puC2CPiewxTmOptI8a1j54f3NF4F/qRx3sEE8li2iq0x/q
   A==;
IronPort-SDR: 6/XICoeSWbHOQoldRyXAeykBwCQRKQRoaA0aDQQB1mHk/sEEfmCVfSHrwmWN9TkwFxngxWUKQb
 N6vBDDfXHERuJuZz2m1p5gASdBszbyLuhpbvJhym9+fGLnNcvo5RVHCy6XYVYKTDNl9XDsuG7m
 kw+GDhXwxwjEw4BAHvg/GOYKC5RmLH/FXF3+iGFzKU8gXHq7ki2JjLqpmMvMMQI3UbKnTo49Zd
 KOm7Q1EDJ4G8xrauOALESTLbD/6vcPeZ/D0zeQSc9QuT3OvRPZtOwkvtyoh4TMHpqO74bonbyP
 QQ4=
X-IronPort-AV: E=Sophos;i="5.64,411,1559491200"; 
   d="scan'208";a="117239112"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Aug 2019 14:15:24 +0800
IronPort-SDR: 0Ohb5ITSJVXJbUSWe7fW0QkaUZCAdmwPIXSREYCv6/y/OV8jK6RNUZIxRwUdK1yJEBU1d95pGA
 HzeGgAaS0JVi/sM9Qw0bxIIFHeJWePDpB4nGPvbBEXi9GFAZCR3Wq+fX1lwNcuXjKffKvEpPBv
 3ymXJmwrtfQLKS7RQZ+Rd/rK7D97iB+WC98kppMbGKYkkUtA3kdMLWfLQG7V3SsgDwgJ1LtDN/
 rxoSIUYKAgSLdB9c8K1ZpdNfgTCEf69G0wGS/iWr0szlLKWYFZLqHMCF/UNe+HK2Al0/jJwpFK
 67coq3AnDGhmi2S4qG9UoTY9
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 23:12:45 -0700
IronPort-SDR: OdxGZ+ZIUZXNxHsyk4r1jitBzzOKbws59uKyfKyGqxJAsocaYs8oIxpzZfzjt5ML1whAzbLmaX
 RwM7I6UulMIpLElfhfQc5hYfBEAbff6XiTo6OdUg2IOOnMUz0R9KML2qvnTlEseLVHNS7pyeSc
 9CTOUyji2b5zizhazjbzfCPSVvgrBe56YrLfQaH1Zt4rfNfxQIaRAfBPRZjR9OpapUegl1b+jL
 uJtoBjulj24n+tVENNu5L8VD++n13brc0PAUBMrQdHgf+PQ6TPFgyBzEVVQm4JhNIRu+VBGZP5
 OFY=
WDCIronportException: Internal
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip01.wdc.com with ESMTP; 20 Aug 2019 23:15:24 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [COMPILE TESTED PATCH V5 9/9] xen/blkback: use helper in vbd_sz()
Date:   Tue, 20 Aug 2019 23:14:23 -0700
Message-Id: <20190821061423.3408-10-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190821061423.3408-1-chaitanya.kulkarni@wdc.com>
References: <20190821061423.3408-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch updates the vbd_sz() macro with newly introduced helper
function to read the nr_sects from block device's hd_parts with the
help of part_nr_sects_read().

Acked-by: Roger Pau Monné <roger.pau@xxxxxxxxxx>
Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/block/xen-blkback/common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index 1d3002d773f7..f96cb8d1cb99 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -359,7 +359,7 @@ struct pending_req {
 
 
 #define vbd_sz(_v)	((_v)->bdev->bd_part ? \
-			 (_v)->bdev->bd_part->nr_sects : \
+			  bdev_nr_sects((_v)->bdev) : \
 			  get_capacity((_v)->bdev->bd_disk))
 
 #define xen_blkif_get(_b) (atomic_inc(&(_b)->refcnt))
-- 
2.17.0

