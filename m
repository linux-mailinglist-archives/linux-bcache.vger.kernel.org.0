Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 888AD108285
	for <lists+linux-bcache@lfdr.de>; Sun, 24 Nov 2019 09:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbfKXI3U (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 24 Nov 2019 03:29:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:56260 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725913AbfKXI3U (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 24 Nov 2019 03:29:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2D5EEAD6C
        for <linux-bcache@vger.kernel.org>; Sun, 24 Nov 2019 08:29:18 +0000 (UTC)
From:   colyli@suse.de
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>
Subject: [RFC PATCH] bcache: avoid unnecessary btree nodes flushing in btree_flush_write()
Date:   Sun, 24 Nov 2019 16:29:06 +0800
Message-Id: <20191124082906.29223-1-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

Commit 91be66e1318f ("bcache: performance improvement for
btree_flush_write()") was an effort to flushing btree node with oldest
btree node faster in following methods,
- Only iterate dirty btree nodes in c->btree_cache, avoid scanning a lot
  of clean btree nodes.
- Take c->btree_cache as a LRU-like list, aggressively flushing all
  dirty nodes from tail of c->btree_cache util the btree node with
  oldest journal entry is flushed. This is to reduce the time of holding
  c->bucket_lock.

Guoju Fang and Shuang Li reported that they observe unexptected extra
write I/Os on cache device after applying Commit 91be66e1318f. Guoju
Fang provideed more detailed diagnose information that the aggressive
btree nodes flushing may cause 10x more btree nodes to flush in his
workload. He points out when system memory is large enough to hold all
btree nodes in memory, c->btree_cache is not a LRU-like list any more.
Then the btree node with oldest journal entry is very probably not-
close to the tail of c->btree_cache list. In such situation much more
dirty btree nodes will be aggressively flushed before the target node
is flushed. When slow SATA SSD is used as cache device, such over-
aggressive flushing behavior will cause performance regression.

This patch tries to fix the unnecessary btree nodes flushhing by the
following methods,
- Get oldest journal entry pointer from c->journal.pin.front.
- Iterate c->btree_cache list from tail, to chck whether journal
  entry of the btree node (a.k.a btree_current_write(b)->journal) is
  equal to the address of previously fetched oldest journal entry
  pointer. If matches, quit the list iteration and flush this btree
  node.
- Still try to do aggressive btree node flush but more restrainedly.
  Before encounter the btree node with oldest journal entry, if a
  dirty btree node's journal entry is very close to the oldest journal
  entry (index distance < BTREE_FLUSH_NR), also flush it.

Now the extra unnecessary btree nodes flushing can be avoided, and
the best btree nodes can be found in O(n) time relative to how large
c->btree_cache list is.

Reported-by: Guoju Fang <fangguoju@gmail.com>
Reported-by: Shuang Li <psymon@bonuscloud.io>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/journal.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index be2a2a201603..43925f7afc3f 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -417,10 +417,15 @@ int bch_journal_replay(struct cache_set *s, struct list_head *list)
 
 /* Journalling */
 
+#define nr_to_fifo_front(front_p, p, mask)	(((p) - (front_p)) & (mask))
+
 static void btree_flush_write(struct cache_set *c)
 {
 	struct btree *b, *t, *btree_nodes[BTREE_FLUSH_NR];
 	unsigned int i, n;
+	unsigned int oldest_found;
+	atomic_t *fifo_front_p;
+	size_t mask;
 
 	if (c->journal.btree_flushing)
 		return;
@@ -435,7 +440,14 @@ static void btree_flush_write(struct cache_set *c)
 
 	atomic_long_inc(&c->flush_write);
 	memset(btree_nodes, 0, sizeof(btree_nodes));
+
+	spin_lock(&c->journal.lock);
+	fifo_front_p = &fifo_front(&c->journal.pin);
+	spin_unlock(&c->journal.lock);
+	mask = c->journal.pin.mask;
+
 	n = 0;
+	oldest_found = 0;
 
 	mutex_lock(&c->bucket_lock);
 	list_for_each_entry_safe_reverse(b, t, &c->btree_cache, list) {
@@ -454,16 +466,45 @@ static void btree_flush_write(struct cache_set *c)
 			continue;
 		}
 
+		/*
+		 * To avoid c->journal.lock inside the loop, fifo_front_p and
+		 * mask are fetched before the loop, and the distance to fifo
+		 * front is calculated by nr_to_fifo_front().
+		 * NOTE: the real journal.pin.front might be increased, it is
+		 * possible that journal.pin.front goes beyond (fifo_front_p +
+		 * BTREE_FLUSH_NR) and nothing selected in the loop. But it
+		 * doesn't hurt because the oldest journal entry is reclaimed
+		 * already.
+		 */
+		if (nr_to_fifo_front(btree_current_write(b)->journal,
+				     fifo_front_p,
+				     mask) >=
+		    BTREE_FLUSH_NR) {
+			mutex_unlock(&b->write_lock);
+			continue;
+		}
+
+		/* For debug purpose in RFC patch */
+		if (btree_current_write(b)->journal == fifo_front_p) {
+			oldest_found = 1;
+		}
+
 		set_btree_node_journal_flush(b);
 
 		mutex_unlock(&b->write_lock);
 
 		btree_nodes[n++] = b;
-		if (n == BTREE_FLUSH_NR)
+		if (n == BTREE_FLUSH_NR || oldest_found)
 			break;
 	}
 	mutex_unlock(&c->bucket_lock);
 
+	/* For debug purpose in RFC patch */
+	if (oldest_found)
+		pr_info_ratelimited("oldest journal entry found, %d bnode to flush.", n);
+	else
+		pr_info_ratelimited"oldest journal entry not found, %d bnode to flush.", n);
+
 	for (i = 0; i < n; i++) {
 		b = btree_nodes[i];
 		if (!b) {
-- 
2.16.4

