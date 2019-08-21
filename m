Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A19197205
	for <lists+linux-bcache@lfdr.de>; Wed, 21 Aug 2019 08:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbfHUGOy (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 21 Aug 2019 02:14:54 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:49516 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727481AbfHUGOx (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Aug 2019 02:14:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566368094; x=1597904094;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=KskMhIccdhyYejQPXHxAAXs3ig7LJbUasu+JL5qAjTA=;
  b=YG4jaOgFKeTYg0ti7PvIC57yt5m9AsxQ9iU5BzcRswX/BTFd9phF3l6y
   TNkQs7JLY5LGqtASPE945Y/am4IQZus4qMZOVAmiijPkdtqC0LGHDh7ED
   CIIag/IKOTXJ5Tp6GdNAY6GZNH1UVNe5yRHxSh53w1vKPyskYH4FCbsEz
   bGDmy4jXXEwALa9bIzPDU4DxVrE7gkOMC8OQ9METyk3i/1OrWW3RZx34Z
   zygCIEV7L63/MH+VVyN6h9I/2DUDNtSHhp1dR1oYwHcpIEwYx5LagvFpM
   fzoq9/3fCv4XUtd+VwSOg6b3ZCssyq6JIB1XjE1nxWeileH6fNUOiaGwD
   A==;
IronPort-SDR: mVJm7nUgQqO3RI2g+IowUVG9hAsva9CpG7hITmQlyad1SUd0Hkt7n8qjYctfVf1JUwU2i8zku5
 ELz6xoUgkL6TGgAcAi/4Pbb6NsXI2xmpneHIyubRVM2MvyVefjQcLAOAWT0oe+td+lNNtJPXS/
 lWS9p6SCV+sj8aZSQJZ0SlzRGq8pwORoouAlgLjAfv7UNwD9oa0VgEZW+jnrtuFk9BwJBdE3If
 egHxU+WAxQwNY+NjB2DqyUp1mluKzk9JBSdafdWDZL+fLl1FLkuodHmGV0DEe8zwNh5W4+eoA0
 q+0=
X-IronPort-AV: E=Sophos;i="5.64,411,1559491200"; 
   d="scan'208";a="116306276"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Aug 2019 14:14:41 +0800
IronPort-SDR: rZsy/B4B3wwvVJpTKt5hf+tLSIV4aBjcGSJB0F5pyqqF2LRQr7RCz/RpUUxji/n1b45gZXn4tO
 JLbDaZjrT2zlapApFTNp+Y2hjM00BQ8s0FfeidZVj5sK5w/rPUWGzVP+KKwtqirtnOGGFjVjAz
 J995jgWR+9csnWPzHEKNLptbawpZy0S0NSCSRmFmgi+1dG18yG8Y2AVZwfDmUM8C6ZeFS9l5Ko
 IT3XBHrwHQ68+aPjSX/Fv5EQBOFFSySAsZR5bOZy623Wi3icEzhXxQQw6+bvlWRAbxHEmOGlDF
 lsdLjO6uIgrPiWEpcenropag
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 23:12:02 -0700
IronPort-SDR: Wkxy2ajw+rcxmh/A1OPQtV/EVpqzu8VQYhbba5Ebo14vmpR//tFwqZJh/KAarh6nBHY302sfLS
 f9y+8m+P7OM4ikcpCf+hrIOkI8rUOheGzIZa7JJEOFgHfeh6fIDpHabHw92QGl2m+MUfpkURBP
 lQz6Vvn3QwxeIwdmkjnxoiS9l0kPa0JFCdZzE8f2tfJpY+Er+2QWJkbPr0OEM04oU8Z5q+nDf8
 HlWWVyH6PtIzzUMmJlH7BSX4MKo4ABaBnXMVRa0qDzPRLG7b3ovnpkJMU1P6TTZ7PmsuGmT6Ci
 NZg=
WDCIronportException: Internal
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip01.wdc.com with ESMTP; 20 Aug 2019 23:14:40 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V5 2/9] blk-zoned: update blkdev_nr_zones() with helper
Date:   Tue, 20 Aug 2019 23:14:16 -0700
Message-Id: <20190821061423.3408-3-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190821061423.3408-1-chaitanya.kulkarni@wdc.com>
References: <20190821061423.3408-1-chaitanya.kulkarni@wdc.com>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch updates the blkdev_nr_zones() with newly introduced helper
function to read the nr_sects from block device's hd_parts with the
help if part_nr_sects_read().

Reviewed-by: Minwoo Im <minwoo.im.dev@gmail.com>
Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 block/blk-zoned.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 4bc5f260248a..3f5e9bf03486 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -93,7 +93,7 @@ unsigned int blkdev_nr_zones(struct block_device *bdev)
 	if (!blk_queue_is_zoned(q))
 		return 0;
 
-	return __blkdev_nr_zones(q, bdev->bd_part->nr_sects);
+	return __blkdev_nr_zones(q, bdev_nr_sects(bdev));
 }
 EXPORT_SYMBOL_GPL(blkdev_nr_zones);
 
-- 
2.17.0

