Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9552F5A11
	for <lists+linux-bcache@lfdr.de>; Thu, 14 Jan 2021 05:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbhANE4o convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-bcache@lfdr.de>); Wed, 13 Jan 2021 23:56:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38589 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbhANE4n (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 13 Jan 2021 23:56:43 -0500
Received: from mail-oi1-f197.google.com ([209.85.167.197])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <dongdong.tao@canonical.com>)
        id 1kzufx-00075Z-Sd
        for linux-bcache@vger.kernel.org; Thu, 14 Jan 2021 04:56:02 +0000
Received: by mail-oi1-f197.google.com with SMTP id l23so1903751oii.3
        for <linux-bcache@vger.kernel.org>; Wed, 13 Jan 2021 20:56:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=t2SjC1ScZoHjVgolMTbzRzJ3tt9MlLt5inN2hVVtp60=;
        b=t6fp8H8LrA5stkdNh06F9TCrYPz0HktaLfbW/x8uDG6Cj5gwWpN57jkhKsjrBnJJN8
         KLJ8mXIfsrKUUulgaF6DfZJ7N7vay5359e9UpP+EPoTZtA5e3jV5oGGHx6J3F32K07sJ
         DhdUk0Zde7fBo1AbUCWA0imgyeY+JK05fd0CL7+zD2re//4KaVKYYKw/HrMicRAgW7Re
         uGVGOUkGd7R8P9xkwh43cKlKSUwo7UiFGsFSJoncKcLEhSF8av1yKGLd+NgeAYGS6Q5C
         vbUuyhDSixIu44doE9vDWMiK3mUQiIhovJVZDR7w3B3QFonutIw2gB107gWlcuhpcEtg
         UfoQ==
X-Gm-Message-State: AOAM531pQKeG8RA6mYo1Rur/R2psgTnQlQX4HmhAEunY7tgR1u5fZzl9
        e3Pl0v0L0b807/JI9KVNyKsY8eHFFzbgyKyVtCGH+6stABUf4F7ShLbwsojyF32jv+rhVyFafyD
        SXg5pxcmuw1EZ0Drvr+2bo8f1aKUH1L8BUdw0ZGGDAMkKvKTgBLu9lCexmg==
X-Received: by 2002:a4a:a9c9:: with SMTP id h9mr3546275oon.93.1610600160659;
        Wed, 13 Jan 2021 20:56:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzbKQZDjiPdxEsO62174esLu1M8NBbyZalAwrLKkbgVdGW4NzU0uQaj4n/tPKNyV2KWpiG6BbqMUAuFlqVpytg=
X-Received: by 2002:a4a:a9c9:: with SMTP id h9mr3546265oon.93.1610600160273;
 Wed, 13 Jan 2021 20:56:00 -0800 (PST)
MIME-Version: 1.0
References: <20210105030602.14427-1-tdd21151186@gmail.com> <CAJS8hVK-ZCxJt=E3hwR0hmqPYL1T07_WC_nerb-dZodO+DqtDA@mail.gmail.com>
 <1a4b2a68-a7b0-8eb0-e60b-c3cf5a5a9e56@suse.de> <CAJS8hVL2B=RZr8H4jFbz=bX9k_E9ur7kTeue6BJwzm4pwv1+qQ@mail.gmail.com>
 <084276ab-7c74-31be-b957-3b039d7061a1@suse.de> <CAJS8hVKJMZ-9Ep-8v7FALeW5dGMttpQ45=WKJTQmLUKEozhfXg@mail.gmail.com>
 <299ea3ff-4a9c-734e-0ec1-8b8d7480a019@suse.de> <CAJS8hVLSP2mk0Qzsxp=i5_ZgH4QJppPOrr2LU0oEAM-EOMjOyg@mail.gmail.com>
In-Reply-To: <CAJS8hVLSP2mk0Qzsxp=i5_ZgH4QJppPOrr2LU0oEAM-EOMjOyg@mail.gmail.com>
From:   Dongdong Tao <dongdong.tao@canonical.com>
Date:   Thu, 14 Jan 2021 12:55:49 +0800
Message-ID: <CAJS8hV+jwVcJWXpmFZgi0E9xd8eRHvUu6eopyne0om-7LQg+2A@mail.gmail.com>
Subject: Re: [PATCH] bcache: consider the fragmentation when update the
 writeback rate
To:     "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>
Cc:     open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

[Share the google doc here to avoid SPAM detection]

Here is the new testing result with multiple threads fio testing:

https://docs.google.com/document/d/1AmbIEa_2MhB9bqhC3rfga9tp7n9YX9PLn0jSUxscVW0/edit?usp=sharing


On Fri, Jan 8, 2021 at 4:47 PM Dongdong Tao <dongdong.tao@canonical.com> wrote:
>
> Yeap, I will scale the testing for multiple threads with larger IO
> depth, thanks for the suggestion!
>
> On Fri, Jan 8, 2021 at 4:40 PM Coly Li <colyli@suse.de> wrote:
> >
> > On 1/8/21 4:30 PM, Dongdong Tao wrote:
> > > Hi Coly,
> > >
> > > They are captured with the same time length, the meaning of the
> > > timestamp and the time unit on the x-axis are different.
> > > (Sorry, I should have clarified this right after the chart)
> > >
> > > For the latency chart:
> > > The timestamp is the relative time since the beginning of the
> > > benchmark, so the start timestamp is 0 and the unit is based on
> > > millisecond
> > >
> > > For the dirty data and cache available percent chart:
> > > The timestamp is the UNIX timestamp, the time unit is based on second,
> > > I capture the stats every 5 seconds with the below script:
> > > ---
> > > #!/bin/sh
> > > while true; do echo "`date +%s`, `cat
> > > /sys/block/bcache0/bcache/dirty_data`, `cat
> > > /sys/block/bcache0/bcache/cache/cache_available_percent`, `cat
> > > /sys/block/bcache0/bcache/writeback_rate`" >> $1; sleep 5; done;
> > > ---
> > >
> > > Unfortunately, I can't easily make them using the same timestamp, but
> > > I guess I can try to convert the UNIX timestamp to the relative time
> > > like the first one.
> > > But If we ignore the value of the X-axis,  we can still roughly
> > > compare them by using the length of the X-axis since they have the
> > > same time length,
> > > and we can see that the Master's write start hitting the backing
> > > device when the cache_available_percent dropped to around 30.
> >
> > Copied, thanks for the explanation. The chart for single thread with io
> > depth 1 is convinced IMHO :-)
> >
> > One more question, the benchmark is about a single I/O thread with io
> > depth 1, which is not typical condition for real workload. Do you have
> > plan to test the latency and IOPS for multiple threads with larger I/O
> > depth ?
> >
> >
> > Thanks.
> >
> >
> > Coly Li
> >
> >
> > >
> > > On Fri, Jan 8, 2021 at 12:06 PM Coly Li <colyli@suse.de> wrote:
> > >>
> > >> On 1/7/21 10:55 PM, Dongdong Tao wrote:
> > >>> Hi Coly,
> > >>>
> > >>>
> > >>> Thanks for the reminder, I understand that the rate is only a hint of
> > >>> the throughput, it’s a value to calculate the sleep time between each
> > >>> round of keys writeback, the higher the rate, the shorter the sleep
> > >>> time, most of the time this means the more dirty keys it can writeback
> > >>> in a certain amount of time before the hard disk running out of speed.
> > >>>
> > >>>
> > >>> Here is the testing data that run on a 400GB NVME + 1TB NVME HDD
> > >>>
> > >>
> > >> Hi Dongdong,
> > >>
> > >> Nice charts :-)
> > >>
> > >>> Steps:
> > >>>
> > >>>  1.
> > >>>
> > >>>     make-bcache -B <HDD> -C <NVME> --writeback
> > >>>
> > >>>  2.
> > >>>
> > >>>     sudo fio --name=random-writers --filename=/dev/bcache0
> > >>>     --ioengine=libaio --iodepth=1 --rw=randrw --blocksize=64k,8k
> > >>>     --direct=1 --numjobs=1  --write_lat_log=mix --log_avg_msec=10
> > >>>> The fio benchmark commands ran for about 20 hours.
> > >>>
> > >>
> > >> The time lengths of first 3 charts are 7.000e+7, rested are 1.60930e+9.
> > >> I guess the time length of the I/O latency chart is 1/100 of the rested.
> > >>
> > >> Can you also post the latency charts for 1.60930e+9 seconds? Then I can
> > >> compare the latency with dirty data and available cache charts.
> > >>
> > >>
> > >> Thanks.
> > >>
> > >>
> > >> Coly Li
> > >>
> > >>
> > >>
> > >>
> > >>
> > >>>
> > >>> Let’s have a look at the write latency first:
> > >>>
> > >>> Master:
> > >>>
> > >>>
> > >>>
> > >>> Master+the patch:
> > >>>
> > >>> Combine them together:
> > >>>
> > >>> Again, the latency (y-axis) is based on nano-second, x-axis is the
> > >>> timestamp based on milli-second,  as we can see the master latency is
> > >>> obviously much higher than the one with my patch when the master bcache
> > >>> hit the cutoff writeback sync, the master isn’t going to get out of this
> > >>> cutoff writeback sync situation, This graph showed it already stuck at
> > >>> the cutoff writeback sync for about 4 hours before I finish the testing,
> > >>> it may still needs to stuck for days before it can get out this
> > >>> situation itself.
> > >>>
> > >>>
> > >>> Note that there are 1 million points for each , red represents master,
> > >>> green represents mater+my patch.  Most of them are overlapped with each
> > >>> other, so it may look like this graph has more red points then green
> > >>> after it hitting the cutoff, but simply it’s because the latency has
> > >>> scaled to a bigger range which represents the HDD latency.
> > >>>
> > >>>
> > >>>
> > >>> Let’s also have a look at the bcache’s cache available percent and dirty
> > >>> data percent.
> > >>>
> > >>> Master:
> > >>>
> > >>> Master+this patch:
> > >>>
> > >>> As you can see, this patch can avoid it hitting the cutoff writeback sync.
> > >>>
> > >>>
> > >>> As to say the improvement for this patch against the first one, let’s
> > >>> take a look at the writeback rate changing during the run.
> > >>>
> > >>> patch V1:
> > >>>
> > >>>
> > >>>
> > >>> Patch V2:
> > >>>
> > >>>
> > >>> The Y-axis is the value of rate, the V1 is very aggressive as it jumps
> > >>> instantly from a minimum 8 to around 10 million. And the patch V2 can
> > >>> control the rate under 5000 during the run, and after the first round of
> > >>> writeback, it can stay even under 2500, so this proves we don’t need to
> > >>> be as aggressive as V1 to get out of the high fragment situation which
> > >>> eventually causes all writes hitting the backing device. This looks very
> > >>> reasonable for me now.
> > >>>
> > >>> Note that the fio command that I used is consuming the bucket quite
> > >>> aggressively, so it had to hit the third stage which has the highest
> > >>> aggressiveness, but I believe this is not true in a real production env,
> > >>> real production env won’t consume buckets that aggressively, so I expect
> > >>> stage 3 may not very often be needed to hit.
> > >>>
> > >>>
> > >>> As discussed, I'll run multiple block size testing on at least 1TB NVME
> > >>> device later.
> > >>> But it might take some time.
> > >>>
> > >>>
> > >>> Regards,
> > >>> Dongdong
> > >>>
> > >>> On Tue, Jan 5, 2021 at 12:33 PM Coly Li <colyli@suse.de
> > >>> <mailto:colyli@suse.de>> wrote:
> > >>>
> > >>>     On 1/5/21 11:44 AM, Dongdong Tao wrote:
> > >>>     > Hey Coly,
> > >>>     >
> > >>>     > This is the second version of the patch, please allow me to explain a
> > >>>     > bit for this patch:
> > >>>     >
> > >>>     > We accelerate the rate in 3 stages with different aggressiveness, the
> > >>>     > first stage starts when dirty buckets percent reach above
> > >>>     > BCH_WRITEBACK_FRAGMENT_THRESHOLD_LOW(50), the second is
> > >>>     > BCH_WRITEBACK_FRAGMENT_THRESHOLD_MID(57) and the third is
> > >>>     > BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH(64). By default the first stage
> > >>>     > tries to writeback the amount of dirty data in one bucket (on average)
> > >>>     > in (1 / (dirty_buckets_percent - 50)) second, the second stage
> > >>>     tries to
> > >>>     > writeback the amount of dirty data in one bucket in (1 /
> > >>>     > (dirty_buckets_percent - 57)) * 200 millisecond. The third stage tries
> > >>>     > to writeback the amount of dirty data in one bucket in (1 /
> > >>>     > (dirty_buckets_percent - 64)) * 20 millisecond.
> > >>>     >
> > >>>     > As we can see, there are two writeback aggressiveness increasing
> > >>>     > strategies, one strategy is with the increasing of the stage, the
> > >>>     first
> > >>>     > stage is the easy-going phase whose initial rate is trying to
> > >>>     write back
> > >>>     > dirty data of one bucket in 1 second, the second stage is a bit more
> > >>>     > aggressive, the initial rate tries to writeback the dirty data of one
> > >>>     > bucket in 200 ms, the last stage is even more, whose initial rate
> > >>>     tries
> > >>>     > to writeback the dirty data of one bucket in 20 ms. This makes sense,
> > >>>     > one reason is that if the preceding stage couldn’t get the
> > >>>     fragmentation
> > >>>     > to a fine stage, then the next stage should increase the
> > >>>     aggressiveness
> > >>>     > properly, also it is because the later stage is closer to the
> > >>>     > bch_cutoff_writeback_sync. Another aggressiveness increasing
> > >>>     strategy is
> > >>>     > with the increasing of dirty bucket percent within each stage, the
> > >>>     first
> > >>>     > strategy controls the initial writeback rate of each stage, while this
> > >>>     > one increases the rate based on the initial rate, which is
> > >>>     initial_rate
> > >>>     > * (dirty bucket percent - BCH_WRITEBACK_FRAGMENT_THRESHOLD_X).
> > >>>     >
> > >>>     > The initial rate can be controlled by 3 parameters
> > >>>     > writeback_rate_fp_term_low, writeback_rate_fp_term_mid,
> > >>>     > writeback_rate_fp_term_high, they are default 1, 5, 50, users can
> > >>>     adjust
> > >>>     > them based on their needs.
> > >>>     >
> > >>>     > The reason that I choose 50, 57, 64 as the threshold value is because
> > >>>     > the GC must be triggered at least once during each stage due to the
> > >>>     > “sectors_to_gc” being set to 1/16 (6.25 %) of the total cache
> > >>>     size. So,
> > >>>     > the hope is that the first and second stage can get us back to good
> > >>>     > shape in most situations by smoothly writing back the dirty data
> > >>>     without
> > >>>     > giving too much stress to the backing devices, but it might still
> > >>>     enter
> > >>>     > the third stage if the bucket consumption is very aggressive.
> > >>>     >
> > >>>     > This patch use (dirty / dirty_buckets) * fp_term to calculate the
> > >>>     rate,
> > >>>     > this formula means that we want to writeback (dirty /
> > >>>     dirty_buckets) in
> > >>>     > 1/fp_term second, fp_term is calculated by above aggressiveness
> > >>>     > controller, “dirty” is the current dirty sectors, “dirty_buckets”
> > >>>     is the
> > >>>     > current dirty buckets, so (dirty / dirty_buckets) means the average
> > >>>     > dirty sectors in one bucket, the value is between 0 to 1024 for the
> > >>>     > default setting,  so this formula basically gives a hint that to
> > >>>     reclaim
> > >>>     > one bucket in 1/fp_term second. By using this semantic, we can have a
> > >>>     > lower writeback rate when the amount of dirty data is decreasing and
> > >>>     > overcome the fact that dirty buckets number is always increasing
> > >>>     unless
> > >>>     > GC happens.
> > >>>     >
> > >>>     > *Compare to the first patch:
> > >>>     > *The first patch is trying to write back all the data in 40 seconds,
> > >>>     > this will result in a very high writeback rate when the amount of
> > >>>     dirty
> > >>>     > data is big, this is mostly true for the large cache devices. The
> > >>>     basic
> > >>>     > problem is that the semantic of this patch is not ideal, because we
> > >>>     > don’t really need to writeback all dirty data in order to solve this
> > >>>     > issue, and the instant large increase of the rate is something I
> > >>>     feel we
> > >>>     > should better avoid (I like things to be smoothly changed unless no
> > >>>     > choice: )).
> > >>>     >
> > >>>     > Before I get to this new patch(which I believe should be optimal
> > >>>     for me
> > >>>     > atm), there have been many tuning/testing iterations, eg. I’ve
> > >>>     tried to
> > >>>     > tune the algorithm to writeback ⅓ of the dirty data in a certain
> > >>>     amount
> > >>>     > of seconds, writeback 1/fragment of the dirty data in a certain amount
> > >>>     > of seconds, writeback all the dirty data only in those error_buckets
> > >>>     > (error buckets = dirty buckets - 50% of the total buckets) in a
> > >>>     certain
> > >>>     > amount of time. However, those all turn out not to be ideal, only the
> > >>>     > semantic of the patch makes much sense for me and allows me to control
> > >>>     > the rate in a more precise way.
> > >>>     >
> > >>>     > *Testing data:
> > >>>     > *I'll provide the visualized testing data in the next couple of days
> > >>>     > with 1TB NVME devices cache but with HDD as backing device since it's
> > >>>     > what we mostly used in production env.
> > >>>     > I have the data for 400GB NVME, let me prepare it and take it for
> > >>>     you to
> > >>>     > review.
> > >>>     [snipped]
> > >>>
> > >>>     Hi Dongdong,
> > >>>
> > >>>     Thanks for the update and continuous effort on this idea.
> > >>>
> > >>>     Please keep in mind the writeback rate is just a advice rate for the
> > >>>     writeback throughput, in real workload changing the writeback rate
> > >>>     number does not change writeback throughput obviously.
> > >>>
> > >>>     Currently I feel this is an interesting and promising idea for your
> > >>>     patch, but I am not able to say whether it may take effect in real
> > >>>     workload, so we do need convinced performance data on real workload and
> > >>>     configuration.
> > >>>
> > >>>     Of course I may also help on the benchmark, but my to-do list is long
> > >>>     enough and it may take a very long delay time.
> > >>>
> > >>>     Thanks.
> > >>>
> > >>>     Coly Li
> > >>>
> > >>
> >
