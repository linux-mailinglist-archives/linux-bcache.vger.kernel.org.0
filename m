Return-Path: <linux-bcache+bounces-68-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC4767FC6C9
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Nov 2023 22:06:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 889A9285DF1
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Nov 2023 21:06:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C15C444C6D;
	Tue, 28 Nov 2023 21:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gs1hUyiu"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B83240BF2;
	Tue, 28 Nov 2023 21:06:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D266BC433CB;
	Tue, 28 Nov 2023 21:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701205594;
	bh=2rhaJ0HB8GuEVIPSqohYD64j1QFkH4NYFmviT6cUuCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gs1hUyiuwXOqPwB7fodgDLUW/na3yIWw4AvVZQuqfvACFlEThVDiyYtVjj+wsqmIn
	 6HUlFDVKOVs3P83Kzg1OJhjEhiJT4fV1cxEssmJKqHNDPEKBnTUwsJsj1Yb1biO173
	 LCO6FBWA07e9YzCiZRs49PZ3vJG1tDANI6+jwQqLEjl/ed4heXA2zq3MyrZX9ZTC/S
	 AEBu/E0MjyyYZ6vgXnyV3U9cFykhKC+39GJjpBS8kx/dZL+BiAQPFCL3YMA9/70Oaq
	 E43l5W0GJtoC4kJEHM1fRveplAbgIh1wlPEQsHOr0GR5ngDDHCYuxAz5aqLVzRTjgd
	 /jNBSZ8JB06iw==
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
Subject: [PATCH AUTOSEL 6.6 08/40] bcache: remove redundant assignment to variable cur_idx
Date: Tue, 28 Nov 2023 16:05:14 -0500
Message-ID: <20231128210615.875085-8-sashal@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231128210615.875085-1-sashal@kernel.org>
References: <20231128210615.875085-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.3
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
index 24c049067f61a..c3e872e0a6f2c 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -913,7 +913,7 @@ static int bch_dirty_init_thread(void *arg)
 	int cur_idx, prev_idx, skip_nr;
 
 	k = p = NULL;
-	cur_idx = prev_idx = 0;
+	prev_idx = 0;
 
 	bch_btree_iter_init(&c->root->keys, &iter, NULL);
 	k = bch_btree_iter_next_filter(&iter, &c->root->keys, bch_ptr_bad);
-- 
2.42.0


