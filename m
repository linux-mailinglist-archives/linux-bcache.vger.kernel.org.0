Return-Path: <linux-bcache+bounces-1104-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D38CACFD9B
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Jun 2025 09:40:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 05F561898629
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Jun 2025 07:40:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B36D625F98C;
	Fri,  6 Jun 2025 07:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FBmztCMZ"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5941E832E
	for <linux-bcache@vger.kernel.org>; Fri,  6 Jun 2025 07:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749195607; cv=none; b=ZEWR5nMKLukTR9D/y5HsdMxhuX1EBZkZyyCEDHguIzfEAZnQ7l96XixsVFCg6DdgEgzTN0KLsQ6dGmmqzc0WOrWEgL2pm6xvOlbRUjiJZ+lw3fUoon0e7YhtNhdRRh43oW5TDaj3gcyluAiSvaQiqzT1j3mUZpaS09JbcBpkXfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749195607; c=relaxed/simple;
	bh=KTfBK6QxhYslzCLAWE9grfglDYw22A+lK1C76ufWEr4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=haaLaxXB5tiiIYMEG/SZksIknNUZbOq6ho2HPK9zLV0bvCCPqUUtri4DeCJJlf/PXB8yUxaAgp+ztqPL5w7NdkMlmLNtf30N7LBjs/5M1mCOKmc36N1tZr38761THfJrDT5whJb7pLVb+LrbX0NhGWjOJy7ub5QowkKkda9+KxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FBmztCMZ; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4a5ac8fae12so304641cf.0
        for <linux-bcache@vger.kernel.org>; Fri, 06 Jun 2025 00:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749195605; x=1749800405; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DJW1J7otxC7IciBMLvYEaNenQ0XVXCzQpmplRM+0ddM=;
        b=FBmztCMZnj9cqds4MFHGy95F9CFSGUYaIb33A+csmRjc3eUZllsTM0z4hM1NxMfMf/
         xAzZfcxq3LARr7NGeKe9zX4mEAC0DvUHYtkrj8gU8DI4Pu1WvPtS47TvcRXw7O0dHmMX
         MtH5oxVvt1flP2ARukTP8OMNNWMkx0ucPIVjIaG6g/iP6gDuWGqUOVmKEOrggkt/SrO0
         f0Tk6/H8PglCADZex8BVR+vUzNpP69baLBt2JamNERchsDyMLp+Rq5FU9hpQOMXgddbK
         orpZNUT+GdE/gXxABFDdeZaKxR27Qab9DOEptiCSEK0cdnqkODcBwZKbrlHpOcOa5CJO
         b8Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749195605; x=1749800405;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DJW1J7otxC7IciBMLvYEaNenQ0XVXCzQpmplRM+0ddM=;
        b=K6MeOzIZNBmCcn4+LqcuJVIC8KETWHIdr+BlD8ZXse3Oi//IS1en/R67bBo3VBgXw3
         E09VQ73IGCJUftgXUCLQI6P9srPLdSdQkxH21yLa74hFkuQcfXLENpAzNmrHudB9oPQt
         56jnw+p12lUPhGeCLRqy2GR16riytAdVLjI2mrdcoIDlJoqjRbm0i4l1Qr6jrLMIIELa
         68qlIRJVfl8FSyAj0oEqn/KTyttFb/t6bHgpSrk5NC4y2FDUp2XI0auhBA4+u/40lpgu
         XTf4Z+M+z3nRjOEgjzoqpn4DYsQohkvR3WjKbhgi87Shjrde5ECCDc/7wkMSZ6coiwq2
         cLHw==
X-Forwarded-Encrypted: i=1; AJvYcCW4jqe0hf8yotRTD6sNlfl30uWpzRYvzJw4hc4hyoPTOROoIMBaj0pwZHtkkIi3pSmNoGTR0lOUB7RYJO0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCxwJKk3h1w5TP87yzL/Ns3Laddb3SUHl9UlZ3KQk0uyCSKAGg
	HqUhme4EZF7Yau4NlbNc4wAzEpwLIkgjpf86XqXT1qIlBGfn5tCkM+OQCYVegt945V76JreRXmO
	R8ZDaKMj06RqzKkzBmHEzSJcdT1phehc57iSB8vSDIQZL4A1f1mt2foVRSG4=
X-Gm-Gg: ASbGnctnm96tVcZDchiVPPYh8rHj5dU1AS0NdTrtVHE48POLq6VMg+XFa2RQY71qKnf
	P29jQsOY8qfz7Qul3Z+68JW4bX4H4mc4YDivlq6z2/V3JS5PphqzGwIEhGIsAZ/3O/Vb8mpps2h
	XLNMbySyiXpfgPHVwf2R4tEQwd/AEKITX6HWf5AHAdvA==
X-Google-Smtp-Source: AGHT+IHWCiFVj0Un3dY4r58cCwD0kar5SCMIyngODtKunszgWwzeH4VrWPOTF7LvQSz3AONRXZySiyufWJ1OGszTsJI=
X-Received: by 2002:a05:622a:1e07:b0:48a:42fa:78fa with SMTP id
 d75a77b69052e-4a5baa641afmr2807741cf.2.1749195604218; Fri, 06 Jun 2025
 00:40:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <pxfu7dxykuj2qnw4m2hyjohmwdyq562zlwnvdphqdbwvttztki@dyx4sa553clx>
 <CAJhEC06F_AtrPgw2-7CvCqZgeStgCtitbD-ryuPpXQA-JG5XXw@mail.gmail.com>
 <aCWTxp7/t8nnBuzD@visitorckw-System-Product-Name> <CAJhEC04qo8CFcFi6tmn9Y28MpasVB93Duboj1gqR1nfOXO+Z2g@mail.gmail.com>
 <aCdkgzPGWzcjXCrf@visitorckw-System-Product-Name> <AD23C0A6-E754-4E43-AF54-BCFF82B19450@coly.li>
 <aCxszsXC1QnHYTzS@visitorckw-System-Product-Name> <8CA66E96-4D39-4DB1-967C-6C0EDA73EBC1@coly.li>
 <aCx04pakaHTU5zD4@visitorckw-System-Product-Name> <79D96395-FFCF-43F8-8CCE-B1F9706A31DB@coly.li>
 <aC3l2J0zBj/OnKwj@visitorckw-System-Product-Name>
In-Reply-To: <aC3l2J0zBj/OnKwj@visitorckw-System-Product-Name>
From: Robert Pang <robertpang@google.com>
Date: Fri, 6 Jun 2025 00:39:52 -0700
X-Gm-Features: AX0GCFu_rzHTa7eThRTCTxGGq8u9NBBTHuHxiKNb1YMFCXXkn2l6VKMfI9P5Eoo
Message-ID: <CAJhEC07ZZrLYbGq5D+iB2G_a2LNn=fnTMAaZzXg3qzdVBoJFsA@mail.gmail.com>
Subject: Re: [PATCH 0/1] bcache: reduce front IO latency during GC
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Coly Li <i@coly.li>, Kent Overstreet <kent.overstreet@linux.dev>, Coly Li <colyli@kernel.org>, 
	linux-bcache@vger.kernel.org, Mingzhe Zou <mingzhe.zou@easystack.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kuan-Wei,

I'm circling back on our plan to address this regression. Based on our
discussions to-date, it seems a separate min_heap API that uses the
conventional top-down sift-down strategy is the preferred approach.

I've prototyped this idea and sent out a patch series [1] to kick off
the discussion on this approach. The patch has been running for over
12 hours and is looking promising. The API name is only my initial
thoughts and suggestions are welcome.

Given that this regression was introduced in Linux 6.11 and affects
versions up to 6.15 (including 6.12 LTS), a timely solution will be
important.

Best regress
Robert Pang

[1] https://lore.kernel.org/linux-bcache/20250606071959.1685079-1-robertpan=
g@google.com/T/#t


On Wed, May 21, 2025 at 7:40=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmail.com=
> wrote:
>
> On Tue, May 20, 2025 at 09:13:09PM +0800, Coly Li wrote:
> >
> >
> > > 2025=E5=B9=B45=E6=9C=8820=E6=97=A5 20:26=EF=BC=8CKuan-Wei Chiu <visit=
orckw@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > On Tue, May 20, 2025 at 08:13:47PM +0800, Coly Li wrote:
> > >>
> > >>
> > >>> 2025=E5=B9=B45=E6=9C=8820=E6=97=A5 19:51=EF=BC=8CKuan-Wei Chiu <vis=
itorckw@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> > >>>
> > >>> On Sat, May 17, 2025 at 07:02:06PM +0800, Coly Li wrote:
> > >>>>
> > >>>>
> > >>>>> 2025=E5=B9=B45=E6=9C=8817=E6=97=A5 00:14=EF=BC=8CKuan-Wei Chiu <v=
isitorckw@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> > >>>>>
> > >>>>> On Thu, May 15, 2025 at 08:58:44PM -0700, Robert Pang wrote:
> > >>>>>> Hi Kuan-Wei,
> > >>>>>>
> > >>>>>> Thank you for your prompt response. I tested your suggested patc=
h to
> > >>>>>> inline the min heap operations for 8 hours and it is still ongoi=
ng.
> > >>>>>> Unfortunately, basing on the results so far, it didn't resolve t=
he
> > >>>>>> regression, suggesting inlining isn't the issue.
> > >>>>>>
> > >>>>>> After reviewing the commits in lib/min_heap.h, I noticed commit
> > >>>>>> c641722 ("lib min_heap: optimize number of comparisons in
> > >>>>>> min_heapify()") and it looked like a potential candidate. I reve=
rted
> > >>>>>> this commit (below) and ran the tests. While the test is still
> > >>>>>> ongoing, the results for the past 3 hours show that the latency =
spikes
> > >>>>>> during invalidate_buckets_lru() disappeared after this change,
> > >>>>>> indicating that this commit is likely the root cause of the
> > >>>>>> regression.
> > >>>>>>
> > >>>>>> My hypothesis is that while commit c641722 was designed to reduc=
e
> > >>>>>> comparisons with randomized input [1], it might inadvertently in=
crease
> > >>>>>> comparisons when the input isn't as random. A scenario where thi=
s
> > >>>>>> could happen is within invalidate_buckets_lru() before the cache=
 is
> > >>>>>> fully populated. In such cases, many buckets are unfilled, causi=
ng
> > >>>>>> new_bucket_prio() to return zero, leading to more frequent
> > >>>>>> compare-equal operations with other unfilled buckets. In the cas=
e when
> > >>>>>> the cache is populated, the bucket priorities fall in a range wi=
th
> > >>>>>> many duplicates. How will heap_sift() behave in such cases?
> > >>>>>>
> > >>>>>> [1] https://lore.kernel.org/linux-bcache/20240121153649.2733274-=
6-visitorckw@gmail.com/
> > >>>>>>
> > >>>>>
> > >>>>> You're very likely correct.
> > >>>>>
> > >>>>> In scenarios where the majority of elements in the heap are ident=
ical,
> > >>>>> the traditional top-down version of heapify finishes after just 2
> > >>>>> comparisons. However, with the bottom-up version introduced by th=
at
> > >>>>> commit, it ends up performing roughly 2 * log=E2=82=82(n) compari=
sons in the
> > >>>>> same case.
> > >>>>
> > >>>> For bcache scenario for ideal circumstances and best performance, =
the cached data
> > >>>> and following requests should have spatial or temporal locality.
> > >>>>
> > >>>> I guess it means for the heap usage, the input might not be typica=
l random.
> > >>>>
> > >>>>
> > >>>>>
> > >>>>> That said, reverting the commit would increase the number of
> > >>>>> comparisons by about 2x in cases where all elements in the heap a=
re
> > >>>>> distinct, which was the original motivation for the change. I'm n=
ot
> > >>>>> entirely sure what the best way would be to fix this regression w=
ithout
> > >>>>> negatively impacting the performance of the other use cases.
> > >>>>
> > >>>> If the data read model are fully sequential or random, bcache cann=
ot help too much.
> > >>>>
> > >>>> So I guess maybe we still need to old heapify code? The new versio=
n is for full random input,
> > >>>> and previous version for not that much random input.
> > >>>>
> > >>>
> > >>> I think we have two options here. One is to add a classic heapify
> > >>> function to min_heap.h, allowing users to choose based on whether t=
hey
> > >>> expect many duplicate elements in the heap. While having two heapif=
y
> > >>> variants might be confusing from a library design perspective, we c=
ould
> > >>> mitigate that with clear kernel-doc comments. The other option is t=
o
> > >>> revert to the old bcache heap code. I'm not sure which approach is
> > >>> better.
> > >>>
> > >>
> > >> I prefer to have two min_heap APIs, but how to name them, this is a =
question from me.
> > >>
> > >> Also if the full-random min_heap version has no user in kernel, whet=
her to keep it in kernel also is a question.
> > >
> > > From the perspective of the number of comparisons in heapify, what
> > > matters more is whether the data contains many equal elements, rather
> > > than whether it's truly random. I assume that for most other kernel
> > > users, their use cases don't typically involve a large number of equa=
l
> > > elements?
> > >
> >
> > Yes, you are right.  Maybe dm-vdo also has similar I/O pattern?
> >
> > Deduplication may also have duplicated items in heap I guess.
> >
>
> Thanks for pointing out this potential issue.
> I'll check with Matthew to confirm.
>
> Regards,
> Kuan-Wei
>
> > Thanks.
> >
> >
> > >>
> > >> Kent,
> > >> Could you please offer your opinion?
> > >>
> > >> Thanks.
> > >>
> > >> Coly Li
> >
> >

