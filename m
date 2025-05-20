Return-Path: <linux-bcache+bounces-1070-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 633D9ABD760
	for <lists+linux-bcache@lfdr.de>; Tue, 20 May 2025 13:51:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D877F3B2916
	for <lists+linux-bcache@lfdr.de>; Tue, 20 May 2025 11:51:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4394B27D771;
	Tue, 20 May 2025 11:51:42 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-m21471.qiye.163.com (mail-m21471.qiye.163.com [117.135.214.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB4314F9FB
	for <linux-bcache@vger.kernel.org>; Tue, 20 May 2025 11:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.214.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747741902; cv=none; b=VymdPpDPOPGBIeIEhp7fucx1k76jywrYTZgwJTIbdxiqgTpyicMWkXU+y3VctL5qr7FcAmTluSPuDhnQ4993blUxvF0sF6UwS8Aym2yfEkKNf6WlNhya3jln/SgnbkZKGi2RcKax1yDpAFgTMIcctRMLRFWLCgpnQ5QP9QOZvVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747741902; c=relaxed/simple;
	bh=YQyYdzFzP8MVe77/g8MzaAjpZEOW7HqyCodb66qbJAI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ibm8PytBPVF5AXLNigBQkOCSQvMR3qgX+94W4MHYiph5ZOpnnsoRdOFm2wIqo0PJ677OSJf8Gue4vi/4BqIj8P36H8l4XSpD4tLCnWdYxDpMBL7xJUwAXbyC6BUXfPh/cbKafPhMsA0NGptBk6KgKKjuw/rd35LF7V0iiFO53V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn; spf=pass smtp.mailfrom=easystack.cn; arc=none smtp.client-ip=117.135.214.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=easystack.cn
Received: from localhost.localdomain (unknown [112.86.132.76])
	by smtp.qiye.163.com (Hmail) with ESMTP id a06a4dff;
	Tue, 20 May 2025 19:46:20 +0800 (GMT+08:00)
From: mingzhe.zou@easystack.cn
To: colyli@kernel.org
Cc: linux-bcache@vger.kernel.org,
	zoumingzhe@qq.com,
	zoumingzhe@outlook.com
Subject: [PATCH] bcache: reserve more RESERVE_BTREE buckets to prevent allocator hang
Date: Tue, 20 May 2025 19:45:58 +0800
Message-Id: <20250520114558.1020593-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlCGkxDVk5OS0lISBpDHksdHlYVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlKSklVQ01VSkhJVUxNWVdZFhoPEhUdFFlBWU9LSFVKS0lPT09IVUpLS1
	VKQktLWQY+
X-HM-Tid: 0a96ed841d0e022bkunmb8d1349419fd65
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6N0k6Lgw*SjcUMwswQkgpMRwx
	ISgKCyxVSlVKTE9MTE9KTkNKTE1DVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
	C1lBWUpKSVVDTVVKSElVTE1ZV1kIAVlBT0NMSzcG

From: Mingzhe Zou <zoumingzhe@qq.com>

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
buckets used up or btree_check_reserve() failed when requst handle btree
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
---
 drivers/md/bcache/super.c | 48 ++++++++++++++++++++++++++++++++-------
 1 file changed, 40 insertions(+), 8 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 813b38aec3e4..4248c6299f28 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2233,15 +2233,47 @@ static int cache_alloc(struct cache *ca)
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
2.34.1


