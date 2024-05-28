Return-Path: <linux-bcache+bounces-498-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 770128D1AB2
	for <lists+linux-bcache@lfdr.de>; Tue, 28 May 2024 14:09:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 05A04B25A1F
	for <lists+linux-bcache@lfdr.de>; Tue, 28 May 2024 12:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 074CC16C87C;
	Tue, 28 May 2024 12:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XUU8eW41";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Z2mvBaeo";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XUU8eW41";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Z2mvBaeo"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2759971753;
	Tue, 28 May 2024 12:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716898169; cv=none; b=Bh5Dxa4OowKT5GO/xwBvmcTHbbB8NX8TjN4kV/5qu+LD3nLu8nAdanY0iAB2V7Fj19m7YkClEwUEze8L4zo6V+0eKWbrprkRnXSvNJ+lVxPThkePfGOO9OQtYAMR3pvDOcj/VAvhaieEa/DfPTtaxMf/SOQ5rbFcF5ww4hOYJ8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716898169; c=relaxed/simple;
	bh=pLLXoGthuWsb1O69OXzVMHtngVE1DlSbgs37f3KpI6E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OrLTJH9KKJr+J1C08yZylTN51SJSoTxkehP0gphOKwvPf6wOXWsPC3h6d++eDEyvmNcuRzjatIIfvS1o8sVOcIuyTVv3RlyqEBdOOFwKQuoylNQkv9aEXA/qeV/fjN2JkLARPGEqgRIelz9sKvbNjbye/0ippm4HgcYhGrA4Xdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XUU8eW41; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Z2mvBaeo; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XUU8eW41; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Z2mvBaeo; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from suse-arm.lan (unknown [10.149.192.130])
	by smtp-out2.suse.de (Postfix) with ESMTP id 7D5B520287;
	Tue, 28 May 2024 12:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716898164; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=jLZnuGn6/os5p3D/vRiGhQorGzmhNB86v186IlLPsFU=;
	b=XUU8eW41yDV9bHTUHb3GGJje+d1G6FCok791uwNR7Y1VQgLeuT1LhPOKPnXiMIVGzURxyn
	oB3NG2n9XRDgQvfLFLua0X03vN+M9wPubfGoTEDVnL9sh36ZBYGaxTzt+0uJguHOhweSOP
	V2GGo+9XgAKTlvvpBj8JMRpkUGTK5iQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716898164;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=jLZnuGn6/os5p3D/vRiGhQorGzmhNB86v186IlLPsFU=;
	b=Z2mvBaeolH/QnYxd/7+aA6/ok95WpYHJWhptVenFz/0yLDVdW6vKTj3j/qx0FH7zuLPCeb
	Le9aEvJZr0SOIuBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716898164; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=jLZnuGn6/os5p3D/vRiGhQorGzmhNB86v186IlLPsFU=;
	b=XUU8eW41yDV9bHTUHb3GGJje+d1G6FCok791uwNR7Y1VQgLeuT1LhPOKPnXiMIVGzURxyn
	oB3NG2n9XRDgQvfLFLua0X03vN+M9wPubfGoTEDVnL9sh36ZBYGaxTzt+0uJguHOhweSOP
	V2GGo+9XgAKTlvvpBj8JMRpkUGTK5iQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716898164;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=jLZnuGn6/os5p3D/vRiGhQorGzmhNB86v186IlLPsFU=;
	b=Z2mvBaeolH/QnYxd/7+aA6/ok95WpYHJWhptVenFz/0yLDVdW6vKTj3j/qx0FH7zuLPCeb
	Le9aEvJZr0SOIuBg==
From: Coly Li <colyli@suse.de>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	Coly Li <colyli@suse.de>
Subject: [PATCH 0/3] bcache-6.10 20240528 
Date: Tue, 28 May 2024 20:09:11 +0800
Message-Id: <20240528120914.28705-1-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	SUBJECT_ENDS_SPACES(0.50)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.982];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_COUNT_ZERO(0.00)[0];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[]

Hi Jens,

This series is just for the patch from Dongsheng Yang, due to more
testing needed, it comes after the first wave.

Dongsheng's patch helps to improve the latency of cache space
allocation. This patch has been shipped in product more than one year
by his team. Robert Pang from Google introduces this patch has been
tested inside Google with quite extended hardware configurations. Eric
Wheeler also deploys this patch in his production for 1+ months.

So far there is no issue reported for this patch, except for a bug in
existed code and easier to be trigger by Dongsheng's patch. This is why
my first patch is composed. Another patch from me is just a code
cleanup cought my eyes during the fix.

Please consider to take them, and thank you in advance.

Coly Li
---

Coly Li (2):
  bcache: call force_wake_up_gc() if necessary in check_should_bypass()
  bcache: code cleanup in __bch_bucket_alloc_set()

Dongsheng Yang (1):
  bcache: allow allocator to invalidate bucket in gc

 drivers/md/bcache/alloc.c   | 21 +++++++--------------
 drivers/md/bcache/bcache.h  |  1 +
 drivers/md/bcache/btree.c   |  7 ++++++-
 drivers/md/bcache/request.c | 16 +++++++++++++++-
 4 files changed, 29 insertions(+), 16 deletions(-)

-- 
2.35.3


