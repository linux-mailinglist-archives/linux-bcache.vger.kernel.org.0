Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFD7A5D582
	for <lists+linux-bcache@lfdr.de>; Tue,  2 Jul 2019 19:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfGBRnp (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 2 Jul 2019 13:43:45 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:62012 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfGBRnp (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Jul 2019 13:43:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1562089425; x=1593625425;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=9vWWJtoonwsaTPSwwa0+qd2wOetTCt6y5aKrlPs6UYc=;
  b=Lo4nNWVM+TaAsAs9slJx39j5yFueysZsaZ5YQywXGAOOx8yk6Gxjjr3X
   4+qWgdZ06g+Quu/UShU3Nl/uCYeDasEhr7Anm2Ujq4+HgdByqLyT96wy8
   e4BtprMJiULolOseOeYx6EnZ2nJ7hvtPADg/DujjrSevhFff6hf2oqjTg
   LyAIVafsb58p5Y4aWZuEL0ZxD/EytOoxsmeZlcoF0tid2gJrXX9EfNwFv
   I+QuiUf49xH4LFDJGxehhxdMJ2p9AB3DJLXq2RZchkN4usf3tTIeg1GOn
   3yglokAs3Fd+ug8HSD01GqRD23QQ7U8JV/eyu3/TiSdGG/uCvc1QW6YNp
   Q==;
IronPort-SDR: jHVgxWTE97H2MjSW9ndpr7LZDef7f0hOSVyR5xe6JZTyWShW6907NlSZky5Z3ts3E82/Gu7dNV
 yleAgO3fzcntgVxa5rcJbEMv7PREL8XO5MVcCAUq6TWBI+Ef5g/rkfJPNo8UZ1jlxPEANIEV9o
 xg6DsqQc+fRGjQZFYu86JrlWBjQnEPkMxre8+OvaLqR9PjPbZ2GqE75HKB9b/6H6lKH7131mNS
 yN3ICyEsjUNn1oDgKz2ZXMJ1/9w+KquPd2L4U0gSCPJ/WzyHUBNvo/bltNk+yfjKQsJ3nsolN+
 /pQ=
X-IronPort-AV: E=Sophos;i="5.63,444,1557158400"; 
   d="scan'208";a="218460089"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2019 01:43:44 +0800
IronPort-SDR: Wsg8faVvcN/7yAcEPdz+/mpVheJzMDZubaVmbdK2u/U6TmBxCEdvvVBBBwbSC4YXa8zeukfeNX
 5Pa7C0vAEYCJOG6FRcgAnkvN+m3XONm+Dv/iSMZE+7K4xtlf8sVQ8+x3GmSYh46skHM4mFAiMq
 XHTH2t/OQWldr623rMLtgUpJeRrQxsty+nbVOwM57q5p85SZtXn+x3Y0I+KhuBvE9eCt3HNFEC
 Ftetmeu+nhT/h8L/pb+a4lNWOTchHEIPgWjTSs163gqDpPkiiawMACsBQLB40yyguFOHXkG2hQ
 fNUi6wwB71anZ3srtzHTuqH/
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP; 02 Jul 2019 10:42:43 -0700
IronPort-SDR: ws5rnzCM4RcXwdxe4HASEQFLH1dnYxxAMKAgVbT4JHCN2jgx943DO6rHgKP+swJs4M91iIs/sT
 gRrZoE1tIOaM6JyLKSoAUUb8hTK+NRvPlUPi1IJhe9ahYwL9curauLL4rf66dnNNMggCfCsFTI
 3/Y+IKEv41CBry2zrJeQxThbAE0FA5Lf1EnTSrQvqmPHERsJ+iVZtdFiBfteYsvau3GieAffN7
 Ri7patlKy/pzZ/QFGhDZFEMvG9Z+F8UK0U8dEwu/NxE5ZVctxdKWEE4Gv1UuEalLIUAzMIkkPs
 db8=
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Jul 2019 10:43:44 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [COMPILE TEST ONLY PATCH V3 8/9] target/pscsi: use helper in pscsi_get_blocks()
Date:   Tue,  2 Jul 2019 10:42:34 -0700
Message-Id: <20190702174236.3332-9-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
References: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
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
2.19.1

