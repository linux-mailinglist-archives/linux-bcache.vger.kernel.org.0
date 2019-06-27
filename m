Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB29D58245
	for <lists+linux-bcache@lfdr.de>; Thu, 27 Jun 2019 14:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfF0MOF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 27 Jun 2019 08:14:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:57114 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726965AbfF0MOD (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 27 Jun 2019 08:14:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7857FAC8C;
        Thu, 27 Jun 2019 12:14:02 +0000 (UTC)
Subject: Re: I/O Reordering: Cache -> Backing Device
To:     Eric Wheeler <bcache@lists.ewheeler.net>,
        Marc Smith <msmith626@gmail.com>
Cc:     linux-bcache@vger.kernel.org
References: <CAH6h+hd5qZdosqavv_ABHKAgRviUidxH_s3HZtLz5Fntg4Y3+A@mail.gmail.com>
 <alpine.LRH.2.11.1906260001290.1114@mx.ewheeler.net>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <10bdb5ec-ca74-33f9-7482-fa53046d51b9@suse.de>
Date:   Thu, 27 Jun 2019 20:13:57 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.11.1906260001290.1114@mx.ewheeler.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/6/26 8:04 上午, Eric Wheeler wrote:
> On Tue, 25 Jun 2019, Marc Smith wrote:
> 
>> Hi,
>>
>> I've been experimenting using bcache and MD RAID on Linux 4.14.91. I
>> have a 12-disk RAID6 MD array as the backing device, and a decent NVMe
>> SSD as the caching device. I'm testing using write-back mode.
>>
>> I've been able to tune the sequential_cutoff so when issuing full
>> stripe writes to the bcache device, these bypass hitting the cache
>> device and go right into the MD RAID6 array, which seems to be working
>> nicely.
>>
>> In the next experiment, when performing more random / sequential
>> (mixed) writes, the cache device does a nice job of keeping up
>> performance. However, when watching the data get flushed from the
>> cache device to the backing device (the MD RAID6 volume), it doesn't
>> seem the data is being written out as mostly full stripe writes. I get
>> a lot of RMW's on the drives, so I don't believe I'm seeing these full
>> stripe writes. I was sort of hoping/expecting bcache to do some
>> re-ordering with this... there seem to be some knobs in bcache where
>> it detects the full stripe size, and it knows partial stripe writes
>> are expensive.
>>
>> So I guess my question is if it's known that the data is not
>> re-ordered using full stripe geometry in bcache, or perhaps this is
>> just a tunable that I'm not seeing? It seems bcache has access to this
>> data, but maybe this is a future item where it could be implemented?
>>
>> The problem of course comes from the the sub-par performance when data
>> is flushed from the cache device to the backing device... lots of
>> read-modify-writes result in very poor write performance. If the I/O
>> was pushed to the backing device as full stripe I/O's (or at least
>> mostly) I'd expect to see better performance when flushing the cache.
> 
> You could try turning up /sys/block/bcache0/bcache/writeback_percent .  
> Maybe there aren't enough contiguous regions in the writeback cache to 
> queue for write.
> 
> Coly,
> 
> Do you know how the nr_stripes, stripe_sectors_dirty and 
> full_dirty_stripes bitmaps work together to make a best-effort of writing 
> full stripes to the disk, and maybe you can explain under what 
> circumstances partial stripes would be written?
Hi Eric,

I don't have satisfied answer to the above question. But if upper layers
don't issue I/Os with full stripe aligned, bcache cannot do anything
more than merging adjacent blocks. But for random I/Os, only a few part
of I/O requests can be merged, after writeback thread working for a
while, almost all writeback I/Os are small and not stripe-aligned, even
they are ordered by LBA address number.

Thanks.

-- 

Coly Li
