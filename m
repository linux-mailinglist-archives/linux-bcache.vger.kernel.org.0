Return-Path: <linux-bcache+bounces-1075-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2E88ABE23E
	for <lists+linux-bcache@lfdr.de>; Tue, 20 May 2025 20:01:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A64F16BA46
	for <lists+linux-bcache@lfdr.de>; Tue, 20 May 2025 18:01:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA45A1754B;
	Tue, 20 May 2025 18:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b="uYfp97yA"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail82.out.titan.email (mail82.out.titan.email [3.216.99.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FA24C9D
	for <linux-bcache@vger.kernel.org>; Tue, 20 May 2025 18:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.216.99.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747764078; cv=none; b=lGYgPLCGi/FIKyiSl47FHzu/xx5mX1JbJoTEkCaFnGAb5Z9ZNq9Pcanb5Z2sdmLpkPzaad7BmdPTY/AfrWPGakK1d8lcuWzXzCJ0OTHqywM69Uo/lhBNWY0Ss7aq4TQ3Nt5bBlfRG2DXcDS4zNxj2tDK0C4P41Nu7fZ1VHoGvcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747764078; c=relaxed/simple;
	bh=aBZEp/8Bm9RZBx+o6o+/3s97F1UqQvJavnsYyXpo9yc=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=YcO5RTT3AfuxSS7z6U5hiRUtb4ac00+rzsIvXwBow4vrQTDT6SHewm4Wp3421F8lSBS+cVtFOgExfUBTmMULS3AY2XK2BN9e0eTT48RDWrl9V60QfnpaqjjOIzL4VK1UOJ7noIQjI7EgYH0Pp8mdr++Y+z27PDrZ+ncjTS09NUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li; spf=pass smtp.mailfrom=coly.li; dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b=uYfp97yA; arc=none smtp.client-ip=3.216.99.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=coly.li
Received: from localhost (localhost [127.0.0.1])
	by smtp-out.flockmail.com (Postfix) with ESMTP id 12EA9602A5;
	Tue, 20 May 2025 13:13:24 +0000 (UTC)
DKIM-Signature: a=rsa-sha256; bh=4XFtYE65Ly4zeoO3VblwIreBx4qg27q6qnYGnMIuHhE=;
	c=relaxed/relaxed; d=t12smtp-sign004.email;
	h=date:cc:from:in-reply-to:references:mime-version:subject:message-id:to:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1747746803; v=1;
	b=uYfp97yAQHL6HEBMso14e2/0YSLHxQRHubnWIG0d02zBWF5koBdVidmRljZNU1h+X8fCE9uL
	KKX443y9pTvvnR25RhFUZEyGmqII8ZHLNmlHhO6dNLIXGrKyXTsQV12qorje8mteOgDRNbpi5DQ
	nbgyZnf+KdUZY7zL+hmcV2FM=
Received: from smtpclient.apple (n218103205009.netvigator.com [218.103.205.9])
	by smtp-out.flockmail.com (Postfix) with ESMTPA id 995FC6076A;
	Tue, 20 May 2025 13:13:21 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [PATCH 0/1] bcache: reduce front IO latency during GC
Feedback-ID: :i@coly.li:coly.li:flockmailId
From: Coly Li <i@coly.li>
In-Reply-To: <aCx04pakaHTU5zD4@visitorckw-System-Product-Name>
Date: Tue, 20 May 2025 21:13:09 +0800
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Robert Pang <robertpang@google.com>,
 Coly Li <colyli@kernel.org>,
 linux-bcache@vger.kernel.org,
 Mingzhe Zou <mingzhe.zou@easystack.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <79D96395-FFCF-43F8-8CCE-B1F9706A31DB@coly.li>
References: <CAJhEC07JauBGfqmEaYbV9XuLUkCdbart-gnbuMWYE7JwzG4CsA@mail.gmail.com>
 <CAJhEC04Po-OtwDe2Uxo2w-0yhgcemo5sn816sT7jNhnEdRxY4Q@mail.gmail.com>
 <pxfu7dxykuj2qnw4m2hyjohmwdyq562zlwnvdphqdbwvttztki@dyx4sa553clx>
 <CAJhEC06F_AtrPgw2-7CvCqZgeStgCtitbD-ryuPpXQA-JG5XXw@mail.gmail.com>
 <aCWTxp7/t8nnBuzD@visitorckw-System-Product-Name>
 <CAJhEC04qo8CFcFi6tmn9Y28MpasVB93Duboj1gqR1nfOXO+Z2g@mail.gmail.com>
 <aCdkgzPGWzcjXCrf@visitorckw-System-Product-Name>
 <AD23C0A6-E754-4E43-AF54-BCFF82B19450@coly.li>
 <aCxszsXC1QnHYTzS@visitorckw-System-Product-Name>
 <8CA66E96-4D39-4DB1-967C-6C0EDA73EBC1@coly.li>
 <aCx04pakaHTU5zD4@visitorckw-System-Product-Name>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
X-Mailer: Apple Mail (2.3826.500.181.1.5)
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1747746803930834926.5242.7522452172738627007@prod-use1-smtp-out1001.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=A8iWP7WG c=1 sm=1 tr=0 ts=682c7ff3
	a=eJNHGpZBYRW47XJYT+WeIA==:117 a=eJNHGpZBYRW47XJYT+WeIA==:17
	a=IkcTkHD0fZMA:10 a=CEWIc4RMnpUA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
	a=PAZ-QNxxQAxaB0R8VxYA:9 a=QEXdDO2ut3YA:10



> 2025=E5=B9=B45=E6=9C=8820=E6=97=A5 20:26=EF=BC=8CKuan-Wei Chiu =
<visitorckw@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Tue, May 20, 2025 at 08:13:47PM +0800, Coly Li wrote:
>>=20
>>=20
>>> 2025=E5=B9=B45=E6=9C=8820=E6=97=A5 19:51=EF=BC=8CKuan-Wei Chiu =
<visitorckw@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> On Sat, May 17, 2025 at 07:02:06PM +0800, Coly Li wrote:
>>>>=20
>>>>=20
>>>>> 2025=E5=B9=B45=E6=9C=8817=E6=97=A5 00:14=EF=BC=8CKuan-Wei Chiu =
<visitorckw@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>>>=20
>>>>> On Thu, May 15, 2025 at 08:58:44PM -0700, Robert Pang wrote:
>>>>>> Hi Kuan-Wei,
>>>>>>=20
>>>>>> Thank you for your prompt response. I tested your suggested patch =
to
>>>>>> inline the min heap operations for 8 hours and it is still =
ongoing.
>>>>>> Unfortunately, basing on the results so far, it didn't resolve =
the
>>>>>> regression, suggesting inlining isn't the issue.
>>>>>>=20
>>>>>> After reviewing the commits in lib/min_heap.h, I noticed commit
>>>>>> c641722 ("lib min_heap: optimize number of comparisons in
>>>>>> min_heapify()") and it looked like a potential candidate. I =
reverted
>>>>>> this commit (below) and ran the tests. While the test is still
>>>>>> ongoing, the results for the past 3 hours show that the latency =
spikes
>>>>>> during invalidate_buckets_lru() disappeared after this change,
>>>>>> indicating that this commit is likely the root cause of the
>>>>>> regression.
>>>>>>=20
>>>>>> My hypothesis is that while commit c641722 was designed to reduce
>>>>>> comparisons with randomized input [1], it might inadvertently =
increase
>>>>>> comparisons when the input isn't as random. A scenario where this
>>>>>> could happen is within invalidate_buckets_lru() before the cache =
is
>>>>>> fully populated. In such cases, many buckets are unfilled, =
causing
>>>>>> new_bucket_prio() to return zero, leading to more frequent
>>>>>> compare-equal operations with other unfilled buckets. In the case =
when
>>>>>> the cache is populated, the bucket priorities fall in a range =
with
>>>>>> many duplicates. How will heap_sift() behave in such cases?
>>>>>>=20
>>>>>> [1] =
https://lore.kernel.org/linux-bcache/20240121153649.2733274-6-visitorckw@g=
mail.com/
>>>>>>=20
>>>>>=20
>>>>> You're very likely correct.
>>>>>=20
>>>>> In scenarios where the majority of elements in the heap are =
identical,
>>>>> the traditional top-down version of heapify finishes after just 2
>>>>> comparisons. However, with the bottom-up version introduced by =
that
>>>>> commit, it ends up performing roughly 2 * log=E2=82=82(n) =
comparisons in the
>>>>> same case.
>>>>=20
>>>> For bcache scenario for ideal circumstances and best performance, =
the cached data
>>>> and following requests should have spatial or temporal locality.
>>>>=20
>>>> I guess it means for the heap usage, the input might not be typical =
random.
>>>>=20
>>>>=20
>>>>>=20
>>>>> That said, reverting the commit would increase the number of
>>>>> comparisons by about 2x in cases where all elements in the heap =
are
>>>>> distinct, which was the original motivation for the change. I'm =
not
>>>>> entirely sure what the best way would be to fix this regression =
without
>>>>> negatively impacting the performance of the other use cases.
>>>>=20
>>>> If the data read model are fully sequential or random, bcache =
cannot help too much.
>>>>=20
>>>> So I guess maybe we still need to old heapify code? The new version =
is for full random input,
>>>> and previous version for not that much random input.
>>>>=20
>>>=20
>>> I think we have two options here. One is to add a classic heapify
>>> function to min_heap.h, allowing users to choose based on whether =
they
>>> expect many duplicate elements in the heap. While having two heapify
>>> variants might be confusing from a library design perspective, we =
could
>>> mitigate that with clear kernel-doc comments. The other option is to
>>> revert to the old bcache heap code. I'm not sure which approach is
>>> better.
>>>=20
>>=20
>> I prefer to have two min_heap APIs, but how to name them, this is a =
question from me.
>>=20
>> Also if the full-random min_heap version has no user in kernel, =
whether to keep it in kernel also is a question.
>=20
> =46rom the perspective of the number of comparisons in heapify, what
> matters more is whether the data contains many equal elements, rather
> than whether it's truly random. I assume that for most other kernel
> users, their use cases don't typically involve a large number of equal
> elements?
>=20

Yes, you are right.  Maybe dm-vdo also has similar I/O pattern?

Deduplication may also have duplicated items in heap I guess.

Thanks.


>>=20
>> Kent,
>> Could you please offer your opinion?
>>=20
>> Thanks.
>>=20
>> Coly Li



