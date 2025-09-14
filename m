Return-Path: <linux-bcache+bounces-1206-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 609F3B56A9A
	for <lists+linux-bcache@lfdr.de>; Sun, 14 Sep 2025 18:32:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1AC963A88D7
	for <lists+linux-bcache@lfdr.de>; Sun, 14 Sep 2025 16:32:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D26A92D8370;
	Sun, 14 Sep 2025 16:32:23 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA07226CE04
	for <linux-bcache@vger.kernel.org>; Sun, 14 Sep 2025 16:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757867543; cv=none; b=JUAE0dE+CKSYUmzHeZugfQfkmeDC+R+Yv4XfTO924Iy/OOEEvIBtYONVDNHcHDkd6uqpL4xgdkDgWytapsEqY6Le8xQdsVveasLRLn5iF5e6pabBqWQNmZKwQ61+7DtWOxGfXl0Gzceb3pn5TLGEYHiMmnXzSoxG/qo+jsPhZTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757867543; c=relaxed/simple;
	bh=TjxFtAtZiBxA1K/7QvP+E9lC9gKQTW/hz/8JB8hfvtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8Vl2eRJ3PncbASN2nI3z0nq+wdq5SSX8tUcZNanT/p4Pbm+bLXnHx7OR/X398yPnANkrC6ka7fuWmixqfK1iOWbF08KN3EYGJD1RTHpcoM4LANY1auIjcen8ZrZGDbpTcEE7kDBt4uHhfbmog/35pQpDboW8Somb1fMEb8vn/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FA5C4CEFA;
	Sun, 14 Sep 2025 16:32:21 +0000 (UTC)
From: colyli@fnnas.com
To: linux-bcache@vger.kernel.org
Cc: Coly Li <colyli@fnnas.com>
Subject: [PATCH 2/4] bcache: remove discard code from alloc.c
Date: Mon, 15 Sep 2025 00:32:14 +0800
Message-ID: <20250914163216.115036-2-colyli@fnnas.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250914163216.115036-1-colyli@fnnas.com>
References: <20250914163216.115036-1-colyli@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Coly Li <colyli@fnnas.com>

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
index 48ce750bf70a..db3684819e38 100644
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
2.47.3


