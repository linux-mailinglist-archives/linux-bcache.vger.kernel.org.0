Return-Path: <linux-bcache+bounces-69-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B5987FC6CC
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Nov 2023 22:06:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13AE2285F7F
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Nov 2023 21:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE8EE44C73;
	Tue, 28 Nov 2023 21:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q5mAyC5r"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF29841C7C;
	Tue, 28 Nov 2023 21:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B34C43397;
	Tue, 28 Nov 2023 21:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701205595;
	bh=XXt0pYEkIcuPBSPwjzKKF4tMn0yJ4NvKcdxqkqI9ReE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5mAyC5r82YWS5U52odbjCepPcA+wzjS7rSB1f5Uf3CLSmBkqx4GagO2BurRpnOb/
	 4no1376Elv8g7bx4ltxe2gfqErqlG9MzsDcXHl3NKUqXMRy7AU3NkGZ+9SI1+kFMQK
	 /yTvLMAf5uXS9X3CVaPqqTTTCvmmMZ6AGfjoaSJEyzUync12SkA+S23Vbzn2R3b0fE
	 qZatAP6tk9cz6U1QwSlg1Mr9OZ/Jb36LuxnY6FeKg8xSBx1xxsujvfGgax/bm5SGbB
	 4fJHCAknRKlah/feF0A9j2tV+AYTNz0boOPluc5k+zHUPj4yINU5FZRapQrKWRtVV3
	 EcpSMRhr4NM3g==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Coly Li <colyli@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	kent.overstreet@gmail.com,
	linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 09/40] bcache: add code comments for bch_btree_node_get() and __bch_btree_node_alloc()
Date: Tue, 28 Nov 2023 16:05:15 -0500
Message-ID: <20231128210615.875085-9-sashal@kernel.org>
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

[ Upstream commit 31f5b956a197d4ec25c8a07cb3a2ab69d0c0b82f ]

This patch adds code comments to bch_btree_node_get() and
__bch_btree_node_alloc() that NULL pointer will not be returned and it
is unnecessary to check NULL pointer by the callers of these routines.

Signed-off-by: Coly Li <colyli@suse.de>
Link: https://lore.kernel.org/r/20231120052503.6122-10-colyli@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/btree.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index fd121a61f17cc..738dfdb6fdb7d 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -995,6 +995,9 @@ static struct btree *mca_alloc(struct cache_set *c, struct btree_op *op,
  *
  * The btree node will have either a read or a write lock held, depending on
  * level and op->lock.
+ *
+ * Note: Only error code or btree pointer will be returned, it is unncessary
+ *       for callers to check NULL pointer.
  */
 struct btree *bch_btree_node_get(struct cache_set *c, struct btree_op *op,
 				 struct bkey *k, int level, bool write,
@@ -1106,6 +1109,10 @@ static void btree_node_free(struct btree *b)
 	mutex_unlock(&b->c->bucket_lock);
 }
 
+/*
+ * Only error code or btree pointer will be returned, it is unncessary for
+ * callers to check NULL pointer.
+ */
 struct btree *__bch_btree_node_alloc(struct cache_set *c, struct btree_op *op,
 				     int level, bool wait,
 				     struct btree *parent)
-- 
2.42.0


