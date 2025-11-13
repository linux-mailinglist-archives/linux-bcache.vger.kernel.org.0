Return-Path: <linux-bcache+bounces-1251-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2B5CC55D1D
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Nov 2025 06:37:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EDCA3B0484
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Nov 2025 05:36:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFE3330215B;
	Thu, 13 Nov 2025 05:36:48 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948A22BCF6C;
	Thu, 13 Nov 2025 05:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763012208; cv=none; b=lcdYLw87e7ulBKmXRLDgxuSUP8lRsiJ5pNMrw6NSi9pOeTbMXm1S5riAsLNpMJCWH2ynXTUQ3O+HnggDUCC0VpgUcbuBfsIERACqAcqOBuv794KhOF8fSCcyqA0mTcdEsa7Bc0dY+crFtvDJXAdAlNiS8uOvMuQGOkeZE0Op/Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763012208; c=relaxed/simple;
	bh=EiXNf2swKm7Ceyd+WoGEquCR1V6D5XVL8lMV2jKJMyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pfhesOLFqJiEXT5QDUQzMrMlZN5jIcJM7IXiaksKMi5eyttApRAShGfp8NIeU7wNrgsd5MfyMFLq6fyaQve86n2FkyNs1/DTfhOMDSFT2WrUWJXw+hlkcv88v18U4Fyby6tu9O8/hnYDR3rpO0zlBhhDu2dHVuOkhwFzt/bgPgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F6DC4CEFB;
	Thu, 13 Nov 2025 05:36:46 +0000 (UTC)
From: colyli@fnnas.com
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org,
	linux-block@vger.kernel.org,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Coly Li <colyli@fnnas.com>
Subject: [PATCH 6/9] bcache: remove redundant __GFP_NOWARN
Date: Thu, 13 Nov 2025 13:36:27 +0800
Message-ID: <20251113053630.54218-7-colyli@fnnas.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113053630.54218-1-colyli@fnnas.com>
References: <20251113053630.54218-1-colyli@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Qianfeng Rong <rongqianfeng@vivo.com>

GFP_NOWAIT already includes __GFP_NOWARN, so let's remove the redundant
__GFP_NOWARN.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Acked-by: Coly Li <colyli@fnnas.com>
---
 drivers/md/bcache/btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 5d922d301ab6..24ddc353cb30 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -372,7 +372,7 @@ static void do_btree_node_write(struct btree *b)
 	SET_PTR_OFFSET(&k.key, 0, PTR_OFFSET(&k.key, 0) +
 		       bset_sector_offset(&b->keys, i));
 
-	if (!bch_bio_alloc_pages(b->bio, __GFP_NOWARN|GFP_NOWAIT)) {
+	if (!bch_bio_alloc_pages(b->bio, GFP_NOWAIT)) {
 		struct bio_vec *bv;
 		void *addr = (void *) ((unsigned long) i & ~(PAGE_SIZE - 1));
 		struct bvec_iter_all iter_all;
-- 
2.47.3


