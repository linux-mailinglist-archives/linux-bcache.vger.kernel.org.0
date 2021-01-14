Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800A52F6107
	for <lists+linux-bcache@lfdr.de>; Thu, 14 Jan 2021 13:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbhANMX0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 14 Jan 2021 07:23:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55574 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727315AbhANMXZ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 14 Jan 2021 07:23:25 -0500
Received: from mail-oi1-f197.google.com ([209.85.167.197])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <dongdong.tao@canonical.com>)
        id 1l01eF-0005sX-7l
        for linux-bcache@vger.kernel.org; Thu, 14 Jan 2021 12:22:43 +0000
Received: by mail-oi1-f197.google.com with SMTP id m15so2330147oig.20
        for <linux-bcache@vger.kernel.org>; Thu, 14 Jan 2021 04:22:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=39q23Keb1WqQfItbOZ2v0vZXTP4HRBS3OrsHfOi0b9M=;
        b=O/nyE3Uq4pZUrR/BSWB7Agf/2l0bc5PxbW0dm0QUCNyLs/yoBEeJ9M053YtKW1p+nb
         jndrtWsmOtC/IHlSPNMcOjIPl6KIQs+utc6oSL+mCwxuaT67rsdHiPkYkUYKezKBSmzj
         gf+YUiytDAhg6EjdUAI2g3gHrAjHWGeqkw7yYsABS/4hamzOE6Gd4/zagCZJXnRyw4Nm
         BLHtT5nlRRxXt5fgYaYgAOBhLdn+AirxD83erwrR3ye1enN0ow1CAozrSUSzOr7rvA+l
         G0FNRdkgMN1ZwRpuZzAtUM+cJIjwSPbPQhZpYqUIIiG9hD/B57HcbGSBm8vxCSCfCiN5
         q/sA==
X-Gm-Message-State: AOAM531sSsHT2hTf0cNCzXPjvAKqeQaI3dxkaRaVumdLJEXzJnioltjt
        6FiDLj4J5OWdJU4h6q/eAGw+ZgPmp3xmZANRmAvCEsD6UWXvSVPJAieHM7f7GjPv3/FO5N/dDpI
        rhbUJIDHxw6MFYOY04y4cWk157aR8LbApzw0FHAudioh5mszaTsgrf8szzw==
X-Received: by 2002:a9d:c68:: with SMTP id 95mr4241989otr.328.1610626962137;
        Thu, 14 Jan 2021 04:22:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxutywbfL5mQOwGMDMYC1AMZ1W6A/CP9TcQfVaRhZjDjmX9U711fZXdSjmi/bOJ5gSqA+cpivThhlu9YlFe0pQ=
X-Received: by 2002:a9d:c68:: with SMTP id 95mr4241971otr.328.1610626961835;
 Thu, 14 Jan 2021 04:22:41 -0800 (PST)
MIME-Version: 1.0
References: <20210105030602.14427-1-tdd21151186@gmail.com> <CAJS8hVK-ZCxJt=E3hwR0hmqPYL1T07_WC_nerb-dZodO+DqtDA@mail.gmail.com>
 <1a4b2a68-a7b0-8eb0-e60b-c3cf5a5a9e56@suse.de> <CAJS8hVL2B=RZr8H4jFbz=bX9k_E9ur7kTeue6BJwzm4pwv1+qQ@mail.gmail.com>
 <084276ab-7c74-31be-b957-3b039d7061a1@suse.de> <CAJS8hVKJMZ-9Ep-8v7FALeW5dGMttpQ45=WKJTQmLUKEozhfXg@mail.gmail.com>
 <299ea3ff-4a9c-734e-0ec1-8b8d7480a019@suse.de> <CAJS8hVLSP2mk0Qzsxp=i5_ZgH4QJppPOrr2LU0oEAM-EOMjOyg@mail.gmail.com>
 <CAJS8hVJDaREvpvG4iO+Xs-KQXQKFi7=k29TrG=NXqjyiPpUCZA@mail.gmail.com> <392abd73-c58a-0a34-bd21-1e9adfffc870@suse.de>
In-Reply-To: <392abd73-c58a-0a34-bd21-1e9adfffc870@suse.de>
From:   Dongdong Tao <dongdong.tao@canonical.com>
Date:   Thu, 14 Jan 2021 20:22:30 +0800
Message-ID: <CAJS8hV+6Txqvevj1YBAOrEog4=rWpBUbNFUpDrE1rqzwXuT4yg@mail.gmail.com>
Subject: Re: [PATCH] bcache: consider the fragmentation when update the
 writeback rate
To:     Coly Li <colyli@suse.de>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Gavin Guo <gavin.guo@canonical.com>,
        Gerald Yang <gerald.yang@canonical.com>,
        Trent Lloyd <trent.lloyd@canonical.com>,
        Dominique Poulain <dominique.poulain@canonical.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Benjamin Allot <benjamin.allot@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly,

Why you limit the iodeph to 8 and iops to 150 on cache device?
For cache device the limitation is small. Iosp 150 with 4KB block size,
it means every hour writing (150*4*60*60=2160000KB=) 2GB data. For 35
hours it is only 70GB.


What if the iodepth is 128 or 64, and no iops rate limitation ?
-> There are two reasons why I limit the iodepth and iops rate.
1. If I don't limit them, the dirty cache will be filled up very
quickly within 20 minutes.
     It's almost NVME speed before it reaches the 70
cutoff_writeback_sync, there is no way for any kind of writeback to
stop it from
     filling up due to the huge gap between NVME and HDD in terms of
the throughput,
     I don't think there is anything we can do about it? and it should
only happen in a benchmark world, not should in production.
     The improvement I'm trying to do here is just for normal
production workload ,not for this benchmark scenario really.
     I currently can't see any necessity to test this scenario, please
kindly let me know about this if I'm wrong.

2. The reason that I set iodepth to 8 and iops to 150 is based on the
experience that I observed from production env, mostly ceph,
    ceph-osd has less than 10 thread(default setting) that will send
io to bcache in parallel. But I'm not sure about other applications.
    I agree that we can increase the iodepth to 64 or 128 and it's
doable. But we have to limit the iops, 150 IOPS is a reasonable
workload.
    The most busy ceph-osd that I've seen is about 1000 IOPS, but on
average is still only about 600.
    I can set the IOPS to a higher value like 600 and the iodepth to
128 to perform the later test if it make sense to you?

Lastly, please allow me to clarify more about the production issue
that this patch is trying to address:

In the production env that hit this issue, it usually takes a very
long time (many take days) for the cache_available_percent to drop to
30, and the dirty data is mostly staying at a very low level (around
10 percent), which means that the bcache isn't being stressed very
hard most of the time.
 There is no intention to save the cutoff_writeback_sync when the
bcache is being stressed without limitation, hope above make sense :)

By the way, my colleague and I are trying to gathering some production
bcache stats, I hope we can give you the performance number before and
after applying the patch.

Thanks,
Dongdong





On Thu, Jan 14, 2021 at 6:05 PM Coly Li <colyli@suse.de> wrote:
>
> On 1/14/21 12:45 PM, Dongdong Tao wrote:
> > Hi Coly,
> >
> > I've got the testing data for multiple threads with larger IO depth.
> >
>
> Hi Dongdong,
>
> Thanks for the testing number.
>
> > *Here is the testing steps:
> > *1. make-bcache -B <> -C <> --writeback
> >
> > 2. Open two tabs, start different fio task in them at the same time.
> > Tab1 run below fio command:
> > sudo fio --name=random-writers --filename=/dev/bcache0 --ioengine=libaio
> > --iodepth=32 --rw=randrw --blocksize=64k,8k  --direct=1 --runtime=24000
> >
> > Tab2 run below fio command:
> > sudo fio --name=random-writers2 --filename=/dev/bcache0
> > --ioengine=libaio --iodepth=8 --rw=randwrite --bs=4k --rate_iops=150
> > --direct=1 --write_lat_log=rw --log_avg_msec=20
> >
>
>
> Why you limit the iodep to 8 and iops to 150 on cache device?
> For cache device the limitation is small. Iosp 150 with 4KB block size,
> it means every hour writing (150*4*60*60=2160000KB=) 2GB data. For 35
> hours it is only 70GB.
>
>
> What if the iodeps is 128 or 64, and no iops rate limitation ?
>
>
> > Note
> > - Tab1 fio will run for 24000 seconds, which is the one to cause the
> > fragmentation and made the cache_available_percent drops to under 40.
> > - Tab2 fio is the one that I'm capturing the latency and I have let it
> > run for about 35 hours, which is long enough to allow the
> > cache_available_percent drops under 30.
> > - This testing method utilized fio benchmark with larger read block
> > size/small write block size to cause the high fragmentation, However in
> > a real production env, there could be
> >    various reasons or a combination of various reasons to cause the high
> > fragmentation,  but I believe it should be ok to use any method to cause
> > the fragmentation to verify if
> >    bcache with this patch is responding better than the master in this
> > situation.
> >
> > *Below is the testing result:*
> >
> > The total run time is about 35 hours, the latency points in the charts
> > for each run are 1.5 million
> >
> > Master:
> > fio-lat-mater.png
> >
> > Master + patch:
> > fio-lat-patch.png
> > Combine them together:
> > fio-lat-mix.png
> >
> > Now we can see the master is even worse when we increase the iodepth,
> > which makes sense since the backing HDD is being stressed more hardly.
> >
> > *Below are the cache stats changing during the run:*
> > Master:
> > bcache-stats-master.png
> >
> > Master + the patch:
> > bcache-stats-patch.png
> >
> > That's all the testing done with 400GB NVME with 512B block size.
> >
> > Coly, do you want me to continue the same testing on 1TB nvme with
> > different block size ?
> > or is it ok to skip the 1TB testing and continue the test with 400GB
> > NVME but with different block size?
> > feel free to let me know any other test scenarios that we should cover
> > here.
>
> Yes please, more testing is desired for performance improvement. So far
> I don't see performance number for real high work load yet.
>
> Thanks.
>
> Coly Li
>
