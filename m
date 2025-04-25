Return-Path: <linux-bcache+bounces-964-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DFCBA9BE1F
	for <lists+linux-bcache@lfdr.de>; Fri, 25 Apr 2025 07:46:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BEC7166F35
	for <lists+linux-bcache@lfdr.de>; Fri, 25 Apr 2025 05:46:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF4931581EE;
	Fri, 25 Apr 2025 05:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dtdSGj7q"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DBB10957;
	Fri, 25 Apr 2025 05:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745559992; cv=none; b=N6ox30gu1W1TJsnq2jiczV6sGPYXxjayStjdMK0KceYgzaSzkyyrpmMg1Xv1d8SHkFUy1mu+PXGHohubM1kU0WJuTZOhqjvF+xXmoPJXq4lum/tXHLTZn+7Qqqmssat5pS9vTknlBAS5XY+7epJZ0v0ZyTRwZh00aIJP1yKDiao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745559992; c=relaxed/simple;
	bh=sDVXspGyyoyMVwq3rjp3VZVC/oLgFQDcBOXE4fzGneM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aJL8rx7labpelo2oBgL79B8Z2aLTtcnehyFfwM0G4b/017yenLZGv0VlnQSrO5+Cq0TzPznnYUuLyo73rR6rxhpdlHDIg8Z3YP7rWNefV+o7zIOTWAmRjpYAW/A8aKt5DnIX4AFjid+3EB94NdVAUK9587AM/HCX78ig1SMlzdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dtdSGj7q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9422FC4CEE4;
	Fri, 25 Apr 2025 05:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745559992;
	bh=sDVXspGyyoyMVwq3rjp3VZVC/oLgFQDcBOXE4fzGneM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dtdSGj7qzfeM3V+ymwnIcF+Mn94PTGxWdmOcbbbgNmCJA4fOHw+umQKAhV4Nq2PXU
	 fdN7L/DHYDWMZ+WfGvsbUml2RS5BqiJwhsZhYjA0CniPNXJsq7iyOVFXwrddUQ5kSY
	 ZMNnN9eNpqvy53nU7ZjnsQnd3fNtbHSlMKXAYQgWdiuZrl+5o3FH7xflOVhXbv+ITO
	 tIzNBuWHDzvAOI9n+vAPomXR5nEoOa0mSsVjOiS23CeFWVmnVAJvTjGcLtDK0S1vFZ
	 sM4Ax5sg0GMzHrNjCqwKCxZL2NT0hxFWq5fC0LvZyaOGl84Hwrpqwc3d8sbLyVEvf2
	 erARNFA0/U9Ag==
Date: Fri, 25 Apr 2025 13:46:26 +0800
From: Coly Li <colyli@kernel.org>
To: Zhou Jifeng <zhoujifeng@kylinos.com.cn>
Cc: kent.overstreet@linux.dev, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org, xiahua@kylinos.com.cn, dengwangbo@kylinos.com.cn
Subject: Re: [PATCH] bcache: add the deferred_flush IO processing path in the
 writeback mode
Message-ID: <ug3sqyn42af4bjsp3l5d5ymiabtc767oaoud3ddzv6jnw2eh27@4gcxqaq5tatf>
References: <20250425035021.921-1-zhoujifeng@kylinos.com.cn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250425035021.921-1-zhoujifeng@kylinos.com.cn>

Hi Jifeng,

Thanks for posting the patch.

On Fri, Apr 25, 2025 at 11:50:21AM +0800, Zhou Jifeng wrote:
> In some scenarios with high requirements for both data reliability and
> write performance, the various cache modes of the current bcache cannot

Could you provide the detail workload or circumstance which requires both
data reliability and write performance that current bcache cannot serve?


> fully match the requirements. deferred_flush aims to increase the
> reliability of writeback write-back. And reduce the sending of PREFLUSH
> requests to the backing device to enhance data security and dsync write
> performance in wrieback mode.

I'd like to see the detailed description on how deferred flush is defined,
and how it works. And why deferred flush may provide the data reliability
and performance better than current bcache code.

And a explicit and clear benchmakr for general workload is quite helpful
for me to understand your idea and how it works better.

I don't look into the patch yet, just with my intuition the overall
performance won't be quite optimized by setting FUA on writeback I/Os.

And the cache mode can swtich arbitarily in run time, if cache mode was none
or writethough, then switch to writeback, I don't see your patch handles
such situation.

Anyway, for performance optimization patch, an explicit markbench is
helpful. If the result is ideal, I'd like to reproduce it on my side.

Thanks.

Coly Li


 
> deferred_flush supports three selectable modes:
> none: do nothing (default )
> normal: sequential I/O bypasses the cache disk
> force: sequential I/O cannot bypass the cache disk
> 
> Signed-off-by: Zhou Jifeng <zhoujifeng@kylinos.com.cn>
> ---
>  drivers/md/bcache/bcache.h        |  6 ++++
>  drivers/md/bcache/bcache_ondisk.h |  5 +++
>  drivers/md/bcache/request.c       | 32 ++++++++++++++++--
>  drivers/md/bcache/sysfs.c         | 54 +++++++++++++++++++++++++++++++
>  drivers/md/bcache/writeback.c     |  7 ++++
>  drivers/md/bcache/writeback.h     |  4 +++
>  6 files changed, 106 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 785b0d9008fa..d2654c449d1c 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -405,6 +405,12 @@ struct cached_dev {
>  	 */
>  #define BCH_WBRATE_UPDATE_MAX_SKIPS	15
>  	unsigned int		rate_update_retry;
> +
> +	/*
> +	 * In the deferred flush mode, 0 indicates that there is no
> +	 * need to send flush to the backing device.
> +	 */
> +	atomic_t		need_flush;
>  };
>  
>  enum alloc_reserve {
> diff --git a/drivers/md/bcache/bcache_ondisk.h b/drivers/md/bcache/bcache_ondisk.h
> index 6620a7f8fffc..822dcdc0caaf 100644
> --- a/drivers/md/bcache/bcache_ondisk.h
> +++ b/drivers/md/bcache/bcache_ondisk.h
> @@ -294,6 +294,11 @@ BITMASK(BDEV_CACHE_MODE,		struct cache_sb, flags, 0, 4);
>  #define CACHE_MODE_WRITEBACK		1U
>  #define CACHE_MODE_WRITEAROUND		2U
>  #define CACHE_MODE_NONE			3U
> +BITMASK(BDEV_DEFERRED_FLUSH,		struct cache_sb, flags, 4, 3);
> +#define DEFERRED_FLUSH_NONE		0U
> +#define DEFERRED_FLUSH_NORMAL		1U
> +#define DEFERRED_FLUSH_FORCE		2U
> +
>  BITMASK(BDEV_STATE,			struct cache_sb, flags, 61, 2);
>  #define BDEV_STATE_NONE			0U
>  #define BDEV_STATE_CLEAN		1U
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index af345dc6fde1..8dc17d9c5f75 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -1026,16 +1026,28 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
>  		bio->bi_end_io = backing_request_endio;
>  		closure_bio_submit(s->iop.c, bio, cl);
>  
> +		if (BDEV_DEFERRED_FLUSH(&dc->sb))
> +			atomic_set(&dc->need_flush, 1);
> +
>  	} else if (s->iop.writeback) {
>  		bch_writeback_add(dc);
>  		s->iop.bio = bio;
>  
>  		if (bio->bi_opf & REQ_PREFLUSH) {
> +			struct bio *flush;
> +
> +			/*
> +			 * When DEFERRED_FLUSH is enabled, if need_flush is 0,
> +			 * there is no need to send a flush to the backing device.
> +			 */
> +			if (BDEV_DEFERRED_FLUSH(&dc->sb) &&
> +				 (!atomic_cmpxchg(&dc->need_flush, 1, 0)))
> +				goto insert_data;
> +
>  			/*
>  			 * Also need to send a flush to the backing
>  			 * device.
>  			 */
> -			struct bio *flush;
>  
>  			flush = bio_alloc_bioset(bio->bi_bdev, 0,
>  						 REQ_OP_WRITE | REQ_PREFLUSH,
> @@ -1050,6 +1062,9 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
>  			closure_bio_submit(s->iop.c, flush, cl);
>  		}
>  	} else {
> +		if (BDEV_DEFERRED_FLUSH(&dc->sb))
> +			atomic_set(&dc->need_flush, 1);
> +
>  		s->iop.bio = bio_alloc_clone(bio->bi_bdev, bio, GFP_NOIO,
>  					     &dc->disk.bio_split);
>  		/* I/O request sent to backing device */
> @@ -1066,14 +1081,27 @@ static CLOSURE_CALLBACK(cached_dev_nodata)
>  {
>  	closure_type(s, struct search, cl);
>  	struct bio *bio = &s->bio.bio;
> +	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
>  
> -	if (s->iop.flush_journal)
> +	if (s->iop.flush_journal) {
>  		bch_journal_meta(s->iop.c, cl);
>  
> +		/*
> +		 * When deferred flush is enabled, it is necessary to determine
> +		 * whether the flush request can be sent to the backing device.
> +		 */
> +		if (BDEV_DEFERRED_FLUSH(&dc->sb) &&
> +				 (!atomic_cmpxchg(&dc->need_flush, 1, 0))) {
> +			s->iop.status = BLK_STS_OK;
> +			goto end;
> +		}
> +	}
> +
>  	/* If it's a flush, we send the flush to the backing device too */
>  	bio->bi_end_io = backing_request_endio;
>  	closure_bio_submit(s->iop.c, bio, cl);
>  
> +end:
>  	continue_at(cl, cached_dev_bio_complete, NULL);
>  }
>  
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index e8f696cb58c0..3f343fba2f96 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -28,6 +28,25 @@ static const char * const bch_cache_modes[] = {
>  	NULL
>  };
>  
> +/*
> + * Deferred flush: In writeback mode, reduce unnecessary PREFLUSH
> + * passed to the backend disk to speed up the performance of dsync
> + * requests.Enhance data writeback security through FUA when dirty
> + * data is written back
> + *
> + * Default is 0 ("none")
> + * none: Do nothing
> + * normal: Sequential I/O bypasses the cache disk
> + * force: Sequential I/O cannot bypass the cache disk
> + */
> +static const char * const bch_deferred_flush[] = {
> +	"none",
> +	"normal",
> +	"force",
> +	NULL
> +};
> +
> +
>  static const char * const bch_reada_cache_policies[] = {
>  	"all",
>  	"meta-only",
> @@ -151,6 +170,7 @@ rw_attribute(copy_gc_enabled);
>  rw_attribute(idle_max_writeback_rate);
>  rw_attribute(gc_after_writeback);
>  rw_attribute(size);
> +rw_attribute(deferred_flush);
>  
>  static ssize_t bch_snprint_string_list(char *buf,
>  				       size_t size,
> @@ -283,6 +303,11 @@ SHOW(__bch_cached_dev)
>  		return strlen(buf);
>  	}
>  
> +	if (attr == &sysfs_deferred_flush)
> +		return bch_snprint_string_list(buf, PAGE_SIZE,
> +					       bch_deferred_flush,
> +					       BDEV_DEFERRED_FLUSH(&dc->sb));
> +
>  #undef var
>  	return 0;
>  }
> @@ -295,6 +320,7 @@ STORE(__cached_dev)
>  	ssize_t v;
>  	struct cache_set *c;
>  	struct kobj_uevent_env *env;
> +	struct bio flush;
>  
>  	/* no user space access if system is rebooting */
>  	if (bcache_is_reboot)
> @@ -383,6 +409,12 @@ STORE(__cached_dev)
>  			SET_BDEV_CACHE_MODE(&dc->sb, v);
>  			bch_write_bdev_super(dc, NULL);
>  		}
> +
> +		/* It's not the writeback mode that can't enable deferred_flush */
> +		if (BDEV_DEFERRED_FLUSH(&dc->sb) && ((unsigned int) v != CACHE_MODE_WRITEBACK)) {
> +			SET_BDEV_DEFERRED_FLUSH(&dc->sb, 0);
> +			bch_write_bdev_super(dc, NULL);
> +		}
>  	}
>  
>  	if (attr == &sysfs_readahead_cache_policy) {
> @@ -451,6 +483,27 @@ STORE(__cached_dev)
>  	if (attr == &sysfs_stop)
>  		bcache_device_stop(&dc->disk);
>  
> +	if (attr == &sysfs_deferred_flush) {
> +		v = __sysfs_match_string(bch_deferred_flush, -1, buf);
> +		if (v < 0)
> +			return v;
> +
> +		if ((unsigned int) v != BDEV_DEFERRED_FLUSH(&dc->sb)) {
> +			if (v && (BDEV_CACHE_MODE(&dc->sb) != CACHE_MODE_WRITEBACK)) {
> +				pr_err("It's not the writeback mode that can't enable deferred_flush.\n");
> +				return -EINVAL;
> +			}
> +
> +			SET_BDEV_DEFERRED_FLUSH(&dc->sb, v);
> +			bch_write_bdev_super(dc, NULL);
> +			if (v) {
> +				bio_init(&flush, dc->bdev, NULL, 0, REQ_OP_WRITE | REQ_PREFLUSH);
> +				/* I/O request sent to backing device */
> +				submit_bio_wait(&flush);
> +			}
> +		}
> +	}
> +
>  	return size;
>  }
>  
> @@ -541,6 +594,7 @@ static struct attribute *bch_cached_dev_attrs[] = {
>  #endif
>  	&sysfs_backing_dev_name,
>  	&sysfs_backing_dev_uuid,
> +	&sysfs_deferred_flush,
>  	NULL
>  };
>  ATTRIBUTE_GROUPS(bch_cached_dev);
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 453efbbdc8ee..68bf655f3b96 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -435,6 +435,13 @@ static CLOSURE_CALLBACK(write_dirty)
>  	if (KEY_DIRTY(&w->key)) {
>  		dirty_init(w);
>  		io->bio.bi_opf = REQ_OP_WRITE;
> +
> +		/* When DEFERRED_FLUSH is enabled, you need to ensure that
> +		 * data is flushed to disk.
> +		 */
> +		if (BDEV_DEFERRED_FLUSH(&dc->sb))
> +			io->bio.bi_opf |= REQ_FUA | REQ_SYNC | REQ_PREFLUSH;
> +
>  		io->bio.bi_iter.bi_sector = KEY_START(&w->key);
>  		bio_set_dev(&io->bio, io->dc->bdev);
>  		io->bio.bi_end_io	= dirty_endio;
> diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
> index 31df716951f6..0c92a607a875 100644
> --- a/drivers/md/bcache/writeback.h
> +++ b/drivers/md/bcache/writeback.h
> @@ -117,6 +117,10 @@ static inline bool should_writeback(struct cached_dev *dc, struct bio *bio,
>  				    bio_sectors(bio)))
>  		return true;
>  
> +	/* Prevent IO from bypassing the cache disk */
> +	if (BDEV_DEFERRED_FLUSH(&dc->sb) == DEFERRED_FLUSH_FORCE)
> +		return true;
> +
>  	if (would_skip)
>  		return false;
>  
> -- 
> 2.18.1
> 
> 

-- 
Coly Li

