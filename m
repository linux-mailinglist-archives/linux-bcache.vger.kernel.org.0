Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D02126457D
	for <lists+linux-bcache@lfdr.de>; Thu, 10 Sep 2020 13:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgIJLvB (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 10 Sep 2020 07:51:01 -0400
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:39012 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730166AbgIJLs4 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 10 Sep 2020 07:48:56 -0400
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id E6D1DE025EA;
        Thu, 10 Sep 2020 19:28:26 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     colyli@suse.de
Cc:     linux-bcache@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH v2] bcache: allow allocator to invalidate bucket in gc
Date:   Thu, 10 Sep 2020 11:28:15 +0000
Message-Id: <1599737295-7985-1-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1599736884-5479-1-git-send-email-dongsheng.yang@easystack.cn>
References: <1599736884-5479-1-git-send-email-dongsheng.yang@easystack.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZGkodQk8ZGU8YSU5KVkpOQkJMSExIS0xKSkxVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS09ISVVKS0tZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NzY6Hhw6Hj4DShMJKxAYAg4C
        Iw0wFFFVSlVKTkJCTEhMSEtMSUNJVTMWGhIXVR8UFRwIEx4VHFUCGhUcOx4aCAIIDxoYEFUYFUVZ
        V1kSC1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBT0lOQjcG
X-HM-Tid: 0a7477c61f8d20bdkuqye6d1de025ea
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Currently, if the gc is running, when the allocator found free_inc
is empty, allocator has to wait the gc finish. Before that, the
IO is blocked.

But actually, there would be some buckets is reclaimable before gc,
and gc will never mark this kind of bucket to be  unreclaimable.

So we can put these buckets into free_inc in gc running to avoid
IO being blocked.

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
---
 drivers/md/bcache/alloc.c  | 11 +++++------
 drivers/md/bcache/bcache.h |  1 +
 drivers/md/bcache/btree.c  | 10 +++++++++-
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 52035a7..faa5a5d 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -130,12 +130,11 @@ static inline bool can_inc_bucket_gen(struct bucket *b)
 
 bool bch_can_invalidate_bucket(struct cache *ca, struct bucket *b)
 {
-	BUG_ON(!ca->set->gc_mark_valid);
-
-	return (!GC_MARK(b) ||
+	return ((b->reclaimable_in_gc || ca->set->gc_mark_valid) &&
+		((!GC_MARK(b) ||
 		GC_MARK(b) == GC_MARK_RECLAIMABLE) &&
 		!atomic_read(&b->pin) &&
-		can_inc_bucket_gen(b);
+		can_inc_bucket_gen(b)));
 }
 
 void __bch_invalidate_one_bucket(struct cache *ca, struct bucket *b)
@@ -149,6 +148,7 @@ void __bch_invalidate_one_bucket(struct cache *ca, struct bucket *b)
 	bch_inc_gen(ca, b);
 	b->prio = INITIAL_PRIO;
 	atomic_inc(&b->pin);
+	b->reclaimable_in_gc = 0;
 }
 
 static void bch_invalidate_one_bucket(struct cache *ca, struct bucket *b)
@@ -353,8 +353,7 @@ static int bch_allocator_thread(void *arg)
 		 */
 
 retry_invalidate:
-		allocator_wait(ca, ca->set->gc_mark_valid &&
-			       !ca->invalidate_needs_gc);
+		allocator_wait(ca, !ca->invalidate_needs_gc);
 		invalidate_buckets(ca);
 
 		/*
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 4fd03d2..870f146 100644
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
index 3d8bd06..d45a1dd 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1702,18 +1702,21 @@ static void btree_gc_start(struct cache_set *c)
 
 	mutex_lock(&c->bucket_lock);
 
-	c->gc_mark_valid = 0;
 	c->gc_done = ZERO_KEY;
 
 	for_each_cache(ca, c, i)
 		for_each_bucket(b, ca) {
 			b->last_gc = b->gen;
+			if (bch_can_invalidate_bucket(ca, b))
+				b->reclaimable_in_gc = 1;
+
 			if (!atomic_read(&b->pin)) {
 				SET_GC_MARK(b, 0);
 				SET_GC_SECTORS_USED(b, 0);
 			}
 		}
 
+	c->gc_mark_valid = 0;
 	mutex_unlock(&c->bucket_lock);
 }
 
@@ -1729,6 +1732,11 @@ static void bch_btree_gc_finish(struct cache_set *c)
 	c->gc_mark_valid = 1;
 	c->need_gc	= 0;
 
+	for_each_cache(ca, c, i)
+		for_each_bucket(b, ca)
+			if (b->reclaimable_in_gc)
+				b->reclaimable_in_gc = 0;
+
 	for (i = 0; i < KEY_PTRS(&c->uuid_bucket); i++)
 		SET_GC_MARK(PTR_BUCKET(c, &c->uuid_bucket, i),
 			    GC_MARK_METADATA);
-- 
1.8.3.1

