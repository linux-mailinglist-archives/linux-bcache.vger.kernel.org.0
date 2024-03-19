Return-Path: <linux-bcache+bounces-313-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C0588805BA
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 20:57:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FE551C223D2
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 19:57:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B304535B3;
	Tue, 19 Mar 2024 19:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qxt/eEnk"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D438E55E40
	for <linux-bcache@vger.kernel.org>; Tue, 19 Mar 2024 19:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710878268; cv=none; b=mDkS+ACi/27DCv+KO6Dr3kQRrygMsCDq+lWcBb5JuKOdQDmFFCM76BpsCyt5Edb6bEdHkeGex1Fb83qefwHto9Gnm70UbxwG67Wrl3FblscvVPypWvBGPuqzVx93wl+bB9mi7dIq0qy68+UNLZ9cBDkwcQ5YJoROwdqtiQpP1yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710878268; c=relaxed/simple;
	bh=35ecHv+9qehFof6aQVy5gVpDqX2M7KB4dSVOdvgkfjI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ngVzRs2tO9j4rUO2pAJHn07a8ityjg0okDIJRBk9wql3Y5d4Ma/MXPsOu85Hc4y99kbWpVQeJhKtJ/LB+P8LIdQ6tS8ITRTMglAo9GO/bSxY0JeOSwkkSq/aYMnY0VxRU22uTvKmAc2eWfloew4ihxb4Ut4Q03n2KkPPxKxhFZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qxt/eEnk; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1dee917abd5so2555ad.1
        for <linux-bcache@vger.kernel.org>; Tue, 19 Mar 2024 12:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710878266; x=1711483066; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XettUXCUytZxztvpokYxesf4Q1Gu8ZAwELXRrBrtnls=;
        b=qxt/eEnksrGJ5ouZYznivYm05QiHTopSEQZRyzP0QhGvv6qqwj4Sr257nyPbeAh63u
         JawtAqqrK5BYrzqnylj6GKRV5DFBNHB078tj5MNhuQPwZsSdTdYzMLjmY+imiKW7wNGm
         6LP/9VEQOCTPFdjbD8JU2G00/8Sd1aHDm0W9MiInLYRHl2JNc6ncK38slDesUM6SqaZP
         pQXu9poVSYHVzkl/f8cg7YYWoXw8MX+2puYi03Vkn2RUvTtm10RmWcl/YKJOlH4Y5xGc
         hSa7Fa10b61UUD8+ntODsrJJSnPO3N2iLoAcuFkfTrmwJjVFuru3HcCpNUS0N8NYRint
         PYHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710878266; x=1711483066;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XettUXCUytZxztvpokYxesf4Q1Gu8ZAwELXRrBrtnls=;
        b=tlAEXhxMwtFpxioQWg1vBhlIHf5pJCUx5LFnTbTo5/OqW58xPTiWbuvPWIHKZ/jwn9
         GYVW1jzj+/2R/LPdUsDq/vf9Bhx7ZITgTuKq1+1wc/Ae2otiklDNuOss1TTQX+DWaeFN
         Nqaq0VypvTtwK80YxyyzSey1u4xVo83FNv27FY89W3d8LFZ2T+Fc7gHx5J2vNS+k8hN4
         RrPRkqQlPN9ebBg+qPfJYoV/qpolZRoViuW2jdPGHX4k7RaMafa7syEhwex+1glJ12V5
         mgcCgivPBPsjYmBuQeDj5Q6ypnAZxsO/n0b4MJYlo3Ay0KnWZBfO6UnSOI3oEitI9km2
         oQ9Q==
X-Forwarded-Encrypted: i=1; AJvYcCXMQaAOwPbi1IOtSES91G203Z/D3meTO8FpczVNZOV1/70a2Se6Q4u4K3vW1+HGrJL5pEMINfIEN04/qhZiVe3TBhXtPxX2zkSzP7P7
X-Gm-Message-State: AOJu0YzNjAbt2DYWdfDWUtULI60MmK4RLGCAKwUxIbM0XrpYA5Bj1IYg
	RLOWH6SqXmH0ki0x8VDrMI04vxGoF1P7XlJn88o5Sdv5wD4vMK1kgonbHd9SgPaQhbH7HTUUNxw
	jqjA1DojHp2ZkCtyHD1y+y6tup6Tp0PQq7or+EBEZ+qBjHgIc7VBkDnY=
X-Google-Smtp-Source: AGHT+IGhJBZPV5sgsvA1Ag4NPK7bHjOsEVeBT2FsY6a3D5GhexHGoEVe1DyqNZMv3VMEmxrkmDela6UPobccY4gXZ38=
X-Received: by 2002:a17:903:230a:b0:1dd:b505:d518 with SMTP id
 d10-20020a170903230a00b001ddb505d518mr62555plh.22.1710878265724; Tue, 19 Mar
 2024 12:57:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240319180005.246930-1-visitorckw@gmail.com> <20240319180005.246930-10-visitorckw@gmail.com>
In-Reply-To: <20240319180005.246930-10-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Tue, 19 Mar 2024 12:57:34 -0700
Message-ID: <CAP-5=fUkm-BxztTFUUsWk=VrksWD=Sb+zo0+Y8peX=c5icbqmw@mail.gmail.com>
Subject: Re: [PATCH 09/13] lib min_heap: Update min_heap_push() and
 min_heap_pop() to return bool values
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com, 
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, adrian.hunter@intel.com, 
	jserv@ccns.ncku.edu.tw, linux-bcache@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 19, 2024 at 11:00=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmail.co=
m> wrote:
>
> Modify the min_heap_push() and min_heap_pop() to return a boolean
> value. They now return false when the operation fails and true when it
> succeeds.
>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Nice change.

Reviewed-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  include/linux/min_heap.h | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> index 97d8ba5c32e6..154ac2102114 100644
> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h
> @@ -130,18 +130,20 @@ void __min_heapify_all(struct __min_heap *heap, siz=
e_t elem_size,
>
>  /* Remove minimum element from the heap, O(log2(nr)). */
>  static __always_inline
> -void __min_heap_pop(struct __min_heap *heap, size_t elem_size,
> +bool __min_heap_pop(struct __min_heap *heap, size_t elem_size,
>                 const struct min_heap_callbacks *func, void *args)
>  {
>         void *data =3D heap->data;
>
>         if (WARN_ONCE(heap->nr <=3D 0, "Popping an empty heap"))
> -               return;
> +               return false;
>
>         /* Place last element at the root (position 0) and then sift down=
. */
>         heap->nr--;
>         memcpy(data, data + (heap->nr * elem_size), elem_size);
>         __min_heapify(heap, 0, elem_size, func, args);
> +
> +       return true;
>  }
>
>  #define min_heap_pop(_heap, _func, _args)      \
> @@ -167,7 +169,7 @@ void __min_heap_pop_push(struct __min_heap *heap,
>
>  /* Push an element on to the heap, O(log2(nr)). */
>  static __always_inline
> -void __min_heap_push(struct __min_heap *heap, const void *element, size_=
t elem_size,
> +bool __min_heap_push(struct __min_heap *heap, const void *element, size_=
t elem_size,
>                 const struct min_heap_callbacks *func, void *args)
>  {
>         void *data =3D heap->data;
> @@ -175,7 +177,7 @@ void __min_heap_push(struct __min_heap *heap, const v=
oid *element, size_t elem_s
>         int pos;
>
>         if (WARN_ONCE(heap->nr >=3D heap->size, "Pushing on a full heap")=
)
> -               return;
> +               return false;
>
>         /* Place at the end of data. */
>         pos =3D heap->nr;
> @@ -190,6 +192,8 @@ void __min_heap_push(struct __min_heap *heap, const v=
oid *element, size_t elem_s
>                         break;
>                 func->swp(parent, child, args);
>         }
> +
> +       return true;
>  }
>
>  #define min_heap_push(_heap, _element, _func, _args)   \
> --
> 2.34.1
>

