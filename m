Return-Path: <linux-bcache+bounces-499-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA7CC8D1AB3
	for <lists+linux-bcache@lfdr.de>; Tue, 28 May 2024 14:09:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05BD51C22889
	for <lists+linux-bcache@lfdr.de>; Tue, 28 May 2024 12:09:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B425316D325;
	Tue, 28 May 2024 12:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bpGdmoJR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Kpnz5l+i";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bpGdmoJR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Kpnz5l+i"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB70716C6BF;
	Tue, 28 May 2024 12:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716898170; cv=none; b=qyzI/hd1if7BMPEOU9In85MEbpeRTYZDAnF3Rmh+b7RAX6JYd16h5ciP8aaodmaSnzzneR7KF17L9F4mcYou1tcjRW+b4fHJ9DnzAsVEZwUzUJ3Ef9QuO4xpK4qdWPN4mfXGmR3MldvdJsQSdt/z97lSrfp5PAFUaXMMz35BEGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716898170; c=relaxed/simple;
	bh=qs1lP3F/RReECvt5ig8VQh0exjUBp8B4DtgFQowtKis=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OA3xwZCKpBajsS7gzp58rPYuk+EnwltU8M72mN0VYbXTpUGgpAGkKX2t+nGt2KUHZrcpJkZw3oSuZa9gk1EXx98/LSZqCSTui33dym4bMSWtp+O6LQywaY17FAWI3zz2nZc7tXj06C3eYyVLFEii4vNCnQ+qDEx2EaJvDj2+wwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bpGdmoJR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Kpnz5l+i; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bpGdmoJR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Kpnz5l+i; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from suse-arm.lan (unknown [10.149.192.130])
	by smtp-out2.suse.de (Postfix) with ESMTP id DE66C20285;
	Tue, 28 May 2024 12:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716898167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4sCyETnzeCTk0ioHlBUzB9OCL1WL60LzLIijIDGAzvY=;
	b=bpGdmoJR9Vzfjeo0Auqb9C6v+d3OlFXKU++b/o6QnMZ5nKTyUCny4iOixTxQ6BfMfFvWB1
	Tb9t/vMe1mZ90UND2PHS5Tcwkcjtnt42baq1G156uZuiczis9jkDAvu8fSy/HWX3q7jdag
	4yyDxXWJaO9gOllXGM/0sH3yxdOyFDo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716898167;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4sCyETnzeCTk0ioHlBUzB9OCL1WL60LzLIijIDGAzvY=;
	b=Kpnz5l+iPkp4hZboLPF4fg2nmOQRty2AisqcEO7kzbZnT799CDIfWgSmwrIRqvzON/UKEy
	xZEbZ7qgR0jALhAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716898167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4sCyETnzeCTk0ioHlBUzB9OCL1WL60LzLIijIDGAzvY=;
	b=bpGdmoJR9Vzfjeo0Auqb9C6v+d3OlFXKU++b/o6QnMZ5nKTyUCny4iOixTxQ6BfMfFvWB1
	Tb9t/vMe1mZ90UND2PHS5Tcwkcjtnt42baq1G156uZuiczis9jkDAvu8fSy/HWX3q7jdag
	4yyDxXWJaO9gOllXGM/0sH3yxdOyFDo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716898167;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4sCyETnzeCTk0ioHlBUzB9OCL1WL60LzLIijIDGAzvY=;
	b=Kpnz5l+iPkp4hZboLPF4fg2nmOQRty2AisqcEO7kzbZnT799CDIfWgSmwrIRqvzON/UKEy
	xZEbZ7qgR0jALhAQ==
From: Coly Li <colyli@suse.de>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	Mingzhe Zou <mingzhe.zou@easystack.cn>,
	Coly Li <colyli@suse.de>
Subject: [PATCH 1/3] bcache: allow allocator to invalidate bucket in gc
Date: Tue, 28 May 2024 20:09:12 +0800
Message-Id: <20240528120914.28705-2-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240528120914.28705-1-colyli@suse.de>
References: <20240528120914.28705-1-colyli@suse.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.981];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email]

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
Signed-off-by: Coly Li <colyli@suse.de>
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
index d011a7154d33..4e6ccf2c8a0b 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1741,18 +1741,20 @@ static void btree_gc_start(struct cache_set *c)
 
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
 
@@ -1809,6 +1811,9 @@ static void bch_btree_gc_finish(struct cache_set *c)
 	for_each_bucket(b, ca) {
 		c->need_gc	= max(c->need_gc, bucket_gc_gen(b));
 
+		if (b->reclaimable_in_gc)
+			b->reclaimable_in_gc = 0;
+
 		if (atomic_read(&b->pin))
 			continue;
 
-- 
2.35.3


