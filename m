Return-Path: <linux-bcache+bounces-256-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C793C8468E6
	for <lists+linux-bcache@lfdr.de>; Fri,  2 Feb 2024 08:03:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DAF228DB30
	for <lists+linux-bcache@lfdr.de>; Fri,  2 Feb 2024 07:03:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBE834C60;
	Fri,  2 Feb 2024 07:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PbEJtyy/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="OvPx+kW3";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PbEJtyy/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="OvPx+kW3"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1AE179BF
	for <linux-bcache@vger.kernel.org>; Fri,  2 Feb 2024 07:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706857229; cv=none; b=hg5Cv/uvMn4GwJ4XTvtltnk+YBHyI/dREprrvJ1Ltu898aPS2hGbHp4Cpj9jZys81pHRyx1sRuF2KYMVzwWqMTyABbH17RX11H5fsSLlXbJiKIMkixZiJNRE2Wc42rVWTMqbkuisQ1MhR0e8OztFisSkwh4wmT3Hdmmu3yDNXrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706857229; c=relaxed/simple;
	bh=wI5QlDsDhEkf6m7m+fNChfVVnu7HyLJk9LKlPPXlML0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Uuy/by/RPJ4Za1Z6ZLcUs+0rTfMJnlNwbmcTga7gLVXP2IE8/Nqx7R13z2Ry1KPqJ+7v/eS4P8rRFjIQ42uHjlndj1vFuElX6e3rDmsEuEhL0K7dI6WYeIXZ6ZsyK+Pv2DG9P2KdYSe1aZdqQMZS/Pk1dOMrHW9CKEnMOT2CQWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PbEJtyy/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=OvPx+kW3; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PbEJtyy/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=OvPx+kW3; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 68EE221C7B;
	Fri,  2 Feb 2024 07:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1706857225; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uYjKlqsPWPtehxlgPsfcwY9fcM8jaZoV2vwt1L72Ero=;
	b=PbEJtyy/+Rz+o/LFvZ9i0RxIpWlC5C8iEYwnh2++8QokxUDE2BZVxw/kfe45JyuRmeoI5r
	WXq228voSsdiiNMVHhcTvCiqAtpxS1H6WrqWTtdij/eozMl/Ia7D373MhR3j2i82JNt2QJ
	0mL112ea7ArcwWBRB9oOPWkv1/4gsk8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1706857225;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uYjKlqsPWPtehxlgPsfcwY9fcM8jaZoV2vwt1L72Ero=;
	b=OvPx+kW3ugxXbtmGrVq6pFRYEft6T5qXbRIPoLlJ4RLnuN36yaMKJhSojZb4nBQWrIcwXL
	tbcqjHUHBC9l38CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1706857225; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uYjKlqsPWPtehxlgPsfcwY9fcM8jaZoV2vwt1L72Ero=;
	b=PbEJtyy/+Rz+o/LFvZ9i0RxIpWlC5C8iEYwnh2++8QokxUDE2BZVxw/kfe45JyuRmeoI5r
	WXq228voSsdiiNMVHhcTvCiqAtpxS1H6WrqWTtdij/eozMl/Ia7D373MhR3j2i82JNt2QJ
	0mL112ea7ArcwWBRB9oOPWkv1/4gsk8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1706857225;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uYjKlqsPWPtehxlgPsfcwY9fcM8jaZoV2vwt1L72Ero=;
	b=OvPx+kW3ugxXbtmGrVq6pFRYEft6T5qXbRIPoLlJ4RLnuN36yaMKJhSojZb4nBQWrIcwXL
	tbcqjHUHBC9l38CA==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 2D6EE138FB;
	Fri,  2 Feb 2024 07:00:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id ju4cKAeTvGUtAwAAn2gu4w
	(envelope-from <colyli@suse.de>); Fri, 02 Feb 2024 07:00:23 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.400.31\))
Subject: Re: I/O error on cache device can cause user observable errors
From: Coly Li <colyli@suse.de>
In-Reply-To: <CANF=pgrX7h26TjA9bPUm9umRA-9KvELb9z3-bJsHm+t6SYbE1w@mail.gmail.com>
Date: Fri, 2 Feb 2024 15:00:10 +0800
Cc: Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <2944152A-ADF8-4B92-A9A2-D550BC51AF5E@suse.de>
References: <CANF=pgrX7h26TjA9bPUm9umRA-9KvELb9z3-bJsHm+t6SYbE1w@mail.gmail.com>
To: Arnaldo Montagner <armont@google.com>
X-Mailer: Apple Mail (2.3774.400.31)
X-Spam-Level: 
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="PbEJtyy/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OvPx+kW3
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:98:from];
	 FROM_HAS_DN(0.00)[];
	 DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	 MV_CASE(0.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 BAYES_HAM(-3.00)[100.00%];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 RCPT_COUNT_TWO(0.00)[2];
	 TO_DN_ALL(0.00)[];
	 MX_GOOD(-0.01)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: 68EE221C7B
X-Spam-Flag: NO



> 2024=E5=B9=B42=E6=9C=882=E6=97=A5 06:25=EF=BC=8CArnaldo Montagner =
<armont@google.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> The bcache documentation says that errors on the cache device are
> handled transparently.
>=20
> I'm seeing a case where the cache device is unregistered in response
> to repeated write errors (expected), but that results in a read error
> on the bcache device (unexpected).
>=20
> Here's how I'm reproducing the problem:
> 1. Create a device with dm-error to simulate I/O errors. The device is
> 1G in size and it will fail I/Os in a 4M extent starting at offset
> 128M:
>    $ dmsetup create cache_disk << EOF
>      0      262144    linear /dev/sdb 0
>      262144 8192      error
>      270336 1826816   linear /dev/sdb 270336
>    EOF
>=20
> 2. Set up bcache in writethrough mode. The backing device is 1000G in =
length:
>    $ make-bcache --cache /dev/mapper/cache_disk --bdev /dev/sdc
> --wipe-bcache --bucket 256k
>    $ echo writethrough > /sys/block/bcache0/bcache/cache_mode
>    $ echo 0 > /sys/block/bcache0/bcache/cache/synchronous
>=20
>    $ lsblk
>    NAME         MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
>    ...
>    sdb            8:16   0    10G  0 disk
>    =E2=94=94=E2=94=80cache_disk 253:0    0     1G  0 dm
>      =E2=94=94=E2=94=80bcache0  252:0    0  1000G  0 disk
>    sdc            8:32   0  1000G  0 disk
>    =E2=94=94=E2=94=80bcache0    252:0    0  1000G  0 disk
>=20
> 3. Start a random read workload on the bcache device (using fio):
>    $ fio --name=3Dbasic --filename=3D/dev/bcache0 --size=3D1000G
> --rw=3Drandread  --blocksize=3D256k --blockalign=3D256k
>=20
> 4. After a while I see that the cache device gets unregistered.
> However, the application output indicates it saw an I/O error on a
> read request:
>     fio: io_u error on file /dev/bcache0: Input/output error: read
> offset=3D592264298496, buflen=3D262144
>=20
> I can see in the syslogs that bcache unregistered the cache. The logs
> also show that there was an I/O error on the bcache device:
>    Feb  1 19:47:23 armont-bcache-test kernel: [ 3327.176867] bcache:
> bch_count_io_errors() dm-0: IO error on writing data to cache.
>    Feb  1 19:47:23 armont-bcache-test kernel: [ 3327.186494] bcache:
> bch_count_io_errors() dm-0: IO error on writing data to cache.
>    Feb  1 19:47:23 armont-bcache-test kernel: [ 3327.195743] bcache:
> bch_count_io_errors() dm-0: IO error on writing data to cache.
>    Feb  1 19:47:23 armont-bcache-test kernel: [ 3327.204869] bcache:
> bch_count_io_errors() dm-0: IO error on writing data to cache.
>    Feb  1 19:47:23 armont-bcache-test kernel: [ 3327.234722] bcache:
> bch_count_io_errors() dm-0: IO error on writing data to cache.
>    Feb  1 19:47:23 armont-bcache-test kernel: [ 3327.246102] bcache:
> bch_count_io_errors() dm-0: IO error on writing data to cache.
>    Feb  1 19:47:23 armont-bcache-test kernel: [ 3327.274013] bcache:
> bch_count_io_errors() dm-0: IO error on writing data to cache.
>    Feb  1 19:47:23 armont-bcache-test kernel: [ 3327.289128] bcache:
> bch_cache_set_error() error on 427201f5-5c86-4890-9866-f9860e518041:
> dm-0: too many IO errors writing data to cache
>    Feb  1 19:47:23 armont-bcache-test kernel: [ 3327.289128] ,
> disabling caching
>    Feb  1 19:47:23 armont-bcache-test kernel: [ 3327.306212] bcache:
> conditional_stop_bcache_device() stop_when_cache_set_failed of bcache0
> is "auto" and cache is clean, keep it alive.
>    Feb  1 19:47:23 armont-bcache-test kernel: [ 3327.306543] Buffer
> I/O error on dev bcache0, logical block 144595776, async page read
>    Feb  1 19:47:23 armont-bcache-test kernel: [ 3327.316119] bcache:
> cached_dev_detach_finish() Caching disabled for sdc
>    Feb  1 19:47:23 armont-bcache-test kernel: [ 3327.316398] bcache:
> cache_set_free() Cache set 427201f5-5c86-4890-9866-f9860e518041
> unregistered
>=20
> The steps above reproduce the problem most of the time, but not
> always. In a few of the attempts, the cache was unregistered without
> resulting in observable I/O errors.
>=20
> Is this expected?

Yes, this is expected as device failure or hot-plug handling.

BTW, which part of document do you read that =E2=80=9Cthat errors on the =
cache device are
handled transparently.=E2=80=9D, let me see whether it should be =
updated.

Thanks.

Coly Li



