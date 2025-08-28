Return-Path: <linux-bcache+bounces-1193-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 086B4B3A5F1
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Aug 2025 18:17:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B34F3A04C14
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Aug 2025 16:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68E96320CCA;
	Thu, 28 Aug 2025 16:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tmRuNayW"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434FB1FF1D1
	for <linux-bcache@vger.kernel.org>; Thu, 28 Aug 2025 16:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756397844; cv=none; b=ofI+20az9gsC7YCp9AnipW+CsOEGgbo5yxlRVBRkrAqOPgBwNmQSPS/Oe+OQzx+OX1ec7pw9BYdhAqyn35R+5vv+f+QnyuElVMVW6F+lAAQeFiZwFxeMdxIANOn21Xn0beU8ck6a1/D/+MKGGeKC1gkxP+A+CQkC9BHjaVmHuek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756397844; c=relaxed/simple;
	bh=ktGSpMu4HpMCA6puSDvdALuCk3Dj6bVx+G8zVJLElRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=icNqLbSF6Rv6wmO8MlLfGosI9gJItuiO1legde/KGK2kLVLRMJ70BWLSMDVHJgDeit+SOl6lH3LZaidebOUGNNyyN1zXclTMTqJrjNWbW69a1fcQQCTM8rRuPhqAvwS1T5nNF95M2s32fd4IXD2T7AViEmH7nZqk/x7I/LL00QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tmRuNayW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B6AC4CEED;
	Thu, 28 Aug 2025 16:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756397843;
	bh=ktGSpMu4HpMCA6puSDvdALuCk3Dj6bVx+G8zVJLElRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tmRuNayW4VG9rMBXxj8ce8yLRguwJrIWrqjZ5G0kHJiff3sHI4xjLIbF8DEjBE2td
	 uYSdAmOmRqg7RUcrBXCum6PBwAFG51RRWBQKIwh7POMyGaNESOziJlct0oHVfydKTa
	 1UHrewrmPPUWNYA8upw9mNejQ/P28QnV2TZBA0wRqMlXqm8ngkjFmFEwZ6a6RlGrJU
	 tcNhr5QB95An24yzaA3o3kZsqN8JEhreJpOWtXQA0k7G4xt3okRQiNlhJuHjLTrsZz
	 zkWFzuL54IRc2VUspk7trw0REIGwuzZafEaPecl+SwjLmjlmv+gzEpxO3niP0WB8vE
	 YLBzNUPwqUhDg==
From: colyli@kernel.org
To: linux-bcache@vger.kernel.org
Cc: Coly Li <colyli@suse.de>,
	Coly Li <colyli@fnnas.com>
Subject: [PATCH 2/4] bcache: remove discard code from alloc.c
Date: Fri, 29 Aug 2025 00:17:15 +0800
Message-ID: <20250828161717.33518-2-colyli@kernel.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250828161717.33518-1-colyli@kernel.org>
References: <20250828161717.33518-1-colyli@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Coly Li <colyli@suse.de>

Bcache allocator initially has no free space to allocate. Firstly it
does a garbage collection which is triggered by a cache device write
and fills free space into ca->free[] lists. The discard happens after
the free bucket is handled by garbage collection added into one of the
ca->free[] lists. But normally this bucket will be allocated out very
soon to requester and filled data onto it. The discard hint on this
bucket LBA range doesn't help SSD control to improve internal erasure
performance, and waste extra CPU cycles to issue discard bios.

This patch removes the almost-useless discard code from alloc.c.

Signed-off-by: Coly Li <colyli@fnnas.com>
---
 drivers/md/bcache/alloc.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index db519e1678c2..7708d92df23e 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -24,21 +24,18 @@
  * Since the gens and priorities are all stored contiguously on disk, we can
  * batch this up: We fill up the free_inc list with freshly invalidated buckets,
  * call prio_write(), and when prio_write() finishes we pull buckets off the
- * free_inc list and optionally discard them.
+ * free_inc list.
  *
  * free_inc isn't the only freelist - if it was, we'd often to sleep while
  * priorities and gens were being written before we could allocate. c->free is a
  * smaller freelist, and buckets on that list are always ready to be used.
  *
- * If we've got discards enabled, that happens when a bucket moves from the
- * free_inc list to the free list.
- *
  * There is another freelist, because sometimes we have buckets that we know
  * have nothing pointing into them - these we can reuse without waiting for
  * priorities to be rewritten. These come from freed btree nodes and buckets
  * that garbage collection discovered no longer had valid keys pointing into
  * them (because they were overwritten). That's the unused list - buckets on the
- * unused list move to the free list, optionally being discarded in the process.
+ * unused list move to the free list.
  *
  * It's also important to ensure that gens don't wrap around - with respect to
  * either the oldest gen in the btree or the gen on disk. This is quite
@@ -118,8 +115,7 @@ void bch_rescale_priorities(struct cache_set *c, int sectors)
 /*
  * Background allocation thread: scans for buckets to be invalidated,
  * invalidates them, rewrites prios/gens (marking them as invalidated on disk),
- * then optionally issues discard commands to the newly free buckets, then puts
- * them on the various freelists.
+ * then puts them on the various freelists.
  */
 
 static inline bool can_inc_bucket_gen(struct bucket *b)
@@ -321,8 +317,7 @@ static int bch_allocator_thread(void *arg)
 	while (1) {
 		/*
 		 * First, we pull buckets off of the unused and free_inc lists,
-		 * possibly issue discards to them, then we add the bucket to
-		 * the free list:
+		 * then we add the bucket to the free list:
 		 */
 		while (1) {
 			long bucket;
@@ -330,14 +325,6 @@ static int bch_allocator_thread(void *arg)
 			if (!fifo_pop(&ca->free_inc, bucket))
 				break;
 
-			if (ca->discard) {
-				mutex_unlock(&ca->set->bucket_lock);
-				blkdev_issue_discard(ca->bdev,
-					bucket_to_sector(ca->set, bucket),
-					ca->sb.bucket_size, GFP_KERNEL);
-				mutex_lock(&ca->set->bucket_lock);
-			}
-
 			allocator_wait(ca, bch_allocator_push(ca, bucket));
 			wake_up(&ca->set->btree_cache_wait);
 			wake_up(&ca->set->bucket_wait);
-- 
2.47.2


