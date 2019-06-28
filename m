Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 464EE599F6
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Jun 2019 14:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfF1MCi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 28 Jun 2019 08:02:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:55506 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727015AbfF1MCi (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 28 Jun 2019 08:02:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BBCCEB62D;
        Fri, 28 Jun 2019 12:02:36 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 36/37] bcache: performance improvement for btree_flush_write()
Date:   Fri, 28 Jun 2019 19:59:59 +0800
Message-Id: <20190628120000.40753-37-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190628120000.40753-1-colyli@suse.de>
References: <20190628120000.40753-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch improves performance for btree_flush_write() in following
ways,
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
  BTREE_FLUSH_NR btree nodes to flush. Iterate all btree nodes from
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
 drivers/md/bcache/journal.c | 85 +++++++++++++++++++++++++++++++++------------
 drivers/md/bcache/journal.h |  4 +++
 2 files changed, 67 insertions(+), 22 deletions(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index a1e3e1fcea6e..8bcd8f1bf8cb 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -419,47 +419,87 @@ int bch_journal_replay(struct cache_set *s, struct list_head *list)
 
 static void btree_flush_write(struct cache_set *c)
 {
-	/*
-	 * Try to find the btree node with that references the oldest journal
-	 * entry, best is our current candidate and is locked if non NULL:
-	 */
-	struct btree *b, *best;
-	unsigned int i;
+	struct btree *b, *t, *btree_nodes[BTREE_FLUSH_NR];
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
+	memset(btree_nodes, 0, sizeof(btree_nodes));
+	n = 0;
 
 	mutex_lock(&c->bucket_lock);
-	for_each_cached_btree(b, c, i)
-		if (btree_current_write(b)->journal) {
-			if (!best)
-				best = b;
-			else if (journal_pin_cmp(c,
-					btree_current_write(best)->journal,
-					btree_current_write(b)->journal)) {
-				best = b;
-			}
+	list_for_each_entry_safe_reverse(b, t, &c->btree_cache, list) {
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
 		}
 
-	b = best;
-	if (b)
 		set_btree_node_journal_flush(b);
+
+		mutex_unlock(&b->write_lock);
+
+		btree_nodes[n++] = b;
+		if (n == BTREE_FLUSH_NR)
+			break;
+	}
 	mutex_unlock(&c->bucket_lock);
 
-	if (b) {
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
+		}
+
 		mutex_lock(&b->write_lock);
 		if (!btree_current_write(b)->journal) {
 			clear_bit(BTREE_NODE_journal_flush, &b->flags);
 			mutex_unlock(&b->write_lock);
-			/* We raced */
-			goto retry;
+			pr_debug("bnode %p: written by others", b);
+			continue;
+		}
+
+		if (!btree_node_dirty(b)) {
+			clear_bit(BTREE_NODE_journal_flush, &b->flags);
+			mutex_unlock(&b->write_lock);
+			pr_debug("bnode %p: dirty bit cleaned by others", b);
+			continue;
 		}
 
 		__bch_btree_node_write(b, NULL);
 		clear_bit(BTREE_NODE_journal_flush, &b->flags);
 		mutex_unlock(&b->write_lock);
 	}
+
+	spin_lock(&c->journal.flush_write_lock);
+	c->journal.btree_flushing = false;
+	spin_unlock(&c->journal.flush_write_lock);
 }
 
 #define last_seq(j)	((j)->seq - fifo_used(&(j)->pin) + 1)
@@ -881,6 +921,7 @@ int bch_journal_alloc(struct cache_set *c)
 	struct journal *j = &c->journal;
 
 	spin_lock_init(&j->lock);
+	spin_lock_init(&j->flush_write_lock);
 	INIT_DELAYED_WORK(&j->work, journal_write_work);
 
 	c->journal_delay_ms = 100;
diff --git a/drivers/md/bcache/journal.h b/drivers/md/bcache/journal.h
index 66f0facff84b..f2ea34d5f431 100644
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
 
+#define BTREE_FLUSH_NR	8
+
 #define journal_pin_cmp(c, l, r)				\
 	(fifo_idx(&(c)->journal.pin, (l)) > fifo_idx(&(c)->journal.pin, (r)))
 
-- 
2.16.4

