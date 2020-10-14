Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64EE528DAA3
	for <lists+linux-bcache@lfdr.de>; Wed, 14 Oct 2020 09:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgJNHrP (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 14 Oct 2020 03:47:15 -0400
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:50855 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgJNHrP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 14 Oct 2020 03:47:15 -0400
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id 99934E02C92;
        Wed, 14 Oct 2020 15:47:09 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     colyli@suse.de
Cc:     linux-bcache@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 1/2] bcache: fix race between setting bdev state to none and new write request direct to backing
Date:   Wed, 14 Oct 2020 07:46:54 +0000
Message-Id: <1602661615-9715-1-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZQhhDQx9NT0lCSksdVkpNS0lNTUpNSUJMQktVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hOT1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pwg6Dhw5TD5PCVECDhQKIUNJ
        OjlPCzRVSlVKTUtJTU1KTUlCQk5NVTMWGhIXVR8UFRwIEx4VHFUCGhUcOx4aCAIIDxoYEFUYFUVZ
        V1kSC1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSElJTDcG
X-HM-Tid: 0a752613bf0820bdkuqy99934e02c92
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

There is a race condition in detaching as below:
A. detaching						B. Write request
(1) writing back
(2) write back done, set bdev state to clean.
(3) cached_dev_put() and schedule_work(&dc->detach);
							(4) write data [0 - 4K] directly into backing and ack to user.
(5) power-failure...

When we restart this bcache device, this bdev is clean but not detached, and read [0 - 4K],
we will get unexpected old data from cache device.

To fix this problem, set the bdev state to none when we writeback done in detaching,
and then if power-failure happend as above, the data in cache will not be used in next
bcache device starting, it's detached, we will read the correct data from backing derectly.

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
---
 drivers/md/bcache/super.c     | 9 ---------
 drivers/md/bcache/writeback.c | 9 +++++++++
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 1bbdc41..9298fc7 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1128,9 +1128,6 @@ static void cancel_writeback_rate_update_dwork(struct cached_dev *dc)
 static void cached_dev_detach_finish(struct work_struct *w)
 {
 	struct cached_dev *dc = container_of(w, struct cached_dev, detach);
-	struct closure cl;
-
-	closure_init_stack(&cl);
 
 	BUG_ON(!test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags));
 	BUG_ON(refcount_read(&dc->count));
@@ -1144,12 +1141,6 @@ static void cached_dev_detach_finish(struct work_struct *w)
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
index 4f4ad6b..2cd0340 100644
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
1.8.3.1

