Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12FF6DA493
	for <lists+linux-bcache@lfdr.de>; Thu,  6 Apr 2023 23:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjDFVVV (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 6 Apr 2023 17:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjDFVVU (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 6 Apr 2023 17:21:20 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E59A26B
        for <linux-bcache@vger.kernel.org>; Thu,  6 Apr 2023 14:21:19 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 0E4EF85;
        Thu,  6 Apr 2023 14:21:19 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id bTBToPVdLNUK; Thu,  6 Apr 2023 14:21:14 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 9FBEC45;
        Thu,  6 Apr 2023 14:21:14 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 9FBEC45
Date:   Thu, 6 Apr 2023 14:21:14 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Adriano Silva <adriano_da_silva@yahoo.com.br>
cc:     Coly Li <colyli@suse.de>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Martin McClure <martin.mcclure@gemtalksystems.com>
Subject: Re: Writeback cache all used.
In-Reply-To: <2054791833.3229438.1680723106142@mail.yahoo.com>
Message-ID: <ceb1db27-11ef-36d1-3fa1-9df09c822c16@ewheeler.net>
References: <1012241948.1268315.1680082721600.ref@mail.yahoo.com> <1012241948.1268315.1680082721600@mail.yahoo.com> <e0e6c881-f1e4-f02c-ce76-1dbc6170ff1f@gemtalksystems.com> <1121771993.1793905.1680221827127@mail.yahoo.com> <eca36733-cdbd-6e16-2436-906ab2a38da9@ewheeler.net>
 <E69AB364-712A-41A3-91EB-46F85A8F3E69@suse.de> <fd12e250-92a8-74f-e24-f7cc62a5b4a4@ewheeler.net> <D4D242AA-D5C3-46B6-AE83-4BE52D2E504B@suse.de> <1783117292.2943582.1680640140702@mail.yahoo.com> <A48EBD27-D83B-4552-8EEC-838162B76BC4@suse.de>
 <2054791833.3229438.1680723106142@mail.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-1188176496-1680815942=:27286"
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1188176496-1680815942=:27286
Content-Type: text/plain; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 5 Apr 2023, Adriano Silva wrote:
> > Can you try to write 1 to cache set sysfs file 
> > gc_after_writeback? 
> > When it is set, a gc will be waken up automatically after 
> > all writeback accomplished. Then most of the clean cache 
> > might be shunk and the B+tree nodes will be deduced 
> > quite a lot.
> 
> Would this be the command you ask me for?
> 
> root@pve-00-005:~# echo 1 > /sys/fs/bcache/a18394d8-186e-44f9-979a-8c07cb3fbbcd/internal/gc_after_writeback
> 
> If this command is correct, I already advance that it did not give the 
> expected result. The Cache continues with 100% of the occupied space. 
> Nothing has changed despite the cache being cleaned and having written 
> the command you recommended. Let's see:

Did you try to trigger gc after setting gc_after_writeback=1?

        echo 1 > /sys/block/bcache0/bcache/cache/internal/trigger_gc

The `gc_after_writeback=1` setting might not trigger until writeback 
finishes, but if writeback is already finished and there is no new IO then 
it may never trigger unless it is forced via `tigger_gc`

-Eric

> root@pve-00-005:~# cat /sys/block/bcache0/bcache/cache/cache0/priority_stats
> Unused:         0%
> Clean:          98%
> Dirty:          1%
> Metadata:       0%
> Average:        1137
> Sectors per Q:  36245232
> Quantiles:      [12 26 42 60 80 127 164 237 322 426 552 651 765 859 948 1030 1176 1264 1370 1457 1539 1674 1786 1899 1989 2076 2232 2350 2471 2594 2764]
> 
> But if there was any movement on the disks after the command, I couldn't detect it:
> 
> root@pve-00-005:~# dstat -drt -D sdc,nvme0n1,bcache0
> --dsk/sdc---dsk/nvme0n1-dsk/bcache0 ---io/sdc----io/nvme0n1--io/bcache0 ----system----
>  read  writ: read  writ: read  writ| read  writ: read  writ: read  writ|     time     
>   54k  153k: 300k  221k: 222k  169k|0.67  0.53 :6.97  20.4 :6.76  12.3 |05-04 15:28:57
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 |05-04 15:28:58
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 |05-04 15:28:59
\>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 
|05-04 15:29:00
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 |05-04 15:29:01
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 |05-04 15:29:02
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 |05-04 15:29:03
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 |05-04 15:29:04^C
> root@pve-00-005:~#
> 
> Why were there no changes?
> 
> > Currently there is no such option for limit bcache 
> > in-memory B+tree nodes cache occupation, but when I/O 
> > load reduces, such memory consumption may drop very 
> > fast by the reaper from system memory management 
> > code. So it won’t be a problem. Bcache will try to use any 
> > possible memory for B+tree nodes cache if it is 
> > necessary, and throttle I/O performance to return these 
> > memory back to memory management code when the 
> > available system memory is low. By default, it should 
> > work well and nothing should be done from user.
> 
> I've been following the server's operation a lot and I've never seen less than 50 GB of free RAM memory. Let's see: 
> 
> root@pve-00-005:~# free               total        used        free      shared  buff/cache   available
> Mem:       131980688    72670448    19088648       76780    40221592    57335704
> Swap:              0           0           0
> root@pve-00-005:~#
> 
> There is always plenty of free RAM, which makes me ask: Could there really be a problem related to a lack of RAM?
> 
> > Bcache doesn’t issue trim request proactively. 
> > [...]
> > In run time, bcache code only forward the trim request to backing device (not cache device).
> 
> Wouldn't it be advantageous if bcache sent TRIM (discard) to the cache temporarily? I believe flash drives (SSD or NVMe) that need TRIM to maintain top performance are typically used as a cache for bcache. So, I think that if the TRIM command was used regularly by bcache, in the background (only for clean and free buckets), with a controlled frequency, or even if executed by a manually triggered by the user background task (always only for clean and free buckets), it could help to reduce the write latency of the cache. I believe it would help the writeback efficiency a lot. What do you think about this?
> 
> Anyway, this issue of the free buckets not appearing is keeping me awake at night. Could it be a problem with my Kernel version (Linux 5.15)?
> 
> As I mentioned before, I saw in the bcache documentation (https://docs.kernel.org/admin-guide/bcache.html) a variable (freelist_percent) that was supposed to control a minimum rate of free buckets. Could it be a solution? I don't know. But in practice, I didn't find this variable in my system (could it be because of the OS version?)
> 
> Thank you very much!
> 
> 
> 
> Em quarta-feira, 5 de abril de 2023 às 10:57:58 BRT, Coly Li <colyli@suse.de> escreveu: 
> 
> 
> 
> 
> 
> 
> 
> > 2023年4月5日 04:29，Adriano Silva <adriano_da_silva@yahoo.com.br> 写道：
> > 
> > Hello,
> > 
> >> It sounds like a large cache size with limit memory cache 
> >> for B+tree nodes?
> > 
> >> If the memory is limited and all B+tree nodes in the hot I/O 
> >> paths cannot stay in memory, it is possible for such 
> >> behavior happens. In this case, shrink the cached data 
> >> may deduce the meta data and consequential in-memory 
> >> B+tree nodes as well. Yes it may be helpful for such 
> >> scenario.
> > 
> > There are several servers (TEN) all with 128 GB of RAM, of which around 100GB (on average) are presented by the OS as free. Cache is 594GB in size on enterprise NVMe, mass storage is 6TB. The configuration on all is the same. They run Ceph OSD to service a pool of disks accessed by servers (others including themselves).
> > 
> > All show the same behavior.
> > 
> > When they were installed, they did not occupy the entire cache. Throughout use, the cache gradually filled up and  never decreased in size. I have another five servers in  another cluster going the same way. During the night  their workload is reduced.
> 
> Copied.
> 
> > 
> >> But what is the I/O pattern here? If all the cache space 
> >> occupied by clean data for read request, and write 
> >> performance is cared about then. Is this a write tended, 
> >> or read tended workload, or mixed?
> > 
> > The workload is greater in writing. Both are important, read and write. But write latency is critical. These are virtual machine disks that are stored on Ceph. Inside we have mixed loads, Windows with terminal service, Linux, including a database where direct write latency is critical.
> 
> 
> Copied.
> 
> > 
> >> As I explained, the re-reclaim has been here already. 
> >> But it cannot help too much if busy I/O requests always 
> >> coming and writeback and gc threads have no spare 
> >> time to perform.
> > 
> >> If coming I/Os exceeds the service capacity of the 
> >> cache service window, disappointed requesters can 
> >> be expected.
> > 
> > Today, the ten servers have been without I/O operation for at least 24 hours. Nothing has changed, they continue with 100% cache occupancy. I believe I should have given time for the GC, no?
> 
> This is nice. Now we have the maximum writeback thoughput after I/O idle for a while, so after 24 hours all dirty data should be written back and the whole cache might be clean.
> 
> I guess just a gc is needed here.
> 
> Can you try to write 1 to cache set sysfs file gc_after_writeback? When it is set, a gc will be waken up automatically after all writeback accomplished. Then most of the clean cache might be shunk and the B+tree nodes will be deduced quite a lot.
> 
> 
> > 
> >> Let’s check whether it is just becasue of insuffecient 
> >> memory to hold the hot B+tree node in memory.
> > 
> > Does the bcache configuration have any RAM memory reservation options? Or would the 100GB of RAM be insufficient for the 594GB of NVMe Cache? For that amount of Cache, how much RAM should I have reserved for bcache? Is there any command or parameter I should use to signal bcache that it should reserve this RAM memory? I didn't do anything about this matter. How would I do it?
> > 
> 
> Currently there is no such option for limit bcache in-memory B+tree nodes cache occupation, but when I/O load reduces, such memory consumption may drop very fast by the reaper from system memory management code. So it won’t be a problem. Bcache will try to use any possible memory for B+tree nodes cache if it is necessary, and throttle I/O performance to return these memory back to memory management code when the available system memory is low. By default, it should work well and nothing should be done from user. 
> 
> > Another question: How do I know if I should trigger a TRIM (discard) for my NVMe with bcache?
> 
> Bcache doesn’t issue trim request proactively. The bcache program from bcache-tools may issue a discard request when you run,
>     bcache make -C <cache device path>
> to create a cache device.
> 
> In run time, bcache code only forward the trim request to backing device (not cache device).
> 
> 
> 
> Thanks.
> 
> Coly Li
> 
> 
> 
> > 
> [snipped]
> 
> 
> 
--8323328-1188176496-1680815942=:27286--
