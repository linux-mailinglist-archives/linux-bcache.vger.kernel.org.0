Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46B726CFA8A
	for <lists+linux-bcache@lfdr.de>; Thu, 30 Mar 2023 07:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjC3FFL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 30 Mar 2023 01:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjC3FFK (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 30 Mar 2023 01:05:10 -0400
X-Greylist: delayed 598 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 29 Mar 2023 22:05:09 PDT
Received: from gateway.gemtalksystems.com (gateway.gemtalksystems.com [50.234.234.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759894C10
        for <linux-bcache@vger.kernel.org>; Wed, 29 Mar 2023 22:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=gemtalksystems.com;
        s=2022-07; t=1680152110;
        bh=jG9IbOhBWM10Nm+ZvrMal9nxspOcmQWyFkrJWamEC2Q=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=GyhUgCkrwh6cNEb9c533GdVS/YfZIgl93RA3E+PiF7L/M28wQS9GSkh039j2QX7rM
         FdDhJVIqs/Mi9RUgAc4ksOYZledtYqOCl/aLAnHJBWBk9KTLCNKabS7+ah0pS7YBxy
         ZHplK48MRrVn0RkhPtanDG5yqUKzb7mlP0HernRpcVLfs2U/3Ur6d5r6Pz2SLOz84j
         /l9dLcJ04AXAAg5Jf59h7oh+cyvncSwJI8wD5ZDxbsemAUCKgRsu5jBr0aRLOKvbHz
         CLIPQwzT6TAgzpyIxs1tJS+HnUkQnp+4wIs+cO7Ey3yNO3/pQ2zprFSCzB5igenqnh
         T2kVjBUAMGdPw==
Received: from [10.94.155.46] (vpn-udp-46.gemtalksystems.com [10.94.155.46])
        by office-ns.gemtalksystems.com (Postfix) with ESMTP id 9ACAD60081;
        Wed, 29 Mar 2023 21:55:10 -0700 (PDT)
Message-ID: <e0e6c881-f1e4-f02c-ce76-1dbc6170ff1f@gemtalksystems.com>
Date:   Wed, 29 Mar 2023 21:55:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: Writeback cache all used.
Content-Language: en-US
To:     Adriano Silva <adriano_da_silva@yahoo.com.br>,
        Bcache Linux <linux-bcache@vger.kernel.org>
References: <1012241948.1268315.1680082721600.ref@mail.yahoo.com>
 <1012241948.1268315.1680082721600@mail.yahoo.com>
From:   Martin McClure <martin.mcclure@gemtalksystems.com>
In-Reply-To: <1012241948.1268315.1680082721600@mail.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/29/23 02:38, Adriano Silva wrote:
> Hey guys,
>
> I'm using bcache to support Ceph. Ten Cluster nodes have a bcache device each consisting of an HDD block device and an NVMe cache. But I am noticing what I consider to be a problem: My cache is 100% used even though I still have 80% of the space available on my HDD.
>
> It is true that there is more data written than would fit in the cache. However, I imagine that most of them should only be on the HDD and not in the cache, as they are cold data, almost never used.
>
> I noticed that there was a significant drop in performance on the disks (writes) and went to check. Benchmark tests confirmed this. Then I noticed that there was 100% cache full and 85% cache evictable. There was a bit of dirty cache. I found an internet message talking about the garbage collector, so I tried the following:
>
> echo 1 > /sys/block/bcache0/bcache/cache/internal/trigger_gc
>
> That doesn't seem to have helped.
>
> Then I collected the following data:
>
> --- bcache ---
> Device /dev/sdc (8:32)
> UUID 38e81dff-a7c9-449f-9ddd-182128a19b69
> Block Size 4.00KiB
> Bucket Size 256.00KiB
> Congested? False
> Read Congestion 0.0ms
> Write Congestion 0.0ms
> Total Cache Size 553.31GiB
> Total Cache Used 547.78GiB (99%)
> Total Unused Cache 5.53GiB (1%)
> Dirty Data 0B (0%)
> Evictable Cache 503.52GiB (91%)
> Replacement Policy [lru] fifo random
> Cache Mode writethrough [writeback] writearound none
> Total Hits 33361829 (99%)
> Total Missions 185029
> Total Bypass Hits 6203 (100%)
> Total Bypass Misses 0
> Total Bypassed 59.20MiB
> --- Cache Device ---
>     Device /dev/nvme0n1p1 (259:1)
>     Size 553.31GiB
>     Block Size 4.00KiB
>     Bucket Size 256.00KiB
>     Replacement Policy [lru] fifo random
>     Discard? False
>     I/O Errors 0
>     Metadata Written 395.00GiB
>     Data Written 1.50 TiB
>     Buckets 2266376
>     Cache Used 547.78GiB (99%)
>     Cache Unused 5.53GiB (0%)
> --- Backing Device ---
>     Device /dev/sdc (8:32)
>     Size 5.46TiB
>     Cache Mode writethrough [writeback] writearound none
>     Readhead
>     Sequential Cutoff 0B
>     Sequential merge? False
>     state clean
>     Writeback? true
>     Dirty Data 0B
>     Total Hits 32903077 (99%)
>     Total Missions 185029
>     Total Bypass Hits 6203 (100%)
>     Total Bypass Misses 0
>     Total Bypassed 59.20MiB
>
> The dirty data has disappeared. But the cache remains 99% utilization, down just 1%. Already the evictable cache increased to 91%!
>
> The impression I have is that this harms the write cache. That is, if I need to write again, the data goes straight to the HDD disks, as there is no space available in the Cache.
>
> Shouldn't bcache remove the least used part of the cache?

I don't know for sure, but I'd think that since 91% of the cache is 
evictable, writing would just evict some data from the cache (without 
writing to the HDD, since it's not dirty data) and write to that area of 
the cache, *not* to the HDD. It wouldn't make sense in many cases to 
actually remove data from the cache, because then any reads of that data 
would have to read from the HDD; leaving it in the cache has very little 
cost and would speed up any reads of that data.

Regards,
-Martin

>
> Does anyone know why this isn't happening?
>
> I may be talking nonsense, but isn't there a way to tell bcache to keep a write-free space rate in the cache automatically? Or even if it was manually by some command that I would trigger at low disk access times?
>
> Thanks!

