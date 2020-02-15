Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E62B15FD7A
	for <lists+linux-bcache@lfdr.de>; Sat, 15 Feb 2020 09:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgBOI3L (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 15 Feb 2020 03:29:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:42432 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbgBOI3L (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 15 Feb 2020 03:29:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0A96AAEC7;
        Sat, 15 Feb 2020 08:29:08 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 1/3] bcache: move macro btree() and btree_root() into btree.h
Date:   Sat, 15 Feb 2020 16:28:56 +0800
Message-Id: <20200215082858.128025-2-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200215082858.128025-1-colyli@suse.de>
References: <20200215082858.128025-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In order to accelerate bcache registration speed, the macro btree()
and btree_root() will be referenced out of btree.c. This patch moves
them from btree.c into btree.h with other relative function declaration
in btree.h, for the following changes.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/btree.c | 60 +-----------------------------------------
 drivers/md/bcache/btree.h | 66 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 59 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index fa872df4e770..99cb201809af 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -101,64 +101,6 @@
 
 #define insert_lock(s, b)	((b)->level <= (s)->lock)
 
-/*
- * These macros are for recursing down the btree - they handle the details of
- * locking and looking up nodes in the cache for you. They're best treated as
- * mere syntax when reading code that uses them.
- *
- * op->lock determines whether we take a read or a write lock at a given depth.
- * If you've got a read lock and find that you need a write lock (i.e. you're
- * going to have to split), set op->lock and return -EINTR; btree_root() will
- * call you again and you'll have the correct lock.
- */
-
-/**
- * btree - recurse down the btree on a specified key
- * @fn:		function to call, which will be passed the child node
- * @key:	key to recurse on
- * @b:		parent btree node
- * @op:		pointer to struct btree_op
- */
-#define btree(fn, key, b, op, ...)					\
-({									\
-	int _r, l = (b)->level - 1;					\
-	bool _w = l <= (op)->lock;					\
-	struct btree *_child = bch_btree_node_get((b)->c, op, key, l,	\
-						  _w, b);		\
-	if (!IS_ERR(_child)) {						\
-		_r = bch_btree_ ## fn(_child, op, ##__VA_ARGS__);	\
-		rw_unlock(_w, _child);					\
-	} else								\
-		_r = PTR_ERR(_child);					\
-	_r;								\
-})
-
-/**
- * btree_root - call a function on the root of the btree
- * @fn:		function to call, which will be passed the child node
- * @c:		cache set
- * @op:		pointer to struct btree_op
- */
-#define btree_root(fn, c, op, ...)					\
-({									\
-	int _r = -EINTR;						\
-	do {								\
-		struct btree *_b = (c)->root;				\
-		bool _w = insert_lock(op, _b);				\
-		rw_lock(_w, _b, _b->level);				\
-		if (_b == (c)->root &&					\
-		    _w == insert_lock(op, _b)) {			\
-			_r = bch_btree_ ## fn(_b, op, ##__VA_ARGS__);	\
-		}							\
-		rw_unlock(_w, _b);					\
-		bch_cannibalize_unlock(c);				\
-		if (_r == -EINTR)					\
-			schedule();					\
-	} while (_r == -EINTR);						\
-									\
-	finish_wait(&(c)->btree_cache_wait, &(op)->wait);		\
-	_r;								\
-})
 
 static inline struct bset *write_block(struct btree *b)
 {
@@ -2422,7 +2364,7 @@ int __bch_btree_map_nodes(struct btree_op *op, struct cache_set *c,
 	return btree_root(map_nodes_recurse, c, op, from, fn, flags);
 }
 
-static int bch_btree_map_keys_recurse(struct btree *b, struct btree_op *op,
+int bch_btree_map_keys_recurse(struct btree *b, struct btree_op *op,
 				      struct bkey *from, btree_map_keys_fn *fn,
 				      int flags)
 {
diff --git a/drivers/md/bcache/btree.h b/drivers/md/bcache/btree.h
index f4dcca449391..f37153db3f6c 100644
--- a/drivers/md/bcache/btree.h
+++ b/drivers/md/bcache/btree.h
@@ -260,6 +260,13 @@ void bch_initial_gc_finish(struct cache_set *c);
 void bch_moving_gc(struct cache_set *c);
 int bch_btree_check(struct cache_set *c);
 void bch_initial_mark_key(struct cache_set *c, int level, struct bkey *k);
+typedef int (btree_map_keys_fn)(struct btree_op *op, struct btree *b,
+				struct bkey *k);
+int bch_btree_map_keys_recurse(struct btree *b, struct btree_op *op,
+			       struct bkey *from, btree_map_keys_fn *fn,
+			       int flags);
+int bch_btree_map_keys(struct btree_op *op, struct cache_set *c,
+		       struct bkey *from, btree_map_keys_fn *fn, int flags);
 
 static inline void wake_up_gc(struct cache_set *c)
 {
@@ -284,6 +291,65 @@ static inline void force_wake_up_gc(struct cache_set *c)
 	wake_up_gc(c);
 }
 
+/*
+ * These macros are for recursing down the btree - they handle the details of
+ * locking and looking up nodes in the cache for you. They're best treated as
+ * mere syntax when reading code that uses them.
+ *
+ * op->lock determines whether we take a read or a write lock at a given depth.
+ * If you've got a read lock and find that you need a write lock (i.e. you're
+ * going to have to split), set op->lock and return -EINTR; btree_root() will
+ * call you again and you'll have the correct lock.
+ */
+
+/**
+ * btree - recurse down the btree on a specified key
+ * @fn:		function to call, which will be passed the child node
+ * @key:	key to recurse on
+ * @b:		parent btree node
+ * @op:		pointer to struct btree_op
+ */
+#define btree(fn, key, b, op, ...)					\
+({									\
+	int _r, l = (b)->level - 1;					\
+	bool _w = l <= (op)->lock;					\
+	struct btree *_child = bch_btree_node_get((b)->c, op, key, l,	\
+						  _w, b);		\
+	if (!IS_ERR(_child)) {						\
+		_r = bch_btree_ ## fn(_child, op, ##__VA_ARGS__);	\
+		rw_unlock(_w, _child);					\
+	} else								\
+		_r = PTR_ERR(_child);					\
+	_r;								\
+})
+
+/**
+ * btree_root - call a function on the root of the btree
+ * @fn:		function to call, which will be passed the child node
+ * @c:		cache set
+ * @op:		pointer to struct btree_op
+ */
+#define btree_root(fn, c, op, ...)					\
+({									\
+	int _r = -EINTR;						\
+	do {								\
+		struct btree *_b = (c)->root;				\
+		bool _w = insert_lock(op, _b);				\
+		rw_lock(_w, _b, _b->level);				\
+		if (_b == (c)->root &&					\
+		    _w == insert_lock(op, _b)) {			\
+			_r = bch_btree_ ## fn(_b, op, ##__VA_ARGS__);	\
+		}							\
+		rw_unlock(_w, _b);					\
+		bch_cannibalize_unlock(c);                              \
+		if (_r == -EINTR)                                       \
+			schedule();                                     \
+	} while (_r == -EINTR);                                         \
+									\
+	finish_wait(&(c)->btree_cache_wait, &(op)->wait);               \
+	_r;                                                             \
+})
+
 #define MAP_DONE	0
 #define MAP_CONTINUE	1
 
-- 
2.16.4

