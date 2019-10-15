Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFFFFD7AC7
	for <lists+linux-bcache@lfdr.de>; Tue, 15 Oct 2019 18:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387775AbfJOQEU (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 15 Oct 2019 12:04:20 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37184 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387774AbfJOQEU (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 15 Oct 2019 12:04:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ynYkMUkukgdvKGE6fY1iFAs50j9h0KHeCM0CrJxjs/8=; b=g33waoR3V0AXBHaoros4VDEK6
        HS+SU8Yd1RAQhJ87FjkDgzKLL9JYroq3WkppPlvj/zMeym+l2dqAJzxnLFHoPx4UQvPg9s3mGAGeA
        EWvdHBZgIewY+5bWtycdmi0u/wVKV68xnkIDsPQ+A3A4ifiIcjy3BAHlQhvyCvla8ONJZIswOneui
        XYpzK8vb81T9KKesXswXd6y297qsZNh4q5Zi6/bhIYp7x4C0VFPIIzXwV7P5GFd9C2ZvaddR6Livz
        kGDHHY0AtR7cO7OBEu3KPQ6nalimzJku747N8LvxHUS+kRoRAgUUoZetmxYSZg90PGpxRSy9q3WpT
        tGtGgCtww==;
Received: from [2001:4bb8:18c:d7b:c70:4a89:bc61:3] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iKPJ5-0002by-Ms; Tue, 15 Oct 2019 16:04:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 2/2] bcache: don't export symbols
Date:   Tue, 15 Oct 2019 18:04:09 +0200
Message-Id: <20191015160409.14250-3-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191015160409.14250-1-hch@lst.de>
References: <20191015160409.14250-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

None of the exported bcache symbols are actually used anywhere.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/bset.c    | 15 ---------------
 drivers/md/bcache/closure.c |  7 -------
 2 files changed, 22 deletions(-)

diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index 08768796b543..a4bab18b2994 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -309,7 +309,6 @@ void bch_btree_keys_free(struct btree_keys *b)
 	t->tree = NULL;
 	t->data = NULL;
 }
-EXPORT_SYMBOL(bch_btree_keys_free);
 
 int bch_btree_keys_alloc(struct btree_keys *b,
 			 unsigned int page_order,
@@ -342,7 +341,6 @@ int bch_btree_keys_alloc(struct btree_keys *b,
 	bch_btree_keys_free(b);
 	return -ENOMEM;
 }
-EXPORT_SYMBOL(bch_btree_keys_alloc);
 
 void bch_btree_keys_init(struct btree_keys *b, const struct btree_keys_ops *ops,
 			 bool *expensive_debug_checks)
@@ -361,7 +359,6 @@ void bch_btree_keys_init(struct btree_keys *b, const struct btree_keys_ops *ops,
 	 * any more.
 	 */
 }
-EXPORT_SYMBOL(bch_btree_keys_init);
 
 /* Binary tree stuff for auxiliary search trees */
 
@@ -678,7 +675,6 @@ void bch_bset_init_next(struct btree_keys *b, struct bset *i, uint64_t magic)
 
 	bch_bset_build_unwritten_tree(b);
 }
-EXPORT_SYMBOL(bch_bset_init_next);
 
 /*
  * Build auxiliary binary tree 'struct bset_tree *t', this tree is used to
@@ -732,7 +728,6 @@ void bch_bset_build_written_tree(struct btree_keys *b)
 	     j = inorder_next(j, t->size))
 		make_bfloat(t, j);
 }
-EXPORT_SYMBOL(bch_bset_build_written_tree);
 
 /* Insert */
 
@@ -780,7 +775,6 @@ fix_right:	do {
 			j = j * 2 + 1;
 		} while (j < t->size);
 }
-EXPORT_SYMBOL(bch_bset_fix_invalidated_key);
 
 static void bch_bset_fix_lookup_table(struct btree_keys *b,
 				      struct bset_tree *t,
@@ -855,7 +849,6 @@ bool bch_bkey_try_merge(struct btree_keys *b, struct bkey *l, struct bkey *r)
 
 	return b->ops->key_merge(b, l, r);
 }
-EXPORT_SYMBOL(bch_bkey_try_merge);
 
 void bch_bset_insert(struct btree_keys *b, struct bkey *where,
 		     struct bkey *insert)
@@ -875,7 +868,6 @@ void bch_bset_insert(struct btree_keys *b, struct bkey *where,
 	bkey_copy(where, insert);
 	bch_bset_fix_lookup_table(b, t, where);
 }
-EXPORT_SYMBOL(bch_bset_insert);
 
 unsigned int bch_btree_insert_key(struct btree_keys *b, struct bkey *k,
 			      struct bkey *replace_key)
@@ -931,7 +923,6 @@ copy:	bkey_copy(m, k);
 merged:
 	return status;
 }
-EXPORT_SYMBOL(bch_btree_insert_key);
 
 /* Lookup */
 
@@ -1077,7 +1068,6 @@ struct bkey *__bch_bset_search(struct btree_keys *b, struct bset_tree *t,
 
 	return i.l;
 }
-EXPORT_SYMBOL(__bch_bset_search);
 
 /* Btree iterator */
 
@@ -1132,7 +1122,6 @@ struct bkey *bch_btree_iter_init(struct btree_keys *b,
 {
 	return __bch_btree_iter_init(b, iter, search, b->set);
 }
-EXPORT_SYMBOL(bch_btree_iter_init);
 
 static inline struct bkey *__bch_btree_iter_next(struct btree_iter *iter,
 						 btree_iter_cmp_fn *cmp)
@@ -1165,7 +1154,6 @@ struct bkey *bch_btree_iter_next(struct btree_iter *iter)
 	return __bch_btree_iter_next(iter, btree_iter_cmp);
 
 }
-EXPORT_SYMBOL(bch_btree_iter_next);
 
 struct bkey *bch_btree_iter_next_filter(struct btree_iter *iter,
 					struct btree_keys *b, ptr_filter_fn fn)
@@ -1196,7 +1184,6 @@ int bch_bset_sort_state_init(struct bset_sort_state *state,
 
 	return mempool_init_page_pool(&state->pool, 1, page_order);
 }
-EXPORT_SYMBOL(bch_bset_sort_state_init);
 
 static void btree_mergesort(struct btree_keys *b, struct bset *out,
 			    struct btree_iter *iter,
@@ -1313,7 +1300,6 @@ void bch_btree_sort_partial(struct btree_keys *b, unsigned int start,
 
 	EBUG_ON(oldsize >= 0 && bch_count_data(b) != oldsize);
 }
-EXPORT_SYMBOL(bch_btree_sort_partial);
 
 void bch_btree_sort_and_fix_extents(struct btree_keys *b,
 				    struct btree_iter *iter,
@@ -1366,7 +1352,6 @@ void bch_btree_sort_lazy(struct btree_keys *b, struct bset_sort_state *state)
 out:
 	bch_bset_build_written_tree(b);
 }
-EXPORT_SYMBOL(bch_btree_sort_lazy);
 
 void bch_btree_keys_stats(struct btree_keys *b, struct bset_stats *stats)
 {
diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.c
index c12cd809ab19..0164a1fe94a9 100644
--- a/drivers/md/bcache/closure.c
+++ b/drivers/md/bcache/closure.c
@@ -45,7 +45,6 @@ void closure_sub(struct closure *cl, int v)
 {
 	closure_put_after_sub(cl, atomic_sub_return(v, &cl->remaining));
 }
-EXPORT_SYMBOL(closure_sub);
 
 /*
  * closure_put - decrement a closure's refcount
@@ -54,7 +53,6 @@ void closure_put(struct closure *cl)
 {
 	closure_put_after_sub(cl, atomic_dec_return(&cl->remaining));
 }
-EXPORT_SYMBOL(closure_put);
 
 /*
  * closure_wake_up - wake up all closures on a wait list, without memory barrier
@@ -76,7 +74,6 @@ void __closure_wake_up(struct closure_waitlist *wait_list)
 		closure_sub(cl, CLOSURE_WAITING + 1);
 	}
 }
-EXPORT_SYMBOL(__closure_wake_up);
 
 /**
  * closure_wait - add a closure to a waitlist
@@ -96,7 +93,6 @@ bool closure_wait(struct closure_waitlist *waitlist, struct closure *cl)
 
 	return true;
 }
-EXPORT_SYMBOL(closure_wait);
 
 struct closure_syncer {
 	struct task_struct	*task;
@@ -131,7 +127,6 @@ void __sched __closure_sync(struct closure *cl)
 
 	__set_current_state(TASK_RUNNING);
 }
-EXPORT_SYMBOL(__closure_sync);
 
 #ifdef CONFIG_BCACHE_CLOSURES_DEBUG
 
@@ -149,7 +144,6 @@ void closure_debug_create(struct closure *cl)
 	list_add(&cl->all, &closure_list);
 	spin_unlock_irqrestore(&closure_list_lock, flags);
 }
-EXPORT_SYMBOL(closure_debug_create);
 
 void closure_debug_destroy(struct closure *cl)
 {
@@ -162,7 +156,6 @@ void closure_debug_destroy(struct closure *cl)
 	list_del(&cl->all);
 	spin_unlock_irqrestore(&closure_list_lock, flags);
 }
-EXPORT_SYMBOL(closure_debug_destroy);
 
 static struct dentry *closure_debug;
 
-- 
2.20.1

