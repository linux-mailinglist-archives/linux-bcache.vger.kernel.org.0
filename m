Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6E7758B7E
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Jul 2023 04:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjGSCrb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 18 Jul 2023 22:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjGSCra (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 18 Jul 2023 22:47:30 -0400
Received: from mail-m2835.qiye.163.com (mail-m2835.qiye.163.com [103.74.28.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548191BF1
        for <linux-bcache@vger.kernel.org>; Tue, 18 Jul 2023 19:47:24 -0700 (PDT)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m2835.qiye.163.com (Hmail) with ESMTPA id D28F58A004E;
        Wed, 19 Jul 2023 10:47:13 +0800 (CST)
From:   Mingzhe Zou <mingzhe.zou@easystack.cn>
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     bcache@lists.ewheeler.net, zoumingzhe@qq.com
Subject: [PATCH v2 2/3] bcache: Separate bch_moving_gc() from bch_btree_gc()
Date:   Wed, 19 Jul 2023 10:47:08 +0800
Message-Id: <20230719024709.287-2-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230719024709.287-1-mingzhe.zou@easystack.cn>
References: <20230719024709.287-1-mingzhe.zou@easystack.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkZGk8aVktNTU4dQhoZSkpIQlUZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hKTFVKS0tVS1kG
X-HM-Tid: 0a896c0b6779841dkuqwd28f58a004e
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OTo6Hjo*PjEyIlYxHBFWPRIL
        Pk1PCR5VSlVKTUNCTEhPQ0hOSklPVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBTEtLSTcG
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Mingzhe Zou <zoumingzhe@qq.com>

Moving gc uses cache->heap to defragment disk. Unlike btree gc,
moving gc only takes up part of the disk bandwidth.

The number of heap is constant. However, the buckets released by
each moving gc is limited. So bch_moving_gc() needs to be called
multiple times.

If bch_gc_thread() always calls bch_btree_gc(), it will block
the IO request.This patch allows bch_gc_thread() to only call
bch_moving_gc() when there are many fragments.

Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/bcache.h   |  4 +-
 drivers/md/bcache/btree.c    | 73 ++++++++++++++++++++++++++++++++++--
 drivers/md/bcache/movinggc.c |  7 +++-
 drivers/md/bcache/super.c    |  2 +
 4 files changed, 81 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 582df3c9dc1b..10f3f548629e 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -459,7 +459,8 @@ struct cache {
 	 * until a gc finishes - otherwise we could pointlessly burn a ton of
 	 * cpu
 	 */
-	unsigned int		invalidate_needs_gc;
+	unsigned int		invalidate_needs_gc:1;
+	unsigned int		only_moving_gc:1;
 
 	bool			discard; /* Get rid of? */
 
@@ -627,6 +628,7 @@ struct cache_set {
 	struct gc_stat		gc_stats;
 	size_t			nbuckets;
 	size_t			avail_nbuckets;
+	size_t			fragment_nbuckets;
 
 	struct task_struct	*gc_thread;
 	/* Where in the btree gc currently is */
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index ca962f329977..baa2149e9235 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -88,6 +88,7 @@
  * Test module load/unload
  */
 
+#define COPY_GC_PERCENT		5
 #define MAX_NEED_GC		64
 #define MAX_SAVE_PRIO		72
 #define MAX_GC_TIMES		100
@@ -1726,6 +1727,7 @@ static void btree_gc_start(struct cache_set *c)
 
 	mutex_lock(&c->bucket_lock);
 
+	set_gc_sectors(c);
 	c->gc_mark_valid = 0;
 	c->gc_done = ZERO_KEY;
 
@@ -1852,8 +1854,58 @@ static void bch_btree_gc(struct cache_set *c)
 	memcpy(&c->gc_stats, &stats, sizeof(struct gc_stat));
 
 	trace_bcache_gc_end(c);
+}
+
+extern unsigned int bch_cutoff_writeback;
+extern unsigned int bch_cutoff_writeback_sync;
+
+static bool moving_gc_should_run(struct cache_set *c)
+{
+	struct bucket *b;
+	struct cache *ca = c->cache;
+	size_t moving_gc_threshold = ca->sb.bucket_size >> 2, frag_percent;
+	unsigned long used_buckets = 0, frag_buckets = 0, move_buckets = 0;
+	unsigned long dirty_sectors = 0, frag_sectors = 0, used_sectors = 0;
+
+	mutex_lock(&c->bucket_lock);
+	for_each_bucket(b, ca) {
+		if (GC_MOVE(b) || GC_MARK(b) != GC_MARK_DIRTY)
+			continue;
+
+		used_buckets++;
+
+		used_sectors = b->gc_sectors_used;
+		dirty_sectors += used_sectors;
+
+		if (used_sectors < ca->sb.bucket_size)
+			frag_buckets++;
+
+		if (used_sectors <= moving_gc_threshold)
+			move_buckets++;
+	}
+	mutex_unlock(&c->bucket_lock);
+
+	c->fragment_nbuckets = frag_buckets;
 
-	bch_moving_gc(c);
+	if (used_buckets < c->nbuckets * bch_cutoff_writeback / 100)
+		return false;
+
+	if (move_buckets > ca->heap.size)
+		return true;
+
+	frag_sectors = used_buckets * ca->sb.bucket_size - dirty_sectors;
+	frag_percent = div_u64(frag_sectors * 100, ca->sb.bucket_size * c->nbuckets);
+
+	if (frag_percent >= COPY_GC_PERCENT)
+		return true;
+
+	if (used_buckets > c->nbuckets * bch_cutoff_writeback_sync / 100)
+		return true;
+
+	if (c->gc_stats.in_use > bch_cutoff_writeback_sync && frag_buckets > 0)
+		return true;
+
+	return false;
 }
 
 static bool gc_should_run(struct cache_set *c)
@@ -1866,6 +1918,19 @@ static bool gc_should_run(struct cache_set *c)
 	if (atomic_read(&c->sectors_to_gc) < 0)
 		return true;
 
+	/*
+	 * Moving gc uses cache->heap to defragment disk. Unlike btree gc,
+	 * moving gc only takes up part of the disk bandwidth.
+	 * The number of heap is constant. However, the buckets released by
+	 * each moving gc is limited. So bch_moving_gc() needs to be called
+	 * multiple times. If bch_gc_thread() always calls bch_btree_gc(),
+	 * it will block the IO request.
+	 */
+	if (c->copy_gc_enabled && moving_gc_should_run(c)) {
+		ca->only_moving_gc = 1;
+		return true;
+	}
+
 	return false;
 }
 
@@ -1883,8 +1948,10 @@ static int bch_gc_thread(void *arg)
 		    test_bit(CACHE_SET_IO_DISABLE, &c->flags))
 			break;
 
-		set_gc_sectors(c);
-		bch_btree_gc(c);
+		if (!c->cache->only_moving_gc)
+			bch_btree_gc(c);
+
+		bch_moving_gc(c);
 	}
 
 	wait_for_kthread_stop();
diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index e4182c3ba9f8..2c3cb1b6e0af 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -200,6 +200,8 @@ void bch_moving_gc(struct cache_set *c)
 	struct bucket *b;
 	unsigned long sectors_to_move, reserve_sectors;
 
+	c->cache->only_moving_gc = 0;
+
 	if (!c->copy_gc_enabled)
 		return;
 
@@ -212,7 +214,7 @@ void bch_moving_gc(struct cache_set *c)
 	ca->heap.used = 0;
 
 	for_each_bucket(b, ca) {
-		if (GC_MARK(b) == GC_MARK_METADATA ||
+		if (GC_MOVE(b) || GC_MARK(b) == GC_MARK_METADATA ||
 		    !b->gc_sectors_used ||
 		    b->gc_sectors_used == ca->sb.bucket_size ||
 		    atomic_read(&b->pin))
@@ -229,6 +231,9 @@ void bch_moving_gc(struct cache_set *c)
 			heap_sift(&ca->heap, 0, bucket_cmp);
 		}
 	}
+ 
+	pr_info("moving gc: on set %pU, %lu sectors from %zu buckets",
+		c->set_uuid, sectors_to_move, ca->heap.used);
 
 	while (sectors_to_move > reserve_sectors) {
 		heap_pop(&ca->heap, b, bucket_cmp);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 0ae2b3676293..7e556bc0ec04 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2112,6 +2112,8 @@ static int run_cache_set(struct cache_set *c)
 	if (bch_gc_thread_start(c))
 		goto err;
 
+	force_wake_up_gc(c);
+
 	closure_sync(&cl);
 	c->cache->sb.last_mount = (u32)ktime_get_real_seconds();
 	bcache_write_super(c);
-- 
2.17.1.windows.2

