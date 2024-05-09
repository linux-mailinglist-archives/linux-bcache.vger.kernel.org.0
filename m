Return-Path: <linux-bcache+bounces-430-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 54B7B8C08EC
	for <lists+linux-bcache@lfdr.de>; Thu,  9 May 2024 03:11:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 09F011F21E10
	for <lists+linux-bcache@lfdr.de>; Thu,  9 May 2024 01:11:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EB6613A3F0;
	Thu,  9 May 2024 01:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sZ85wdL7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gNzY3sGd";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sZ85wdL7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gNzY3sGd"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC5013A3E7;
	Thu,  9 May 2024 01:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715217087; cv=none; b=QIN/eA2kxI0SDdBPr7pTO9p+eE7moliWCQTNT7wx8OJnry4YL1E6sXRTu5ItfINEacCGU4vZ3Zc5LfXtLnNGu9+s/qy63fhDV8bwnPX7RveUONKkKEKlraNRaHh8tXBhO385Es+DxbeJHLhsC/6PNHqlPgGhllLjtCYUAGnyWRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715217087; c=relaxed/simple;
	bh=GfA3oed5U4Ly4zVHYc64Hjt319Ykdp+43mkwmkQXEjA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jZraoFp+DUMCTUEzqDwmafSsRxju1vdFbZjgcUDDzWOWM/0X2sFXC+8WeOR1F0lT41Sc5LDsqbAbpWzZ0R9aAm5hOM881GBMaD0LWIRloxzZMHwyqcybjVVLS+0t203YCTX2oBUMWSpddm4845dOKcpql6FjcCHgKTshR1lf2KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sZ85wdL7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gNzY3sGd; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sZ85wdL7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gNzY3sGd; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from suse-arm.lan (unknown [10.149.192.130])
	by smtp-out1.suse.de (Postfix) with ESMTP id 729003790F;
	Thu,  9 May 2024 01:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1715217084; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DKZpzeIXN646Ee4rgH3JskCQeCbuyVVT0LKjTQ7YC9M=;
	b=sZ85wdL7YTpFVBcYWUiApn9px0Z5r7w3NMlj7XBFFGNkPJAsfl+L4TRGVWFDH5pAW7V6nz
	mtFa3lbcHY0hhjN8XRzumMy5Jaa1qEsB8F62G0MZHELoNSWBvVwLBgbl+ZubcrdjwvFQzq
	BCuAXiwCx4C/GtKiotRUvunx8oBm4bU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1715217084;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DKZpzeIXN646Ee4rgH3JskCQeCbuyVVT0LKjTQ7YC9M=;
	b=gNzY3sGdtRk6SymtkctZNkS3Rcehqm6JkuyOCrT0hPo73/rznCz/j4+d+Ht0cNIC0bYEC4
	uhEItWcyZrNpe3Bg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1715217084; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DKZpzeIXN646Ee4rgH3JskCQeCbuyVVT0LKjTQ7YC9M=;
	b=sZ85wdL7YTpFVBcYWUiApn9px0Z5r7w3NMlj7XBFFGNkPJAsfl+L4TRGVWFDH5pAW7V6nz
	mtFa3lbcHY0hhjN8XRzumMy5Jaa1qEsB8F62G0MZHELoNSWBvVwLBgbl+ZubcrdjwvFQzq
	BCuAXiwCx4C/GtKiotRUvunx8oBm4bU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1715217084;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DKZpzeIXN646Ee4rgH3JskCQeCbuyVVT0LKjTQ7YC9M=;
	b=gNzY3sGdtRk6SymtkctZNkS3Rcehqm6JkuyOCrT0hPo73/rznCz/j4+d+Ht0cNIC0bYEC4
	uhEItWcyZrNpe3Bg==
From: Coly Li <colyli@suse.de>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Coly Li <colyli@suse.de>
Subject: [PATCH 1/2] bcache: Remove usage of the deprecated ida_simple_xx() API
Date: Thu,  9 May 2024 09:11:16 +0800
Message-Id: <20240509011117.2697-2-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240509011117.2697-1-colyli@suse.de>
References: <20240509011117.2697-1-colyli@suse.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	REPLY(-4.00)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	BAYES_HAM(-0.00)[36.51%];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_ZERO(0.00)[0];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,wanadoo.fr,suse.de];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	FREEMAIL_ENVRCPT(0.00)[wanadoo.fr]
X-Spam-Score: -3.80
X-Spam-Flag: NO

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

Note that the upper limit of ida_simple_get() is exclusive, but the one of
ida_alloc_max() is inclusive. So a -1 has been added when needed.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 330bcd9ea4a9..38e41039edb8 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -881,8 +881,8 @@ static void bcache_device_free(struct bcache_device *d)
 		bcache_device_detach(d);
 
 	if (disk) {
-		ida_simple_remove(&bcache_device_idx,
-				  first_minor_to_idx(disk->first_minor));
+		ida_free(&bcache_device_idx,
+			 first_minor_to_idx(disk->first_minor));
 		put_disk(disk);
 	}
 
@@ -940,8 +940,8 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 	if (!d->full_dirty_stripes)
 		goto out_free_stripe_sectors_dirty;
 
-	idx = ida_simple_get(&bcache_device_idx, 0,
-				BCACHE_DEVICE_IDX_MAX, GFP_KERNEL);
+	idx = ida_alloc_max(&bcache_device_idx, BCACHE_DEVICE_IDX_MAX - 1,
+			    GFP_KERNEL);
 	if (idx < 0)
 		goto out_free_full_dirty_stripes;
 
@@ -986,7 +986,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 out_bioset_exit:
 	bioset_exit(&d->bio_split);
 out_ida_remove:
-	ida_simple_remove(&bcache_device_idx, idx);
+	ida_free(&bcache_device_idx, idx);
 out_free_full_dirty_stripes:
 	kvfree(d->full_dirty_stripes);
 out_free_stripe_sectors_dirty:
-- 
2.35.3


