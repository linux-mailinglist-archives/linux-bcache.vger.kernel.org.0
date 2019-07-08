Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9F3F6289C
	for <lists+linux-bcache@lfdr.de>; Mon,  8 Jul 2019 20:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729754AbfGHSrq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 8 Jul 2019 14:47:46 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:20316 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbfGHSrq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Jul 2019 14:47:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1562611665; x=1594147665;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=fBeS4/ZwqvDjhy1b8MtLdfBATaR+YEkh8G8mPyvIJT0=;
  b=H4yH1nR1e4FzfyMqUhn9gSo/grI2RcPhhLtoTLWkMhowaMtG/Xksx8K0
   5IgBuvKCOKWn4sgYdkYzexAzy+CRov5uAXi0q1GkzElzFSUhLnfnJNQWT
   8x9Hos0ylDN1Oxq9k+M53PkfbcnEzdBz6O7/JmmTPqGmy0RvnQEwpwA/Y
   idg408KqoTjbijb9dTY7CMvNNby/0NaPTYQ6LTvtg1P+mIRrbdVSkNklz
   dDFu+kgJ85ybazBYM3pYn7Nvhf/sooq4y9HhXoB+1IpCks3MF72EKnmPv
   2wMqauqxVlNehhM8wDSyvgHqoQjKuJHgDSvj0ukKfT/ApL57wXfS3LyKN
   g==;
IronPort-SDR: pQKkVKpiL3BYJAYp2OVQbPw5Nthk/JD/kiHlnQvuHNygFXBS1lDjeZaAXqm0LAOid3L9M03c9+
 F0EHLh4xNBgLiI0yGcxsU79e5u3Xh0s91KuB5kEGn1gXXXuW6/6QC+79hKSQrWditQS0zDL81d
 mY7LRjDGJpEqFrwCmTFzumbxFBOasznfhCJz8t8FVswekAts8WbopJHIxpKOu5HfSmMShc5ikS
 Z7vySjh3o7LjwO1qC2PEQADM3tRz/1VfFCKj1irrdQZ83tgwJhv0vETYIhVaOozfDWCoYkyAl0
 Dtk=
X-IronPort-AV: E=Sophos;i="5.63,466,1557158400"; 
   d="scan'208";a="218874419"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jul 2019 02:47:45 +0800
IronPort-SDR: DCHipo5YHAO4Hx4ZpqqtTplzHohMn90+0KgJO0sVbPvFWxmodo8YEHSs1yimcMXj+4xtWuYPnB
 9LSvaoTq8aKBHYvdUrKCTIFzum3+qQ0d2903Q2+CgCELFdKgfN2JHTK3w+TVwdEJSaTy30ahWs
 sVs7B2V37wj/FFpo1CuCtI77vJNsrvzouWtMY0ZTRO9rr7cZlCpEhpy7zssBEalP98k/j8GniI
 /X68NtoDw0yrNgQft+RcD6R4SBjXdRGAAxwTnlAQDAThB5mZZUN818KBPeIp7MF+6L+n3CEMFt
 HR009elVE2L26kRWy6Nbk5di
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP; 08 Jul 2019 11:46:33 -0700
IronPort-SDR: mSzQo+wfNgERgCVFud7JBTp2NieFcrt7EnGnb+zRa7q9bK08hCzDg+CJfwLIldFz0pOGFDaOKS
 V6OLvb+6LzgoSZ8fb06fYk117r61T/uhgntkoprDYN+CpfYFFy8Z4K5aL8MlfWEEC7slAkAebQ
 RzEUF6LpJ2Fl9VRSOL/l7pBDwfnAJvdasZYCjnUsGlYv9bAJsIIK6krklHTnNtryjtwKwmHIup
 TcdxBUboya/h4ldKo3V5LNG4gKVzAq1Ws/lBSg2Eets7EHoT7i8XMvEDqQtXp9sqLszOkgy8Ka
 Yhc=
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Jul 2019 11:47:44 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V4 5/9] bcache: update cached_dev_init() with helper
Date:   Mon,  8 Jul 2019 11:47:07 -0700
Message-Id: <20190708184711.2984-6-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
References: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In the bcache when initializing the cached device we don't actually
use any sort of locking when reading the number of sectors from the
part. This patch updates the cached_dev_init() with newly introduced
helper function to read the nr_sects from block device's hd_parts with
the help of part_nr_sects_read().

Acked-by: Coly Li <colyli@suse.de>
Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/md/bcache/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 26e374fbf57c..024c52d11b0f 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1302,7 +1302,7 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
 			q->limits.raid_partial_stripes_expensive;
 
 	ret = bcache_device_init(&dc->disk, block_size,
-			 dc->bdev->bd_part->nr_sects - dc->sb.data_offset);
+			 bdev_nr_sects(dc->bdev) - dc->sb.data_offset);
 	if (ret)
 		return ret;
 
-- 
2.17.0

