Return-Path: <linux-bcache+bounces-8-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39ED27F0B8C
	for <lists+linux-bcache@lfdr.de>; Mon, 20 Nov 2023 06:26:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 610221C20336
	for <lists+linux-bcache@lfdr.de>; Mon, 20 Nov 2023 05:26:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 158091FAD;
	Mon, 20 Nov 2023 05:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lOfw8hEm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jNAOs/lA"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5653E3;
	Sun, 19 Nov 2023 21:26:08 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 3C2EF218E4;
	Mon, 20 Nov 2023 05:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1700457967; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7Qm6yCo0+3GAlOA66zHG1XQF6Yyycd87rE/chkMHYVk=;
	b=lOfw8hEmw2f3HKcfBp60ch4jLHwR442E4McKYaBqtEC3vVP26N9IuXn0IrVv6iKVuHCzTD
	1mNfgYaK2HYJxhZ0H73DOG4ke5MV+p3ySDceFjWN8UhZLL1QnQ1mPhtmBmLO23J7OZGO8p
	OpGuTbJb4SDokflcLGKjig7QKe6CtXU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1700457967;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7Qm6yCo0+3GAlOA66zHG1XQF6Yyycd87rE/chkMHYVk=;
	b=jNAOs/lA7dxqXT6S3oVhS1peoKQ9vl5wjfB53BwSpIIyOu1WUtIc6wEwEDRZKwjvfzsxwC
	yMeSVHUsqfR7y/AQ==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
	by relay2.suse.de (Postfix) with ESMTP id E52832C90E;
	Mon, 20 Nov 2023 05:26:05 +0000 (UTC)
From: Coly Li <colyli@suse.de>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	Coly Li <colyli@suse.de>
Subject: [PATCH 00/10] bcache-next 20231120
Date: Mon, 20 Nov 2023 13:24:53 +0800
Message-Id: <20231120052503.6122-1-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++++++++++++++
Authentication-Results: smtp-out1.suse.de;
	dkim=none;
	dmarc=none;
	spf=softfail (smtp-out1.suse.de: 149.44.160.134 is neither permitted nor denied by domain of colyli@suse.de) smtp.mailfrom=colyli@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [17.99 / 50.00];
	 ARC_NA(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[4];
	 TO_DN_SOME(0.00)[];
	 NEURAL_SPAM_SHORT(3.00)[1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 DMARC_NA(1.20)[suse.de];
	 R_SPF_SOFTFAIL(4.60)[~all:c];
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
X-Spam-Score: 17.99
X-Rspamd-Queue-Id: 3C2EF218E4

Hi Jens,

Here are recent bcache patches tested by me on Linux v6.7-rc1 and can be
applied on branch block-6.7 of linux-block tree. 

In this series, Colin provids useful code cleanup, some small and still
important fixes are contributed from Mingzhe, Rand. Also there are some
fixes and a code comments patch from me.

When I fixed the issue found during testing, 6.7-rc1 was released. IMHO
it still makes sense to have most of the fixes into 6.7. Please consider
to take them in block-6.7 if it is possible.

Thanks in advance.

Coly Li
---

Colin Ian King (1):
  bcache: remove redundant assignment to variable cur_idx

Coly Li (5):
  bcache: avoid oversize memory allocation by small stripe_size
  bcache: check return value from btree_node_alloc_replacement()
  bcache: replace a mistaken IS_ERR() by IS_ERR_OR_NULL() in
    btree_gc_coalesce()
  bcache: add code comments for bch_btree_node_get() and
    __bch_btree_node_alloc()
  bcache: avoid NULL checking to c->root in run_cache_set()

Mingzhe Zou (3):
  bcache: fixup init dirty data errors
  bcache: fixup lock c->root error
  bcache: fixup multi-threaded bch_sectors_dirty_init() wake-up race

Rand Deeb (1):
  bcache: prevent potential division by zero error

 drivers/md/bcache/bcache.h    |  1 +
 drivers/md/bcache/btree.c     | 11 ++++++++++-
 drivers/md/bcache/super.c     |  4 +++-
 drivers/md/bcache/sysfs.c     |  2 +-
 drivers/md/bcache/writeback.c | 24 ++++++++++++++++++------
 5 files changed, 33 insertions(+), 9 deletions(-)

-- 
2.35.3


