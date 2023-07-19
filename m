Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15124758B7D
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Jul 2023 04:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbjGSCrb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 18 Jul 2023 22:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjGSCra (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 18 Jul 2023 22:47:30 -0400
Received: from mail-m2835.qiye.163.com (mail-m2835.qiye.163.com [103.74.28.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832B91BF7
        for <linux-bcache@vger.kernel.org>; Tue, 18 Jul 2023 19:47:24 -0700 (PDT)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m2835.qiye.163.com (Hmail) with ESMTPA id F012F8A0048;
        Wed, 19 Jul 2023 10:47:12 +0800 (CST)
From:   Mingzhe Zou <mingzhe.zou@easystack.cn>
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     bcache@lists.ewheeler.net, zoumingzhe@qq.com
Subject: [PATCH v2 1/3] bcache: the gc_sectors_used size matches the bucket size
Date:   Wed, 19 Jul 2023 10:47:07 +0800
Message-Id: <20230719024709.287-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkaSB9JVk9OGUlISh9CGUhNTFUZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hKTFVKS0tVS1kG
X-HM-Tid: 0a896c0b641c841dkuqwf012f8a0048
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PCI6KSo6KzE3PlY6DBEKPRI2
        Ih4KC1FVSlVKTUNCTEhPQ0hITE1PVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBQ0pNQjcG
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Mingzhe Zou <zoumingzhe@qq.com>

The bucket size in the superblock is defined as uint16_t.
But, GC_SECTORS_USED is only 13 bits. If the bucket size
is 4M (8192 sectors), GC_SECTORS_USED will be truncated
to MAX_GC_SECTORS_USED.

GC_SECTORS_USED is the moving gc sorting condition, we
should try our best to ensure it is correct.

Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/alloc.c    | 12 ++++++++----
 drivers/md/bcache/bcache.h   | 12 ++++++------
 drivers/md/bcache/btree.c    | 18 ++++++++++++------
 drivers/md/bcache/movinggc.c | 14 +++++++-------
 drivers/md/bcache/sysfs.c    |  2 +-
 5 files changed, 34 insertions(+), 24 deletions(-)

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
-- 
2.17.1.windows.2

