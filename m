Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5CA28DAA4
	for <lists+linux-bcache@lfdr.de>; Wed, 14 Oct 2020 09:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbgJNHrR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 14 Oct 2020 03:47:17 -0400
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:50856 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbgJNHrQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 14 Oct 2020 03:47:16 -0400
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id 03CD9E02D4B;
        Wed, 14 Oct 2020 15:47:09 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     colyli@suse.de
Cc:     linux-bcache@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 2/2] bcache: send request to backing when detaching and there is no dirty
Date:   Wed, 14 Oct 2020 07:46:55 +0000
Message-Id: <1602661615-9715-2-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602661615-9715-1-git-send-email-dongsheng.yang@easystack.cn>
References: <1602661615-9715-1-git-send-email-dongsheng.yang@easystack.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZGBkfGEsZSxodTUwZVkpNS0lNTUpNSEtJQklVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hOT1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ohg6Egw6Mj4MTlEtNAsLIUgM
        KRpPCipVSlVKTUtJTU1KTUhLTkNDVTMWGhIXVR8UFRwIEx4VHFUCGhUcOx4aCAIIDxoYEFUYFUVZ
        V1kSC1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBT05KTDcG
X-HM-Tid: 0a752613c08420bdkuqy03cd9e02d4b
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

If bcache device is detaching and there is no dirty data in cache,
we should send request to backing rather than get dc->count to do
cached_dev_read or cached_dev_write.

Otherwise, if there are lots of requests here to call cached_dev_get(dc),
we could never put dc->count to be 0 where calling schedule_work(&dc->detach) to finish
detaching, that means this detaching will never finish.

This commit introduce a new bit in bcache dev flags BCACHE_DEV_DETACHING_WB_DONE, this
will be set when we finish writeback in detaching and cleared in cached_dev_detach_finish().
when the request find BCACHE_DEV_DETACHING_WB_DONE is set, that means, this request should
go into backing device directly.

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
---
 drivers/md/bcache/bcache.h    |  1 +
 drivers/md/bcache/request.c   | 11 ++++++++++-
 drivers/md/bcache/super.c     |  1 +
 drivers/md/bcache/writeback.c |  7 +++++++
 4 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 870f146..aedf211 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -265,6 +265,7 @@ struct bcache_device {
 #define BCACHE_DEV_UNLINK_DONE		2
 #define BCACHE_DEV_WB_RUNNING		3
 #define BCACHE_DEV_RATE_DW_RUNNING	4
+#define BCACHE_DEV_DETACHING_WB_DONE	5
 	int			nr_stripes;
 	unsigned int		stripe_size;
 	atomic_t		*stripe_sectors_dirty;
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index c7cadaa..94c44f2 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1194,7 +1194,16 @@ blk_qc_t cached_dev_submit_bio(struct bio *bio)
 	bio_set_dev(bio, dc->bdev);
 	bio->bi_iter.bi_sector += dc->sb.data_offset;
 
-	if (cached_dev_get(dc)) {
+	/*
+	 * If BCACHE_DEV_DETACHING_WB_DONE is set,
+	 * we should send request to backing rather than get dc->count to do
+	 * cached_dev_read or cached_dev_write. Otherwise, if there are lots
+	 * of requests here to call cached_dev_get(dc), we could never put
+	 * dc->count to be 0 where calling schedule_work(&dc->detach) to finish
+	 * detaching, that means this detaching will never finish.
+	 */
+	if (!test_bit(BCACHE_DEV_DETACHING_WB_DONE, &dc->disk.flags) &&
+	    cached_dev_get(dc)) {
 		s = search_alloc(bio, d);
 		trace_bcache_request_start(s->d, bio);
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 9298fc7..3c32ddb 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1147,6 +1147,7 @@ static void cached_dev_detach_finish(struct work_struct *w)
 	bcache_device_detach(&dc->disk);
 	list_move(&dc->list, &uncached_devices);
 
+	clear_bit(BCACHE_DEV_DETACHING_WB_DONE, &dc->disk.flags);
 	clear_bit(BCACHE_DEV_DETACHING, &dc->disk.flags);
 	clear_bit(BCACHE_DEV_UNLINK_DONE, &dc->disk.flags);
 
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 2cd0340..6799f99 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -714,6 +714,13 @@ static int bch_writeback_thread(void *arg)
 				bch_write_bdev_super(dc, &cl);
 				closure_sync(&cl);
 
+				/*
+				 * BCACHE_DEV_DETACHING_WB_DONE will tell
+				 * request should be sent directly to backing
+				 * device directly, without getting dc->count.
+				 */
+				set_bit(BCACHE_DEV_DETACHING_WB_DONE,
+					&dc->disk.flags);
 				up_write(&dc->writeback_lock);
 				break;
 			}
-- 
1.8.3.1

