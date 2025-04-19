Return-Path: <linux-bcache+bounces-906-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A0E2A94186
	for <lists+linux-bcache@lfdr.de>; Sat, 19 Apr 2025 06:11:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6188D4615F7
	for <lists+linux-bcache@lfdr.de>; Sat, 19 Apr 2025 04:11:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACBBA7E107;
	Sat, 19 Apr 2025 04:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b="oJhOnwfe"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail38.out.titan.email (mail38.out.titan.email [209.209.25.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D814B70823
	for <linux-bcache@vger.kernel.org>; Sat, 19 Apr 2025 04:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.209.25.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745035882; cv=none; b=mTnnA/9h24yCcNOuMDPCWyvJ8aasJXX2Qov32n5bX0+ECBkeTBJdcjmyKSoiE1CwlpExI+IHLVCAKPDCk0ezyPHdBuKt400OK8Wjb+tSsj15psUAJKGBDZ6zyMetj+OlnBE8D+yS48ETQnqnW+j7kTvrgzMGgKzJhzQwQ6bJdvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745035882; c=relaxed/simple;
	bh=8vsWUbNInXOmJ6LkU6uCbJfr9BGsN9vSttRt6BzaTnU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=jVsCcy7x7OenmzOTj8TzBC7veNJHNZKCzR5MGknNmw86g8gZTV713mHE6PLWXFqWXPQFr6yhEYDLvT60oGlWmTIlHZ2IFKJsMyf2XAI3gpvnCk+huIpTWrfl6J0ujlaydjHakeAG70EFLI8RNG4PLCvtMy5RTGmzhjYZA3dk9+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li; spf=pass smtp.mailfrom=coly.li; dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b=oJhOnwfe; arc=none smtp.client-ip=209.209.25.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=coly.li
Received: from localhost (localhost [127.0.0.1])
	by smtp-out.flockmail.com (Postfix) with ESMTP id D13B760059;
	Sat, 19 Apr 2025 03:55:26 +0000 (UTC)
DKIM-Signature: a=rsa-sha256; bh=bAvYi5ImaoxjDMe4vzylBlBmlqcUZYzHCYPKwoB87qI=;
	c=relaxed/relaxed; d=t12smtp-sign004.email;
	h=from:in-reply-to:cc:to:mime-version:subject:references:date:message-id:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1745034926; v=1;
	b=oJhOnwfeVOG8XG2+ePu+rd/hidWNokUuygMfqtb86FuyRwQz7ETjQwhTBXb7BCwtnAY3iYwH
	Yh1+xXALoOaA+3snTLim7K46mUvpB+x3mwVCC6wrPZiKcHLJZgeMtxiTfm/uHx9NomZibAM/Ar/
	VJgUsYz0lAVs9qpKOELp5Qy4=
Received: from smtpclient.apple (unknown [43.161.241.230])
	by smtp-out.flockmail.com (Postfix) with ESMTPA id C447160038;
	Sat, 19 Apr 2025 03:55:23 +0000 (UTC)
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
In-Reply-To: <20250418202130.it.887-kees@kernel.org>
Date: Sat, 19 Apr 2025 11:55:10 +0800
Cc: Coly Li <colyli@kernel.org>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Ard Biesheuvel <ardb@kernel.org>,
 linux-bcache@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <389A9925-0990-422C-A1B3-0195FAA73288@coly.li>
References: <20250418202130.it.887-kees@kernel.org>
To: Kees Cook <kees@kernel.org>
X-Mailer: Apple Mail (2.3826.500.181.1.5)
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1745034926648469019.5242.7544881322108761200@prod-use1-smtp-out1001.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=RvE/LDmK c=1 sm=1 tr=0 ts=68031eae
	a=sdR4fqZNG57T/J2FY8bnUA==:117 a=sdR4fqZNG57T/J2FY8bnUA==:17
	a=IkcTkHD0fZMA:10 a=CEWIc4RMnpUA:10 a=VwQbUJbxAAAA:8
	a=BDcCamcCxTd4Ojxa7JYA:9 a=QEXdDO2ut3YA:10 a=FvX_cx3yyqDC_9C4kSCW:22



> 2025=E5=B9=B44=E6=9C=8819=E6=97=A5 04:21=EF=BC=8CKees Cook =
<kees@kernel.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> GCC 15's new -Wunterminated-string-initialization notices that the 16
> character lookup table "zero_uuid" (which is not used as a C-String)
> needs to be marked as "nonstring":
>=20
> drivers/md/bcache/super.c: In function 'uuid_find_empty':
> drivers/md/bcache/super.c:549:43: warning: initializer-string for =
array of 'char' truncates NUL terminator but destination lacks =
'nonstring' attribute (17 chars into 16 available) =
[-Wunterminated-string-initialization]
>  549 |         static const char zero_uuid[16] =3D =
"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
>      |                                           =
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>=20
> Add the annotation (since it is not used as a C-String), and switch =
the
> initializer to an array of bytes.
>=20
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
> v2: use byte array initializer (colyli)
> v1: =
https://lore.kernel.org/all/20250416220135.work.394-kees@kernel.org/
> Cc: Coly Li <colyli@kernel.org>
> Cc: Kent Overstreet <kent.overstreet@linux.dev>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: linux-bcache@vger.kernel.org
> ---
> drivers/md/bcache/super.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index e42f1400cea9..a76ce92502ed 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -546,7 +546,8 @@ static struct uuid_entry *uuid_find(struct =
cache_set *c, const char *uuid)
>=20
> static struct uuid_entry *uuid_find_empty(struct cache_set *c)
> {
> - static const char zero_uuid[16] =3D =
"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
> + static const char zero_uuid[] __nonstring =3D

I notice zero_uuid[16] changes to zero_uuid[], then the element number =
information is removed.

Is it OK for GCC 15 to only add __nonstring and keep zero_uuid[16]?

Thanks.

Coly Li=20


> + { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
>=20
> return uuid_find(c, zero_uuid);
> }
> --=20
> 2.34.1
>=20
>=20


