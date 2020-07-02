Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A944C211743
	for <lists+linux-bcache@lfdr.de>; Thu,  2 Jul 2020 02:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgGBAik (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 1 Jul 2020 20:38:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:39804 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgGBAij (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Jul 2020 20:38:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 62419B1C2;
        Thu,  2 Jul 2020 00:38:35 +0000 (UTC)
Subject: Re: [PATCH 4/4] writeback: remove bdi->congested_fn
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Tejun Heo <tj@kernel.org>, dm-devel@redhat.com,
        cgroups@vger.kernel.org, linux-block@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20200701090622.3354860-1-hch@lst.de>
 <20200701090622.3354860-5-hch@lst.de>
From:   Coly Li <colyli@suse.de>
Autocrypt: addr=colyli@suse.de; keydata=
 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
Message-ID: <69234075-06c9-fcca-0c59-2452aa4e2714@suse.de>
Date:   Thu, 2 Jul 2020 08:38:29 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200701090622.3354860-5-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/7/1 17:06, Christoph Hellwig wrote:
> Except for pktdvd, the only places setting congested bits are file
> systems that allocate their own backing_dev_info structures.  And
> pktdvd is a deprecated driver that isn't useful in stack setup
> either.  So remove the dead congested_fn stacking infrastructure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

For the bcache part, Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li


> ---
>  drivers/block/drbd/drbd_main.c   | 59 --------------------------------
>  drivers/md/bcache/request.c      | 43 -----------------------
>  drivers/md/bcache/super.c        |  1 -
>  drivers/md/dm-cache-target.c     | 19 ----------
>  drivers/md/dm-clone-target.c     | 15 --------
>  drivers/md/dm-era-target.c       | 15 --------
>  drivers/md/dm-raid.c             | 12 -------
>  drivers/md/dm-table.c            | 37 +-------------------
>  drivers/md/dm-thin.c             | 16 ---------
>  drivers/md/dm.c                  | 33 ------------------
>  drivers/md/dm.h                  |  1 -
>  drivers/md/md-linear.c           | 24 -------------
>  drivers/md/md-multipath.c        | 23 -------------
>  drivers/md/md.c                  | 23 -------------
>  drivers/md/md.h                  |  4 ---
>  drivers/md/raid0.c               | 16 ---------
>  drivers/md/raid1.c               | 31 -----------------
>  drivers/md/raid10.c              | 26 --------------
>  drivers/md/raid5.c               | 25 --------------
>  fs/btrfs/disk-io.c               | 23 -------------
>  include/linux/backing-dev-defs.h |  4 ---
>  include/linux/backing-dev.h      |  4 ---
>  include/linux/device-mapper.h    | 11 ------
>  23 files changed, 1 insertion(+), 464 deletions(-)
> 

[snipped]

> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 7acf024e99f351..cda05fc61c3afa 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -1228,36 +1228,10 @@ static int cached_dev_ioctl(struct bcache_device *d, fmode_t mode,
>  	return __blkdev_driver_ioctl(dc->bdev, mode, cmd, arg);
>  }
>  
> -static int cached_dev_congested(void *data, int bits)
> -{
> -	struct bcache_device *d = data;
> -	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
> -	struct request_queue *q = bdev_get_queue(dc->bdev);
> -	int ret = 0;
> -
> -	if (bdi_congested(q->backing_dev_info, bits))
> -		return 1;
> -
> -	if (cached_dev_get(dc)) {
> -		unsigned int i;
> -		struct cache *ca;
> -
> -		for_each_cache(ca, d->c, i) {
> -			q = bdev_get_queue(ca->bdev);
> -			ret |= bdi_congested(q->backing_dev_info, bits);
> -		}
> -
> -		cached_dev_put(dc);
> -	}
> -
> -	return ret;
> -}
> -
>  void bch_cached_dev_request_init(struct cached_dev *dc)
>  {
>  	struct gendisk *g = dc->disk.disk;
>  
> -	g->queue->backing_dev_info->congested_fn = cached_dev_congested;
>  	dc->disk.cache_miss			= cached_dev_cache_miss;
>  	dc->disk.ioctl				= cached_dev_ioctl;
>  }
> @@ -1342,27 +1316,10 @@ static int flash_dev_ioctl(struct bcache_device *d, fmode_t mode,
>  	return -ENOTTY;
>  }
>  
> -static int flash_dev_congested(void *data, int bits)
> -{
> -	struct bcache_device *d = data;
> -	struct request_queue *q;
> -	struct cache *ca;
> -	unsigned int i;
> -	int ret = 0;
> -
> -	for_each_cache(ca, d->c, i) {
> -		q = bdev_get_queue(ca->bdev);
> -		ret |= bdi_congested(q->backing_dev_info, bits);
> -	}
> -
> -	return ret;
> -}
> -
>  void bch_flash_dev_request_init(struct bcache_device *d)
>  {
>  	struct gendisk *g = d->disk;
>  
> -	g->queue->backing_dev_info->congested_fn = flash_dev_congested;
>  	d->cache_miss				= flash_dev_cache_miss;
>  	d->ioctl				= flash_dev_ioctl;
>  }
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 2014016f9a60d3..1810d7ca2f6653 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -877,7 +877,6 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>  
>  	d->disk->queue			= q;
>  	q->queuedata			= d;
> -	q->backing_dev_info->congested_data = d;
>  	q->limits.max_hw_sectors	= UINT_MAX;
>  	q->limits.max_sectors		= UINT_MAX;
>  	q->limits.max_segment_size	= UINT_MAX;
> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index d3bb355819a421..24549dc92eeec5 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -421,8 +421,6 @@ struct cache {
>  
>  	struct rw_semaphore quiesce_lock;
>  
> -	struct dm_target_callbacks callbacks;
> -
>  	/*
>  	 * origin_blocks entries, discarded if set.
>  	 */
> @@ -2423,20 +2421,6 @@ static void set_cache_size(struct cache *cache, dm_cblock_t size)
>  	cache->cache_size = size;
>  }
>  
> -static int is_congested(struct dm_dev *dev, int bdi_bits)
> -{
> -	struct request_queue *q = bdev_get_queue(dev->bdev);
> -	return bdi_congested(q->backing_dev_info, bdi_bits);
> -}
> -
> -static int cache_is_congested(struct dm_target_callbacks *cb, int bdi_bits)
> -{
> -	struct cache *cache = container_of(cb, struct cache, callbacks);
> -
> -	return is_congested(cache->origin_dev, bdi_bits) ||
> -		is_congested(cache->cache_dev, bdi_bits);
> -}
> -
>  #define DEFAULT_MIGRATION_THRESHOLD 2048
>  
>  static int cache_create(struct cache_args *ca, struct cache **result)
> @@ -2471,9 +2455,6 @@ static int cache_create(struct cache_args *ca, struct cache **result)
>  			goto bad;
>  	}
>  
> -	cache->callbacks.congested_fn = cache_is_congested;
> -	dm_table_add_target_callbacks(ti->table, &cache->callbacks);
> -
>  	cache->metadata_dev = ca->metadata_dev;
>  	cache->origin_dev = ca->origin_dev;
>  	cache->cache_dev = ca->cache_dev;

[snipped]
