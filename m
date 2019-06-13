Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66BB143791
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Jun 2019 17:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732830AbfFMPAG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 13 Jun 2019 11:00:06 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:40636 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732823AbfFMPAF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 13 Jun 2019 11:00:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560438006; x=1591974006;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VBC26O1p/NtpU2PjVzYsY1MQoQe3JQazvQ/PjsDbWN4=;
  b=DGFia5/9yooq+Xom5nEK2BdrIDLzVHeN9GXtc9xh2Wqpl9v8evoZ/cfE
   hhrzZB3wwifnRC1qSDDmj4rkWaHYfwVl+OTHwWD7Tn5wlCopN4c1KmHoN
   TrAOTb1Ul713lPPdsxsemfr/e3mJD+VJUWI5o/4lMkQqJlDGwDvQs1/S2
   wVgy4mAQdUT/syGtJ0hYEiMR+V6bYlo+m6s44Y+fzyd5R3FRgGfKooPwf
   7nreCalimDbFeonXbrHP2obsKvnUsasOu8uWDB2P/n8VVFeGd7fP9Xkou
   W68ImWj0N8vzKDj/a1iJ4nLCYckxcvXyjExU8/Ne9A587MLUWiUfoRPnl
   w==;
X-IronPort-AV: E=Sophos;i="5.63,369,1557158400"; 
   d="scan'208";a="115418338"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jun 2019 23:00:05 +0800
IronPort-SDR: RihYE+Nz9olAJKOoBJ6gtR3ByXy0VuCdSKc/24Bz9BsAa5zeXBG+0ZrwPDiH+N4cNaxhftNGSH
 KB5AAkX9n1T89ZqZSWVziNnOZGhoQPAo5AZHI6B1hI1aDZtIcB2qPJ4FIle/exLf24GYBcjCr4
 hUzaDj3ynSH8KzZlLXBN3rqw8YVOrCYlJDfuN3Oi/kMtnFJqrGoVo0puSoB4JANrtLjf8kKuxs
 G4MRUE7vhU5xUYpqEQebuCg3QQQNzReqnZee6mMxJG+xuyHFBvDuoazWJIvvjyOgD465UFh+lL
 0kVM9+he0HBNktxqQ1NMXtwC
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP; 13 Jun 2019 07:59:48 -0700
IronPort-SDR: h1RuY/8orlvoKCWmBZmvrXctNkzEu5YO4Th1rUP0mWjpFbDOMJv22E2X1f1BG0pD0VIUvGRF/K
 wuMVQAxd8n91gbNYATRmm+EyCJTmPddVXOFOPAZhHDKlfVqRfiYiRpRWPDXBhNJiwHjdYzHe0E
 IYnz6VNunrAGQflRnMo2mFcQKnS672rTQVYa+W8wn54lCwOeUqVvsqtoIEytv7ME75LBj+gSVX
 nZsS+vZdZdh6kzMIDUlkCA3HuFTTbeCyCIaqLM1aTds/j/zJ2O0eAK/ylPue14nNlWiyq066wU
 +XE=
Received: from cmercuryqemu.hgst.com ([10.202.65.32])
  by uls-op-cesaip01.wdc.com with ESMTP; 13 Jun 2019 08:00:04 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-btrace@vger.kernel.org,
        kent.overstreet@gmail.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 1/8] block: add a helper function to read nr_setcs
Date:   Thu, 13 Jun 2019 07:59:48 -0700
Message-Id: <20190613145955.4813-2-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190613145955.4813-1-chaitanya.kulkarni@wdc.com>
References: <20190613145955.4813-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch introduces helper function to read the number of sectors
from struct block_device->bd_part member. For more details Please refer
to the comment in the include/linux/genhd.h for part_nr_sects_read().

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 include/linux/blkdev.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 592669bcc536..1ae65107182a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1475,6 +1475,18 @@ static inline void put_dev_sector(Sector p)
 	put_page(p.v);
 }
 
+/* Helper function to read the bdev->bd_part->nr_sects */
+static inline sector_t bdev_nr_sects(struct block_device *bdev)
+{
+	sector_t nr_sects;
+
+	rcu_read_lock();
+	nr_sects = part_nr_sects_read(bdev->bd_part);
+	rcu_read_unlock();
+
+	return nr_sects;
+}
+
 int kblockd_schedule_work(struct work_struct *work);
 int kblockd_schedule_work_on(int cpu, struct work_struct *work);
 int kblockd_mod_delayed_work_on(int cpu, struct delayed_work *dwork, unsigned long delay);
-- 
2.19.1

