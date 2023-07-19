Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 495FC758EFB
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Jul 2023 09:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjGSH2O (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 19 Jul 2023 03:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbjGSH2I (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 19 Jul 2023 03:28:08 -0400
Received: from mail-m2835.qiye.163.com (mail-m2835.qiye.163.com [103.74.28.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE68E60
        for <linux-bcache@vger.kernel.org>; Wed, 19 Jul 2023 00:28:06 -0700 (PDT)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m2835.qiye.163.com (Hmail) with ESMTPA id AE2738A0093;
        Wed, 19 Jul 2023 15:28:00 +0800 (CST)
From:   Mingzhe Zou <mingzhe.zou@easystack.cn>
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     bcache@lists.ewheeler.net, zoumingzhe@qq.com
Subject: [PATCH v3 3/3] bcache: only copy dirty data during moving gc
Date:   Wed, 19 Jul 2023 15:27:53 +0800
Message-Id: <20230719072753.366-3-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230719072753.366-1-mingzhe.zou@easystack.cn>
References: <20230719072753.366-1-mingzhe.zou@easystack.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlDHUkYVhkeHkgeSkNMSUhDGlUZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hKTFVKS0tVS1kG
X-HM-Tid: 0a896d0c7746841dkuqwae2738a0093
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NTo6HAw4PzE#FFZLFEM4Nww8
        PDwwCwpVSlVKTUNCTE5KTUNKQkJIVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBTkJJSTcG
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

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

