Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1051052E7EF
	for <lists+linux-bcache@lfdr.de>; Fri, 20 May 2022 10:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345711AbiETIpE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 20 May 2022 04:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344162AbiETIpD (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 20 May 2022 04:45:03 -0400
Received: from mail-m2839.qiye.163.com (mail-m2839.qiye.163.com [103.74.28.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB3CA0D02
        for <linux-bcache@vger.kernel.org>; Fri, 20 May 2022 01:45:01 -0700 (PDT)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m2839.qiye.163.com (Hmail) with ESMTPA id 384CDC0544;
        Fri, 20 May 2022 16:44:59 +0800 (CST)
From:   mingzhe.zou@easystack.cn
To:     colyli@suse.de, dongsheng.yang@easystack.cn,
        linux-bcache@vger.kernel.org
Cc:     zoumingzhe@qq.com
Subject: [PATCH] bcache: allow allocator invalidate bucket in gc
Date:   Fri, 20 May 2022 16:44:58 +0800
Message-Id: <20220520084458.23049-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlCN1dZLVlBSVdZDwkaFQgSH1lBWUIaH09WGBlMGkNDHxgfSE
        hIVRkRExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktPSElVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MC46Qyo6GjIfCkNCUU0YNlEz
        TigaCxVVSlVKTU5IS0hNSUJCQ0lPVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBT0tKTDcG
X-HM-Tid: 0a80e0a434528421kuqw384cdc0544
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Dongsheng Yang <dongsheng.yang@easystack.cn>

Currently, if the gc is running, when the allocator found free_inc
is empty, allocator has to wait the gc finish. Before that, the
IO is blocked.

But actually, there would be some buckets is reclaimable before gc,
and gc will never mark this kind of bucket to be  unreclaimable.

So we can put these buckets into free_inc in gc running to avoid
IO being blocked.

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/alloc.c  | 13 +++++--------
 drivers/md/bcache/bcache.h |  1 +
 drivers/md/bcache/btree.c  | 10 +++++++---
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 097577ae3c47..410da3e25c76 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -129,12 +129,9 @@ static inline bool can_inc_bucket_gen(struct bucket *b)
 
 bool bch_can_invalidate_bucket(struct cache *ca, struct bucket *b)
 {
-	BUG_ON(!ca->set->gc_mark_valid);
-
-	return (!GC_MARK(b) ||
-		GC_MARK(b) == GC_MARK_RECLAIMABLE) &&
-		!atomic_read(&b->pin) &&
-		can_inc_bucket_gen(b);
+	return (ca->set->gc_mark_valid || b->reclaimable_in_gc) &&
+	       ((!GC_MARK(b) || GC_MARK(b) == GC_MARK_RECLAIMABLE) &&
+	       !atomic_read(&b->pin) && can_inc_bucket_gen(b));
 }
 
 void __bch_invalidate_one_bucket(struct cache *ca, struct bucket *b)
@@ -148,6 +145,7 @@ void __bch_invalidate_one_bucket(struct cache *ca, struct bucket *b)
 	bch_inc_gen(ca, b);
 	b->prio = INITIAL_PRIO;
 	atomic_inc(&b->pin);
+	b->reclaimable_in_gc = 0;
 }
 
 static void bch_invalidate_one_bucket(struct cache *ca, struct bucket *b)
@@ -352,8 +350,7 @@ static int bch_allocator_thread(void *arg)
 		 */
 
 retry_invalidate:
-		allocator_wait(ca, ca->set->gc_mark_valid &&
-			       !ca->invalidate_needs_gc);
+		allocator_wait(ca, !ca->invalidate_needs_gc);
 		invalidate_buckets(ca);
 
 		/*
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 9ed9c955add7..8103b61e4f81 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -200,6 +200,7 @@ struct bucket {
 	uint8_t		gen;
 	uint8_t		last_gc; /* Most out of date gen in the btree */
 	uint16_t	gc_mark; /* Bitfield used by GC. See below for field */
+	uint16_t	reclaimable_in_gc:1;
 };
 
 /*
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index ad9f16689419..d94b6f52652f 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1703,18 +1703,19 @@ static void btree_gc_start(struct cache_set *c)
 
 	mutex_lock(&c->bucket_lock);
 
-	c->gc_mark_valid = 0;
-	c->gc_done = ZERO_KEY;
-
 	ca = c->cache;
 	for_each_bucket(b, ca) {
 		b->last_gc = b->gen;
+		if (bch_can_invalidate_bucket(ca, b))
+			b->reclaimable_in_gc = 1;
 		if (!atomic_read(&b->pin)) {
 			SET_GC_MARK(b, 0);
 			SET_GC_SECTORS_USED(b, 0);
 		}
 	}
 
+	c->gc_mark_valid = 0;
+	c->gc_done = ZERO_KEY;
 	mutex_unlock(&c->bucket_lock);
 }
 
@@ -1771,6 +1772,9 @@ static void bch_btree_gc_finish(struct cache_set *c)
 	for_each_bucket(b, ca) {
 		c->need_gc	= max(c->need_gc, bucket_gc_gen(b));
 
+		if (b->reclaimable_in_gc)
+			b->reclaimable_in_gc = 0;
+
 		if (atomic_read(&b->pin))
 			continue;
 
-- 
2.17.1

