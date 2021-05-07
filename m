Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F6A3764EC
	for <lists+linux-bcache@lfdr.de>; Fri,  7 May 2021 14:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236138AbhEGMOL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 7 May 2021 08:14:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:56842 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230386AbhEGMOJ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 7 May 2021 08:14:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4C3A6B168;
        Fri,  7 May 2021 12:13:09 +0000 (UTC)
Subject: Re: Dirty data loss after cache disk error recovery
To:     Kai Krakow <kai@kaishome.de>,
        =?UTF-8?B?5ZC05pys5Y2/KOS6keahjOmdoiDnpo8=?= =?UTF-8?B?5beeKQ==?= 
        <wubenqing@ruijie.com.cn>
Cc:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
References: <82A10A71B70FF2449A8AD233969A45A101CCE29C5B@FZEX5.ruijie.com.cn>
 <CAC2ZOYugQAw9NbMk_oo_2iC5GsZUN=uTO5FuvdRTMy9M6ASNEg@mail.gmail.com>
 <CAC2ZOYtg4P_CYrTH6kQM1vCuU4Bai7v8K3Nmu3Yz7fNuHfEnRw@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <2662a21d-8f12-186a-e632-964ac7bae72d@suse.de>
Date:   Fri, 7 May 2021 20:13:06 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAC2ZOYtg4P_CYrTH6kQM1vCuU4Bai7v8K3Nmu3Yz7fNuHfEnRw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/29/21 2:39 AM, Kai Krakow wrote:
> Hi Coly!
> 
> Am Mi., 28. Apr. 2021 um 20:30 Uhr schrieb Kai Krakow <kai@kaishome.de>:
>>
>> Hello!
>>
>> Am Di., 20. Apr. 2021 um 05:24 Uhr schrieb 吴本卿(云桌面 福州)
>> <wubenqing@ruijie.com.cn>:
>>>
>>> Hi, Recently I found a problem in the process of using bcache. My cache disk was offline for some reasons. When the cache disk was back online, I found that the backend in the detached state. I tried to attach the backend to the bcache again, and found that the dirty data was lost. The md5 value of the same file on backend's filesystem is different because dirty data loss.
>>>
>>> I checked the log and found that logs:
>>> [12228.642630] bcache: conditional_stop_bcache_device() stop_when_cache_set_failed of bcache0 is "auto" and cache is dirty, stop it to avoid potential data corruption.
>>
>> "stop it to avoid potential data corruption" is not what it actually
>> does: neither it stops it, nor it prevents corruption because dirty
>> data becomes thrown away.
>>
>>> [12228.644072] bcache: cached_dev_detach_finish() Caching disabled for sdb
>>> [12228.644352] bcache: cache_set_free() Cache set 55b9112d-d52b-4e15-aa93-e7d5ccfcac37 unregistered
>>>
>>> I checked the code of bcache and found that a cache disk IO error will trigger __cache_set_unregister, which will cause the backend to be datach, which also causes the loss of dirty data. Because after the backend is reattached, the allocated bcache_device->id is incremented, and the bkey that points to the dirty data stores the old id.
>>>
>>> Is there a way to avoid this problem, such as providing users with options, if a cache disk error occurs, execute the stop process instead of detach.
>>> I tried to increase cache_set->io_error_limit, in order to win the time to execute stop cache_set.
>>> echo 4294967295 > /sys/fs/bcache/55b9112d-d52b-4e15-aa93-e7d5ccfcac37/io_error_limit
>>>
>>> It did not work at that time, because in addition to bch_count_io_errors, which calls bch_cache_set_error, there are other code paths that also call bch_cache_set_error. For example, an io error occurs in the journal:
>>> Apr 19 05:50:18 localhost.localdomain kernel: bcache: bch_cache_set_error() bcache: error on 55b9112d-d52b-4e15-aa93-e7d5ccfcac37:
>>> Apr 19 05:50:18 localhost.localdomain kernel: journal io error
>>> Apr 19 05:50:18 localhost.localdomain kernel: bcache: bch_cache_set_error() , disabling caching
>>> Apr 19 05:50:18 localhost.localdomain kernel: bcache: conditional_stop_bcache_device() stop_when_cache_set_failed of bcache0 is "auto" and cache is dirty, stop it to avoid potential data corruption.
>>>
>>> When an error occurs in the cache device, why is it designed to unregister the cache_set? What is the original intention? The unregister operation means that all backend relationships are deleted, which will result in the loss of dirty data.
>>> Is it possible to provide users with a choice to stop the cache_set instead of unregistering it.
>>
>> I think the same problem hit me, too, last night.
>>
>> My kernel choked because of a GPU error, and that somehow disconnected
>> the cache. I can only guess that there was some sort of timeout due to
>> blocked queues, and that introduced an IO error which detached the
>> caches.
>>
>> Sadly, I only realized this after I already reformatted and started
>> restore from backup: During the restore I watched the bcache status
>> and found that the devices are not attached.
>>
>> I don't know if I could have re-attached the devices instead of
>> formatting. But I think the dirty data would have been discarded
>> anyways due to incrementing bcache_device->id.
>>
>> This really needs a better solution, detaching is one of the worst,
>> especially on btrfs this has catastrophic consequences because data is
>> not updated inline but via copy on write. This requires updating a lot
>> of pointers. Usually, cow filesystem would be robust to this kind of
>> data-loss but the vast amount of dirty data that is lost puts the tree
>> generations too far behind of what btrfs is expecting, making it
>> essentially broken beyond repair. If some trees in the FS are just a
>> few generations behind, btrfs can repair itself by using a backup tree
>> root, but when the bcache is lost, generation numbers usually lag
>> behind several hundred generations. Detaching would be fine if there'd
>> be no dirty data - otherwise the device should probably stop and
>> refuse any more IO.
>>
>> @Coly If I patched the source to stop instead of detach, would it have
>> made anything better? Would there be any side-effects? Is it possible
>> to atomically check for dirty data in that case and take either the
>> one or the other action?
> 
> I think this behavior was introduced by https://lwn.net/Articles/748226/
> 
> So above is my late review. ;-)
> 
> (around commit 7e027ca4b534b6b99a7c0471e13ba075ffa3f482 if you cannot
> access LWN for reasons[tm])
> 

Hi Kai,

Sorry I just find this thread from my INBOX. Hope it is not too late. I
replied in your latest reply in this thread.

Thanks.

Coly Li
