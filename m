Return-Path: <linux-bcache+bounces-13-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C9407F0BA7
	for <lists+linux-bcache@lfdr.de>; Mon, 20 Nov 2023 06:45:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5926E1C208CD
	for <lists+linux-bcache@lfdr.de>; Mon, 20 Nov 2023 05:44:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C23814414;
	Mon, 20 Nov 2023 05:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="f9FL7Eks";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ey8/m1fP"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC13107;
	Sun, 19 Nov 2023 21:44:45 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id D01D01F74D;
	Mon, 20 Nov 2023 05:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1700459083; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j8/95pF7pHaAfL14xhyblreDCMEifIqJMqWfYMvKYvg=;
	b=f9FL7EkslsTgz6cNLc5umx+WY0anftMLsoDXlGQNkALMU5LlqjzWRZXooqkgHZtpPjFpr0
	HWeorSU4Yt9x3sg5QXSHgF+fKgMLiv6eK37ixUxPvttszt6B5bpdc54lqLIZAbn46/5Amr
	A+NI3lC6I0Tk1nje8Jwc0yc4FZg/lqU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1700459083;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j8/95pF7pHaAfL14xhyblreDCMEifIqJMqWfYMvKYvg=;
	b=ey8/m1fPRinw/a5fWUSPa8rs0Lm6asBJZ97f10JMDd57hqUbRktcj4zFLFNLAJRImBdtcx
	exJMMPRcSw0G0tAw==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
	by relay2.suse.de (Postfix) with ESMTP id 6B6AB2CFCE;
	Mon, 20 Nov 2023 05:26:25 +0000 (UTC)
From: Coly Li <colyli@suse.de>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	Coly Li <colyli@suse.de>,
	stable@vger.kernel.org,
	Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH 08/10] bcache: replace a mistaken IS_ERR() by IS_ERR_OR_NULL() in btree_gc_coalesce()
Date: Mon, 20 Nov 2023 13:25:01 +0800
Message-Id: <20231120052503.6122-9-colyli@suse.de>
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
X-Spamd-Bar: +++++++++++++++++++++++++++
Authentication-Results: smtp-out2.suse.de;
	dkim=none;
	dmarc=none;
	spf=softfail (smtp-out2.suse.de: 149.44.160.134 is neither permitted nor denied by domain of colyli@suse.de) smtp.mailfrom=colyli@suse.de
X-Rspamd-Server: rspamd1
X-Spamd-Result: default: False [27.09 / 50.00];
	 BAYES_SPAM(5.10)[100.00%];
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
	 FREEMAIL_ENVRCPT(0.00)[163.com];
	 NEURAL_SPAM_SHORT(3.00)[1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 DMARC_NA(1.20)[suse.de];
	 TO_MATCH_ENVRCPT_SOME(0.00)[];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 VIOLATED_DIRECT_SPF(3.50)[];
	 NEURAL_SPAM_LONG(3.50)[1.000];
	 MID_CONTAINS_FROM(1.00)[];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FREEMAIL_CC(0.00)[vger.kernel.org,suse.de,163.com];
	 RCVD_COUNT_TWO(0.00)[2];
	 GREYLIST(0.00)[pass,body]
X-Spam-Score: 27.09
X-Rspamd-Queue-Id: D01D01F74D
X-Spam: Yes

Commit 028ddcac477b ("bcache: Remove unnecessary NULL point check in
node allocations") do the following change inside btree_gc_coalesce(),

31 @@ -1340,7 +1340,7 @@ static int btree_gc_coalesce(
32         memset(new_nodes, 0, sizeof(new_nodes));
33         closure_init_stack(&cl);
34
35 -       while (nodes < GC_MERGE_NODES && !IS_ERR_OR_NULL(r[nodes].b))
36 +       while (nodes < GC_MERGE_NODES && !IS_ERR(r[nodes].b))
37                 keys += r[nodes++].keys;
38
39         blocks = btree_default_blocks(b->c) * 2 / 3;

At line 35 the original r[nodes].b is not always allocatored from
__bch_btree_node_alloc(), and possibly initialized as NULL pointer by
caller of btree_gc_coalesce(). Therefore the change at line 36 is not
correct.

This patch replaces the mistaken IS_ERR() by IS_ERR_OR_NULL() to avoid
potential issue.

Fixes: 028ddcac477b ("bcache: Remove unnecessary NULL point check in node allocations")
Cc: stable@vger.kernel.org # 6.5+
Cc: Zheng Wang <zyytlz.wz@163.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index de8d552201dc..79f1fa4a0d55 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1368,7 +1368,7 @@ static int btree_gc_coalesce(struct btree *b, struct btree_op *op,
 	memset(new_nodes, 0, sizeof(new_nodes));
 	closure_init_stack(&cl);
 
-	while (nodes < GC_MERGE_NODES && !IS_ERR(r[nodes].b))
+	while (nodes < GC_MERGE_NODES && !IS_ERR_OR_NULL(r[nodes].b))
 		keys += r[nodes++].keys;
 
 	blocks = btree_default_blocks(b->c) * 2 / 3;
-- 
2.35.3


