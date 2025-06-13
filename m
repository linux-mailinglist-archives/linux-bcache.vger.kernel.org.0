Return-Path: <linux-bcache+bounces-1129-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 59D0DAD8320
	for <lists+linux-bcache@lfdr.de>; Fri, 13 Jun 2025 08:18:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E60A1899AC0
	for <lists+linux-bcache@lfdr.de>; Fri, 13 Jun 2025 06:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA06125A64C;
	Fri, 13 Jun 2025 06:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hp/ACLjC"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A8825A351;
	Fri, 13 Jun 2025 06:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749795484; cv=none; b=Liq4PdJoVq/OxNN4ssWXpcwqcoS46qM1LXmA1sNJWih9utuorOrYNrbmZV4+4iGPcxpGW3UhkQkcHuDd7Rf5tADRbVIRamawbxFPyeOsxdz2zvxRVzYqnnFaJ2ZOc5a6cVGaZa+nEL3GcNHpjAC66Ronv0pfXuAoPxdLlinrHgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749795484; c=relaxed/simple;
	bh=0niJSDKSOXEOs7ASseKgdsRjkom/g5n+i1aWk+pBLA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j+X0Q2z19ilHdv+ciQ+pZWOzjewjXuTP1g7fE9PlEa04kFoe0ESh12pPzFnxhdJcYIb7bz57j+sxCZksvKyikF2kyg2UJlue6UrJtV8Lak6OsP1gdOlqZPQ0Zber3mqouiTpfifLfyoiE1xmaxyeH+CwNKC36uqDGk/tBa/3RJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hp/ACLjC; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7390d21bb1cso1442513b3a.2;
        Thu, 12 Jun 2025 23:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749795482; x=1750400282; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NEQ+oF0djJWq9SDDZsOf15v0QosPMJkF2diyCZV/7No=;
        b=hp/ACLjCT2STBCYw1rAUn9a03AKtBfU59d0JUmAoyv6ZA/5B+y9aWzyqbEEEq5EIBl
         1Bd8nu1FzwAp5wuzzG/5g96ntCVSaABeizb7edEQw1RRDPtOoPDXiOveJO1X8dnOeY78
         jLwlz1xWIQ9wSBVwjE6rJHdzVqcOzbx0l36nYqBkW/jacxAMsjPE0h+x8GqIfMqE3ouv
         mPxuUbvY5iInb25tY1SXZC5pCvV4jKRSfmv8AWjB9/A2mvSx065TSLNNVGot0fqai3QU
         9vRtuhKinQeEEX7fzYj3J2KTcd+5RZOYGpsmz8BPjoDSgZLYvPYxhpcv92YjH4HZCG0h
         Ma6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749795482; x=1750400282;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NEQ+oF0djJWq9SDDZsOf15v0QosPMJkF2diyCZV/7No=;
        b=UuPy/0Tt2miECqjjahAIToNhiMd4XQE4GwUgTKdhbIliMt2m0gqyXd5lXhxdftsoU4
         AvE/Pm++uCng9u6voG+/ZG4w+7Bhggnk/3XSbNu9c8G8alw+9ixvaxoNGKZ2h0n+bA6o
         zZqp2SaJRxNvSJFhP3tr2tK23F8gxWoLkHEJxFTBGOOr+xkBfWGae34EnDkDKwHGlb6K
         HRL4MqnRBd5HPI1k6I84DdhmlI4VR8pu0CI8LwduO7uAKxCWjoHaxIAwOhef/hFzi90I
         P3V1b1vVNCbZnZEAUnSDqe/wfXDxnsuz26QB3c1yMMLmqpbTU+e8z23z/TYtxDkcLOW4
         DxCA==
X-Forwarded-Encrypted: i=1; AJvYcCUCGsInBS21/PtLjGRE+KvogNd8VlNRXTJFIpuJdM+soitCwEhPhH/28K5Ozgc77c8hIz8AXM12T1M9Z0cg@vger.kernel.org, AJvYcCVg1bvlgi7i+6A4nZ7skPcRBd7CFPKoy8Un9XOIiD6K30CXThOCR5i44MH7kOApwzvFQ7gJ4NaO1UfF@vger.kernel.org, AJvYcCXHZm0GIn4YEGk4rgJGVCMccyZh1L8C2WwjpYtlUb+8MNJUTAKtw1bubsaiGn6xsIL0naKryccWwrua17s=@vger.kernel.org, AJvYcCXy7FnOIhUN1hkZMOC5+doNcTUg/Dxm5Tzq53XovFqStAN2D8nuCRaDnEECYbKruwZG+OTJv/Ok@vger.kernel.org
X-Gm-Message-State: AOJu0YyowCBhFK1lGwdZS0gJkDFgC383/MvH1NeL2JhpvQpbM89m4OS/
	573BrM4O18KIreT3Sj97skPJI34NCvGGeCSTU1yBLpl+Rcoo/EgXyECN
X-Gm-Gg: ASbGncuW48ZRbiNS6CV51NKS8Y2FtuBWrKQtLfG2W9Rnf2SktVzLAqwbNEGkjWptdkZ
	6JgShxXdpUDH2jM8oV0WrbZghSKGoILk2UsUDVyAnjpsK/mywrK/DywYIdhntnrXHYQgTwa26VO
	lkHyaB0nYBv75mXbyB/BDGXZoYLwZbHAS8hxi7Eh+vItKSXwa0fSRbX3pvVOLPDAlXJ64mL5Bdd
	9f1HtlOL1ejFoL88GwIDCziDeYOHcMa8mSMij/IOQmNmzvYtQouP0ipSWA4RoulLZlYkjxNT0ND
	r3frbPdBRaHM/bX+gzVmrJySA5oaxcx9H2rUHZ2l9tN8KkVcr7awaFtJIudMUpuxLBfeaKkoMlE
	5oR/+S4LVfZZ7LQ==
X-Google-Smtp-Source: AGHT+IH1HPtc0JXAOofq/MfGoBAYE2uisZmm5JgOcucJHvZbbB84Lgn8PnCj5aG8zasbQuNo0uRr9Q==
X-Received: by 2002:a05:6a00:21d1:b0:746:2c7f:b271 with SMTP id d2e1a72fcca58-7488f641129mr2407868b3a.9.1749795482279;
        Thu, 12 Jun 2025 23:18:02 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7489000531esm804843b3a.41.2025.06.12.23.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 23:18:01 -0700 (PDT)
Date: Fri, 13 Jun 2025 14:17:58 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Robert Pang <robertpang@google.com>
Cc: corbet@lwn.net, colyli@kernel.org, kent.overstreet@linux.dev,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-bcache@vger.kernel.org,
	jserv@ccns.ncku.edu.tw, stable@vger.kernel.org
Subject: Re: [PATCH 1/8] lib min_heap: Add equal-elements-aware sift_down
 variant
Message-ID: <aEvCljo6GPRRvWuO@visitorckw-System-Product-Name>
References: <20250610215516.1513296-1-visitorckw@gmail.com>
 <20250610215516.1513296-2-visitorckw@gmail.com>
 <CAJhEC05pmnTd9mROTazKMFzSO+CcpY8au57oypCiXGaqhpA_2Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJhEC05pmnTd9mROTazKMFzSO+CcpY8au57oypCiXGaqhpA_2Q@mail.gmail.com>

On Thu, Jun 12, 2025 at 10:00:14PM +0900, Robert Pang wrote:
> Hi Kuan-Wei
> 
> Thanks for this patch series to address the bcache latency regression.
> I tested it but results show regression still remains. Upon review of
> the patch changes, I notice that the min_heap_sift_down_eqaware_inline
> #define macro in this patch may have been mapped incorrectly:
> 
> +#define min_heap_sift_down_eqaware_inline(_heap, _pos, _func, _args)   \
> +       __min_heap_sift_down_inline(container_of(&(_heap)->nr,
> min_heap_char, nr), _pos,        \
> +                                   __minheap_obj_size(_heap), _func, _args)
> 
> I changed it to map to its "eqaware" counterpart like this and the
> regression does not happen again.
> 
> +#define min_heap_sift_down_eqaware_inline(_heap, _pos, _func, _args)   \
> +       __min_heap_sift_down_eqaware_inline(container_of(&(_heap)->nr,
> min_heap_char, nr), _pos,        \
> +                                   __minheap_obj_size(_heap), _func, _args)
> 
> Do you think this correction is appropriate?
> 
That's definitely my mistake.
Thanks for testing and pointing it out.
I'll fix the typo in the next version.

Regards,
Kuan-Wei

> Best regards
> Robert Pang
> 
> On Wed, Jun 11, 2025 at 6:55 AM Kuan-Wei Chiu <visitorckw@gmail.com> wrote:
> >
> > The existing min_heap_sift_down() uses the bottom-up heapify variant,
> > which reduces the number of comparisons from ~2 * log2(n) to
> > ~1 * log2(n) when all elements are distinct. However, in workloads
> > where the heap contains many equal elements, this bottom-up variant
> > can degenerate and perform up to 2 * log2(n) comparisons, while the
> > traditional top-down variant needs only O(1) comparisons in such cases.
> >
> > To address this, introduce min_heap_sift_down_eqaware(), a top-down
> > heapify variant optimized for scenarios with many equal elements. This
> > variant avoids unnecessary comparisons and swaps when elements are
> > already equal or in the correct position.
> >
> > Cc: stable@vger.kernel.org # 6.11+
> > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > ---
> >  include/linux/min_heap.h | 51 ++++++++++++++++++++++++++++++++++++++++
> >  lib/min_heap.c           |  7 ++++++
> >  2 files changed, 58 insertions(+)
> >
> > diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> > index 79ddc0adbf2b..b0d603fe5379 100644
> > --- a/include/linux/min_heap.h
> > +++ b/include/linux/min_heap.h
> > @@ -292,6 +292,52 @@ void __min_heap_sift_down_inline(min_heap_char *heap, size_t pos, size_t elem_si
> >         __min_heap_sift_down_inline(container_of(&(_heap)->nr, min_heap_char, nr), _pos,        \
> >                                     __minheap_obj_size(_heap), _func, _args)
> >
> > +/*
> > + * Sift the element at pos down the heap.
> > + *
> > + * Variants of heap functions using an equal-elements-aware sift_down.
> > + * These may perform better when the heap contains many equal elements.
> > + */
> > +static __always_inline
> > +void __min_heap_sift_down_eqaware_inline(min_heap_char * heap, size_t pos, size_t elem_size,
> > +                                        const struct min_heap_callbacks *func, void *args)
> > +{
> > +       void *data = heap->data;
> > +       void (*swp)(void *lhs, void *rhs, void *args) = func->swp;
> > +       /* pre-scale counters for performance */
> > +       size_t a = pos * elem_size;
> > +       size_t b, c, smallest;
> > +       size_t n = heap->nr * elem_size;
> > +
> > +       if (!swp)
> > +               swp = select_swap_func(data, elem_size);
> > +
> > +       for (;;) {
> > +               b = 2 * a + elem_size;
> > +               c = b + elem_size;
> > +               smallest = a;
> > +
> > +               if (b >= n)
> > +                       break;
> > +
> > +               if (func->less(data + b, data + smallest, args))
> > +                       smallest = b;
> > +
> > +               if (c < n && func->less(data + c, data + smallest, args))
> > +                       smallest = c;
> > +
> > +               if (smallest == a)
> > +                       break;
> > +
> > +               do_swap(data + a, data + smallest, elem_size, swp, args);
> > +               a = smallest;
> > +       }
> > +}
> > +
> > +#define min_heap_sift_down_eqaware_inline(_heap, _pos, _func, _args)   \
> > +       __min_heap_sift_down_inline(container_of(&(_heap)->nr, min_heap_char, nr), _pos,        \
> > +                                   __minheap_obj_size(_heap), _func, _args)
> > +
> >  /* Sift up ith element from the heap, O(log2(nr)). */
> >  static __always_inline
> >  void __min_heap_sift_up_inline(min_heap_char *heap, size_t elem_size, size_t idx,
> > @@ -433,6 +479,8 @@ void *__min_heap_peek(struct min_heap_char *heap);
> >  bool __min_heap_full(min_heap_char *heap);
> >  void __min_heap_sift_down(min_heap_char *heap, size_t pos, size_t elem_size,
> >                           const struct min_heap_callbacks *func, void *args);
> > +void __min_heap_sift_down_eqaware(min_heap_char *heap, size_t pos, size_t elem_size,
> > +                                 const struct min_heap_callbacks *func, void *args);
> >  void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
> >                         const struct min_heap_callbacks *func, void *args);
> >  void __min_heapify_all(min_heap_char *heap, size_t elem_size,
> > @@ -455,6 +503,9 @@ bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
> >  #define min_heap_sift_down(_heap, _pos, _func, _args)  \
> >         __min_heap_sift_down(container_of(&(_heap)->nr, min_heap_char, nr), _pos,       \
> >                              __minheap_obj_size(_heap), _func, _args)
> > +#define min_heap_sift_down_eqaware(_heap, _pos, _func, _args)  \
> > +       __min_heap_sift_down_eqaware(container_of(&(_heap)->nr, min_heap_char, nr), _pos,       \
> > +                            __minheap_obj_size(_heap), _func, _args)
> >  #define min_heap_sift_up(_heap, _idx, _func, _args)    \
> >         __min_heap_sift_up(container_of(&(_heap)->nr, min_heap_char, nr),       \
> >                            __minheap_obj_size(_heap), _idx, _func, _args)
> > diff --git a/lib/min_heap.c b/lib/min_heap.c
> > index 96f01a4c5fb6..2225f40d0d7a 100644
> > --- a/lib/min_heap.c
> > +++ b/lib/min_heap.c
> > @@ -27,6 +27,13 @@ void __min_heap_sift_down(min_heap_char *heap, size_t pos, size_t elem_size,
> >  }
> >  EXPORT_SYMBOL(__min_heap_sift_down);
> >
> > +void __min_heap_sift_down_eqaware(min_heap_char *heap, size_t pos, size_t elem_size,
> > +                                 const struct min_heap_callbacks *func, void *args)
> > +{
> > +       __min_heap_sift_down_eqaware_inline(heap, pos, elem_size, func, args);
> > +}
> > +EXPORT_SYMBOL(__min_heap_sift_down_eqaware);
> > +
> >  void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
> >                         const struct min_heap_callbacks *func, void *args)
> >  {
> > --
> > 2.34.1
> >

