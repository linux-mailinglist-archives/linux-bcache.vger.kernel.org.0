Return-Path: <linux-bcache+bounces-795-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E9639D2705
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Nov 2024 14:35:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 32BC7B28324
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Nov 2024 13:23:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DA5F1CCB29;
	Tue, 19 Nov 2024 13:23:51 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from ec2-44-216-146-164.compute-1.amazonaws.com (ec2-44-216-146-164.compute-1.amazonaws.com [44.216.146.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9601CC894
	for <linux-bcache@vger.kernel.org>; Tue, 19 Nov 2024 13:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.216.146.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732022631; cv=none; b=G8GH0SnevAxAXxixbCaR55Tm9sbTLd/epdYiaWOXQFW/Yk7o8I9GVh2iHGBExLoBCeaogASQLgOoelHJH9E6halFyRjEIVNHzpE41GZGFUf827wUL5yc/4tQonr2IMPJq3MIx+zSCXg0XTVOWT/zqWLAjlUalDOVibwkjZcDKD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732022631; c=relaxed/simple;
	bh=HUWruPY+fuLwrmOuejFimbT9wfsHEgnGLkgeWIqSY7c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=k4wBVShox5vZYBgmftVmEoT23g0Nl91UnhZQw71u2nJ0RHF155gCQqKlJ+rOU+i8PQoNNHNxXnL0QmQh1jutTesHT7aVFYUpWAPxxg5z/GTHTuheTdN0o2gWMfOxBM5eD6MUF3Yv92fp+o02omaSPggIJ1MWC5eR/W+yJS/Xw6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=easystack.cn; spf=none smtp.mailfrom=easystack.cn; arc=none smtp.client-ip=44.216.146.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=easystack.cn
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 18ebb455;
	Tue, 19 Nov 2024 15:40:51 +0800 (GMT+08:00)
From: mingzhe.zou@easystack.cn
To: colyli@suse.de
Cc: linux-bcache@vger.kernel.org,
	dongsheng.yang@easystack.cn,
	zoumingzhe@qq.com
Subject: [PATCH v2 1/3] bcache: avoid invalidating buckets in use
Date: Tue, 19 Nov 2024 15:40:29 +0800
Message-Id: <20241119074031.27340-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlCTB8aVhgZHUMYSxlJSUoaSFYVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0lPT09LVUpLS1
	VLWQY+
X-HM-Tid: 0a93435df4ab022bkunm18ebb455
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Nhg6IRw*FDcsDUkfQyxJKRU*
	ASkaFDJVSlVKTEhJS0tJS05JTU1MVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
	C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSE5DTTcG

From: Mingzhe Zou <mingzhe.zou@easystack.cn>

If the bucket was reused while our bio was in flight, we might
have read the wrong data. Currently, we will reread the data from
the backing device. This not only reduces performance, but also
makes the process more complex.

When the bucket is in use, we hope not to reclaim it.

Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/alloc.c  | 32 +++++++++++++++++++++++---------
 drivers/md/bcache/bcache.h |  3 ++-
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index da50f6661bae..18441aa74229 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -134,25 +134,41 @@ bool bch_can_invalidate_bucket(struct cache *ca, struct bucket *b)
 	       !atomic_read(&b->pin) && can_inc_bucket_gen(b));
 }
 
-void __bch_invalidate_one_bucket(struct cache *ca, struct bucket *b)
+bool __bch_invalidate_one_bucket(struct cache *ca, struct bucket *b)
 {
 	lockdep_assert_held(&ca->set->bucket_lock);
 	BUG_ON(GC_MARK(b) && GC_MARK(b) != GC_MARK_RECLAIMABLE);
 
+	if (!spin_trylock(&b->lock))
+		return false;
+
+	/*
+	 * If the bucket was reused while read bio was in flight, it will
+	 * reread the data from the backing device. This will increase latency
+	 * and cause other errors. When b->pin is not 0, do not invalidate
+	 * the bucket.
+	 */
+
+	if (atomic_inc_return(&b->pin) > 1) {
+		atomic_dec(&b->pin);
+		spin_unlock(&b->lock);
+		return false;
+	}
+
 	if (GC_SECTORS_USED(b))
 		trace_bcache_invalidate(ca, b - ca->buckets);
 
 	bch_inc_gen(ca, b);
 	b->prio = INITIAL_PRIO;
-	atomic_inc(&b->pin);
 	b->reclaimable_in_gc = 0;
+	spin_unlock(&b->lock);
+	return true;
 }
 
 static void bch_invalidate_one_bucket(struct cache *ca, struct bucket *b)
 {
-	__bch_invalidate_one_bucket(ca, b);
-
-	fifo_push(&ca->free_inc, b - ca->buckets);
+	if (bch_can_invalidate_bucket(ca, b) && __bch_invalidate_one_bucket(ca, b))
+		fifo_push(&ca->free_inc, b - ca->buckets);
 }
 
 /*
@@ -253,8 +269,7 @@ static void invalidate_buckets_fifo(struct cache *ca)
 
 		b = ca->buckets + ca->fifo_last_bucket++;
 
-		if (bch_can_invalidate_bucket(ca, b))
-			bch_invalidate_one_bucket(ca, b);
+		bch_invalidate_one_bucket(ca, b);
 
 		if (++checked >= ca->sb.nbuckets) {
 			ca->invalidate_needs_gc = 1;
@@ -279,8 +294,7 @@ static void invalidate_buckets_random(struct cache *ca)
 
 		b = ca->buckets + n;
 
-		if (bch_can_invalidate_bucket(ca, b))
-			bch_invalidate_one_bucket(ca, b);
+		bch_invalidate_one_bucket(ca, b);
 
 		if (++checked >= ca->sb.nbuckets / 2) {
 			ca->invalidate_needs_gc = 1;
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 785b0d9008fa..fc7f10c5f222 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -196,6 +196,7 @@
 
 struct bucket {
 	atomic_t	pin;
+	spinlock_t	lock;
 	uint16_t	prio;
 	uint8_t		gen;
 	uint8_t		last_gc; /* Most out of date gen in the btree */
@@ -981,7 +982,7 @@ uint8_t bch_inc_gen(struct cache *ca, struct bucket *b);
 void bch_rescale_priorities(struct cache_set *c, int sectors);
 
 bool bch_can_invalidate_bucket(struct cache *ca, struct bucket *b);
-void __bch_invalidate_one_bucket(struct cache *ca, struct bucket *b);
+bool __bch_invalidate_one_bucket(struct cache *ca, struct bucket *b);
 
 void __bch_bucket_free(struct cache *ca, struct bucket *b);
 void bch_bucket_free(struct cache_set *c, struct bkey *k);
-- 
2.34.1


