Return-Path: <linux-bcache+bounces-501-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 892DE8D1AB7
	for <lists+linux-bcache@lfdr.de>; Tue, 28 May 2024 14:09:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E4D11F24028
	for <lists+linux-bcache@lfdr.de>; Tue, 28 May 2024 12:09:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 485F416C87F;
	Tue, 28 May 2024 12:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NwlLummx";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="j/hDu81B";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NwlLummx";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="j/hDu81B"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B330E161321;
	Tue, 28 May 2024 12:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716898175; cv=none; b=nKcm5BwyUGORmlzPsL3H29uXpfb0GhV0xBI+XK5lWXaqTqoQjb/Vt441nKkLC2IGXS1iOLuZpYiP/vA/V+R5Uo6Riq41zq4WzhZpvlvbK5Wj0t7xzM9JpjiS4vapFCojQq5NuoRy0AaFK0pxoZGNCeqIsKOfETyixnTzWJ1ZG4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716898175; c=relaxed/simple;
	bh=8H7BV9/eeO5tjatJqOyVQkKquqg19jk66pQrSgWPS3A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nUoox60XqDaEmSEueZ/ZxWn3OQjFEASNdOMUJiXkoTJ0tN74fR++iS+zeCFnVz5GnoE/cVlxSTBGoRYu3+3cIEavD8asL/nGQFcFpShyfH6MsRG+eGTZn8/LIemI2Hzn4/nZbEKUjuFjxy7/W4j9Z7/KHMk6js+3A8Kcr8inqYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NwlLummx; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=j/hDu81B; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NwlLummx; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=j/hDu81B; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from suse-arm.lan (unknown [10.149.192.130])
	by smtp-out2.suse.de (Postfix) with ESMTP id 407B020287;
	Tue, 28 May 2024 12:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716898172; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X+3f9q1shIhYWg9rVbKhSKne37I38ok0u2p9d2o7S2s=;
	b=NwlLummxCmct8INs3CIGrwAZ433/cFyOkNry0YkZ3ZqBpSfC68cIPv2gZvrJ3KRKfXRYOa
	7igfmlgUfSKAbv4/bMTl6iwQI22t++VPhLeLEqxDVodeN2/N+3SdhTvwNVDw3uUamYc1iV
	MR/TtVRpw5Dvly58sMYuzcfWJeAiSIs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716898172;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X+3f9q1shIhYWg9rVbKhSKne37I38ok0u2p9d2o7S2s=;
	b=j/hDu81B/mYHHXPYUJ0gu2L1vC1fUb/th9gCREccG5Y7yKndNGzn76P4UnWxEJJl8pMOcb
	eUdbIH+JsgK62oCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716898172; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X+3f9q1shIhYWg9rVbKhSKne37I38ok0u2p9d2o7S2s=;
	b=NwlLummxCmct8INs3CIGrwAZ433/cFyOkNry0YkZ3ZqBpSfC68cIPv2gZvrJ3KRKfXRYOa
	7igfmlgUfSKAbv4/bMTl6iwQI22t++VPhLeLEqxDVodeN2/N+3SdhTvwNVDw3uUamYc1iV
	MR/TtVRpw5Dvly58sMYuzcfWJeAiSIs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716898172;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X+3f9q1shIhYWg9rVbKhSKne37I38ok0u2p9d2o7S2s=;
	b=j/hDu81B/mYHHXPYUJ0gu2L1vC1fUb/th9gCREccG5Y7yKndNGzn76P4UnWxEJJl8pMOcb
	eUdbIH+JsgK62oCg==
From: Coly Li <colyli@suse.de>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	Coly Li <colyli@suse.de>
Subject: [PATCH 3/3] bcache: code cleanup in __bch_bucket_alloc_set()
Date: Tue, 28 May 2024 20:09:14 +0800
Message-Id: <20240528120914.28705-4-colyli@suse.de>
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
	NEURAL_HAM_SHORT(-0.20)[-0.978];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_ZERO(0.00)[0];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email]

In __bch_bucket_alloc_set() the lines after lable 'err:' indeed do
nothing useful after multiple cache devices are removed from bcache
code. This cleanup patch drops the useless code to save a bit CPU
cycles.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/alloc.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 32a46343097d..48ce750bf70a 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -498,8 +498,8 @@ int __bch_bucket_alloc_set(struct cache_set *c, unsigned int reserve,
 
 	ca = c->cache;
 	b = bch_bucket_alloc(ca, reserve, wait);
-	if (b == -1)
-		goto err;
+	if (b < 0)
+		return -1;
 
 	k->ptr[0] = MAKE_PTR(ca->buckets[b].gen,
 			     bucket_to_sector(c, b),
@@ -508,10 +508,6 @@ int __bch_bucket_alloc_set(struct cache_set *c, unsigned int reserve,
 	SET_KEY_PTRS(k, 1);
 
 	return 0;
-err:
-	bch_bucket_free(c, k);
-	bkey_put(c, k);
-	return -1;
 }
 
 int bch_bucket_alloc_set(struct cache_set *c, unsigned int reserve,
-- 
2.35.3


