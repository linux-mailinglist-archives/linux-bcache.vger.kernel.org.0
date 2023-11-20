Return-Path: <linux-bcache+bounces-7-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A1BD7F0ACA
	for <lists+linux-bcache@lfdr.de>; Mon, 20 Nov 2023 04:08:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC8221F216D3
	for <lists+linux-bcache@lfdr.de>; Mon, 20 Nov 2023 03:08:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E84F371;
	Mon, 20 Nov 2023 03:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mU02q8p+"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFD7137;
	Sun, 19 Nov 2023 19:07:47 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700449665;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2RvnDv7pSjTLUWX78Yp3ip9aNEXzeRXiA82vk20KSDM=;
	b=mU02q8p+UMRifU2hAFTRzJCkGBuWnjEogDF+3RfxDip9i1/QOvhxX+w4WRPpnpqEbDpix6
	y8TOFBypscB42d+Zo1TTbpSOkEli22Ce4SDENio9Lp41rXwqn1vkwHHqd90OFofAdqUcum
	8xPGabU4B6zGvN8ZxngkRwPygwzWEMg=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-bcache@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Kees Cook <keescook@chromium.org>,
	Coly Li <colyli@suse.de>
Subject: [PATCH] closures: CLOSURE_CALLBACK() to fix type punning
Date: Sun, 19 Nov 2023 22:07:25 -0500
Message-ID: <20231120030729.3285278-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Control flow integrity is now checking that type signatures match on
indirect function calls. That breaks closures, which embed a work_struct
in a closure in such a way that a closure_fn may also be used as a
workqueue fn by the underlying closure code.

So we have to change closure fns to take a work_struct as their
argument - but that results in a loss of clarity, as closure fns have
different semantics from normal workqueue functions (they run owning a
ref on the closure, which must be released with continue_at() or
closure_return()).

Thus, this patc introduces CLOSURE_CALLBACK() and closure_type() macros
as suggested by Kees, to smooth things over a bit.

Suggested-by: Kees Cook <keescook@chromium.org>
Cc: Coly Li <colyli@suse.de>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 drivers/md/bcache/btree.c           | 14 +++---
 drivers/md/bcache/journal.c         | 20 ++++----
 drivers/md/bcache/movinggc.c        | 16 +++----
 drivers/md/bcache/request.c         | 74 ++++++++++++++---------------
 drivers/md/bcache/request.h         |  2 +-
 drivers/md/bcache/super.c           | 40 ++++++++--------
 drivers/md/bcache/writeback.c       | 16 +++----
 fs/bcachefs/btree_io.c              |  7 ++-
 fs/bcachefs/btree_update_interior.c |  4 +-
 fs/bcachefs/fs-io-direct.c          |  8 ++--
 fs/bcachefs/io_write.c              | 14 +++---
 fs/bcachefs/io_write.h              |  3 +-
 fs/bcachefs/journal_io.c            | 17 ++++---
 fs/bcachefs/journal_io.h            |  2 +-
 include/linux/closure.h             |  9 +++-
 lib/closure.c                       |  5 +-
 16 files changed, 127 insertions(+), 124 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index fd121a61f17c..e7ccf731f08b 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -293,16 +293,16 @@ static void btree_complete_write(struct btree *b, struct btree_write *w)
 	w->journal	= NULL;
 }
 
-static void btree_node_write_unlock(struct closure *cl)
+static CLOSURE_CALLBACK(btree_node_write_unlock)
 {
-	struct btree *b = container_of(cl, struct btree, io);
+	closure_type(b, struct btree, io);
 
 	up(&b->io_mutex);
 }
 
-static void __btree_node_write_done(struct closure *cl)
+static CLOSURE_CALLBACK(__btree_node_write_done)
 {
-	struct btree *b = container_of(cl, struct btree, io);
+	closure_type(b, struct btree, io);
 	struct btree_write *w = btree_prev_write(b);
 
 	bch_bbio_free(b->bio, b->c);
@@ -315,12 +315,12 @@ static void __btree_node_write_done(struct closure *cl)
 	closure_return_with_destructor(cl, btree_node_write_unlock);
 }
 
-static void btree_node_write_done(struct closure *cl)
+static CLOSURE_CALLBACK(btree_node_write_done)
 {
-	struct btree *b = container_of(cl, struct btree, io);
+	closure_type(b, struct btree, io);
 
 	bio_free_pages(b->bio);
-	__btree_node_write_done(cl);
+	__btree_node_write_done(&cl->work);
 }
 
 static void btree_node_write_endio(struct bio *bio)
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index c182c21de2e8..7ff14bd2feb8 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -723,11 +723,11 @@ static void journal_write_endio(struct bio *bio)
 	closure_put(&w->c->journal.io);
 }
 
-static void journal_write(struct closure *cl);
+static CLOSURE_CALLBACK(journal_write);
 
-static void journal_write_done(struct closure *cl)
+static CLOSURE_CALLBACK(journal_write_done)
 {
-	struct journal *j = container_of(cl, struct journal, io);
+	closure_type(j, struct journal, io);
 	struct journal_write *w = (j->cur == j->w)
 		? &j->w[1]
 		: &j->w[0];
@@ -736,19 +736,19 @@ static void journal_write_done(struct closure *cl)
 	continue_at_nobarrier(cl, journal_write, bch_journal_wq);
 }
 
-static void journal_write_unlock(struct closure *cl)
+static CLOSURE_CALLBACK(journal_write_unlock)
 	__releases(&c->journal.lock)
 {
-	struct cache_set *c = container_of(cl, struct cache_set, journal.io);
+	closure_type(c, struct cache_set, journal.io);
 
 	c->journal.io_in_flight = 0;
 	spin_unlock(&c->journal.lock);
 }
 
-static void journal_write_unlocked(struct closure *cl)
+static CLOSURE_CALLBACK(journal_write_unlocked)
 	__releases(c->journal.lock)
 {
-	struct cache_set *c = container_of(cl, struct cache_set, journal.io);
+	closure_type(c, struct cache_set, journal.io);
 	struct cache *ca = c->cache;
 	struct journal_write *w = c->journal.cur;
 	struct bkey *k = &c->journal.key;
@@ -823,12 +823,12 @@ static void journal_write_unlocked(struct closure *cl)
 	continue_at(cl, journal_write_done, NULL);
 }
 
-static void journal_write(struct closure *cl)
+static CLOSURE_CALLBACK(journal_write)
 {
-	struct cache_set *c = container_of(cl, struct cache_set, journal.io);
+	closure_type(c, struct cache_set, journal.io);
 
 	spin_lock(&c->journal.lock);
-	journal_write_unlocked(cl);
+	journal_write_unlocked(&cl->work);
 }
 
 static void journal_try_write(struct cache_set *c)
diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index 9f32901fdad1..ebd500bdf0b2 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -35,16 +35,16 @@ static bool moving_pred(struct keybuf *buf, struct bkey *k)
 
 /* Moving GC - IO loop */
 
-static void moving_io_destructor(struct closure *cl)
+static CLOSURE_CALLBACK(moving_io_destructor)
 {
-	struct moving_io *io = container_of(cl, struct moving_io, cl);
+	closure_type(io, struct moving_io, cl);
 
 	kfree(io);
 }
 
-static void write_moving_finish(struct closure *cl)
+static CLOSURE_CALLBACK(write_moving_finish)
 {
-	struct moving_io *io = container_of(cl, struct moving_io, cl);
+	closure_type(io, struct moving_io, cl);
 	struct bio *bio = &io->bio.bio;
 
 	bio_free_pages(bio);
@@ -89,9 +89,9 @@ static void moving_init(struct moving_io *io)
 	bch_bio_map(bio, NULL);
 }
 
-static void write_moving(struct closure *cl)
+static CLOSURE_CALLBACK(write_moving)
 {
-	struct moving_io *io = container_of(cl, struct moving_io, cl);
+	closure_type(io, struct moving_io, cl);
 	struct data_insert_op *op = &io->op;
 
 	if (!op->status) {
@@ -113,9 +113,9 @@ static void write_moving(struct closure *cl)
 	continue_at(cl, write_moving_finish, op->wq);
 }
 
-static void read_moving_submit(struct closure *cl)
+static CLOSURE_CALLBACK(read_moving_submit)
 {
-	struct moving_io *io = container_of(cl, struct moving_io, cl);
+	closure_type(io, struct moving_io, cl);
 	struct bio *bio = &io->bio.bio;
 
 	bch_submit_bbio(bio, io->op.c, &io->w->key, 0);
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index a9b1f3896249..83d112bd2b1c 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -25,7 +25,7 @@
 
 struct kmem_cache *bch_search_cache;
 
-static void bch_data_insert_start(struct closure *cl);
+static CLOSURE_CALLBACK(bch_data_insert_start);
 
 static unsigned int cache_mode(struct cached_dev *dc)
 {
@@ -55,9 +55,9 @@ static void bio_csum(struct bio *bio, struct bkey *k)
 
 /* Insert data into cache */
 
-static void bch_data_insert_keys(struct closure *cl)
+static CLOSURE_CALLBACK(bch_data_insert_keys)
 {
-	struct data_insert_op *op = container_of(cl, struct data_insert_op, cl);
+	closure_type(op, struct data_insert_op, cl);
 	atomic_t *journal_ref = NULL;
 	struct bkey *replace_key = op->replace ? &op->replace_key : NULL;
 	int ret;
@@ -136,9 +136,9 @@ static void bch_data_invalidate(struct closure *cl)
 	continue_at(cl, bch_data_insert_keys, op->wq);
 }
 
-static void bch_data_insert_error(struct closure *cl)
+static CLOSURE_CALLBACK(bch_data_insert_error)
 {
-	struct data_insert_op *op = container_of(cl, struct data_insert_op, cl);
+	closure_type(op, struct data_insert_op, cl);
 
 	/*
 	 * Our data write just errored, which means we've got a bunch of keys to
@@ -163,7 +163,7 @@ static void bch_data_insert_error(struct closure *cl)
 
 	op->insert_keys.top = dst;
 
-	bch_data_insert_keys(cl);
+	bch_data_insert_keys(&cl->work);
 }
 
 static void bch_data_insert_endio(struct bio *bio)
@@ -184,9 +184,9 @@ static void bch_data_insert_endio(struct bio *bio)
 	bch_bbio_endio(op->c, bio, bio->bi_status, "writing data to cache");
 }
 
-static void bch_data_insert_start(struct closure *cl)
+static CLOSURE_CALLBACK(bch_data_insert_start)
 {
-	struct data_insert_op *op = container_of(cl, struct data_insert_op, cl);
+	closure_type(op, struct data_insert_op, cl);
 	struct bio *bio = op->bio, *n;
 
 	if (op->bypass)
@@ -305,16 +305,16 @@ static void bch_data_insert_start(struct closure *cl)
  * If op->bypass is true, instead of inserting the data it invalidates the
  * region of the cache represented by op->bio and op->inode.
  */
-void bch_data_insert(struct closure *cl)
+CLOSURE_CALLBACK(bch_data_insert)
 {
-	struct data_insert_op *op = container_of(cl, struct data_insert_op, cl);
+	closure_type(op, struct data_insert_op, cl);
 
 	trace_bcache_write(op->c, op->inode, op->bio,
 			   op->writeback, op->bypass);
 
 	bch_keylist_init(&op->insert_keys);
 	bio_get(op->bio);
-	bch_data_insert_start(cl);
+	bch_data_insert_start(&cl->work);
 }
 
 /*
@@ -575,9 +575,9 @@ static int cache_lookup_fn(struct btree_op *op, struct btree *b, struct bkey *k)
 	return n == bio ? MAP_DONE : MAP_CONTINUE;
 }
 
-static void cache_lookup(struct closure *cl)
+static CLOSURE_CALLBACK(cache_lookup)
 {
-	struct search *s = container_of(cl, struct search, iop.cl);
+	closure_type(s, struct search, iop.cl);
 	struct bio *bio = &s->bio.bio;
 	struct cached_dev *dc;
 	int ret;
@@ -698,9 +698,9 @@ static void do_bio_hook(struct search *s,
 	bio_cnt_set(bio, 3);
 }
 
-static void search_free(struct closure *cl)
+static CLOSURE_CALLBACK(search_free)
 {
-	struct search *s = container_of(cl, struct search, cl);
+	closure_type(s, struct search, cl);
 
 	atomic_dec(&s->iop.c->search_inflight);
 
@@ -749,20 +749,20 @@ static inline struct search *search_alloc(struct bio *bio,
 
 /* Cached devices */
 
-static void cached_dev_bio_complete(struct closure *cl)
+static CLOSURE_CALLBACK(cached_dev_bio_complete)
 {
-	struct search *s = container_of(cl, struct search, cl);
+	closure_type(s, struct search, cl);
 	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
 
 	cached_dev_put(dc);
-	search_free(cl);
+	search_free(&cl->work);
 }
 
 /* Process reads */
 
-static void cached_dev_read_error_done(struct closure *cl)
+static CLOSURE_CALLBACK(cached_dev_read_error_done)
 {
-	struct search *s = container_of(cl, struct search, cl);
+	closure_type(s, struct search, cl);
 
 	if (s->iop.replace_collision)
 		bch_mark_cache_miss_collision(s->iop.c, s->d);
@@ -770,12 +770,12 @@ static void cached_dev_read_error_done(struct closure *cl)
 	if (s->iop.bio)
 		bio_free_pages(s->iop.bio);
 
-	cached_dev_bio_complete(cl);
+	cached_dev_bio_complete(&cl->work);
 }
 
-static void cached_dev_read_error(struct closure *cl)
+static CLOSURE_CALLBACK(cached_dev_read_error)
 {
-	struct search *s = container_of(cl, struct search, cl);
+	closure_type(s, struct search, cl);
 	struct bio *bio = &s->bio.bio;
 
 	/*
@@ -801,9 +801,9 @@ static void cached_dev_read_error(struct closure *cl)
 	continue_at(cl, cached_dev_read_error_done, NULL);
 }
 
-static void cached_dev_cache_miss_done(struct closure *cl)
+static CLOSURE_CALLBACK(cached_dev_cache_miss_done)
 {
-	struct search *s = container_of(cl, struct search, cl);
+	closure_type(s, struct search, cl);
 	struct bcache_device *d = s->d;
 
 	if (s->iop.replace_collision)
@@ -812,13 +812,13 @@ static void cached_dev_cache_miss_done(struct closure *cl)
 	if (s->iop.bio)
 		bio_free_pages(s->iop.bio);
 
-	cached_dev_bio_complete(cl);
+	cached_dev_bio_complete(&cl->work);
 	closure_put(&d->cl);
 }
 
-static void cached_dev_read_done(struct closure *cl)
+static CLOSURE_CALLBACK(cached_dev_read_done)
 {
-	struct search *s = container_of(cl, struct search, cl);
+	closure_type(s, struct search, cl);
 	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
 
 	/*
@@ -858,9 +858,9 @@ static void cached_dev_read_done(struct closure *cl)
 	continue_at(cl, cached_dev_cache_miss_done, NULL);
 }
 
-static void cached_dev_read_done_bh(struct closure *cl)
+static CLOSURE_CALLBACK(cached_dev_read_done_bh)
 {
-	struct search *s = container_of(cl, struct search, cl);
+	closure_type(s, struct search, cl);
 	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
 
 	bch_mark_cache_accounting(s->iop.c, s->d,
@@ -955,13 +955,13 @@ static void cached_dev_read(struct cached_dev *dc, struct search *s)
 
 /* Process writes */
 
-static void cached_dev_write_complete(struct closure *cl)
+static CLOSURE_CALLBACK(cached_dev_write_complete)
 {
-	struct search *s = container_of(cl, struct search, cl);
+	closure_type(s, struct search, cl);
 	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
 
 	up_read_non_owner(&dc->writeback_lock);
-	cached_dev_bio_complete(cl);
+	cached_dev_bio_complete(&cl->work);
 }
 
 static void cached_dev_write(struct cached_dev *dc, struct search *s)
@@ -1048,9 +1048,9 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
 	continue_at(cl, cached_dev_write_complete, NULL);
 }
 
-static void cached_dev_nodata(struct closure *cl)
+static CLOSURE_CALLBACK(cached_dev_nodata)
 {
-	struct search *s = container_of(cl, struct search, cl);
+	closure_type(s, struct search, cl);
 	struct bio *bio = &s->bio.bio;
 
 	if (s->iop.flush_journal)
@@ -1265,9 +1265,9 @@ static int flash_dev_cache_miss(struct btree *b, struct search *s,
 	return MAP_CONTINUE;
 }
 
-static void flash_dev_nodata(struct closure *cl)
+static CLOSURE_CALLBACK(flash_dev_nodata)
 {
-	struct search *s = container_of(cl, struct search, cl);
+	closure_type(s, struct search, cl);
 
 	if (s->iop.flush_journal)
 		bch_journal_meta(s->iop.c, cl);
diff --git a/drivers/md/bcache/request.h b/drivers/md/bcache/request.h
index 38ab4856eaab..46bbef00aebb 100644
--- a/drivers/md/bcache/request.h
+++ b/drivers/md/bcache/request.h
@@ -34,7 +34,7 @@ struct data_insert_op {
 };
 
 unsigned int bch_get_congested(const struct cache_set *c);
-void bch_data_insert(struct closure *cl);
+CLOSURE_CALLBACK(bch_data_insert);
 
 void bch_cached_dev_request_init(struct cached_dev *dc);
 void cached_dev_submit_bio(struct bio *bio);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 8bd899766372..e0db905c1ca0 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -327,9 +327,9 @@ static void __write_super(struct cache_sb *sb, struct cache_sb_disk *out,
 	submit_bio(bio);
 }
 
-static void bch_write_bdev_super_unlock(struct closure *cl)
+static CLOSURE_CALLBACK(bch_write_bdev_super_unlock)
 {
-	struct cached_dev *dc = container_of(cl, struct cached_dev, sb_write);
+	closure_type(dc, struct cached_dev, sb_write);
 
 	up(&dc->sb_write_mutex);
 }
@@ -363,9 +363,9 @@ static void write_super_endio(struct bio *bio)
 	closure_put(&ca->set->sb_write);
 }
 
-static void bcache_write_super_unlock(struct closure *cl)
+static CLOSURE_CALLBACK(bcache_write_super_unlock)
 {
-	struct cache_set *c = container_of(cl, struct cache_set, sb_write);
+	closure_type(c, struct cache_set, sb_write);
 
 	up(&c->sb_write_mutex);
 }
@@ -407,9 +407,9 @@ static void uuid_endio(struct bio *bio)
 	closure_put(cl);
 }
 
-static void uuid_io_unlock(struct closure *cl)
+static CLOSURE_CALLBACK(uuid_io_unlock)
 {
-	struct cache_set *c = container_of(cl, struct cache_set, uuid_write);
+	closure_type(c, struct cache_set, uuid_write);
 
 	up(&c->uuid_write_mutex);
 }
@@ -1342,9 +1342,9 @@ void bch_cached_dev_release(struct kobject *kobj)
 	module_put(THIS_MODULE);
 }
 
-static void cached_dev_free(struct closure *cl)
+static CLOSURE_CALLBACK(cached_dev_free)
 {
-	struct cached_dev *dc = container_of(cl, struct cached_dev, disk.cl);
+	closure_type(dc, struct cached_dev, disk.cl);
 
 	if (test_and_clear_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags))
 		cancel_writeback_rate_update_dwork(dc);
@@ -1376,9 +1376,9 @@ static void cached_dev_free(struct closure *cl)
 	kobject_put(&dc->disk.kobj);
 }
 
-static void cached_dev_flush(struct closure *cl)
+static CLOSURE_CALLBACK(cached_dev_flush)
 {
-	struct cached_dev *dc = container_of(cl, struct cached_dev, disk.cl);
+	closure_type(dc, struct cached_dev, disk.cl);
 	struct bcache_device *d = &dc->disk;
 
 	mutex_lock(&bch_register_lock);
@@ -1497,9 +1497,9 @@ void bch_flash_dev_release(struct kobject *kobj)
 	kfree(d);
 }
 
-static void flash_dev_free(struct closure *cl)
+static CLOSURE_CALLBACK(flash_dev_free)
 {
-	struct bcache_device *d = container_of(cl, struct bcache_device, cl);
+	closure_type(d, struct bcache_device, cl);
 
 	mutex_lock(&bch_register_lock);
 	atomic_long_sub(bcache_dev_sectors_dirty(d),
@@ -1510,9 +1510,9 @@ static void flash_dev_free(struct closure *cl)
 	kobject_put(&d->kobj);
 }
 
-static void flash_dev_flush(struct closure *cl)
+static CLOSURE_CALLBACK(flash_dev_flush)
 {
-	struct bcache_device *d = container_of(cl, struct bcache_device, cl);
+	closure_type(d, struct bcache_device, cl);
 
 	mutex_lock(&bch_register_lock);
 	bcache_device_unlink(d);
@@ -1668,9 +1668,9 @@ void bch_cache_set_release(struct kobject *kobj)
 	module_put(THIS_MODULE);
 }
 
-static void cache_set_free(struct closure *cl)
+static CLOSURE_CALLBACK(cache_set_free)
 {
-	struct cache_set *c = container_of(cl, struct cache_set, cl);
+	closure_type(c, struct cache_set, cl);
 	struct cache *ca;
 
 	debugfs_remove(c->debug);
@@ -1709,9 +1709,9 @@ static void cache_set_free(struct closure *cl)
 	kobject_put(&c->kobj);
 }
 
-static void cache_set_flush(struct closure *cl)
+static CLOSURE_CALLBACK(cache_set_flush)
 {
-	struct cache_set *c = container_of(cl, struct cache_set, caching);
+	closure_type(c, struct cache_set, caching);
 	struct cache *ca = c->cache;
 	struct btree *b;
 
@@ -1806,9 +1806,9 @@ static void conditional_stop_bcache_device(struct cache_set *c,
 	}
 }
 
-static void __cache_set_unregister(struct closure *cl)
+static CLOSURE_CALLBACK(__cache_set_unregister)
 {
-	struct cache_set *c = container_of(cl, struct cache_set, caching);
+	closure_type(c, struct cache_set, caching);
 	struct cached_dev *dc;
 	struct bcache_device *d;
 	size_t i;
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 24c049067f61..77427e355613 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -341,16 +341,16 @@ static void dirty_init(struct keybuf_key *w)
 	bch_bio_map(bio, NULL);
 }
 
-static void dirty_io_destructor(struct closure *cl)
+static CLOSURE_CALLBACK(dirty_io_destructor)
 {
-	struct dirty_io *io = container_of(cl, struct dirty_io, cl);
+	closure_type(io, struct dirty_io, cl);
 
 	kfree(io);
 }
 
-static void write_dirty_finish(struct closure *cl)
+static CLOSURE_CALLBACK(write_dirty_finish)
 {
-	struct dirty_io *io = container_of(cl, struct dirty_io, cl);
+	closure_type(io, struct dirty_io, cl);
 	struct keybuf_key *w = io->bio.bi_private;
 	struct cached_dev *dc = io->dc;
 
@@ -400,9 +400,9 @@ static void dirty_endio(struct bio *bio)
 	closure_put(&io->cl);
 }
 
-static void write_dirty(struct closure *cl)
+static CLOSURE_CALLBACK(write_dirty)
 {
-	struct dirty_io *io = container_of(cl, struct dirty_io, cl);
+	closure_type(io, struct dirty_io, cl);
 	struct keybuf_key *w = io->bio.bi_private;
 	struct cached_dev *dc = io->dc;
 
@@ -462,9 +462,9 @@ static void read_dirty_endio(struct bio *bio)
 	dirty_endio(bio);
 }
 
-static void read_dirty_submit(struct closure *cl)
+static CLOSURE_CALLBACK(read_dirty_submit)
 {
-	struct dirty_io *io = container_of(cl, struct dirty_io, cl);
+	closure_type(io, struct dirty_io, cl);
 
 	closure_bio_submit(io->dc->disk.c, &io->bio, cl);
 
diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index 1f73ee0ee359..3c663c596b46 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -1358,10 +1358,9 @@ static bool btree_node_has_extra_bsets(struct bch_fs *c, unsigned offset, void *
 	return offset;
 }
 
-static void btree_node_read_all_replicas_done(struct closure *cl)
+static CLOSURE_CALLBACK(btree_node_read_all_replicas_done)
 {
-	struct btree_node_read_all *ra =
-		container_of(cl, struct btree_node_read_all, cl);
+	closure_type(ra, struct btree_node_read_all, cl);
 	struct bch_fs *c = ra->c;
 	struct btree *b = ra->b;
 	struct printbuf buf = PRINTBUF;
@@ -1567,7 +1566,7 @@ static int btree_node_read_all_replicas(struct bch_fs *c, struct btree *b, bool
 
 	if (sync) {
 		closure_sync(&ra->cl);
-		btree_node_read_all_replicas_done(&ra->cl);
+		btree_node_read_all_replicas_done(&ra->cl.work);
 	} else {
 		continue_at(&ra->cl, btree_node_read_all_replicas_done,
 			    c->io_complete_wq);
diff --git a/fs/bcachefs/btree_update_interior.c b/fs/bcachefs/btree_update_interior.c
index 18e5a75142e9..bfe4d7975bd8 100644
--- a/fs/bcachefs/btree_update_interior.c
+++ b/fs/bcachefs/btree_update_interior.c
@@ -774,9 +774,9 @@ static void btree_interior_update_work(struct work_struct *work)
 	}
 }
 
-static void btree_update_set_nodes_written(struct closure *cl)
+static CLOSURE_CALLBACK(btree_update_set_nodes_written)
 {
-	struct btree_update *as = container_of(cl, struct btree_update, cl);
+	closure_type(as, struct btree_update, cl);
 	struct bch_fs *c = as->c;
 
 	mutex_lock(&c->btree_interior_update_lock);
diff --git a/fs/bcachefs/fs-io-direct.c b/fs/bcachefs/fs-io-direct.c
index 5b42a76c4796..9a479e4de6b3 100644
--- a/fs/bcachefs/fs-io-direct.c
+++ b/fs/bcachefs/fs-io-direct.c
@@ -35,9 +35,9 @@ static void bio_check_or_release(struct bio *bio, bool check_dirty)
 	}
 }
 
-static void bch2_dio_read_complete(struct closure *cl)
+static CLOSURE_CALLBACK(bch2_dio_read_complete)
 {
-	struct dio_read *dio = container_of(cl, struct dio_read, cl);
+	closure_type(dio, struct dio_read, cl);
 
 	dio->req->ki_complete(dio->req, dio->ret);
 	bio_check_or_release(&dio->rbio.bio, dio->should_dirty);
@@ -325,9 +325,9 @@ static noinline int bch2_dio_write_copy_iov(struct dio_write *dio)
 	return 0;
 }
 
-static void bch2_dio_write_flush_done(struct closure *cl)
+static CLOSURE_CALLBACK(bch2_dio_write_flush_done)
 {
-	struct dio_write *dio = container_of(cl, struct dio_write, op.cl);
+	closure_type(dio, struct dio_write, op.cl);
 	struct bch_fs *c = dio->op.c;
 
 	closure_debug_destroy(cl);
diff --git a/fs/bcachefs/io_write.c b/fs/bcachefs/io_write.c
index 75376f040e4b..d6bd8f788d3a 100644
--- a/fs/bcachefs/io_write.c
+++ b/fs/bcachefs/io_write.c
@@ -580,9 +580,9 @@ static inline void wp_update_state(struct write_point *wp, bool running)
 	__wp_update_state(wp, state);
 }
 
-static void bch2_write_index(struct closure *cl)
+static CLOSURE_CALLBACK(bch2_write_index)
 {
-	struct bch_write_op *op = container_of(cl, struct bch_write_op, cl);
+	closure_type(op, struct bch_write_op, cl);
 	struct write_point *wp = op->wp;
 	struct workqueue_struct *wq = index_update_wq(op);
 	unsigned long flags;
@@ -1208,9 +1208,9 @@ static void __bch2_nocow_write_done(struct bch_write_op *op)
 		bch2_nocow_write_convert_unwritten(op);
 }
 
-static void bch2_nocow_write_done(struct closure *cl)
+static CLOSURE_CALLBACK(bch2_nocow_write_done)
 {
-	struct bch_write_op *op = container_of(cl, struct bch_write_op, cl);
+	closure_type(op, struct bch_write_op, cl);
 
 	__bch2_nocow_write_done(op);
 	bch2_write_done(cl);
@@ -1363,7 +1363,7 @@ static void bch2_nocow_write(struct bch_write_op *op)
 		op->insert_keys.top = op->insert_keys.keys;
 	} else if (op->flags & BCH_WRITE_SYNC) {
 		closure_sync(&op->cl);
-		bch2_nocow_write_done(&op->cl);
+		bch2_nocow_write_done(&op->cl.work);
 	} else {
 		/*
 		 * XXX
@@ -1566,9 +1566,9 @@ static void bch2_write_data_inline(struct bch_write_op *op, unsigned data_len)
  * If op->discard is true, instead of inserting the data it invalidates the
  * region of the cache represented by op->bio and op->inode.
  */
-void bch2_write(struct closure *cl)
+CLOSURE_CALLBACK(bch2_write)
 {
-	struct bch_write_op *op = container_of(cl, struct bch_write_op, cl);
+	closure_type(op, struct bch_write_op, cl);
 	struct bio *bio = &op->wbio.bio;
 	struct bch_fs *c = op->c;
 	unsigned data_len;
diff --git a/fs/bcachefs/io_write.h b/fs/bcachefs/io_write.h
index 9323167229ee..6c276a48f95d 100644
--- a/fs/bcachefs/io_write.h
+++ b/fs/bcachefs/io_write.h
@@ -90,8 +90,7 @@ static inline void bch2_write_op_init(struct bch_write_op *op, struct bch_fs *c,
 	op->devs_need_flush	= NULL;
 }
 
-void bch2_write(struct closure *);
-
+CLOSURE_CALLBACK(bch2_write);
 void bch2_write_point_do_index_updates(struct work_struct *);
 
 static inline struct bch_write_bio *wbio_init(struct bio *bio)
diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index 09fcea643a6a..6553a2cab1d4 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -1042,10 +1042,9 @@ static int journal_read_bucket(struct bch_dev *ca,
 	return 0;
 }
 
-static void bch2_journal_read_device(struct closure *cl)
+static CLOSURE_CALLBACK(bch2_journal_read_device)
 {
-	struct journal_device *ja =
-		container_of(cl, struct journal_device, read);
+	closure_type(ja, struct journal_device, read);
 	struct bch_dev *ca = container_of(ja, struct bch_dev, journal);
 	struct bch_fs *c = ca->fs;
 	struct journal_list *jlist =
@@ -1544,9 +1543,9 @@ static inline struct journal_buf *journal_last_unwritten_buf(struct journal *j)
 	return j->buf + (journal_last_unwritten_seq(j) & JOURNAL_BUF_MASK);
 }
 
-static void journal_write_done(struct closure *cl)
+static CLOSURE_CALLBACK(journal_write_done)
 {
-	struct journal *j = container_of(cl, struct journal, io);
+	closure_type(j, struct journal, io);
 	struct bch_fs *c = container_of(j, struct bch_fs, journal);
 	struct journal_buf *w = journal_last_unwritten_buf(j);
 	struct bch_replicas_padded replicas;
@@ -1666,9 +1665,9 @@ static void journal_write_endio(struct bio *bio)
 	percpu_ref_put(&ca->io_ref);
 }
 
-static void do_journal_write(struct closure *cl)
+static CLOSURE_CALLBACK(do_journal_write)
 {
-	struct journal *j = container_of(cl, struct journal, io);
+	closure_type(j, struct journal, io);
 	struct bch_fs *c = container_of(j, struct bch_fs, journal);
 	struct bch_dev *ca;
 	struct journal_buf *w = journal_last_unwritten_buf(j);
@@ -1902,9 +1901,9 @@ static int bch2_journal_write_pick_flush(struct journal *j, struct journal_buf *
 	return 0;
 }
 
-void bch2_journal_write(struct closure *cl)
+CLOSURE_CALLBACK(bch2_journal_write)
 {
-	struct journal *j = container_of(cl, struct journal, io);
+	closure_type(j, struct journal, io);
 	struct bch_fs *c = container_of(j, struct bch_fs, journal);
 	struct bch_dev *ca;
 	struct journal_buf *w = journal_last_unwritten_buf(j);
diff --git a/fs/bcachefs/journal_io.h b/fs/bcachefs/journal_io.h
index a88d097b13f1..c035e7c108e1 100644
--- a/fs/bcachefs/journal_io.h
+++ b/fs/bcachefs/journal_io.h
@@ -60,6 +60,6 @@ void bch2_journal_ptrs_to_text(struct printbuf *, struct bch_fs *,
 
 int bch2_journal_read(struct bch_fs *, u64 *, u64 *, u64 *);
 
-void bch2_journal_write(struct closure *);
+CLOSURE_CALLBACK(bch2_journal_write);
 
 #endif /* _BCACHEFS_JOURNAL_IO_H */
diff --git a/include/linux/closure.h b/include/linux/closure.h
index de7bb47d8a46..c554c6a08768 100644
--- a/include/linux/closure.h
+++ b/include/linux/closure.h
@@ -104,7 +104,7 @@
 
 struct closure;
 struct closure_syncer;
-typedef void (closure_fn) (struct closure *);
+typedef void (closure_fn) (struct work_struct *);
 extern struct dentry *bcache_debug;
 
 struct closure_waitlist {
@@ -254,7 +254,7 @@ static inline void closure_queue(struct closure *cl)
 		INIT_WORK(&cl->work, cl->work.func);
 		BUG_ON(!queue_work(wq, &cl->work));
 	} else
-		cl->fn(cl);
+		cl->fn(&cl->work);
 }
 
 /**
@@ -309,6 +309,11 @@ static inline void closure_wake_up(struct closure_waitlist *list)
 	__closure_wake_up(list);
 }
 
+#define CLOSURE_CALLBACK(name)	void name(struct work_struct *ws)
+#define closure_type(name, type, member)				\
+	struct closure *cl = container_of(ws, struct closure, work);	\
+	type *name = container_of(cl, type, member)
+
 /**
  * continue_at - jump to another function with barrier
  *
diff --git a/lib/closure.c b/lib/closure.c
index f86c9eeafb35..c16540552d61 100644
--- a/lib/closure.c
+++ b/lib/closure.c
@@ -36,7 +36,7 @@ static inline void closure_put_after_sub(struct closure *cl, int flags)
 			closure_debug_destroy(cl);
 
 			if (destructor)
-				destructor(cl);
+				destructor(&cl->work);
 
 			if (parent)
 				closure_put(parent);
@@ -108,8 +108,9 @@ struct closure_syncer {
 	int			done;
 };
 
-static void closure_sync_fn(struct closure *cl)
+static CLOSURE_CALLBACK(closure_sync_fn)
 {
+	struct closure *cl = container_of(ws, struct closure, work);
 	struct closure_syncer *s = cl->s;
 	struct task_struct *p;
 
-- 
2.42.0


