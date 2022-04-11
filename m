Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F02524FB221
	for <lists+linux-bcache@lfdr.de>; Mon, 11 Apr 2022 05:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238464AbiDKDGq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 10 Apr 2022 23:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244476AbiDKDGp (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 10 Apr 2022 23:06:45 -0400
Received: from mail-m2835.qiye.163.com (mail-m2835.qiye.163.com [103.74.28.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E72B871
        for <linux-bcache@vger.kernel.org>; Sun, 10 Apr 2022 20:04:30 -0700 (PDT)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m2835.qiye.163.com (Hmail) with ESMTPA id C52448A0295;
        Mon, 11 Apr 2022 11:04:27 +0800 (CST)
From:   mingzhe.zou@easystack.cn
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     zoumingzhe@qq.com, ZouMingzhe <mingzhe.zou@easystack.cn>
Subject: [PATCH v2 1/3] bcache: bch_sectors_dirty_init() check each thread result and return error
Date:   Mon, 11 Apr 2022 11:04:15 +0800
Message-Id: <20220411030417.7222-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220401122725.17725-1-mingzhe.zou@easystack.cn>
References: <20220401122725.17725-1-mingzhe.zou@easystack.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlCN1dZLVlBSVdZDwkaFQgSH1lBWRoaQhlWTkxOSE8fGEweH0
        0eVRkRExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktISkNVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MxQ6Tww*SjIZISg0ExkeQkwh
        QiwaFDFVSlVKTU9CTU9NSU1DSElKVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBTk5OSTcG
X-HM-Tid: 0a8016946e5a841dkuqwc52448a0295
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: ZouMingzhe <mingzhe.zou@easystack.cn>

1. bch_dirty_init_thread() dont check bch_root_node_dirty_init() error
   and return it, add result in struct dirty_init_thrd_info.
2. bch_sectors_dirty_init() dont check each thread result and return void,
   we should check each thread and return error.
3. bch_btree_check() and bch_sectors_dirty_init() must wait all threads stop,
   cannot return error immediately.

Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/btree.c     |  6 +++++-
 drivers/md/bcache/writeback.c | 27 ++++++++++++++++++++++-----
 drivers/md/bcache/writeback.h |  3 ++-
 3 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index f8e6f5c7c736..f5f2718e03e5 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -2064,16 +2064,20 @@ int bch_btree_check(struct cache_set *c)
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

