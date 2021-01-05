Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A3D2EA47B
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Jan 2021 05:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbhAEEeX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 4 Jan 2021 23:34:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:59790 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbhAEEeW (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 Jan 2021 23:34:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5E0D8ACAF;
        Tue,  5 Jan 2021 04:33:40 +0000 (UTC)
To:     Dongdong Tao <dongdong.tao@canonical.com>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Gavin Guo <gavin.guo@canonical.com>,
        Gerald Yang <gerald.yang@canonical.com>,
        Trent Lloyd <trent.lloyd@canonical.com>,
        Dominique Poulain <dominique.poulain@canonical.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
References: <20210105030602.14427-1-tdd21151186@gmail.com>
 <CAJS8hVK-ZCxJt=E3hwR0hmqPYL1T07_WC_nerb-dZodO+DqtDA@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: consider the fragmentation when update the
 writeback rate
Message-ID: <1a4b2a68-a7b0-8eb0-e60b-c3cf5a5a9e56@suse.de>
Date:   Tue, 5 Jan 2021 12:33:35 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAJS8hVK-ZCxJt=E3hwR0hmqPYL1T07_WC_nerb-dZodO+DqtDA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 1/5/21 11:44 AM, Dongdong Tao wrote:
> Hey Coly,
> 
> This is the second version of the patch, please allow me to explain a
> bit for this patch:
> 
> We accelerate the rate in 3 stages with different aggressiveness, the
> first stage starts when dirty buckets percent reach above
> BCH_WRITEBACK_FRAGMENT_THRESHOLD_LOW(50), the second is
> BCH_WRITEBACK_FRAGMENT_THRESHOLD_MID(57) and the third is
> BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH(64). By default the first stage
> tries to writeback the amount of dirty data in one bucket (on average)
> in (1 / (dirty_buckets_percent - 50)) second, the second stage tries to
> writeback the amount of dirty data in one bucket in (1 /
> (dirty_buckets_percent - 57)) * 200 millisecond. The third stage tries
> to writeback the amount of dirty data in one bucket in (1 /
> (dirty_buckets_percent - 64)) * 20 millisecond.
> 
> As we can see, there are two writeback aggressiveness increasing
> strategies, one strategy is with the increasing of the stage, the first
> stage is the easy-going phase whose initial rate is trying to write back
> dirty data of one bucket in 1 second, the second stage is a bit more
> aggressive, the initial rate tries to writeback the dirty data of one
> bucket in 200 ms, the last stage is even more, whose initial rate tries
> to writeback the dirty data of one bucket in 20 ms. This makes sense,
> one reason is that if the preceding stage couldn’t get the fragmentation
> to a fine stage, then the next stage should increase the aggressiveness
> properly, also it is because the later stage is closer to the
> bch_cutoff_writeback_sync. Another aggressiveness increasing strategy is
> with the increasing of dirty bucket percent within each stage, the first
> strategy controls the initial writeback rate of each stage, while this
> one increases the rate based on the initial rate, which is initial_rate
> * (dirty bucket percent - BCH_WRITEBACK_FRAGMENT_THRESHOLD_X).  
> 
> The initial rate can be controlled by 3 parameters
> writeback_rate_fp_term_low, writeback_rate_fp_term_mid,
> writeback_rate_fp_term_high, they are default 1, 5, 50, users can adjust
> them based on their needs.
> 
> The reason that I choose 50, 57, 64 as the threshold value is because
> the GC must be triggered at least once during each stage due to the
> “sectors_to_gc” being set to 1/16 (6.25 %) of the total cache size. So,
> the hope is that the first and second stage can get us back to good
> shape in most situations by smoothly writing back the dirty data without
> giving too much stress to the backing devices, but it might still enter
> the third stage if the bucket consumption is very aggressive.
> 
> This patch use (dirty / dirty_buckets) * fp_term to calculate the rate,
> this formula means that we want to writeback (dirty / dirty_buckets) in
> 1/fp_term second, fp_term is calculated by above aggressiveness
> controller, “dirty” is the current dirty sectors, “dirty_buckets” is the
> current dirty buckets, so (dirty / dirty_buckets) means the average
> dirty sectors in one bucket, the value is between 0 to 1024 for the
> default setting,  so this formula basically gives a hint that to reclaim
> one bucket in 1/fp_term second. By using this semantic, we can have a
> lower writeback rate when the amount of dirty data is decreasing and
> overcome the fact that dirty buckets number is always increasing unless
> GC happens.
> 
> *Compare to the first patch:
> *The first patch is trying to write back all the data in 40 seconds,
> this will result in a very high writeback rate when the amount of dirty
> data is big, this is mostly true for the large cache devices. The basic
> problem is that the semantic of this patch is not ideal, because we
> don’t really need to writeback all dirty data in order to solve this
> issue, and the instant large increase of the rate is something I feel we
> should better avoid (I like things to be smoothly changed unless no
> choice: )).
> 
> Before I get to this new patch(which I believe should be optimal for me
> atm), there have been many tuning/testing iterations, eg. I’ve tried to
> tune the algorithm to writeback ⅓ of the dirty data in a certain amount
> of seconds, writeback 1/fragment of the dirty data in a certain amount
> of seconds, writeback all the dirty data only in those error_buckets
> (error buckets = dirty buckets - 50% of the total buckets) in a certain
> amount of time. However, those all turn out not to be ideal, only the
> semantic of the patch makes much sense for me and allows me to control
> the rate in a more precise way.
> 
> *Testing data:
> *I'll provide the visualized testing data in the next couple of days
> with 1TB NVME devices cache but with HDD as backing device since it's
> what we mostly used in production env. 
> I have the data for 400GB NVME, let me prepare it and take it for you to
> review.
[snipped]

Hi Dongdong,

Thanks for the update and continuous effort on this idea.

Please keep in mind the writeback rate is just a advice rate for the
writeback throughput, in real workload changing the writeback rate
number does not change writeback throughput obviously.

Currently I feel this is an interesting and promising idea for your
patch, but I am not able to say whether it may take effect in real
workload, so we do need convinced performance data on real workload and
configuration.

Of course I may also help on the benchmark, but my to-do list is long
enough and it may take a very long delay time.

Thanks.

Coly Li
