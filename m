Return-Path: <linux-bcache+bounces-433-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E69BD8C1258
	for <lists+linux-bcache@lfdr.de>; Thu,  9 May 2024 17:56:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 83DFFB207E4
	for <lists+linux-bcache@lfdr.de>; Thu,  9 May 2024 15:56:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7FD416F0FD;
	Thu,  9 May 2024 15:56:19 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-m605.netease.com (mail-m605.netease.com [210.79.60.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0464D3F8E2
	for <linux-bcache@vger.kernel.org>; Thu,  9 May 2024 15:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.79.60.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715270179; cv=none; b=IHgLfE4HALa0wnHIqAogRaYwThHT81g75JV3N3EbREv8ABEHAzjOEXBONvU0pRm8F+0UA/HtZP0HCxYjO+AHppLDEF0pyt/9I1KJtPKBBscjdm2lOBeTulXaV76sOM3964LhjNBmNuGkJ6H8YrsWocDHzWUdebKGObOhcqcfawQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715270179; c=relaxed/simple;
	bh=DZVN1uZYlyg7yG872Nhgig8UoFmTEZ/JL9yd2MZZDVc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=p49jr28o4OrnIgPp2bluXz3cUOCpx/8lIT2AmV1bCyVAfQbGVwAiXjVko7TQCTc3lhyhaVUQuUpFK2ZyFBShM3tu+W1Q1CZClEq0sWVWTrt7Mu2ERUSr/W51O9vdx9CGCfrtvHAv0tMyhVR6AnDsa4mWLc49sMJTO0TDNJlKv2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn; spf=pass smtp.mailfrom=easystack.cn; arc=none smtp.client-ip=210.79.60.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=easystack.cn
Received: from easystack.cn (unknown [127.0.0.1])
	by smtp.qiye.163.com (Hmail) with ESMTP id 8FECC4C01FE
	for <linux-bcache@vger.kernel.org>; Thu,  9 May 2024 10:59:03 +0800 (CST)
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTPA id A460426024D;
	Wed,  8 May 2024 15:32:22 +0800 (CST)
From: mingzhe.zou@easystack.cn
To: colyli@suse.de,
	bcache@lists.ewheeler.net,
	robertpang@google.com
Cc: linux-bcache@vger.kernel.org,
	zoumingzhe@qq.com,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	Mingzhe Zou <mingzhe.zou@easystack.cn>
Subject: [PATCH v3] bcache: allow allocator to invalidate bucket in gc
Date: Wed,  8 May 2024 15:32:15 +0800
Message-Id: <1596418224.689.1715223543586.JavaMail.hmail@wm-bj-12-entmail-virt53.gy.ntes>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Resent-From: mingzhe.zou@easystack.cn
Resent-Message-Id: <20240509025903.8FECC4C01FE@smtp.qiye.163.com>
Resent-Date: Thu,  9 May 2024 10:59:03 +0800 (CST)
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlCSkgfVhhKHR1OQ0geGE5MSVUZERMWGhIXJBQOD1
	lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpNT0lMTlVKS0tVSkJLS1kG
X-HM-Tid: 0a8f5b4a3f250242kunm8fecc4c01fe
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQQ8JDh5XWRIfHhUPWUFZRzo8KjoeOjpDOj9NOi0cOD06Kzo6
	QxoKFlVKVUpMSk5JSUhOT09KSElVMxYaEhdVFhIVHAETHlUBFA47HhoIAggPGhgQVRgVRVlXWRIL
	WUFZSUpDVUJPVUpKQ1VCS1lXWQgBWUFOQ0lLNwY+

From: Dongsheng Yang <dongsheng.yang@easystack.cn>

Currently, if the gc is running, when the allocator found free_inc
is empty, allocator has to wait the gc finish. Before that, the
IO is blocked.

But actually, there would be some buckets is reclaimable before gc,
and gc will never mark this kind of bucket to be unreclaimable.

So we can put these buckets into free_inc in gc running to avoid
IO being blocked.

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/alloc.c  | 13 +++++--------
 drivers/md/bcache/bcache.h |  1 +
 drivers/md/bcache/btree.c  |  7 ++++++-
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index ce13c272c387..32a46343097d 100644
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
index 4e6afa89921f..1d33e40d26ea 100644
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
index 196cdacce38f..5d64543a1fb2 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1740,18 +1740,20 @@ static void btree_gc_start(struct cache_set *c)
 
 	mutex_lock(&c->bucket_lock);
 
-	c->gc_mark_valid = 0;
 	c->gc_done = ZERO_KEY;
 
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
 	mutex_unlock(&c->bucket_lock);
 }
 
@@ -1808,6 +1810,9 @@ static void bch_btree_gc_finish(struct cache_set *c)
 	for_each_bucket(b, ca) {
 		c->need_gc	= max(c->need_gc, bucket_gc_gen(b));
 
+		if (b->reclaimable_in_gc)
+			b->reclaimable_in_gc = 0;
+
 		if (atomic_read(&b->pin))
 			continue;
 
-- 
2.34.1


