Return-Path: <linux-bcache+bounces-1250-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F2F8C55D1A
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Nov 2025 06:37:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D88283AF834
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Nov 2025 05:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 338012C0277;
	Thu, 13 Nov 2025 05:36:48 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DD72BCF6C;
	Thu, 13 Nov 2025 05:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763012208; cv=none; b=IBI3hDu0thh2PbP1DtsOTlBqY+Rmq/Z4PH5U9IL393W135J6RNwCTV1sQQTzDtdgD/mGc2fi5pWxXWE00q6LetxNBcHdq4DQoUapmTovz1v26wQhzZ5FN+J96SynFqLWhBUIbRmTyXVKrsGe2JDAWYljDRQVeYjhDZhwhdf1/5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763012208; c=relaxed/simple;
	bh=uHWziFT7rCgEKdY1ynIvc1Fe7vvZDuZ58Oe7s2V435c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOK3fC40Ji9/2xxU5xQnBAAMyeeXW9c7jKxAoiV3VwtDmX497dLdCY7HFBjCAE+hbNjT/pgWTqMyrSR00Rb5KNmyO6MlaOPf9StxPYIPk0EfHV+U4z0bbPzvGXmUmRnwKySOnOVMBrDq0Aknor53glxcpBahF3l4gYZkBoFCy0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29CAC2BC86;
	Thu, 13 Nov 2025 05:36:44 +0000 (UTC)
From: colyli@fnnas.com
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org,
	linux-block@vger.kernel.org,
	Coly Li <colyli@fnnas.com>,
	Robert Pang <robertpang@google.com>,
	Mingzhe Zou <mingzhe.zou@easystack.cn>
Subject: [PATCH 5/9] bcache: reduce gc latency by processing less nodes and sleep less time
Date: Thu, 13 Nov 2025 13:36:26 +0800
Message-ID: <20251113053630.54218-6-colyli@fnnas.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113053630.54218-1-colyli@fnnas.com>
References: <20251113053630.54218-1-colyli@fnnas.com>
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
 drivers/md/bcache/alloc.c  |  4 ++++
 drivers/md/bcache/bcache.h |  1 +
 drivers/md/bcache/btree.c  | 48 +++++++++++++++++++-------------------
 3 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index db3684819e38..7708d92df23e 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -399,7 +399,11 @@ long bch_bucket_alloc(struct cache *ca, unsigned int reserve, bool wait)
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
index b8bd6d4a4298..8ccacba85547 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -604,6 +604,7 @@ struct cache_set {
 	 */
 	atomic_t		prio_blocked;
 	wait_queue_head_t	bucket_wait;
+	atomic_t		bucket_wait_cnt;
 
 	/*
 	 * For any bio we don't skip we subtract the number of sectors from
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 210b59007d98..5d922d301ab6 100644
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
@@ -1578,29 +1579,29 @@ static unsigned int btree_gc_count_keys(struct btree *b)
 
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
+
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
@@ -1668,8 +1669,7 @@ static int btree_gc_recurse(struct btree *b, struct btree_op *op,
 		memmove(r + 1, r, sizeof(r[0]) * (GC_MERGE_NODES - 1));
 		r->b = NULL;
 
-		if (atomic_read(&b->c->search_inflight) &&
-		    gc->nodes >= gc->nodes_pre + btree_gc_min_nodes(b->c)) {
+		if (gc->nodes >= (gc->nodes_pre + btree_gc_min_nodes(b->c))) {
 			gc->nodes_pre =  gc->nodes;
 			ret = -EAGAIN;
 			break;
@@ -1846,8 +1846,8 @@ static void bch_btree_gc(struct cache_set *c)
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
2.47.3


