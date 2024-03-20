Return-Path: <linux-bcache+bounces-349-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1C72881668
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 18:20:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E57EF1C231FA
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 17:20:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3B866A339;
	Wed, 20 Mar 2024 17:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VITnYw2M"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58BF6A031
	for <linux-bcache@vger.kernel.org>; Wed, 20 Mar 2024 17:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710955205; cv=none; b=Qly7RO7P5R/cnJWbSxyw5z/g+B63GL20JIzbt1QqVUgfLNL0G5vlsbPq9mOaAfWsLjDWgn7KDKGYEB8kYIaGCgCKuBV30bQ+qgcnI9MowjucxBaFU9fOfgmvGSdoV/4sgyGV96mKk7CiRD5gkbh+8zVAwqdxrN2F/kdGEdJZKX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710955205; c=relaxed/simple;
	bh=Ib8lyWXMnD9vT9nJYt8omhosblHYTldPRJpYZ/W+3OU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OxMTwndjgAA5HNu26KDXkC+900PZ9Uy8StEbCdc90+HI3dSu7/TQplcxmzklDqYFwABaITLjPvKdZkZ5P6Z6cX9bSYH2OwRUMH/yYdcEw+kh0sc2UMzenafCaS3NIEH5lab/zREKN+N0hz51IHdppTG9tVN46qe8Sn5zT1I46rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VITnYw2M; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-42ee0c326e8so15731cf.0
        for <linux-bcache@vger.kernel.org>; Wed, 20 Mar 2024 10:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710955201; x=1711560001; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fPwmwIZ8YTEFp0yxz7m7ihi0PX68Wb/m/XoO76VbHNs=;
        b=VITnYw2MBaMNswsmcL7QFKk3nZ2GiIE46+QjpIA9eedylKouofMSEMLMreGPVsxWpz
         7FO1ONgC60w5UKBHAsqwxlpVK3lnhxZHQlzyero8oJkPbxC+0/H9bfw9bXDk0aZa3Ovc
         3pFugPJ9fpZoLOzHpHNl2ENOT/P3xQZzTJBrrB+0AFR7yq7ryLmUshwYtYg63aBfraiz
         KBNBn3O/uk7B1oVZAvwDDSShw8SzSOt4hJMwrI4JP1RxoqImncKyAXWaiAQHmpOtBJuC
         SuoRiLQAXI0GO7vIJRUmIANFAhHduUCSr117AiLmd0k9o1MNVfZuBpU5q19Zzj8vwtGT
         X5sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710955201; x=1711560001;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fPwmwIZ8YTEFp0yxz7m7ihi0PX68Wb/m/XoO76VbHNs=;
        b=Tnm2tW37Nli6MG66xpoJdfkDfoBBXuVOZCzkiidXhdGIjIQKNJaCQa9Q72s1xpuLvY
         6XYA10HtxUA7kNLOtsLt3vxSEK6A0VR20+nsb+EIl1jOx724VyVJPag/F/i/MDDme1BI
         NeDng3ep8ueUhSybTYwKPTk6R1cIh6hq7nu2Nc1yh/Bw1FODxVzg1eBI6uqnawqDuGvD
         kvjgI5xMgc/jZ1tXngj5r9S0T3+HmcPGbYUeGW2FymFdZ5SkpASvEUJiA50P8/SNJk91
         cMsKNAZwuKqDj3pC3MIa224LT36NA/7sYL5qoMmtcJA83VpuZZs4dkP3VIAgYjQAcB2d
         muHA==
X-Forwarded-Encrypted: i=1; AJvYcCUQyTsg3q/rWVxob/YsW7H9OzJZvV+vAYbY4kj+R3MUDVsNwoPLjs/I05mMlfNMUCQzyp1UPRNkyyTUo2OHTiQz1ir147XvbeAwT8Ie
X-Gm-Message-State: AOJu0YwpE1e//mZzy7WXPbV3OwmnTNFABEjdizqtUhBWjEduKwSvpDrt
	kSquVB7cxVRSeU2nTmDuUlKgZhuqqOEnKLK0FdBXIXaAwlFkOyGo+K1pIGRJjA6cJrFHymsoG5B
	RYrSs48mWOy0SOHpscVpjCEItzulVCxQp2IwP
X-Google-Smtp-Source: AGHT+IEgtVXDy3ghBd31VPkb7V1nNUVlyl6ZmY8G8ccvLIch20Yjpf3JtAzqw+pWdkNOGSUp2aOKZDKGY4c/j9Wk5h8=
X-Received: by 2002:a05:622a:d:b0:431:1da3:dd52 with SMTP id
 x13-20020a05622a000d00b004311da3dd52mr23677qtw.18.1710955200546; Wed, 20 Mar
 2024 10:20:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240320145417.336208-1-visitorckw@gmail.com> <20240320145417.336208-15-visitorckw@gmail.com>
In-Reply-To: <20240320145417.336208-15-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Wed, 20 Mar 2024 10:19:49 -0700
Message-ID: <CAP-5=fWowSogo4Y_V4p3T4roUTq+RvEdQ-NCsifq99EXjy2rWQ@mail.gmail.com>
Subject: Re: [PATCH v2 14/15] bcache: Remove heap-related macros and switch to
 generic min_heap
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
> Drop the heap-related macros from bcache and replacing them with the
> generic min_heap implementation from include/linux. By doing so, code
> readability is improved by using functions instead of macros. Moreover,
> the min_heap implementation in include/linux adopts a bottom-up
> variation compared to the textbook version currently used in bcache.
> This bottom-up variation allows for approximately 50% reduction in the
> number of comparison operations during heap siftdown, without changing
> the number of swaps, thus making it more efficient.
>
> Link: https://lkml.kernel.org/ioyfizrzq7w7mjrqcadtzsfgpuntowtjdw5pgn4qhvs=
dp4mqqg@nrlek5vmisbu
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

I think this is a useful clean up but I'm unfamiliar with bcache and
its concerns.

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
>  drivers/md/bcache/alloc.c    | 66 +++++++++++++++++++++--------
>  drivers/md/bcache/bcache.h   |  2 +-
>  drivers/md/bcache/bset.c     | 73 ++++++++++++++++++++++----------
>  drivers/md/bcache/bset.h     | 38 ++++++++++-------
>  drivers/md/bcache/btree.c    | 27 +++++++++++-
>  drivers/md/bcache/extents.c  | 44 ++++++++++++--------
>  drivers/md/bcache/movinggc.c | 40 +++++++++++++-----
>  drivers/md/bcache/super.c    | 16 +++++++
>  drivers/md/bcache/sysfs.c    |  3 ++
>  drivers/md/bcache/util.h     | 81 +-----------------------------------
>  10 files changed, 224 insertions(+), 166 deletions(-)
>
> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
> index ce13c272c387..b27c0e25b661 100644
> --- a/drivers/md/bcache/alloc.c
> +++ b/drivers/md/bcache/alloc.c
> @@ -166,40 +166,70 @@ static void bch_invalidate_one_bucket(struct cache =
*ca, struct bucket *b)
>   * prio is worth 1/8th of what INITIAL_PRIO is worth.
>   */
>
> -#define bucket_prio(b)                                                 \
> -({                                                                     \
> -       unsigned int min_prio =3D (INITIAL_PRIO - ca->set->min_prio) / 8;=
 \
> -                                                                       \
> -       (b->prio - ca->set->min_prio + min_prio) * GC_SECTORS_USED(b);  \
> -})
> +static inline unsigned int bucket_prio(struct cache *ca, struct bucket *=
b)
> +{
> +       unsigned int min_prio =3D (INITIAL_PRIO - ca->set->min_prio) / 8;
> +
> +       return (b->prio - ca->set->min_prio + min_prio) * GC_SECTORS_USED=
(b);
> +
> +}
> +
> +static inline bool bucket_max_cmp(const void *l, const void *r, void *ar=
gs)
> +{
> +       struct bucket *lhs =3D (struct bucket *)l;
> +       struct bucket *rhs =3D (struct bucket *)r;
> +       struct cache *ca =3D args;
> +
> +       return bucket_prio(ca, lhs) > bucket_prio(ca, rhs);
> +}
> +
> +static inline bool bucket_min_cmp(const void *l, const void *r, void *ar=
gs)
> +{
> +       struct bucket *lhs =3D (struct bucket *)l;
> +       struct bucket *rhs =3D (struct bucket *)r;
> +       struct cache *ca =3D args;
> +
> +       return bucket_prio(ca, lhs) < bucket_prio(ca, rhs);
> +}
> +
> +static inline void bucket_swap(void *l, void *r, void __always_unused *a=
rgs)
> +{
> +       struct bucket *lhs =3D l, *rhs =3D r;
>
> -#define bucket_max_cmp(l, r)   (bucket_prio(l) < bucket_prio(r))
> -#define bucket_min_cmp(l, r)   (bucket_prio(l) > bucket_prio(r))
> +       swap(*lhs, *rhs);
> +}
>
>  static void invalidate_buckets_lru(struct cache *ca)
>  {
>         struct bucket *b;
> -       ssize_t i;
> +       const struct min_heap_callbacks bucket_max_cmp_callback =3D {
> +               .less =3D bucket_max_cmp,
> +               .swp =3D bucket_swap,
> +       };
> +       const struct min_heap_callbacks bucket_min_cmp_callback =3D {
> +               .less =3D bucket_min_cmp,
> +               .swp =3D bucket_swap,
> +       };
>
> -       ca->heap.used =3D 0;
> +       ca->heap.heap.nr =3D 0;
>
>         for_each_bucket(b, ca) {
>                 if (!bch_can_invalidate_bucket(ca, b))
>                         continue;
>
> -               if (!heap_full(&ca->heap))
> -                       heap_add(&ca->heap, b, bucket_max_cmp);
> -               else if (bucket_max_cmp(b, heap_peek(&ca->heap))) {
> -                       ca->heap.data[0] =3D b;
> -                       heap_sift(&ca->heap, 0, bucket_max_cmp);
> +               if (!min_heap_full(&ca->heap))
> +                       min_heap_push(&ca->heap, b, &bucket_max_cmp_callb=
ack, ca);
> +               else if (!bucket_max_cmp(b, min_heap_peek(&ca->heap), ca)=
) {
> +                       *min_heap_peek(&ca->heap) =3D b;
> +                       min_heap_sift_down(&ca->heap, 0, &bucket_max_cmp_=
callback, ca);
>                 }
>         }
>
> -       for (i =3D ca->heap.used / 2 - 1; i >=3D 0; --i)
> -               heap_sift(&ca->heap, i, bucket_min_cmp);
> +       min_heapify_all(&ca->heap, &bucket_min_cmp_callback, ca);
>
>         while (!fifo_full(&ca->free_inc)) {
> -               if (!heap_pop(&ca->heap, b, bucket_min_cmp)) {
> +               b =3D *min_heap_peek(&ca->heap);
> +               if (!min_heap_pop(&ca->heap, &bucket_min_cmp_callback, ca=
)) {
>                         /*
>                          * We don't want to be calling invalidate_buckets=
()
>                          * multiple times when it can't do anything
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 4e6afa89921f..97b0a1768ba7 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -457,7 +457,7 @@ struct cache {
>         /* Allocation stuff: */
>         struct bucket           *buckets;
>
> -       DECLARE_HEAP(struct bucket *, heap);
> +       MIN_HEAP(struct bucket *, heap) heap;
>
>         /*
>          * If nonzero, we know we aren't going to find any buckets to inv=
alidate
> diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
> index 2bba4d6aaaa2..6b1c8ac0f866 100644
> --- a/drivers/md/bcache/bset.c
> +++ b/drivers/md/bcache/bset.c
> @@ -56,7 +56,9 @@ int __bch_count_data(struct btree_keys *b)
>         unsigned int ret =3D 0;
>         struct btree_iter iter;
>         struct bkey *k;
> +       struct btree_iter_set data[MAX_BSETS];
>
> +       iter.heap.heap.data =3D data;
>         if (b->ops->is_extents)
>                 for_each_key(b, k, &iter)
>                         ret +=3D KEY_SIZE(k);
> @@ -69,6 +71,9 @@ void __bch_check_keys(struct btree_keys *b, const char =
*fmt, ...)
>         struct bkey *k, *p =3D NULL;
>         struct btree_iter iter;
>         const char *err;
> +       struct btree_iter_set data[MAX_BSETS];
> +
> +       iter.heap.heap.data =3D data;
>
>         for_each_key(b, k, &iter) {
>                 if (b->ops->is_extents) {
> @@ -110,9 +115,9 @@ void __bch_check_keys(struct btree_keys *b, const cha=
r *fmt, ...)
>
>  static void bch_btree_iter_next_check(struct btree_iter *iter)
>  {
> -       struct bkey *k =3D iter->data->k, *next =3D bkey_next(k);
> +       struct bkey *k =3D min_heap_peek(&iter->heap)->k, *next =3D bkey_=
next(k);
>
> -       if (next < iter->data->end &&
> +       if (next < min_heap_peek(&iter->heap)->end &&
>             bkey_cmp(k, iter->b->ops->is_extents ?
>                      &START_KEY(next) : next) > 0) {
>                 bch_dump_bucket(iter->b);
> @@ -882,6 +887,9 @@ unsigned int bch_btree_insert_key(struct btree_keys *=
b, struct bkey *k,
>         struct btree_iter iter;
>         struct bkey preceding_key_on_stack =3D ZERO_KEY;
>         struct bkey *preceding_key_p =3D &preceding_key_on_stack;
> +       struct btree_iter_set data[MAX_BSETS];
> +
> +       iter.heap.heap.data =3D data;
>
>         BUG_ON(b->ops->is_extents && !KEY_SIZE(k));
>
> @@ -1077,27 +1085,34 @@ struct bkey *__bch_bset_search(struct btree_keys =
*b, struct bset_tree *t,
>
>  /* Btree iterator */
>
> -typedef bool (btree_iter_cmp_fn)(struct btree_iter_set,
> -                                struct btree_iter_set);
> +typedef bool (btree_iter_cmp_fn)(const void *, const void *, void *);
>
> -static inline bool btree_iter_cmp(struct btree_iter_set l,
> -                                 struct btree_iter_set r)
> +static inline bool btree_iter_cmp(const void *l, const void *r, void __a=
lways_unused *args)
>  {
> -       return bkey_cmp(l.k, r.k) > 0;
> +       const struct btree_iter_set *_l =3D l;
> +       const struct btree_iter_set *_r =3D r;
> +
> +       return bkey_cmp(_l->k, _r->k) <=3D 0;
>  }
>
>  static inline bool btree_iter_end(struct btree_iter *iter)
>  {
> -       return !iter->used;
> +       return !iter->heap.heap.nr;
>  }
>
>  void bch_btree_iter_push(struct btree_iter *iter, struct bkey *k,
>                          struct bkey *end)
>  {
> +       const struct min_heap_callbacks callbacks =3D {
> +               .less =3D btree_iter_cmp,
> +               .swp =3D btree_iter_swap,
> +       };
> +
>         if (k !=3D end)
> -               BUG_ON(!heap_add(iter,
> -                                ((struct btree_iter_set) { k, end }),
> -                                btree_iter_cmp));
> +               BUG_ON(!min_heap_push(&iter->heap,
> +                                &((struct btree_iter_set){ k, end }),
> +                                &callbacks,
> +                                NULL));
>  }
>
>  static struct bkey *__bch_btree_iter_init(struct btree_keys *b,
> @@ -1107,8 +1122,8 @@ static struct bkey *__bch_btree_iter_init(struct bt=
ree_keys *b,
>  {
>         struct bkey *ret =3D NULL;
>
> -       iter->size =3D ARRAY_SIZE(iter->data);
> -       iter->used =3D 0;
> +       iter->heap.heap.size =3D MAX_BSETS;
> +       iter->heap.heap.nr =3D 0;
>
>  #ifdef CONFIG_BCACHE_DEBUG
>         iter->b =3D b;
> @@ -1134,22 +1149,28 @@ static inline struct bkey *__bch_btree_iter_next(=
struct btree_iter *iter,
>  {
>         struct btree_iter_set b __maybe_unused;
>         struct bkey *ret =3D NULL;
> +       const struct min_heap_callbacks callbacks =3D {
> +               .less =3D cmp,
> +               .swp =3D btree_iter_swap,
> +       };
>
>         if (!btree_iter_end(iter)) {
>                 bch_btree_iter_next_check(iter);
>
> -               ret =3D iter->data->k;
> -               iter->data->k =3D bkey_next(iter->data->k);
> +               ret =3D min_heap_peek(&iter->heap)->k;
> +               min_heap_peek(&iter->heap)->k =3D bkey_next(min_heap_peek=
(&iter->heap)->k);
>
> -               if (iter->data->k > iter->data->end) {
> +               if (min_heap_peek(&iter->heap)->k > min_heap_peek(&iter->=
heap)->end) {
>                         WARN_ONCE(1, "bset was corrupt!\n");
> -                       iter->data->k =3D iter->data->end;
> +                       min_heap_peek(&iter->heap)->k =3D min_heap_peek(&=
iter->heap)->end;
>                 }
>
> -               if (iter->data->k =3D=3D iter->data->end)
> -                       heap_pop(iter, b, cmp);
> +               if (min_heap_peek(&iter->heap)->k =3D=3D min_heap_peek(&i=
ter->heap)->end) {
> +                       b =3D *min_heap_peek(&iter->heap);
> +                       min_heap_pop(&iter->heap, &callbacks, NULL);
> +               }
>                 else
> -                       heap_sift(iter, 0, cmp);
> +                       min_heap_sift_down(&iter->heap, 0, &callbacks, NU=
LL);
>         }
>
>         return ret;
> @@ -1195,16 +1216,18 @@ static void btree_mergesort(struct btree_keys *b,=
 struct bset *out,
>                             struct btree_iter *iter,
>                             bool fixup, bool remove_stale)
>  {
> -       int i;
>         struct bkey *k, *last =3D NULL;
>         BKEY_PADDED(k) tmp;
>         bool (*bad)(struct btree_keys *, const struct bkey *) =3D remove_=
stale
>                 ? bch_ptr_bad
>                 : bch_ptr_invalid;
> +       const struct min_heap_callbacks callbacks =3D {
> +               .less =3D b->ops->sort_cmp,
> +               .swp =3D btree_iter_swap,
> +       };
>
>         /* Heapify the iterator, using our comparison function */
> -       for (i =3D iter->used / 2 - 1; i >=3D 0; --i)
> -               heap_sift(iter, i, b->ops->sort_cmp);
> +       min_heapify_all(&iter->heap, &callbacks, NULL);
>
>         while (!btree_iter_end(iter)) {
>                 if (b->ops->sort_fixup && fixup)
> @@ -1295,7 +1318,9 @@ void bch_btree_sort_partial(struct btree_keys *b, u=
nsigned int start,
>         size_t order =3D b->page_order, keys =3D 0;
>         struct btree_iter iter;
>         int oldsize =3D bch_count_data(b);
> +       struct btree_iter_set data[MAX_BSETS];
>
> +       iter.heap.heap.data =3D data;
>         __bch_btree_iter_init(b, &iter, NULL, &b->set[start]);
>
>         if (start) {
> @@ -1324,7 +1349,9 @@ void bch_btree_sort_into(struct btree_keys *b, stru=
ct btree_keys *new,
>  {
>         uint64_t start_time =3D local_clock();
>         struct btree_iter iter;
> +       struct btree_iter_set data[MAX_BSETS];
>
> +       iter.heap.heap.data =3D data;
>         bch_btree_iter_init(b, &iter, NULL);
>
>         btree_mergesort(b, new->set->data, &iter, false, true);
> diff --git a/drivers/md/bcache/bset.h b/drivers/md/bcache/bset.h
> index d795c84246b0..e9559486a4c5 100644
> --- a/drivers/md/bcache/bset.h
> +++ b/drivers/md/bcache/bset.h
> @@ -152,6 +152,19 @@ struct btree_iter;
>  struct btree_iter_set;
>  struct bkey_float;
>
> +/* Btree key iteration */
> +
> +struct btree_iter_set {
> +       struct bkey *k, *end;
> +};
> +
> +struct btree_iter {
> +#ifdef CONFIG_BCACHE_DEBUG
> +       struct btree_keys *b;
> +#endif
> +       MIN_HEAP(struct btree_iter_set, btree_iter_heap) heap;
> +};
> +
>  #define MAX_BSETS              4U
>
>  struct bset_tree {
> @@ -187,8 +200,9 @@ struct bset_tree {
>  };
>
>  struct btree_keys_ops {
> -       bool            (*sort_cmp)(struct btree_iter_set l,
> -                                   struct btree_iter_set r);
> +       bool            (*sort_cmp)(const void *l,
> +                                   const void *r,
> +                                       void *args);
>         struct bkey     *(*sort_fixup)(struct btree_iter *iter,
>                                        struct bkey *tmp);
>         bool            (*insert_fixup)(struct btree_keys *b,
> @@ -258,6 +272,14 @@ static inline unsigned int bset_sector_offset(struct=
 btree_keys *b,
>         return bset_byte_offset(b, i) >> 9;
>  }
>
> +static inline void btree_iter_swap(void *iter1, void *iter2, void __alwa=
ys_unused *args)
> +{
> +       struct btree_iter_set *_iter1 =3D iter1;
> +       struct btree_iter_set *_iter2 =3D iter2;
> +
> +       swap(*_iter1, *_iter2);
> +}
> +
>  #define __set_bytes(i, k)      (sizeof(*(i)) + (k) * sizeof(uint64_t))
>  #define set_bytes(i)           __set_bytes(i, i->keys)
>
> @@ -312,18 +334,6 @@ enum {
>         BTREE_INSERT_STATUS_FRONT_MERGE,
>  };
>
> -/* Btree key iteration */
> -
> -struct btree_iter {
> -       size_t size, used;
> -#ifdef CONFIG_BCACHE_DEBUG
> -       struct btree_keys *b;
> -#endif
> -       struct btree_iter_set {
> -               struct bkey *k, *end;
> -       } data[MAX_BSETS];
> -};
> -
>  typedef bool (*ptr_filter_fn)(struct btree_keys *b, const struct bkey *k=
);
>
>  struct bkey *bch_btree_iter_next(struct btree_iter *iter);
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 196cdacce38f..e7333a8c4819 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -157,8 +157,8 @@ void bch_btree_node_read_done(struct btree *b)
>          * See the comment arount cache_set->fill_iter.
>          */
>         iter =3D mempool_alloc(&b->c->fill_iter, GFP_NOIO);
> -       iter->size =3D b->c->cache->sb.bucket_size / b->c->cache->sb.bloc=
k_size;
> -       iter->used =3D 0;
> +       iter->heap.heap.size =3D b->c->cache->sb.bucket_size / b->c->cach=
e->sb.block_size;
> +       iter->heap.heap.nr =3D 0;
>
>  #ifdef CONFIG_BCACHE_DEBUG
>         iter->b =3D &b->keys;
> @@ -1311,6 +1311,9 @@ static bool btree_gc_mark_node(struct btree *b, str=
uct gc_stat *gc)
>         struct bkey *k;
>         struct btree_iter iter;
>         struct bset_tree *t;
> +       struct btree_iter_set data[MAX_BSETS];
> +
> +       iter.heap.heap.data =3D data;
>
>         gc->nodes++;
>
> @@ -1572,6 +1575,9 @@ static unsigned int btree_gc_count_keys(struct btre=
e *b)
>         struct bkey *k;
>         struct btree_iter iter;
>         unsigned int ret =3D 0;
> +       struct btree_iter_set data[MAX_BSETS];
> +
> +       iter.heap.heap.data =3D data;
>
>         for_each_key_filter(&b->keys, k, &iter, bch_ptr_bad)
>                 ret +=3D bkey_u64s(k);
> @@ -1614,6 +1620,9 @@ static int btree_gc_recurse(struct btree *b, struct=
 btree_op *op,
>         struct btree_iter iter;
>         struct gc_merge_info r[GC_MERGE_NODES];
>         struct gc_merge_info *i, *last =3D r + ARRAY_SIZE(r) - 1;
> +       struct btree_iter_set data[MAX_BSETS];
> +
> +       iter.heap.heap.data =3D data;
>
>         bch_btree_iter_init(&b->keys, &iter, &b->c->gc_done);
>
> @@ -1912,6 +1921,9 @@ static int bch_btree_check_recurse(struct btree *b,=
 struct btree_op *op)
>         int ret =3D 0;
>         struct bkey *k, *p =3D NULL;
>         struct btree_iter iter;
> +       struct btree_iter_set data[MAX_BSETS];
> +
> +       iter.heap.heap.data =3D data;
>
>         for_each_key_filter(&b->keys, k, &iter, bch_ptr_invalid)
>                 bch_initial_mark_key(b->c, b->level, k);
> @@ -1953,7 +1965,9 @@ static int bch_btree_check_thread(void *arg)
>         struct btree_iter iter;
>         struct bkey *k, *p;
>         int cur_idx, prev_idx, skip_nr;
> +       struct btree_iter_set data[MAX_BSETS];
>
> +       iter.heap.heap.data =3D data;
>         k =3D p =3D NULL;
>         cur_idx =3D prev_idx =3D 0;
>         ret =3D 0;
> @@ -2053,6 +2067,9 @@ int bch_btree_check(struct cache_set *c)
>         struct bkey *k =3D NULL;
>         struct btree_iter iter;
>         struct btree_check_state check_state;
> +       struct btree_iter_set data[MAX_BSETS];
> +
> +       iter.heap.heap.data =3D data;
>
>         /* check and mark root node keys */
>         for_each_key_filter(&c->root->keys, k, &iter, bch_ptr_invalid)
> @@ -2548,6 +2565,9 @@ static int bch_btree_map_nodes_recurse(struct btree=
 *b, struct btree_op *op,
>         if (b->level) {
>                 struct bkey *k;
>                 struct btree_iter iter;
> +               struct btree_iter_set data[MAX_BSETS];
> +
> +               iter.heap.heap.data =3D data;
>
>                 bch_btree_iter_init(&b->keys, &iter, from);
>
> @@ -2581,6 +2601,9 @@ int bch_btree_map_keys_recurse(struct btree *b, str=
uct btree_op *op,
>         int ret =3D MAP_CONTINUE;
>         struct bkey *k;
>         struct btree_iter iter;
> +       struct btree_iter_set data[MAX_BSETS];
> +
> +       iter.heap.heap.data =3D data;
>
>         bch_btree_iter_init(&b->keys, &iter, from);
>
> diff --git a/drivers/md/bcache/extents.c b/drivers/md/bcache/extents.c
> index d626ffcbecb9..8279596004f5 100644
> --- a/drivers/md/bcache/extents.c
> +++ b/drivers/md/bcache/extents.c
> @@ -32,16 +32,19 @@ static void sort_key_next(struct btree_iter *iter,
>  {
>         i->k =3D bkey_next(i->k);
>
> -       if (i->k =3D=3D i->end)
> -               *i =3D iter->data[--iter->used];
> +       if (i->k =3D=3D i->end) {
> +               struct btree_iter_set *data =3D iter->heap.heap.data;
> +               *i =3D data[--iter->heap.heap.nr];
> +       }
>  }
>
> -static bool bch_key_sort_cmp(struct btree_iter_set l,
> -                            struct btree_iter_set r)
> +static bool bch_key_sort_cmp(const void *l, const void *r, void *args)
>  {
> -       int64_t c =3D bkey_cmp(l.k, r.k);
> +       struct btree_iter_set *_l =3D (struct btree_iter_set *)l;
> +       struct btree_iter_set *_r =3D (struct btree_iter_set *)r;
> +       int64_t c =3D bkey_cmp(_l->k, _r->k);
>
> -       return c ? c > 0 : l.k < r.k;
> +       return !(c ? c > 0 : _l->k < _r->k);
>  }
>
>  static bool __ptr_invalid(struct cache_set *c, const struct bkey *k)
> @@ -255,22 +258,29 @@ const struct btree_keys_ops bch_btree_keys_ops =3D =
{
>   * Necessary for btree_sort_fixup() - if there are multiple keys that co=
mpare
>   * equal in different sets, we have to process them newest to oldest.
>   */
> -static bool bch_extent_sort_cmp(struct btree_iter_set l,
> -                               struct btree_iter_set r)
> +static bool bch_extent_sort_cmp(const void *l, const void *r, void __alw=
ays_unused *args)
>  {
> -       int64_t c =3D bkey_cmp(&START_KEY(l.k), &START_KEY(r.k));
> +       struct btree_iter_set *_l =3D (struct btree_iter_set *)l;
> +       struct btree_iter_set *_r =3D (struct btree_iter_set *)r;
> +
> +       int64_t c =3D bkey_cmp(&START_KEY(_l->k), &START_KEY(_r->k));
>
> -       return c ? c > 0 : l.k < r.k;
> +       return !(c ? c > 0 : _l->k < _r->k);
>  }
>
>  static struct bkey *bch_extent_sort_fixup(struct btree_iter *iter,
>                                           struct bkey *tmp)
>  {
> -       while (iter->used > 1) {
> -               struct btree_iter_set *top =3D iter->data, *i =3D top + 1=
;
> +       const struct min_heap_callbacks callbacks =3D {
> +               .less =3D bch_extent_sort_cmp,
> +               .swp =3D btree_iter_swap,
> +       };
> +
> +       while (iter->heap.heap.nr > 1) {
> +               struct btree_iter_set *top =3D min_heap_peek(&iter->heap)=
, *i =3D top + 1;
>
> -               if (iter->used > 2 &&
> -                   bch_extent_sort_cmp(i[0], i[1]))
> +               if (iter->heap.heap.nr > 2 &&
> +                   !bch_extent_sort_cmp(&i[0], &i[1], NULL))
>                         i++;
>
>                 if (bkey_cmp(top->k, &START_KEY(i->k)) <=3D 0)
> @@ -278,7 +288,7 @@ static struct bkey *bch_extent_sort_fixup(struct btre=
e_iter *iter,
>
>                 if (!KEY_SIZE(i->k)) {
>                         sort_key_next(iter, i);
> -                       heap_sift(iter, i - top, bch_extent_sort_cmp);
> +                       min_heap_sift_down(&iter->heap, i - top, &callbac=
ks, NULL);
>                         continue;
>                 }
>
> @@ -288,7 +298,7 @@ static struct bkey *bch_extent_sort_fixup(struct btre=
e_iter *iter,
>                         else
>                                 bch_cut_front(top->k, i->k);
>
> -                       heap_sift(iter, i - top, bch_extent_sort_cmp);
> +                       min_heap_sift_down(&iter->heap, i - top, &callbac=
ks, NULL);
>                 } else {
>                         /* can't happen because of comparison func */
>                         BUG_ON(!bkey_cmp(&START_KEY(top->k), &START_KEY(i=
->k)));
> @@ -298,7 +308,7 @@ static struct bkey *bch_extent_sort_fixup(struct btre=
e_iter *iter,
>
>                                 bch_cut_back(&START_KEY(i->k), tmp);
>                                 bch_cut_front(i->k, top->k);
> -                               heap_sift(iter, 0, bch_extent_sort_cmp);
> +                               min_heap_sift_down(&iter->heap, 0, &callb=
acks, NULL);
>
>                                 return tmp;
>                         } else {
> diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
> index ebd500bdf0b2..0f50192fea2c 100644
> --- a/drivers/md/bcache/movinggc.c
> +++ b/drivers/md/bcache/movinggc.c
> @@ -182,16 +182,27 @@ err:              if (!IS_ERR_OR_NULL(w->private))
>         closure_sync(&cl);
>  }
>
> -static bool bucket_cmp(struct bucket *l, struct bucket *r)
> +static bool bucket_cmp(const void *l, const void *r, void __always_unuse=
d *args)
>  {
> -       return GC_SECTORS_USED(l) < GC_SECTORS_USED(r);
> +       struct bucket *_l =3D (struct bucket *)l;
> +       struct bucket *_r =3D (struct bucket *)r;
> +
> +       return GC_SECTORS_USED(_l) >=3D GC_SECTORS_USED(_r);
> +}
> +
> +static void bucket_swap(void *l, void *r, void __always_unused *args)
> +{
> +       struct bucket *_l =3D l;
> +       struct bucket *_r =3D r;
> +
> +       swap(*_l, *_r);
>  }
>
>  static unsigned int bucket_heap_top(struct cache *ca)
>  {
>         struct bucket *b;
>
> -       return (b =3D heap_peek(&ca->heap)) ? GC_SECTORS_USED(b) : 0;
> +       return (b =3D *min_heap_peek(&ca->heap)) ? GC_SECTORS_USED(b) : 0=
;
>  }
>
>  void bch_moving_gc(struct cache_set *c)
> @@ -199,6 +210,10 @@ void bch_moving_gc(struct cache_set *c)
>         struct cache *ca =3D c->cache;
>         struct bucket *b;
>         unsigned long sectors_to_move, reserve_sectors;
> +       const struct min_heap_callbacks callbacks =3D {
> +               .less =3D bucket_cmp,
> +               .swp =3D bucket_swap,
> +       };
>
>         if (!c->copy_gc_enabled)
>                 return;
> @@ -209,7 +224,7 @@ void bch_moving_gc(struct cache_set *c)
>         reserve_sectors =3D ca->sb.bucket_size *
>                              fifo_used(&ca->free[RESERVE_MOVINGGC]);
>
> -       ca->heap.used =3D 0;
> +       ca->heap.heap.nr =3D 0;
>
>         for_each_bucket(b, ca) {
>                 if (GC_MARK(b) =3D=3D GC_MARK_METADATA ||
> @@ -218,25 +233,28 @@ void bch_moving_gc(struct cache_set *c)
>                     atomic_read(&b->pin))
>                         continue;
>
> -               if (!heap_full(&ca->heap)) {
> +               if (!min_heap_full(&ca->heap)) {
>                         sectors_to_move +=3D GC_SECTORS_USED(b);
> -                       heap_add(&ca->heap, b, bucket_cmp);
> -               } else if (bucket_cmp(b, heap_peek(&ca->heap))) {
> +                       min_heap_push(&ca->heap, b, &callbacks, NULL);
> +               } else if (!bucket_cmp(b, min_heap_peek(&ca->heap), NULL)=
) {
>                         sectors_to_move -=3D bucket_heap_top(ca);
>                         sectors_to_move +=3D GC_SECTORS_USED(b);
>
> -                       ca->heap.data[0] =3D b;
> -                       heap_sift(&ca->heap, 0, bucket_cmp);
> +                       *min_heap_peek(&ca->heap) =3D b;
> +                       min_heap_sift_down(&ca->heap, 0, &callbacks, NULL=
);
>                 }
>         }
>
>         while (sectors_to_move > reserve_sectors) {
> -               heap_pop(&ca->heap, b, bucket_cmp);
> +               b =3D *min_heap_peek(&ca->heap);
> +               min_heap_pop(&ca->heap, &callbacks, NULL);
>                 sectors_to_move -=3D GC_SECTORS_USED(b);
>         }
>
> -       while (heap_pop(&ca->heap, b, bucket_cmp))
> +       while ((b =3D *min_heap_peek(&ca->heap))) {
> +               min_heap_pop(&ca->heap, &callbacks, NULL);
>                 SET_GC_MOVE(b, 1);
> +       }
>
>         mutex_unlock(&c->bucket_lock);
>
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 330bcd9ea4a9..1c6aeeff2cc3 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2193,6 +2193,22 @@ static const char *register_cache_set(struct cache=
 *ca)
>         return err;
>  }
>
> +static inline bool init_heap(struct heap *heap, size_t size, gfp_t gfp)
> +{
> +       size_t bytes =3D size * sizeof(struct bucket *);
> +       void *data =3D kvmalloc(bytes, (gfp) & GFP_KERNEL);
> +
> +       min_heap_init(heap, data, size);
> +
> +       return data;
> +}
> +
> +static inline void free_heap(struct heap *heap)
> +{
> +       kvfree(heap->heap.data);
> +       heap->heap.data =3D NULL;
> +}
> +
>  /* Cache device */
>
>  /* When ca->kobj released */
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index 6956beb55326..eac2039c2cad 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -661,6 +661,9 @@ static unsigned int bch_root_usage(struct cache_set *=
c)
>         struct bkey *k;
>         struct btree *b;
>         struct btree_iter iter;
> +       struct btree_iter_set data[MAX_BSETS];
> +
> +       iter.heap.heap.data =3D data;
>
>         goto lock_root;
>
> diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
> index f61ab1bada6c..fa928d1d327a 100644
> --- a/drivers/md/bcache/util.h
> +++ b/drivers/md/bcache/util.h
> @@ -7,6 +7,7 @@
>  #include <linux/closure.h>
>  #include <linux/errno.h>
>  #include <linux/kernel.h>
> +#include <linux/min_heap.h>
>  #include <linux/sched/clock.h>
>  #include <linux/llist.h>
>  #include <linux/ratelimit.h>
> @@ -30,86 +31,6 @@ struct closure;
>
>  #endif
>
> -#define DECLARE_HEAP(type, name)                                       \
> -       struct {                                                        \
> -               size_t size, used;                                      \
> -               type *data;                                             \
> -       } name
> -
> -#define init_heap(heap, _size, gfp)                                    \
> -({                                                                     \
> -       size_t _bytes;                                                  \
> -       (heap)->used =3D 0;                                              =
 \
> -       (heap)->size =3D (_size);                                        =
 \
> -       _bytes =3D (heap)->size * sizeof(*(heap)->data);                 =
 \
> -       (heap)->data =3D kvmalloc(_bytes, (gfp) & GFP_KERNEL);           =
 \
> -       (heap)->data;                                                   \
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
> -#define heap_swap(h, i, j)     swap((h)->data[i], (h)->data[j])
> -
> -#define heap_sift(h, i, cmp)                                           \
> -do {                                                                   \
> -       size_t _r, _j =3D i;                                             =
 \
> -                                                                       \
> -       for (; _j * 2 + 1 < (h)->used; _j =3D _r) {                      =
 \
> -               _r =3D _j * 2 + 1;                                       =
 \
> -               if (_r + 1 < (h)->used &&                               \
> -                   cmp((h)->data[_r], (h)->data[_r + 1]))              \
> -                       _r++;                                           \
> -                                                                       \
> -               if (cmp((h)->data[_r], (h)->data[_j]))                  \
> -                       break;                                          \
> -               heap_swap(h, _r, _j);                                   \
> -       }                                                               \
> -} while (0)
> -
> -#define heap_sift_down(h, i, cmp)                                      \
> -do {                                                                   \
> -       while (i) {                                                     \
> -               size_t p =3D (i - 1) / 2;                                =
 \
> -               if (cmp((h)->data[i], (h)->data[p]))                    \
> -                       break;                                          \
> -               heap_swap(h, i, p);                                     \
> -               i =3D p;                                                 =
 \
> -       }                                                               \
> -} while (0)
> -
> -#define heap_add(h, d, cmp)                                            \
> -({                                                                     \
> -       bool _r =3D !heap_full(h);                                       =
 \
> -       if (_r) {                                                       \
> -               size_t _i =3D (h)->used++;                               =
 \
> -               (h)->data[_i] =3D d;                                     =
 \
> -                                                                       \
> -               heap_sift_down(h, _i, cmp);                             \
> -               heap_sift(h, _i, cmp);                                  \
> -       }                                                               \
> -       _r;                                                             \
> -})
> -
> -#define heap_pop(h, d, cmp)                                            \
> -({                                                                     \
> -       bool _r =3D (h)->used;                                           =
 \
> -       if (_r) {                                                       \
> -               (d) =3D (h)->data[0];                                    =
 \
> -               (h)->used--;                                            \
> -               heap_swap(h, 0, (h)->used);                             \
> -               heap_sift(h, 0, cmp);                                   \
> -       }                                                               \
> -       _r;                                                             \
> -})
> -
> -#define heap_peek(h)   ((h)->used ? (h)->data[0] : NULL)
> -
> -#define heap_full(h)   ((h)->used =3D=3D (h)->size)
> -
>  #define DECLARE_FIFO(type, name)                                       \
>         struct {                                                        \
>                 size_t front, back, size, mask;                         \
> --
> 2.34.1
>

