Return-Path: <linux-bcache+bounces-287-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A38387C6BF
	for <lists+linux-bcache@lfdr.de>; Fri, 15 Mar 2024 01:27:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D5C501F21C97
	for <lists+linux-bcache@lfdr.de>; Fri, 15 Mar 2024 00:27:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B001919F;
	Fri, 15 Mar 2024 00:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mm12.xyz header.i=@mm12.xyz header.b="U+lnK99y"
X-Original-To: linux-bcache@vger.kernel.org
Received: from elcheapo.mm12.xyz (elcheapo.mm12.xyz [148.135.104.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413B619E;
	Fri, 15 Mar 2024 00:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.135.104.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710462417; cv=none; b=jumSXFKxAr3EPbkmw1Q3PqcbAw8tlrSh57U30dlZT8PFq69+8apTyt8DpmMPOnQwOvlINM+OMjspjN+pc4bFpsZbd+fpzFKbK/ygpTcpOQIPFtGJbbV+SxhyJ+M79yBCCEsBD8DDt1Tzqprk5v4MZNWOLPTuyOTXFYt2r78eZu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710462417; c=relaxed/simple;
	bh=VSTz2nmsff19M7nCbuGbpVRlSK3Sz7gAbrDukUsOAtI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YEezScA9XsylTPFkxJOMNqNZbJc4y0X/0O3NpeSoRp7l3lM8t0ICKYZqT19ibQVbxIWz+UYOkpf9cOQt6DZJ2fZ5Qj22tzp/79aWFfP166/xpj+BIUvAJq1ZgMh0A51++XGaqBtgX702TA6McKaHg90iFyajJA9hMcWZF46BaIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mm12.xyz; spf=pass smtp.mailfrom=mm12.xyz; dkim=pass (2048-bit key) header.d=mm12.xyz header.i=@mm12.xyz header.b=U+lnK99y; arc=none smtp.client-ip=148.135.104.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mm12.xyz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mm12.xyz
Received: from scala.mm12.xyz by elcheapo.mm12.xyz (Postfix) with ESMTPSA id 411401F366;
	Thu, 14 Mar 2024 20:21:48 -0400 (EDT)
Received: from matthew-desktop-u2.uwaterloo.ca by scala.mm12.xyz (Postfix) with ESMTPSA id 4B19C180148;
	Thu, 14 Mar 2024 20:21:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mm12.xyz; s=mail;
	t=1710462106; bh=VSTz2nmsff19M7nCbuGbpVRlSK3Sz7gAbrDukUsOAtI=;
	h=From:To:Cc:Subject:Date:From;
	b=U+lnK99yd4W8fJ2IiXX2IQmLHUqVAEVbHKqHP3Gn7LSEMy11vBNuDinsYQ74FuJ3/
	 N9rRo9BDPOJFjPEXYz5odKYXXaFkm72o/M/mysrkyRwvFR57x7B2Qnr36Ux9r3l/78
	 6ufvQgx1XpN+PbeTMPIGCYgSjK2uXuRP8U7Vz1QSlIWwmPMyjAzfzwwaca3buWB9jY
	 9FGLzNmdYxshopV31MxLSFDCHFjvdIrhYeNNRWqQlnMoncXrAcexVTA5fuhBwl4Dxm
	 cm6UtogaOcRgubabiLwTxc57C9yUW+eKxA3sa704TZuwClbYgRxtbBRnUwhUtNeppg
	 7+4jPBjic1gYw==
From: Matthew Mirvish <matthew@mm12.xyz>
To: linux-bcache@vger.kernel.org
Cc: Matthew Mirvish <matthew@mm12.xyz>,
	stable@vger.kernel.org
Subject: [PATCH] bcache: fix variable length array abuse in btree_iter
Date: Thu, 14 Mar 2024 20:21:29 -0400
Message-Id: <20240315002129.18827-1-matthew@mm12.xyz>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btree_iter is used in two ways: either allocated on the stack with a
fixed size MAX_BSETS, or from a mempool with a dynamic size based on the
specific cache set. Previously, the struct had a fixed-length array of
size MAX_BSETS which was indexed out-of-bounds for the dynamically-sized
iterators, which causes UBSAN to complain.

This patch uses the same approach as in bcachefs's sort_iter and splits
the iterator into a btree_iter with a flexible array member and a
btree_iter_stack which embeds a btree_iter as well as a fixed-length
data array.

Cc: stable@vger.kernel.org
Closes: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2039368
Signed-off-by: Matthew Mirvish <matthew@mm12.xyz>
---
 drivers/md/bcache/bset.c      | 44 +++++++++++++++++------------------
 drivers/md/bcache/bset.h      | 28 ++++++++++++++--------
 drivers/md/bcache/btree.c     | 40 ++++++++++++++++---------------
 drivers/md/bcache/super.c     |  5 ++--
 drivers/md/bcache/sysfs.c     |  2 +-
 drivers/md/bcache/writeback.c | 10 ++++----
 6 files changed, 70 insertions(+), 59 deletions(-)

diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index 2bba4d6aaaa2..463eb13bd0b2 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -54,7 +54,7 @@ void bch_dump_bucket(struct btree_keys *b)
 int __bch_count_data(struct btree_keys *b)
 {
 	unsigned int ret = 0;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 	struct bkey *k;
 
 	if (b->ops->is_extents)
@@ -67,7 +67,7 @@ void __bch_check_keys(struct btree_keys *b, const char *fmt, ...)
 {
 	va_list args;
 	struct bkey *k, *p = NULL;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 	const char *err;
 
 	for_each_key(b, k, &iter) {
@@ -879,7 +879,7 @@ unsigned int bch_btree_insert_key(struct btree_keys *b, struct bkey *k,
 	unsigned int status = BTREE_INSERT_STATUS_NO_INSERT;
 	struct bset *i = bset_tree_last(b)->data;
 	struct bkey *m, *prev = NULL;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 	struct bkey preceding_key_on_stack = ZERO_KEY;
 	struct bkey *preceding_key_p = &preceding_key_on_stack;
 
@@ -895,9 +895,9 @@ unsigned int bch_btree_insert_key(struct btree_keys *b, struct bkey *k,
 	else
 		preceding_key(k, &preceding_key_p);
 
-	m = bch_btree_iter_init(b, &iter, preceding_key_p);
+	m = bch_btree_iter_stack_init(b, &iter, preceding_key_p);
 
-	if (b->ops->insert_fixup(b, k, &iter, replace_key))
+	if (b->ops->insert_fixup(b, k, &iter.iter, replace_key))
 		return status;
 
 	status = BTREE_INSERT_STATUS_INSERT;
@@ -1100,33 +1100,33 @@ void bch_btree_iter_push(struct btree_iter *iter, struct bkey *k,
 				 btree_iter_cmp));
 }
 
-static struct bkey *__bch_btree_iter_init(struct btree_keys *b,
-					  struct btree_iter *iter,
-					  struct bkey *search,
-					  struct bset_tree *start)
+static struct bkey *__bch_btree_iter_stack_init(struct btree_keys *b,
+						struct btree_iter_stack *iter,
+						struct bkey *search,
+						struct bset_tree *start)
 {
 	struct bkey *ret = NULL;
 
-	iter->size = ARRAY_SIZE(iter->data);
-	iter->used = 0;
+	iter->iter.size = ARRAY_SIZE(iter->stack_data);
+	iter->iter.used = 0;
 
 #ifdef CONFIG_BCACHE_DEBUG
-	iter->b = b;
+	iter->iter.b = b;
 #endif
 
 	for (; start <= bset_tree_last(b); start++) {
 		ret = bch_bset_search(b, start, search);
-		bch_btree_iter_push(iter, ret, bset_bkey_last(start->data));
+		bch_btree_iter_push(&iter->iter, ret, bset_bkey_last(start->data));
 	}
 
 	return ret;
 }
 
-struct bkey *bch_btree_iter_init(struct btree_keys *b,
-				 struct btree_iter *iter,
+struct bkey *bch_btree_iter_stack_init(struct btree_keys *b,
+				 struct btree_iter_stack *iter,
 				 struct bkey *search)
 {
-	return __bch_btree_iter_init(b, iter, search, b->set);
+	return __bch_btree_iter_stack_init(b, iter, search, b->set);
 }
 
 static inline struct bkey *__bch_btree_iter_next(struct btree_iter *iter,
@@ -1293,10 +1293,10 @@ void bch_btree_sort_partial(struct btree_keys *b, unsigned int start,
 			    struct bset_sort_state *state)
 {
 	size_t order = b->page_order, keys = 0;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 	int oldsize = bch_count_data(b);
 
-	__bch_btree_iter_init(b, &iter, NULL, &b->set[start]);
+	__bch_btree_iter_stack_init(b, &iter, NULL, &b->set[start]);
 
 	if (start) {
 		unsigned int i;
@@ -1307,7 +1307,7 @@ void bch_btree_sort_partial(struct btree_keys *b, unsigned int start,
 		order = get_order(__set_bytes(b->set->data, keys));
 	}
 
-	__btree_sort(b, &iter, start, order, false, state);
+	__btree_sort(b, &iter.iter, start, order, false, state);
 
 	EBUG_ON(oldsize >= 0 && bch_count_data(b) != oldsize);
 }
@@ -1323,11 +1323,11 @@ void bch_btree_sort_into(struct btree_keys *b, struct btree_keys *new,
 			 struct bset_sort_state *state)
 {
 	uint64_t start_time = local_clock();
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 
-	bch_btree_iter_init(b, &iter, NULL);
+	bch_btree_iter_stack_init(b, &iter, NULL);
 
-	btree_mergesort(b, new->set->data, &iter, false, true);
+	btree_mergesort(b, new->set->data, &iter.iter, false, true);
 
 	bch_time_stats_update(&state->time, start_time);
 
diff --git a/drivers/md/bcache/bset.h b/drivers/md/bcache/bset.h
index d795c84246b0..011f6062c4c0 100644
--- a/drivers/md/bcache/bset.h
+++ b/drivers/md/bcache/bset.h
@@ -321,7 +321,14 @@ struct btree_iter {
 #endif
 	struct btree_iter_set {
 		struct bkey *k, *end;
-	} data[MAX_BSETS];
+	} data[];
+};
+
+/* Fixed-size btree_iter that can be allocated on the stack */
+
+struct btree_iter_stack {
+	struct btree_iter iter;
+	struct btree_iter_set stack_data[MAX_BSETS];
 };
 
 typedef bool (*ptr_filter_fn)(struct btree_keys *b, const struct bkey *k);
@@ -333,9 +340,9 @@ struct bkey *bch_btree_iter_next_filter(struct btree_iter *iter,
 
 void bch_btree_iter_push(struct btree_iter *iter, struct bkey *k,
 			 struct bkey *end);
-struct bkey *bch_btree_iter_init(struct btree_keys *b,
-				 struct btree_iter *iter,
-				 struct bkey *search);
+struct bkey *bch_btree_iter_stack_init(struct btree_keys *b,
+				       struct btree_iter_stack *iter,
+				       struct bkey *search);
 
 struct bkey *__bch_bset_search(struct btree_keys *b, struct bset_tree *t,
 			       const struct bkey *search);
@@ -350,13 +357,14 @@ static inline struct bkey *bch_bset_search(struct btree_keys *b,
 	return search ? __bch_bset_search(b, t, search) : t->data->start;
 }
 
-#define for_each_key_filter(b, k, iter, filter)				\
-	for (bch_btree_iter_init((b), (iter), NULL);			\
-	     ((k) = bch_btree_iter_next_filter((iter), (b), filter));)
+#define for_each_key_filter(b, k, stack_iter, filter)                      \
+	for (bch_btree_iter_stack_init((b), (stack_iter), NULL);           \
+	     ((k) = bch_btree_iter_next_filter(&((stack_iter)->iter), (b), \
+					       filter));)
 
-#define for_each_key(b, k, iter)					\
-	for (bch_btree_iter_init((b), (iter), NULL);			\
-	     ((k) = bch_btree_iter_next(iter));)
+#define for_each_key(b, k, stack_iter)                           \
+	for (bch_btree_iter_stack_init((b), (stack_iter), NULL); \
+	     ((k) = bch_btree_iter_next(&((stack_iter)->iter)));)
 
 /* Sorting */
 
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 196cdacce38f..d011a7154d33 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1309,7 +1309,7 @@ static bool btree_gc_mark_node(struct btree *b, struct gc_stat *gc)
 	uint8_t stale = 0;
 	unsigned int keys = 0, good_keys = 0;
 	struct bkey *k;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 	struct bset_tree *t;
 
 	gc->nodes++;
@@ -1570,7 +1570,7 @@ static int btree_gc_rewrite_node(struct btree *b, struct btree_op *op,
 static unsigned int btree_gc_count_keys(struct btree *b)
 {
 	struct bkey *k;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 	unsigned int ret = 0;
 
 	for_each_key_filter(&b->keys, k, &iter, bch_ptr_bad)
@@ -1611,17 +1611,18 @@ static int btree_gc_recurse(struct btree *b, struct btree_op *op,
 	int ret = 0;
 	bool should_rewrite;
 	struct bkey *k;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 	struct gc_merge_info r[GC_MERGE_NODES];
 	struct gc_merge_info *i, *last = r + ARRAY_SIZE(r) - 1;
 
-	bch_btree_iter_init(&b->keys, &iter, &b->c->gc_done);
+	bch_btree_iter_stack_init(&b->keys, &iter, &b->c->gc_done);
 
 	for (i = r; i < r + ARRAY_SIZE(r); i++)
 		i->b = ERR_PTR(-EINTR);
 
 	while (1) {
-		k = bch_btree_iter_next_filter(&iter, &b->keys, bch_ptr_bad);
+		k = bch_btree_iter_next_filter(&iter.iter, &b->keys,
+					       bch_ptr_bad);
 		if (k) {
 			r->b = bch_btree_node_get(b->c, op, k, b->level - 1,
 						  true, b);
@@ -1911,7 +1912,7 @@ static int bch_btree_check_recurse(struct btree *b, struct btree_op *op)
 {
 	int ret = 0;
 	struct bkey *k, *p = NULL;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 
 	for_each_key_filter(&b->keys, k, &iter, bch_ptr_invalid)
 		bch_initial_mark_key(b->c, b->level, k);
@@ -1919,10 +1920,10 @@ static int bch_btree_check_recurse(struct btree *b, struct btree_op *op)
 	bch_initial_mark_key(b->c, b->level + 1, &b->key);
 
 	if (b->level) {
-		bch_btree_iter_init(&b->keys, &iter, NULL);
+		bch_btree_iter_stack_init(&b->keys, &iter, NULL);
 
 		do {
-			k = bch_btree_iter_next_filter(&iter, &b->keys,
+			k = bch_btree_iter_next_filter(&iter.iter, &b->keys,
 						       bch_ptr_bad);
 			if (k) {
 				btree_node_prefetch(b, k);
@@ -1950,7 +1951,7 @@ static int bch_btree_check_thread(void *arg)
 	struct btree_check_info *info = arg;
 	struct btree_check_state *check_state = info->state;
 	struct cache_set *c = check_state->c;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 	struct bkey *k, *p;
 	int cur_idx, prev_idx, skip_nr;
 
@@ -1959,8 +1960,8 @@ static int bch_btree_check_thread(void *arg)
 	ret = 0;
 
 	/* root node keys are checked before thread created */
-	bch_btree_iter_init(&c->root->keys, &iter, NULL);
-	k = bch_btree_iter_next_filter(&iter, &c->root->keys, bch_ptr_bad);
+	bch_btree_iter_stack_init(&c->root->keys, &iter, NULL);
+	k = bch_btree_iter_next_filter(&iter.iter, &c->root->keys, bch_ptr_bad);
 	BUG_ON(!k);
 
 	p = k;
@@ -1978,7 +1979,7 @@ static int bch_btree_check_thread(void *arg)
 		skip_nr = cur_idx - prev_idx;
 
 		while (skip_nr) {
-			k = bch_btree_iter_next_filter(&iter,
+			k = bch_btree_iter_next_filter(&iter.iter,
 						       &c->root->keys,
 						       bch_ptr_bad);
 			if (k)
@@ -2051,7 +2052,7 @@ int bch_btree_check(struct cache_set *c)
 	int ret = 0;
 	int i;
 	struct bkey *k = NULL;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 	struct btree_check_state check_state;
 
 	/* check and mark root node keys */
@@ -2547,11 +2548,11 @@ static int bch_btree_map_nodes_recurse(struct btree *b, struct btree_op *op,
 
 	if (b->level) {
 		struct bkey *k;
-		struct btree_iter iter;
+		struct btree_iter_stack iter;
 
-		bch_btree_iter_init(&b->keys, &iter, from);
+		bch_btree_iter_stack_init(&b->keys, &iter, from);
 
-		while ((k = bch_btree_iter_next_filter(&iter, &b->keys,
+		while ((k = bch_btree_iter_next_filter(&iter.iter, &b->keys,
 						       bch_ptr_bad))) {
 			ret = bcache_btree(map_nodes_recurse, k, b,
 				    op, from, fn, flags);
@@ -2580,11 +2581,12 @@ int bch_btree_map_keys_recurse(struct btree *b, struct btree_op *op,
 {
 	int ret = MAP_CONTINUE;
 	struct bkey *k;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 
-	bch_btree_iter_init(&b->keys, &iter, from);
+	bch_btree_iter_stack_init(&b->keys, &iter, from);
 
-	while ((k = bch_btree_iter_next_filter(&iter, &b->keys, bch_ptr_bad))) {
+	while ((k = bch_btree_iter_next_filter(&iter.iter, &b->keys,
+					       bch_ptr_bad))) {
 		ret = !b->level
 			? fn(op, b, k)
 			: bcache_btree(map_keys_recurse, k,
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index dc3f50f69714..0676f863355a 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1913,8 +1913,9 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 	INIT_LIST_HEAD(&c->btree_cache_freed);
 	INIT_LIST_HEAD(&c->data_buckets);
 
-	iter_size = ((meta_bucket_pages(sb) * PAGE_SECTORS) / sb->block_size + 1) *
-		sizeof(struct btree_iter_set);
+	iter_size = sizeof(struct btree_iter) +
+		    ((meta_bucket_pages(sb) * PAGE_SECTORS) / sb->block_size) *
+			    sizeof(struct btree_iter_set);
 
 	c->devices = kcalloc(c->nr_uuids, sizeof(void *), GFP_KERNEL);
 	if (!c->devices)
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index a438efb66069..c4633425acc4 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -660,7 +660,7 @@ static unsigned int bch_root_usage(struct cache_set *c)
 	unsigned int bytes = 0;
 	struct bkey *k;
 	struct btree *b;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 
 	goto lock_root;
 
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 8827a6f130ad..792e070ccf38 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -908,15 +908,15 @@ static int bch_dirty_init_thread(void *arg)
 	struct dirty_init_thrd_info *info = arg;
 	struct bch_dirty_init_state *state = info->state;
 	struct cache_set *c = state->c;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 	struct bkey *k, *p;
 	int cur_idx, prev_idx, skip_nr;
 
 	k = p = NULL;
 	prev_idx = 0;
 
-	bch_btree_iter_init(&c->root->keys, &iter, NULL);
-	k = bch_btree_iter_next_filter(&iter, &c->root->keys, bch_ptr_bad);
+	bch_btree_iter_stack_init(&c->root->keys, &iter, NULL);
+	k = bch_btree_iter_next_filter(&iter.iter, &c->root->keys, bch_ptr_bad);
 	BUG_ON(!k);
 
 	p = k;
@@ -930,7 +930,7 @@ static int bch_dirty_init_thread(void *arg)
 		skip_nr = cur_idx - prev_idx;
 
 		while (skip_nr) {
-			k = bch_btree_iter_next_filter(&iter,
+			k = bch_btree_iter_next_filter(&iter.iter,
 						       &c->root->keys,
 						       bch_ptr_bad);
 			if (k)
@@ -979,7 +979,7 @@ void bch_sectors_dirty_init(struct bcache_device *d)
 	int i;
 	struct btree *b = NULL;
 	struct bkey *k = NULL;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 	struct sectors_dirty_init op;
 	struct cache_set *c = d->c;
 	struct bch_dirty_init_state state;
-- 
2.40.1


