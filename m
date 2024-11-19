Return-Path: <linux-bcache+bounces-797-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CD3859D29F3
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Nov 2024 16:44:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E7788B2E702
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Nov 2024 15:40:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B604E1D0DF7;
	Tue, 19 Nov 2024 15:37:35 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from ec2-44-216-146-176.compute-1.amazonaws.com (ec2-44-216-146-176.compute-1.amazonaws.com [44.216.146.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310C61D26F6
	for <linux-bcache@vger.kernel.org>; Tue, 19 Nov 2024 15:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.216.146.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732030655; cv=none; b=TuHM750t9+tmkDr89pN+2KC/9xEd0jnjerZS5OTE4BSQKRdHcseHpDSvRGxnkPPuAYALYoTxzmoKdRV9eAheGTW7dnLvsZ3ZicO4XMcnMQydNswP4nuEDlMjq1X8Fee3l9LH2MHK2E2asUJeIdNgQwwRlct2wdbHhDYBOcQVef0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732030655; c=relaxed/simple;
	bh=00ZSA2mbmV9RqyWMU988pEUYldEk6afcm1y3UmnLLVc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZBykKH85tYmqeelsE5l5FBgvYA6TwU25zyPvRb8AKAXZpVUFKHdeC9BRRIqEzRIgLEfofd1Wa8GhzZzxFbW8fBmm/5VkReL/mPqtBKXn7ylNMtA/+d0hfFOaMNT6PE3VrdjI+uTDLAJmZF9yiPCwK/xLK5Qk7TTIPF2jP1xFBdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=easystack.cn; spf=none smtp.mailfrom=easystack.cn; arc=none smtp.client-ip=44.216.146.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=easystack.cn
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 18ebb45f;
	Tue, 19 Nov 2024 15:40:52 +0800 (GMT+08:00)
From: mingzhe.zou@easystack.cn
To: colyli@suse.de
Cc: linux-bcache@vger.kernel.org,
	dongsheng.yang@easystack.cn,
	zoumingzhe@qq.com
Subject: [PATCH v2 2/3] bcache: fix io error during cache read race
Date: Tue, 19 Nov 2024 15:40:30 +0800
Message-Id: <20241119074031.27340-2-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241119074031.27340-1-mingzhe.zou@easystack.cn>
References: <20241119074031.27340-1-mingzhe.zou@easystack.cn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkZHR0aVkNISUNIGBpNHR5JH1YVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0lPT09LVUpLS1
	VLWQY+
X-HM-Tid: 0a93435dfa9c022bkunm18ebb45f
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6N006NSo5GjciTklCHi0rKU5N
	MjoaCUlVSlVKTEhJS0tJS05IQk9MVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
	C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBT0tCSTcG

From: Mingzhe Zou <mingzhe.zou@easystack.cn>

In our production environment, bcache returned IO_ERROR(errno=-5).
These errors always happen during 1M read IO under high pressure
and without any message log. When the error occurred, we stopped
all reading and writing and used 1M read IO to read the entire disk
without any errors. Later we found that cache_read_races of cache_set
is non-zero.

If a large (1M) read bio is split into two or more bios, when one bio
reads dirty data, s->read_dirty_data will be set to true and remain.
If the bucket was reused while our subsequent read bio was in flight,
the read will be unrecoverable(cannot read data from backing).

This patch increases the count for bucket->pin to prevent the bucket
from being reclaimed and reused.

Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/request.c | 39 ++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index af345dc6fde1..6c41957138e5 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -502,12 +502,8 @@ static void bch_cache_read_endio(struct bio *bio)
 	struct closure *cl = bio->bi_private;
 	struct search *s = container_of(cl, struct search, cl);
 
-	/*
-	 * If the bucket was reused while our bio was in flight, we might have
-	 * read the wrong data. Set s->error but not error so it doesn't get
-	 * counted against the cache device, but we'll still reread the data
-	 * from the backing device.
-	 */
+	BUG_ON(ptr_stale(s->iop.c, &b->key, 0)); // bucket should not be reused
+	atomic_dec(&PTR_BUCKET(s->iop.c, &b->key, 0)->pin);
 
 	if (bio->bi_status)
 		s->iop.status = bio->bi_status;
@@ -520,6 +516,8 @@ static void bch_cache_read_endio(struct bio *bio)
 	bch_bbio_endio(s->iop.c, bio, bio->bi_status, "reading from cache");
 }
 
+static void backing_request_endio(struct bio *bio);
+
 /*
  * Read from a single key, handling the initial cache miss if the key starts in
  * the middle of the bio
@@ -529,7 +527,6 @@ static int cache_lookup_fn(struct btree_op *op, struct btree *b, struct bkey *k)
 	struct search *s = container_of(op, struct search, op);
 	struct bio *n, *bio = &s->bio.bio;
 	struct bkey *bio_key;
-	unsigned int ptr;
 
 	if (bkey_cmp(k, &KEY(s->iop.inode, bio->bi_iter.bi_sector, 0)) <= 0)
 		return MAP_CONTINUE;
@@ -553,20 +550,36 @@ static int cache_lookup_fn(struct btree_op *op, struct btree *b, struct bkey *k)
 	if (!KEY_SIZE(k))
 		return MAP_CONTINUE;
 
-	/* XXX: figure out best pointer - for multiple cache devices */
-	ptr = 0;
+	/*
+	 * If the bucket was reused while our bio was in flight, we might have
+	 * read the wrong data. Set s->cache_read_races and reread the data
+	 * from the backing device.
+	 */
+	spin_lock(&PTR_BUCKET(b->c, k, 0)->lock);
+	if (ptr_stale(s->iop.c, k, 0)) {
+		spin_unlock(&PTR_BUCKET(b->c, k, 0)->lock);
+		atomic_long_inc(&s->iop.c->cache_read_races);
+		pr_warn("%pU cache read race count: %lu", s->iop.c->sb.set_uuid,
+			atomic_long_read(&s->iop.c->cache_read_races));
 
-	PTR_BUCKET(b->c, k, ptr)->prio = INITIAL_PRIO;
+		n->bi_end_io	= backing_request_endio;
+		n->bi_private	= &s->cl;
+
+		/* I/O request sent to backing device */
+		closure_bio_submit(s->iop.c, n, &s->cl);
+		return n == bio ? MAP_DONE : MAP_CONTINUE;
+	}
+	atomic_inc(&PTR_BUCKET(s->iop.c, k, 0)->pin);
+	spin_unlock(&PTR_BUCKET(b->c, k, 0)->lock);
 
-	if (KEY_DIRTY(k))
-		s->read_dirty_data = true;
+	PTR_BUCKET(b->c, k, 0)->prio = INITIAL_PRIO;
 
 	n = bio_next_split(bio, min_t(uint64_t, INT_MAX,
 				      KEY_OFFSET(k) - bio->bi_iter.bi_sector),
 			   GFP_NOIO, &s->d->bio_split);
 
 	bio_key = &container_of(n, struct bbio, bio)->key;
-	bch_bkey_copy_single_ptr(bio_key, k, ptr);
+	bch_bkey_copy_single_ptr(bio_key, k, 0);
 
 	bch_cut_front(&KEY(s->iop.inode, n->bi_iter.bi_sector, 0), bio_key);
 	bch_cut_back(&KEY(s->iop.inode, bio_end_sector(n), 0), bio_key);
-- 
2.34.1


