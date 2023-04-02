Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81D0D6D3507
	for <lists+linux-bcache@lfdr.de>; Sun,  2 Apr 2023 02:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjDBABK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 1 Apr 2023 20:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDBABK (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 1 Apr 2023 20:01:10 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954A91880E
        for <linux-bcache@vger.kernel.org>; Sat,  1 Apr 2023 17:01:06 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 0ED4085;
        Sat,  1 Apr 2023 17:01:06 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id Ik8PHsgngJqT; Sat,  1 Apr 2023 17:01:04 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 6EB5345;
        Sat,  1 Apr 2023 17:01:04 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 6EB5345
Date:   Sat, 1 Apr 2023 17:01:04 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Coly Li <colyli@suse.de>
cc:     Bcache Linux <linux-bcache@vger.kernel.org>,
        Martin McClure <martin.mcclure@gemtalksystems.com>,
        Adriano Silva <adriano_da_silva@yahoo.com.br>
Subject: Re: Writeback cache all used.
In-Reply-To: <1121771993.1793905.1680221827127@mail.yahoo.com>
Message-ID: <eca36733-cdbd-6e16-2436-906ab2a38da9@ewheeler.net>
References: <1012241948.1268315.1680082721600.ref@mail.yahoo.com> <1012241948.1268315.1680082721600@mail.yahoo.com> <e0e6c881-f1e4-f02c-ce76-1dbc6170ff1f@gemtalksystems.com> <1121771993.1793905.1680221827127@mail.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-367368634-1680393344=:27286"
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-367368634-1680393344=:27286
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Fri, 31 Mar 2023, Adriano Silva wrote:
> Thank you very much!
> 
> > I don't know for sure, but I'd think that since 91% of the cache is
> > evictable, writing would just evict some data from the cache (without
> > writing to the HDD, since it's not dirty data) and write to that area of
> > the cache, *not* to the HDD. It wouldn't make sense in many cases to
> > actually remove data from the cache, because then any reads of that data
> > would have to read from the HDD; leaving it in the cache has very little
> > cost and would speed up any reads of that data.
> 
> Maybe you're right, it seems to be writing to the cache, despite it 
> indicating that the cache is at 100% full.
> 
> I noticed that it has excellent reading performance, but the writing 
> performance dropped a lot when the cache was full. It's still a higher 
> performance than the HDD, but much lower than it is when it's half full 
> or empty.
> 
> Sequential writing tests with "_fio" now show me 240MB/s of writing, 
> which was already 900MB/s when the cache was still half full. Write 
> latency has also increased. IOPS on random 4K writes are now in the 5K 
> range. It was 16K with half used cache. At random 4K with Ioping, 
> latency went up. With half cache it was 500us. It is now 945us.
> 
> For reading, nothing has changed.
> 
> However, for systems where writing time is critical, it makes a 
> significant difference. If possible I would like to always keep it with 
> a reasonable amount of empty space, to improve writing responses. Reduce 
> 4K latency, mostly. Even if it were for me to program a script in 
> crontab or something like that, so that during the night or something 
> like that the system executes a command for it to clear a percentage of 
> the cache (about 30% for example) that has been unused for the longest 
> time . This would possibly make the cache more efficient on writes as 
> well.

That is an intersting idea since it saves latency. Keeping a few unused 
ready to go would prevent GC during a cached write. 

Coly, would this be an easy feature to add?

Bcache would need a `cache_min_free` tunable that would (asynchronously) 
free the least recently used buckets that are not dirty.

-Eric

> 
> If anyone knows a solution, thanks!
> 
> 
> 
> On 3/29/23 02:38, Adriano Silva wrote:
> > Hey guys,
> >
> > I'm using bcache to support Ceph. Ten Cluster nodes have a bcache device each consisting of an HDD block device and an NVMe cache. But I am noticing what I consider to be a problem: My cache is 100% used even though I still have 80% of the space available on my HDD.
> >
> > It is true that there is more data written than would fit in the cache. However, I imagine that most of them should only be on the HDD and not in the cache, as they are cold data, almost never used.
> >
> > I noticed that there was a significant drop in performance on the disks (writes) and went to check. Benchmark tests confirmed this. Then I noticed that there was 100% cache full and 85% cache evictable. There was a bit of dirty cache. I found an internet message talking about the garbage collector, so I tried the following:
> >
> > echo 1 > /sys/block/bcache0/bcache/cache/internal/trigger_gc
> >
> > That doesn't seem to have helped.
> >
> > Then I collected the following data:
> >
> > --- bcache ---
> > Device /dev/sdc (8:32)
> > UUID 38e81dff-a7c9-449f-9ddd-182128a19b69
> > Block Size 4.00KiB
> > Bucket Size 256.00KiB
> > Congested? False
> > Read Congestion 0.0ms
> > Write Congestion 0.0ms
> > Total Cache Size 553.31GiB
> > Total Cache Used 547.78GiB (99%)
> > Total Unused Cache 5.53GiB (1%)
> > Dirty Data 0B (0%)
> > Evictable Cache 503.52GiB (91%)
> > Replacement Policy [lru] fifo random
> > Cache Mode writethrough [writeback] writearound none
> > Total Hits 33361829 (99%)
> > Total Missions 185029
> > Total Bypass Hits 6203 (100%)
> > Total Bypass Misses 0
> > Total Bypassed 59.20MiB
> > --- Cache Device ---
> >     Device /dev/nvme0n1p1 (259:1)
> >     Size 553.31GiB
> >     Block Size 4.00KiB
> >     Bucket Size 256.00KiB
> >     Replacement Policy [lru] fifo random
> >     Discard? False
> >     I/O Errors 0
> >     Metadata Written 395.00GiB
> >     Data Written 1.50 TiB
> >     Buckets 2266376
> >     Cache Used 547.78GiB (99%)
> >     Cache Unused 5.53GiB (0%)
> > --- Backing Device ---
> >     Device /dev/sdc (8:32)
> >     Size 5.46TiB
> >     Cache Mode writethrough [writeback] writearound none
> >     Readhead
> >     Sequential Cutoff 0B
> >     Sequential merge? False
> >     state clean
> >     Writeback? true
> >     Dirty Data 0B
> >     Total Hits 32903077 (99%)
> >     Total Missions 185029
> >     Total Bypass Hits 6203 (100%)
> >     Total Bypass Misses 0
> >     Total Bypassed 59.20MiB
> >
> > The dirty data has disappeared. But the cache remains 99% utilization, down just 1%. Already the evictable cache increased to 91%!
> >
> > The impression I have is that this harms the write cache. That is, if I need to write again, the data goes straight to the HDD disks, as there is no space available in the Cache.
> >
> > Shouldn't bcache remove the least used part of the cache?
> 
> I don't know for sure, but I'd think that since 91% of the cache is 
> evictable, writing would just evict some data from the cache (without 
> writing to the HDD, since it's not dirty data) and write to that area of 
> the cache, *not* to the HDD. It wouldn't make sense in many cases to 
> actually remove data from the cache, because then any reads of that data 
> would have to read from the HDD; leaving it in the cache has very little 
> cost and would speed up any reads of that data.
> 
> Regards,
> -Martin
> 
> 
> >
> > Does anyone know why this isn't happening?
> >
> > I may be talking nonsense, but isn't there a way to tell bcache to keep a write-free space rate in the cache automatically? Or even if it was manually by some command that I would trigger at low disk access times?
> >
> > Thanks!
> 
> 
--8323328-367368634-1680393344=:27286--
