Return-Path: <linux-bcache+bounces-490-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 443608D0981
	for <lists+linux-bcache@lfdr.de>; Mon, 27 May 2024 19:47:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04CDF1F212EB
	for <lists+linux-bcache@lfdr.de>; Mon, 27 May 2024 17:47:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66E2315EFA8;
	Mon, 27 May 2024 17:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kPGS5czX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Ps73Diqk";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kPGS5czX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Ps73Diqk"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A469F61FE7
	for <linux-bcache@vger.kernel.org>; Mon, 27 May 2024 17:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716832063; cv=none; b=gOSu4x/yF8HNOTp4rMTINmeUMfHCnGCQhaD8zE/J7guMGo5JSMU39cmKaaI+Uei5KaFdDMbh3qXr6tnTWiMrepB6lCT7yop404vQUXzQFvw5QzgLzHbS76biC4i/5IWMSbgX/+pA7+IdC5p++LGM8V826DW8aTZWpo/iZTCYm14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716832063; c=relaxed/simple;
	bh=nhEyW+xxyANKL/q4Lh5FO00xmvZp5ITPXPEhC/qKC+U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qPp1u74q9BT2vSYy8stLAUQi1ypasxgTYlxOtZskI4D0+YFwSLvgkCDftGHXG3C1qiXFXlouFH4KHkJS+PIQ3QMW90bBSwxLz++oPD+WRXqHj/Mq4EKMP/QvoYpDVOgrCFiV+sr4H1whrKmaHb3QmRRaWMY9qTy2DspYDaxPsEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kPGS5czX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Ps73Diqk; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kPGS5czX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Ps73Diqk; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from suse-arm.lan (unknown [10.149.192.130])
	by smtp-out2.suse.de (Postfix) with ESMTP id D6DF01FE8B;
	Mon, 27 May 2024 17:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716832059; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Ecu6l64rYKbloNPdAo4aXfsHx7rdsvlKjgwucOmGwr4=;
	b=kPGS5czXNSuo+lIaLcYGGzMedsWQftFdQ6qbFHwGgUxNQki/UTyZQutHzU8hV3hkJrsTrA
	wC0yFfOYSX6Ax84nBE/GvwB3LzCYNuMmSy0fEn1c3WZ7XF01JbbgrCUzBF/g+MUYtFUHpg
	hJNEzdSKMeUYK+qmOp9qDvEeqtXNByQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716832059;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Ecu6l64rYKbloNPdAo4aXfsHx7rdsvlKjgwucOmGwr4=;
	b=Ps73DiqkNgeQXayaTs6CW1HCK9x+Vw1ySOtpJvEpLzFvE7u404C/B6T8bRFS5Zdyg4zzjV
	vqYrCd89AaQF95Dg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716832059; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Ecu6l64rYKbloNPdAo4aXfsHx7rdsvlKjgwucOmGwr4=;
	b=kPGS5czXNSuo+lIaLcYGGzMedsWQftFdQ6qbFHwGgUxNQki/UTyZQutHzU8hV3hkJrsTrA
	wC0yFfOYSX6Ax84nBE/GvwB3LzCYNuMmSy0fEn1c3WZ7XF01JbbgrCUzBF/g+MUYtFUHpg
	hJNEzdSKMeUYK+qmOp9qDvEeqtXNByQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716832059;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Ecu6l64rYKbloNPdAo4aXfsHx7rdsvlKjgwucOmGwr4=;
	b=Ps73DiqkNgeQXayaTs6CW1HCK9x+Vw1ySOtpJvEpLzFvE7u404C/B6T8bRFS5Zdyg4zzjV
	vqYrCd89AaQF95Dg==
From: Coly Li <colyli@suse.de>
To: linux-bcache@vger.kernel.org
Cc: Coly Li <colyli@suse.de>
Subject: [PATCH 2/3] bcache: call force_wake_up_gc() if necessary in check_should_bypass()
Date: Tue, 28 May 2024 01:47:32 +0800
Message-Id: <20240527174733.16351-1-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_ZERO(0.00)[0];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email]

If there are extreme heavy write I/O continuously hit on relative small
cache device (512GB in my testing), it is possible to make counter
c->gc_stats.in_use continue to increase and exceed CUTOFF_CACHE_ADD.

If 'c->gc_stats.in_use > CUTOFF_CACHE_ADD' happens, all following write
requests will bypass the cache device because check_should_bypass()
returns 'true'. Because all writes bypass the cache device, counter
c->sectors_to_gc has no chance to be negative value, and garbage
collection thread won't be waken up even the whole cache becomes clean
after writeback accomplished. The aftermath is that all write I/Os go
directly into backing device even the cache device is clean.

To avoid the above situation, this patch uses a quite conservative way
to fix: if 'c->gc_stats.in_use > CUTOFF_CACHE_ADD' happens, only wakes
up garbage collection thread when the whole cache device is clean.

Before the fix, the writes-always-bypass situation happens after 10+
hours write I/O pressure on 512GB Intel optane memory which acts as
cache device. After this fix, such situation doesn't happen after 36+
hours testing.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/request.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 83d112bd2b1c..af345dc6fde1 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -369,10 +369,24 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
 	struct io *i;
 
 	if (test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags) ||
-	    c->gc_stats.in_use > CUTOFF_CACHE_ADD ||
 	    (bio_op(bio) == REQ_OP_DISCARD))
 		goto skip;
 
+	if (c->gc_stats.in_use > CUTOFF_CACHE_ADD) {
+		/*
+		 * If cached buckets are all clean now, 'true' will be
+		 * returned and all requests will bypass the cache device.
+		 * Then c->sectors_to_gc has no chance to be negative, and
+		 * gc thread won't wake up and caching won't work forever.
+		 * Here call force_wake_up_gc() to avoid such aftermath.
+		 */
+		if (BDEV_STATE(&dc->sb) == BDEV_STATE_CLEAN &&
+		    c->gc_mark_valid)
+			force_wake_up_gc(c);
+
+		goto skip;
+	}
+
 	if (mode == CACHE_MODE_NONE ||
 	    (mode == CACHE_MODE_WRITEAROUND &&
 	     op_is_write(bio_op(bio))))
-- 
2.35.3


