Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB860357B3
	for <lists+linux-bcache@lfdr.de>; Wed,  5 Jun 2019 09:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfFEH1r (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 5 Jun 2019 03:27:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:41200 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726477AbfFEH1r (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Jun 2019 03:27:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 20EE9AE08;
        Wed,  5 Jun 2019 07:27:45 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 5/6] bcache: fix race in btree_flush_write()
Date:   Wed,  5 Jun 2019 15:27:17 +0800
Message-Id: <20190605072718.121379-6-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190605072718.121379-1-colyli@suse.de>
References: <20190605072718.121379-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

There is a race between mca_reap(), btree_node_free() and journal code
btree_flush_write(), which results very rare and strange deadlock or
panic and are very hard to reproduce.

Let me explain how the race happens. In btree_flush_write() one btree
node with oldest journal pin is selected, then it is flushed to cache
device, the select-and-flush is a two steps operation. Between these two
steps, there are something may happen inside the race window,
- The selected btree node was reaped by mca_reap() and allocated to
  other requesters for other btree node.
- The slected btree node was selected, flushed and released by mca
  shrink callback bch_mca_scan().
When btree_flush_write() tries to flush the selected btree node, firstly
b->write_lock is held by mutex_lock(). If the race happens and the
memory of selected btree node is allocated to other btree node, if that
btree node's write_lock is held already, a deadlock very probably
happens here. A worse case is the memory of the selected btree node is
released, then all references to this btree node (e.g. b->write_lock)
will trigger NULL pointer deference panic.

This race was introduced in commit cafe56359144 ("bcache: A block layer
cache"), and enlarged by commit c4dc2497d50d ("bcache: fix high CPU
occupancy during journal"), which selected 128 btree nodes and flushed
them one-by-one in a quite long time period.

Such race is not easy to reproduce before. On a Lenovo SR650 server with
48 Xeon cores, and configure 1 NVMe SSD as cache device, a MD raid0
device assembled by 3 NVMe SSDs as backing device, this race can be
observed around every 10,000 times btree_flush_write() gets called. Both
deadlock and kernel panic all happened as aftermath of the race.

The idea of the fix is to add a btree flag BTREE_NODE_journal_flush. It
is set when selecting btree nodes, and cleared after btree nodes
flushed. Then when mca_reap() selects a btree node with this bit set,
this btree node will be skipped. Since mca_reap() only reaps btree node
without BTREE_NODE_journal_flush flag, such race is avoided.

Once corner case should be noticed, that is btree_node_free(). It might
be called in some error handling code path. For example the following
code piece from btree_split(),
	2149 err_free2:
	2150         bkey_put(b->c, &n2->key);
	2151         btree_node_free(n2);
	2152         rw_unlock(true, n2);
	2153 err_free1:
	2154         bkey_put(b->c, &n1->key);
	2155         btree_node_free(n1);
	2156         rw_unlock(true, n1);
At line 2151 and 2155, the btree node n2 and n1 are released without
mac_reap(), so BTREE_NODE_journal_flush also needs to be checked here.
If btree_node_free() is called directly in such error handling path,
and the selected btree node has BTREE_NODE_journal_flush bit set, just
wait for 1 jiffy and retry again. In this case this btree node won't
be skipped, just retry until the BTREE_NODE_journal_flush bit cleared,
and free the btree node memory.

Wait for 1 jiffy inside btree_node_free() does not hurt too much
performance here, the reasons are,
- Error handling code path is not frequently executed, and the race
  inside this cold path should be very rare. If the very rare race
  happens in the cold code path, waiting 1 jiffy should be acceptible.
- If bree_node_free() is called inside mca_reap(), it means the bit
  BTREE_NODE_journal_flush is checked already, no wait will happen here.

Beside the above fix, the way to select flushing btree nodes is also
changed in this patch. Let me explain what changes in this patch.

- Use another spinlock journal.flush_write_lock to replace the very
  hot journal.lock. We don't have to use journal.lock here, selecting
  candidate btree nodes takes a lot of time, hold journal.lock here will
  block other jouranling threads and drop the overall I/O performance.
- Only select flushing btree node from c->btree_cache list. When the
  machine has a large system memory, mca cache may have a huge number of
  cached btree nodes. Iterating all the cached nodes will take a lot
  of CPU time, and most of the nodes on c->btree_cache_freeable and
  c->btree_cache_freed lists are cleared and have need to flush. So only
  travel mca list c->btree_cache to select flushing btree node should be
  enough for most of the cases.
- Don't iterate whole c->btree_cache list, only reversely select first
  BTREE_FLUSH_NR (32) btree nodes to flush. Iterate all btree nodes from
  c->btree_cache and select the oldest journal pin btree nodes consumes
  huge number of CPU cycles if the list is huge (push and pop a node
  into/out of a heap is expensive). The last several dirty btree nodes
  on the tail of c->btree_cache list are earlest allocated and cached
  btree nodes, they are relative to the oldest journal pin btree nodes.
  Therefore only flushing BTREE_FLUSH_NR btree nodes from tail of
  c->btree_cache probably includes the oldest journal pin btree nodes.

In my testing, the above change decreases 50%+ CPU consumption when
journal space is full. Some times IOPS drops to 0 for 5-8 seconds,
comparing blocking I/O for 120+ seconds in previous code, this is much
better. Maybe there is room to improve in future, but at this momment
the fix looks fine and performs well in my testing.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/btree.c   | 15 +++++++-
 drivers/md/bcache/btree.h   |  2 +
 drivers/md/bcache/journal.c | 93 ++++++++++++++++++++++++++++++++++-----------
 drivers/md/bcache/journal.h |  4 ++
 4 files changed, 90 insertions(+), 24 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index cf38a1b031fa..c0dd8fde37af 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -660,6 +660,13 @@ static int mca_reap(struct btree *b, unsigned int min_order, bool flush)
 	}
 
 	mutex_lock(&b->write_lock);
+	/* don't reap btree node handling in btree_flush_write() */
+	if (btree_node_journal_flush(b)) {
+		pr_debug("bnode %p is flushing by journal, ignore", b);
+		mutex_unlock(&b->write_lock);
+		goto out_unlock;
+	}
+
 	if (btree_node_dirty(b))
 		__bch_btree_node_write(b, &cl);
 	mutex_unlock(&b->write_lock);
@@ -1071,8 +1078,14 @@ static void btree_node_free(struct btree *b)
 
 	BUG_ON(b == b->c->root);
 
+retry:
 	mutex_lock(&b->write_lock);
-
+	if (btree_node_journal_flush(b)) {
+		mutex_unlock(&b->write_lock);
+		pr_debug("bnode %p journal_flush set, retry", b);
+		schedule_timeout_interruptible(1);
+		goto retry;
+	}
 	if (btree_node_dirty(b))
 		btree_complete_write(b, btree_current_write(b));
 	clear_bit(BTREE_NODE_dirty, &b->flags);
diff --git a/drivers/md/bcache/btree.h b/drivers/md/bcache/btree.h
index d1c72ef64edf..76cfd121a486 100644
--- a/drivers/md/bcache/btree.h
+++ b/drivers/md/bcache/btree.h
@@ -158,11 +158,13 @@ enum btree_flags {
 	BTREE_NODE_io_error,
 	BTREE_NODE_dirty,
 	BTREE_NODE_write_idx,
+	BTREE_NODE_journal_flush,
 };
 
 BTREE_FLAG(io_error);
 BTREE_FLAG(dirty);
 BTREE_FLAG(write_idx);
+BTREE_FLAG(journal_flush);
 
 static inline struct btree_write *btree_current_write(struct btree *b)
 {
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 69586ded980c..4a7cc1bf8e3a 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -419,41 +419,87 @@ int bch_journal_replay(struct cache_set *s, struct list_head *list)
 
 static void btree_flush_write(struct cache_set *c)
 {
-	/*
-	 * Try to find the btree node with that references the oldest journal
-	 * entry, best is our current candidate and is locked if non NULL:
-	 */
-	struct btree *b, *best;
-	unsigned int i;
+	struct btree *b, *btree_nodes[BTREE_FLUSH_NR];
+	unsigned int i, n;
+
+	if (c->journal.btree_flushing)
+		return;
+
+	spin_lock(&c->journal.flush_write_lock);
+	if (c->journal.btree_flushing) {
+		spin_unlock(&c->journal.flush_write_lock);
+		return;
+	}
+	c->journal.btree_flushing = true;
+	spin_unlock(&c->journal.flush_write_lock);
 
 	atomic_long_inc(&c->flush_write);
-retry:
-	best = NULL;
-
-	for_each_cached_btree(b, c, i)
-		if (btree_current_write(b)->journal) {
-			if (!best)
-				best = b;
-			else if (journal_pin_cmp(c,
-					btree_current_write(best)->journal,
-					btree_current_write(b)->journal)) {
-				best = b;
-			}
+	memset(btree_nodes, 0, sizeof(btree_nodes));
+	n = 0;
+
+	mutex_lock(&c->bucket_lock);
+	list_for_each_entry_reverse(b, &c->btree_cache, list) {
+		if (btree_node_journal_flush(b))
+			pr_err("BUG: flush_write bit should not be set here!");
+
+		mutex_lock(&b->write_lock);
+
+		if (!btree_node_dirty(b)) {
+			mutex_unlock(&b->write_lock);
+			continue;
+		}
+
+		if (!btree_current_write(b)->journal) {
+			mutex_unlock(&b->write_lock);
+			continue;
+		}
+
+		set_btree_node_journal_flush(b);
+
+		mutex_unlock(&b->write_lock);
+
+		btree_nodes[n++] = b;
+		if (n == BTREE_FLUSH_NR)
+			break;
+	}
+	mutex_unlock(&c->bucket_lock);
+
+	for (i = 0; i < n; i++) {
+		b = btree_nodes[i];
+		if (!b) {
+			pr_err("BUG: btree_nodes[%d] is NULL", i);
+			continue;
+		}
+
+		/* safe to check without holding b->write_lock */
+		if (!btree_node_journal_flush(b)) {
+			pr_err("BUG: bnode %p: journal_flush bit cleaned", b);
+			continue;
 		}
 
-	b = best;
-	if (b) {
 		mutex_lock(&b->write_lock);
 		if (!btree_current_write(b)->journal) {
 			mutex_unlock(&b->write_lock);
-			/* We raced */
-			atomic_long_inc(&c->retry_flush_write);
-			goto retry;
+			pr_debug("bnode %p: written by others", b);
+			clear_bit(BTREE_NODE_journal_flush, &b->flags);
+			continue;
+		}
+
+		if (!btree_node_dirty(b)) {
+			pr_debug("bnode %p: dirty bit cleaned by others", b);
+			clear_bit(BTREE_NODE_journal_flush, &b->flags);
+			mutex_unlock(&b->write_lock);
+			continue;
 		}
 
 		__bch_btree_node_write(b, NULL);
+		clear_bit(BTREE_NODE_journal_flush, &b->flags);
 		mutex_unlock(&b->write_lock);
 	}
+
+	spin_lock(&c->journal.flush_write_lock);
+	c->journal.btree_flushing = false;
+	spin_unlock(&c->journal.flush_write_lock);
 }
 
 #define last_seq(j)	((j)->seq - fifo_used(&(j)->pin) + 1)
@@ -875,6 +921,7 @@ int bch_journal_alloc(struct cache_set *c)
 	struct journal *j = &c->journal;
 
 	spin_lock_init(&j->lock);
+	spin_lock_init(&j->flush_write_lock);
 	INIT_DELAYED_WORK(&j->work, journal_write_work);
 
 	c->journal_delay_ms = 100;
diff --git a/drivers/md/bcache/journal.h b/drivers/md/bcache/journal.h
index 66f0facff84b..aeed791f05e7 100644
--- a/drivers/md/bcache/journal.h
+++ b/drivers/md/bcache/journal.h
@@ -103,6 +103,8 @@ struct journal_write {
 /* Embedded in struct cache_set */
 struct journal {
 	spinlock_t		lock;
+	spinlock_t		flush_write_lock;
+	bool			btree_flushing;
 	/* used when waiting because the journal was full */
 	struct closure_waitlist	wait;
 	struct closure		io;
@@ -154,6 +156,8 @@ struct journal_device {
 	struct bio_vec		bv[8];
 };
 
+#define BTREE_FLUSH_NR	32
+
 #define journal_pin_cmp(c, l, r)				\
 	(fifo_idx(&(c)->journal.pin, (l)) > fifo_idx(&(c)->journal.pin, (r)))
 
-- 
2.16.4

