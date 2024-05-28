Return-Path: <linux-bcache+bounces-496-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B270D8D1282
	for <lists+linux-bcache@lfdr.de>; Tue, 28 May 2024 05:24:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C38A1F22F3F
	for <lists+linux-bcache@lfdr.de>; Tue, 28 May 2024 03:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDA5C10957;
	Tue, 28 May 2024 03:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LiJGfPSa";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Ag+iIl2Q";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LiJGfPSa";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Ag+iIl2Q"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182C115BB
	for <linux-bcache@vger.kernel.org>; Tue, 28 May 2024 03:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716866668; cv=none; b=gW4KPZTAwfscMLBmCYbkRrUQI/M088T8TF0O5S3Ifou9Jvwt9Kty+lK4MBb4wjNiMfB79FiyW1UnUfkvUdYzDaa6BRp4suTbDt/bva6OtoqwniQJ3GZ51ZUy1tCt7lrcc16eIV+Vf8hpe1G/9qZRIHK12DC5RkYTtSM6SEo7a/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716866668; c=relaxed/simple;
	bh=3bZ5aRWIDaHkEdPRLltkCqU7KRxglRGw+ef41JpWj2k=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=eYDE33DvRxeA0zZLiSt3rx9bH2klFKpu752HEypIHbmPEDwGmRGWSeqqPjcMoQ3l0kMx69gPjRZc175NsWf2PdLZ4maZL9TSGk4nnD0bfczwfLZeiIOHBF6mVqGOqVF5Bbuc26Q+QR0hqpDITcQPMzc9RiGI36z+duIv0eErk5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LiJGfPSa; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Ag+iIl2Q; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LiJGfPSa; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Ag+iIl2Q; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 06AF11FF7E;
	Tue, 28 May 2024 03:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716866665; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9xlVACu/bPwknAcao5PRPnXcVPFBPXcYFZr8GwOHuPY=;
	b=LiJGfPSazx7oHCHF1Vk9WorW2GTlkNA2HCkCYdKFZwBBi561Gsz3zHBoPlF4dkAfBPc3Zq
	FXrsSFWNOzSHoUoN4S8Wmuytr4xa6wc2p4lPYmwvLh1RhKVOM+9mf/Vt5SazH7ST3P9Lm3
	Edn0PP1oyruI7dyvIJJwtL2z0C96WEs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716866665;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9xlVACu/bPwknAcao5PRPnXcVPFBPXcYFZr8GwOHuPY=;
	b=Ag+iIl2QNH1viCH8Snn+/53E4dsJmPJI+qjJIVq416SV6lawTeQoPkpwEHMUS2o7Hjj2qK
	oRAENBmwAxDl2oBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716866665; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9xlVACu/bPwknAcao5PRPnXcVPFBPXcYFZr8GwOHuPY=;
	b=LiJGfPSazx7oHCHF1Vk9WorW2GTlkNA2HCkCYdKFZwBBi561Gsz3zHBoPlF4dkAfBPc3Zq
	FXrsSFWNOzSHoUoN4S8Wmuytr4xa6wc2p4lPYmwvLh1RhKVOM+9mf/Vt5SazH7ST3P9Lm3
	Edn0PP1oyruI7dyvIJJwtL2z0C96WEs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716866665;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9xlVACu/bPwknAcao5PRPnXcVPFBPXcYFZr8GwOHuPY=;
	b=Ag+iIl2QNH1viCH8Snn+/53E4dsJmPJI+qjJIVq416SV6lawTeQoPkpwEHMUS2o7Hjj2qK
	oRAENBmwAxDl2oBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D8EF113A55;
	Tue, 28 May 2024 03:24:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VYYBH2dOVWafDgAAD6G6ig
	(envelope-from <colyli@suse.de>); Tue, 28 May 2024 03:24:23 +0000
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
In-Reply-To: <1f87c967-d593-b11c-55e8-a2b7a0a75c2@ewheeler.net>
Date: Tue, 28 May 2024 11:24:05 +0800
Cc: Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F380E42C-9F6A-4659-A3DF-EAB97E69073F@suse.de>
References: <20240527174733.16351-1-colyli@suse.de>
 <1f87c967-d593-b11c-55e8-a2b7a0a75c2@ewheeler.net>
To: Eric Wheeler <bcache@lists.ewheeler.net>
X-Mailer: Apple Mail (2.3774.600.62)
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.994];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	APPLE_MAILER_COMMON(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+]



> 2024=E5=B9=B45=E6=9C=8828=E6=97=A5 06:31=EF=BC=8CEric Wheeler =
<bcache@lists.ewheeler.net> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Tue, 28 May 2024, Coly Li wrote:
>=20
>> If there are extreme heavy write I/O continuously hit on relative =
small
>> cache device (512GB in my testing), it is possible to make counter
>> c->gc_stats.in_use continue to increase and exceed CUTOFF_CACHE_ADD.
>>=20
>> If 'c->gc_stats.in_use > CUTOFF_CACHE_ADD' happens, all following =
write
>> requests will bypass the cache device because check_should_bypass()
>> returns 'true'. Because all writes bypass the cache device, counter
>> c->sectors_to_gc has no chance to be negative value, and garbage
>> collection thread won't be waken up even the whole cache becomes =
clean
>> after writeback accomplished. The aftermath is that all write I/Os go
>> directly into backing device even the cache device is clean.
>>=20
>> To avoid the above situation, this patch uses a quite conservative =
way
>> to fix: if 'c->gc_stats.in_use > CUTOFF_CACHE_ADD' happens, only =
wakes
>> up garbage collection thread when the whole cache device is clean.
>=20
> Nice fix.
>=20
> If I understand correctly, even with this fix, bcache can reach a =
point=20
> where it must wait until garbage collection frees a bucket (via=20
> force_wake_up_gc) before buckets can be used again.  Waiting to call=20=

> force_wake_up_gc until `c->gc_stats.in_use` exceeds CUTOFF_CACHE_ADD =
may=20
> not respond as fast as it could, and IO latency is important.
>=20

CUTOFF_CACHE_ADD is not for this purpose.
GC is triggered by c->sectors_to_gc, it works as
- initialized as 1/16 size of cache device.
- every allocation decreases cached size from it.
- once c->sectors_go_gc is negative value, wakeup gc thread and reset =
the value to 1/16 size of cache device.

CUTOFF_CACHE_ADD is to avoid something like no-space deadlock in cache =
space. If cache space is allocated more than CUTOFF_CACHE_ADD (95%), =
cache space will not be allocated out anymore and all read/write will =
bypass and go directly into backing device. In my testing, after 10+ =
hours I can see c->gc_stats.in_use is 96%. Which is a bit more than 95%, =
but c->sectors_go_gc is still larger than 0. This is how the =
forever-bypass happens. It has nothing to do with the latency of neither =
I/O nor gc.


> It may be a good idea to do `c->gc_stats.in_use > CUTOFF_CACHE_ADD/2` =
to
> start garbage collection when it is half-way "full".
>=20

No, it is not designed to work in this way. By the above change, all I/O =
will bypass the cache device and go directly into backing device when =
cache device is occupied only 50% space.



> Reaching 50% is still quite conservative, but if you want to wait =
longer,=20
> then even 80% or 90% would be fine; however, I think 100% is too far.  =
We=20
> want to avoid the case where bcache is completely "out" of buckets and =
we=20
> have to wait for garbage collection latency before a cache bucket can=20=

> fill, since buckets should be available.
>=20
> For example on our system we have 736824 buckets available:
> # cat /sys/devices/virtual/block/dm-9/bcache/nbuckets
> 736824
>=20
> There should be no reason to wait until all buckets are exhausted. =
Forcing=20
> garbage collection at 50% (368412 buckets "in use") would be good =
house=20
> keeping.
>=20
> You know this code very well so if I have misinterpreted something =
here,=20
> then please fill me in on the details.

As I said, this patch is just to avoid a forever-bypass condition, and =
this is an extreme condition which is rare to happen for normal =
workload.

Thanks.

Coly Li=

