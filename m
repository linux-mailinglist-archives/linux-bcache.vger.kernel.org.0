Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7761C2F64C2
	for <lists+linux-bcache@lfdr.de>; Thu, 14 Jan 2021 16:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbhANPgQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 14 Jan 2021 10:36:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33529 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbhANPgQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 14 Jan 2021 10:36:16 -0500
Received: from mail-ot1-f70.google.com ([209.85.210.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <dongdong.tao@canonical.com>)
        id 1l04ep-0003hX-U6
        for linux-bcache@vger.kernel.org; Thu, 14 Jan 2021 15:35:32 +0000
Received: by mail-ot1-f70.google.com with SMTP id q8so1778259otk.6
        for <linux-bcache@vger.kernel.org>; Thu, 14 Jan 2021 07:35:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qYot9zCDucWco4V0yid0zIuAnNyVpGykxmK/k1V5cpE=;
        b=s+3x1/o/qV9MXqtOt8eR4OMPNU+IQgQRcM84ZOXPipkwxPthRp6+YagEBzePDJlkrw
         3KcAfr8mdf+2RshpHoIR2RjsmUcOCoz9yInW3GrhVE84/xPp/QKxYWTFEEAUQWqN6en1
         gf83rAYD+hE/9uK8FIc92n/wzj8uVsyKfhMuQEeMvtH9dFNKGEzd5wdRD8kqeDPI9qph
         jNpSrIdF7Z0Z9VxteeMyVsziku3w5IZb2XKWqqJw4XYufJrPe96rIDNly+o+j6sIEfux
         Kklpmm18wvrXTdncr8YKnAaVB1iWffsY1JAAeH9gP8VtVB+H8n768jjIhV/pEUVjwRSo
         f1lg==
X-Gm-Message-State: AOAM531b+S2w+VELirG4nDwp/0eUXWtvLDgrWGgxsvqhhhcUWcaoSdhw
        Wd2abt0e7Y8u+k9qh8m9NhHd6sUk3eXbZv0nfoY1Bu2KDOB6bp9Q8ZIITfP9R8Aw/rex5eMLVuV
        OCJbz5Fs5GsP+iNPkAOtAa4w3Gi1+QQoCaV0KFOi2WfNQoCkP9frwdaafWA==
X-Received: by 2002:a9d:c68:: with SMTP id 95mr4789382otr.328.1610638530801;
        Thu, 14 Jan 2021 07:35:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxANdpRp9+6+4Dn7V3m8sTpXcMJ/sjragibUIEDUssykDLszLMj+AByozc8E489CfriOTjD+EgS6YH2U0lLRbw=
X-Received: by 2002:a9d:c68:: with SMTP id 95mr4789283otr.328.1610638529053;
 Thu, 14 Jan 2021 07:35:29 -0800 (PST)
MIME-Version: 1.0
References: <20210105030602.14427-1-tdd21151186@gmail.com> <CAJS8hVK-ZCxJt=E3hwR0hmqPYL1T07_WC_nerb-dZodO+DqtDA@mail.gmail.com>
 <1a4b2a68-a7b0-8eb0-e60b-c3cf5a5a9e56@suse.de> <CAJS8hVL2B=RZr8H4jFbz=bX9k_E9ur7kTeue6BJwzm4pwv1+qQ@mail.gmail.com>
 <084276ab-7c74-31be-b957-3b039d7061a1@suse.de> <CAJS8hVKJMZ-9Ep-8v7FALeW5dGMttpQ45=WKJTQmLUKEozhfXg@mail.gmail.com>
 <299ea3ff-4a9c-734e-0ec1-8b8d7480a019@suse.de> <CAJS8hVLSP2mk0Qzsxp=i5_ZgH4QJppPOrr2LU0oEAM-EOMjOyg@mail.gmail.com>
 <CAJS8hVJDaREvpvG4iO+Xs-KQXQKFi7=k29TrG=NXqjyiPpUCZA@mail.gmail.com>
 <392abd73-c58a-0a34-bd21-1e9adfffc870@suse.de> <CAJS8hV+6Txqvevj1YBAOrEog4=rWpBUbNFUpDrE1rqzwXuT4yg@mail.gmail.com>
 <3ca15755-9ad2-1d57-b86a-fb659f701cfb@suse.de>
In-Reply-To: <3ca15755-9ad2-1d57-b86a-fb659f701cfb@suse.de>
From:   Dongdong Tao <dongdong.tao@canonical.com>
Date:   Thu, 14 Jan 2021 23:35:16 +0800
Message-ID: <CAJS8hVLthLcaSLt3bZ6VGNqHZZhW6ou4zLqg_NJoKhgW3V90Sw@mail.gmail.com>
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

Apologies for any confusion that I might have caused, and thanks a lot
for your patience and your help !

On Thu, Jan 14, 2021 at 9:31 PM Coly Li <colyli@suse.de> wrote:
>
> On 1/14/21 8:22 PM, Dongdong Tao wrote:
> > Hi Coly,
> >
> > Why you limit the iodeph to 8 and iops to 150 on cache device?
> > For cache device the limitation is small. Iosp 150 with 4KB block size,
> > it means every hour writing (150*4*60*60=2160000KB=) 2GB data. For 35
> > hours it is only 70GB.
> >
> >
> > What if the iodepth is 128 or 64, and no iops rate limitation ?
> > -> There are two reasons why I limit the iodepth and iops rate.
> > 1. If I don't limit them, the dirty cache will be filled up very
> > quickly within 20 minutes.
> >      It's almost NVME speed before it reaches the 70
> > cutoff_writeback_sync, there is no way for any kind of writeback to
> > stop it from
> >      filling up due to the huge gap between NVME and HDD in terms of
> > the throughput,
> >      I don't think there is anything we can do about it? and it should
> > only happen in a benchmark world, not should in production.
> >      The improvement I'm trying to do here is just for normal
> > production workload ,not for this benchmark scenario really.
> >      I currently can't see any necessity to test this scenario, please
> > kindly let me know about this if I'm wrong.
> >
> > 2. The reason that I set iodepth to 8 and iops to 150 is based on the
> > experience that I observed from production env, mostly ceph,
> >     ceph-osd has less than 10 thread(default setting) that will send
> > io to bcache in parallel. But I'm not sure about other applications.
> >     I agree that we can increase the iodepth to 64 or 128 and it's
> > doable. But we have to limit the iops, 150 IOPS is a reasonable
> > workload.
> >     The most busy ceph-osd that I've seen is about 1000 IOPS, but on
> > average is still only about 600.
> >     I can set the IOPS to a higher value like 600 and the iodepth to
> > 128 to perform the later test if it make sense to you?
> >
>
> OK, now I know the reason with the extra information. Since the cache
> device is filled up within 20 minutes, it is unnecessary to do the
> faster testing on your side. Let me do it later on my hardware.
>
>
> > Lastly, please allow me to clarify more about the production issue
> > that this patch is trying to address:
> >
> > In the production env that hit this issue, it usually takes a very
> > long time (many take days) for the cache_available_percent to drop to
> > 30, and the dirty data is mostly staying at a very low level (around
> > 10 percent), which means that the bcache isn't being stressed very
> > hard most of the time.
> >  There is no intention to save the cutoff_writeback_sync when the
> > bcache is being stressed without limitation, hope above make sense :)
> >
>
> Yes you explained clearly previously. What I worried was whether a
> faster writeback may interfere throughput and latency of regular I/O
> regular I/Os.
>
> From your current testing data it looks find with me.
>
>
> > By the way, my colleague and I are trying to gathering some production
> > bcache stats, I hope we can give you the performance number before and
> > after applying the patch.
>
> Yes that will be great.
>
> And could you please gather all current data chats into a single email,
> and reference it in your patch via lore ? Then for people don't
> subscribe linux-bcache mailing list, they may find all the posted
> performance data from you patch.
>

Sounds good, I'll update the patch comment with reference data.
But it seems like the linux mailing list doesn't accept chart ?
(always been detected as SPAM)
But, I can't be sure, I'll try to send it again, but if not, I'll put
all those data into a google doc.

> In general your testing data is convinced IMHO, and I will add your
> updated patch for 5.12 merge window.
>
Thank you Coly, that's great !!!

>
> Thanks.
>
> Coly Li
>
>
> >
> >
> > On Thu, Jan 14, 2021 at 6:05 PM Coly Li <colyli@suse.de> wrote:
> >>
> >> On 1/14/21 12:45 PM, Dongdong Tao wrote:
> >>> Hi Coly,
> >>>
> >>> I've got the testing data for multiple threads with larger IO depth.
> >>>
> >>
> >> Hi Dongdong,
> >>
> >> Thanks for the testing number.
> >>
> >>> *Here is the testing steps:
> >>> *1. make-bcache -B <> -C <> --writeback
> >>>
> >>> 2. Open two tabs, start different fio task in them at the same time.
> >>> Tab1 run below fio command:
> >>> sudo fio --name=random-writers --filename=/dev/bcache0 --ioengine=libaio
> >>> --iodepth=32 --rw=randrw --blocksize=64k,8k  --direct=1 --runtime=24000
> >>>
> >>> Tab2 run below fio command:
> >>> sudo fio --name=random-writers2 --filename=/dev/bcache0
> >>> --ioengine=libaio --iodepth=8 --rw=randwrite --bs=4k --rate_iops=150
> >>> --direct=1 --write_lat_log=rw --log_avg_msec=20
> >>>
> >>
> >>
> >> Why you limit the iodep to 8 and iops to 150 on cache device?
> >> For cache device the limitation is small. Iosp 150 with 4KB block size,
> >> it means every hour writing (150*4*60*60=2160000KB=) 2GB data. For 35
> >> hours it is only 70GB.
> >>
> >>
> >> What if the iodeps is 128 or 64, and no iops rate limitation ?
> >>
> >>
> >>> Note
> >>> - Tab1 fio will run for 24000 seconds, which is the one to cause the
> >>> fragmentation and made the cache_available_percent drops to under 40.
> >>> - Tab2 fio is the one that I'm capturing the latency and I have let it
> >>> run for about 35 hours, which is long enough to allow the
> >>> cache_available_percent drops under 30.
> >>> - This testing method utilized fio benchmark with larger read block
> >>> size/small write block size to cause the high fragmentation, However in
> >>> a real production env, there could be
> >>>    various reasons or a combination of various reasons to cause the high
> >>> fragmentation,  but I believe it should be ok to use any method to cause
> >>> the fragmentation to verify if
> >>>    bcache with this patch is responding better than the master in this
> >>> situation.
> >>>
> >>> *Below is the testing result:*
> >>>
> >>> The total run time is about 35 hours, the latency points in the charts
> >>> for each run are 1.5 million
> >>>
> >>> Master:
> >>> fio-lat-mater.png
> >>>
> >>> Master + patch:
> >>> fio-lat-patch.png
> >>> Combine them together:
> >>> fio-lat-mix.png
> >>>
> >>> Now we can see the master is even worse when we increase the iodepth,
> >>> which makes sense since the backing HDD is being stressed more hardly.
> >>>
> >>> *Below are the cache stats changing during the run:*
> >>> Master:
> >>> bcache-stats-master.png
> >>>
> >>> Master + the patch:
> >>> bcache-stats-patch.png
> >>>
> >>> That's all the testing done with 400GB NVME with 512B block size.
> >>>
> >>> Coly, do you want me to continue the same testing on 1TB nvme with
> >>> different block size ?
> >>> or is it ok to skip the 1TB testing and continue the test with 400GB
> >>> NVME but with different block size?
> >>> feel free to let me know any other test scenarios that we should cover
> >>> here.
> >>
> >> Yes please, more testing is desired for performance improvement. So far
> >> I don't see performance number for real high work load yet.
> >>
> >> Thanks.
> >>
> >> Coly Li
> >>
>
