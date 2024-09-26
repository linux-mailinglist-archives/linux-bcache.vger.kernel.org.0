Return-Path: <linux-bcache+bounces-741-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CFB0987707
	for <lists+linux-bcache@lfdr.de>; Thu, 26 Sep 2024 17:55:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFD511C257BB
	for <lists+linux-bcache@lfdr.de>; Thu, 26 Sep 2024 15:55:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4395A14F126;
	Thu, 26 Sep 2024 15:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xN2GAYaV";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NaCXA9hN";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xN2GAYaV";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NaCXA9hN"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779CF487B0
	for <linux-bcache@vger.kernel.org>; Thu, 26 Sep 2024 15:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727366156; cv=none; b=Kbi2QWMemPK9OmnBKfrB32BVvND0oil6uij1QijmQ+eDt8sG3TyIvdIBh/CzMVpIzFxGdQ1vqaIKuTF53KbuDFjlak9vMb/I9XoYdpcSZhgO0EVbei895C63bt4hB896QQxBDyXSRgxfLd29gM144JGaH+USWLLg1KfsVKXpW7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727366156; c=relaxed/simple;
	bh=v4MWPiPvSRKGJl+y07Tz/RYryD6yhLW7CybIle8QPwM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=RRtCOrXONonZAeWLIFOfn9TMoehdr6+xIn88dQmFZr+feZYUo24MLVE0fAhX8ftvWEtEBDJEdRBOlCa2B8RsvCHSwC7cf3Eh8eEGlumI9Tp3+kmHBPcnT3s0sfiwDakUSGozpqv2GxSXzMbCKzsep+Ug2jRkCLlQUj07/y206uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xN2GAYaV; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NaCXA9hN; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xN2GAYaV; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NaCXA9hN; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8089E1FCEC;
	Thu, 26 Sep 2024 15:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727366151; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kk/NLPSVR1DyTt/hdXGaFXV2bVbtOB1e4kQLTf5WPlo=;
	b=xN2GAYaVlNq5WV7t6o16MDZbgsOjyr/AxQBWmqWuSgJbP/WO8ZkbK4TgsqEgQViM8au1El
	qOZ2vWeCF6cl5QzAq5mN1H1Xws0BivCGLM09MGTXQwmOObSXOWGIDMP8EqSa2LmA89LEuU
	mKow0R5rFumIv0N0O6FLZJlH9mitgzQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727366151;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kk/NLPSVR1DyTt/hdXGaFXV2bVbtOB1e4kQLTf5WPlo=;
	b=NaCXA9hNwotpT15Uq5S9L1+X/bOw/N1grdm9NTokbTKrVdl5ejridV7GPBPb7ZyqWqXQdk
	lDiBR0mtMPv+j6Dw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727366151; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kk/NLPSVR1DyTt/hdXGaFXV2bVbtOB1e4kQLTf5WPlo=;
	b=xN2GAYaVlNq5WV7t6o16MDZbgsOjyr/AxQBWmqWuSgJbP/WO8ZkbK4TgsqEgQViM8au1El
	qOZ2vWeCF6cl5QzAq5mN1H1Xws0BivCGLM09MGTXQwmOObSXOWGIDMP8EqSa2LmA89LEuU
	mKow0R5rFumIv0N0O6FLZJlH9mitgzQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727366151;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kk/NLPSVR1DyTt/hdXGaFXV2bVbtOB1e4kQLTf5WPlo=;
	b=NaCXA9hNwotpT15Uq5S9L1+X/bOw/N1grdm9NTokbTKrVdl5ejridV7GPBPb7ZyqWqXQdk
	lDiBR0mtMPv+j6Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7A44813793;
	Thu, 26 Sep 2024 15:55:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SlyoCwaE9WaXEwAAD6G6ig
	(envelope-from <colyli@suse.de>); Thu, 26 Sep 2024 15:55:50 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: multipath'd bcache device
From: Coly Li <colyli@suse.de>
In-Reply-To: <CAG2GFaGfd3dZwUrwsgW4K9Le=yoYJsU4FuwDh1RNCs3S4_NoLg@mail.gmail.com>
Date: Thu, 26 Sep 2024 23:55:26 +0800
Cc: Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <01034362-64FB-4D49-ACC0-496076543F2F@suse.de>
References: <CAG2GFaH3_Ux=Ewi_SOqpiDhF=qVDkX-sTBB8z75mm8LOd03tfw@mail.gmail.com>
 <08E9CAFD-1ECC-4B46-8F0D-7124716E76EF@suse.de>
 <CAG2GFaFQBkzhOJZedHPVdZLYRvU_XMs4MZ-4KKPkDUfbU9AfVg@mail.gmail.com>
 <BD613445-66A6-4B29-A62E-2340C97D831A@suse.de>
 <CAG2GFaGFBGJwvK2hvQ-rgn3_vBHeapNzG9uSRHdagab3s8F9og@mail.gmail.com>
 <63707B6C-C735-4706-98E4-40C061F3FDB6@suse.de>
 <CAG2GFaHiznZrFP+vqWDhA5NJ2xeM454yS62BR2xbFXA=6oyTWQ@mail.gmail.com>
 <C8501408-19FF-4933-A215-C1D044AB7ADE@suse.de>
 <CAG2GFaE_5dB8pTxODyAEY=RkogtwCRiyv7rCC-cL9PWRkzU9Xw@mail.gmail.com>
 <CAG2GFaGTxtm8TUPtbyssdnvW5bF77VHPPiBGkTUJPsWYMCDe9w@mail.gmail.com>
 <EDDD3F26-805D-43CD-BD8C-01C760290B07@suse.de>
 <CAG2GFaHyNanEN5kQNuA3q-Pga8PVR2apQHqZJo2H+R4Z1Hizxw@mail.gmail.com>
 <CAG2GFaGfd3dZwUrwsgW4K9Le=yoYJsU4FuwDh1RNCs3S4_NoLg@mail.gmail.com>
To: Mitchell Dzurick <mitchell.dzurick@canonical.com>
X-Mailer: Apple Mail (2.3776.700.51)
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	APPLE_MAILER_COMMON(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 

I doubt bcache_allocator involved in this issue. After the cache device =
registered, an extra refcount will be added to the block device, this is =
expected.
And Bcache is fine with multipath, because another path has identical =
UUID, the registration just fails and exits.

Why multipath was not initialized at the first place, this is an open =
question for me.

Coly Li



> 2024=E5=B9=B49=E6=9C=8826=E6=97=A5 09:15=EF=BC=8CMitchell Dzurick =
<mitchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Is it perhaps the bcache_allocator interacting with the block device?
> I dug around a little bit but couldn't conclude if the allocator was
> interacting with the block device, but there might be a better way to
> confirm that, which I am not aware of.
>=20
> On Wed, Sep 25, 2024 at 5:55=E2=80=AFPM Mitchell Dzurick
> <mitchell.dzurick@canonical.com> wrote:
>>=20
>> Yes, sdc is another path to sdd. The lsblk command looks like this:
>>=20
>> NAME             MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINTS
>> fd0                2:0    1    4K  0 disk
>> sda                8:0    0   20G  0 disk
>> =E2=94=94=E2=94=80mpatha         252:1    0   20G  0 mpath
>>  =E2=94=9C=E2=94=80mpatha-part1 252:2    0    1M  0 part
>>  =E2=94=94=E2=94=80mpatha-part2 252:3    0   20G  0 part  /
>> sdb                8:16   0   20G  0 disk
>> =E2=94=94=E2=94=80mpatha         252:1    0   20G  0 mpath
>>  =E2=94=9C=E2=94=80mpatha-part1 252:2    0    1M  0 part
>>  =E2=94=94=E2=94=80mpatha-part2 252:3    0   20G  0 part  /
>> sdc                8:32   0    1G  0 disk
>> =E2=94=94=E2=94=80mpathb         252:0    0    1G  0 mpath
>> sdd                8:48   0    1G  0 disk
>> =E2=94=94=E2=94=80mpathb         252:0    0    1G  0 mpath
>> sr0               11:0    1  2.6G  0 rom
>>=20
>> Where I invoke the KVM command like this:
>> $ kvm -m 2048 -boot c \
>>    -cdrom ./oracular-live-server-amd64.iso \
>>    -device virtio-scsi-pci,id=3Dscsi \
>>    -drive file=3Dimage.img,if=3Dnone,id=3Dsda,format=3Draw,file.locking=
=3Doff \
>>    -device scsi-hd,drive=3Dsda,serial=3D0001 \
>>    -drive if=3Dnone,id=3Dsdb,file=3Dimage.img,format=3Draw,file.locking=
=3Doff \
>>    -device scsi-hd,drive=3Dsdb,serial=3D0001 \
>>    -drive file=3Dimage2.img,if=3Dnone,id=3Dsdc,format=3Draw,file.lockin=
g=3Doff \
>>    -device scsi-hd,drive=3Dsdc,serial=3D0002 \
>>    -drive if=3Dnone,id=3Dsdd,file=3Dimage2.img,format=3Draw,file.lockin=
g=3Doff \
>>    -device scsi-hd,drive=3Dsdd,serial=3D0002 \
>>    -netdev user,id=3Dnet0,hostfwd=3Dtcp::2222-:22 \
>>    -device virtio-net-pci,netdev=3Dnet0
>>=20
>>> Do you know why multipath failed to get device 252:1 ?  And why I =
don=E2=80=99t see backing device of bcache here ?
>> I'm not sure at the moment, that's what I'm trying to get to the =
bottom of.
>>=20
>> The one thing that lead me down this path of bcache being involved
>> with this issue, is simply that by `sudo apt purge bcache-tools` I =
see
>> the device is picked up by multipath-tools successfully, so it seems
>> something in the bcache-tools package is causing this.
>>=20
>> Is there any specific thing you'd like me to look for, or a command
>> you'd like me to run?
>>=20
>> I originally assumed that the reason multipath failed was that the
>> bcache udev rule opens the device file, but that is clearly a
>> misunderstanding since the multipath udev rules run first, so
>> _something_ is intereacting with the device early and making it busy,
>> I'm just not sure what right now.
>>=20
>> On Sun, Sep 22, 2024 at 6:55=E2=80=AFPM Coly Li <colyli@suse.de> =
wrote:
>>>=20
>>> Hi Mitchell,
>>>=20
>>> Yes I can see the log.
>>>=20
>>> [ 1.226296] device-mapper: multipath service-time: version 0.3.0 =
loaded
>>> [ 1.277039] device-mapper: table: 252:1: multipath: error getting =
device (-EBUSY)
>>> [ 1.277086] device-mapper: ioctl: error adding target to table
>>> [ 1.300407] bcache: bch_journal_replay() journal replay done, 0 keys =
in 1 entries, seq 1
>>> [ 1.301650] bcache: register_cache() registered cache device sdd
>>> [ 1.301748] bcache: register_cache_worker() error /dev/sdc: fail to =
register cache device
>>>=20
>>>=20
>>> =46rom the above lines, it seems device mapper starts early, but =
both dm and bcache encounter a busy device.
>>> Then bcache registered sdd successfully, and not register sdc. But I =
don=E2=80=99t see other information about how the backing device was =
registered.
>>>=20
>>> =46rom the following message,
>>> [ 4.049395] bcache: register_bcache() error : device already =
registered
>>> [ 4.268997] bcache: register_cache_worker() error /dev/sdc: fail to =
register cache device
>>>=20
>>> I assume sdc is the another path of sdd?
>>> =46rom the logs, it seems all bcache behaviors are expected, except =
for no backing device existed/registered.
>>>=20
>>> Also I see multipath rule might execute before bcache one, but =
explains =E2=80=9C[ 1.277039] device-mapper: table: 252:1: multipath: =
error getting device (-EBUSY)=E2=80=9D. I don=E2=80=99t know how it =
happens, but this is a suspicious one.
>>>=20
>>> Do you know why multipath failed to get device 252:1 ?  And why I =
don=E2=80=99t see backing device of bcache here ?
>>>=20
>>> Thanks.
>>>=20
>>> Coly Li
>>>=20
>>>> 2024=E5=B9=B49=E6=9C=8820=E6=97=A5 21:11=EF=BC=8CMitchell Dzurick =
<mitchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>>=20
>>>> Coly,
>>>>=20
>>>> Are you able to view this?
>>>>=20
>>>> https://gist.github.com/mitchdz/addb44425709fd6df5a6b1b91611b234
>>>>=20
>>>> -Mitch
>>>>=20
>>>> On Fri, Sep 20, 2024 at 5:51=E2=80=AFAM Mitchell Dzurick
>>>> <mitchell.dzurick@canonical.com> wrote:
>>>>>=20
>>>>> You are right, it seems to be something else than the udev rules. =
Let
>>>>> me paste the boot messages real quick.
>>>>>=20
>>>>> On Fri, Sep 20, 2024 at 5:42=E2=80=AFAM Coly Li <colyli@suse.de> =
wrote:
>>>>>>=20
>>>>>> On my distribution, I see multipath rules is 56-multipath.rules, =
it should be executed early than bcache one. I am not an systemd and =
boot expert, but what is the order of your multipath rules?
>>>>>>=20
>>>>>> Coly Li
>>>>>>=20
>>>>>>> 2024=E5=B9=B49=E6=9C=8820=E6=97=A5 19:24=EF=BC=8CMitchell =
Dzurick <mitchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>>>>>=20
>>>>>>> Coly,
>>>>>>>=20
>>>>>>> Yes, I made that observation in multipath-tools upstream bug[0].
>>>>>>>=20
>>>>>>> Ultimately the issue is that the bcache-tools udev rule runs
>>>>>>> bcache-register on the device and therefore it can't be opened =
by
>>>>>>> multipath tools.
>>>>>>>=20
>>>>>>> Therefore, the udev rule should wait to run until after =
multipath has
>>>>>>> a chance to make the maps. I'm not sure if there's any =
complications
>>>>>>> with moving the rules later into the boot process though, WDYT?
>>>>>>>=20
>>>>>>> -Mitch
>>>>>>>=20
>>>>>>> On Mon, Sep 9, 2024 at 8:56=E2=80=AFAM Coly Li <colyli@suse.de> =
wrote:
>>>>>>>>=20
>>>>>>>>=20
>>>>>>>>=20
>>>>>>>>> 2024=E5=B9=B49=E6=9C=886=E6=97=A5 07:37=EF=BC=8CMitchell =
Dzurick <mitchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>>>>>>>=20
>>>>>>>>> Thanks for the response Coly!
>>>>>>>>>=20
>>>>>>>>> Apologies on my delay, I was out for a bit and then was sick =
=3D=3D lots
>>>>>>>>> of catching up to do.
>>>>>>>>>=20
>>>>>>>>> Getting back to this, I do see that we have the bcache KCONFIG =
value enabled
>>>>>>>>>=20
>>>>>>>>> CONFIG_BCACHE_ASYNC_REGISTRATION=3Dy
>>>>>>>>>=20
>>>>>>>>> I don't believe this is a race condition issue. If I try to =
reload the
>>>>>>>>> devmap table with multipath-tools well after boot, I see the =
following
>>>>>>>>> in dmesg:
>>>>>>>>>=20
>>>>>>>>> $ sudo multipath -r
>>>>>>>>> [ 8758.157075] device-mapper: table: 252:3: multipath: error =
getting
>>>>>>>>> device (-EBUSY)
>>>>>>>>> [ 8758.158039] device-mapper: ioctl: error adding target to =
table
>>>>>>>>> [ 8758.256206] device-mapper: table: 252:3: multipath: error =
getting
>>>>>>>>> device (-EBUSY)
>>>>>>>>> [ 8758.256758] device-mapper: ioctl: error adding target to =
table
>>>>>>>>=20
>>>>>>>> When you see the above kernel message, can you check whether =
bcache device is initialized already?
>>>>>>>> Or you may post the boot time kernel message as attachment, or =
past it somewhere, then let me have a look.
>>>>>>>>=20
>>>>>>>> Thanks.
>>>>>>>>=20
>>>>>>>>=20
>>>>>>>> Coly Li
>>>>>>>>=20
>>>>>>>>=20
>>>>>>>>=20
>>>>>>>>=20
>>>>>>>>>=20
>>>>>>>>> FYI - Since I'm not sure if this is a bug in bcache-tools or
>>>>>>>>> multipath-tools, I also made an upstream bug report for
>>>>>>>>> multipath-tools at[0].
>>>>>>>>>=20
>>>>>>>>> If there is anything else you'd like me to try, let me know :)
>>>>>>>>>=20
>>>>>>>>> [0] - https://github.com/opensvc/multipath-tools/issues/96
>>>>>>>>>=20
>>>>>>>>> On Mon, Aug 12, 2024 at 12:17=E2=80=AFAM Coly Li =
<colyli@suse.de> wrote:
>>>>>>>>>>=20
>>>>>>>>>> Hi Mitchell,
>>>>>>>>>>=20
>>>>>>>>>>=20
>>>>>>>>>> It sounds like a timing issue of the initialization scripts. =
I assume the cache and backing devices are relative large, so the =
initialization takes time. And because the storage is not local, the =
remote link contributes more time to wait for the bcache device being =
ready.
>>>>>>>>>>=20
>>>>>>>>>> If this is the case, then you have to tune the multipath =
initialization to wait for longer, or compose a customized script to =
start services depending on bcache devices.
>>>>>>>>>>=20
>>>>>>>>>> BTW, I assume the bcache Kconfig =E2=80=9CAsynchronous device =
registration=E2=80=9D is checked/enabled. If not, maybe check it on can =
be a bit helpful.
>>>>>>>>>>=20
>>>>>>>>>> Just FYI.
>>>>>>>>>>=20
>>>>>>>>>> Coly Li
>>>>>>>>>>=20
>>>>>>>>>>> 2024=E5=B9=B48=E6=9C=8812=E6=97=A5 10:54=EF=BC=8CMitchell =
Dzurick <mitchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>>>>>>>>>=20
>>>>>>>>>>> Thanks for the reply Coly.
>>>>>>>>>>>=20
>>>>>>>>>>> I've been able to reproduce this in Ubuntu Noble and =
Oracular (24.04
>>>>>>>>>>> && 24.10). It should be an issue in Jammy but haven't tested =
that yet.
>>>>>>>>>>> The current kernel used in Oracular is 6.8.0-31.31 and the =
current
>>>>>>>>>>> kernel used in Noble is 6.8.0-40.40.
>>>>>>>>>>>=20
>>>>>>>>>>> Unfortunately you need an account to access pastebin. I can =
copy that
>>>>>>>>>>> information elsewhere for you if that would be helpful, but =
I can also
>>>>>>>>>>> just gather any extra information you may want from my =
testbed.
>>>>>>>>>>>=20
>>>>>>>>>>> I also have some steps in the bug report to reproduce this =
issue using kvm.
>>>>>>>>>>>=20
>>>>>>>>>>> Lastly, if there's any steps you'd like me to try or look =
into, I'd be
>>>>>>>>>>> glad to hear :)
>>>>>>>>>>>=20
>>>>>>>>>>> -Mitch
>>>>>>>>>>>=20
>>>>>>>>>>> On Sun, Aug 11, 2024 at 5:31=E2=80=AFAM Coly Li =
<colyli@suse.de> wrote:
>>>>>>>>>>>>=20
>>>>>>>>>>>>=20
>>>>>>>>>>>>=20
>>>>>>>>>>>>> 2024=E5=B9=B48=E6=9C=888=E6=97=A5 09:21=EF=BC=8CMitchell =
Dzurick <mitchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>>>>>>>>>>>=20
>>>>>>>>>>>>> Hello bcache team.
>>>>>>>>>>>>>=20
>>>>>>>>>>>>> I know this project is done and stable as [0] says, but I =
have a
>>>>>>>>>>>>> question if anyone is around to answer.
>>>>>>>>>>>>>=20
>>>>>>>>>>>>> Has bcache devices been tested and supported on =
multipath'd disks? I'm
>>>>>>>>>>>>> looking into an Ubuntu bug[1], where these 2 projects are =
clashing.
>>>>>>>>>>>>> I'm wondering if there was any consideration or support =
for
>>>>>>>>>>>>> multipathing when this project was made.
>>>>>>>>>>>>>=20
>>>>>>>>>>>>> Also, your new project, bcachefs, might be hitting the =
same scenario.
>>>>>>>>>>>>> I haven't had the time to test this though unfortunately.
>>>>>>>>>>>>>=20
>>>>>>>>>>>>> Thanks for your time,
>>>>>>>>>>>>> -Mitch
>>>>>>>>>>>>>=20
>>>>>>>>>>>>> [0] - https://bcache.evilpiepirate.org/#index4h1
>>>>>>>>>>>>> [1] - =
https://bugs.launchpad.net/ubuntu/+source/bcache-tools/+bug/1887558
>>>>>>>>>>>>>=20
>>>>>>>>>>>>=20
>>>>>>>>>>>> =46rom the Ubuntu bug report, I don=E2=80=99t see the =
kernel version. After parallel and asynchronous initialization was =
enabled, the udev rule won=E2=80=99t always occupy the bcache block =
device for long time.
>>>>>>>>>>>>=20
>>>>>>>>>>>> It might be a bit helpful if you may provide the kernel =
version and Ubuntu os version. BTW I don=E2=80=99t have ubuntu account =
and cannot access pastern.canonical.com.
>>>>>>>>>>>>=20
>>>>>>>>>>>> Thanks.
>>>>>>>>>>>>=20
>>>>>>>>>>>> Coly Li
>>>>>>>>>>>=20
>>>>>>>>>>=20
>>>>>>>>>=20
>>>>>>>>=20
>>>>>>=20
>>>>=20
>>>=20
>=20


