Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D282D169F
	for <lists+linux-bcache@lfdr.de>; Mon,  7 Dec 2020 17:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgLGQki (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 7 Dec 2020 11:40:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:56046 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727135AbgLGQki (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 7 Dec 2020 11:40:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 62BD2AD20;
        Mon,  7 Dec 2020 16:39:56 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 1/1] bcache: fix race between setting bdev state to none and new write request direct to backing
Date:   Tue,  8 Dec 2020 00:39:15 +0800
Message-Id: <20201207163915.126877-2-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201207163915.126877-1-colyli@suse.de>
References: <20201207163915.126877-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Dongsheng Yang <dongsheng.yang@easystack.cn>

There is a race condition in detaching as below:
A. detaching			B. Write request
(1) writing back
(2) write back done, set bdev
    state to clean.
(3) cached_dev_put() and
    schedule_work(&dc->detach);
				(4) write data [0 - 4K] directly
				    into backing and ack to user.
(5) power-failure...

When we restart this bcache device, this bdev is clean but not detached,
and read [0 - 4K], we will get unexpected old data from cache device.

To fix this problem, set the bdev state to none when we writeback done
in detaching, and then if power-failure happened as above, the data in
cache will not be used in next bcache device starting, it's detached, we
will read the correct data from backing derectly.

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c     | 9 ---------
 drivers/md/bcache/writeback.c | 9 +++++++++
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 46a00134a36a..b1a6ba9a5adb 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1114,9 +1114,6 @@ static void cancel_writeback_rate_update_dwork(struct cached_dev *dc)
 static void cached_dev_detach_finish(struct work_struct *w)
 {
 	struct cached_dev *dc = container_of(w, struct cached_dev, detach);
-	struct closure cl;
-
-	closure_init_stack(&cl);
 
 	BUG_ON(!test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags));
 	BUG_ON(refcount_read(&dc->count));
@@ -1130,12 +1127,6 @@ static void cached_dev_detach_finish(struct work_struct *w)
 		dc->writeback_thread = NULL;
 	}
 
-	memset(&dc->sb.set_uuid, 0, 16);
-	SET_BDEV_STATE(&dc->sb, BDEV_STATE_NONE);
-
-	bch_write_bdev_super(dc, &cl);
-	closure_sync(&cl);
-
 	mutex_lock(&bch_register_lock);
 
 	calc_cached_dev_sectors(dc->disk.c);
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 3c74996978da..a129e4d2707c 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -705,6 +705,15 @@ static int bch_writeback_thread(void *arg)
 			 * bch_cached_dev_detach().
 			 */
 			if (test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags)) {
+				struct closure cl;
+
+				closure_init_stack(&cl);
+				memset(&dc->sb.set_uuid, 0, 16);
+				SET_BDEV_STATE(&dc->sb, BDEV_STATE_NONE);
+
+				bch_write_bdev_super(dc, &cl);
+				closure_sync(&cl);
+
 				up_write(&dc->writeback_lock);
 				break;
 			}
-- 
2.26.2

