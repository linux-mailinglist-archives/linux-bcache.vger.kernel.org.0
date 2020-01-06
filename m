Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3282131C16
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Jan 2020 00:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgAFXIg (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 6 Jan 2020 18:08:36 -0500
Received: from mx.ewheeler.net ([173.205.220.69]:54861 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726721AbgAFXIf (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 6 Jan 2020 18:08:35 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 4F789A0633;
        Mon,  6 Jan 2020 23:08:34 +0000 (UTC)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id tyrcgu0_T50Y; Mon,  6 Jan 2020 23:08:03 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 69684A0440;
        Mon,  6 Jan 2020 23:08:03 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 69684A0440
Date:   Mon, 6 Jan 2020 23:08:02 +0000 (UTC)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
X-X-Sender: lists@mx.ewheeler.net
To:     Coly Li <colyli@suse.de>
cc:     linux-bcache@vger.kernel.org
Subject: Re: [RFC PATCH 5/7] bcache: limit bcache btree node cache memory
 consumption by I/O throttle
In-Reply-To: <20200106160456.45689-6-colyli@suse.de>
Message-ID: <alpine.LRH.2.11.2001062306590.2074@mx.ewheeler.net>
References: <20200106160456.45689-1-colyli@suse.de> <20200106160456.45689-6-colyli@suse.de>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, 7 Jan 2020, Coly Li wrote:

> Now most of obvious deadlock or panic problems in bcache are fixed, so
> bcache now can survie under very high I/O load until ... it consumpts
> all system memory for bcache btree node cache, and the system hangs or
> panics.
> 
> The bcache btree node cache is used to cache the bcace btree node from
> SSD to memory, when determine whether a data block is cached or not
> by indexing the btree, the speed can be much more fast by an in-memory
> search.
> 
> Before this patch, there is no btree node cache memory limitation, just
> a slab shrinker callback registered to slab memory manager. If the I/O
> requests are coming faster than kernel memory management code to shrink
> the bcache btree node cache memory, it is possible for bcache to consume
> all available system memory for its btree node cache, and make whole
> system hang or panic. On high performance machine with many CPU cores,
> large memory size and SSD capanicity, it is often observed the whole
> system gets hung or panic afer 12+ hours high small random I/O load
> (e.g. 30K IOPS with 512 bytes random reads and writes).
> 
> This patch tries to limit bcache btree node cache memory consumption by
> I/O throttle. The idea is,
> 1) Add kernel thread c->btree_cache_shrink_thread to shrink in-memory
>    cached btree nodes.
> 2) Add a threshold c->btree_cache_threshold to limit number of in-memory
>    cached btree node, if c->btree_cache_used reaches the threshold, wake
>    up the shrink kernel thread to shrink in-memory cached btree nodes.
> 3) In the shrink kernel thread, call __bch_mca_scan() with reap_flush
>    parameter set to true, then all candidate clean and dirty (flush to
>    SSD before reap) btree nodes will be shrunk.
> 4) In the shrink kernel thread main loop, try to shrink 100 btree nodes
>    by calling __bch_mca_scan(). Inside __bch_mca_scan() c->bucket_lock
>    is held during shrinking all the 100 btree nodes. The shrinking will
>    stop until in-memory cached btree node number less than
> 	c->btree_cache_threshold - MCA_SHRINK_DEFAULT_HYSTERESIS
>    MCA_SHRINK_DEFAULT_HYSTERESIS is used to avoid the shrinking kernel
>    thread is waken up too frequently, by default its value is 1000.
> 
> The I/O throttle happens when __bch_mca_scan() is called in the while-
> loop inside the shrink kernel thread main loop.
> - Every time when __bch_mca_scan() is called, 100 btree nodes are about
>   to shrink. During __bch_mca_scan() shrinking all the btree nodes,
>   c->bucket_lock is held.
> - When a write request coming, bcache needs to allocate a SSD space for
>   the cached data with c->bucket_lock held. If __bch_mca_scan() is
>   executing to shrink btree node memory, the allocation operation has to
>   wait for c->bucket_lock.
> - When allocating in-memory btree node for new I/O request, mutex
>   c->bucket_lock is also required. If __bch_mca_scan() is running
>   new I/O request has to wait until the above 100 btree nodes are
>   shunk, then the new I/O request has chance to compete c->bucket_lock.
> Once c->bucket_lock is acquired inside shrink kernel thread, all other
> I/Os has to wait until the 100 in-memory btree node cache are shunk.
> Then the I/O requests are throttled by shrink kernel thread until all
> in-memory cached btree node number is less than,
> 	c->btree_cache_threshold - MCA_SHRINK_DEFAULT_HYSTERESIS
> 
> This is a simple but working method to limit bcache btree node cache
> memory consumption by I/O throttle.
> 
> By default c->btree_cache_threshold is 15000, if the btree node size is
> 2MB (default bucket size), it is around 30GB. It means if the bcache
> btree node cache accupies around 30GB memory, the shrink kernel thread
> will wake up and start to shrink the bcache in-memory btree node cache.
> 
> 30GB in-memory btree node cache is already big enough, it is reasonable
> for a default threshold. If there is report in fture that people do want
> to offer much more memory for bcache in-memory btree node cache, there
> will be a sysfs interface later for such configuration.

Is there already a sysfs that shows what is currently used by the cache?

--
Eric Wheeler



> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>  drivers/md/bcache/bcache.h |  3 +++
>  drivers/md/bcache/btree.c  | 63 ++++++++++++++++++++++++++++++++++++++++++++--
>  drivers/md/bcache/btree.h  |  3 +++
>  drivers/md/bcache/super.c  |  3 +++
>  4 files changed, 70 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index def15a6b4f7b..cff62084271b 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -589,6 +589,9 @@ struct cache_set {
>  	struct task_struct	*btree_cache_alloc_lock;
>  	spinlock_t		btree_cannibalize_lock;
>  
> +	unsigned int		btree_cache_threshold;
> +	struct task_struct	*btree_cache_shrink_thread;
> +
>  	/*
>  	 * When we free a btree node, we increment the gen of the bucket the
>  	 * node is in - but we can't rewrite the prios and gens until we
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index b37405aedf6e..ada17113482f 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -835,13 +835,64 @@ void bch_btree_cache_free(struct cache_set *c)
>  	mutex_unlock(&c->bucket_lock);
>  }
>  
> +#define MCA_SHRINK_DEFAULT_HYSTERESIS 1000
> +static int bch_mca_shrink_thread(void *arg)
> +{
> +
> +	struct cache_set *c = arg;
> +
> +	while (!kthread_should_stop() &&
> +	       !test_bit(CACHE_SET_IO_DISABLE, &c->flags)) {
> +
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		if (c->btree_cache_used < c->btree_cache_threshold ||
> +		    c->shrinker_disabled ||
> +		    c->btree_cache_alloc_lock) {
> +			/* quit main loop if kthread should stop */
> +			if (kthread_should_stop() ||
> +			    test_bit(CACHE_SET_IO_DISABLE, &c->flags)) {
> +				set_current_state(TASK_RUNNING);
> +				break;
> +			}
> +			schedule_timeout(30*HZ);
> +			continue;
> +		}
> +		set_current_state(TASK_RUNNING);
> +
> +		/* Now shrink mca cache memory */
> +		while (!kthread_should_stop() &&
> +		       !test_bit(CACHE_SET_IO_DISABLE, &c->flags) &&
> +		       ((c->btree_cache_used + MCA_SHRINK_DEFAULT_HYSTERESIS) >=
> +			c->btree_cache_threshold)) {
> +				struct shrink_control sc;
> +
> +				sc.gfp_mask = GFP_KERNEL;
> +				sc.nr_to_scan = 100 * c->btree_pages;
> +				__bch_mca_scan(&c->shrink, &sc, true);
> +				cond_resched();
> +		} /* shrink loop done */
> +	} /* kthread loop done */
> +
> +	wait_for_kthread_stop();
> +	return 0;
> +}
> +
>  int bch_btree_cache_alloc(struct cache_set *c)
>  {
>  	unsigned int i;
>  
> -	for (i = 0; i < mca_reserve(c); i++)
> -		if (!mca_bucket_alloc(c, &ZERO_KEY, GFP_KERNEL))
> +	c->btree_cache_shrink_thread =
> +		kthread_create(bch_mca_shrink_thread, c, "bcache_mca_shrink");
> +	if (IS_ERR_OR_NULL(c->btree_cache_shrink_thread))
> +		return -ENOMEM;
> +	c->btree_cache_threshold = BTREE_CACHE_THRESHOLD_DEFAULT;
> +
> +	for (i = 0; i < mca_reserve(c); i++) {
> +		if (!mca_bucket_alloc(c, &ZERO_KEY, GFP_KERNEL)) {
> +			kthread_stop(c->btree_cache_shrink_thread);
>  			return -ENOMEM;
> +		}
> +	}
>  
>  	list_splice_init(&c->btree_cache,
>  			 &c->btree_cache_freeable);
> @@ -961,6 +1012,14 @@ static struct btree *mca_alloc(struct cache_set *c, struct btree_op *op,
>  	if (mca_find(c, k))
>  		return NULL;
>  
> +	/*
> +	 * If too many btree node cache allocated, wake up
> +	 * the cache shrink thread to release btree node
> +	 * cache memory.
> +	 */
> +	if (c->btree_cache_used >= c->btree_cache_threshold)
> +		wake_up_process(c->btree_cache_shrink_thread);
> +
>  	/* btree_free() doesn't free memory; it sticks the node on the end of
>  	 * the list. Check if there's any freed nodes there:
>  	 */
> diff --git a/drivers/md/bcache/btree.h b/drivers/md/bcache/btree.h
> index f4dcca449391..3b1a423fb593 100644
> --- a/drivers/md/bcache/btree.h
> +++ b/drivers/md/bcache/btree.h
> @@ -102,6 +102,9 @@
>  #include "bset.h"
>  #include "debug.h"
>  
> +/* For 2MB bucket, 15000 is around 30GB memory */
> +#define BTREE_CACHE_THRESHOLD_DEFAULT 15000
> +
>  struct btree_write {
>  	atomic_t		*journal;
>  
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 047d9881f529..dc9455ae81b9 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1662,6 +1662,9 @@ static void cache_set_flush(struct closure *cl)
>  	if (!IS_ERR_OR_NULL(c->gc_thread))
>  		kthread_stop(c->gc_thread);
>  
> +	if (!IS_ERR_OR_NULL(c->btree_cache_shrink_thread))
> +		kthread_stop(c->btree_cache_shrink_thread);
> +
>  	if (!IS_ERR_OR_NULL(c->root))
>  		list_add(&c->root->list, &c->btree_cache);
>  
> -- 
> 2.16.4
> 
> 
