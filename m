Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597392FC511
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Jan 2021 00:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbhASXhb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 19 Jan 2021 18:37:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:52096 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389222AbhASOHo (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 19 Jan 2021 09:07:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AA9D0AB7F;
        Tue, 19 Jan 2021 14:07:01 +0000 (UTC)
To:     Dongdong Tao <tdd21151186@gmail.com>
Cc:     dongdong tao <dongdong.tao@canonical.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210119125639.21013-1-tdd21151186@gmail.com>
From:   Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: consider the fragmentation when update the
 writeback rate
Message-ID: <937e8096-b0fe-9fcc-87bd-dff82d760546@suse.de>
Date:   Tue, 19 Jan 2021 22:06:53 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210119125639.21013-1-tdd21151186@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 1/19/21 8:56 PM, Dongdong Tao wrote:
> From: dongdong tao <dongdong.tao@canonical.com>
> 
> Current way to calculate the writeback rate only considered the
> dirty sectors, this usually works fine when the fragmentation
> is not high, but it will give us unreasonable small rate when
> we are under a situation that very few dirty sectors consumed
> a lot dirty buckets. In some case, the dirty bucekts can reached
> to CUTOFF_WRITEBACK_SYNC while the dirty data(sectors) not even
> reached the writeback_percent, the writeback rate will still
> be the minimum value (4k), thus it will cause all the writes to be
> stucked in a non-writeback mode because of the slow writeback.
> 
> We accelerate the rate in 3 stages with different aggressiveness,
> the first stage starts when dirty buckets percent reach above
> BCH_WRITEBACK_FRAGMENT_THRESHOLD_LOW (50), the second is
> BCH_WRITEBACK_FRAGMENT_THRESHOLD_MID (57), the third is
> BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH (64). By default
> the first stage tries to writeback the amount of dirty data
> in one bucket (on average) in (1 / (dirty_buckets_percent - 50)) second,
> the second stage tries to writeback the amount of dirty data in one bucket
> in (1 / (dirty_buckets_percent - 57)) * 100 millisecond, the third
> stage tries to writeback the amount of dirty data in one bucket in
> (1 / (dirty_buckets_percent - 64)) millisecond. It is ok to be very
> aggressive in the last stage, as it is our last chance to pull it back.
> 
> Option writeback_consider_fragment to control whether we want
> this feature to be on or off, it's on by default.
> 
> Lastly, below is the performance data for all the testing result,
> including the data from production env:
> https://docs.google.com/document/d/
> 1AmbIEa_2MhB9bqhC3rfga9tp7n9YX9PLn0jSUxscVW0/edit?usp=sharing
> 
> Signed-off-by: dongdong tao <dongdong.tao@canonical.com>

Hi Dongdong,

Now overall the patch is OK for me, just minor comments  and please
check them inline.


> ---
>  drivers/md/bcache/bcache.h    |  4 ++++
>  drivers/md/bcache/sysfs.c     | 22 ++++++++++++++++++
>  drivers/md/bcache/writeback.c | 42 +++++++++++++++++++++++++++++++++++
>  drivers/md/bcache/writeback.h |  4 ++++
>  4 files changed, 72 insertions(+)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 1d57f48307e6..d7a84327b7f1 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -373,6 +373,7 @@ struct cached_dev {
>  	unsigned int		partial_stripes_expensive:1;
>  	unsigned int		writeback_metadata:1;
>  	unsigned int		writeback_running:1;
> +	unsigned int		writeback_consider_fragment:1;
>  	unsigned char		writeback_percent;
>  	unsigned int		writeback_delay;
>  
> @@ -385,6 +386,9 @@ struct cached_dev {
>  	unsigned int		writeback_rate_update_seconds;
>  	unsigned int		writeback_rate_i_term_inverse;
>  	unsigned int		writeback_rate_p_term_inverse;
> +	unsigned int		writeback_rate_fp_term_low;
> +	unsigned int		writeback_rate_fp_term_mid;
> +	unsigned int		writeback_rate_fp_term_high;
>  	unsigned int		writeback_rate_minimum;
>  
>  	enum stop_on_failure	stop_when_cache_set_failed;
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index 00a520c03f41..136899beadba 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -117,10 +117,14 @@ rw_attribute(writeback_running);
>  rw_attribute(writeback_percent);
>  rw_attribute(writeback_delay);
>  rw_attribute(writeback_rate);
> +rw_attribute(writeback_consider_fragment);
>  
>  rw_attribute(writeback_rate_update_seconds);
>  rw_attribute(writeback_rate_i_term_inverse);
>  rw_attribute(writeback_rate_p_term_inverse);
> +rw_attribute(writeback_rate_fp_term_low);
> +rw_attribute(writeback_rate_fp_term_mid);
> +rw_attribute(writeback_rate_fp_term_high);
>  rw_attribute(writeback_rate_minimum);
>  read_attribute(writeback_rate_debug);
>  
> @@ -195,6 +199,7 @@ SHOW(__bch_cached_dev)
>  	var_printf(bypass_torture_test,	"%i");
>  	var_printf(writeback_metadata,	"%i");
>  	var_printf(writeback_running,	"%i");
> +	var_printf(writeback_consider_fragment,	"%i");
>  	var_print(writeback_delay);
>  	var_print(writeback_percent);
>  	sysfs_hprint(writeback_rate,
> @@ -205,6 +210,9 @@ SHOW(__bch_cached_dev)
>  	var_print(writeback_rate_update_seconds);
>  	var_print(writeback_rate_i_term_inverse);
>  	var_print(writeback_rate_p_term_inverse);
> +	var_print(writeback_rate_fp_term_low);
> +	var_print(writeback_rate_fp_term_mid);
> +	var_print(writeback_rate_fp_term_high);
>  	var_print(writeback_rate_minimum);
>  
>  	if (attr == &sysfs_writeback_rate_debug) {
> @@ -303,6 +311,7 @@ STORE(__cached_dev)
>  	sysfs_strtoul_bool(bypass_torture_test, dc->bypass_torture_test);
>  	sysfs_strtoul_bool(writeback_metadata, dc->writeback_metadata);
>  	sysfs_strtoul_bool(writeback_running, dc->writeback_running);
> +	sysfs_strtoul_bool(writeback_consider_fragment, dc->writeback_consider_fragment);
>  	sysfs_strtoul_clamp(writeback_delay, dc->writeback_delay, 0, UINT_MAX);
>  
>  	sysfs_strtoul_clamp(writeback_percent, dc->writeback_percent,
> @@ -331,6 +340,15 @@ STORE(__cached_dev)
>  	sysfs_strtoul_clamp(writeback_rate_p_term_inverse,
>  			    dc->writeback_rate_p_term_inverse,
>  			    1, UINT_MAX);
> +	sysfs_strtoul_clamp(writeback_rate_fp_term_low,
> +			    dc->writeback_rate_fp_term_low,
> +			    1, UINT_MAX);
> +	sysfs_strtoul_clamp(writeback_rate_fp_term_mid,
> +			    dc->writeback_rate_fp_term_mid,
> +			    1, UINT_MAX);
> +	sysfs_strtoul_clamp(writeback_rate_fp_term_high,
> +			    dc->writeback_rate_fp_term_high,
> +			    1, UINT_MAX);


Here you should make sure the input value should always be in order,
  low < mid < high

Otherwise the calculation might be messed up.


>  	sysfs_strtoul_clamp(writeback_rate_minimum,
>  			    dc->writeback_rate_minimum,
>  			    1, UINT_MAX);
> @@ -499,9 +517,13 @@ static struct attribute *bch_cached_dev_files[] = {
>  	&sysfs_writeback_delay,
>  	&sysfs_writeback_percent,
>  	&sysfs_writeback_rate,
> +	&sysfs_writeback_consider_fragment,
>  	&sysfs_writeback_rate_update_seconds,
>  	&sysfs_writeback_rate_i_term_inverse,
>  	&sysfs_writeback_rate_p_term_inverse,
> +	&sysfs_writeback_rate_fp_term_low,
> +	&sysfs_writeback_rate_fp_term_mid,
> +	&sysfs_writeback_rate_fp_term_high,
>  	&sysfs_writeback_rate_minimum,
>  	&sysfs_writeback_rate_debug,
>  	&sysfs_io_errors,
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index a129e4d2707c..9d440166c6bf 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -88,6 +88,44 @@ static void __update_writeback_rate(struct cached_dev *dc)
>  	int64_t integral_scaled;
>  	uint32_t new_rate;
>  
> +	/*
> +	 * We need to consider the number of dirty buckets as well
> +	 * when calculating the proportional_scaled, Otherwise we might
> +	 * have an unreasonable small writeback rate at a highly fragmented situation
> +	 * when very few dirty sectors consumed a lot dirty buckets, the
> +	 * worst case is when dirty buckets reached cutoff_writeback_sync and
> +	 * dirty data is still not even reached to writeback percent, so the rate
> +	 * still will be at the minimum value, which will cause the write
> +	 * stuck at a non-writeback mode.
> +	 */
> +	struct cache_set *c = dc->disk.c;
> +
> +	int64_t dirty_buckets = c->nbuckets - c->avail_nbuckets;
> +
> +	if (dc->writeback_consider_fragment &&
> +		c->gc_stats.in_use > BCH_WRITEBACK_FRAGMENT_THRESHOLD_LOW && dirty > 0) {
> +		int64_t fragment =
> +			div_s64((dirty_buckets *  c->cache->sb.bucket_size), dirty);
> +		int64_t fp_term;
> +		int64_t fps;
> +
> +		if (c->gc_stats.in_use <= BCH_WRITEBACK_FRAGMENT_THRESHOLD_MID) {
> +			fp_term = dc->writeback_rate_fp_term_low *
> +			(c->gc_stats.in_use - BCH_WRITEBACK_FRAGMENT_THRESHOLD_LOW);
> +		} else if (c->gc_stats.in_use <= BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH) {
> +			fp_term = dc->writeback_rate_fp_term_mid *
> +			(c->gc_stats.in_use - BCH_WRITEBACK_FRAGMENT_THRESHOLD_MID);
> +		} else {
> +			fp_term = dc->writeback_rate_fp_term_high *
> +			(c->gc_stats.in_use - BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH);
> +		}
> +		fps = div_s64(dirty, dirty_buckets) * fp_term;
> +		if (fragment > 3 && fps > proportional_scaled) {
> +			//Only overrite the p when fragment > 3

The above "//" style is not recommended as bcache coding style.


> +			proportional_scaled = fps;
> +		}
> +	}
> +
>  	if ((error < 0 && dc->writeback_rate_integral > 0) ||
>  	    (error > 0 && time_before64(local_clock(),
>  			 dc->writeback_rate.next + NSEC_PER_MSEC))) {
> @@ -977,6 +1015,7 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
>  
>  	dc->writeback_metadata		= true;
>  	dc->writeback_running		= false;
> +	dc->writeback_consider_fragment = true;
>  	dc->writeback_percent		= 10;
>  	dc->writeback_delay		= 30;
>  	atomic_long_set(&dc->writeback_rate.rate, 1024);
> @@ -984,6 +1023,9 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
>  
>  	dc->writeback_rate_update_seconds = WRITEBACK_RATE_UPDATE_SECS_DEFAULT;
>  	dc->writeback_rate_p_term_inverse = 40;
> +	dc->writeback_rate_fp_term_low = 1;
> +	dc->writeback_rate_fp_term_mid = 10;
> +	dc->writeback_rate_fp_term_high = 1000;

Could you please to explain a bit how the above 3 numbers are decided ?



>  	dc->writeback_rate_i_term_inverse = 10000;
>  
>  	WARN_ON(test_and_clear_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags));
> diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
> index 3f1230e22de0..02b2f9df73f6 100644
> --- a/drivers/md/bcache/writeback.h
> +++ b/drivers/md/bcache/writeback.h
> @@ -16,6 +16,10 @@
>  
>  #define BCH_AUTO_GC_DIRTY_THRESHOLD	50
>  
> +#define BCH_WRITEBACK_FRAGMENT_THRESHOLD_LOW 50
> +#define BCH_WRITEBACK_FRAGMENT_THRESHOLD_MID 57
> +#define BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH 64
> +
>  #define BCH_DIRTY_INIT_THRD_MAX	64
>  /*
>   * 14 (16384ths) is chosen here as something that each backing device
> 

Thanks in advance.

Coly Li
