Return-Path: <linux-bcache+bounces-88-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A6507FC79F
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Nov 2023 22:11:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6BC9C1C211FC
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Nov 2023 21:11:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B115E44C9B;
	Tue, 28 Nov 2023 21:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wit8Fhkb"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9425044C9A;
	Tue, 28 Nov 2023 21:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7EBC43140;
	Tue, 28 Nov 2023 21:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701205808;
	bh=8sWl0VD40rNw244o7yO5xqupCAKOvu6uNQWiQMcF3Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wit8FhkbnEyeLFkJIWQ6si2yAOOayXdelaZWgK37tw0w/r7lr7qDDv9WFbDRxCX6G
	 IwVpY4xDWjGQnfQwOFF5M9lKGwwUTPaRvCeDLot3+Wwgn4JXbthm2lqrMdYME3nm7M
	 kHp8nBTKFAeaefaurabtnFHp4P6EdMONwdNmifwAFmbnCb+2QkTjFDt44Io54WwLpx
	 Zd3GCCdtCbWHTDPnJNaLIBbN4zbq1WuVuweRM5YHN6JYPTWEzNn+z16CKpfmzwNZby
	 eTPTx7j7DKF6BFWCSY331PRBqGD+NapniuutC+2lvZD8kwqJV9EH0lVVxjyNPbAqpY
	 hrFCqoUiATArg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Coly Li <colyli@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	kent.overstreet@gmail.com,
	linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/10] bcache: avoid NULL checking to c->root in run_cache_set()
Date: Tue, 28 Nov 2023 16:09:53 -0500
Message-ID: <20231128211001.877333-4-sashal@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231128211001.877333-1-sashal@kernel.org>
References: <20231128211001.877333-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 4.19.300
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
index 8b4a2bd6b57c9..70f0f3096beea 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1846,7 +1846,7 @@ static int run_cache_set(struct cache_set *c)
 		c->root = bch_btree_node_get(c, NULL, k,
 					     j->btree_level,
 					     true, NULL);
-		if (IS_ERR_OR_NULL(c->root))
+		if (IS_ERR(c->root))
 			goto err;
 
 		list_del_init(&c->root->list);
-- 
2.42.0


