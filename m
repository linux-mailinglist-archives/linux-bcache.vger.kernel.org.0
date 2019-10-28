Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 619E6E74A9
	for <lists+linux-bcache@lfdr.de>; Mon, 28 Oct 2019 16:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbfJ1PON (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 28 Oct 2019 11:14:13 -0400
Received: from titan.nuclearwinter.com ([205.185.120.7]:43784 "EHLO
        titan.nuclearwinter.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbfJ1PON (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 28 Oct 2019 11:14:13 -0400
Received: from [IPv6:2601:6c5:8000:6b90:3869:81d7:ef0:db01] (desktop.nuclearwinter.com [IPv6:2601:6c5:8000:6b90:3869:81d7:ef0:db01])
        (authenticated bits=0)
        by titan.nuclearwinter.com (8.14.7/8.14.7) with ESMTP id x9SFE9uV017789
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO)
        for <linux-bcache@vger.kernel.org>; Mon, 28 Oct 2019 11:14:11 -0400
DKIM-Filter: OpenDKIM Filter v2.11.0 titan.nuclearwinter.com x9SFE9uV017789
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nuclearwinter.com;
        s=201211; t=1572275651;
        bh=39SlYUMXXAm2mKUL4wC1hD8/5i5lX+zTdRUGVm0KbOQ=;
        h=From:Subject:To:References:Date:In-Reply-To:From;
        b=PF6t4T5o4UsBDgTvpxllEW0ZeLO7aWRbDMyzH394iCPfltDww9fKxk0unhyaHXarU
         U1i8n4Fn6MXHksx6PVNe18chDmSTv7MiltshnVWXzQINBsfSd+eVpK8hHPEioM8kfs
         ITJaaDNcJAWDf4AHSnTQuwXrW/0wTUEfVsOeJ5JA=
From:   Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Re: bcache writeback infinite loop?
To:     linux-bcache@vger.kernel.org
References: <4d6fe8a0-ecae-738b-165b-ee66683a2df6@nuclearwinter.com>
 <alpine.LRH.2.11.1910242322110.25870@mx.ewheeler.net>
 <fa7a7125-195f-a2ad-4b5e-287c02cd9327@suse.de>
Message-ID: <89f29562-409b-7b4e-e299-1c8e8db77ea5@nuclearwinter.com>
Date:   Mon, 28 Oct 2019 11:14:10 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <fa7a7125-195f-a2ad-4b5e-287c02cd9327@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (titan.nuclearwinter.com [IPv6:2605:6400:20:950:ed61:983f:b93a:fc2b]); Mon, 28 Oct 2019 11:14:11 -0400 (EDT)
X-Spam-Status: No, score=-1.1 required=5.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU autolearn=disabled version=3.4.0
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        titan.nuclearwinter.com
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 10/27/2019 11:01 PM, Coly Li wrote:
> On 2019/10/25 7:22 上午, Eric Wheeler wrote:
>> On Wed, 23 Oct 2019, Larkin Lowrey wrote:
>>> I have a backing device that is constantly writing due to bcache_writebac. It
>>> has been at 14.3.MB dirty all day and has not changed. There's nothing else
>>> writing to it.
>>>
>>> This started after I "upgraded" from Fedora 29 to 30 and consequently from
>>> kernel 5.2.18 to 5.3.6.
>>>
>>> You can see from the info below that the writeback process is chewing up  A
>>> LOT of CPU and writing constantly at ~7MB/s. It sure looks like it's in an
>>> infinite loop and writing the same data over and over. At least I hope that's
>>> the case and it's not just filling the array with garbage.
>>>
>>> This configuration has been stable for many years and across many Fedora
>>> upgrades. The host has ECC memory so RAM corruption should not be a concern. I
>>> have not had any recent controller or drive failures.
>>>
>>>   PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
>>>   5915 root      20   0       0      0      0 R  94.1   0.0 891:45.42
>>>   bcache_writebac
>>>
>>>
>>> Device            r/s     w/s     rMB/s     wMB/s   rrqm/s   wrqm/s  %rrqm
>>> %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
>>> md3              0.02 1478.77      0.00      6.90     0.00     0.00   0.00
>>> 0.00    0.00    0.00   0.00     7.72     4.78   0.00   0.00
>>> md3              0.00 1600.00      0.00      7.48     0.00     0.00   0.00
>>> 0.00    0.00    0.00   0.00     0.00     4.79   0.00   0.00
>>> md3              0.00 1300.00      0.00      6.07     0.00     0.00   0.00
>>> 0.00    0.00    0.00   0.00     0.00     4.78   0.00   0.00
>>> md3              0.00 1500.00      0.00      7.00     0.00     0.00   0.00
>>> 0.00    0.00    0.00   0.00     0.00     4.78   0.00   0.00
>>>
>>> --- bcache ---
>>> UUID                        dc2877bc-d1b3-43fa-9f15-cad018e73bf6
>>> Block Size                  512 B
>>> Bucket Size                 512.00 KiB
>>> Congested?                  False
>>> Read Congestion             2.0ms
>>> Write Congestion            20.0ms
>>> Total Cache Size            128 GiB
>>> Total Cache Used            128 GiB     (100%)
>>> Total Cache Unused          0 B (0%)
>>> Evictable Cache             127 GiB     (99%)
>>> Replacement Policy          [lru] fifo random
>>> Cache Mode                  writethrough [writeback] writearound none
>>> Total Hits                  49872       (97%)
>>> Total Misses                1291
>>> Total Bypass Hits           659 (77%)
>>> Total Bypass Misses         189
>>> Total Bypassed              5.8 MiB
>>> --- Cache Device ---
>>>    Device File               /dev/dm-3 (253:3)
>>>    Size                      128 GiB
>>>    Block Size                512 B
>>>    Bucket Size               512.00 KiB
>>>    Replacement Policy        [lru] fifo random
>>>    Discard?                  False
>>>    I/O Errors                0
>>>    Metadata Written          5.0 MiB
>>>    Data Written              86.1 MiB
>>>    Buckets                   262144
>>>    Cache Used                128 GiB     (100%)
>>>    Cache Unused              0 B (0%)
>>> --- Backing Device ---
>>>    Device File               /dev/md3 (9:3)
>>>    bcache Device File        /dev/bcache0 (252:0)
>>>    Size                      73 TiB
>>>    Cache Mode                writethrough [writeback] writearound none
>>>    Readahead                 0.0k
>>>    Sequential Cutoff         4.0 MiB
>>>    Merge sequential?         False
>>>    State                     dirty
>>>    Writeback?                True
>>>    Dirty Data                14.3 MiB
>>>    Total Hits                49872       (97%)
>>>    Total Misses              1291
>>>    Total Bypass Hits         659 (77%)
>>>    Total Bypass Misses       189
>>>    Total Bypassed            5.8 MiB
>>>
>>> I have not tried reverting back to an earlier kernel. I'm concerned about
>>> possible corruption. Is that safe? Any other suggestions as to how to debug
>>> and/or resolve this issue?
>> I don't there have been any on-disk format changes, reverting should be
>> safe.
>>
>> Coly?  Can you confirm?
> There is no on-disk format change for now. It should be safe to revert
> to previous version.
>

Reverting to 5.2.18 didn't make a difference not did moving forward to 
5.3.7.

I noticed that on each reboot the point where it got stuck changed. It 
had been stuck at 14.3MiB dirty then a couple of reboots later it was 
down to 10.7MiB. For example...

On reboot, the dirty was 42.9MiB and proceeded to shrink until it got 
stuck at 10.7MiB. I then rebooted and it was 44.9MiB and shrank to 
10.0MiB. I rebooted again, and got unlucky, it started at 45.4MiB and 
got stuck at 10.3MiB (an increase from the prior run). I assume that 
mounting and unmounting the fs does generate some small amount of writes 
which may explain the differences.

The cache device is a raid5 of SSDs and I've not had any unclean 
shutdowns so I would not expect data corruption there. A raid check ran 
yesterday with no errors.

--Larkin

