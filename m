Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8A05BE46C
	for <lists+linux-bcache@lfdr.de>; Tue, 20 Sep 2022 13:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiITL2z (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 20 Sep 2022 07:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiITL2y (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 20 Sep 2022 07:28:54 -0400
Received: from mail-m31114.qiye.163.com (mail-m31114.qiye.163.com [103.74.31.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152C46C108
        for <linux-bcache@vger.kernel.org>; Tue, 20 Sep 2022 04:28:53 -0700 (PDT)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m31114.qiye.163.com (Hmail) with ESMTPA id 988795C01A4;
        Tue, 20 Sep 2022 19:28:50 +0800 (CST)
From:   mingzhe.zou@easystack.cn
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     zoumingzhe@qq.com
Subject: [PATCH v3 1/3] bcache: bch_sectors_dirty_init() check each thread result and return error
Date:   Tue, 20 Sep 2022 19:28:48 +0800
Message-Id: <20220920112850.13157-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkaT05LVkkfTkwYT0MfQk5IS1UZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hKTFVKS0tVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Oj46Sxw4ETILIygVCgkrFB4w
        HyMwCkxVSlVKTU1ITUxISEhKS01NVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBTktDTzcG
X-HM-Tid: 0a835aa86c1700c3kurm988795c01a4
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/btree.c     |  6 +++++-
 drivers/md/bcache/writeback.c | 26 ++++++++++++++++++++++----
 drivers/md/bcache/writeback.h |  3 ++-
 3 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 147c493a989a..a76a77764b2c 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -2051,7 +2051,7 @@ int bch_btree_check(struct cache_set *c)
 			for (--i; i >= 0; i--)
 				kthread_stop(check_state.infos[i].thread);
 			ret = -ENOMEM;
-			goto out;
+			goto out_wait;
 		}
 		atomic_inc(&check_state.started);
 	}
@@ -2059,8 +2059,12 @@ int bch_btree_check(struct cache_set *c)
 	/*
 	 * Must wait for all threads to stop.
 	 */
+out_wait:
 	wait_event(check_state.wait, atomic_read(&check_state.started) == 0);
 
+	if (ret)
+		goto out;
+
 	for (i = 0; i < check_state.total_threads; i++) {
 		if (check_state.infos[i].result) {
 			ret = check_state.infos[i].result;
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 3f0ff3aab6f2..77db056cd97a 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -865,6 +865,7 @@ static int bch_root_node_dirty_init(struct cache_set *c,
 
 static int bch_dirty_init_thread(void *arg)
 {
+	int ret = 0;
 	struct dirty_init_thrd_info *info = arg;
 	struct bch_dirty_init_state *state = info->state;
 	struct cache_set *c = state->c;
@@ -905,7 +906,8 @@ static int bch_dirty_init_thread(void *arg)
 		}
 
 		if (p) {
-			if (bch_root_node_dirty_init(c, state->d, p) < 0)
+			ret = bch_root_node_dirty_init(c, state->d, p);
+			if (ret < 0)
 				goto out;
 		}
 
@@ -914,6 +916,7 @@ static int bch_dirty_init_thread(void *arg)
 	}
 
 out:
+	info->result = ret;
 	/* In order to wake up state->wait in time */
 	smp_mb__before_atomic();
 	if (atomic_dec_and_test(&state->started))
@@ -937,6 +940,7 @@ static int bch_btre_dirty_init_thread_nr(void)
 void bch_sectors_dirty_init(struct bcache_device *d)
 {
 	int i;
+	int ret = 0;
 	struct bkey *k = NULL;
 	struct btree_iter iter;
 	struct sectors_dirty_init op;
@@ -955,7 +959,7 @@ void bch_sectors_dirty_init(struct bcache_device *d)
 			sectors_dirty_init_fn(&op.op, c->root, k);
 
 		rw_unlock(0, c->root);
-		return;
+		return 0;
 	}
 
 	memset(&state, 0, sizeof(struct bch_dirty_init_state));
@@ -982,15 +986,29 @@ void bch_sectors_dirty_init(struct bcache_device *d)
 			pr_err("fails to run thread bch_dirty_init[%d]\n", i);
 			for (--i; i >= 0; i--)
 				kthread_stop(state.infos[i].thread);
-			goto out;
+			ret = -ENOMEM;
+			goto out_wait;
 		}
 		atomic_inc(&state.started);
 	}
 
-out:
+out_wait:
 	/* Must wait for all threads to stop. */
 	wait_event(state.wait, atomic_read(&state.started) == 0);
+
+	if (ret)
+		goto out;
+
+	for (i = 0; i < state.total_threads; i++) {
+		if (state.infos[i].result) {
+			ret = state.infos[i].result;
+			goto out;
+		}
+	}
+
+out:
 	rw_unlock(0, c->root);
+	return ret;
 }
 
 void bch_cached_dev_writeback_init(struct cached_dev *dc)
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index 31df716951f6..bb5372a14adc 100644
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

