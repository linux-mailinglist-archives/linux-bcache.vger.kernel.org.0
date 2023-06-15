Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9D1873184B
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Jun 2023 14:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343855AbjFOMN5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 15 Jun 2023 08:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343674AbjFOMN4 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 15 Jun 2023 08:13:56 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A8519B5;
        Thu, 15 Jun 2023 05:13:53 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 0CAEA223DA;
        Thu, 15 Jun 2023 12:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686831232; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s/txWO7dihxN+v9ZTDPm7tmWwWAwkv4+ElJccgrA55U=;
        b=yiQPkk35PwuwvgupdGTOVqb/baxXGOi7MUnFh9/awyYFIoeXL8UDIRHkwCmarGtj7pw7om
        dgwIJ97f890Dk8cOS52Qe+IoOzfPAwh+NXTAaufNqsr7/GHnfX4XLalxV/PvSFgOHIhl26
        ywMRkRMUhRpcXI0UnOZRpNp61DysDw8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686831232;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s/txWO7dihxN+v9ZTDPm7tmWwWAwkv4+ElJccgrA55U=;
        b=q3KKy0t9UoYzqSQa3GQsqMiAdm8Gw0/FBPntFpQuZs+zMCrlJValMXgIO1pYeinNsLvS9N
        76pRDh9DcnyymsBg==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 38A1A2C142;
        Thu, 15 Jun 2023 12:13:46 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Mingzhe Zou <mingzhe.zou@easystack.cn>, stable@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 6/6] bcache: fixup btree_cache_wait list damage
Date:   Thu, 15 Jun 2023 20:12:23 +0800
Message-Id: <20230615121223.22502-7-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230615121223.22502-1-colyli@suse.de>
References: <20230615121223.22502-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Mingzhe Zou <mingzhe.zou@easystack.cn>

We get a kernel crash about "list_add corruption. next->prev should be
prev (ffff9c801bc01210), but was ffff9c77b688237c.
(next=ffffae586d8afe68)."

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
[230469.044363]  ? bch_btree_keys_free+0x6c/0xc0 [escache]
[230469.056533]  mca_cannibalize_lock+0x72/0x90 [escache]
[230469.068788]  mca_alloc+0x2ae/0x450 [escache]
[230469.080790]  bch_btree_node_get+0x136/0x2d0 [escache]
[230469.092681]  bch_btree_check_thread+0x1e1/0x260 [escache]
[230469.104382]  ? finish_wait+0x80/0x80
[230469.115884]  ? bch_btree_check_recurse+0x1a0/0x1a0 [escache]
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

Fixes: 8e7102273f59 ("bcache: make bch_btree_check() to be multithreaded")
Fixes: b144e45fc576 ("bcache: make bch_sectors_dirty_init() to be multithreaded")
Cc: stable@vger.kernel.org
Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/btree.c     | 11 ++++++++++-
 drivers/md/bcache/btree.h     |  1 +
 drivers/md/bcache/writeback.c | 10 ++++++++++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 0ddf91204782..68b9d7ca864e 100644
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
@@ -1970,6 +1970,15 @@ static int bch_btree_check_thread(void *arg)
 			c->gc_stats.nodes++;
 			bch_btree_op_init(&op, 0);
 			ret = bcache_btree(check_recurse, p, c->root, &op);
+			/*
+			 * The op may be added to cache_set's btree_cache_wait
+			 * in mca_cannibalize(), must ensure it is removed from
+			 * the list and release btree_cache_alloc_lock before
+			 * free op memory.
+			 * Otherwise, the btree_cache_wait will be damaged.
+			 */
+			bch_cannibalize_unlock(c);
+			finish_wait(&c->btree_cache_wait, &(&op)->wait);
 			if (ret)
 				goto out;
 		}
diff --git a/drivers/md/bcache/btree.h b/drivers/md/bcache/btree.h
index 1b5fdbc0d83e..a2920bbfcad5 100644
--- a/drivers/md/bcache/btree.h
+++ b/drivers/md/bcache/btree.h
@@ -282,6 +282,7 @@ void bch_initial_gc_finish(struct cache_set *c);
 void bch_moving_gc(struct cache_set *c);
 int bch_btree_check(struct cache_set *c);
 void bch_initial_mark_key(struct cache_set *c, int level, struct bkey *k);
+void bch_cannibalize_unlock(struct cache_set *c);
 
 static inline void wake_up_gc(struct cache_set *c)
 {
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index d4a5fc0650bb..24c049067f61 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -890,6 +890,16 @@ static int bch_root_node_dirty_init(struct cache_set *c,
 	if (ret < 0)
 		pr_warn("sectors dirty init failed, ret=%d!\n", ret);
 
+	/*
+	 * The op may be added to cache_set's btree_cache_wait
+	 * in mca_cannibalize(), must ensure it is removed from
+	 * the list and release btree_cache_alloc_lock before
+	 * free op memory.
+	 * Otherwise, the btree_cache_wait will be damaged.
+	 */
+	bch_cannibalize_unlock(c);
+	finish_wait(&c->btree_cache_wait, &(&op.op)->wait);
+
 	return ret;
 }
 
-- 
2.35.3

