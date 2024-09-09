Return-Path: <linux-bcache+bounces-717-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E84BC971E82
	for <lists+linux-bcache@lfdr.de>; Mon,  9 Sep 2024 17:57:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF5FA1C21174
	for <lists+linux-bcache@lfdr.de>; Mon,  9 Sep 2024 15:56:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 097DF77110;
	Mon,  9 Sep 2024 15:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IBXAI00v";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1xAFjDpV";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="o4688HS7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4P2Ed/H2"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811331BC40
	for <linux-bcache@vger.kernel.org>; Mon,  9 Sep 2024 15:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725897416; cv=none; b=f+O8EYoJnG5Na6FSElUxnmM7SiCBZGyxz6NhrT7xnJYy++c2acAIzCf0pi6NYFnWvKHBQpBp3PTSozo0fPGH7uYEcoQV+O4us/6Xk5xE4sicdRSm9T3KUwa6F+rRikB807ZnTc4fc1kKsr6oOlloZ+szJRCncZgnLTeVSYaAbBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725897416; c=relaxed/simple;
	bh=6ttO2DyggUdTvmFzWjrvjhHUQTjoD8etzjR2gMR2LJw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=J9XDf0gCHKSf7Y2YONZoGRwKbzoiWdnzuxWH8iGam0nL7CN+TahZLnqtiHF6I9lnXUFURMYDzSe8cwiMyBWO6mEQzX1n1jSRoaQ7B3twHyVqjC+XnxQmvP/kbXDVrjuK7EJwQbwN5+smZLoipOjyclDlSY1uQSv2bE0XeHxoKUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IBXAI00v; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1xAFjDpV; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=o4688HS7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4P2Ed/H2; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7803B21A54;
	Mon,  9 Sep 2024 15:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1725897412; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6ttO2DyggUdTvmFzWjrvjhHUQTjoD8etzjR2gMR2LJw=;
	b=IBXAI00vp5gRhvcq4MV6XLzyywShYPyVoEVA7KHD3jPcM8vaHxf94s1kz7RwPqjr+AYBub
	/2JJdqrRWIOYL0pCijwo79RMDO7m8SlCdM3P9YKub/Hhr7UvuDlzlm68XOqGy0wOvbvAYF
	m8QsctyBF78m3Sh/IMicYVYfWjWOAak=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1725897412;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6ttO2DyggUdTvmFzWjrvjhHUQTjoD8etzjR2gMR2LJw=;
	b=1xAFjDpV+oeE+euhN00O+BjPN80EZBdSJWPQDGOCP66TbDSxr2h7XvXYJoQPSrjb8g5csh
	mPYEtAqePfRDd4AQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1725897411; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6ttO2DyggUdTvmFzWjrvjhHUQTjoD8etzjR2gMR2LJw=;
	b=o4688HS7oGcCAeF8u84tr8G+GUK/yss0E2FaSYng0YICxpvOiyYPHjUFicv8urZvujejR5
	4AWadUE4w6VjCrXoDe0pUet/MRAFcfVLLjdV1pZz5GQM6dezocPxRk4ViGA2W4TjdmyQsF
	eUJG/PL35YuTgjH81Bc2rVRfChvZQyY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1725897411;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6ttO2DyggUdTvmFzWjrvjhHUQTjoD8etzjR2gMR2LJw=;
	b=4P2Ed/H2Km9YoUIMm/i2P9OukZN9LyLXvH0TdVwTN/aBmGeagonlefla1DVSnqIbjpYY5O
	VdlP5K++ebGIqeBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A4F0A13312;
	Mon,  9 Sep 2024 15:56:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Uq2mGMIa32ZWIgAAD6G6ig
	(envelope-from <colyli@suse.de>); Mon, 09 Sep 2024 15:56:50 +0000
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
In-Reply-To: <CAG2GFaGFBGJwvK2hvQ-rgn3_vBHeapNzG9uSRHdagab3s8F9og@mail.gmail.com>
Date: Mon, 9 Sep 2024 23:56:35 +0800
Cc: Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <63707B6C-C735-4706-98E4-40C061F3FDB6@suse.de>
References: <CAG2GFaH3_Ux=Ewi_SOqpiDhF=qVDkX-sTBB8z75mm8LOd03tfw@mail.gmail.com>
 <08E9CAFD-1ECC-4B46-8F0D-7124716E76EF@suse.de>
 <CAG2GFaFQBkzhOJZedHPVdZLYRvU_XMs4MZ-4KKPkDUfbU9AfVg@mail.gmail.com>
 <BD613445-66A6-4B29-A62E-2340C97D831A@suse.de>
 <CAG2GFaGFBGJwvK2hvQ-rgn3_vBHeapNzG9uSRHdagab3s8F9og@mail.gmail.com>
To: Mitchell Dzurick <mitchell.dzurick@canonical.com>
X-Mailer: Apple Mail (2.3776.700.51)
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_DN_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	APPLE_MAILER_COMMON(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid,evilpiepirate.org:url,canonical.com:email,canonical.com:url,launchpad.net:url]
X-Spam-Score: -4.30
X-Spam-Flag: NO



> 2024=E5=B9=B49=E6=9C=886=E6=97=A5 07:37=EF=BC=8CMitchell Dzurick =
<mitchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Thanks for the response Coly!
>=20
> Apologies on my delay, I was out for a bit and then was sick =3D=3D =
lots
> of catching up to do.
>=20
> Getting back to this, I do see that we have the bcache KCONFIG value =
enabled
>=20
> CONFIG_BCACHE_ASYNC_REGISTRATION=3Dy
>=20
> I don't believe this is a race condition issue. If I try to reload the
> devmap table with multipath-tools well after boot, I see the following
> in dmesg:
>=20
> $ sudo multipath -r
> [ 8758.157075] device-mapper: table: 252:3: multipath: error getting
> device (-EBUSY)
> [ 8758.158039] device-mapper: ioctl: error adding target to table
> [ 8758.256206] device-mapper: table: 252:3: multipath: error getting
> device (-EBUSY)
> [ 8758.256758] device-mapper: ioctl: error adding target to table

When you see the above kernel message, can you check whether bcache =
device is initialized already?
Or you may post the boot time kernel message as attachment, or past it =
somewhere, then let me have a look.

Thanks.


Coly Li




>=20
> FYI - Since I'm not sure if this is a bug in bcache-tools or
> multipath-tools, I also made an upstream bug report for
> multipath-tools at[0].
>=20
> If there is anything else you'd like me to try, let me know :)
>=20
> [0] - https://github.com/opensvc/multipath-tools/issues/96
>=20
> On Mon, Aug 12, 2024 at 12:17=E2=80=AFAM Coly Li <colyli@suse.de> =
wrote:
>>=20
>> Hi Mitchell,
>>=20
>>=20
>> It sounds like a timing issue of the initialization scripts. I assume =
the cache and backing devices are relative large, so the initialization =
takes time. And because the storage is not local, the remote link =
contributes more time to wait for the bcache device being ready.
>>=20
>> If this is the case, then you have to tune the multipath =
initialization to wait for longer, or compose a customized script to =
start services depending on bcache devices.
>>=20
>> BTW, I assume the bcache Kconfig =E2=80=9CAsynchronous device =
registration=E2=80=9D is checked/enabled. If not, maybe check it on can =
be a bit helpful.
>>=20
>> Just FYI.
>>=20
>> Coly Li
>>=20
>>> 2024=E5=B9=B48=E6=9C=8812=E6=97=A5 10:54=EF=BC=8CMitchell Dzurick =
<mitchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> Thanks for the reply Coly.
>>>=20
>>> I've been able to reproduce this in Ubuntu Noble and Oracular (24.04
>>> && 24.10). It should be an issue in Jammy but haven't tested that =
yet.
>>> The current kernel used in Oracular is 6.8.0-31.31 and the current
>>> kernel used in Noble is 6.8.0-40.40.
>>>=20
>>> Unfortunately you need an account to access pastebin. I can copy =
that
>>> information elsewhere for you if that would be helpful, but I can =
also
>>> just gather any extra information you may want from my testbed.
>>>=20
>>> I also have some steps in the bug report to reproduce this issue =
using kvm.
>>>=20
>>> Lastly, if there's any steps you'd like me to try or look into, I'd =
be
>>> glad to hear :)
>>>=20
>>> -Mitch
>>>=20
>>> On Sun, Aug 11, 2024 at 5:31=E2=80=AFAM Coly Li <colyli@suse.de> =
wrote:
>>>>=20
>>>>=20
>>>>=20
>>>>> 2024=E5=B9=B48=E6=9C=888=E6=97=A5 09:21=EF=BC=8CMitchell Dzurick =
<mitchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>>>=20
>>>>> Hello bcache team.
>>>>>=20
>>>>> I know this project is done and stable as [0] says, but I have a
>>>>> question if anyone is around to answer.
>>>>>=20
>>>>> Has bcache devices been tested and supported on multipath'd disks? =
I'm
>>>>> looking into an Ubuntu bug[1], where these 2 projects are =
clashing.
>>>>> I'm wondering if there was any consideration or support for
>>>>> multipathing when this project was made.
>>>>>=20
>>>>> Also, your new project, bcachefs, might be hitting the same =
scenario.
>>>>> I haven't had the time to test this though unfortunately.
>>>>>=20
>>>>> Thanks for your time,
>>>>> -Mitch
>>>>>=20
>>>>> [0] - https://bcache.evilpiepirate.org/#index4h1
>>>>> [1] - =
https://bugs.launchpad.net/ubuntu/+source/bcache-tools/+bug/1887558
>>>>>=20
>>>>=20
>>>> =46rom the Ubuntu bug report, I don=E2=80=99t see the kernel =
version. After parallel and asynchronous initialization was enabled, the =
udev rule won=E2=80=99t always occupy the bcache block device for long =
time.
>>>>=20
>>>> It might be a bit helpful if you may provide the kernel version and =
Ubuntu os version. BTW I don=E2=80=99t have ubuntu account and cannot =
access pastern.canonical.com.
>>>>=20
>>>> Thanks.
>>>>=20
>>>> Coly Li
>>>=20
>>=20
>=20


