Return-Path: <linux-bcache+bounces-740-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ABFE986A61
	for <lists+linux-bcache@lfdr.de>; Thu, 26 Sep 2024 03:15:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02ADF1F22D1A
	for <lists+linux-bcache@lfdr.de>; Thu, 26 Sep 2024 01:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 712EC171E68;
	Thu, 26 Sep 2024 01:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="FVriZzDe"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D6F16FF26
	for <linux-bcache@vger.kernel.org>; Thu, 26 Sep 2024 01:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727313306; cv=none; b=rgnEpsMoSMpTffXezxZGjE8RlT8mAjFVJ3j4HV7a3n0J6SCOSvkfRIPLNG9IQrYD9AhKc+uu68zn7wW80bDBr2gXSulkAQ4IRUWAQvFX3PT5A+xbtVdHcBsh2Da+TfY3vYhTK9JM5gSrVKIjmfH7cciOy+KCUytQere2TaONHMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727313306; c=relaxed/simple;
	bh=BNurDWqyvsrpEriWYP4RLAgaGYs4GgJ5EccIge41bL8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FFvSirs5oErY4YvXMUFE0mMqeWXZdL6qo+9s47N9JEp68xKSD1oeeZcAUCx5rvUVDFhRsB/6eJ4H9S10zHO8O+lWS3geD3c1lM6ba1oFkLmYJhHkJ6BVmwTfNANkbRobbzZA2dkulPOSEXA29mYEEBrlZv7uKifjFaA+p1BAYTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=FVriZzDe; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 61A7F3F363
	for <linux-bcache@vger.kernel.org>; Thu, 26 Sep 2024 01:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1727313295;
	bh=yb9ojvj2zckrb80ihknkbfoEsnyFjsux0z8LhTgmvZ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=FVriZzDeCKVwPTbeEtanEa+rgz3rwKLzlFNkUFdRmwC+cYsU+xaQIzCFmv3FH1FIX
	 5YHiaEEvM5MiBZrB5rZQvZVmiDe3jYo1VUox1Qcn/FWR4Vikj20FGKNXosn0Fz1tKu
	 a3UzLvBXNVBdPaqhHXaCBrlbbh6zqcIbEyUrrh38SPvlxBPoHRmYTAcZm/3m8BCcI7
	 e8gU4VtbDIkSG6C7BlckIlQbFiKA9aJKYYZANoM0mRp2thAAQiZFqbnOt0hB+3uc5Z
	 ApSBrHkWWiCv/f0gdijSIZoR3S/rUanaJe7rSt3ttd9OBx4XCEFnr6gNuuuzl7X6y9
	 Dr9lf48yyrPBw==
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5356a102038so476071e87.1
        for <linux-bcache@vger.kernel.org>; Wed, 25 Sep 2024 18:14:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727313294; x=1727918094;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yb9ojvj2zckrb80ihknkbfoEsnyFjsux0z8LhTgmvZ8=;
        b=aQC+xR5ns+Zo6pqLtS/Ikv5m5sggjL5hNWs85NAXLBuhQdZbxurep2DfOx8oNIrdrN
         AF/ArzoXk3k0A1oJ/CxGW8tpaycGii3u1rTj97tXjIOUt8Jc6vE69qn9ZB/eiXlfH/O9
         IbnB9lq4f53RC2E/DxZUuQYU+MPVuPb3vqpizjxNpVmYvrcn4ctsdYvqCpEt1xYREFrr
         ykp63SYPb7lzLtIYYfykb1ZBtXldVtdktj7IAZX6dKOpyKvKzKWfCFOtjuRiE4ZNmPY3
         r6tf0M3T2DXG+xLHjRSko+G8Boyi39KVRHPygwLO37ggkANiX2m7ji6QeGQK0bUQNUjL
         eoHw==
X-Gm-Message-State: AOJu0Yw+YPsb7TfTqwMaaR3jyU1MkwiZjujKvqg2K7ta0tw32f45fO58
	dDET2mFQXDvyq0bVoTVfaI8ZPPZPC1N7zE8VXCQLfmcGLfOMeyoh+MJb6Oylvvh6NqS5JWd7Ud+
	+JuQcO4ALvbAB4DSuSMbNS3RQdN82h7ZWZm9bCXyaeGCKlmQm+gYYAflzHfdgRgmx75F77EEEYn
	zKx2VTu5J/30EM9yoP2Z73vPR7Y811UsfFO9xvx6K5qbRE26D+m0L6wCvZoDnexdMauA==
X-Received: by 2002:a05:6512:3a90:b0:52e:fa5f:b6a7 with SMTP id 2adb3069b0e04-53870496c1fmr3744375e87.13.1727313293807;
        Wed, 25 Sep 2024 18:14:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHlwx0yj6ToqPiufhANJG+455Rd+sHN6aXGXjXlVyK4Gf1hNJzRjtyLWZrrUb8GWCn6paXFUuX2zLcQlbc3G3A=
X-Received: by 2002:a05:6512:3a90:b0:52e:fa5f:b6a7 with SMTP id
 2adb3069b0e04-53870496c1fmr3744369e87.13.1727313293211; Wed, 25 Sep 2024
 18:14:53 -0700 (PDT)
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
In-Reply-To: <CAG2GFaHyNanEN5kQNuA3q-Pga8PVR2apQHqZJo2H+R4Z1Hizxw@mail.gmail.com>
From: Mitchell Dzurick <mitchell.dzurick@canonical.com>
Date: Wed, 25 Sep 2024 18:15:48 -0700
Message-ID: <CAG2GFaGfd3dZwUrwsgW4K9Le=yoYJsU4FuwDh1RNCs3S4_NoLg@mail.gmail.com>
Subject: Re: multipath'd bcache device
To: Coly Li <colyli@suse.de>
Cc: Bcache Linux <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Is it perhaps the bcache_allocator interacting with the block device?
I dug around a little bit but couldn't conclude if the allocator was
interacting with the block device, but there might be a better way to
confirm that, which I am not aware of.

On Wed, Sep 25, 2024 at 5:55=E2=80=AFPM Mitchell Dzurick
<mitchell.dzurick@canonical.com> wrote:
>
> Yes, sdc is another path to sdd. The lsblk command looks like this:
>
> NAME             MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINTS
> fd0                2:0    1    4K  0 disk
> sda                8:0    0   20G  0 disk
> =E2=94=94=E2=94=80mpatha         252:1    0   20G  0 mpath
>   =E2=94=9C=E2=94=80mpatha-part1 252:2    0    1M  0 part
>   =E2=94=94=E2=94=80mpatha-part2 252:3    0   20G  0 part  /
> sdb                8:16   0   20G  0 disk
> =E2=94=94=E2=94=80mpatha         252:1    0   20G  0 mpath
>   =E2=94=9C=E2=94=80mpatha-part1 252:2    0    1M  0 part
>   =E2=94=94=E2=94=80mpatha-part2 252:3    0   20G  0 part  /
> sdc                8:32   0    1G  0 disk
> =E2=94=94=E2=94=80mpathb         252:0    0    1G  0 mpath
> sdd                8:48   0    1G  0 disk
> =E2=94=94=E2=94=80mpathb         252:0    0    1G  0 mpath
> sr0               11:0    1  2.6G  0 rom
>
> Where I invoke the KVM command like this:
> $ kvm -m 2048 -boot c \
>     -cdrom ./oracular-live-server-amd64.iso \
>     -device virtio-scsi-pci,id=3Dscsi \
>     -drive file=3Dimage.img,if=3Dnone,id=3Dsda,format=3Draw,file.locking=
=3Doff \
>     -device scsi-hd,drive=3Dsda,serial=3D0001 \
>     -drive if=3Dnone,id=3Dsdb,file=3Dimage.img,format=3Draw,file.locking=
=3Doff \
>     -device scsi-hd,drive=3Dsdb,serial=3D0001 \
>     -drive file=3Dimage2.img,if=3Dnone,id=3Dsdc,format=3Draw,file.locking=
=3Doff \
>     -device scsi-hd,drive=3Dsdc,serial=3D0002 \
>     -drive if=3Dnone,id=3Dsdd,file=3Dimage2.img,format=3Draw,file.locking=
=3Doff \
>     -device scsi-hd,drive=3Dsdd,serial=3D0002 \
>     -netdev user,id=3Dnet0,hostfwd=3Dtcp::2222-:22 \
>     -device virtio-net-pci,netdev=3Dnet0
>
> > Do you know why multipath failed to get device 252:1 ?  And why I don=
=E2=80=99t see backing device of bcache here ?
> I'm not sure at the moment, that's what I'm trying to get to the bottom o=
f.
>
> The one thing that lead me down this path of bcache being involved
> with this issue, is simply that by `sudo apt purge bcache-tools` I see
> the device is picked up by multipath-tools successfully, so it seems
> something in the bcache-tools package is causing this.
>
> Is there any specific thing you'd like me to look for, or a command
> you'd like me to run?
>
> I originally assumed that the reason multipath failed was that the
> bcache udev rule opens the device file, but that is clearly a
> misunderstanding since the multipath udev rules run first, so
> _something_ is intereacting with the device early and making it busy,
> I'm just not sure what right now.
>
> On Sun, Sep 22, 2024 at 6:55=E2=80=AFPM Coly Li <colyli@suse.de> wrote:
> >
> > Hi Mitchell,
> >
> > Yes I can see the log.
> >
> > [ 1.226296] device-mapper: multipath service-time: version 0.3.0 loaded
> > [ 1.277039] device-mapper: table: 252:1: multipath: error getting devic=
e (-EBUSY)
> > [ 1.277086] device-mapper: ioctl: error adding target to table
> > [ 1.300407] bcache: bch_journal_replay() journal replay done, 0 keys in=
 1 entries, seq 1
> > [ 1.301650] bcache: register_cache() registered cache device sdd
> > [ 1.301748] bcache: register_cache_worker() error /dev/sdc: fail to reg=
ister cache device
> >
> >
> > From the above lines, it seems device mapper starts early, but both dm =
and bcache encounter a busy device.
> > Then bcache registered sdd successfully, and not register sdc. But I do=
n=E2=80=99t see other information about how the backing device was register=
ed.
> >
> > From the following message,
> > [ 4.049395] bcache: register_bcache() error : device already registered
> > [ 4.268997] bcache: register_cache_worker() error /dev/sdc: fail to reg=
ister cache device
> >
> > I assume sdc is the another path of sdd?
> > From the logs, it seems all bcache behaviors are expected, except for n=
o backing device existed/registered.
> >
> > Also I see multipath rule might execute before bcache one, but explains=
 =E2=80=9C[ 1.277039] device-mapper: table: 252:1: multipath: error getting=
 device (-EBUSY)=E2=80=9D. I don=E2=80=99t know how it happens, but this is=
 a suspicious one.
> >
> > Do you know why multipath failed to get device 252:1 ?  And why I don=
=E2=80=99t see backing device of bcache here ?
> >
> > Thanks.
> >
> > Coly Li
> >
> > > 2024=E5=B9=B49=E6=9C=8820=E6=97=A5 21:11=EF=BC=8CMitchell Dzurick <mi=
tchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > Coly,
> > >
> > > Are you able to view this?
> > >
> > > https://gist.github.com/mitchdz/addb44425709fd6df5a6b1b91611b234
> > >
> > > -Mitch
> > >
> > > On Fri, Sep 20, 2024 at 5:51=E2=80=AFAM Mitchell Dzurick
> > > <mitchell.dzurick@canonical.com> wrote:
> > >>
> > >> You are right, it seems to be something else than the udev rules. Le=
t
> > >> me paste the boot messages real quick.
> > >>
> > >> On Fri, Sep 20, 2024 at 5:42=E2=80=AFAM Coly Li <colyli@suse.de> wro=
te:
> > >>>
> > >>> On my distribution, I see multipath rules is 56-multipath.rules, it=
 should be executed early than bcache one. I am not an systemd and boot exp=
ert, but what is the order of your multipath rules?
> > >>>
> > >>> Coly Li
> > >>>
> > >>>> 2024=E5=B9=B49=E6=9C=8820=E6=97=A5 19:24=EF=BC=8CMitchell Dzurick =
<mitchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
> > >>>>
> > >>>> Coly,
> > >>>>
> > >>>> Yes, I made that observation in multipath-tools upstream bug[0].
> > >>>>
> > >>>> Ultimately the issue is that the bcache-tools udev rule runs
> > >>>> bcache-register on the device and therefore it can't be opened by
> > >>>> multipath tools.
> > >>>>
> > >>>> Therefore, the udev rule should wait to run until after multipath =
has
> > >>>> a chance to make the maps. I'm not sure if there's any complicatio=
ns
> > >>>> with moving the rules later into the boot process though, WDYT?
> > >>>>
> > >>>> -Mitch
> > >>>>
> > >>>> On Mon, Sep 9, 2024 at 8:56=E2=80=AFAM Coly Li <colyli@suse.de> wr=
ote:
> > >>>>>
> > >>>>>
> > >>>>>
> > >>>>>> 2024=E5=B9=B49=E6=9C=886=E6=97=A5 07:37=EF=BC=8CMitchell Dzurick=
 <mitchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
> > >>>>>>
> > >>>>>> Thanks for the response Coly!
> > >>>>>>
> > >>>>>> Apologies on my delay, I was out for a bit and then was sick =3D=
=3D lots
> > >>>>>> of catching up to do.
> > >>>>>>
> > >>>>>> Getting back to this, I do see that we have the bcache KCONFIG v=
alue enabled
> > >>>>>>
> > >>>>>> CONFIG_BCACHE_ASYNC_REGISTRATION=3Dy
> > >>>>>>
> > >>>>>> I don't believe this is a race condition issue. If I try to relo=
ad the
> > >>>>>> devmap table with multipath-tools well after boot, I see the fol=
lowing
> > >>>>>> in dmesg:
> > >>>>>>
> > >>>>>> $ sudo multipath -r
> > >>>>>> [ 8758.157075] device-mapper: table: 252:3: multipath: error get=
ting
> > >>>>>> device (-EBUSY)
> > >>>>>> [ 8758.158039] device-mapper: ioctl: error adding target to tabl=
e
> > >>>>>> [ 8758.256206] device-mapper: table: 252:3: multipath: error get=
ting
> > >>>>>> device (-EBUSY)
> > >>>>>> [ 8758.256758] device-mapper: ioctl: error adding target to tabl=
e
> > >>>>>
> > >>>>> When you see the above kernel message, can you check whether bcac=
he device is initialized already?
> > >>>>> Or you may post the boot time kernel message as attachment, or pa=
st it somewhere, then let me have a look.
> > >>>>>
> > >>>>> Thanks.
> > >>>>>
> > >>>>>
> > >>>>> Coly Li
> > >>>>>
> > >>>>>
> > >>>>>
> > >>>>>
> > >>>>>>
> > >>>>>> FYI - Since I'm not sure if this is a bug in bcache-tools or
> > >>>>>> multipath-tools, I also made an upstream bug report for
> > >>>>>> multipath-tools at[0].
> > >>>>>>
> > >>>>>> If there is anything else you'd like me to try, let me know :)
> > >>>>>>
> > >>>>>> [0] - https://github.com/opensvc/multipath-tools/issues/96
> > >>>>>>
> > >>>>>> On Mon, Aug 12, 2024 at 12:17=E2=80=AFAM Coly Li <colyli@suse.de=
> wrote:
> > >>>>>>>
> > >>>>>>> Hi Mitchell,
> > >>>>>>>
> > >>>>>>>
> > >>>>>>> It sounds like a timing issue of the initialization scripts. I =
assume the cache and backing devices are relative large, so the initializat=
ion takes time. And because the storage is not local, the remote link contr=
ibutes more time to wait for the bcache device being ready.
> > >>>>>>>
> > >>>>>>> If this is the case, then you have to tune the multipath initia=
lization to wait for longer, or compose a customized script to start servic=
es depending on bcache devices.
> > >>>>>>>
> > >>>>>>> BTW, I assume the bcache Kconfig =E2=80=9CAsynchronous device r=
egistration=E2=80=9D is checked/enabled. If not, maybe check it on can be a=
 bit helpful.
> > >>>>>>>
> > >>>>>>> Just FYI.
> > >>>>>>>
> > >>>>>>> Coly Li
> > >>>>>>>
> > >>>>>>>> 2024=E5=B9=B48=E6=9C=8812=E6=97=A5 10:54=EF=BC=8CMitchell Dzur=
ick <mitchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
> > >>>>>>>>
> > >>>>>>>> Thanks for the reply Coly.
> > >>>>>>>>
> > >>>>>>>> I've been able to reproduce this in Ubuntu Noble and Oracular =
(24.04
> > >>>>>>>> && 24.10). It should be an issue in Jammy but haven't tested t=
hat yet.
> > >>>>>>>> The current kernel used in Oracular is 6.8.0-31.31 and the cur=
rent
> > >>>>>>>> kernel used in Noble is 6.8.0-40.40.
> > >>>>>>>>
> > >>>>>>>> Unfortunately you need an account to access pastebin. I can co=
py that
> > >>>>>>>> information elsewhere for you if that would be helpful, but I =
can also
> > >>>>>>>> just gather any extra information you may want from my testbed=
.
> > >>>>>>>>
> > >>>>>>>> I also have some steps in the bug report to reproduce this iss=
ue using kvm.
> > >>>>>>>>
> > >>>>>>>> Lastly, if there's any steps you'd like me to try or look into=
, I'd be
> > >>>>>>>> glad to hear :)
> > >>>>>>>>
> > >>>>>>>> -Mitch
> > >>>>>>>>
> > >>>>>>>> On Sun, Aug 11, 2024 at 5:31=E2=80=AFAM Coly Li <colyli@suse.d=
e> wrote:
> > >>>>>>>>>
> > >>>>>>>>>
> > >>>>>>>>>
> > >>>>>>>>>> 2024=E5=B9=B48=E6=9C=888=E6=97=A5 09:21=EF=BC=8CMitchell Dzu=
rick <mitchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
> > >>>>>>>>>>
> > >>>>>>>>>> Hello bcache team.
> > >>>>>>>>>>
> > >>>>>>>>>> I know this project is done and stable as [0] says, but I ha=
ve a
> > >>>>>>>>>> question if anyone is around to answer.
> > >>>>>>>>>>
> > >>>>>>>>>> Has bcache devices been tested and supported on multipath'd =
disks? I'm
> > >>>>>>>>>> looking into an Ubuntu bug[1], where these 2 projects are cl=
ashing.
> > >>>>>>>>>> I'm wondering if there was any consideration or support for
> > >>>>>>>>>> multipathing when this project was made.
> > >>>>>>>>>>
> > >>>>>>>>>> Also, your new project, bcachefs, might be hitting the same =
scenario.
> > >>>>>>>>>> I haven't had the time to test this though unfortunately.
> > >>>>>>>>>>
> > >>>>>>>>>> Thanks for your time,
> > >>>>>>>>>> -Mitch
> > >>>>>>>>>>
> > >>>>>>>>>> [0] - https://bcache.evilpiepirate.org/#index4h1
> > >>>>>>>>>> [1] - https://bugs.launchpad.net/ubuntu/+source/bcache-tools=
/+bug/1887558
> > >>>>>>>>>>
> > >>>>>>>>>
> > >>>>>>>>> From the Ubuntu bug report, I don=E2=80=99t see the kernel ve=
rsion. After parallel and asynchronous initialization was enabled, the udev=
 rule won=E2=80=99t always occupy the bcache block device for long time.
> > >>>>>>>>>
> > >>>>>>>>> It might be a bit helpful if you may provide the kernel versi=
on and Ubuntu os version. BTW I don=E2=80=99t have ubuntu account and canno=
t access pastern.canonical.com.
> > >>>>>>>>>
> > >>>>>>>>> Thanks.
> > >>>>>>>>>
> > >>>>>>>>> Coly Li
> > >>>>>>>>
> > >>>>>>>
> > >>>>>>
> > >>>>>
> > >>>
> > >
> >

