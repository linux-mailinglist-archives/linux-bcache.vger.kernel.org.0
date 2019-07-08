Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B82A628A8
	for <lists+linux-bcache@lfdr.de>; Mon,  8 Jul 2019 20:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729761AbfGHSsI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 8 Jul 2019 14:48:08 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:53112 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbfGHSsI (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Jul 2019 14:48:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1562611729; x=1594147729;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=PIKkEzI8jjM5eH2i58/XfLrTPoIAapkGFdyFIcgq7l0=;
  b=D7m9jhZ/w7ytqY4qt57MaOvUI0X3w2TszWj+9qp6yVAWaTiNp0bMASHE
   nb53gK+Dx3ys/gr2ZSx3URTw4bpI5/a0oeZJXOKsYSQPrvq8ag61CZpXf
   DUyTXkuqRIJzKSDAKbvIgjIhCY8zEy0OXbhfNBPskLKoYBlzY4+EDdgPk
   nbrmze7bq9l7Q5ukK5LE6puwPCLuRTZv74+nmWwPlOGJtkmdarzQQxgaQ
   TZ2QfH8WJ8B2j+4j2Fn8Sq0SH0CLoAqrpICV6sZtt2LXiJ5EvSeXJm+Lp
   N0/+XdPkEqhnlg4O7dTR5h4ZJQrzIEJtp1umwSKpYkIMzxKDrKP4loJH0
   A==;
IronPort-SDR: SYJw6nnIMiB63TiQHxHc6Oesr52ywaHISi4hsjDOMWyh402oM5KiJRVlpc7uWi+dWe8RO5AGrY
 5h6pOW2ZZOVzAZo9FMF0drCzgiMWdeQI7SiFNbSz9mv5s9W6ZltjIuAZlT23iBku3WWSty35Ko
 AX4KgYXpTrcR+Db8TNQUnttuwHSZgchg+7nVL1bBrhKrHA/Luy9i+IK5hzKBWdu5tevz8nkD0R
 lTmFO7O/0XDeEqDbjMumatXTQszW3nMEpeQkRUO6qvYKdsiL06IVOfd7ak+UcCbF0JcoZXsEVh
 DW0=
X-IronPort-AV: E=Sophos;i="5.63,466,1557158400"; 
   d="scan'208";a="212364780"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jul 2019 02:48:48 +0800
IronPort-SDR: 7F0abe20jJ4Rfev6an6sV12LgquKG5mTMWnj81vwxdxoORs/HRfYQI6gvwfAe3O/Lxza/2Ksw4
 Q8s9O9Z8SBe9QOwcRwX+ypTsJwn5aYc3Eq4hIUPWrLwBxTeufkXsEsBMaWJjiQKeGISb+EXoP8
 EB0J0jZ6TAGL2v/dncy2Y92/eIrrnpaCUdMPZ3oT7OXAclZZaI+c+895pFY0bZ2oDf0957wvD9
 4aVJuiCnWnqW/zzWxOVz1qxw+0/GFmIwXBir4HC4A5pFKPJqdZw+aHpo/5oxXNknOj7MCvKOx7
 aKCk5i4lfGLdLrwuX0rUsmfl
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP; 08 Jul 2019 11:46:56 -0700
IronPort-SDR: 26GGS3luZiL/5ckkNXHpZvmNp3T9hhLG9lVgKoii3ZrNjTfbn7JDDAdDbg3EYAFCavGLZwgseq
 bZ492xPRRMIg5a4Q/mNnufyTTDO/6t+CSUsrr62FgCwL4fDxOvEe5/ShBeTSWY/Bvhpct7909Q
 fLEbyMa16Zyu2TnBE7i5FRyyZVF0XAyIGTClGLHEislCugo9rwiVPBoIuTe8R03DFt4VG2cZH/
 zk0t7Rms1al8fiv4wzxJ/f7DZivEmKC0K+mbDMQKseLJ16+Ye4oALigBMwGdWxAp4zWEJdV9tr
 7V0=
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Jul 2019 11:48:08 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V4 9/9] xen/blkback: use helper in vbd_sz()
Date:   Mon,  8 Jul 2019 11:47:11 -0700
Message-Id: <20190708184711.2984-10-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
References: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch updates the vbd_sz() macro with newly introduced helper
function to read the nr_sects from block device's hd_parts with the
help of part_nr_sects_read().

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

