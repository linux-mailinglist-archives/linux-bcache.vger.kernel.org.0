Return-Path: <linux-bcache+bounces-1362-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 002BFD17A30
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Jan 2026 10:32:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EA755303E687
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Jan 2026 09:31:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8358A38E100;
	Tue, 13 Jan 2026 09:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OUBp5wf7"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714D738734F
	for <linux-bcache@vger.kernel.org>; Tue, 13 Jan 2026 09:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768296466; cv=none; b=rDPpCtb+UGI0dx6dInCTggyC9gffBPhK+Bjh2GYCiNEXM9btN0Wz/Kr9N6W5Gt536TKHjScir+LGUtLXKlHVD79Q3gqanYWjtGZ7wdP4x2iNo6Qk+AEWLaJ4fz1PBZiLJyakhgHZdajkE8sSwIS9Px/9jXbBQc9ecCaRm5JwLm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768296466; c=relaxed/simple;
	bh=94MSUmL/MMDaPlt3cgKuBeh671e40jdkeghdKEH0BgQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EzMq6kTPzWXChFLB9eTj1bkVYiNex+ix+3qh1yBdwR3+ygKUNg5Uzu0ery+EUnWh83foxao+UFT1SnC8C80H4fxMyL7iygiD8cT/fpCx7pOyNoEUvCpO4ILbFOhb4jvPiUyL+XzKTQtfkds5qVTIEjrNy2qvV6KQRDer/Nh9gBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OUBp5wf7; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 13 Jan 2026 04:27:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768296443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hzffGuKIPIfE0BT34CMkXcHna2ejlS9HNOGvY77obiI=;
	b=OUBp5wf7erWRrARcrfOT0eL2k+ljBXRur8duvk2ib2QqYNVB6AwFKb5ZNbn6HIqWP/PT1J
	INiFypnSUyiN6WSqK5EGtm3GSdCjII+nLdCkEtBsy9N3lCq7FsIPmtbjph7eyb4OqYx1HP
	djm74zqFG87gI8F+l4NEWebxoqSk1Oc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Christoph Hellwig <hch@infradead.org>
Cc: colyli@fnnas.com, axboe@kernel.dk, linux-block@vger.kernel.org, 
	linux-bcache@vger.kernel.org, Shida Zhang <zhangshida@kylinos.cn>
Subject: Re: [PATCH] Revert "bcache: fix improper use of bi_end_io"
Message-ID: <aWYL9x5s1nB_B1Ho@moria.home.lan>
References: <20260113060940.46489-1-colyli@fnnas.com>
 <aWX9WmRrlaCRuOqy@infradead.org>
 <aWYCe-MJKFaS__vi@moria.home.lan>
 <aWYDnKOdpT6gwL5b@infradead.org>
 <aWYDySBBmQ01JQOk@moria.home.lan>
 <aWYJRsxQcLfEXJlu@infradead.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWYJRsxQcLfEXJlu@infradead.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 13, 2026 at 12:58:46AM -0800, Christoph Hellwig wrote:
> On Tue, Jan 13, 2026 at 03:39:28AM -0500, Kent Overstreet wrote:
> > No. The original (buggy) patch has your name on it in the suggested-by,
> > you should have done your homework.
> 
> How about you stop being a dick?  And if you're talking about homework
> do you own and lookup that thread, and help implementing the suggestions
> for fixing an API abuse, or at least reviewing them instead of angrily
> shouting at someone suggesting to fix things.

It's not being a dick to tell someone they need to slow down and be more
careful when they're doing something broken and arguing over the revert.

The priority is keeping things working for the end user. Show me that
you understand that point, and can slow down and be more careful - so I
don't have to take time out of my day when I've got other things that I
need to be working on - and I'll be able to engage in a much more
friendly manner.

> Anyway, Coly: I think the issue is that bcache tries to do a silly
> shortcut and reuses the bio for multiple layers of I/O which still trying
> to hook into completions for both.  Something like the (untested) patch
> below fixes that by cloning the bio and making everything work as
> expected.  I'm not sure how dead lock safe even the original version is,
> and my suspicion is that it needs a bio_set.  Of course even suggesting
> something will probably get me in trouble so take it with a grain of
> salt.

Cloning the bio is completely fine - that's a cleaner and more modern
approach.

I'd still like to know why you consider the bare bi_end_io calls
problematic. If it's just that you want the code clean so you can grep
for actual issues, that's an acceptable answer. Historically that's been
fine, and I haven't seen it cause issues, so I would like to be
enlightened on that point.

On a side note, I just yesterday had to shoot down another broken "fix"
for memory allocation profiling - where it, again, turned out that the
submitter hadn't confirmed anything he was basing his patch on by
testing.

One of the big factors in why I was ok with continuing bcachefs
development outside the kernel is that when getting patch submissions
from the kernel community, I repeatedly had to tell people that yes,
testing their code is, in fact their responsibility, and I even had
people argue with me over it - and at some point I realized that this
has literally never been an issue with submissions from people outside
the kernel community.

This is something that really needs to change.

> 
> ---
> From 1a2336f617f2e351564ec20e4db9727584e04aa9 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Tue, 13 Jan 2026 09:53:34 +0100
> Subject: bcache: clone bio in detached_dev_do_request
> 
> Not-yet-Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/bcache/request.c | 72 ++++++++++++++++++-------------------
>  1 file changed, 36 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 82fdea7dea7a..9e7b59121313 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -1078,67 +1078,66 @@ static CLOSURE_CALLBACK(cached_dev_nodata)
>  }
>  
>  struct detached_dev_io_private {
> -	struct bcache_device	*d;
>  	unsigned long		start_time;
> -	bio_end_io_t		*bi_end_io;
> -	void			*bi_private;
> -	struct block_device	*orig_bdev;
> +	struct bio		*orig_bio;
> +	struct bio		bio;
>  };
>  
>  static void detached_dev_end_io(struct bio *bio)
>  {
> -	struct detached_dev_io_private *ddip;
> -
> -	ddip = bio->bi_private;
> -	bio->bi_end_io = ddip->bi_end_io;
> -	bio->bi_private = ddip->bi_private;
> +	struct detached_dev_io_private *ddip =
> +		container_of(bio, struct detached_dev_io_private, bio);
> +	struct bio *orig_bio = ddip->orig_bio;
>  
>  	/* Count on the bcache device */
> -	bio_end_io_acct_remapped(bio, ddip->start_time, ddip->orig_bdev);
> +	bio_end_io_acct(orig_bio, ddip->start_time);
>  
>  	if (bio->bi_status) {
> -		struct cached_dev *dc = container_of(ddip->d,
> -						     struct cached_dev, disk);
> +		struct cached_dev *dc = bio->bi_private;
> +
>  		/* should count I/O error for backing device here */
>  		bch_count_backing_io_errors(dc, bio);
> +		orig_bio->bi_status = bio->bi_status;
>  	}
>  
>  	kfree(ddip);
> -	bio_endio(bio);
> +	bio_endio(orig_bio);
>  }
>  
> -static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
> -		struct block_device *orig_bdev, unsigned long start_time)
> +static void detached_dev_do_request(struct bcache_device *d,
> +		struct bio *orig_bio, unsigned long start_time)
>  {
>  	struct detached_dev_io_private *ddip;
>  	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
>  
> +	if (bio_op(orig_bio) == REQ_OP_DISCARD &&
> +	    !bdev_max_discard_sectors(dc->bdev)) {
> +		bio_endio(orig_bio);
> +		return;
> +	}
> +
>  	/*
>  	 * no need to call closure_get(&dc->disk.cl),
>  	 * because upper layer had already opened bcache device,
>  	 * which would call closure_get(&dc->disk.cl)
>  	 */
>  	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
> -	if (!ddip) {
> -		bio->bi_status = BLK_STS_RESOURCE;
> -		bio_endio(bio);
> -		return;
> -	}
> -
> -	ddip->d = d;
> +	if (!ddip)
> +		goto enomem;
> +	if (bio_init_clone(dc->bdev, &ddip->bio, orig_bio, GFP_NOIO))
> +		goto free_ddip;
>  	/* Count on the bcache device */
> -	ddip->orig_bdev = orig_bdev;
>  	ddip->start_time = start_time;
> -	ddip->bi_end_io = bio->bi_end_io;
> -	ddip->bi_private = bio->bi_private;
> -	bio->bi_end_io = detached_dev_end_io;
> -	bio->bi_private = ddip;
> -
> -	if ((bio_op(bio) == REQ_OP_DISCARD) &&
> -	    !bdev_max_discard_sectors(dc->bdev))
> -		detached_dev_end_io(bio);
> -	else
> -		submit_bio_noacct(bio);
> +	ddip->orig_bio = orig_bio;
> +	ddip->bio.bi_end_io = detached_dev_end_io;
> +	ddip->bio.bi_private = dc;
> +	submit_bio_noacct(&ddip->bio);
> +	return;
> +free_ddip:
> +	kfree(ddip);
> +enomem:
> +	orig_bio->bi_status = BLK_STS_RESOURCE;
> +	bio_endio(orig_bio);
>  }
>  
>  static void quit_max_writeback_rate(struct cache_set *c,
> @@ -1214,10 +1213,10 @@ void cached_dev_submit_bio(struct bio *bio)
>  
>  	start_time = bio_start_io_acct(bio);
>  
> -	bio_set_dev(bio, dc->bdev);
>  	bio->bi_iter.bi_sector += dc->sb.data_offset;
>  
>  	if (cached_dev_get(dc)) {
> +		bio_set_dev(bio, dc->bdev);
>  		s = search_alloc(bio, d, orig_bdev, start_time);
>  		trace_bcache_request_start(s->d, bio);
>  
> @@ -1237,9 +1236,10 @@ void cached_dev_submit_bio(struct bio *bio)
>  			else
>  				cached_dev_read(dc, s);
>  		}
> -	} else
> +	} else {
>  		/* I/O request sent to backing device */
> -		detached_dev_do_request(d, bio, orig_bdev, start_time);
> +		detached_dev_do_request(d, bio, start_time);
> +	}
>  }
>  
>  static int cached_dev_ioctl(struct bcache_device *d, blk_mode_t mode,
> -- 
> 2.47.3
> 

