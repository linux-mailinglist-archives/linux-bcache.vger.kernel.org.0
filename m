Return-Path: <linux-bcache+bounces-425-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 829228BB30F
	for <lists+linux-bcache@lfdr.de>; Fri,  3 May 2024 20:28:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A00F41C209C9
	for <lists+linux-bcache@lfdr.de>; Fri,  3 May 2024 18:28:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 821B915821F;
	Fri,  3 May 2024 18:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QRypujeR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CFPk/Pl+";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JeD1kcRT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SJS20ZMc"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF31F41A80
	for <linux-bcache@vger.kernel.org>; Fri,  3 May 2024 18:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714760919; cv=none; b=N7dmwO4AgXzB7xFt/xUjpVxLzA+95uDnkGa3as90Xkj9Cfvx+e+qpV4AcrS4qbY08nWG9K6czbg4Eyzin/tk0j1ZXZ201/CDbZNHD+hjGGYWULZUNTr3oLYpm9skvgKr2brlvHaUy0LX6UJ1uTYQnD2kRMmD1tWiaMbY5Isq9ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714760919; c=relaxed/simple;
	bh=n8pbx/+cCqaG/FVyGTl0h6P+y28FX5EjxjbH71qltxA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=TqQTs2BD6mNZvLCYiwzdblkM9p6oE+d6dFu+LRmzvIKENn2xivwRsUGK7e9GaDT0jSoxfucN6AnTJMVA1KV2Vi1wG9LvyuUKNJ3nBCDNgAqS1uJey/EY38KN9OCfhvHyPCjfh4W8VG/1zOvCUyU4KjgcnLPUkGObTFmkIM/3+jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QRypujeR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CFPk/Pl+; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JeD1kcRT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SJS20ZMc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 160F9206BE;
	Fri,  3 May 2024 18:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714760916; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n8pbx/+cCqaG/FVyGTl0h6P+y28FX5EjxjbH71qltxA=;
	b=QRypujeR1GULuU88HTnU1Mx/6JvrE3on5e0IFLKSEtnYNTTdDUmy4VeYSVOTMoi7OJcEGG
	hUTHWtt0B6BpeS7AOVmly2+b3Ilo2FYt1EEpWT+yFy69dTmf0cVOCYwjpIyJ/W1au/cve3
	B5PijIhxVGqGv6bfxtZTvSncrNz3rXQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714760916;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n8pbx/+cCqaG/FVyGTl0h6P+y28FX5EjxjbH71qltxA=;
	b=CFPk/Pl+/oVg3oyDzd1KYyHLps6QQGlHdspQpRTiWMwp2f6Aj9bVIJcJSkWIKWwnDfgoGJ
	vvNJ40oN9I2eUEDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714760915; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n8pbx/+cCqaG/FVyGTl0h6P+y28FX5EjxjbH71qltxA=;
	b=JeD1kcRT5MtKEoiaB2fhEPZrWe/welezgErLSyDwHQfsU3vdmYZ0c651duzHnQa0DUNDbv
	FcdA4F66zxATvDE/p+NSA50iHPMUmqUXP+OHJyi3ZPPJFWu1Z/9j9D7ruZYsgirTOfWN5g
	feXWtyCCDwoGpsSaEBPU//d6ZZ57+pg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714760915;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n8pbx/+cCqaG/FVyGTl0h6P+y28FX5EjxjbH71qltxA=;
	b=SJS20ZMc0X7N3DSUsaNumu67hrSxwR/Sg8tPehctZ5eAqwSNTFaZVekuzZeYKnIC53qi/c
	3zSj6C4zbROdhwCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F1D4B13991;
	Fri,  3 May 2024 18:28:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cx0LK9EsNWYoYwAAD6G6ig
	(envelope-from <colyli@suse.de>); Fri, 03 May 2024 18:28:33 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH v2] bcache: allow allocator to invalidate bucket in gc
From: Coly Li <colyli@suse.de>
In-Reply-To: <5C71FFC2-B22E-4FC2-852F-F40BFDEDFB2C@suse.de>
Date: Sat, 4 May 2024 02:28:16 +0800
Cc: Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C659682B-4EAB-4022-A669-1574962ECE82@suse.de>
References: <1ddde040-9bde-515a-1d4d-b41de472a702@suse.de>
 <20240315224527.694458-1-robertpang@google.com>
 <584A2724-ACA2-4000-A8D2-50B6AA5684A7@suse.de>
 <CAJhEC06dsqq2y4MNCW7t52cPc1=PbStGTBOddZofg4vqGKkQsA@mail.gmail.com>
 <5B79FFA6-1995-4167-8318-3EDCC6F0B432@suse.de>
 <CAJhEC07hAWsW5Aq0=hCCAXJGKU47L_n8a0mQ-SjOq2wqGAj_gA@mail.gmail.com>
 <CAJhEC05TrboyqKAn0i5D72LWBs7bZ05qFrPedgmNWy8A7qYmOA@mail.gmail.com>
 <C787D2E8-6D03-4F4D-9633-2237AA0B2BE7@suse.de>
 <CAJhEC05hzf2zVyJabVExFNF0esiLovc+WLHOY_YhV22OUdGFZw@mail.gmail.com>
 <5C71FFC2-B22E-4FC2-852F-F40BFDEDFB2C@suse.de>
To: Robert Pang <robertpang@google.com>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>
X-Mailer: Apple Mail (2.3774.500.171.1.1)
X-Spam-Flag: NO
X-Spam-Score: -3.30
X-Spam-Level: 
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-2.51)[97.77%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MV_CASE(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.984];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]



> 2024=E5=B9=B45=E6=9C=884=E6=97=A5 02:23=EF=BC=8CColy Li =
<colyli@suse.de> =E5=86=99=E9=81=93=EF=BC=9A
>=20
>=20
>=20
>> 2024=E5=B9=B44=E6=9C=8811=E6=97=A5 14:44=EF=BC=8CRobert Pang =
<robertpang@google.com> =E5=86=99=E9=81=93=EF=BC=9A
>>=20
>> HI Coly
>>=20
>> Thank you for submitting it in the next merge window. This patch is
>> very critical because the long IO stall measured in tens of seconds
>> every hour is a serious issue making bcache unusable when it happens.
>> So we look forward to this patch.
>>=20
>> Speaking of this GC issue, we gathered the bcache btree GC stats =
after
>> our fio benchmark on a 375GB SSD cache device with 256kB bucket size:
>>=20
>> $ grep . =
/sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree_gc_*
>> =
/sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree_gc_aver=
age_duration_ms:45293
>> =
/sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree_gc_aver=
age_frequency_sec:286
>> =
/sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree_gc_last=
_sec:212
>> =
/sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree_gc_max_=
duration_ms:61986
>> $ more =
/sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree_nodes
>> 5876
>>=20
>> However, fio directly on the SSD device itself shows pretty good =
performance:
>>=20
>> Read IOPS 14,100 (110MiB/s)
>> Write IOPS 42,200 (330MiB/s)
>> Latency: 106.64 microseconds
>>=20
>> Can you shed some light on why CG takes so long (avg 45 seconds) =
given
>> the SSD speed? And is there any way or setting to reduce the CG time
>> or lower the GC frequency?
>>=20
>> One interesting thing we observed is when the SSD is encrypted via
>> dm-crypt, the GC time is shortened ~80% to be under 10 seconds. Is it
>> possible that GC writes the blocks one-by-one synchronously, and
>> dm-crypt's internal queuing and buffering mitigates the GC IO =
latency?
>=20
> Hi Robert,
>=20
> Can I know In which kernel version did you test the patch?
>=20

Sorry I missed a bit more information here.

> I do a patch rebase and apply it on Linux v6.9. With a 4TB SSD as =
cache device, I didn=E2=80=99t observe obvious performance advantage of =
this patch.

When I didn=E2=80=99t see obvious performance advantage, the testing was =
on a 512G Intel Optane memory (with pmem driver) as cache device.


> And occasionally I a bit more GC time. It might be from my rebase =
modification in bch_btree_gc_finish(),

And for the above situation, it was on a 4TB NVMe SSD.


I guess maybe it was from my improper patch rebase. Once Dongsheng posts =
a new version for the latest upstream kernel bcache code, I will test =
the patch again.


Thanks.

Coly Li=

