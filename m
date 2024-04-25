Return-Path: <linux-bcache+bounces-413-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 986838B23DB
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 16:22:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D83E28333A
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 14:22:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE79A14A0BE;
	Thu, 25 Apr 2024 14:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hdBShEoW"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2F714EC65;
	Thu, 25 Apr 2024 14:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714054754; cv=none; b=Pr48R2ZRh7OEYJFl6tzM6ns+q9K2Pa/PsedC4oeUgqljo2741uTObOHMbERd28ddib1Vu0eJrLWDL7/ralGyQeNC3+IoyJJsOleKJwWKFUUThL0cIrg9cBPr2S+FjHQ/N+G+4ghGqM8lgGsm0YwQ67gL1Q4dYPceq5E3YyjWUbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714054754; c=relaxed/simple;
	bh=00KH2f809CEXeklo+9a6PeGPW2v5ORHI9eZgRU7gLTQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O0z+JBfCtw8sXoPehDNAjKLM/uXWYYz76l+qD39PknDTDcJYHLJhp4TN63LS+tl/ujd3AYC+hsOmj//gO7xN5KC6s0NyS1z/SBuFNH0il9zvt42zVjS2Bfbb7GiLhgy1OrcyLnYrLlm4d3P0jW3S68JZUxbe7kDcuN/0jnluy4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hdBShEoW; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2ab936993abso275466a91.3;
        Thu, 25 Apr 2024 07:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714054751; x=1714659551; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G2ZkCe3L0WTN4eDU8EG8GGd4mOKJnXr9AQ1ChGE8nos=;
        b=hdBShEoWirBfAQkgVWGv2Wc7Ja4849iPrNYjP0TMRF5Ow7SDT5/1zY4DvU4KM8Ny8A
         zYZ4Kyqp4L1vMPvlA12mxmlbCufe8/sLHe+Oraiy3B61O0I2IpY+UP7F0fFgABg34+Yh
         SRDR3HSP0qAdVUSkcmQlhb+7cByKiE7Y5D/vfeNOuC7f+NjAXMlhtFUOYg47LRgNrkh9
         QeRYcf+01x2DTIk6cQO4XYlO5r7eFve1D5wWZXBeQ28iB46D2q5Az8rdVXLyN9p0fbP7
         GT/HqTxJYKrJb0V7Am3F5rjb44Af63/2tas0UDQttmPkphWW4olukru6YA8Vybrmlm/F
         NCaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714054752; x=1714659552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G2ZkCe3L0WTN4eDU8EG8GGd4mOKJnXr9AQ1ChGE8nos=;
        b=A7bGqzjw7CEJr1ZyvS+UkxhXJukPqUjnF4dOCnPYwAIkRz2v2R4b5NefO9izT+dnB/
         Ka5V6nkNmNrGRDwE1I7JZzYGLF72VeWrcBWly2EKKU7+vzPgFTat+0jsotn+l/syOuQp
         LyPgUcOrUOhfFD5nf04d5GZ0/zIH8ThFn8sN7Eb2MbX/ybVoJ8S6htgp61iLVsP3TxwN
         uBc2H19czmWqcfzOmpy9q/CW3+wcwyRAuz0dbdFxxjau55PQKP25SOvEtEFBO4HActmm
         obU10/wKabDINEAiB+ddlW8du4s75DmeN4r3oVMZX7V8IBJN8cY8ZKqz/VlcoKI6+WLl
         kR3w==
X-Forwarded-Encrypted: i=1; AJvYcCW6DKyGmYp5LWUOsu5mS8PYs/XT6dcnsklICwo7RlTyo6y4dNGy7HIaq2sPzqKWnczhkpjYaeGwZpnLDz3BfnrepVHnHrLvbrm4tpxK4edL0P1EXWHGVg6tL7rqxvbf4ZEZ659AcmoXuA6VqaBxawTo7LJXBYyTtQXfIE23ebwmKCFgHlZxVxgcIqHFE/uyILUzsjAYgsEUTJPHi4hSd7Z8sJOn2cFxsnW44oKE
X-Gm-Message-State: AOJu0YzMVuiPAoMQ21Uh8beNkpZ6SZu1UNzoZWZKvkWCqV/xtJ7VbClg
	Zkn0GndHQpmTwBjfRqcF8ToK20cnOaQLqvSvZVrm6Ayw4FijlyJ/
X-Google-Smtp-Source: AGHT+IFweNbsshiPfGQ561gGsKZAQ2sChKP/jXB6OKLQJfo+kJel1hX0+ot0R9ZMnWRynP0ZAN/e7w==
X-Received: by 2002:a62:840b:0:b0:6ea:8604:cb1d with SMTP id k11-20020a62840b000000b006ea8604cb1dmr6892127pfd.0.1714054751538;
        Thu, 25 Apr 2024 07:19:11 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id go20-20020a056a003b1400b006e6233563cesm13162397pfb.218.2024.04.25.07.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 07:19:11 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: colyli@suse.de,
	kent.overstreet@linux.dev,
	msakai@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	akpm@linux-foundation.org
Cc: bfoster@redhat.com,
	mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH v4 08/16] lib min_heap: Add args for min_heap_callbacks
Date: Thu, 25 Apr 2024 22:18:18 +0800
Message-Id: <20240425141826.840077-9-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240425141826.840077-1-visitorckw@gmail.com>
References: <20240425141826.840077-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a third parameter 'args' for the 'less' and 'swp' functions in the
'struct min_heap_callbacks'. This additional parameter allows these
comparison and swap functions to handle extra arguments when necessary.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 drivers/md/dm-vdo/repair.c     | 10 +++----
 drivers/md/dm-vdo/slab-depot.c |  9 +++---
 include/linux/min_heap.h       | 51 +++++++++++++++++-----------------
 kernel/events/core.c           | 10 +++----
 lib/test_min_heap.c            | 26 ++++++++---------
 5 files changed, 54 insertions(+), 52 deletions(-)

diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
index 48c266fa07b6..c1ed3ae823bf 100644
--- a/drivers/md/dm-vdo/repair.c
+++ b/drivers/md/dm-vdo/repair.c
@@ -137,7 +137,7 @@ struct repair_completion {
  * to sort by slot while still ensuring we replay all entries with the same slot in the exact order
  * as they appeared in the journal.
  */
-static bool mapping_is_less_than(const void *item1, const void *item2)
+static bool mapping_is_less_than(const void *item1, const void *item2, void __always_unused *args)
 {
 	const struct numbered_block_mapping *mapping1 =
 		(const struct numbered_block_mapping *) item1;
@@ -156,7 +156,7 @@ static bool mapping_is_less_than(const void *item1, const void *item2)
 	return 0;
 }
 
-static void swap_mappings(void *item1, void *item2)
+static void swap_mappings(void *item1, void *item2, void __always_unused *args)
 {
 	struct numbered_block_mapping *mapping1 = item1;
 	struct numbered_block_mapping *mapping2 = item2;
@@ -182,8 +182,8 @@ static struct numbered_block_mapping *sort_next_heap_element(struct repair_compl
 	 * restore the heap invariant, and return a pointer to the popped element.
 	 */
 	last = &repair->entries[--heap->nr];
-	swap_mappings(heap->data, last);
-	min_heapify(heap, 0, &repair_min_heap);
+	swap_mappings(heap->data, last, NULL);
+	min_heapify(heap, 0, &repair_min_heap, NULL);
 	return last;
 }
 
@@ -1123,7 +1123,7 @@ static void recover_block_map(struct vdo_completion *completion)
 		.nr = repair->block_map_entry_count,
 		.size = repair->block_map_entry_count,
 	};
-	min_heapify_all(&repair->replay_heap, &repair_min_heap);
+	min_heapify_all(&repair->replay_heap, &repair_min_heap, NULL);
 
 	vdo_log_info("Replaying %zu recovery entries into block map",
 		     repair->block_map_entry_count);
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index f6ae6956f321..2739f5b1f8bd 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -3288,7 +3288,8 @@ int vdo_release_block_reference(struct block_allocator *allocator,
  * Thus, the ordering is reversed from the usual sense since min_heap returns smaller elements
  * before larger ones.
  */
-static bool slab_status_is_less_than(const void *item1, const void *item2)
+static bool slab_status_is_less_than(const void *item1, const void *item2,
+					void __always_unused *args)
 {
 	const struct slab_status *info1 = item1;
 	const struct slab_status *info2 = item2;
@@ -3300,7 +3301,7 @@ static bool slab_status_is_less_than(const void *item1, const void *item2)
 	return info1->slab_number < info2->slab_number;
 }
 
-static void swap_slab_statuses(void *item1, void *item2)
+static void swap_slab_statuses(void *item1, void *item2, void __always_unused *args)
 {
 	struct slab_status *info1 = item1;
 	struct slab_status *info2 = item2;
@@ -3525,7 +3526,7 @@ static int __must_check vdo_prepare_slabs_for_allocation(struct block_allocator
 		.nr = allocator->slab_count,
 		.size = allocator->slab_count,
 	};
-	min_heapify_all(&heap, &slab_status_min_heap);
+	min_heapify_all(&heap, &slab_status_min_heap, NULL);
 
 	while (heap.nr > 0) {
 		bool high_priority;
@@ -3533,7 +3534,7 @@ static int __must_check vdo_prepare_slabs_for_allocation(struct block_allocator
 		struct slab_journal *journal;
 
 		current_slab_status = slab_statuses[0];
-		min_heap_pop(&heap, &slab_status_min_heap);
+		min_heap_pop(&heap, &slab_status_min_heap, NULL);
 		slab = depot->slabs[current_slab_status.slab_number];
 
 		if ((depot->load_type == VDO_SLAB_DEPOT_REBUILD_LOAD) ||
diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index d4ec7e749280..9391f7cc9da9 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -34,8 +34,8 @@ typedef MIN_HEAP(char, min_heap_char) min_heap_char;
  * @swp: Swap elements function.
  */
 struct min_heap_callbacks {
-	bool (*less)(const void *lhs, const void *rhs);
-	void (*swp)(void *lhs, void *rhs);
+	bool (*less)(const void *lhs, const void *rhs, void *args);
+	void (*swp)(void *lhs, void *rhs, void *args);
 };
 
 /* Initialize a min-heap. */
@@ -76,7 +76,7 @@ bool __min_heap_full(min_heap_char *heap)
 /* Sift the element at pos down the heap. */
 static __always_inline
 void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
-		const struct min_heap_callbacks *func)
+		const struct min_heap_callbacks *func, void *args)
 {
 	void *left, *right;
 	void *data = heap->data;
@@ -89,7 +89,7 @@ void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
 			break;
 		left = data + (i * 2 + 1) * elem_size;
 		right = data + (i * 2 + 2) * elem_size;
-		i = func->less(left, right) ? i * 2 + 1 : i * 2 + 2;
+		i = func->less(left, right, args) ? i * 2 + 1 : i * 2 + 2;
 	}
 
 	/* Special case for the last leaf with no sibling. */
@@ -97,38 +97,38 @@ void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
 		i = i * 2 + 1;
 
 	/* Backtrack to the correct location. */
-	while (i != pos && func->less(root, data + i * elem_size))
+	while (i != pos && func->less(root, data + i * elem_size, args))
 		i = (i - 1) / 2;
 
 	/* Shift the element into its correct place. */
 	j = i;
 	while (i != pos) {
 		i = (i - 1) / 2;
-		func->swp(data + i * elem_size, data + j * elem_size);
+		func->swp(data + i * elem_size, data + j * elem_size, args);
 	}
 }
 
-#define min_heapify(_heap, _pos, _func)	\
-	__min_heapify((min_heap_char *)_heap, _pos, __minheap_obj_size(_heap), _func)
+#define min_heapify(_heap, _pos, _func, _args)	\
+	__min_heapify((min_heap_char *)_heap, _pos, __minheap_obj_size(_heap), _func, _args)
 
 /* Floyd's approach to heapification that is O(nr). */
 static __always_inline
 void __min_heapify_all(min_heap_char *heap, size_t elem_size,
-		const struct min_heap_callbacks *func)
+		const struct min_heap_callbacks *func, void *args)
 {
 	int i;
 
 	for (i = heap->nr / 2 - 1; i >= 0; i--)
-		__min_heapify(heap, i, elem_size, func);
+		__min_heapify(heap, i, elem_size, func, args);
 }
 
-#define min_heapify_all(_heap, _func)	\
-	__min_heapify_all((min_heap_char *)_heap, __minheap_obj_size(_heap), _func)
+#define min_heapify_all(_heap, _func, _args)	\
+	__min_heapify_all((min_heap_char *)_heap, __minheap_obj_size(_heap), _func, _args)
 
 /* Remove minimum element from the heap, O(log2(nr)). */
 static __always_inline
 void __min_heap_pop(min_heap_char *heap, size_t elem_size,
-		const struct min_heap_callbacks *func)
+		const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
 
@@ -138,11 +138,11 @@ void __min_heap_pop(min_heap_char *heap, size_t elem_size,
 	/* Place last element at the root (position 0) and then sift down. */
 	heap->nr--;
 	memcpy(data, data + (heap->nr * elem_size), elem_size);
-	__min_heapify(heap, 0, elem_size, func);
+	__min_heapify(heap, 0, elem_size, func, args);
 }
 
-#define min_heap_pop(_heap, _func)	\
-	__min_heap_pop((min_heap_char *)_heap, __minheap_obj_size(_heap), _func)
+#define min_heap_pop(_heap, _func, _args)	\
+	__min_heap_pop((min_heap_char *)_heap, __minheap_obj_size(_heap), _func, _args)
 
 /*
  * Remove the minimum element and then push the given element. The
@@ -152,19 +152,20 @@ void __min_heap_pop(min_heap_char *heap, size_t elem_size,
 static __always_inline
 void __min_heap_pop_push(min_heap_char *heap,
 		const void *element, size_t elem_size,
-		const struct min_heap_callbacks *func)
+		const struct min_heap_callbacks *func,
+		void *args)
 {
 	memcpy(heap->data, element, elem_size);
-	__min_heapify(heap, 0, elem_size, func);
+	__min_heapify(heap, 0, elem_size, func, args);
 }
 
-#define min_heap_pop_push(_heap, _element, _func)	\
-	__min_heap_pop_push((min_heap_char *)_heap, _element, __minheap_obj_size(_heap), _func)
+#define min_heap_pop_push(_heap, _element, _func, _args)	\
+	__min_heap_pop_push((min_heap_char *)_heap, _element, __minheap_obj_size(_heap), _func, _args)
 
 /* Push an element on to the heap, O(log2(nr)). */
 static __always_inline
 void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
-		const struct min_heap_callbacks *func)
+		const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
 	void *child, *parent;
@@ -182,13 +183,13 @@ void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 	for (; pos > 0; pos = (pos - 1) / 2) {
 		child = data + (pos * elem_size);
 		parent = data + ((pos - 1) / 2) * elem_size;
-		if (func->less(parent, child))
+		if (func->less(parent, child, args))
 			break;
-		func->swp(parent, child);
+		func->swp(parent, child, args);
 	}
 }
 
-#define min_heap_push(_heap, _element, _func)	\
-	__min_heap_push((min_heap_char *)_heap, _element, __minheap_obj_size(_heap), _func)
+#define min_heap_push(_heap, _element, _func, _args)	\
+	__min_heap_push((min_heap_char *)_heap, _element, __minheap_obj_size(_heap), _func, _args)
 
 #endif /* _LINUX_MIN_HEAP_H */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 55930479599b..dfd7b5748cbb 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3683,7 +3683,7 @@ void __perf_event_task_sched_out(struct task_struct *task,
 	perf_cgroup_switch(next);
 }
 
-static bool perf_less_group_idx(const void *l, const void *r)
+static bool perf_less_group_idx(const void *l, const void *r, void __always_unused *args)
 {
 	const struct perf_event *le = *(const struct perf_event **)l;
 	const struct perf_event *re = *(const struct perf_event **)r;
@@ -3691,7 +3691,7 @@ static bool perf_less_group_idx(const void *l, const void *r)
 	return le->group_index < re->group_index;
 }
 
-static void swap_ptr(void *l, void *r)
+static void swap_ptr(void *l, void *r, void __always_unused *args)
 {
 	void **lp = l, **rp = r;
 
@@ -3783,7 +3783,7 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
 		perf_assert_pmu_disabled((*evt)->pmu_ctx->pmu);
 	}
 
-	min_heapify_all(&event_heap, &perf_min_heap);
+	min_heapify_all(&event_heap, &perf_min_heap, NULL);
 
 	while (event_heap.nr) {
 		ret = func(*evt, data);
@@ -3792,9 +3792,9 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
 
 		*evt = perf_event_groups_next(*evt, pmu);
 		if (*evt)
-			min_heapify(&event_heap, 0, &perf_min_heap);
+			min_heapify(&event_heap, 0, &perf_min_heap, NULL);
 		else
-			min_heap_pop(&event_heap, &perf_min_heap);
+			min_heap_pop(&event_heap, &perf_min_heap, NULL);
 	}
 
 	return 0;
diff --git a/lib/test_min_heap.c b/lib/test_min_heap.c
index dd5c0fa862ab..0b5037b4bd68 100644
--- a/lib/test_min_heap.c
+++ b/lib/test_min_heap.c
@@ -13,17 +13,17 @@
 
 MIN_HEAP(int, min_heap_test);
 
-static __init bool less_than(const void *lhs, const void *rhs)
+static __init bool less_than(const void *lhs, const void *rhs, void __always_unused *args)
 {
 	return *(int *)lhs < *(int *)rhs;
 }
 
-static __init bool greater_than(const void *lhs, const void *rhs)
+static __init bool greater_than(const void *lhs, const void *rhs, void __always_unused *args)
 {
 	return *(int *)lhs > *(int *)rhs;
 }
 
-static __init void swap_ints(void *lhs, void *rhs)
+static __init void swap_ints(void *lhs, void *rhs, void __always_unused *args)
 {
 	int temp = *(int *)lhs;
 
@@ -40,7 +40,7 @@ static __init int pop_verify_heap(bool min_heap,
 	int last;
 
 	last = values[0];
-	min_heap_pop(heap, funcs);
+	min_heap_pop(heap, funcs, NULL);
 	while (heap->nr > 0) {
 		if (min_heap) {
 			if (last > values[0]) {
@@ -56,7 +56,7 @@ static __init int pop_verify_heap(bool min_heap,
 			}
 		}
 		last = values[0];
-		min_heap_pop(heap, funcs);
+		min_heap_pop(heap, funcs, NULL);
 	}
 	return err;
 }
@@ -77,7 +77,7 @@ static __init int test_heapify_all(bool min_heap)
 	int i, err;
 
 	/* Test with known set of values. */
-	min_heapify_all(&heap, &funcs);
+	min_heapify_all(&heap, &funcs, NULL);
 	err = pop_verify_heap(min_heap, &heap, &funcs);
 
 
@@ -86,7 +86,7 @@ static __init int test_heapify_all(bool min_heap)
 	for (i = 0; i < heap.nr; i++)
 		values[i] = get_random_u32();
 
-	min_heapify_all(&heap, &funcs);
+	min_heapify_all(&heap, &funcs, NULL);
 	err += pop_verify_heap(min_heap, &heap, &funcs);
 
 	return err;
@@ -110,14 +110,14 @@ static __init int test_heap_push(bool min_heap)
 
 	/* Test with known set of values copied from data. */
 	for (i = 0; i < ARRAY_SIZE(data); i++)
-		min_heap_push(&heap, &data[i], &funcs);
+		min_heap_push(&heap, &data[i], &funcs, NULL);
 
 	err = pop_verify_heap(min_heap, &heap, &funcs);
 
 	/* Test with randomly generated values. */
 	while (heap.nr < heap.size) {
 		temp = get_random_u32();
-		min_heap_push(&heap, &temp, &funcs);
+		min_heap_push(&heap, &temp, &funcs, NULL);
 	}
 	err += pop_verify_heap(min_heap, &heap, &funcs);
 
@@ -143,22 +143,22 @@ static __init int test_heap_pop_push(bool min_heap)
 	/* Fill values with data to pop and replace. */
 	temp = min_heap ? 0x80000000 : 0x7FFFFFFF;
 	for (i = 0; i < ARRAY_SIZE(data); i++)
-		min_heap_push(&heap, &temp, &funcs);
+		min_heap_push(&heap, &temp, &funcs, NULL);
 
 	/* Test with known set of values copied from data. */
 	for (i = 0; i < ARRAY_SIZE(data); i++)
-		min_heap_pop_push(&heap, &data[i], &funcs);
+		min_heap_pop_push(&heap, &data[i], &funcs, NULL);
 
 	err = pop_verify_heap(min_heap, &heap, &funcs);
 
 	heap.nr = 0;
 	for (i = 0; i < ARRAY_SIZE(data); i++)
-		min_heap_push(&heap, &temp, &funcs);
+		min_heap_push(&heap, &temp, &funcs, NULL);
 
 	/* Test with randomly generated values. */
 	for (i = 0; i < ARRAY_SIZE(data); i++) {
 		temp = get_random_u32();
-		min_heap_pop_push(&heap, &temp, &funcs);
+		min_heap_pop_push(&heap, &temp, &funcs, NULL);
 	}
 	err += pop_verify_heap(min_heap, &heap, &funcs);
 
-- 
2.34.1


