Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A05381F64
	for <lists+linux-bcache@lfdr.de>; Sun, 16 May 2021 16:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233616AbhEPPAK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 16 May 2021 11:00:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:48770 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229807AbhEPPAK (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 16 May 2021 11:00:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 067C6ABED;
        Sun, 16 May 2021 14:58:55 +0000 (UTC)
To:     Marc Smith <msmith626@gmail.com>
Cc:     linux-bcache <linux-bcache@vger.kernel.org>
References: <CAH6h+hc2quJhhBindQwQdK5pfsJRZWk5tX95RT3U_shuN1D=eQ@mail.gmail.com>
 <d616e7c1-2406-472f-0653-39612250c2f0@suse.de>
 <CAH6h+hfXoRdsTQZJ-y2zAkCwcQiBN_fZtEuZdy3yCKoXRzpeVA@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
Subject: Re: [PATCH v2] RFC - Write Bypass Race Bug
Message-ID: <504aedf3-f550-5ce3-1851-c20754a2a851@suse.de>
Date:   Sun, 16 May 2021 22:58:50 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAH6h+hfXoRdsTQZJ-y2zAkCwcQiBN_fZtEuZdy3yCKoXRzpeVA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/11/21 5:06 AM, Marc Smith wrote:
> On Thu, May 6, 2021 at 12:09 AM Coly Li <colyli@suse.de> wrote:
>>
>> On 4/30/21 10:44 PM, Marc Smith wrote:
>>> The problem:
>>> If an inflight backing WRITE operation for a block is performed that
>>> meets the criteria for bypassing the cache and that takes a long time
>>> to complete, a READ operation for the same block may be fully
>>> processed in the interim that populates the cache with the device
>>> content from before the inflight WRITE. When the inflight WRITE
>>> finally completes, since it was marked for bypass, the cache is not
>>> subsequently updated, and the stale data populated by the READ request
>>> remains in cache. While there is code in bcache for invalidating the
>>> cache when a bypassed WRITE is performed, this is done prior to
>>> issuing the backing I/O so it does not help.
>>>
>>> The proposed fix:
>>> Add two new lists to the cached_dev structure to track inflight
>>> "bypass" write requests and inflight read requests that have have
>>> missed cache. These are called "inflight_bypass_write_list" and
>>> "inflight_read_list", respectively, and are protected by a spinlock
>>> called the "inflight_lock"
>>>
>>> When a WRITE is bypassing the cache, check whether there is an
>>> overlapping inflight read. If so, set bypass = false to essentially
>>> convert the bypass write into a writethrough write. Otherwise, if
>>> there is no overlapping inflight read, then add the "search" structure
>>> to the inflight bypass write list.
>>
>> Hi Marc,
>>
>> Could you please explain a bit more why the above thing is necessary ?
>> Please help me to understand your idea more clear :-)
>>
> 
> As stated previously, the race condition involves two requests attempting
> I/O on the same block. One is a bypass write and the other is a normal
> read that misses the cache.
> 
> The simplest form of the race is the following:
> 
> 1.  BYPASS WRITER starts processing bcache request
> 2.  BYPASS WRITER invalidates block in the cache
> 3.  NORMAL READER starts processing bcache request
> 4.  NORMAL READER misses cache, issues READ request to backing device
> 5.  NORMAL READER processes completion of backing dev request
> 6.  NORMAL READER populates cache with stale data
> 7.  NORMAL READER completes
> 8.  BYPASS WRITER issues WRITE request to backing device
> 9.  BYPASS WRITER processes completion of backing dev request
> 10. BYPASS WRITER completes
> 
> An approach to avoiding the race is to add the following steps:
> 
> 1.5 BYPASS WRITER adds the sector range to a data structure that holds
>     inflight writes. (As currently coded, this data structure is an
>     interval tree.)
> 
> 5.5 NORMAL READER checks the data structure to see if there are any
>     inflight bypass writers having overlapping sectors. If so, skip
>     step 6.
> 
> 9.5 BYPASS WRITER removes sector range added in step 1.5
> 
> If this were the only order of operations for the race, then the 3 added
> steps would be sufficient and only inflight BYPASS WRITES would need
> to be tracked.
> 
> However, consider the following ordering with new steps above added:
> 
> 1.  NORMAL READER starts processing bcache request
> 2.  NORMAL READER misses cache, issues READ request to backing device
> 3.  NORMAL READER processes completion of backing dev request
> 4.  NORMAL READER checks the data structure to see if there are any
>     inflight bypass writers having overlapping sectors. None are found.
> 5.  BYPASS WRITER starts processing bcache request
> 6.  BYPASS WRITER adds the sector range to a data structure that holds
>     inflight writes.
> 7.  BYPASS WRITER invalidates block in the cache
> 8.  BYPASS WRITER issues WRITE request to backing device
> 9 . NORMAL READER populates cache with stale data
> 10. NORMAL READER completes
> 11. BYPASS WRITER processes completion of backing dev request
> 12. BYPASS WRITER removes sector range added in step 6.
> 13. BYPASS WRITER completes
> 
> With this order of operations, the added steps don't solve the problem
> as stale data is added in step #9 and never corrected.
> 

I am not sure whether the above condition can take place. For a cache
missing, before reading the missing data from backing device, a replace
key is inserted into the btree as a check key. After the missing data is
read form backing device, the data is returned to caller firstly, and
inserted into btree.

There is a trick for the second-insert, if there is a matching check key
is founded, then the data of read missing is inserted into btree. If the
check key is not find, it means there is another key inserted and
overwritten the check key, than the btree insert for read-missing data
will give up to avoid a race.

So I feel current code may avoid the above race condition. For the first
race condition, I agree that it exists and should be fixed.


> So to cover both scenarios (and potentially others), both inflight bypass
> WRITEs and normal READs are tracked. If a BYPASS WRITE is being performed,
> it checks for an inflight overlapping read. If one exists, the BYPASS
> WRITE coverts itself to a WRITETHROUGH, which essentially "neutralizes" it
> from the race. If, however, there are no overlapping READs, it adds itself
> to a tracking data structure. When a normal read is issued that misses
> the cache, a check is made for an inflight overlapping BYPASS WRITE. If
> one exists, the READ sets the "do_not_cache" flag which neutralizes it
> from the race. If, however, there are no inflight overlapping BYPASS
> WRITEs, the sector range is added to the data structure holding
> inflight reads.
> 
> This effectively adds/modifies the following steps:
> 
> 1.5 NORMAL READER adds its sector range to a data structure that holds
>     inflight writes.
> 
> 5.5 BYPASS WRITER checks for the data structure to see if there is an
>     inflight overlapping READ. There is one! So it coverts itself to
>     a WRITETHROUGH write.
> 
> 8.  [WRITETHROUGH] WRITER issues WRITE request to BOTH the cache
>     and the backing device. A writethrough racing with a reader (step 9)
>     is already correctly handled by bcache (I think.)
> 
> 9.5 NORMAL READER removes the sector range added in step 1.5
> 
> In summary, when a BYPASS WRITE is racing with a normal READ,
> one of them needs to take evasive maneuvers to avoid corruption. The
> BYPASS WRITE can convert itself to a WRITETHROUGH WRITE or the READ
> can skip populating the cache. To handle all order of operations, it
> appears that support for both are needed depending on whether the
> BYPASS WRITE or normal READ arrives first. Therefore, both BYPASS WRITES
> and normal READS need to be tracked.
> 
> 
>>>
>>> When a READ misses cache, check whether there is an overlapping
>>> inflight write. If so, set a new flag in the search structure called
>>> "do_not_cache" which causes cache population to be skipped after the
>>> backing I/O completes. Otherwise, if there is no overlapping inflight
>>> write, then add the "search" structure to the inflight read list.
>>>
>>> The rest of the changes are to add a new stat called
>>> "bypass_cache_insert_races" to track how many times the race was
>>> encountered. Example:
>>> cat /sys/fs/bcache/0c9b7a62-b431-4328-9dcb-a81e322238af/bdev0/stats_total/cache_bypass_races
>>> 16577
>>>
>>
>> The stat counters make sense.
>>
>>> Assuming this is the correct approach, areas to look at:
>>> 1) Searching linked lists doesn't scale. Can something like an
>>> interval tree be used here instead?
>>
>> Tree is not good. Heavy I/O may add and delete many nodes in and from
>> the tree, the operation is heavy and congested, especially this is a
>> balanced tree.
>>
>>
>>> 2) Can this be restructured so that the inflight_lock doesn't have to
>>> be accessed with interrupts disabled? Note that search_free() can be
>>> called in interrupt context.
>>
>> Yes it is possible, with a lockless approach. What is needed is an array
>> to atomic counter. Each element of the array covers a range of LBA, if a
>> bypass write hits a range of LBA, increases the atomic counter from
>> corresponding element(s). For the cache miss read, just do an atomic
>> read without tree iteration and any lock protection.
>>
>> An array of atomic counters should work but not space efficient, memory
>> should be allocated for all LBA ranges even most of the counters not
>> touched during the whole system up time.
>>
>> Maybe xarray works, but I don't look into the xarray api carefully yet.
> 
> Okay, we'll look into using this data structure, thanks.
> 

There is spinlock inside xarray, I am not sure whether it scales well in
random I/O on large LBA range. We need to try.

[snipped]

Coly Li
