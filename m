Return-Path: <linux-bcache+bounces-1204-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 490B6B56A90
	for <lists+linux-bcache@lfdr.de>; Sun, 14 Sep 2025 18:27:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E886317B290
	for <lists+linux-bcache@lfdr.de>; Sun, 14 Sep 2025 16:27:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16BA62D9EF3;
	Sun, 14 Sep 2025 16:27:07 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2279EEB3
	for <linux-bcache@vger.kernel.org>; Sun, 14 Sep 2025 16:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757867227; cv=none; b=UE0JsqU/CuOHn7UUV5V2Tr4LN6kvcgQnj4eqqZEvSuJ24fB9h6YvpXBKkuFOCL1v2QRHJfKAKjCOS66qQFlVQhAQAJA8vohM0Ffu6wnFnM/hNZrf3mkYOmTJGOA7k9onFU0kMReRaFtlElpe8MOz670ZOG1wKEpel09MsN/n0Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757867227; c=relaxed/simple;
	bh=QHemlwxIxEz1rLBGs9UyWemPw/PptUgKPa0YEv03+FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dmc2QLy50uc9CtENk+KflvrHyqDuilaitx74OaL8AqGY4NC5gG2Nyq3cOyoYqOkV5zqqVJKTCFvKDUtfPyJWQp1yJy+UQj+aTz264+D5sYr9URvQWi+S8ixxK9nL0HMAhIf6eYHLRJvZ0kb2Hpf/bsKh/8kEyKWe/pBDUJQyfMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E774AC4CEF0;
	Sun, 14 Sep 2025 16:27:04 +0000 (UTC)
From: colyli@fnnas.com
To: linux-bcache@vger.kernel.org
Cc: Coly Li <colyli@fnnas.com>,
	Robert Pang <robertpang@google.com>,
	Mingzhe Zou <mingzhe.zou@easystack.cn>
Subject: [PATCH v2] bcache: reduce gc latency by processing less nodes and sleep less time
Date: Mon, 15 Sep 2025 00:26:55 +0800
Message-ID: <20250914162655.114689-1-colyli@fnnas.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Coly Li <colyli@fnnas.com>

When bcache device is busy for high I/O loads, there are two methods to
reduce the garbage collection latency,
- Process less nodes in eac loop of incremental garbage collection in
  btree_gc_recurse().
- Sleep less time between two full garbage collection in
  bch_btree_gc().

This patch introduces to hleper routines to provide different garbage
collection nodes number and sleep intervel time.
- btree_gc_min_nodes()
  If there is no front end I/O, return 128 nodes to process in each
  incremental loop, otherwise only 10 nodes are returned. Then front I/O
  is able to access the btree earlier.
- btree_gc_sleep_ms()
  If there is no synchronized wait for bucket allocation, sleep 100 ms
  between two incremental GC loop. Othersize only sleep 10 ms before
  incremental GC loop. Then a faster GC may provide available buckets
  earlier, to avoid most of bcache working threads from being starved by
  buckets allocation.

The idea is inspired by works from Mingzhe Zou and Robert Pang, but much
simpler and the expected behavior is more predictable.

Signed-off-by: Coly Li <colyli@fnnas.com>
Signed-off-by: Robert Pang <robertpang@google.com>
Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
---
changelog,
v2: Add Robert Pang and Mingzhe Zou as Signed-off-by, they are authors
    of the original patches which inspired me.
v1: original version.

 drivers/md/bcache/alloc.c  |  4 ++++
 drivers/md/bcache/bcache.h |  1 +
 drivers/md/bcache/btree.c  | 47 +++++++++++++++++++-------------------
 3 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 48ce750bf70a..db519e1678c2 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -412,7 +412,11 @@ long bch_bucket_alloc(struct cache *ca, unsigned int reserve, bool wait)
 				TASK_UNINTERRUPTIBLE);
 
 		mutex_unlock(&ca->set->bucket_lock);
+
+		atomic_inc(&ca->set->bucket_wait_cnt);
 		schedule();
+		atomic_dec(&ca->set->bucket_wait_cnt);
+
 		mutex_lock(&ca->set->bucket_lock);
 	} while (!fifo_pop(&ca->free[RESERVE_NONE], r) &&
 		 !fifo_pop(&ca->free[reserve], r));
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 1d33e40d26ea..d43fcccf297c 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -607,6 +607,7 @@ struct cache_set {
 	 */
 	atomic_t		prio_blocked;
 	wait_queue_head_t	bucket_wait;
+	atomic_t		bucket_wait_cnt;
 
 	/*
 	 * For any bio we don't skip we subtract the number of sectors from
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 210b59007d98..f79a229d5728 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -89,8 +89,9 @@
  * Test module load/unload
  */
 
-#define MAX_GC_TIMES		100
-#define MIN_GC_NODES		100
+#define MAX_GC_TIMES_SHIFT	7  /* 128 loops */
+#define GC_NODES_MIN		10
+#define GC_SLEEP_MS_MIN		10
 #define GC_SLEEP_MS		100
 
 #define PTR_DIRTY_BIT		(((uint64_t) 1 << 36))
@@ -1578,29 +1579,28 @@ static unsigned int btree_gc_count_keys(struct btree *b)
 
 static size_t btree_gc_min_nodes(struct cache_set *c)
 {
-	size_t min_nodes;
+	size_t min_nodes = GC_NODES_MIN;
 
-	/*
-	 * Since incremental GC would stop 100ms when front
-	 * side I/O comes, so when there are many btree nodes,
-	 * if GC only processes constant (100) nodes each time,
-	 * GC would last a long time, and the front side I/Os
-	 * would run out of the buckets (since no new bucket
-	 * can be allocated during GC), and be blocked again.
-	 * So GC should not process constant nodes, but varied
-	 * nodes according to the number of btree nodes, which
-	 * realized by dividing GC into constant(100) times,
-	 * so when there are many btree nodes, GC can process
-	 * more nodes each time, otherwise, GC will process less
-	 * nodes each time (but no less than MIN_GC_NODES)
-	 */
-	min_nodes = c->gc_stats.nodes / MAX_GC_TIMES;
-	if (min_nodes < MIN_GC_NODES)
-		min_nodes = MIN_GC_NODES;
+	if (atomic_read(&c->search_inflight) == 0) {
+		size_t n = c->gc_stats.nodes >> MAX_GC_TIMES_SHIFT;
+		if (min_nodes < n)
+			min_nodes = n;
+	}
 
 	return min_nodes;
 }
 
+static uint64_t btree_gc_sleep_ms(struct cache_set *c)
+{
+	uint64_t sleep_ms;
+
+	if (atomic_read(&c->bucket_wait_cnt) > 0)
+		sleep_ms = GC_SLEEP_MS_MIN;
+	else
+		sleep_ms = GC_SLEEP_MS;
+
+	return sleep_ms;
+}
 
 static int btree_gc_recurse(struct btree *b, struct btree_op *op,
 			    struct closure *writes, struct gc_stat *gc)
@@ -1668,8 +1668,7 @@ static int btree_gc_recurse(struct btree *b, struct btree_op *op,
 		memmove(r + 1, r, sizeof(r[0]) * (GC_MERGE_NODES - 1));
 		r->b = NULL;
 
-		if (atomic_read(&b->c->search_inflight) &&
-		    gc->nodes >= gc->nodes_pre + btree_gc_min_nodes(b->c)) {
+		if (gc->nodes >= (gc->nodes_pre + btree_gc_min_nodes(b->c))) {
 			gc->nodes_pre =  gc->nodes;
 			ret = -EAGAIN;
 			break;
@@ -1846,8 +1845,8 @@ static void bch_btree_gc(struct cache_set *c)
 		cond_resched();
 
 		if (ret == -EAGAIN)
-			schedule_timeout_interruptible(msecs_to_jiffies
-						       (GC_SLEEP_MS));
+			schedule_timeout_interruptible(
+				msecs_to_jiffies(btree_gc_sleep_ms(c)));
 		else if (ret)
 			pr_warn("gc failed!\n");
 	} while (ret && !test_bit(CACHE_SET_IO_DISABLE, &c->flags));
-- 
2.39.5


