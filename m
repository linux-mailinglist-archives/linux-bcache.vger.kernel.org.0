Return-Path: <linux-bcache+bounces-1209-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EDE0B9AD0C
	for <lists+linux-bcache@lfdr.de>; Wed, 24 Sep 2025 18:07:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E4B407AA8E9
	for <lists+linux-bcache@lfdr.de>; Wed, 24 Sep 2025 16:05:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B02E2FD1C2;
	Wed, 24 Sep 2025 16:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="LVwcRj+5"
X-Original-To: linux-bcache@vger.kernel.org
Received: from sg-1-19.ptr.blmpb.com (sg-1-19.ptr.blmpb.com [118.26.132.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD1D1311AC
	for <linux-bcache@vger.kernel.org>; Wed, 24 Sep 2025 16:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758730038; cv=none; b=BmHm/BSPo184ke/qJnmetCeorp69YXS0jCrzw3Mvdc81O/3xLQ5/3DKMr5h0RH6W3h6sfFtqTknVQHOQcBhd/r/zVrS5QewPfmvAwB9NjvciBugvVNbetZr7pP8wJOXHBAfu2reIm8ujrtfAsuvCrGoQw91zX1HHlCjop662du4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758730038; c=relaxed/simple;
	bh=XBCgSckQt7IM22vJ5De5Ijl5O+kcIJnZGJBikHzUVtc=;
	h=To:Cc:Date:Content-Type:In-Reply-To:From:Message-Id:References:
	 Subject:Mime-Version; b=lIrL/GCa17P6LK8mR+w3QWMJn1xC/jAucDFv69qp+MtBvyKyyKCaxWBZzSkppdgMD5q6HuFmwR+RpH6SS3YbUFgIFwDv2Y9vP4KPOgC7snfXEZiEb+E8akIXkhc8uaQF5dzcfU+2wALQgFUHfB6VvfU94P5U+hx4HrbFiC8o0wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=fail smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=LVwcRj+5; arc=none smtp.client-ip=118.26.132.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fnnas.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1758729910;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=jE19ZwRQzDh9IGWXXAfbBmdAN7GngJTcbHfkNT0DRPw=;
 b=LVwcRj+5rgzF6lju8WsleEwagEbyspJFf8iXOD8YZlTtOYLnJsY0nfr/YqxF3euiHuuNBM
 626NLAE1dTbSsRQdKlaTEVhFkNBp5bVpfGIKQNwPjIW/2a+Ij2NQqcpuvetvBZCcRqwGaL
 LhOOm6fhmuOpCf9htTodRGp0nzwTXrWb9jXZQ2a+13Lo1+F67h1aKflxXs5GtHcXq5xtxu
 G/JzoAn/PkMZp1dpihSYXnwsgM9PoFRJnQevkeXPfuGLWQXqMPcO4GRW7U8yO+/B6+G9JK
 96CefN/V0kVJbo/zMxj2NRCLy0lTkwBK6g5WEYeb3hozBOIw6CtCuXcNuT6pLg==
Content-Transfer-Encoding: quoted-printable
To: "Nix" <nix@esperi.org.uk>
Cc: <linux-bcache@vger.kernel.org>
Date: Thu, 25 Sep 2025 00:04:55 +0800
Content-Type: text/plain; charset=UTF-8
X-Mailer: Apple Mail (2.3826.700.81)
In-Reply-To: <871poecngh.fsf@esperi.org.uk>
Received: from smtpclient.apple ([120.245.64.75]) by smtp.feishu.cn with ESMTPS; Thu, 25 Sep 2025 00:05:07 +0800
X-Original-From: Coly Li <colyli@fnnas.com>
From: "Coly Li" <colyli@fnnas.com>
Message-Id: <B7F547FD-BEE7-4910-BA69-5C6F2C9FE4E4@fnnas.com>
References: <87a536e3b5.fsf@esperi.org.uk> <C155231F-E439-46E5-8AFE-502CB75F183C@coly.li> <871poecngh.fsf@esperi.org.uk>
Subject: Re: gen wraparound warning: is this a problem?
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+268d416b4+02d43c+vger.kernel.org+colyli@fnnas.com>

> 2025=E5=B9=B49=E6=9C=8810=E6=97=A5 23:54=EF=BC=8CNix <nix@esperi.org.uk> =
=E5=86=99=E9=81=93=EF=BC=9A
>=20
> On 8 Sep 2025, Coly Li verbalised:
>=20
>>> 2025=E5=B9=B49=E6=9C=887=E6=97=A5 22:37=EF=BC=8CNix <nix@esperi.org.uk>=
 =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> So, out of the blue, I just got this for my long-standing writearound
>>> bcache setup (which covers my rootfs and $HOME, so I kind of care that
>>> it keeps working):
>=20
> (Oh, this is kernel 6.15.6 -- but that's only since Jul 20th. Before
> that, I was running 5.16.19 right back to April 2022, yes, I know... so
> it's possible this wasn't touched by *5.16* and thus this is a bug that
> was fixed long ago.)

IMHO this might not be a kernel bug, and just about time.

>=20
>>> These both map to this in bch_inc_gen():
>>>=20
>>>    WARN_ON_ONCE(ca->set->need_gc > BUCKET_GC_GEN_MAX);
>>=20
>> It seems a bucket has not been touched by garbage collection for a long =
time.
>=20
> Not too surprising: half-terabyte cache, and the xfs filesystems it
> backs only has 1.5TiB of data on it and not all of it is accessed
> frequently, and some is bypassed... so it can take a long time to gc
> through the entire cache :) it took months just to fill it.
>=20

Copied.



>>> Is this something the admin needs to do something about? (And, if it's
>>> not and bcache recovers smoothly, as so far it seems to -- though I
>>> haven't tried to remount it since the warning -- why do we warn about
>>> it at all?)
>>=20
>> I don=E2=80=99t know why this bucket is not touched by GC for such a lon=
g
>> time. It should not happen in my expectation.
>=20
> It's possible that *no* buckets were touched for a long time.
>=20

Yeah, I assumed for that.


>> To make sure everything is safe, I would suggest to writeback all the
>> dirty datas into backing device, detach the cache device, re-make the
>> cache device and attach backing device to it again.
>=20
> There is no dirty data (writethrough cache)... and this is backing the
> rootfs, among other things, so IIRC detaching is quite difficult and
> panic-prone to do (it's been many years, but I believe you can't do it
> while mounted?). I'll schedule it for the next reboot=E2=80=A6

If there is no dirty data on the cache, the cache device can be safely deta=
ched
from backing device while the bcache device is mounted.

echo 1 > /sys/block/<backing dev>/bcache/detach

Hope it works.

Thanks.

Coly Li

