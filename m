Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99B826CF2FB
	for <lists+linux-bcache@lfdr.de>; Wed, 29 Mar 2023 21:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjC2TTJ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 29 Mar 2023 15:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjC2TTJ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 29 Mar 2023 15:19:09 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA73E10F5
        for <linux-bcache@vger.kernel.org>; Wed, 29 Mar 2023 12:18:40 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 2C73681;
        Wed, 29 Mar 2023 12:18:38 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id JfBlGAADeUwC; Wed, 29 Mar 2023 12:18:37 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id DEA2845;
        Wed, 29 Mar 2023 12:18:36 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net DEA2845
Date:   Wed, 29 Mar 2023 12:18:36 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Adriano Silva <adriano_da_silva@yahoo.com.br>
cc:     Bcache Linux <linux-bcache@vger.kernel.org>
Subject: Re: Writeback cache all used.
In-Reply-To: <1012241948.1268315.1680082721600@mail.yahoo.com>
Message-ID: <680c7a6-f9ab-329d-95a8-97b457a634e5@ewheeler.net>
References: <1012241948.1268315.1680082721600.ref@mail.yahoo.com> <1012241948.1268315.1680082721600@mail.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-714639048-1680117417=:27286"
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-714639048-1680117417=:27286
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Wed, 29 Mar 2023, Adriano Silva wrote:

> Hey guys,
> 
> I'm using bcache to support Ceph. Ten Cluster nodes have a bcache device 
> each consisting of an HDD block device and an NVMe cache. But I am 
> noticing what I consider to be a problem: My cache is 100% used even 
> though I still have 80% of the space available on my HDD.
> 
> It is true that there is more data written than would fit in the cache. 
> However, I imagine that most of them should only be on the HDD and not 
> in the cache, as they are cold data, almost never used.
> 
> I noticed that there was a significant drop in performance on the disks 
> (writes) and went to check. Benchmark tests confirmed this. Then I 
> noticed that there was 100% cache full and 85% cache evictable. There 
> was a bit of dirty cache. I found an internet message talking about the 
> garbage collector, so I tried the following:
> 
> echo 1 > /sys/block/bcache0/bcache/cache/internal/trigger_gc

What kernel version are you running?  There are some gc cache fixes out 
there, about v5.18 IIRC, that might help things.

--
Eric Wheeler



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
>    Device /dev/nvme0n1p1 (259:1)
>    Size 553.31GiB
>    Block Size 4.00KiB
>    Bucket Size 256.00KiB
>    Replacement Policy [lru] fifo random
>    Discard? False
>    I/O Errors 0
>    Metadata Written 395.00GiB
>    Data Written 1.50 TiB
>    Buckets 2266376
>    Cache Used 547.78GiB (99%)
>    Cache Unused 5.53GiB (0%)
> --- Backing Device ---
>    Device /dev/sdc (8:32)
>    Size 5.46TiB
>    Cache Mode writethrough [writeback] writearound none
>    Readhead
>    Sequential Cutoff 0B
>    Sequential merge? False
>    state clean
>    Writeback? true
>    Dirty Data 0B
>    Total Hits 32903077 (99%)
>    Total Missions 185029
>    Total Bypass Hits 6203 (100%)
>    Total Bypass Misses 0
>    Total Bypassed 59.20MiB
> 
> The dirty data has disappeared. But the cache remains 99% utilization, down just 1%. Already the evictable cache increased to 91%!
> 
> The impression I have is that this harms the write cache. That is, if I need to write again, the data goes straight to the HDD disks, as there is no space available in the Cache.
> 
> Shouldn't bcache remove the least used part of the cache?
> 
> Does anyone know why this isn't happening?
> 
> I may be talking nonsense, but isn't there a way to tell bcache to keep a write-free space rate in the cache automatically? Or even if it was manually by some command that I would trigger at low disk access times?
> 
> Thanks!
> 
--8323328-714639048-1680117417=:27286--
