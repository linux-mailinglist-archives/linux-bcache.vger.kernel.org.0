Return-Path: <linux-bcache+bounces-1365-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A0926D1A322
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Jan 2026 17:22:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CDB8A30674D5
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Jan 2026 16:18:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D6762C236B;
	Tue, 13 Jan 2026 16:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="ZJt1nKKv"
X-Original-To: linux-bcache@vger.kernel.org
Received: from sg-1-14.ptr.blmpb.com (sg-1-14.ptr.blmpb.com [118.26.132.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AD829BD85
	for <linux-bcache@vger.kernel.org>; Tue, 13 Jan 2026 16:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768321138; cv=none; b=IwXCDC6NynM1EjX/MZgIqt+gaIXDLYfotHnN/Izcl0tJgJZKzRjfv7UyPAVOTK9nrDpv3QLeNoRt0TESNw8LmR74BK9K9mvdhaB+gmZ3usYOTbmb55NBVAJc+K1iaqYD6yC1Rj68wpsTu+ODBlQFy0nTzVk53zes+miIGF/6fyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768321138; c=relaxed/simple;
	bh=z8QW9RM/QtCie70LzQhtGtw6a5KRTfRDA/Y3zNEPukc=;
	h=To:In-Reply-To:From:Date:Message-Id:Mime-Version:Cc:
	 Content-Disposition:Subject:References:Content-Type; b=nykdfWL/okXGOfydn/cOkX37Fp0gaoHIMTgn5lJevrpO3pLLr9bi2gleVnFnDJB9RHnDTFQKTsVQSqRHByKJkHVAsjbjpVPcP013mUrDG3XsCtl5cRPSc05tvb1AFbly4dXnMnB8MlMlxWhAcdU7n/8WSZ5o1PssS9rI/qJceTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=ZJt1nKKv; arc=none smtp.client-ip=118.26.132.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1768321128;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=1FEaWR6s3vACUbZUBJqrBfIUA2CDXoSFYAmZNWSjVqI=;
 b=ZJt1nKKvtR+wTGv23J9o6Z+yEezbqLCpLEUUOrRqSCRuMhueXMTymNddUfmoRQSdkFINQ0
 k0oaRAl2bGpYFgL09BM52NYqoZG9ACULv6hWimF3P+28kPWiD1RjMQCSGjMzuUxZTKl9X2
 /Rs92k0g2ONQ4SZGz1WVW3vPpj4inCLuFpsk7030jGtuuZvjPjm2Ke8CoFihw9JHwZk67h
 ue6fxpKJI99QbwHg5F/A61x2e3IPgLUBUAHItIUTCZxhf1BYdw/llj5g2r5JPSp4ukYRCG
 0zNdeL8rUcg5187qg2hX5HUFhBX90F7EyboKA4EbEpPN+DktX2faYA5xCCn9iA==
To: "Christoph Hellwig" <hch@infradead.org>
In-Reply-To: <aWYJRsxQcLfEXJlu@infradead.org>
Received: from studio.local ([120.245.64.3]) by smtp.feishu.cn with ESMTPS; Wed, 14 Jan 2026 00:18:45 +0800
Content-Transfer-Encoding: 7bit
From: "Coly Li" <colyli@fnnas.com>
Date: Wed, 14 Jan 2026 00:18:45 +0800
Message-Id: <aWZwBZaVVBC0otPd@studio.local>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Coly Li <colyli@fnnas.com>
X-Lms-Return-Path: <lba+269667066+e30e01+vger.kernel.org+colyli@fnnas.com>
Cc: "Kent Overstreet" <kent.overstreet@linux.dev>, <axboe@kernel.dk>, 
	<linux-block@vger.kernel.org>, <linux-bcache@vger.kernel.org>, 
	"Shida Zhang" <zhangshida@kylinos.cn>
Content-Disposition: inline
Subject: Re: [PATCH] Revert "bcache: fix improper use of bi_end_io"
References: <20260113060940.46489-1-colyli@fnnas.com> <aWX9WmRrlaCRuOqy@infradead.org> <aWYCe-MJKFaS__vi@moria.home.lan> <aWYDnKOdpT6gwL5b@infradead.org> <aWYDySBBmQ01JQOk@moria.home.lan> <aWYJRsxQcLfEXJlu@infradead.org>
Content-Type: text/plain; charset=UTF-8

On Tue, Jan 13, 2026 at 12:58:46AM +0800, Christoph Hellwig wrote:
> Anyway, Coly: I think the issue is that bcache tries to do a silly
> shortcut and reuses the bio for multiple layers of I/O which still trying
> to hook into completions for both.  Something like the (untested) patch
> below fixes that by cloning the bio and making everything work as
> expected.  I'm not sure how dead lock safe even the original version is,
> and my suspicion is that it needs a bio_set.  Of course even suggesting
> something will probably get me in trouble so take it with a grain of
> salt.
> 
> ---
> From 1a2336f617f2e351564ec20e4db9727584e04aa9 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Tue, 13 Jan 2026 09:53:34 +0100
> Subject: bcache: clone bio in detached_dev_do_request
> 
> Not-yet-Signed-off-by: Christoph Hellwig <hch@lst.de>

Hi Christoph,

This cloned bio method looks good. Could you please post a formal patch?
Then I may replace the revert commit with your patch.

Thanks.

Coly Li

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

