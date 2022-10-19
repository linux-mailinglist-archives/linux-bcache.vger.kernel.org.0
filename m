Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB58603AEF
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Oct 2022 09:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiJSHuZ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 19 Oct 2022 03:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiJSHuY (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 19 Oct 2022 03:50:24 -0400
Received: from mail-m3164.qiye.163.com (mail-m3164.qiye.163.com [103.74.31.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0BF961D77
        for <linux-bcache@vger.kernel.org>; Wed, 19 Oct 2022 00:50:18 -0700 (PDT)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m3164.qiye.163.com (Hmail) with ESMTPA id 6E86D620210;
        Wed, 19 Oct 2022 15:50:16 +0800 (CST)
From:   mingzhe.zou@easystack.cn
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     zoumingzhe@qq.com
Subject: [PATCH v2 2/2] bcache: support QoS for the writeback_rate of cache_set
Date:   Wed, 19 Oct 2022 15:50:15 +0800
Message-Id: <20221019075015.15050-2-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221019075015.15050-1-mingzhe.zou@easystack.cn>
References: <20221019075015.15050-1-mingzhe.zou@easystack.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlDTR8ZVh9JHRhOHh8ZGBlNHlUZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hKTFVKS0tVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PDo6Tjo*CTIcLwEsL04aTBER
        CFEaCUNVSlVKTU1NSk1OQ0pNQkNKVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSktPSkI3Bg++
X-HM-Tid: 0a83ef38bcd700a4kurm6e86d620210
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: mingzhe <mingzhe.zou@easystack.cn>

The PI controller of the writeback thread takes backing as
the control object, but it cannot specify the upper limit.

If the backing device is not an independent disk, too fast
writeback will also affect other business IO. For example,
when rbd is used as the backing device, the writeback_rate
is not limited, the ceph cluster will appear slow_request.

This patch supports QoS for the writeback of cache_set.

Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>

Changelog:
v2: Fix up the missing "cancel_delayed_work_sync"
v1: Original verison
---
 drivers/md/bcache/bcache.h    |  9 ++++
 drivers/md/bcache/super.c     | 12 +++++
 drivers/md/bcache/sysfs.c     | 18 +++++++
 drivers/md/bcache/writeback.c | 99 +++++++++++++++++++++++++++++++++++
 drivers/md/bcache/writeback.h |  9 ++++
 5 files changed, 147 insertions(+)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 040e1f79c505..0b1b54c5598a 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -719,6 +719,15 @@ struct cache_set {
 	atomic_long_t		writeback_counter;
 	struct delayed_work	writeback_rate_update;
 
+	uint64_t		writeback_qos_bw;
+	uint64_t		writeback_qos_io;
+	uint64_t		writeback_qos_time;
+	atomic_long_t		writeback_token_bw;
+	atomic_long_t		writeback_token_io;
+	spinlock_t		writeback_qos_lock;
+	wait_queue_head_t	writeback_qos_wait;
+	struct delayed_work	writeback_qos_update;
+
 	atomic_long_t		reclaim;
 	atomic_long_t		reclaimed_journal_buckets;
 	atomic_long_t		flush_write;
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index c314c6b242cb..a91a1c3f4055 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1700,6 +1700,7 @@ static void cache_set_free(struct closure *cl)
 	mempool_exit(&c->search);
 	kfree(c->devices);
 
+	cancel_delayed_work_sync(&c->writeback_qos_update);
 	cancel_delayed_work_sync(&c->writeback_rate_update);
 
 	list_del(&c->list);
@@ -1914,6 +1915,17 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 			  cache_set_update_writeback_rate);
 	schedule_delayed_work(&c->writeback_rate_update, HZ);
 
+	c->writeback_qos_time	= local_clock();
+	c->writeback_qos_bw	= WRITEBACK_QOS_BW_DEFAULT;
+	c->writeback_qos_io	= WRITEBACK_QOS_IOPS_DEFAULT;
+	atomic_long_set(&c->writeback_token_bw, WRITEBACK_QOS_BW_DEFAULT);
+	atomic_long_set(&c->writeback_token_io, WRITEBACK_QOS_IOPS_DEFAULT);
+	spin_lock_init(&c->writeback_qos_lock);
+	init_waitqueue_head(&c->writeback_qos_wait);
+	INIT_DELAYED_WORK(&c->writeback_qos_update,
+			  cache_set_update_writeback_qos);
+	schedule_delayed_work(&c->writeback_qos_update, HZ);
+
 	bch_moving_init_cache_set(c);
 
 	INIT_LIST_HEAD(&c->list);
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 81eb7a70295a..f3f8fce74fab 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -101,6 +101,8 @@ read_attribute(flush_write);
 read_attribute(writeback_keys_done);
 read_attribute(writeback_keys_failed);
 read_attribute(cache_writeback_rate);
+rw_attribute(cache_writeback_qos_bw);
+rw_attribute(cache_writeback_qos_iops);
 read_attribute(io_errors);
 read_attribute(congested);
 read_attribute(cutoff_writeback);
@@ -770,6 +772,8 @@ SHOW(__bch_cache_set)
 	sysfs_print(writeback_keys_failed,
 		    atomic_long_read(&c->writeback_keys_failed));
 	sysfs_hprint(cache_writeback_rate, c->writeback_rate);
+	sysfs_hprint(cache_writeback_qos_bw, c->writeback_qos_bw);
+	sysfs_print(cache_writeback_qos_iops, c->writeback_qos_io);
 
 	if (attr == &sysfs_errors)
 		return bch_snprint_string_list(buf, PAGE_SIZE, error_actions,
@@ -933,6 +937,18 @@ STORE(__bch_cache_set)
 	 */
 	sysfs_strtoul_clamp(gc_after_writeback, c->gc_after_writeback, 0, 1);
 
+	sysfs_strtoul_clamp(cache_writeback_qos_iops,
+			    c->writeback_qos_io,
+			    WRITEBACK_QOS_IOPS_MIN,
+			    WRITEBACK_QOS_IOPS_MAX);
+	if (attr == &sysfs_cache_writeback_qos_bw) {
+		uint64_t v;
+		strtoi_h_or_return(buf, v);
+		c->writeback_qos_bw = clamp_t(uint64_t, v,
+					      WRITEBACK_QOS_BW_MIN,
+					      WRITEBACK_QOS_BW_MAX);
+	}
+
 	return size;
 }
 STORE_LOCKED(bch_cache_set)
@@ -984,6 +1000,8 @@ static struct attribute *bch_cache_set_attrs[] = {
 	&sysfs_clear_stats,
 
 	&sysfs_cache_writeback_rate,
+	&sysfs_cache_writeback_qos_bw,
+	&sysfs_cache_writeback_qos_iops,
 	NULL
 };
 ATTRIBUTE_GROUPS(bch_cache_set);
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 0d9b30f5897a..1546cde68e9c 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -336,6 +336,90 @@ void cache_set_update_writeback_rate(struct work_struct *work)
 	schedule_delayed_work(&c->writeback_rate_update, HZ);
 }
 
+static inline bool cache_set_writeback_should_wait(struct cache_set *c)
+{
+	if (atomic_long_read(&c->writeback_token_bw) < 0)
+		return true;
+	if (atomic_long_read(&c->writeback_token_io) < 0)
+		return true;
+
+	return false;
+}
+
+static inline bool cache_set_writeback_qos_control(struct cache_set *c)
+{
+	int64_t delta_bw, delta_io, token_bw, token_io;
+	uint64_t clock, delta;
+
+	/*
+	 * The cache_set_writeback_qos_control() can be called
+	 * at the same time, so it needs to be locked.
+	 */
+	spin_lock(&c->writeback_qos_lock);
+
+	clock = local_clock();
+	delta = clock - c->writeback_qos_time;
+	delta = div64_u64(clock - c->writeback_qos_time, NSEC_PER_MSEC);
+	if (delta >= WRITEBACK_QOS_UPDATE_MSECS_MIN) {
+		c->writeback_qos_time = clock;
+		delta = min_t(uint64_t, delta, MSEC_PER_SEC);
+		delta_bw = div64_u64(c->writeback_qos_bw * delta, MSEC_PER_SEC);
+		delta_io = div64_u64(c->writeback_qos_io * delta, MSEC_PER_SEC);
+		token_bw = atomic_long_read(&c->writeback_token_bw) + delta_bw;
+		token_io = atomic_long_read(&c->writeback_token_io) + delta_io;
+		/*
+		 * The number of tokens in the token bucket should
+		 * not be greater than the increment of the token.
+		 * Otherwise, the token will keep increasing when
+		 * there is no dirty data to writeback.
+		 */
+		atomic_long_set(&c->writeback_token_bw, min(token_bw, delta_bw));
+		atomic_long_set(&c->writeback_token_io, min(token_io, delta_io));
+	}
+
+	if (!cache_set_writeback_should_wait(c))
+		goto out_wake_up_all;
+
+	spin_unlock(&c->writeback_qos_lock);
+	return true;
+
+out_wake_up_all:
+	wake_up_all(&c->writeback_qos_wait);
+	spin_unlock(&c->writeback_qos_lock);
+	return false;
+}
+
+void cache_set_update_writeback_qos(struct work_struct *work)
+{
+	struct cache_set *c = container_of(to_delayed_work(work),
+					   struct cache_set,
+					   writeback_qos_update);
+
+	/*
+	 * If the number of tokens in the token bucket is
+	 * negative, we need to increase the tokens faster.
+	 * Otherwise, we just need to update every second.
+	 */
+	if (cache_set_writeback_qos_control(c))
+		schedule_delayed_work(&c->writeback_qos_update,
+			msecs_to_jiffies(WRITEBACK_QOS_UPDATE_MSECS_MIN));
+	else
+		schedule_delayed_work(&c->writeback_qos_update, HZ);
+}
+
+static void writeback_wait(struct cache_set *c)
+{
+	DEFINE_WAIT(w);
+
+	if (cache_set_writeback_should_wait(c) &&
+	    cache_set_writeback_qos_control(c)) {
+		prepare_to_wait(&c->writeback_qos_wait,
+				&w, TASK_UNINTERRUPTIBLE);
+		schedule();
+		finish_wait(&c->writeback_qos_wait, &w);
+	}
+}
+
 static unsigned int writeback_delay(struct cached_dev *dc,
 				    unsigned int sectors)
 {
@@ -510,6 +594,7 @@ static void read_dirty(struct cached_dev *dc)
 	struct dirty_io *io;
 	struct closure cl;
 	uint16_t sequence = 0;
+	int64_t token_bw, token_io;
 
 	BUG_ON(!llist_empty(&dc->writeback_ordering_wait.list));
 	atomic_set(&dc->writeback_sequence_next, sequence);
@@ -589,6 +674,20 @@ static void read_dirty(struct cached_dev *dc)
 
 			down(&dc->in_flight);
 
+			/*
+			 * The number of tokens in the token bucket
+			 * is allowed to be negative, at this time
+			 * the thread needs to wait, but it will
+			 * wake up as the token increases.
+			 */
+			token_bw = atomic_long_sub_return(
+					KEY_SIZE(&w->key) << 9,
+					&dc->disk.c->writeback_token_bw);
+			token_io = atomic_long_dec_return(
+					&dc->disk.c->writeback_token_io);
+			if (token_bw < 0 || token_io < 0)
+				writeback_wait(dc->disk.c);
+
 			/*
 			 * We've acquired a semaphore for the maximum
 			 * simultaneous number of writebacks; from here
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index 7540983f2c9f..7e5a2fe03429 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -14,6 +14,14 @@
 #define WRITEBACK_RATE_UPDATE_SECS_MAX		60
 #define WRITEBACK_RATE_UPDATE_SECS_DEFAULT	5
 
+#define WRITEBACK_QOS_UPDATE_MSECS_MIN	50
+#define WRITEBACK_QOS_IOPS_DEFAULT	100000LLU
+#define WRITEBACK_QOS_IOPS_MAX		10000000LLU
+#define WRITEBACK_QOS_IOPS_MIN		1000LLU
+#define WRITEBACK_QOS_BW_DEFAULT	52428800LLU
+#define WRITEBACK_QOS_BW_MAX		107374182400LLU
+#define WRITEBACK_QOS_BW_MIN		1048576LLU
+
 #define BCH_AUTO_GC_DIRTY_THRESHOLD	50
 
 #define BCH_WRITEBACK_FRAGMENT_THRESHOLD_LOW 50
@@ -153,5 +161,6 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc);
 int bch_cached_dev_writeback_start(struct cached_dev *dc);
 
 void cache_set_update_writeback_rate(struct work_struct *work);
+void cache_set_update_writeback_qos(struct work_struct *work);
 
 #endif
-- 
2.17.1

