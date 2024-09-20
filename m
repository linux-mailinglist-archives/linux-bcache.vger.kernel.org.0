Return-Path: <linux-bcache+bounces-730-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79C6297D5FC
	for <lists+linux-bcache@lfdr.de>; Fri, 20 Sep 2024 15:10:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8C5E3B21263
	for <lists+linux-bcache@lfdr.de>; Fri, 20 Sep 2024 13:10:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1519152786;
	Fri, 20 Sep 2024 13:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="Lo/wQZXf"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0733C2D05E
	for <linux-bcache@vger.kernel.org>; Fri, 20 Sep 2024 13:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726837850; cv=none; b=V5nSODHeFX+QRpD2t5f08x1aDBwVADt0hOYH4pnEVrTf1tAxgadGITdxXau1z02I+PSnONE7MMkdpG2ZJCY5LNS5EAU6BWMM8A30r1oVD8UgNW+SoaMA6sC2mNXSnhvwvfKwukX5QO74UUCx2zcrdwmbn3Z6+AyhxvU5ltGZDFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726837850; c=relaxed/simple;
	bh=8EWj+YOgIQ0FA1uHX/WPvywV5e+ORaPsfi0GUXHGX74=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BH839tVgCJ6EnNVjzyYXLAy8VldRdshurhWWKnFuwIS5mZlCjNowGmx0dMXgLd84cpEROiSSD1HPwkPPG95rD8KnHuhRQJa6cpR7KHLOFMdDe9ZqGYjeymGMcNccN+MVonc9y3VHJZdB9/oVz3jwBmzfaDKSXVmwHtr7DGq2wjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=Lo/wQZXf; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 4BD923F45F
	for <linux-bcache@vger.kernel.org>; Fri, 20 Sep 2024 13:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1726837846;
	bh=8EWj+YOgIQ0FA1uHX/WPvywV5e+ORaPsfi0GUXHGX74=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=Lo/wQZXfUwt7xw1kRR1eKkv+GiTl5NOh09jggnDTod7vFM3XsX0Zebnjyjz9hblBm
	 ZLI/sLUwhPfEfOWa+wM7nj1HZsJmFfr+KmjV/Z3tPKNWgi0U51zycTDKY/z2tHJKD9
	 9nYVpp3IovMQ9oJl/zemHGZqBCSmDp8a2UO+piiDeBpgIEUhA81FJbjGof8/73FEG6
	 x/Jgtz+zsLT3PEquZcvu/2jk4eAfVXqrT59tMKjOTuir4xV5a0wlMNPXbJ9CwrEYld
	 h/tL6xkIEkzxARKZtUhI0tzSnthx+p9ErFBJJu5LhosXFSrXEtlj5+5M5BAJ94ik9J
	 4L7o62vJJ2tBg==
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a8d13a9cc2cso139944766b.3
        for <linux-bcache@vger.kernel.org>; Fri, 20 Sep 2024 06:10:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726837845; x=1727442645;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8EWj+YOgIQ0FA1uHX/WPvywV5e+ORaPsfi0GUXHGX74=;
        b=bPLANF0otIgESFIDPKDZK9LU+NgF2ai7cx+zcN0G/6QWe9Lf88zLd81zheZv82CaBx
         KsXDTuCeB6DyMjIydov1un+Frdo21QZEliVpT2PfU9ULsJ0+9RjwfN2CONJU8ekjs+vW
         voHUMEWlQZxF7pKU07dcHv3DJNc+Br0S/R7YlXWlym0dSzhlPhiYLgqpcKyCy9N+X+ws
         csEtzu0guq5fXRYY2zVN75+DOC3ngn2zrDKGZaKMJ/QVSS7iPON0kksC2NRA/gHtdOkY
         J0I/CnarpkVuEujDhwUwLKZEr/SuEUyGghcN5owac1YvInbn7GUQ5HuymxtWk6C9v9eT
         OcGQ==
X-Gm-Message-State: AOJu0YyEq0fWWnCDrEjnT74gpnom2+plnKxt2azJhUuJeD4w87CzXufy
	Ex9aIkdxLsbnAN5YDk69OjdRLoqTuOr5RFP5cDnW0KzURrpKAbeDh5FI/iamXwVOkDEGrzTuJNV
	8TUEaSXburUY7pbHfm15aSxI3mBC8MP4TDs+kggG13lokNaRVZi8yuIX9u9ruhjY90mJhSoWqbn
	Yri9mo4BqoXm+CBXJN6gA7FNIAnMyMMTDOn27Jlaw8vDs0pHsTWCs8BcZ1epPaqLiw8TA0
X-Received: by 2002:a17:907:9289:b0:a86:700f:93c1 with SMTP id a640c23a62f3a-a90d5169165mr217164566b.60.1726837845457;
        Fri, 20 Sep 2024 06:10:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFp47rpR8XFUx8JF0OfgXoyJl1+KNioqRV/F7bgSaxNaIPNcBZZllPi+5zy0oh82xSW7hP6pKSCAVWK2+BzqwY=
X-Received: by 2002:a17:907:9289:b0:a86:700f:93c1 with SMTP id
 a640c23a62f3a-a90d5169165mr217160866b.60.1726837844851; Fri, 20 Sep 2024
 06:10:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAG2GFaH3_Ux=Ewi_SOqpiDhF=qVDkX-sTBB8z75mm8LOd03tfw@mail.gmail.com>
 <08E9CAFD-1ECC-4B46-8F0D-7124716E76EF@suse.de> <CAG2GFaFQBkzhOJZedHPVdZLYRvU_XMs4MZ-4KKPkDUfbU9AfVg@mail.gmail.com>
 <BD613445-66A6-4B29-A62E-2340C97D831A@suse.de> <CAG2GFaGFBGJwvK2hvQ-rgn3_vBHeapNzG9uSRHdagab3s8F9og@mail.gmail.com>
 <63707B6C-C735-4706-98E4-40C061F3FDB6@suse.de> <CAG2GFaHiznZrFP+vqWDhA5NJ2xeM454yS62BR2xbFXA=6oyTWQ@mail.gmail.com>
 <C8501408-19FF-4933-A215-C1D044AB7ADE@suse.de> <CAG2GFaE_5dB8pTxODyAEY=RkogtwCRiyv7rCC-cL9PWRkzU9Xw@mail.gmail.com>
In-Reply-To: <CAG2GFaE_5dB8pTxODyAEY=RkogtwCRiyv7rCC-cL9PWRkzU9Xw@mail.gmail.com>
From: Mitchell Dzurick <mitchell.dzurick@canonical.com>
Date: Fri, 20 Sep 2024 06:11:33 -0700
Message-ID: <CAG2GFaGTxtm8TUPtbyssdnvW5bF77VHPPiBGkTUJPsWYMCDe9w@mail.gmail.com>
Subject: Re: multipath'd bcache device
To: Coly Li <colyli@suse.de>
Cc: Bcache Linux <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Coly,

Are you able to view this?

https://gist.github.com/mitchdz/addb44425709fd6df5a6b1b91611b234

-Mitch

On Fri, Sep 20, 2024 at 5:51=E2=80=AFAM Mitchell Dzurick
<mitchell.dzurick@canonical.com> wrote:
>
> You are right, it seems to be something else than the udev rules. Let
> me paste the boot messages real quick.
>
> On Fri, Sep 20, 2024 at 5:42=E2=80=AFAM Coly Li <colyli@suse.de> wrote:
> >
> > On my distribution, I see multipath rules is 56-multipath.rules, it sho=
uld be executed early than bcache one. I am not an systemd and boot expert,=
 but what is the order of your multipath rules?
> >
> > Coly Li
> >
> > > 2024=E5=B9=B49=E6=9C=8820=E6=97=A5 19:24=EF=BC=8CMitchell Dzurick <mi=
tchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > Coly,
> > >
> > > Yes, I made that observation in multipath-tools upstream bug[0].
> > >
> > > Ultimately the issue is that the bcache-tools udev rule runs
> > > bcache-register on the device and therefore it can't be opened by
> > > multipath tools.
> > >
> > > Therefore, the udev rule should wait to run until after multipath has
> > > a chance to make the maps. I'm not sure if there's any complications
> > > with moving the rules later into the boot process though, WDYT?
> > >
> > > -Mitch
> > >
> > > On Mon, Sep 9, 2024 at 8:56=E2=80=AFAM Coly Li <colyli@suse.de> wrote=
:
> > >>
> > >>
> > >>
> > >>> 2024=E5=B9=B49=E6=9C=886=E6=97=A5 07:37=EF=BC=8CMitchell Dzurick <m=
itchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
> > >>>
> > >>> Thanks for the response Coly!
> > >>>
> > >>> Apologies on my delay, I was out for a bit and then was sick =3D=3D=
 lots
> > >>> of catching up to do.
> > >>>
> > >>> Getting back to this, I do see that we have the bcache KCONFIG valu=
e enabled
> > >>>
> > >>> CONFIG_BCACHE_ASYNC_REGISTRATION=3Dy
> > >>>
> > >>> I don't believe this is a race condition issue. If I try to reload =
the
> > >>> devmap table with multipath-tools well after boot, I see the follow=
ing
> > >>> in dmesg:
> > >>>
> > >>> $ sudo multipath -r
> > >>> [ 8758.157075] device-mapper: table: 252:3: multipath: error gettin=
g
> > >>> device (-EBUSY)
> > >>> [ 8758.158039] device-mapper: ioctl: error adding target to table
> > >>> [ 8758.256206] device-mapper: table: 252:3: multipath: error gettin=
g
> > >>> device (-EBUSY)
> > >>> [ 8758.256758] device-mapper: ioctl: error adding target to table
> > >>
> > >> When you see the above kernel message, can you check whether bcache =
device is initialized already?
> > >> Or you may post the boot time kernel message as attachment, or past =
it somewhere, then let me have a look.
> > >>
> > >> Thanks.
> > >>
> > >>
> > >> Coly Li
> > >>
> > >>
> > >>
> > >>
> > >>>
> > >>> FYI - Since I'm not sure if this is a bug in bcache-tools or
> > >>> multipath-tools, I also made an upstream bug report for
> > >>> multipath-tools at[0].
> > >>>
> > >>> If there is anything else you'd like me to try, let me know :)
> > >>>
> > >>> [0] - https://github.com/opensvc/multipath-tools/issues/96
> > >>>
> > >>> On Mon, Aug 12, 2024 at 12:17=E2=80=AFAM Coly Li <colyli@suse.de> w=
rote:
> > >>>>
> > >>>> Hi Mitchell,
> > >>>>
> > >>>>
> > >>>> It sounds like a timing issue of the initialization scripts. I ass=
ume the cache and backing devices are relative large, so the initialization=
 takes time. And because the storage is not local, the remote link contribu=
tes more time to wait for the bcache device being ready.
> > >>>>
> > >>>> If this is the case, then you have to tune the multipath initializ=
ation to wait for longer, or compose a customized script to start services =
depending on bcache devices.
> > >>>>
> > >>>> BTW, I assume the bcache Kconfig =E2=80=9CAsynchronous device regi=
stration=E2=80=9D is checked/enabled. If not, maybe check it on can be a bi=
t helpful.
> > >>>>
> > >>>> Just FYI.
> > >>>>
> > >>>> Coly Li
> > >>>>
> > >>>>> 2024=E5=B9=B48=E6=9C=8812=E6=97=A5 10:54=EF=BC=8CMitchell Dzurick=
 <mitchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
> > >>>>>
> > >>>>> Thanks for the reply Coly.
> > >>>>>
> > >>>>> I've been able to reproduce this in Ubuntu Noble and Oracular (24=
.04
> > >>>>> && 24.10). It should be an issue in Jammy but haven't tested that=
 yet.
> > >>>>> The current kernel used in Oracular is 6.8.0-31.31 and the curren=
t
> > >>>>> kernel used in Noble is 6.8.0-40.40.
> > >>>>>
> > >>>>> Unfortunately you need an account to access pastebin. I can copy =
that
> > >>>>> information elsewhere for you if that would be helpful, but I can=
 also
> > >>>>> just gather any extra information you may want from my testbed.
> > >>>>>
> > >>>>> I also have some steps in the bug report to reproduce this issue =
using kvm.
> > >>>>>
> > >>>>> Lastly, if there's any steps you'd like me to try or look into, I=
'd be
> > >>>>> glad to hear :)
> > >>>>>
> > >>>>> -Mitch
> > >>>>>
> > >>>>> On Sun, Aug 11, 2024 at 5:31=E2=80=AFAM Coly Li <colyli@suse.de> =
wrote:
> > >>>>>>
> > >>>>>>
> > >>>>>>
> > >>>>>>> 2024=E5=B9=B48=E6=9C=888=E6=97=A5 09:21=EF=BC=8CMitchell Dzuric=
k <mitchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
> > >>>>>>>
> > >>>>>>> Hello bcache team.
> > >>>>>>>
> > >>>>>>> I know this project is done and stable as [0] says, but I have =
a
> > >>>>>>> question if anyone is around to answer.
> > >>>>>>>
> > >>>>>>> Has bcache devices been tested and supported on multipath'd dis=
ks? I'm
> > >>>>>>> looking into an Ubuntu bug[1], where these 2 projects are clash=
ing.
> > >>>>>>> I'm wondering if there was any consideration or support for
> > >>>>>>> multipathing when this project was made.
> > >>>>>>>
> > >>>>>>> Also, your new project, bcachefs, might be hitting the same sce=
nario.
> > >>>>>>> I haven't had the time to test this though unfortunately.
> > >>>>>>>
> > >>>>>>> Thanks for your time,
> > >>>>>>> -Mitch
> > >>>>>>>
> > >>>>>>> [0] - https://bcache.evilpiepirate.org/#index4h1
> > >>>>>>> [1] - https://bugs.launchpad.net/ubuntu/+source/bcache-tools/+b=
ug/1887558
> > >>>>>>>
> > >>>>>>
> > >>>>>> From the Ubuntu bug report, I don=E2=80=99t see the kernel versi=
on. After parallel and asynchronous initialization was enabled, the udev ru=
le won=E2=80=99t always occupy the bcache block device for long time.
> > >>>>>>
> > >>>>>> It might be a bit helpful if you may provide the kernel version =
and Ubuntu os version. BTW I don=E2=80=99t have ubuntu account and cannot a=
ccess pastern.canonical.com.
> > >>>>>>
> > >>>>>> Thanks.
> > >>>>>>
> > >>>>>> Coly Li
> > >>>>>
> > >>>>
> > >>>
> > >>
> >

