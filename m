Return-Path: <linux-bcache+bounces-491-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 64F268D0982
	for <lists+linux-bcache@lfdr.de>; Mon, 27 May 2024 19:47:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C4551F221FC
	for <lists+linux-bcache@lfdr.de>; Mon, 27 May 2024 17:47:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11E9F15EFD8;
	Mon, 27 May 2024 17:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mlWh+vd5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wsb/qLtO";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mlWh+vd5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wsb/qLtO"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606BC15E5A0
	for <linux-bcache@vger.kernel.org>; Mon, 27 May 2024 17:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716832065; cv=none; b=ELhHtsoEnRT3BWMkEGur7/KbNwdscno+8UdeoCqgl4Lw6Tt0cuh2737UyaPt/gmkFHwgO86iEXCPQnoVAlQpTBdT8f1JxSldzh8dql4FAnDxc/NJHEoc0ltmdlsRSVADNOTcczNk7bS/4Mdfh5jY2ufg7J0ydyM1hw2SqA7+dyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716832065; c=relaxed/simple;
	bh=8H7BV9/eeO5tjatJqOyVQkKquqg19jk66pQrSgWPS3A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ar7QClca0qaD0N+JguVSqJy5awm4eDkwT20LRAnun8VcV+jRHqK1KRScajhIyaasWemDGxNwGEVbF+rz/ddk614+JJjFkOSLm7QqoJp/3ffq+G11qnzrDgDqnWIEt1J5OLUrqL3GvrWtnTlS7XnpFaabdSGdjTDu5CUxIytIgJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mlWh+vd5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wsb/qLtO; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mlWh+vd5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wsb/qLtO; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from suse-arm.lan (unknown [10.149.192.130])
	by smtp-out2.suse.de (Postfix) with ESMTP id 7E4201FE8C;
	Mon, 27 May 2024 17:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716832061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X+3f9q1shIhYWg9rVbKhSKne37I38ok0u2p9d2o7S2s=;
	b=mlWh+vd5yIhtINM3ls8fNyFLNX5cURluuAYRAsq3hcplxtNzOgE6tzBp24QNwGD23iHyK9
	uOH8f7nP9GDTFDFTevUxxTpSdcTqzHNPzLooIjBEHPHMv5NYjYd+IOtXbKnUGEI0iXsc4a
	xRqIhKDQCfVlsisoXOzrTmXd5oviFlQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716832061;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X+3f9q1shIhYWg9rVbKhSKne37I38ok0u2p9d2o7S2s=;
	b=wsb/qLtO/PSHngd1rtiLr/w0kgsxr4dmWxNUMknofT7uWgB+91cn8BKA1r3Esagjd0c0Ja
	ahJk/UlV52Hq1fAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716832061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X+3f9q1shIhYWg9rVbKhSKne37I38ok0u2p9d2o7S2s=;
	b=mlWh+vd5yIhtINM3ls8fNyFLNX5cURluuAYRAsq3hcplxtNzOgE6tzBp24QNwGD23iHyK9
	uOH8f7nP9GDTFDFTevUxxTpSdcTqzHNPzLooIjBEHPHMv5NYjYd+IOtXbKnUGEI0iXsc4a
	xRqIhKDQCfVlsisoXOzrTmXd5oviFlQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716832061;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X+3f9q1shIhYWg9rVbKhSKne37I38ok0u2p9d2o7S2s=;
	b=wsb/qLtO/PSHngd1rtiLr/w0kgsxr4dmWxNUMknofT7uWgB+91cn8BKA1r3Esagjd0c0Ja
	ahJk/UlV52Hq1fAw==
From: Coly Li <colyli@suse.de>
To: linux-bcache@vger.kernel.org
Cc: Coly Li <colyli@suse.de>
Subject: [PATCH 3/3] bcache: code cleanup in __bch_bucket_alloc_set()
Date: Tue, 28 May 2024 01:47:33 +0800
Message-Id: <20240527174733.16351-2-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240527174733.16351-1-colyli@suse.de>
References: <20240527174733.16351-1-colyli@suse.de>
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
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_ZERO(0.00)[0];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email]
X-Spam-Score: -6.80
X-Spam-Flag: NO

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


