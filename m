Return-Path: <linux-bcache+bounces-309-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 639A38805A6
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 20:49:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1774D284B85
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 19:49:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B045639FED;
	Tue, 19 Mar 2024 19:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="etWSF54W"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9760554780
	for <linux-bcache@vger.kernel.org>; Tue, 19 Mar 2024 19:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710877770; cv=none; b=up6ycsTsYrIxuWZoR9/BVmkY7lQ3M6IGASEvmp6wZTSeWGmT/8om3w6imn8klezSHGvqLybkRWzWhCYqE4DSG0JSLHcpR4gIidD17Sj7zWeAN8gWYwMBnLt7A7umsaVBpDrV36XipkfNbdkcdlTFAgyMZmXBSjqnrUSKDDl8Ym8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710877770; c=relaxed/simple;
	bh=q1gUpeqfKFnoWyKIheibeyBf4j7SpdCtaqYlE2IUJ2E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hUpHCeoL8xJp4DhPukwKK16Km6CzYs6nsXt2GAvpQei9v1fWZ7g2BqiLQ8B98c6y7pxHHrDfLTbslY+daHnTWlF989kFuaXpXQsTXQmtFFzvUGeDu1I2bpKRnmiOt5PBam6sr4xvlVmpTleERTS6VHexQAHQD48GPZm2zl3fcd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=etWSF54W; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1e058b9e479so23995ad.0
        for <linux-bcache@vger.kernel.org>; Tue, 19 Mar 2024 12:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710877768; x=1711482568; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zZ/hphHXr9caBgRGgnaigJ69Mj94z+rM1zOQLSO0SCs=;
        b=etWSF54WwW37r20Qjdo/WAoou7y0vooikNCd2NXlaXl4P+3FwaIMakj/3ff98hXUUz
         bwv/jclmZgR7c1AeoHTtmIzbk0JF/g7ZDb/S9bJ8gTtBk1JNZBA6y9sA5W0IHa7Dc9g3
         f0j3tI9ZX+fsnSNLeeXUwKPEHuxlN3TZjvh/fF+VpkA59xukjhPsc2dcbgpY/UNDyG4o
         y+Gtg6hHi+LYgEcfT7YUvDuZW8NXBUxYa61dGnCXp78VdcRlDsjizU/eJnoW2WH/3jVM
         hCAf97R43uIidB9gaOJacovqvpKmduYhaLzgHP/ZcKxrXTbojTlrwhXIOIO0E1OxW49A
         EbkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710877768; x=1711482568;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zZ/hphHXr9caBgRGgnaigJ69Mj94z+rM1zOQLSO0SCs=;
        b=Qr3oSqqKsSCBvj8LVFINm4pVoXL+iEUVD+hQG5GjN16Ho4m8fdLdiY3wk39BiXSNv7
         v5chxEZwk2CeljbmSN+HWNG5HvnIGx0eWI6tDAvAOR9WXaK93+J2ZoC6lei6ovpDkgvZ
         8yThE00GyvGakKmfFDyUTQhl3pqf/kIImsSntK2zgp4XFWaq5CmNXeQdaxgZWIBHZzgO
         Eab6chHLU0EdxDoarvUU8QnpTdir/FirCEW6Fmp9HuPDRYyWLAbnVl71NhHG1rDOnytm
         Lk4VrvJtvr+riDS+5xcDkhBIZaq9myNa8nh9GZe39keJEHfN/WDnlSXnlS4RlM1ChMuJ
         S34w==
X-Forwarded-Encrypted: i=1; AJvYcCUMRBx94UtUEKgKxLB5Wha/Y5kPirBMkwOvKyjjCLhTrnjRVoloWMJoAQ9tBR09imyuJqyVQbHI2bj3oiefE0Ssit4fFjLmI6GDbmd0
X-Gm-Message-State: AOJu0YyrL38mQMmyYkCFWAOgof/O2tYg0Gm/HlR+1mSkq4RDShf1qEPx
	22n0756xWn9d+S/JqjQhVQH8NfkTAOac+Ue9RXjIb4sZ2jVtl5PBn6oFQvxef3VuQnkp/OGPDEo
	lqQFHSKV6merTwdzNOSPRpYvIoEZlMoZRMa98
X-Google-Smtp-Source: AGHT+IH+Q5axf23Nr/EsaGJSf9P3ShYzDoQ1PAOfForV8vEKwOe2IPfqxA7R8WMTIZCRpDINC8Vm8SAstrWArVg/IFs=
X-Received: by 2002:a17:902:c406:b0:1dd:9171:1d0a with SMTP id
 k6-20020a170902c40600b001dd91711d0amr1654plk.25.1710877767366; Tue, 19 Mar
 2024 12:49:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240319180005.246930-1-visitorckw@gmail.com> <20240319180005.246930-5-visitorckw@gmail.com>
In-Reply-To: <20240319180005.246930-5-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Tue, 19 Mar 2024 12:49:16 -0700
Message-ID: <CAP-5=fWY5CQ94kRru=SsaVbhYx+Q+dgDZ6J8TfkN5pFCo0cObw@mail.gmail.com>
Subject: Re: [PATCH 04/13] lib min_heap: Add type safe interface
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

On Tue, Mar 19, 2024 at 11:00=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmail.co=
m> wrote:
>
> Introduce a type-safe interface for min_heap by adding small macro
> wrappers around functions and using a 0-size array to store type
> information. This enables the use of __minheap_cast and
> __minheap_obj_size macros for type casting and obtaining element size.
> The implementation draws inspiration from generic-radix-tree.h,
> eliminating the need to pass element size in min_heap_callbacks.
>
> Link: https://lkml.kernel.org/ioyfizrzq7w7mjrqcadtzsfgpuntowtjdw5pgn4qhvs=
dp4mqqg@nrlek5vmisbu
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Reviewed-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  drivers/md/dm-vdo/repair.c     | 21 +++++-----
>  drivers/md/dm-vdo/slab-depot.c | 13 +++---
>  include/linux/min_heap.h       | 75 +++++++++++++++++++++++-----------
>  kernel/events/core.c           | 35 ++++++++--------
>  lib/test_min_heap.c            | 49 +++++++++++-----------
>  5 files changed, 107 insertions(+), 86 deletions(-)
>
> diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
> index defc9359f10e..7663fa2098f4 100644
> --- a/drivers/md/dm-vdo/repair.c
> +++ b/drivers/md/dm-vdo/repair.c
> @@ -51,6 +51,8 @@ struct recovery_point {
>         bool increment_applied;
>  };
>
> +MIN_HEAP(struct numbered_block_mapping *, replay_heap);
> +
>  struct repair_completion {
>         /* The completion header */
>         struct vdo_completion completion;
> @@ -97,7 +99,7 @@ struct repair_completion {
>          * order, then original journal order. This permits efficient ite=
ration over the journal
>          * entries in order.
>          */
> -       struct min_heap replay_heap;
> +       struct replay_heap replay_heap;
>         /* Fields tracking progress through the journal entries. */
>         struct numbered_block_mapping *current_entry;
>         struct numbered_block_mapping *current_unfetched_entry;
> @@ -163,25 +165,24 @@ static void swap_mappings(void *item1, void *item2)
>  }
>
>  static const struct min_heap_callbacks repair_min_heap =3D {
> -       .elem_size =3D sizeof(struct numbered_block_mapping),
>         .less =3D mapping_is_less_than,
>         .swp =3D swap_mappings,
>  };
>
>  static struct numbered_block_mapping *sort_next_heap_element(struct repa=
ir_completion *repair)
>  {
> -       struct min_heap *heap =3D &repair->replay_heap;
> +       struct replay_heap *heap =3D &repair->replay_heap;
>         struct numbered_block_mapping *last;
>
> -       if (heap->nr =3D=3D 0)
> +       if (heap->heap.nr =3D=3D 0)
>                 return NULL;
>
>         /*
>          * Swap the next heap element with the last one on the heap, popp=
ing it off the heap,
>          * restore the heap invariant, and return a pointer to the popped=
 element.
>          */
> -       last =3D &repair->entries[--heap->nr];
> -       swap_mappings(heap->data, last);
> +       last =3D &repair->entries[--heap->heap.nr];
> +       swap_mappings(heap->heap.data, last);
>         min_heapify(heap, 0, &repair_min_heap);
>         return last;
>  }
> @@ -1117,11 +1118,9 @@ static void recover_block_map(struct vdo_completio=
n *completion)
>          * Organize the journal entries into a binary heap so we can iter=
ate over them in sorted
>          * order incrementally, avoiding an expensive sort call.
>          */
> -       repair->replay_heap =3D (struct min_heap) {
> -               .data =3D repair->entries,
> -               .nr =3D repair->block_map_entry_count,
> -               .size =3D repair->block_map_entry_count,
> -       };
> +       repair->replay_heap.heap.data =3D repair->entries;
> +       repair->replay_heap.heap.nr =3D repair->block_map_entry_count;
> +       repair->replay_heap.heap.size =3D repair->block_map_entry_count;
>         min_heapify_all(&repair->replay_heap, &repair_min_heap);
>
>         vdo_log_info("Replaying %zu recovery entries into block map",
> diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depo=
t.c
> index 46e4721e5b4f..3309480170c3 100644
> --- a/drivers/md/dm-vdo/slab-depot.c
> +++ b/drivers/md/dm-vdo/slab-depot.c
> @@ -3309,7 +3309,6 @@ static void swap_slab_statuses(void *item1, void *i=
tem2)
>  }
>
>  static const struct min_heap_callbacks slab_status_min_heap =3D {
> -       .elem_size =3D sizeof(struct slab_status),
>         .less =3D slab_status_is_less_than,
>         .swp =3D swap_slab_statuses,
>  };
> @@ -3509,7 +3508,7 @@ static int get_slab_statuses(struct block_allocator=
 *allocator,
>  static int __must_check vdo_prepare_slabs_for_allocation(struct block_al=
locator *allocator)
>  {
>         struct slab_status current_slab_status;
> -       struct min_heap heap;
> +       MIN_HEAP(struct slab_status *, heap) heap;
>         int result;
>         struct slab_status *slab_statuses;
>         struct slab_depot *depot =3D allocator->depot;
> @@ -3521,14 +3520,12 @@ static int __must_check vdo_prepare_slabs_for_all=
ocation(struct block_allocator
>                 return result;
>
>         /* Sort the slabs by cleanliness, then by emptiness hint. */
> -       heap =3D (struct min_heap) {
> -               .data =3D slab_statuses,
> -               .nr =3D allocator->slab_count,
> -               .size =3D allocator->slab_count,
> -       };
> +       heap.heap.data =3D slab_statuses;
> +       heap.heap.nr =3D allocator->slab_count;
> +       heap.heap.size =3D allocator->slab_count;
>         min_heapify_all(&heap, &slab_status_min_heap);
>
> -       while (heap.nr > 0) {
> +       while (heap.heap.nr > 0) {
>                 bool high_priority;
>                 struct vdo_slab *slab;
>                 struct slab_journal *journal;
> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> index d52daf45861b..c3635a7fdb88 100644
> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h
> @@ -7,45 +7,59 @@
>  #include <linux/types.h>
>
>  /**
> - * struct min_heap - Data structure to hold a min-heap.
> + * struct __min_heap - Data structure to hold a min-heap.
>   * @data: Start of array holding the heap elements.
>   * @nr: Number of elements currently in the heap.
>   * @size: Maximum number of elements that can be held in current storage=
.
>   */
> -struct min_heap {
> +struct __min_heap {
>         void *data;
>         int nr;
>         int size;
>  };
>
> +/*
> + * We use a 0 size array to stash the type we're storing without taking =
any
> + * space at runtime - then the various accessor macros can use typeof() =
to get
> + * to it for casts/sizeof - we also force the alignment so that storing =
a type
> + * with a ridiculous alignment doesn't blow up the alignment or size of =
the
> + * min_heap.
> + */
> +#define MIN_HEAP(_type, _name)                 \
> +struct _name {                         \
> +       struct __min_heap       heap;           \
> +       _type type[0] __aligned(1);     \
> +}
> +
> +#define __minheap_cast(_heap)          (typeof((_heap)->type[0]) *)
> +#define __minheap_obj_size(_heap)      sizeof((_heap)->type[0])
> +
>  /**
>   * struct min_heap_callbacks - Data/functions to customise the min_heap.
> - * @elem_size: The nr of each element in bytes.
>   * @less: Partial order function for this heap.
>   * @swp: Swap elements function.
>   */
>  struct min_heap_callbacks {
> -       int elem_size;
>         bool (*less)(const void *lhs, const void *rhs);
>         void (*swp)(void *lhs, void *rhs);
>  };
>
>  /* Sift the element at pos down the heap. */
>  static __always_inline
> -void min_heapify(struct min_heap *heap, int pos,
> +void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
>                 const struct min_heap_callbacks *func)
>  {
>         void *left, *right;
>         void *data =3D heap->data;
> -       void *root =3D data + pos * func->elem_size;
> +       void *root =3D data + pos * elem_size;
>         int i =3D pos, j;
>
>         /* Find the sift-down path all the way to the leaves. */
>         for (;;) {
>                 if (i * 2 + 2 >=3D heap->nr)
>                         break;
> -               left =3D data + (i * 2 + 1) * func->elem_size;
> -               right =3D data + (i * 2 + 2) * func->elem_size;
> +               left =3D data + (i * 2 + 1) * elem_size;
> +               right =3D data + (i * 2 + 2) * elem_size;
>                 i =3D func->less(left, right) ? i * 2 + 1 : i * 2 + 2;
>         }
>
> @@ -54,31 +68,37 @@ void min_heapify(struct min_heap *heap, int pos,
>                 i =3D i * 2 + 1;
>
>         /* Backtrack to the correct location. */
> -       while (i !=3D pos && func->less(root, data + i * func->elem_size)=
)
> +       while (i !=3D pos && func->less(root, data + i * elem_size))
>                 i =3D (i - 1) / 2;
>
>         /* Shift the element into its correct place. */
>         j =3D i;
>         while (i !=3D pos) {
>                 i =3D (i - 1) / 2;
> -               func->swp(data + i * func->elem_size, data + j * func->el=
em_size);
> +               func->swp(data + i * elem_size, data + j * elem_size);
>         }
>  }
>
> +#define min_heapify(_heap, _pos, _func)        \
> +       __min_heapify(&(_heap)->heap, _pos, __minheap_obj_size(_heap), _f=
unc)
> +
>  /* Floyd's approach to heapification that is O(nr). */
>  static __always_inline
> -void min_heapify_all(struct min_heap *heap,
> +void __min_heapify_all(struct __min_heap *heap, size_t elem_size,
>                 const struct min_heap_callbacks *func)
>  {
>         int i;
>
>         for (i =3D heap->nr / 2 - 1; i >=3D 0; i--)
> -               min_heapify(heap, i, func);
> +               __min_heapify(heap, i, elem_size, func);
>  }
>
> +#define min_heapify_all(_heap, _func)  \
> +       __min_heapify_all(&(_heap)->heap, __minheap_obj_size(_heap), _fun=
c)
> +
>  /* Remove minimum element from the heap, O(log2(nr)). */
>  static __always_inline
> -void min_heap_pop(struct min_heap *heap,
> +void __min_heap_pop(struct __min_heap *heap, size_t elem_size,
>                 const struct min_heap_callbacks *func)
>  {
>         void *data =3D heap->data;
> @@ -88,27 +108,33 @@ void min_heap_pop(struct min_heap *heap,
>
>         /* Place last element at the root (position 0) and then sift down=
. */
>         heap->nr--;
> -       memcpy(data, data + (heap->nr * func->elem_size), func->elem_size=
);
> -       min_heapify(heap, 0, func);
> +       memcpy(data, data + (heap->nr * elem_size), elem_size);
> +       __min_heapify(heap, 0, elem_size, func);
>  }
>
> +#define min_heap_pop(_heap, _func)     \
> +       __min_heap_pop(&(_heap)->heap, __minheap_obj_size(_heap), _func)
> +
>  /*
>   * Remove the minimum element and then push the given element. The
>   * implementation performs 1 sift (O(log2(nr))) and is therefore more
>   * efficient than a pop followed by a push that does 2.
>   */
>  static __always_inline
> -void min_heap_pop_push(struct min_heap *heap,
> -               const void *element,
> +void __min_heap_pop_push(struct __min_heap *heap,
> +               const void *element, size_t elem_size,
>                 const struct min_heap_callbacks *func)
>  {
> -       memcpy(heap->data, element, func->elem_size);
> -       min_heapify(heap, 0, func);
> +       memcpy(heap->data, element, elem_size);
> +       __min_heapify(heap, 0, elem_size, func);
>  }
>
> +#define min_heap_pop_push(_heap, _element, _func)      \
> +       __min_heap_pop_push(&(_heap)->heap, _element, __minheap_obj_size(=
_heap), _func)
> +
>  /* Push an element on to the heap, O(log2(nr)). */
>  static __always_inline
> -void min_heap_push(struct min_heap *heap, const void *element,
> +void __min_heap_push(struct __min_heap *heap, const void *element, size_=
t elem_size,
>                 const struct min_heap_callbacks *func)
>  {
>         void *data =3D heap->data;
> @@ -120,17 +146,20 @@ void min_heap_push(struct min_heap *heap, const voi=
d *element,
>
>         /* Place at the end of data. */
>         pos =3D heap->nr;
> -       memcpy(data + (pos * func->elem_size), element, func->elem_size);
> +       memcpy(data + (pos * elem_size), element, elem_size);
>         heap->nr++;
>
>         /* Sift child at pos up. */
>         for (; pos > 0; pos =3D (pos - 1) / 2) {
> -               child =3D data + (pos * func->elem_size);
> -               parent =3D data + ((pos - 1) / 2) * func->elem_size;
> +               child =3D data + (pos * elem_size);
> +               parent =3D data + ((pos - 1) / 2) * elem_size;
>                 if (func->less(parent, child))
>                         break;
>                 func->swp(parent, child);
>         }
>  }
>
> +#define min_heap_push(_heap, _element, _func)  \
> +       __min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(_hea=
p), _func)
> +
>  #endif /* _LINUX_MIN_HEAP_H */
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 10ac2db83f14..065dfaa8b009 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3698,19 +3698,20 @@ static void swap_ptr(void *l, void *r)
>         swap(*lp, *rp);
>  }
>
> +MIN_HEAP(struct perf_event *, perf_event_min_heap);
> +
>  static const struct min_heap_callbacks perf_min_heap =3D {
> -       .elem_size =3D sizeof(struct perf_event *),
>         .less =3D perf_less_group_idx,
>         .swp =3D swap_ptr,
>  };
>
> -static void __heap_add(struct min_heap *heap, struct perf_event *event)
> +static void __heap_add(struct perf_event_min_heap *heap, struct perf_eve=
nt *event)
>  {
> -       struct perf_event **itrs =3D heap->data;
> +       struct perf_event **itrs =3D heap->heap.data;
>
>         if (event) {
> -               itrs[heap->nr] =3D event;
> -               heap->nr++;
> +               itrs[heap->heap.nr] =3D event;
> +               heap->heap.nr++;
>         }
>  }
>
> @@ -3738,7 +3739,7 @@ static noinline int visit_groups_merge(struct perf_=
event_context *ctx,
>         struct perf_cpu_context *cpuctx =3D NULL;
>         /* Space for per CPU and/or any CPU event iterators. */
>         struct perf_event *itrs[2];
> -       struct min_heap event_heap;
> +       struct perf_event_min_heap event_heap;
>         struct perf_event **evt;
>         int ret;
>
> @@ -3747,11 +3748,9 @@ static noinline int visit_groups_merge(struct perf=
_event_context *ctx,
>
>         if (!ctx->task) {
>                 cpuctx =3D this_cpu_ptr(&perf_cpu_context);
> -               event_heap =3D (struct min_heap){
> -                       .data =3D cpuctx->heap,
> -                       .nr =3D 0,
> -                       .size =3D cpuctx->heap_size,
> -               };
> +               event_heap.heap.data =3D cpuctx->heap;
> +               event_heap.heap.nr =3D 0;
> +               event_heap.heap.size =3D cpuctx->heap_size;
>
>                 lockdep_assert_held(&cpuctx->ctx.lock);
>
> @@ -3760,15 +3759,13 @@ static noinline int visit_groups_merge(struct per=
f_event_context *ctx,
>                         css =3D &cpuctx->cgrp->css;
>  #endif
>         } else {
> -               event_heap =3D (struct min_heap){
> -                       .data =3D itrs,
> -                       .nr =3D 0,
> -                       .size =3D ARRAY_SIZE(itrs),
> -               };
> +               event_heap.heap.data =3D itrs;
> +               event_heap.heap.nr =3D 0;
> +               event_heap.heap.size =3D ARRAY_SIZE(itrs);
>                 /* Events not within a CPU context may be on any CPU. */
>                 __heap_add(&event_heap, perf_event_groups_first(groups, -=
1, pmu, NULL));
>         }
> -       evt =3D event_heap.data;
> +       evt =3D event_heap.heap.data;
>
>         __heap_add(&event_heap, perf_event_groups_first(groups, cpu, pmu,=
 NULL));
>
> @@ -3777,14 +3774,14 @@ static noinline int visit_groups_merge(struct per=
f_event_context *ctx,
>                 __heap_add(&event_heap, perf_event_groups_first(groups, c=
pu, pmu, css->cgroup));
>  #endif
>
> -       if (event_heap.nr) {
> +       if (event_heap.heap.nr) {
>                 __link_epc((*evt)->pmu_ctx);
>                 perf_assert_pmu_disabled((*evt)->pmu_ctx->pmu);
>         }
>
>         min_heapify_all(&event_heap, &perf_min_heap);
>
> -       while (event_heap.nr) {
> +       while (event_heap.heap.nr) {
>                 ret =3D func(*evt, data);
>                 if (ret)
>                         return ret;
> diff --git a/lib/test_min_heap.c b/lib/test_min_heap.c
> index 7b01b4387cfb..af2e446034d8 100644
> --- a/lib/test_min_heap.c
> +++ b/lib/test_min_heap.c
> @@ -11,6 +11,8 @@
>  #include <linux/printk.h>
>  #include <linux/random.h>
>
> +MIN_HEAP(int, min_heap_test);
> +
>  static __init bool less_than(const void *lhs, const void *rhs)
>  {
>         return *(int *)lhs < *(int *)rhs;
> @@ -30,16 +32,16 @@ static __init void swap_ints(void *lhs, void *rhs)
>  }
>
>  static __init int pop_verify_heap(bool min_heap,
> -                               struct min_heap *heap,
> +                               struct min_heap_test *heap,
>                                 const struct min_heap_callbacks *funcs)
>  {
> -       int *values =3D heap->data;
> +       int *values =3D heap->heap.data;
>         int err =3D 0;
>         int last;
>
>         last =3D values[0];
>         min_heap_pop(heap, funcs);
> -       while (heap->nr > 0) {
> +       while (heap->heap.nr > 0) {
>                 if (min_heap) {
>                         if (last > values[0]) {
>                                 pr_err("error: expected %d <=3D %d\n", la=
st,
> @@ -63,13 +65,12 @@ static __init int test_heapify_all(bool min_heap)
>  {
>         int values[] =3D { 3, 1, 2, 4, 0x8000000, 0x7FFFFFF, 0,
>                          -3, -1, -2, -4, 0x8000000, 0x7FFFFFF };
> -       struct min_heap heap =3D {
> -               .data =3D values,
> -               .nr =3D ARRAY_SIZE(values),
> -               .size =3D  ARRAY_SIZE(values),
> -       };
> +       struct min_heap_test heap;
> +
> +       heap.heap.data =3D values;
> +       heap.heap.nr =3D ARRAY_SIZE(values);
> +       heap.heap.size =3D  ARRAY_SIZE(values);
>         struct min_heap_callbacks funcs =3D {
> -               .elem_size =3D sizeof(int),
>                 .less =3D min_heap ? less_than : greater_than,
>                 .swp =3D swap_ints,
>         };
> @@ -81,8 +82,8 @@ static __init int test_heapify_all(bool min_heap)
>
>
>         /* Test with randomly generated values. */
> -       heap.nr =3D ARRAY_SIZE(values);
> -       for (i =3D 0; i < heap.nr; i++)
> +       heap.heap.nr =3D ARRAY_SIZE(values);
> +       for (i =3D 0; i < heap.heap.nr; i++)
>                 values[i] =3D get_random_u32();
>
>         min_heapify_all(&heap, &funcs);
> @@ -96,13 +97,12 @@ static __init int test_heap_push(bool min_heap)
>         const int data[] =3D { 3, 1, 2, 4, 0x80000000, 0x7FFFFFFF, 0,
>                              -3, -1, -2, -4, 0x80000000, 0x7FFFFFFF };
>         int values[ARRAY_SIZE(data)];
> -       struct min_heap heap =3D {
> -               .data =3D values,
> -               .nr =3D 0,
> -               .size =3D  ARRAY_SIZE(values),
> -       };
> +       struct min_heap_test heap;
> +
> +       heap.heap.data =3D values;
> +       heap.heap.nr =3D 0;
> +       heap.heap.size =3D  ARRAY_SIZE(values);
>         struct min_heap_callbacks funcs =3D {
> -               .elem_size =3D sizeof(int),
>                 .less =3D min_heap ? less_than : greater_than,
>                 .swp =3D swap_ints,
>         };
> @@ -115,7 +115,7 @@ static __init int test_heap_push(bool min_heap)
>         err =3D pop_verify_heap(min_heap, &heap, &funcs);
>
>         /* Test with randomly generated values. */
> -       while (heap.nr < heap.size) {
> +       while (heap.heap.nr < heap.heap.size) {
>                 temp =3D get_random_u32();
>                 min_heap_push(&heap, &temp, &funcs);
>         }
> @@ -129,13 +129,12 @@ static __init int test_heap_pop_push(bool min_heap)
>         const int data[] =3D { 3, 1, 2, 4, 0x80000000, 0x7FFFFFFF, 0,
>                              -3, -1, -2, -4, 0x80000000, 0x7FFFFFFF };
>         int values[ARRAY_SIZE(data)];
> -       struct min_heap heap =3D {
> -               .data =3D values,
> -               .nr =3D 0,
> -               .size =3D  ARRAY_SIZE(values),
> -       };
> +       struct min_heap_test heap;
> +
> +       heap.heap.data =3D values;
> +       heap.heap.nr =3D 0;
> +       heap.heap.size =3D  ARRAY_SIZE(values);
>         struct min_heap_callbacks funcs =3D {
> -               .elem_size =3D sizeof(int),
>                 .less =3D min_heap ? less_than : greater_than,
>                 .swp =3D swap_ints,
>         };
> @@ -152,7 +151,7 @@ static __init int test_heap_pop_push(bool min_heap)
>
>         err =3D pop_verify_heap(min_heap, &heap, &funcs);
>
> -       heap.nr =3D 0;
> +       heap.heap.nr =3D 0;
>         for (i =3D 0; i < ARRAY_SIZE(data); i++)
>                 min_heap_push(&heap, &temp, &funcs);
>
> --
> 2.34.1
>

