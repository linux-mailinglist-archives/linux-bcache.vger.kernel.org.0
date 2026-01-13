Return-Path: <linux-bcache+bounces-1361-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 98E8BD17705
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Jan 2026 10:00:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2372D30161C0
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Jan 2026 08:58:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A97BF363C57;
	Tue, 13 Jan 2026 08:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vsqC0brM"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B31C3128AE;
	Tue, 13 Jan 2026 08:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768294730; cv=none; b=BNgquZSSqwY7nSiD7jn7+BKMTXwlP3NGEWOHdF2+OUdqE+t5kkHQSzJ98avuYeWPdFI1kZ0yeKF9hAuU6HKF/lTogFm/npv74QhU7jkt+EThJ2RuTOfayc1y9W9IWhmNJLFrTr9MXM5x+LaGJJEgJl1bYbh/9DHTtiMjAsSMk0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768294730; c=relaxed/simple;
	bh=jrjP6j95c/8wllPaaUk3m4aPhraQkDBi4X3wo7AVk20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bqMyKP53VsAAkkHli0d2IxcAUD+exvS1kdr505YS7FnXnq4VW4/6V+ljqTZZaBiB+B0dtxH6zA1ZFYOgq+19Iio1IHXCz+b1LoHPiLjkav9wcRCXGFVvsfSqq1B6XDGUrSabnTY1yH0m+xv4++Pscnznqx2Y3ZevCo7vFZQnID8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vsqC0brM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=e+dG4xGgiyQt7O154N7Ew0Gw4qxgevpzhcNaMX1WhSc=; b=vsqC0brM4wTr20sMP5NH6b91rH
	VBH/aOJuaNmmbjlnnz8w5BA5kidTGrlfoYQR8YwnOQ8PGHgAcKWVmYhH4r6NuhuJJ/C05j51D1n0l
	oW0GRA2BwLmpDJwpGXKNHoDoUeKW9j+gzALKj3rw8VtT84aN+OLPx4jdco40UD+HP+jOhP+nE9glk
	jKWjTKAstA5d1Q4hcXXLOw4O1f16tDofp112zSg4FCeGAUNPPFfugV3oQ1jVhEMD6Xo+OTzkysfe0
	w/65NZ7x4yHGmnJJnMyAO8q8TtsLVFesKLEpiK3ChGrvQ8aq7N2D660eS1JREUFYBGtyOR1qNfbd2
	X8/p95Yw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vfaEg-00000006myx-3Ocr;
	Tue, 13 Jan 2026 08:58:46 +0000
Date: Tue, 13 Jan 2026 00:58:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Christoph Hellwig <hch@infradead.org>, colyli@fnnas.com,
	axboe@kernel.dk, linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org, Shida Zhang <zhangshida@kylinos.cn>
Subject: Re: [PATCH] Revert "bcache: fix improper use of bi_end_io"
Message-ID: <aWYJRsxQcLfEXJlu@infradead.org>
References: <20260113060940.46489-1-colyli@fnnas.com>
 <aWX9WmRrlaCRuOqy@infradead.org>
 <aWYCe-MJKFaS__vi@moria.home.lan>
 <aWYDnKOdpT6gwL5b@infradead.org>
 <aWYDySBBmQ01JQOk@moria.home.lan>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWYDySBBmQ01JQOk@moria.home.lan>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 13, 2026 at 03:39:28AM -0500, Kent Overstreet wrote:
> No. The original (buggy) patch has your name on it in the suggested-by,
> you should have done your homework.

How about you stop being a dick?  And if you're talking about homework
do you own and lookup that thread, and help implementing the suggestions
for fixing an API abuse, or at least reviewing them instead of angrily
shouting at someone suggesting to fix things.

> You need to reexamine your priorities here.

Maybe my priority should be to better ignore you..

Anyway, Coly: I think the issue is that bcache tries to do a silly
shortcut and reuses the bio for multiple layers of I/O which still trying
to hook into completions for both.  Something like the (untested) patch
below fixes that by cloning the bio and making everything work as
expected.  I'm not sure how dead lock safe even the original version is,
and my suspicion is that it needs a bio_set.  Of course even suggesting
something will probably get me in trouble so take it with a grain of
salt.

---
From 1a2336f617f2e351564ec20e4db9727584e04aa9 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Tue, 13 Jan 2026 09:53:34 +0100
Subject: bcache: clone bio in detached_dev_do_request

Not-yet-Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/request.c | 72 ++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 82fdea7dea7a..9e7b59121313 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1078,67 +1078,66 @@ static CLOSURE_CALLBACK(cached_dev_nodata)
 }
 
 struct detached_dev_io_private {
-	struct bcache_device	*d;
 	unsigned long		start_time;
-	bio_end_io_t		*bi_end_io;
-	void			*bi_private;
-	struct block_device	*orig_bdev;
+	struct bio		*orig_bio;
+	struct bio		bio;
 };
 
 static void detached_dev_end_io(struct bio *bio)
 {
-	struct detached_dev_io_private *ddip;
-
-	ddip = bio->bi_private;
-	bio->bi_end_io = ddip->bi_end_io;
-	bio->bi_private = ddip->bi_private;
+	struct detached_dev_io_private *ddip =
+		container_of(bio, struct detached_dev_io_private, bio);
+	struct bio *orig_bio = ddip->orig_bio;
 
 	/* Count on the bcache device */
-	bio_end_io_acct_remapped(bio, ddip->start_time, ddip->orig_bdev);
+	bio_end_io_acct(orig_bio, ddip->start_time);
 
 	if (bio->bi_status) {
-		struct cached_dev *dc = container_of(ddip->d,
-						     struct cached_dev, disk);
+		struct cached_dev *dc = bio->bi_private;
+
 		/* should count I/O error for backing device here */
 		bch_count_backing_io_errors(dc, bio);
+		orig_bio->bi_status = bio->bi_status;
 	}
 
 	kfree(ddip);
-	bio_endio(bio);
+	bio_endio(orig_bio);
 }
 
-static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
-		struct block_device *orig_bdev, unsigned long start_time)
+static void detached_dev_do_request(struct bcache_device *d,
+		struct bio *orig_bio, unsigned long start_time)
 {
 	struct detached_dev_io_private *ddip;
 	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
 
+	if (bio_op(orig_bio) == REQ_OP_DISCARD &&
+	    !bdev_max_discard_sectors(dc->bdev)) {
+		bio_endio(orig_bio);
+		return;
+	}
+
 	/*
 	 * no need to call closure_get(&dc->disk.cl),
 	 * because upper layer had already opened bcache device,
 	 * which would call closure_get(&dc->disk.cl)
 	 */
 	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
-	if (!ddip) {
-		bio->bi_status = BLK_STS_RESOURCE;
-		bio_endio(bio);
-		return;
-	}
-
-	ddip->d = d;
+	if (!ddip)
+		goto enomem;
+	if (bio_init_clone(dc->bdev, &ddip->bio, orig_bio, GFP_NOIO))
+		goto free_ddip;
 	/* Count on the bcache device */
-	ddip->orig_bdev = orig_bdev;
 	ddip->start_time = start_time;
-	ddip->bi_end_io = bio->bi_end_io;
-	ddip->bi_private = bio->bi_private;
-	bio->bi_end_io = detached_dev_end_io;
-	bio->bi_private = ddip;
-
-	if ((bio_op(bio) == REQ_OP_DISCARD) &&
-	    !bdev_max_discard_sectors(dc->bdev))
-		detached_dev_end_io(bio);
-	else
-		submit_bio_noacct(bio);
+	ddip->orig_bio = orig_bio;
+	ddip->bio.bi_end_io = detached_dev_end_io;
+	ddip->bio.bi_private = dc;
+	submit_bio_noacct(&ddip->bio);
+	return;
+free_ddip:
+	kfree(ddip);
+enomem:
+	orig_bio->bi_status = BLK_STS_RESOURCE;
+	bio_endio(orig_bio);
 }
 
 static void quit_max_writeback_rate(struct cache_set *c,
@@ -1214,10 +1213,10 @@ void cached_dev_submit_bio(struct bio *bio)
 
 	start_time = bio_start_io_acct(bio);
 
-	bio_set_dev(bio, dc->bdev);
 	bio->bi_iter.bi_sector += dc->sb.data_offset;
 
 	if (cached_dev_get(dc)) {
+		bio_set_dev(bio, dc->bdev);
 		s = search_alloc(bio, d, orig_bdev, start_time);
 		trace_bcache_request_start(s->d, bio);
 
@@ -1237,9 +1236,10 @@ void cached_dev_submit_bio(struct bio *bio)
 			else
 				cached_dev_read(dc, s);
 		}
-	} else
+	} else {
 		/* I/O request sent to backing device */
-		detached_dev_do_request(d, bio, orig_bdev, start_time);
+		detached_dev_do_request(d, bio, start_time);
+	}
 }
 
 static int cached_dev_ioctl(struct bcache_device *d, blk_mode_t mode,
-- 
2.47.3


