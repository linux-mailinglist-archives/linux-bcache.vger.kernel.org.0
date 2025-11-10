Return-Path: <linux-bcache+bounces-1237-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A394C46160
	for <lists+linux-bcache@lfdr.de>; Mon, 10 Nov 2025 11:59:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B63F1890E5A
	for <lists+linux-bcache@lfdr.de>; Mon, 10 Nov 2025 10:59:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50CCD305E27;
	Mon, 10 Nov 2025 10:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ULyG0SvA"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230181DF72C;
	Mon, 10 Nov 2025 10:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762772350; cv=none; b=I1Y2wsmOefVb41HSwEGVHENqBvp0pO+M5yImMfGpYdLAk2iVLr5ltdnglQh1H/uLIId6eRZAxvPldzJ6TZBCfaQvC6YWV7IZ1i5Ek5zqdQjVxkCuS6QY0xUQZFeQEt0TQkMMnxtnltjo2NuJTwhbMcZW4utfGDrHMAjIy2rVfWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762772350; c=relaxed/simple;
	bh=H1KCquvsgrEEnjmZA9EO1r7LzKOIv3jfOjS0aZILJ2k=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=iKrIep12pos1OlLmWspLFRjCR8+cY72QFgGJH0QaCXOR+lAQJjM6MJ0LkHaZ7QXk19Myo0Clds+ZQAFX9eq0GVTYBfv9N7r26ZgtDVy3uQGTKM6jbPeymypOp2qstydrlE1mTMqIlEj/fox2p1UZmxgCfWIXCS7Y8uFiLKxMsdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ULyG0SvA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCCE8C116D0;
	Mon, 10 Nov 2025 10:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762772344;
	bh=H1KCquvsgrEEnjmZA9EO1r7LzKOIv3jfOjS0aZILJ2k=;
	h=Date:From:To:Cc:Subject:From;
	b=ULyG0SvAVnId7zgahBYhEKxlY5GLjXTO3HXMynN1QZK1UYmxo8bs1yYpgTWAFNsgP
	 wEaWGCkXbgHszISgWAazEQJdjzCLijfRPQsRwbRlkaFAuL/G0CvfJc0Xu7kHoRl/EP
	 STQ45AXBjweppvYfrkq6T/VmnzqXZ5huw9uSV/kFF1gLEZctclzaxQ3GBdOhKF4Thj
	 MI2T5Zqd41uLQ0L55PpuOINrNH+/4XE6Otf4kgn4uevJsiJuQDzaVwetP67qyxPaqu
	 nb3WZa4raCiDaEPJTC4E3ACr0+pQzAaBY9lYUuNXIBlPN1UjimXyHvIedvbP2j9Xl0
	 fCf3/3UT6LVRA==
Date: Mon, 10 Nov 2025 19:58:58 +0900
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Coly Li <colyli@fnnas.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH][next] bcache: Avoid -Wflex-array-member-not-at-end warning
Message-ID: <aRHFchrO3BmVMH5c@kspp>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

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
intentionally placed inmediately after the corresponding structures --no
blank line in between.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
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
2.43.0


