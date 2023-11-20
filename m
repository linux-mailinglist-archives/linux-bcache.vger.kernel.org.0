Return-Path: <linux-bcache+bounces-17-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A94337F0BB0
	for <lists+linux-bcache@lfdr.de>; Mon, 20 Nov 2023 06:45:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 399B6B209B6
	for <lists+linux-bcache@lfdr.de>; Mon, 20 Nov 2023 05:45:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 596BC53AC;
	Mon, 20 Nov 2023 05:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="s4vFZ0Ds";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FbMsC416"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D42137;
	Sun, 19 Nov 2023 21:44:45 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 0A510218EE;
	Mon, 20 Nov 2023 05:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1700459084; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W+WSQ1aEa1mhWOIBOXLLunnldrkZuwfd1DN7KTeJBL8=;
	b=s4vFZ0DseDktWCG4UfKfu41AnQI/0iqdGTKRP19Keu1S28sqE5HoP8QNAG4c5HgxlyY7J6
	akGFxTePM67tSuv/Ztxx4cPbVD5FYcYGaYSmx2IjatWp/zBKoYNICLeSOiSJhD6P4u1m+g
	LvntIrkT7gP1M/GOz3STZzoS3U7+vzM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1700459084;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W+WSQ1aEa1mhWOIBOXLLunnldrkZuwfd1DN7KTeJBL8=;
	b=FbMsC416nRcpfbgRkjpBWik6osVTQRyFz0enNsvf+DIpGbTLp7tolcs1C3QEmLtizUJqIH
	ZvJaJQ9MI0O3XlCQ==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
	by relay2.suse.de (Postfix) with ESMTP id 009222C433;
	Mon, 20 Nov 2023 05:26:14 +0000 (UTC)
From: Coly Li <colyli@suse.de>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	Rand Deeb <rand.sec96@gmail.com>,
	stable@vger.kernel.org,
	Coly Li <colyli@suse.de>
Subject: [PATCH 04/10] bcache: prevent potential division by zero error
Date: Mon, 20 Nov 2023 13:24:57 +0800
Message-Id: <20231120052503.6122-5-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231120052503.6122-1-colyli@suse.de>
References: <20231120052503.6122-1-colyli@suse.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++++++++++++++++++++
Authentication-Results: smtp-out1.suse.de;
	dkim=none;
	dmarc=none;
	spf=softfail (smtp-out1.suse.de: 149.44.160.134 is neither permitted nor denied by domain of colyli@suse.de) smtp.mailfrom=colyli@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [23.49 / 50.00];
	 GREYLIST(0.00)[pass,body];
	 TO_DN_SOME(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 RWL_MAILSPIKE_GOOD(-1.00)[149.44.160.134:from];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 R_SPF_SOFTFAIL(4.60)[~all:c];
	 RCPT_COUNT_FIVE(0.00)[6];
	 MX_GOOD(-0.01)[];
	 RCVD_NO_TLS_LAST(0.10)[];
	 FROM_EQ_ENVFROM(0.00)[];
	 R_DKIM_NA(2.20)[];
	 MIME_TRACE(0.00)[0:+];
	 ARC_NA(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 NEURAL_SPAM_SHORT(3.00)[1.000];
	 TAGGED_RCPT(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 DMARC_NA(1.20)[suse.de];
	 TO_MATCH_ENVRCPT_SOME(0.00)[];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 VIOLATED_DIRECT_SPF(3.50)[];
	 NEURAL_SPAM_LONG(3.50)[1.000];
	 MID_CONTAINS_FROM(1.00)[];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,suse.de];
	 RCVD_COUNT_TWO(0.00)[2];
	 SUSPICIOUS_RECIPS(1.50)[]
X-Spam-Score: 23.49
X-Rspamd-Queue-Id: 0A510218EE
X-Spam: Yes

From: Rand Deeb <rand.sec96@gmail.com>

In SHOW(), the variable 'n' is of type 'size_t.' While there is a
conditional check to verify that 'n' is not equal to zero before
executing the 'do_div' macro, concerns arise regarding potential
division by zero error in 64-bit environments.

The concern arises when 'n' is 64 bits in size, greater than zero, and
the lower 32 bits of it are zeros. In such cases, the conditional check
passes because 'n' is non-zero, but the 'do_div' macro casts 'n' to
'uint32_t,' effectively truncating it to its lower 32 bits.
Consequently, the 'n' value becomes zero.

To fix this potential division by zero error and ensure precise
division handling, this commit replaces the 'do_div' macro with
div64_u64(). div64_u64() is designed to work with 64-bit operands,
guaranteeing that division is performed correctly.

This change enhances the robustness of the code, ensuring that division
operations yield accurate results in all scenarios, eliminating the
possibility of division by zero, and improving compatibility across
different 64-bit environments.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Rand Deeb <rand.sec96@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 45d8af755de6..a438efb66069 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -1104,7 +1104,7 @@ SHOW(__bch_cache)
 			sum += INITIAL_PRIO - cached[i];
 
 		if (n)
-			do_div(sum, n);
+			sum = div64_u64(sum, n);
 
 		for (i = 0; i < ARRAY_SIZE(q); i++)
 			q[i] = INITIAL_PRIO - cached[n * (i + 1) /
-- 
2.35.3


