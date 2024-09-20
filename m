Return-Path: <linux-bcache+bounces-727-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 309B597D4C9
	for <lists+linux-bcache@lfdr.de>; Fri, 20 Sep 2024 13:24:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1385281F27
	for <lists+linux-bcache@lfdr.de>; Fri, 20 Sep 2024 11:24:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 469F4143C5D;
	Fri, 20 Sep 2024 11:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="nfNwHDiK"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8083B14F100
	for <linux-bcache@vger.kernel.org>; Fri, 20 Sep 2024 11:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726831451; cv=none; b=V0e5Wdbpz9+sc2ApgejnMu50KjA0oJvqCJBPaIQ1GhS6yLrX4lO12wvV3DywIRJ1VEAVfdx9TZph3SVorhTfqbjv6leugsj0eaAeVfca6NC/DFJHQU/pjN+Uw18MtRt+EJPQtRss40nRyKT0QsVdV6gM+eYTJAI6VicAuHJIyPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726831451; c=relaxed/simple;
	bh=Jdc+reJ8tffxzIXD0gHzjZjsTqKrL6qyiH/tZivUZKg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=awcBiCBKFfUASAI43WDprbWRWFB+bu5LzL84OUmwed0BEQceKszxY1Ux+/sOyva7oSXOwuJBq5YHYArGK9QSDH13bhqrx6KNi87hRnRXGDR7IKTWJNpKadfvDZ6G9lGNI0iZEWoRfI1nm5A1D6mK/6F6uY2Zh67uIm6XHXM0OAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=nfNwHDiK; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 94F373F174
	for <linux-bcache@vger.kernel.org>; Fri, 20 Sep 2024 11:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1726831440;
	bh=Jdc+reJ8tffxzIXD0gHzjZjsTqKrL6qyiH/tZivUZKg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=nfNwHDiKzejTbAIO6X86xMqqVTsLNYqVnHNOPYQENqrzKg9A9/AHRcxTXLomQnI1H
	 ryWjzywbeFbTB51KDpRYuD8+egfrvPgGqOGL1dK29fol8noDP/ipmKu51G3qhYOuhA
	 W/myc4JhARc6f1rYtkG13p1nKC3sxiqpbehsL/eRJqrnLeuhVBwy2SBlixeBuELoth
	 NU9ILWFNhA9HkBrHGRGtV+N0Dx0IkBPfdQqU1FzLYPMABycLYBvDq+p1fjKx/NpxHq
	 p3QOsgOrkP1FaTsH9snHe8ob0ACjsxMnM9GL3O0LE2XR85xftDHxfFWYHsyP4YFFWn
	 IagtnRfekXaaw==
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a8a9094c96cso121952366b.1
        for <linux-bcache@vger.kernel.org>; Fri, 20 Sep 2024 04:24:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726831440; x=1727436240;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jdc+reJ8tffxzIXD0gHzjZjsTqKrL6qyiH/tZivUZKg=;
        b=WpdjJNhmLf4iQLIIuV1iEL3IGoqEst2kToqAnKUveu+zFIqPnz5lWuFJBn4FPq/AKW
         0dPuWh631d/0qsZgPUQ32YajQnUbWXfJW3racwV5efwolddvO48rdlU3EQ3AfrV7iwsx
         g0HW49KoPTDxpMBSTB5HBnrTmBbfpOJ9sMZZh0U199KPq4jbbIl6Anax0KSaGVen28Mk
         erbGXJRc4NayRHg//9Xcm4Lgsv2gDI9upHsu93IHiYeZTG8pIUWsQK/Ifuif6WTSXDzD
         fXhRXXpmYwxhl1rv19qQdVQYwxk+5pZZZ2/XNFXkqVebi692CWFtednFZaAy2LXHqSNB
         XUQw==
X-Gm-Message-State: AOJu0Ywrmfx6o0UuIW73vNSX3ZUy/A/wEPLDhiMATpiadVkex29qodVE
	G2Pv/tbLVkg7/F+af2OTJTEIpQPdEdmgFEQ2h1UC8Hn095+xSiwWSTwvBkJ1FO/MDf+TpI7UVOE
	8tMuPkKxcx7MinqH/v7UPkMPi+C2KIh7Dy//GRlJXzDZK3dWq0+UTTewsdFjKMPU+UnmHhotnD0
	K3+YqMmqZ9dq4kqMP908jgNwlT947A6kSszVBUNiO2bCFD5+uxtryrxEmwdsJJ39R+1w==
X-Received: by 2002:a17:907:96a7:b0:a77:cbe5:413f with SMTP id a640c23a62f3a-a90d56726bamr203546066b.4.1726831439739;
        Fri, 20 Sep 2024 04:23:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXYNdD39g0UBWf7yzv2iPjsijrbnW4Z2MOyPEATmjnP6RJ+p5ZkX86hUbOChnMjAbU2dfWiJXwd/XoBcjQQjQ=
X-Received: by 2002:a17:907:96a7:b0:a77:cbe5:413f with SMTP id
 a640c23a62f3a-a90d56726bamr203544066b.4.1726831439343; Fri, 20 Sep 2024
 04:23:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAG2GFaH3_Ux=Ewi_SOqpiDhF=qVDkX-sTBB8z75mm8LOd03tfw@mail.gmail.com>
 <08E9CAFD-1ECC-4B46-8F0D-7124716E76EF@suse.de> <CAG2GFaFQBkzhOJZedHPVdZLYRvU_XMs4MZ-4KKPkDUfbU9AfVg@mail.gmail.com>
 <BD613445-66A6-4B29-A62E-2340C97D831A@suse.de> <CAG2GFaGFBGJwvK2hvQ-rgn3_vBHeapNzG9uSRHdagab3s8F9og@mail.gmail.com>
 <63707B6C-C735-4706-98E4-40C061F3FDB6@suse.de>
In-Reply-To: <63707B6C-C735-4706-98E4-40C061F3FDB6@suse.de>
From: Mitchell Dzurick <mitchell.dzurick@canonical.com>
Date: Fri, 20 Sep 2024 04:24:48 -0700
Message-ID: <CAG2GFaHiznZrFP+vqWDhA5NJ2xeM454yS62BR2xbFXA=6oyTWQ@mail.gmail.com>
Subject: Re: multipath'd bcache device
To: Coly Li <colyli@suse.de>
Cc: Bcache Linux <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Coly,

Yes, I made that observation in multipath-tools upstream bug[0].

Ultimately the issue is that the bcache-tools udev rule runs
bcache-register on the device and therefore it can't be opened by
multipath tools.

Therefore, the udev rule should wait to run until after multipath has
a chance to make the maps. I'm not sure if there's any complications
with moving the rules later into the boot process though, WDYT?

-Mitch

On Mon, Sep 9, 2024 at 8:56=E2=80=AFAM Coly Li <colyli@suse.de> wrote:
>
>
>
> > 2024=E5=B9=B49=E6=9C=886=E6=97=A5 07:37=EF=BC=8CMitchell Dzurick <mitch=
ell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > Thanks for the response Coly!
> >
> > Apologies on my delay, I was out for a bit and then was sick =3D=3D lot=
s
> > of catching up to do.
> >
> > Getting back to this, I do see that we have the bcache KCONFIG value en=
abled
> >
> > CONFIG_BCACHE_ASYNC_REGISTRATION=3Dy
> >
> > I don't believe this is a race condition issue. If I try to reload the
> > devmap table with multipath-tools well after boot, I see the following
> > in dmesg:
> >
> > $ sudo multipath -r
> > [ 8758.157075] device-mapper: table: 252:3: multipath: error getting
> > device (-EBUSY)
> > [ 8758.158039] device-mapper: ioctl: error adding target to table
> > [ 8758.256206] device-mapper: table: 252:3: multipath: error getting
> > device (-EBUSY)
> > [ 8758.256758] device-mapper: ioctl: error adding target to table
>
> When you see the above kernel message, can you check whether bcache devic=
e is initialized already?
> Or you may post the boot time kernel message as attachment, or past it so=
mewhere, then let me have a look.
>
> Thanks.
>
>
> Coly Li
>
>
>
>
> >
> > FYI - Since I'm not sure if this is a bug in bcache-tools or
> > multipath-tools, I also made an upstream bug report for
> > multipath-tools at[0].
> >
> > If there is anything else you'd like me to try, let me know :)
> >
> > [0] - https://github.com/opensvc/multipath-tools/issues/96
> >
> > On Mon, Aug 12, 2024 at 12:17=E2=80=AFAM Coly Li <colyli@suse.de> wrote=
:
> >>
> >> Hi Mitchell,
> >>
> >>
> >> It sounds like a timing issue of the initialization scripts. I assume =
the cache and backing devices are relative large, so the initialization tak=
es time. And because the storage is not local, the remote link contributes =
more time to wait for the bcache device being ready.
> >>
> >> If this is the case, then you have to tune the multipath initializatio=
n to wait for longer, or compose a customized script to start services depe=
nding on bcache devices.
> >>
> >> BTW, I assume the bcache Kconfig =E2=80=9CAsynchronous device registra=
tion=E2=80=9D is checked/enabled. If not, maybe check it on can be a bit he=
lpful.
> >>
> >> Just FYI.
> >>
> >> Coly Li
> >>
> >>> 2024=E5=B9=B48=E6=9C=8812=E6=97=A5 10:54=EF=BC=8CMitchell Dzurick <mi=
tchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>>
> >>> Thanks for the reply Coly.
> >>>
> >>> I've been able to reproduce this in Ubuntu Noble and Oracular (24.04
> >>> && 24.10). It should be an issue in Jammy but haven't tested that yet=
.
> >>> The current kernel used in Oracular is 6.8.0-31.31 and the current
> >>> kernel used in Noble is 6.8.0-40.40.
> >>>
> >>> Unfortunately you need an account to access pastebin. I can copy that
> >>> information elsewhere for you if that would be helpful, but I can als=
o
> >>> just gather any extra information you may want from my testbed.
> >>>
> >>> I also have some steps in the bug report to reproduce this issue usin=
g kvm.
> >>>
> >>> Lastly, if there's any steps you'd like me to try or look into, I'd b=
e
> >>> glad to hear :)
> >>>
> >>> -Mitch
> >>>
> >>> On Sun, Aug 11, 2024 at 5:31=E2=80=AFAM Coly Li <colyli@suse.de> wrot=
e:
> >>>>
> >>>>
> >>>>
> >>>>> 2024=E5=B9=B48=E6=9C=888=E6=97=A5 09:21=EF=BC=8CMitchell Dzurick <m=
itchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>>>>
> >>>>> Hello bcache team.
> >>>>>
> >>>>> I know this project is done and stable as [0] says, but I have a
> >>>>> question if anyone is around to answer.
> >>>>>
> >>>>> Has bcache devices been tested and supported on multipath'd disks? =
I'm
> >>>>> looking into an Ubuntu bug[1], where these 2 projects are clashing.
> >>>>> I'm wondering if there was any consideration or support for
> >>>>> multipathing when this project was made.
> >>>>>
> >>>>> Also, your new project, bcachefs, might be hitting the same scenari=
o.
> >>>>> I haven't had the time to test this though unfortunately.
> >>>>>
> >>>>> Thanks for your time,
> >>>>> -Mitch
> >>>>>
> >>>>> [0] - https://bcache.evilpiepirate.org/#index4h1
> >>>>> [1] - https://bugs.launchpad.net/ubuntu/+source/bcache-tools/+bug/1=
887558
> >>>>>
> >>>>
> >>>> From the Ubuntu bug report, I don=E2=80=99t see the kernel version. =
After parallel and asynchronous initialization was enabled, the udev rule w=
on=E2=80=99t always occupy the bcache block device for long time.
> >>>>
> >>>> It might be a bit helpful if you may provide the kernel version and =
Ubuntu os version. BTW I don=E2=80=99t have ubuntu account and cannot acces=
s pastern.canonical.com.
> >>>>
> >>>> Thanks.
> >>>>
> >>>> Coly Li
> >>>
> >>
> >
>

