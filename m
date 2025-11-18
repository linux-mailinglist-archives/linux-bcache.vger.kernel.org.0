Return-Path: <linux-bcache+bounces-1258-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id BA02EC6BB58
	for <lists+linux-bcache@lfdr.de>; Tue, 18 Nov 2025 22:21:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 366A5367959
	for <lists+linux-bcache@lfdr.de>; Tue, 18 Nov 2025 21:19:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4948830AAC2;
	Tue, 18 Nov 2025 21:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XMwjFUkH"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB533002C6
	for <linux-bcache@vger.kernel.org>; Tue, 18 Nov 2025 21:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763500761; cv=none; b=FuuzaYohT5foJ7Pk5/o5weOjMCb9D8IeT59XdZB3ZVXKgFuySpQs1sBzMax6M4P+n2gNGb26NqQjghe5IVQNrPorWi3jx5jAsI/KfXy2Avl7NKK/qg+8BFFUlejevjOWAb6k6m9qE7boZ/sKIH6L9aS12eR4zRBHMGLJYOrkgQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763500761; c=relaxed/simple;
	bh=S1p+1uh5Qnw9KbCY/tPNm3juBs65q4x/3qBm2RyJUJ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TcE/wP01nM5CvedGhyELXRaTxQGV2yD27ntMqQbOvYOSkl/nr8JUZYXvsi+BM6FEkaXgrrI0QgJ7ISi0BE0TTb4a/jMPlAWYG+x+O2mftiTsk836JmdyZiZamz/rz5ac5sPntTEixKxAD3QETu+ctG8sW4IWEWYPTu3yBqObsv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XMwjFUkH; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ee147baf7bso24431cf.1
        for <linux-bcache@vger.kernel.org>; Tue, 18 Nov 2025 13:19:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763500758; x=1764105558; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wTNIaT6hawss8NcHro1kkVVLu9sPdxYwoB3MDDsm3x8=;
        b=XMwjFUkH12F5Ab5tflFYKx4sAVqPXJg8lm2FwsWyXrZy5UdUd32zkh38Y5bN/psYFG
         6Kctp3hAuiPlXNSQpcintV/UL0cnTYq6D682U4AjpFGiL7LV2WzcA0I6yMP2cT+eFJDW
         uPreX4OTEeE3wA/6o1SMlVRWb8rwKq2GQJaprMxF5dDUVdOc8YP+r1SA19RBjDIM880R
         YGj3e9OLvWZ+rSwOISavkY9371rBzjq1bZiQZgWWRkm2aCC9szYEm2vE0qh9DtJPxLgV
         cdU/TMcilxQcvRKXwA+cEeAUCvil5T+RQ8ZnSYeLbYNRqRakNGIwoddH0Vcx3Dxb+xQI
         SPIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763500758; x=1764105558;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wTNIaT6hawss8NcHro1kkVVLu9sPdxYwoB3MDDsm3x8=;
        b=DES06EuBavPwhtxwu0xua4Xr+mTQtKsOrGYxa9jmXZkNFvaeyk4WPDlzwrQgFVyG8t
         q1BC3Wob9c0VXf5BSio8/As+hpaLDOFMwIkV6Co23v0Bnjf7XhTBdwuofQP/mOZUo+tl
         3DMKpe8U5BE1fwEr7jIkzvyLjT31TsQyWc1eQqWQGBJZEOYHU+qLRSYwOW/pCs9ewN09
         FShd9+iY5aSX0O3LyuMFtDBVXeGUSXfZPfZx9ntBylmY7y4r5/3ejcfFCJlCm1OnjVQ7
         RDLdSz/K8z7mFAW4ez2Ks/VvNPUm3N/9bHkv0yQ0r8/KYqTmNBFL5Jn8qxBON1npP1+H
         87cA==
X-Gm-Message-State: AOJu0YzM151p+goTxc1OaA5RM1gCjchqDfRZVDGEiQUzAvDIujskh6H0
	JQ2v9X0WrSGx5yW8HMoEAELrVzEXH8+g6UxAYVqaBSkz2fhw2PU4oU24T+Tb5N2vIUfw4+SSz7V
	pjslsRGtpg9JuFQdwa92MU1Wto7J0QxZHGhbUG78j
X-Gm-Gg: ASbGncvWXbfX4WyXtaLTbuWN+RsKO3Ah7OpU250zQwEHiyERmMB3GriZB/CGsNiYvEL
	l2qMNY1KE50ORq/9TX09LTTp+NxcClJwNRWa2t0+Z83xUQfWNxjzj4RsqkrYN6xI0kMZkuvo44O
	h14vH3iyRb/JRqsQcdEUEEdsrieWVlgHbDYnGBvp2aWwGzYt5XYsVD7OjBp0oUttPNlvExFKh2/
	n19SVjUAENtZKI1twWxPMWrdthKwCEDt++zwOH3RafzpGnHx9+9pP3B/FG6oa1rw1QeKFink/qk
	K74P3MUDa3JdwEoAF1rAtVc6Sr5gKZLfEFFf
X-Google-Smtp-Source: AGHT+IEkb+JubdQGkitY8RsKDLpR38aflwPlNZYLjkbAhIxH6DqVCtUKVbYZcMEukG/Q9vlGidm9yfryPH1Fb6bmGrI=
X-Received: by 2002:a05:622a:4d2:b0:4ed:7c45:9908 with SMTP id
 d75a77b69052e-4ee3eb9b15cmr1434181cf.10.1763500757956; Tue, 18 Nov 2025
 13:19:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251009071512.3952240-2-robertpang@google.com> <CAJhEC05VTcS-=jsDUoyybQ5Cc33DbPXqJ=5FxfVxo06xfugwAQ@mail.gmail.com>
In-Reply-To: <CAJhEC05VTcS-=jsDUoyybQ5Cc33DbPXqJ=5FxfVxo06xfugwAQ@mail.gmail.com>
From: Robert Pang <robertpang@google.com>
Date: Tue, 18 Nov 2025 13:19:06 -0800
X-Gm-Features: AWmQ_bkBU8vQ0_W2Gx9ur2SfzRyOFFhAKDlN1lMiaVbNbsPuZaB9aYKg_q9JbTA
Message-ID: <CAJhEC06kaOgD3=0r+K7yh9+x4mXEfCzBXiDkD9yn2qqCEs1SJA@mail.gmail.com>
Subject: Re: [PATCH v2] bcache: add "clock" cache replacement policy
To: Coly Li <colyli@fnnas.com>, Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Coly and Kent,

I'm writing to follow up on the patch proposal regarding this new
cache replacement policy.

Do you have any feedback on the proposed policy or the implementation?

Best regards
Robert


On Thu, Oct 9, 2025 at 3:06=E2=80=AFPM Robert Pang <robertpang@google.com> =
wrote:
>
> Apology for missing the change log earlier:
> v2: Add "clock" cache replacement policy to admin-guide/bcache.rst and
> performance results.
> v1: initial version.
>
> On Thu, Oct 9, 2025 at 12:17=E2=80=AFAM Robert Pang <robertpang@google.co=
m> wrote:
> >
> > This new policy extends the FIFO policy to approximate the classic cloc=
k policy
> > (O(n) time complexity) by considering bucket priority, similar to the L=
RU
> > policy.
> >
> > This clock policy addresses the high IO latency (1-2 seconds) experienc=
ed on
> > multi-terabyte cache devices when the free list is empty due to the def=
ault LRU
> > policy. The LRU policy's O(n log n) complexity for sorting priorities f=
or the
> > entire bucket list causes this delay.
> >
> > Here are the average execution times (in microseconds) of the LRU and t=
he clock
> > replacement policies:
> >
> > SSD Size  Bucket Count  LRU (us)  Clock (us)
> > 375 GB      1536000       58292        1163
> > 750 GB      3072000      121769        1729
> > 1.5 TB      6144000      244012        3862
> > 3 TB       12288000      496569        6428
> > 6 TB       24576000     1067628       14298
> > 9 TB       36864000     1564348       25763
> >
> > Signed-off-by: Robert Pang <robertpang@google.com>
> > ---
> >  Documentation/admin-guide/bcache.rst |  2 +-
> >  drivers/md/bcache/alloc.c            | 34 ++++++++++++++++++++++++----
> >  drivers/md/bcache/bcache_ondisk.h    |  1 +
> >  drivers/md/bcache/sysfs.c            |  1 +
> >  4 files changed, 33 insertions(+), 5 deletions(-)
> >
> > diff --git a/Documentation/admin-guide/bcache.rst b/Documentation/admin=
-guide/bcache.rst
> > index 6fdb495ac466..2be2999c7de4 100644
> > --- a/Documentation/admin-guide/bcache.rst
> > +++ b/Documentation/admin-guide/bcache.rst
> > @@ -616,7 +616,7 @@ bucket_size
> >    Size of buckets
> >
> >  cache_replacement_policy
> > -  One of either lru, fifo or random.
> > +  One of either lru, fifo, random or clock.
> >
> >  discard
> >    Boolean; if on a discard/TRIM will be issued to each bucket before i=
t is
> > diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
> > index 48ce750bf70a..c65c48eab169 100644
> > --- a/drivers/md/bcache/alloc.c
> > +++ b/drivers/md/bcache/alloc.c
> > @@ -69,7 +69,8 @@
> >  #include <linux/random.h>
> >  #include <trace/events/bcache.h>
> >
> > -#define MAX_OPEN_BUCKETS 128
> > +#define MAX_OPEN_BUCKETS       128
> > +#define CHECK_PRIO_SLICES      16
> >
> >  /* Bucket heap / gen */
> >
> > @@ -211,19 +212,41 @@ static void invalidate_buckets_lru(struct cache *=
ca)
> >         }
> >  }
> >
> > -static void invalidate_buckets_fifo(struct cache *ca)
> > +/*
> > + * When check_prio is true, this FIFO policy examines the priority of =
the
> > + * buckets and invalidates only the ones below a threshold in the prio=
rity
> > + * ladder. As it goes, the threshold will be raised if not enough buck=
ets are
> > + * invalidated. Empty buckets are also invalidated. This evaulation re=
sembles
> > + * the LRU policy, and is used to approximate the classic clock-sweep =
cache
> > + * replacement algorithm.
> > + */
> > +static void invalidate_buckets_fifo(struct cache *ca, bool check_prio)
> >  {
> >         struct bucket *b;
> >         size_t checked =3D 0;
> > +       size_t check_quota =3D 0;
> > +       uint16_t prio_threshold =3D ca->set->min_prio;
> >
> >         while (!fifo_full(&ca->free_inc)) {
> >                 if (ca->fifo_last_bucket <  ca->sb.first_bucket ||
> >                     ca->fifo_last_bucket >=3D ca->sb.nbuckets)
> >                         ca->fifo_last_bucket =3D ca->sb.first_bucket;
> >
> > +               if (check_prio && checked >=3D check_quota) {
> > +                       BUG_ON(ca->set->min_prio > INITIAL_PRIO);
> > +                       prio_threshold +=3D
> > +                               DIV_ROUND_UP(INITIAL_PRIO - ca->set->mi=
n_prio,
> > +                                            CHECK_PRIO_SLICES);
> > +                       check_quota +=3D DIV_ROUND_UP(ca->sb.nbuckets,
> > +                                                   CHECK_PRIO_SLICES);
> > +               }
> > +
> >                 b =3D ca->buckets + ca->fifo_last_bucket++;
> >
> > -               if (bch_can_invalidate_bucket(ca, b))
> > +               if (bch_can_invalidate_bucket(ca, b) &&
> > +                   (!check_prio ||
> > +                    b->prio <=3D prio_threshold ||
> > +                    !GC_SECTORS_USED(b)))
> >                         bch_invalidate_one_bucket(ca, b);
> >
> >                 if (++checked >=3D ca->sb.nbuckets) {
> > @@ -269,11 +292,14 @@ static void invalidate_buckets(struct cache *ca)
> >                 invalidate_buckets_lru(ca);
> >                 break;
> >         case CACHE_REPLACEMENT_FIFO:
> > -               invalidate_buckets_fifo(ca);
> > +               invalidate_buckets_fifo(ca, false);
> >                 break;
> >         case CACHE_REPLACEMENT_RANDOM:
> >                 invalidate_buckets_random(ca);
> >                 break;
> > +       case CACHE_REPLACEMENT_CLOCK:
> > +               invalidate_buckets_fifo(ca, true);
> > +               break;
> >         }
> >  }
> >
> > diff --git a/drivers/md/bcache/bcache_ondisk.h b/drivers/md/bcache/bcac=
he_ondisk.h
> > index 6620a7f8fffc..d45794e01fe1 100644
> > --- a/drivers/md/bcache/bcache_ondisk.h
> > +++ b/drivers/md/bcache/bcache_ondisk.h
> > @@ -288,6 +288,7 @@ BITMASK(CACHE_REPLACEMENT,          struct cache_sb=
, flags, 2, 3);
> >  #define CACHE_REPLACEMENT_LRU          0U
> >  #define CACHE_REPLACEMENT_FIFO         1U
> >  #define CACHE_REPLACEMENT_RANDOM       2U
> > +#define CACHE_REPLACEMENT_CLOCK                3U
> >
> >  BITMASK(BDEV_CACHE_MODE,               struct cache_sb, flags, 0, 4);
> >  #define CACHE_MODE_WRITETHROUGH                0U
> > diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> > index 826b14cae4e5..c8617bad0648 100644
> > --- a/drivers/md/bcache/sysfs.c
> > +++ b/drivers/md/bcache/sysfs.c
> > @@ -45,6 +45,7 @@ static const char * const cache_replacement_policies[=
] =3D {
> >         "lru",
> >         "fifo",
> >         "random",
> > +       "clock",
> >         NULL
> >  };
> >
> > --
> > 2.51.0.710.ga91ca5db03-goog
> >

