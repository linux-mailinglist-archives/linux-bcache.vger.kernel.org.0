Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C406FF778
	for <lists+linux-bcache@lfdr.de>; Sun, 17 Nov 2019 04:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfKQDeX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 16 Nov 2019 22:34:23 -0500
Received: from mx.ewheeler.net ([173.205.220.69]:55140 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbfKQDeX (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 16 Nov 2019 22:34:23 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 327ADA0694;
        Sun, 17 Nov 2019 03:34:14 +0000 (UTC)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id Dm2f_Cnp8rLV; Sun, 17 Nov 2019 03:33:52 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 84F0CA0693;
        Sun, 17 Nov 2019 03:33:50 +0000 (UTC)
Date:   Sun, 17 Nov 2019 03:33:44 +0000 (UTC)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
X-X-Sender: lists@mx.ewheeler.net
To:     Coly Li <colyli@suse.de>
cc:     axboe@kernel.dk, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org,
        Andrea Righi <andrea.righi@canonical.com>
Subject: Re: [PATCH 07/12] bcache: fix deadlock in bcache_allocator
In-Reply-To: <20191113080326.69989-8-colyli@suse.de>
Message-ID: <alpine.LRH.2.11.1911170333320.23583@mx.ewheeler.net>
References: <20191113080326.69989-1-colyli@suse.de> <20191113080326.69989-8-colyli@suse.de>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, 13 Nov 2019, Coly Li wrote:

> From: Andrea Righi <andrea.righi@canonical.com>
> 
> bcache_allocator can call the following:
> 
>  bch_allocator_thread()
>   -> bch_prio_write()
>      -> bch_bucket_alloc()
>         -> wait on &ca->set->bucket_wait
> 
> But the wake up event on bucket_wait is supposed to come from
> bch_allocator_thread() itself => deadlock:
> 
> [ 1158.490744] INFO: task bcache_allocato:15861 blocked for more than 10 seconds.
> [ 1158.495929]       Not tainted 5.3.0-050300rc3-generic #201908042232
> [ 1158.500653] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1158.504413] bcache_allocato D    0 15861      2 0x80004000
> [ 1158.504419] Call Trace:
> [ 1158.504429]  __schedule+0x2a8/0x670
> [ 1158.504432]  schedule+0x2d/0x90
> [ 1158.504448]  bch_bucket_alloc+0xe5/0x370 [bcache]
> [ 1158.504453]  ? wait_woken+0x80/0x80
> [ 1158.504466]  bch_prio_write+0x1dc/0x390 [bcache]
> [ 1158.504476]  bch_allocator_thread+0x233/0x490 [bcache]
> [ 1158.504491]  kthread+0x121/0x140
> [ 1158.504503]  ? invalidate_buckets+0x890/0x890 [bcache]
> [ 1158.504506]  ? kthread_park+0xb0/0xb0
> [ 1158.504510]  ret_from_fork+0x35/0x40
> 
> Fix by making the call to bch_prio_write() non-blocking, so that
> bch_allocator_thread() never waits on itself.
> 
> Moreover, make sure to wake up the garbage collector thread when
> bch_prio_write() is failing to allocate buckets.
> 
> BugLink: https://bugs.launchpad.net/bugs/1784665
> BugLink: https://bugs.launchpad.net/bugs/1796292
> Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
> Signed-off-by: Coly Li <colyli@suse.de>

Add cc stable?

-Eric


> ---
>  drivers/md/bcache/alloc.c  |  5 ++++-
>  drivers/md/bcache/bcache.h |  2 +-
>  drivers/md/bcache/super.c  | 27 +++++++++++++++++++++------
>  3 files changed, 26 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
> index 6f776823b9ba..a1df0d95151c 100644
> --- a/drivers/md/bcache/alloc.c
> +++ b/drivers/md/bcache/alloc.c
> @@ -377,7 +377,10 @@ static int bch_allocator_thread(void *arg)
>  			if (!fifo_full(&ca->free_inc))
>  				goto retry_invalidate;
>  
> -			bch_prio_write(ca);
> +			if (bch_prio_write(ca, false) < 0) {
> +				ca->invalidate_needs_gc = 1;
> +				wake_up_gc(ca->set);
> +			}
>  		}
>  	}
>  out:
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 3653faf3bf48..50241e045c70 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -978,7 +978,7 @@ bool bch_cached_dev_error(struct cached_dev *dc);
>  __printf(2, 3)
>  bool bch_cache_set_error(struct cache_set *c, const char *fmt, ...);
>  
> -void bch_prio_write(struct cache *ca);
> +int bch_prio_write(struct cache *ca, bool wait);
>  void bch_write_bdev_super(struct cached_dev *dc, struct closure *parent);
>  
>  extern struct workqueue_struct *bcache_wq;
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 623fdaf10c4c..d1352fcc6ff2 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -530,12 +530,29 @@ static void prio_io(struct cache *ca, uint64_t bucket, int op,
>  	closure_sync(cl);
>  }
>  
> -void bch_prio_write(struct cache *ca)
> +int bch_prio_write(struct cache *ca, bool wait)
>  {
>  	int i;
>  	struct bucket *b;
>  	struct closure cl;
>  
> +	pr_debug("free_prio=%zu, free_none=%zu, free_inc=%zu",
> +		 fifo_used(&ca->free[RESERVE_PRIO]),
> +		 fifo_used(&ca->free[RESERVE_NONE]),
> +		 fifo_used(&ca->free_inc));
> +
> +	/*
> +	 * Pre-check if there are enough free buckets. In the non-blocking
> +	 * scenario it's better to fail early rather than starting to allocate
> +	 * buckets and do a cleanup later in case of failure.
> +	 */
> +	if (!wait) {
> +		size_t avail = fifo_used(&ca->free[RESERVE_PRIO]) +
> +			       fifo_used(&ca->free[RESERVE_NONE]);
> +		if (prio_buckets(ca) > avail)
> +			return -ENOMEM;
> +	}
> +
>  	closure_init_stack(&cl);
>  
>  	lockdep_assert_held(&ca->set->bucket_lock);
> @@ -545,9 +562,6 @@ void bch_prio_write(struct cache *ca)
>  	atomic_long_add(ca->sb.bucket_size * prio_buckets(ca),
>  			&ca->meta_sectors_written);
>  
> -	//pr_debug("free %zu, free_inc %zu, unused %zu", fifo_used(&ca->free),
> -	//	 fifo_used(&ca->free_inc), fifo_used(&ca->unused));
> -
>  	for (i = prio_buckets(ca) - 1; i >= 0; --i) {
>  		long bucket;
>  		struct prio_set *p = ca->disk_buckets;
> @@ -565,7 +579,7 @@ void bch_prio_write(struct cache *ca)
>  		p->magic	= pset_magic(&ca->sb);
>  		p->csum		= bch_crc64(&p->magic, bucket_bytes(ca) - 8);
>  
> -		bucket = bch_bucket_alloc(ca, RESERVE_PRIO, true);
> +		bucket = bch_bucket_alloc(ca, RESERVE_PRIO, wait);
>  		BUG_ON(bucket == -1);
>  
>  		mutex_unlock(&ca->set->bucket_lock);
> @@ -594,6 +608,7 @@ void bch_prio_write(struct cache *ca)
>  
>  		ca->prio_last_buckets[i] = ca->prio_buckets[i];
>  	}
> +	return 0;
>  }
>  
>  static void prio_read(struct cache *ca, uint64_t bucket)
> @@ -1964,7 +1979,7 @@ static int run_cache_set(struct cache_set *c)
>  
>  		mutex_lock(&c->bucket_lock);
>  		for_each_cache(ca, c, i)
> -			bch_prio_write(ca);
> +			bch_prio_write(ca, true);
>  		mutex_unlock(&c->bucket_lock);
>  
>  		err = "cannot allocate new UUID bucket";
> -- 
> 2.16.4
> 
> 
