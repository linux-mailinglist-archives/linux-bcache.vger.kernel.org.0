Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3EBC687396
	for <lists+linux-bcache@lfdr.de>; Thu,  2 Feb 2023 04:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbjBBDD5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 1 Feb 2023 22:03:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbjBBDDp (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Feb 2023 22:03:45 -0500
Received: from mail-m3164.qiye.163.com (mail-m3164.qiye.163.com [103.74.31.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E11C77DDB
        for <linux-bcache@vger.kernel.org>; Wed,  1 Feb 2023 19:03:13 -0800 (PST)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m3164.qiye.163.com (Hmail) with ESMTPA id D5DB262024F;
        Thu,  2 Feb 2023 11:02:32 +0800 (CST)
From:   mingzhe.zou@easystack.cn
To:     colyli@suse.de, andrea.tomassetti-opensource@devo.com,
        bcache@lists.ewheeler.net
Cc:     kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        zoumingzhe@qq.com, Dongsheng Yang <dongsheng.yang@easystack.cn>,
        mingzhe <mingzhe.zou@easystack.cn>
Subject: [PATCH v2 1/3] bcache: make writeback inflight configurable in sysfs
Date:   Thu,  2 Feb 2023 11:02:19 +0800
Message-Id: <20230202030221.14397-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlCGExOVk5OGEJLGhkeHkNOS1UZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hKTFVKS0tVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OBg6NAw*NzIBNRAqIkMNAzE*
        TAgaC0NVSlVKTUxOSEtNQk5ITEhLVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBTElKTTcG
X-HM-Tid: 0a8610136a1c00a4kurmd5db262024f
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Dongsheng Yang <dongsheng.yang@easystack.cn>

This commit introduce a new sysfs file:
/sys/block/bcache0/bcache/writeback_inflight (read only)
/sys/block/bcache0/bcache/writeback_inflight_max (read write)

(1) read the writeback_inflight will output the current inflight writeback op.
(2）read the writeback_inflight_max will output the max number of writeback inflight.
(3) write the writeback_inflight_max can set the max number of writeback inflight,
valid range is [1, INT_MAX).

E.g:
 $ ll /sys/block/bcache0/bcache/writeback_inflight*
-r--r--r-- 1 root root 4096 Oct 27 08:45 /sys/block/bcache0/bcache/writeback_inflight
-rw-r--r-- 1 root root 4096 Oct 27 08:45 /sys/block/bcache0/bcache/writeback_inflight_max
 $ cat /sys/block/bcache0/bcache/writeback_inflight
0
 $ cat /sys/block/bcache0/bcache/writeback_inflight_max
64
 $ echo 1024 > /sys/block/bcache0/bcache/writeback_inflight_max
 $ cat /sys/block/bcache0/bcache/writeback_inflight_max
1024

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/bcache.h    |  6 ++++-
 drivers/md/bcache/sysfs.c     | 21 +++++++++++++++++
 drivers/md/bcache/writeback.c | 43 ++++++++++++++++++++++++++++++++---
 3 files changed, 66 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index aebb7ef10e63..74434a7730bb 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -337,7 +337,11 @@ struct cached_dev {
 	struct delayed_work	writeback_rate_update;
 
 	/* Limit number of writeback bios in flight */
-	struct semaphore	in_flight;
+	atomic_t		wb_inflight;
+	unsigned long		wb_inflight_max;
+	spinlock_t		wb_inflight_lock;
+	wait_queue_head_t	wb_inflight_wait;
+
 	struct task_struct	*writeback_thread;
 	struct workqueue_struct	*writeback_write_wq;
 
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index c6f677059214..0382b70c29d5 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -119,6 +119,9 @@ rw_attribute(writeback_delay);
 rw_attribute(writeback_rate);
 rw_attribute(writeback_consider_fragment);
 
+read_attribute(writeback_inflight);
+rw_attribute(writeback_inflight_max);
+
 rw_attribute(writeback_rate_update_seconds);
 rw_attribute(writeback_rate_i_term_inverse);
 rw_attribute(writeback_rate_p_term_inverse);
@@ -201,6 +204,8 @@ SHOW(__bch_cached_dev)
 	var_printf(writeback_consider_fragment,	"%i");
 	var_print(writeback_delay);
 	var_print(writeback_percent);
+	sysfs_printf(writeback_inflight, "%i", atomic_read(&dc->wb_inflight));
+	sysfs_printf(writeback_inflight_max, "%li", dc->wb_inflight_max);
 	sysfs_hprint(writeback_rate,
 		     wb ? atomic_long_read(&dc->writeback_rate.rate) << 9 : 0);
 	sysfs_printf(io_errors,		"%i", atomic_read(&dc->io_errors));
@@ -448,6 +453,20 @@ STORE(__cached_dev)
 	if (attr == &sysfs_detach && dc->disk.c)
 		bch_cached_dev_detach(dc);
 
+	if (attr == &sysfs_writeback_inflight_max) {
+		ssize_t ret;
+		unsigned long v;
+
+		ret = strtoul_safe_clamp(buf, v, 1, INT_MAX);
+		if (ret)
+			return ret;
+
+		spin_lock(&dc->wb_inflight_lock);
+		dc->wb_inflight_max = v;
+		spin_unlock(&dc->wb_inflight_lock);
+		wake_up(&dc->wb_inflight_wait);
+	}
+
 	if (attr == &sysfs_stop)
 		bcache_device_stop(&dc->disk);
 
@@ -514,6 +533,8 @@ static struct attribute *bch_cached_dev_attrs[] = {
 	&sysfs_writeback_running,
 	&sysfs_writeback_delay,
 	&sysfs_writeback_percent,
+	&sysfs_writeback_inflight,
+	&sysfs_writeback_inflight_max,
 	&sysfs_writeback_rate,
 	&sysfs_writeback_consider_fragment,
 	&sysfs_writeback_rate_update_seconds,
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index d4a5fc0650bb..0c5f25816e2e 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -348,6 +348,7 @@ static void dirty_io_destructor(struct closure *cl)
 	kfree(io);
 }
 
+static void end_wb_inflight(struct cached_dev *dc);
 static void write_dirty_finish(struct closure *cl)
 {
 	struct dirty_io *io = container_of(cl, struct dirty_io, cl);
@@ -382,7 +383,7 @@ static void write_dirty_finish(struct closure *cl)
 	}
 
 	bch_keybuf_del(&dc->writeback_keys, w);
-	up(&dc->in_flight);
+	end_wb_inflight(dc);
 
 	closure_return_with_destructor(cl, dirty_io_destructor);
 }
@@ -471,6 +472,38 @@ static void read_dirty_submit(struct closure *cl)
 	continue_at(cl, write_dirty, io->dc->writeback_write_wq);
 }
 
+static void start_wb_inflight(struct cached_dev *dc)
+{
+	DEFINE_WAIT(w);
+
+	spin_lock(&dc->wb_inflight_lock);
+	if (atomic_read(&dc->wb_inflight) < dc->wb_inflight_max)
+		goto out;
+
+	do {
+		prepare_to_wait(&dc->wb_inflight_wait, &w,
+				TASK_UNINTERRUPTIBLE);
+
+		spin_unlock(&dc->wb_inflight_lock);
+		schedule();
+		spin_lock(&dc->wb_inflight_lock);
+	} while (atomic_read(&dc->wb_inflight) >= dc->wb_inflight_max);
+
+	finish_wait(&dc->wb_inflight_wait, &w);
+
+out:
+	BUG_ON(atomic_inc_return(&dc->wb_inflight) > dc->wb_inflight_max);
+	spin_unlock(&dc->wb_inflight_lock);
+}
+
+static void end_wb_inflight(struct cached_dev *dc)
+{
+	spin_lock(&dc->wb_inflight_lock);
+	BUG_ON(atomic_dec_return(&dc->wb_inflight) < 0);
+	spin_unlock(&dc->wb_inflight_lock);
+	wake_up(&dc->wb_inflight_wait);
+}
+
 static void read_dirty(struct cached_dev *dc)
 {
 	unsigned int delay = 0;
@@ -557,7 +590,7 @@ static void read_dirty(struct cached_dev *dc)
 
 			trace_bcache_writeback(&w->key);
 
-			down(&dc->in_flight);
+			start_wb_inflight(dc);
 
 			/*
 			 * We've acquired a semaphore for the maximum
@@ -1025,7 +1058,11 @@ void bch_sectors_dirty_init(struct bcache_device *d)
 
 void bch_cached_dev_writeback_init(struct cached_dev *dc)
 {
-	sema_init(&dc->in_flight, 64);
+	atomic_set(&dc->wb_inflight, 0);
+	dc->wb_inflight_max = 64;
+	spin_lock_init(&dc->wb_inflight_lock);
+	init_waitqueue_head(&dc->wb_inflight_wait);
+
 	init_rwsem(&dc->writeback_lock);
 	bch_keybuf_init(&dc->writeback_keys);
 
-- 
2.17.1

