Return-Path: <linux-bcache+bounces-344-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 84A64881649
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 18:15:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EBD3228558B
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 17:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50C416A338;
	Wed, 20 Mar 2024 17:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pR69oNWA"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22E46A013
	for <linux-bcache@vger.kernel.org>; Wed, 20 Mar 2024 17:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710954922; cv=none; b=Mad/ORwVoUBcQJx+O8CZgQzt2lV9ifHJPKb8sqrY73/e4SqGkO5BjYPLjCgdOcePkJWMl4iAXJX3SPovHvKErkovvIninlCAEGrsVhDJ25y2xTHQMWMTd6a+dWHZ+4QY2yRfB4RCr4ePnWY16ULJMCgZeb5Ec2EWE6I/cpoc8BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710954922; c=relaxed/simple;
	bh=XgLLe/0HidMplx5GiFezhsQrFnXrNoWbzeUa4QSU3u4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F9jA/ibWOFSi2j2BqzO3yxOWz7QRi6az/QiH8LZaZZ48Y/Vu9OuhIEVGkGCZPLZcoY2IY0Pm9XNYXKRwIIPjVszROOoikMDXbDmcb/yP3CXGsnWgg8GHbnjDPOdSCpKK7LoOkBQuSUUz6/LWrdx/FeeK/iPzzx+6gjuZVIyp2aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pR69oNWA; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1deddb82b43so8905ad.0
        for <linux-bcache@vger.kernel.org>; Wed, 20 Mar 2024 10:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710954920; x=1711559720; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oIp5RcXnXJ7qPYcrKHILUGb2p95lzF1Zlt+aRd98e2s=;
        b=pR69oNWAtkN+GiSMjWpsJnAJ72L/JqDjqlcqvtEKFJxR1JKCfVsKNCJS9ybu+cHC7Y
         hFnpoIkFoYFyiJpys7mnlZsgrHHVCDOeZ9hoZdlQvDNBne19YdrfTNqscdjsaZWdN+Ez
         1HptVFHo0/jvY8kfl+yNSj/7PiXCuNUsUdp5IgrS4BEWb11su4friYTSbsOiyaU+n6q3
         FBOj8wN6Tjy0uD3Tqcu05aztGo9MCs+TVM1SEaOo1m5BjfXqs641D/4atLLpVB0v0Bem
         GkkfymRISyVahaFYVB4PvATpEn6nnNkwQpHPCal8QyUMq+ZJs/eP9fYIHPFX+Ef+zZ1K
         oNEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710954920; x=1711559720;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oIp5RcXnXJ7qPYcrKHILUGb2p95lzF1Zlt+aRd98e2s=;
        b=AI8kIzG6lUKAJNAbG6okZ2LZRpx7er5itru03axlZ8KBQgVB5NrHM+AgThjX63J7LL
         qUJdCbs/fMVOqdAgLTetsKzYJ1IZ5OayAe2oIlfcSdkixF2r9rudUIypds2tkq/a2aw1
         E6oT4mKRNMGhNSOA3McUFjcBa08S8nHubAGSWBige8nBI4f7xh2oqeo4bcOIlOfkTuCH
         5aj9PlNHjs6ikxuBgBDksWI7l/VjxUmOypI/IE5+5QeN1CBDJPGqKt9eKPO1hwN+IoX0
         gvAeTWgNJFnHwpKheE9JT4OI/etwmvZ2XLUtdFyvPq6UzJONrxQaAm/ZUEFyUgcW3PSr
         qiPA==
X-Forwarded-Encrypted: i=1; AJvYcCUwP3Jd/VFkBzPBxUfiNVxYC1zAU2iNMCw3e5RBiMZhxrKvuG5/e+FA2+OPWTNODkKoMizhC6oJRPBGd5/k/LbLgK7fwA64yWZnzrdg
X-Gm-Message-State: AOJu0Yz+O7JFVqLkcB6fJ+jA+yFlyggLgEhFF+h9blK1kb3t1Z8MxVkm
	ycM2Fh6S4jzk4Hh00mj2FOYapTysqXOcJAraTsJ+Vl0YmB8FrKVIRhr/6/fpQUCujZI6ZBcb2Gj
	HjDkT1mCK+Grk1X+m2/u3m2IkhQZQS5bYKSYx
X-Google-Smtp-Source: AGHT+IGD/YlWW3iEs0IrRWmm6hXwC9f92VNOJhCPilELzQoK/i7dejWld8froyLEaz/lQCnkq961NX8v3FntamPL7Gw=
X-Received: by 2002:a17:902:e74d:b0:1dd:9e99:f6b2 with SMTP id
 p13-20020a170902e74d00b001dd9e99f6b2mr306294plf.20.1710954919511; Wed, 20 Mar
 2024 10:15:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240320145417.336208-1-visitorckw@gmail.com> <20240320145417.336208-10-visitorckw@gmail.com>
In-Reply-To: <20240320145417.336208-10-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Wed, 20 Mar 2024 10:15:08 -0700
Message-ID: <CAP-5=fWAF33f+RnaXNQd6NNJUr=UQzNGAEo_-G07CD5q8Xmrow@mail.gmail.com>
Subject: Re: [PATCH v2 09/15] lib min_heap: Add min_heap_sift_up()
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
> Add min_heap_sift_up() to sift up the element at index 'idx' in the
> heap.

Thanks, should min_heap_push be updated to use this sift up rather
than its inline version?

Ian

> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> ---
>  include/linux/min_heap.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> index 36023e0be232..af12531474a4 100644
> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h
> @@ -194,6 +194,26 @@ void __min_heap_push(struct __min_heap *heap, const =
void *element, size_t elem_s
>  #define min_heap_push(_heap, _element, _func)  \
>         __min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(_hea=
p), _func)
>
> +/* Sift up ith element from the heap, O(log2(nr)). */
> +static __always_inline
> +void __min_heap_sift_up(struct __min_heap *heap, size_t elem_size, size_=
t idx,
> +               const struct min_heap_callbacks *func, void *args)
> +{
> +       void *data =3D heap->data;
> +       size_t parent;
> +
> +       while (idx) {
> +               parent =3D (idx - 1) / 2;
> +               if (func->less(data + parent * elem_size, data + idx * el=
em_size, args))
> +                       break;
> +               func->swp(data + parent * elem_size, data + idx * elem_si=
ze, args);
> +               idx =3D parent;
> +       }
> +}
> +
> +#define min_heap_sift_up(_heap, _idx, _func, _args)    \
> +       __min_heap_sift_up(&(_heap)->heap, __minheap_obj_size(_heap), _id=
x, _func, _args)
> +
>  /* Remove ith element from the heap, O(log2(nr)). */
>  static __always_inline
>  bool __min_heap_del(struct __min_heap *heap, size_t elem_size, size_t id=
x,
> --
> 2.34.1
>

