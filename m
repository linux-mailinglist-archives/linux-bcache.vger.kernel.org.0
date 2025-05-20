Return-Path: <linux-bcache+bounces-1074-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4038CABD837
	for <lists+linux-bcache@lfdr.de>; Tue, 20 May 2025 14:30:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5731A1B6212D
	for <lists+linux-bcache@lfdr.de>; Tue, 20 May 2025 12:30:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2280E155322;
	Tue, 20 May 2025 12:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b="Xuvzs4Nm"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail77.out.titan.email (mail77.out.titan.email [3.216.99.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014942C18A
	for <linux-bcache@vger.kernel.org>; Tue, 20 May 2025 12:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.216.99.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747744204; cv=none; b=TFbNU8QmtNnSNMjbxmHxTrxD+ldjTHaumzA9eM8ExmuVfAE8Tu1w+Cdwpqt/brtTr8Ecj43yHFS41sIvAtpX0+J65gEA3UK4Py+Zo6CmRUGXEzFtslxrIiu4IyFplxkp/7fYaWMXjitKOKZ19iquXl6OkwlUSjIVZRg4LcGW4L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747744204; c=relaxed/simple;
	bh=PVtLV9laKxcFf6Yc5iX540g7tZ+2rWlN/6GkTKHRz94=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=hdr8Zwmcj3JT+raj0A/awyRMzooCJNRAikpQT53AGMmP/F9o9H4RFvAYwU3H3edsmxv8oHH0tJvcPVsN3/Riuv0lVjRstXeNPWpd1AKAOH6+9s5kF2zXwxehvEmR+plbU8MQs5ff0AkxalWR8mEzYo+7KHNmZXkFYwx6YjUCJtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li; spf=pass smtp.mailfrom=coly.li; dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b=Xuvzs4Nm; arc=none smtp.client-ip=3.216.99.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=coly.li
Received: from localhost (localhost [127.0.0.1])
	by smtp-out.flockmail.com (Postfix) with ESMTP id 1ED1C1406DA;
	Tue, 20 May 2025 12:13:59 +0000 (UTC)
DKIM-Signature: a=rsa-sha256; bh=PVtLV9laKxcFf6Yc5iX540g7tZ+2rWlN/6GkTKHRz94=;
	c=relaxed/relaxed; d=t12smtp-sign004.email;
	h=subject:date:to:from:cc:references:mime-version:in-reply-to:message-id:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1747743238; v=1;
	b=Xuvzs4Nmk56LBpbDHuhc5CYmYB4Ccm7Hr/M3/BKqvXh61Afy5zbdMTUTPfjd9U9vqeeoYLDe
	Nvv0J6TEkgcXpZD6CWubSlQjZO6KyciDESQUS+JOk59yZVTp/C616PDpnSoYabgzPmXr/j/2hGv
	vpqdT//Vi8PRqpoCE/r6zcns=
Received: from smtpclient.apple (n218103205009.netvigator.com [218.103.205.9])
	by smtp-out.flockmail.com (Postfix) with ESMTPA id C8B221401C6;
	Tue, 20 May 2025 12:13:56 +0000 (UTC)
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
In-Reply-To: <aCxszsXC1QnHYTzS@visitorckw-System-Product-Name>
Date: Tue, 20 May 2025 20:13:47 +0800
Cc: Robert Pang <robertpang@google.com>,
 Coly Li <colyli@kernel.org>,
 linux-bcache@vger.kernel.org,
 Mingzhe Zou <mingzhe.zou@easystack.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <8CA66E96-4D39-4DB1-967C-6C0EDA73EBC1@coly.li>
References: <20250414224415.77926-1-robertpang@google.com>
 <75D48114-A5BD-4AC6-9370-D61456FD4FD2@coly.li>
 <CAJhEC07JauBGfqmEaYbV9XuLUkCdbart-gnbuMWYE7JwzG4CsA@mail.gmail.com>
 <CAJhEC04Po-OtwDe2Uxo2w-0yhgcemo5sn816sT7jNhnEdRxY4Q@mail.gmail.com>
 <pxfu7dxykuj2qnw4m2hyjohmwdyq562zlwnvdphqdbwvttztki@dyx4sa553clx>
 <CAJhEC06F_AtrPgw2-7CvCqZgeStgCtitbD-ryuPpXQA-JG5XXw@mail.gmail.com>
 <aCWTxp7/t8nnBuzD@visitorckw-System-Product-Name>
 <CAJhEC04qo8CFcFi6tmn9Y28MpasVB93Duboj1gqR1nfOXO+Z2g@mail.gmail.com>
 <aCdkgzPGWzcjXCrf@visitorckw-System-Product-Name>
 <AD23C0A6-E754-4E43-AF54-BCFF82B19450@coly.li>
 <aCxszsXC1QnHYTzS@visitorckw-System-Product-Name>
To: Kuan-Wei Chiu <visitorckw@gmail.com>,
 Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3826.500.181.1.5)
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1747743238867686890.32042.8687302548720394528@prod-use1-smtp-out1003.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=U8BoDfru c=1 sm=1 tr=0 ts=682c7206
	a=eJNHGpZBYRW47XJYT+WeIA==:117 a=eJNHGpZBYRW47XJYT+WeIA==:17
	a=IkcTkHD0fZMA:10 a=CEWIc4RMnpUA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
	a=soO3Ray3s_zbp76wwXsA:9 a=QEXdDO2ut3YA:10



> 2025=E5=B9=B45=E6=9C=8820=E6=97=A5 19:51=EF=BC=8CKuan-Wei Chiu =
<visitorckw@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Sat, May 17, 2025 at 07:02:06PM +0800, Coly Li wrote:
>>=20
>>=20
>>> 2025=E5=B9=B45=E6=9C=8817=E6=97=A5 00:14=EF=BC=8CKuan-Wei Chiu =
<visitorckw@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> On Thu, May 15, 2025 at 08:58:44PM -0700, Robert Pang wrote:
>>>> Hi Kuan-Wei,
>>>>=20
>>>> Thank you for your prompt response. I tested your suggested patch =
to
>>>> inline the min heap operations for 8 hours and it is still ongoing.
>>>> Unfortunately, basing on the results so far, it didn't resolve the
>>>> regression, suggesting inlining isn't the issue.
>>>>=20
>>>> After reviewing the commits in lib/min_heap.h, I noticed commit
>>>> c641722 ("lib min_heap: optimize number of comparisons in
>>>> min_heapify()") and it looked like a potential candidate. I =
reverted
>>>> this commit (below) and ran the tests. While the test is still
>>>> ongoing, the results for the past 3 hours show that the latency =
spikes
>>>> during invalidate_buckets_lru() disappeared after this change,
>>>> indicating that this commit is likely the root cause of the
>>>> regression.
>>>>=20
>>>> My hypothesis is that while commit c641722 was designed to reduce
>>>> comparisons with randomized input [1], it might inadvertently =
increase
>>>> comparisons when the input isn't as random. A scenario where this
>>>> could happen is within invalidate_buckets_lru() before the cache is
>>>> fully populated. In such cases, many buckets are unfilled, causing
>>>> new_bucket_prio() to return zero, leading to more frequent
>>>> compare-equal operations with other unfilled buckets. In the case =
when
>>>> the cache is populated, the bucket priorities fall in a range with
>>>> many duplicates. How will heap_sift() behave in such cases?
>>>>=20
>>>> [1] =
https://lore.kernel.org/linux-bcache/20240121153649.2733274-6-visitorckw@g=
mail.com/
>>>>=20
>>>=20
>>> You're very likely correct.
>>>=20
>>> In scenarios where the majority of elements in the heap are =
identical,
>>> the traditional top-down version of heapify finishes after just 2
>>> comparisons. However, with the bottom-up version introduced by that
>>> commit, it ends up performing roughly 2 * log=E2=82=82(n) =
comparisons in the
>>> same case.
>>=20
>> For bcache scenario for ideal circumstances and best performance, the =
cached data
>> and following requests should have spatial or temporal locality.
>>=20
>> I guess it means for the heap usage, the input might not be typical =
random.
>>=20
>>=20
>>>=20
>>> That said, reverting the commit would increase the number of
>>> comparisons by about 2x in cases where all elements in the heap are
>>> distinct, which was the original motivation for the change. I'm not
>>> entirely sure what the best way would be to fix this regression =
without
>>> negatively impacting the performance of the other use cases.
>>=20
>> If the data read model are fully sequential or random, bcache cannot =
help too much.
>>=20
>> So I guess maybe we still need to old heapify code? The new version =
is for full random input,
>> and previous version for not that much random input.
>>=20
>=20
> I think we have two options here. One is to add a classic heapify
> function to min_heap.h, allowing users to choose based on whether they
> expect many duplicate elements in the heap. While having two heapify
> variants might be confusing from a library design perspective, we =
could
> mitigate that with clear kernel-doc comments. The other option is to
> revert to the old bcache heap code. I'm not sure which approach is
> better.
>=20

I prefer to have two min_heap APIs, but how to name them, this is a =
question from me.

Also if the full-random min_heap version has no user in kernel, whether =
to keep it in kernel also is a question.

Kent,
Could you please offer your opinion?

Thanks.

Coly Li


