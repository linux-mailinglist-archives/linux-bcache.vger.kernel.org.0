Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 272312A838E
	for <lists+linux-bcache@lfdr.de>; Thu,  5 Nov 2020 17:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgKEQcb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 5 Nov 2020 11:32:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:56166 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726214AbgKEQca (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 5 Nov 2020 11:32:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1B08BAB4C;
        Thu,  5 Nov 2020 16:32:28 +0000 (UTC)
Subject: Re: [PATCH] bcache: consider the fragmentation when update the
 writeback rate
To:     Dongdong Tao <tdd21151186@gmail.com>
Cc:     gavin.guo@canonical.com, gerald.yang@canonical.com,
        trent.lloyd@canonical.com,
        dongdong tao <dongdong.tao@canonical.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20201103124235.14440-1-tdd21151186@gmail.com>
From:   Coly Li <colyli@suse.de>
Autocrypt: addr=colyli@suse.de; keydata=
 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
Message-ID: <8e043313-003b-41be-cbd0-ebcc247dcba2@suse.de>
Date:   Fri, 6 Nov 2020 00:32:17 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201103124235.14440-1-tdd21151186@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/11/3 20:42, Dongdong Tao wrote:
> From: dongdong tao <dongdong.tao@canonical.com>
> 
> Current way to calculate the writeback rate only considered the
> dirty sectors, this usually works fine when the fragmentation
> is not high, but it will give us unreasonable small rate when
> we are under a situation that very few dirty sectors consumed
> a lot dirty buckets. In some case, the dirty bucekts can reached
> to CUTOFF_WRITEBACK_SYNC while the dirty data(sectors) noteven
> reached the writeback_percent, the writeback rate will still
> be the minimum value (4k), thus it will cause all the writes to be
> stucked in a non-writeback mode because of the slow writeback.
> 
> This patch will try to accelerate the writeback rate when the
> fragmentation is high. It calculate the propotional_scaled value
> based on below:
> (dirty_sectors / writeback_rate_p_term_inverse) * fragment
> As we can see, the higher fragmentation will result a larger
> proportional_scaled value, thus cause a larger writeback rate.
> The fragment value is calculated based on below:
> (dirty_buckets *  bucket_size) / dirty_sectors
> If you think about it, the value of fragment will be always
> inside [1, bucket_size].
> 
> This patch only considers the fragmentation when the number of
> dirty_buckets reached to a dirty threshold(configurable by
> writeback_fragment_percent, default is 50), so bcache will
> remain the original behaviour before the dirty buckets reached
> the threshold.
> 
> Signed-off-by: dongdong tao <dongdong.tao@canonical.com>

Hi Dongdong,

Change the writeback rate does not effect the real throughput indeed,
your change is just increasing the upper limit hint of the writeback
throughput, the bottle neck is spinning drive for random I/O.

A good direction should be the moving gc. If the moving gc may work
faster, the situation you mentioned above could be relaxed a lot.

I will NACK this patch unless you may have a observable and reproducible
performance number.

Thanks.

Coly Li


> ---
>  drivers/md/bcache/bcache.h    |  1 +
>  drivers/md/bcache/sysfs.c     |  6 ++++++
>  drivers/md/bcache/writeback.c | 21 +++++++++++++++++++++
>  3 files changed, 28 insertions(+)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 1d57f48307e6..87632f7032b6 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -374,6 +374,7 @@ struct cached_dev {
>  	unsigned int		writeback_metadata:1;
>  	unsigned int		writeback_running:1;
>  	unsigned char		writeback_percent;
> +	unsigned char		writeback_fragment_percent;
>  	unsigned int		writeback_delay;
>  
>  	uint64_t		writeback_rate_target;
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index 554e3afc9b68..69499113aef8 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -115,6 +115,7 @@ rw_attribute(stop_when_cache_set_failed);
>  rw_attribute(writeback_metadata);
>  rw_attribute(writeback_running);
>  rw_attribute(writeback_percent);
> +rw_attribute(writeback_fragment_percent);
>  rw_attribute(writeback_delay);
>  rw_attribute(writeback_rate);
>  
> @@ -197,6 +198,7 @@ SHOW(__bch_cached_dev)
>  	var_printf(writeback_running,	"%i");
>  	var_print(writeback_delay);
>  	var_print(writeback_percent);
> +	var_print(writeback_fragment_percent);
>  	sysfs_hprint(writeback_rate,
>  		     wb ? atomic_long_read(&dc->writeback_rate.rate) << 9 : 0);
>  	sysfs_printf(io_errors,		"%i", atomic_read(&dc->io_errors));
> @@ -308,6 +310,9 @@ STORE(__cached_dev)
>  	sysfs_strtoul_clamp(writeback_percent, dc->writeback_percent,
>  			    0, bch_cutoff_writeback);
>  
> +	sysfs_strtoul_clamp(writeback_fragment_percent, dc->writeback_fragment_percent,
> +			    0, bch_cutoff_writeback_sync);
> +
>  	if (attr == &sysfs_writeback_rate) {
>  		ssize_t ret;
>  		long int v = atomic_long_read(&dc->writeback_rate.rate);
> @@ -498,6 +503,7 @@ static struct attribute *bch_cached_dev_files[] = {
>  	&sysfs_writeback_running,
>  	&sysfs_writeback_delay,
>  	&sysfs_writeback_percent,
> +	&sysfs_writeback_fragment_percent,
>  	&sysfs_writeback_rate,
>  	&sysfs_writeback_rate_update_seconds,
>  	&sysfs_writeback_rate_i_term_inverse,
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 3c74996978da..34babc89fdf3 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -88,6 +88,26 @@ static void __update_writeback_rate(struct cached_dev *dc)
>  	int64_t integral_scaled;
>  	uint32_t new_rate;
>  
> +	/*
> +	 * We need to consider the number of dirty buckets as well
> +	 * when calculating the proportional_scaled, Otherwise we might
> +	 * have an unreasonable small writeback rate at a highly fragmented situation
> +	 * when very few dirty sectors consumed a lot dirty buckets, the
> +	 * worst case is when dirty_data reached writeback_percent and
> +	 * dirty buckets reached to cutoff_writeback_sync, but the rate
> +	 * still will be at the minimum value, which will cause the write
> +	 * stuck at a non-writeback mode.
> +	 */
> +	struct cache_set *c = dc->disk.c;
> +
> +	if (c->gc_stats.in_use > dc->writeback_fragment_percent && dirty > 0) {
> +		int64_t dirty_buckets = (c->gc_stats.in_use * c->nbuckets) / 100;
> +		int64_t fragment = (dirty_buckets *  c->cache->sb.bucket_size) / dirty;
> +
> +		proportional_scaled =
> +		div_s64(dirty, dc->writeback_rate_p_term_inverse) * (fragment);
> +	}
> +
>  	if ((error < 0 && dc->writeback_rate_integral > 0) ||
>  	    (error > 0 && time_before64(local_clock(),
>  			 dc->writeback_rate.next + NSEC_PER_MSEC))) {
> @@ -969,6 +989,7 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
>  	dc->writeback_metadata		= true;
>  	dc->writeback_running		= false;
>  	dc->writeback_percent		= 10;
> +	dc->writeback_fragment_percent	= 50;
>  	dc->writeback_delay		= 30;
>  	atomic_long_set(&dc->writeback_rate.rate, 1024);
>  	dc->writeback_rate_minimum	= 8;
> 

