Return-Path: <linux-bcache+bounces-11-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 853697F0B94
	for <lists+linux-bcache@lfdr.de>; Mon, 20 Nov 2023 06:26:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EF7DCB207CE
	for <lists+linux-bcache@lfdr.de>; Mon, 20 Nov 2023 05:26:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 273F51FAD;
	Mon, 20 Nov 2023 05:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="uR40Crvt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9ojSMYtD"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED87D8;
	Sun, 19 Nov 2023 21:26:21 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id E72CB218EE;
	Mon, 20 Nov 2023 05:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1700457979; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wEyttQhlG/fqThqqLMN+xqZGDxU7a6EZ31kO3DhpKq0=;
	b=uR40CrvtMEYZnbZrQQknHreMat697/jzHKdepSKtU0z4IZZ1mUoW78jrgBHxAMz0LfNyJv
	nnu2WURaRlf2mJZlpMUsIaP6di7fq7Sw0dTFyGBYSkXKj9pokpGWE72894cnAiv19g6PCy
	Qs8bSrDbQKHNH1221HjAbSo7y299s6U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1700457979;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wEyttQhlG/fqThqqLMN+xqZGDxU7a6EZ31kO3DhpKq0=;
	b=9ojSMYtDkkEutzTPXcZdRa4NA2SJ0CpY7ulQXHjooVQ0cTcP46PwKPa1bCEuQg6YidIXLk
	6866GK4axYJLZxAA==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
	by relay2.suse.de (Postfix) with ESMTP id 775F62D3C8;
	Mon, 20 Nov 2023 05:26:17 +0000 (UTC)
From: Coly Li <colyli@suse.de>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	Mingzhe Zou <mingzhe.zou@easystack.cn>,
	stable@vger.kernel.org,
	Coly Li <colyli@suse.de>
Subject: [PATCH 05/10] bcache: fixup init dirty data errors
Date: Mon, 20 Nov 2023 13:24:58 +0800
Message-Id: <20231120052503.6122-6-colyli@suse.de>
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
X-Spamd-Bar: ++++++++++++++++++++++
Authentication-Results: smtp-out1.suse.de;
	dkim=none;
	dmarc=none;
	spf=softfail (smtp-out1.suse.de: 149.44.160.134 is neither permitted nor denied by domain of colyli@suse.de) smtp.mailfrom=colyli@suse.de
X-Rspamd-Server: rspamd1
X-Spamd-Result: default: False [22.06 / 50.00];
	 ARC_NA(0.00)[];
	 BAYES_SPAM(0.07)[58.45%];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 NEURAL_SPAM_SHORT(3.00)[1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 DMARC_NA(1.20)[suse.de];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 R_SPF_SOFTFAIL(4.60)[~all:c];
	 RCPT_COUNT_FIVE(0.00)[6];
	 TO_MATCH_ENVRCPT_SOME(0.00)[];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 MX_GOOD(-0.01)[];
	 NEURAL_SPAM_LONG(3.50)[1.000];
	 MID_CONTAINS_FROM(1.00)[];
	 RWL_MAILSPIKE_GOOD(-1.00)[149.44.160.134:from];
	 VIOLATED_DIRECT_SPF(3.50)[];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 RCVD_NO_TLS_LAST(0.10)[];
	 FROM_EQ_ENVFROM(0.00)[];
	 R_DKIM_NA(2.20)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_COUNT_TWO(0.00)[2]
X-Spam-Score: 22.06
X-Rspamd-Queue-Id: E72CB218EE

From: Mingzhe Zou <mingzhe.zou@easystack.cn>

We found that after long run, the dirty_data of the bcache device
will have errors. This error cannot be eliminated unless re-register.

We also found that reattach after detach, this error can accumulate.

In bch_sectors_dirty_init(), all inode <= d->id keys will be recounted
again. This is wrong, we only need to count the keys of the current
device.

Fixes: b144e45fc576 ("bcache: make bch_sectors_dirty_init() to be multithreaded")
Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/writeback.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index c3e872e0a6f2..77fb72ac6b81 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -991,8 +991,11 @@ void bch_sectors_dirty_init(struct bcache_device *d)
 		op.count = 0;
 
 		for_each_key_filter(&c->root->keys,
-				    k, &iter, bch_ptr_invalid)
+				    k, &iter, bch_ptr_invalid) {
+			if (KEY_INODE(k) != op.inode)
+				continue;
 			sectors_dirty_init_fn(&op.op, c->root, k);
+		}
 
 		rw_unlock(0, c->root);
 		return;
-- 
2.35.3


