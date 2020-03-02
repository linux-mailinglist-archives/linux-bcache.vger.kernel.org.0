Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A472B1760B0
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Mar 2020 18:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgCBRGt (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 2 Mar 2020 12:06:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:52882 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgCBRGt (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 2 Mar 2020 12:06:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 26DC6AE3C;
        Mon,  2 Mar 2020 17:06:47 +0000 (UTC)
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
To:     Michal Hocko <mhocko@kernel.org>
Cc:     axboe@kernel.dk, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, hare@suse.de, mkoutny@suse.com,
        Oleg Nesterov <oleg@redhat.com>, Christoph Hellwig <hch@lst.de>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz>
 <29a1c9fa-46e2-af5f-9531-c25dbb0a3dca@suse.de>
 <20200302134048.GK4380@dhcp22.suse.cz>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <cc759569-e79e-a1a0-3019-0e07dd6957cb@suse.de>
Date:   Tue, 3 Mar 2020 01:06:38 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200302134048.GK4380@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/3/2 9:40 下午, Michal Hocko wrote:
> On Mon 02-03-20 21:29:09, Coly Li wrote:
> [...]
>>> I cannot really comment on the bcache part because I am not familiar
>>> with the code. It is quite surprising to see an initialization taking
>>> that long though.
>>>
>>
>> Back to the time 10 years ago when bcache merged into Linux mainline,
>> checking meta data for a 120G SSD was fast. But now an 8TB SSD is quite
>> common on server... So the problem appears.
> 
> Does all that work has to happen synchronously from the kworker context?
> Is it possible some of the initialization to be done more lazily or in
> the background?
> 

The registration is a user space process, not a kthread/kworker. The
created kthread is for later run time purpose as part of initialization.
The problem is, if there is pending signal, creating kthread will fail
and return -EINTR to caller, then the whole registration will fail.

And all the work has to be completed before the kernel code (by a write
syscall via sysfs interface) returns to the user space process. After
the registration process finished, the bcache disk file like
/dev/bcache0 will show up for following mount. A delayed lazy method is
not feasible here.

>>> Anyway
>>>
>>>> This patch calls flush_signals() in bcache_device_init() if there is
>>>> pending signal for current process. It avoids bcache registration
>>>> failure in system boot up time due to bcache udev rule timeout.
>>>
>>> this sounds like a wrong way to address the issue. Killing the udev
>>> worker is a userspace policy and the kernel shouldn't simply ignore it.
>>
>> Indeed the bcache registering process cannot be killed, because a mutex
>> lock (bch_register_lock) is held during all the registration operation.
>>
>> In my testing, kthread_run()/kthread_create() failure by pending signal
>> happens after all metadata checking finished, that's 55 minutes later.
>> No mater the registration successes or fails, the time length is same.
>>
>> Once the udev timeout killing is useless, why not make the registration
>> to success ? This is what the patch does.
> 
> I cannot really comment for the systemd part but it is quite unexpected
> for it to have signals ignored completely.
> 

I see. But so far I don't have better solution to fix this problem.
Asking people to do extra configure to udev rules is very tricky, most
of common users will be scared. I need to get it fixed by no-extra
configuration.


>>> Is there any problem to simply increase the timeout on the system which
>>> uses a large bcache?
>>>
>>
>> At this moment, this is a workaround. Christoph Hellwig also suggests to
>> fix kthread_run()/kthread_create(). Now I am looking for method to
>> distinct that the parent process is killed by OOM killer and not by
>> other processes in kthread_run()/kthread_create(), but the solution is
>> not clear to me yet.
> 
> It is really hard to comment on this because I do not have a sufficient
> insight but in genereal. The oom victim context can be checked by
> tsk_is_oom_victim but kernel threads are subject of the oom killer
> because they do not own any address space. I also suspect that none of
> the data you allocate for the cache is accounted per any specific
> process.

You are right, the cached data is not bonded to process, it is bonded to
specific backing block devices.

In my case, kthread_run()/kthread_create() is called in context of
registration process (/lib/udev/bcache-register), so it is unnecessary
to worry about kthread address space. So maybe I can check
tsk_is_oom_victim to judge whether current process is killing by OOM
killer other then simply calling pending_signal() ?

> 
>> When meta-data size is around 40GB, registering cache device will take
>> around 55 minutes on my machine for current Linux kernel. I have patch
>> to reduce the time to around 7~8 minutes but still too long. I may add a
>> timeout in bcache udev rule for example 10 munites, but when the cache
>> device get large and large, the timeout will be not enough eventually.
>>
>> As I mentioned, this is a workaround to fix the problem now. Fixing
>> kthread_run()/kthread_create() may take longer time for me. If there is
>> hint to make it, please offer me.
> 
> My main question is why there is any need to touch the kernel code. You
> can still update the systemd/udev timeout AFAIK. This would be the
> proper workaround from my (admittedly limited) POV.
> 

I see your concern. But the udev timeout is global for all udev rules, I
am not sure whether change it to a very long time is good ... (indeed I
tried to add event_timeout=3600 but I can still see the signal received).

Ignore the pending signal in bcache registering code is the only method
currently I know to avoid bcache auto-register failure in boot time. If
there is other way I can achieve the same goal, I'd like to try.

BTW, by the mean time, I am still looking for the reason why
event_timeout=3600 in /etc/udev/udev.conf does not take effect...

-- 

Coly Li
