Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0A5741C84
	for <lists+linux-bcache@lfdr.de>; Thu, 29 Jun 2023 01:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbjF1XiC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 28 Jun 2023 19:38:02 -0400
Received: from mx.ewheeler.net ([173.205.220.69]:42806 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230340AbjF1XiB (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 28 Jun 2023 19:38:01 -0400
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 84C454B;
        Wed, 28 Jun 2023 16:38:01 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id HwNVA9KxvTtB; Wed, 28 Jun 2023 16:37:57 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 1985540;
        Wed, 28 Jun 2023 16:37:57 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 1985540
Date:   Wed, 28 Jun 2023 16:37:57 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Mingzhe Zou <mingzhe.zou@easystack.cn>
cc:     colyli@suse.de, linux-bcache@vger.kernel.org, zoumingzhe@qq.com
Subject: Re: [PATCH v2] Separate bch_moving_gc() from bch_btree_gc()
In-Reply-To: <20230628055235.255-1-mingzhe.zou@easystack.cn>
Message-ID: <4dac5ba5-fac3-3383-45ed-ca8c24a033b0@ewheeler.net>
References: <20230628055235.255-1-mingzhe.zou@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, 28 Jun 2023, Mingzhe Zou wrote:

> From: Mingzhe Zou <zoumingzhe@qq.com>
> 
> Moving gc uses cache->heap to defragment disk. Unlike btree gc,
> moving gc only takes up part of the disk bandwidth.
> 
> The number of heap is constant. However, the buckets released by
> each moving gc is limited. So bch_moving_gc() needs to be called
> multiple times.
> 
> If bch_gc_thread() always calls bch_btree_gc(), it will block
> the IO request.This patch allows bch_gc_thread() to only call
> bch_moving_gc() when there are many fragments.
> 
> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>


Hi Mingzhe,

Could this be used to free buckets down to a minimum bucket count?

See more below:



> ---
>  drivers/md/bcache/bcache.h   |  4 ++-
>  drivers/md/bcache/btree.c    | 66 ++++++++++++++++++++++++++++++++++--
>  drivers/md/bcache/movinggc.c |  2 ++
>  3 files changed, 68 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 5a79bb3c272f..155deff0ce05 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -461,7 +461,8 @@ struct cache {
>  	 * until a gc finishes - otherwise we could pointlessly burn a ton of
>  	 * cpu
>  	 */
> -	unsigned int		invalidate_needs_gc;
> +	unsigned int		invalidate_needs_gc:1;
> +	unsigned int		only_moving_gc:1;
>  
>  	bool			discard; /* Get rid of? */
>  
> @@ -629,6 +630,7 @@ struct cache_set {
>  	struct gc_stat		gc_stats;
>  	size_t			nbuckets;
>  	size_t			avail_nbuckets;
> +	size_t			fragment_nbuckets;
>  
>  	struct task_struct	*gc_thread;
>  	/* Where in the btree gc currently is */
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 68b9d7ca864e..6698a4480e05 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -88,6 +88,7 @@
>   * Test module load/unload
>   */
>  
> +#define COPY_GC_PERCENT		5
>  #define MAX_NEED_GC		64
>  #define MAX_SAVE_PRIO		72
>  #define MAX_GC_TIMES		100
> @@ -1705,6 +1706,7 @@ static void btree_gc_start(struct cache_set *c)
>  
>  	mutex_lock(&c->bucket_lock);
>  
> +	set_gc_sectors(c);
>  	c->gc_mark_valid = 0;
>  	c->gc_done = ZERO_KEY;
>  
> @@ -1825,8 +1827,51 @@ static void bch_btree_gc(struct cache_set *c)
>  	memcpy(&c->gc_stats, &stats, sizeof(struct gc_stat));
>  
>  	trace_bcache_gc_end(c);
> +}
> +
> +extern unsigned int bch_cutoff_writeback;
> +extern unsigned int bch_cutoff_writeback_sync;
> +
> +static bool moving_gc_should_run(struct cache_set *c)
> +{
> +	struct bucket *b;
> +	struct cache *ca = c->cache;
> +	size_t moving_gc_threshold = ca->sb.bucket_size >> 2, frag_percent;
> +	unsigned long used_buckets = 0, frag_buckets = 0, move_buckets = 0;
> +	unsigned long dirty_sectors = 0, frag_sectors, used_sectors;
> +
> +	if (c->gc_stats.in_use > bch_cutoff_writeback_sync)
> +		return true;
> +
> +	mutex_lock(&c->bucket_lock);
> +	for_each_bucket(b, ca) {
> +		if (GC_MARK(b) != GC_MARK_DIRTY)
> +			continue;
> +
> +		used_buckets++;
> +
> +		used_sectors = GC_SECTORS_USED(b);
> +		dirty_sectors += used_sectors;
> +
> +		if (used_sectors < ca->sb.bucket_size)
> +			frag_buckets++;
>  
> -	bch_moving_gc(c);
> +		if (used_sectors <= moving_gc_threshold)
> +			move_buckets++;
> +	}
> +	mutex_unlock(&c->bucket_lock);
> +
> +	c->fragment_nbuckets = frag_buckets;
> +	frag_sectors = used_buckets * ca->sb.bucket_size - dirty_sectors;
> +	frag_percent = div_u64(frag_sectors * 100, ca->sb.bucket_size * c->nbuckets);
> +
> +	if (move_buckets > ca->heap.size)
> +		return true;
> +
> +	if (frag_percent >= COPY_GC_PERCENT)
> +		return true;

For example, could we add this to `moving_gc_should_run`:

+	if (used_buckets >= MAX_USED_BUCKETS)
+		return true;

to solve the issue in this thread:
	https://www.spinics.net/lists/linux-bcache/msg11746.html

where MAX_USED_BUCKETS is a placeholder for a sysfs tunable like 
`cache_max_used_percent` ?

-Eric


> +
> +	return false;
>  }
>  
>  static bool gc_should_run(struct cache_set *c)
> @@ -1839,6 +1884,19 @@ static bool gc_should_run(struct cache_set *c)
>  	if (atomic_read(&c->sectors_to_gc) < 0)
>  		return true;
>  
> +	/*
> +	 * Moving gc uses cache->heap to defragment disk. Unlike btree gc,
> +	 * moving gc only takes up part of the disk bandwidth.
> +	 * The number of heap is constant. However, the buckets released by
> +	 * each moving gc is limited. So bch_moving_gc() needs to be called
> +	 * multiple times. If bch_gc_thread() always calls bch_btree_gc(),
> +	 * it will block the IO request.
> +	 */
> +	if (c->copy_gc_enabled && moving_gc_should_run(c)) {
> +		ca->only_moving_gc = 1;
> +		return true;
> +	}
> +
>  	return false;
>  }
>  
> @@ -1856,8 +1914,10 @@ static int bch_gc_thread(void *arg)
>  		    test_bit(CACHE_SET_IO_DISABLE, &c->flags))
>  			break;
>  
> -		set_gc_sectors(c);
> -		bch_btree_gc(c);
> +		if (!c->cache->only_moving_gc)
> +			bch_btree_gc(c);
> +
> +		bch_moving_gc(c);
>  	}
>  
>  	wait_for_kthread_stop();
> diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
> index 9f32901fdad1..04da088cefe8 100644
> --- a/drivers/md/bcache/movinggc.c
> +++ b/drivers/md/bcache/movinggc.c
> @@ -200,6 +200,8 @@ void bch_moving_gc(struct cache_set *c)
>  	struct bucket *b;
>  	unsigned long sectors_to_move, reserve_sectors;
>  
> +	c->cache->only_moving_gc = 0;
> +
>  	if (!c->copy_gc_enabled)
>  		return;
>  
> -- 
> 2.17.1.windows.2
> 
> 
