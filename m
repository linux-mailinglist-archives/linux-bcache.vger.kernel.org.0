Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE520210776
	for <lists+linux-bcache@lfdr.de>; Wed,  1 Jul 2020 11:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbgGAJGe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 1 Jul 2020 05:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729135AbgGAJGc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Jul 2020 05:06:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6CBAC061755;
        Wed,  1 Jul 2020 02:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=mQGibEZ4EWaABS2sp9qmYlTXUEke11FF9TIW85Q/1Tw=; b=Bh7fgHaWEQ050xNgT9piFrz3KR
        OItr3cACp5cdTBuqnW1B+b0HLoHX5+FqtmQ/jm4M7evAWLtsHh59fK1ftbjq7qy4koTjKzYY50AFI
        6laFKn9TentYLxwD28E2YV8lCYb7y9ebgtx/4l5FkRsrZYAgYEcpGC+ZyQtETY6W6rD6MQniO8ZtB
        kaLlkK/1AQGDBHEMzXKSjzy6yLsZZU61fP2ZTChYOV7HU705F8jUegQmfPI3AI9jkYpkyWGFWs7v6
        1q3bUWtZlWZNylOn4EUlmaDQoGfxckgW6CVqLbv1slUmgsjv800/r7QXSDMFs/u2mwBhqXKn+xx4S
        WTw1z2AA==;
Received: from [2001:4bb8:184:76e3:ea38:596b:3e9e:422a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqYhI-0000iD-Ab; Wed, 01 Jul 2020 09:06:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tejun Heo <tj@kernel.org>, dm-devel@redhat.com,
        cgroups@vger.kernel.org, linux-block@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] writeback: remove struct bdi_writeback_congested
Date:   Wed,  1 Jul 2020 11:06:21 +0200
Message-Id: <20200701090622.3354860-4-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701090622.3354860-1-hch@lst.de>
References: <20200701090622.3354860-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

We never set any congested bits in the group writeback instances of it.
And for the simpler bdi-wide case a simple scalar field is all that
that is needed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-cgroup.c               |  19 +---
 drivers/md/dm.c                  |   2 +-
 include/linux/backing-dev-defs.h |  25 +-----
 include/linux/backing-dev.h      |  18 +---
 include/linux/blk-cgroup.h       |   6 --
 mm/backing-dev.c                 | 149 ++-----------------------------
 6 files changed, 14 insertions(+), 205 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 1ce94afc03bcfd..30dc14ddf0f69c 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -95,9 +95,6 @@ static void __blkg_release(struct rcu_head *rcu)
 	css_put(&blkg->blkcg->css);
 	if (blkg->parent)
 		blkg_put(blkg->parent);
-
-	wb_congested_put(blkg->wb_congested);
-
 	blkg_free(blkg);
 }
 
@@ -227,7 +224,6 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 				    struct blkcg_gq *new_blkg)
 {
 	struct blkcg_gq *blkg;
-	struct bdi_writeback_congested *wb_congested;
 	int i, ret;
 
 	WARN_ON_ONCE(!rcu_read_lock_held());
@@ -245,31 +241,22 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 		goto err_free_blkg;
 	}
 
-	wb_congested = wb_congested_get_create(q->backing_dev_info,
-					       blkcg->css.id,
-					       GFP_NOWAIT | __GFP_NOWARN);
-	if (!wb_congested) {
-		ret = -ENOMEM;
-		goto err_put_css;
-	}
-
 	/* allocate */
 	if (!new_blkg) {
 		new_blkg = blkg_alloc(blkcg, q, GFP_NOWAIT | __GFP_NOWARN);
 		if (unlikely(!new_blkg)) {
 			ret = -ENOMEM;
-			goto err_put_congested;
+			goto err_put_css;
 		}
 	}
 	blkg = new_blkg;
-	blkg->wb_congested = wb_congested;
 
 	/* link parent */
 	if (blkcg_parent(blkcg)) {
 		blkg->parent = __blkg_lookup(blkcg_parent(blkcg), q, false);
 		if (WARN_ON_ONCE(!blkg->parent)) {
 			ret = -ENODEV;
-			goto err_put_congested;
+			goto err_put_css;
 		}
 		blkg_get(blkg->parent);
 	}
@@ -306,8 +293,6 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 	blkg_put(blkg);
 	return ERR_PTR(ret);
 
-err_put_congested:
-	wb_congested_put(wb_congested);
 err_put_css:
 	css_put(&blkcg->css);
 err_free_blkg:
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e44473fe0f4873..97838b6d0b5473 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1838,7 +1838,7 @@ static int dm_any_congested(void *congested_data, int bdi_bits)
 			 * top-level queue for congestion.
 			 */
 			struct backing_dev_info *bdi = md->queue->backing_dev_info;
-			r = bdi->wb.congested->state & bdi_bits;
+			r = bdi->wb.congested & bdi_bits;
 		} else {
 			map = dm_get_live_table_fast(md);
 			if (map)
diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index cc5aa1f32b91f0..1cec4521e1fbe2 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -87,26 +87,6 @@ struct wb_completion {
 #define DEFINE_WB_COMPLETION(cmpl, bdi)	\
 	struct wb_completion cmpl = WB_COMPLETION_INIT(bdi)
 
-/*
- * For cgroup writeback, multiple wb's may map to the same blkcg.  Those
- * wb's can operate mostly independently but should share the congested
- * state.  To facilitate such sharing, the congested state is tracked using
- * the following struct which is created on demand, indexed by blkcg ID on
- * its bdi, and refcounted.
- */
-struct bdi_writeback_congested {
-	unsigned long state;		/* WB_[a]sync_congested flags */
-	refcount_t refcnt;		/* nr of attached wb's and blkg */
-
-#ifdef CONFIG_CGROUP_WRITEBACK
-	struct backing_dev_info *__bdi;	/* the associated bdi, set to NULL
-					 * on bdi unregistration. For memcg-wb
-					 * internal use only! */
-	int blkcg_id;			/* ID of the associated blkcg */
-	struct rb_node rb_node;		/* on bdi->cgwb_congestion_tree */
-#endif
-};
-
 /*
  * Each wb (bdi_writeback) can perform writeback operations, is measured
  * and throttled, independently.  Without cgroup writeback, each bdi
@@ -140,7 +120,7 @@ struct bdi_writeback {
 
 	struct percpu_counter stat[NR_WB_STAT_ITEMS];
 
-	struct bdi_writeback_congested *congested;
+	unsigned long congested;	/* WB_[a]sync_congested flags */
 
 	unsigned long bw_time_stamp;	/* last time write bw is updated */
 	unsigned long dirtied_stamp;
@@ -208,11 +188,8 @@ struct backing_dev_info {
 	struct list_head wb_list; /* list of all wbs */
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct radix_tree_root cgwb_tree; /* radix tree of active cgroup wbs */
-	struct rb_root cgwb_congested_tree; /* their congested states */
 	struct mutex cgwb_release_mutex;  /* protect shutdown of wb structs */
 	struct rw_semaphore wb_switch_rwsem; /* no cgwb switch while syncing */
-#else
-	struct bdi_writeback_congested *wb_congested;
 #endif
 	wait_queue_head_t wb_waitq;
 
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 6b3504bf7a42b3..9173d2c22b4aa0 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -173,7 +173,7 @@ static inline int wb_congested(struct bdi_writeback *wb, int cong_bits)
 
 	if (bdi->congested_fn)
 		return bdi->congested_fn(bdi->congested_data, cong_bits);
-	return wb->congested->state & cong_bits;
+	return wb->congested & cong_bits;
 }
 
 long congestion_wait(int sync, long timeout);
@@ -224,9 +224,6 @@ static inline int bdi_sched_wait(void *word)
 
 #ifdef CONFIG_CGROUP_WRITEBACK
 
-struct bdi_writeback_congested *
-wb_congested_get_create(struct backing_dev_info *bdi, int blkcg_id, gfp_t gfp);
-void wb_congested_put(struct bdi_writeback_congested *congested);
 struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
 				    struct cgroup_subsys_state *memcg_css);
 struct bdi_writeback *wb_get_create(struct backing_dev_info *bdi,
@@ -404,19 +401,6 @@ static inline bool inode_cgwb_enabled(struct inode *inode)
 	return false;
 }
 
-static inline struct bdi_writeback_congested *
-wb_congested_get_create(struct backing_dev_info *bdi, int blkcg_id, gfp_t gfp)
-{
-	refcount_inc(&bdi->wb_congested->refcnt);
-	return bdi->wb_congested;
-}
-
-static inline void wb_congested_put(struct bdi_writeback_congested *congested)
-{
-	if (refcount_dec_and_test(&congested->refcnt))
-		kfree(congested);
-}
-
 static inline struct bdi_writeback *wb_find_current(struct backing_dev_info *bdi)
 {
 	return &bdi->wb;
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 431b2d18bf4074..c8fc9792ac776d 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -109,12 +109,6 @@ struct blkcg_gq {
 	struct hlist_node		blkcg_node;
 	struct blkcg			*blkcg;
 
-	/*
-	 * Each blkg gets congested separately and the congestion state is
-	 * propagated to the matching bdi_writeback_congested.
-	 */
-	struct bdi_writeback_congested	*wb_congested;
-
 	/* all non-root blkcg_gq's are guaranteed to have access to parent */
 	struct blkcg_gq			*parent;
 
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 3ebe5144a102f2..8e8b00627bb2d8 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -281,7 +281,7 @@ void wb_wakeup_delayed(struct bdi_writeback *wb)
 #define INIT_BW		(100 << (20 - PAGE_SHIFT))
 
 static int wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi,
-		   int blkcg_id, gfp_t gfp)
+		   gfp_t gfp)
 {
 	int i, err;
 
@@ -308,15 +308,9 @@ static int wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi,
 	INIT_DELAYED_WORK(&wb->dwork, wb_workfn);
 	wb->dirty_sleep = jiffies;
 
-	wb->congested = wb_congested_get_create(bdi, blkcg_id, gfp);
-	if (!wb->congested) {
-		err = -ENOMEM;
-		goto out_put_bdi;
-	}
-
 	err = fprop_local_init_percpu(&wb->completions, gfp);
 	if (err)
-		goto out_put_cong;
+		goto out_put_bdi;
 
 	for (i = 0; i < NR_WB_STAT_ITEMS; i++) {
 		err = percpu_counter_init(&wb->stat[i], 0, gfp);
@@ -330,8 +324,6 @@ static int wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi,
 	while (i--)
 		percpu_counter_destroy(&wb->stat[i]);
 	fprop_local_destroy_percpu(&wb->completions);
-out_put_cong:
-	wb_congested_put(wb->congested);
 out_put_bdi:
 	if (wb != &bdi->wb)
 		bdi_put(bdi);
@@ -374,7 +366,6 @@ static void wb_exit(struct bdi_writeback *wb)
 		percpu_counter_destroy(&wb->stat[i]);
 
 	fprop_local_destroy_percpu(&wb->completions);
-	wb_congested_put(wb->congested);
 	if (wb != &wb->bdi->wb)
 		bdi_put(wb->bdi);
 }
@@ -384,99 +375,12 @@ static void wb_exit(struct bdi_writeback *wb)
 #include <linux/memcontrol.h>
 
 /*
- * cgwb_lock protects bdi->cgwb_tree, bdi->cgwb_congested_tree,
- * blkcg->cgwb_list, and memcg->cgwb_list.  bdi->cgwb_tree is also RCU
- * protected.
+ * cgwb_lock protects bdi->cgwb_tree, blkcg->cgwb_list, and memcg->cgwb_list.
+ * bdi->cgwb_tree is also RCU protected.
  */
 static DEFINE_SPINLOCK(cgwb_lock);
 static struct workqueue_struct *cgwb_release_wq;
 
-/**
- * wb_congested_get_create - get or create a wb_congested
- * @bdi: associated bdi
- * @blkcg_id: ID of the associated blkcg
- * @gfp: allocation mask
- *
- * Look up the wb_congested for @blkcg_id on @bdi.  If missing, create one.
- * The returned wb_congested has its reference count incremented.  Returns
- * NULL on failure.
- */
-struct bdi_writeback_congested *
-wb_congested_get_create(struct backing_dev_info *bdi, int blkcg_id, gfp_t gfp)
-{
-	struct bdi_writeback_congested *new_congested = NULL, *congested;
-	struct rb_node **node, *parent;
-	unsigned long flags;
-retry:
-	spin_lock_irqsave(&cgwb_lock, flags);
-
-	node = &bdi->cgwb_congested_tree.rb_node;
-	parent = NULL;
-
-	while (*node != NULL) {
-		parent = *node;
-		congested = rb_entry(parent, struct bdi_writeback_congested,
-				     rb_node);
-		if (congested->blkcg_id < blkcg_id)
-			node = &parent->rb_left;
-		else if (congested->blkcg_id > blkcg_id)
-			node = &parent->rb_right;
-		else
-			goto found;
-	}
-
-	if (new_congested) {
-		/* !found and storage for new one already allocated, insert */
-		congested = new_congested;
-		rb_link_node(&congested->rb_node, parent, node);
-		rb_insert_color(&congested->rb_node, &bdi->cgwb_congested_tree);
-		spin_unlock_irqrestore(&cgwb_lock, flags);
-		return congested;
-	}
-
-	spin_unlock_irqrestore(&cgwb_lock, flags);
-
-	/* allocate storage for new one and retry */
-	new_congested = kzalloc(sizeof(*new_congested), gfp);
-	if (!new_congested)
-		return NULL;
-
-	refcount_set(&new_congested->refcnt, 1);
-	new_congested->__bdi = bdi;
-	new_congested->blkcg_id = blkcg_id;
-	goto retry;
-
-found:
-	refcount_inc(&congested->refcnt);
-	spin_unlock_irqrestore(&cgwb_lock, flags);
-	kfree(new_congested);
-	return congested;
-}
-
-/**
- * wb_congested_put - put a wb_congested
- * @congested: wb_congested to put
- *
- * Put @congested and destroy it if the refcnt reaches zero.
- */
-void wb_congested_put(struct bdi_writeback_congested *congested)
-{
-	unsigned long flags;
-
-	if (!refcount_dec_and_lock_irqsave(&congested->refcnt, &cgwb_lock, &flags))
-		return;
-
-	/* bdi might already have been destroyed leaving @congested unlinked */
-	if (congested->__bdi) {
-		rb_erase(&congested->rb_node,
-			 &congested->__bdi->cgwb_congested_tree);
-		congested->__bdi = NULL;
-	}
-
-	spin_unlock_irqrestore(&cgwb_lock, flags);
-	kfree(congested);
-}
-
 static void cgwb_release_workfn(struct work_struct *work)
 {
 	struct bdi_writeback *wb = container_of(work, struct bdi_writeback,
@@ -558,7 +462,7 @@ static int cgwb_create(struct backing_dev_info *bdi,
 		goto out_put;
 	}
 
-	ret = wb_init(wb, bdi, blkcg_css->id, gfp);
+	ret = wb_init(wb, bdi, gfp);
 	if (ret)
 		goto err_free;
 
@@ -696,11 +600,10 @@ static int cgwb_bdi_init(struct backing_dev_info *bdi)
 	int ret;
 
 	INIT_RADIX_TREE(&bdi->cgwb_tree, GFP_ATOMIC);
-	bdi->cgwb_congested_tree = RB_ROOT;
 	mutex_init(&bdi->cgwb_release_mutex);
 	init_rwsem(&bdi->wb_switch_rwsem);
 
-	ret = wb_init(&bdi->wb, bdi, 1, GFP_KERNEL);
+	ret = wb_init(&bdi->wb, bdi, GFP_KERNEL);
 	if (!ret) {
 		bdi->wb.memcg_css = &root_mem_cgroup->css;
 		bdi->wb.blkcg_css = blkcg_root_css;
@@ -769,21 +672,6 @@ void wb_blkcg_offline(struct blkcg *blkcg)
 	spin_unlock_irq(&cgwb_lock);
 }
 
-static void cgwb_bdi_exit(struct backing_dev_info *bdi)
-{
-	struct rb_node *rbn;
-
-	spin_lock_irq(&cgwb_lock);
-	while ((rbn = rb_first(&bdi->cgwb_congested_tree))) {
-		struct bdi_writeback_congested *congested =
-			rb_entry(rbn, struct bdi_writeback_congested, rb_node);
-
-		rb_erase(rbn, &bdi->cgwb_congested_tree);
-		congested->__bdi = NULL;	/* mark @congested unlinked */
-	}
-	spin_unlock_irq(&cgwb_lock);
-}
-
 static void cgwb_bdi_register(struct backing_dev_info *bdi)
 {
 	spin_lock_irq(&cgwb_lock);
@@ -810,29 +698,11 @@ subsys_initcall(cgwb_init);
 
 static int cgwb_bdi_init(struct backing_dev_info *bdi)
 {
-	int err;
-
-	bdi->wb_congested = kzalloc(sizeof(*bdi->wb_congested), GFP_KERNEL);
-	if (!bdi->wb_congested)
-		return -ENOMEM;
-
-	refcount_set(&bdi->wb_congested->refcnt, 1);
-
-	err = wb_init(&bdi->wb, bdi, 1, GFP_KERNEL);
-	if (err) {
-		wb_congested_put(bdi->wb_congested);
-		return err;
-	}
-	return 0;
+	return wb_init(&bdi->wb, bdi, GFP_KERNEL);
 }
 
 static void cgwb_bdi_unregister(struct backing_dev_info *bdi) { }
 
-static void cgwb_bdi_exit(struct backing_dev_info *bdi)
-{
-	wb_congested_put(bdi->wb_congested);
-}
-
 static void cgwb_bdi_register(struct backing_dev_info *bdi)
 {
 	list_add_tail_rcu(&bdi->wb.bdi_node, &bdi->wb_list);
@@ -1023,7 +893,6 @@ static void release_bdi(struct kref *ref)
 		bdi_unregister(bdi);
 	WARN_ON_ONCE(bdi->dev);
 	wb_exit(&bdi->wb);
-	cgwb_bdi_exit(bdi);
 	kfree(bdi);
 }
 
@@ -1053,7 +922,7 @@ void clear_bdi_congested(struct backing_dev_info *bdi, int sync)
 	enum wb_congested_state bit;
 
 	bit = sync ? WB_sync_congested : WB_async_congested;
-	if (test_and_clear_bit(bit, &bdi->wb.congested->state))
+	if (test_and_clear_bit(bit, &bdi->wb.congested))
 		atomic_dec(&nr_wb_congested[sync]);
 	smp_mb__after_atomic();
 	if (waitqueue_active(wqh))
@@ -1066,7 +935,7 @@ void set_bdi_congested(struct backing_dev_info *bdi, int sync)
 	enum wb_congested_state bit;
 
 	bit = sync ? WB_sync_congested : WB_async_congested;
-	if (!test_and_set_bit(bit, &bdi->wb.congested->state))
+	if (!test_and_set_bit(bit, &bdi->wb.congested))
 		atomic_inc(&nr_wb_congested[sync]);
 }
 EXPORT_SYMBOL(set_bdi_congested);
-- 
2.26.2

