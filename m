Return-Path: <linux-bcache+bounces-714-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D75F394E797
	for <lists+linux-bcache@lfdr.de>; Mon, 12 Aug 2024 09:17:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4114F1F237E6
	for <lists+linux-bcache@lfdr.de>; Mon, 12 Aug 2024 07:17:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12C7F14B952;
	Mon, 12 Aug 2024 07:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tMl3po9x";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1y0B5M7l";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AgPrHJfV";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vw97HRxf"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B23B45C0B
	for <linux-bcache@vger.kernel.org>; Mon, 12 Aug 2024 07:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723447057; cv=none; b=ecsKAPwCSBC0GfVCbjCHD/NXnC9YSdvyzwKbMGtAzOqJbMjeMYXdIgxcjJyElgBMOHfMQk4S2rQ0a+HMvXUA0h1oBTyJk2Dc81GHZS2byUIorydzmvdveSgx6wLvsW5WOqiWszbEuEknKcrgVn/JA+C/d7fIJdfesH2AGMUZcxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723447057; c=relaxed/simple;
	bh=ZZy9iZENB2gsQhbk9D0CN06NGQMk4S2ZGet4JgWCHgw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=XoR1BpPwGD4DLK7oAyHrsL7ZMWhRHzk7Y58S2i+hCrmJW4ZcHOg2QzMpclpZWPetrji87yanyCS12EfvJkKHQ7WFhRFrWruJXHmPkqY5r3EW9hhxRGMm94i+F5eOtaYTr494kuwnC98hOPRl36QNs2xirpmlZys8ABZGFsRkry8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tMl3po9x; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1y0B5M7l; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AgPrHJfV; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vw97HRxf; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D1AAE2022B;
	Mon, 12 Aug 2024 07:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723447053; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZy9iZENB2gsQhbk9D0CN06NGQMk4S2ZGet4JgWCHgw=;
	b=tMl3po9xgfRpY2v5eufmzMnI2HHHPx0WOITT9UA57tngPVCbXV0j2f+bvqRN3Sj8vmcray
	cgYOiEqpQliYTLJrHHpTTgFLWoz5X5NFYOHdH//lZRUzDY0HC/bRf3DcOffTSOdac6/sLp
	Qs9tKmOM5/ZkEOP6gVjHE5XFynBFlsQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723447053;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZy9iZENB2gsQhbk9D0CN06NGQMk4S2ZGet4JgWCHgw=;
	b=1y0B5M7lrjghk9KEZqexeqM9vQ4feDb2Sy4zehGgpMHEBqgxD9ploodK0kmujkvD67RbaM
	TEAxdYoE4w6lUADg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=AgPrHJfV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vw97HRxf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723447051; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZy9iZENB2gsQhbk9D0CN06NGQMk4S2ZGet4JgWCHgw=;
	b=AgPrHJfVv0RZjVm/l13yfvtGpVqqSB1N1nd19WX3y+iRC/BBs+E4jbtaNxywqsE9vWzkY2
	WCEv4Kfvkg+awDQey9rJmGh+79VJzubGviXhH5G9ShiwgbiKBo/oCSjuHlZ6ULRzgAYfEX
	KXOTcAHgAafVNkI1lLoAJ+SKcCVsrSs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723447051;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZy9iZENB2gsQhbk9D0CN06NGQMk4S2ZGet4JgWCHgw=;
	b=vw97HRxfjY8mGd4OxDN4trxBmUYHgXrau0BlVdNECnifT9eBqJyOi43uPy45Qt4GiK4+Vq
	uxmKCRZjZIQk55AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AF211137BA;
	Mon, 12 Aug 2024 07:17:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fZPKFAq3uWa6CgAAD6G6ig
	(envelope-from <colyli@suse.de>); Mon, 12 Aug 2024 07:17:30 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.600.62\))
Subject: Re: multipath'd bcache device
From: Coly Li <colyli@suse.de>
In-Reply-To: <CAG2GFaFQBkzhOJZedHPVdZLYRvU_XMs4MZ-4KKPkDUfbU9AfVg@mail.gmail.com>
Date: Mon, 12 Aug 2024 15:17:10 +0800
Cc: Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <BD613445-66A6-4B29-A62E-2340C97D831A@suse.de>
References: <CAG2GFaH3_Ux=Ewi_SOqpiDhF=qVDkX-sTBB8z75mm8LOd03tfw@mail.gmail.com>
 <08E9CAFD-1ECC-4B46-8F0D-7124716E76EF@suse.de>
 <CAG2GFaFQBkzhOJZedHPVdZLYRvU_XMs4MZ-4KKPkDUfbU9AfVg@mail.gmail.com>
To: Mitchell Dzurick <mitchell.dzurick@canonical.com>
X-Mailer: Apple Mail (2.3774.600.62)
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: D1AAE2022B
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	APPLE_MAILER_COMMON(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[canonical.com:email,canonical.com:url,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email,evilpiepirate.org:url,launchpad.net:url]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Spam-Flag: NO

Hi Mitchell,


It sounds like a timing issue of the initialization scripts. I assume =
the cache and backing devices are relative large, so the initialization =
takes time. And because the storage is not local, the remote link =
contributes more time to wait for the bcache device being ready.

If this is the case, then you have to tune the multipath initialization =
to wait for longer, or compose a customized script to start services =
depending on bcache devices.=20

BTW, I assume the bcache Kconfig =E2=80=9CAsynchronous device =
registration=E2=80=9D is checked/enabled. If not, maybe check it on can =
be a bit helpful.

Just FYI.

Coly Li=20

> 2024=E5=B9=B48=E6=9C=8812=E6=97=A5 10:54=EF=BC=8CMitchell Dzurick =
<mitchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Thanks for the reply Coly.
>=20
> I've been able to reproduce this in Ubuntu Noble and Oracular (24.04
> && 24.10). It should be an issue in Jammy but haven't tested that yet.
> The current kernel used in Oracular is 6.8.0-31.31 and the current
> kernel used in Noble is 6.8.0-40.40.
>=20
> Unfortunately you need an account to access pastebin. I can copy that
> information elsewhere for you if that would be helpful, but I can also
> just gather any extra information you may want from my testbed.
>=20
> I also have some steps in the bug report to reproduce this issue using =
kvm.
>=20
> Lastly, if there's any steps you'd like me to try or look into, I'd be
> glad to hear :)
>=20
> -Mitch
>=20
> On Sun, Aug 11, 2024 at 5:31=E2=80=AFAM Coly Li <colyli@suse.de> =
wrote:
>>=20
>>=20
>>=20
>>> 2024=E5=B9=B48=E6=9C=888=E6=97=A5 09:21=EF=BC=8CMitchell Dzurick =
<mitchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> Hello bcache team.
>>>=20
>>> I know this project is done and stable as [0] says, but I have a
>>> question if anyone is around to answer.
>>>=20
>>> Has bcache devices been tested and supported on multipath'd disks? =
I'm
>>> looking into an Ubuntu bug[1], where these 2 projects are clashing.
>>> I'm wondering if there was any consideration or support for
>>> multipathing when this project was made.
>>>=20
>>> Also, your new project, bcachefs, might be hitting the same =
scenario.
>>> I haven't had the time to test this though unfortunately.
>>>=20
>>> Thanks for your time,
>>> -Mitch
>>>=20
>>> [0] - https://bcache.evilpiepirate.org/#index4h1
>>> [1] - =
https://bugs.launchpad.net/ubuntu/+source/bcache-tools/+bug/1887558
>>>=20
>>=20
>> =46rom the Ubuntu bug report, I don=E2=80=99t see the kernel version. =
After parallel and asynchronous initialization was enabled, the udev =
rule won=E2=80=99t always occupy the bcache block device for long time.
>>=20
>> It might be a bit helpful if you may provide the kernel version and =
Ubuntu os version. BTW I don=E2=80=99t have ubuntu account and cannot =
access pastern.canonical.com.
>>=20
>> Thanks.
>>=20
>> Coly Li
>=20


