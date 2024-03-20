Return-Path: <linux-bcache+bounces-348-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0511C88165A
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 18:18:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFD99281C17
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 17:18:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9348F6A00B;
	Wed, 20 Mar 2024 17:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2tsVeBu5"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858F56A03D
	for <linux-bcache@vger.kernel.org>; Wed, 20 Mar 2024 17:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710955088; cv=none; b=fRPwtjyU0U4xsAbSM4f0rAtTOuJTGBH3DpN+OSkShDl5Qt1cxicmmN5EGNWPPlIiEQxz/3od98STeiaRuiy1VVHE1afeZ0f7RmedRTY4sqKUrlXPYJKslp6KVUtTXN13iEMjtlPx4N3j6j9SFohcSXRE09Z5TBXG5WMTnfUTLyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710955088; c=relaxed/simple;
	bh=i2BEZFAyX546ezurPqd4csVc+WA0lDVIhN8qJ8wxgQ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EjKswAFZWW0a9M572MYmESfxfzj7aNeg0tTDb0tBO4i9pudEmTacqL2v7ngQ9bk+DqJCNAm13MFVpo0ktNZ28Ng9OaE7G+0J3Sro5HySOdCsdSnBUwGD71fMcsM2tbXJFlT5EWfuCbyRGwzjQaVsDkQ/KiExkY1okQ9l6tenAWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2tsVeBu5; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-36849db2578so6135ab.1
        for <linux-bcache@vger.kernel.org>; Wed, 20 Mar 2024 10:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710955086; x=1711559886; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZM0WVIa9l/1ThrfQ4+QlUUSP9F5rAVL4rgudWVT1ID4=;
        b=2tsVeBu5o89a/0SCuGCG8C7gX5i9MGnCLugRMOTzmtdrqUNDgg2xekYG0NWZMOI+wg
         rS7r2Ky43sjUHsIwo5PirU6Q77Wh8iBDRLRW/S2sBu3xsDLtf3GnoocOH7MBblj4MZJp
         VoAL+XnlDNrrSmEllBtImprfdiXTO+QRWJ1QOf/3S2TdJJQH/mLFPvWkQl5cvmY9n2gE
         8XKBFwfJvdHpCAciB9ZoX+a/0YdrTyLvHaBxEpczRPGqUIaVuYFYIq9iZy5BfPu29Hca
         vXxIKPdHkfiHi84iFQuyuN3pvz+PwqtN7pMgT8N/M4sjt/JAmmIQgWLEKqRrI1UMiZ1+
         Ym4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710955086; x=1711559886;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZM0WVIa9l/1ThrfQ4+QlUUSP9F5rAVL4rgudWVT1ID4=;
        b=B3bHTc6+tNJPoLNzTkwlelKXflHBPeKMjPW4oZgW/q5jUhZ93g9N9kbUql6/6oVWT4
         G07JjjD3jp/lrP9rG7jFGAaO3/gFiRtKuBFaOiai/BRSu9sS84TcePvgyIF3X6govIUY
         cw6jNFw4mu2YRnT0uiUnh1xy4dZpImom/gJwTyDhbEmzFAvllnkEwluynIuzXPbnhktP
         5S44x1xWrcmg2q+uZ4kma3eV+TZ9iMX8ryDYaIBLIDrkD/7au/XElT2xwjYKg0ThRiaz
         a53+teCL4DIfMis7xHZ9I0SPOWMtKqDaZZHc/uJ9p8NFgnyM2gGeSKLgVTh/E6z0oQQ3
         j5hw==
X-Forwarded-Encrypted: i=1; AJvYcCX/vT9oz7KqxRtQuAlljjCEhoVJ8PXKHjcP3o8rm0gkzLrat4akavtuqu8Ti2Ky5AsuF8UNxDW2g86TyN0W/MW+pHMt6qVwuHJ/Pfkg
X-Gm-Message-State: AOJu0YxfST4djAmkHHGpyrWjkBpc98L0mDIqsGrdaGUQ9Id0KkUsyNtH
	SBk5WiYRQpc4UaRT7MRKH8LojcaDrpX2gf5zqr+9iEhAWlRDpz2Re9mMjeZf7QfzzYePU8dbDeX
	unCLKi5Zms4pupEYTpZSxLXvPnCFHYQXV4nCI
X-Google-Smtp-Source: AGHT+IGL71+mYBMVT7Bm4BaeSdAvzmHm8DEaQFWQBnobcCC6EXKSeWhC/WoyNt1zCGKX2XHM7pQOkpYX8ljYWkHXed4=
X-Received: by 2002:a05:6e02:16cc:b0:368:1860:509b with SMTP id
 12-20020a056e0216cc00b003681860509bmr300085ilx.3.1710955085644; Wed, 20 Mar
 2024 10:18:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240320145417.336208-1-visitorckw@gmail.com> <20240320145417.336208-13-visitorckw@gmail.com>
In-Reply-To: <20240320145417.336208-13-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Wed, 20 Mar 2024 10:17:50 -0700
Message-ID: <CAP-5=fVYisZxfL-2E6s+XLdsYwmpdAtn7BffPtQEAYjfCnjrSg@mail.gmail.com>
Subject: Re: [PATCH v2 12/15] lib min_heap: Rename min_heapify() to min_heap_sift_down()
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com, 
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, adrian.hunter@intel.com, 
	jserv@ccns.ncku.edu.tw, dm-devel@lists.linux.dev, 
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 20, 2024 at 7:55=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmail.com=
> wrote:
>
> After adding min_heap_sift_up(), the naming convention has been
> adjusted to maintain consistency with the min_heap_sift_up().
> Consequently, min_heapify() has been renamed to min_heap_sift_down().
>
> Link: https://lkml.kernel.org/CAP-5=3DfVcBAxt8Mw72=3DNCJPRJfjDaJcqk4rjbad=
gouAEAHz_q1A@mail.gmail.com
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Reviewed-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  drivers/md/dm-vdo/repair.c |  2 +-
>  include/linux/min_heap.h   | 14 +++++++-------
>  kernel/events/core.c       |  2 +-
>  3 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
> index 6acaebcd305d..e99f908bbdb9 100644
> --- a/drivers/md/dm-vdo/repair.c
> +++ b/drivers/md/dm-vdo/repair.c
> @@ -183,7 +183,7 @@ static struct numbered_block_mapping *sort_next_heap_=
element(struct repair_compl
>          */
>         last =3D &repair->entries[--heap->heap.nr];
>         swap_mappings(heap->heap.data, last, NULL);
> -       min_heapify(heap, 0, &repair_min_heap, NULL);
> +       min_heap_sift_down(heap, 0, &repair_min_heap, NULL);
>         return last;
>  }
>
> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> index 586965977104..436997070f4e 100644
> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h
> @@ -78,7 +78,7 @@ bool __min_heap_full(struct __min_heap *heap)
>
>  /* Sift the element at pos down the heap. */
>  static __always_inline
> -void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
> +void __min_heap_sift_down(struct __min_heap *heap, int pos, size_t elem_=
size,
>                 const struct min_heap_callbacks *func, void *args)
>  {
>         void *left, *right;
> @@ -111,8 +111,8 @@ void __min_heapify(struct __min_heap *heap, int pos, =
size_t elem_size,
>         }
>  }
>
> -#define min_heapify(_heap, _pos, _func, _args) \
> -       __min_heapify(&(_heap)->heap, _pos, __minheap_obj_size(_heap), _f=
unc, _args)
> +#define min_heap_sift_down(_heap, _pos, _func, _args)  \
> +       __min_heap_sift_down(&(_heap)->heap, _pos, __minheap_obj_size(_he=
ap), _func, _args)
>
>  /* Floyd's approach to heapification that is O(nr). */
>  static __always_inline
> @@ -122,7 +122,7 @@ void __min_heapify_all(struct __min_heap *heap, size_=
t elem_size,
>         int i;
>
>         for (i =3D heap->nr / 2 - 1; i >=3D 0; i--)
> -               __min_heapify(heap, i, elem_size, func, args);
> +               __min_heap_sift_down(heap, i, elem_size, func, args);
>  }
>
>  #define min_heapify_all(_heap, _func, _args)   \
> @@ -141,7 +141,7 @@ bool __min_heap_pop(struct __min_heap *heap, size_t e=
lem_size,
>         /* Place last element at the root (position 0) and then sift down=
. */
>         heap->nr--;
>         memcpy(data, data + (heap->nr * elem_size), elem_size);
> -       __min_heapify(heap, 0, elem_size, func, args);
> +       __min_heap_sift_down(heap, 0, elem_size, func, args);
>
>         return true;
>  }
> @@ -161,7 +161,7 @@ void __min_heap_pop_push(struct __min_heap *heap,
>                 void *args)
>  {
>         memcpy(heap->data, element, elem_size);
> -       __min_heapify(heap, 0, elem_size, func, args);
> +       __min_heap_sift_down(heap, 0, elem_size, func, args);
>  }
>
>  #define min_heap_pop_push(_heap, _element, _func, _args)       \
> @@ -235,7 +235,7 @@ bool __min_heap_del(struct __min_heap *heap, size_t e=
lem_size, size_t idx,
>                 return true;
>         memcpy(data, data + (heap->nr * elem_size), elem_size);
>         __min_heap_sift_up(heap, elem_size, idx, func, args);
> -       __min_heapify(heap, idx, elem_size, func, args);
> +       __min_heap_sift_down(heap, idx, elem_size, func, args);
>
>         return true;
>  }
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index c32a78c489f3..314fb7ea4ec3 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3788,7 +3788,7 @@ static noinline int visit_groups_merge(struct perf_=
event_context *ctx,
>
>                 *evt =3D perf_event_groups_next(*evt, pmu);
>                 if (*evt)
> -                       min_heapify(&event_heap, 0, &perf_min_heap, NULL)=
;
> +                       min_heap_sift_down(&event_heap, 0, &perf_min_heap=
, NULL);
>                 else
>                         min_heap_pop(&event_heap, &perf_min_heap, NULL);
>         }
> --
> 2.34.1
>

