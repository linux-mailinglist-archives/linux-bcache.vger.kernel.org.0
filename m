Return-Path: <linux-bcache+bounces-387-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A3B089B3CF
	for <lists+linux-bcache@lfdr.de>; Sun,  7 Apr 2024 21:23:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 899AA1C20D1A
	for <lists+linux-bcache@lfdr.de>; Sun,  7 Apr 2024 19:23:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 370773BBE9;
	Sun,  7 Apr 2024 19:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dBOUD2Wl"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CF33FB8C
	for <linux-bcache@vger.kernel.org>; Sun,  7 Apr 2024 19:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712517807; cv=none; b=Xz2aerhK63rngb4gHc4pBiuAeGMRwxPjvy2mbuuXESocnUPBP3yAm/j6XRf3WW3N7H1lH/4wzbUZcjDRxDUUDx50OWnr3ZL887sj2Ng1zyXFPrd2znpqj6VomO2TQctT4/fM7ZEUMgB5AkspfsfMmmzsGUueluHvSNr2Y6sx7xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712517807; c=relaxed/simple;
	bh=22VmL+tFNE0uTkCejpkMoP/bIhby50wK3RXGm4NSyrM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JQstqVixWdGx44MgDbLVwpWe+4sC6r+6eTtWSqim8J7XNg0yB3FsZXtyNDC6s3WMgmqFdd2se8AjTnD9x0UjRnyd28mfYV/+ENYTaIFCvrxr0doW1IYvZWQJoyUjqIy7JdDmcfuvsMNgNBL+cVce9v/fY71VHyr8uQw8Ebtf3Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dBOUD2Wl; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-431347c6c99so318151cf.0
        for <linux-bcache@vger.kernel.org>; Sun, 07 Apr 2024 12:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712517804; x=1713122604; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u9EK+/yKJWqRz4L882cCc6fbjSJC3IRZpgkO1qv3gbY=;
        b=dBOUD2WlDWsa9xSrsNBz0w6qB2Xv5X8vGluK+WmI5jh7+eLpOo52Wcn4IeggH2AXaJ
         jteQYTbwbf5QQS4RyMgROwhVcF/01xErGZK+c171UjPQ8gmR9+yT4aJhBa7gnOQb+EL/
         Q/8kkA6OCFaK2bohX/I8Zobraj0A8zlSU1AmUwQT/Gb7sG8swK8MjZvMaHxDW1yrN4wp
         DMdF9TkJxTQD3/gkW1ev3J0Ac5f+c5tOcgi2oSjOY8+AXzFwh5USVDBVTjIlTvj1owi5
         g7ylThBdi2ah60InBhvGhkJ+2IEsMncFfYqNXxub/JpOsEPfGhZSny2GPA0UVPTrEoXM
         swng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712517804; x=1713122604;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u9EK+/yKJWqRz4L882cCc6fbjSJC3IRZpgkO1qv3gbY=;
        b=ey23I3qo4XPnjgpHUNVwGcS64T55h/raAy2zTvvJD4SajZCRHz9pASRsB6ZgI3yR01
         OWzrWUXq+FMgskCzGD0/wQjvpKmEAZXgy2Icw++na7UyghEBE6+MOohBiKPdDxvEe5/U
         eJJA+yizk9K/rrriCSKgqp+memlSg7WEN0TVdGvSWEJLytmhy2rZxODrAC0Pic/KKmVC
         gmJ91ULaLs3YULu8sMsSANX5R1/7a1T8BmPFV4VdOTQ0ExnzOheu9gmVDuMynUYekUul
         fiLEX42/XVjwSSzeG0whPTu1q9T477CicnJ9kHtiBLw8ySWKgcTPbdBsrTVWhFAa53q5
         LARg==
X-Forwarded-Encrypted: i=1; AJvYcCWcyyOKBKXXx79WLd1KolwQ4//vMqZTeVGMOr/bO6bsJVxwhcmYVfZmTWZ+r3f4BFqjDAXKcWSyoPtzCu2r7LRFIjqqm+0JT01b23tI
X-Gm-Message-State: AOJu0Yx5Qsla96VIzN7js0rFT1kqJO3z/iIeLkN3tsAJFo7+OFuokQHz
	KHqE9foIyMoX2uClscTwcIdqMXtRbfXNQlHxHD8WYgNcaz/TSmEUCcwpk3bkevOb8uqRgp9g8xA
	QHa3HS1H4G/H405X+qwze8H41tcDgEiGg3v4G
X-Google-Smtp-Source: AGHT+IHar9eAfxca2nmrIrD2fR+nsCEr8Z9S6xUUBtYvOamZ7oI6wPcUjOWZvBJYg8gNmg59mfRxZth/y35fmMF/4NM=
X-Received: by 2002:a05:622a:1b1f:b0:430:e8f2:7d02 with SMTP id
 bb31-20020a05622a1b1f00b00430e8f27d02mr277035qtb.10.1712517804333; Sun, 07
 Apr 2024 12:23:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240406164727.577914-1-visitorckw@gmail.com> <20240406164727.577914-16-visitorckw@gmail.com>
In-Reply-To: <20240406164727.577914-16-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Sun, 7 Apr 2024 12:23:10 -0700
Message-ID: <CAP-5=fUQz0oiO9i6=+F3X9QgkaPVfCRWxH=kCSpYzNRFR=Y=qg@mail.gmail.com>
Subject: Re: [PATCH v3 15/17] lib/test_min_heap: Add test for heap_del()
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com, 
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, adrian.hunter@intel.com, 
	jserv@ccns.ncku.edu.tw, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 6, 2024 at 9:48=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmail.com>=
 wrote:
>
> Add test cases for the min_heap_del() to ensure its functionality is
> thoroughly tested.
>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Reviewed-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  lib/test_min_heap.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
>
> diff --git a/lib/test_min_heap.c b/lib/test_min_heap.c
> index 67dd4f644f6c..9d4bbb590a49 100644
> --- a/lib/test_min_heap.c
> +++ b/lib/test_min_heap.c
> @@ -160,6 +160,40 @@ static __init int test_heap_pop_push(bool min_heap)
>         return err;
>  }
>
> +static __init int test_heap_del(bool min_heap)
> +{
> +       int values[] =3D { 3, 1, 2, 4, 0x8000000, 0x7FFFFFF, 0,
> +                        -3, -1, -2, -4, 0x8000000, 0x7FFFFFF };
> +       struct min_heap_test heap;
> +
> +       min_heap_init(&heap, values, ARRAY_SIZE(values));
> +       heap.nr =3D ARRAY_SIZE(values);
> +       struct min_heap_callbacks funcs =3D {
> +               .less =3D min_heap ? less_than : greater_than,
> +               .swp =3D swap_ints,
> +       };
> +       int i, err;
> +
> +       /* Test with known set of values. */
> +       min_heapify_all(&heap, &funcs, NULL);
> +       for (i =3D 0; i < ARRAY_SIZE(values) / 2; i++)
> +               min_heap_del(&heap, get_random_u32() % heap.nr, &funcs, N=
ULL);
> +       err =3D pop_verify_heap(min_heap, &heap, &funcs);
> +
> +
> +       /* Test with randomly generated values. */
> +       heap.nr =3D ARRAY_SIZE(values);
> +       for (i =3D 0; i < heap.nr; i++)
> +               values[i] =3D get_random_u32();
> +       min_heapify_all(&heap, &funcs, NULL);
> +
> +       for (i =3D 0; i < ARRAY_SIZE(values) / 2; i++)
> +               min_heap_del(&heap, get_random_u32() % heap.nr, &funcs, N=
ULL);
> +       err +=3D pop_verify_heap(min_heap, &heap, &funcs);
> +
> +       return err;
> +}
> +
>  static int __init test_min_heap_init(void)
>  {
>         int err =3D 0;
> @@ -170,6 +204,8 @@ static int __init test_min_heap_init(void)
>         err +=3D test_heap_push(false);
>         err +=3D test_heap_pop_push(true);
>         err +=3D test_heap_pop_push(false);
> +       err +=3D test_heap_del(true);
> +       err +=3D test_heap_del(false);
>         if (err) {
>                 pr_err("test failed with %d errors\n", err);
>                 return -EINVAL;
> --
> 2.34.1
>

