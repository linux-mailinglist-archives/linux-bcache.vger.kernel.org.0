Return-Path: <linux-bcache+bounces-315-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E994D8805CD
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 21:03:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F70A283FCC
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 20:03:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CB6053801;
	Tue, 19 Mar 2024 20:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s5OrTROq"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6F057895
	for <linux-bcache@vger.kernel.org>; Tue, 19 Mar 2024 20:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710878612; cv=none; b=l4UM39kIXtwhsgfB1AjP0d4klJdp5mj4+rsZ4XYAxpsFDhmivDOtbRYQbovutSGAGefinlv2S731D3237C6zazizD10kXZZz/muXAaFcwaGA74Z4lvCzZ09yEvNjVI/HBFQWCSV1yPjbH2RUeO6ROi7LklmF9y0vusDu1c6lhyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710878612; c=relaxed/simple;
	bh=2TUnjcBXBHgRCr35/qx+4y7C7sGNXXnV5WnawsRFLjI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=syFP9ML3cbfS9avrbMzUSci6nlP2rFBAHVVunaHkbg2xsRuyhcU8stizMCENBsuDajqPiDC97zlUYqCIU6CRbZh/MGWofepmF90TshJ57Hj9oz5F5238j/jlsr5k/kVPxKZFxEiC+3OJ5FWTJTgh57tlGASk3Fz5gQKYGkFu3bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s5OrTROq; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1e058b9e479so26575ad.0
        for <linux-bcache@vger.kernel.org>; Tue, 19 Mar 2024 13:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710878609; x=1711483409; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kfr58buX1lcY8l+atgDFOG3sXHkwNDbtqSK3q62WZ/M=;
        b=s5OrTROqnTMBR4jpK8w73h7Nj6b58sVG4L1Sp0+zilGfTGxEJjzlac3ZgmTsokuPkT
         +JAFfO9+5nhFlamKTHrbS64sDp8UyQWqgHr1QQ/dOx1hYagVsmFU2t03801R6Rn070TH
         HvNsbQhUqqQxFg5IV/N2aGdC9C41HsMCEjPjmZljEwTIZUOpk24q8+qPz5Zp+PKoD2hd
         iNmP7EhiE7wRgPuEqfk5lgsgAO5wwVuuUng0PCtmDUZQWA0rfTRH1MkXrQxLxspC6lxJ
         fXeywnDmTSjrOU89SHMIljUKQr26Eyf/EzasgpS0tYuYvRRM3Ykbbq3LfSZ1BmOfB6Ju
         DSxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710878609; x=1711483409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kfr58buX1lcY8l+atgDFOG3sXHkwNDbtqSK3q62WZ/M=;
        b=UcihYx/a7YALG59doY+K15H05LSXs5I6caELzHzYc38ReRdXhKfcmYStS1N0I+8/jJ
         yjCn4LMAqIfyQhrziatJqVYtmKFeGAmrq1sRg5y2+4GgAbNAeTiS5krotQpqbXr14Xmr
         1KdzCSsBRoB4pf1BhkFENsqWuq/+PCD6Cm9YzYIx3Ly5I2NocBref8hfHKfs2JBF+tLZ
         kmNEaIZjhiTRuN31Iz9lsg3byVvo8/7Ei72plg9xoBMhJx91wZJHbEOXK1bdS1l7bHrM
         DEhaeKNI/J/+W8dpQ6cZI7NH3t/akXu0gn1ccDAIpIJTLO0x3T8KDPa07k8lA3GP4hlm
         H9Tg==
X-Forwarded-Encrypted: i=1; AJvYcCVlsmRMXTwzMuOz5Mi3gIJ4OKjURHXz/6WqhK9rSBPwFk+mdvXBX4pYyGrGWSEco6tBaCIZuLZrGBDQuHmFyuktjs3Dl3pL+0TA5O9a
X-Gm-Message-State: AOJu0YxIWNGAd+DWEks6VpO5VX/Im5i4AZ0eUP2Z4wsUKNBO9siHYs4v
	+RKUZxSqcjYyW1wy8Nk2EesDFdCqXIywx8FU2LQjJJ9Uh/Yhcz2HLJ5ohDqz5fl5tfoa/m4zYhY
	A2nNM7jGBBlUAmMI99lDXQ4ByH/uFMQV1C/Mv
X-Google-Smtp-Source: AGHT+IFnEgv5Z7UhdTj2prOaMISKCaZQChty823Sjc+SsNZqSSd/2VBnHkh40T7+batruDUdghjiGY7Ag2yMYF43jKg=
X-Received: by 2002:a17:902:db01:b0:1dd:9e68:d2f3 with SMTP id
 m1-20020a170902db0100b001dd9e68d2f3mr69151plx.10.1710878608551; Tue, 19 Mar
 2024 13:03:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240319180005.246930-1-visitorckw@gmail.com> <20240319180005.246930-14-visitorckw@gmail.com>
In-Reply-To: <20240319180005.246930-14-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Tue, 19 Mar 2024 13:03:17 -0700
Message-ID: <CAP-5=fWQvjdOV=TgdGrScGJ9Qe+eqRfh5jM8i3uiJeQSi9Yt3w@mail.gmail.com>
Subject: Re: [PATCH 13/13] bcachefs: Remove heap-related macros and switch to
 generic min_heap
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
> Drop the heap-related macros from bcachefs and replaces them with the
> generic min_heap implementation from include/linux. This change
> improves code readability by using functions instead of macros.
>
> Link: https://lkml.kernel.org/ioyfizrzq7w7mjrqcadtzsfgpuntowtjdw5pgn4qhvs=
dp4mqqg@nrlek5vmisbu
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> ---
>  fs/bcachefs/clock.c       |  53 +++++++++++-----
>  fs/bcachefs/clock_types.h |   2 +-
>  fs/bcachefs/ec.c          |  99 ++++++++++++++++++-----------
>  fs/bcachefs/ec_types.h    |   2 +-
>  fs/bcachefs/util.h        | 127 +++-----------------------------------
>  5 files changed, 109 insertions(+), 174 deletions(-)
>
> diff --git a/fs/bcachefs/clock.c b/fs/bcachefs/clock.c
> index 363644451106..7a7d13f7a629 100644
> --- a/fs/bcachefs/clock.c
> +++ b/fs/bcachefs/clock.c
> @@ -6,16 +6,29 @@
>  #include <linux/kthread.h>
>  #include <linux/preempt.h>
>
> -static inline long io_timer_cmp(io_timer_heap *h,
> -                               struct io_timer *l,
> -                               struct io_timer *r)
> +static inline bool io_timer_cmp(const void *l, const void *r, void *args=
)

Should args here and below be marked with the attribute __always_unused?

Thanks,
Ian

>  {
> -       return l->expire - r->expire;
> +       struct io_timer *_l =3D (struct io_timer *)l;
> +       struct io_timer *_r =3D (struct io_timer *)r;
> +
> +       return _l->expire >=3D _r->expire;
> +}
> +
> +static inline void io_timer_swp(void *l, void *r, void *args)
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
> index b98e2c2b8bf0..7b6a31237503 100644
> --- a/fs/bcachefs/ec.c
> +++ b/fs/bcachefs/ec.c
> @@ -860,14 +860,14 @@ static int __ec_stripe_mem_alloc(struct bch_fs *c, =
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
> +                       memcpy(min_heap_peek(&n), min_heap_peek(h), h->he=
ap.nr * sizeof(*min_heap_peek(h)));
> +                       n.heap.nr =3D h->heap.nr;
>                         swap(*h, n);
>                 }
>                 mutex_unlock(&c->ec_stripes_heap_lock);
> @@ -958,20 +958,21 @@ static u64 stripe_idx_to_delete(struct bch_fs *c)
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
d *args)
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
> @@ -979,7 +980,21 @@ static inline void ec_stripes_heap_set_backpointer(e=
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
> @@ -987,34 +1002,43 @@ static void heap_verify_backpointer(struct bch_fs =
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
> @@ -1026,17 +1050,20 @@ void bch2_stripes_heap_update(struct bch_fs *c,
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
> +       min_heapify(h, i, &callbacks, &c->ec_stripes_heap);
>
>         heap_verify_backpointer(c, idx);
>
> @@ -1828,12 +1855,12 @@ static s64 get_existing_stripe(struct bch_fs *c,
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
> @@ -2159,14 +2186,14 @@ void bch2_stripes_heap_to_text(struct printbuf *o=
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
> index 7ffbddb80400..c599dc5276ac 100644
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

