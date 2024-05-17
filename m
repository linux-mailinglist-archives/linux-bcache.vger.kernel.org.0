Return-Path: <linux-bcache+bounces-465-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F22AB8C89C4
	for <lists+linux-bcache@lfdr.de>; Fri, 17 May 2024 18:06:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 208981C2141C
	for <lists+linux-bcache@lfdr.de>; Fri, 17 May 2024 16:06:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBB8712F5A3;
	Fri, 17 May 2024 16:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PpzuIL4r";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="R8kIZVx3";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PpzuIL4r";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="R8kIZVx3"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4792912F584
	for <linux-bcache@vger.kernel.org>; Fri, 17 May 2024 16:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715961994; cv=none; b=bEKH+T868axkwxM3kfDJxJP6lleeyLvGlEfPR6n2a8vQ2XdIsR8VhRIk19jd99CUfVZcEMYwgijvYWlcCmPidTJOSMJhqjJYhmPIYJ0Jd2+NxTMaL7oefZquTgXtSdi7rpT1O2x74huY2nIKiZqZF3z1qjnLEcByETplJIC6YYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715961994; c=relaxed/simple;
	bh=qIRCrKslUpl3JnECPfhyh7+l0eGpFb9ss4aLVe6O0tg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=td4XBpIGV4vlCJ/RPxX8lIuXZjcofGXJIaGt6kDN140IjaDfZXu07x0QgXPzXTFcevXAfeRV/2vChuZref9TM2Z5iJHUyYR5B9fTNBJHIS45+P6BCPxOQgBbrbwiVIi44N7bGF/kvwPOIOyvgnRdSq/wXym6+Bx399UpY+07QP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PpzuIL4r; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=R8kIZVx3; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PpzuIL4r; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=R8kIZVx3; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7756B37565;
	Fri, 17 May 2024 16:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1715961991; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VM1tWvv2bFk3RtB6T+NRccWA+r1b7KMy9cJFL/8gdfY=;
	b=PpzuIL4rqcCxVa8G0FGV0Ll763lNOkus1aJe7R0PTmBX6vnTbM1l3oFV3lzJ4MogunjBvP
	rzrzRjcEvxotfwtTIqePshDeSj+jE/EpWMIBQdD32dVFlDz3+/CF/Ji6HXi5A4iKDPoewH
	qkAD63EbtqNkS9bq7iBbvc7E38v9uzk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1715961991;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VM1tWvv2bFk3RtB6T+NRccWA+r1b7KMy9cJFL/8gdfY=;
	b=R8kIZVx3J4tuoMd34+/QKpZcD3qEUkUGORAF86EFMg8VHCnvYMXTXoqzsPlTtSIvlH1vGr
	A9k+WMhoCpyQSKAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1715961991; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VM1tWvv2bFk3RtB6T+NRccWA+r1b7KMy9cJFL/8gdfY=;
	b=PpzuIL4rqcCxVa8G0FGV0Ll763lNOkus1aJe7R0PTmBX6vnTbM1l3oFV3lzJ4MogunjBvP
	rzrzRjcEvxotfwtTIqePshDeSj+jE/EpWMIBQdD32dVFlDz3+/CF/Ji6HXi5A4iKDPoewH
	qkAD63EbtqNkS9bq7iBbvc7E38v9uzk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1715961991;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VM1tWvv2bFk3RtB6T+NRccWA+r1b7KMy9cJFL/8gdfY=;
	b=R8kIZVx3J4tuoMd34+/QKpZcD3qEUkUGORAF86EFMg8VHCnvYMXTXoqzsPlTtSIvlH1vGr
	A9k+WMhoCpyQSKAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 38C7D13942;
	Fri, 17 May 2024 16:06:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ravTJYKAR2bQRwAAD6G6ig
	(envelope-from <colyli@suse.de>); Fri, 17 May 2024 16:06:26 +0000
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
In-Reply-To: <9c197420-2c46-222a-6176-8a3ecae1d01d@ewheeler.net>
Date: Sat, 18 May 2024 00:06:09 +0800
Cc: Robert Pang <robertpang@google.com>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>,
 =?utf-8?B?6YK55piO5ZOy?= <mingzhe.zou@easystack.cn>,
 Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3E11DC5E-92D1-43FF-8948-B99F665E445D@suse.de>
References: <C787D2E8-6D03-4F4D-9633-2237AA0B2BE7@suse.de>
 <CAJhEC05hzf2zVyJabVExFNF0esiLovc+WLHOY_YhV22OUdGFZw@mail.gmail.com>
 <5C71FFC2-B22E-4FC2-852F-F40BFDEDFB2C@suse.de>
 <C659682B-4EAB-4022-A669-1574962ECE82@suse.de>
 <CAJhEC04+VUKqUpMfACF0pSiwtdaJaOsb50dp_VbyhahPS6KE5A@mail.gmail.com>
 <82DDC16E-F4BF-4F8D-8DB8-352D9A6D9AF5@suse.de>
 <ea18e5b9-2d10-c459-ffec-fe7012fad345@easystack.cn>
 <CAJhEC04czCGuwdS3AC8JdzKax4aX9i4D7BJ01xgi3PKCpgzwzw@mail.gmail.com>
 <1B20E890-F136-496B-AF1F-C09DB0B45BE8@suse.de>
 <CAJhEC06FQPw3p7PHJpjN13CVjibbBVv-ZhwBb_6ducJP+XJ3gg@mail.gmail.com>
 <xbm4drbn7hdxedptocnc77m53kce3jdaedsvxh7dcwts7yivjx@jbvhh43wd3tp>
 <9c197420-2c46-222a-6176-8a3ecae1d01d@ewheeler.net>
To: Eric Wheeler <bcache@lists.ewheeler.net>
X-Mailer: Apple Mail (2.3774.500.171.1.1)
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MV_CASE(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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
	RCPT_COUNT_FIVE(0.00)[5]
X-Spam-Score: -3.80
X-Spam-Flag: NO



> 2024=E5=B9=B45=E6=9C=8817=E6=97=A5 08:30=EF=BC=8CEric Wheeler =
<bcache@lists.ewheeler.net> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Wed, 15 May 2024, Coly Li wrote:
>> On Mon, May 13, 2024 at 10:15:00PM -0700, Robert Pang wrote:
>>> Dear Coly,
>>>=20
>>=20
>> Hi Robert,
>>=20
>> Thanks for the email. Let me explain inline.
>>=20
>>> Thank you for your dedication in reviewing this patch. I understand =
my
>>> previous message may have come across as urgent, but I want to
>>> emphasize the significance of this bcache operational issue as it =
has
>>> been reported by multiple users.
>>>=20
>>=20
>> What I concerned was still the testing itself. First of all, from the
>> following information, I see quite a lot of testings are done. I do
>> appreciate for the effort, which makes me confident for the quality =
of
>> this patch.
>>=20
>>> We understand the importance of thoroughness, To that end, we have
>>> conducted extensive, repeated testing on this patch across a range =
of
>>> cache sizes (375G/750G/1.5T/3T/6T/9TB) and CPU cores
>>> (2/4/8/16/32/48/64/80/96/128) for an hour-long run. We tested =
various
>>> workloads (read-only, read-write, and write-only) with 8kB I/O size.
>>> In addition, we did a series of 16-hour runs with 750GB cache and 16
>>> CPU cores. Our tests, primarily in writethrough mode, haven't =
revealed
>>> any issues or deadlocks.
>>>=20
>>=20
>> An hour-long run is not enough for bcache. Normally for stability =
prupose
>> at least 12-36 hours continue I/O pressure is necessary. Before Linux
>> v5.3 bcache will run into out-of-memory after 10 ~ 12 hours heavy =
randome
>> write workload on the server hardware Lenovo sponsored me.
>=20
> FYI:
>=20
> We have been running the v2 patch in production on 5 different servers=20=

> containing a total of 8 bcache volumes since April 7th this year, =
applied=20
> to 6.6.25 and later kernels. Some servers run 4k sector sizes, and =
others=20
> run 512-byte sectors for the data volume. For the cache volumes, their =
all=20
> cache devices use 512 byte sectors.
>=20
> The backing storage on these servers range from 40-350 terabytes, and =
the=20
> cache sizes are in the 1-2 TB range.  We log kernel messages with=20
> netconsole into a centralized log server and have not had any bcache=20=

> issues.


Thanks for the information.
The issue I stated didn=E2=80=99t generate kernel message. It just =
causes all I/Os bypass the almost fully occupied cache even it is all =
clean data.
Anyway this is not directly caused by this patch, this patch just makes =
it more easier to arrive such situation before I found and fixed it.


And to all contributors (including Dongsheng, Mingzhe, Robert, Eric and =
others),

At this moment I see it works fine on my server. I am about to submit it =
to Jens next week, if no other issue pops up.

Thanks.

Coly Li=

