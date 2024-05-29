Return-Path: <linux-bcache+bounces-504-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B712A8D3C31
	for <lists+linux-bcache@lfdr.de>; Wed, 29 May 2024 18:24:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 446711F21E7D
	for <lists+linux-bcache@lfdr.de>; Wed, 29 May 2024 16:24:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A6011836CE;
	Wed, 29 May 2024 16:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zQev/5sg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zslQyD2O";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zQev/5sg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zslQyD2O"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3C71836E0
	for <linux-bcache@vger.kernel.org>; Wed, 29 May 2024 16:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716999859; cv=none; b=DYka4WPVqTlk5Ubi6va55Fvq3EK+cVWt9ik8opqO0ygUeYW+ZKNpx4kGi7ZdtmuKdfny/Pjyc6aopP+b8wFTKRx0Iqw7SRGF0a/RzMbUXvQsZ5ngjoMBbXlaoEoxck8QbalTmL9zUzxgKTEUPbBNYd5Cx9YMGz0p5h6XqR2XUQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716999859; c=relaxed/simple;
	bh=PV+V6nkrUKp8h/ornYSqFEh6NMsqtqO8pqXBDSI21qM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=eZHdkU1f43PJE5xWiwhPGrI2+5ZXi1fvFnH9aep7HKmU8/LgHIwul+00DGIOxF2nsJYlNfLY3DLSPI34A6fQEJ1U8kxPo0wub7Xe2owED2uL7QRZcKW+CtSuc8hg1yK7uHsTWT/4g2E6KnKGXumIDgQneygN8x+cwevyiIuHb30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zQev/5sg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zslQyD2O; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zQev/5sg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zslQyD2O; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 09120205B3;
	Wed, 29 May 2024 16:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716999856; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=McG+pvnhW1/ADyVgOQg7XqmWFHC0/ulAO4KqnAGksN8=;
	b=zQev/5sg8jH0pdnPOnMov5IlpeCYuKsfM+EuqV1c2a3PwJ7sFbbTJqbYk0jSZFrVlZXSFI
	XEAJOJPtNulcNpouzZ1d20n27ZwSFYOAQVB3iRPzNQkmakwxdbKrFGXYV8NyLwS54vzp+d
	DcCfQyp13tIIO+9tfab38YIFduo914E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716999856;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=McG+pvnhW1/ADyVgOQg7XqmWFHC0/ulAO4KqnAGksN8=;
	b=zslQyD2OTmOTKwWmhQ7vhfttNnS8LwslO9o4WXaF1cjEpk2/EUYUXCqlmOfCb1L1uroZaT
	oMrra69KcoBHrWCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716999856; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=McG+pvnhW1/ADyVgOQg7XqmWFHC0/ulAO4KqnAGksN8=;
	b=zQev/5sg8jH0pdnPOnMov5IlpeCYuKsfM+EuqV1c2a3PwJ7sFbbTJqbYk0jSZFrVlZXSFI
	XEAJOJPtNulcNpouzZ1d20n27ZwSFYOAQVB3iRPzNQkmakwxdbKrFGXYV8NyLwS54vzp+d
	DcCfQyp13tIIO+9tfab38YIFduo914E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716999856;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=McG+pvnhW1/ADyVgOQg7XqmWFHC0/ulAO4KqnAGksN8=;
	b=zslQyD2OTmOTKwWmhQ7vhfttNnS8LwslO9o4WXaF1cjEpk2/EUYUXCqlmOfCb1L1uroZaT
	oMrra69KcoBHrWCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E0C2F1372E;
	Wed, 29 May 2024 16:24:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dHCXIa5WV2bRBgAAD6G6ig
	(envelope-from <colyli@suse.de>); Wed, 29 May 2024 16:24:14 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.600.62\))
Subject: Re: [PATCH 2/3] bcache: call force_wake_up_gc() if necessary in
 check_should_bypass()
From: Coly Li <colyli@suse.de>
In-Reply-To: <915ded95-d5c1-7354-e3bd-2f71eabe36f9@ewheeler.net>
Date: Thu, 30 May 2024 00:23:52 +0800
Cc: Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <0C49E027-7963-477C-B0BE-82AA85A21718@suse.de>
References: <20240527174733.16351-1-colyli@suse.de>
 <1f87c967-d593-b11c-55e8-a2b7a0a75c2@ewheeler.net>
 <F380E42C-9F6A-4659-A3DF-EAB97E69073F@suse.de>
 <915ded95-d5c1-7354-e3bd-2f71eabe36f9@ewheeler.net>
To: Eric Wheeler <bcache@lists.ewheeler.net>
X-Mailer: Apple Mail (2.3774.600.62)
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]



> 2024=E5=B9=B45=E6=9C=8829=E6=97=A5 08:16=EF=BC=8CEric Wheeler =
<bcache@lists.ewheeler.net> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Tue, 28 May 2024, Coly Li wrote:
>>> 2024=E5=B9=B45=E6=9C=8828=E6=97=A5 06:31=EF=BC=8CEric Wheeler =
<bcache@lists.ewheeler.net> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> On Tue, 28 May 2024, Coly Li wrote:
>>>=20
>>>> If there are extreme heavy write I/O continuously hit on relative =
small
>>>> cache device (512GB in my testing), it is possible to make counter
>>>> c->gc_stats.in_use continue to increase and exceed =
CUTOFF_CACHE_ADD.
>>>>=20
>>>> If 'c->gc_stats.in_use > CUTOFF_CACHE_ADD' happens, all following =
write
>>>> requests will bypass the cache device because check_should_bypass()
>>>> returns 'true'. Because all writes bypass the cache device, counter
>>>> c->sectors_to_gc has no chance to be negative value, and garbage
>>>> collection thread won't be waken up even the whole cache becomes =
clean
>>>> after writeback accomplished. The aftermath is that all write I/Os =
go
>>>> directly into backing device even the cache device is clean.
>>>>=20
>>>> To avoid the above situation, this patch uses a quite conservative =
way
>>>> to fix: if 'c->gc_stats.in_use > CUTOFF_CACHE_ADD' happens, only =
wakes
>>>> up garbage collection thread when the whole cache device is clean.
>>>=20
>>> Nice fix.
>>>=20
>>> If I understand correctly, even with this fix, bcache can reach a =
point=20
>>> where it must wait until garbage collection frees a bucket (via=20
>>> force_wake_up_gc) before buckets can be used again.  Waiting to call=20=

>>> force_wake_up_gc until `c->gc_stats.in_use` exceeds CUTOFF_CACHE_ADD =
may=20
>>> not respond as fast as it could, and IO latency is important.
>>>=20
>>=20
>> CUTOFF_CACHE_ADD is not for this purpose.
>> GC is triggered by c->sectors_to_gc, it works as
>> - initialized as 1/16 size of cache device.
>> - every allocation decreases cached size from it.
>> - once c->sectors_go_gc is negative value, wakeup gc thread and reset =
the value to 1/16 size of cache device.
>>=20
>> CUTOFF_CACHE_ADD is to avoid something like no-space deadlock in =
cache=20
>> space. If cache space is allocated more than CUTOFF_CACHE_ADD (95%),=20=

>> cache space will not be allocated out anymore and all read/write will=20=

>> bypass and go directly into backing device. In my testing, after 10+=20=

>> hours I can see c->gc_stats.in_use is 96%. Which is a bit more than =
95%,=20
>> but c->sectors_go_gc is still larger than 0. This is how the=20
>> forever-bypass happens. It has nothing to do with the latency of =
neither=20
>> I/O nor gc.
>=20
> Understood, thank you for the explanation!
>=20
> You said that this bug exists an older version even though it is =
difficult=20
> trigger. Perhaps it is a good idea to CC stable:
>=20
> Cc: stable@vger.kernel.org
>=20

It is unnecessary to Cc stable, manually writing sysfs file trigger_gc =
can avoid the always-bypass situation.
This patch is to make the default configuration works without extra =
operation.



> Also,=20
> Reviewed-by: "Eric Wheeler" <bcache@linux.ewheeler.net>

Thanks for the review. Maybe it is a bit late to add the tag, I just =
found this series was in linux-block tree already and will show up in =
next -rc quite soon.

Thanks.

Coly Li


[snipped]


