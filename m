Return-Path: <linux-bcache+bounces-1115-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 62561AD376C
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Jun 2025 14:55:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7820E188F2CE
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Jun 2025 12:52:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C3AB2989AA;
	Tue, 10 Jun 2025 12:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A6Cltho/"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81547299936
	for <linux-bcache@vger.kernel.org>; Tue, 10 Jun 2025 12:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749559496; cv=none; b=Lrg1IiLZyDEl3NnJ+rDda5Rr17qzKRLz9pFporQNNNFgjDdvIeXPF/p/87d/yOuVVE1+ws8BCjwLLyPg/EAC41vu4gOXWMc/+f35KaVHTb902oFT7b/EttbAQcynPctmuY72cU1xvw4ZypPvArMQ1WawTeusbpSbAdN5OSn8WVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749559496; c=relaxed/simple;
	bh=5NZ8fvANuTshXHR+1mhzA2pnJZJFpCdsX8vCqxtphTw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AUdJgQ6uFynMtv8Kk84zam5SYbMa+rDAIcWRsztJ5fh2xiPPkpe5RYc54LPK5M/cxzbrog015JLU/R2W4notrK6TFoRTTQvmrOk9uK4WJ9Ys/lTP69yEqr/LoC8tC2OKBRdZiVZwH1nYF9cKuBC5jb+QWFzL0vIRxU7ERhcD5qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A6Cltho/; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4a5ac8fae12so292391cf.0
        for <linux-bcache@vger.kernel.org>; Tue, 10 Jun 2025 05:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749559493; x=1750164293; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fpw+yS+Dw1/BevpFldXsTlHsyXa8rqC9UDFW/ZY7v+0=;
        b=A6Cltho/3kKvBXCxYjH4qoc9yQQR4Smno5M4jf7wHNkyriJildIkdPoH0p/p5s1VSy
         ic88Xk5kq/XbSQP6ZYuyxs3XiAZDAIM1Sl9psyRCaZpFW/3v9gZAL1IyJCZSKgllWngA
         xEREGTeQVp1ay9IRL5p/5SJNAv+vGspOcG6PmMxv8ImNFWaXNsVki1dNK4mMpm+vciB4
         8h8tCL5t5FAgf+bVGIyO5D+2BcycvdE/7/VZNrMK9EHjmlvtCpJymeqdMzQUWNm411++
         cZVZU5U2i+kB/MVZfgpwj46AxJBRhxlJOLdaVMFUQe3fvxR3WMgQ8mQk3w44YBc5AuSK
         6/sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749559493; x=1750164293;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fpw+yS+Dw1/BevpFldXsTlHsyXa8rqC9UDFW/ZY7v+0=;
        b=V5Dxw5ABH8nHcaH0jFllHuZVn15QMypRFOUrrTK6rP4sJFmg0js5TGLbi8/msjlnCw
         eyLC7tI5ANKub1ddXDZ5aqMktJ9ynD+UN3fzEnrqAvXn7DERDqu/OzUhaszcKSC0/XbE
         COCMNpMVbTKvbbb6VSwVaRIPq0c1JW92QD7yaS/0yBA7A9oFkQiZu9Svf4ciS8vonj6n
         6mb50M+OhxmhyuxwnBUcYGdDu9I9q1o8ilGuufcLcmvXECWreik92NitTd0LhxzXgwbT
         pIXqLoNt4jzhp2kFH2o32XJ31SlKxEDyUtEU/TJCCNVxHirihAjfCmK1TDC6CDsZl7C1
         Re5g==
X-Forwarded-Encrypted: i=1; AJvYcCVeTOmaEKowgaIL3i01tG3/pccUbGF/QijTtr/JhpTR0gv3kztP5alrc8DMa5ZbVFlVVQ7wovjdGntxClk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+vll127o9HfWQRqYCKxCaiXJ8LTIKStUfZCb43j4LmpBb2CSM
	f7ILavWulT3+HiIc0/BP5kaqZ0wnSAmZZ4YO6iNkLotAax3VJbZoHoO4Z2xAsn9GKf9lHO0l5W2
	EE4JVGS/Adh5/xhTVmwKZfNdv+2ELHAmi7bvmaOK3
X-Gm-Gg: ASbGncscL6zvhYZr4a86x7WjFehyJ3BPWWl23jFJvRqdLislYXvfqdDll9xBNh7lA7e
	nEUaWLMprbx6+6AvVxYhgpMVLEIa/9zcGziu47ovEq4fFDIa61N8BCGGNrqTrZA/zv+8N1+hRkv
	3jeL5SL1XHM1TZW6Kth3d9YlJCFdfNKxWifJ0X4NAZYKE0
X-Google-Smtp-Source: AGHT+IEh6TL0OuiIcvh66cLqV6sW8Fj7pXHRuiFjkwoBa1gzunfNDH3NZcBTyNdb3Bn2v05fW7Xkr/fkDsGZSAuIJa8=
X-Received: by 2002:a05:622a:3d1:b0:4a6:fda0:748f with SMTP id
 d75a77b69052e-4a6fda077a0mr8099251cf.7.1749559492936; Tue, 10 Jun 2025
 05:44:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250606071959.1685079-1-robertpang@google.com>
 <20250606071959.1685079-4-robertpang@google.com> <aELmvZ4Mm7gwGqhj@visitorckw-System-Product-Name>
In-Reply-To: <aELmvZ4Mm7gwGqhj@visitorckw-System-Product-Name>
From: Robert Pang <robertpang@google.com>
Date: Tue, 10 Jun 2025 21:44:40 +0900
X-Gm-Features: AX0GCFvfEGDMLol2b2Ohr8zA_nT8w9My6vANUbl3mNgS21IlZ11A_a1v_mhOgsA
Message-ID: <CAJhEC05LRVKHBVYL1UrA2-iZGkMaQSNVKj4bEpqWxjhDaexkPA@mail.gmail.com>
Subject: Re: [PATCH 3/3] bcache: Fix the tail IO latency regression due to the
 use of lib min_heap
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Coly Li <colyli@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

When I tested this patch series initially, merely switching to the
traditional top-down sift-down alone did not resolve the latency
regression fully. It requires both the top-down sift-down plus
inlining together to match the original latency numbers before the
migration to lib/min_heap API. As I understand, the
invalidate_buckets_lru() is performance-critical and requires both
optimizations.

Best regards
Robert

On Fri, Jun 6, 2025 at 10:01=E2=80=AFPM Kuan-Wei Chiu <visitorckw@gmail.com=
> wrote:
>
> On Fri, Jun 06, 2025 at 12:19:45AM -0700, Robert Pang wrote:
> > In commit "lib/min_heap: introduce non-inline versions of min heap API =
functions"
> > (92a8b22), bcache migrates to the generic lib min_heap for all heap ope=
rations.
> > This causes sizeable the tail IO latency regression during the cache re=
placement.
>
> Nit: According to the documentation, I'd prefer referencing the commit
> like this:
>
> 92a8b224b833 ("lib/min_heap: introduce non-inline versions of min heap
> API functions")
> https://docs.kernel.org/process/submitting-patches.html#describe-your-cha=
nges
>
> Also, if the regression is caused by the heapify method, shouldn't the
> commit that introduced it be 866898efbb25 ("bcache: remove heap-related
> macros and switch to generic min_heap") ?
>
> >
> > This commit updates invalidate_buckets_lru() to use the alternative API=
s that
> > sift down elements using the top-down approach like bcache's own origin=
al heap
> > implementation.
> >
> > [1] https://lore.kernel.org/linux-bcache/wtfuhfntbi6yorxqtpcs4vg5w67mvy=
ckp2a6jmxuzt2hvbw65t@gznwsae5653d/T/#me50a9ddd0386ce602b2f17415e02d33b8e29f=
533
> >
> > Signed-off-by: Robert Pang <robertpang@google.com>
> > ---
> >  drivers/md/bcache/alloc.c | 14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
> > index 8998e61efa40..547d1cd0c7c2 100644
> > --- a/drivers/md/bcache/alloc.c
> > +++ b/drivers/md/bcache/alloc.c
> > @@ -207,15 +207,15 @@ static void invalidate_buckets_lru(struct cache *=
ca)
> >               if (!bch_can_invalidate_bucket(ca, b))
> >                       continue;
> >
> > -             if (!min_heap_full(&ca->heap))
> > -                     min_heap_push(&ca->heap, &b, &bucket_max_cmp_call=
back, ca);
> > -             else if (!new_bucket_max_cmp(&b, min_heap_peek(&ca->heap)=
, ca)) {
> > +             if (!min_heap_full_inline(&ca->heap))
> > +                     min_heap_push_inline(&ca->heap, &b, &bucket_max_c=
mp_callback, ca);
>
> If the regression is caused by the heapify method rather than the
> inline vs non-inline change, is it necessary to switch to the
> non-inline version here?
>
> Regards,
> Kuan-Wei
>
> > +             else if (!new_bucket_max_cmp(&b, min_heap_peek_inline(&ca=
->heap), ca)) {
> >                       ca->heap.data[0] =3D b;
> > -                     min_heap_sift_down(&ca->heap, 0, &bucket_max_cmp_=
callback, ca);
> > +                     min_heap_sift_down_top_down_inline(&ca->heap, 0, =
&bucket_max_cmp_callback, ca);
> >               }
> >       }
> >
> > -     min_heapify_all(&ca->heap, &bucket_min_cmp_callback, ca);
> > +     min_heapify_all_top_down_inline(&ca->heap, &bucket_min_cmp_callba=
ck, ca);
> >
> >       while (!fifo_full(&ca->free_inc)) {
> >               if (!ca->heap.nr) {
> > @@ -227,8 +227,8 @@ static void invalidate_buckets_lru(struct cache *ca=
)
> >                       wake_up_gc(ca->set);
> >                       return;
> >               }
> > -             b =3D min_heap_peek(&ca->heap)[0];
> > -             min_heap_pop(&ca->heap, &bucket_min_cmp_callback, ca);
> > +             b =3D min_heap_peek_inline(&ca->heap)[0];
> > +             min_heap_pop_top_down_inline(&ca->heap, &bucket_min_cmp_c=
allback, ca);
> >
> >               bch_invalidate_one_bucket(ca, b);
> >       }
> > --
> > 2.50.0.rc1.591.g9c95f17f64-goog
> >

