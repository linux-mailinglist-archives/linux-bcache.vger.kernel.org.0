Return-Path: <linux-bcache+bounces-1246-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E1C9C55D38
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Nov 2025 06:38:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5685F4E2DC2
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Nov 2025 05:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4ADF2E285C;
	Thu, 13 Nov 2025 05:36:39 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8EC22A1CF;
	Thu, 13 Nov 2025 05:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763012199; cv=none; b=CgClAhYg/8GS6kTCdHG3C+67ypWcIUdhLxALzSIx8wltpbh8lj1QqkMByLjzfs0h+VSJlcMkN28vIc4yRzCkTRGJTKq4Iikz4Ia3ZycJiaY9BBG6QoOpoavW79XaA1pid+2fNNXUA75CRFDBM0RTvv3ZubczD6lIOPCS5IZq2Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763012199; c=relaxed/simple;
	bh=z+lk+Tq/cjYSwLl0r89hW2S7uJqi9txedJ0obWyvM14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qaOCZe0eDXYk2lmx9f3/GFsg6HR2sfh8SRZ8ESgCfObOt2GREaeE14uunGHNBvloM6amUn2p2FqKsePw1ea5gzb31T6wxJRfOrxO6AEeQC5VaL0A3hSi9JXHOsGE4E3b8JnTwfcsAQia+0VQsOOmdSfUoW5u0iw9zasMEV9Cqbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B9EC4CEF7;
	Thu, 13 Nov 2025 05:36:38 +0000 (UTC)
From: colyli@fnnas.com
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org,
	linux-block@vger.kernel.org,
	Coly Li <colyli@fnnas.com>
Subject: [PATCH 1/9] bcache: get rid of discard code from journal
Date: Thu, 13 Nov 2025 13:36:22 +0800
Message-ID: <20251113053630.54218-2-colyli@fnnas.com>
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

From: Coly Li <colyli@fnnas.com>

In bcache journal there is discard functionality but almost useless in
reality. Because discard happens after a journal bucket is reclaimed,
and the reclaimed bucket is allocated for new journaling immediately.
There is no time for underlying SSD to use the discard hint for internal
data management.

The discard code in bcache journal doesn't bring any performance
optimization and wastes CPU cycles for issuing discard bios. Therefore
this patch gits rid of it from journal.c and journal.h.

Signed-off-by: Coly Li <colyli@fnnas.com>
---
 drivers/md/bcache/journal.c | 93 ++++---------------------------------
 drivers/md/bcache/journal.h | 13 ------
 2 files changed, 8 insertions(+), 98 deletions(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index d50eb82ccb4f..144693b7c46a 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -275,8 +275,7 @@ int bch_journal_read(struct cache_set *c, struct list_head *list)
 			 * ja->cur_idx
 			 */
 			ja->cur_idx = i;
-			ja->last_idx = ja->discard_idx = (i + 1) %
-				ca->sb.njournal_buckets;
+			ja->last_idx = (i + 1) % ca->sb.njournal_buckets;
 
 		}
 
@@ -336,16 +335,6 @@ void bch_journal_mark(struct cache_set *c, struct list_head *list)
 	}
 }
 
-static bool is_discard_enabled(struct cache_set *s)
-{
-	struct cache *ca = s->cache;
-
-	if (ca->discard)
-		return true;
-
-	return false;
-}
-
 int bch_journal_replay(struct cache_set *s, struct list_head *list)
 {
 	int ret = 0, keys = 0, entries = 0;
@@ -360,15 +349,10 @@ int bch_journal_replay(struct cache_set *s, struct list_head *list)
 		BUG_ON(i->pin && atomic_read(i->pin) != 1);
 
 		if (n != i->j.seq) {
-			if (n == start && is_discard_enabled(s))
-				pr_info("journal entries %llu-%llu may be discarded! (replaying %llu-%llu)\n",
-					n, i->j.seq - 1, start, end);
-			else {
-				pr_err("journal entries %llu-%llu missing! (replaying %llu-%llu)\n",
-					n, i->j.seq - 1, start, end);
-				ret = -EIO;
-				goto err;
-			}
+			pr_err("journal entries %llu-%llu missing! (replaying %llu-%llu)\n",
+				n, i->j.seq - 1, start, end);
+			ret = -EIO;
+			goto err;
 		}
 
 		for (k = i->j.start;
@@ -568,65 +552,6 @@ static void btree_flush_write(struct cache_set *c)
 
 #define last_seq(j)	((j)->seq - fifo_used(&(j)->pin) + 1)
 
-static void journal_discard_endio(struct bio *bio)
-{
-	struct journal_device *ja =
-		container_of(bio, struct journal_device, discard_bio);
-	struct cache *ca = container_of(ja, struct cache, journal);
-
-	atomic_set(&ja->discard_in_flight, DISCARD_DONE);
-
-	closure_wake_up(&ca->set->journal.wait);
-	closure_put(&ca->set->cl);
-}
-
-static void journal_discard_work(struct work_struct *work)
-{
-	struct journal_device *ja =
-		container_of(work, struct journal_device, discard_work);
-
-	submit_bio(&ja->discard_bio);
-}
-
-static void do_journal_discard(struct cache *ca)
-{
-	struct journal_device *ja = &ca->journal;
-	struct bio *bio = &ja->discard_bio;
-
-	if (!ca->discard) {
-		ja->discard_idx = ja->last_idx;
-		return;
-	}
-
-	switch (atomic_read(&ja->discard_in_flight)) {
-	case DISCARD_IN_FLIGHT:
-		return;
-
-	case DISCARD_DONE:
-		ja->discard_idx = (ja->discard_idx + 1) %
-			ca->sb.njournal_buckets;
-
-		atomic_set(&ja->discard_in_flight, DISCARD_READY);
-		fallthrough;
-
-	case DISCARD_READY:
-		if (ja->discard_idx == ja->last_idx)
-			return;
-
-		atomic_set(&ja->discard_in_flight, DISCARD_IN_FLIGHT);
-
-		bio_init_inline(bio, ca->bdev, 1, REQ_OP_DISCARD);
-		bio->bi_iter.bi_sector	= bucket_to_sector(ca->set,
-						ca->sb.d[ja->discard_idx]);
-		bio->bi_iter.bi_size	= bucket_bytes(ca);
-		bio->bi_end_io		= journal_discard_endio;
-
-		closure_get(&ca->set->cl);
-		INIT_WORK(&ja->discard_work, journal_discard_work);
-		queue_work(bch_journal_wq, &ja->discard_work);
-	}
-}
-
 static unsigned int free_journal_buckets(struct cache_set *c)
 {
 	struct journal *j = &c->journal;
@@ -635,10 +560,10 @@ static unsigned int free_journal_buckets(struct cache_set *c)
 	unsigned int n;
 
 	/* In case njournal_buckets is not power of 2 */
-	if (ja->cur_idx >= ja->discard_idx)
-		n = ca->sb.njournal_buckets +  ja->discard_idx - ja->cur_idx;
+	if (ja->cur_idx >= ja->last_idx)
+		n = ca->sb.njournal_buckets + ja->last_idx - ja->cur_idx;
 	else
-		n = ja->discard_idx - ja->cur_idx;
+		n = ja->last_idx - ja->cur_idx;
 
 	if (n > (1 + j->do_reserve))
 		return n - (1 + j->do_reserve);
@@ -668,8 +593,6 @@ static void journal_reclaim(struct cache_set *c)
 		ja->last_idx = (ja->last_idx + 1) %
 			ca->sb.njournal_buckets;
 
-	do_journal_discard(ca);
-
 	if (c->journal.blocks_free)
 		goto out;
 
diff --git a/drivers/md/bcache/journal.h b/drivers/md/bcache/journal.h
index cd316b4a1e95..9e9d1b3016a5 100644
--- a/drivers/md/bcache/journal.h
+++ b/drivers/md/bcache/journal.h
@@ -139,19 +139,6 @@ struct journal_device {
 	/* Last journal bucket that still contains an open journal entry */
 	unsigned int		last_idx;
 
-	/* Next journal bucket to be discarded */
-	unsigned int		discard_idx;
-
-#define DISCARD_READY		0
-#define DISCARD_IN_FLIGHT	1
-#define DISCARD_DONE		2
-	/* 1 - discard in flight, -1 - discard completed */
-	atomic_t		discard_in_flight;
-
-	struct work_struct	discard_work;
-	struct bio		discard_bio;
-	struct bio_vec		discard_bv;
-
 	/* Bio for journal reads/writes to this device */
 	struct bio		bio;
 	struct bio_vec		bv[8];
-- 
2.47.3


