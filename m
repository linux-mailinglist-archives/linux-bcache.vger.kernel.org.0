Return-Path: <linux-bcache+bounces-388-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B5AA89B48A
	for <lists+linux-bcache@lfdr.de>; Mon,  8 Apr 2024 01:03:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0D871F20F62
	for <lists+linux-bcache@lfdr.de>; Sun,  7 Apr 2024 23:03:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A42C29CFD;
	Sun,  7 Apr 2024 23:03:28 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C947745C12
	for <linux-bcache@vger.kernel.org>; Sun,  7 Apr 2024 23:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.205.220.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712531007; cv=none; b=Z9LP16NhtCqB+0KBtuCM0WGglL+wWC1O9FHGZkN8NP0n98E8m//X9kEuekJQXK1uPHCc1AHFRiWddnbp9ZDzRPgap9F2SvR83qLQDpN1LGSF2cQ8HvlyotFGSVlrXGAvqmlbnXBKNOzDW/OvQIVv52hKaXSJHqS8DSp93z40xOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712531007; c=relaxed/simple;
	bh=zDJ5ivWyD0isjvcsFAdORjXy4Kdn25p7KgH9Up4lK8I=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=CufpMwlFudhzbGNVzBLnlklOa2Tjv0kAlax6PwxwuWAVJJ8AfRa+z32+7a1ev5qAah28kySTaSNT3J3GSapzEcizLo360is7YTYi2qphc2LgKR2nmlWU/BcIEn8XRrgFP3mV4mTjHIEKfZBr5YCX+V1rj92y2VqZG/JyvFR8ceM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net; spf=none smtp.mailfrom=lists.ewheeler.net; arc=none smtp.client-ip=173.205.220.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=lists.ewheeler.net
Received: from localhost (localhost [127.0.0.1])
	by mx.ewheeler.net (Postfix) with ESMTP id CDF278B;
	Sun,  7 Apr 2024 15:54:40 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
	by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id aJ-84rP1vdU2; Sun,  7 Apr 2024 15:54:36 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx.ewheeler.net (Postfix) with ESMTPSA id 3F58946;
	Sun,  7 Apr 2024 15:54:36 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 3F58946
Date: Sun, 7 Apr 2024 15:54:30 -0700 (PDT)
From: Eric Wheeler <bcache@lists.ewheeler.net>
To: colyli@suse.de
cc: linux-bcache@vger.kernel.org, zoumingzhe@qq.com, mingzhe.zou@easystack.cn
Subject: [PATCH v3] bcache patches to review from 7/19/23
Message-ID: <f11efb2e-824-c934-1d68-91a09dcb2dbd@ewheeler.net>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi Coly,

Did you see the patches from Mingzhe from July 19th?  They look like good 
ideas but I've not seen any traction or commentary yet.  Below they are 
forwarded for your reference.


--
Eric Wheeler

---------- Forwarded message ----------
In-Reply-To: <20230719072753.366-1-mingzhe.zou@easystack.cn>
Date: Wed, 19 Jul 2023 15:27:52 +0800
To: colyli@suse.de, linux-bcache@vger.kernel.org
Cc: bcache@lists.ewheeler.net, zoumingzhe@qq.com
From: Mingzhe Zou <mingzhe.zou@easystack.cn>
Subject: [PATCH v3 2/3] bcache: Separate bch_moving_gc() from bch_btree_gc()

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




---------- Forwarded message ----------
Date: Wed, 19 Jul 2023 15:27:51 +0800
To: colyli@suse.de, linux-bcache@vger.kernel.org
Cc: bcache@lists.ewheeler.net, zoumingzhe@qq.com
From: Mingzhe Zou <mingzhe.zou@easystack.cn>
Subject: [PATCH v3 1/3] bcache: the gc_sectors_used size matches the bucket size

From: Mingzhe Zou <zoumingzhe@qq.com>

The bucket size in the superblock is defined as uint16_t.
But, GC_SECTORS_USED is only 13 bits. If the bucket size
is 4M (8192 sectors), GC_SECTORS_USED will be truncated
to MAX_GC_SECTORS_USED.

GC_SECTORS_USED is the moving gc sorting condition, we
should try our best to ensure it is correct.

Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/alloc.c     | 12 ++++++++----
 drivers/md/bcache/bcache.h    | 12 ++++++------
 drivers/md/bcache/btree.c     | 18 ++++++++++++------
 drivers/md/bcache/movinggc.c  | 14 +++++++-------
 drivers/md/bcache/sysfs.c     |  2 +-
 include/trace/events/bcache.h |  2 +-
 6 files changed, 35 insertions(+), 25 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index ce13c272c387..4ae1018bf029 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -142,7 +142,7 @@ void __bch_invalidate_one_bucket(struct cache *ca, struct bucket *b)
 	lockdep_assert_held(&ca->set->bucket_lock);
 	BUG_ON(GC_MARK(b) && GC_MARK(b) != GC_MARK_RECLAIMABLE);
 
-	if (GC_SECTORS_USED(b))
+	if (b->gc_sectors_used)
 		trace_bcache_invalidate(ca, b - ca->buckets);
 
 	bch_inc_gen(ca, b);
@@ -170,7 +170,7 @@ static void bch_invalidate_one_bucket(struct cache *ca, struct bucket *b)
 ({									\
 	unsigned int min_prio = (INITIAL_PRIO - ca->set->min_prio) / 8;	\
 									\
-	(b->prio - ca->set->min_prio + min_prio) * GC_SECTORS_USED(b);	\
+	(b->prio - ca->set->min_prio + min_prio) * b->gc_sectors_used;	\
 })
 
 #define bucket_max_cmp(l, r)	(bucket_prio(l) < bucket_prio(r))
@@ -446,7 +446,11 @@ long bch_bucket_alloc(struct cache *ca, unsigned int reserve, bool wait)
 
 	BUG_ON(atomic_read(&b->pin) != 1);
 
-	SET_GC_SECTORS_USED(b, ca->sb.bucket_size);
+	/*
+	 * If gc_sectors_used is 0, moving gc is preferred. But the new bucket
+	 * should not do moving gc. So we set gc_sectors_used to the maximum.
+	 */
+	b->gc_sectors_used = ca->sb.bucket_size;
 
 	if (reserve <= RESERVE_PRIO) {
 		SET_GC_MARK(b, GC_MARK_METADATA);
@@ -469,7 +473,7 @@ long bch_bucket_alloc(struct cache *ca, unsigned int reserve, bool wait)
 void __bch_bucket_free(struct cache *ca, struct bucket *b)
 {
 	SET_GC_MARK(b, 0);
-	SET_GC_SECTORS_USED(b, 0);
+	b->gc_sectors_used = 0;
 
 	if (ca->set->avail_nbuckets < ca->set->nbuckets) {
 		ca->set->avail_nbuckets++;
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 5a79bb3c272f..582df3c9dc1b 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -197,9 +197,10 @@
 struct bucket {
 	atomic_t	pin;
 	uint16_t	prio;
+	uint16_t	flag;
 	uint8_t		gen;
 	uint8_t		last_gc; /* Most out of date gen in the btree */
-	uint16_t	gc_mark; /* Bitfield used by GC. See below for field */
+	uint16_t	gc_sectors_used;
 };
 
 /*
@@ -207,14 +208,11 @@ struct bucket {
  * as multiple threads touch struct bucket without locking
  */
 
-BITMASK(GC_MARK,	 struct bucket, gc_mark, 0, 2);
 #define GC_MARK_RECLAIMABLE	1
 #define GC_MARK_DIRTY		2
 #define GC_MARK_METADATA	3
-#define GC_SECTORS_USED_SIZE	13
-#define MAX_GC_SECTORS_USED	(~(~0ULL << GC_SECTORS_USED_SIZE))
-BITMASK(GC_SECTORS_USED, struct bucket, gc_mark, 2, GC_SECTORS_USED_SIZE);
-BITMASK(GC_MOVE, struct bucket, gc_mark, 15, 1);
+BITMASK(GC_MARK, struct bucket, flag, 0, 2);
+BITMASK(GC_MOVE, struct bucket, flag, 2, 1);
 
 #include "journal.h"
 #include "stats.h"
@@ -764,6 +762,8 @@ struct bbio {
 #define bucket_bytes(ca)	((ca)->sb.bucket_size << 9)
 #define block_bytes(ca)		((ca)->sb.block_size << 9)
 
+#define MAX_BUCKET_SIZE		(~(~0ULL << 16)) /* sectors */
+
 static inline unsigned int meta_bucket_pages(struct cache_sb *sb)
 {
 	unsigned int n, max_pages;
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index fd121a61f17c..ca962f329977 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1255,11 +1255,11 @@ static uint8_t __bch_btree_mark_key(struct cache_set *c, int level,
 			SET_GC_MARK(g, GC_MARK_RECLAIMABLE);
 
 		/* guard against overflow */
-		SET_GC_SECTORS_USED(g, min_t(unsigned int,
-					     GC_SECTORS_USED(g) + KEY_SIZE(k),
-					     MAX_GC_SECTORS_USED));
+		g->gc_sectors_used = min_t(uint16_t, c->cache->sb.bucket_size,
+					   g->gc_sectors_used + KEY_SIZE(k));
 
-		BUG_ON(!GC_SECTORS_USED(g));
+		BUG_ON(g->gc_sectors_used < KEY_SIZE(k) ||
+		       g->gc_sectors_used > c->cache->sb.bucket_size);
 	}
 
 	return stale;
@@ -1732,9 +1732,15 @@ static void btree_gc_start(struct cache_set *c)
 	ca = c->cache;
 	for_each_bucket(b, ca) {
 		b->last_gc = b->gen;
+
+		/*
+		 * If the bucket is still in use, mark is not necessary.
+		 * In bch_bucket_alloc(), we set the gc_sectors_used to
+		 * cache bucket size, just keep the maximum.
+		 */
 		if (!atomic_read(&b->pin)) {
 			SET_GC_MARK(b, 0);
-			SET_GC_SECTORS_USED(b, 0);
+			b->gc_sectors_used = 0;
 		}
 	}
 
@@ -1797,7 +1803,7 @@ static void bch_btree_gc_finish(struct cache_set *c)
 		if (atomic_read(&b->pin))
 			continue;
 
-		BUG_ON(!GC_MARK(b) && GC_SECTORS_USED(b));
+		BUG_ON(!GC_MARK(b) && b->gc_sectors_used);
 
 		if (!GC_MARK(b) || GC_MARK(b) == GC_MARK_RECLAIMABLE)
 			c->avail_nbuckets++;
diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index 9f32901fdad1..e4182c3ba9f8 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -184,14 +184,14 @@ err:		if (!IS_ERR_OR_NULL(w->private))
 
 static bool bucket_cmp(struct bucket *l, struct bucket *r)
 {
-	return GC_SECTORS_USED(l) < GC_SECTORS_USED(r);
+	return l->gc_sectors_used < r->gc_sectors_used;
 }
 
 static unsigned int bucket_heap_top(struct cache *ca)
 {
 	struct bucket *b;
 
-	return (b = heap_peek(&ca->heap)) ? GC_SECTORS_USED(b) : 0;
+	return (b = heap_peek(&ca->heap)) ? b->gc_sectors_used : 0;
 }
 
 void bch_moving_gc(struct cache_set *c)
@@ -213,17 +213,17 @@ void bch_moving_gc(struct cache_set *c)
 
 	for_each_bucket(b, ca) {
 		if (GC_MARK(b) == GC_MARK_METADATA ||
-		    !GC_SECTORS_USED(b) ||
-		    GC_SECTORS_USED(b) == ca->sb.bucket_size ||
+		    !b->gc_sectors_used ||
+		    b->gc_sectors_used == ca->sb.bucket_size ||
 		    atomic_read(&b->pin))
 			continue;
 
 		if (!heap_full(&ca->heap)) {
-			sectors_to_move += GC_SECTORS_USED(b);
+			sectors_to_move += b->gc_sectors_used;
 			heap_add(&ca->heap, b, bucket_cmp);
 		} else if (bucket_cmp(b, heap_peek(&ca->heap))) {
 			sectors_to_move -= bucket_heap_top(ca);
-			sectors_to_move += GC_SECTORS_USED(b);
+			sectors_to_move += b->gc_sectors_used;
 
 			ca->heap.data[0] = b;
 			heap_sift(&ca->heap, 0, bucket_cmp);
@@ -232,7 +232,7 @@ void bch_moving_gc(struct cache_set *c)
 
 	while (sectors_to_move > reserve_sectors) {
 		heap_pop(&ca->heap, b, bucket_cmp);
-		sectors_to_move -= GC_SECTORS_USED(b);
+		sectors_to_move -= b->gc_sectors_used;
 	}
 
 	while (heap_pop(&ca->heap, b, bucket_cmp))
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 0e2c1880f60b..3b859954b8c5 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -1073,7 +1073,7 @@ SHOW(__bch_cache)
 
 		mutex_lock(&ca->set->bucket_lock);
 		for_each_bucket(b, ca) {
-			if (!GC_SECTORS_USED(b))
+			if (!b->gc_sectors_used)
 				unused++;
 			if (GC_MARK(b) == GC_MARK_RECLAIMABLE)
 				available++;
diff --git a/include/trace/events/bcache.h b/include/trace/events/bcache.h
index 899fdacf57b9..b9d63e18c453 100644
--- a/include/trace/events/bcache.h
+++ b/include/trace/events/bcache.h
@@ -438,7 +438,7 @@ TRACE_EVENT(bcache_invalidate,
 	TP_fast_assign(
 		__entry->dev		= ca->bdev->bd_dev;
 		__entry->offset		= bucket << ca->set->bucket_bits;
-		__entry->sectors	= GC_SECTORS_USED(&ca->buckets[bucket]);
+		__entry->sectors	= ca->buckets[bucket].gc_sectors_used;
 	),
 
 	TP_printk("invalidated %u sectors at %d,%d sector=%llu",
-- 
2.17.1.windows.2




---------- Forwarded message ----------
In-Reply-To: <20230719072753.366-1-mingzhe.zou@easystack.cn>
Date: Wed, 19 Jul 2023 15:27:53 +0800
To: colyli@suse.de, linux-bcache@vger.kernel.org
Cc: bcache@lists.ewheeler.net, zoumingzhe@qq.com
From: Mingzhe Zou <mingzhe.zou@easystack.cn>
Subject: [PATCH v3 3/3] bcache: only copy dirty data during moving gc

From: Mingzhe Zou <zoumingzhe@qq.com>

When we want to shorten the moving gc interval, we must consider
its impact, such as: performance, cache life.

Usually ssd and nvme calculate the lifespan by the write cycles.
When moving gc, only copy dirty data, which can reduce the amount
of written data. This will improve moving gc speed, and extend
cache life.

Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/alloc.c    |  2 ++
 drivers/md/bcache/bcache.h   |  1 +
 drivers/md/bcache/btree.c    | 10 +++++++++-
 drivers/md/bcache/movinggc.c | 16 ++++++++--------
 4 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 4ae1018bf029..3d4b9f50b056 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -451,6 +451,7 @@ long bch_bucket_alloc(struct cache *ca, unsigned int reserve, bool wait)
 	 * should not do moving gc. So we set gc_sectors_used to the maximum.
 	 */
 	b->gc_sectors_used = ca->sb.bucket_size;
+	b->gc_sectors_dirty = ca->sb.bucket_size;
 
 	if (reserve <= RESERVE_PRIO) {
 		SET_GC_MARK(b, GC_MARK_METADATA);
@@ -474,6 +475,7 @@ void __bch_bucket_free(struct cache *ca, struct bucket *b)
 {
 	SET_GC_MARK(b, 0);
 	b->gc_sectors_used = 0;
+	b->gc_sectors_dirty = 0;
 
 	if (ca->set->avail_nbuckets < ca->set->nbuckets) {
 		ca->set->avail_nbuckets++;
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 10f3f548629e..b3e8e4f513f1 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -201,6 +201,7 @@ struct bucket {
 	uint8_t		gen;
 	uint8_t		last_gc; /* Most out of date gen in the btree */
 	uint16_t	gc_sectors_used;
+	uint16_t	gc_sectors_dirty;
 };
 
 /*
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index baa2149e9235..d4aeaaf1b9bc 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1250,8 +1250,14 @@ static uint8_t __bch_btree_mark_key(struct cache_set *c, int level,
 
 		if (level)
 			SET_GC_MARK(g, GC_MARK_METADATA);
-		else if (KEY_DIRTY(k))
+		else if (KEY_DIRTY(k)) {
 			SET_GC_MARK(g, GC_MARK_DIRTY);
+			g->gc_sectors_dirty = min_t(uint16_t, c->cache->sb.bucket_size,
+						    g->gc_sectors_dirty + KEY_SIZE(k));
+
+			BUG_ON(g->gc_sectors_dirty < KEY_SIZE(k) ||
+			       g->gc_sectors_dirty > c->cache->sb.bucket_size);
+		}
 		else if (!GC_MARK(g))
 			SET_GC_MARK(g, GC_MARK_RECLAIMABLE);
 
@@ -1743,6 +1749,7 @@ static void btree_gc_start(struct cache_set *c)
 		if (!atomic_read(&b->pin)) {
 			SET_GC_MARK(b, 0);
 			b->gc_sectors_used = 0;
+			b->gc_sectors_dirty = 0;
 		}
 	}
 
@@ -1806,6 +1813,7 @@ static void bch_btree_gc_finish(struct cache_set *c)
 			continue;
 
 		BUG_ON(!GC_MARK(b) && b->gc_sectors_used);
+		BUG_ON(!GC_MARK(b) && b->gc_sectors_dirty);
 
 		if (!GC_MARK(b) || GC_MARK(b) == GC_MARK_RECLAIMABLE)
 			c->avail_nbuckets++;
diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index 2c3cb1b6e0af..98f2487f518d 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -27,7 +27,7 @@ static bool moving_pred(struct keybuf *buf, struct bkey *k)
 
 	for (i = 0; i < KEY_PTRS(k); i++)
 		if (ptr_available(c, k, i) &&
-		    GC_MOVE(PTR_BUCKET(c, k, i)))
+		    GC_MOVE(PTR_BUCKET(c, k, i)) && KEY_DIRTY(k))
 			return true;
 
 	return false;
@@ -184,14 +184,14 @@ err:		if (!IS_ERR_OR_NULL(w->private))
 
 static bool bucket_cmp(struct bucket *l, struct bucket *r)
 {
-	return l->gc_sectors_used < r->gc_sectors_used;
+	return l->gc_sectors_dirty < r->gc_sectors_dirty;
 }
 
 static unsigned int bucket_heap_top(struct cache *ca)
 {
 	struct bucket *b;
 
-	return (b = heap_peek(&ca->heap)) ? b->gc_sectors_used : 0;
+	return (b = heap_peek(&ca->heap)) ? b->gc_sectors_dirty : 0;
 }
 
 void bch_moving_gc(struct cache_set *c)
@@ -215,17 +215,17 @@ void bch_moving_gc(struct cache_set *c)
 
 	for_each_bucket(b, ca) {
 		if (GC_MOVE(b) || GC_MARK(b) == GC_MARK_METADATA ||
-		    !b->gc_sectors_used ||
-		    b->gc_sectors_used == ca->sb.bucket_size ||
+		    !b->gc_sectors_dirty ||
+		    b->gc_sectors_dirty == ca->sb.bucket_size ||
 		    atomic_read(&b->pin))
 			continue;
 
 		if (!heap_full(&ca->heap)) {
-			sectors_to_move += b->gc_sectors_used;
+			sectors_to_move += b->gc_sectors_dirty;
 			heap_add(&ca->heap, b, bucket_cmp);
 		} else if (bucket_cmp(b, heap_peek(&ca->heap))) {
 			sectors_to_move -= bucket_heap_top(ca);
-			sectors_to_move += b->gc_sectors_used;
+			sectors_to_move += b->gc_sectors_dirty;
 
 			ca->heap.data[0] = b;
 			heap_sift(&ca->heap, 0, bucket_cmp);
@@ -237,7 +237,7 @@ void bch_moving_gc(struct cache_set *c)
 
 	while (sectors_to_move > reserve_sectors) {
 		heap_pop(&ca->heap, b, bucket_cmp);
-		sectors_to_move -= b->gc_sectors_used;
+		sectors_to_move -= b->gc_sectors_dirty;
 	}
 
 	while (heap_pop(&ca->heap, b, bucket_cmp))
-- 
2.17.1.windows.2


