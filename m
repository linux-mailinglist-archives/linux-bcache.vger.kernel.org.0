Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F532F8B05
	for <lists+linux-bcache@lfdr.de>; Tue, 12 Nov 2019 09:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725821AbfKLItw (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 12 Nov 2019 03:49:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:56174 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725775AbfKLItw (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 12 Nov 2019 03:49:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 852D6ADFB;
        Tue, 12 Nov 2019 08:49:50 +0000 (UTC)
Subject: Re: Several bugs/flaws in the current(?) bcache implementation
To:     Christian Balzer <chibi@gol.com>
Cc:     linux-bcache@vger.kernel.org
References: <20191111104219.6d12c4b6@batzmaru.gol.ad.jp>
 <a138b451-0a3e-2646-111e-cd095699ab0e@suse.de>
 <20191112101739.1c2517a4@batzmaru.gol.ad.jp>
 <a3d675f1-2309-d3fc-12b9-2ffb38ca5965@suse.de>
 <20191112153947.7acdc5a2@batzmaru.gol.ad.jp>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <9509ec0a-d9b7-67c4-1552-44cc9064179a@suse.de>
Date:   Tue, 12 Nov 2019 16:49:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191112153947.7acdc5a2@batzmaru.gol.ad.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/11/12 2:39 下午, Christian Balzer wrote:
> On Tue, 12 Nov 2019 13:00:14 +0800 Coly Li wrote:
> 
>> On 2019/11/12 9:17 上午, Christian Balzer wrote:
>>> On Mon, 11 Nov 2019 23:56:04 +0800 Coly Li wrote:
>>>   
>>>> On 2019/11/11 10:10 上午, Christian Balzer wrote:  
>>>>>
>>>>>
>>>>> Hello,
>>>>>
>>>>> When researching the issues below and finding out about the PDC changes
>>>>> since 4.9 this also provided a good explanation for the load spikes we see
>>>>> with 4.9, as the default writeback is way too slow to empty the dirty
>>>>> pages and thus there is never much of a buffer for sudden write spikes,
>>>>> causing the PDC to overshoot when trying to flush things out to the
>>>>> backing device.

[snip]

>>> At some tests the backing device came to screeching halt at just 4MB/s
>>> trying to accommodate that torrent of I/O.
>>> At the best of times it peaked around 150MB/s which is still shy of what
>>> it could do in a steady state scenario.
>>>
>>> This is the backing device when set to a 32MB writeback minimum rate, as
>>> you can see the RAID cache (4GB) still manages to squirrel that away w/o
>>> any sign of load and then nicely coalesced flushes it to the actual RAID
>>> (which can do about 700MBs sequential):
>>> ---
>>>
>>> DSK |          sda | busy      0% | read       0 | write  8002/s | MBr/s    0.0 | MBw/s   32.1 | avio 0.00 ms |
>>>
>>> ---
>>>
>>> This is when the lack of IO causes bcache to go to 1TB/s and totally trash
>>> things:
>>> ---
>>>
>>> DSK |          sda | busy     84% | read     0/s | write 1845/s  | MBr/s    0.0 | MBw/s    7.2 | avio 0.45 ms |
>>>
>>> ---
>>>
>>>
>>> Whatever bcache or other kernel friends are doing when flushing at full
>>> speed seems to be vastly different from the regulated writeback rate.
>>>   
>>
>> It seems Areca RAID adapter can not handle high random I/O pressure
>> properly and even worse then regular write I/O rate (am I right ?).
>>
> Already addressed, not really.
> 
>> It makes sense to not boost writeback rate in your case, one more
>> question needs to be confirmed to make sure I don't mis-understand your
>> issue.
>>
>> For same amount of dirty data size, when regular I/O request is idle, in
>> your hardware configuration, does maximum writeback rate accomplishes
>> dirty data flushing faster ?
>>
> See above, not necessarily and definitely not at the "cost" of very visible
> load spikes that can cause alerts to be triggered in production.
> 
>  
>>
>>
>>> So yes, please either honor writeback_rate_minimum as the top value when
>>> not under actual dirty cache pressure or add another parameter for upper
>>> limits.
>>> The later would also come in handy as an end stop for the PDC in general,
>>> in my case I would never want it to write faster than something like
>>> 100MB/s (average is 1-2MB/s on those servers).
>>>
>>>   
>>
>> So even with maximum writeback rate, the total time of flushing all
>> dirty data can be much less, you still want a normal writeback rate and
>> longer cache cleaning time with writeback_rate_minimum ?
>>
> 
> Even if that were the case, yes. 
> Because it would reduce the load and leave more IOPS on the SSDs for other
> activities.
> 
> Think of this similar to the MD RAID min and max settings.
> The minimum is already there, max is currently hard-coded at 1TB/s and it
> would be nice if a user who knows what they are doing could control that
> as well.
> 

Copied. There should be a method to permit people to disable maximum
writeback rate if they don't like this.

I will add a sysfs interface to permit people to disable maximum
writeback rate. Since all my customers require the maximum writeback
rate feature, it will be enabled as default, and people may disable it
by writing 0 into the sysfs file.


>>>>> 2. Initial and intermittent 5 second drops
>>>>>

[snipped]

>>> Which is obviously fishy, as when running with "--rate_iops=10" neither at
>>> the start nor during the run is there any kind of pressure/load.
>>> So my guess it's doing some navel gazing and rather ineffectively at that.
>>> Again, this did not happen with the 4.9 kernel version.
>>>   
>>
>> When --rate_iops=10, it means there is regular I/O coming, maximum
>> writeback rate should not be set. 
> 
> Correct, it never is.
> 
>> If you observe the 30 seconds stalls
>> and writeback thread is 100% cpu consuming, there might be something
>> wrong in the code. It seems not related to the backing raid adapter.
>>
> None of the devices is (obviously) the least busy at 10 IOPS. 
> The stall/pause is purely CPU, not iowait related.
> And it's for 10 seconds (with the 10 IOPS at least), after 30 seconds of
> normal operation.
> 
>> Could you please to offer me the command lines how the bcache devices
>> are created, and the fio job file for your testing ? Then I can try to
>> run similar procedure on my local machine and check what should be fixed.
>>
> The fio command line and output were in the original mail, vanilla bcache
> creation originally on Jessie, don't have the exact command line anymore
> obviously.
> 
> To trigger those stalls:
> ---
> fio --size=1G --ioengine=libaio --invalidate=1 --direct=1 --numjobs=1 --rw=randwrite --name=fiojob --blocksize=4K --iodepth=32 --rate_iops=10
> ---

OK, I will verify the change I mentioned above by this fio command line.

Thanks.

-- 

Coly Li
