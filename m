Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDF968655F
	for <lists+linux-bcache@lfdr.de>; Wed,  1 Feb 2023 12:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjBALZa (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 1 Feb 2023 06:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBALZ3 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Feb 2023 06:25:29 -0500
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396937A88
        for <linux-bcache@vger.kernel.org>; Wed,  1 Feb 2023 03:25:28 -0800 (PST)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-16332831ed0so23095185fac.10
        for <linux-bcache@vger.kernel.org>; Wed, 01 Feb 2023 03:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devo.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Xlwa7w/peQSBlsqSgNwUqdqLZxCSA4GIJ22ASmmtV8=;
        b=V03oyCA6LNqlOQARODHlMdlZX4bBPeoOc9DFVEXXDmS/4Np3IgUjjHZX2OTsAV44qt
         uPowEN9GVkSk1tTwgmWg8zDcays62X/DKeTM0VyBo3r3fRbIWHOhw30NTmATdWxCV2qo
         xHCZ3OkjG4SJr/6P70QagQM/A/9jbHrQ6gG57yY5VwETwrbygl77yk6TzclRIutYUJn0
         8Hqf1sizANr/2joPoOHaoxmwjyWDcqPivAv+8I7tUepqXmdos37fmgrYHGpX8NyObpVu
         0G7yVau3KbX4z2UhtRJxgVjHFa4CQL1AhcSpsjHjAJP7ymtmtkZHvCgv9kQPDSTWYlyo
         qgrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Xlwa7w/peQSBlsqSgNwUqdqLZxCSA4GIJ22ASmmtV8=;
        b=bJke6gHLbQKcE9anrKh1QYzZWh8bRdUoYiA78BNnf9KNDf51fUSH8u7R78c3Qbrr8i
         1F3Z556E4iBzByDkyr1BtJOEItZZY7je4mQLFA5WRZEvsC4q5QfKgzPbwsL590jdN50X
         rPM4K3y89CYm+4daRu2ERuFu+ZZAe8aGfav/Ft/HE9Z5LfPZN8150RzY6uimvmCeGpMl
         l4I2Zs42G6TpzwK+h6dxAiGhYQf7R/ihmsZDPBNOpmEX41IJhg3aNaixQ7zZ2n4grrqG
         5qlUcoTTdC4GtAgSdYAPGGas7pIXpzWwgTF4X8sW+U2OibbP1LZZ6ztTBWU6B5h1aHG2
         WddQ==
X-Gm-Message-State: AO0yUKVimuqE8MqkkZNY6UQlFPKfa6j+SxJ9C9Ah0rAdgM/L8wgEqIZf
        0k7iSVuOroNQ7NSSrk/SpsKI7Z1UAW1mfQYtj1HOwA==
X-Google-Smtp-Source: AK7set8b4j3d5XMeF2m0NMuHgdAt8IFfEjhS/ecjrEGshtr+gaaTOdr5h02TNFGEvx5kN8DGnko2O7qqBKygCv3UJ00=
X-Received: by 2002:a05:6870:c88f:b0:163:23ed:982c with SMTP id
 er15-20020a056870c88f00b0016323ed982cmr105640oab.230.1675250727504; Wed, 01
 Feb 2023 03:25:27 -0800 (PST)
MIME-Version: 1.0
References: <CAHykVA6L3bQkGJ11N3jG_QSgPbyr40zc8rBNPPwBN9a5RHwC6Q@mail.gmail.com>
 <AA6912BA-7DE5-466E-8E85-9EB58FCFC81D@suse.de> <3ac5b76c-4f73-5668-50da-d3038f162040@easystack.cn>
In-Reply-To: <3ac5b76c-4f73-5668-50da-d3038f162040@easystack.cn>
From:   Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
Date:   Wed, 1 Feb 2023 12:25:16 +0100
Message-ID: <CAHykVA5DmjjuLan1N9cHkhshtZ==M0FVjEJ7cHGjWBymE4kP0A@mail.gmail.com>
Subject: Re: Multi-Level Caching
To:     mingzhe <mingzhe.zou@easystack.cn>
Cc:     Coly Li <colyli@suse.de>, Eric Wheeler <bcache@lists.ewheeler.net>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly,

On Wed, Feb 1, 2023 at 4:03 AM mingzhe <mingzhe.zou@easystack.cn> wrote:
>
>
>
> =E5=9C=A8 2023/1/31 23:51, Coly Li =E5=86=99=E9=81=93:
> >
> >
> >> 2023=E5=B9=B41=E6=9C=8826=E6=97=A5 19:30=EF=BC=8CAndrea Tomassetti <an=
drea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>
> >> Hi,
> >> I know that bcache doesn't natively support multi-level caching but I
> >> was playing with it and found this interesting "workaround":
> >>   make-bcache -B /dev/vdb -C /dev/vdc
> >> the above command will generate a /dev/bcache0 device that we can now
> >> use as backing (or cached) device:
> >>   make-bcache -B /dev/bcache0 -C /dev/vdd
> >> This will make the kernel panic because the driver is trying to create
> >> a duplicated "bcache" folder under /sys/block/bcache0/ .
> >> So, simply patching the code inside register_bdev to create a folder
> >> "bcache2" if "bcache" already exists does the trick.
> >> Now I have:
> >> vdb                       252:16   0    5G  0 disk
> >> =E2=94=94=E2=94=80bcache0                 251:0    0    5G  0 disk
> >>   =E2=94=94=E2=94=80bcache1               251:128  0    5G  0 disk /mn=
t/bcache1
> >> vdc                       252:32   0   10G  0 disk
> >> =E2=94=94=E2=94=80bcache0                 251:0    0    5G  0 disk
> >>   =E2=94=94=E2=94=80bcache1               251:128  0    5G  0 disk /mn=
t/bcache1
> >> vdd                       252:48   0    5G  0 disk
> >> =E2=94=94=E2=94=80bcache1                 251:128  0    5G  0 disk /mn=
t/bcache1
> >>
> >> Is anyone using this functionality? I assume not, because by default
> >> it doesn't work.
> >> Is there any good reason why this doesn't work by default?
> >>
> >> I tried to understand how data will be read out of /dev/bcache1: will
> >> the /dev/vdd cache, secondly created cache device, be interrogated
> >> first and then will it be the turn of /dev/vdc ?
> >> Meaning: can we consider that now the layer structure is
> >>
> >> vdd
> >> =E2=94=94=E2=94=80vdc
> >>        =E2=94=94=E2=94=80bcache0
> >>              =E2=94=94=E2=94=80bcache1
> >> ?
> >
> > IIRC, there was a patch tried to achieve similar purpose. I was not sup=
portive for this idea because I didn=E2=80=99t see really useful use case.
I didn't test it extensively but it looks like that the patch to
achieve this is just a one-line patch, it could be very beneficial. (I
just realized that mingzhe sent a relevant patch on this, thank for
your work)
Our use case will be to be able to take advantage of different
blocking devices that differ in performance and cost.
Some of these blocking devices are ephemeral and not suitable for wb
cache mode, but stacking them with non-ephemeral ones would be a very
nice and neat solution.

Cheers,
Andrea


>
> Hi, Coly
>
> Maybe we have a case like this. We are considering make-bcache a hdd as
> a cache device and create a flash device in it, and then using the flash
> device as a backing. So=EF=BC=8C completely converts writeback to sequent=
ial
> writes.
>
> However, we found that there may be many unknown problems in the flash
> device, such as the created size, etc.
>
> For now, we've put it due to time=EF=BC=8Cbut we think it might be a good=
 thing
> to do. We also have some patches, I will post them.
>
> mingzhe
>
> > In general, extra layer cache means extra latency in the I/O path. What=
 I see in practical deployments are, people try very hard to minimize the c=
ache layer and place it close to application.
> >
> > Introduce stackable bcache for itself may work, but I don=E2=80=99t see=
 real usage yet, and no motivation to maintain such usage still.
> >
> > Thanks.
> >
> > Coly Li
