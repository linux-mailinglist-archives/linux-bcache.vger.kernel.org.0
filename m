Return-Path: <linux-bcache+bounces-1098-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B237AC4777
	for <lists+linux-bcache@lfdr.de>; Tue, 27 May 2025 07:16:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A027F177718
	for <lists+linux-bcache@lfdr.de>; Tue, 27 May 2025 05:16:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D59F61B4F0A;
	Tue, 27 May 2025 05:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LlNewfUm"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0000382;
	Tue, 27 May 2025 05:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748322972; cv=none; b=PG/xOVc+3ZyK04NMHSaoDxn0oesFasdngXiTvrnJIJ0n9nuf/C0ROKNT5sMuZGLExoubRUGYaGTM5UyORSVIRUrRp3cneT7AF1uy7zF/K0uJxl/hyIER137eyi5sWKxHQKRt7abkiBX9ZLRMlh1nonY85hFnUX1t01NwmAmjfe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748322972; c=relaxed/simple;
	bh=/GP//rwPvAl67p1ECi3pVR/Cj2GJLiXPJ7MoFyv+eIU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YSowW4ZVvgHAzMVT2DLfGl1kpa0pJCqZld9YYb3J3f+apQarQ8KHRNYKWiczR+qjtPyguaD8eeUnwLfNZCzd4i2tnYT+60V5XLDlHUuX+NkAK3jqkVIpa15jElWEywBmDobGgEAoDZwJ06UE9BSzn8UnL+jPRHKzD5Rfk51k70Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LlNewfUm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73ACC4CEEA;
	Tue, 27 May 2025 05:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748322972;
	bh=/GP//rwPvAl67p1ECi3pVR/Cj2GJLiXPJ7MoFyv+eIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LlNewfUmO51XmBvLDq5LL8oA7b857MPY9H6OUDD10CF3hv6h3SG+s/LzCZyuGol9O
	 jJH6TKoEi1GLsJd1ufScbh9Xh/zJRwXJk3KR773M8UOH/sMEXiHXyhU3yRL/R/+YfD
	 jldkwhatV27Ju7TTYXC9vnMPKljW4nhtXiry3+bahiZrRwm0AFrrtfPDfAvFvnkj7T
	 pcdzIfbpRKc1T9+EEMQD83GykLk9G/nS4c2DnD0ZYQkpbX2LfKMg+IxHVBVdj6doM+
	 Oj3hVl7mDGbSsvu4tNeOvOvg1iT8ShC1TYESkpWMihaQyWmPY9dsLLLr8mZ5y184+B
	 qA32pG7zlbr1w==
From: colyli@kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org,
	linux-block@vger.kernel.org,
	Mingzhe Zou <mingzhe.zou@easystack.cn>,
	Coly Li <colyli@kernel.org>
Subject: [PATCH 3/3] bcache: reserve more RESERVE_BTREE buckets to prevent allocator hang
Date: Tue, 27 May 2025 13:16:01 +0800
Message-Id: <20250527051601.74407-4-colyli@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250527051601.74407-1-colyli@kernel.org>
References: <20250527051601.74407-1-colyli@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mingzhe Zou <mingzhe.zou@easystack.cn>

Reported an IO hang and unrecoverable error in our testing environment.

After careful research, we found that bch_allocator_thread is stuck,
the call stack is as follows:
[<0>] __switch_to+0xbc/0x108
[<0>] __closure_sync+0x7c/0xbc [bcache]
[<0>] bch_prio_write+0x430/0x448 [bcache]
[<0>] bch_allocator_thread+0xb44/0xb70 [bcache]
[<0>] kthread+0x124/0x130
[<0>] ret_from_fork+0x10/0x18

Moreover, the RESERVE_BTREE type bucket slot are empty and journal_full
occurs at the same time.

When the cache disk is first used, the sb.nJournal_buckets defaults to 0.
So, only 8 RESERVE_BTREE type buckets are reserved. If RESERVE_BTREE type
buckets used up or btree_check_reserve() failed when request handle btree
split, the request will be repeatedly retried and wait for alloc thread to
fill in.

After the alloc thread fills the buckets, it will call bch_prio_write().
If journal_full occurs simultaneously at this time, journal_reclaim() and
btree_flush_write() will be called sequentially, journal_write cannot be
completed.

This is a low probability event, we believe that reserve more RESERVE_BTREE
buckets can avoid the worst situation.

Fixes: 682811b3ce1a ("bcache: fix for allocator and register thread race")
Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
Signed-off-by: Coly Li <colyli@kernel.org>
---
 drivers/md/bcache/super.c | 48 ++++++++++++++++++++++++++++++++-------
 1 file changed, 40 insertions(+), 8 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 9e6dfe2ec147..12fb3e557fb1 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2237,15 +2237,47 @@ static int cache_alloc(struct cache *ca)
 	bio_init(&ca->journal.bio, NULL, ca->journal.bio.bi_inline_vecs, 8, 0);
 
 	/*
-	 * when ca->sb.njournal_buckets is not zero, journal exists,
-	 * and in bch_journal_replay(), tree node may split,
-	 * so bucket of RESERVE_BTREE type is needed,
-	 * the worst situation is all journal buckets are valid journal,
-	 * and all the keys need to replay,
-	 * so the number of  RESERVE_BTREE type buckets should be as much
-	 * as journal buckets
+	 * When the cache disk is first registered, ca->sb.njournal_buckets
+	 * is zero, and it is assigned in run_cache_set().
+	 *
+	 * When ca->sb.njournal_buckets is not zero, journal exists,
+	 * and in bch_journal_replay(), tree node may split.
+	 * The worst situation is all journal buckets are valid journal,
+	 * and all the keys need to replay, so the number of RESERVE_BTREE
+	 * type buckets should be as much as journal buckets.
+	 *
+	 * If the number of RESERVE_BTREE type buckets is too few, the
+	 * bch_allocator_thread() may hang up and unable to allocate
+	 * bucket. The situation is roughly as follows:
+	 *
+	 * 1. In bch_data_insert_keys(), if the operation is not op->replace,
+	 *    it will call the bch_journal(), which increments the journal_ref
+	 *    counter. This counter is only decremented after bch_btree_insert
+	 *    completes.
+	 *
+	 * 2. When calling bch_btree_insert, if the btree needs to split,
+	 *    it will call btree_split() and btree_check_reserve() to check
+	 *    whether there are enough reserved buckets in the RESERVE_BTREE
+	 *    slot. If not enough, bcache_btree_root() will repeatedly retry.
+	 *
+	 * 3. Normally, the bch_allocator_thread is responsible for filling
+	 *    the reservation slots from the free_inc bucket list. When the
+	 *    free_inc bucket list is exhausted, the bch_allocator_thread
+	 *    will call invalidate_buckets() until free_inc is refilled.
+	 *    Then bch_allocator_thread calls bch_prio_write() once. and
+	 *    bch_prio_write() will call bch_journal_meta() and waits for
+	 *    the journal write to complete.
+	 *
+	 * 4. During journal_write, journal_write_unlocked() is be called.
+	 *    If journal full occurs, journal_reclaim() and btree_flush_write()
+	 *    will be called sequentially, then retry journal_write.
+	 *
+	 * 5. When 2 and 4 occur together, IO will hung up and cannot recover.
+	 *
+	 * Therefore, reserve more RESERVE_BTREE type buckets.
 	 */
-	btree_buckets = ca->sb.njournal_buckets ?: 8;
+	btree_buckets = clamp_t(size_t, ca->sb.nbuckets >> 7,
+				32, SB_JOURNAL_BUCKETS);
 	free = roundup_pow_of_two(ca->sb.nbuckets) >> 10;
 	if (!free) {
 		ret = -EPERM;
-- 
2.39.5


