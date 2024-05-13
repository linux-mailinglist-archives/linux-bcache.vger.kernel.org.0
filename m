Return-Path: <linux-bcache+bounces-436-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D428B8C3C34
	for <lists+linux-bcache@lfdr.de>; Mon, 13 May 2024 09:44:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88A7F281A5B
	for <lists+linux-bcache@lfdr.de>; Mon, 13 May 2024 07:44:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 356D6145B30;
	Mon, 13 May 2024 07:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rom1+rKG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RwaBQCrf";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rom1+rKG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RwaBQCrf"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6268033985
	for <linux-bcache@vger.kernel.org>; Mon, 13 May 2024 07:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715586238; cv=none; b=jXwhpCxXbS11A62XeFL8Kbm/Zj7trDacP79RbLRYq8obvipb+MFPmt2Cvuq2UizMy+mY8foPESwMxmn4OmDi50pB/x3CIV6INuRfGe5sUVam95f1JuxoSpwWw2LBX3grncbWEeQ9c/oJeTk0rO5I8LZZFouLB5qHU+8Lg0Q4kOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715586238; c=relaxed/simple;
	bh=JIK3GgEu37PPIgW4JOdf02NFrVD4GMAVu9iqeC5YqDo=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=TVM4P+3mVfKUyDapmRZTui1MMhgGHIJbFJPkbBNLV3/TcLzHrwJ2YSEBLQnYHzXqAGQl6SdpDd1s0TbUWYbAuCfsVpnRl6/ldf9Lwk6C/DTuw20PbZ/Y1RFlUuuImfSzC/Pts/OvcmOoRbPKa7qQY3CHMbIJGjE/0NwWoA3U9jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rom1+rKG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RwaBQCrf; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rom1+rKG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RwaBQCrf; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 80E391FE84;
	Mon, 13 May 2024 07:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1715586234; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PnzWqpEMXF+X/fadNAN1OM8H5alnNYYzVFLYMtzthg4=;
	b=rom1+rKG+lInGsl5DrvKncSDUJW4oI6FFigki8/CP+ewE/d130OJ1o4+VBQuB32nKLsgHh
	76WsnZWAuboWotnVCffYGQpujRFIpIw1fLey0mN9Ty8P2vmMeWGSYFQF7147Hc5QzncYK3
	vDMIhiNH6yAn24tOMgej8mvquvI16VI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1715586234;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PnzWqpEMXF+X/fadNAN1OM8H5alnNYYzVFLYMtzthg4=;
	b=RwaBQCrfjFCaQXxspzBsxQFaioHzrZomhaZOJIrHVPHSPiJQofEOZu+hgifMCRq66+k/fO
	XKQM/G3hPKtP+/Ag==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rom1+rKG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RwaBQCrf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1715586234; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PnzWqpEMXF+X/fadNAN1OM8H5alnNYYzVFLYMtzthg4=;
	b=rom1+rKG+lInGsl5DrvKncSDUJW4oI6FFigki8/CP+ewE/d130OJ1o4+VBQuB32nKLsgHh
	76WsnZWAuboWotnVCffYGQpujRFIpIw1fLey0mN9Ty8P2vmMeWGSYFQF7147Hc5QzncYK3
	vDMIhiNH6yAn24tOMgej8mvquvI16VI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1715586234;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PnzWqpEMXF+X/fadNAN1OM8H5alnNYYzVFLYMtzthg4=;
	b=RwaBQCrfjFCaQXxspzBsxQFaioHzrZomhaZOJIrHVPHSPiJQofEOZu+hgifMCRq66+k/fO
	XKQM/G3hPKtP+/Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 22ADB13A5B;
	Mon, 13 May 2024 07:43:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JFCdNLjEQWaxIgAAD6G6ig
	(envelope-from <colyli@suse.de>); Mon, 13 May 2024 07:43:52 +0000
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
In-Reply-To: <CAJhEC04czCGuwdS3AC8JdzKax4aX9i4D7BJ01xgi3PKCpgzwzw@mail.gmail.com>
Date: Mon, 13 May 2024 15:43:36 +0800
Cc: Dongsheng Yang <dongsheng.yang@easystack.cn>,
 =?utf-8?B?6YK55piO5ZOy?= <mingzhe.zou@easystack.cn>,
 Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1B20E890-F136-496B-AF1F-C09DB0B45BE8@suse.de>
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
 <C659682B-4EAB-4022-A669-1574962ECE82@suse.de>
 <CAJhEC04+VUKqUpMfACF0pSiwtdaJaOsb50dp_VbyhahPS6KE5A@mail.gmail.com>
 <82DDC16E-F4BF-4F8D-8DB8-352D9A6D9AF5@suse.de>
 <ea18e5b9-2d10-c459-ffec-fe7012fad345@easystack.cn>
 <CAJhEC04czCGuwdS3AC8JdzKax4aX9i4D7BJ01xgi3PKCpgzwzw@mail.gmail.com>
To: Robert Pang <robertpang@google.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)
X-Spam-Flag: NO
X-Spam-Score: -5.01
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 80E391FE84
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-5.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_LOW(-1.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim];
	TO_DN_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]



> 2024=E5=B9=B45=E6=9C=8812=E6=97=A5 13:43=EF=BC=8CRobert Pang =
<robertpang@google.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Coly
>=20
> I see that Mingzhe has submitted the rebased patch [1]. Do you have a
> chance to reproduce the stall and test the patch? Are we on track to
> submit this patch upstream in the coming 6.10 merge window? Do you
> need any help or more info?
>=20

Hi Robert,

Please don=E2=80=99t push me. The first wave of bcache-6.10 is in =
linux-next now. For this patch, I need to do more pressure testing, to =
make me comfortable that no-space deadlock won=E2=80=99t be triggered.

The testing is simple, using small I/O size (512Bytes to 4KB) to do =
random write on writeback mode cache for long time (24-48 hours), see =
whether there is any warning or deadlock happens.

For me, my tests covers cache size from 256G/512G/1T/4T cache size with =
20-24 CPU cores. If you may help to test on more machine and =
configuration, that will be helpful.

I trust you and Zheming for the allocation latency measurement, now I =
need to confirm that offering allocation more priority than GC won=E2=80=99=
t trigger potential no-space deadlock in practice.

Thanks.

Coly Li


>=20
>=20
> [1] =
https://lore.kernel.org/linux-bcache/1596418224.689.1715223543586.JavaMail=
.hmail@wm-bj-12-entmail-virt53.gy.ntes/T/#u
>=20
>=20
> On Tue, May 7, 2024 at 7:34=E2=80=AFPM Dongsheng Yang
> <dongsheng.yang@easystack.cn> wrote:
>>=20
>>=20
>>=20
>> =E5=9C=A8 2024/5/4 =E6=98=9F=E6=9C=9F=E5=85=AD =E4=B8=8A=E5=8D=88 =
11:08, Coly Li =E5=86=99=E9=81=93:
>>>=20
>>>=20
>>>> 2024=E5=B9=B45=E6=9C=884=E6=97=A5 10:04=EF=BC=8CRobert Pang =
<robertpang@google.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>>=20
>>>> Hi Coly,
>>>>=20
>>>>> Can I know In which kernel version did you test the patch?
>>>>=20
>>>> I tested in both Linux kernels 5.10 and 6.1.
>>>>=20
>>>>> I didn=E2=80=99t observe obvious performance advantage of this =
patch.
>>>>=20
>>>> This patch doesn't improve bcache performance. Instead, it =
eliminates the IO stall in bcache that happens due to =
bch_allocator_thread() getting blocked and waiting on GC to finish when =
GC happens.
>>>>=20
>>>> /*
>>>> * We've run out of free buckets, we need to find some buckets
>>>> * we can invalidate. First, invalidate them in memory and add
>>>> * them to the free_inc list:
>>>> */
>>>> retry_invalidate:
>>>> allocator_wait(ca, ca->set->gc_mark_valid &&  <--------
>>>>        !ca->invalidate_needs_gc);
>>>> invalidate_buckets(ca);
>>>>=20
>>>> =46rom what you showed, it looks like your rebase is good. As you =
already noticed, the original patch was based on 4.x kernel so the =
bucket traversal in btree.c needs to be adapted for 5.x and 6.x kernels. =
I attached the patch rebased to 6.9 HEAD for your reference.
>>>>=20
>>>> But to observe the IO stall before the patch, please test with a =
read-write workload so GC will happen periodically enough (read-only or =
read-mostly workload doesn't show the problem). For me, I used the "fio" =
utility to generate a random read-write workload as follows.
>>>>=20
>>>> # Pre-generate a 900GB test file
>>>> $ truncate -s 900G test
>>>>=20
>>>> # Run random read-write workload for 1 hour
>>>> $ fio --time_based --runtime=3D3600s --ramp_time=3D2s =
--ioengine=3Dlibaio --name=3Dlatency_test --filename=3Dtest --bs=3D8k =
--iodepth=3D1 --size=3D900G  --readwrite=3Drandrw --verify=3D0 =
--filename=3Dfio --write_lat_log=3Dlat --log_avg_msec=3D1000 =
--log_max_value=3D1
>>>>=20
>>>> We include the flags "--write_lat_log=3Dlat --log_avg_msec=3D1000 =
--log_max_value=3D1" so fio will dump the second-by-second max latency =
into a log file at the end of test so we can when stall happens and for =
how long:
>>>>=20
>>>=20
>>> Copied. Thanks for the information. Let me try the above command =
lines on my local machine with longer time.
>>>=20
>>>=20
>>>=20
>>>> E.g.
>>>>=20
>>>> $ more lat_lat.1.log
>>>> (format: <time-ms>,<max-latency-ns>,,,)
>>>> ...
>>>> 777000, 5155548, 0, 0, 0
>>>> 778000, 105551, 1, 0, 0
>>>> 802615, 24276019570, 0, 0, 0 <---- stalls for 24s with no IO =
possible
>>>> 802615, 82134, 1, 0, 0
>>>> 804000, 9944554, 0, 0, 0
>>>> 805000, 7424638, 1, 0, 0
>>>>=20
>>>> I used a 375 GB local SSD (cache device) and a 1 TB =
network-attached storage (backing device). In the 1-hr run, GC starts =
happening about 10 minutes into the run and then happens at ~ 5 minute =
intervals. The stall duration ranges from a few seconds at the beginning =
to close to 40 seconds towards the end. Only about 1/2 to 2/3 of the =
cache is used by the end.
>>>>=20
>>>> Note that this patch doesn't shorten the GC either. Instead, it =
just avoids GC from blocking the allocator thread by first sweeping the =
buckets and marking reclaimable ones quickly at the beginning of GC so =
the allocator can proceed while GC continues its actual job.
>>>>=20
>>>> We are eagerly looking forward to this patch to be merged in this =
coming merge window that is expected to open in a week to two.
>>>=20
>>> In order to avoid the no-space deadlock, normally there are around =
10% space will not be allocated out. I need to look more close onto this =
patch.
>>>=20
>>>=20
>>> Dongsheng Yang,
>>>=20
>>> Could you please post a new version based on current mainline kernel =
code ?
>>=20
>> Hi Coly,
>>        Mingzhe will send a new version based on mainline.
>>=20
>> Thanx
>>>=20
>>> Thanks.
>>>=20
>>> Coly Li
>>>=20
>>>=20
>>>=20


