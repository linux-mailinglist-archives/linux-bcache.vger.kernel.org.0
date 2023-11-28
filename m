Return-Path: <linux-bcache+bounces-70-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A58B87FC6CE
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Nov 2023 22:07:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D756D1C21B85
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Nov 2023 21:07:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DDC641C84;
	Tue, 28 Nov 2023 21:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="faOuo9Zi"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F5344391;
	Tue, 28 Nov 2023 21:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD93DC433C7;
	Tue, 28 Nov 2023 21:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701205596;
	bh=+vhaieq4DktHSc6OJcr3KYQsszPREgSeZNTZNt9jFAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=faOuo9Zi/84g5gSnH65YB/eV3HI4H0iYNEwliMWiC1Keds9ScEcoq3tkouSfh0YDs
	 wT8UuUz29R/2zck1IYz3YfnyW3KPKWJOu304ZdrU37epOwz6qBzAJqDfHCJl8+aBPQ
	 2OxjRvwPJ9h3Lp33U11P6wnlVqx23s4nWsxM6K/xgr9uUdN6ZWOBKUHldWcm14wdI4
	 Eo9hp1+vaBGlpFkhDqk0t9CGaMmzLk0U18aObybRCLY2GWBDeLWyxbaVqZnFHvP9tc
	 zNTqoK3TYZnsFkWIU4mdmeUWNe5D9oOJbDbNCoAqpIzmp2uVy9GD7whIkR0kZ62bnU
	 xR8KbKrQXadDA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Coly Li <colyli@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	kent.overstreet@gmail.com,
	linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 10/40] bcache: avoid NULL checking to c->root in run_cache_set()
Date: Tue, 28 Nov 2023 16:05:16 -0500
Message-ID: <20231128210615.875085-10-sashal@kernel.org>
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
index 93791e46b1e8f..1e677af385211 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2017,7 +2017,7 @@ static int run_cache_set(struct cache_set *c)
 		c->root = bch_btree_node_get(c, NULL, k,
 					     j->btree_level,
 					     true, NULL);
-		if (IS_ERR_OR_NULL(c->root))
+		if (IS_ERR(c->root))
 			goto err;
 
 		list_del_init(&c->root->list);
-- 
2.42.0


