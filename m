Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46E96437B6
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Jun 2019 17:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732948AbfFMPAo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 13 Jun 2019 11:00:44 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:64461 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732938AbfFMPAn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 13 Jun 2019 11:00:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560438043; x=1591974043;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O5KQeFcpa5oDQTKNk9Or1W6DnU5mVrpci4gg06xOIhI=;
  b=kMy6KwGUjYo0P4RJSKZf6X1cIQGJaj1C7pLwhy44/UO40k21S7EAK+jQ
   w8IZ/hzurgpJplij8fbmOANG334FSbFWsAA8kdHSxRvrkoYQfdiu+3J3D
   Xxsfa+6VE0mK0iTFqeRRqkPvMRmtlN7JSbeirTcj6ahKKsmXqXB0gmbBm
   hSqrmkzRfWVS6vg9fqSNtFJWzckGQISLyKOdu5O3DWi1i9Y24iAOjSbE5
   98v8xX3hGBXEAc63FFdOR4jmfU8pEo8GQII1YwTFRiiDiuAWOwinpO3G4
   tPR17cA7urhau/CjzbwMkQpFUf4nJT3P9rZ93ZRm2gxA1Wv5+zM4187eI
   A==;
X-IronPort-AV: E=Sophos;i="5.63,369,1557158400"; 
   d="scan'208";a="112137108"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jun 2019 23:00:38 +0800
IronPort-SDR: Sl509DC5AJd4p74XuFa74uUUmv2F8n3G70Oc7oals+9CpABVzqkNwiOdhD0h7L/tGpI5Hi5+k5
 JIx+WrYTp/BWcq0u4rJlpi/pOAcq8znRrCqL40rhodrL/IOnDjHMqsAouZNhFDG4LRtA6aPKm4
 pxwIDVX0ejBmR7e2/5ilk0tCsEOxTE1/eJYPbzBk9AAtvOf9AvYjLeQATXpxgU8yxoipvFeZxb
 QpQlLTy9PoVvxpvpV8P1TUMsMZjgDsrA80dKsPPh7l5kVItlWUlXy9/diO2y9Xqgl0z4R/GyCe
 6zg1F3az7L0N2sYFau92kMX9
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP; 13 Jun 2019 08:00:20 -0700
IronPort-SDR: GvWuNW7r2PV3qNc62iAsDmdDRIJbJV6YnZnTWhRilRu5TXO6729tqaTycEJHEjnpobzzMehZqq
 CJkJTOtD5IeTiQ7/vYdEM8r9tAciRslVf2ANzgWe/N2JD7gT41wzKkVBantCxA0VH07BmZ/ktI
 6YzlykAB5Z5R0UjH7SCP6q6lN9RCPwIBNRQ3CFpEHd6TidW56KxCRrRjHQT2lLj9+2vFrj/5ft
 Yg8jBjFqMDaJ27NAelHpRelSW4wjhG7nXaLwBD+z6Rqj5IFJC1fIAZOihZZOZF6mtDLrAKBBi5
 FhI=
Received: from cmercuryqemu.hgst.com ([10.202.65.32])
  by uls-op-cesaip01.wdc.com with ESMTP; 13 Jun 2019 08:00:36 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-btrace@vger.kernel.org,
        kent.overstreet@gmail.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [COMPILE TESTED PATCH 6/8] target/pscsi: use helper in pscsi_get_blocks()
Date:   Thu, 13 Jun 2019 07:59:53 -0700
Message-Id: <20190613145955.4813-7-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190613145955.4813-1-chaitanya.kulkarni@wdc.com>
References: <20190613145955.4813-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch updates the pscsi_get_blocks() with newly introduced helper
function to read the nr_sects from block device's hd_parts with the
help if part_nr_sects_read() protected by appropriate locking.

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

