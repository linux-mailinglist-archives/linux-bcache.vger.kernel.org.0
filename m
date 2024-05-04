Return-Path: <linux-bcache+bounces-427-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 845558BB954
	for <lists+linux-bcache@lfdr.de>; Sat,  4 May 2024 05:08:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8AD91C22152
	for <lists+linux-bcache@lfdr.de>; Sat,  4 May 2024 03:08:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DC8228E6;
	Sat,  4 May 2024 03:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="h9AZuXEM";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hDGfCDOS";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JnY1tiPm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jVyyQvqR"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B442B79D1
	for <linux-bcache@vger.kernel.org>; Sat,  4 May 2024 03:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714792128; cv=none; b=pjT2xYeuBahOyV8xoQrYCTl12SYF4juiYAVOzSCQRcxj8FHPbWC/6oPP2mWbaJdV2ulY4rQ9VrfngxRpRfPlF0X01FhBpCi4xEwTNPv6A5LfOY4CF+rq2beYcoqAhijoLeaKWwzUtw6hLI2j2MRy9SYEh7FwI8jArbgR+nm/wa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714792128; c=relaxed/simple;
	bh=Mts0jZcjPI1zCn8A1pUdpswGuyp2SUErKdE0sLzeYYQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=n2CnS06KHCNHMVxCPLObhy6mxGM4ef0UOWiKTt2Pbtl54YZn2XQG5IaSykTVn+UcsIViQhQsET4ByzDDWlWrqWC7TVN3kxWsFod7UJzvsxnjfUUXkz5nvw373S2AlkF2IXdopIFNSVxrqhfmYbj8bPUVnBuTp5hstrpF160IQPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=h9AZuXEM; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hDGfCDOS; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JnY1tiPm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jVyyQvqR; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E341420AA1;
	Sat,  4 May 2024 03:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714792125; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=shp8bZJ9S+t4znTCbvcVLNeu5EIxT0GOYmS1NtjMdIA=;
	b=h9AZuXEMM3iazIFgz3E3cnL2puSmAqHM52Kd0HBOMyCAnfutiQY9VQzYmRp7UsqNWWhtsN
	EFo9/7vPrmNWn4yUVjtj74dRtCdFymeA7tQikHB/1P/eahi1OLcHecdAXrnUqnO6nVR3dZ
	2+gAG3FOyzhseuAPPdMpgh47J5XT3Q4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714792125;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=shp8bZJ9S+t4znTCbvcVLNeu5EIxT0GOYmS1NtjMdIA=;
	b=hDGfCDOS+fikFJT4Eit2drdllDr4nIrnmEIzWj2jWaa4FcWn7wBFrrNerSJAdH6S8Q8a6f
	sTeICDQ81ES0pVDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714792124; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=shp8bZJ9S+t4znTCbvcVLNeu5EIxT0GOYmS1NtjMdIA=;
	b=JnY1tiPme0/4uyH/jmyAysXPM6KS9bF+4TIXYv09Qt/85co7eHhFOFcH7sFv1cKOliB39P
	DC13W8cUMsZ45IkDSv305BnsslUU6HsGauyj9BsIuTbdje3+5h9dU4v5lgK67Q7e5I6L/I
	9eRruNnfCjrFZlnBrYQ8dv5W1zlOgNQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714792124;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=shp8bZJ9S+t4znTCbvcVLNeu5EIxT0GOYmS1NtjMdIA=;
	b=jVyyQvqRrDJsHzXV1SgyKrDOcnvRlSi/3m2v6nEDY7faBUXp9oYwFh52/qFi4OmAdKuO6p
	rVBr/xIYL7UGvvCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 36A4513991;
	Sat,  4 May 2024 03:08:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FUFRMrqmNWZ9YwAAD6G6ig
	(envelope-from <colyli@suse.de>); Sat, 04 May 2024 03:08:42 +0000
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
In-Reply-To: <CAJhEC04+VUKqUpMfACF0pSiwtdaJaOsb50dp_VbyhahPS6KE5A@mail.gmail.com>
Date: Sat, 4 May 2024 11:08:22 +0800
Cc: Dongsheng Yang <dongsheng.yang@easystack.cn>,
 Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <82DDC16E-F4BF-4F8D-8DB8-352D9A6D9AF5@suse.de>
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
To: Robert Pang <robertpang@google.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MV_CASE(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_THREE(0.00)[3]



> 2024=E5=B9=B45=E6=9C=884=E6=97=A5 10:04=EF=BC=8CRobert Pang =
<robertpang@google.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Coly,
>=20
> > Can I know In which kernel version did you test the patch?
>=20
> I tested in both Linux kernels 5.10 and 6.1.
>=20
> > I didn=E2=80=99t observe obvious performance advantage of this =
patch.
>=20
> This patch doesn't improve bcache performance. Instead, it eliminates =
the IO stall in bcache that happens due to bch_allocator_thread() =
getting blocked and waiting on GC to finish when GC happens.
>=20
> /*
> * We've run out of free buckets, we need to find some buckets
> * we can invalidate. First, invalidate them in memory and add
> * them to the free_inc list:
> */
> retry_invalidate:
> allocator_wait(ca, ca->set->gc_mark_valid &&  <--------
>        !ca->invalidate_needs_gc);
> invalidate_buckets(ca);
>=20
> =46rom what you showed, it looks like your rebase is good. As you =
already noticed, the original patch was based on 4.x kernel so the =
bucket traversal in btree.c needs to be adapted for 5.x and 6.x kernels. =
I attached the patch rebased to 6.9 HEAD for your reference.
>=20
> But to observe the IO stall before the patch, please test with a =
read-write workload so GC will happen periodically enough (read-only or =
read-mostly workload doesn't show the problem). For me, I used the "fio" =
utility to generate a random read-write workload as follows.
>=20
> # Pre-generate a 900GB test file
> $ truncate -s 900G test
>=20
> # Run random read-write workload for 1 hour
> $ fio --time_based --runtime=3D3600s --ramp_time=3D2s =
--ioengine=3Dlibaio --name=3Dlatency_test --filename=3Dtest --bs=3D8k =
--iodepth=3D1 --size=3D900G  --readwrite=3Drandrw --verify=3D0 =
--filename=3Dfio --write_lat_log=3Dlat --log_avg_msec=3D1000 =
--log_max_value=3D1=20
>=20
> We include the flags "--write_lat_log=3Dlat --log_avg_msec=3D1000 =
--log_max_value=3D1" so fio will dump the second-by-second max latency =
into a log file at the end of test so we can when stall happens and for =
how long:
>=20

Copied. Thanks for the information. Let me try the above command lines =
on my local machine with longer time.



> E.g.
>=20
> $ more lat_lat.1.log
> (format: <time-ms>,<max-latency-ns>,,,)
> ...
> 777000, 5155548, 0, 0, 0
> 778000, 105551, 1, 0, 0
> 802615, 24276019570, 0, 0, 0 <---- stalls for 24s with no IO possible
> 802615, 82134, 1, 0, 0
> 804000, 9944554, 0, 0, 0
> 805000, 7424638, 1, 0, 0
>=20
> I used a 375 GB local SSD (cache device) and a 1 TB network-attached =
storage (backing device). In the 1-hr run, GC starts happening about 10 =
minutes into the run and then happens at ~ 5 minute intervals. The stall =
duration ranges from a few seconds at the beginning to close to 40 =
seconds towards the end. Only about 1/2 to 2/3 of the cache is used by =
the end.
>=20
> Note that this patch doesn't shorten the GC either. Instead, it just =
avoids GC from blocking the allocator thread by first sweeping the =
buckets and marking reclaimable ones quickly at the beginning of GC so =
the allocator can proceed while GC continues its actual job.
>=20
> We are eagerly looking forward to this patch to be merged in this =
coming merge window that is expected to open in a week to two.

In order to avoid the no-space deadlock, normally there are around 10% =
space will not be allocated out. I need to look more close onto this =
patch.


Dongsheng Yang,

Could you please post a new version based on current mainline kernel =
code ?

Thanks.

Coly Li



