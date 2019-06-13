Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99BBF43796
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Jun 2019 17:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732844AbfFMPAM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 13 Jun 2019 11:00:12 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:28007 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732593AbfFMPAL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 13 Jun 2019 11:00:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560438011; x=1591974011;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QMnJHJeyK2zBHP7uZNpeZhh+2JxuOJeP7H5x5fxlm0Q=;
  b=ku+S1AH64wC9MZN7qXgoHzXCeJGMuheAtLguCx+/IcpU0b0MYPzP17NI
   1KbKwhttQstJbIYtT6xiUMaBUj+jqs/1PSsBkXMOOS67j7CykkL9rvt44
   HEVTkAK/7x6zdIJ7AP1xnLFjT4yAO78PDbG1lsOIdxT4BU5TggDUU2G6+
   vDrCnxJ3Yg2Xfyk2GT3aJMxXODeQm42qnQR4vO0i/j/KQzyK4F/kk24Su
   qJV8f2xwGki5ePq8Afw+yBkLv1jHTE/azYa5+Ll+SnNVVX9BaBvgRz/Gw
   H5WjtHgrXK4fpm0TO2iQJkk6K76LfNy4eIxttfNQJlY16G5azR57beM2I
   g==;
X-IronPort-AV: E=Sophos;i="5.63,369,1557158400"; 
   d="scan'208";a="110477836"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jun 2019 23:00:11 +0800
IronPort-SDR: 3hAtYaPybUCW7IherzczATAwuCdqRCNooFDtD5kF3THg0GUhpPDfWIRM7XRpU1rMfd+APjKmcU
 VYjpu4KYAe7Y/sHT8iIKabN2gl9dlFL/oJw9YJUISM92fIkcxiAyjMJ8UlRaO/Roa1FYJxdfjq
 lAMfKglXoHzBupKlr6/W4Wh/Axy5DT0X6/5nrir8I7jfoXN/TLIj53IRBUhsixhrOHBT5xaAAa
 KQFg4DsVzoeNvFySTxwfiWHpIZwEpw7fdcqm1jiwhCXTbbCzSXovY4QDDOiB6XDfkO3Gv10YvK
 /YwyH7j6sTAqXuWPwNl/oz5h
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP; 13 Jun 2019 07:59:54 -0700
IronPort-SDR: dz4r6fkdMMQbaQ9czUf1eIUpszHIPH2SCzb4uLNzZPD81N/J8lYnhxpeuWEj9qMJuVfRc9tbXx
 5EN9/T5qzl/OIrOklF9L6hFGOG6VWV/rx1JLvNDUZ7HmyQcAyBFqYCiLYVB8FA7t7IQzykJGVH
 Yx1PneSFY3+KEsUz9LEklkhWeC9ZBhLcHQufoSykCeZ2Cz7nug5/+k5K0t6HJKezZ1RaD2VnR7
 UsZwQHXQg93U4mt29VFdDoF//VhcHBBwV4uRhFPCRGS2PGOdxTtJ2WvCFiwDs/3or+ILCjJZo+
 JaI=
Received: from cmercuryqemu.hgst.com ([10.202.65.32])
  by uls-op-cesaip01.wdc.com with ESMTP; 13 Jun 2019 08:00:10 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-btrace@vger.kernel.org,
        kent.overstreet@gmail.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 2/8] blk-zoned: update blkdev_nr_zones() with helper
Date:   Thu, 13 Jun 2019 07:59:49 -0700
Message-Id: <20190613145955.4813-3-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190613145955.4813-1-chaitanya.kulkarni@wdc.com>
References: <20190613145955.4813-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch updates the blkdev_nr_zones() with newly introduced helper
function to read the nr_sects from block device's hd_parts with the
help if part_nr_sects_read() protected by appropriate locking.

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
2.19.1

