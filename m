Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E100318641
	for <lists+linux-bcache@lfdr.de>; Thu, 11 Feb 2021 09:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbhBKIWY (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 11 Feb 2021 03:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhBKIWW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 11 Feb 2021 03:22:22 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD97C06174A;
        Thu, 11 Feb 2021 00:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=6/FGIVwlCesXZ+hKz+1qJa4pxglPX2QZJ52uUAojztI=; b=AMp4qXBUd/Dvsic8S6GlzQNl1b
        HPdCONr0Rme24YB1AXJAncGs4eMVO5X2v+A8FPzpu0qbVkomHrfR9zKkMALz0xu6pL2rh5Kde13AS
        QaYmKd1seeMTryUYnElzRGsnnnjVXz4pJ0UAmWJIV3MjmMq3wh27zvxitVd/bvwj34RiEKCr+iadp
        j5gGZPme+GJEyrYQRVoqF5l45H006LFpuKsaeNVIwZ/qj3BWJP+5F1rlFYhYdHpD4xAoT6Sz25ejk
        d2Am92nBNUmpzFzqysTwQMpvGmNEGQYc/WG6bSM1MfblhgYSG2cDPgAhMcYL1kx1EpZyo/aEora49
        6jLEhY1A==;
Received: from 213-225-11-22.nat.highway.a1.net ([213.225.11.22] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lA7EH-009y1i-RW; Thu, 11 Feb 2021 08:21:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     colyli@suse.de
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH] bcache: remove PTR_BUCKET
Date:   Thu, 11 Feb 2021 09:19:26 +0100
Message-Id: <20210211081926.104917-1-hch@lst.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Remove the PTR_BUCKET inline and replace it with a direct dereference
of c->cache.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/alloc.c     |  5 ++---
 drivers/md/bcache/bcache.h    | 11 ++---------
 drivers/md/bcache/btree.c     |  4 ++--
 drivers/md/bcache/debug.c     |  2 +-
 drivers/md/bcache/extents.c   |  4 ++--
 drivers/md/bcache/io.c        |  4 ++--
 drivers/md/bcache/journal.c   |  2 +-
 drivers/md/bcache/writeback.c |  5 ++---
 8 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 8c371d5eef8eb9..097577ae3c4717 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -482,8 +482,7 @@ void bch_bucket_free(struct cache_set *c, struct bkey *k)
 	unsigned int i;
 
 	for (i = 0; i < KEY_PTRS(k); i++)
-		__bch_bucket_free(PTR_CACHE(c, k, i),
-				  PTR_BUCKET(c, k, i));
+		__bch_bucket_free(c->cache, PTR_BUCKET(c, k, i));
 }
 
 int __bch_bucket_alloc_set(struct cache_set *c, unsigned int reserve,
@@ -674,7 +673,7 @@ bool bch_alloc_sectors(struct cache_set *c,
 		SET_PTR_OFFSET(&b->key, i, PTR_OFFSET(&b->key, i) + sectors);
 
 		atomic_long_add(sectors,
-				&PTR_CACHE(c, &b->key, i)->sectors_written);
+				&c->cache->sectors_written);
 	}
 
 	if (b->sectors_free < c->cache->sb.block_size)
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 848dd4db165929..0a4551e165abf9 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -804,13 +804,6 @@ static inline sector_t bucket_remainder(struct cache_set *c, sector_t s)
 	return s & (c->cache->sb.bucket_size - 1);
 }
 
-static inline struct cache *PTR_CACHE(struct cache_set *c,
-				      const struct bkey *k,
-				      unsigned int ptr)
-{
-	return c->cache;
-}
-
 static inline size_t PTR_BUCKET_NR(struct cache_set *c,
 				   const struct bkey *k,
 				   unsigned int ptr)
@@ -822,7 +815,7 @@ static inline struct bucket *PTR_BUCKET(struct cache_set *c,
 					const struct bkey *k,
 					unsigned int ptr)
 {
-	return PTR_CACHE(c, k, ptr)->buckets + PTR_BUCKET_NR(c, k, ptr);
+	return c->cache->buckets + PTR_BUCKET_NR(c, k, ptr);
 }
 
 static inline uint8_t gen_after(uint8_t a, uint8_t b)
@@ -841,7 +834,7 @@ static inline uint8_t ptr_stale(struct cache_set *c, const struct bkey *k,
 static inline bool ptr_available(struct cache_set *c, const struct bkey *k,
 				 unsigned int i)
 {
-	return (PTR_DEV(k, i) < MAX_CACHES_PER_SET) && PTR_CACHE(c, k, i);
+	return (PTR_DEV(k, i) < MAX_CACHES_PER_SET) && c->cache;
 }
 
 /* Btree key macros */
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index fe6dce125aba22..183a58c893774d 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -426,7 +426,7 @@ void __bch_btree_node_write(struct btree *b, struct closure *parent)
 	do_btree_node_write(b);
 
 	atomic_long_add(set_blocks(i, block_bytes(b->c->cache)) * b->c->cache->sb.block_size,
-			&PTR_CACHE(b->c, &b->key, 0)->btree_sectors_written);
+			&b->c->cache->btree_sectors_written);
 
 	b->written += set_blocks(i, block_bytes(b->c->cache));
 }
@@ -1161,7 +1161,7 @@ static void make_btree_freeing_key(struct btree *b, struct bkey *k)
 
 	for (i = 0; i < KEY_PTRS(k); i++)
 		SET_PTR_GEN(k, i,
-			    bch_inc_gen(PTR_CACHE(b->c, &b->key, i),
+			    bch_inc_gen(b->c->cache,
 					PTR_BUCKET(b->c, &b->key, i)));
 
 	mutex_unlock(&b->c->bucket_lock);
diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 63e809f38e3f51..589a052efeb1ab 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -50,7 +50,7 @@ void bch_btree_verify(struct btree *b)
 	v->keys.ops = b->keys.ops;
 
 	bio = bch_bbio_alloc(b->c);
-	bio_set_dev(bio, PTR_CACHE(b->c, &b->key, 0)->bdev);
+	bio_set_dev(bio, c->cache->bdev);
 	bio->bi_iter.bi_sector	= PTR_OFFSET(&b->key, 0);
 	bio->bi_iter.bi_size	= KEY_SIZE(&v->key) << 9;
 	bio->bi_opf		= REQ_OP_READ | REQ_META;
diff --git a/drivers/md/bcache/extents.c b/drivers/md/bcache/extents.c
index f4658a1f37b862..d626ffcbecb99c 100644
--- a/drivers/md/bcache/extents.c
+++ b/drivers/md/bcache/extents.c
@@ -50,7 +50,7 @@ static bool __ptr_invalid(struct cache_set *c, const struct bkey *k)
 
 	for (i = 0; i < KEY_PTRS(k); i++)
 		if (ptr_available(c, k, i)) {
-			struct cache *ca = PTR_CACHE(c, k, i);
+			struct cache *ca = c->cache;
 			size_t bucket = PTR_BUCKET_NR(c, k, i);
 			size_t r = bucket_remainder(c, PTR_OFFSET(k, i));
 
@@ -71,7 +71,7 @@ static const char *bch_ptr_status(struct cache_set *c, const struct bkey *k)
 
 	for (i = 0; i < KEY_PTRS(k); i++)
 		if (ptr_available(c, k, i)) {
-			struct cache *ca = PTR_CACHE(c, k, i);
+			struct cache *ca = c->cache;
 			size_t bucket = PTR_BUCKET_NR(c, k, i);
 			size_t r = bucket_remainder(c, PTR_OFFSET(k, i));
 
diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index dad71a6b78891c..e4388fe3ab7ef9 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -36,7 +36,7 @@ void __bch_submit_bbio(struct bio *bio, struct cache_set *c)
 	struct bbio *b = container_of(bio, struct bbio, bio);
 
 	bio->bi_iter.bi_sector	= PTR_OFFSET(&b->key, 0);
-	bio_set_dev(bio, PTR_CACHE(c, &b->key, 0)->bdev);
+	bio_set_dev(bio, c->cache->bdev);
 
 	b->submit_time_us = local_clock_us();
 	closure_bio_submit(c, bio, bio->bi_private);
@@ -137,7 +137,7 @@ void bch_bbio_count_io_errors(struct cache_set *c, struct bio *bio,
 			      blk_status_t error, const char *m)
 {
 	struct bbio *b = container_of(bio, struct bbio, bio);
-	struct cache *ca = PTR_CACHE(c, &b->key, 0);
+	struct cache *ca = c->cache;
 	int is_read = (bio_data_dir(bio) == READ ? 1 : 0);
 
 	unsigned int threshold = op_is_write(bio_op(bio))
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index c6613e81733376..de2c0d7699cf54 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -768,7 +768,7 @@ static void journal_write_unlocked(struct closure *cl)
 	w->data->csum		= csum_set(w->data);
 
 	for (i = 0; i < KEY_PTRS(k); i++) {
-		ca = PTR_CACHE(c, k, i);
+		ca = c->cache;
 		bio = &ca->journal.bio;
 
 		atomic_long_add(sectors, &ca->meta_sectors_written);
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 82d4e0880a994e..bcd550a2b0dab7 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -416,7 +416,7 @@ static void read_dirty_endio(struct bio *bio)
 	struct dirty_io *io = w->private;
 
 	/* is_read = 1 */
-	bch_count_io_errors(PTR_CACHE(io->dc->disk.c, &w->key, 0),
+	bch_count_io_errors(io->dc->disk.c->cache,
 			    bio->bi_status, 1,
 			    "reading dirty data from cache");
 
@@ -510,8 +510,7 @@ static void read_dirty(struct cached_dev *dc)
 			dirty_init(w);
 			bio_set_op_attrs(&io->bio, REQ_OP_READ, 0);
 			io->bio.bi_iter.bi_sector = PTR_OFFSET(&w->key, 0);
-			bio_set_dev(&io->bio,
-				    PTR_CACHE(dc->disk.c, &w->key, 0)->bdev);
+			bio_set_dev(&io->bio, dc->disk.c->cache->bdev);
 			io->bio.bi_end_io	= read_dirty_endio;
 
 			if (bch_bio_alloc_pages(&io->bio, GFP_KERNEL))
-- 
2.29.2

