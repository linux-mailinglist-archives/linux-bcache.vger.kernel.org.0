Return-Path: <linux-bcache+bounces-1376-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 35DAAD39494
	for <lists+linux-bcache@lfdr.de>; Sun, 18 Jan 2026 12:51:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DEF593009562
	for <lists+linux-bcache@lfdr.de>; Sun, 18 Jan 2026 11:51:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42BE9285CB8;
	Sun, 18 Jan 2026 11:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="Qx3s62eB"
X-Original-To: linux-bcache@vger.kernel.org
Received: from sg-1-18.ptr.blmpb.com (sg-1-18.ptr.blmpb.com [118.26.132.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF3F1FF1B5
	for <linux-bcache@vger.kernel.org>; Sun, 18 Jan 2026 11:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768737102; cv=none; b=Xy4slJVUVXHT4wl/Q+NnARAwggWIK5q5i8Atp/rcYJ8HcuWKEuQjjANh08CRnMR5wE6fA4QGIT33UGBnHZd1od25IYuZ+4aOIIZ9fMbC3X46NHYHv8ypistXnsVwKH2a1rQ6EWdxWGWcQJOToLnm3vay3Rdi8r1tHMv2prJQeIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768737102; c=relaxed/simple;
	bh=TYrA+BtZ5tDVXnEw9Dj9X3sxVgMpJYqN/WIELjvkVkk=;
	h=Subject:Content-Disposition:To:Cc:From:Message-Id:Mime-Version:
	 References:In-Reply-To:Date:Content-Type; b=HZZ+ylwryVSPd9qFzBxvd1Yr0RS5b5FrTkyr0y2RGVylEcAD7b7tNerPFoZeEaA1d7MARFpE74ZfU6QBR1iTgaohKDhyeyYfR5yluri2J74hXWk96ErqKedJ10rkLq4LrsudCSDa6zBNq7DgOud+K7RVhXhSrg9gFLrSyvTqpNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=Qx3s62eB; arc=none smtp.client-ip=118.26.132.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1768736979;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Ei7NximDVGoTvpIerMVQGa2slchhbjINmFbfXFyQJ1E=;
 b=Qx3s62eBkMahFM6Yf2lmuvJR0Li0GVbfHBMBGRMfIv3TCzDZac3djoacBBQGAGvnsU7tId
 pIs0p/vxfGk05j4iX5NiMb5pVJdAvKbmQdTh6PQ5z3OxHHPjAuuC7ekjdXacJytHay13P+
 82S2N7oq3xUVV/2D5hoQFBVfoMIkLNNVyL3JTksExLxAbue5GlqK7tbkH6dVfZodgJrl0j
 38GZ0PRXsi6Hi3I2bh50ywIwtKVA99OYMBq+34+XGkTzOhaoEqkWWRQAxqF5YU+fY8ka/7
 K+b+HRRpDugGoPjreo00JAHfcUG4u3K7wC4dzA0Zmd1kLZE62vnBlO0jeWEQCA==
Subject: Re: [PATCH] bcache: fix double bio_endio completion in detached_dev_end_io
X-Lms-Return-Path: <lba+2696cc8d2+597c0b+vger.kernel.org+colyli@fnnas.com>
Received: from studio.local ([120.245.64.73]) by smtp.feishu.cn with ESMTPS; Sun, 18 Jan 2026 19:49:37 +0800
Content-Disposition: inline
To: "Christoph Hellwig" <hch@infradead.org>
Cc: "Stephen Zhang" <starzhangzsd@gmail.com>, <kent.overstreet@linux.dev>, 
	<axboe@kernel.dk>, <sashal@kernel.org>, <linux-bcache@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <zhangshida@kylinos.cn>
From: "Coly Li" <colyli@fnnas.com>
Content-Transfer-Encoding: 7bit
Message-Id: <aWzIU3ASp139lHNz@studio.local>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260115074811.230807-1-zhangshida@kylinos.cn> <CANubcdUdQ9gJ7uQELc80h0+FpurR5f2COmB3hBEDejavfFZJ9g@mail.gmail.com> <aWilW0RKQiHJzpsZ@infradead.org>
In-Reply-To: <aWilW0RKQiHJzpsZ@infradead.org>
Date: Sun, 18 Jan 2026 19:49:36 +0800
Content-Type: text/plain; charset=UTF-8
X-Original-From: Coly Li <colyli@fnnas.com>

On Thu, Jan 15, 2026 at 12:29:15AM +0800, Christoph Hellwig wrote:
> Can you please test this patch?
> 

Shida,
can you also test it and confirm? We need to get the fix in within 6.19 cycle.

Yes, we need to make a dicision ASAP.
I prefer the clone bio solution, and it looks fine to me.

Thanks in advance.

Coly Li




> commit d14f13516f60424f3cffc6d1837be566e360a8a3
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Tue Jan 13 09:53:34 2026 +0100
> 
>     bcache: clone bio in detached_dev_do_request
>     
>     Not-yet-Signed-off-by: Christoph Hellwig <hch@lst.de>
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

