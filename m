Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC80114C8A
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Dec 2019 08:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbfLFHJo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 6 Dec 2019 02:09:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:56176 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726377AbfLFHJo (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Dec 2019 02:09:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E0463B154;
        Fri,  6 Dec 2019 07:09:38 +0000 (UTC)
Subject: Re: [RFC PATCH] bcache: enable zoned device support
To:     Coly Li <colyli@suse.de>, Damien Le Moal <Damien.LeMoal@wdc.com>,
        Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>
References: <20191205152543.73885-1-colyli@suse.de>
 <alpine.LRH.2.11.1912060012380.11561@mx.ewheeler.net>
 <BYAPR04MB5816090B934A7CA17EFA688AE75F0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <a21ce3de-5591-198f-56bf-8dc3aee6c926@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <66345af3-fad6-3079-1604-3b0e9d2779ce@suse.de>
Date:   Fri, 6 Dec 2019 08:09:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <a21ce3de-5591-198f-56bf-8dc3aee6c926@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/6/19 5:37 AM, Coly Li wrote:
> On 2019/12/6 8:30 上午, Damien Le Moal wrote:
>> On 2019/12/06 9:22, Eric Wheeler wrote:
>>> On Thu, 5 Dec 2019, Coly Li wrote:
>>>> This is a very basic zoned device support. With this patch, bcache
>>>> device is able to,
>>>> - Export zoned device attribution via sysfs
>>>> - Response report zones request, e.g. by command 'blkzone report'
>>>> But the bcache device is still NOT able to,
>>>> - Response any zoned device management request or IOCTL command
>>>>
>>>> Here are the testings I have done,
>>>> - read /sys/block/bcache0/queue/zoned, content is 'host-managed'
>>>> - read /sys/block/bcache0/queue/nr_zones, content is number of zones
>>>>   including all zone types.
>>>> - read /sys/block/bcache0/queue/chunk_sectors, content is zone size
>>>>   in sectors.
>>>> - run 'blkzone report /dev/bcache0', all zones information displayed.
>>>> - run 'blkzone reset /dev/bcache0', operation is rejected with error
>>>>   information: "blkzone: /dev/bcache0: BLKRESETZONE ioctl failed:
>>>>   Operation not supported"
>>>> - Sequential writes by dd, I can see some zones' write pointer 'wptr'
>>>>   values updated.
>>>>
>>>> All of these are very basic testings, if you have better testing
>>>> tools or cases, please offer me hint.
>>>
>>> Interesting. 
>>>
>>> 1. should_writeback() could benefit by hinting true when an IO would fall 
>>>    in a zoned region.
>>>
>>> 2. The writeback thread could writeback such that they prefer 
>>>    fully(mostly)-populated zones when choosing what to write out.
>>
>> That definitely would be a good idea since that would certainly benefit
>> backend-GC (that will be needed).
>>
>> However, I do not see the point in exposing the /dev/bcacheX block
>> device itself as a zoned disk. In fact, I think we want exactly the
>> opposite: expose it as a regular disk so that any FS or application can
>> run. If the bcache backend disk is zoned, then the writeback handles
>> sequential writes. This would be in the end a solution similar to
>> dm-zoned, that is, a zoned disk becomes useable as a regular block
>> device (random writes anywhere are possible), but likely far more
>> efficient and faster. That may result in imposing some limitations on
>> bcache operations though, e.g. it can only be setup with writeback, no
>> writethrough allowed (not sure though...).
>> Thoughts ?
>>
> 
> I come to realize this is really an idea on the opposite. Let me try to
> explain what I understand, please correct me if I am wrong. The idea you
> proposed indeed is to make bcache act as something like FTL for the
> backend zoned SMR drive, that is, for all random writes, bcache may
> convert them into sequential write onto the backend zoned SMR drive. In
> the meantime, if there are hot data, bcache continues to act as a
> caching device to accelerate read request.
> 
> Yes, if I understand your proposal correctly, writeback mode might be
> mandatory and backend-GC will be needed. The idea is interesting, it
> looks like adding a log-structure storage layer between current bcache
> B+tree indexing and zoned SMR hard drive.
> 
Well, not sure if that's required.

Or, to be correct, we actually have _two_ use-cases:
1) Have a SMR drive as a backing device. This was my primary goal for
handling these devices, as SMR device are typically not _that_ fast.
(Damien once proudly reported getting the incredible speed of 1 IOPS :-)
So having bcache running on top of those will be a clear win.
But in this scenario the cache device will be a normal device (typically
an SSD), and we shouldn't need much modification here.
In fact, a good testcase would be the btrfs patches which got posted
earlier this week. With them you should be able to create a btrfs
filesystem on the SMR drive, and use an SSD as a cache device.
Getting this scenario to run would indeed be my primary goal, and I
guess your patches should be more or less sufficient for that.
2) Using a SMR drive as a _cache_ device. This seems to be contrary to
the above statement of SMR drive not being fast, but then the NVMe WG is
working on a similar mechanism for flash devices called 'ZNS' (zoned
namespaces). And for those it really would make sense to have bcache
being able to handle zoned devices as a cache device.
But this is to my understanding really in the early stages, with no real
hardware being available. Damien might disagree, though :-)
And the implementation is still on the works on the linux side, so it's
more of a long-term goal.

But the first use-case is definitely something we should be looking at;
SMR drives are available _and_ with large capacity, so any speedup there
would be greatly appreciated.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
