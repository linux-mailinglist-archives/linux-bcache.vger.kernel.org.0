Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4D135F0707
	for <lists+linux-bcache@lfdr.de>; Fri, 30 Sep 2022 11:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbiI3JCZ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 30 Sep 2022 05:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbiI3JCW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 30 Sep 2022 05:02:22 -0400
Received: from mail-m3164.qiye.163.com (mail-m3164.qiye.163.com [103.74.31.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C661F9CAD
        for <linux-bcache@vger.kernel.org>; Fri, 30 Sep 2022 02:02:16 -0700 (PDT)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m3164.qiye.163.com (Hmail) with ESMTPA id 0FE486202BE;
        Fri, 30 Sep 2022 17:02:14 +0800 (CST)
From:   mingzhe.zou@easystack.cn
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     zoumingzhe@qq.com, dongsheng.yang@easystack.cn
Subject: [PATCH 1/3] bcache: add the writeback_rate of cache_set in sysfs
Date:   Fri, 30 Sep 2022 17:02:11 +0800
Message-Id: <20220930090213.11072-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlDSU9LVkoaHxkeTk9JQhkZH1UZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hKQ1VKS0tVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NRQ6Dww6DjIWLxxIPwo4KTox
        QysaCR5VSlVKTU1PTklDTkhPQ0hIVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBTkxNTTcG
X-HM-Tid: 0a838da1caaf00a4kurm0fe486202be
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: mingzhe <mingzhe.zou@easystack.cn>

The PI controller of the writeback thread takes backing as
the control object. When multiple backings share a cache,
it is difficult for us to get the real-time writeback_rate
of cache_set.

This patch counts the writeback_rate of cache_set, and add
it in sysfs.

Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/bcache.h    |  6 ++++++
 drivers/md/bcache/super.c     |  8 ++++++++
 drivers/md/bcache/sysfs.c     |  4 ++++
 drivers/md/bcache/writeback.c | 30 ++++++++++++++++++++++++++++++
 drivers/md/bcache/writeback.h |  2 ++
 5 files changed, 50 insertions(+)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 2acda9cea0f9..4e1d2cd169cf 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -713,6 +713,12 @@ struct cache_set {
 	atomic_long_t		writeback_keys_done;
 	atomic_long_t		writeback_keys_failed;
 
+	uint64_t		writeback_rate;
+	uint64_t		writeback_rate_time;
+	uint64_t		writeback_sectors;
+	atomic_long_t		writeback_counter;
+	struct delayed_work	writeback_rate_update;
+
 	atomic_long_t		reclaim;
 	atomic_long_t		reclaimed_journal_buckets;
 	atomic_long_t		flush_write;
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index ba3909bb6bea..9db8dbe0d05c 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1904,6 +1904,14 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 	spin_lock_init(&c->btree_split_time.lock);
 	spin_lock_init(&c->btree_read_time.lock);
 
+	c->writeback_rate	= 0;
+	c->writeback_sectors	= 0;
+	c->writeback_rate_time	= local_clock();
+	atomic_long_set(&c->writeback_counter, 0);
+	INIT_DELAYED_WORK(&c->writeback_rate_update,
+			  cache_set_update_writeback_rate);
+	schedule_delayed_work(&c->writeback_rate_update, HZ);
+
 	bch_moving_init_cache_set(c);
 
 	INIT_LIST_HEAD(&c->list);
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index c6f677059214..81eb7a70295a 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -100,6 +100,7 @@ read_attribute(reclaimed_journal_buckets);
 read_attribute(flush_write);
 read_attribute(writeback_keys_done);
 read_attribute(writeback_keys_failed);
+read_attribute(cache_writeback_rate);
 read_attribute(io_errors);
 read_attribute(congested);
 read_attribute(cutoff_writeback);
@@ -768,6 +769,7 @@ SHOW(__bch_cache_set)
 		    atomic_long_read(&c->writeback_keys_done));
 	sysfs_print(writeback_keys_failed,
 		    atomic_long_read(&c->writeback_keys_failed));
+	sysfs_hprint(cache_writeback_rate, c->writeback_rate);
 
 	if (attr == &sysfs_errors)
 		return bch_snprint_string_list(buf, PAGE_SIZE, error_actions,
@@ -980,6 +982,8 @@ static struct attribute *bch_cache_set_attrs[] = {
 	&sysfs_congested_read_threshold_us,
 	&sysfs_congested_write_threshold_us,
 	&sysfs_clear_stats,
+
+	&sysfs_cache_writeback_rate,
 	NULL
 };
 ATTRIBUTE_GROUPS(bch_cache_set);
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 3f0ff3aab6f2..3174e333fd5f 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -278,6 +278,33 @@ static void update_writeback_rate(struct work_struct *work)
 	smp_mb__after_atomic();
 }
 
+void cache_set_update_writeback_rate(struct work_struct *work)
+{
+	struct cache_set *c = container_of(to_delayed_work(work),
+					   struct cache_set,
+					   writeback_rate_update);
+	uint64_t bytes, clock, delta;
+
+	clock = local_clock();
+	delta = div64_u64(clock - c->writeback_rate_time, NSEC_PER_MSEC);
+	if (delta > MSEC_PER_SEC) {
+		c->writeback_rate_time = clock;
+		/*
+		 * The c->writeback_sectors records the value of
+		 * c->writeback_counter at the last update.
+		 * So, the increment of write after the last update
+		 * is c->writeback_counter - c->writeback_sectors.
+		 */
+		c->writeback_sectors = atomic_long_sub_return(
+						c->writeback_sectors,
+						&c->writeback_counter);
+		bytes = c->writeback_sectors << 9;
+		c->writeback_rate = div_u64(bytes * MSEC_PER_SEC, delta);
+	}
+
+	schedule_delayed_work(&c->writeback_rate_update, HZ);
+}
+
 static unsigned int writeback_delay(struct cached_dev *dc,
 				    unsigned int sectors)
 {
@@ -348,6 +375,9 @@ static void write_dirty_finish(struct closure *cl)
 		atomic_long_inc(ret
 				? &dc->disk.c->writeback_keys_failed
 				: &dc->disk.c->writeback_keys_done);
+
+		atomic_long_add(KEY_SIZE(&w->key),
+				&dc->disk.c->writeback_counter);
 	}
 
 	bch_keybuf_del(&dc->writeback_keys, w);
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index 31df716951f6..7540983f2c9f 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -152,4 +152,6 @@ void bch_sectors_dirty_init(struct bcache_device *d);
 void bch_cached_dev_writeback_init(struct cached_dev *dc);
 int bch_cached_dev_writeback_start(struct cached_dev *dc);
 
+void cache_set_update_writeback_rate(struct work_struct *work);
+
 #endif
-- 
2.17.1

