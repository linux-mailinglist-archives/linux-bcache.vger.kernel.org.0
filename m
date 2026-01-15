Return-Path: <linux-bcache+bounces-1372-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E3E66D23316
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Jan 2026 09:39:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1FFFF3005E90
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Jan 2026 08:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32DAB334C34;
	Thu, 15 Jan 2026 08:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zI67UewF"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90604334C27;
	Thu, 15 Jan 2026 08:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768465781; cv=none; b=ZZVxnJUb8VAGTXprBSLdBYYbu3SoELz+4TKwVsaeQUOX7RlIq3F3MuVQ37VGZ2UyJNV6wuPsQE+swh7fsjyJGRoCoyd5aR5ud3IFsUVCkALxOr6YMe6p4rRbQN3K8M48/BMt/z+nvnPQCRrTp8icKveGylYMpVhYZHPER6oLIgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768465781; c=relaxed/simple;
	bh=cVrHuIxp0SvzUNr7KdXh//WCduVHgy7NymILwK9lJYw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n+BcQMZb/QxixLK2euRNE8EE9O5S9XwM0c+mo6wcF2HnJxQPkojuMea4ySnBbs9FEsBPtOmSDAfgrJzTAM25+bj3CPvXDgS5FN4ObxhAVlQ+mfXAKaVKZTYOoxFkuAMJP6BdrRgWpIHP0SmHA6f9WpyGlVl04bvYKUcxiXHrVTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zI67UewF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Lirm5P/5wM0KRdGYWMDDtujON2xhe6+O9/mjAjVQEpU=; b=zI67UewF3GzpJo+PUC+F0dtt+L
	VH1kVE80pN6XahWMmlAFBiNB+3lUbGKNXs/WEx4qlb8UIik+P/xbNo/a/AghwG3jbYyrTBY4/lXuU
	Dzvv0yIvluvqKLfGaiPUdv7o0lcchOBCYhHY3ptOZrqKMk5C6Bq+xs5xwkXzLoO1kcxl2rKKaHQXc
	UhDKxfSfMD/LxxYAIsUP6bXWlVWSbT+v0ELrAT6ZbdUpwjGDY4GL+5y8Yt28LGoEh8JgWweXIQdZJ
	pEuq/p7mIS6s1aQFzyX8Nl3do77mrsa6qP+2fJi/qf6lC8azgDEBqNvhz6aIFSi4AJ3aqRCaQHWo6
	XFY3HElw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vgIjD-0000000Bzqb-2r8d;
	Thu, 15 Jan 2026 08:29:15 +0000
Date: Thu, 15 Jan 2026 00:29:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Stephen Zhang <starzhangzsd@gmail.com>
Cc: colyli@fnnas.com, kent.overstreet@linux.dev, axboe@kernel.dk,
	sashal@kernel.org, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Subject: Re: [PATCH] bcache: fix double bio_endio completion in
 detached_dev_end_io
Message-ID: <aWilW0RKQiHJzpsZ@infradead.org>
References: <20260115074811.230807-1-zhangshida@kylinos.cn>
 <CANubcdUdQ9gJ7uQELc80h0+FpurR5f2COmB3hBEDejavfFZJ9g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANubcdUdQ9gJ7uQELc80h0+FpurR5f2COmB3hBEDejavfFZJ9g@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Can you please test this patch?

commit d14f13516f60424f3cffc6d1837be566e360a8a3
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue Jan 13 09:53:34 2026 +0100

    bcache: clone bio in detached_dev_do_request
    
    Not-yet-Signed-off-by: Christoph Hellwig <hch@lst.de>

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

