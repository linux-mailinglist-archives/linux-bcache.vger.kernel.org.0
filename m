Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8172A97215
	for <lists+linux-bcache@lfdr.de>; Wed, 21 Aug 2019 08:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfHUGPT (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 21 Aug 2019 02:15:19 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:34576 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfHUGPT (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Aug 2019 02:15:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566368119; x=1597904119;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=9HCTUA025JIZSm64FGSGpZxpfChbQ94lvGtg+dmKvTo=;
  b=e5r254pm5f1d3g7KHFGUkhwbpdrg+7+BozZ+BYNrFVIs8mMlU7uDoeCW
   wdLy1RTcqoPuR6BuH7VZA+QD10JieCZE8UH0ghf03qnWZx9WGSpG/pIRJ
   Z/X+fMpb3lC5VM+OUD8baO0ih9guZ40iCLES+xQD1dRlxxpv23qRiK0Vr
   IbEWm0POGLWgYcYk5j4GfMWc7RCqE22pRUpFO2eTi4gqfdnyVbC3W5Q9C
   1ICu2gSNFYcbQ1P00IroJAvHmUmqEU+6lTIKrbvbO5RW7S9wnnNvD93O7
   rUnRPAu2ELl4YwWuNyGMtQ+1FPq/bRljMurzC4YzJn90+dhthu/lVFx5y
   Q==;
IronPort-SDR: eD4MHxrnAa6mK6OIuQ8pEcDBN7erQFnRfZPHad5zOLrPkIio4dIMEdt4F649RQpbnD2TLJQwhI
 qqbJvMR/zeycO76gQaHBTz4klDxkzapParWkZNRZF0TbuH+T6Zw0QjrOIGUpRiHtAVMwmUyW1I
 huxDeADnts7wljHlaxORKr03uOjR2z7eW4tkSY4UAb1PpV4xbYAbRzGqJcXIy9Z0wgBWQ7ZO/J
 /6VIbQqYvQVJymiv2q3015T9QyEPN+lTVpYcE9jX8lRLXRzlKIxHUDNv95+3jbnOLjjTy4fYet
 2LQ=
X-IronPort-AV: E=Sophos;i="5.64,411,1559491200"; 
   d="scan'208";a="117904728"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Aug 2019 14:15:18 +0800
IronPort-SDR: lk+I2OtviS4A0ddhsoaX8Pjmp6dgZSdlkmj96UpYIPPnODEDs10JtZ5/50HqGL2bNhDMMMWS/t
 WxG++gEhnNF2+X9G+DO+uJsiqJ1/oa8fP9KDIcJRSrYdJVYbO40/RitjpvoAtCAaJhaid98msu
 jyoLeUGT+H1dgS736WnTwrMz4E7DH4a72jN4MHMnO/E5ODmcpci3LjDa2wNtW+SXZ8883Kw9no
 bdYIUP0FgW/CCdt8eTQcWzBFNDVKMer1bXUnd928e5Kl567U6GdmaR4GLCIP0cciHyp2n23ijf
 Mw5FDOiz2SCDnkFD52CFTluL
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 23:12:40 -0700
IronPort-SDR: 1yyzw1PKyEPWh8uB2oJ4KRZ7o5fJYOCS3TLjOfJjglT/lGWvLyF7NmCbICpqjeV9uwoFw7sBmV
 nJoZ8sJ5Wdusbzi2NM2t1/6bvQvetVzJBResAGi6iRHNn8y3zCfRh7I9MBJXBsny6rNr83aMIx
 uqewzTGkqWRbDAG1nxzDKivWsjDb/QHL9tkpqMGfM2elRtbSBA3gZ1zdEE2ldZAXE6deT1xBWI
 U7VASCa1lSf94SNnDxADwyjBizyM8Y+ZkI/gi6oZJV3ZNsGYz6OiM/GGSlOshqrL1LpuA25Xqd
 ZrU=
WDCIronportException: Internal
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip01.wdc.com with ESMTP; 20 Aug 2019 23:15:18 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [COMPILE TESTED PATCH V5 8/9] target/pscsi: use helper in pscsi_get_blocks()
Date:   Tue, 20 Aug 2019 23:14:22 -0700
Message-Id: <20190821061423.3408-9-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190821061423.3408-1-chaitanya.kulkarni@wdc.com>
References: <20190821061423.3408-1-chaitanya.kulkarni@wdc.com>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch updates the pscsi_get_blocks() with newly introduced helper
function to read the nr_sects from block device's hd_parts with the
help of part_nr_sects_read().

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_pscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index c9d92b3e777d..da481edab2de 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1030,7 +1030,7 @@ static sector_t pscsi_get_blocks(struct se_device *dev)
 	struct pscsi_dev_virt *pdv = PSCSI_DEV(dev);
 
 	if (pdv->pdv_bd && pdv->pdv_bd->bd_part)
-		return pdv->pdv_bd->bd_part->nr_sects;
+		return bdev_nr_sects(pdv->pdv_bd);
 
 	return 0;
 }
-- 
2.17.0

