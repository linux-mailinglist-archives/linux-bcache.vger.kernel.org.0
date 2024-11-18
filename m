Return-Path: <linux-bcache+bounces-790-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F9489D0C0B
	for <lists+linux-bcache@lfdr.de>; Mon, 18 Nov 2024 10:42:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8A709B20FF3
	for <lists+linux-bcache@lfdr.de>; Mon, 18 Nov 2024 09:42:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC9A918E03A;
	Mon, 18 Nov 2024 09:42:34 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-m1036.netease.com (mail-m1036.netease.com [154.81.10.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971DC22083
	for <linux-bcache@vger.kernel.org>; Mon, 18 Nov 2024 09:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=154.81.10.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731922954; cv=none; b=WM/SpANH0KluNp4ifhlnR6Z1A/qHxdycnQB9LQwZPP5AqFAlK4cA70lfmfB23H+P3vEZKsfQj3e/366QWOx3MIWUJTKxRukKhY0S0oVvFcAb+mp2JkitfClonB+2YuHpXP1DvOc+8+TZ8OsigH/B6dVnyLqOApdzWEnwbkZyb9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731922954; c=relaxed/simple;
	bh=REi77f3UIjp3koYsTQzPX10jUCasR3X7wjAnWwBlCs8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cEIiJqd0ghn2NmW49MtCCa58x5DljLmt0KedAsqO29HeG0tB8n2E8bO2C6ttboHbWlgm3vxNfR2aCChELvVO+NMnsQcavdLz0FFWGbYsA5sD+TezWH5J4NNlR6+nUZtQJIXqPMWM/d873NQOU4A+DRGqPu05t3vKTFdwFxwgLMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn; spf=pass smtp.mailfrom=easystack.cn; arc=none smtp.client-ip=154.81.10.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 18240ea8;
	Mon, 18 Nov 2024 17:27:02 +0800 (GMT+08:00)
From: mingzhe.zou@easystack.cn
To: colyli@suse.de
Cc: linux-bcache@vger.kernel.org,
	zoumingzhe@qq.com
Subject: [PATCH 2/3] bcache: fix io error during cache read race
Date: Mon, 18 Nov 2024 17:26:41 +0800
Message-Id: <20241118092642.7044-2-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241118092642.7044-1-mingzhe.zou@easystack.cn>
References: <20241118092642.7044-1-mingzhe.zou@easystack.cn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlDQ04eVhoaGEtLHx1JSk0eGFYVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0lPT09IVUpLS1
	VKQktLWQY+
X-HM-Tid: 0a933e98cff2022bkunm18240ea8
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NTo6Ohw4PjcoL0oaIy8fNggf
	GAEKFBRVSlVKTEhKQklJS0lISUlOVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
	C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBT0tDSDcG

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
 drivers/md/bcache/request.c | 44 +++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index af345dc6fde1..3e76ae687045 100644
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
@@ -553,20 +550,39 @@ static int cache_lookup_fn(struct btree_op *op, struct btree *b, struct bkey *k)
 	if (!KEY_SIZE(k))
 		return MAP_CONTINUE;
 
-	/* XXX: figure out best pointer - for multiple cache devices */
-	ptr = 0;
+	atomic_inc(&PTR_BUCKET(s->iop.c, k, 0)->pin);
 
-	PTR_BUCKET(b->c, k, ptr)->prio = INITIAL_PRIO;
-
-	if (KEY_DIRTY(k))
-		s->read_dirty_data = true;
+	PTR_BUCKET(b->c, k, 0)->prio = INITIAL_PRIO;
 
 	n = bio_next_split(bio, min_t(uint64_t, INT_MAX,
 				      KEY_OFFSET(k) - bio->bi_iter.bi_sector),
 			   GFP_NOIO, &s->d->bio_split);
 
+retry:
+	/*
+	 * If the bucket was reused while our bio was in flight, we might have
+	 * read the wrong data. Set s->cache_read_races and reread the data
+	 * from the backing device.
+	 */
+	if (ptr_stale(s->iop.c, k, 0)) {
+		if (PTR_BUCKET(b->c, k, 0)->invalidating)
+			goto retry;
+
+		atomic_dec(&PTR_BUCKET(s->iop.c, k, 0)->pin);
+		atomic_long_inc(&s->iop.c->cache_read_races);
+		pr_warn("%pU cache read race count: %lu", s->iop.c->sb.set_uuid,
+			atomic_long_read(&s->iop.c->cache_read_races));
+
+		n->bi_end_io	= backing_request_endio;
+		n->bi_private	= &s->cl;
+
+		/* I/O request sent to backing device */
+		closure_bio_submit(s->iop.c, n, &s->cl);
+		return n == bio ? MAP_DONE : MAP_CONTINUE;
+	}
+
 	bio_key = &container_of(n, struct bbio, bio)->key;
-	bch_bkey_copy_single_ptr(bio_key, k, ptr);
+	bch_bkey_copy_single_ptr(bio_key, k, 0);
 
 	bch_cut_front(&KEY(s->iop.inode, n->bi_iter.bi_sector, 0), bio_key);
 	bch_cut_back(&KEY(s->iop.inode, bio_end_sector(n), 0), bio_key);
-- 
2.34.1


