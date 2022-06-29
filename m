Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E21155FFDF
	for <lists+linux-bcache@lfdr.de>; Wed, 29 Jun 2022 14:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiF2Mae (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 29 Jun 2022 08:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiF2Mad (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 29 Jun 2022 08:30:33 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2655AE73
        for <linux-bcache@vger.kernel.org>; Wed, 29 Jun 2022 05:30:32 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id a2so27790847lfg.5
        for <linux-bcache@vger.kernel.org>; Wed, 29 Jun 2022 05:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QDEy5+d4uUG28H0PyR6OznaaDDjhKOtEDv6kFrLof9E=;
        b=ibn1UyK+trA/wdJ6FBYKgZKumqJp6vnUUSlcj/0P1/Y3fl/F3Qd6SP+eN5GEfteqXr
         QnXPLu51c4y5VC7IasxkrCOI2ZBmvGXDivkWSqW9CHasVsjeN3jsKnuvh6t6sCtwnkbL
         d3dMOPMc/M3Do4m/pQC419Wfs6pFxfBZSHmUhVpaltd6++65kgfiavB5wh6Qkj1crsvP
         R4IgSQZ0hqJXnDBqDDsNB9CpGkPi7Pi7rk5I6ns6NxJKzmGErJg4atmejNILOkjfaBMq
         oYIJh1fmBO3OHthRlX8oPi5aUKT9rQL38nq23Im+KHzRkbpbpeNAf0qnT6Yw1Pl1mgH9
         n6CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QDEy5+d4uUG28H0PyR6OznaaDDjhKOtEDv6kFrLof9E=;
        b=JnQ4jg+U51hFdSvC5WqVANm5t31fZdQ0x5ZF5BQ4hBSmA4rgzrSb3q4d9iAywuMAG3
         mLdAsdVRb1+KyCocdlAmWuYT+Gg/FYpS6QxMm80h6rXr0gc/RKbY+rf4r7cmBO12E6ms
         p8nGV6Swpx33G74KBYK63s4nOMTgy91CI6K8buHHQvbmJzNlIBd7WL7sm6gdd2982+EM
         JUCvLySHw0+EVji2X/vySldEbW5h9nBfp3RDESKZN4mE+m/TVU/qgVgG7tnbl556sAmF
         mPkpMi1G+aQyUVC5qT2k261YnAc5WIi4m515MSKzTrx2nwTEUgBXCUJCn1T3nZYrBPdU
         G2qQ==
X-Gm-Message-State: AJIora8gHnoScx1BewLpA+b1OsVu0EIpC7O1P9QgrlPVT64FZYZzrNwI
        DWciH6eosoxURvKKAhO+srs3U4VaxRe6lngz0dFqgxSIciBLRg==
X-Google-Smtp-Source: AGRyM1sqeLWh6uR0uQDg4+ckTQO9mYBKET8po6hZqdRnY+AhjAIgCtlf2rVZ0oS4/5nAbHs/OPzhuQmqpyzvWRAacIg=
X-Received: by 2002:a05:6512:793:b0:47f:82d0:fadb with SMTP id
 x19-20020a056512079300b0047f82d0fadbmr1904551lfr.545.1656505830097; Wed, 29
 Jun 2022 05:30:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAC6jXv07ejbwOtqBLxLtV+Bc-ibBuSNgB+hTgY2QtAXH2tuN3Q@mail.gmail.com>
 <342D4E30-B29D-4C19-8DE5-90726F97282A@suse.de> <CAC6jXv1SvSQfjrCEX0R9gcYOuVO0AJSfcZoaW9gvSdCRr=Yfew@mail.gmail.com>
 <AB9B7785-A53B-4015-9217-5D56CFF8E482@suse.de> <CAC6jXv310pcJ5oEJ98cQBeM9iEhSLOUEuSMbtoP5nSL37T17KA@mail.gmail.com>
 <CAC6jXv1wRjYsDmkR_BjExQ6-kgF+8bAhy84AnVqgObDg1_BEvA@mail.gmail.com>
 <A6B77C96-E453-4631-BB3C-10B46C41A6FE@suse.de> <CAC6jXv2d3KizHWn+TTiwtzEThbu8UBwgD8fSf7i8AHjyXQFCCQ@mail.gmail.com>
In-Reply-To: <CAC6jXv2d3KizHWn+TTiwtzEThbu8UBwgD8fSf7i8AHjyXQFCCQ@mail.gmail.com>
From:   Nikhil Kshirsagar <nkshirsagar@gmail.com>
Date:   Wed, 29 Jun 2022 18:00:17 +0530
Message-ID: <CAC6jXv3aPcuLDC-_sGmJ+QzmX3WmMsv8L8JF6zzNi193MVUMtw@mail.gmail.com>
Subject: Re: seeing this stace trace on kernel 5.15
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

Hi Coly,

I am not able to see this issue on  5.18.0-051800-generic
(https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.18/amd64/), so I am
guessing its been fixed since 5.15.50 sometime. If you are aware of
which commit may be the fix please let me know. I will keep testing on
5.18.0-051800-generic to see if I see it ever.

Regards,
Nikhil.

On Wed, 29 Jun 2022 at 16:03, Nikhil Kshirsagar <nkshirsagar@gmail.com> wro=
te:
>
> Hi Coly,
>
> please use this as a reference, this is the source code to refer to
> for the kernel i was able to reproduce this on
> (https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.15.50/)
>
>
> commit 18a33c8dabb88b50b860e0177a73933f2c0ddf68 (tag: v5.15.50)
> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Sat Jun 25 15:18:40 2022 +0200
>
>     Linux 5.15.50
>
>     Link: https://lore.kernel.org/r/20220623164322.288837280@linuxfoundat=
ion.org
>     Tested-by: Florian Fainelli <f.fainelli@gmail.com>
>     Tested-by: Shuah Khan <skhan@linuxfoundation.org>
>     Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
>     Tested-by: Jon Hunter <jonathanh@nvidia.com>
>     Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
>     Tested-by: Ron Economos <re@w6rz.net>
>     Tested-by: Guenter Roeck <linux@roeck-us.net>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> I am able to reproduce this bug on older kernels too, like 5.4.0-121.
> I will also test the latest upstream kernel soon.
>
> Regards,
> Nikhil.
>
> On Wed, 29 Jun 2022 at 13:47, Coly Li <colyli@suse.de> wrote:
> >
> >
> >
> > > 2022=E5=B9=B46=E6=9C=8829=E6=97=A5 16:09=EF=BC=8CNikhil Kshirsagar <n=
kshirsagar@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > Hi Coly,
> > >
> > > Note I used partitions for the bcache as well as the hdd, not sure if
> > > that's a factor.
> > >
> > > the kernel is upstream kernel -
> > >
> > > # uname -a
> > > Linux bronzor 5.15.50-051550-generic #202206251445 SMP Sat Jun 25
> > > 14:51:22 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
> >
> >
> > Hi Nikhil,
> >
> > I don=E2=80=99t find the commit id 767db4b286c3e101ac220b813c873f492d9e=
4ee8 fro neither Linus tree nor stable tree.
> >
> > The tree you mentioned at https://kernel.ubuntu.com/~kernel-ppa/mainlin=
e/v5.15.50/cod/mainline/v5.15.50 (767db4b286c3e101ac220b813c873f492d9e4ee8)=
, I am not sure whether it is a clone of Linus tree or stable tree. Maybe y=
ou may try v5.15.50 from the stable tree (git://git.kernel.org/pub/scm/linu=
x/kernel/git/stable/linux.git), then we can focus on identical code base.
> >
> > Thanks.
> >
> > Coly Li
> >
> >
> > >>>>>>
> >
> > [snipped]
> > >>>>>>
> > >>>>>> Is this a bug? It's in writeback mode. I'd setup the cache and r=
un stuff like,
> > >>>>>>
> > >>>>>> echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
> > >>>>>>
> > >>>>>> I had also echoed 0 into congested_read_threshold_us,
> > >>>>>> congested_write_threshold_us.
> > >>>>>>
> > >>>>>> echo writeback > /sys/block/bcache0/bcache/cache_mode
> > >>>>>
> > >>>>> Where do you get the kernel? If this is stable kernel, could you =
give me the HEAD commit id?
> > >>>>>
> > >>>>> Coly Li
> > >>>>>
> > >>>
> >
