Return-Path: <linux-bcache+bounces-1057-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2BEAAAF15E
	for <lists+linux-bcache@lfdr.de>; Thu,  8 May 2025 05:02:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1DAE3BAB06
	for <lists+linux-bcache@lfdr.de>; Thu,  8 May 2025 03:01:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 499B01DFDB8;
	Thu,  8 May 2025 03:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b="cBzuG33s"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail73.out.titan.email (mail73.out.titan.email [3.216.99.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6251F1D63F2
	for <linux-bcache@vger.kernel.org>; Thu,  8 May 2025 03:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.216.99.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746673319; cv=none; b=ck65kkTbiqAa0GgI41naJC7fm+Xfcc02HN//WvVyJio7jX/OvCrAaVvyuX0bkG5+6z9gKmfqDAVTcjq+cqNB+N3uZAF8z8/RGRbDDd0sm5JNGmrOH1r8uXtXUE5aKgdJIYK6z6KKlifugbILQxVSeIUWpCjyA8GMH7f1OSv0ZKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746673319; c=relaxed/simple;
	bh=7Tf1EqFD545JHpAWZXvSjHa28oRZjVWMUVk79TF5iA8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=PDRcCdw1OakS9PNcvOUEMx/UiuDbp8JrDKnIpTAt0uuoR9U/OOsIagAN2+7OWzTrD29BW2eZ+DKxgowvrARxpaJf/pmnzKMhF15X7KqmZKKRloL07FVsi3iaYQoaObNUn2KXfVaFzGMhiAYZLrpo00Rm3nPQkS7EoRHIhoF84cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li; spf=pass smtp.mailfrom=coly.li; dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b=cBzuG33s; arc=none smtp.client-ip=3.216.99.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=coly.li
Received: from localhost (localhost [127.0.0.1])
	by smtp-out.flockmail.com (Postfix) with ESMTP id 2A42E60360;
	Thu,  8 May 2025 03:01:50 +0000 (UTC)
DKIM-Signature: a=rsa-sha256; bh=RCzvqplp+4SerGTRkXu4/iLMKYFITxB7gCQ/kktCJrU=;
	c=relaxed/relaxed; d=t12smtp-sign004.email;
	h=cc:from:references:to:mime-version:in-reply-to:date:subject:message-id:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1746673310; v=1;
	b=cBzuG33sSgGRIR9ebvPLQtox5qhT95Arw3IlLbP4nMW+4EdBFxOjc2NDYRwEz6hzb6JMTjFu
	Of1gRa4Qu8Vy+3pFXkGX/ItJWp19nRzdxSap3pwl2L4Mml1kuZ6xiFwBGukL08ph3nUqlvqQnDZ
	0Qfi+ucJ+FxSoRHS18NuInfc=
Received: from smtpclient.apple (unknown [141.11.218.23])
	by smtp-out.flockmail.com (Postfix) with ESMTPA id 1E03E60363;
	Thu,  8 May 2025 03:01:46 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [PATCH v2] md/bcache: Mark __nonstring look-up table
Feedback-ID: :i@coly.li:coly.li:flockmailId
From: Coly Li <i@coly.li>
In-Reply-To: <389A9925-0990-422C-A1B3-0195FAA73288@coly.li>
Date: Thu, 8 May 2025 11:01:34 +0800
Cc: Coly Li <colyli@kernel.org>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Ard Biesheuvel <ardb@kernel.org>,
 linux-bcache@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <851B250D-A22C-4B47-BBAC-55284B5B5790@coly.li>
References: <20250418202130.it.887-kees@kernel.org>
 <389A9925-0990-422C-A1B3-0195FAA73288@coly.li>
To: Kees Cook <kees@kernel.org>
X-Mailer: Apple Mail (2.3826.500.181.1.5)
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1746673310016857733.5242.3433233303003199658@prod-use1-smtp-out1001.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=fZxXy1QF c=1 sm=1 tr=0 ts=681c1e9e
	a=USBFZE4A2Ag4MGBBroF6Xg==:117 a=USBFZE4A2Ag4MGBBroF6Xg==:17
	a=IkcTkHD0fZMA:10 a=CEWIc4RMnpUA:10 a=VwQbUJbxAAAA:8
	a=41P4AONiiAATRugwBd4A:9 a=QEXdDO2ut3YA:10 a=ZImdrWQ-kMQFOr_krkRP:22



> 2025=E5=B9=B44=E6=9C=8819=E6=97=A5 11:55=EF=BC=8CColy Li <i@coly.li> =
=E5=86=99=E9=81=93=EF=BC=9A
>=20
>=20
>=20
>> 2025=E5=B9=B44=E6=9C=8819=E6=97=A5 04:21=EF=BC=8CKees Cook =
<kees@kernel.org> =E5=86=99=E9=81=93=EF=BC=9A
>>=20
>> GCC 15's new -Wunterminated-string-initialization notices that the 16
>> character lookup table "zero_uuid" (which is not used as a C-String)
>> needs to be marked as "nonstring":
>>=20
>> drivers/md/bcache/super.c: In function 'uuid_find_empty':
>> drivers/md/bcache/super.c:549:43: warning: initializer-string for =
array of 'char' truncates NUL terminator but destination lacks =
'nonstring' attribute (17 chars into 16 available) =
[-Wunterminated-string-initialization]
>> 549 |         static const char zero_uuid[16] =3D =
"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
>>     |                                           =
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>=20
>> Add the annotation (since it is not used as a C-String), and switch =
the
>> initializer to an array of bytes.
>>=20
>> Signed-off-by: Kees Cook <kees@kernel.org>
>> ---
>> v2: use byte array initializer (colyli)
>> v1: =
https://lore.kernel.org/all/20250416220135.work.394-kees@kernel.org/
>> Cc: Coly Li <colyli@kernel.org>
>> Cc: Kent Overstreet <kent.overstreet@linux.dev>
>> Cc: Ard Biesheuvel <ardb@kernel.org>
>> Cc: linux-bcache@vger.kernel.org
>> ---
>> drivers/md/bcache/super.c | 3 ++-
>> 1 file changed, 2 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index e42f1400cea9..a76ce92502ed 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -546,7 +546,8 @@ static struct uuid_entry *uuid_find(struct =
cache_set *c, const char *uuid)
>>=20
>> static struct uuid_entry *uuid_find_empty(struct cache_set *c)
>> {
>> - static const char zero_uuid[16] =3D =
"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
>> + static const char zero_uuid[] __nonstring =3D
>=20

Hi Kees,

> I notice zero_uuid[16] changes to zero_uuid[], then the element number =
information is removed.
>=20
> Is it OK for GCC 15 to only add __nonstring and keep zero_uuid[16]?

Ping ?

You are expert here, I need your opinion.

Thanks.

Coly Li



>> + { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
>>=20
>> return uuid_find(c, zero_uuid);
>> }
>> --=20
>> 2.34.1



