Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228F13D06D4
	for <lists+linux-bcache@lfdr.de>; Wed, 21 Jul 2021 04:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhGUCNh (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 20 Jul 2021 22:13:37 -0400
Received: from out0.migadu.com ([94.23.1.103]:33985 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230338AbhGUCNf (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 20 Jul 2021 22:13:35 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1626836048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=51YmTxfzNKlavCo7kR2iu6L2+V7nhQlMITqRfus3ojA=;
        b=Z57qvvuWbcxm2Nn+VDVR4Z4vhVgvhyA1kUFtx0jZaLuiO23uJC6cKqpd6HUFJvqL+d0aTi
        5Yx0k0fKSDI36JlzljzXutCFMx5f9TO5WDlBq4ZrTy0YtZn6o07/mlADbsVYHjWIG7VYsd
        Q3BSkmrJGR4eHuE374NksLLdTx3lhTs=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     axboe@kernel.dk, colyli@suse.de, kent.overstreet@gmail.com,
        agk@redhat.com, snitzer@redhat.com
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-bcache@vger.kernel.org
Subject: [PATCH] block: move some macros to blkdev.h
Date:   Wed, 21 Jul 2021 10:53:15 +0800
Message-Id: <20210721025315.1729118-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Guoqing Jiang <jiangguoqing@kylinos.cn>

Move them (PAGE_SECTORS_SHIFT, PAGE_SECTORS and SECTOR_MASK) to the
generic header file to remove redundancy.

Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
---
 drivers/block/brd.c           | 3 ---
 drivers/block/null_blk/main.c | 4 ----
 drivers/md/bcache/util.h      | 2 --
 include/linux/blkdev.h        | 4 ++++
 include/linux/device-mapper.h | 1 -
 5 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 95694113e38e..58ec167aa018 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -27,9 +27,6 @@
 
 #include <linux/uaccess.h>
 
-#define PAGE_SECTORS_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
-#define PAGE_SECTORS		(1 << PAGE_SECTORS_SHIFT)
-
 /*
  * Each block ramdisk device has a radix_tree brd_pages of pages that stores
  * the pages containing the block device's contents. A brd page's ->index is
diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index d734e9ee1546..f128242d1170 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -11,10 +11,6 @@
 #include <linux/init.h>
 #include "null_blk.h"
 
-#define PAGE_SECTORS_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
-#define PAGE_SECTORS		(1 << PAGE_SECTORS_SHIFT)
-#define SECTOR_MASK		(PAGE_SECTORS - 1)
-
 #define FREE_BATCH		16
 
 #define TICKS_PER_SEC		50ULL
diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index bca4a7c97da7..b64460a76267 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -15,8 +15,6 @@
 
 #include "closure.h"
 
-#define PAGE_SECTORS		(PAGE_SIZE / 512)
-
 struct closure;
 
 #ifdef CONFIG_BCACHE_DEBUG
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3177181c4326..0d0b6967c954 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -941,6 +941,10 @@ static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
 #define SECTOR_SIZE (1 << SECTOR_SHIFT)
 #endif
 
+#define PAGE_SECTORS_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
+#define PAGE_SECTORS		(1 << PAGE_SECTORS_SHIFT)
+#define SECTOR_MASK		(PAGE_SECTORS - 1)
+
 /*
  * blk_rq_pos()			: the current sector
  * blk_rq_bytes()		: bytes left in the entire request
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 7457d49acf9a..94f2cd6a8e83 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -151,7 +151,6 @@ typedef size_t (*dm_dax_copy_iter_fn)(struct dm_target *ti, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *i);
 typedef int (*dm_dax_zero_page_range_fn)(struct dm_target *ti, pgoff_t pgoff,
 		size_t nr_pages);
-#define PAGE_SECTORS (PAGE_SIZE / 512)
 
 void dm_error(const char *message);
 
-- 
2.25.1

