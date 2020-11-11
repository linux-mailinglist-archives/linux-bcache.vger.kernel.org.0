Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857252AEC11
	for <lists+linux-bcache@lfdr.de>; Wed, 11 Nov 2020 09:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgKKIdq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 11 Nov 2020 03:33:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:48198 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726020AbgKKIdq (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 11 Nov 2020 03:33:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1FA93AC75;
        Wed, 11 Nov 2020 08:33:44 +0000 (UTC)
Subject: Re: [PATCH] bcache: consider the fragmentation when update the
 writeback rate
To:     Dongdong Tao <dongdong.tao@canonical.com>
Cc:     Dongdong Tao <tdd21151186@gmail.com>,
        "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Kent Overstreet <kent.overstreet@gmail.com>
References: <20201103124235.14440-1-tdd21151186@gmail.com>
 <8e043313-003b-41be-cbd0-ebcc247dcba2@suse.de>
 <CAJS8hVKNeua4iaRu7nwbdRhQVA5nbjLJSrCewLYbhJ4XBiGg5Q@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
Autocrypt: addr=colyli@suse.de; keydata=
 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
Message-ID: <f579ba86-97ff-25e2-319f-933a382589c9@suse.de>
Date:   Wed, 11 Nov 2020 16:33:39 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAJS8hVKNeua4iaRu7nwbdRhQVA5nbjLJSrCewLYbhJ4XBiGg5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/11/10 12:19, Dongdong Tao wrote:
> [Sorry again for the SPAM detection]
> 
> Thank you the reply Coly!
> 
> I agree that this patch is not a final solution for fixing the
> fragmentation issue, but more like a workaround to alleviate this
> problem.
> So, part of my intention is to look for how upstream would like to fix
> this issue.
> 
> I've looked into the code of moving_gc part, as well as did some
> debug/test, unfortunately, I think it's not the solution for this
> issue also.
> Because movnig_gc will not just move the dirty cache, but also the
> clean cache, so seems the purpose of moving_gc
> is trying to move the data (dirty and clean) from those relatively
> empty buckets to some new buckets, so that to reclaim the original
> buckets.
> For this purpose, I guess moving gc was more useful at the time when
> we usually don't have large nvme devices.
> 
> Let's get back to the problem I have, the problem that I'm trying to
> fix is that you might have lots of buckets (Say 70 percent) that are
> all being fully consumed,
> while those buckets only contain very few dirty data (Say 10 percent
> ), since gc can't reclaim a bucket which contains any dirty data, so
> the worst situation
> is that the cache_availability_percent can drop under 30 percent which
> will make all the write op can't perform in a writeback mode, thus
> kill the performance of writes.
> 
> So, unlike the moving_gc, I only want to move dirty data around (as
> you've suggested :)), but I don't think it's a good idea to change the
> behavior of moving_gc.
> My current idea is to implement a compaction thread that triggers the
> dirty data compaction only under some certain circumstances (like when
> the fragmentaion and dirty buckets are both high), and this thread can
> be turned on/off based on an extra option, so that people can keep the
> original behavior if they want.
> 
> This is a rough idea now, could you please let me know if the above
> thought makes sense to you or any other suggestions will be
> appreciated!
> I also understand the hardest part is making sure the general bcache
> performance and functionality still look sane,
> so it might require much more time to do it and it's more likely a
> feature atm.
> 
> How to reproduce and observe this issue:
> This issue is very easy to repreduce by running below fio command
> against a writeback mode bcache deivce:
> 
> fio --name=random-writers --filename=/dev/bcache0 --ioengine=libaio
> --iodepth=4 --rw=randrw --rate_iops=95,5 --bs=4k --direct=1
> --numjobs=4
> 
> Note that the key option to reproduce this issue here is
> "rate_iops=95,5", so that you will have 95 percent read and only 5
> percent write, this is to make sure
> one bucket only contains very few dirty data.
> Also, it's faster to reproduce this with a small cache device, I use
> 1GB cache, but it's same for bigger cache device, just a matter of
> time.
> 
> We can observe this issue by monitoring bcache stats "data_dirty" and
> "cache_available_percent", after the cache_available_percent dropped
> to 30 percent,
> we can observe the write performance is hugely degraded by below
> bpftrace script:
> ---
> #!/usr/bin/env bpftrace
> 
> #include <linux/bio.h>
> 
> kprobe:cached_dev_make_request
> {
>    @start[arg1] = nsecs;
> }
> 
> kprobe:bio_endio /@start[arg0]/
> {
>  if(((struct bio *)arg0)->bi_opf & 1) {
>     @write = hist(nsecs - @start[arg0]); delete(@start[arg0]);
>  }
>  else {
>     @read = hist(nsecs - @start[arg0]); delete(@start[arg0]);
>  }
> }
> ---
> 
> To run this script：
> Save above bpftrace file to bcache_io_lat.bt, then run it with chmod
> +x bcache_io_lat.bt & ./bcache_io_lat.bt
> 
> By the way, we mainly hit this issue on ceph, the fio reproducer is
> just an easy way to reproduce it.
> 

Hi Dongdong,

I know this situation, this is not the first time it is mentioned.

What is the performance number that your patch gains ? I wanted to see
"observable and reproducible performance number", especially the latency
 and IOPS for regular I/O requests.

Thanks.

Coly Li


> On Fri, Nov 6, 2020 at 12:32 AM Coly Li <colyli@suse.de> wrote:
>>
>> On 2020/11/3 20:42, Dongdong Tao wrote:
>>> From: dongdong tao <dongdong.tao@canonical.com>
>>>
>>> Current way to calculate the writeback rate only considered the
>>> dirty sectors, this usually works fine when the fragmentation
>>> is not high, but it will give us unreasonable small rate when
>>> we are under a situation that very few dirty sectors consumed
>>> a lot dirty buckets. In some case, the dirty bucekts can reached
>>> to CUTOFF_WRITEBACK_SYNC while the dirty data(sectors) noteven
>>> reached the writeback_percent, the writeback rate will still
>>> be the minimum value (4k), thus it will cause all the writes to be
>>> stucked in a non-writeback mode because of the slow writeback.
>>>
>>> This patch will try to accelerate the writeback rate when the
>>> fragmentation is high. It calculate the propotional_scaled value
>>> based on below:
>>> (dirty_sectors / writeback_rate_p_term_inverse) * fragment
>>> As we can see, the higher fragmentation will result a larger
>>> proportional_scaled value, thus cause a larger writeback rate.
>>> The fragment value is calculated based on below:
>>> (dirty_buckets *  bucket_size) / dirty_sectors
>>> If you think about it, the value of fragment will be always
>>> inside [1, bucket_size].
>>>
>>> This patch only considers the fragmentation when the number of
>>> dirty_buckets reached to a dirty threshold(configurable by
>>> writeback_fragment_percent, default is 50), so bcache will
>>> remain the original behaviour before the dirty buckets reached
>>> the threshold.
>>>
>>> Signed-off-by: dongdong tao <dongdong.tao@canonical.com>
>>
>> Hi Dongdong,
>>
>> Change the writeback rate does not effect the real throughput indeed,
>> your change is just increasing the upper limit hint of the writeback
>> throughput, the bottle neck is spinning drive for random I/O.
>>
>> A good direction should be the moving gc. If the moving gc may work
>> faster, the situation you mentioned above could be relaxed a lot.
>>
>> I will NACK this patch unless you may have a observable and reproducible
>> performance number.
>>
>> Thanks.
>>
>> Coly Li
