Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B38774CE06
	for <lists+linux-bcache@lfdr.de>; Mon, 10 Jul 2023 09:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjGJHO7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 10 Jul 2023 03:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjGJHO6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 10 Jul 2023 03:14:58 -0400
X-Greylist: delayed 459 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 10 Jul 2023 00:14:55 PDT
Received: from mail-m2835.qiye.163.com (mail-m2835.qiye.163.com [103.74.28.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30E0E9
        for <linux-bcache@vger.kernel.org>; Mon, 10 Jul 2023 00:14:55 -0700 (PDT)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m2835.qiye.163.com (Hmail) with ESMTPA id 4D8DB8A006A;
        Mon, 10 Jul 2023 15:07:08 +0800 (CST)
From:   Mingzhe Zou <mingzhe.zou@easystack.cn>
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     bcache@lists.ewheeler.net, zoumingzhe@qq.com
Subject: [PATCH v4 2/2] bcache: only copy dirty data during moving gc
Date:   Mon, 10 Jul 2023 15:07:01 +0800
Message-Id: <20230710070702.68-2-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230710070702.68-1-mingzhe.zou@easystack.cn>
References: <20230710070702.68-1-mingzhe.zou@easystack.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlCH05PVkNDThofSxkfGBpLHlUZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hKTFVKS0tVS1kG
X-HM-Tid: 0a893ea01f5d841dkuqw4d8db8a006a
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MVE6Nww4PjE9OhQvLEpKGAlK
        HjYaCzxVSlVKTUNDQkxJQ0lCSUpCVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBTU1MTzcG
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 drivers/md/bcache/bcache.h   |  3 ++-
 drivers/md/bcache/btree.c    | 12 ++++++++++--
 drivers/md/bcache/movinggc.c | 16 ++++++++--------
 4 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index ce13c272c387..b6215cddef5b 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -447,6 +447,7 @@ long bch_bucket_alloc(struct cache *ca, unsigned int reserve, bool wait)
 	BUG_ON(atomic_read(&b->pin) != 1);
 
 	SET_GC_SECTORS_USED(b, ca->sb.bucket_size);
+	SET_GC_SECTORS_DIRTY(b, 0);
 
 	if (reserve <= RESERVE_PRIO) {
 		SET_GC_MARK(b, GC_MARK_METADATA);
@@ -470,6 +471,7 @@ void __bch_bucket_free(struct cache *ca, struct bucket *b)
 {
 	SET_GC_MARK(b, 0);
 	SET_GC_SECTORS_USED(b, 0);
+	SET_GC_SECTORS_DIRTY(b, 0);
 
 	if (ca->set->avail_nbuckets < ca->set->nbuckets) {
 		ca->set->avail_nbuckets++;
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 155deff0ce05..a215d89761ba 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -199,7 +199,7 @@ struct bucket {
 	uint16_t	prio;
 	uint8_t		gen;
 	uint8_t		last_gc; /* Most out of date gen in the btree */
-	uint16_t	gc_mark; /* Bitfield used by GC. See below for field */
+	uint32_t	gc_mark; /* Bitfield used by GC. See below for field */
 };
 
 /*
@@ -215,6 +215,7 @@ BITMASK(GC_MARK,	 struct bucket, gc_mark, 0, 2);
 #define MAX_GC_SECTORS_USED	(~(~0ULL << GC_SECTORS_USED_SIZE))
 BITMASK(GC_SECTORS_USED, struct bucket, gc_mark, 2, GC_SECTORS_USED_SIZE);
 BITMASK(GC_MOVE, struct bucket, gc_mark, 15, 1);
+BITMASK(GC_SECTORS_DIRTY, struct bucket, gc_mark, 16, GC_SECTORS_USED_SIZE);
 
 #include "journal.h"
 #include "stats.h"
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 475ae69b1916..4e7e66c9f542 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1250,8 +1250,13 @@ static uint8_t __bch_btree_mark_key(struct cache_set *c, int level,
 
 		if (level)
 			SET_GC_MARK(g, GC_MARK_METADATA);
-		else if (KEY_DIRTY(k))
+		else if (KEY_DIRTY(k)) {
+			SET_GC_SECTORS_DIRTY(g, GC_SECTORS_DIRTY(g) + KEY_SIZE(k));
 			SET_GC_MARK(g, GC_MARK_DIRTY);
+
+			BUG_ON(GC_SECTORS_DIRTY(g) < KEY_SIZE(k) ||
+			       GC_SECTORS_DIRTY(g) > c->cache->sb.bucket_size);
+		}
 		else if (!GC_MARK(g))
 			SET_GC_MARK(g, GC_MARK_RECLAIMABLE);
 
@@ -1260,7 +1265,8 @@ static uint8_t __bch_btree_mark_key(struct cache_set *c, int level,
 					     GC_SECTORS_USED(g) + KEY_SIZE(k),
 					     MAX_GC_SECTORS_USED));
 
-		BUG_ON(!GC_SECTORS_USED(g));
+		BUG_ON(GC_SECTORS_USED(g) < KEY_SIZE(k) ||
+		       GC_SECTORS_USED(g) > c->cache->sb.bucket_size);
 	}
 
 	return stale;
@@ -1738,6 +1744,7 @@ static void btree_gc_start(struct cache_set *c)
 			SET_GC_MARK(b, 0);
 			SET_GC_SECTORS_USED(b, 0);
 		}
+		SET_GC_SECTORS_DIRTY(b, 0);
 	}
 
 	mutex_unlock(&c->bucket_lock);
@@ -1800,6 +1807,7 @@ static void bch_btree_gc_finish(struct cache_set *c)
 			continue;
 
 		BUG_ON(!GC_MARK(b) && GC_SECTORS_USED(b));
+		BUG_ON(!GC_MARK(b) && GC_SECTORS_DIRTY(b));
 
 		if (!GC_MARK(b) || GC_MARK(b) == GC_MARK_RECLAIMABLE)
 			c->avail_nbuckets++;
diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index 93a449226f36..ad54cdde2554 100644
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
-	return GC_SECTORS_USED(l) < GC_SECTORS_USED(r);
+	return GC_SECTORS_DIRTY(l) < GC_SECTORS_DIRTY(r);
 }
 
 static unsigned int bucket_heap_top(struct cache *ca)
 {
 	struct bucket *b;
 
-	return (b = heap_peek(&ca->heap)) ? GC_SECTORS_USED(b) : 0;
+	return (b = heap_peek(&ca->heap)) ? GC_SECTORS_DIRTY(b) : 0;
 }
 
 void bch_moving_gc(struct cache_set *c)
@@ -215,17 +215,17 @@ void bch_moving_gc(struct cache_set *c)
 
 	for_each_bucket(b, ca) {
 		if (GC_MOVE(b) || GC_MARK(b) == GC_MARK_METADATA ||
-		    !GC_SECTORS_USED(b) ||
-		    GC_SECTORS_USED(b) == ca->sb.bucket_size ||
+		    !GC_SECTORS_DIRTY(b) ||
+		    GC_SECTORS_DIRTY(b) == ca->sb.bucket_size ||
 		    atomic_read(&b->pin))
 			continue;
 
 		if (!heap_full(&ca->heap)) {
-			sectors_to_move += GC_SECTORS_USED(b);
+			sectors_to_move += GC_SECTORS_DIRTY(b);
 			heap_add(&ca->heap, b, bucket_cmp);
 		} else if (bucket_cmp(b, heap_peek(&ca->heap))) {
 			sectors_to_move -= bucket_heap_top(ca);
-			sectors_to_move += GC_SECTORS_USED(b);
+			sectors_to_move += GC_SECTORS_DIRTY(b);
 
 			ca->heap.data[0] = b;
 			heap_sift(&ca->heap, 0, bucket_cmp);
@@ -234,7 +234,7 @@ void bch_moving_gc(struct cache_set *c)
 
 	while (sectors_to_move > reserve_sectors) {
 		heap_pop(&ca->heap, b, bucket_cmp);
-		sectors_to_move -= GC_SECTORS_USED(b);
+		sectors_to_move -= GC_SECTORS_DIRTY(b);
 	}
 
 	pr_info("moving gc: on set %pU, %lu sectors from %zu buckets",
-- 
2.17.1.windows.2

