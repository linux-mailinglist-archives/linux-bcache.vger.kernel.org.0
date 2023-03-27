Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF6B6C9DFA
	for <lists+linux-bcache@lfdr.de>; Mon, 27 Mar 2023 10:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbjC0Ig5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 27 Mar 2023 04:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbjC0Igd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 27 Mar 2023 04:36:33 -0400
Received: from mail-m3164.qiye.163.com (mail-m3164.qiye.163.com [103.74.31.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C52349F8
        for <linux-bcache@vger.kernel.org>; Mon, 27 Mar 2023 01:31:19 -0700 (PDT)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m3164.qiye.163.com (Hmail) with ESMTPA id 7DAC662046E;
        Mon, 27 Mar 2023 16:28:21 +0800 (CST)
From:   Mingzhe Zou <mingzhe.zou@easystack.cn>
To:     colyli@suse.de
Cc:     linux-bcache@vger.kernel.org, bcache@lists.ewheeler.net,
        zoumingzhe@qq.com
Subject: [PATCH v2] bcache: fixup btree_cache_wait list damage
Date:   Mon, 27 Mar 2023 16:28:06 +0800
Message-Id: <20230327082806.15172-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1.windows.2
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlDQklLVh5JSB8ZGUlISEhJGlUZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hKQ1VKS0tVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MQw6LRw5IjJODhAePjEQLgs4
        NBMKChhVSlVKTUxCQktOTEtJSExLVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBT0JCSDcG
X-HM-Tid: 0a87222ebf1200a4kurm7dac662046e
X-HM-MType: 1
X-Spam-Status: No, score=0.0 required=5.0 tests=RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

We get a kernel crash about "list_add corruption. next->prev should be
prev (ffff9c801bc01210), but was ffff9c77b688237c. (next=ffffae586d8afe68)."

crash> struct list_head 0xffff9c801bc01210
struct list_head {
  next = 0xffffae586d8afe68,
  prev = 0xffffae586d8afe68
}
crash> struct list_head 0xffff9c77b688237c
struct list_head {
  next = 0x0,
  prev = 0x0
}
crash> struct list_head 0xffffae586d8afe68
struct list_head struct: invalid kernel virtual address: ffffae586d8afe68  type: "gdb_readmem_callback"
Cannot access memory at address 0xffffae586d8afe68

[230469.019492] Call Trace:
[230469.032041]  prepare_to_wait+0x8a/0xb0
[230469.044363]  ? bch_btree_keys_free+0x6c/0xc0 [bcache]
[230469.056533]  mca_cannibalize_lock+0x72/0x90 [bcache]
[230469.068788]  mca_alloc+0x2ae/0x450 [bcache]
[230469.080790]  bch_btree_node_get+0x136/0x2d0 [bcache]
[230469.092681]  bch_btree_check_thread+0x1e1/0x260 [bcache]
[230469.104382]  ? finish_wait+0x80/0x80
[230469.115884]  ? bch_btree_check_recurse+0x1a0/0x1a0 [bcache]
[230469.127259]  kthread+0x112/0x130
[230469.138448]  ? kthread_flush_work_fn+0x10/0x10
[230469.149477]  ret_from_fork+0x35/0x40

bch_btree_check_thread() and bch_dirty_init_thread() maybe call
mca_cannibalize() to cannibalize other cached btree nodes. Only
one thread can do it at a time, so the op of other threads will
be added to the btree_cache_wait list.

We must call finish_wait() to remove op from btree_cache_wait
before free it's memory address. Otherwise, the list will be
damaged. Also should call bch_cannibalize_unlock() to release
the btree_cache_alloc_lock and wake_up other waiters.

Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>

---
Changelog:
v2: apply to 6.3-rc4.
v1: Original verison.
---
 drivers/md/bcache/btree.c     | 10 +++++++++-
 drivers/md/bcache/btree.h     |  2 ++
 drivers/md/bcache/writeback.c |  8 ++++++++
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 147c493a989a..d53483cbd378 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -885,7 +885,7 @@ static struct btree *mca_cannibalize(struct cache_set *c, struct btree_op *op,
  * cannibalize_bucket() will take. This means every time we unlock the root of
  * the btree, we need to release this lock if we have it held.
  */
-static void bch_cannibalize_unlock(struct cache_set *c)
+void bch_cannibalize_unlock(struct cache_set *c)
 {
 	spin_lock(&c->btree_cannibalize_lock);
 	if (c->btree_cache_alloc_lock == current) {
@@ -1968,6 +1968,14 @@ static int bch_btree_check_thread(void *arg)
 			c->gc_stats.nodes++;
 			bch_btree_op_init(&op, 0);
 			ret = bcache_btree(check_recurse, p, c->root, &op);
+			/* The op may be added to cache_set's btree_cache_wait
+			* in mca_cannibalize(), must ensure it is removed from
+			* the list and release btree_cache_alloc_lock before
+			* free op memory.
+			* Otherwise, the btree_cache_wait will be damaged.
+			*/
+			bch_cannibalize_unlock(c);
+			finish_wait(&c->btree_cache_wait, &(&op)->wait);
 			if (ret)
 				goto out;
 		}
diff --git a/drivers/md/bcache/btree.h b/drivers/md/bcache/btree.h
index 1b5fdbc0d83e..5a3c602c2929 100644
--- a/drivers/md/bcache/btree.h
+++ b/drivers/md/bcache/btree.h
@@ -365,6 +365,8 @@ static inline void force_wake_up_gc(struct cache_set *c)
 	_r;                                                             \
 })
 
+void bch_cannibalize_unlock(struct cache_set *c);
+
 #define MAP_DONE	0
 #define MAP_CONTINUE	1
 
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index d4a5fc0650bb..ebc1f65727ea 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -890,6 +890,14 @@ static int bch_root_node_dirty_init(struct cache_set *c,
 	if (ret < 0)
 		pr_warn("sectors dirty init failed, ret=%d!\n", ret);
 
+	/* The op may be added to cache_set's btree_cache_wait
+	 * in mca_cannibalize(), must ensure it is removed from
+	 * the list and release btree_cache_alloc_lock before
+	 * free op memory.
+	 * Otherwise, the btree_cache_wait will be damaged.
+	 */
+	bch_cannibalize_unlock(c);
+	finish_wait(&c->btree_cache_wait, &(&op.op)->wait);
 	return ret;
 }
 
-- 
2.17.1.windows.2

