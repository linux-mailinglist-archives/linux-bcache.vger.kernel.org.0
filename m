Return-Path: <linux-bcache+bounces-76-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A97F87FC74B
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Nov 2023 22:09:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2EED6B25A84
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Nov 2023 21:09:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC50644C7B;
	Tue, 28 Nov 2023 21:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X7wT6f5Z"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6CC42A8E;
	Tue, 28 Nov 2023 21:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26658C433A9;
	Tue, 28 Nov 2023 21:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701205734;
	bh=f1gzDelGg4oWJgujz2chwopJdsVltC23ldrlMx+lJtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7wT6f5Z/K99+OFjMnJJ3R7JuSUe6CZUmaikEgSuv8ARr/C4tbfDFU7KrcQxGIsU3
	 5qd+82MRZgoWrg2tYG6+9IcDK8rYDPixGi/JRtqh64m5U5usGeWuHUUXSf+UFAjUEO
	 gsbmUUyUna8aG0K37PPCMMSl/qt7Jib2I27YcNv9EngZPwjlUj744kIavKSPtZQ8po
	 jjyLrZwdcmQFtQlo4+MC6B5YQPBHLlAtPJco77ZOTufxMFCbbxBALwZOas43hwTUur
	 MRyc5JeHMXyeCLCLqG7Fkz4E2s7i4YRnbVMl8nMIvdDvJM0sLKH14Q6RTiQLnBpq3x
	 DG2ZabsAQ5yUQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Colin Ian King <colin.i.king@gmail.com>,
	Coly Li <colyli@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	kent.overstreet@gmail.com,
	nathan@kernel.org,
	ndesaulniers@google.com,
	linux-bcache@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 06/15] bcache: remove redundant assignment to variable cur_idx
Date: Tue, 28 Nov 2023 16:08:27 -0500
Message-ID: <20231128210843.876493-6-sashal@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231128210843.876493-1-sashal@kernel.org>
References: <20231128210843.876493-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.140
Content-Transfer-Encoding: 8bit

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit be93825f0e6428c2d3f03a6e4d447dc48d33d7ff ]

Variable cur_idx is being initialized with a value that is never read,
it is being re-assigned later in a while-loop. Remove the redundant
assignment. Cleans up clang scan build warning:

drivers/md/bcache/writeback.c:916:2: warning: Value stored to 'cur_idx'
is never read [deadcode.DeadStores]

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Coly Li <colyli@suse.de>
Signed-off-by: Coly Li <colyli@suse.de>
Link: https://lore.kernel.org/r/20231120052503.6122-4-colyli@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/writeback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 4dcbaf9a2149d..1866aa1c08bba 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -903,7 +903,7 @@ static int bch_dirty_init_thread(void *arg)
 	int cur_idx, prev_idx, skip_nr;
 
 	k = p = NULL;
-	cur_idx = prev_idx = 0;
+	prev_idx = 0;
 
 	bch_btree_iter_init(&c->root->keys, &iter, NULL);
 	k = bch_btree_iter_next_filter(&iter, &c->root->keys, bch_ptr_bad);
-- 
2.42.0


