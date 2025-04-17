Return-Path: <linux-bcache+bounces-902-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBB9AA91F52
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Apr 2025 16:17:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04EB94636A0
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Apr 2025 14:17:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A740E2512D3;
	Thu, 17 Apr 2025 14:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b="YfXiimzx"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail38.out.titan.email (mail38.out.titan.email [209.209.25.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCDF2505D6
	for <linux-bcache@vger.kernel.org>; Thu, 17 Apr 2025 14:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.209.25.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744899468; cv=none; b=l4Ps6Dz9mi5eirayHQ9lDuNUagjb6or7iRrOZhpu7iPUnZQ2MidvvagIVFvcZWwCfHUSe7nrTjXD7SfYqWZPtygEAeeLxOhEFDMHDqF+9YZyULQzwMIZGg1288lLoAIWUI3cfUlhj+z42JFkwEQSIulrYirLsBkhizZTmdxG5sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744899468; c=relaxed/simple;
	bh=j/PfWcvOdvDX/QR5kqDYMnCt+/AXcLPVxvAygbwKZpU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=ipRW6cuPQv4ZQnik+CKWZpN5XkLIkLsBwojDjv9+FtxDze9P4JxwlGvpVc0JxqQ16cbgLUYxxmuHHLdjqHY1l8Rut/TN5ZPev7p+JDz/wdVDsb9tR8Fv2jbWuHTnfXt9LEpFKac9QQpYQvkQqOvOp0lhaLnrE+a66nzFlo7YlQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li; spf=pass smtp.mailfrom=coly.li; dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b=YfXiimzx; arc=none smtp.client-ip=209.209.25.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=coly.li
Received: from localhost (localhost [127.0.0.1])
	by smtp-out.flockmail.com (Postfix) with ESMTP id B35D260359;
	Thu, 17 Apr 2025 14:17:45 +0000 (UTC)
DKIM-Signature: a=rsa-sha256; bh=XnB24iAeGbj6B5uP93ZICmKOLHtGxbBDP9NdC4vj7ME=;
	c=relaxed/relaxed; d=t12smtp-sign004.email;
	h=mime-version:from:references:subject:in-reply-to:cc:date:message-id:to:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1744899465; v=1;
	b=YfXiimzxGicQ+epEfxkoqE365IAHrB4fVc8Fd5giar6CaO/7iG4idJ/+6Yw4Mdn8geGnIOWH
	hS4Ypf64Oejd5sT66e0zCtGUokHfo+Db8lKA0mY42PuxMrW2H9P+n+39xXyz1gxK2nnPBNzflPC
	fw8hXNNAgstZe9sCdwLigDqM=
Received: from smtpclient.apple (unknown [141.11.218.23])
	by smtp-out.flockmail.com (Postfix) with ESMTPA id 1262F6020D;
	Thu, 17 Apr 2025 14:17:42 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [PATCH] md/bcache: Mark __nonstring look-up table
Feedback-ID: :i@coly.li:coly.li:flockmailId
From: Coly Li <i@coly.li>
In-Reply-To: <CAMj1kXHwBKu1K=yjJprnEArZFKphvDPsfZzA5KgTtyo5L866=w@mail.gmail.com>
Date: Thu, 17 Apr 2025 22:17:30 +0800
Cc: Kees Cook <kees@kernel.org>,
 Coly Li <colyli@kernel.org>,
 linux-bcache@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A64AEAB9-9C41-408E-8B51-F2F58882CFBE@coly.li>
References: <20250416220135.work.394-kees@kernel.org>
 <CAMj1kXHfearSZG6TFTxxX87qmRkUmAefQm-TfPNS8j09kWxujQ@mail.gmail.com>
 <994E520B-64B1-4387-8DFF-88755346FE55@kernel.org>
 <208BFA1D-F3E9-4D9F-A4A1-4E4C3F4CA309@coly.li>
 <CAMj1kXHwBKu1K=yjJprnEArZFKphvDPsfZzA5KgTtyo5L866=w@mail.gmail.com>
To: Ard Biesheuvel <ardb@kernel.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3826.500.181.1.5)
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1744899465573767940.5242.3803715497672975691@prod-use1-smtp-out1001.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=fZxXy1QF c=1 sm=1 tr=0 ts=68010d89
	a=USBFZE4A2Ag4MGBBroF6Xg==:117 a=USBFZE4A2Ag4MGBBroF6Xg==:17
	a=IkcTkHD0fZMA:10 a=CEWIc4RMnpUA:10 a=VwQbUJbxAAAA:8
	a=bNni2TGrO3FHrKkdXQAA:9 a=QEXdDO2ut3YA:10 a=2sD_2MczOTEKGp_KAmFJ:22



> 2025=E5=B9=B44=E6=9C=8817=E6=97=A5 22:08=EF=BC=8CArd Biesheuvel =
<ardb@kernel.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Thu, 17 Apr 2025 at 15:12, Coly Li <i@coly.li> wrote:
>>=20
>>=20
>>=20
>>> 2025=E5=B9=B44=E6=9C=8817=E6=97=A5 15:10=EF=BC=8CKees Cook =
<kees@kernel.org> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>>=20
>>>=20
>>> On April 16, 2025 11:16:45 PM PDT, Ard Biesheuvel <ardb@kernel.org> =
wrote:
>>>> On Thu, 17 Apr 2025 at 00:01, Kees Cook <kees@kernel.org> wrote:
>>>>>=20
>>>>> GCC 15's new -Wunterminated-string-initialization notices that the =
16
>>>>> character lookup table "zero_uuid" (which is not used as a =
C-String)
>>>>> needs to be marked as "nonstring":
>>>>>=20
>>>>> drivers/md/bcache/super.c: In function 'uuid_find_empty':
>>>>> drivers/md/bcache/super.c:549:43: warning: initializer-string for =
array of 'char' truncates NUL terminator but destination lacks =
'nonstring' attribute (17 chars into 16 available) =
[-Wunterminated-string-initialization]
>>>>> 549 |         static const char zero_uuid[16] =3D =
"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
>>>>>     |                                           =
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>>>=20
>>>>> Add the annotation to silence the GCC warning.
>>>>>=20
>>>>> Signed-off-by: Kees Cook <kees@kernel.org>
>>>>> ---
>>>>> Cc: Coly Li <colyli@kernel.org>
>>>>> Cc: Kent Overstreet <kent.overstreet@linux.dev>
>>>>> Cc: linux-bcache@vger.kernel.org
>>>>> ---
>>>>> drivers/md/bcache/super.c | 2 +-
>>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>=20
>>>>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>>>>> index e42f1400cea9..577d048170fe 100644
>>>>> --- a/drivers/md/bcache/super.c
>>>>> +++ b/drivers/md/bcache/super.c
>>>>> @@ -546,7 +546,7 @@ static struct uuid_entry *uuid_find(struct =
cache_set *c, const char *uuid)
>>>>>=20
>>>>> static struct uuid_entry *uuid_find_empty(struct cache_set *c)
>>>>> {
>>>>> -       static const char zero_uuid[16] =3D =
"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
>>>>> +       static const char zero_uuid[] __nonstring =3D =
"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
>>>>>=20
>>>>=20
>>>> Just
>>>>=20
>>>> static const char zero_uuid[16] =3D {};
>>>>=20
>>>> should work fine here too. No need for the initializer.
>>>=20
>>> =F0=9F=A4=A6 Yes. This is what I get for fixing dozens of these. =
I'll send a v2...
>>=20
>>=20
>> Can we do this,
>>=20
>> static const char zero_uuid[16] =3D {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, =
0, 0, 0, 0, 0};
>>=20
>> I like the explicit array element number 16, and the explicit uuid =
content by obvious zero (=E2=80=980=E2=80=99) symbols. They provide =
redundant information.
>> Not sure whether GCC 15 complains or not.
>>=20
>=20
> Even the {} initializer is entirely redundant, given that the variable
> has static linkage, and so C guarantees that it will be zero
> initialized.
>=20
> Could you use NULL_GUID and be done with it?

I feel the =E2=80=9Cstatic=E2=80=9D here is an optimization to avoid =
initializing zero_uuid again =E2=80=A6.

Kent,

Am I right?

Coly Li




