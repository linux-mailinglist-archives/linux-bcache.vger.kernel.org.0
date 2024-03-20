Return-Path: <linux-bcache+bounces-326-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4609880A6D
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 05:44:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D860E1C213DF
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 04:44:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1AEC12B83;
	Wed, 20 Mar 2024 04:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kKyD5H6E"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E85125CE
	for <linux-bcache@vger.kernel.org>; Wed, 20 Mar 2024 04:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710909843; cv=none; b=rXB7an0xOnuC1qVNe0ms3RJw9B4rEioS9HWT9CeftDc2yQgmgniIPeUcQ6vYuSFLzqJcrS+G0dlVDgg1PZf4dAKB9NfFDUMCJOZCa9DRKh+NCqsCbWCfI4p5Sz7tm3v4YN/iIpldt4+z4OAMEIOFmA4M5jmOXKXHN8mQPrNCbWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710909843; c=relaxed/simple;
	bh=ZtLX1VgjUt5FiiPz9WKWrGlX/1NAunFciXiTRzXgsYU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tsnX6Xy5H9Z0pAvJwcJV55YokiALRy7L4lK/HJb/EBalGCUt2SB9JRKg3VaB4xM+cLcz1CcQ7GuERe2viwApMAO3SnMHvh2noOYlCWPUbiOzFeAmFoDCNn9hU646jqvk8pQBCwSAXcYAczzCMHBv/i0iW+pZTnCSqaGi6KdbYds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kKyD5H6E; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1dee917abd5so83945ad.1
        for <linux-bcache@vger.kernel.org>; Tue, 19 Mar 2024 21:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710909841; x=1711514641; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ZihA0qI8jT5z7yEg/nEBAiJHrOhd9ChJlHxxUNkIPA=;
        b=kKyD5H6EaDZFXACe6HDfi/zFv+ke5c/Qnm11Vy/6bFch20m+BMYqKsKxm1xOdss/J2
         x0i+I0VH1SG5MY/4NLMrFEsyCSIbEFnNiAzqSRO6n/+gqMc0RGNRS2B/DFVxy7q2lRuE
         UOQPJxiNmff6agulwb9TkPPjplMfTtPS2CnEQDjRbnznmSdGf+Sc/8XxyQpZoZwX69HT
         hedYvjTCjJtPgFvueMR7/6vJo+Czxav2upUCVqp0PeM4xu2FcTcVA0kzWNsV/TJM2vD4
         Mqfll3a+SlkdD8ObIimB69ZNUT8yAky0EdnTyTvAvGKvT7Zh5zUIuOIhennL6MNPFGIn
         egfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710909841; x=1711514641;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6ZihA0qI8jT5z7yEg/nEBAiJHrOhd9ChJlHxxUNkIPA=;
        b=JdtZuJqBsxlXnS5sMgwhIiDhTwdId+k59oHyrkRQKDZxwD7Yf0rbYcdas0CUHLRORz
         5rIQ+RgGCkfnzjF4jOk24mlPE1A0zn3fiByVYTprc3bRpLKDpeevz68iaHcrbtLR/MgB
         pFnpH2lNXG8hUZ6aXwztk1Yxm17fFN6IYZfPoWf9u5orB9ytnCDTGND9ScnB3EVliiji
         nghGpSBtzUuQoPsLGI6xEhv49wtk4xOvp3R/jx1qT21I5RGkSUE9WMB+9s1tHlVw1rJe
         Og3kD4IbaODh5C45WM0RTQEX3ElhukPPW/hrWIL2JipuTqvWwyWesFtqWfdx7S75Dyxx
         hWjQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsUCIOdW9tP7L7D6F7BWOYHMChjMnizl1nuqnKcl/kUkDRi2kSc9mf0KlvTwJzrvgNox/9/SQYLbbmgWEYNHiX1cMdpo0bVLN8+SPP
X-Gm-Message-State: AOJu0YzkOOQVKgceOi+szjZbtiCQMmjkT1+i7jvGutOAHm/KZvAZxT2f
	lqqyW7CWTZuHc+PkZuYROkRjGvvqVZB1tgk7c8SVmYLZTGOhKkV+2o10czv1KBfsZRqILL+gVUA
	hNWeRA9sn8FT8EZm55hwI7eYtHBV2yjhHque2
X-Google-Smtp-Source: AGHT+IEUOv4buDRPSCtDXgL1hpAnp9Xd2qAvxy/0wWEuUDTYFYBEmSUQ981eTC0UAnVIoy21MOV8OCIwwoqQt2klG7I=
X-Received: by 2002:a17:902:bb97:b0:1dd:6e0b:75fb with SMTP id
 m23-20020a170902bb9700b001dd6e0b75fbmr113558pls.9.1710909840396; Tue, 19 Mar
 2024 21:44:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240319180005.246930-1-visitorckw@gmail.com> <20240319180005.246930-9-visitorckw@gmail.com>
 <CAP-5=fUk12o7u-+0u0KeUbdRDYiGzeZU0vgOrTc_3BHEntjn_Q@mail.gmail.com> <ZfpOvsD++wbwCTWO@visitorckw-System-Product-Name>
In-Reply-To: <ZfpOvsD++wbwCTWO@visitorckw-System-Product-Name>
From: Ian Rogers <irogers@google.com>
Date: Tue, 19 Mar 2024 21:43:49 -0700
Message-ID: <CAP-5=fUxWAXH0n0+PVZeEC31CtNX4x66MetVGQs4uEYmmY_Nrw@mail.gmail.com>
Subject: Re: [PATCH 08/13] lib min_heap: Add args for min_heap_callbacks
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

On Tue, Mar 19, 2024 at 7:49=E2=80=AFPM Kuan-Wei Chiu <visitorckw@gmail.com=
> wrote:
>
> On Tue, Mar 19, 2024 at 01:05:18PM -0700, Ian Rogers wrote:
> > On Tue, Mar 19, 2024 at 11:00=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmai=
l.com> wrote:
> > >
> > > Add a third parameter 'args' for the 'less' and 'swp' functions in th=
e
> > > 'struct min_heap_callbacks'. This additional parameter allows these
> > > comparison and swap functions to handle extra arguments when necessar=
y.
> > >
> > > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> >
> > I've no objection to this but I don't see it used in your changes -
> > that may be my fault :-). Perhaps hold off or add a test with args
> > being non-null?
> >
>
> The parameter will be required in the patches for bcache and bcachefs.
> One is for bucket_min_cmp() and bucket_max_cmp() in
> drivers/md/bcache/alloc.c, and the other is for ec_stripes_heap_swap()
> in fs/bcachefs/ec.c.
>
> Do you have any more specific suggestions for adding non-null
> test cases? I'm unsure about what would be a reasonable way to include
> non-null test items in testing.

I didn't have anything in mind, I just wanted to make sure there was
coverage for everything.

Thanks,
Ian

> >
> > > ---
> > >  drivers/md/dm-vdo/repair.c     | 10 +++----
> > >  drivers/md/dm-vdo/slab-depot.c |  8 +++---
> > >  include/linux/min_heap.h       | 51 +++++++++++++++++---------------=
--
> > >  kernel/events/core.c           | 10 +++----
> > >  lib/test_min_heap.c            | 26 ++++++++---------
> > >  5 files changed, 53 insertions(+), 52 deletions(-)
> > >
> > > diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
> > > index 7663fa2098f4..528fa100b410 100644
> > > --- a/drivers/md/dm-vdo/repair.c
> > > +++ b/drivers/md/dm-vdo/repair.c
> > > @@ -137,7 +137,7 @@ struct repair_completion {
> > >   * to sort by slot while still ensuring we replay all entries with t=
he same slot in the exact order
> > >   * as they appeared in the journal.
> > >   */
> > > -static bool mapping_is_less_than(const void *item1, const void *item=
2)
> > > +static bool mapping_is_less_than(const void *item1, const void *item=
2, void *args)
> > >  {
> > >         const struct numbered_block_mapping *mapping1 =3D
> > >                 (const struct numbered_block_mapping *) item1;
> > > @@ -156,7 +156,7 @@ static bool mapping_is_less_than(const void *item=
1, const void *item2)
> > >         return 0;
> > >  }
> > >
> > > -static void swap_mappings(void *item1, void *item2)
> > > +static void swap_mappings(void *item1, void *item2, void *args)
> > >  {
> > >         struct numbered_block_mapping *mapping1 =3D item1;
> > >         struct numbered_block_mapping *mapping2 =3D item2;
> > > @@ -182,8 +182,8 @@ static struct numbered_block_mapping *sort_next_h=
eap_element(struct repair_compl
> > >          * restore the heap invariant, and return a pointer to the po=
pped element.
> > >          */
> > >         last =3D &repair->entries[--heap->heap.nr];
> > > -       swap_mappings(heap->heap.data, last);
> > > -       min_heapify(heap, 0, &repair_min_heap);
> > > +       swap_mappings(heap->heap.data, last, NULL);
> > > +       min_heapify(heap, 0, &repair_min_heap, NULL);
> > >         return last;
> > >  }
> > >
> > > @@ -1121,7 +1121,7 @@ static void recover_block_map(struct vdo_comple=
tion *completion)
> > >         repair->replay_heap.heap.data =3D repair->entries;
> > >         repair->replay_heap.heap.nr =3D repair->block_map_entry_count=
;
> > >         repair->replay_heap.heap.size =3D repair->block_map_entry_cou=
nt;
> > > -       min_heapify_all(&repair->replay_heap, &repair_min_heap);
> > > +       min_heapify_all(&repair->replay_heap, &repair_min_heap, NULL)=
;
> > >
> > >         vdo_log_info("Replaying %zu recovery entries into block map",
> > >                      repair->block_map_entry_count);
> > > diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-=
depot.c
> > > index 3309480170c3..b8c41d7ccde0 100644
> > > --- a/drivers/md/dm-vdo/slab-depot.c
> > > +++ b/drivers/md/dm-vdo/slab-depot.c
> > > @@ -3288,7 +3288,7 @@ int vdo_release_block_reference(struct block_al=
locator *allocator,
> > >   * Thus, the ordering is reversed from the usual sense since min_hea=
p returns smaller elements
> > >   * before larger ones.
> > >   */
> > > -static bool slab_status_is_less_than(const void *item1, const void *=
item2)
> > > +static bool slab_status_is_less_than(const void *item1, const void *=
item2, void *args)
> > >  {
> > >         const struct slab_status *info1 =3D item1;
> > >         const struct slab_status *info2 =3D item2;
> > > @@ -3300,7 +3300,7 @@ static bool slab_status_is_less_than(const void=
 *item1, const void *item2)
> > >         return info1->slab_number < info2->slab_number;
> > >  }
> > >
> > > -static void swap_slab_statuses(void *item1, void *item2)
> > > +static void swap_slab_statuses(void *item1, void *item2, void *args)
> > >  {
> > >         struct slab_status *info1 =3D item1;
> > >         struct slab_status *info2 =3D item2;
> > > @@ -3523,7 +3523,7 @@ static int __must_check vdo_prepare_slabs_for_a=
llocation(struct block_allocator
> > >         heap.heap.data =3D slab_statuses;
> > >         heap.heap.nr =3D allocator->slab_count;
> > >         heap.heap.size =3D allocator->slab_count;
> > > -       min_heapify_all(&heap, &slab_status_min_heap);
> > > +       min_heapify_all(&heap, &slab_status_min_heap, NULL);
> > >
> > >         while (heap.heap.nr > 0) {
> > >                 bool high_priority;
> > > @@ -3531,7 +3531,7 @@ static int __must_check vdo_prepare_slabs_for_a=
llocation(struct block_allocator
> > >                 struct slab_journal *journal;
> > >
> > >                 current_slab_status =3D slab_statuses[0];
> > > -               min_heap_pop(&heap, &slab_status_min_heap);
> > > +               min_heap_pop(&heap, &slab_status_min_heap, NULL);
> > >                 slab =3D depot->slabs[current_slab_status.slab_number=
];
> > >
> > >                 if ((depot->load_type =3D=3D VDO_SLAB_DEPOT_REBUILD_L=
OAD) ||
> > > diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> > > index b1d874f4d536..97d8ba5c32e6 100644
> > > --- a/include/linux/min_heap.h
> > > +++ b/include/linux/min_heap.h
> > > @@ -40,8 +40,8 @@ struct _name {                                \
> > >   * @swp: Swap elements function.
> > >   */
> > >  struct min_heap_callbacks {
> > > -       bool (*less)(const void *lhs, const void *rhs);
> > > -       void (*swp)(void *lhs, void *rhs);
> > > +       bool (*less)(const void *lhs, const void *rhs, void *args);
> > > +       void (*swp)(void *lhs, void *rhs, void *args);
> > >  };
> > >
> > >  /* Initialize a min-heap. */
> > > @@ -79,7 +79,7 @@ bool __min_heap_full(struct __min_heap *heap)
> > >  /* Sift the element at pos down the heap. */
> > >  static __always_inline
> > >  void __min_heapify(struct __min_heap *heap, int pos, size_t elem_siz=
e,
> > > -               const struct min_heap_callbacks *func)
> > > +               const struct min_heap_callbacks *func, void *args)
> > >  {
> > >         void *left, *right;
> > >         void *data =3D heap->data;
> > > @@ -92,7 +92,7 @@ void __min_heapify(struct __min_heap *heap, int pos=
, size_t elem_size,
> > >                         break;
> > >                 left =3D data + (i * 2 + 1) * elem_size;
> > >                 right =3D data + (i * 2 + 2) * elem_size;
> > > -               i =3D func->less(left, right) ? i * 2 + 1 : i * 2 + 2=
;
> > > +               i =3D func->less(left, right, args) ? i * 2 + 1 : i *=
 2 + 2;
> > >         }
> > >
> > >         /* Special case for the last leaf with no sibling. */
> > > @@ -100,38 +100,38 @@ void __min_heapify(struct __min_heap *heap, int=
 pos, size_t elem_size,
> > >                 i =3D i * 2 + 1;
> > >
> > >         /* Backtrack to the correct location. */
> > > -       while (i !=3D pos && func->less(root, data + i * elem_size))
> > > +       while (i !=3D pos && func->less(root, data + i * elem_size, a=
rgs))
> > >                 i =3D (i - 1) / 2;
> > >
> > >         /* Shift the element into its correct place. */
> > >         j =3D i;
> > >         while (i !=3D pos) {
> > >                 i =3D (i - 1) / 2;
> > > -               func->swp(data + i * elem_size, data + j * elem_size)=
;
> > > +               func->swp(data + i * elem_size, data + j * elem_size,=
 args);
> > >         }
> > >  }
> > >
> > > -#define min_heapify(_heap, _pos, _func)        \
> > > -       __min_heapify(&(_heap)->heap, _pos, __minheap_obj_size(_heap)=
, _func)
> > > +#define min_heapify(_heap, _pos, _func, _args) \
> > > +       __min_heapify(&(_heap)->heap, _pos, __minheap_obj_size(_heap)=
, _func, _args)
> > >
> > >  /* Floyd's approach to heapification that is O(nr). */
> > >  static __always_inline
> > >  void __min_heapify_all(struct __min_heap *heap, size_t elem_size,
> > > -               const struct min_heap_callbacks *func)
> > > +               const struct min_heap_callbacks *func, void *args)
> > >  {
> > >         int i;
> > >
> > >         for (i =3D heap->nr / 2 - 1; i >=3D 0; i--)
> > > -               __min_heapify(heap, i, elem_size, func);
> > > +               __min_heapify(heap, i, elem_size, func, args);
> > >  }
> > >
> > > -#define min_heapify_all(_heap, _func)  \
> > > -       __min_heapify_all(&(_heap)->heap, __minheap_obj_size(_heap), =
_func)
> > > +#define min_heapify_all(_heap, _func, _args)   \
> > > +       __min_heapify_all(&(_heap)->heap, __minheap_obj_size(_heap), =
_func, _args)
> > >
> > >  /* Remove minimum element from the heap, O(log2(nr)). */
> > >  static __always_inline
> > >  void __min_heap_pop(struct __min_heap *heap, size_t elem_size,
> > > -               const struct min_heap_callbacks *func)
> > > +               const struct min_heap_callbacks *func, void *args)
> > >  {
> > >         void *data =3D heap->data;
> > >
> > > @@ -141,11 +141,11 @@ void __min_heap_pop(struct __min_heap *heap, si=
ze_t elem_size,
> > >         /* Place last element at the root (position 0) and then sift =
down. */
> > >         heap->nr--;
> > >         memcpy(data, data + (heap->nr * elem_size), elem_size);
> > > -       __min_heapify(heap, 0, elem_size, func);
> > > +       __min_heapify(heap, 0, elem_size, func, args);
> > >  }
> > >
> > > -#define min_heap_pop(_heap, _func)     \
> > > -       __min_heap_pop(&(_heap)->heap, __minheap_obj_size(_heap), _fu=
nc)
> > > +#define min_heap_pop(_heap, _func, _args)      \
> > > +       __min_heap_pop(&(_heap)->heap, __minheap_obj_size(_heap), _fu=
nc, _args)
> > >
> > >  /*
> > >   * Remove the minimum element and then push the given element. The
> > > @@ -155,19 +155,20 @@ void __min_heap_pop(struct __min_heap *heap, si=
ze_t elem_size,
> > >  static __always_inline
> > >  void __min_heap_pop_push(struct __min_heap *heap,
> > >                 const void *element, size_t elem_size,
> > > -               const struct min_heap_callbacks *func)
> > > +               const struct min_heap_callbacks *func,
> > > +               void *args)
> > >  {
> > >         memcpy(heap->data, element, elem_size);
> > > -       __min_heapify(heap, 0, elem_size, func);
> > > +       __min_heapify(heap, 0, elem_size, func, args);
> > >  }
> > >
> > > -#define min_heap_pop_push(_heap, _element, _func)      \
> > > -       __min_heap_pop_push(&(_heap)->heap, _element, __minheap_obj_s=
ize(_heap), _func)
> > > +#define min_heap_pop_push(_heap, _element, _func, _args)       \
> > > +       __min_heap_pop_push(&(_heap)->heap, _element, __minheap_obj_s=
ize(_heap), _func, _args)
> > >
> > >  /* Push an element on to the heap, O(log2(nr)). */
> > >  static __always_inline
> > >  void __min_heap_push(struct __min_heap *heap, const void *element, s=
ize_t elem_size,
> > > -               const struct min_heap_callbacks *func)
> > > +               const struct min_heap_callbacks *func, void *args)
> > >  {
> > >         void *data =3D heap->data;
> > >         void *child, *parent;
> > > @@ -185,13 +186,13 @@ void __min_heap_push(struct __min_heap *heap, c=
onst void *element, size_t elem_s
> > >         for (; pos > 0; pos =3D (pos - 1) / 2) {
> > >                 child =3D data + (pos * elem_size);
> > >                 parent =3D data + ((pos - 1) / 2) * elem_size;
> > > -               if (func->less(parent, child))
> > > +               if (func->less(parent, child, args))
> > >                         break;
> > > -               func->swp(parent, child);
> > > +               func->swp(parent, child, args);
> > >         }
> > >  }
> > >
> > > -#define min_heap_push(_heap, _element, _func)  \
> > > -       __min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(=
_heap), _func)
> > > +#define min_heap_push(_heap, _element, _func, _args)   \
> > > +       __min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(=
_heap), _func, _args)
> > >
> > >  #endif /* _LINUX_MIN_HEAP_H */
> > > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > > index 065dfaa8b009..f2a9044058ee 100644
> > > --- a/kernel/events/core.c
> > > +++ b/kernel/events/core.c
> > > @@ -3683,7 +3683,7 @@ void __perf_event_task_sched_out(struct task_st=
ruct *task,
> > >         perf_cgroup_switch(next);
> > >  }
> > >
> > > -static bool perf_less_group_idx(const void *l, const void *r)
> > > +static bool perf_less_group_idx(const void *l, const void *r, void *=
args)
> > >  {
> > >         const struct perf_event *le =3D *(const struct perf_event **)=
l;
> > >         const struct perf_event *re =3D *(const struct perf_event **)=
r;
> > > @@ -3691,7 +3691,7 @@ static bool perf_less_group_idx(const void *l, =
const void *r)
> > >         return le->group_index < re->group_index;
> > >  }
> > >
> > > -static void swap_ptr(void *l, void *r)
> > > +static void swap_ptr(void *l, void *r, void *args)
> > >  {
> > >         void **lp =3D l, **rp =3D r;
> > >
> > > @@ -3779,7 +3779,7 @@ static noinline int visit_groups_merge(struct p=
erf_event_context *ctx,
> > >                 perf_assert_pmu_disabled((*evt)->pmu_ctx->pmu);
> > >         }
> > >
> > > -       min_heapify_all(&event_heap, &perf_min_heap);
> > > +       min_heapify_all(&event_heap, &perf_min_heap, NULL);
> > >
> > >         while (event_heap.heap.nr) {
> > >                 ret =3D func(*evt, data);
> > > @@ -3788,9 +3788,9 @@ static noinline int visit_groups_merge(struct p=
erf_event_context *ctx,
> > >
> > >                 *evt =3D perf_event_groups_next(*evt, pmu);
> > >                 if (*evt)
> > > -                       min_heapify(&event_heap, 0, &perf_min_heap);
> > > +                       min_heapify(&event_heap, 0, &perf_min_heap, N=
ULL);
> > >                 else
> > > -                       min_heap_pop(&event_heap, &perf_min_heap);
> > > +                       min_heap_pop(&event_heap, &perf_min_heap, NUL=
L);
> > >         }
> > >
> > >         return 0;
> > > diff --git a/lib/test_min_heap.c b/lib/test_min_heap.c
> > > index af2e446034d8..b8859d17a19c 100644
> > > --- a/lib/test_min_heap.c
> > > +++ b/lib/test_min_heap.c
> > > @@ -13,17 +13,17 @@
> > >
> > >  MIN_HEAP(int, min_heap_test);
> > >
> > > -static __init bool less_than(const void *lhs, const void *rhs)
> > > +static __init bool less_than(const void *lhs, const void *rhs, void =
*args)
> > >  {
> > >         return *(int *)lhs < *(int *)rhs;
> > >  }
> > >
> > > -static __init bool greater_than(const void *lhs, const void *rhs)
> > > +static __init bool greater_than(const void *lhs, const void *rhs, vo=
id *args)
> > >  {
> > >         return *(int *)lhs > *(int *)rhs;
> > >  }
> > >
> > > -static __init void swap_ints(void *lhs, void *rhs)
> > > +static __init void swap_ints(void *lhs, void *rhs, void *argsss)
> > >  {
> > >         int temp =3D *(int *)lhs;
> > >
> > > @@ -40,7 +40,7 @@ static __init int pop_verify_heap(bool min_heap,
> > >         int last;
> > >
> > >         last =3D values[0];
> > > -       min_heap_pop(heap, funcs);
> > > +       min_heap_pop(heap, funcs, NULL);
> > >         while (heap->heap.nr > 0) {
> > >                 if (min_heap) {
> > >                         if (last > values[0]) {
> > > @@ -56,7 +56,7 @@ static __init int pop_verify_heap(bool min_heap,
> > >                         }
> > >                 }
> > >                 last =3D values[0];
> > > -               min_heap_pop(heap, funcs);
> > > +               min_heap_pop(heap, funcs, NULL);
> > >         }
> > >         return err;
> > >  }
> > > @@ -77,7 +77,7 @@ static __init int test_heapify_all(bool min_heap)
> > >         int i, err;
> > >
> > >         /* Test with known set of values. */
> > > -       min_heapify_all(&heap, &funcs);
> > > +       min_heapify_all(&heap, &funcs, NULL);
> > >         err =3D pop_verify_heap(min_heap, &heap, &funcs);
> > >
> > >
> > > @@ -86,7 +86,7 @@ static __init int test_heapify_all(bool min_heap)
> > >         for (i =3D 0; i < heap.heap.nr; i++)
> > >                 values[i] =3D get_random_u32();
> > >
> > > -       min_heapify_all(&heap, &funcs);
> > > +       min_heapify_all(&heap, &funcs, NULL);
> > >         err +=3D pop_verify_heap(min_heap, &heap, &funcs);
> > >
> > >         return err;
> > > @@ -110,14 +110,14 @@ static __init int test_heap_push(bool min_heap)
> > >
> > >         /* Test with known set of values copied from data. */
> > >         for (i =3D 0; i < ARRAY_SIZE(data); i++)
> > > -               min_heap_push(&heap, &data[i], &funcs);
> > > +               min_heap_push(&heap, &data[i], &funcs, NULL);
> > >
> > >         err =3D pop_verify_heap(min_heap, &heap, &funcs);
> > >
> > >         /* Test with randomly generated values. */
> > >         while (heap.heap.nr < heap.heap.size) {
> > >                 temp =3D get_random_u32();
> > > -               min_heap_push(&heap, &temp, &funcs);
> > > +               min_heap_push(&heap, &temp, &funcs, NULL);
> > >         }
> > >         err +=3D pop_verify_heap(min_heap, &heap, &funcs);
> > >
> > > @@ -143,22 +143,22 @@ static __init int test_heap_pop_push(bool min_h=
eap)
> > >         /* Fill values with data to pop and replace. */
> > >         temp =3D min_heap ? 0x80000000 : 0x7FFFFFFF;
> > >         for (i =3D 0; i < ARRAY_SIZE(data); i++)
> > > -               min_heap_push(&heap, &temp, &funcs);
> > > +               min_heap_push(&heap, &temp, &funcs, NULL);
> > >
> > >         /* Test with known set of values copied from data. */
> > >         for (i =3D 0; i < ARRAY_SIZE(data); i++)
> > > -               min_heap_pop_push(&heap, &data[i], &funcs);
> > > +               min_heap_pop_push(&heap, &data[i], &funcs, NULL);
> > >
> > >         err =3D pop_verify_heap(min_heap, &heap, &funcs);
> > >
> > >         heap.heap.nr =3D 0;
> > >         for (i =3D 0; i < ARRAY_SIZE(data); i++)
> > > -               min_heap_push(&heap, &temp, &funcs);
> > > +               min_heap_push(&heap, &temp, &funcs, NULL);
> > >
> > >         /* Test with randomly generated values. */
> > >         for (i =3D 0; i < ARRAY_SIZE(data); i++) {
> > >                 temp =3D get_random_u32();
> > > -               min_heap_pop_push(&heap, &temp, &funcs);
> > > +               min_heap_pop_push(&heap, &temp, &funcs, NULL);
> > >         }
> > >         err +=3D pop_verify_heap(min_heap, &heap, &funcs);
> > >
> > > --
> > > 2.34.1
> > >

