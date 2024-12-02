Return-Path: <linux-bcache+bounces-814-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 591DD9E026E
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Dec 2024 13:48:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A97A1B2235F
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Dec 2024 11:56:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38AC01FE45D;
	Mon,  2 Dec 2024 11:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oKxdRH1Q";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KE0dzF34";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oKxdRH1Q";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KE0dzF34"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDB917E;
	Mon,  2 Dec 2024 11:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733140609; cv=none; b=PmAdw2ZSI7o15MEeqHlNHPOn/YPc7Qi/zW6C+1wG7nigutF7cDKs1//n93kzva+Tt0Xmt1M1STfycjy8UvoDrlMXEX8gAfEK2DjWfju14H644BCjGklt/L988xzOVOdPw9JBX5ET+KI4oLMt248KOuMPSJelB7TKD7NnJKCCzEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733140609; c=relaxed/simple;
	bh=QvziMC894iGHTfuFqaLrvaUFZqlQA19Q2VMj3BQkr6U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YQRkv85ZbYcs24wE65DOilgQBP6PHo3ZBB92bOG+Uy6gFEkt18ceV4lH6DT1tKfCD5tEHc4YwSqoCUOMOL+NipzsX1KK5ztSAoFv+OUPnS0zHlQgl7NVPL9ndKpOnJrZ8BrXXZNgYbVNyVIWriw10YGY6NdcEvsjyumRFxlmog4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oKxdRH1Q; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KE0dzF34; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oKxdRH1Q; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KE0dzF34; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from suse-arm.lan (unknown [10.149.192.130])
	by smtp-out1.suse.de (Postfix) with ESMTP id BB065211C4;
	Mon,  2 Dec 2024 11:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733140604; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1/nX+ri+j8OZyEGbGccgSKjseqKkWiOy08jSWLTSklU=;
	b=oKxdRH1Q8JUCfJmSgmBM1C9n3ZJ742FW7R/meBrk64bA6YdH2wkZ1EMabgIJ6FDxBgyXIb
	pN32XIXrCgRXbl8cStia7LZEoaSkZ5w+MbT6eXlS4K6ZBIXvtu23o65ITgR+09yJQTphnd
	fZR3n+qPTfKcWZIjHJ6rd6FBU7Kh0X4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733140604;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1/nX+ri+j8OZyEGbGccgSKjseqKkWiOy08jSWLTSklU=;
	b=KE0dzF34MwusyVKCjFoWdtTQKu6Alf+ERUYq3VazJeEoiIp6W2Uz/6rYYFKmOJSjrB7qY+
	c7KV9ZTK536BF0DA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733140604; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1/nX+ri+j8OZyEGbGccgSKjseqKkWiOy08jSWLTSklU=;
	b=oKxdRH1Q8JUCfJmSgmBM1C9n3ZJ742FW7R/meBrk64bA6YdH2wkZ1EMabgIJ6FDxBgyXIb
	pN32XIXrCgRXbl8cStia7LZEoaSkZ5w+MbT6eXlS4K6ZBIXvtu23o65ITgR+09yJQTphnd
	fZR3n+qPTfKcWZIjHJ6rd6FBU7Kh0X4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733140604;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1/nX+ri+j8OZyEGbGccgSKjseqKkWiOy08jSWLTSklU=;
	b=KE0dzF34MwusyVKCjFoWdtTQKu6Alf+ERUYq3VazJeEoiIp6W2Uz/6rYYFKmOJSjrB7qY+
	c7KV9ZTK536BF0DA==
From: Coly Li <colyli@suse.de>
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org,
	linux-block@vger.kernel.org,
	Liequan Che <cheliequan@inspur.com>,
	stable@vger.kernel.org,
	Zheng Wang <zyytlz.wz@163.com>,
	Mingzhe Zou <mingzhe.zou@easystack.cn>,
	Coly Li <colyli@suse.de>
Subject: [PATCH] bcache: revert replacing IS_ERR_OR_NULL with IS_ERR again
Date: Mon,  2 Dec 2024 19:56:38 +0800
Message-ID: <20241202115638.28957-1-colyli@suse.de>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_COUNT_ZERO(0.00)[0];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,inspur.com,163.com,easystack.cn,suse.de];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	URIBL_BLOCKED(0.00)[suse.de:mid,suse.de:email,suse-arm.lan:helo,inspur.com:email,easystack.cn:email];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[163.com]
X-Spam-Flag: NO
X-Spam-Level: 

From: Liequan Che <cheliequan@inspur.com>

Commit 028ddcac477b ("bcache: Remove unnecessary NULL point check in
node allocations") leads a NULL pointer deference in cache_set_flush().

1721         if (!IS_ERR_OR_NULL(c->root))
1722                 list_add(&c->root->list, &c->btree_cache);

From the above code in cache_set_flush(), if previous registration code
fails before allocating c->root, it is possible c->root is NULL as what
it is initialized. __bch_btree_node_alloc() never returns NULL but
c->root is possible to be NULL at above line 1721.

This patch replaces IS_ERR() by IS_ERR_OR_NULL() to fix this.

Fixes: 028ddcac477b ("bcache: Remove unnecessary NULL point check in node allocations")
Signed-off-by: Liequan Che <cheliequan@inspur.com>
Cc: stable@vger.kernel.org
Cc: Zheng Wang <zyytlz.wz@163.com>
Reviewed-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index e7abfdd77c3b..e42f1400cea9 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1718,7 +1718,7 @@ static CLOSURE_CALLBACK(cache_set_flush)
 	if (!IS_ERR_OR_NULL(c->gc_thread))
 		kthread_stop(c->gc_thread);
 
-	if (!IS_ERR(c->root))
+	if (!IS_ERR_OR_NULL(c->root))
 		list_add(&c->root->list, &c->btree_cache);
 
 	/*
-- 
2.47.1


