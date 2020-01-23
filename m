Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F545146F0E
	for <lists+linux-bcache@lfdr.de>; Thu, 23 Jan 2020 18:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730050AbgAWRDI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 23 Jan 2020 12:03:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:51882 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730037AbgAWRDH (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 23 Jan 2020 12:03:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 06026AD73;
        Thu, 23 Jan 2020 17:03:06 +0000 (UTC)
From:   colyli@suse.de
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 15/17] bcache: remove member accessed from struct btree
Date:   Fri, 24 Jan 2020 01:01:40 +0800
Message-Id: <20200123170142.98974-16-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200123170142.98974-1-colyli@suse.de>
References: <20200123170142.98974-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

The member 'accessed' of struct btree is used in bch_mca_scan() when
shrinking btree node caches. The original idea is, if b->accessed is
set, clean it and look at next btree node cache from c->btree_cache
list, and only shrink the caches whose b->accessed is cleaned. Then
only cold btree node cache will be shrunk.

But when I/O pressure is high, it is very probably that b->accessed
of a btree node cache will be set again in bch_btree_node_get()
before bch_mca_scan() selects it again. Then there is no chance for
bch_mca_scan() to shrink enough memory back to slub or slab system.

This patch removes member accessed from struct btree, then once a
btree node ache is selected, it will be immediately shunk. By this
change, bch_mca_scan() may release btree node cahce more efficiently.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/btree.c | 8 ++------
 drivers/md/bcache/btree.h | 2 --
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 14d6c33b0957..357535a5c89c 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -754,14 +754,12 @@ static unsigned long bch_mca_scan(struct shrinker *shrink,
 		b = list_first_entry(&c->btree_cache, struct btree, list);
 		list_rotate_left(&c->btree_cache);
 
-		if (!b->accessed &&
-		    !mca_reap(b, 0, false)) {
+		if (!mca_reap(b, 0, false)) {
 			mca_bucket_free(b);
 			mca_data_free(b);
 			rw_unlock(true, b);
 			freed++;
-		} else
-			b->accessed = 0;
+		}
 	}
 out:
 	mutex_unlock(&c->bucket_lock);
@@ -1069,7 +1067,6 @@ struct btree *bch_btree_node_get(struct cache_set *c, struct btree_op *op,
 	BUG_ON(!b->written);
 
 	b->parent = parent;
-	b->accessed = 1;
 
 	for (; i <= b->keys.nsets && b->keys.set[i].size; i++) {
 		prefetch(b->keys.set[i].tree);
@@ -1160,7 +1157,6 @@ struct btree *__bch_btree_node_alloc(struct cache_set *c, struct btree_op *op,
 		goto retry;
 	}
 
-	b->accessed = 1;
 	b->parent = parent;
 	bch_bset_init_next(&b->keys, b->keys.set->data, bset_magic(&b->c->sb));
 
diff --git a/drivers/md/bcache/btree.h b/drivers/md/bcache/btree.h
index 76cfd121a486..f4dcca449391 100644
--- a/drivers/md/bcache/btree.h
+++ b/drivers/md/bcache/btree.h
@@ -121,8 +121,6 @@ struct btree {
 	/* Key/pointer for this btree node */
 	BKEY_PADDED(key);
 
-	/* Single bit - set when accessed, cleared by shrinker */
-	unsigned long		accessed;
 	unsigned long		seq;
 	struct rw_semaphore	lock;
 	struct cache_set	*c;
-- 
2.16.4

