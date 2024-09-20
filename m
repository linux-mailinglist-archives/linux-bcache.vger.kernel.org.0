Return-Path: <linux-bcache+bounces-729-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A6CB97D5CF
	for <lists+linux-bcache@lfdr.de>; Fri, 20 Sep 2024 14:51:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 501281C20F6B
	for <lists+linux-bcache@lfdr.de>; Fri, 20 Sep 2024 12:51:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE58C170A15;
	Fri, 20 Sep 2024 12:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="GWCNtdZE"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB5F16B38E
	for <linux-bcache@vger.kernel.org>; Fri, 20 Sep 2024 12:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726836658; cv=none; b=duulEIlZDj6p4DV/WsCAVTfFKL9PTnnQCNziuNhLjq2ke3n76omy63myXIyVaEJBaL6pviLEScca/fHxzoZFpynqJOMhVyQL9bONOghpF5jql9GJDBCsYeECSzMYeUTLaUiY2lQcAfTq3ozbn6eQxKLloZvvKLmpbUqgLYfblI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726836658; c=relaxed/simple;
	bh=GW4DbS7vBwYhswG8k6RDmU0e4S7vupFjLlYGL6P4s3o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lt20bUHFlf27OkWp+9cOLPm48Gs27FyJltqVk3PqhvjROqjRi+YoCuotMR3piDkgNHoMVL0uhHlmlvhN+JVy9FM2E/yjTLsnSUIjN+mTMbif6YGN7gk3qTR9Zd4KCiGdqQinXvsTVUVXmqRimRjP01tUl7uM974okUFHfb41D9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=GWCNtdZE; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id E1FC23F45F
	for <linux-bcache@vger.kernel.org>; Fri, 20 Sep 2024 12:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1726836647;
	bh=GW4DbS7vBwYhswG8k6RDmU0e4S7vupFjLlYGL6P4s3o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=GWCNtdZEDWsgiayOqh/3ighRbsIaXIA6NSPPmAQGX71mBMj88r4wce4OoO7gJHztk
	 EkbjZXHAiSJ0Yc+4XMzcphqnriiAyqTEsOjBIvbaDQnkj6gDm66t4nTtPWHrlhZJIB
	 zYs2xjlVIr+eeON8PaiJ9nfqdgiehc5k0qnALd07b029x+yz3L/TuFt+OUfUpkWoHS
	 WdXxT1EyhOwbLR09URKSu5Zq4zQvY0ZtDv8Vqu6K/+xZL+a4c0aOA7wxKNP9ruKWmQ
	 7AMB7zP7zQxBbbPSbGcK89QNn3aWddp06jAL5nr++2lLQ3wul6Sngf13XLyoBBT5lV
	 pmfylkQTfFDtA==
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a8a9094c96cso126886766b.1
        for <linux-bcache@vger.kernel.org>; Fri, 20 Sep 2024 05:50:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726836647; x=1727441447;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GW4DbS7vBwYhswG8k6RDmU0e4S7vupFjLlYGL6P4s3o=;
        b=LI9DZfxDJ/dYdeK8VO+VgdcbDMdHqWZrv+ERp5wWcWn4TsjDcr7Ckjwrn1tVMbGUKH
         8HWWHCpEY8i0X81S3zKYACgOw3hnU0XsbG/RlpSY0OYtHg4cTml7Pz+QF1QrbuqgnwJP
         0I5Lwj5olrzozb2KfnVcsSWuldcZTdp+QfWRkUkqBl9QKqNJYsRf1zPktp+bFv+nsIAF
         7EGJlw7S0RjyxOWH/Jbli+Zp23W5+jZZzvXMhCuMShvONwVENdwhP01BI4g1IJqFxSJs
         KTHgJCxkEui5RuD8hONgcdyUu7lifoIM5DCxl4X/bDM/peXbQb5ju1pfgM7e2BNVbu2i
         zizA==
X-Gm-Message-State: AOJu0Yyklcq0SoiZ9E6SAkprq7U30lZm3InF2x5TrvcAD4DsJstv/1rk
	sPHS8iQfeFjkFzPNF+WEINSs5ngEmdREhPpzIsZSIGJxeGEgrfV32siqrBkYQ9GjxQFiiliODXm
	Zb2kRYDrKFZyYTvKlILp44sRmhBFGLZ6J2YHIFbVYiDcMhIuSR2RFuDXhJEJXwggkw401FyNxjY
	Sa7Y1DT1VqFlcuL4lcV7bO3RPWifTCODTJggod9IjMOTmhJNi5Ko1pDch7yN4AQeo0cg==
X-Received: by 2002:a17:906:fe4a:b0:a8d:2d35:3dc6 with SMTP id a640c23a62f3a-a90d5728fd0mr193089666b.26.1726836646941;
        Fri, 20 Sep 2024 05:50:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQfE2PWi7unfOfaW3xJ5u1kDcgkWId/JvhpZyxI/XmMKhFX+3hGU0mbTJKElI+7bgvo0PwlwFPuw//BfyS7X0=
X-Received: by 2002:a17:906:fe4a:b0:a8d:2d35:3dc6 with SMTP id
 a640c23a62f3a-a90d5728fd0mr193086566b.26.1726836646444; Fri, 20 Sep 2024
 05:50:46 -0700 (PDT)
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
 <C8501408-19FF-4933-A215-C1D044AB7ADE@suse.de>
In-Reply-To: <C8501408-19FF-4933-A215-C1D044AB7ADE@suse.de>
From: Mitchell Dzurick <mitchell.dzurick@canonical.com>
Date: Fri, 20 Sep 2024 05:51:35 -0700
Message-ID: <CAG2GFaE_5dB8pTxODyAEY=RkogtwCRiyv7rCC-cL9PWRkzU9Xw@mail.gmail.com>
Subject: Re: multipath'd bcache device
To: Coly Li <colyli@suse.de>
Cc: Bcache Linux <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

You are right, it seems to be something else than the udev rules. Let
me paste the boot messages real quick.

On Fri, Sep 20, 2024 at 5:42=E2=80=AFAM Coly Li <colyli@suse.de> wrote:
>
> On my distribution, I see multipath rules is 56-multipath.rules, it shoul=
d be executed early than bcache one. I am not an systemd and boot expert, b=
ut what is the order of your multipath rules?
>
> Coly Li
>
> > 2024=E5=B9=B49=E6=9C=8820=E6=97=A5 19:24=EF=BC=8CMitchell Dzurick <mitc=
hell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > Coly,
> >
> > Yes, I made that observation in multipath-tools upstream bug[0].
> >
> > Ultimately the issue is that the bcache-tools udev rule runs
> > bcache-register on the device and therefore it can't be opened by
> > multipath tools.
> >
> > Therefore, the udev rule should wait to run until after multipath has
> > a chance to make the maps. I'm not sure if there's any complications
> > with moving the rules later into the boot process though, WDYT?
> >
> > -Mitch
> >
> > On Mon, Sep 9, 2024 at 8:56=E2=80=AFAM Coly Li <colyli@suse.de> wrote:
> >>
> >>
> >>
> >>> 2024=E5=B9=B49=E6=9C=886=E6=97=A5 07:37=EF=BC=8CMitchell Dzurick <mit=
chell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>>
> >>> Thanks for the response Coly!
> >>>
> >>> Apologies on my delay, I was out for a bit and then was sick =3D=3D l=
ots
> >>> of catching up to do.
> >>>
> >>> Getting back to this, I do see that we have the bcache KCONFIG value =
enabled
> >>>
> >>> CONFIG_BCACHE_ASYNC_REGISTRATION=3Dy
> >>>
> >>> I don't believe this is a race condition issue. If I try to reload th=
e
> >>> devmap table with multipath-tools well after boot, I see the followin=
g
> >>> in dmesg:
> >>>
> >>> $ sudo multipath -r
> >>> [ 8758.157075] device-mapper: table: 252:3: multipath: error getting
> >>> device (-EBUSY)
> >>> [ 8758.158039] device-mapper: ioctl: error adding target to table
> >>> [ 8758.256206] device-mapper: table: 252:3: multipath: error getting
> >>> device (-EBUSY)
> >>> [ 8758.256758] device-mapper: ioctl: error adding target to table
> >>
> >> When you see the above kernel message, can you check whether bcache de=
vice is initialized already?
> >> Or you may post the boot time kernel message as attachment, or past it=
 somewhere, then let me have a look.
> >>
> >> Thanks.
> >>
> >>
> >> Coly Li
> >>
> >>
> >>
> >>
> >>>
> >>> FYI - Since I'm not sure if this is a bug in bcache-tools or
> >>> multipath-tools, I also made an upstream bug report for
> >>> multipath-tools at[0].
> >>>
> >>> If there is anything else you'd like me to try, let me know :)
> >>>
> >>> [0] - https://github.com/opensvc/multipath-tools/issues/96
> >>>
> >>> On Mon, Aug 12, 2024 at 12:17=E2=80=AFAM Coly Li <colyli@suse.de> wro=
te:
> >>>>
> >>>> Hi Mitchell,
> >>>>
> >>>>
> >>>> It sounds like a timing issue of the initialization scripts. I assum=
e the cache and backing devices are relative large, so the initialization t=
akes time. And because the storage is not local, the remote link contribute=
s more time to wait for the bcache device being ready.
> >>>>
> >>>> If this is the case, then you have to tune the multipath initializat=
ion to wait for longer, or compose a customized script to start services de=
pending on bcache devices.
> >>>>
> >>>> BTW, I assume the bcache Kconfig =E2=80=9CAsynchronous device regist=
ration=E2=80=9D is checked/enabled. If not, maybe check it on can be a bit =
helpful.
> >>>>
> >>>> Just FYI.
> >>>>
> >>>> Coly Li
> >>>>
> >>>>> 2024=E5=B9=B48=E6=9C=8812=E6=97=A5 10:54=EF=BC=8CMitchell Dzurick <=
mitchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>>>>
> >>>>> Thanks for the reply Coly.
> >>>>>
> >>>>> I've been able to reproduce this in Ubuntu Noble and Oracular (24.0=
4
> >>>>> && 24.10). It should be an issue in Jammy but haven't tested that y=
et.
> >>>>> The current kernel used in Oracular is 6.8.0-31.31 and the current
> >>>>> kernel used in Noble is 6.8.0-40.40.
> >>>>>
> >>>>> Unfortunately you need an account to access pastebin. I can copy th=
at
> >>>>> information elsewhere for you if that would be helpful, but I can a=
lso
> >>>>> just gather any extra information you may want from my testbed.
> >>>>>
> >>>>> I also have some steps in the bug report to reproduce this issue us=
ing kvm.
> >>>>>
> >>>>> Lastly, if there's any steps you'd like me to try or look into, I'd=
 be
> >>>>> glad to hear :)
> >>>>>
> >>>>> -Mitch
> >>>>>
> >>>>> On Sun, Aug 11, 2024 at 5:31=E2=80=AFAM Coly Li <colyli@suse.de> wr=
ote:
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>>> 2024=E5=B9=B48=E6=9C=888=E6=97=A5 09:21=EF=BC=8CMitchell Dzurick =
<mitchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>>>>>>
> >>>>>>> Hello bcache team.
> >>>>>>>
> >>>>>>> I know this project is done and stable as [0] says, but I have a
> >>>>>>> question if anyone is around to answer.
> >>>>>>>
> >>>>>>> Has bcache devices been tested and supported on multipath'd disks=
? I'm
> >>>>>>> looking into an Ubuntu bug[1], where these 2 projects are clashin=
g.
> >>>>>>> I'm wondering if there was any consideration or support for
> >>>>>>> multipathing when this project was made.
> >>>>>>>
> >>>>>>> Also, your new project, bcachefs, might be hitting the same scena=
rio.
> >>>>>>> I haven't had the time to test this though unfortunately.
> >>>>>>>
> >>>>>>> Thanks for your time,
> >>>>>>> -Mitch
> >>>>>>>
> >>>>>>> [0] - https://bcache.evilpiepirate.org/#index4h1
> >>>>>>> [1] - https://bugs.launchpad.net/ubuntu/+source/bcache-tools/+bug=
/1887558
> >>>>>>>
> >>>>>>
> >>>>>> From the Ubuntu bug report, I don=E2=80=99t see the kernel version=
. After parallel and asynchronous initialization was enabled, the udev rule=
 won=E2=80=99t always occupy the bcache block device for long time.
> >>>>>>
> >>>>>> It might be a bit helpful if you may provide the kernel version an=
d Ubuntu os version. BTW I don=E2=80=99t have ubuntu account and cannot acc=
ess pastern.canonical.com.
> >>>>>>
> >>>>>> Thanks.
> >>>>>>
> >>>>>> Coly Li
> >>>>>
> >>>>
> >>>
> >>
>

