Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D122ED337
	for <lists+linux-bcache@lfdr.de>; Thu,  7 Jan 2021 16:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbhAGPGe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-bcache@lfdr.de>); Thu, 7 Jan 2021 10:06:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43796 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbhAGPGe (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 7 Jan 2021 10:06:34 -0500
Received: from mail-oo1-f70.google.com ([209.85.161.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <dongdong.tao@canonical.com>)
        id 1kxWrI-0007TE-Gr
        for linux-bcache@vger.kernel.org; Thu, 07 Jan 2021 15:05:52 +0000
Received: by mail-oo1-f70.google.com with SMTP id m7so4570722oop.18
        for <linux-bcache@vger.kernel.org>; Thu, 07 Jan 2021 07:05:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WpyyFJ4fPBGwTKzWOT59msmfGVx9mRP8BSo7tdCr2OA=;
        b=sx6E4BbhcDvaYPeazevzjAkqJGl6XygGJgVUjTX0/xdbcr8ACMUyA8xO0Sackja8Ln
         xK6rFOW5lQ6qUQrsSh9t6dbp9zEwf+gzwmY0TIGzxZEbFQPQCMP2XuTLsUvB/vTjoszR
         Gle//IZzH6Ruj0GWcIubHENZXAqFKdfVGKDa3pUmKqI4L/X36zBizL9tG2RfbKKV9CQx
         HnPYlqe3e+JXLpWtIJGhqa5iYqaPRJ+mhkQWw/mdzriKDRovmKLgu7ftmkwJWN8hF+Qz
         /Aja5yPML4bgcCjPwbWK+zs6BOinfARIQAVxiCfbhL0AjLZr3+rU8WMNM0f9KVkPEs66
         JBxg==
X-Gm-Message-State: AOAM5310Mp1N33NG3YinnSWgH87JakyuXhcd31kNrn5CtUe4DoICBi1R
        Ey0jdGChlMFDUVhlljvZGC/sQIpu7u79fagi2f7D5Xg5IhmIb+QR060wsX9jPxtFA6hAbk8FGG4
        0bUlqQ6GC0AyXi4SZX3HzDeAdzKrA7FuiWKUrBLatXrwzwIQjGnasdjb3xQ==
X-Received: by 2002:a9d:620f:: with SMTP id g15mr6589817otj.361.1610031951259;
        Thu, 07 Jan 2021 07:05:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyqDxCqli8GEZNkQM5LBxaIorYM/vpbarUfdQ/ZkZXjEkMr3zCWLewrTvBRHM1xqzZBgu1TdiCW+ybpKYbRX4w=
X-Received: by 2002:a9d:620f:: with SMTP id g15mr6589792otj.361.1610031950935;
 Thu, 07 Jan 2021 07:05:50 -0800 (PST)
MIME-Version: 1.0
References: <20210105030602.14427-1-tdd21151186@gmail.com> <CAJS8hVK-ZCxJt=E3hwR0hmqPYL1T07_WC_nerb-dZodO+DqtDA@mail.gmail.com>
 <1a4b2a68-a7b0-8eb0-e60b-c3cf5a5a9e56@suse.de>
In-Reply-To: <1a4b2a68-a7b0-8eb0-e60b-c3cf5a5a9e56@suse.de>
From:   Dongdong Tao <dongdong.tao@canonical.com>
Date:   Thu, 7 Jan 2021 23:05:39 +0800
Message-ID: <CAJS8hVJpXR6XEE=VL73RdjcjLR9aCKGJ5t=a48ag_Ey98L-uzg@mail.gmail.com>
Subject: Re: [PATCH] bcache: consider the fragmentation when update the
 writeback rate
To:     "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>
Cc:     Dongdong Tao <dongdong.tao@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

[Sorry for the Spam]

Here is the testing result on 400G NVME, I'll get a 1TB NVME later

https://docs.google.com/document/d/1MmZBWfLRIX7_NfX4tGpWxOj31oIN5NuhNfCFzrIAP48/edit?usp=sharing


On Tue, Jan 5, 2021 at 12:33 PM Coly Li <colyli@suse.de> wrote:
>
> On 1/5/21 11:44 AM, Dongdong Tao wrote:
> > Hey Coly,
> >
> > This is the second version of the patch, please allow me to explain a
> > bit for this patch:
> >
> > We accelerate the rate in 3 stages with different aggressiveness, the
> > first stage starts when dirty buckets percent reach above
> > BCH_WRITEBACK_FRAGMENT_THRESHOLD_LOW(50), the second is
> > BCH_WRITEBACK_FRAGMENT_THRESHOLD_MID(57) and the third is
> > BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH(64). By default the first stage
> > tries to writeback the amount of dirty data in one bucket (on average)
> > in (1 / (dirty_buckets_percent - 50)) second, the second stage tries to
> > writeback the amount of dirty data in one bucket in (1 /
> > (dirty_buckets_percent - 57)) * 200 millisecond. The third stage tries
> > to writeback the amount of dirty data in one bucket in (1 /
> > (dirty_buckets_percent - 64)) * 20 millisecond.
> >
> > As we can see, there are two writeback aggressiveness increasing
> > strategies, one strategy is with the increasing of the stage, the first
> > stage is the easy-going phase whose initial rate is trying to write back
> > dirty data of one bucket in 1 second, the second stage is a bit more
> > aggressive, the initial rate tries to writeback the dirty data of one
> > bucket in 200 ms, the last stage is even more, whose initial rate tries
> > to writeback the dirty data of one bucket in 20 ms. This makes sense,
> > one reason is that if the preceding stage couldn’t get the fragmentation
> > to a fine stage, then the next stage should increase the aggressiveness
> > properly, also it is because the later stage is closer to the
> > bch_cutoff_writeback_sync. Another aggressiveness increasing strategy is
> > with the increasing of dirty bucket percent within each stage, the first
> > strategy controls the initial writeback rate of each stage, while this
> > one increases the rate based on the initial rate, which is initial_rate
> > * (dirty bucket percent - BCH_WRITEBACK_FRAGMENT_THRESHOLD_X).
> >
> > The initial rate can be controlled by 3 parameters
> > writeback_rate_fp_term_low, writeback_rate_fp_term_mid,
> > writeback_rate_fp_term_high, they are default 1, 5, 50, users can adjust
> > them based on their needs.
> >
> > The reason that I choose 50, 57, 64 as the threshold value is because
> > the GC must be triggered at least once during each stage due to the
> > “sectors_to_gc” being set to 1/16 (6.25 %) of the total cache size. So,
> > the hope is that the first and second stage can get us back to good
> > shape in most situations by smoothly writing back the dirty data without
> > giving too much stress to the backing devices, but it might still enter
> > the third stage if the bucket consumption is very aggressive.
> >
> > This patch use (dirty / dirty_buckets) * fp_term to calculate the rate,
> > this formula means that we want to writeback (dirty / dirty_buckets) in
> > 1/fp_term second, fp_term is calculated by above aggressiveness
> > controller, “dirty” is the current dirty sectors, “dirty_buckets” is the
> > current dirty buckets, so (dirty / dirty_buckets) means the average
> > dirty sectors in one bucket, the value is between 0 to 1024 for the
> > default setting,  so this formula basically gives a hint that to reclaim
> > one bucket in 1/fp_term second. By using this semantic, we can have a
> > lower writeback rate when the amount of dirty data is decreasing and
> > overcome the fact that dirty buckets number is always increasing unless
> > GC happens.
> >
> > *Compare to the first patch:
> > *The first patch is trying to write back all the data in 40 seconds,
> > this will result in a very high writeback rate when the amount of dirty
> > data is big, this is mostly true for the large cache devices. The basic
> > problem is that the semantic of this patch is not ideal, because we
> > don’t really need to writeback all dirty data in order to solve this
> > issue, and the instant large increase of the rate is something I feel we
> > should better avoid (I like things to be smoothly changed unless no
> > choice: )).
> >
> > Before I get to this new patch(which I believe should be optimal for me
> > atm), there have been many tuning/testing iterations, eg. I’ve tried to
> > tune the algorithm to writeback ⅓ of the dirty data in a certain amount
> > of seconds, writeback 1/fragment of the dirty data in a certain amount
> > of seconds, writeback all the dirty data only in those error_buckets
> > (error buckets = dirty buckets - 50% of the total buckets) in a certain
> > amount of time. However, those all turn out not to be ideal, only the
> > semantic of the patch makes much sense for me and allows me to control
> > the rate in a more precise way.
> >
> > *Testing data:
> > *I'll provide the visualized testing data in the next couple of days
> > with 1TB NVME devices cache but with HDD as backing device since it's
> > what we mostly used in production env.
> > I have the data for 400GB NVME, let me prepare it and take it for you to
> > review.
> [snipped]
>
> Hi Dongdong,
>
> Thanks for the update and continuous effort on this idea.
>
> Please keep in mind the writeback rate is just a advice rate for the
> writeback throughput, in real workload changing the writeback rate
> number does not change writeback throughput obviously.
>
> Currently I feel this is an interesting and promising idea for your
> patch, but I am not able to say whether it may take effect in real
> workload, so we do need convinced performance data on real workload and
> configuration.
>
> Of course I may also help on the benchmark, but my to-do list is long
> enough and it may take a very long delay time.
>
> Thanks.
>
> Coly Li
