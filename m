Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF89D114DAA
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Dec 2019 09:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfLFIaG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 6 Dec 2019 03:30:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:38026 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726088AbfLFIaG (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Dec 2019 03:30:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 931CFB019;
        Fri,  6 Dec 2019 08:30:03 +0000 (UTC)
Subject: Re: [RFC PATCH] bcache: enable zoned device support
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>
References: <20191205152543.73885-1-colyli@suse.de>
 <alpine.LRH.2.11.1912060012380.11561@mx.ewheeler.net>
 <BYAPR04MB5816090B934A7CA17EFA688AE75F0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <a21ce3de-5591-198f-56bf-8dc3aee6c926@suse.de>
 <66345af3-fad6-3079-1604-3b0e9d2779ce@suse.de>
 <BYAPR04MB5816E7F7741B3DC8D1B3B759E75F0@BYAPR04MB5816.namprd04.prod.outlook.com>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <9bcbcb7b-4620-359a-b7b0-63366688a523@suse.de>
Date:   Fri, 6 Dec 2019 16:29:49 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB5816E7F7741B3DC8D1B3B759E75F0@BYAPR04MB5816.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=iso-2022-jp
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/12/6 3:42 下午, Damien Le Moal wrote:
> On 2019/12/06 16:09, Hannes Reinecke wrote:
>> On 12/6/19 5:37 AM, Coly Li wrote:
>>> On 2019/12/6 8:30 上午, Damien Le Moal wrote:
>>>> On 2019/12/06 9:22, Eric Wheeler wrote:
>>>>> On Thu, 5 Dec 2019, Coly Li wrote:
>>>>>> This is a very basic zoned device support. With this patch, bcache
>>>>>> device is able to,
>>>>>> - Export zoned device attribution via sysfs
>>>>>> - Response report zones request, e.g. by command 'blkzone report'
>>>>>> But the bcache device is still NOT able to,
>>>>>> - Response any zoned device management request or IOCTL command
>>>>>>
>>>>>> Here are the testings I have done,
>>>>>> - read /sys/block/bcache0/queue/zoned, content is 'host-managed'
>>>>>> - read /sys/block/bcache0/queue/nr_zones, content is number of zones
>>>>>>   including all zone types.
>>>>>> - read /sys/block/bcache0/queue/chunk_sectors, content is zone size
>>>>>>   in sectors.
>>>>>> - run 'blkzone report /dev/bcache0', all zones information displayed.
>>>>>> - run 'blkzone reset /dev/bcache0', operation is rejected with error
>>>>>>   information: "blkzone: /dev/bcache0: BLKRESETZONE ioctl failed:
>>>>>>   Operation not supported"
>>>>>> - Sequential writes by dd, I can see some zones' write pointer 'wptr'
>>>>>>   values updated.
>>>>>>
>>>>>> All of these are very basic testings, if you have better testing
>>>>>> tools or cases, please offer me hint.
>>>>>
>>>>> Interesting. 
>>>>>
>>>>> 1. should_writeback() could benefit by hinting true when an IO would fall 
>>>>>    in a zoned region.
>>>>>
>>>>> 2. The writeback thread could writeback such that they prefer 
>>>>>    fully(mostly)-populated zones when choosing what to write out.
>>>>
>>>> That definitely would be a good idea since that would certainly benefit
>>>> backend-GC (that will be needed).
>>>>
>>>> However, I do not see the point in exposing the /dev/bcacheX block
>>>> device itself as a zoned disk. In fact, I think we want exactly the
>>>> opposite: expose it as a regular disk so that any FS or application can
>>>> run. If the bcache backend disk is zoned, then the writeback handles
>>>> sequential writes. This would be in the end a solution similar to
>>>> dm-zoned, that is, a zoned disk becomes useable as a regular block
>>>> device (random writes anywhere are possible), but likely far more
>>>> efficient and faster. That may result in imposing some limitations on
>>>> bcache operations though, e.g. it can only be setup with writeback, no
>>>> writethrough allowed (not sure though...).
>>>> Thoughts ?
>>>>
>>>
>>> I come to realize this is really an idea on the opposite. Let me try to
>>> explain what I understand, please correct me if I am wrong. The idea you
>>> proposed indeed is to make bcache act as something like FTL for the
>>> backend zoned SMR drive, that is, for all random writes, bcache may
>>> convert them into sequential write onto the backend zoned SMR drive. In
>>> the meantime, if there are hot data, bcache continues to act as a
>>> caching device to accelerate read request.
>>>
>>> Yes, if I understand your proposal correctly, writeback mode might be
>>> mandatory and backend-GC will be needed. The idea is interesting, it
>>> looks like adding a log-structure storage layer between current bcache
>>> B+tree indexing and zoned SMR hard drive.
>>>
>> Well, not sure if that's required.
>>
>> Or, to be correct, we actually have _two_ use-cases:
>> 1) Have a SMR drive as a backing device. This was my primary goal for
>> handling these devices, as SMR device are typically not _that_ fast.
>> (Damien once proudly reported getting the incredible speed of 1 IOPS :-)
> 
> Yes, it can get to that with dm-zoned if one goes crazy with sustained
> random writes :) The physical drive itself does a lot more than 1 iops
> in that case though and is as fast as any other HDD. But from the DM
> logical drive side, the user can sometimes fall into the 1 iops
> territory for really nasty workloads. Tests for well behaved users like
> f2fs show that SMR and regular HDDs are on par for performance.
> 
>> So having bcache running on top of those will be a clear win.
>> But in this scenario the cache device will be a normal device (typically
>> an SSD), and we shouldn't need much modification here.
> 
> I agree. That should work mostly as is since the user will be zone aware
> and already be issuing sequential writes. bcache write-through only
> needs to follow the same pattern, not reordering any write, and
> write-back only has to replay the same.
> 
>> In fact, a good testcase would be the btrfs patches which got posted
>> earlier this week. With them you should be able to create a btrfs
>> filesystem on the SMR drive, and use an SSD as a cache device.
>> Getting this scenario to run would indeed be my primary goal, and I
>> guess your patches should be more or less sufficient for that.
> 
> + Will need the zone revalidation and zone type & write lock bitmaps to
> prevent reordering from the block IO stack, unless bcache is a BIO
> driver ? My knowledge of bcache is limited. Would need to look into the
> details a little more to be able to comment.

Hi Damien,

Bcache should be a bio based driver, it splits and clones bios, and
submits it by generic_make_request() to underlying block layer code.

So zone revalidation and zone type & write lock bitmaps are unnecessary
for bcache ?

> 
>> 2) Using a SMR drive as a _cache_ device. This seems to be contrary to
>> the above statement of SMR drive not being fast, but then the NVMe WG is
>> working on a similar mechanism for flash devices called 'ZNS' (zoned
>> namespaces). And for those it really would make sense to have bcache
>> being able to handle zoned devices as a cache device.
>> But this is to my understanding really in the early stages, with no real
>> hardware being available. Damien might disagree, though :-)
> 
> Yes, that would be another potential use case and ZNS indeed could fit
> this model, assuming that zone sizes align (multiples) between front and
> back devices.
> 
>> And the implementation is still on the works on the linux side, so it's
>> more of a long-term goal.>
>> But the first use-case is definitely something we should be looking at;
>> SMR drives are available _and_ with large capacity, so any speedup there
>> would be greatly appreciated.
> 
> Yes. And what I was talking about in my earlier email is actually a
> third use case:
> 3) SMR drive as backend + regular SSD as frontend and the resulting
> bcache device advertising itself as a regular disk, hiding all the zone
> & sequential write constraint to the user. Since bcache already has some
> form of indirection table for cached blocks, I thought we could hijack
> this to implement a sort of FTL that would allow serializing random
> writes to the backend with the help of the frontend as a write staging
> buffer. Doing so, we get full random write capability with the benefit
> of "hot" blocks staying in the cache. But again, not knowing enough
> details about bcache, I may be talking too lightly here. Not sure if
> that is reasonably easily feasible with the current bcache code.

There are three addresses involved in the above proposal.
1) User space LBA address: the LBA of block device which are combiled by
bcache+SMR.
2) Cache device LBA address: where the random writing cached data blocks
are stored on SSD.
3) SMR drive LBA address: where the sequential writing data blocks are
stored on zoned SMR drive

Therefore we need at least two layers mapping to connect these 3
addresses together. Currently only 1 mapping from bcache B+tree is not
enough.

Maybe stacking bcache backing device on top of dm-zoned target is a
solution for proposal 3), let me try whether it works.

-- 

Coly Li
