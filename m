Return-Path: <linux-bcache+bounces-789-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 793CC9D0BA7
	for <lists+linux-bcache@lfdr.de>; Mon, 18 Nov 2024 10:27:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2682C1F218BE
	for <lists+linux-bcache@lfdr.de>; Mon, 18 Nov 2024 09:27:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D028C18C03E;
	Mon, 18 Nov 2024 09:27:26 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-m17237.xmail.ntesmail.com (mail-m17237.xmail.ntesmail.com [45.195.17.237])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AB9DDC1
	for <linux-bcache@vger.kernel.org>; Mon, 18 Nov 2024 09:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.195.17.237
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731922046; cv=none; b=sU4ecM4xvC25oigMIFw5WE4rGIMdwgLORTSCCFTIZWnGCC+gdG74WIxaFapMk3zaAbVb4nvi/dpV8PY9l4CNAmh7zhgKgref/CdgVjb0G4Lbql57z2rqV93YOLrz0o5mGiUsoVJnl+xTO8RyuYBbm3u1y9Vvosa9tjVPBNCIFD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731922046; c=relaxed/simple;
	bh=IGCSyRmJJ5Axgg6lHrrO0QkmMNzDk+z07lWKloJLeHY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NJTsjbjE5paxUbsVEaqy75BkB5MyOnDtBwuDt/BqZJx9U6JY2B+n2GFLQbArvsw3EWdaOR7cCnf8RDmYex1tWbvc1Q+GSHguOluSguJ6SSqC7hvZs36BOAbNInONqZ0Etf1k7Wt76mbG0FY+YYF6Hc/Spu2hnnEsnsE9/GkEUBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=easystack.cn; spf=none smtp.mailfrom=easystack.cn; arc=none smtp.client-ip=45.195.17.237
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=easystack.cn
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 18240ea4;
	Mon, 18 Nov 2024 17:27:01 +0800 (GMT+08:00)
From: mingzhe.zou@easystack.cn
To: colyli@suse.de
Cc: linux-bcache@vger.kernel.org,
	zoumingzhe@qq.com
Subject: [PATCH 1/3] bcache: avoid invalidating buckets in use
Date: Mon, 18 Nov 2024 17:26:40 +0800
Message-Id: <20241118092642.7044-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkZQklLVh9ITh9DTUlOSUgfSFYVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0hLS0xOVUpLS1
	VLWQY+
X-HM-Tid: 0a933e98cc78022bkunm18240ea4
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pjo6KDo*DDcsFUowFSoLNghM
	LTcaFC9VSlVKTEhKQklJS0lJSEtOVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
	C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSE5CTzcG

From: Mingzhe Zou <mingzhe.zou@easystack.cn>

If the bucket was reused while our bio was in flight, we might
have read the wrong data. Currently, we will reread the data from
the backing device. This not only reduces performance, but also
makes the process more complex.

When the bucket is in use, we hope not to reclaim it.

Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/alloc.c  | 30 +++++++++++++++++++++---------
 drivers/md/bcache/bcache.h |  3 ++-
 2 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index da50f6661bae..32f65d6fc906 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -134,25 +134,39 @@ bool bch_can_invalidate_bucket(struct cache *ca, struct bucket *b)
 	       !atomic_read(&b->pin) && can_inc_bucket_gen(b));
 }
 
-void __bch_invalidate_one_bucket(struct cache *ca, struct bucket *b)
+bool __bch_invalidate_one_bucket(struct cache *ca, struct bucket *b)
 {
 	lockdep_assert_held(&ca->set->bucket_lock);
 	BUG_ON(GC_MARK(b) && GC_MARK(b) != GC_MARK_RECLAIMABLE);
 
+	/*
+	 * If the bucket was reused while read bio was in flight, it will
+	 * reread the data from the backing device. This will increase latency
+	 * and cause other errors. When b->pin is not 0, do not invalidate
+	 * the bucket.
+	 */
+
+	b->invalidating = 1;
+
+	if (atomic_inc_return(&b->pin) > 1) {
+		atomic_dec(&b->pin);
+		return false;
+	}
+
 	if (GC_SECTORS_USED(b))
 		trace_bcache_invalidate(ca, b - ca->buckets);
 
 	bch_inc_gen(ca, b);
 	b->prio = INITIAL_PRIO;
-	atomic_inc(&b->pin);
 	b->reclaimable_in_gc = 0;
+	b->invalidating = 0;
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
@@ -253,8 +267,7 @@ static void invalidate_buckets_fifo(struct cache *ca)
 
 		b = ca->buckets + ca->fifo_last_bucket++;
 
-		if (bch_can_invalidate_bucket(ca, b))
-			bch_invalidate_one_bucket(ca, b);
+		bch_invalidate_one_bucket(ca, b);
 
 		if (++checked >= ca->sb.nbuckets) {
 			ca->invalidate_needs_gc = 1;
@@ -279,8 +292,7 @@ static void invalidate_buckets_random(struct cache *ca)
 
 		b = ca->buckets + n;
 
-		if (bch_can_invalidate_bucket(ca, b))
-			bch_invalidate_one_bucket(ca, b);
+		bch_invalidate_one_bucket(ca, b);
 
 		if (++checked >= ca->sb.nbuckets / 2) {
 			ca->invalidate_needs_gc = 1;
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 785b0d9008fa..2777d72e1038 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -201,6 +201,7 @@ struct bucket {
 	uint8_t		last_gc; /* Most out of date gen in the btree */
 	uint16_t	gc_mark; /* Bitfield used by GC. See below for field */
 	uint16_t	reclaimable_in_gc:1;
+	uint16_t	invalidating:1;
 };
 
 /*
@@ -981,7 +982,7 @@ uint8_t bch_inc_gen(struct cache *ca, struct bucket *b);
 void bch_rescale_priorities(struct cache_set *c, int sectors);
 
 bool bch_can_invalidate_bucket(struct cache *ca, struct bucket *b);
-void __bch_invalidate_one_bucket(struct cache *ca, struct bucket *b);
+bool __bch_invalidate_one_bucket(struct cache *ca, struct bucket *b);
 
 void __bch_bucket_free(struct cache *ca, struct bucket *b);
 void bch_bucket_free(struct cache_set *c, struct bkey *k);
-- 
2.34.1


