Return-Path: <linux-bcache+bounces-355-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A27C18858C2
	for <lists+linux-bcache@lfdr.de>; Thu, 21 Mar 2024 13:04:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61261281918
	for <lists+linux-bcache@lfdr.de>; Thu, 21 Mar 2024 12:04:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44DB575809;
	Thu, 21 Mar 2024 12:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eCp6ELKp"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1EF59151;
	Thu, 21 Mar 2024 12:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711022677; cv=none; b=uUDj6g8z9GeYlGZu+UgVWtUAvPGV7wquU7cB7ET9IsCJBOpC+Rnbwtv78i4mYTO7FXVGJj6WZzqYzkttpa1umuDhmPDV3o1LKhgzKXPFjJ+NobAs9Hbh3Qi0BnIuGnsYvOJ4COnbcwiWVaUjdDGXDn5aAVgtKm6K5HVPLJ4iEiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711022677; c=relaxed/simple;
	bh=TX+in0K1hIva3e0RoskQ0JOU9bglMbaCy9xcNuMPlaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NxeBuv8WjyHSJll1SJ+NuJQ/ZWKAye9YI5/oJccxktexzKAljXpZyPGe5jYW4meqkSJkM/d/OVzClEQdeEzmN/zFEjCr2U6UEKThmCLZebLwOUBGj2w0EXGQWZF/maveMuWsg9i/76evY5ihH9OC+ZocbnQBVM/w/oJZjb8aXAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eCp6ELKp; arc=none smtp.client-ip=209.85.222.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-7de27c9e68dso138071241.0;
        Thu, 21 Mar 2024 05:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711022674; x=1711627474; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YZRFrQklSkv20MN8ktPNAHQP5AvV2olfj2T2rJpQo1I=;
        b=eCp6ELKpmGufDr/6AaTf8U+dqPqVVu3+FhKE8LWdUQmkNskaQ2YUJmjUIHFQhxxRB9
         TjDkkU+Mgj6VTWDNzaiKrsJnQ38TWPL2DggUNhnt921PTaSHTSvdkZFOkrqxjsCMeDFq
         Ltx6JcaKDeEYOLMggctWZEbPiu5UQYBNUeDqUxdjpGZniY0G7rOhTm7pm+CE2Gao+EsS
         gwtmjTvDc4u/JNfXOEjfKDh/c+oQyYUYnvPeTSEDVvck9FgMrVDORfHCB1iOoPFKWwNX
         53oBwLupiJvuTjrs55gmDniUj3cC6pABOeB1m4gP9jXuM1Gq/hYHah5E+NrnggdC/Cfv
         e6Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711022674; x=1711627474;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YZRFrQklSkv20MN8ktPNAHQP5AvV2olfj2T2rJpQo1I=;
        b=LsrlPBpBnFwItf3D10RADsiuHuvomqSn4HXc0IkIum7uB8l4cq7NOsmoss/eniKIn+
         6yQue1+hOYcROhD3rHHEi8GCj2PpsfOg17N2Mzs4GYYb4U5nxmgsrRiPdGv+xh5zyDqu
         cDPPCRU4qb2QMgsK1cESogOtrVNxorC3RZd9eyRIbMU6TsXC/cAb2Rg6KNS41RFN97mb
         oegR2tqgXkxuRXIc28EQ4F2GJCZ2W4G+GLarJMrBx1OGW+r0wCjCJM9KmsxmAsG8uko8
         3pbcQT1UCJMKAR6R8GNdr20j98WkYQvrvYErXfraiyh9hdypHRf2Xh6wXKC5sZweLDgG
         1BHw==
X-Forwarded-Encrypted: i=1; AJvYcCXKdJ+zrAC8F/E49vg2R/rLXKJWXbtsxt6JPTzvmvQpI/HzrY2HVtnuKGtS9jUV7LXZAd8SKiYdK7dNLvTDJHlv9EZmth9jIdZXtAD+ItQ9/G5+cs0FUy4wRTVvGegXagXdlufaQeA/0a0Q0oyMoKsj+2wvRSx4p59W/PKs3AP6M/JuJuoS31sVqulyOu2+Z6skD0KEojI7kD3sN+aVTtvZRfVsWMZTgEwYq+f5
X-Gm-Message-State: AOJu0YwjS4OHEMugBDqOYMcmUWftqmbi91g/4LhsmXHka+22cjbYm50C
	+4SLuw2UkZUNQZ+Lw7hygq0Jn8HwbqR21qqN43dAPPqjQmLWknYpTZTbLePFzz0=
X-Google-Smtp-Source: AGHT+IH0UXq60lII4YQ6oIMqqe9KHTxUmMp4huf7E4QHb7hzveOaw7llPoVIvJhm91G1bY56ZMoDYA==
X-Received: by 2002:a05:6a21:3283:b0:1a3:5f13:e447 with SMTP id yt3-20020a056a21328300b001a35f13e447mr4651895pzb.0.1711022273084;
        Thu, 21 Mar 2024 04:57:53 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id r11-20020aa7844b000000b006e65d676d3dsm13811835pfn.18.2024.03.21.04.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 04:57:52 -0700 (PDT)
Date: Thu, 21 Mar 2024 19:57:47 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: colyli@suse.de, msakai@redhat.com, peterz@infradead.org,
	mingo@redhat.com, acme@kernel.org, namhyung@kernel.org,
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com, jserv@ccns.ncku.edu.tw,
	dm-devel@lists.linux.dev, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v2 04/15] lib min_heap: Add type safe interface
Message-ID: <Zfwgu8+IeH/YqWYR@visitorckw-System-Product-Name>
References: <20240320145417.336208-1-visitorckw@gmail.com>
 <20240320145417.336208-5-visitorckw@gmail.com>
 <iz6wl3twuc72txd4ifxy73bbbfijo3ecy7izw3drsmcb2payeu@b2dusfoqobgu>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <iz6wl3twuc72txd4ifxy73bbbfijo3ecy7izw3drsmcb2payeu@b2dusfoqobgu>

On Wed, Mar 20, 2024 at 04:56:57PM -0400, Kent Overstreet wrote:
> On Wed, Mar 20, 2024 at 10:54:06PM +0800, Kuan-Wei Chiu wrote:
> > Introduce a type-safe interface for min_heap by adding small macro
> > wrappers around functions and using a 0-size array to store type
> > information. This enables the use of __minheap_cast and
> > __minheap_obj_size macros for type casting and obtaining element size.
> > The implementation draws inspiration from generic-radix-tree.h,
> > eliminating the need to pass element size in min_heap_callbacks.
> 
> let's avoid the heap->heap.nr - darray (fs/bcachefs/darray.h) has a
> trick for that. All heaps have the same memory layout, so we can just
> cast to a void pointer heap to get something the C code can use.
>
If I understand correctly, you're suggesting adding APIs similar to
darray_top(), darray_first(), and darray_last() within min_heap and
having them return a pointer. However, some users are using heap.nr in
conditional statements instead of utilizing heap.nr for memory
operations, so returning pointers may not be as convenient. What about
adding get and set functions for nr instead?

Regards,
Kuan-Wei

> > 
> > Link: https://lkml.kernel.org/ioyfizrzq7w7mjrqcadtzsfgpuntowtjdw5pgn4qhvsdp4mqqg@nrlek5vmisbu
> > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > Reviewed-by: Ian Rogers <irogers@google.com>
> > ---
> >  drivers/md/dm-vdo/repair.c     | 21 +++++-----
> >  drivers/md/dm-vdo/slab-depot.c | 13 +++---
> >  include/linux/min_heap.h       | 75 +++++++++++++++++++++++-----------
> >  kernel/events/core.c           | 35 ++++++++--------
> >  lib/test_min_heap.c            | 49 +++++++++++-----------
> >  5 files changed, 107 insertions(+), 86 deletions(-)
> > 
> > diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
> > index defc9359f10e..7663fa2098f4 100644
> > --- a/drivers/md/dm-vdo/repair.c
> > +++ b/drivers/md/dm-vdo/repair.c
> > @@ -51,6 +51,8 @@ struct recovery_point {
> >  	bool increment_applied;
> >  };
> >  
> > +MIN_HEAP(struct numbered_block_mapping *, replay_heap);
> > +
> >  struct repair_completion {
> >  	/* The completion header */
> >  	struct vdo_completion completion;
> > @@ -97,7 +99,7 @@ struct repair_completion {
> >  	 * order, then original journal order. This permits efficient iteration over the journal
> >  	 * entries in order.
> >  	 */
> > -	struct min_heap replay_heap;
> > +	struct replay_heap replay_heap;
> >  	/* Fields tracking progress through the journal entries. */
> >  	struct numbered_block_mapping *current_entry;
> >  	struct numbered_block_mapping *current_unfetched_entry;
> > @@ -163,25 +165,24 @@ static void swap_mappings(void *item1, void *item2)
> >  }
> >  
> >  static const struct min_heap_callbacks repair_min_heap = {
> > -	.elem_size = sizeof(struct numbered_block_mapping),
> >  	.less = mapping_is_less_than,
> >  	.swp = swap_mappings,
> >  };
> >  
> >  static struct numbered_block_mapping *sort_next_heap_element(struct repair_completion *repair)
> >  {
> > -	struct min_heap *heap = &repair->replay_heap;
> > +	struct replay_heap *heap = &repair->replay_heap;
> >  	struct numbered_block_mapping *last;
> >  
> > -	if (heap->nr == 0)
> > +	if (heap->heap.nr == 0)
> >  		return NULL;
> >  
> >  	/*
> >  	 * Swap the next heap element with the last one on the heap, popping it off the heap,
> >  	 * restore the heap invariant, and return a pointer to the popped element.
> >  	 */
> > -	last = &repair->entries[--heap->nr];
> > -	swap_mappings(heap->data, last);
> > +	last = &repair->entries[--heap->heap.nr];
> > +	swap_mappings(heap->heap.data, last);
> >  	min_heapify(heap, 0, &repair_min_heap);
> >  	return last;
> >  }
> > @@ -1117,11 +1118,9 @@ static void recover_block_map(struct vdo_completion *completion)
> >  	 * Organize the journal entries into a binary heap so we can iterate over them in sorted
> >  	 * order incrementally, avoiding an expensive sort call.
> >  	 */
> > -	repair->replay_heap = (struct min_heap) {
> > -		.data = repair->entries,
> > -		.nr = repair->block_map_entry_count,
> > -		.size = repair->block_map_entry_count,
> > -	};
> > +	repair->replay_heap.heap.data = repair->entries;
> > +	repair->replay_heap.heap.nr = repair->block_map_entry_count;
> > +	repair->replay_heap.heap.size = repair->block_map_entry_count;
> >  	min_heapify_all(&repair->replay_heap, &repair_min_heap);
> >  
> >  	vdo_log_info("Replaying %zu recovery entries into block map",
> > diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
> > index 46e4721e5b4f..3309480170c3 100644
> > --- a/drivers/md/dm-vdo/slab-depot.c
> > +++ b/drivers/md/dm-vdo/slab-depot.c
> > @@ -3309,7 +3309,6 @@ static void swap_slab_statuses(void *item1, void *item2)
> >  }
> >  
> >  static const struct min_heap_callbacks slab_status_min_heap = {
> > -	.elem_size = sizeof(struct slab_status),
> >  	.less = slab_status_is_less_than,
> >  	.swp = swap_slab_statuses,
> >  };
> > @@ -3509,7 +3508,7 @@ static int get_slab_statuses(struct block_allocator *allocator,
> >  static int __must_check vdo_prepare_slabs_for_allocation(struct block_allocator *allocator)
> >  {
> >  	struct slab_status current_slab_status;
> > -	struct min_heap heap;
> > +	MIN_HEAP(struct slab_status *, heap) heap;
> >  	int result;
> >  	struct slab_status *slab_statuses;
> >  	struct slab_depot *depot = allocator->depot;
> > @@ -3521,14 +3520,12 @@ static int __must_check vdo_prepare_slabs_for_allocation(struct block_allocator
> >  		return result;
> >  
> >  	/* Sort the slabs by cleanliness, then by emptiness hint. */
> > -	heap = (struct min_heap) {
> > -		.data = slab_statuses,
> > -		.nr = allocator->slab_count,
> > -		.size = allocator->slab_count,
> > -	};
> > +	heap.heap.data = slab_statuses;
> > +	heap.heap.nr = allocator->slab_count;
> > +	heap.heap.size = allocator->slab_count;
> >  	min_heapify_all(&heap, &slab_status_min_heap);
> >  
> > -	while (heap.nr > 0) {
> > +	while (heap.heap.nr > 0) {
> >  		bool high_priority;
> >  		struct vdo_slab *slab;
> >  		struct slab_journal *journal;
> > diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> > index d52daf45861b..c3635a7fdb88 100644
> > --- a/include/linux/min_heap.h
> > +++ b/include/linux/min_heap.h
> > @@ -7,45 +7,59 @@
> >  #include <linux/types.h>
> >  
> >  /**
> > - * struct min_heap - Data structure to hold a min-heap.
> > + * struct __min_heap - Data structure to hold a min-heap.
> >   * @data: Start of array holding the heap elements.
> >   * @nr: Number of elements currently in the heap.
> >   * @size: Maximum number of elements that can be held in current storage.
> >   */
> > -struct min_heap {
> > +struct __min_heap {
> >  	void *data;
> >  	int nr;
> >  	int size;
> >  };
> >  
> > +/*
> > + * We use a 0 size array to stash the type we're storing without taking any
> > + * space at runtime - then the various accessor macros can use typeof() to get
> > + * to it for casts/sizeof - we also force the alignment so that storing a type
> > + * with a ridiculous alignment doesn't blow up the alignment or size of the
> > + * min_heap.
> > + */
> > +#define MIN_HEAP(_type, _name)			\
> > +struct _name {				\
> > +	struct __min_heap	heap;		\
> > +	_type type[0] __aligned(1);	\
> > +}
> > +
> > +#define __minheap_cast(_heap)		(typeof((_heap)->type[0]) *)
> > +#define __minheap_obj_size(_heap)	sizeof((_heap)->type[0])
> > +
> >  /**
> >   * struct min_heap_callbacks - Data/functions to customise the min_heap.
> > - * @elem_size: The nr of each element in bytes.
> >   * @less: Partial order function for this heap.
> >   * @swp: Swap elements function.
> >   */
> >  struct min_heap_callbacks {
> > -	int elem_size;
> >  	bool (*less)(const void *lhs, const void *rhs);
> >  	void (*swp)(void *lhs, void *rhs);
> >  };
> >  
> >  /* Sift the element at pos down the heap. */
> >  static __always_inline
> > -void min_heapify(struct min_heap *heap, int pos,
> > +void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
> >  		const struct min_heap_callbacks *func)
> >  {
> >  	void *left, *right;
> >  	void *data = heap->data;
> > -	void *root = data + pos * func->elem_size;
> > +	void *root = data + pos * elem_size;
> >  	int i = pos, j;
> >  
> >  	/* Find the sift-down path all the way to the leaves. */
> >  	for (;;) {
> >  		if (i * 2 + 2 >= heap->nr)
> >  			break;
> > -		left = data + (i * 2 + 1) * func->elem_size;
> > -		right = data + (i * 2 + 2) * func->elem_size;
> > +		left = data + (i * 2 + 1) * elem_size;
> > +		right = data + (i * 2 + 2) * elem_size;
> >  		i = func->less(left, right) ? i * 2 + 1 : i * 2 + 2;
> >  	}
> >  
> > @@ -54,31 +68,37 @@ void min_heapify(struct min_heap *heap, int pos,
> >  		i = i * 2 + 1;
> >  
> >  	/* Backtrack to the correct location. */
> > -	while (i != pos && func->less(root, data + i * func->elem_size))
> > +	while (i != pos && func->less(root, data + i * elem_size))
> >  		i = (i - 1) / 2;
> >  
> >  	/* Shift the element into its correct place. */
> >  	j = i;
> >  	while (i != pos) {
> >  		i = (i - 1) / 2;
> > -		func->swp(data + i * func->elem_size, data + j * func->elem_size);
> > +		func->swp(data + i * elem_size, data + j * elem_size);
> >  	}
> >  }
> >  
> > +#define min_heapify(_heap, _pos, _func)	\
> > +	__min_heapify(&(_heap)->heap, _pos, __minheap_obj_size(_heap), _func)
> > +
> >  /* Floyd's approach to heapification that is O(nr). */
> >  static __always_inline
> > -void min_heapify_all(struct min_heap *heap,
> > +void __min_heapify_all(struct __min_heap *heap, size_t elem_size,
> >  		const struct min_heap_callbacks *func)
> >  {
> >  	int i;
> >  
> >  	for (i = heap->nr / 2 - 1; i >= 0; i--)
> > -		min_heapify(heap, i, func);
> > +		__min_heapify(heap, i, elem_size, func);
> >  }
> >  
> > +#define min_heapify_all(_heap, _func)	\
> > +	__min_heapify_all(&(_heap)->heap, __minheap_obj_size(_heap), _func)
> > +
> >  /* Remove minimum element from the heap, O(log2(nr)). */
> >  static __always_inline
> > -void min_heap_pop(struct min_heap *heap,
> > +void __min_heap_pop(struct __min_heap *heap, size_t elem_size,
> >  		const struct min_heap_callbacks *func)
> >  {
> >  	void *data = heap->data;
> > @@ -88,27 +108,33 @@ void min_heap_pop(struct min_heap *heap,
> >  
> >  	/* Place last element at the root (position 0) and then sift down. */
> >  	heap->nr--;
> > -	memcpy(data, data + (heap->nr * func->elem_size), func->elem_size);
> > -	min_heapify(heap, 0, func);
> > +	memcpy(data, data + (heap->nr * elem_size), elem_size);
> > +	__min_heapify(heap, 0, elem_size, func);
> >  }
> >  
> > +#define min_heap_pop(_heap, _func)	\
> > +	__min_heap_pop(&(_heap)->heap, __minheap_obj_size(_heap), _func)
> > +
> >  /*
> >   * Remove the minimum element and then push the given element. The
> >   * implementation performs 1 sift (O(log2(nr))) and is therefore more
> >   * efficient than a pop followed by a push that does 2.
> >   */
> >  static __always_inline
> > -void min_heap_pop_push(struct min_heap *heap,
> > -		const void *element,
> > +void __min_heap_pop_push(struct __min_heap *heap,
> > +		const void *element, size_t elem_size,
> >  		const struct min_heap_callbacks *func)
> >  {
> > -	memcpy(heap->data, element, func->elem_size);
> > -	min_heapify(heap, 0, func);
> > +	memcpy(heap->data, element, elem_size);
> > +	__min_heapify(heap, 0, elem_size, func);
> >  }
> >  
> > +#define min_heap_pop_push(_heap, _element, _func)	\
> > +	__min_heap_pop_push(&(_heap)->heap, _element, __minheap_obj_size(_heap), _func)
> > +
> >  /* Push an element on to the heap, O(log2(nr)). */
> >  static __always_inline
> > -void min_heap_push(struct min_heap *heap, const void *element,
> > +void __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_size,
> >  		const struct min_heap_callbacks *func)
> >  {
> >  	void *data = heap->data;
> > @@ -120,17 +146,20 @@ void min_heap_push(struct min_heap *heap, const void *element,
> >  
> >  	/* Place at the end of data. */
> >  	pos = heap->nr;
> > -	memcpy(data + (pos * func->elem_size), element, func->elem_size);
> > +	memcpy(data + (pos * elem_size), element, elem_size);
> >  	heap->nr++;
> >  
> >  	/* Sift child at pos up. */
> >  	for (; pos > 0; pos = (pos - 1) / 2) {
> > -		child = data + (pos * func->elem_size);
> > -		parent = data + ((pos - 1) / 2) * func->elem_size;
> > +		child = data + (pos * elem_size);
> > +		parent = data + ((pos - 1) / 2) * elem_size;
> >  		if (func->less(parent, child))
> >  			break;
> >  		func->swp(parent, child);
> >  	}
> >  }
> >  
> > +#define min_heap_push(_heap, _element, _func)	\
> > +	__min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(_heap), _func)
> > +
> >  #endif /* _LINUX_MIN_HEAP_H */
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index 10ac2db83f14..065dfaa8b009 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -3698,19 +3698,20 @@ static void swap_ptr(void *l, void *r)
> >  	swap(*lp, *rp);
> >  }
> >  
> > +MIN_HEAP(struct perf_event *, perf_event_min_heap);
> > +
> >  static const struct min_heap_callbacks perf_min_heap = {
> > -	.elem_size = sizeof(struct perf_event *),
> >  	.less = perf_less_group_idx,
> >  	.swp = swap_ptr,
> >  };
> >  
> > -static void __heap_add(struct min_heap *heap, struct perf_event *event)
> > +static void __heap_add(struct perf_event_min_heap *heap, struct perf_event *event)
> >  {
> > -	struct perf_event **itrs = heap->data;
> > +	struct perf_event **itrs = heap->heap.data;
> >  
> >  	if (event) {
> > -		itrs[heap->nr] = event;
> > -		heap->nr++;
> > +		itrs[heap->heap.nr] = event;
> > +		heap->heap.nr++;
> >  	}
> >  }
> >  
> > @@ -3738,7 +3739,7 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
> >  	struct perf_cpu_context *cpuctx = NULL;
> >  	/* Space for per CPU and/or any CPU event iterators. */
> >  	struct perf_event *itrs[2];
> > -	struct min_heap event_heap;
> > +	struct perf_event_min_heap event_heap;
> >  	struct perf_event **evt;
> >  	int ret;
> >  
> > @@ -3747,11 +3748,9 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
> >  
> >  	if (!ctx->task) {
> >  		cpuctx = this_cpu_ptr(&perf_cpu_context);
> > -		event_heap = (struct min_heap){
> > -			.data = cpuctx->heap,
> > -			.nr = 0,
> > -			.size = cpuctx->heap_size,
> > -		};
> > +		event_heap.heap.data = cpuctx->heap;
> > +		event_heap.heap.nr = 0;
> > +		event_heap.heap.size = cpuctx->heap_size;
> >  
> >  		lockdep_assert_held(&cpuctx->ctx.lock);
> >  
> > @@ -3760,15 +3759,13 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
> >  			css = &cpuctx->cgrp->css;
> >  #endif
> >  	} else {
> > -		event_heap = (struct min_heap){
> > -			.data = itrs,
> > -			.nr = 0,
> > -			.size = ARRAY_SIZE(itrs),
> > -		};
> > +		event_heap.heap.data = itrs;
> > +		event_heap.heap.nr = 0;
> > +		event_heap.heap.size = ARRAY_SIZE(itrs);
> >  		/* Events not within a CPU context may be on any CPU. */
> >  		__heap_add(&event_heap, perf_event_groups_first(groups, -1, pmu, NULL));
> >  	}
> > -	evt = event_heap.data;
> > +	evt = event_heap.heap.data;
> >  
> >  	__heap_add(&event_heap, perf_event_groups_first(groups, cpu, pmu, NULL));
> >  
> > @@ -3777,14 +3774,14 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
> >  		__heap_add(&event_heap, perf_event_groups_first(groups, cpu, pmu, css->cgroup));
> >  #endif
> >  
> > -	if (event_heap.nr) {
> > +	if (event_heap.heap.nr) {
> >  		__link_epc((*evt)->pmu_ctx);
> >  		perf_assert_pmu_disabled((*evt)->pmu_ctx->pmu);
> >  	}
> >  
> >  	min_heapify_all(&event_heap, &perf_min_heap);
> >  
> > -	while (event_heap.nr) {
> > +	while (event_heap.heap.nr) {
> >  		ret = func(*evt, data);
> >  		if (ret)
> >  			return ret;
> > diff --git a/lib/test_min_heap.c b/lib/test_min_heap.c
> > index 7b01b4387cfb..af2e446034d8 100644
> > --- a/lib/test_min_heap.c
> > +++ b/lib/test_min_heap.c
> > @@ -11,6 +11,8 @@
> >  #include <linux/printk.h>
> >  #include <linux/random.h>
> >  
> > +MIN_HEAP(int, min_heap_test);
> > +
> >  static __init bool less_than(const void *lhs, const void *rhs)
> >  {
> >  	return *(int *)lhs < *(int *)rhs;
> > @@ -30,16 +32,16 @@ static __init void swap_ints(void *lhs, void *rhs)
> >  }
> >  
> >  static __init int pop_verify_heap(bool min_heap,
> > -				struct min_heap *heap,
> > +				struct min_heap_test *heap,
> >  				const struct min_heap_callbacks *funcs)
> >  {
> > -	int *values = heap->data;
> > +	int *values = heap->heap.data;
> >  	int err = 0;
> >  	int last;
> >  
> >  	last = values[0];
> >  	min_heap_pop(heap, funcs);
> > -	while (heap->nr > 0) {
> > +	while (heap->heap.nr > 0) {
> >  		if (min_heap) {
> >  			if (last > values[0]) {
> >  				pr_err("error: expected %d <= %d\n", last,
> > @@ -63,13 +65,12 @@ static __init int test_heapify_all(bool min_heap)
> >  {
> >  	int values[] = { 3, 1, 2, 4, 0x8000000, 0x7FFFFFF, 0,
> >  			 -3, -1, -2, -4, 0x8000000, 0x7FFFFFF };
> > -	struct min_heap heap = {
> > -		.data = values,
> > -		.nr = ARRAY_SIZE(values),
> > -		.size =  ARRAY_SIZE(values),
> > -	};
> > +	struct min_heap_test heap;
> > +
> > +	heap.heap.data = values;
> > +	heap.heap.nr = ARRAY_SIZE(values);
> > +	heap.heap.size =  ARRAY_SIZE(values);
> >  	struct min_heap_callbacks funcs = {
> > -		.elem_size = sizeof(int),
> >  		.less = min_heap ? less_than : greater_than,
> >  		.swp = swap_ints,
> >  	};
> > @@ -81,8 +82,8 @@ static __init int test_heapify_all(bool min_heap)
> >  
> >  
> >  	/* Test with randomly generated values. */
> > -	heap.nr = ARRAY_SIZE(values);
> > -	for (i = 0; i < heap.nr; i++)
> > +	heap.heap.nr = ARRAY_SIZE(values);
> > +	for (i = 0; i < heap.heap.nr; i++)
> >  		values[i] = get_random_u32();
> >  
> >  	min_heapify_all(&heap, &funcs);
> > @@ -96,13 +97,12 @@ static __init int test_heap_push(bool min_heap)
> >  	const int data[] = { 3, 1, 2, 4, 0x80000000, 0x7FFFFFFF, 0,
> >  			     -3, -1, -2, -4, 0x80000000, 0x7FFFFFFF };
> >  	int values[ARRAY_SIZE(data)];
> > -	struct min_heap heap = {
> > -		.data = values,
> > -		.nr = 0,
> > -		.size =  ARRAY_SIZE(values),
> > -	};
> > +	struct min_heap_test heap;
> > +
> > +	heap.heap.data = values;
> > +	heap.heap.nr = 0;
> > +	heap.heap.size =  ARRAY_SIZE(values);
> >  	struct min_heap_callbacks funcs = {
> > -		.elem_size = sizeof(int),
> >  		.less = min_heap ? less_than : greater_than,
> >  		.swp = swap_ints,
> >  	};
> > @@ -115,7 +115,7 @@ static __init int test_heap_push(bool min_heap)
> >  	err = pop_verify_heap(min_heap, &heap, &funcs);
> >  
> >  	/* Test with randomly generated values. */
> > -	while (heap.nr < heap.size) {
> > +	while (heap.heap.nr < heap.heap.size) {
> >  		temp = get_random_u32();
> >  		min_heap_push(&heap, &temp, &funcs);
> >  	}
> > @@ -129,13 +129,12 @@ static __init int test_heap_pop_push(bool min_heap)
> >  	const int data[] = { 3, 1, 2, 4, 0x80000000, 0x7FFFFFFF, 0,
> >  			     -3, -1, -2, -4, 0x80000000, 0x7FFFFFFF };
> >  	int values[ARRAY_SIZE(data)];
> > -	struct min_heap heap = {
> > -		.data = values,
> > -		.nr = 0,
> > -		.size =  ARRAY_SIZE(values),
> > -	};
> > +	struct min_heap_test heap;
> > +
> > +	heap.heap.data = values;
> > +	heap.heap.nr = 0;
> > +	heap.heap.size =  ARRAY_SIZE(values);
> >  	struct min_heap_callbacks funcs = {
> > -		.elem_size = sizeof(int),
> >  		.less = min_heap ? less_than : greater_than,
> >  		.swp = swap_ints,
> >  	};
> > @@ -152,7 +151,7 @@ static __init int test_heap_pop_push(bool min_heap)
> >  
> >  	err = pop_verify_heap(min_heap, &heap, &funcs);
> >  
> > -	heap.nr = 0;
> > +	heap.heap.nr = 0;
> >  	for (i = 0; i < ARRAY_SIZE(data); i++)
> >  		min_heap_push(&heap, &temp, &funcs);
> >  
> > -- 
> > 2.34.1
> > 

