Return-Path: <linux-bcache+bounces-290-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B3D9087D803
	for <lists+linux-bcache@lfdr.de>; Sat, 16 Mar 2024 03:49:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8A50EB20D65
	for <lists+linux-bcache@lfdr.de>; Sat, 16 Mar 2024 02:49:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2871A641;
	Sat, 16 Mar 2024 02:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PrKCNqJQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="lfnFEUhV";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PrKCNqJQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="lfnFEUhV"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBB7393
	for <linux-bcache@vger.kernel.org>; Sat, 16 Mar 2024 02:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710557363; cv=none; b=Kpb3ZHpoRrELFt6GHc4mgSIOXSBLNBPO7W2N3OT0riIPvPlWD45h+U+UK0Sesl1+bH5eHOGr7g/uBb9oy2HW0ogZjz1VpeRWbmq6jviqJu0QVyaLR+TRXUOesXssE++EI7953rO31delS6KqhjnXZfZ/N0hLbyj+3XoMeeaJZ4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710557363; c=relaxed/simple;
	bh=OaLdwco+n/Z+nALsBhv7KhNBz+X5O3AHoIbkVnt+DwQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=U7BtkRkfN/mJFw8L1c0vo3jERNeeT71fjbMYuKD0ntHQXQ1UhJFW3RVKDU7XzWLd0T3ES/fJjh4QSHaYNqKcJQEF5TBslmodQaeh8OHN97OX3lJh0/9wmw83pK9l9rN/rAbttz68bYqutiqIpY8M0NlY63sYdy3NaU32tynF8zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PrKCNqJQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lfnFEUhV; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PrKCNqJQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lfnFEUhV; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9E1491FB9F;
	Sat, 16 Mar 2024 02:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1710557357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RfNTUOighXiBvErV5PYO3XgGea2Gbx9G3PtBKtknGfQ=;
	b=PrKCNqJQQOYcyacYB5BurV4/4pa+YTB2xAA5eJ+7b0sR26S/m9+gQOcNvSk9aZzCv0sGt/
	R8CRPAhFzaGX13DvTUKCNBjSWXHIP9/SJQvdYfgEB4+hPTmzSSiW991DmHElu6JR3vmZOS
	2DRSzSfVZugFJoPGGGPO9StvzIkWEZs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1710557357;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RfNTUOighXiBvErV5PYO3XgGea2Gbx9G3PtBKtknGfQ=;
	b=lfnFEUhVLBKiz6M3VjuNavWkKz0yu+ZnJwRy616UYxQ5kHOWsrSTlMKYtO84CjgMFld3A1
	DliusPxWY/rBTiBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1710557357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RfNTUOighXiBvErV5PYO3XgGea2Gbx9G3PtBKtknGfQ=;
	b=PrKCNqJQQOYcyacYB5BurV4/4pa+YTB2xAA5eJ+7b0sR26S/m9+gQOcNvSk9aZzCv0sGt/
	R8CRPAhFzaGX13DvTUKCNBjSWXHIP9/SJQvdYfgEB4+hPTmzSSiW991DmHElu6JR3vmZOS
	2DRSzSfVZugFJoPGGGPO9StvzIkWEZs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1710557357;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RfNTUOighXiBvErV5PYO3XgGea2Gbx9G3PtBKtknGfQ=;
	b=lfnFEUhVLBKiz6M3VjuNavWkKz0yu+ZnJwRy616UYxQ5kHOWsrSTlMKYtO84CjgMFld3A1
	DliusPxWY/rBTiBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 255D513460;
	Sat, 16 Mar 2024 02:49:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id v6vyLqsI9WUwEwAAD6G6ig
	(envelope-from <colyli@suse.de>); Sat, 16 Mar 2024 02:49:15 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.400.31\))
Subject: Re: [PATCH v2] bcache: allow allocator to invalidate bucket in gc
From: Coly Li <colyli@suse.de>
In-Reply-To: <20240315224527.694458-1-robertpang@google.com>
Date: Sat, 16 Mar 2024 10:48:58 +0800
Cc: Dongsheng Yang <dongsheng.yang@easystack.cn>,
 linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <584A2724-ACA2-4000-A8D2-50B6AA5684A7@suse.de>
References: <1ddde040-9bde-515a-1d4d-b41de472a702@suse.de>
 <20240315224527.694458-1-robertpang@google.com>
To: Robert Pang <robertpang@google.com>
X-Mailer: Apple Mail (2.3774.400.31)
X-Spam-Score: -1.01
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spamd-Result: default: False [-1.01 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 BAYES_HAM(-0.00)[28.01%];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[3];
	 MV_CASE(0.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 TO_DN_SOME(0.00)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[];
	 RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from]
X-Spam-Level: 
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PrKCNqJQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lfnFEUhV
X-Rspamd-Queue-Id: 9E1491FB9F

Hi Robert,

Thanks for your email.

> 2024=E5=B9=B43=E6=9C=8816=E6=97=A5 06:45=EF=BC=8CRobert Pang =
<robertpang@google.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi all
>=20
> We found this patch via google.
>=20
> We have a setup that uses bcache to cache a network attached storage =
in a local SSD drive. Under heavy traffic, IO on the cached device =
stalls every hour or so for tens of seconds. When we track the latency =
with "fio" utility continuously, we can see the max IO latency shoots up =
when stall happens, =20
>=20
> latency_test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D50416: Fri Mar =
15 21:14:18 2024
>  read: IOPS=3D62.3k, BW=3D486MiB/s (510MB/s)(11.4GiB/24000msec)
>    slat (nsec): min=3D1377, max=3D98964, avg=3D4567.31, stdev=3D1330.69
>    clat (nsec): min=3D367, max=3D43682, avg=3D429.77, stdev=3D234.70
>     lat (nsec): min=3D1866, max=3D105301, avg=3D5068.60, stdev=3D1383.14=

>    clat percentiles (nsec):
>     |  1.00th=3D[  386],  5.00th=3D[  406], 10.00th=3D[  406], =
20.00th=3D[  410],
>     | 30.00th=3D[  414], 40.00th=3D[  414], 50.00th=3D[  414], =
60.00th=3D[  418],
>     | 70.00th=3D[  418], 80.00th=3D[  422], 90.00th=3D[  426], =
95.00th=3D[  462],
>     | 99.00th=3D[  652], 99.50th=3D[  708], 99.90th=3D[ 3088], =
99.95th=3D[ 5600],
>     | 99.99th=3D[11328]
>   bw (  KiB/s): min=3D318192, max=3D627591, per=3D99.97%, =
avg=3D497939.04, stdev=3D81923.63, samples=3D47
>   iops        : min=3D39774, max=3D78448, avg=3D62242.15, =
stdev=3D10240.39, samples=3D47
> ...
>=20
> <IO stall>
>=20
> latency_test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D50416: Fri Mar =
15 21:21:23 2024
>  read: IOPS=3D26.0k, BW=3D203MiB/s (213MB/s)(89.1GiB/448867msec)
>    slat (nsec): min=3D958, max=3D40745M, avg=3D15596.66, =
stdev=3D13650543.09
>    clat (nsec): min=3D364, max=3D104599, avg=3D435.81, stdev=3D302.81
>     lat (nsec): min=3D1416, max=3D40745M, avg=3D16104.06, =
stdev=3D13650546.77
>    clat percentiles (nsec):
>     |  1.00th=3D[  378],  5.00th=3D[  390], 10.00th=3D[  406], =
20.00th=3D[  410],
>     | 30.00th=3D[  414], 40.00th=3D[  414], 50.00th=3D[  418], =
60.00th=3D[  418],
>     | 70.00th=3D[  418], 80.00th=3D[  422], 90.00th=3D[  426], =
95.00th=3D[  494],
>     | 99.00th=3D[  772], 99.50th=3D[  916], 99.90th=3D[ 3856], =
99.95th=3D[ 5920],
>     | 99.99th=3D[10816]
>   bw (  KiB/s): min=3D    1, max=3D627591, per=3D100.00%, =
avg=3D244393.77, stdev=3D103534.74, samples=3D765
>   iops        : min=3D    0, max=3D78448, avg=3D30549.06, =
stdev=3D12941.82, samples=3D765
>=20
> When we track per-second max latency in fio, we see something like =
this:
>=20
> <time-ms>,<max-latency-ns>,,,
> ...
> 777000, 5155548, 0, 0, 0
> 778000, 105551, 1, 0, 0
> 802615, 24276019570, 0, 0, 0
> 802615, 82134, 1, 0, 0
> 804000, 9944554, 0, 0, 0
> 805000, 7424638, 1, 0, 0
>=20
> fio --time_based --runtime=3D3600s --ramp_time=3D2s --ioengine=3Dlibaio =
--name=3Dlatency_test --filename=3Dfio --bs=3D8k --iodepth=3D1 =
--size=3D900G  --readwrite=3Drandrw --verify=3D0 --filename=3Dfio =
--write_lat_log=3Dlat --log_avg_msec=3D1000 --log_max_value=3D1
>=20
> We saw a smiliar issue reported in =
https://www.spinics.net/lists/linux-bcache/msg09578.html, which suggests =
an issue in garbage collection. When we trigger GC manually via "echo 1 =
> /sys/fs/bcache/a356bdb0-...-64f794387488/internal/trigger_gc", the =
stall is always reproduced. That thread points to this patch =
(https://www.spinics.net/lists/linux-bcache/msg08870.html) that we =
tested and the stall no longer happens.
>=20
> AFAIK, this patch marks buckets reclaimable at the beginning of GC to =
unblock the allocator so it does not need to wait for GC to finish. This =
periodic stall is a serious issue. Can the community look at this issue =
and this patch if possible?
>=20

Could you please share more performance information of this patch? And =
how many nodes/how long time does the test cover so far?

Last time I test the patch, it looked fine. But I was not confident how =
large scale and how long time this patch was tested. If you may provide =
more testing information, it will be helpful.
=20

Coly Li=

