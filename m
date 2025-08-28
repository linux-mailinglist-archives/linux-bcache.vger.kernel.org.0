Return-Path: <linux-bcache+bounces-1191-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0347B3A5EF
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Aug 2025 18:17:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5350161B6F
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Aug 2025 16:16:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27B093203B9;
	Thu, 28 Aug 2025 16:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bg7eZ72h"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04905212567
	for <linux-bcache@vger.kernel.org>; Thu, 28 Aug 2025 16:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756397797; cv=none; b=SgF+1Zx4tjYYsRFORnqkC12G3/Otr4ENG15FYKzQCyz6lGtO07Akly7kSiY0NwPp1lhTBQRgyeYiZ7syYtg6W9US2vEUW+RoKvcQi1BN84/Gy7q4RY70xqv4/Qb2CRLM4rjy5G5g7fTq2aWERXf5W3nJbIUQVgxNnAjuBVGB1MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756397797; c=relaxed/simple;
	bh=a/Scw0MupeEhJrlREpJGNFG+Alw4Ari6AkHjzc6xlBY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ugK42ud5VHw0R3AvAMgmQ77vy5pVEINQidxzkeSxa4N05aUNxYNisTnrZlOj0HHGOjaYQg+w4Hzc/5lmODskKWm1Z2dCw9tpwOhzq1jSPI7bx+8qZk5B+PKrm5uXSnOIeQTwgMBgI2SekejqaNCRNc8A21IqTNeFlCgs0L7Pu88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bg7eZ72h; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633C6C4CEED;
	Thu, 28 Aug 2025 16:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756397796;
	bh=a/Scw0MupeEhJrlREpJGNFG+Alw4Ari6AkHjzc6xlBY=;
	h=From:To:Cc:Subject:Date:From;
	b=bg7eZ72he68TyNqtqsaChocD/XR/efMOaEYqMq/24V1Slmpn0N1tyO06NnP5NBFWc
	 C0tOa0TvdgbvyrrYQRkeFTnbrl9UhRLSHMRDSWIEqEqbsnz4k8C0Ix+e4fd96Q21j+
	 G9nqt7vUdFQqKFR1UsDWAvj7I1qfdP1oQm2Fxm+N7mD6Zy+7Cs0DckK/izU2jPD2Gp
	 2ZG6aJ6dUyFC3qtuk3D7c16VqhqxpBoUCjTVWUG9x5mU5shcclZZwDoxcHKqRH7DNk
	 iW9k+PE4nVau+6IbKVeZEFhyTybfddH4tNoRfXKLkHcNJMvtaGbIl2OpZnjYB8HTSp
	 uuC4QoCra8nTQ==
From: colyli@kernel.org
To: linux-bcache@vger.kernel.org
Cc: Coly Li <colyli@suse.de>,
	Coly Li <colyli@fnnas.com>,
	Robert Pang <robertpang@google.com>,
	Mingzhe Zou <mingzhe.zou@easystack.cn>
Subject: [RFC PATCH] bcache: reduce gc latency by processing less nodes and sleep less time
Date: Fri, 29 Aug 2025 00:16:31 +0800
Message-ID: <20250828161631.33480-1-colyli@kernel.org>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Coly Li <colyli@suse.de>

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
Cc: Robert Pang <robertpang@google.com>
Cc: Mingzhe Zou <mingzhe.zou@easystack.cn>
---
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
2.47.2


