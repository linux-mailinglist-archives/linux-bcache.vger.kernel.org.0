Return-Path: <linux-bcache+bounces-317-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E3618805E2
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 21:12:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D37E8284C52
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 20:12:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 822C25EE8D;
	Tue, 19 Mar 2024 20:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JjEYKWp8"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E232B59B77
	for <linux-bcache@vger.kernel.org>; Tue, 19 Mar 2024 20:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710879152; cv=none; b=SSsIcQaBFWoJHymWvhZ9KbkDs7xhlA3p0+CRTFuhdGyvs4AHR9xfc3rZiPqPfzeDfvvGFS/gizl63zKbn4PL71L7bd5KdfyGX6eO3EwY3OJAbdhCDReIZrA6k5YCeiifQGMsabR3tbcIeFEZ8Zdu5ApmfDXC7F6YHXUE273LiuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710879152; c=relaxed/simple;
	bh=8yaxvB6bUHYBs0zmT9Eiw6XjDqKFmwedLMjHxHXfPnw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SvkLLioKMUQRRthGjBtUIJ79HVCxMGXWZcfPlJquYB2wbOyLYjlrbapR7SkKmj2F/mB2m1dP2/euCFTSYUMktRtKTLWRPORvfHcS9R3xFH/obhXky8aD4VV3rBkNvtzu6aAg2GZXDl/xJ5sb4fp6jS97FW2mVnI2EAFoQlCkFuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JjEYKWp8; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1dddd7d64cdso5345ad.1
        for <linux-bcache@vger.kernel.org>; Tue, 19 Mar 2024 13:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710879150; x=1711483950; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tX+TNd0OCISuOTBPfi7a9IeALZq1DpePFpW0ki49zWs=;
        b=JjEYKWp81VZOTPRz0O/AMmHTVGm4LIpxhFNIeDMFRQP7e/5X07nVeEUGvZNXpn7IvL
         yvHRBSTbEfPC0c+Ky+BisAcCJ5uvAb9gM+rD8x1MIFlT2J439LaVihpxlP085HJRaLWJ
         phihvpIW/R1CNY1vxIV2yVUWRzfpTfRcpONLXGc247catvviBgsNeCpMhm+KwYpbcRdC
         g/TviK3v2rDZ3fsSVMgFRpj/wwjMn8TLu8MuIRoQxebUZdvYnsjiQi4aM7m3lDyIXJzt
         zmudB+54e6KBliUG3zdJ3cgQ91LA5NB7fY1zwiP6PrEwHyI8W9lve3IyBm3DTrLFMG5F
         cJRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710879150; x=1711483950;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tX+TNd0OCISuOTBPfi7a9IeALZq1DpePFpW0ki49zWs=;
        b=tHuijb9G69RcCTpMrOHfnpSX8IhIq1XxXjJ0iSGUjv+4BQBtN+/bLKLaGOHDrxy0/l
         jlI0RdPEpnWrQ8YmVx24mc2ag3eqIS70TrPz9cDGvIpp06YnHKukqBoG4aC4QgiwjR15
         Mu+6jGhOpQsYZ+urg2gSjKJFF1mfdQiaAUi2znWJ9SclDYuY2NTUXLZojAxLSZPJI0Qq
         3q3xc/jdurptK1IvJQwRK7GK4bSs+5ksAOhEW0BsxNR6ajtbK0KPbVlGO9SO+75dDu30
         A+Z0nv1PwJShTT19uLtOJ0OwoziV+aO3uxZUzgv6LZW74PJxSi35WJJWH47TqsOP3QBq
         LOZg==
X-Forwarded-Encrypted: i=1; AJvYcCVvgDJRu2yzWvURFImUsakfHgMO27AJop9AYrYhk1eBgKc7qYtRcdkOeOLIPqvbxwDIkI3rFDfkX27PmhawWQjZAsYCsXcXacWdIN0v
X-Gm-Message-State: AOJu0Yz98Qs+gp67bSssKCq4u5qB2SFTBMOvfApuYMN6EvETayIb+Ti7
	9CfJI7uSryYYu+i9TT+83eQUOw+jyek7iGJRa/9+yvAI58i+zz4nCCI22xRIS5GordBiCjsd2mR
	2e9fzSiIerO4wUoW5rZ8UZBE0ZA1uR4XRlOoP
X-Google-Smtp-Source: AGHT+IGbGf1RVMK7axLEkZqDasCPpcTykPmTPG7Mu7HWubRQke5co6hu1xILc3epPRWgfZ6F1xPBBZC5XffRHd5YKKQ=
X-Received: by 2002:a17:902:d508:b0:1e0:e16:dcc0 with SMTP id
 b8-20020a170902d50800b001e00e16dcc0mr10873plg.13.1710879149903; Tue, 19 Mar
 2024 13:12:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240319180005.246930-1-visitorckw@gmail.com> <20240319180005.246930-13-visitorckw@gmail.com>
In-Reply-To: <20240319180005.246930-13-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Tue, 19 Mar 2024 13:12:18 -0700
Message-ID: <CAP-5=fVcBAxt8Mw72=NCJPRJfjDaJcqk4rjbadgouAEAHz_q1A@mail.gmail.com>
Subject: Re: [PATCH 12/13] lib min_heap: Add min_heap_sift_up()
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

On Tue, Mar 19, 2024 at 11:01=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmail.co=
m> wrote:
>
> Add min_heap_sift_up() to sift up the element at index 'idx' in the
> heap.

Normally sift up is used to implement the min heap but isn't part of
the API, eg. there is a sift up in min_heap_push. Should min_heapify
be renamed to min_heap_sift_down to align with this name?

Thanks,
Ian

> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> ---
>  include/linux/min_heap.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> index ce085137fce7..586965977104 100644
> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h
> @@ -199,6 +199,26 @@ bool __min_heap_push(struct __min_heap *heap, const =
void *element, size_t elem_s
>  #define min_heap_push(_heap, _element, _func, _args)   \
>         __min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(_hea=
p), _func, _args)
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

