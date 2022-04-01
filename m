Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF4D4EED1C
	for <lists+linux-bcache@lfdr.de>; Fri,  1 Apr 2022 14:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345875AbiDAM3W (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 1 Apr 2022 08:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345877AbiDAM3W (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 1 Apr 2022 08:29:22 -0400
Received: from mail-m2835.qiye.163.com (mail-m2835.qiye.163.com [103.74.28.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366DA278C4B
        for <linux-bcache@vger.kernel.org>; Fri,  1 Apr 2022 05:27:32 -0700 (PDT)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m2835.qiye.163.com (Hmail) with ESMTPA id 88C198A07ED;
        Fri,  1 Apr 2022 20:27:28 +0800 (CST)
From:   mingzhe.zou@easystack.cn
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     zoumingzhe@qq.com, ZouMingzhe <mingzhe.zou@easystack.cn>
Subject: [PATCH 2/2] bcache: check return in the register process and handle error
Date:   Fri,  1 Apr 2022 20:27:25 +0800
Message-Id: <20220401122725.17725-2-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220401122725.17725-1-mingzhe.zou@easystack.cn>
References: <20220401122725.17725-1-mingzhe.zou@easystack.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlCN1dZLVlBSVdZDwkaFQgSH1lBWUMeGUtWSE1DTExCTRgfSk
        pOVRkRExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktISkxVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PyI6Dxw*ODIhLkw6GDRODhMu
        LykKCxlVSlVKTU9DQ0pNS09DQkJNVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSkpPQkw3Bg++
X-HM-Tid: 0a7fe5184a3e841dkuqw88c198a07ed
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: ZouMingzhe <mingzhe.zou@easystack.cn>

Register bcache device process maybe return error. However,
some functions miss return value or unchecked. This allows
the problem device to be successfully registered.

We must to check for these errors and handle them properly.

Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/btree.c     | 30 ++++++++++-----
 drivers/md/bcache/super.c     | 69 +++++++++++++++++++++++------------
 drivers/md/bcache/writeback.c | 27 +++++++++++---
 drivers/md/bcache/writeback.h |  3 +-
 4 files changed, 91 insertions(+), 38 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index f8e6f5c7c736..7525d8c2406c 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1032,7 +1032,7 @@ struct btree *bch_btree_node_get(struct cache_set *c, struct btree_op *op,
 	return b;
 }
 
-static void btree_node_prefetch(struct btree *parent, struct bkey *k)
+static int btree_node_prefetch(struct btree *parent, struct bkey *k)
 {
 	struct btree *b;
 
@@ -1040,11 +1040,16 @@ static void btree_node_prefetch(struct btree *parent, struct bkey *k)
 	b = mca_alloc(parent->c, NULL, k, parent->level - 1);
 	mutex_unlock(&parent->c->bucket_lock);
 
-	if (!IS_ERR_OR_NULL(b)) {
-		b->parent = parent;
-		bch_btree_node_read(b);
-		rw_unlock(true, b);
-	}
+	if (IS_ERR(b))
+		return PTR_ERR(b);
+
+	if (!b)
+		return -ENOMEM;
+
+	b->parent = parent;
+	bch_btree_node_read(b);
+	rw_unlock(true, b);
+	return 0;
 }
 
 /* Btree alloc */
@@ -1888,7 +1893,7 @@ static int bch_btree_check_recurse(struct btree *b, struct btree_op *op)
 			k = bch_btree_iter_next_filter(&iter, &b->keys,
 						       bch_ptr_bad);
 			if (k) {
-				btree_node_prefetch(b, k);
+				ret = btree_node_prefetch(b, k);
 				/*
 				 * initiallize c->gc_stats.nodes
 				 * for incremental GC
@@ -1896,7 +1901,7 @@ static int bch_btree_check_recurse(struct btree *b, struct btree_op *op)
 				b->c->gc_stats.nodes++;
 			}
 
-			if (p)
+			if (p && !ret)
 				ret = bcache_btree(check_recurse, p, b, op);
 
 			p = k;
@@ -1965,6 +1970,9 @@ static int bch_btree_check_thread(void *arg)
 			struct btree_op op;
 
 			btree_node_prefetch(c->root, p);
+			ret = btree_node_prefetch(c->root, p);
+			if (ret)
+				goto out;
 			c->gc_stats.nodes++;
 			bch_btree_op_init(&op, 0);
 			ret = bcache_btree(check_recurse, p, c->root, &op);
@@ -2064,16 +2072,20 @@ int bch_btree_check(struct cache_set *c)
 			for (--i; i >= 0; i--)
 				kthread_stop(check_state->infos[i].thread);
 			ret = -ENOMEM;
-			goto out;
+			goto out_wait;
 		}
 	}
 
 	/*
 	 * Must wait for all threads to stop.
 	 */
+out_wait:
 	wait_event_interruptible(check_state->wait,
 				 atomic_read(&check_state->started) == 0);
 
+	if (ret)
+		goto out;
+
 	for (i = 0; i < check_state->total_threads; i++) {
 		if (check_state->infos[i].result) {
 			ret = check_state->infos[i].result;
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index bf3de149d3c9..a6b062a87acc 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1300,21 +1300,17 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 		bch_writeback_queue(dc);
 	}
 
-	bch_sectors_dirty_init(&dc->disk);
+	ret = bch_sectors_dirty_init(&dc->disk);
+	if (ret) {
+		pr_err("Fails in sectors dirty init for %s\n",
+		       dc->disk.disk->disk_name);
+		goto err;
+	}
 
 	ret = bch_cached_dev_run(dc);
 	if (ret && (ret != -EBUSY)) {
-		up_write(&dc->writeback_lock);
-		/*
-		 * bch_register_lock is held, bcache_device_stop() is not
-		 * able to be directly called. The kthread and kworker
-		 * created previously in bch_cached_dev_writeback_start()
-		 * have to be stopped manually here.
-		 */
-		kthread_stop(dc->writeback_thread);
-		cancel_writeback_rate_update_dwork(dc);
 		pr_err("Couldn't run cached device %pg\n", dc->bdev);
-		return ret;
+		goto err;
 	}
 
 	bcache_device_link(&dc->disk, c, "bdev");
@@ -1334,6 +1330,18 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 		dc->disk.disk->disk_name,
 		dc->disk.c->set_uuid);
 	return 0;
+
+err:
+	up_write(&dc->writeback_lock);
+	/*
+	 * bch_register_lock is held, bcache_device_stop() is not
+	 * able to be directly called. The kthread and kworker
+	 * created previously in bch_cached_dev_writeback_start()
+	 * have to be stopped manually here.
+	 */
+	kthread_stop(dc->writeback_thread);
+	cancel_writeback_rate_update_dwork(dc);
+	return ret;
 }
 
 /* when dc->disk.kobj released */
@@ -1472,8 +1480,12 @@ static int register_bdev(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 
 	list_add(&dc->list, &uncached_devices);
 	/* attach to a matched cache set if it exists */
-	list_for_each_entry(c, &bch_cache_sets, list)
-		bch_cached_dev_attach(dc, c, NULL);
+	err = "failed to attach cached device";
+	list_for_each_entry(c, &bch_cache_sets, list) {
+		ret = bch_cached_dev_attach(dc, c, NULL);
+		if (ret)
+			goto err;
+	}
 
 	if (BDEV_STATE(&dc->sb) == BDEV_STATE_NONE ||
 	    BDEV_STATE(&dc->sb) == BDEV_STATE_STALE) {
@@ -1526,7 +1538,7 @@ static void flash_dev_flush(struct closure *cl)
 
 static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
 {
-	int err = -ENOMEM;
+	int ret = -ENOMEM;
 	struct bcache_device *d = kzalloc(sizeof(struct bcache_device),
 					  GFP_KERNEL);
 	if (!d)
@@ -1542,14 +1554,19 @@ static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
 		goto err;
 
 	bcache_device_attach(d, c, u - c->uuids);
-	bch_sectors_dirty_init(d);
+
+	ret = bch_sectors_dirty_init(d);
+	if (ret)
+		goto err;
+
 	bch_flash_dev_request_init(d);
-	err = add_disk(d->disk);
-	if (err)
+
+	ret = add_disk(d->disk);
+	if (ret)
 		goto err;
 
-	err = kobject_add(&d->kobj, &disk_to_dev(d->disk)->kobj, "bcache");
-	if (err)
+	ret = kobject_add(&d->kobj, &disk_to_dev(d->disk)->kobj, "bcache");
+	if (ret)
 		goto err;
 
 	bcache_device_link(d, c, "volume");
@@ -1564,7 +1581,7 @@ static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
 err:
 	kobject_put(&d->kobj);
 err_ret:
-	return err;
+	return ret;
 }
 
 static int flash_devs_run(struct cache_set *c)
@@ -1971,6 +1988,8 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 
 static int run_cache_set(struct cache_set *c)
 {
+	int ret = -EIO;
+
 	const char *err = "cannot allocate memory";
 	struct cached_dev *dc, *t;
 	struct cache *ca = c->cache;
@@ -2123,8 +2142,12 @@ static int run_cache_set(struct cache_set *c)
 	if (bch_has_feature_obso_large_bucket(&c->cache->sb))
 		pr_err("Detect obsoleted large bucket layout, all attached bcache device will be read-only\n");
 
-	list_for_each_entry_safe(dc, t, &uncached_devices, list)
-		bch_cached_dev_attach(dc, c, NULL);
+	err = "failed to attach cached device";
+	list_for_each_entry_safe(dc, t, &uncached_devices, list) {
+		ret = bch_cached_dev_attach(dc, c, NULL);
+		if (ret)
+			goto err;
+	}
 
 	flash_devs_run(c);
 
@@ -2141,7 +2164,7 @@ static int run_cache_set(struct cache_set *c)
 
 	bch_cache_set_error(c, "%s", err);
 
-	return -EIO;
+	return ret;
 }
 
 static const char *register_cache_set(struct cache *ca)
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 5b828555bca8..f61cb71ca0c7 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -878,6 +878,7 @@ static int bch_root_node_dirty_init(struct cache_set *c,
 
 static int bch_dirty_init_thread(void *arg)
 {
+	int ret = 0;
 	struct dirty_init_thrd_info *info = arg;
 	struct bch_dirty_init_state *state = info->state;
 	struct cache_set *c = state->c;
@@ -919,7 +920,8 @@ static int bch_dirty_init_thread(void *arg)
 		}
 
 		if (p) {
-			if (bch_root_node_dirty_init(c, state->d, p) < 0)
+			ret = bch_root_node_dirty_init(c, state->d, p);
+			if (ret < 0)
 				goto out;
 		}
 
@@ -929,6 +931,7 @@ static int bch_dirty_init_thread(void *arg)
 	}
 
 out:
+	info->result = ret;
 	/* In order to wake up state->wait in time */
 	smp_mb__before_atomic();
 	if (atomic_dec_and_test(&state->started))
@@ -949,8 +952,9 @@ static int bch_btre_dirty_init_thread_nr(void)
 	return n;
 }
 
-void bch_sectors_dirty_init(struct bcache_device *d)
+int bch_sectors_dirty_init(struct bcache_device *d)
 {
+	int ret = 0;
 	int i;
 	struct bkey *k = NULL;
 	struct btree_iter iter;
@@ -969,13 +973,13 @@ void bch_sectors_dirty_init(struct bcache_device *d)
 		for_each_key_filter(&c->root->keys,
 				    k, &iter, bch_ptr_invalid)
 			sectors_dirty_init_fn(&op.op, c->root, k);
-		return;
+		return 0;
 	}
 
 	state = kzalloc(sizeof(struct bch_dirty_init_state), GFP_KERNEL);
 	if (!state) {
 		pr_warn("sectors dirty init failed: cannot allocate memory\n");
-		return;
+		return -ENOMEM;
 	}
 
 	state->c = c;
@@ -1005,18 +1009,31 @@ void bch_sectors_dirty_init(struct bcache_device *d)
 			pr_err("fails to run thread bch_dirty_init[%d]\n", i);
 			for (--i; i >= 0; i--)
 				kthread_stop(state->infos[i].thread);
-			goto out;
+			ret = -ENOMEM;
+			goto out_wait;
 		}
 	}
 
 	/*
 	 * Must wait for all threads to stop.
 	 */
+out_wait:
 	wait_event_interruptible(state->wait,
 		 atomic_read(&state->started) == 0);
 
+	if (ret)
+		goto out;
+
+	for (i = 0; i < state->total_threads; i++) {
+		if (state->infos[i].result) {
+			ret = state->infos[i].result;
+			goto out;
+		}
+	}
+
 out:
 	kfree(state);
+	return ret;
 }
 
 void bch_cached_dev_writeback_init(struct cached_dev *dc)
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index 02b2f9df73f6..0e42b3de5be6 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -32,6 +32,7 @@ struct bch_dirty_init_state;
 struct dirty_init_thrd_info {
 	struct bch_dirty_init_state	*state;
 	struct task_struct		*thread;
+	int				result;
 };
 
 struct bch_dirty_init_state {
@@ -148,7 +149,7 @@ static inline void bch_writeback_add(struct cached_dev *dc)
 void bcache_dev_sectors_dirty_add(struct cache_set *c, unsigned int inode,
 				  uint64_t offset, int nr_sectors);
 
-void bch_sectors_dirty_init(struct bcache_device *d);
+int bch_sectors_dirty_init(struct bcache_device *d);
 void bch_cached_dev_writeback_init(struct cached_dev *dc);
 int bch_cached_dev_writeback_start(struct cached_dev *dc);
 
-- 
2.17.1

