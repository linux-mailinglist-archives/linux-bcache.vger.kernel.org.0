Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A94B18494C
	for <lists+linux-bcache@lfdr.de>; Wed,  7 Aug 2019 12:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfHGKSu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 7 Aug 2019 06:18:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:55022 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726685AbfHGKSu (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 7 Aug 2019 06:18:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A0451AE6F;
        Wed,  7 Aug 2019 10:18:48 +0000 (UTC)
Subject: Re: [PATCH v2] bcache: fix deadlock in bcache_allocator
To:     Andrea Righi <andrea.righi@canonical.com>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190806091801.GC11184@xps-13> <20190806173648.GB27866@xps-13>
 <20190807092554.GB23070@xps-13>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <ade17acb-28e6-574b-b149-8ff8afeda3f3@suse.de>
Date:   Wed, 7 Aug 2019 18:18:40 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190807092554.GB23070@xps-13>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/8/7 5:25 下午, Andrea Righi wrote:
> On Tue, Aug 06, 2019 at 07:36:48PM +0200, Andrea Righi wrote:
>> On Tue, Aug 06, 2019 at 11:18:01AM +0200, Andrea Righi wrote:
>>> bcache_allocator() can call the following:
>>>
>>>  bch_allocator_thread()
>>>   -> bch_prio_write()
>>>      -> bch_bucket_alloc()
>>>         -> wait on &ca->set->bucket_wait
>>>
>>> But the wake up event on bucket_wait is supposed to come from
>>> bch_allocator_thread() itself => deadlock:
>>>
>>> [ 1158.490744] INFO: task bcache_allocato:15861 blocked for more than 10 seconds.
>>> [ 1158.495929]       Not tainted 5.3.0-050300rc3-generic #201908042232
>>> [ 1158.500653] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> [ 1158.504413] bcache_allocato D    0 15861      2 0x80004000
>>> [ 1158.504419] Call Trace:
>>> [ 1158.504429]  __schedule+0x2a8/0x670
>>> [ 1158.504432]  schedule+0x2d/0x90
>>> [ 1158.504448]  bch_bucket_alloc+0xe5/0x370 [bcache]
>>> [ 1158.504453]  ? wait_woken+0x80/0x80
>>> [ 1158.504466]  bch_prio_write+0x1dc/0x390 [bcache]
>>> [ 1158.504476]  bch_allocator_thread+0x233/0x490 [bcache]
>>> [ 1158.504491]  kthread+0x121/0x140
>>> [ 1158.504503]  ? invalidate_buckets+0x890/0x890 [bcache]
>>> [ 1158.504506]  ? kthread_park+0xb0/0xb0
>>> [ 1158.504510]  ret_from_fork+0x35/0x40
>>>
>>> Fix by making the call to bch_prio_write() non-blocking, so that
>>> bch_allocator_thread() never waits on itself.
>>>
>>> Moreover, make sure to wake up the garbage collector thread when
>>> bch_prio_write() is failing to allocate buckets.
>>>
>>> BugLink: https://bugs.launchpad.net/bugs/1784665
>>> BugLink: https://bugs.launchpad.net/bugs/1796292
>>> Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
>>> ---
>>> Changes in v2:
>>>  - prevent retry_invalidate busy loop in bch_allocator_thread()
>>>
>>>  drivers/md/bcache/alloc.c  |  5 ++++-
>>>  drivers/md/bcache/bcache.h |  2 +-
>>>  drivers/md/bcache/super.c  | 13 +++++++++----
>>>  3 files changed, 14 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
>>> index 6f776823b9ba..a1df0d95151c 100644
>>> --- a/drivers/md/bcache/alloc.c
>>> +++ b/drivers/md/bcache/alloc.c
>>> @@ -377,7 +377,10 @@ static int bch_allocator_thread(void *arg)
>>>  			if (!fifo_full(&ca->free_inc))
>>>  				goto retry_invalidate;
>>>  
>>> -			bch_prio_write(ca);
>>> +			if (bch_prio_write(ca, false) < 0) {
>>> +				ca->invalidate_needs_gc = 1;
>>> +				wake_up_gc(ca->set);
>>> +			}
>>>  		}
>>>  	}
>>>  out:
>>> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
>>> index 013e35a9e317..deb924e1d790 100644
>>> --- a/drivers/md/bcache/bcache.h
>>> +++ b/drivers/md/bcache/bcache.h
>>> @@ -977,7 +977,7 @@ bool bch_cached_dev_error(struct cached_dev *dc);
>>>  __printf(2, 3)
>>>  bool bch_cache_set_error(struct cache_set *c, const char *fmt, ...);
>>>  
>>> -void bch_prio_write(struct cache *ca);
>>> +int bch_prio_write(struct cache *ca, bool wait);
>>>  void bch_write_bdev_super(struct cached_dev *dc, struct closure *parent);
>>>  
>>>  extern struct workqueue_struct *bcache_wq;
>>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>>> index 20ed838e9413..716ea272fb55 100644
>>> --- a/drivers/md/bcache/super.c
>>> +++ b/drivers/md/bcache/super.c
>>> @@ -529,7 +529,7 @@ static void prio_io(struct cache *ca, uint64_t bucket, int op,
>>>  	closure_sync(cl);
>>>  }
>>>  
>>> -void bch_prio_write(struct cache *ca)
>>> +int bch_prio_write(struct cache *ca, bool wait)
>>>  {
>>>  	int i;
>>>  	struct bucket *b;
>>> @@ -564,8 +564,12 @@ void bch_prio_write(struct cache *ca)
>>>  		p->magic	= pset_magic(&ca->sb);
>>>  		p->csum		= bch_crc64(&p->magic, bucket_bytes(ca) - 8);
>>>  
>>> -		bucket = bch_bucket_alloc(ca, RESERVE_PRIO, true);
>>> -		BUG_ON(bucket == -1);
>>> +		bucket = bch_bucket_alloc(ca, RESERVE_PRIO, wait);
>>> +		if (bucket == -1) {
>>> +			if (!wait)
>>> +				return -ENOMEM;
>>> +			BUG_ON(1);
>>> +		}
>>
>> Coly,
>>
>> looking more at this change, I think we should handle the failure path
>> properly or we may leak buckets, am I right? (sorry for not realizing
>> this before). Maybe we need something like the following on top of my
>> previous patch.
>>
>> I'm going to run more stress tests with this patch applied and will try
>> to figure out if we're actually leaking buckets without it.
>>
>> ---
>> Subject: bcache: prevent leaking buckets in bch_prio_write()
>>
>> Handle the allocation failure path properly in bch_prio_write() to avoid
>> leaking buckets from the previous successful iterations.
>>
>> Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
> 
> Coly, ignore this one please. A v3 of the previous patch with a better
> fix for this potential buckets leak is on the way.

Sure, waiting for next version :-)


-- 

Coly Li
