Return-Path: <linux-bcache+bounces-321-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3121E8809F1
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 03:51:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9C1991F2537B
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 02:51:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C37CF11CA0;
	Wed, 20 Mar 2024 02:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CNPvhzY3"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5319125DE;
	Wed, 20 Mar 2024 02:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710902982; cv=none; b=Ke9uV3qfWTPYgnL/Dqdhcbl4412aglxyXMsHFrrHie+/yuxbQudIM36CVQx5u8p7D1pa435hK1stZMjwsSEwK47USYQLFKaWhfsxl/ktjlmZmgMge1Juj/PN4kBjRIa/JIVm5zmsmeYJZTLwdM/y5d5y2QFnic5R2SLlSCbsBk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710902982; c=relaxed/simple;
	bh=I38XBXif3WDOPZGd4HX+W842KBGrtupkmvRocUe3FL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M398rSCg88QlW6I7sqpWcMDo5EZELyUpjn7X/ShAiSN6Jv7J88Fgio/LFigdKoKFb1sh6UpbrsXJnCnwodIKeN0KDRmeiPh9FblX1F5FkHgqXIUIYYLFtIvnCJyoRuCqKR3Si/6i/ceqx4gBq/zco/LasHQT5V0fgUYYkrCHd8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CNPvhzY3; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6e6ca65edc9so2020739b3a.0;
        Tue, 19 Mar 2024 19:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710902980; x=1711507780; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rK5f5lnEOGDA0dNCZVHYPRsxftlJcrb8cEbJ45ahcLU=;
        b=CNPvhzY3qGrVtR4/UZNgXQ7zI2LdXweGz8Qr4RuBNKrMCITnZLZ0a6YTabWA9U9tOV
         kGvjR3Ecklc+xRMozMFJO4LMibm9LUO1nkEhpUPK842+LazmuC44ru8OXlzcDh85kBUd
         gCD25bDo6RFcfGUdNXSS849UI9MhXdG33wwBgGvSCBdu7BgcwS6V3QcV/jNKkjbxhmrr
         //5HSrdkCr+M/3mi025axgZHwAi2TI+aMD76wzbHmnA8cuA3kxZvn+jgs+lLMXYB8+rA
         19h++5mk78oUm6+hm3izCXJktBrM6dubslXOzLecFZPB82Lo2nMpKsV2YA0Mirvyepvw
         mGOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710902980; x=1711507780;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rK5f5lnEOGDA0dNCZVHYPRsxftlJcrb8cEbJ45ahcLU=;
        b=KioAeWgPH1Jnb3eYXdw+GeeQE4pzbysEW2jTo74WrlTcDZFSPZ31ezFJB32dVqYf7W
         wiFmT+cb/VLuqztp/pV0R7zSQhgJC28z1s3ib4Cmp6COAfsSG8f/JSGdGy8VsMYSJMKh
         b61xzuCbsyCK8u0oL5C85ztEPwOqmvzUwdczVo5GLq1vEE3rEgzM3vmajjZf4fc60ur1
         W2ROs03UeCRXv2YcEsS+0RVFN/cIT14E95vNkOHdZPkCEj8+hIXzOG36webr4yOuV0oT
         3ka3yJZZEriIthQX2fWmyWs7zIK+o94jtYcis1llEy+d0TdwG+HUFbojMsiChh9ZoNEA
         DoaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXRt+RST0gOqmnHm6fSEKWDYMDhCTqsrIIi5uCGEZJ9vMC32oW1zJu8MLsrUaDEHV9NOXeR7TfQsp14/tYvKWIwsBp6JZ8cNxRzElJjSgllLood0kHjyoMa3oYHnvbDUVirKRSKOrCWCXSGyaxqiP3yl+iMHHeHTuMkRRYDq7qOVDBw8wBMGzOd1EDziiTJ9Uy1n9vYERNoLZ/wUp7uiceZoyhBBdxdwExNBdJs
X-Gm-Message-State: AOJu0YxRJu55GPEoSR0cfSogGTPYvRO2p/hAP/CF1gPy4+mz8T1MRuIF
	vB+jlR3WJqebubj8sflgVAiYVGTwyVe/0s6KNl2c+vZiwZKg7EVO
X-Google-Smtp-Source: AGHT+IEEmmwgIgoQbNlzSIaaKFkhbsGbkd5CbtIJYv4wDGSywn8Gpt53Dr6SbO0nA5u2nSCtpNhJ+A==
X-Received: by 2002:a17:902:e80c:b0:1dd:b883:3398 with SMTP id u12-20020a170902e80c00b001ddb8833398mr462837plg.4.1710902979704;
        Tue, 19 Mar 2024 19:49:39 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id a6-20020a170902ecc600b001dffe8a22aesm7599871plh.262.2024.03.19.19.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 19:49:39 -0700 (PDT)
Date: Wed, 20 Mar 2024 10:49:34 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Ian Rogers <irogers@google.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com,
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
	namhyung@kernel.org, akpm@linux-foundation.org, bfoster@redhat.com,
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, adrian.hunter@intel.com, jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/13] lib min_heap: Add args for min_heap_callbacks
Message-ID: <ZfpOvsD++wbwCTWO@visitorckw-System-Product-Name>
References: <20240319180005.246930-1-visitorckw@gmail.com>
 <20240319180005.246930-9-visitorckw@gmail.com>
 <CAP-5=fUk12o7u-+0u0KeUbdRDYiGzeZU0vgOrTc_3BHEntjn_Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAP-5=fUk12o7u-+0u0KeUbdRDYiGzeZU0vgOrTc_3BHEntjn_Q@mail.gmail.com>

On Tue, Mar 19, 2024 at 01:05:18PM -0700, Ian Rogers wrote:
> On Tue, Mar 19, 2024 at 11:00 AM Kuan-Wei Chiu <visitorckw@gmail.com> wrote:
> >
> > Add a third parameter 'args' for the 'less' and 'swp' functions in the
> > 'struct min_heap_callbacks'. This additional parameter allows these
> > comparison and swap functions to handle extra arguments when necessary.
> >
> > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> 
> I've no objection to this but I don't see it used in your changes -
> that may be my fault :-). Perhaps hold off or add a test with args
> being non-null?
>

The parameter will be required in the patches for bcache and bcachefs.
One is for bucket_min_cmp() and bucket_max_cmp() in
drivers/md/bcache/alloc.c, and the other is for ec_stripes_heap_swap()
in fs/bcachefs/ec.c.

Do you have any more specific suggestions for adding non-null
test cases? I'm unsure about what would be a reasonable way to include
non-null test items in testing.
> 
> > ---
> >  drivers/md/dm-vdo/repair.c     | 10 +++----
> >  drivers/md/dm-vdo/slab-depot.c |  8 +++---
> >  include/linux/min_heap.h       | 51 +++++++++++++++++-----------------
> >  kernel/events/core.c           | 10 +++----
> >  lib/test_min_heap.c            | 26 ++++++++---------
> >  5 files changed, 53 insertions(+), 52 deletions(-)
> >
> > diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
> > index 7663fa2098f4..528fa100b410 100644
> > --- a/drivers/md/dm-vdo/repair.c
> > +++ b/drivers/md/dm-vdo/repair.c
> > @@ -137,7 +137,7 @@ struct repair_completion {
> >   * to sort by slot while still ensuring we replay all entries with the same slot in the exact order
> >   * as they appeared in the journal.
> >   */
> > -static bool mapping_is_less_than(const void *item1, const void *item2)
> > +static bool mapping_is_less_than(const void *item1, const void *item2, void *args)
> >  {
> >         const struct numbered_block_mapping *mapping1 =
> >                 (const struct numbered_block_mapping *) item1;
> > @@ -156,7 +156,7 @@ static bool mapping_is_less_than(const void *item1, const void *item2)
> >         return 0;
> >  }
> >
> > -static void swap_mappings(void *item1, void *item2)
> > +static void swap_mappings(void *item1, void *item2, void *args)
> >  {
> >         struct numbered_block_mapping *mapping1 = item1;
> >         struct numbered_block_mapping *mapping2 = item2;
> > @@ -182,8 +182,8 @@ static struct numbered_block_mapping *sort_next_heap_element(struct repair_compl
> >          * restore the heap invariant, and return a pointer to the popped element.
> >          */
> >         last = &repair->entries[--heap->heap.nr];
> > -       swap_mappings(heap->heap.data, last);
> > -       min_heapify(heap, 0, &repair_min_heap);
> > +       swap_mappings(heap->heap.data, last, NULL);
> > +       min_heapify(heap, 0, &repair_min_heap, NULL);
> >         return last;
> >  }
> >
> > @@ -1121,7 +1121,7 @@ static void recover_block_map(struct vdo_completion *completion)
> >         repair->replay_heap.heap.data = repair->entries;
> >         repair->replay_heap.heap.nr = repair->block_map_entry_count;
> >         repair->replay_heap.heap.size = repair->block_map_entry_count;
> > -       min_heapify_all(&repair->replay_heap, &repair_min_heap);
> > +       min_heapify_all(&repair->replay_heap, &repair_min_heap, NULL);
> >
> >         vdo_log_info("Replaying %zu recovery entries into block map",
> >                      repair->block_map_entry_count);
> > diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
> > index 3309480170c3..b8c41d7ccde0 100644
> > --- a/drivers/md/dm-vdo/slab-depot.c
> > +++ b/drivers/md/dm-vdo/slab-depot.c
> > @@ -3288,7 +3288,7 @@ int vdo_release_block_reference(struct block_allocator *allocator,
> >   * Thus, the ordering is reversed from the usual sense since min_heap returns smaller elements
> >   * before larger ones.
> >   */
> > -static bool slab_status_is_less_than(const void *item1, const void *item2)
> > +static bool slab_status_is_less_than(const void *item1, const void *item2, void *args)
> >  {
> >         const struct slab_status *info1 = item1;
> >         const struct slab_status *info2 = item2;
> > @@ -3300,7 +3300,7 @@ static bool slab_status_is_less_than(const void *item1, const void *item2)
> >         return info1->slab_number < info2->slab_number;
> >  }
> >
> > -static void swap_slab_statuses(void *item1, void *item2)
> > +static void swap_slab_statuses(void *item1, void *item2, void *args)
> >  {
> >         struct slab_status *info1 = item1;
> >         struct slab_status *info2 = item2;
> > @@ -3523,7 +3523,7 @@ static int __must_check vdo_prepare_slabs_for_allocation(struct block_allocator
> >         heap.heap.data = slab_statuses;
> >         heap.heap.nr = allocator->slab_count;
> >         heap.heap.size = allocator->slab_count;
> > -       min_heapify_all(&heap, &slab_status_min_heap);
> > +       min_heapify_all(&heap, &slab_status_min_heap, NULL);
> >
> >         while (heap.heap.nr > 0) {
> >                 bool high_priority;
> > @@ -3531,7 +3531,7 @@ static int __must_check vdo_prepare_slabs_for_allocation(struct block_allocator
> >                 struct slab_journal *journal;
> >
> >                 current_slab_status = slab_statuses[0];
> > -               min_heap_pop(&heap, &slab_status_min_heap);
> > +               min_heap_pop(&heap, &slab_status_min_heap, NULL);
> >                 slab = depot->slabs[current_slab_status.slab_number];
> >
> >                 if ((depot->load_type == VDO_SLAB_DEPOT_REBUILD_LOAD) ||
> > diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> > index b1d874f4d536..97d8ba5c32e6 100644
> > --- a/include/linux/min_heap.h
> > +++ b/include/linux/min_heap.h
> > @@ -40,8 +40,8 @@ struct _name {                                \
> >   * @swp: Swap elements function.
> >   */
> >  struct min_heap_callbacks {
> > -       bool (*less)(const void *lhs, const void *rhs);
> > -       void (*swp)(void *lhs, void *rhs);
> > +       bool (*less)(const void *lhs, const void *rhs, void *args);
> > +       void (*swp)(void *lhs, void *rhs, void *args);
> >  };
> >
> >  /* Initialize a min-heap. */
> > @@ -79,7 +79,7 @@ bool __min_heap_full(struct __min_heap *heap)
> >  /* Sift the element at pos down the heap. */
> >  static __always_inline
> >  void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
> > -               const struct min_heap_callbacks *func)
> > +               const struct min_heap_callbacks *func, void *args)
> >  {
> >         void *left, *right;
> >         void *data = heap->data;
> > @@ -92,7 +92,7 @@ void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
> >                         break;
> >                 left = data + (i * 2 + 1) * elem_size;
> >                 right = data + (i * 2 + 2) * elem_size;
> > -               i = func->less(left, right) ? i * 2 + 1 : i * 2 + 2;
> > +               i = func->less(left, right, args) ? i * 2 + 1 : i * 2 + 2;
> >         }
> >
> >         /* Special case for the last leaf with no sibling. */
> > @@ -100,38 +100,38 @@ void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
> >                 i = i * 2 + 1;
> >
> >         /* Backtrack to the correct location. */
> > -       while (i != pos && func->less(root, data + i * elem_size))
> > +       while (i != pos && func->less(root, data + i * elem_size, args))
> >                 i = (i - 1) / 2;
> >
> >         /* Shift the element into its correct place. */
> >         j = i;
> >         while (i != pos) {
> >                 i = (i - 1) / 2;
> > -               func->swp(data + i * elem_size, data + j * elem_size);
> > +               func->swp(data + i * elem_size, data + j * elem_size, args);
> >         }
> >  }
> >
> > -#define min_heapify(_heap, _pos, _func)        \
> > -       __min_heapify(&(_heap)->heap, _pos, __minheap_obj_size(_heap), _func)
> > +#define min_heapify(_heap, _pos, _func, _args) \
> > +       __min_heapify(&(_heap)->heap, _pos, __minheap_obj_size(_heap), _func, _args)
> >
> >  /* Floyd's approach to heapification that is O(nr). */
> >  static __always_inline
> >  void __min_heapify_all(struct __min_heap *heap, size_t elem_size,
> > -               const struct min_heap_callbacks *func)
> > +               const struct min_heap_callbacks *func, void *args)
> >  {
> >         int i;
> >
> >         for (i = heap->nr / 2 - 1; i >= 0; i--)
> > -               __min_heapify(heap, i, elem_size, func);
> > +               __min_heapify(heap, i, elem_size, func, args);
> >  }
> >
> > -#define min_heapify_all(_heap, _func)  \
> > -       __min_heapify_all(&(_heap)->heap, __minheap_obj_size(_heap), _func)
> > +#define min_heapify_all(_heap, _func, _args)   \
> > +       __min_heapify_all(&(_heap)->heap, __minheap_obj_size(_heap), _func, _args)
> >
> >  /* Remove minimum element from the heap, O(log2(nr)). */
> >  static __always_inline
> >  void __min_heap_pop(struct __min_heap *heap, size_t elem_size,
> > -               const struct min_heap_callbacks *func)
> > +               const struct min_heap_callbacks *func, void *args)
> >  {
> >         void *data = heap->data;
> >
> > @@ -141,11 +141,11 @@ void __min_heap_pop(struct __min_heap *heap, size_t elem_size,
> >         /* Place last element at the root (position 0) and then sift down. */
> >         heap->nr--;
> >         memcpy(data, data + (heap->nr * elem_size), elem_size);
> > -       __min_heapify(heap, 0, elem_size, func);
> > +       __min_heapify(heap, 0, elem_size, func, args);
> >  }
> >
> > -#define min_heap_pop(_heap, _func)     \
> > -       __min_heap_pop(&(_heap)->heap, __minheap_obj_size(_heap), _func)
> > +#define min_heap_pop(_heap, _func, _args)      \
> > +       __min_heap_pop(&(_heap)->heap, __minheap_obj_size(_heap), _func, _args)
> >
> >  /*
> >   * Remove the minimum element and then push the given element. The
> > @@ -155,19 +155,20 @@ void __min_heap_pop(struct __min_heap *heap, size_t elem_size,
> >  static __always_inline
> >  void __min_heap_pop_push(struct __min_heap *heap,
> >                 const void *element, size_t elem_size,
> > -               const struct min_heap_callbacks *func)
> > +               const struct min_heap_callbacks *func,
> > +               void *args)
> >  {
> >         memcpy(heap->data, element, elem_size);
> > -       __min_heapify(heap, 0, elem_size, func);
> > +       __min_heapify(heap, 0, elem_size, func, args);
> >  }
> >
> > -#define min_heap_pop_push(_heap, _element, _func)      \
> > -       __min_heap_pop_push(&(_heap)->heap, _element, __minheap_obj_size(_heap), _func)
> > +#define min_heap_pop_push(_heap, _element, _func, _args)       \
> > +       __min_heap_pop_push(&(_heap)->heap, _element, __minheap_obj_size(_heap), _func, _args)
> >
> >  /* Push an element on to the heap, O(log2(nr)). */
> >  static __always_inline
> >  void __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_size,
> > -               const struct min_heap_callbacks *func)
> > +               const struct min_heap_callbacks *func, void *args)
> >  {
> >         void *data = heap->data;
> >         void *child, *parent;
> > @@ -185,13 +186,13 @@ void __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_s
> >         for (; pos > 0; pos = (pos - 1) / 2) {
> >                 child = data + (pos * elem_size);
> >                 parent = data + ((pos - 1) / 2) * elem_size;
> > -               if (func->less(parent, child))
> > +               if (func->less(parent, child, args))
> >                         break;
> > -               func->swp(parent, child);
> > +               func->swp(parent, child, args);
> >         }
> >  }
> >
> > -#define min_heap_push(_heap, _element, _func)  \
> > -       __min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(_heap), _func)
> > +#define min_heap_push(_heap, _element, _func, _args)   \
> > +       __min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(_heap), _func, _args)
> >
> >  #endif /* _LINUX_MIN_HEAP_H */
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index 065dfaa8b009..f2a9044058ee 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -3683,7 +3683,7 @@ void __perf_event_task_sched_out(struct task_struct *task,
> >         perf_cgroup_switch(next);
> >  }
> >
> > -static bool perf_less_group_idx(const void *l, const void *r)
> > +static bool perf_less_group_idx(const void *l, const void *r, void *args)
> >  {
> >         const struct perf_event *le = *(const struct perf_event **)l;
> >         const struct perf_event *re = *(const struct perf_event **)r;
> > @@ -3691,7 +3691,7 @@ static bool perf_less_group_idx(const void *l, const void *r)
> >         return le->group_index < re->group_index;
> >  }
> >
> > -static void swap_ptr(void *l, void *r)
> > +static void swap_ptr(void *l, void *r, void *args)
> >  {
> >         void **lp = l, **rp = r;
> >
> > @@ -3779,7 +3779,7 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
> >                 perf_assert_pmu_disabled((*evt)->pmu_ctx->pmu);
> >         }
> >
> > -       min_heapify_all(&event_heap, &perf_min_heap);
> > +       min_heapify_all(&event_heap, &perf_min_heap, NULL);
> >
> >         while (event_heap.heap.nr) {
> >                 ret = func(*evt, data);
> > @@ -3788,9 +3788,9 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
> >
> >                 *evt = perf_event_groups_next(*evt, pmu);
> >                 if (*evt)
> > -                       min_heapify(&event_heap, 0, &perf_min_heap);
> > +                       min_heapify(&event_heap, 0, &perf_min_heap, NULL);
> >                 else
> > -                       min_heap_pop(&event_heap, &perf_min_heap);
> > +                       min_heap_pop(&event_heap, &perf_min_heap, NULL);
> >         }
> >
> >         return 0;
> > diff --git a/lib/test_min_heap.c b/lib/test_min_heap.c
> > index af2e446034d8..b8859d17a19c 100644
> > --- a/lib/test_min_heap.c
> > +++ b/lib/test_min_heap.c
> > @@ -13,17 +13,17 @@
> >
> >  MIN_HEAP(int, min_heap_test);
> >
> > -static __init bool less_than(const void *lhs, const void *rhs)
> > +static __init bool less_than(const void *lhs, const void *rhs, void *args)
> >  {
> >         return *(int *)lhs < *(int *)rhs;
> >  }
> >
> > -static __init bool greater_than(const void *lhs, const void *rhs)
> > +static __init bool greater_than(const void *lhs, const void *rhs, void *args)
> >  {
> >         return *(int *)lhs > *(int *)rhs;
> >  }
> >
> > -static __init void swap_ints(void *lhs, void *rhs)
> > +static __init void swap_ints(void *lhs, void *rhs, void *argsss)
> >  {
> >         int temp = *(int *)lhs;
> >
> > @@ -40,7 +40,7 @@ static __init int pop_verify_heap(bool min_heap,
> >         int last;
> >
> >         last = values[0];
> > -       min_heap_pop(heap, funcs);
> > +       min_heap_pop(heap, funcs, NULL);
> >         while (heap->heap.nr > 0) {
> >                 if (min_heap) {
> >                         if (last > values[0]) {
> > @@ -56,7 +56,7 @@ static __init int pop_verify_heap(bool min_heap,
> >                         }
> >                 }
> >                 last = values[0];
> > -               min_heap_pop(heap, funcs);
> > +               min_heap_pop(heap, funcs, NULL);
> >         }
> >         return err;
> >  }
> > @@ -77,7 +77,7 @@ static __init int test_heapify_all(bool min_heap)
> >         int i, err;
> >
> >         /* Test with known set of values. */
> > -       min_heapify_all(&heap, &funcs);
> > +       min_heapify_all(&heap, &funcs, NULL);
> >         err = pop_verify_heap(min_heap, &heap, &funcs);
> >
> >
> > @@ -86,7 +86,7 @@ static __init int test_heapify_all(bool min_heap)
> >         for (i = 0; i < heap.heap.nr; i++)
> >                 values[i] = get_random_u32();
> >
> > -       min_heapify_all(&heap, &funcs);
> > +       min_heapify_all(&heap, &funcs, NULL);
> >         err += pop_verify_heap(min_heap, &heap, &funcs);
> >
> >         return err;
> > @@ -110,14 +110,14 @@ static __init int test_heap_push(bool min_heap)
> >
> >         /* Test with known set of values copied from data. */
> >         for (i = 0; i < ARRAY_SIZE(data); i++)
> > -               min_heap_push(&heap, &data[i], &funcs);
> > +               min_heap_push(&heap, &data[i], &funcs, NULL);
> >
> >         err = pop_verify_heap(min_heap, &heap, &funcs);
> >
> >         /* Test with randomly generated values. */
> >         while (heap.heap.nr < heap.heap.size) {
> >                 temp = get_random_u32();
> > -               min_heap_push(&heap, &temp, &funcs);
> > +               min_heap_push(&heap, &temp, &funcs, NULL);
> >         }
> >         err += pop_verify_heap(min_heap, &heap, &funcs);
> >
> > @@ -143,22 +143,22 @@ static __init int test_heap_pop_push(bool min_heap)
> >         /* Fill values with data to pop and replace. */
> >         temp = min_heap ? 0x80000000 : 0x7FFFFFFF;
> >         for (i = 0; i < ARRAY_SIZE(data); i++)
> > -               min_heap_push(&heap, &temp, &funcs);
> > +               min_heap_push(&heap, &temp, &funcs, NULL);
> >
> >         /* Test with known set of values copied from data. */
> >         for (i = 0; i < ARRAY_SIZE(data); i++)
> > -               min_heap_pop_push(&heap, &data[i], &funcs);
> > +               min_heap_pop_push(&heap, &data[i], &funcs, NULL);
> >
> >         err = pop_verify_heap(min_heap, &heap, &funcs);
> >
> >         heap.heap.nr = 0;
> >         for (i = 0; i < ARRAY_SIZE(data); i++)
> > -               min_heap_push(&heap, &temp, &funcs);
> > +               min_heap_push(&heap, &temp, &funcs, NULL);
> >
> >         /* Test with randomly generated values. */
> >         for (i = 0; i < ARRAY_SIZE(data); i++) {
> >                 temp = get_random_u32();
> > -               min_heap_pop_push(&heap, &temp, &funcs);
> > +               min_heap_pop_push(&heap, &temp, &funcs, NULL);
> >         }
> >         err += pop_verify_heap(min_heap, &heap, &funcs);
> >
> > --
> > 2.34.1
> >

