Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C6B741060
	for <lists+linux-bcache@lfdr.de>; Wed, 28 Jun 2023 13:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbjF1LuZ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 28 Jun 2023 07:50:25 -0400
Received: from mail-m3174.qiye.163.com ([103.74.31.74]:48184 "EHLO
        mail-m3174.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjF1LuW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 28 Jun 2023 07:50:22 -0400
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m3174.qiye.163.com (Hmail) with ESMTPA id EB8064022E;
        Wed, 28 Jun 2023 13:52:38 +0800 (CST)
From:   Mingzhe Zou <mingzhe.zou@easystack.cn>
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     bcache@lists.ewheeler.net, zoumingzhe@qq.com
Subject: [PATCH v2] Separate bch_moving_gc() from bch_btree_gc()
Date:   Wed, 28 Jun 2023 13:52:35 +0800
Message-Id: <20230628055235.255-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlCSk8YVktDHR9PTUNPGRoeQ1UZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hKTFVKS0tVS1kG
X-HM-Tid: 0a89008f9cbd00aekurmeb8064022e
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PiI6PTo5CjE#CCE9KRkuCRJK
        GjcKCk1VSlVKTUNMQkhKTk5CTk1LVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBTk9JTDcG
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
 drivers/md/bcache/bcache.h   |  4 ++-
 drivers/md/bcache/btree.c    | 66 ++++++++++++++++++++++++++++++++++--
 drivers/md/bcache/movinggc.c |  2 ++
 3 files changed, 68 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 5a79bb3c272f..155deff0ce05 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -461,7 +461,8 @@ struct cache {
 	 * until a gc finishes - otherwise we could pointlessly burn a ton of
 	 * cpu
 	 */
-	unsigned int		invalidate_needs_gc;
+	unsigned int		invalidate_needs_gc:1;
+	unsigned int		only_moving_gc:1;
 
 	bool			discard; /* Get rid of? */
 
@@ -629,6 +630,7 @@ struct cache_set {
 	struct gc_stat		gc_stats;
 	size_t			nbuckets;
 	size_t			avail_nbuckets;
+	size_t			fragment_nbuckets;
 
 	struct task_struct	*gc_thread;
 	/* Where in the btree gc currently is */
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 68b9d7ca864e..6698a4480e05 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -88,6 +88,7 @@
  * Test module load/unload
  */
 
+#define COPY_GC_PERCENT		5
 #define MAX_NEED_GC		64
 #define MAX_SAVE_PRIO		72
 #define MAX_GC_TIMES		100
@@ -1705,6 +1706,7 @@ static void btree_gc_start(struct cache_set *c)
 
 	mutex_lock(&c->bucket_lock);
 
+	set_gc_sectors(c);
 	c->gc_mark_valid = 0;
 	c->gc_done = ZERO_KEY;
 
@@ -1825,8 +1827,51 @@ static void bch_btree_gc(struct cache_set *c)
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
+	unsigned long dirty_sectors = 0, frag_sectors, used_sectors;
+
+	if (c->gc_stats.in_use > bch_cutoff_writeback_sync)
+		return true;
+
+	mutex_lock(&c->bucket_lock);
+	for_each_bucket(b, ca) {
+		if (GC_MARK(b) != GC_MARK_DIRTY)
+			continue;
+
+		used_buckets++;
+
+		used_sectors = GC_SECTORS_USED(b);
+		dirty_sectors += used_sectors;
+
+		if (used_sectors < ca->sb.bucket_size)
+			frag_buckets++;
 
-	bch_moving_gc(c);
+		if (used_sectors <= moving_gc_threshold)
+			move_buckets++;
+	}
+	mutex_unlock(&c->bucket_lock);
+
+	c->fragment_nbuckets = frag_buckets;
+	frag_sectors = used_buckets * ca->sb.bucket_size - dirty_sectors;
+	frag_percent = div_u64(frag_sectors * 100, ca->sb.bucket_size * c->nbuckets);
+
+	if (move_buckets > ca->heap.size)
+		return true;
+
+	if (frag_percent >= COPY_GC_PERCENT)
+		return true;
+
+	return false;
 }
 
 static bool gc_should_run(struct cache_set *c)
@@ -1839,6 +1884,19 @@ static bool gc_should_run(struct cache_set *c)
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
 
@@ -1856,8 +1914,10 @@ static int bch_gc_thread(void *arg)
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
index 9f32901fdad1..04da088cefe8 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -200,6 +200,8 @@ void bch_moving_gc(struct cache_set *c)
 	struct bucket *b;
 	unsigned long sectors_to_move, reserve_sectors;
 
+	c->cache->only_moving_gc = 0;
+
 	if (!c->copy_gc_enabled)
 		return;
 
-- 
2.17.1.windows.2

