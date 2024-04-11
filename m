Return-Path: <linux-bcache+bounces-396-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E7428A08A8
	for <lists+linux-bcache@lfdr.de>; Thu, 11 Apr 2024 08:44:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2BE71C21171
	for <lists+linux-bcache@lfdr.de>; Thu, 11 Apr 2024 06:44:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B85BC13D613;
	Thu, 11 Apr 2024 06:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XjzggpwK"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD99713CA96
	for <linux-bcache@vger.kernel.org>; Thu, 11 Apr 2024 06:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712817867; cv=none; b=LrSic9bJ+rHavT2jxx39P4EeV9176XSuh5zO6VhiltCbtwiZmqs/DEBg4yfNw0ubBS1M9E2khKxE/0oSqRPP5yyP6+AqZFJ8D+kQ7SUFIZnvqtaB2OKRKaC/kJxBo2tjtTY1gAtSrEulGw/jLI9HE3i/EpaBxiVq5aCGuw6lZrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712817867; c=relaxed/simple;
	bh=h6NjZ+OTz7PrJdOp5GSPR2ZfwveoOF4QGhQ7FHriEKk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AQZlRpdOe5IEUrGMnHLB7s2ZzgE7cPFpkntRPqM6NDSAgw9btoUX785gA7CUAekjY02jrstwZzNiC+g0IzJN0qG/R10HjMVI5QnHrNEkmH7oJvFPJTJtIFMJMGqYqNvAHLyBgk3crGMEOnCafGLP2GlCYSFyX6kqrrB6t5tHIeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XjzggpwK; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-41641a889ccso43725e9.1
        for <linux-bcache@vger.kernel.org>; Wed, 10 Apr 2024 23:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712817864; x=1713422664; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h6NjZ+OTz7PrJdOp5GSPR2ZfwveoOF4QGhQ7FHriEKk=;
        b=XjzggpwKoBLEmMmvrnnqgHd1xdznUGUW0bjEfTvuHq9PgkyAF/IMw0Yh4tnKRKs27f
         Tnbu5qXG20gX9miFQ3x+v+342deLmxu7oAL7IMqAf614A94TDVG6OuyCTbk4bSvZgRDx
         wHAG3Xb/ux1vUV9e/QyKqatfcSIWm3E5zaMvDCuVr0pkhvUJMSTxNRXP0kjS5oVRhZhU
         /pThQ2rJW34fWKb0tHhsBFybfkc1RY9mtHXq5a+ntd1QjhnwwahnSeA89s5YLTuYhDPI
         AXuGMWKBeAdYSbl5erSQKTZ9C64gI0VWQqQiK/vrEsjCxLiHySKBybg8eNMTNZPghzCB
         ySBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712817864; x=1713422664;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h6NjZ+OTz7PrJdOp5GSPR2ZfwveoOF4QGhQ7FHriEKk=;
        b=lnkwmUb0Bl1BwX6uVtkpYgPLcZpqJIEakSvZ1ntkhltcfrJkAlNiZY8mFyAGMrOZ+I
         +BGWQB3I3TRikSjuVMbkCdhiSXJGo6E/EJNAIJqYh+zCY2I8pmyzvJfuwPZpkpch0Qb8
         yBinZ5UIlL66j1oQmAEvcwn7EleSPx7AjkQuU0Tjz/vHrFxwgUkcPCM5ndn0n0i8EBaj
         bGHDh7q3lEPnlDKnlgVaIuLlD0hGwaanmFlD0mfBD1eLz2iX3P4bmAcYMhH4qp99dcVu
         F9f4I8U+adPruQeY91GmXK8iYdJfpKxeFkP1quwQIjyZ/EtUNW4mahDz4LdUMYKXAmbZ
         2+9A==
X-Forwarded-Encrypted: i=1; AJvYcCX/sxJpNn6lbhaUCNSjh8rtZmjsZ7I20VP3I6Bt8oam5lCGUnoq0X8H3ev9FQpYk/3lidxBrRombJVhRlEpnzAXKg56ZtN3khH7WTo0
X-Gm-Message-State: AOJu0YwnEsuRwSzkHRmxODwZ0JcKa0D1WZqGIyH9jXlRaiZYwv7xXAoY
	LQ/RB7q9vQjXl/Njgs/qWHNPj1rBqLV3Vv4UudoYH/ZcoRYKhlfbWqHmTuHyts7oud65ZKJMef5
	+EpgUFIp4lO1aXFS24tJFZ1BA4QMPKXCT8s8WYo+pxqL7idxZrDn7
X-Google-Smtp-Source: AGHT+IFe+9sSCTKx7X4zAZz2PY4j3ww3zBJc8WCPOxgP8ipOA1ZEmj1hHfwjgMTzVbGv+i8d+H92rbHUKoJoj2leSLY=
X-Received: by 2002:a05:600c:3503:b0:416:6d90:38fe with SMTP id
 h3-20020a05600c350300b004166d9038femr123928wmq.4.1712817863781; Wed, 10 Apr
 2024 23:44:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1ddde040-9bde-515a-1d4d-b41de472a702@suse.de> <20240315224527.694458-1-robertpang@google.com>
 <584A2724-ACA2-4000-A8D2-50B6AA5684A7@suse.de> <CAJhEC06dsqq2y4MNCW7t52cPc1=PbStGTBOddZofg4vqGKkQsA@mail.gmail.com>
 <5B79FFA6-1995-4167-8318-3EDCC6F0B432@suse.de> <CAJhEC07hAWsW5Aq0=hCCAXJGKU47L_n8a0mQ-SjOq2wqGAj_gA@mail.gmail.com>
 <CAJhEC05TrboyqKAn0i5D72LWBs7bZ05qFrPedgmNWy8A7qYmOA@mail.gmail.com> <C787D2E8-6D03-4F4D-9633-2237AA0B2BE7@suse.de>
In-Reply-To: <C787D2E8-6D03-4F4D-9633-2237AA0B2BE7@suse.de>
From: Robert Pang <robertpang@google.com>
Date: Wed, 10 Apr 2024 23:44:11 -0700
Message-ID: <CAJhEC05hzf2zVyJabVExFNF0esiLovc+WLHOY_YhV22OUdGFZw@mail.gmail.com>
Subject: Re: [PATCH v2] bcache: allow allocator to invalidate bucket in gc
To: Coly Li <colyli@suse.de>
Cc: Dongsheng Yang <dongsheng.yang@easystack.cn>, 
	Bcache Linux <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

HI Coly

Thank you for submitting it in the next merge window. This patch is
very critical because the long IO stall measured in tens of seconds
every hour is a serious issue making bcache unusable when it happens.
So we look forward to this patch.

Speaking of this GC issue, we gathered the bcache btree GC stats after
our fio benchmark on a 375GB SSD cache device with 256kB bucket size:

$ grep . /sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree=
_gc_*
/sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree_gc_avera=
ge_duration_ms:45293
/sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree_gc_avera=
ge_frequency_sec:286
/sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree_gc_last_=
sec:212
/sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree_gc_max_d=
uration_ms:61986
$ more /sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree_n=
odes
5876

However, fio directly on the SSD device itself shows pretty good performanc=
e:

Read IOPS 14,100 (110MiB/s)
Write IOPS 42,200 (330MiB/s)
Latency: 106.64 microseconds

Can you shed some light on why CG takes so long (avg 45 seconds) given
the SSD speed? And is there any way or setting to reduce the CG time
or lower the GC frequency?

One interesting thing we observed is when the SSD is encrypted via
dm-crypt, the GC time is shortened ~80% to be under 10 seconds. Is it
possible that GC writes the blocks one-by-one synchronously, and
dm-crypt's internal queuing and buffering mitigates the GC IO latency?

Thanks
Robert


On Fri, Mar 29, 2024 at 6:00=E2=80=AFAM Coly Li <colyli@suse.de> wrote:
>
>
>
> > 2024=E5=B9=B43=E6=9C=8829=E6=97=A5 02:05=EF=BC=8CRobert Pang <robertpan=
g@google.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > Hi bcache developers
> >
> > Greetings. Any update on this patch? How are things going with the
> > testing and submission upstream?
>
> Hi Peng,
>
> As I said, it will be in next merge window, not this one. If there is hel=
p necessary, I will ask :-)
>
> Thanks.
>
> Coly Li
>
>
> >
> >
> > On Sun, Mar 17, 2024 at 11:16=E2=80=AFPM Robert Pang <robertpang@google=
.com> wrote:
> >>
> >> Hi Coly
> >>
> >> Thank you for confirming. It looks like the 6.9 merge window just
> >> opened last week so we hope it can catch it. Please update in this
> >> thread when it gets submitted.
> >>
> >> https://lore.kernel.org/lkml/CAHk-=3Dwiehc0DfPtL6fC2=3DbFuyzkTnuiuYSQr=
r6JTQxQao6pq1Q@mail.gmail.com/T/
> >>
> >> BTW, speaking of testing, mind if you point us to the bcache test
> >> suite? We would like to have a look and maybe give it a try also.
> >>
> >> Thanks
> >> Robert
> >>
> >> On Sun, Mar 17, 2024 at 7:00=E2=80=AFAM Coly Li <colyli@suse.de> wrote=
:
> >>>
> >>>
> >>>
> >>>> 2024=E5=B9=B43=E6=9C=8817=E6=97=A5 13:41=EF=BC=8CRobert Pang <robert=
pang@google.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>>>
> >>>> Hi Coly
> >>>>
> >>>
> >>> Hi Robert,
> >>>
> >>>> Thank you for looking into this issue.
> >>>>
> >>>> We tested this patch in 5 machines with local SSD size ranging from
> >>>> 375 GB to 9 TB, and ran tests for 10 to 12 hours each. We observed n=
o
> >>>> stall nor other issues. Performance was comparable before and after
> >>>> the patch. Hope this info will be helpful.
> >>>
> >>> Thanks for the information.
> >>>
> >>> Also I was told this patch has been deployed and shipped for 1+ year =
in easystack products, works well.
> >>>
> >>> The above information makes me feel confident for this patch. I will =
submit it in next merge window if some ultra testing loop passes.
> >>>
> >>> Coly Li
> >>>
> >
>
> [snipped]
>

