Return-Path: <linux-bcache+bounces-1212-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 746E2BC0CEA
	for <lists+linux-bcache@lfdr.de>; Tue, 07 Oct 2025 11:03:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 224D63A3A11
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Oct 2025 09:03:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 996A82C3258;
	Tue,  7 Oct 2025 09:03:02 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8068B1891AB
	for <linux-bcache@vger.kernel.org>; Tue,  7 Oct 2025 09:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759827782; cv=none; b=elBVCorY9wqDV+NMtNakcs+D3tw4T2PoVGXqqTXVVss3lpCcobPL1H/Wjmcp6qZT4Z8jP3ZtmlFcu8uBsVYd+ujMRRf1N4ROUrzzta1t2h5OLOmqqYmcqG23SeMYexUavKgwD9ES3EFWrS8hJIZt2g6JQR0Sp/4xYsZoIKITydc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759827782; c=relaxed/simple;
	bh=am8F0jhQ86R2uVPYT2W+IWbx6NwhsYoO67B+qZdE5fg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GeomVRwiYL/Or2hc+9I1dKN+SqTiRc2SvvEOQ2fv5MLtXNwT6OGsJjqPyd02xI8A4CB21Lfowxsnemehh1Unem4tvkgDII7cH9nlGz5lsnm0wrBtMR4Ce2hAo6Wbphlr0sS4eCmJALC7bgX8N00iswOHs9BcMBLP6HVX7nm+Lsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247F1C4CEF1;
	Tue,  7 Oct 2025 09:02:59 +0000 (UTC)
From: colyli@fnnas.com
To: linux-bcache@vger.kernel.org
Cc: Coly Li <colyli@fnnas.com>,
	Zhou Jifeng <zhoujifeng@kylinos.com.cn>
Subject: [PATCH] bcache: avoid redundant access RB tree in read_dirty
Date: Tue,  7 Oct 2025 17:02:32 +0800
Message-ID: <20251007090232.30386-1-colyli@fnnas.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Coly Li <colyli@fnnas.com>

In bcache writeback procedure, scanned dirty keys are stored in a
red-black tree, it is dc->writeback_keys.freelist, and can be indexed by
dc->writeback_keys.keys. Inside red_dirty() one dirty key is fetched by
calling bch_keybuf_next() in each while-loop until one of the following
situations meets,
- The fetched keys number reaches MAX_WRTEBACKS_IN_PASS.
- The total size of the fetched keys reaches MAX_WRITESIZE_IN_PASS.
- All nodes in the red-black tree are iterated.

The above process is reasonable, but calling bch_keybuf_next() in each
while-loop is inefficient. Let me explain why. Let's see its code,
2767 struct keybuf_key *bch_keybuf_next(struct keybuf *buf)
2768 {
2769         struct keybuf_key *w;
2770
2771         spin_lock(&buf->lock);
2772
2773         w = RB_FIRST(&buf->keys, struct keybuf_key, node);
2774
2775         while (w && w->private)
2776                 w = RB_NEXT(w, node);
2777
2778         if (w)
2779                 w->private = ERR_PTR(-EINTR);
2780
2781         spin_unlock(&buf->lock);
2782         return w;
2783 }

Every time when bch_keybuf_next() is called, the red-black tree is
iterated from start until a node doesn't have w->private value. Then
this node's w->private is set by ERR_PTR(-EINTR) and pointer of the
node's holder (struct keybuf_key) is returned back to read_dirty().

In worst case, if there are 500 nodes in this red-black tree, nodes to
be iterated in each calling of bch_keybuf_next() in read_dirty() will
be: 1, 2, 3, 4, ......, 498, 499, 500. The total nodes iteration times
are 125250. If all the nodes can be fetched from read_dirty() once, the
iteration times are only 500, it is about 0.3% of the original number.

This patch adds new member dump_keys[KEYBUF_NR], it is used to store
one-time fetched dirty keys from the red-black trees. All the keys in
dump_keys[] array is in their original iterated order. A new function
bch_keybuf_dump() is used to fetch all ndoes from the red-black tree and
store the selected keys in dump_keys[]. In side read_dirty(), this new
function is called before entering while-loop, and bch_keybuf_next() is
not used anymore. Now the red-black tree only be iterated once, also the
spinlock buf->lock is only acquired once.

For the situation that not all nodes inside dump_keys[] are handled, the
non-handled nodes should be fetched next time when read_dirty() is
called again. So inside the red-black tree, w->private is not set by
ERR_PTR(-EINTR) when the node is fetched into dump_keys[]. It is set in
write_dirty_finish(), that means this node is marked as handled when the
dirty data of the key is written backed to backing device. This is a
change should be noticed.

Inside read_dirty() after closure_sync() returned, it means all write-
back bios are completed, then patch will check whether all fetched nodes
are written back. Because items in dump_keys[] array are exactly equal
to nodes in the red-black tree, if all the keys in dump_keys[] are
handled, the red-black tree is reset directly by array_allocator_init().
Only when unexpected condition happens and there are some items inside
dump_keys[] array not handled, bch_keybuf_del() is called to delete the
written dirty keys one by one from the red-black tree.

In practice, testing shows most of the time all items in dump_keys[] are
all handled promptly, the red-black tree is directly reset.

Answers to some potential concerns:
- Memory barrier issue for dc->writeback_keys.hangled.
    This atomic_t value is increased inside semaphore dc->in_flight in
  write_dirty_finish(). Calling up(&dc->in_flight) has implicit memory
  barrier inside, no need to redundant explicit memory barrier call. 
- Concurrent access to the red-black tree in dc->writeback_keys.freelist
    Access to dc->writeback_keys.freelist is guarded by
  dc->writeback_keys.lock, it is safe for concurrent access on it.
  Indeed before returning from read_dirty(), no one else will access
  this red-black tree (no matter adding new nodes or setting w->private)
  it is also safe to check w->private inside read_dirty() without
  holding dc->writeback_keys.lock after closure_sync() returned. 

The idea was inspired by code review comments of previous patches from
Zhou Jifeng.


Signed-off-by: Coly Li <colyli@fnnas.com> 
Cc: Zhou Jifeng <zhoujifeng@kylinos.com.cn>
---
 drivers/md/bcache/bcache.h    |  2 ++
 drivers/md/bcache/btree.c     | 28 ++++++++++++++++++++++
 drivers/md/bcache/btree.h     |  2 ++
 drivers/md/bcache/writeback.c | 45 +++++++++++++++++++++++++----------
 4 files changed, 65 insertions(+), 12 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 8ccacba85547..06880e2d5b1d 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -240,11 +240,13 @@ struct keybuf {
 	 */
 	struct bkey		start;
 	struct bkey		end;
+	atomic_t		handled;
 
 	struct rb_root		keys;
 
 #define KEYBUF_NR		500
 	DECLARE_ARRAY_ALLOCATOR(struct keybuf_key, freelist, KEYBUF_NR);
+	struct keybuf_key	*dump_keys[KEYBUF_NR];
 };
 
 struct bcache_device {
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index bdb90833bff0..e107d0f05ee4 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -2763,6 +2763,34 @@ bool bch_keybuf_check_overlapping(struct keybuf *buf, struct bkey *start,
 	return ret;
 }
 
+int bch_keybuf_dump(struct keybuf *buf, struct keybuf_key *dump_list[],
+		    int dump_list_len)
+{
+	struct keybuf_key *w;
+	int i = 0;
+
+	memset(dump_list, 0, dump_list_len * sizeof(struct keybuf_key *));
+
+	spin_lock(&buf->lock);
+
+	w = RB_FIRST(&buf->keys, struct keybuf_key, node);
+
+	while (w && i < dump_list_len) {
+		if (w->private) {
+			w = RB_NEXT(w, node);
+			continue;
+		}
+
+		dump_list[i++] = w;
+		w->private = ERR_PTR(-EINTR);
+		w = RB_NEXT(w, node);
+	}
+
+	spin_unlock(&buf->lock);
+
+	return i;
+}
+
 struct keybuf_key *bch_keybuf_next(struct keybuf *buf)
 {
 	struct keybuf_key *w;
diff --git a/drivers/md/bcache/btree.h b/drivers/md/bcache/btree.h
index 45d64b54115a..65d81a7b5ac6 100644
--- a/drivers/md/bcache/btree.h
+++ b/drivers/md/bcache/btree.h
@@ -413,5 +413,7 @@ struct keybuf_key *bch_keybuf_next_rescan(struct cache_set *c,
 					  struct keybuf *buf,
 					  struct bkey *end,
 					  keybuf_pred_fn *pred);
+int bch_keybuf_dump(struct keybuf *buf, struct keybuf_key *dump_list[],
+		   int dump_list_len);
 void bch_update_bucket_in_use(struct cache_set *c, struct gc_stat *stats);
 #endif
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 59cd0c3f8ce9..e6c548e83ff1 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -381,7 +381,8 @@ static CLOSURE_CALLBACK(write_dirty_finish)
 				: &dc->disk.c->writeback_keys_done);
 	}
 
-	bch_keybuf_del(&dc->writeback_keys, w);
+	w->private = ERR_PTR(-EINTR);
+	atomic_inc(&dc->writeback_keys.handled);
 	up(&dc->in_flight);
 
 	closure_return_with_destructor(cl, dirty_io_destructor);
@@ -474,8 +475,10 @@ static CLOSURE_CALLBACK(read_dirty_submit)
 static void read_dirty(struct cached_dev *dc)
 {
 	unsigned int delay = 0;
-	struct keybuf_key *next, *keys[MAX_WRITEBACKS_IN_PASS], *w;
+	struct keybuf_key *keys[MAX_WRITEBACKS_IN_PASS], *w;
+	struct keybuf_key **dump_keys;
 	size_t size;
+	int checked, dump_nr;
 	int nk, i;
 	struct dirty_io *io;
 	struct closure cl;
@@ -489,17 +492,22 @@ static void read_dirty(struct cached_dev *dc)
 	 * XXX: if we error, background writeback just spins. Should use some
 	 * mempools.
 	 */
-
-	next = bch_keybuf_next(&dc->writeback_keys);
+	dump_nr = bch_keybuf_dump(&dc->writeback_keys,
+			dc->writeback_keys.dump_keys,
+			ARRAY_SIZE(dc->writeback_keys.dump_keys));
+	dump_keys = dc->writeback_keys.dump_keys;
+	atomic_set(&dc->writeback_keys.handled, 0);
+	checked = 0;
 
 	while (!kthread_should_stop() &&
 	       !test_bit(CACHE_SET_IO_DISABLE, &dc->disk.c->flags) &&
-	       next) {
+	       (checked < dump_nr)) {
 		size = 0;
 		nk = 0;
 
 		do {
-			BUG_ON(ptr_stale(dc->disk.c, &next->key, 0));
+			w = dump_keys[checked];
+			BUG_ON(ptr_stale(dc->disk.c, &w->key, 0));
 
 			/*
 			 * Don't combine too many operations, even if they
@@ -525,12 +533,12 @@ static void read_dirty(struct cached_dev *dc)
 			 * command queueing.
 			 */
 			if ((nk != 0) && bkey_cmp(&keys[nk-1]->key,
-						&START_KEY(&next->key)))
+						&START_KEY(&w->key)))
 				break;
 
-			size += KEY_SIZE(&next->key);
-			keys[nk++] = next;
-		} while ((next = bch_keybuf_next(&dc->writeback_keys)));
+			size += KEY_SIZE(&w->key);
+			keys[nk++] = w;
+		} while (++checked < dump_nr);
 
 		/* Now we have gathered a set of 1..5 keys to write back. */
 		for (i = 0; i < nk; i++) {
@@ -581,7 +589,6 @@ static void read_dirty(struct cached_dev *dc)
 err_free:
 		kfree(w->private);
 err:
-		bch_keybuf_del(&dc->writeback_keys, w);
 	}
 
 	/*
@@ -589,6 +596,21 @@ static void read_dirty(struct cached_dev *dc)
 	 * freed) before refilling again
 	 */
 	closure_sync(&cl);
+
+	if (atomic_read(&dc->writeback_keys.handled) == dump_nr) {
+		spin_lock(&dc->writeback_keys.lock);
+		dc->writeback_keys.keys = RB_ROOT;
+		array_allocator_init(&dc->writeback_keys.freelist);
+		spin_unlock(&dc->writeback_keys.lock);
+	} else {
+		for (i = 0; i < dump_nr; i++) {
+			w = dump_keys[i];
+			if (!w->private)
+				continue;
+			bch_keybuf_del(&dc->writeback_keys, w);
+		}
+	}
+	atomic_set(&dc->writeback_keys.handled, 0);
 }
 
 /* Scan for dirty data */
@@ -820,7 +842,6 @@ static int bch_writeback_thread(void *arg)
 
 		if (searched_full_index) {
 			unsigned int delay = dc->writeback_delay * HZ;
-
 			while (delay &&
 			       !kthread_should_stop() &&
 			       !test_bit(CACHE_SET_IO_DISABLE, &c->flags) &&
-- 
2.39.5


