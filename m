Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E38964960
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Jul 2019 17:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfGJPMX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Jul 2019 11:12:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:32984 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726097AbfGJPMX (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Jul 2019 11:12:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F22ACAFA4;
        Wed, 10 Jul 2019 15:12:20 +0000 (UTC)
Subject: Re: [PATCH] bcache: fix deadlock in bcache_allocator()
To:     Andrea Righi <andrea.righi@canonical.com>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190710093117.GA2792@xps-13>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <82f1c5a9-9da4-3529-1ca5-af724d280580@suse.de>
Date:   Wed, 10 Jul 2019 23:11:37 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190710093117.GA2792@xps-13>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/7/10 5:31 下午, Andrea Righi wrote:
> bcache_allocator() can call the following:
> 
>  bch_allocator_thread()
>   -> bch_prio_write()
>      -> bch_bucket_alloc()
>         -> wait on &ca->set->bucket_wait
> 
> But the wake up event on bucket_wait is supposed to come from
> bch_allocator_thread() itself => deadlock:
> 
>  [ 242.888435] INFO: task bcache_allocato:9015 blocked for more than 120 seconds.
>  [ 242.893786] Not tainted 4.20.0-042000rc3-generic #201811182231
>  [ 242.896669] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>  [ 242.900428] bcache_allocato D 0 9015 2 0x80000000
>  [ 242.900434] Call Trace:
>  [ 242.900448] __schedule+0x2a2/0x880
>  [ 242.900455] ? __schedule+0x2aa/0x880
>  [ 242.900462] schedule+0x2c/0x80
>  [ 242.900480] bch_bucket_alloc+0x19d/0x380 [bcache]
>  [ 242.900503] ? wait_woken+0x80/0x80
>  [ 242.900519] bch_prio_write+0x190/0x340 [bcache]
>  [ 242.900530] bch_allocator_thread+0x482/0xd10 [bcache]
>  [ 242.900535] kthread+0x120/0x140
>  [ 242.900546] ? bch_invalidate_one_bucket+0x80/0x80 [bcache]
>  [ 242.900549] ? kthread_park+0x90/0x90
>  [ 242.900554] ret_from_fork+0x35/0x40
> 
> Fix by making the call to bch_prio_write() non-blocking, so that
> bch_allocator_thread() never waits on itself.
> 
> Moreover, make sure to wake up the garbage collector thread when
> bch_prio_write() is failing to allocate buckets.
> 
> BugLink: https://bugs.launchpad.net/bugs/1784665
> Signed-off-by: Andrea Righi <andrea.righi@canonical.com>

Hi Andrea,

From the BugLink, it seems several critical bcache fixes are missing.
Could you please to try current 5.3-rc kernel, and try whether such
problem exists or not ?

For this patch itself, it looks good except that I am not sure whether
invoking garbage collection is a proper method. Because bch_prio_write()
is called right after garbage collection gets done, jump back to
retry_invalidate: again may just hide a non-space long time waiting
condition.

Could you please give me some hint, on how to reproduce such hang
timeout situation. If I am lucky to reproduce such problem on 5.3-rc
kernel, it may be very helpful to understand what exact problem your
patch fixes.

Thanks in advance.

Coly Li


> ---
>  drivers/md/bcache/alloc.c  |  6 +++++-
>  drivers/md/bcache/bcache.h |  2 +-
>  drivers/md/bcache/super.c  | 13 +++++++++----
>  3 files changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
> index f8986effcb50..0797587600c7 100644
> --- a/drivers/md/bcache/alloc.c
> +++ b/drivers/md/bcache/alloc.c
> @@ -377,7 +377,11 @@ static int bch_allocator_thread(void *arg)
>  			if (!fifo_full(&ca->free_inc))
>  				goto retry_invalidate;
>  
> -			bch_prio_write(ca);
> +			if (bch_prio_write(ca, false) < 0) {
> +				ca->invalidate_needs_gc = 1;
> +				wake_up_gc(ca->set);
> +				goto retry_invalidate;
> +			}
>  		}
>  	}
>  out:
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index fdf75352e16a..dc5106b21260 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -979,7 +979,7 @@ bool bch_cached_dev_error(struct cached_dev *dc);
>  __printf(2, 3)
>  bool bch_cache_set_error(struct cache_set *c, const char *fmt, ...);
>  
> -void bch_prio_write(struct cache *ca);
> +int bch_prio_write(struct cache *ca, bool wait);
>  void bch_write_bdev_super(struct cached_dev *dc, struct closure *parent);
>  
>  extern struct workqueue_struct *bcache_wq;
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 1b63ac876169..6598b457df1a 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -525,7 +525,7 @@ static void prio_io(struct cache *ca, uint64_t bucket, int op,
>  	closure_sync(cl);
>  }
>  
> -void bch_prio_write(struct cache *ca)
> +int bch_prio_write(struct cache *ca, bool wait)
>  {
>  	int i;
>  	struct bucket *b;
> @@ -560,8 +560,12 @@ void bch_prio_write(struct cache *ca)
>  		p->magic	= pset_magic(&ca->sb);
>  		p->csum		= bch_crc64(&p->magic, bucket_bytes(ca) - 8);
>  
> -		bucket = bch_bucket_alloc(ca, RESERVE_PRIO, true);
> -		BUG_ON(bucket == -1);
> +		bucket = bch_bucket_alloc(ca, RESERVE_PRIO, wait);
> +		if (bucket == -1) {
> +			if (!wait)
> +				return -ENOMEM;
> +			BUG_ON(1);
> +		}
>  
>  		mutex_unlock(&ca->set->bucket_lock);
>  		prio_io(ca, bucket, REQ_OP_WRITE, 0);
> @@ -589,6 +593,7 @@ void bch_prio_write(struct cache *ca)
>  
>  		ca->prio_last_buckets[i] = ca->prio_buckets[i];
>  	}
> +	return 0;
>  }
>  
>  static void prio_read(struct cache *ca, uint64_t bucket)
> @@ -1903,7 +1908,7 @@ static int run_cache_set(struct cache_set *c)
>  
>  		mutex_lock(&c->bucket_lock);
>  		for_each_cache(ca, c, i)
> -			bch_prio_write(ca);
> +			bch_prio_write(ca, true);
>  		mutex_unlock(&c->bucket_lock);
>  
>  		err = "cannot allocate new UUID bucket";
> 


-- 

Coly Li
