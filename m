Return-Path: <linux-bcache+bounces-500-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43B3F8D1AB5
	for <lists+linux-bcache@lfdr.de>; Tue, 28 May 2024 14:09:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE6FC28416A
	for <lists+linux-bcache@lfdr.de>; Tue, 28 May 2024 12:09:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0058716D333;
	Tue, 28 May 2024 12:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fNzyeYgL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0XbKw6xm";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fNzyeYgL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0XbKw6xm"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE3C16C6BF;
	Tue, 28 May 2024 12:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716898173; cv=none; b=gmUUBiwbrf9nm6jAJ7D9NpN/RJoeWO0+qSM9fqNlpZ52kookMbaGhDmtdsIEd15sWsupBSTK57B7rmDi1Kb3JBRX7KFL4AtFKDGYxs7R4ZO20yWsYkCxgyRncZeJL44B3xSQ5mWDMq/P2imUQozFTCbOvlKyTFLc47lJtQKIHUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716898173; c=relaxed/simple;
	bh=nhEyW+xxyANKL/q4Lh5FO00xmvZp5ITPXPEhC/qKC+U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R3SpMagvYI3I0XY3bGOL6zQXJPSJBkhkRupdUUxUF3EW2kJQ0IFvqcEp2PvuFSiFeb2j+teGi+JWKX4LIXJ7i8BqtOGMpicONiWpdOUcm4dbhNAW6YCZItuHyLEicEblHyZNickKoW3dKomoRNbGSf7YsK7HkhsudZ90nOXiYjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fNzyeYgL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0XbKw6xm; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fNzyeYgL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0XbKw6xm; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from suse-arm.lan (unknown [10.149.192.130])
	by smtp-out2.suse.de (Postfix) with ESMTP id DE62420288;
	Tue, 28 May 2024 12:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716898169; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ecu6l64rYKbloNPdAo4aXfsHx7rdsvlKjgwucOmGwr4=;
	b=fNzyeYgLtrIkkSJVCezicad1Rt0MerBfp8hPeRBvbRlR6znSg75ncI6e68bAZZ+aIgtrkD
	vl6to/iq+ETwPXAhdPX9/aC/kn+gjxAXkx8xCVgyzt69UNZ04ZsiGCS4Qj8DwvvfQ5JDat
	0NeVJKCiWczqUGCXSVtG51ADZegS5QM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716898169;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ecu6l64rYKbloNPdAo4aXfsHx7rdsvlKjgwucOmGwr4=;
	b=0XbKw6xmoqytsJwKs+FR5Gb9T6l3lLUcVr7RUaDcrw7x7w49fMhy7BMnCTUacySNNW1wCZ
	enRlqo5EaaX+HgAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716898169; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ecu6l64rYKbloNPdAo4aXfsHx7rdsvlKjgwucOmGwr4=;
	b=fNzyeYgLtrIkkSJVCezicad1Rt0MerBfp8hPeRBvbRlR6znSg75ncI6e68bAZZ+aIgtrkD
	vl6to/iq+ETwPXAhdPX9/aC/kn+gjxAXkx8xCVgyzt69UNZ04ZsiGCS4Qj8DwvvfQ5JDat
	0NeVJKCiWczqUGCXSVtG51ADZegS5QM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716898169;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ecu6l64rYKbloNPdAo4aXfsHx7rdsvlKjgwucOmGwr4=;
	b=0XbKw6xmoqytsJwKs+FR5Gb9T6l3lLUcVr7RUaDcrw7x7w49fMhy7BMnCTUacySNNW1wCZ
	enRlqo5EaaX+HgAw==
From: Coly Li <colyli@suse.de>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	Coly Li <colyli@suse.de>
Subject: [PATCH 2/3] bcache: call force_wake_up_gc() if necessary in check_should_bypass()
Date: Tue, 28 May 2024 20:09:13 +0800
Message-Id: <20240528120914.28705-3-colyli@suse.de>
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
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.980];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_ZERO(0.00)[0];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email]
X-Spam-Score: -6.80
X-Spam-Flag: NO

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


