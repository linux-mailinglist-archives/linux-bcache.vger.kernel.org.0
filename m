Return-Path: <linux-bcache+bounces-350-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EB79488167C
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 18:22:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 62236B24139
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 17:22:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CC4B6A352;
	Wed, 20 Mar 2024 17:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b7BA9ICF"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3426A329
	for <linux-bcache@vger.kernel.org>; Wed, 20 Mar 2024 17:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710955265; cv=none; b=GmPTfYgRO3lY15J5jQorZ/Dpn8813LPXDqZyRyT6b4KXkwf0ZETu0wJ/uOQI5bnOCOi1gYZfZtIYtf7VKdJL4iOjhL/5deDph1Xg/CsHhA5GCzmZbLUVlh2AotdN8pjj0HBbbFcZBenFb8u1Wf4VtDx9ka+rcJWKUWZwYO0b/DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710955265; c=relaxed/simple;
	bh=+SX43BWO6u+p5f4Vx1LbMGUeQVHcvfL4yh3HKoiXaOI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ItSAY/jYDb+A69RJduiUonceMKbPc5D6EuWbmOLCSpgAGbHzOXJPNWvPjlsIoUFel+nrM5fkAGvKzPZb/fDA3y0paC++o6pBgZ5PvvVaQnxPvEsKu4pwdKQJl7I45iroA0QHPecnV0O1fDPRwhzfhLWMgJkg6NJQNx6RzcHac60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b7BA9ICF; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1e062f3a47bso6725ad.1
        for <linux-bcache@vger.kernel.org>; Wed, 20 Mar 2024 10:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710955262; x=1711560062; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b8zFRjf4Lu5KxIDhdOc4C9O3ujBbtuLkYfCxydXmaL0=;
        b=b7BA9ICFPzV9n7JIHW+t+J79h05D2go0wH1dSJCE33EPBWMqHyjr8CH/Jci2jiSsvy
         KWWXTVf+lJAQcWfBr1fqLoD5/i7dLAwC6030N2EQubRWnZjEnx9OAX5sF/UVsdmy5GBB
         kl8JVnxZDd1GcClHkL5ZEWdziQL/DWd6v0TrtdZ9m9vSvo9wVlPyu6a7Tg7mEel5Ps9X
         9sv9xzNtpLavxJiaZoeg4uqn5Fpx9TNJHqqSOYxojvuPHl/mHt0TvZHrtQWirYdDfuZb
         sBAW+amyvhH4/OkHveKTMH1q+qLIFnhCqAjipjJ9Bp7JhE0e7h2BRYoAdwIKxg1wUX6a
         wmdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710955262; x=1711560062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b8zFRjf4Lu5KxIDhdOc4C9O3ujBbtuLkYfCxydXmaL0=;
        b=l3IcvrguqlNvcPqptpRShyc5wnIlWlUGvWjNUAyuHZVEvy3flvboCsMzbPALU4wYKm
         kmKaC/Y9vsQ0ZLuGnhzzEvnxfauBm/W835NoQEVnsvL/fz9WuspB+4woyFNRAAq2gsfr
         wH/PELuvrgnEYn6aHYnf+fzj5EIUbhlHgZRZe4iCk9t/sSCNnoJfmou8LyC/7+kPjAES
         AhdmXyxd9BnNRlQquqz6y1ma/d2QXaoSS5GOm+T7kVnfHhbzz2HZPkAkJ6weeQ0NQzNH
         2ET6wzQKIjx7hqzN0ZtPWpPcRMlKemGugrZjDarIh3jRYK0TToc3UgPO/nKMXaX0lJ+A
         PGeQ==
X-Forwarded-Encrypted: i=1; AJvYcCVU5gCdv9rVQ0l0R66dI++BZWUNbxfNHa1zDGkgilBxZ87CTDjYjWU+gSe+f/ia8RVLRXs7mm2oi5gCdvK6F/RhJqyJrjtFfzOLwwXZ
X-Gm-Message-State: AOJu0YzDvqbydnyJofm9xYoxNNVpAEE41ZCTnJk2A3DrneAMpP3J8UWl
	VRFiLPEojpwMvxHQn/A8vhvs+RfKKeSj9UWD8zUbTm6ex5nmRPD+BBb9FkeiYZzb2XeJQP0dfpR
	yoOtjhfoc52mIUPkl+QWEFJXQrddYLqfqcAx3
X-Google-Smtp-Source: AGHT+IGxkRxK8RgP4Er4icB5kbdhxDCHvobQMPJ+91a7OPiuAM4D/WWiMYrc0KMnivFPSdshJz+8NuvedPr8WreDM68=
X-Received: by 2002:a17:902:ea11:b0:1de:ed50:41f8 with SMTP id
 s17-20020a170902ea1100b001deed5041f8mr306592plg.22.1710955261406; Wed, 20 Mar
 2024 10:21:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240320145417.336208-1-visitorckw@gmail.com> <20240320145417.336208-16-visitorckw@gmail.com>
In-Reply-To: <20240320145417.336208-16-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Wed, 20 Mar 2024 10:20:50 -0700
Message-ID: <CAP-5=fVfrhvMdU+6RkK6FYuNa-FtSe8LvkvTRnCXHtCe42NjQw@mail.gmail.com>
Subject: Re: [PATCH v2 15/15] bcachefs: Remove heap-related macros and switch
 to generic min_heap
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
> Drop the heap-related macros from bcachefs and replacing them with the
> generic min_heap implementation from include/linux. By doing so, code
> readability is improved by using functions instead of macros. Moreover,
> the min_heap implementation in include/linux adopts a bottom-up
> variation compared to the textbook version currently used in bcachefs.
> This bottom-up variation allows for approximately 50% reduction in the
> number of comparison operations during heap siftdown, without changing
> the number of swaps, thus making it more efficient.
>
> Link: https://lkml.kernel.org/ioyfizrzq7w7mjrqcadtzsfgpuntowtjdw5pgn4qhvs=
dp4mqqg@nrlek5vmisbu
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Reviewed-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
> Changes in v2:
> - Add attribute __always_unused to the compare and swap functions that
>   do not use the args parameter.
> - Rename min_heapify() to min_heap_sift_down().
> - Refine the commit message.
>
>  fs/bcachefs/clock.c       |  53 +++++++++++-----
>  fs/bcachefs/clock_types.h |   2 +-
>  fs/bcachefs/ec.c          | 100 +++++++++++++++++++-----------
>  fs/bcachefs/ec_types.h    |   2 +-
>  fs/bcachefs/util.h        | 127 +++-----------------------------------
>  5 files changed, 110 insertions(+), 174 deletions(-)
>
> diff --git a/fs/bcachefs/clock.c b/fs/bcachefs/clock.c
> index 363644451106..e898f4693bd0 100644
> --- a/fs/bcachefs/clock.c
> +++ b/fs/bcachefs/clock.c
> @@ -6,16 +6,29 @@
>  #include <linux/kthread.h>
>  #include <linux/preempt.h>
>
> -static inline long io_timer_cmp(io_timer_heap *h,
> -                               struct io_timer *l,
> -                               struct io_timer *r)
> +static inline bool io_timer_cmp(const void *l, const void *r, void __alw=
ays_unused *args)
>  {
> -       return l->expire - r->expire;
> +       struct io_timer *_l =3D (struct io_timer *)l;
> +       struct io_timer *_r =3D (struct io_timer *)r;
> +
> +       return _l->expire >=3D _r->expire;
> +}
> +
> +static inline void io_timer_swp(void *l, void *r, void __always_unused *=
args)
> +{
> +       struct io_timer *_l =3D (struct io_timer *)l;
> +       struct io_timer *_r =3D (struct io_timer *)r;
> +
> +       swap(*_l, *_r);
>  }
>
>  void bch2_io_timer_add(struct io_clock *clock, struct io_timer *timer)
>  {
>         size_t i;
> +       const struct min_heap_callbacks callbacks =3D {
> +               .less =3D io_timer_cmp,
> +               .swp =3D io_timer_swp,
> +       };
>
>         spin_lock(&clock->timer_lock);
>
> @@ -26,11 +39,11 @@ void bch2_io_timer_add(struct io_clock *clock, struct=
 io_timer *timer)
>                 return;
>         }
>
> -       for (i =3D 0; i < clock->timers.used; i++)
> -               if (clock->timers.data[i] =3D=3D timer)
> +       for (i =3D 0; i < clock->timers.heap.nr; i++)
> +               if (min_heap_peek(&clock->timers)[i] =3D=3D timer)
>                         goto out;
>
> -       BUG_ON(!heap_add(&clock->timers, timer, io_timer_cmp, NULL));
> +       BUG_ON(!min_heap_push(&clock->timers, &timer, &callbacks, NULL));
>  out:
>         spin_unlock(&clock->timer_lock);
>  }
> @@ -38,12 +51,16 @@ void bch2_io_timer_add(struct io_clock *clock, struct=
 io_timer *timer)
>  void bch2_io_timer_del(struct io_clock *clock, struct io_timer *timer)
>  {
>         size_t i;
> +       const struct min_heap_callbacks callbacks =3D {
> +               .less =3D io_timer_cmp,
> +               .swp =3D io_timer_swp,
> +       };
>
>         spin_lock(&clock->timer_lock);
>
> -       for (i =3D 0; i < clock->timers.used; i++)
> -               if (clock->timers.data[i] =3D=3D timer) {
> -                       heap_del(&clock->timers, i, io_timer_cmp, NULL);
> +       for (i =3D 0; i < clock->timers.heap.nr; i++)
> +               if (min_heap_peek(&clock->timers)[i] =3D=3D timer) {
> +                       min_heap_pop(&clock->timers, &callbacks, NULL);
>                         break;
>                 }
>
> @@ -131,12 +148,16 @@ static struct io_timer *get_expired_timer(struct io=
_clock *clock,
>                                           unsigned long now)
>  {
>         struct io_timer *ret =3D NULL;
> +       const struct min_heap_callbacks callbacks =3D {
> +               .less =3D io_timer_cmp,
> +               .swp =3D io_timer_swp,
> +       };
>
>         spin_lock(&clock->timer_lock);
>
> -       if (clock->timers.used &&
> -           time_after_eq(now, clock->timers.data[0]->expire))
> -               heap_pop(&clock->timers, ret, io_timer_cmp, NULL);
> +       if (clock->timers.heap.nr &&
> +           time_after_eq(now, min_heap_peek(&clock->timers)[0]->expire))
> +               min_heap_pop(&clock->timers, &callbacks, NULL);
>
>         spin_unlock(&clock->timer_lock);
>
> @@ -161,10 +182,10 @@ void bch2_io_timers_to_text(struct printbuf *out, s=
truct io_clock *clock)
>         spin_lock(&clock->timer_lock);
>         now =3D atomic64_read(&clock->now);
>
> -       for (i =3D 0; i < clock->timers.used; i++)
> +       for (i =3D 0; i < clock->timers.heap.nr; i++)
>                 prt_printf(out, "%ps:\t%li\n",
> -                      clock->timers.data[i]->fn,
> -                      clock->timers.data[i]->expire - now);
> +                      min_heap_peek(&clock->timers)[i]->fn,
> +                      min_heap_peek(&clock->timers)[i]->expire - now);
>         spin_unlock(&clock->timer_lock);
>         --out->atomic;
>  }
> diff --git a/fs/bcachefs/clock_types.h b/fs/bcachefs/clock_types.h
> index 5fae0012d808..b02b24b9d74f 100644
> --- a/fs/bcachefs/clock_types.h
> +++ b/fs/bcachefs/clock_types.h
> @@ -23,7 +23,7 @@ struct io_timer {
>  /* Amount to buffer up on a percpu counter */
>  #define IO_CLOCK_PCPU_SECTORS  128
>
> -typedef HEAP(struct io_timer *)        io_timer_heap;
> +typedef MIN_HEAP(struct io_timer *, io_timer_heap) io_timer_heap;
>
>  struct io_clock {
>         atomic64_t              now;
> diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
> index 082075244e16..68c5e9e928a7 100644
> --- a/fs/bcachefs/ec.c
> +++ b/fs/bcachefs/ec.c
> @@ -860,14 +860,15 @@ static int __ec_stripe_mem_alloc(struct bch_fs *c, =
size_t idx, gfp_t gfp)
>  {
>         ec_stripes_heap n, *h =3D &c->ec_stripes_heap;
>
> -       if (idx >=3D h->size) {
> +       if (idx >=3D h->heap.size) {
>                 if (!init_heap(&n, max(1024UL, roundup_pow_of_two(idx + 1=
)), gfp))
>                         return -BCH_ERR_ENOMEM_ec_stripe_mem_alloc;
>
>                 mutex_lock(&c->ec_stripes_heap_lock);
> -               if (n.size > h->size) {
> -                       memcpy(n.data, h->data, h->used * sizeof(h->data[=
0]));
> -                       n.used =3D h->used;
> +               if (n.heap.size > h->heap.size) {
> +                       memcpy(min_heap_peek(&n), min_heap_peek(h),
> +                               h->heap.nr * sizeof(*min_heap_peek(h)));
> +                       n.heap.nr =3D h->heap.nr;
>                         swap(*h, n);
>                 }
>                 mutex_unlock(&c->ec_stripes_heap_lock);
> @@ -958,20 +959,21 @@ static u64 stripe_idx_to_delete(struct bch_fs *c)
>
>         lockdep_assert_held(&c->ec_stripes_heap_lock);
>
> -       if (h->used &&
> -           h->data[0].blocks_nonempty =3D=3D 0 &&
> -           !bch2_stripe_is_open(c, h->data[0].idx))
> -               return h->data[0].idx;
> +       if (h->heap.nr &&
> +           min_heap_peek(h)->blocks_nonempty =3D=3D 0 &&
> +           !bch2_stripe_is_open(c, min_heap_peek(h)->idx))
> +               return min_heap_peek(h)->idx;
>
>         return 0;
>  }
>
> -static inline int ec_stripes_heap_cmp(ec_stripes_heap *h,
> -                                     struct ec_stripe_heap_entry l,
> -                                     struct ec_stripe_heap_entry r)
> +static inline bool ec_stripes_heap_cmp(const void *l, const void *r, voi=
d __always_unused *args)
>  {
> -       return ((l.blocks_nonempty > r.blocks_nonempty) -
> -               (l.blocks_nonempty < r.blocks_nonempty));
> +       struct ec_stripe_heap_entry *_l =3D (struct ec_stripe_heap_entry =
*)l;
> +       struct ec_stripe_heap_entry *_r =3D (struct ec_stripe_heap_entry =
*)r;
> +
> +       return ((_l->blocks_nonempty > _r->blocks_nonempty) >=3D
> +               (_l->blocks_nonempty < _r->blocks_nonempty));
>  }
>
>  static inline void ec_stripes_heap_set_backpointer(ec_stripes_heap *h,
> @@ -979,7 +981,21 @@ static inline void ec_stripes_heap_set_backpointer(e=
c_stripes_heap *h,
>  {
>         struct bch_fs *c =3D container_of(h, struct bch_fs, ec_stripes_he=
ap);
>
> -       genradix_ptr(&c->stripes, h->data[i].idx)->heap_idx =3D i;
> +       genradix_ptr(&c->stripes, min_heap_peek(h)[i].idx)->heap_idx =3D =
i;
> +}
> +
> +static inline void ec_stripes_heap_swap(void *l, void *r, void *h)
> +{
> +       struct ec_stripe_heap_entry *_l =3D (struct ec_stripe_heap_entry =
*)l;
> +       struct ec_stripe_heap_entry *_r =3D (struct ec_stripe_heap_entry =
*)r;
> +       ec_stripes_heap *_h =3D (ec_stripes_heap *)h;
> +       size_t i =3D _l - min_heap_peek(_h);
> +       size_t j =3D _r - min_heap_peek(_h);
> +
> +       ec_stripes_heap_set_backpointer(_h, i);
> +       ec_stripes_heap_set_backpointer(_h, j);
> +
> +       swap(*_l, *_r);
>  }
>
>  static void heap_verify_backpointer(struct bch_fs *c, size_t idx)
> @@ -987,34 +1003,43 @@ static void heap_verify_backpointer(struct bch_fs =
*c, size_t idx)
>         ec_stripes_heap *h =3D &c->ec_stripes_heap;
>         struct stripe *m =3D genradix_ptr(&c->stripes, idx);
>
> -       BUG_ON(m->heap_idx >=3D h->used);
> -       BUG_ON(h->data[m->heap_idx].idx !=3D idx);
> +       BUG_ON(m->heap_idx >=3D h->heap.nr);
> +       BUG_ON(min_heap_peek(h)[m->heap_idx].idx !=3D idx);
>  }
>
>  void bch2_stripes_heap_del(struct bch_fs *c,
>                            struct stripe *m, size_t idx)
>  {
> +       const struct min_heap_callbacks callbacks =3D {
> +               .less =3D ec_stripes_heap_cmp,
> +               .swp =3D ec_stripes_heap_swap,
> +       };
> +
>         mutex_lock(&c->ec_stripes_heap_lock);
>         heap_verify_backpointer(c, idx);
>
> -       heap_del(&c->ec_stripes_heap, m->heap_idx,
> -                ec_stripes_heap_cmp,
> -                ec_stripes_heap_set_backpointer);
> +       min_heap_del(&c->ec_stripes_heap, m->heap_idx, &callbacks, &c->ec=
_stripes_heap);
>         mutex_unlock(&c->ec_stripes_heap_lock);
>  }
>
>  void bch2_stripes_heap_insert(struct bch_fs *c,
>                               struct stripe *m, size_t idx)
>  {
> +       const struct min_heap_callbacks callbacks =3D {
> +               .less =3D ec_stripes_heap_cmp,
> +               .swp =3D ec_stripes_heap_swap,
> +       };
> +
>         mutex_lock(&c->ec_stripes_heap_lock);
> -       BUG_ON(heap_full(&c->ec_stripes_heap));
> +       BUG_ON(min_heap_full(&c->ec_stripes_heap));
>
> -       heap_add(&c->ec_stripes_heap, ((struct ec_stripe_heap_entry) {
> +       genradix_ptr(&c->stripes, idx)->heap_idx =3D c->ec_stripes_heap.h=
eap.nr;
> +       min_heap_push(&c->ec_stripes_heap, &((struct ec_stripe_heap_entry=
) {
>                         .idx =3D idx,
>                         .blocks_nonempty =3D m->blocks_nonempty,
>                 }),
> -                ec_stripes_heap_cmp,
> -                ec_stripes_heap_set_backpointer);
> +                &callbacks,
> +                &c->ec_stripes_heap);
>
>         heap_verify_backpointer(c, idx);
>         mutex_unlock(&c->ec_stripes_heap_lock);
> @@ -1026,17 +1051,20 @@ void bch2_stripes_heap_update(struct bch_fs *c,
>         ec_stripes_heap *h =3D &c->ec_stripes_heap;
>         bool do_deletes;
>         size_t i;
> +       const struct min_heap_callbacks callbacks =3D {
> +               .less =3D ec_stripes_heap_cmp,
> +               .swp =3D ec_stripes_heap_swap,
> +       };
>
>         mutex_lock(&c->ec_stripes_heap_lock);
>         heap_verify_backpointer(c, idx);
>
> -       h->data[m->heap_idx].blocks_nonempty =3D m->blocks_nonempty;
> +       min_heap_peek(h)[m->heap_idx].blocks_nonempty =3D m->blocks_nonem=
pty;
>
>         i =3D m->heap_idx;
> -       heap_sift_up(h,   i, ec_stripes_heap_cmp,
> -                    ec_stripes_heap_set_backpointer);
> -       heap_sift_down(h, i, ec_stripes_heap_cmp,
> -                      ec_stripes_heap_set_backpointer);
> +
> +       min_heap_sift_up(h,     i, &callbacks, &c->ec_stripes_heap);
> +       min_heap_sift_down(h, i, &callbacks, &c->ec_stripes_heap);
>
>         heap_verify_backpointer(c, idx);
>
> @@ -1828,12 +1856,12 @@ static s64 get_existing_stripe(struct bch_fs *c,
>                 return -1;
>
>         mutex_lock(&c->ec_stripes_heap_lock);
> -       for (heap_idx =3D 0; heap_idx < h->used; heap_idx++) {
> +       for (heap_idx =3D 0; heap_idx < h->heap.nr; heap_idx++) {
>                 /* No blocks worth reusing, stripe will just be deleted: =
*/
> -               if (!h->data[heap_idx].blocks_nonempty)
> +               if (!min_heap_peek(h)[heap_idx].blocks_nonempty)
>                         continue;
>
> -               stripe_idx =3D h->data[heap_idx].idx;
> +               stripe_idx =3D min_heap_peek(h)[heap_idx].idx;
>
>                 m =3D genradix_ptr(&c->stripes, stripe_idx);
>
> @@ -2159,14 +2187,14 @@ void bch2_stripes_heap_to_text(struct printbuf *o=
ut, struct bch_fs *c)
>         size_t i;
>
>         mutex_lock(&c->ec_stripes_heap_lock);
> -       for (i =3D 0; i < min_t(size_t, h->used, 50); i++) {
> -               m =3D genradix_ptr(&c->stripes, h->data[i].idx);
> +       for (i =3D 0; i < min_t(size_t, h->heap.nr, 50); i++) {
> +               m =3D genradix_ptr(&c->stripes, min_heap_peek(h)[i].idx);
>
> -               prt_printf(out, "%zu %u/%u+%u", h->data[i].idx,
> -                      h->data[i].blocks_nonempty,
> +               prt_printf(out, "%zu %u/%u+%u", min_heap_peek(h)[i].idx,
> +                      min_heap_peek(h)[i].blocks_nonempty,
>                        m->nr_blocks - m->nr_redundant,
>                        m->nr_redundant);
> -               if (bch2_stripe_is_open(c, h->data[i].idx))
> +               if (bch2_stripe_is_open(c, min_heap_peek(h)[i].idx))
>                         prt_str(out, " open");
>                 prt_newline(out);
>         }
> diff --git a/fs/bcachefs/ec_types.h b/fs/bcachefs/ec_types.h
> index 976426da3a12..2ed67431a81c 100644
> --- a/fs/bcachefs/ec_types.h
> +++ b/fs/bcachefs/ec_types.h
> @@ -36,6 +36,6 @@ struct ec_stripe_heap_entry {
>         unsigned                blocks_nonempty;
>  };
>
> -typedef HEAP(struct ec_stripe_heap_entry) ec_stripes_heap;
> +typedef MIN_HEAP(struct ec_stripe_heap_entry, ec_stripes_heap) ec_stripe=
s_heap;
>
>  #endif /* _BCACHEFS_EC_TYPES_H */
> diff --git a/fs/bcachefs/util.h b/fs/bcachefs/util.h
> index 175aee3074c7..e0c86ad04bf3 100644
> --- a/fs/bcachefs/util.h
> +++ b/fs/bcachefs/util.h
> @@ -8,6 +8,7 @@
>  #include <linux/errno.h>
>  #include <linux/freezer.h>
>  #include <linux/kernel.h>
> +#include <linux/min_heap.h>
>  #include <linux/sched/clock.h>
>  #include <linux/llist.h>
>  #include <linux/log2.h>
> @@ -54,134 +55,20 @@ static inline size_t buf_pages(void *p, size_t len)
>                             PAGE_SIZE);
>  }
>
> -#define HEAP(type)                                                     \
> -struct {                                                               \
> -       size_t size, used;                                              \
> -       type *data;                                                     \
> -}
> -
> -#define DECLARE_HEAP(type, name) HEAP(type) name
> -
>  #define init_heap(heap, _size, gfp)                                    \
>  ({                                                                     \
> -       (heap)->used =3D 0;                                              =
 \
> -       (heap)->size =3D (_size);                                        =
 \
> -       (heap)->data =3D kvmalloc((heap)->size * sizeof((heap)->data[0]),=
\
> -                                (gfp));                                \
> -})
> -
> -#define free_heap(heap)                                                 =
       \
> -do {                                                                   \
> -       kvfree((heap)->data);                                           \
> -       (heap)->data =3D NULL;                                           =
 \
> -} while (0)
> -
> -#define heap_set_backpointer(h, i, _fn)                                 =
       \
> -do {                                                                   \
> -       void (*fn)(typeof(h), size_t) =3D _fn;                           =
 \
> -       if (fn)                                                         \
> -               fn(h, i);                                               \
> -} while (0)
> -
> -#define heap_swap(h, i, j, set_backpointer)                            \
> -do {                                                                   \
> -       swap((h)->data[i], (h)->data[j]);                               \
> -       heap_set_backpointer(h, i, set_backpointer);                    \
> -       heap_set_backpointer(h, j, set_backpointer);                    \
> -} while (0)
> -
> -#define heap_peek(h)                                                   \
> -({                                                                     \
> -       EBUG_ON(!(h)->used);                                            \
> -       (h)->data[0];                                                   \
> -})
> -
> -#define heap_full(h)   ((h)->used =3D=3D (h)->size)
> -
> -#define heap_sift_down(h, i, cmp, set_backpointer)                     \
> -do {                                                                   \
> -       size_t _c, _j =3D i;                                             =
 \
> -                                                                       \
> -       for (; _j * 2 + 1 < (h)->used; _j =3D _c) {                      =
 \
> -               _c =3D _j * 2 + 1;                                       =
 \
> -               if (_c + 1 < (h)->used &&                               \
> -                   cmp(h, (h)->data[_c], (h)->data[_c + 1]) >=3D 0)     =
 \
> -                       _c++;                                           \
> -                                                                       \
> -               if (cmp(h, (h)->data[_c], (h)->data[_j]) >=3D 0)         =
 \
> -                       break;                                          \
> -               heap_swap(h, _c, _j, set_backpointer);                  \
> -       }                                                               \
> -} while (0)
> -
> -#define heap_sift_up(h, i, cmp, set_backpointer)                       \
> -do {                                                                   \
> -       while (i) {                                                     \
> -               size_t p =3D (i - 1) / 2;                                =
 \
> -               if (cmp(h, (h)->data[i], (h)->data[p]) >=3D 0)           =
 \
> -                       break;                                          \
> -               heap_swap(h, i, p, set_backpointer);                    \
> -               i =3D p;                                                 =
 \
> -       }                                                               \
> -} while (0)
> -
> -#define __heap_add(h, d, cmp, set_backpointer)                         \
> -({                                                                     \
> -       size_t _i =3D (h)->used++;                                       =
 \
> -       (h)->data[_i] =3D d;                                             =
 \
> -       heap_set_backpointer(h, _i, set_backpointer);                   \
> -                                                                       \
> -       heap_sift_up(h, _i, cmp, set_backpointer);                      \
> -       _i;                                                             \
> -})
> -
> -#define heap_add(h, d, cmp, set_backpointer)                           \
> -({                                                                     \
> -       bool _r =3D !heap_full(h);                                       =
 \
> -       if (_r)                                                         \
> -               __heap_add(h, d, cmp, set_backpointer);                 \
> -       _r;                                                             \
> +       void *data =3D kvmalloc(_size * sizeof(*min_heap_peek(heap)), (gf=
p));\
> +       min_heap_init(heap, data, _size);                               \
> +       min_heap_peek(heap);                                            \
>  })
>
> -#define heap_add_or_replace(h, new, cmp, set_backpointer)              \
> -do {                                                                   \
> -       if (!heap_add(h, new, cmp, set_backpointer) &&                  \
> -           cmp(h, new, heap_peek(h)) >=3D 0) {                          =
 \
> -               (h)->data[0] =3D new;                                    =
 \
> -               heap_set_backpointer(h, 0, set_backpointer);            \
> -               heap_sift_down(h, 0, cmp, set_backpointer);             \
> -       }                                                               \
> -} while (0)
>
> -#define heap_del(h, i, cmp, set_backpointer)                           \
> +#define free_heap(_heap)                                                =
       \
>  do {                                                                   \
> -       size_t _i =3D (i);                                               =
 \
> -                                                                       \
> -       BUG_ON(_i >=3D (h)->used);                                       =
 \
> -       (h)->used--;                                                    \
> -       if ((_i) < (h)->used) {                                         \
> -               heap_swap(h, _i, (h)->used, set_backpointer);           \
> -               heap_sift_up(h, _i, cmp, set_backpointer);              \
> -               heap_sift_down(h, _i, cmp, set_backpointer);            \
> -       }                                                               \
> +       kvfree((_heap)->heap.data);                                      =
       \
> +       (_heap)->heap.data =3D NULL;                                     =
         \
>  } while (0)
>
> -#define heap_pop(h, d, cmp, set_backpointer)                           \
> -({                                                                     \
> -       bool _r =3D (h)->used;                                           =
 \
> -       if (_r) {                                                       \
> -               (d) =3D (h)->data[0];                                    =
 \
> -               heap_del(h, 0, cmp, set_backpointer);                   \
> -       }                                                               \
> -       _r;                                                             \
> -})
> -
> -#define heap_resort(heap, cmp, set_backpointer)                         =
       \
> -do {                                                                   \
> -       ssize_t _i;                                                     \
> -       for (_i =3D (ssize_t) (heap)->used / 2 -  1; _i >=3D 0; --_i)    =
   \
> -               heap_sift_down(heap, _i, cmp, set_backpointer);         \
> -} while (0)
>
>  #define ANYSINT_MAX(t)                                                 \
>         ((((t) 1 << (sizeof(t) * 8 - 2)) - (t) 1) * (t) 2 + (t) 1)
> --
> 2.34.1
>

