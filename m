Return-Path: <linux-bcache+bounces-1201-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7616B466C4
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Sep 2025 00:43:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 82D951B23FD8
	for <lists+linux-bcache@lfdr.de>; Fri,  5 Sep 2025 22:44:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A77FB2741A0;
	Fri,  5 Sep 2025 22:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WlL+bCHa"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97ECA1B3935
	for <linux-bcache@vger.kernel.org>; Fri,  5 Sep 2025 22:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757112224; cv=none; b=meYpCcuiB9bHvvKgF0CbRmpM7IS/51Gf2gU3lVo/RUocGk9j0at/i2jrnLk5VVlNrTHYWMYR0hpXl7/po8VZynMAuW7q18ptqlkSOBeZUYcMJwWiq+JinoMPng8omagDtYUDkZzxK5LiIKBMDxkjFUQo+vnskOzmJjxX96Yb2yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757112224; c=relaxed/simple;
	bh=lQ0WxFywZW9XwzY77UkiLAw4S+FTC7dFLVATZVPkuwk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hz3tfjUZQSxYHW47fUAdnGWkXoJajWtVVdK8H77LD0fL0S0wcwxj6Av+P9yi6Y8JHrfFM19LPq9cvZOkkG2LzKixyzSeTWSEEhPwuAn3nduX/I2/reA1zInDUzv6n9perVMEXz1ribMYhX7qbaXwQz2qW7MOY421E3mgmvHzw/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WlL+bCHa; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4b350971a2eso36071cf.1
        for <linux-bcache@vger.kernel.org>; Fri, 05 Sep 2025 15:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757112221; x=1757717021; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A/PSopFxnL5bEX7RbCq8Lkb1gScmBjtjSzM8/FyG5zA=;
        b=WlL+bCHaWHZDizr2Mc3R2fe4sVGxTE7UXQvBv9XZpjhMgfS9wdpbVKLGmMgjZrmSzy
         4Y11I4TAGRqrJfSTsVV18MO+mq1oMYx8ZAhUIqDx6DyzvqEaFDyugY5LM8QkVTi7rMeF
         SVrIKS1pbzs3WYZtoQWB/o3TdXXy8d4ck+kQ8/yWJWEK1LfVwhzj1yINUbxl5O7ZM6qW
         wpI3Kq2pPzY5EDjOCYb74kSYGZDnEfV6zUS6Zyxp1Z6yq727Bvi5zY+ROiR+IvpWQUbn
         IRbFqJTvmRa0BYKTewLDNzm+CeatSOPOIDW/EUIhdR6VRr3hBLCPezAEj2/sCy6PzfRp
         ttWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757112221; x=1757717021;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A/PSopFxnL5bEX7RbCq8Lkb1gScmBjtjSzM8/FyG5zA=;
        b=JDVbL+vWbPfNwvHPyiFXuOYOXGGkTjEIla5Vz4y+eC5hPmy0icXWrQw5pwOF2V8c2a
         +Ivq2Eg+TpYg8M7lpwuvmtGdeStLzUss2pf6Whv/WHqSRvSSWEPoKaATrcM3uAFc1aD5
         dSIFHj71ynkqpb6hAdv+kP4rpk4sRIDxeoZbX7pCTT4HzTKYALw9UOPWBXIPJm+hmvb8
         BrU0ni49ybUwe2AlJ/s/F/v7xZlA7tQ0oxheILafOPxA/MFVmVsK1dj73545Z0fq8TGD
         +11mLFZwyDTXE4USdACu/J9AfH7qGaMN+aI/OPzChWa8P3fPt1BD2Gi4xPLBu6JEmwIZ
         DCmA==
X-Forwarded-Encrypted: i=1; AJvYcCUv46iZxfI+nRhh/FugMi7sLR+twRTvydNe6QtCULR+dVjtzqfQ8Ez7HNlVZ6z5rkL+pI+V8FQryiEkRJQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSUetLlB6YSIny+mVDQRGyN0K7yjCWGjULlVLcGTYWEBZoGLdF
	Fimb/iuAqd2/S24QvUSA0O1QPVYHLPNxuBSXLZ8IIu18N4zKSgu32WLLr5z5cTCxN9IxdhHB6io
	IFWegLK8BvHGCtvVSqQCaqu2lhDNOIF7GU2UvWT2y
X-Gm-Gg: ASbGncupF+yfxDGI8h6kE2nJHVFpvtv+STxFz+xNoAPJTAe+lpDUxjn92Hrl4ovaLEF
	LoQPSlSHYu1/zFYCHNdXvj6+ltWKrKSpfoilOwP0Cyytr5OiP1ZB4MerLAV9TlVdCBgyp4yqosU
	1uNu4Lo0TcgErZPXHTIuRtvgncMqbLFmyQdYNOGf0AmKUR6f8oXg33uFZIL9vxKSCtJPcSLJaOJ
	rSm6Gzuxqx+
X-Google-Smtp-Source: AGHT+IE5oIO5eTyPajlmWiB1Cit9otoUodTI2NixRYbGD88hcwGy58wvF+Po7wRUFH3Nuz7e3JE3mXo+sn5+eqZ7M9M=
X-Received: by 2002:ac8:5e0d:0:b0:4b4:979d:8764 with SMTP id
 d75a77b69052e-4b5f83f6654mr549251cf.19.1757112221043; Fri, 05 Sep 2025
 15:43:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250828161631.33480-1-colyli@kernel.org> <9CAADFD0-B713-4F83-8B08-3FA97604D9FD@coly.li>
In-Reply-To: <9CAADFD0-B713-4F83-8B08-3FA97604D9FD@coly.li>
From: Robert Pang <robertpang@google.com>
Date: Fri, 5 Sep 2025 15:43:29 -0700
X-Gm-Features: Ac12FXxBwnAgcCGdxRsYa9fMo7kHHauleaT__hwJMCwfgg6nmf74TrwTvW05Mew
Message-ID: <CAJhEC04owpJMN_7+0kkNeJnFsUDjcv1JapgRqOnkOfyUCpN8pA@mail.gmail.com>
Subject: Re: [RFC PATCH] bcache: reduce gc latency by processing less nodes
 and sleep less time
To: Coly Li <i@coly.li>
Cc: Mingzhe Zou <mingzhe.zou@easystack.cn>, linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Coly,

Thank you for your new patch. I have reviewed the patch, and it is
much simpler and cleaner indeed.

In addition, I have run the 24-hour stress tests and can confirm that
it brings noticeable performance improvement. For our 4kb writethrough
workload, your patch further reduces the median (P50) latency during
garbage collection from about 20 ms in the previous approach [1] to 4
ms [2]. And I did not observe any issues during my testing.

This is a great step forward. I look forward to seeing this patch
submitted soon. And please feel free to add me to the sign-off list if
it fits.

Best regards,
Robert Pang

[1] https://gist.github.com/robert-pang/a22b7c5dee2600be3260f4db57e5776d
[2] https://gist.github.com/robert-pang/05b17921a83d59afc8aab28b5d9e9e0d

On Thu, Aug 28, 2025 at 9:25=E2=80=AFAM Coly Li <i@coly.li> wrote:
>
> Hi Robert,
>
> Your patch breaks the emwa_add() method to maintain the gc stats numbers.=
 So I have to look for another method but try to get similar benchmark resu=
lts as yours did.
>
>  Hi Mingzhe,
>
> The dynamic sleep interval and gc nodes patch is kind of over complicated=
 IMHO. So I compose a simplified one based on the idea from you and Robert.
>
>
> Can you all help to review and test this RFC patch? Hope it may work out.=
 Thanks for your help in advance.
>
> Coly Li
>
>
>
> > 2025=E5=B9=B48=E6=9C=8829=E6=97=A5 00:16=EF=BC=8Ccolyli@kernel.org =E5=
=86=99=E9=81=93=EF=BC=9A
> >
> > When bcache device is busy for high I/O loads, there are two methods to
> > reduce the garbage collection latency,
> > - Process less nodes in eac loop of incremental garbage collection in
> >  btree_gc_recurse().
> > - Sleep less time between two full garbage collection in
> >  bch_btree_gc().
> >
> > This patch introduces to hleper routines to provide different garbage
> > collection nodes number and sleep intervel time.
> > - btree_gc_min_nodes()
> >  If there is no front end I/O, return 128 nodes to process in each
> >  incremental loop, otherwise only 10 nodes are returned. Then front I/O
> >  is able to access the btree earlier.
> > - btree_gc_sleep_ms()
> >  If there is no synchronized wait for bucket allocation, sleep 100 ms
> >  between two incremental GC loop. Othersize only sleep 10 ms before
> >  incremental GC loop. Then a faster GC may provide available buckets
> >  earlier, to avoid most of bcache working threads from being starved by
> >  buckets allocation.
> >
> > The idea is inspired by works from Mingzhe Zou and Robert Pang, but muc=
h
> > simpler and the expected behavior is more predictable.
> >
> > Signed-off-by: Coly Li <colyli@fnnas.com>
> > Cc: Robert Pang <robertpang@google.com>
> > Cc: Mingzhe Zou <mingzhe.zou@easystack.cn>
> > ---
>
> [snipped]
>

