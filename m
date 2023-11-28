Return-Path: <linux-bcache+bounces-78-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AB977FC750
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Nov 2023 22:09:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B85B8B25B58
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Nov 2023 21:09:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 143A044C7F;
	Tue, 28 Nov 2023 21:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H12Bv/Bf"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79B042A8E;
	Tue, 28 Nov 2023 21:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DEC4C433B9;
	Tue, 28 Nov 2023 21:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701205736;
	bh=xIRxk6xMVYTkjBQ5VOx8YZWzvYlob8G6Xp5S/o7yk5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H12Bv/Bfz8DEd2czpdUFDrM03q8xYZTuL1ZSfAN0D6LVEIIX8WKh3OzElsKOAhKRR
	 qkfEaPDPDSHWCfWZHLI4NiJQEyB39+Y7DH96Ohnqv4dEnQh02JOPtSlAwmVFA39i36
	 QRr6RViyrGaLglscQ6eUqcEQq3SaNitpS1qcI+xlQdFJxmOFPXlvkt4L1UEF2vlmI9
	 IWhx8/JCvX4P4OPpP5+vk9moUIghRcIIvAm1nTied6VdWOpSEdcCd0w5Z/clAyqyck
	 1u8dpGz5C4W1AQMsUx8KilUYJVRanIu1hfAzlubuYSXu7SDm20eq/n+HtUEegwbQiI
	 yDs5cAYbSmWuA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Coly Li <colyli@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	kent.overstreet@gmail.com,
	linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 08/15] bcache: avoid NULL checking to c->root in run_cache_set()
Date: Tue, 28 Nov 2023 16:08:29 -0500
Message-ID: <20231128210843.876493-8-sashal@kernel.org>
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

From: Coly Li <colyli@suse.de>

[ Upstream commit 3eba5e0b2422aec3c9e79822029599961fdcab97 ]

In run_cache_set() after c->root returned from bch_btree_node_get(), it
is checked by IS_ERR_OR_NULL(). Indeed it is unncessary to check NULL
because bch_btree_node_get() will not return NULL pointer to caller.

This patch replaces IS_ERR_OR_NULL() by IS_ERR() for the above reason.

Signed-off-by: Coly Li <colyli@suse.de>
Link: https://lore.kernel.org/r/20231120052503.6122-11-colyli@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 5ad83924d8e3b..8ec48d8a5821c 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2024,7 +2024,7 @@ static int run_cache_set(struct cache_set *c)
 		c->root = bch_btree_node_get(c, NULL, k,
 					     j->btree_level,
 					     true, NULL);
-		if (IS_ERR_OR_NULL(c->root))
+		if (IS_ERR(c->root))
 			goto err;
 
 		list_del_init(&c->root->list);
-- 
2.42.0


