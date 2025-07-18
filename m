Return-Path: <linux-bcache+bounces-1158-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AB175B09B3B
	for <lists+linux-bcache@lfdr.de>; Fri, 18 Jul 2025 08:18:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A389188D9DF
	for <lists+linux-bcache@lfdr.de>; Fri, 18 Jul 2025 06:18:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE6691E521B;
	Fri, 18 Jul 2025 06:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b="ERACsqGd"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail2.out.flockmail.com (mail2.out.flockmail.com [52.206.209.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03CF1552FD
	for <linux-bcache@vger.kernel.org>; Fri, 18 Jul 2025 06:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.206.209.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752819516; cv=none; b=WLfShXWRmfCMKynkun1gALUqkNlUOSRhe2MxzJ20vltT8rK52I0pu82ywPjOgmTlJa/1s4yDzH/Q4+JXdMPynjxGM+Rf42GJtuJsBuYlzVIfwx8SmVCxRTaPaaCtkZApu6X3+7YBJV6bu0/OXRu9F3izHVsRqjvLnBMTGmKNh/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752819516; c=relaxed/simple;
	bh=tGX7Wlz0wPEdQn19udVQNRnNHCoji00lrRiqKsp3G8A=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=dNbOblcVWQvGGRh6glKaK0+68m0WWycrwX4TsQELMI4QAf11AHQX6WPokQq29CpBtSHve3BxUXjQVldQbjFjeIYmol4a2yx21OJXObf7QqJH41rHKLMe0R5NTCBJ3YIirLYRAIPBpceJNQJWlxTc4ZiKhF4oq1NijakAZHxK1F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li; spf=pass smtp.mailfrom=coly.li; dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b=ERACsqGd; arc=none smtp.client-ip=52.206.209.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=coly.li
Received: from localhost (localhost [127.0.0.1])
	by smtp-out.flockmail.com (Postfix) with ESMTP id 4C7BE140024;
	Fri, 18 Jul 2025 06:09:33 +0000 (UTC)
DKIM-Signature: a=rsa-sha256; bh=78On3oXz9S7bJ5mG/CjUj1tcjOaSjPe35WUxntRFgp0=;
	c=relaxed/relaxed; d=t12smtp-sign004.email;
	h=mime-version:subject:from:date:cc:message-id:to:in-reply-to:references:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1752818973; v=1;
	b=ERACsqGdVOAjN3StaqsceniFpKHTZnB4u//mwy3qAq1/36sjvQhlNfie5p5iUonCzlSUFM+M
	kyWS5AY4jv/hw9G0lsT8x4JlHDliigpsZrhthbfdEOQcArDLYppm+A5VTCwZfFNFZ6k/ksI289/
	r9D7vBujaizJTIcIw6wbsVdE=
Received: from smtpclient.apple (ns3036696.ip-164-132-201.eu [164.132.201.48])
	by smtp-out.flockmail.com (Postfix) with ESMTPA id 72C3F140020;
	Fri, 18 Jul 2025 06:09:31 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [PATCH 0/1] bcache: reduce front IO latency during GC
Feedback-ID: :i@coly.li:coly.li:flockmailId
From: Coly Li <i@coly.li>
In-Reply-To: <CAJhEC06jacpCiautzfmnXUmt8x2d2nv-hEgmjnVX9yriDiV45Q@mail.gmail.com>
Date: Fri, 18 Jul 2025 14:09:19 +0800
Cc: Coly Li <colyli@kernel.org>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcache@vger.kernel.org,
 Mingzhe Zou <mingzhe.zou@easystack.cn>,
 Kuan-Wei Chiu <visitorckw@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <8D6417FA-0596-42F9-B8DD-25CA497E3370@coly.li>
References: <20250414224415.77926-1-robertpang@google.com>
 <75D48114-A5BD-4AC6-9370-D61456FD4FD2@coly.li>
 <CAJhEC07JauBGfqmEaYbV9XuLUkCdbart-gnbuMWYE7JwzG4CsA@mail.gmail.com>
 <CAJhEC04Po-OtwDe2Uxo2w-0yhgcemo5sn816sT7jNhnEdRxY4Q@mail.gmail.com>
 <pxfu7dxykuj2qnw4m2hyjohmwdyq562zlwnvdphqdbwvttztki@dyx4sa553clx>
 <CAJhEC06F_AtrPgw2-7CvCqZgeStgCtitbD-ryuPpXQA-JG5XXw@mail.gmail.com>
 <CAJhEC05tF6zthgSD2VmUHap2kYGgTWXz+uq4KOrGg_GAV_KKQQ@mail.gmail.com>
 <10F3457F-FC71-4D21-B2CA-05346B68D873@coly.li>
 <A52B16E2-DF9C-4C8A-9853-464385D1A7FA@coly.li>
 <CAJhEC06jacpCiautzfmnXUmt8x2d2nv-hEgmjnVX9yriDiV45Q@mail.gmail.com>
To: Robert Pang <robertpang@google.com>
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1752818973161435883.32042.8400446391709754651@prod-use1-smtp-out1003.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=YclH5xRf c=1 sm=1 tr=0 ts=6879e51d
	a=cqlkUh1Psg5J4QAqX6BmHg==:117 a=cqlkUh1Psg5J4QAqX6BmHg==:17
	a=IkcTkHD0fZMA:10 a=CEWIc4RMnpUA:10 a=NEAV23lmAAAA:8 a=1XWaLZrsAAAA:8
	a=oLVidFdP73vijPTVRdoA:9 a=QEXdDO2ut3YA:10

Hi Robert,

Thanks for the great effort! Let me take a look and respond later.

Coly Li

> 2025=E5=B9=B47=E6=9C=8818=E6=97=A5 06:52=EF=BC=8CRobert Pang =
<robertpang@google.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Coly
>=20
>>> With the min heap regression addressed by the recent revert [1], I =
am
>>> going to initiate a rerun of our last test set [2]. I will share the
>>> results as soon as they are available.
>=20
> My apologies for the delay in sharing the results due to my work =
schedule.
>=20
> I've completed the rerun of the tests, and the results are available
> for your review in [1]. As expected, the data confirms the desired
> latency improvements. Furthermore, I've checked for any unintended
> side effects and can confirm that no regressions were observed.
>=20
> Please take a look and let me know what you think. If there are any
> other specific scenarios or tests you would like me to execute to
> further validate the changes, please don't hesitate to let me know.
>=20
> Best regards
> Robert Pang
>=20
> [1] =
https://gist.github.com/robert-pang/a22b7c5dee2600be3260f4db57e5776d#file-=
test-results-md
>=20
> On Thu, Jul 3, 2025 at 9:47=E2=80=AFAM Coly Li <i@coly.li> wrote:
>>=20
>>=20
>>=20
>>> 2025=E5=B9=B47=E6=9C=883=E6=97=A5 23:34=EF=BC=8CColy Li <i@coly.li> =
=E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> Hi Robert,
>>>=20
>>>> 2025=E5=B9=B47=E6=9C=883=E6=97=A5 23:28=EF=BC=8CRobert Pang =
<robertpang@google.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>>=20
>>>> Hi Coly
>>>>=20
>>>> I'm writing to provide an update on this bcache GC latency patch.
>>>>=20
>>>> With the min heap regression addressed by the recent revert [1], I =
am
>>>> going to initiate a rerun of our last test set [2]. I will share =
the
>>>> results as soon as they are available.
>>>>=20
>>>> To ensure this patch is fully qualified for the next merge window, =
I'm
>>>> eager to perform any further tests you deem necessary. What =
additional
>>>> test scenarios would you recommend?"
>>>>=20
>>>=20
>>> Can you also do some full random write (4K and 64K block size) =
performance testing?
>>>=20
>>> If there is no performance regression (and I believe improvement =
will be observed), then let=E2=80=99s go ahead.
>>=20
>> BTW,  I don=E2=80=99t commit that this patch will go into next merge =
window.
>>=20
>> Thanks.
>>=20
>> Coly Li
>>=20
>>=20
>>=20
>=20


