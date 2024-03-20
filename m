Return-Path: <linux-bcache+bounces-345-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65CB088164C
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 18:16:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 908951C231B9
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 17:16:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 891556A01C;
	Wed, 20 Mar 2024 17:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1nJCAKE3"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8152969E05
	for <linux-bcache@vger.kernel.org>; Wed, 20 Mar 2024 17:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710954959; cv=none; b=UJHe/X1ZtjjNfJAbtcYGAhQFDfhnf10ikkT1pR2PnoADhB4hFiwdmTXZXiA2w5ePKUN0ZjnSIjdsX3Dzp1NVLxK49+pXQGRm5blxSqHa3RooGgvoPMYFC/LAefh26YehQcD4KriQwBSwKs2u4yKxa1prjsBLxslWZmhH+3g/puc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710954959; c=relaxed/simple;
	bh=f+iSbqY5hfrPkeeghKKghIEVCQuiVRxSJNb10dVqR5Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PhaSy/pgWByee8Oi8YgYNIsx5qUjjKxZgmECFnul8HuCc8XROSGKegeMeYqGiJJPO1J0lAGYxBvlXSrrfnbn9KdOote+kdCYhqa96sXMhPmRTvLyS3eEk9iQy2BRdASPSwES6/1cfsyzJnbRBUCq9k6vfyD2UMM7/aG1VfjeeLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1nJCAKE3; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1e058b9e479so9275ad.0
        for <linux-bcache@vger.kernel.org>; Wed, 20 Mar 2024 10:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710954957; x=1711559757; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bLTcftt4XcM8falGvx2yyeP1h7BFVnpg09qwz1I/YUg=;
        b=1nJCAKE3QDZEcpsJI0Ov+qrvBkElZqO6eRaRGuBGzD9+Bx1C7eLzn7NOQ7cITsxEfD
         xuQD+DE3zFCEq4DjHQFtdimerSfwD/8TtdtwzW66whGU++e5DEaKPAxR8ySV7F1Mv4hY
         gPwEQHNFzedanQxaj04oKxyb7cdgp3HBGi/LCkqx7GuTe3bBWuNbBHLSYz4WZjK4trj3
         /OB5lNf1GF52sNkOtIvI6qEgJW2ToFoeBwu63edso8brrVYSAMSPv4k1cx/oaaKQJrvE
         j5IhCfLM9kRgN29L4DvSO6Sq6ycPE4sILWTdDAo90NMx74xSaoxjaVNXnzYxg0Uy8VZF
         ubcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710954957; x=1711559757;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bLTcftt4XcM8falGvx2yyeP1h7BFVnpg09qwz1I/YUg=;
        b=rBJSj7MUD/YrLB5kxNoS42URWlUhBFd1ILKe0hN78q8fI/ga3rKbOMn75mm5lAc0uP
         LRaR3WIB6hiYrxVoymhNIEm+7K/2gDu7OwEwHBC41uIp51s1KJ21EqeI0d4xnYFS+5fv
         CwrHLNS63LbOGsfUmNewMdZdZUbv8Ed88jZkvFS9EMgE5/IWkV7OBxyAhaE4f/zM6//9
         VkvVNAS0FUdg4u8+Xj3kNaEEQ6wbCVoDjPEtndntsTfL8Jn+9VQQptoluw0NgSma6mXl
         4bU/zUxhBdrvsKOGtvdHZ0HZ40kz0BfoS/XjzMRm21gdhcLRpRQAUQ/aqI7fo9vols9T
         7oHw==
X-Forwarded-Encrypted: i=1; AJvYcCXkt5uAruRSj2fbjjA+dksdzaXyjVi6XnYlJ3r0vVjwFgZsHLzKoI6XHZ72Ih/KnmH7gQGPc6x0EmcpVNZrO7P+4c362M7hAhglhuCy
X-Gm-Message-State: AOJu0YxBchuLhRkB7AoL/l66xD/AtLffSxT/g5UrHCGR6CuXboR4OO9u
	tuCniqBNg+9nZQQxlO/01/pl/QuUz+yv83GFfuHRMbWipEmXLyDQMG89BRiSFrDKKdMfey7awk7
	B/1dx9F6GqhSP9bygjIQtRPXK609MZCr/jRUM
X-Google-Smtp-Source: AGHT+IHWDJNpZOWdwzLeIYXsKnsA6OgbxFgHKoIoIdwxptc6cL17PJ0iMY55njqJjoCx9uU9W1Ycnw+q8/3tecMDjPI=
X-Received: by 2002:a17:902:6b08:b0:1de:fe62:547d with SMTP id
 o8-20020a1709026b0800b001defe62547dmr256888plk.17.1710954956511; Wed, 20 Mar
 2024 10:15:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240320145417.336208-1-visitorckw@gmail.com> <20240320145417.336208-11-visitorckw@gmail.com>
In-Reply-To: <20240320145417.336208-11-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Wed, 20 Mar 2024 10:15:45 -0700
Message-ID: <CAP-5=fWysFv=7dRqA6SLjDTwOFxCQpd8Yhqa9Wv1VwF0xHjYpQ@mail.gmail.com>
Subject: Re: [PATCH v2 10/15] lib min_heap: Add args for min_heap_callbacks
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
> Add a third parameter 'args' for the 'less' and 'swp' functions in the
> 'struct min_heap_callbacks'. This additional parameter allows these
> comparison and swap functions to handle extra arguments when necessary.
>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Reviewed-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
> Changes in v2:
> - Add attribute __always_unused to the compare and swap functions that
>   do not use the args parameter.
>
>  drivers/md/dm-vdo/repair.c     | 10 +++----
>  drivers/md/dm-vdo/slab-depot.c |  9 +++---
>  include/linux/min_heap.h       | 51 +++++++++++++++++-----------------
>  kernel/events/core.c           | 10 +++----
>  lib/test_min_heap.c            | 26 ++++++++---------
>  5 files changed, 54 insertions(+), 52 deletions(-)
>
> diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
> index 7663fa2098f4..6acaebcd305d 100644
> --- a/drivers/md/dm-vdo/repair.c
> +++ b/drivers/md/dm-vdo/repair.c
> @@ -137,7 +137,7 @@ struct repair_completion {
>   * to sort by slot while still ensuring we replay all entries with the s=
ame slot in the exact order
>   * as they appeared in the journal.
>   */
> -static bool mapping_is_less_than(const void *item1, const void *item2)
> +static bool mapping_is_less_than(const void *item1, const void *item2, v=
oid __always_unused *args)
>  {
>         const struct numbered_block_mapping *mapping1 =3D
>                 (const struct numbered_block_mapping *) item1;
> @@ -156,7 +156,7 @@ static bool mapping_is_less_than(const void *item1, c=
onst void *item2)
>         return 0;
>  }
>
> -static void swap_mappings(void *item1, void *item2)
> +static void swap_mappings(void *item1, void *item2, void __always_unused=
 *args)
>  {
>         struct numbered_block_mapping *mapping1 =3D item1;
>         struct numbered_block_mapping *mapping2 =3D item2;
> @@ -182,8 +182,8 @@ static struct numbered_block_mapping *sort_next_heap_=
element(struct repair_compl
>          * restore the heap invariant, and return a pointer to the popped=
 element.
>          */
>         last =3D &repair->entries[--heap->heap.nr];
> -       swap_mappings(heap->heap.data, last);
> -       min_heapify(heap, 0, &repair_min_heap);
> +       swap_mappings(heap->heap.data, last, NULL);
> +       min_heapify(heap, 0, &repair_min_heap, NULL);
>         return last;
>  }
>
> @@ -1121,7 +1121,7 @@ static void recover_block_map(struct vdo_completion=
 *completion)
>         repair->replay_heap.heap.data =3D repair->entries;
>         repair->replay_heap.heap.nr =3D repair->block_map_entry_count;
>         repair->replay_heap.heap.size =3D repair->block_map_entry_count;
> -       min_heapify_all(&repair->replay_heap, &repair_min_heap);
> +       min_heapify_all(&repair->replay_heap, &repair_min_heap, NULL);
>
>         vdo_log_info("Replaying %zu recovery entries into block map",
>                      repair->block_map_entry_count);
> diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depo=
t.c
> index 3309480170c3..102f492bb1f8 100644
> --- a/drivers/md/dm-vdo/slab-depot.c
> +++ b/drivers/md/dm-vdo/slab-depot.c
> @@ -3288,7 +3288,8 @@ int vdo_release_block_reference(struct block_alloca=
tor *allocator,
>   * Thus, the ordering is reversed from the usual sense since min_heap re=
turns smaller elements
>   * before larger ones.
>   */
> -static bool slab_status_is_less_than(const void *item1, const void *item=
2)
> +static bool slab_status_is_less_than(const void *item1, const void *item=
2,
> +                                       void __always_unused *args)
>  {
>         const struct slab_status *info1 =3D item1;
>         const struct slab_status *info2 =3D item2;
> @@ -3300,7 +3301,7 @@ static bool slab_status_is_less_than(const void *it=
em1, const void *item2)
>         return info1->slab_number < info2->slab_number;
>  }
>
> -static void swap_slab_statuses(void *item1, void *item2)
> +static void swap_slab_statuses(void *item1, void *item2, void __always_u=
nused *args)
>  {
>         struct slab_status *info1 =3D item1;
>         struct slab_status *info2 =3D item2;
> @@ -3523,7 +3524,7 @@ static int __must_check vdo_prepare_slabs_for_alloc=
ation(struct block_allocator
>         heap.heap.data =3D slab_statuses;
>         heap.heap.nr =3D allocator->slab_count;
>         heap.heap.size =3D allocator->slab_count;
> -       min_heapify_all(&heap, &slab_status_min_heap);
> +       min_heapify_all(&heap, &slab_status_min_heap, NULL);
>
>         while (heap.heap.nr > 0) {
>                 bool high_priority;
> @@ -3531,7 +3532,7 @@ static int __must_check vdo_prepare_slabs_for_alloc=
ation(struct block_allocator
>                 struct slab_journal *journal;
>
>                 current_slab_status =3D slab_statuses[0];
> -               min_heap_pop(&heap, &slab_status_min_heap);
> +               min_heap_pop(&heap, &slab_status_min_heap, NULL);
>                 slab =3D depot->slabs[current_slab_status.slab_number];
>
>                 if ((depot->load_type =3D=3D VDO_SLAB_DEPOT_REBUILD_LOAD)=
 ||
> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> index af12531474a4..879a9d12e030 100644
> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h
> @@ -40,8 +40,8 @@ struct _name {                                \
>   * @swp: Swap elements function.
>   */
>  struct min_heap_callbacks {
> -       bool (*less)(const void *lhs, const void *rhs);
> -       void (*swp)(void *lhs, void *rhs);
> +       bool (*less)(const void *lhs, const void *rhs, void *args);
> +       void (*swp)(void *lhs, void *rhs, void *args);
>  };
>
>  /* Initialize a min-heap. */
> @@ -79,7 +79,7 @@ bool __min_heap_full(struct __min_heap *heap)
>  /* Sift the element at pos down the heap. */
>  static __always_inline
>  void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
> -               const struct min_heap_callbacks *func)
> +               const struct min_heap_callbacks *func, void *args)
>  {
>         void *left, *right;
>         void *data =3D heap->data;
> @@ -92,7 +92,7 @@ void __min_heapify(struct __min_heap *heap, int pos, si=
ze_t elem_size,
>                         break;
>                 left =3D data + (i * 2 + 1) * elem_size;
>                 right =3D data + (i * 2 + 2) * elem_size;
> -               i =3D func->less(left, right) ? i * 2 + 1 : i * 2 + 2;
> +               i =3D func->less(left, right, args) ? i * 2 + 1 : i * 2 +=
 2;
>         }
>
>         /* Special case for the last leaf with no sibling. */
> @@ -100,38 +100,38 @@ void __min_heapify(struct __min_heap *heap, int pos=
, size_t elem_size,
>                 i =3D i * 2 + 1;
>
>         /* Backtrack to the correct location. */
> -       while (i !=3D pos && func->less(root, data + i * elem_size))
> +       while (i !=3D pos && func->less(root, data + i * elem_size, args)=
)
>                 i =3D (i - 1) / 2;
>
>         /* Shift the element into its correct place. */
>         j =3D i;
>         while (i !=3D pos) {
>                 i =3D (i - 1) / 2;
> -               func->swp(data + i * elem_size, data + j * elem_size);
> +               func->swp(data + i * elem_size, data + j * elem_size, arg=
s);
>         }
>  }
>
> -#define min_heapify(_heap, _pos, _func)        \
> -       __min_heapify(&(_heap)->heap, _pos, __minheap_obj_size(_heap), _f=
unc)
> +#define min_heapify(_heap, _pos, _func, _args) \
> +       __min_heapify(&(_heap)->heap, _pos, __minheap_obj_size(_heap), _f=
unc, _args)
>
>  /* Floyd's approach to heapification that is O(nr). */
>  static __always_inline
>  void __min_heapify_all(struct __min_heap *heap, size_t elem_size,
> -               const struct min_heap_callbacks *func)
> +               const struct min_heap_callbacks *func, void *args)
>  {
>         int i;
>
>         for (i =3D heap->nr / 2 - 1; i >=3D 0; i--)
> -               __min_heapify(heap, i, elem_size, func);
> +               __min_heapify(heap, i, elem_size, func, args);
>  }
>
> -#define min_heapify_all(_heap, _func)  \
> -       __min_heapify_all(&(_heap)->heap, __minheap_obj_size(_heap), _fun=
c)
> +#define min_heapify_all(_heap, _func, _args)   \
> +       __min_heapify_all(&(_heap)->heap, __minheap_obj_size(_heap), _fun=
c, _args)
>
>  /* Remove minimum element from the heap, O(log2(nr)). */
>  static __always_inline
>  void __min_heap_pop(struct __min_heap *heap, size_t elem_size,
> -               const struct min_heap_callbacks *func)
> +               const struct min_heap_callbacks *func, void *args)
>  {
>         void *data =3D heap->data;
>
> @@ -141,11 +141,11 @@ void __min_heap_pop(struct __min_heap *heap, size_t=
 elem_size,
>         /* Place last element at the root (position 0) and then sift down=
. */
>         heap->nr--;
>         memcpy(data, data + (heap->nr * elem_size), elem_size);
> -       __min_heapify(heap, 0, elem_size, func);
> +       __min_heapify(heap, 0, elem_size, func, args);
>  }
>
> -#define min_heap_pop(_heap, _func)     \
> -       __min_heap_pop(&(_heap)->heap, __minheap_obj_size(_heap), _func)
> +#define min_heap_pop(_heap, _func, _args)      \
> +       __min_heap_pop(&(_heap)->heap, __minheap_obj_size(_heap), _func, =
_args)
>
>  /*
>   * Remove the minimum element and then push the given element. The
> @@ -155,19 +155,20 @@ void __min_heap_pop(struct __min_heap *heap, size_t=
 elem_size,
>  static __always_inline
>  void __min_heap_pop_push(struct __min_heap *heap,
>                 const void *element, size_t elem_size,
> -               const struct min_heap_callbacks *func)
> +               const struct min_heap_callbacks *func,
> +               void *args)
>  {
>         memcpy(heap->data, element, elem_size);
> -       __min_heapify(heap, 0, elem_size, func);
> +       __min_heapify(heap, 0, elem_size, func, args);
>  }
>
> -#define min_heap_pop_push(_heap, _element, _func)      \
> -       __min_heap_pop_push(&(_heap)->heap, _element, __minheap_obj_size(=
_heap), _func)
> +#define min_heap_pop_push(_heap, _element, _func, _args)       \
> +       __min_heap_pop_push(&(_heap)->heap, _element, __minheap_obj_size(=
_heap), _func, _args)
>
>  /* Push an element on to the heap, O(log2(nr)). */
>  static __always_inline
>  void __min_heap_push(struct __min_heap *heap, const void *element, size_=
t elem_size,
> -               const struct min_heap_callbacks *func)
> +               const struct min_heap_callbacks *func, void *args)
>  {
>         void *data =3D heap->data;
>         void *child, *parent;
> @@ -185,14 +186,14 @@ void __min_heap_push(struct __min_heap *heap, const=
 void *element, size_t elem_s
>         for (; pos > 0; pos =3D (pos - 1) / 2) {
>                 child =3D data + (pos * elem_size);
>                 parent =3D data + ((pos - 1) / 2) * elem_size;
> -               if (func->less(parent, child))
> +               if (func->less(parent, child, args))
>                         break;
> -               func->swp(parent, child);
> +               func->swp(parent, child, args);
>         }
>  }
>
> -#define min_heap_push(_heap, _element, _func)  \
> -       __min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(_hea=
p), _func)
> +#define min_heap_push(_heap, _element, _func, _args)   \
> +       __min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(_hea=
p), _func, _args)
>
>  /* Sift up ith element from the heap, O(log2(nr)). */
>  static __always_inline
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 065dfaa8b009..c32a78c489f3 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3683,7 +3683,7 @@ void __perf_event_task_sched_out(struct task_struct=
 *task,
>         perf_cgroup_switch(next);
>  }
>
> -static bool perf_less_group_idx(const void *l, const void *r)
> +static bool perf_less_group_idx(const void *l, const void *r, void __alw=
ays_unused *args)
>  {
>         const struct perf_event *le =3D *(const struct perf_event **)l;
>         const struct perf_event *re =3D *(const struct perf_event **)r;
> @@ -3691,7 +3691,7 @@ static bool perf_less_group_idx(const void *l, cons=
t void *r)
>         return le->group_index < re->group_index;
>  }
>
> -static void swap_ptr(void *l, void *r)
> +static void swap_ptr(void *l, void *r, void __always_unused *args)
>  {
>         void **lp =3D l, **rp =3D r;
>
> @@ -3779,7 +3779,7 @@ static noinline int visit_groups_merge(struct perf_=
event_context *ctx,
>                 perf_assert_pmu_disabled((*evt)->pmu_ctx->pmu);
>         }
>
> -       min_heapify_all(&event_heap, &perf_min_heap);
> +       min_heapify_all(&event_heap, &perf_min_heap, NULL);
>
>         while (event_heap.heap.nr) {
>                 ret =3D func(*evt, data);
> @@ -3788,9 +3788,9 @@ static noinline int visit_groups_merge(struct perf_=
event_context *ctx,
>
>                 *evt =3D perf_event_groups_next(*evt, pmu);
>                 if (*evt)
> -                       min_heapify(&event_heap, 0, &perf_min_heap);
> +                       min_heapify(&event_heap, 0, &perf_min_heap, NULL)=
;
>                 else
> -                       min_heap_pop(&event_heap, &perf_min_heap);
> +                       min_heap_pop(&event_heap, &perf_min_heap, NULL);
>         }
>
>         return 0;
> diff --git a/lib/test_min_heap.c b/lib/test_min_heap.c
> index af2e446034d8..062e908e9fa3 100644
> --- a/lib/test_min_heap.c
> +++ b/lib/test_min_heap.c
> @@ -13,17 +13,17 @@
>
>  MIN_HEAP(int, min_heap_test);
>
> -static __init bool less_than(const void *lhs, const void *rhs)
> +static __init bool less_than(const void *lhs, const void *rhs, void __al=
ways_unused *args)
>  {
>         return *(int *)lhs < *(int *)rhs;
>  }
>
> -static __init bool greater_than(const void *lhs, const void *rhs)
> +static __init bool greater_than(const void *lhs, const void *rhs, void _=
_always_unused *args)
>  {
>         return *(int *)lhs > *(int *)rhs;
>  }
>
> -static __init void swap_ints(void *lhs, void *rhs)
> +static __init void swap_ints(void *lhs, void *rhs, void __always_unused =
*args)
>  {
>         int temp =3D *(int *)lhs;
>
> @@ -40,7 +40,7 @@ static __init int pop_verify_heap(bool min_heap,
>         int last;
>
>         last =3D values[0];
> -       min_heap_pop(heap, funcs);
> +       min_heap_pop(heap, funcs, NULL);
>         while (heap->heap.nr > 0) {
>                 if (min_heap) {
>                         if (last > values[0]) {
> @@ -56,7 +56,7 @@ static __init int pop_verify_heap(bool min_heap,
>                         }
>                 }
>                 last =3D values[0];
> -               min_heap_pop(heap, funcs);
> +               min_heap_pop(heap, funcs, NULL);
>         }
>         return err;
>  }
> @@ -77,7 +77,7 @@ static __init int test_heapify_all(bool min_heap)
>         int i, err;
>
>         /* Test with known set of values. */
> -       min_heapify_all(&heap, &funcs);
> +       min_heapify_all(&heap, &funcs, NULL);
>         err =3D pop_verify_heap(min_heap, &heap, &funcs);
>
>
> @@ -86,7 +86,7 @@ static __init int test_heapify_all(bool min_heap)
>         for (i =3D 0; i < heap.heap.nr; i++)
>                 values[i] =3D get_random_u32();
>
> -       min_heapify_all(&heap, &funcs);
> +       min_heapify_all(&heap, &funcs, NULL);
>         err +=3D pop_verify_heap(min_heap, &heap, &funcs);
>
>         return err;
> @@ -110,14 +110,14 @@ static __init int test_heap_push(bool min_heap)
>
>         /* Test with known set of values copied from data. */
>         for (i =3D 0; i < ARRAY_SIZE(data); i++)
> -               min_heap_push(&heap, &data[i], &funcs);
> +               min_heap_push(&heap, &data[i], &funcs, NULL);
>
>         err =3D pop_verify_heap(min_heap, &heap, &funcs);
>
>         /* Test with randomly generated values. */
>         while (heap.heap.nr < heap.heap.size) {
>                 temp =3D get_random_u32();
> -               min_heap_push(&heap, &temp, &funcs);
> +               min_heap_push(&heap, &temp, &funcs, NULL);
>         }
>         err +=3D pop_verify_heap(min_heap, &heap, &funcs);
>
> @@ -143,22 +143,22 @@ static __init int test_heap_pop_push(bool min_heap)
>         /* Fill values with data to pop and replace. */
>         temp =3D min_heap ? 0x80000000 : 0x7FFFFFFF;
>         for (i =3D 0; i < ARRAY_SIZE(data); i++)
> -               min_heap_push(&heap, &temp, &funcs);
> +               min_heap_push(&heap, &temp, &funcs, NULL);
>
>         /* Test with known set of values copied from data. */
>         for (i =3D 0; i < ARRAY_SIZE(data); i++)
> -               min_heap_pop_push(&heap, &data[i], &funcs);
> +               min_heap_pop_push(&heap, &data[i], &funcs, NULL);
>
>         err =3D pop_verify_heap(min_heap, &heap, &funcs);
>
>         heap.heap.nr =3D 0;
>         for (i =3D 0; i < ARRAY_SIZE(data); i++)
> -               min_heap_push(&heap, &temp, &funcs);
> +               min_heap_push(&heap, &temp, &funcs, NULL);
>
>         /* Test with randomly generated values. */
>         for (i =3D 0; i < ARRAY_SIZE(data); i++) {
>                 temp =3D get_random_u32();
> -               min_heap_pop_push(&heap, &temp, &funcs);
> +               min_heap_pop_push(&heap, &temp, &funcs, NULL);
>         }
>         err +=3D pop_verify_heap(min_heap, &heap, &funcs);
>
> --
> 2.34.1
>

