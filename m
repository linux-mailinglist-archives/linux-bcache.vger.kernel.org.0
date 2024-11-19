Return-Path: <linux-bcache+bounces-793-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A958C9D208A
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Nov 2024 07:59:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 62DB01F2323F
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Nov 2024 06:59:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FACD14D44D;
	Tue, 19 Nov 2024 06:58:40 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-m49235.qiye.163.com (mail-m49235.qiye.163.com [45.254.49.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF4B14AD1A
	for <linux-bcache@vger.kernel.org>; Tue, 19 Nov 2024 06:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731999519; cv=none; b=BIup7TVO1oUXQ2HiD+S6R8217eHHmsIAU+wr77GMaOyo209GiVDpqd4UKob7sB4IvGn3GwYklcAVI91jGJsO+RNVu7cyPH9pcO6eqVmfTRD1Tg6cywmCKxgQClLTujnwNYNwVstM5U5HIWgkGzvc7I2Lf64WslY29he+6z2xDwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731999519; c=relaxed/simple;
	bh=XjZ3PlNt4babuA8LY9Qu7sxkinu73O6WzbsEZBuO4hA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u1cmnnvD2RNYJ1c3ZZEXfiXGeoAnI8DoVqO8BsnsC13gv3Bqk865NG+WjO9BcVWEFkFwewhTP0ES48hYQpdpqb9ZTPdQTWlLceptJuC0PbY5XkGr6S3p1s+WPSqFyQn0JkySm2OiXBnyg9um6g3y/+mN3N4QCao6LJJvksBHJXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=easystack.cn; spf=none smtp.mailfrom=easystack.cn; arc=none smtp.client-ip=45.254.49.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=easystack.cn
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 18abbff2;
	Tue, 19 Nov 2024 11:29:14 +0800 (GMT+08:00)
From: mingzhe.zou@easystack.cn
To: colyli@suse.de
Cc: linux-bcache@vger.kernel.org,
	dongsheng.yang@easystack.cn,
	zoumingzhe@qq.com
Subject: [PATCH 3/3] bcache: remove unused parameters
Date: Tue, 19 Nov 2024 11:28:52 +0800
Message-Id: <20241119032852.2511-3-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241119032852.2511-1-mingzhe.zou@easystack.cn>
References: <20241119032852.2511-1-mingzhe.zou@easystack.cn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkaHxhJVh1NGk0eGEtIGkxIGVYVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0hKTkxKVUpLS1
	VKQktLWQY+
X-HM-Tid: 0a9342779a7f022bkunm18abbff2
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OjI6KQw*KzcoCUkdLUweCBIM
	EToaC01VSlVKTEhKQkNNQk5OQ0JJVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
	C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBT0tJSDcG

From: Mingzhe Zou <mingzhe.zou@easystack.cn>

We have prevented the bucket in use from being reclaimed and reused.
So, search->recoverable and search->read_dirty_data are unused.

Moreover, we do not need to consider that the bucket is reused during
cache reading.

Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/request.c | 45 +------------------------------------
 1 file changed, 1 insertion(+), 44 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 3e76ae687045..8cb22ab4a79a 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -484,9 +484,7 @@ struct search {
 	struct bcache_device	*d;
 
 	unsigned int		insert_bio_sectors;
-	unsigned int		recoverable:1;
 	unsigned int		write:1;
-	unsigned int		read_dirty_data:1;
 	unsigned int		cache_missed:1;
 
 	struct block_device	*orig_bdev;
@@ -507,11 +505,6 @@ static void bch_cache_read_endio(struct bio *bio)
 
 	if (bio->bi_status)
 		s->iop.status = bio->bi_status;
-	else if (!KEY_DIRTY(&b->key) &&
-		 ptr_stale(s->iop.c, &b->key, 0)) {
-		atomic_long_inc(&s->iop.c->cache_read_races);
-		s->iop.status = BLK_STS_IOERR;
-	}
 
 	bch_bbio_endio(s->iop.c, bio, bio->bi_status, "reading from cache");
 }
@@ -609,7 +602,6 @@ static CLOSURE_CALLBACK(cache_lookup)
 {
 	closure_type(s, struct search, iop.cl);
 	struct bio *bio = &s->bio.bio;
-	struct cached_dev *dc;
 	int ret;
 
 	bch_btree_op_init(&s->op, -1);
@@ -633,12 +625,6 @@ static CLOSURE_CALLBACK(cache_lookup)
 	 */
 	if (ret < 0) {
 		BUG_ON(ret == -EINTR);
-		if (s->d && s->d->c &&
-				!UUID_FLASH_ONLY(&s->d->c->uuids[s->d->id])) {
-			dc = container_of(s->d, struct cached_dev, disk);
-			if (dc && atomic_read(&dc->has_dirty))
-				s->recoverable = false;
-		}
 		if (!s->iop.status)
 			s->iop.status = BLK_STS_IOERR;
 	}
@@ -654,10 +640,7 @@ static void request_endio(struct bio *bio)
 
 	if (bio->bi_status) {
 		struct search *s = container_of(cl, struct search, cl);
-
 		s->iop.status = bio->bi_status;
-		/* Only cache read errors are recoverable */
-		s->recoverable = false;
 	}
 
 	bio_put(bio);
@@ -687,7 +670,6 @@ static void backing_request_endio(struct bio *bio)
 			/* set to orig_bio->bi_status in bio_complete() */
 			s->iop.status = bio->bi_status;
 		}
-		s->recoverable = false;
 		/* should count I/O error for backing device here */
 		bch_count_backing_io_errors(dc, bio);
 	}
@@ -758,9 +740,7 @@ static inline struct search *search_alloc(struct bio *bio,
 	s->cache_miss		= NULL;
 	s->cache_missed		= 0;
 	s->d			= d;
-	s->recoverable		= 1;
 	s->write		= op_is_write(bio_op(bio));
-	s->read_dirty_data	= 0;
 	/* Count on the bcache device */
 	s->orig_bdev		= orig_bdev;
 	s->start_time		= start_time;
@@ -805,29 +785,6 @@ static CLOSURE_CALLBACK(cached_dev_read_error_done)
 
 static CLOSURE_CALLBACK(cached_dev_read_error)
 {
-	closure_type(s, struct search, cl);
-	struct bio *bio = &s->bio.bio;
-
-	/*
-	 * If read request hit dirty data (s->read_dirty_data is true),
-	 * then recovery a failed read request from cached device may
-	 * get a stale data back. So read failure recovery is only
-	 * permitted when read request hit clean data in cache device,
-	 * or when cache read race happened.
-	 */
-	if (s->recoverable && !s->read_dirty_data) {
-		/* Retry from the backing device: */
-		trace_bcache_read_retry(s->orig_bio);
-
-		s->iop.status = 0;
-		do_bio_hook(s, s->orig_bio, backing_request_endio);
-
-		/* XXX: invalidate cache */
-
-		/* I/O request sent to backing device */
-		closure_bio_submit(s->iop.c, bio, cl);
-	}
-
 	continue_at(cl, cached_dev_read_error_done, NULL);
 }
 
@@ -873,7 +830,7 @@ static CLOSURE_CALLBACK(cached_dev_read_done)
 		s->cache_miss = NULL;
 	}
 
-	if (verify(dc) && s->recoverable && !s->read_dirty_data)
+	if (verify(dc))
 		bch_data_verify(dc, s->orig_bio);
 
 	closure_get(&dc->disk.cl);
-- 
2.34.1


