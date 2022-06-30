Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0728956135D
	for <lists+linux-bcache@lfdr.de>; Thu, 30 Jun 2022 09:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbiF3Hju (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 30 Jun 2022 03:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbiF3Hjt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 30 Jun 2022 03:39:49 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2684C3334B
        for <linux-bcache@vger.kernel.org>; Thu, 30 Jun 2022 00:39:48 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id x3so32257873lfd.2
        for <linux-bcache@vger.kernel.org>; Thu, 30 Jun 2022 00:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0ScasB1UMxuWIotu/8C1MUnQdLlZhNHs9MdxOHAaOdw=;
        b=X/oNhWv/Jrx/ypWwko3+oKAiReq+73LvIAe750v1jPsPhr15f6iiyOl6zSN/537aqb
         CUOvL4j48eMIte2DrxLHouD6pvj+nRRwn9+bP8o7mJLeRKjsnXymvRNIxcJ/UX706Rsf
         vNP+jWaFrcxA32DL8OBGtQepDpvODWHCba8L86kgt9wW//SIhfl8NQVszXKeMLtNAB5z
         w7sYcsArFH7QbA/L369+v/B2P8AlsBOR+UF86NqDZCoEagZsfD1vIcJNjd5jhZ595o8W
         aHDivCAgZPEM8jOlYiQFn3h5JYfJ5x6t3mLJG6Ktdm0nsTJ5lvFWbw6vcGpd9IhDPtVQ
         1Rrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0ScasB1UMxuWIotu/8C1MUnQdLlZhNHs9MdxOHAaOdw=;
        b=IGKT7J4oIe5y9RjmO7VMac2D+0DPZMjcIZ7HrhVFUORLpKjXb5MDQq9KUvDUoU0APG
         E/q374BxC/8BvBt1HQbysacUn/HfwrKT4wtx6F0gxyNJeDyYL2Dr7/rOk7uSi8BXEv7I
         LzMpQXoIRI++lNacHyppKXWLfI2E2JxU0U6Cpv45A9bUXhA429djfLv8vGvP8/wunggv
         TOGJLOhV2L53FP0hL5Yh2i1KtI/D43yUtIlswX2dHhKD8pYj2zGUYtU3lldW92PwJhxT
         YBaLclG5CNtsCUllK8Hl49sApUkONAOogjxBEzp4pGg2jKXtcasEvzv2mPwLqqg3BfhZ
         vXag==
X-Gm-Message-State: AJIora/+ZyOk3VzXGOXktyQ6SYdZAlJ+ZFHi0D9oTGgdk6yfec0NIBLF
        +teE4nsqOSUp5ixzztfyobYdXt0JSX6W2nfdjE5zrGNaupc=
X-Google-Smtp-Source: AGRyM1u4IYFKBjOWWt7rx4ox0aPxCY3g2phtT0jllLe8jjr+nkGCKfTvhjJo0Tg/xi5mF4zlr8uLF3IV1bYvyVtbZow=
X-Received: by 2002:a05:6512:1104:b0:481:d6b:450 with SMTP id
 l4-20020a056512110400b004810d6b0450mr4518615lfg.346.1656574786407; Thu, 30
 Jun 2022 00:39:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAC6jXv0FoE60HEuc7tDMXEA27hkoMkZm5d6gt4NCRkAh2w3WvA@mail.gmail.com>
 <8C0D66FE-FF1D-469D-A209-10E95F79D2FA@suse.de> <CAC6jXv18FhR9M9ckSrYOe+vzhQe022VfPb4dWaY7AnSn1M7qfg@mail.gmail.com>
 <CAC6jXv0yOZ98XqG=quDcONuZ9ggqK4doM8EzVTc=Sk1m-H=_Xw@mail.gmail.com>
 <F1BAF641-4818-4574-8467-3CD0AC3E8DE7@suse.de> <CAC6jXv2u_0s-hvj4J4gurfoxgKNHFcHYq9F8cfcf-s6oG+pU+Q@mail.gmail.com>
 <E5629229-E51D-470F-9A6E-53434EF9F7FF@suse.de>
In-Reply-To: <E5629229-E51D-470F-9A6E-53434EF9F7FF@suse.de>
From:   Nikhil Kshirsagar <nkshirsagar@gmail.com>
Date:   Thu, 30 Jun 2022 13:09:34 +0530
Message-ID: <CAC6jXv1mHjUO8OZ8W0LJkH-z8dQ=hZkk9Au8NVTFLfSj2J88zg@mail.gmail.com>
Subject: Re: bcache I/O performance tests on 5.15.0-40-generic
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Yes, I understand, but if you see the graphs, for a 12gb random write
IO (with a 15gb SSD, so enough cache in theory for entire write),
bcache gets speeds very close to SLOW DISK! (3MB/s consistently, while
dmcache gets 400mb/s consistently except the first run where it "warms
up"), so that is why I wanted to understand whether there's any
tunable to get the "close to ssd" or even 300-400MB/s speed (ssd speed
is 500mb/s avg)

Regards,
Nikhil.


On Thu, 30 Jun 2022 at 13:06, Coly Li <colyli@suse.de> wrote:
>
>
>
> > 2022=E5=B9=B46=E6=9C=8830=E6=97=A5 15:26=EF=BC=8CNikhil Kshirsagar <nks=
hirsagar@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > Thank you for the clarification. But my testing results show that even =
with 15GB cache device, if I write 12gb, it still slow down, so you do not =
get  "close to ssd" speed for such IO write.. even if its smaller than cach=
e size.
> >
> > Attached results of testing comparing dm-cache with bcache. command use=
d was "fio --rw=3Drandwrite --size=3D12G --ioengine=3Dlibaio --direct=3D1 -=
-gtod_reduce=3D1 --iodepth=3D128 --bs=3D4k"
> >
> >
>
> I cannot tell why dmcache is so good from your performance number. But if=
 the peak write speed is around 550MB/s, it may take around 20 seconds. Wha=
t happens if the I/O testing may take longer, e.g. 1 hours?
>
> BTW, people cannot get =E2=80=9Cclose to ssd=E2=80=9D speed on bcache, fo=
r each write/read I/O request, bcache will update B+tree index, cache data,=
 write journal, and maybe split B+tree node, and the I/O procedure might be=
 interfered by I/Os from gc and writeback. So it is good enough, but cannot=
 be close to SSD speed.
>
> Coly Li
>
> >
> >
> > -Nikhil.
> >
> > On Thu, 30 Jun 2022 at 12:19, Coly Li <colyli@suse.de> wrote:
> > >
> > >
> > >
> > > > 2022=E5=B9=B46=E6=9C=8830=E6=97=A5 13:07=EF=BC=8CNikhil Kshirsagar =
<nkshirsagar@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> > > >
> > > > HI Coly,
> > > >
> > > > even after turning it on by echo 1 into
> > > > /sys/fs/bcache/<UUID>/internal/gc_after_writeback
> > >
> > > gc_after_writeback is a switch to triger a gc operation when writebac=
k finished to flush all dirty data to backing device. Which might be good f=
or future writing I/Os.
> > > It doesn=E2=80=99t help to gc performance.
> > >
> > >
> > >
> > > >
> > > > I still see [bcache_gc] threads appear about 70% into writing the 8=
 gb
> > > > IO into 10 gb cache.. so with the result that 8gb write takes very
> > > > long, in spite of having more than enough ssd cache for it..
> > > >
> > >
> > > This is as designed. Gc thread is triggered when every 1/16 cache spa=
ce is used, if there is no gc, the whole bcache process is very probably to=
 be locked up, due to no space for meta-data or cached data.
> > >
> > > This is why I suggest a larger cache device. And gc is unavoidable, w=
hen cache device is small, all allocation will wait for gc to make more fre=
e room. And in order to make more available free space, the dirty sectors s=
hould be written back to backing device, which is why you see everything is=
 slow down.
> > >
> > >
> > > Coly Li
> > >
> > >
> > >
> > > > Regards,
> > > > Nikhil.
> > > >
> > > > On Thu, 30 Jun 2022 at 09:54, Nikhil Kshirsagar <nkshirsagar@gmail.=
com> wrote:
> > > >>
> > > >> Thanks Coly!
> > > >>
> > > >> Can garbage collection be turned off, by echo 1 into
> > > >> /sys/fs/bcache/<UUID>/internal/gc_after_writeback ?
> > > >>
> > > >> The issue I'm seeing is, garbage collection causes write performan=
ce
> > > >> (writeback mode) to drop whenever the cache gets 50% full.
> > > >>
> > > >> With a 10gb cache device, an 8 GB write (using fio randwrite) shou=
ld
> > > >> give SSD like speed, but it does not. I am wondering if its due to=
 the
> > > >> gc threads.
> > > >>
> > > >> Regards,
> > > >> Nikhil.
> > > >>
> > > >> On Sat, 25 Jun 2022 at 17:38, Coly Li <colyli@suse.de> wrote:
> > > >>>
> > > >>>
> > > >>>
> > > >>>> 2022=E5=B9=B46=E6=9C=8825=E6=97=A5 14:29=EF=BC=8CNikhil Kshirsag=
ar <nkshirsagar@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> > > >>>>
> > > >>>> Hello,
> > > >>>>
> > > >>>> I've been doing some performance tests of bcache on 5.15.0-40-ge=
neric.
> > > >>>>
> > > >>>> The baseline figures for the fast and slow disk for random write=
s are
> > > >>>> consistent at around 225MiB/s and 3046KiB/s.
> > > >>>>
> > > >>>> But the bcache results inexplicably drop sometimes to 10Mib/s, f=
or
> > > >>>> random write test using fio like this -
> > > >>>>
> > > >>>> fio --rw=3Drandwrite --size=3D1G --ioengine=3Dlibaio --direct=3D=
1
> > > >>>> --gtod_reduce=3D1 --iodepth=3D128 --bs=3D4k --name=3DMY_TEST1
> > > >>>>
> > > >>>> WRITE: bw=3D168MiB/s (176MB/s), 168MiB/s-168MiB/s (176MB/s-176MB=
/s),
> > > >>>> io=3D1024MiB (1074MB), run=3D6104-6104msec
> > > >>>> WRITE: bw=3D283MiB/s (297MB/s), 283MiB/s-283MiB/s (297MB/s-297MB=
/s),
> > > >>>> io=3D1024MiB (1074MB), run=3D3621-3621msec
> > > >>>> WRITE: bw=3D10.3MiB/s (10.9MB/s), 10.3MiB/s-10.3MiB/s
> > > >>>> (10.9MB/s-10.9MB/s), io=3D1024MiB (1074MB), run=3D98945-98945mse=
c
> > > >>>> WRITE: bw=3D8236KiB/s (8434kB/s), 8236KiB/s-8236KiB/s
> > > >>>> (8434kB/s-8434kB/s), io=3D1024MiB (1074MB), run=3D127317-127317m=
sec
> > > >>>> WRITE: bw=3D9657KiB/s (9888kB/s), 9657KiB/s-9657KiB/s
> > > >>>> (9888kB/s-9888kB/s), io=3D1024MiB (1074MB), run=3D108587-108587m=
sec
> > > >>>> WRITE: bw=3D4543KiB/s (4652kB/s), 4543KiB/s-4543KiB/s
> > > >>>> (4652kB/s-4652kB/s), io=3D1024MiB (1074MB), run=3D230819-230819m=
sec
> > > >>>>
> > > >>>> This seems to happen after 2 runs of 1gb writes (cache disk is 4=
gb size)
> > > >>>>
> > > >>>> Some details are here - https://pastebin.com/V9mpLCbY , I will s=
hare
> > > >>>> the full testing results soon, but just was wondering about this
> > > >>>> performance drop for no apparent reason once the cache gets abou=
t 50%
> > > >>>> full.
> > > >>>
> > > >>>
> > > >>> It seems you are stuck by garbage collection. 4GB cache is small,=
 the garbage collection might be invoked quite frequently. Maybe you can se=
e the output of =E2=80=99top -H=E2=80=99 to check whether there is kernel t=
hread named bache_gc.
> > > >>>
> > > >>> Anyway, 4GB cache is too small.
> > > >>>
> > > >>> Coly Li
> > > >>>
> > >
>
