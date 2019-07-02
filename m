Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0C7A5D578
	for <lists+linux-bcache@lfdr.de>; Tue,  2 Jul 2019 19:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbfGBRn0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 2 Jul 2019 13:43:26 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:44393 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfGBRn0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Jul 2019 13:43:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1562089413; x=1593625413;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=0UgEtdIHm7+hH9Kxhy5WBonEw4nU5YoTIqQ0fdsN3UA=;
  b=Gb4DRtMFp+7RK6GLHSNHT0I15Ks//drFAa7QzkRpOohsy0Y2ZUbQvc2z
   Fr/AN6nL7UzIzhX1458xtHg2dJJVhN+a/heSkCv5q8Or5ZQ2LTCnpVjBx
   UHJLTCjMkzg/QD0/99oHme2jlcerFClyrh54HFaLUHJlmamFGgjvkNi68
   T7Uu333MHKe0bpVFf8j+pC83UZcneoVwD8hYCiAp5B7l7+ULU5lJZqWiG
   fnZ3JgK0wNIpkrgN9HNrvW0vCr1AVQzPNdvvYXB53RzVrEUYt0XYHX2sX
   CQZ5Au/uQjpMyRQSXwtUYIzZVHnB0Sv+aWGk7jQ/HYNSZtNARvvL+a5V4
   Q==;
IronPort-SDR: cQGl3onIsKgOaFWG5QQGZxYIn913GUmhqzikVcaua/5MTFppHifeBPHm/HlNaL3pQbPzdogZS+
 4PDA0rkzTi4urfca8GGBrre215S+vxFuLPm19Z/ywrgQSx5TY0nhU7y292yaYC8tDWGAMXVftJ
 pFjrTpsTTALtv/GmSIujviE5zG74w9OtTWz6VsQ8kncIJrBj1zR77X7uhhhNLuBNv/dQoAaaSL
 aoep0K4a+mY3F/0OXqI3T4uAjid1JGgNTK0YiD3U51JsWDGRWnZqeAqYdsWq41rm/UPlGFw4G5
 NgQ=
X-IronPort-AV: E=Sophos;i="5.63,444,1557158400"; 
   d="scan'208";a="211924202"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2019 01:43:25 +0800
IronPort-SDR: y/WW7D0ePeoNzW9UBvybMDTdufz6d/iSI7Ekqy/GyqmaArQU32jd2ycYnRYrZhkMiugoWPkRQv
 YANAG9ljgWU+rSUjrSbQT3uSIAEcgzGRCzuYF1S5eAsCPMxtU2CEXrF3eqMcsbDUU5X044pTju
 bJxqPBoLfevzTEVLWzsYby3k9vrPkczjAHsHDp9Ih2lCs9f9/JwJ0i7scrC4mMqPfzklx7RWIn
 ZF3YutXnNwtv+Cl+vg4eTku89DcpbuKei9AkILy/JcN/ztTqOWapx1AI2UFYPFn542/WWR6qPP
 zzNFSayvBtZftOxDMGpZuaNF
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP; 02 Jul 2019 10:42:20 -0700
IronPort-SDR: dsdfrG+O+D0YYUKDQmR4iE3UN3zVh/hsdwUfa6x7YhTtUiGIL8CpmfkBwMDTgt0WzdLK9m8IAG
 jYsHWpvDyzppL1pgzcvOiz9dvRaFzp+UV4DGE2Qj6epyYaGFA0N+k406z9PObsn/0+cPUjLQ/X
 WE1E455mHT1sBW+V63HZhc7EKmX80L5NAxQo4WHs+RnjTp6Exnns3m6jjZroXcgog5MKSTbJER
 ZZjwX0UI2MDh6Rwc5quokKaI99tN9VzJI2KH+raddvpBf/NohnJUIwwJVnZcacJhGyuYPLliiT
 GoM=
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Jul 2019 10:43:20 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V3 5/9] bcache: update cached_dev_init() with helper
Date:   Tue,  2 Jul 2019 10:42:31 -0700
Message-Id: <20190702174236.3332-6-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
References: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
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
index 1b63ac876169..6a29ba89dae1 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1263,7 +1263,7 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
 			q->limits.raid_partial_stripes_expensive;
 
 	ret = bcache_device_init(&dc->disk, block_size,
-			 dc->bdev->bd_part->nr_sects - dc->sb.data_offset);
+			 bdev_nr_sects(dc->bdev) - dc->sb.data_offset);
 	if (ret)
 		return ret;
 
-- 
2.19.1

