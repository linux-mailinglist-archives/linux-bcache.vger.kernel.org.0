Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54F1B175B9D
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Mar 2020 14:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgCBN3V (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 2 Mar 2020 08:29:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:37096 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727659AbgCBN3V (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 2 Mar 2020 08:29:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8D7DBB119;
        Mon,  2 Mar 2020 13:29:18 +0000 (UTC)
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
To:     Michal Hocko <mhocko@kernel.org>
Cc:     axboe@kernel.dk, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, hare@suse.de, mkoutny@suse.com,
        Oleg Nesterov <oleg@redhat.com>, Christoph Hellwig <hch@lst.de>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <29a1c9fa-46e2-af5f-9531-c25dbb0a3dca@suse.de>
Date:   Mon, 2 Mar 2020 21:29:09 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200302122748.GH4380@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/3/2 8:27 下午, Michal Hocko wrote:
> [Cc Oleg]
> 
> On Mon 02-03-20 17:34:49, Coly Li wrote:
>> When cache device and cached device are registered simuteneously and
>> register_cache() firstly acquires bch_register_lock. register_bdev()
>> has to wait before register_cache() finished, it might be a very long
>> time.
>>
>> If the registration is from udev rules in system boot up time, and
>> registration is not completed before udev timeout (default 180s), the
>> registration process will be killed by udevd. Then the following calls
>> to kthread_run() or kthread_create() will fail due to the pending
>> signal (they are implemented this way at this moment).
>>
>> For boot time, this is not good, because it means a cache device with
>> huge cached data will always fail in boot time, just because it
>> spends too much time to check its internal meta data (btree and dirty
>> sectors).
>>
>> The failure for cache device registration is solved by previous
>> patches, but failure due to timeout also exists in cached device
>> registration. As the above text explains, cached device registration
>> may also be timeout if it is blocked by a timeout cache device
>> registration process. Then in the following code path,
>>     bioset_init() <= bcache_device_init() <= cached_dev_init() <=
>>     register_bdev() <= register_bcache()
>> bioset_init() will fail because internally kthread_create() will fail
>> for pending signal in the following code path,
>>     bioset_init() => alloc_workqueue() => init_rescuer() =>
>>     kthread_create()
>>
>> Maybe fix kthread_create() and kthread_run() is better method, but at
>> this moment a fast workaroudn is to flush pending signals before
>> calling bioset_init() in bcache_device_init().
> 

Hi Michal,

> I cannot really comment on the bcache part because I am not familiar
> with the code. It is quite surprising to see an initialization taking
> that long though.
> 

Back to the time 10 years ago when bcache merged into Linux mainline,
checking meta data for a 120G SSD was fast. But now an 8TB SSD is quite
common on server... So the problem appears.

> Anyway
> 
>> This patch calls flush_signals() in bcache_device_init() if there is
>> pending signal for current process. It avoids bcache registration
>> failure in system boot up time due to bcache udev rule timeout.
> 
> this sounds like a wrong way to address the issue. Killing the udev
> worker is a userspace policy and the kernel shouldn't simply ignore it.

Indeed the bcache registering process cannot be killed, because a mutex
lock (bch_register_lock) is held during all the registration operation.

In my testing, kthread_run()/kthread_create() failure by pending signal
happens after all metadata checking finished, that's 55 minutes later.
No mater the registration successes or fails, the time length is same.

Once the udev timeout killing is useless, why not make the registration
to success ? This is what the patch does.

> Is there any problem to simply increase the timeout on the system which
> uses a large bcache?
> 

At this moment, this is a workaround. Christoph Hellwig also suggests to
fix kthread_run()/kthread_create(). Now I am looking for method to
distinct that the parent process is killed by OOM killer and not by
other processes in kthread_run()/kthread_create(), but the solution is
not clear to me yet.

When meta-data size is around 40GB, registering cache device will take
around 55 minutes on my machine for current Linux kernel. I have patch
to reduce the time to around 7~8 minutes but still too long. I may add a
timeout in bcache udev rule for example 10 munites, but when the cache
device get large and large, the timeout will be not enough eventually.

As I mentioned, this is a workaround to fix the problem now. Fixing
kthread_run()/kthread_create() may take longer time for me. If there is
hint to make it, please offer me.

Thanks.

Coly Li


> Btw. Oleg, I have noticed quite a lot of flush_signals usage in the
> drivers land and I have really hard time to understand their purpose.
> What is the actual valid usage of this function? Should we somehow
> document it?
> 
>> Signed-off-by: Coly Li <colyli@suse.de>
>> ---
>>  drivers/md/bcache/super.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index 0c3c5419c52b..e8bbd4f171ca 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -850,6 +850,18 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>>  	if (idx < 0)
>>  		return idx;
>>  
>> +	/*
>> +	 * There is a timeout in udevd, if the bcache device is registering
>> +	 * by udev rules, and not completed in time, the udevd may kill the
>> +	 * registration process. In this condition, there will be pending
>> +	 * signal here and cause bioset_init() failed for internally creating
>> +	 * its kthread. Here the registration should ignore the timeout and
>> +	 * continue, it is safe to ignore the pending signal and avoid to
>> +	 * fail bcache registration in boot up time.
>> +	 */
>> +	if (signal_pending(current))
>> +		flush_signals(current);
>> +
>>  	if (bioset_init(&d->bio_split, 4, offsetof(struct bbio, bio),
>>  			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
>>  		goto err;
>> -- 
>> 2.16.4
> 


-- 

Coly Li
