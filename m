Return-Path: <linux-bcache+bounces-1254-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34D4EC55D2C
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Nov 2025 06:37:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D0293AF942
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Nov 2025 05:36:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A911A303C97;
	Thu, 13 Nov 2025 05:36:54 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF54302CB1;
	Thu, 13 Nov 2025 05:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763012214; cv=none; b=lVf4v7wdX0ZycetrUryLguazE+96TdIDt07IfSw0WuddmyE/ZkyoovMK+C0ctc37E6cLZ4HwGmBU5GxiaCQqM3PXcke6CK7ZvK1LAnrV2h7PUv2MYuemTxR2p87LXOZ1/zbUumNh+YK0HzI0PD8eRRL9ElEDR/xwXBzqyZ9W8Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763012214; c=relaxed/simple;
	bh=x+9AeoA7jlCzl4yi6ZcWGHbOPLoZKWTsbgJoXtoXfbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVbZauIYVbBxVPaXupa7snDvzFwziD2DUerv2zrY1ut6T0ZCnjZCRX8OF5GBxd1R0pj30jiSZHHqw/RrOAdpJHaM0DH2FH8ACpMPAKDq7B+fDxQrWL+77omgNDXE+MIC5WjYuaOJz3zWCArTZGv3jsxIjpWa4U/0MmoPAvTh2J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD04C16AAE;
	Thu, 13 Nov 2025 05:36:52 +0000 (UTC)
From: colyli@fnnas.com
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org,
	linux-block@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Coly Li <colyli@fnnas.com>
Subject: [PATCH 9/9] bcache: Avoid -Wflex-array-member-not-at-end warning
Date: Thu, 13 Nov 2025 13:36:30 +0800
Message-ID: <20251113053630.54218-10-colyli@fnnas.com>
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

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

-Wflex-array-member-not-at-end was introduced in GCC-14, and we are
getting ready to enable it, globally.

Use the new TRAILING_OVERLAP() helper to fix the following warning:

drivers/md/bcache/bset.h:330:27: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

This helper creates a union between a flexible-array member (FAM) and a
set of MEMBERS that would otherwise follow it.

This overlays the trailing MEMBER struct btree_iter_set stack_data[MAX_BSETS];
onto the FAM struct btree_iter::data[], while keeping the FAM and the start
of MEMBER aligned.

The static_assert() ensures this alignment remains, and it's
intentionally placed immediately after the corresponding structures --no
blank line in between.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Coly Li <colyli@fnnas.com>
---
 drivers/md/bcache/bset.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/bset.h b/drivers/md/bcache/bset.h
index 011f6062c4c0..6ee2c6a506a2 100644
--- a/drivers/md/bcache/bset.h
+++ b/drivers/md/bcache/bset.h
@@ -327,9 +327,13 @@ struct btree_iter {
 /* Fixed-size btree_iter that can be allocated on the stack */
 
 struct btree_iter_stack {
-	struct btree_iter iter;
-	struct btree_iter_set stack_data[MAX_BSETS];
+	/* Must be last as it ends in a flexible-array member. */
+	TRAILING_OVERLAP(struct btree_iter, iter, data,
+		struct btree_iter_set stack_data[MAX_BSETS];
+	);
 };
+static_assert(offsetof(struct btree_iter_stack, iter.data) ==
+	      offsetof(struct btree_iter_stack, stack_data));
 
 typedef bool (*ptr_filter_fn)(struct btree_keys *b, const struct bkey *k);
 
-- 
2.47.3


