Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABF424C9D5
	for <lists+linux-bcache@lfdr.de>; Fri, 21 Aug 2020 04:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgHUCEk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 20 Aug 2020 22:04:40 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10247 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726983AbgHUCEj (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 20 Aug 2020 22:04:39 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7CF4D46E9A2671E94ED7;
        Fri, 21 Aug 2020 10:04:36 +0800 (CST)
Received: from DESKTOP-C3MD9UG.china.huawei.com (10.174.177.253) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Fri, 21 Aug 2020 10:04:27 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        dm-devel <dm-devel@redhat.com>,
        linux-block <linux-block@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-bcache <linux-bcache@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] block: move the PAGE_SECTORS definition into <linux/blkdev.h>
Date:   Fri, 21 Aug 2020 10:03:45 +0800
Message-ID: <20200821020345.3358-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.253]
X-CFilter-Loop: Reflected
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

There are too many PAGE_SECTORS definitions, and all of them are the
same. It looks a bit of a mess. So why not move it into <linux/blkdev.h>,
to achieve a basic and unique definition.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/block/brd.c           | 1 -
 drivers/block/null_blk_main.c | 1 -
 drivers/md/bcache/util.h      | 2 --
 include/linux/blkdev.h        | 5 +++--
 include/linux/device-mapper.h | 1 -
 5 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 2723a70eb855936..24c4687694b9f49 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -26,7 +26,6 @@
 #include <linux/uaccess.h>
 
 #define PAGE_SECTORS_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
-#define PAGE_SECTORS		(1 << PAGE_SECTORS_SHIFT)
 
 /*
  * Each block ramdisk device has a radix_tree brd_pages of pages that stores
diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index 47a9dad880af2aa..0624a26b86453ce 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -12,7 +12,6 @@
 #include "null_blk.h"
 
 #define PAGE_SECTORS_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
-#define PAGE_SECTORS		(1 << PAGE_SECTORS_SHIFT)
 #define SECTOR_MASK		(PAGE_SECTORS - 1)
 
 #define FREE_BATCH		16
diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index c029f7443190805..55196e0f37c32c6 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -15,8 +15,6 @@
 
 #include "closure.h"
 
-#define PAGE_SECTORS		(PAGE_SIZE / 512)
-
 struct closure;
 
 #ifdef CONFIG_BCACHE_DEBUG
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index bb5636cc17b91a7..b068dfc5f2ef0ab 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -949,11 +949,12 @@ static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
  * multiple of 512 bytes. Hence these two constants.
  */
 #ifndef SECTOR_SHIFT
-#define SECTOR_SHIFT 9
+#define SECTOR_SHIFT		9
 #endif
 #ifndef SECTOR_SIZE
-#define SECTOR_SIZE (1 << SECTOR_SHIFT)
+#define SECTOR_SIZE		(1 << SECTOR_SHIFT)
 #endif
+#define PAGE_SECTORS		(PAGE_SIZE / SECTOR_SIZE)
 
 /*
  * blk_rq_pos()			: the current sector
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 93096e524e43945..ffccce9b700c326 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -143,7 +143,6 @@ typedef size_t (*dm_dax_copy_iter_fn)(struct dm_target *ti, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *i);
 typedef int (*dm_dax_zero_page_range_fn)(struct dm_target *ti, pgoff_t pgoff,
 		size_t nr_pages);
-#define PAGE_SECTORS (PAGE_SIZE / 512)
 
 void dm_error(const char *message);
 
-- 
1.8.3


