Return-Path: <linux-bcache+bounces-80-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AB277FC769
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Nov 2023 22:10:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B9451C21206
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Nov 2023 21:10:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 703E25027F;
	Tue, 28 Nov 2023 21:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iyrwdhf2"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBC842AA1;
	Tue, 28 Nov 2023 21:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D50AC433AB;
	Tue, 28 Nov 2023 21:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701205762;
	bh=PT0I+olLlXtUjxYV1w8HFJTWaUQzQ5WtMjWEJ8FyfB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iyrwdhf2EcTkFmOxBP69LmNoyh679f+x+M/81IF001kvzCFJM9Ek8Eln4e5c1XFDM
	 JYeI5bLe/J0e7uFVduZl6f3saUA9uyeEqR85xCfXA1TXCc+/U+684WWX9KtLj7ulWL
	 TeuuEFPzE2VKgUABjwuzA2JF+mEE00r3vk/Wq6VfQgYjcM4LfgWlkyrGxz5Yij3tky
	 m1Ga3VDOCuufydc69G0tLAc9+lrVW0u5N9fEQQ7oF5EPdawtp7MKHKAfAHcZcksmLF
	 jg9m5JF76tsKTAwyw3UVtSRs1BkcfCyx/Gz8jPk/xhKPu9cAw38IVcNQ1Ukvl3WHSR
	 54Qh0hovTFjgA==
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
Subject: [PATCH AUTOSEL 5.10 04/13] bcache: remove redundant assignment to variable cur_idx
Date: Tue, 28 Nov 2023 16:08:58 -0500
Message-ID: <20231128210914.876813-4-sashal@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231128210914.876813-1-sashal@kernel.org>
References: <20231128210914.876813-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.202
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
index 6324c922f6ba4..6551ea47b39fb 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -857,7 +857,7 @@ static int bch_dirty_init_thread(void *arg)
 	int cur_idx, prev_idx, skip_nr;
 
 	k = p = NULL;
-	cur_idx = prev_idx = 0;
+	prev_idx = 0;
 
 	bch_btree_iter_init(&c->root->keys, &iter, NULL);
 	k = bch_btree_iter_next_filter(&iter, &c->root->keys, bch_ptr_bad);
-- 
2.42.0


