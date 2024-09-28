Return-Path: <linux-bcache+bounces-742-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44B4E9891F8
	for <lists+linux-bcache@lfdr.de>; Sun, 29 Sep 2024 01:01:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFB0C285707
	for <lists+linux-bcache@lfdr.de>; Sat, 28 Sep 2024 23:01:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8778216630A;
	Sat, 28 Sep 2024 23:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="v74NahCr"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31992AEEE
	for <linux-bcache@vger.kernel.org>; Sat, 28 Sep 2024 23:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727564500; cv=none; b=T1TlvY/bXCxYF+0P0bv2zNxVFTn3bEBmvDxCj1sQMeiRl3izC+XrAtN/2zp2utunP8X93cVQWfj2PzzKnLQtfUJ2ISJgxq03GT8NFLyXUnH6DYUfop2/pdfuB1htT0ke/G1WRotQq50N8zvupM0kZzcIBwgdYJoJDIgXexUDp9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727564500; c=relaxed/simple;
	bh=Yue5N+56wsSIiNL3SQDT7dJspdYbgKMsOjHKcu8/I6Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q56fIodMbwP5AMGeY88wNU+o7cyN73oFMqtW/8CRnybxA1ZbHfp0cMJWCgyrhpPxYw31ixvvL54ViB7BM/6f8QQlXzpeN88DBb8+IObjr94WNQV1J/f15Ss79qez/UJ0z8uIswVJB41zpC0XEOy3Wcg4u5+7uDYvJJPEVPp355g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=v74NahCr; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id A75203F178
	for <linux-bcache@vger.kernel.org>; Sat, 28 Sep 2024 22:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1727564080;
	bh=bigS5DguSwf2DMrqNo1gCYXq/gCLesWiPHNFycO3vYE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=v74NahCr4IJktQ2pEl1Xx7NIwAyFknhJLBgQgBAIZ7DHoofT/vKHokYx7rsT4xPpP
	 lMNxgNP1Y26b6BVN9c/CzLxmuhHnfigo6jsJuJOkL1TdfYR+4+D6Z9j9Ybk7zyUmMp
	 XnjcL7UEKkUhJBeE9QRCwJeFMWIGHhi2ZY/4Bzd2CPu8VHejl3X2A8T3CWpCDQpz8D
	 YDQkoN1Qy6Fu4H3qdsJM123FjcNkBnpU3VGJO5w4DSBIvi2svW4nFE5J1ankrCfbv5
	 +Id4L/ods6baXoLLBufaAjcLIRQVMDpqhm7Ls99ZoaKSO6iGuCqhPrVjzR965KoXpT
	 /jBSpo7vCcdJg==
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5c87b5179d9so2205511a12.1
        for <linux-bcache@vger.kernel.org>; Sat, 28 Sep 2024 15:54:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727564079; x=1728168879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bigS5DguSwf2DMrqNo1gCYXq/gCLesWiPHNFycO3vYE=;
        b=NnOysrzYsuVrs1kbfhVaRbyoz9hA5PCf04ckI3A/CPe7uNm2SFTK5QnDZo/dHP7djp
         B6WPyRxqDFQQeKYO9r+RqWzpdKahlShypgQsUSpHjR+RTT5UwYudTs1g5l7UZ0y9P1h2
         Wmh5l8Ak3R3HCZbLDBOPHjnrnWsKOJOAUjQMdS/5TysKi5esTss37x7qkG2n6Fu1BbJs
         mBcEWtN6Xl3LtX/f0hj9CNPRWQBmDtmpijnWnzZSnkEEPEV6PSmKKRsFU18Ceo193nLJ
         Rx47ElzcqrdOjses2BfZpvvC1kQTdPDimv0f4i4GbUia5xHNX1NRaZBgikK/zHHPFkpp
         zy5A==
X-Gm-Message-State: AOJu0YypKF+AF+1FQFB5F9E1/UxTs9TAcc8L/VGQdtZMnoJTt5tUSCoh
	eJHGOJdEs81RjmR/7ygCKol1+agOp+hF3/VJuaSgF7FiTLspW7AM3+hgiITdNO5U8pqapDSA6Ti
	30M21gPFJsFOHqA47wuSz3U+CixYr04mZM0nAvB/EV4u2m4+qoZt1dCqq6q0Ry/z9Sst4ejVRIk
	gn3lrYmA9H9k4HB9WAcgZ4CD9Db98KSFOuuu8olVyncbU39LdkYEuofskbf3YadFw=
X-Received: by 2002:a17:907:a44:b0:a7a:9f0f:ab18 with SMTP id a640c23a62f3a-a93c490e2f7mr824562366b.20.1727564079475;
        Sat, 28 Sep 2024 15:54:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHOSdJBTELVE5gmFmNVLllTt3a7DgOtTZasN+WjwbkAEC1u+6012y2teYaFjdVGti+LchW1YimEDO/yscKtBU0=
X-Received: by 2002:a17:907:a44:b0:a7a:9f0f:ab18 with SMTP id
 a640c23a62f3a-a93c490e2f7mr824559266b.20.1727564078273; Sat, 28 Sep 2024
 15:54:38 -0700 (PDT)
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
 <CAG2GFaGTxtm8TUPtbyssdnvW5bF77VHPPiBGkTUJPsWYMCDe9w@mail.gmail.com>
 <EDDD3F26-805D-43CD-BD8C-01C760290B07@suse.de> <CAG2GFaHyNanEN5kQNuA3q-Pga8PVR2apQHqZJo2H+R4Z1Hizxw@mail.gmail.com>
 <CAG2GFaGfd3dZwUrwsgW4K9Le=yoYJsU4FuwDh1RNCs3S4_NoLg@mail.gmail.com> <01034362-64FB-4D49-ACC0-496076543F2F@suse.de>
In-Reply-To: <01034362-64FB-4D49-ACC0-496076543F2F@suse.de>
From: Mitchell Dzurick <mitchell.dzurick@canonical.com>
Date: Sat, 28 Sep 2024 15:55:36 -0700
Message-ID: <CAG2GFaFHm-SQYpEgcH13Rs=CknwzNqJGp_8_0oGGPwwi_RYmvA@mail.gmail.com>
Subject: Re: multipath'd bcache device
To: Coly Li <colyli@suse.de>
Cc: Bcache Linux <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

There is some more conversation with the multipath-tools bug, but it
seems the udev rules might actually be at play here.

Making the bcache-tools udev rules respect SYSTEMD_READY has
alleviated the problems for me in my testbed. This is a generic
mechanism that other udev rules use (btrfs as an example). Would you
consider looking into including something like this?

To do it is pretty easy, you just add this at the top of the udev rule:

ENV{SYSTEMD_READY}=3D=3D"0", GOTO=3D"bcache_end"

-Mitch

On Thu, Sep 26, 2024 at 8:55=E2=80=AFAM Coly Li <colyli@suse.de> wrote:
>
> I doubt bcache_allocator involved in this issue. After the cache device r=
egistered, an extra refcount will be added to the block device, this is exp=
ected.
> And Bcache is fine with multipath, because another path has identical UUI=
D, the registration just fails and exits.
>
> Why multipath was not initialized at the first place, this is an open que=
stion for me.
>
> Coly Li
>
>
>
> > 2024=E5=B9=B49=E6=9C=8826=E6=97=A5 09:15=EF=BC=8CMitchell Dzurick <mitc=
hell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > Is it perhaps the bcache_allocator interacting with the block device?
> > I dug around a little bit but couldn't conclude if the allocator was
> > interacting with the block device, but there might be a better way to
> > confirm that, which I am not aware of.
> >
> > On Wed, Sep 25, 2024 at 5:55=E2=80=AFPM Mitchell Dzurick
> > <mitchell.dzurick@canonical.com> wrote:
> >>
> >> Yes, sdc is another path to sdd. The lsblk command looks like this:
> >>
> >> NAME             MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINTS
> >> fd0                2:0    1    4K  0 disk
> >> sda                8:0    0   20G  0 disk
> >> =E2=94=94=E2=94=80mpatha         252:1    0   20G  0 mpath
> >>  =E2=94=9C=E2=94=80mpatha-part1 252:2    0    1M  0 part
> >>  =E2=94=94=E2=94=80mpatha-part2 252:3    0   20G  0 part  /
> >> sdb                8:16   0   20G  0 disk
> >> =E2=94=94=E2=94=80mpatha         252:1    0   20G  0 mpath
> >>  =E2=94=9C=E2=94=80mpatha-part1 252:2    0    1M  0 part
> >>  =E2=94=94=E2=94=80mpatha-part2 252:3    0   20G  0 part  /
> >> sdc                8:32   0    1G  0 disk
> >> =E2=94=94=E2=94=80mpathb         252:0    0    1G  0 mpath
> >> sdd                8:48   0    1G  0 disk
> >> =E2=94=94=E2=94=80mpathb         252:0    0    1G  0 mpath
> >> sr0               11:0    1  2.6G  0 rom
> >>
> >> Where I invoke the KVM command like this:
> >> $ kvm -m 2048 -boot c \
> >>    -cdrom ./oracular-live-server-amd64.iso \
> >>    -device virtio-scsi-pci,id=3Dscsi \
> >>    -drive file=3Dimage.img,if=3Dnone,id=3Dsda,format=3Draw,file.lockin=
g=3Doff \
> >>    -device scsi-hd,drive=3Dsda,serial=3D0001 \
> >>    -drive if=3Dnone,id=3Dsdb,file=3Dimage.img,format=3Draw,file.lockin=
g=3Doff \
> >>    -device scsi-hd,drive=3Dsdb,serial=3D0001 \
> >>    -drive file=3Dimage2.img,if=3Dnone,id=3Dsdc,format=3Draw,file.locki=
ng=3Doff \
> >>    -device scsi-hd,drive=3Dsdc,serial=3D0002 \
> >>    -drive if=3Dnone,id=3Dsdd,file=3Dimage2.img,format=3Draw,file.locki=
ng=3Doff \
> >>    -device scsi-hd,drive=3Dsdd,serial=3D0002 \
> >>    -netdev user,id=3Dnet0,hostfwd=3Dtcp::2222-:22 \
> >>    -device virtio-net-pci,netdev=3Dnet0
> >>
> >>> Do you know why multipath failed to get device 252:1 ?  And why I don=
=E2=80=99t see backing device of bcache here ?
> >> I'm not sure at the moment, that's what I'm trying to get to the botto=
m of.
> >>
> >> The one thing that lead me down this path of bcache being involved
> >> with this issue, is simply that by `sudo apt purge bcache-tools` I see
> >> the device is picked up by multipath-tools successfully, so it seems
> >> something in the bcache-tools package is causing this.
> >>
> >> Is there any specific thing you'd like me to look for, or a command
> >> you'd like me to run?
> >>
> >> I originally assumed that the reason multipath failed was that the
> >> bcache udev rule opens the device file, but that is clearly a
> >> misunderstanding since the multipath udev rules run first, so
> >> _something_ is intereacting with the device early and making it busy,
> >> I'm just not sure what right now.
> >>
> >> On Sun, Sep 22, 2024 at 6:55=E2=80=AFPM Coly Li <colyli@suse.de> wrote=
:
> >>>
> >>> Hi Mitchell,
> >>>
> >>> Yes I can see the log.
> >>>
> >>> [ 1.226296] device-mapper: multipath service-time: version 0.3.0 load=
ed
> >>> [ 1.277039] device-mapper: table: 252:1: multipath: error getting dev=
ice (-EBUSY)
> >>> [ 1.277086] device-mapper: ioctl: error adding target to table
> >>> [ 1.300407] bcache: bch_journal_replay() journal replay done, 0 keys =
in 1 entries, seq 1
> >>> [ 1.301650] bcache: register_cache() registered cache device sdd
> >>> [ 1.301748] bcache: register_cache_worker() error /dev/sdc: fail to r=
egister cache device
> >>>
> >>>
> >>> From the above lines, it seems device mapper starts early, but both d=
m and bcache encounter a busy device.
> >>> Then bcache registered sdd successfully, and not register sdc. But I =
don=E2=80=99t see other information about how the backing device was regist=
ered.
> >>>
> >>> From the following message,
> >>> [ 4.049395] bcache: register_bcache() error : device already register=
ed
> >>> [ 4.268997] bcache: register_cache_worker() error /dev/sdc: fail to r=
egister cache device
> >>>
> >>> I assume sdc is the another path of sdd?
> >>> From the logs, it seems all bcache behaviors are expected, except for=
 no backing device existed/registered.
> >>>
> >>> Also I see multipath rule might execute before bcache one, but explai=
ns =E2=80=9C[ 1.277039] device-mapper: table: 252:1: multipath: error getti=
ng device (-EBUSY)=E2=80=9D. I don=E2=80=99t know how it happens, but this =
is a suspicious one.
> >>>
> >>> Do you know why multipath failed to get device 252:1 ?  And why I don=
=E2=80=99t see backing device of bcache here ?
> >>>
> >>> Thanks.
> >>>
> >>> Coly Li
> >>>
> >>>> 2024=E5=B9=B49=E6=9C=8820=E6=97=A5 21:11=EF=BC=8CMitchell Dzurick <m=
itchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>>>
> >>>> Coly,
> >>>>
> >>>> Are you able to view this?
> >>>>
> >>>> https://gist.github.com/mitchdz/addb44425709fd6df5a6b1b91611b234
> >>>>
> >>>> -Mitch
> >>>>
> >>>> On Fri, Sep 20, 2024 at 5:51=E2=80=AFAM Mitchell Dzurick
> >>>> <mitchell.dzurick@canonical.com> wrote:
> >>>>>
> >>>>> You are right, it seems to be something else than the udev rules. L=
et
> >>>>> me paste the boot messages real quick.
> >>>>>
> >>>>> On Fri, Sep 20, 2024 at 5:42=E2=80=AFAM Coly Li <colyli@suse.de> wr=
ote:
> >>>>>>
> >>>>>> On my distribution, I see multipath rules is 56-multipath.rules, i=
t should be executed early than bcache one. I am not an systemd and boot ex=
pert, but what is the order of your multipath rules?
> >>>>>>
> >>>>>> Coly Li
> >>>>>>
> >>>>>>> 2024=E5=B9=B49=E6=9C=8820=E6=97=A5 19:24=EF=BC=8CMitchell Dzurick=
 <mitchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>>>>>>
> >>>>>>> Coly,
> >>>>>>>
> >>>>>>> Yes, I made that observation in multipath-tools upstream bug[0].
> >>>>>>>
> >>>>>>> Ultimately the issue is that the bcache-tools udev rule runs
> >>>>>>> bcache-register on the device and therefore it can't be opened by
> >>>>>>> multipath tools.
> >>>>>>>
> >>>>>>> Therefore, the udev rule should wait to run until after multipath=
 has
> >>>>>>> a chance to make the maps. I'm not sure if there's any complicati=
ons
> >>>>>>> with moving the rules later into the boot process though, WDYT?
> >>>>>>>
> >>>>>>> -Mitch
> >>>>>>>
> >>>>>>> On Mon, Sep 9, 2024 at 8:56=E2=80=AFAM Coly Li <colyli@suse.de> w=
rote:
> >>>>>>>>
> >>>>>>>>
> >>>>>>>>
> >>>>>>>>> 2024=E5=B9=B49=E6=9C=886=E6=97=A5 07:37=EF=BC=8CMitchell Dzuric=
k <mitchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>>>>>>>>
> >>>>>>>>> Thanks for the response Coly!
> >>>>>>>>>
> >>>>>>>>> Apologies on my delay, I was out for a bit and then was sick =
=3D=3D lots
> >>>>>>>>> of catching up to do.
> >>>>>>>>>
> >>>>>>>>> Getting back to this, I do see that we have the bcache KCONFIG =
value enabled
> >>>>>>>>>
> >>>>>>>>> CONFIG_BCACHE_ASYNC_REGISTRATION=3Dy
> >>>>>>>>>
> >>>>>>>>> I don't believe this is a race condition issue. If I try to rel=
oad the
> >>>>>>>>> devmap table with multipath-tools well after boot, I see the fo=
llowing
> >>>>>>>>> in dmesg:
> >>>>>>>>>
> >>>>>>>>> $ sudo multipath -r
> >>>>>>>>> [ 8758.157075] device-mapper: table: 252:3: multipath: error ge=
tting
> >>>>>>>>> device (-EBUSY)
> >>>>>>>>> [ 8758.158039] device-mapper: ioctl: error adding target to tab=
le
> >>>>>>>>> [ 8758.256206] device-mapper: table: 252:3: multipath: error ge=
tting
> >>>>>>>>> device (-EBUSY)
> >>>>>>>>> [ 8758.256758] device-mapper: ioctl: error adding target to tab=
le
> >>>>>>>>
> >>>>>>>> When you see the above kernel message, can you check whether bca=
che device is initialized already?
> >>>>>>>> Or you may post the boot time kernel message as attachment, or p=
ast it somewhere, then let me have a look.
> >>>>>>>>
> >>>>>>>> Thanks.
> >>>>>>>>
> >>>>>>>>
> >>>>>>>> Coly Li
> >>>>>>>>
> >>>>>>>>
> >>>>>>>>
> >>>>>>>>
> >>>>>>>>>
> >>>>>>>>> FYI - Since I'm not sure if this is a bug in bcache-tools or
> >>>>>>>>> multipath-tools, I also made an upstream bug report for
> >>>>>>>>> multipath-tools at[0].
> >>>>>>>>>
> >>>>>>>>> If there is anything else you'd like me to try, let me know :)
> >>>>>>>>>
> >>>>>>>>> [0] - https://github.com/opensvc/multipath-tools/issues/96
> >>>>>>>>>
> >>>>>>>>> On Mon, Aug 12, 2024 at 12:17=E2=80=AFAM Coly Li <colyli@suse.d=
e> wrote:
> >>>>>>>>>>
> >>>>>>>>>> Hi Mitchell,
> >>>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>> It sounds like a timing issue of the initialization scripts. I=
 assume the cache and backing devices are relative large, so the initializa=
tion takes time. And because the storage is not local, the remote link cont=
ributes more time to wait for the bcache device being ready.
> >>>>>>>>>>
> >>>>>>>>>> If this is the case, then you have to tune the multipath initi=
alization to wait for longer, or compose a customized script to start servi=
ces depending on bcache devices.
> >>>>>>>>>>
> >>>>>>>>>> BTW, I assume the bcache Kconfig =E2=80=9CAsynchronous device =
registration=E2=80=9D is checked/enabled. If not, maybe check it on can be =
a bit helpful.
> >>>>>>>>>>
> >>>>>>>>>> Just FYI.
> >>>>>>>>>>
> >>>>>>>>>> Coly Li
> >>>>>>>>>>
> >>>>>>>>>>> 2024=E5=B9=B48=E6=9C=8812=E6=97=A5 10:54=EF=BC=8CMitchell Dzu=
rick <mitchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>>>>>>>>>>
> >>>>>>>>>>> Thanks for the reply Coly.
> >>>>>>>>>>>
> >>>>>>>>>>> I've been able to reproduce this in Ubuntu Noble and Oracular=
 (24.04
> >>>>>>>>>>> && 24.10). It should be an issue in Jammy but haven't tested =
that yet.
> >>>>>>>>>>> The current kernel used in Oracular is 6.8.0-31.31 and the cu=
rrent
> >>>>>>>>>>> kernel used in Noble is 6.8.0-40.40.
> >>>>>>>>>>>
> >>>>>>>>>>> Unfortunately you need an account to access pastebin. I can c=
opy that
> >>>>>>>>>>> information elsewhere for you if that would be helpful, but I=
 can also
> >>>>>>>>>>> just gather any extra information you may want from my testbe=
d.
> >>>>>>>>>>>
> >>>>>>>>>>> I also have some steps in the bug report to reproduce this is=
sue using kvm.
> >>>>>>>>>>>
> >>>>>>>>>>> Lastly, if there's any steps you'd like me to try or look int=
o, I'd be
> >>>>>>>>>>> glad to hear :)
> >>>>>>>>>>>
> >>>>>>>>>>> -Mitch
> >>>>>>>>>>>
> >>>>>>>>>>> On Sun, Aug 11, 2024 at 5:31=E2=80=AFAM Coly Li <colyli@suse.=
de> wrote:
> >>>>>>>>>>>>
> >>>>>>>>>>>>
> >>>>>>>>>>>>
> >>>>>>>>>>>>> 2024=E5=B9=B48=E6=9C=888=E6=97=A5 09:21=EF=BC=8CMitchell Dz=
urick <mitchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> Hello bcache team.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> I know this project is done and stable as [0] says, but I h=
ave a
> >>>>>>>>>>>>> question if anyone is around to answer.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> Has bcache devices been tested and supported on multipath'd=
 disks? I'm
> >>>>>>>>>>>>> looking into an Ubuntu bug[1], where these 2 projects are c=
lashing.
> >>>>>>>>>>>>> I'm wondering if there was any consideration or support for
> >>>>>>>>>>>>> multipathing when this project was made.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> Also, your new project, bcachefs, might be hitting the same=
 scenario.
> >>>>>>>>>>>>> I haven't had the time to test this though unfortunately.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> Thanks for your time,
> >>>>>>>>>>>>> -Mitch
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> [0] - https://bcache.evilpiepirate.org/#index4h1
> >>>>>>>>>>>>> [1] - https://bugs.launchpad.net/ubuntu/+source/bcache-tool=
s/+bug/1887558
> >>>>>>>>>>>>>
> >>>>>>>>>>>>
> >>>>>>>>>>>> From the Ubuntu bug report, I don=E2=80=99t see the kernel v=
ersion. After parallel and asynchronous initialization was enabled, the ude=
v rule won=E2=80=99t always occupy the bcache block device for long time.
> >>>>>>>>>>>>
> >>>>>>>>>>>> It might be a bit helpful if you may provide the kernel vers=
ion and Ubuntu os version. BTW I don=E2=80=99t have ubuntu account and cann=
ot access pastern.canonical.com.
> >>>>>>>>>>>>
> >>>>>>>>>>>> Thanks.
> >>>>>>>>>>>>
> >>>>>>>>>>>> Coly Li
> >>>>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>
> >>>>>>>>
> >>>>>>
> >>>>
> >>>
> >
>

