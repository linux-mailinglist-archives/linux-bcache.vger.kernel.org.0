Return-Path: <linux-bcache+bounces-84-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E16FD7FC787
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Nov 2023 22:10:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EBBC1C21286
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Nov 2023 21:10:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B54B44C83;
	Tue, 28 Nov 2023 21:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jT/1X10R"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5C144C7B;
	Tue, 28 Nov 2023 21:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D40AC4339A;
	Tue, 28 Nov 2023 21:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701205789;
	bh=ahGNTsFYwxPZbgh4s2bRoFZfNzzeT6Wil67EYkmih1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jT/1X10Rh0Ga4dLXYBndQ2X0fBvX67Ye37ZR83fqeGoM3mXSudyPjjQSA5w4E0yig
	 9igSdOWDiONor1LWgOcm5mARXnXlByFWdZiY+FR8r+VhDUETzwApoij3R8+KwZE7U+
	 OPH7hawCPJQP9FimCSY7HDzjn2obl4yPmDCb+g7+B9kmVAbO38N4T3Zu2CB0Az4i9I
	 RpHaCMVFYcJqKHGec/cUpA9CXph6HL6QZ15XzYhPAuEGFrPh9RcOwykcxs/Uo5s3qN
	 JcK15pR53PcqVVHJ6nbgOcj6EqWZoqOl6Px6TuBZlrT9bdS8WpYI522XxEo2LwYPyn
	 CiQnazHTNoDAw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Coly Li <colyli@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	kent.overstreet@gmail.com,
	linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 04/11] bcache: add code comments for bch_btree_node_get() and __bch_btree_node_alloc()
Date: Tue, 28 Nov 2023 16:09:28 -0500
Message-ID: <20231128210941.877094-4-sashal@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231128210941.877094-1-sashal@kernel.org>
References: <20231128210941.877094-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.262
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
index cc0c1f2bba45c..26b4ff6be3723 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1020,6 +1020,9 @@ static struct btree *mca_alloc(struct cache_set *c, struct btree_op *op,
  *
  * The btree node will have either a read or a write lock held, depending on
  * level and op->lock.
+ *
+ * Note: Only error code or btree pointer will be returned, it is unncessary
+ *       for callers to check NULL pointer.
  */
 struct btree *bch_btree_node_get(struct cache_set *c, struct btree_op *op,
 				 struct bkey *k, int level, bool write,
@@ -1132,6 +1135,10 @@ static void btree_node_free(struct btree *b)
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


