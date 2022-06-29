Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54E655FD61
	for <lists+linux-bcache@lfdr.de>; Wed, 29 Jun 2022 12:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbiF2KeH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 29 Jun 2022 06:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiF2KeH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 29 Jun 2022 06:34:07 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833BE3DDF7
        for <linux-bcache@vger.kernel.org>; Wed, 29 Jun 2022 03:34:06 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id r9so13053574ljp.9
        for <linux-bcache@vger.kernel.org>; Wed, 29 Jun 2022 03:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=B/6vSOqvYz8Tueai5wof03+ZemrevxEcYmE45MG4nyE=;
        b=CzsBBy+oHhAUYLwYACF3c080TM+WggD7zKB1jHt3rTmpsT/mg/saJDhUOSwJnOBMPP
         hRowdnHgpHEBYzi2DdvyD98KIQoEXtRBQGrhYG9CzNtDHyZkQegXQtBpUL6IkCSED4zu
         dohmP6YfR1FQnBVzfqrnQAvNQqTu6Ca/bGd0dhmZXRlY9lJmH0TSY03w85uKJiruupYJ
         z0csFlYbu9OKcN0NpYRLH+dIbi0bbDmIfNQe3EedMKs1/OjpdZTSXCVd/xhvgFXT2A2H
         2Fs7z/xvYtgW2ob101/+aYPpwVv6zsS7TuLl7uZhMMoJ9zSQKRO5RR4DyllVXGR/6K9e
         ATcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=B/6vSOqvYz8Tueai5wof03+ZemrevxEcYmE45MG4nyE=;
        b=l6zjcdditA0xDVlLHP6XLibqAA7GQnI10sAXxApG+XWulFEGuAgMYt/BDPJ9qgvPDj
         4ubqDBBaXlW1Mm1VsTIjbLnfHe9fryFlbpAIP+aVjeEAQ0cZfIXF3B6cocscNyVg5MYK
         7r45lx31yF5N1Q0GZBFaFakHRjWUnsVJlcxrj+H846xuwVHBcwzDFg3HZcvrmIpW0MhG
         wdUKOe0sWMBT4g3NWg79eUC9lrB2uFOEikuH39IuMAsqjezuBxmi3qIzAbpFaZnSYP3h
         ORLm85+ZmjBNxnJjVCwylLpz/g5IrUMDaPoRVAULbyiTw0x0UfP0btSdSHBI1YsnMCVW
         /uuA==
X-Gm-Message-State: AJIora/3CN09oYzQfM0ZZ8S80VN3Zm9uDuaqN+VKSDL7pyd7teC+MNwm
        8InHE6k702mMuVmW6WJini6JCkpnQ5jSGY8JSD0XbzuAXU5aTg==
X-Google-Smtp-Source: AGRyM1vlgcS3i7/SK8UXYpkB80mhnwpO4ayRdpTZ0a4LvoF0GBRyjykO1jQZzazTi7r8kWWM8uxsWqWY8B63IILDnC0=
X-Received: by 2002:a05:651c:386:b0:25a:a5a7:fe47 with SMTP id
 e6-20020a05651c038600b0025aa5a7fe47mr1391270ljp.194.1656498844572; Wed, 29
 Jun 2022 03:34:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAC6jXv07ejbwOtqBLxLtV+Bc-ibBuSNgB+hTgY2QtAXH2tuN3Q@mail.gmail.com>
 <342D4E30-B29D-4C19-8DE5-90726F97282A@suse.de> <CAC6jXv1SvSQfjrCEX0R9gcYOuVO0AJSfcZoaW9gvSdCRr=Yfew@mail.gmail.com>
 <AB9B7785-A53B-4015-9217-5D56CFF8E482@suse.de> <CAC6jXv310pcJ5oEJ98cQBeM9iEhSLOUEuSMbtoP5nSL37T17KA@mail.gmail.com>
 <CAC6jXv1wRjYsDmkR_BjExQ6-kgF+8bAhy84AnVqgObDg1_BEvA@mail.gmail.com> <A6B77C96-E453-4631-BB3C-10B46C41A6FE@suse.de>
In-Reply-To: <A6B77C96-E453-4631-BB3C-10B46C41A6FE@suse.de>
From:   Nikhil Kshirsagar <nkshirsagar@gmail.com>
Date:   Wed, 29 Jun 2022 16:03:52 +0530
Message-ID: <CAC6jXv2d3KizHWn+TTiwtzEThbu8UBwgD8fSf7i8AHjyXQFCCQ@mail.gmail.com>
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

please use this as a reference, this is the source code to refer to
for the kernel i was able to reproduce this on
(https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.15.50/)


commit 18a33c8dabb88b50b860e0177a73933f2c0ddf68 (tag: v5.15.50)
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Sat Jun 25 15:18:40 2022 +0200

    Linux 5.15.50

    Link: https://lore.kernel.org/r/20220623164322.288837280@linuxfoundatio=
n.org
    Tested-by: Florian Fainelli <f.fainelli@gmail.com>
    Tested-by: Shuah Khan <skhan@linuxfoundation.org>
    Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
    Tested-by: Jon Hunter <jonathanh@nvidia.com>
    Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
    Tested-by: Ron Economos <re@w6rz.net>
    Tested-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I am able to reproduce this bug on older kernels too, like 5.4.0-121.
I will also test the latest upstream kernel soon.

Regards,
Nikhil.

On Wed, 29 Jun 2022 at 13:47, Coly Li <colyli@suse.de> wrote:
>
>
>
> > 2022=E5=B9=B46=E6=9C=8829=E6=97=A5 16:09=EF=BC=8CNikhil Kshirsagar <nks=
hirsagar@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > Hi Coly,
> >
> > Note I used partitions for the bcache as well as the hdd, not sure if
> > that's a factor.
> >
> > the kernel is upstream kernel -
> >
> > # uname -a
> > Linux bronzor 5.15.50-051550-generic #202206251445 SMP Sat Jun 25
> > 14:51:22 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
>
>
> Hi Nikhil,
>
> I don=E2=80=99t find the commit id 767db4b286c3e101ac220b813c873f492d9e4e=
e8 fro neither Linus tree nor stable tree.
>
> The tree you mentioned at https://kernel.ubuntu.com/~kernel-ppa/mainline/=
v5.15.50/cod/mainline/v5.15.50 (767db4b286c3e101ac220b813c873f492d9e4ee8), =
I am not sure whether it is a clone of Linus tree or stable tree. Maybe you=
 may try v5.15.50 from the stable tree (git://git.kernel.org/pub/scm/linux/=
kernel/git/stable/linux.git), then we can focus on identical code base.
>
> Thanks.
>
> Coly Li
>
>
> >>>>>>
>
> [snipped]
> >>>>>>
> >>>>>> Is this a bug? It's in writeback mode. I'd setup the cache and run=
 stuff like,
> >>>>>>
> >>>>>> echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
> >>>>>>
> >>>>>> I had also echoed 0 into congested_read_threshold_us,
> >>>>>> congested_write_threshold_us.
> >>>>>>
> >>>>>> echo writeback > /sys/block/bcache0/bcache/cache_mode
> >>>>>
> >>>>> Where do you get the kernel? If this is stable kernel, could you gi=
ve me the HEAD commit id?
> >>>>>
> >>>>> Coly Li
> >>>>>
> >>>
>
