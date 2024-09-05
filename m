Return-Path: <linux-bcache+bounces-716-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2676396E65E
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Sep 2024 01:38:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6FCA6B224F7
	for <lists+linux-bcache@lfdr.de>; Thu,  5 Sep 2024 23:38:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 295EB1A727D;
	Thu,  5 Sep 2024 23:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="SjUw8HYD"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE04C5381B
	for <linux-bcache@vger.kernel.org>; Thu,  5 Sep 2024 23:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725579496; cv=none; b=QMGUj7x+N43yMo5OI3HUxpKoS6ShmBIbVIkP7VOCaFme/pqke9hZGyWtM/P6uiTMfga3hErw0P7lvYWPkCb2UPRbALF1E61lh7Hv+S6lnKXrrIGVoP3jO2k7UHtCUcMXSPwfOGf1LMVn0cJRmPkgoWA+iOdTUtrxFhOIosJgKkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725579496; c=relaxed/simple;
	bh=I8ySLiUDqQSvpKMIqy1MvQLipzK8/hlENv/JjTI3GcA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uc2bbXhcMGZFZPyYqQuXgaVqfjxlXIs7/KbSuwa0kaMRFqPvErLWind804W0OE78G/G+c8QEWvGje3eCGLTXuQ6b5mI25l+IUS4d9R4W963+7PssL+xkgkmFESMzTSx3Mm0tbQbv2Xo529YprPDb+xXyjI6wDUZUyCB/Q3u+dhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=SjUw8HYD; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id BE9433F187
	for <linux-bcache@vger.kernel.org>; Thu,  5 Sep 2024 23:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1725579490;
	bh=I8ySLiUDqQSvpKMIqy1MvQLipzK8/hlENv/JjTI3GcA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=SjUw8HYDH7808uacs+lE2d9KkyKnNqBMztvxjqt+VjA21w0zppu4HBUbnM3+h6PM1
	 DHIPDAmiS2i58OFdrxx7Pyk+y6BbDWNZt/5E5r/WIWjo1Q31HoM3hNLjSi3rVx8NfB
	 7ua75Mdg7panJr+oOaHNLhCfifYj0XSLfc/0/BbwCYwEP83lopB2sbrSmd0rZXBnX0
	 RgjhdCqbzGemQ90G6jJLONeHVJuMEKl8h/2wALK01Qlrf8Jo26bzKekQEqcXKkBShf
	 +/pBOw0xXlIBASuy7yHeGmi4OvHNcvD50F4D9GmFRyN+S0t/SfjnIIGx0CpkBZDoNB
	 pSl4H8NzAt1wQ==
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a86915aeb32so142803466b.3
        for <linux-bcache@vger.kernel.org>; Thu, 05 Sep 2024 16:38:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725579490; x=1726184290;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I8ySLiUDqQSvpKMIqy1MvQLipzK8/hlENv/JjTI3GcA=;
        b=tulkn9qxzrWOyFcDivDm3B6GcufhehU3LVrh6O4fUvuPn3il41Mt7jhEBj08iLufmG
         dcWIymEIqNEpoB9VKcaQXrA7xyXz/O340ACliSnVMNNdgXNMN98C9QhxsWxp53HbXYJf
         Ci7+/d7oPU9GHoRXIrRm8IGMd0KH3K7rV++KQ/s/9VqIsqD9yvZziDvSLdlkN2juwkPX
         Be+7ZtJO882OgtGD6PUQ4luSY5893NMGkN/+c505f0OBtz8QOfmHDM3Yde9hqUQgIP71
         E3wuIrkIo3H/8Lpvk+AXb4LaPOMCtQ2mSe2Xncwoq+Azct9OtMUUYsSvdlNgNLxZuJVs
         AUtA==
X-Gm-Message-State: AOJu0YyuygdYTTyJF1vHPEHYGW9wy9Z+xNHOx9wc7BC9H9Y6FuU4HxQk
	WJV9JulJZtJrZi+oupKiCVzu4QND4aKYXzcabf7SWUTQVoHkTyhSwfZHv85zAZ4a+7TVmia124N
	2rlL7K4ToY6ias10GbT977Uf9Z8KNPy6c0L09CnPc4UvkuIeebDxquAanZmKJkQO4HFSj+vqAkl
	XLhDYn0UVndqI81Wfa7tbi/C335Fy3+vLf8RWQo1KGpRq132aVJmj3vyKGcNqtSJg=
X-Received: by 2002:a17:907:da4:b0:a86:7bdf:efcd with SMTP id a640c23a62f3a-a8a885fbe3cmr54153666b.20.1725579489938;
        Thu, 05 Sep 2024 16:38:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFOo3xo/vFR3mso11hL9/h7Um/vB1MoXzhXMTV+X5DQht+pGPR8v6U05S7gi4ZKhBAdAXd1j3KLgQvPidGL3cU=
X-Received: by 2002:a17:907:da4:b0:a86:7bdf:efcd with SMTP id
 a640c23a62f3a-a8a885fbe3cmr54151266b.20.1725579488669; Thu, 05 Sep 2024
 16:38:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAG2GFaH3_Ux=Ewi_SOqpiDhF=qVDkX-sTBB8z75mm8LOd03tfw@mail.gmail.com>
 <08E9CAFD-1ECC-4B46-8F0D-7124716E76EF@suse.de> <CAG2GFaFQBkzhOJZedHPVdZLYRvU_XMs4MZ-4KKPkDUfbU9AfVg@mail.gmail.com>
 <BD613445-66A6-4B29-A62E-2340C97D831A@suse.de>
In-Reply-To: <BD613445-66A6-4B29-A62E-2340C97D831A@suse.de>
From: Mitchell Dzurick <mitchell.dzurick@canonical.com>
Date: Thu, 5 Sep 2024 16:37:57 -0700
Message-ID: <CAG2GFaGFBGJwvK2hvQ-rgn3_vBHeapNzG9uSRHdagab3s8F9og@mail.gmail.com>
Subject: Re: multipath'd bcache device
To: Coly Li <colyli@suse.de>
Cc: Bcache Linux <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the response Coly!

Apologies on my delay, I was out for a bit and then was sick =3D=3D lots
of catching up to do.

Getting back to this, I do see that we have the bcache KCONFIG value enable=
d

CONFIG_BCACHE_ASYNC_REGISTRATION=3Dy

I don't believe this is a race condition issue. If I try to reload the
devmap table with multipath-tools well after boot, I see the following
in dmesg:

$ sudo multipath -r
[ 8758.157075] device-mapper: table: 252:3: multipath: error getting
device (-EBUSY)
[ 8758.158039] device-mapper: ioctl: error adding target to table
[ 8758.256206] device-mapper: table: 252:3: multipath: error getting
device (-EBUSY)
[ 8758.256758] device-mapper: ioctl: error adding target to table

FYI - Since I'm not sure if this is a bug in bcache-tools or
multipath-tools, I also made an upstream bug report for
multipath-tools at[0].

If there is anything else you'd like me to try, let me know :)

[0] - https://github.com/opensvc/multipath-tools/issues/96

On Mon, Aug 12, 2024 at 12:17=E2=80=AFAM Coly Li <colyli@suse.de> wrote:
>
> Hi Mitchell,
>
>
> It sounds like a timing issue of the initialization scripts. I assume the=
 cache and backing devices are relative large, so the initialization takes =
time. And because the storage is not local, the remote link contributes mor=
e time to wait for the bcache device being ready.
>
> If this is the case, then you have to tune the multipath initialization t=
o wait for longer, or compose a customized script to start services dependi=
ng on bcache devices.
>
> BTW, I assume the bcache Kconfig =E2=80=9CAsynchronous device registratio=
n=E2=80=9D is checked/enabled. If not, maybe check it on can be a bit helpf=
ul.
>
> Just FYI.
>
> Coly Li
>
> > 2024=E5=B9=B48=E6=9C=8812=E6=97=A5 10:54=EF=BC=8CMitchell Dzurick <mitc=
hell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > Thanks for the reply Coly.
> >
> > I've been able to reproduce this in Ubuntu Noble and Oracular (24.04
> > && 24.10). It should be an issue in Jammy but haven't tested that yet.
> > The current kernel used in Oracular is 6.8.0-31.31 and the current
> > kernel used in Noble is 6.8.0-40.40.
> >
> > Unfortunately you need an account to access pastebin. I can copy that
> > information elsewhere for you if that would be helpful, but I can also
> > just gather any extra information you may want from my testbed.
> >
> > I also have some steps in the bug report to reproduce this issue using =
kvm.
> >
> > Lastly, if there's any steps you'd like me to try or look into, I'd be
> > glad to hear :)
> >
> > -Mitch
> >
> > On Sun, Aug 11, 2024 at 5:31=E2=80=AFAM Coly Li <colyli@suse.de> wrote:
> >>
> >>
> >>
> >>> 2024=E5=B9=B48=E6=9C=888=E6=97=A5 09:21=EF=BC=8CMitchell Dzurick <mit=
chell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>>
> >>> Hello bcache team.
> >>>
> >>> I know this project is done and stable as [0] says, but I have a
> >>> question if anyone is around to answer.
> >>>
> >>> Has bcache devices been tested and supported on multipath'd disks? I'=
m
> >>> looking into an Ubuntu bug[1], where these 2 projects are clashing.
> >>> I'm wondering if there was any consideration or support for
> >>> multipathing when this project was made.
> >>>
> >>> Also, your new project, bcachefs, might be hitting the same scenario.
> >>> I haven't had the time to test this though unfortunately.
> >>>
> >>> Thanks for your time,
> >>> -Mitch
> >>>
> >>> [0] - https://bcache.evilpiepirate.org/#index4h1
> >>> [1] - https://bugs.launchpad.net/ubuntu/+source/bcache-tools/+bug/188=
7558
> >>>
> >>
> >> From the Ubuntu bug report, I don=E2=80=99t see the kernel version. Af=
ter parallel and asynchronous initialization was enabled, the udev rule won=
=E2=80=99t always occupy the bcache block device for long time.
> >>
> >> It might be a bit helpful if you may provide the kernel version and Ub=
untu os version. BTW I don=E2=80=99t have ubuntu account and cannot access =
pastern.canonical.com.
> >>
> >> Thanks.
> >>
> >> Coly Li
> >
>

