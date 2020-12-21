Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1652DF9BF
	for <lists+linux-bcache@lfdr.de>; Mon, 21 Dec 2020 09:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgLUIJh (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 21 Dec 2020 03:09:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:45310 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbgLUIJh (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 21 Dec 2020 03:09:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EF413AD45;
        Mon, 21 Dec 2020 08:08:55 +0000 (UTC)
To:     Dongdong Tao <dongdong.tao@canonical.com>
Cc:     Gavin Guo <gavin.guo@canonical.com>,
        Gerald Yang <gerald.yang@canonical.com>,
        Trent Lloyd <trent.lloyd@canonical.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Dominique Poulain <dominique.poulain@canonical.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
References: <20201103124235.14440-1-tdd21151186@gmail.com>
 <89b83c00-1117-d114-2c23-7b03fc22966e@easystack.cn>
 <CAJS8hV+UmLFQVhuqUin1Ze6kLtAO7paXH95+9gaiZgM19VZe1A@mail.gmail.com>
 <ce04461c-ca5c-781d-7aad-cdad3ebadac2@easystack.cn>
 <CAJS8hVLMUS1mdrwC8ovzvMO+HWf4xtXRCNJEghtbtW0g93Kh_g@mail.gmail.com>
 <35a038d8-fe6b-7954-f2d9-be74eb32dcdd@suse.de>
 <CAJS8hVKMjec1cpe_zoeZAJrfY0Pq9bJ51eO6E+g8pgN9jV3Nmw@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: consider the fragmentation when update the
 writeback rate
Message-ID: <c362fbc1-b337-fba9-131e-d4b919cb2c79@suse.de>
Date:   Mon, 21 Dec 2020 16:08:51 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <CAJS8hVKMjec1cpe_zoeZAJrfY0Pq9bJ51eO6E+g8pgN9jV3Nmw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/21/20 12:06 PM, Dongdong Tao wrote:
> Hi Coly,
> 
> Thank you so much for your prompt reply!
> 
> So, I've performed the same fio testing based on 1TB NVME and 10 TB HDD
> disk as the backing device.
> I've run them both for about 4 hours, since it's 1TB nvme device, it
> will roughly take about 10 days to consume 50 percent dirty buckets
> I did increase the iops to 500,100, but the dirty buckets only increased
> to about 30 after 2 days run, and because the read is much limited by
> the backing hdd deivce, so the actual maximum read iops I can constantly
> get is only about 200.

HI Dongdong,

There are two method to make the buckets being filled faster.
1) use larger non-spinning backing device (e.g. a md raid0 with multiple
SSDs).
2) specify larger read block size and small write block size in fio

Or you may combine them together to fill the cache device faster.


> 
> Though the 4 hours run on 1TB nvme bcache didn't make us hit the 50
> percent dirty bucket threshold, but I think it's still valuable to prove
> that 
> bcache with my patch behaves the same way as expected in terms of the
> latency when the dirty bucket is under 50 percent. I guess this might be
> what you wanted to confirm with this run.
> 

Previous testing on tiny SSD size is much better than this time, I
cannot provide my opinion before a non-optimized-configuration testing
finished.

If the latency distribution has no (recognized) difference, it will mean
your patch does not improve I/O latency. I believe this is only the
testing is unfinished yet.

The idea to heuristically estimate bucket fragmentation condition is
cool IMHO, but we need solid performance number to prove this
optimization. Please continue to finish the benchmark with real hardware
configuration, and I do hope we can see recoganized positive result for
your goal (improve I/O latency and throughput for high bucket dirty
segmentation).


Thanks.


Coly Li


> Here is the result:
> Master:
> 
> fio-master.png
> 
> Master + My patch:
> fio-patch.png
> As we can see, the latency distributions for the outliers or those
> majorities are the same between these two runs。 
> Let's combine those two together, and they are more clear:
> fio-full.png
> The test steps are exactly the same for those two runs:
> 
> 
> 1. make-bcache -B <hdd> -C <nvme> --writeback
> 
> 2. sudo fio --name=random-writers --filename=/dev/bcache0
> --ioengine=libaio --iodepth=1 --rw=randrw --bs=16k --direct=1
> --rate_iops=90,10 --numjobs=1 --write_lat_log=16k --runtime=14000
> 
> Thank you so much!
> Regards,
> Dongdong
> 
> On Tue, Dec 15, 2020 at 1:07 AM Coly Li <colyli@suse.de
> <mailto:colyli@suse.de>> wrote:
> 
>     On 12/14/20 11:30 PM, Dongdong Tao wrote:
>     > Hi Coly and Dongsheng,
>     >
>     > I've get the testing result and confirmed that this testing result is
>     > reproducible by repeating it many times.
>     > I ran fio to get the write latency log and parsed the log and then
>     > generated below latency graphs with some visualization tool
>     >
> 
>     Hi Dongdong,
> 
>     Thank you so much for the performance number!
> 
>     [snipped]
>     > So, my code will accelerate the writeback process when the dirty
>     buckets
>     > exceeds 50%( can be tuned), as we can see
>     > the cache_available_percent does increase once it hit 50, so we won't
>     > hit writeback cutoff issue.
>     >
>     > Below are the steps that I used to do the experiment:
>     > 1. make-bcache -B <hdd> -C <nvme> --writeback -- I prepared the nvme
>     > size to 1G, so it can be reproduced faster
>     >
>     > 2. sudo fio --name=random-writers --filename=/dev/bcache0
>     > --ioengine=libaio --iodepth=1 --rw=randrw --bs=16k --direct=1
>     > --rate_iops=90,10 --numjobs=1 --write_lat_log=16k
>     >
>     > 3. For 1 G nvme, running for about 20 minutes is enough get the data.
> 
>     1GB cache and 20 minutes is quite limited for the performance valuation.
>     Could you please to do similar testing with 1TB SSD and 1 hours for each
>     run of the benchmark ?
> 
>     >
>     > Using randrw with rate_iops=90,10 is just one way to reproduce this
>     > easily, this can be reproduced as long as we can create a fragmented
>     > situation that quite few dirty data consumed a lot dirty buckets thus
>     > killing the write performance.
>     >
> 
>     Yes this is a good method to generate dirty data segments.
> 
>     > This bug nowadays is becoming very critical, as ceph is hitting
>     it, ceph
>     > mostly submitting random small IO.
>     > Please let me know what you need in order to move forward in this
>     > direction, I'm sure this patch can be improved also.
> 
>     The performance number is quite convinced and the idea in your patch is
>     promising.
> 
>     I will provide my comments on your patch after we see the performance
>     number for larger cache device and longer run time.
> 
>     Thanks again for the detailed performance number, which is really
>     desired for performance optimization changes :-)
> 
>     Coly Li
> 

