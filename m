Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC454569E7D
	for <lists+linux-bcache@lfdr.de>; Thu,  7 Jul 2022 11:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235199AbiGGJW7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 7 Jul 2022 05:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234797AbiGGJW6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 7 Jul 2022 05:22:58 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780FA32EDA
        for <linux-bcache@vger.kernel.org>; Thu,  7 Jul 2022 02:22:57 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id t25so30062567lfg.7
        for <linux-bcache@vger.kernel.org>; Thu, 07 Jul 2022 02:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MvTZo0RUWhj8QQLLGVVEfrgkX14H+kF4jW0M0ETlN3w=;
        b=PbB5cm9x8aZt01JYccuQrYAcgCx37PxYUNcp/uCQCIKENjBm36yAfsFRwvSNioNTpm
         KDs5AG2MSvw59xfWToUFERXqBLY9BEhXbjqzBA/lbX3fZDXPeNUqOZ2TB2UJ3C2u9c9j
         LUEzYUKa9G5lEbUBK8fwSUs5+UocrFnGkJW+YXBOhI2O7iRIGxiYkpREXoe4jX6MMlli
         qPfVKnBf1z/VLr+hsvNczqYFN8MYEhtSl9r/zsAERtZoDtKI3g2MbykVrKCc4ZiohxzN
         HNnVWTG4aype8HUsvKBPqORcnmh5/3pD4eFyiacN81ljXK3k8C1yf5WtsZt1L+CpYl0D
         OhpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MvTZo0RUWhj8QQLLGVVEfrgkX14H+kF4jW0M0ETlN3w=;
        b=Vs18oK6gNMovLQWZHgBTa8SAJfxM2Y15nQMwYxsr1Q2hoAF7IABljPVmSbf4IBRrJD
         /Os7rJ6QU+WktczeZkcbynljoqDqazIpuYPdEnMzE3CPzCJA6nfS1/pA7O9wEKBlGndP
         PQN1i1yFV6LWrYtxaH4ncDuKhnhYspgTxRbdUpNHcD8meIdTN3+/UGa5Cu0w6SPHHRWI
         5Os4mzBriYLo5FQ3KqLTFVnk8nNuFV+AJwNbUqxPK9swbTHQjGuaJ94gjE5aJ14GGWld
         JDq0miq+ilR9uWuV8UJJeJDf1g4hhWZPGRndHVCZY12gDp38s4b8yx5ID57mjyFdg1uG
         1DwQ==
X-Gm-Message-State: AJIora+k4VcNzxWur3ssRoAJS8zf2dnXI3SMLK5unLmazibKorAkPYk/
        IVtDDQB2lgEN6ZOQtmC8nouo91c8E3c49g6LMXPYhRAvrmrtOQ==
X-Google-Smtp-Source: AGRyM1vfV9KqwRBjqdryCUa78RkbH//K5M71CQoLJzC08w6tTbnHCDfpVgQTclzgLG0Z/TUU264/KKmpLZASvEdX8QE=
X-Received: by 2002:a05:6512:3da8:b0:47f:616d:e54c with SMTP id
 k40-20020a0565123da800b0047f616de54cmr31325790lfv.218.1657185775640; Thu, 07
 Jul 2022 02:22:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAC6jXv07ejbwOtqBLxLtV+Bc-ibBuSNgB+hTgY2QtAXH2tuN3Q@mail.gmail.com>
 <342D4E30-B29D-4C19-8DE5-90726F97282A@suse.de> <CAC6jXv1SvSQfjrCEX0R9gcYOuVO0AJSfcZoaW9gvSdCRr=Yfew@mail.gmail.com>
 <AB9B7785-A53B-4015-9217-5D56CFF8E482@suse.de> <CAC6jXv310pcJ5oEJ98cQBeM9iEhSLOUEuSMbtoP5nSL37T17KA@mail.gmail.com>
 <CAC6jXv1wRjYsDmkR_BjExQ6-kgF+8bAhy84AnVqgObDg1_BEvA@mail.gmail.com>
 <A6B77C96-E453-4631-BB3C-10B46C41A6FE@suse.de> <CAC6jXv2d3KizHWn+TTiwtzEThbu8UBwgD8fSf7i8AHjyXQFCCQ@mail.gmail.com>
 <CAC6jXv3aPcuLDC-_sGmJ+QzmX3WmMsv8L8JF6zzNi193MVUMtw@mail.gmail.com> <B10F7435-83E6-451B-ABF6-3E2911C11CA7@suse.de>
In-Reply-To: <B10F7435-83E6-451B-ABF6-3E2911C11CA7@suse.de>
From:   Nikhil Kshirsagar <nkshirsagar@gmail.com>
Date:   Thu, 7 Jul 2022 14:52:44 +0530
Message-ID: <CAC6jXv3bvrV4_sb68bx3N49uAD3tfxJMkF=4YtvePnMGZ6uuyw@mail.gmail.com>
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

Yes, 7d6b902ea0e0 seems to be the fix for it. I cannot reproduce this
deadlock when I build this patch into 5.15.50.

Thanks for pointing me to this patch!

Regards,
Nikhil.


On Wed, 29 Jun 2022 at 18:33, Coly Li <colyli@suse.de> wrote:
>
>
>
> > 2022=E5=B9=B46=E6=9C=8829=E6=97=A5 20:30=EF=BC=8CNikhil Kshirsagar <nks=
hirsagar@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > Hi Coly,
> >
> > I am not able to see this issue on  5.18.0-051800-generic
> > (https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.18/amd64/), so I am
> > guessing its been fixed since 5.15.50 sometime. If you are aware of
> > which commit may be the fix please let me know. I will keep testing on
> > 5.18.0-051800-generic to see if I see it ever.
>
>
> Hi Nikhil,
>
> Thanks for the update. Recently there are several fixes go into stable 5.=
15.51 (but still one patch I just submitted to Greg yesterday, maybe it wil=
l show up in future 5.15.52).
>
> Maybe you can try stable tree 5.15.51 with appying one more patch,
> commit 7d6b902ea0e0 (=E2=80=9Cbcache: memset on stack variables in bch_bt=
ree_check() and bch_sectors_dirty_init()=E2=80=9D)
>
> BTW, the journal no-space deadlock fix is in 5.15.51 now.
>
> Coly Li
>
> >
> > On Wed, 29 Jun 2022 at 16:03, Nikhil Kshirsagar <nkshirsagar@gmail.com>=
 wrote:
> >>
> >> Hi Coly,
> >>
> >> please use this as a reference, this is the source code to refer to
> >> for the kernel i was able to reproduce this on
> >> (https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.15.50/)
> >>
> >>
> >> commit 18a33c8dabb88b50b860e0177a73933f2c0ddf68 (tag: v5.15.50)
> >> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> Date:   Sat Jun 25 15:18:40 2022 +0200
> >>
> >>    Linux 5.15.50
> >>
> >>    Link: https://lore.kernel.org/r/20220623164322.288837280@linuxfound=
ation.org
> >>    Tested-by: Florian Fainelli <f.fainelli@gmail.com>
> >>    Tested-by: Shuah Khan <skhan@linuxfoundation.org>
> >>    Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
> >>    Tested-by: Jon Hunter <jonathanh@nvidia.com>
> >>    Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
> >>    Tested-by: Ron Economos <re@w6rz.net>
> >>    Tested-by: Guenter Roeck <linux@roeck-us.net>
> >>    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >>
> >> I am able to reproduce this bug on older kernels too, like 5.4.0-121.
> >> I will also test the latest upstream kernel soon.
> >>
> >> Regards,
> >> Nikhil.
> >>
> >> On Wed, 29 Jun 2022 at 13:47, Coly Li <colyli@suse.de> wrote:
> >>>
> >>>
> >>>
> >>>> 2022=E5=B9=B46=E6=9C=8829=E6=97=A5 16:09=EF=BC=8CNikhil Kshirsagar <=
nkshirsagar@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>>>
> >>>> Hi Coly,
> >>>>
> >>>> Note I used partitions for the bcache as well as the hdd, not sure i=
f
> >>>> that's a factor.
> >>>>
> >>>> the kernel is upstream kernel -
> >>>>
> >>>> # uname -a
> >>>> Linux bronzor 5.15.50-051550-generic #202206251445 SMP Sat Jun 25
> >>>> 14:51:22 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
> >>>
> >>>
> >>> Hi Nikhil,
> >>>
> >>> I don=E2=80=99t find the commit id 767db4b286c3e101ac220b813c873f492d=
9e4ee8 fro neither Linus tree nor stable tree.
> >>>
> >>> The tree you mentioned at https://kernel.ubuntu.com/~kernel-ppa/mainl=
ine/v5.15.50/cod/mainline/v5.15.50 (767db4b286c3e101ac220b813c873f492d9e4ee=
8), I am not sure whether it is a clone of Linus tree or stable tree. Maybe=
 you may try v5.15.50 from the stable tree (git://git.kernel.org/pub/scm/li=
nux/kernel/git/stable/linux.git), then we can focus on identical code base.
> >>>
> >>> Thanks.
> >>>
> >>> Coly Li
> >>>
> >>>
> >>>>>>>>>
> >>>
> >>> [snipped]
> >>>>>>>>>
> >>>>>>>>> Is this a bug? It's in writeback mode. I'd setup the cache and =
run stuff like,
> >>>>>>>>>
> >>>>>>>>> echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
> >>>>>>>>>
> >>>>>>>>> I had also echoed 0 into congested_read_threshold_us,
> >>>>>>>>> congested_write_threshold_us.
> >>>>>>>>>
> >>>>>>>>> echo writeback > /sys/block/bcache0/bcache/cache_mode
> >>>>>>>>
> >>>>>>>> Where do you get the kernel? If this is stable kernel, could you=
 give me the HEAD commit id?
> >>>>>>>>
> >>>>>>>> Coly Li
> >>>>>>>>
> >>>>>>
> >>>
>
