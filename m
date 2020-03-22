Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBD3718E705
	for <lists+linux-bcache@lfdr.de>; Sun, 22 Mar 2020 07:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbgCVGEn (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 22 Mar 2020 02:04:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:48988 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbgCVGEn (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 22 Mar 2020 02:04:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 79B68ACA2;
        Sun, 22 Mar 2020 06:04:40 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/7] bcache: add bcache_ prefix to btree_root() and btree() macros
Date:   Sun, 22 Mar 2020 14:03:00 +0800
Message-Id: <20200322060305.70637-3-colyli@suse.de>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200322060305.70637-1-colyli@suse.de>
References: <20200322060305.70637-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch changes macro btree_root() and btree() to bcache_btree_root()
and bcache_btree(), to avoid potential generic name clash in future.

NOTE: for porduct kernel maintainers, this patch can be skipped if
you feel the rename stuffs introduce inconvenince to patch backport.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/btree.c | 15 ++++++++-------
 drivers/md/bcache/btree.h |  4 ++--
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 99cb201809af..faf152524a16 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1790,7 +1790,7 @@ static void bch_btree_gc(struct cache_set *c)
 
 	/* if CACHE_SET_IO_DISABLE set, gc thread should stop too */
 	do {
-		ret = btree_root(gc_root, c, &op, &writes, &stats);
+		ret = bcache_btree_root(gc_root, c, &op, &writes, &stats);
 		closure_sync(&writes);
 		cond_resched();
 
@@ -1888,7 +1888,7 @@ static int bch_btree_check_recurse(struct btree *b, struct btree_op *op)
 			}
 
 			if (p)
-				ret = btree(check_recurse, p, b, op);
+				ret = bcache_btree(check_recurse, p, b, op);
 
 			p = k;
 		} while (p && !ret);
@@ -1903,7 +1903,7 @@ int bch_btree_check(struct cache_set *c)
 
 	bch_btree_op_init(&op, SHRT_MAX);
 
-	return btree_root(check_recurse, c, &op);
+	return bcache_btree_root(check_recurse, c, &op);
 }
 
 void bch_initial_gc_finish(struct cache_set *c)
@@ -2343,7 +2343,7 @@ static int bch_btree_map_nodes_recurse(struct btree *b, struct btree_op *op,
 
 		while ((k = bch_btree_iter_next_filter(&iter, &b->keys,
 						       bch_ptr_bad))) {
-			ret = btree(map_nodes_recurse, k, b,
+			ret = bcache_btree(map_nodes_recurse, k, b,
 				    op, from, fn, flags);
 			from = NULL;
 
@@ -2361,7 +2361,7 @@ static int bch_btree_map_nodes_recurse(struct btree *b, struct btree_op *op,
 int __bch_btree_map_nodes(struct btree_op *op, struct cache_set *c,
 			  struct bkey *from, btree_map_nodes_fn *fn, int flags)
 {
-	return btree_root(map_nodes_recurse, c, op, from, fn, flags);
+	return bcache_btree_root(map_nodes_recurse, c, op, from, fn, flags);
 }
 
 int bch_btree_map_keys_recurse(struct btree *b, struct btree_op *op,
@@ -2377,7 +2377,8 @@ int bch_btree_map_keys_recurse(struct btree *b, struct btree_op *op,
 	while ((k = bch_btree_iter_next_filter(&iter, &b->keys, bch_ptr_bad))) {
 		ret = !b->level
 			? fn(op, b, k)
-			: btree(map_keys_recurse, k, b, op, from, fn, flags);
+			: bcache_btree(map_keys_recurse, k,
+				       b, op, from, fn, flags);
 		from = NULL;
 
 		if (ret != MAP_CONTINUE)
@@ -2394,7 +2395,7 @@ int bch_btree_map_keys_recurse(struct btree *b, struct btree_op *op,
 int bch_btree_map_keys(struct btree_op *op, struct cache_set *c,
 		       struct bkey *from, btree_map_keys_fn *fn, int flags)
 {
-	return btree_root(map_keys_recurse, c, op, from, fn, flags);
+	return bcache_btree_root(map_keys_recurse, c, op, from, fn, flags);
 }
 
 /* Keybuf code */
diff --git a/drivers/md/bcache/btree.h b/drivers/md/bcache/btree.h
index f37153db3f6c..19e30266070a 100644
--- a/drivers/md/bcache/btree.h
+++ b/drivers/md/bcache/btree.h
@@ -309,7 +309,7 @@ static inline void force_wake_up_gc(struct cache_set *c)
  * @b:		parent btree node
  * @op:		pointer to struct btree_op
  */
-#define btree(fn, key, b, op, ...)					\
+#define bcache_btree(fn, key, b, op, ...)				\
 ({									\
 	int _r, l = (b)->level - 1;					\
 	bool _w = l <= (op)->lock;					\
@@ -329,7 +329,7 @@ static inline void force_wake_up_gc(struct cache_set *c)
  * @c:		cache set
  * @op:		pointer to struct btree_op
  */
-#define btree_root(fn, c, op, ...)					\
+#define bcache_btree_root(fn, c, op, ...)				\
 ({									\
 	int _r = -EINTR;						\
 	do {								\
-- 
2.25.0

