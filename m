Return-Path: <linux-bcache+bounces-368-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 079BD89AC2B
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 18:49:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A6911C20DAB
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 16:48:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F38684D9FF;
	Sat,  6 Apr 2024 16:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QeHLzAay"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CBB3FBA7;
	Sat,  6 Apr 2024 16:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712422084; cv=none; b=PUA3NN3fr18Dk2Vj+eZQGN2R8m4a+FTSHJCf+F7TyFwA06ktSOVyHWZ1s25zQ9E9VWA+egCnhwUDGyVGfcgXSZskckG+yFHj0C2ZogFOx/+o7uYFYE+wBhedsEEo1sJanL86qJHrRSGgY4ISlntvS79cr67VRJyYEPSOTOgR5+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712422084; c=relaxed/simple;
	bh=Kmi/WfJXrF9DmnDIPKVOruewhD/0hLZT0Rq7qSw+uTg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cChwbFNtEFgptINH0PItvpRCVkDuLtl0RbADjHCFcFTEwu35U0QOwKcSPcCjjpYpUpaEn54AQuz7PU2ATiMV2Sx6Deoruh9mFUkq2AWnNVpORhflwX62DEDKKYiRbSP8eAE7F1z3kl00Ry7IRT/ZSfMJNJo4Lq8a/l1o3svZ4oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QeHLzAay; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6ecfea4f01cso484049b3a.0;
        Sat, 06 Apr 2024 09:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712422082; x=1713026882; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dK09sdVm3FDc6WKxOeZ2eJalXfjQmceUyaajZx+IgEI=;
        b=QeHLzAayT0sw6/+FlgnV/oCpGntoxHm+6PjXK4GN0mwr3g5FQB+60lScEf8zcJj6B5
         T8hyLYYWnepberPB0DzJ3FVbEHmh3Ts0Uxd1yEjqzvDlUvF1fSktyu5+oTd/t+Hkwd5R
         L2aQJx4UqlVCcWXFl11KsSnf6XEkLS7SYnwCfGcUOx67KMJq01YI1XQiu+mGgVT4vS2H
         jiQihIBivXVEAT1kjJFDsEdANlpsyi6sTIaL+N8Jz+vhIbxMLnpXQOU38plQ1ME+OZPf
         9mPxH5ymMyrZAlG1DulQm3fNxmDub5S8Jgl48FFiOK457uP4KweqeV+UfOK8XdMaaqU+
         AvaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712422082; x=1713026882;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dK09sdVm3FDc6WKxOeZ2eJalXfjQmceUyaajZx+IgEI=;
        b=rdNSQVc5ZEkQ/VFl5VgTDvYn9Y4cx0mMRgjkEvWnq4mEUKYBKRZdijZBc+VLzfnfi4
         aDvXfVTWTnwIF5DxbSYuzxtiAXRMKU8MTxilNb0K90y7GYruy8WJBraJKv7XXCINresQ
         qnSFRY+mKiftl/iDPLrK1wMRjwRV0IxESTEvqZxT2tmBAad54rJ7Fq/BNu1tnJAYOgGl
         VEkMdEC6rUdMMJM8LUHesIiDBRE3/kuZ6oXOq/0Z3ghOyPpOuHIMIlG51aktZI4x8S11
         dsMr8zD7EgBqMLN5Pi1Esefb3feYLWWhd+lb0PbPBZwYUalhLw8poK2KdmepiQXDjHLU
         MZFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWe+xOiFlDrlJtekD/5vjVH0YdfjDmNWEG+Hh7KxiJ2TS54l7/jkdp0OSDhwIarvBFhW7c3KXI28wHF1MTQY4CQx6icA5s8uQhvFLGV4j1ytq2GZOqE6hLA4/siedRN8x9VhoEZ043Yhxo6Wd1geZ6ps1+Y3XcbB8mnyiQwF3oPR66G0W04mbVCUUYSSYaIBeknQy9uddq/HSy424HK1ibg0GxRt+R0WB0EG9wr
X-Gm-Message-State: AOJu0YwDvhMrVSzNbrYXLcDcIFXMYORyWMY4kYPZhYUfHKhLTqRCvDIi
	qyWCIRwZcP2OfsBHWPRlVYVe1C1SGZtY9/RiWh4XXUNnfKFr5Otu
X-Google-Smtp-Source: AGHT+IF6bSM9TvaOHZ1SxE6Lem5Gy66Hig9ApmIiEpbRWhnjYwG5p8fVQ2KN7omN/hwecz/4GFfmWA==
X-Received: by 2002:a17:902:e5c1:b0:1e0:c91b:b950 with SMTP id u1-20020a170902e5c100b001e0c91bb950mr5606192plf.5.1712422082051;
        Sat, 06 Apr 2024 09:48:02 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b001e2b8c91f04sm3665068plb.22.2024.04.06.09.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 09:48:01 -0700 (PDT)
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
Subject: [PATCH v3 04/17] lib min_heap: Add type safe interface
Date: Sun,  7 Apr 2024 00:47:14 +0800
Message-Id: <20240406164727.577914-5-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240406164727.577914-1-visitorckw@gmail.com>
References: <20240406164727.577914-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement a type-safe interface for min_heap using strong type
pointers instead of void * in the data field. This change includes
adding small macro wrappers around functions, enabling the use of
__minheap_cast and __minheap_obj_size macros for type casting and
obtaining element size. This implementation removes the necessity of
passing element size in min_heap_callbacks. Additionally, introduce the
MIN_HEAP_PREALLOCATED macro for preallocating some elements.

Link: https://lkml.kernel.org/ioyfizrzq7w7mjrqcadtzsfgpuntowtjdw5pgn4qhvsdp4mqqg@nrlek5vmisbu
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
Changes in v3:
- Avoid heap->heap.nr to eliminate the nested types.
- Add MIN_HEAP_PREALLOCATED macro for preallocating some elements.

 drivers/md/dm-vdo/repair.c     | 15 +++----
 drivers/md/dm-vdo/slab-depot.c | 11 ++---
 include/linux/min_heap.h       | 79 ++++++++++++++++++++++------------
 kernel/events/core.c           | 23 +++++-----
 lib/test_min_heap.c            | 37 ++++++++--------
 5 files changed, 90 insertions(+), 75 deletions(-)

diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
index defc9359f10e..1916dc284365 100644
--- a/drivers/md/dm-vdo/repair.c
+++ b/drivers/md/dm-vdo/repair.c
@@ -51,6 +51,8 @@ struct recovery_point {
 	bool increment_applied;
 };
 
+MIN_HEAP(struct numbered_block_mapping, replay_heap);
+
 struct repair_completion {
 	/* The completion header */
 	struct vdo_completion completion;
@@ -97,7 +99,7 @@ struct repair_completion {
 	 * order, then original journal order. This permits efficient iteration over the journal
 	 * entries in order.
 	 */
-	struct min_heap replay_heap;
+	struct replay_heap replay_heap;
 	/* Fields tracking progress through the journal entries. */
 	struct numbered_block_mapping *current_entry;
 	struct numbered_block_mapping *current_unfetched_entry;
@@ -163,14 +165,13 @@ static void swap_mappings(void *item1, void *item2)
 }
 
 static const struct min_heap_callbacks repair_min_heap = {
-	.elem_size = sizeof(struct numbered_block_mapping),
 	.less = mapping_is_less_than,
 	.swp = swap_mappings,
 };
 
 static struct numbered_block_mapping *sort_next_heap_element(struct repair_completion *repair)
 {
-	struct min_heap *heap = &repair->replay_heap;
+	struct replay_heap *heap = &repair->replay_heap;
 	struct numbered_block_mapping *last;
 
 	if (heap->nr == 0)
@@ -1117,11 +1118,9 @@ static void recover_block_map(struct vdo_completion *completion)
 	 * Organize the journal entries into a binary heap so we can iterate over them in sorted
 	 * order incrementally, avoiding an expensive sort call.
 	 */
-	repair->replay_heap = (struct min_heap) {
-		.data = repair->entries,
-		.nr = repair->block_map_entry_count,
-		.size = repair->block_map_entry_count,
-	};
+	repair->replay_heap.data = repair->entries;
+	repair->replay_heap.nr = repair->block_map_entry_count;
+	repair->replay_heap.size = repair->block_map_entry_count;
 	min_heapify_all(&repair->replay_heap, &repair_min_heap);
 
 	vdo_log_info("Replaying %zu recovery entries into block map",
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index 46e4721e5b4f..fb38e3b8befc 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -3309,7 +3309,6 @@ static void swap_slab_statuses(void *item1, void *item2)
 }
 
 static const struct min_heap_callbacks slab_status_min_heap = {
-	.elem_size = sizeof(struct slab_status),
 	.less = slab_status_is_less_than,
 	.swp = swap_slab_statuses,
 };
@@ -3509,7 +3508,7 @@ static int get_slab_statuses(struct block_allocator *allocator,
 static int __must_check vdo_prepare_slabs_for_allocation(struct block_allocator *allocator)
 {
 	struct slab_status current_slab_status;
-	struct min_heap heap;
+	MIN_HEAP(struct slab_status, heap) heap;
 	int result;
 	struct slab_status *slab_statuses;
 	struct slab_depot *depot = allocator->depot;
@@ -3521,11 +3520,9 @@ static int __must_check vdo_prepare_slabs_for_allocation(struct block_allocator
 		return result;
 
 	/* Sort the slabs by cleanliness, then by emptiness hint. */
-	heap = (struct min_heap) {
-		.data = slab_statuses,
-		.nr = allocator->slab_count,
-		.size = allocator->slab_count,
-	};
+	heap.data = slab_statuses;
+	heap.nr = allocator->slab_count;
+	heap.size = allocator->slab_count;
 	min_heapify_all(&heap, &slab_status_min_heap);
 
 	while (heap.nr > 0) {
diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index d52daf45861b..87737cadb9a5 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -7,45 +7,53 @@
 #include <linux/types.h>
 
 /**
- * struct min_heap - Data structure to hold a min-heap.
- * @data: Start of array holding the heap elements.
+ * Data structure to hold a min-heap.
  * @nr: Number of elements currently in the heap.
  * @size: Maximum number of elements that can be held in current storage.
+ * @data: Pointer to the start of array holding the heap elements.
+ * @preallocated: Start of the static preallocated array holding the heap elements.
  */
-struct min_heap {
-	void *data;
-	int nr;
-	int size;
-};
+#define MIN_HEAP_PREALLOCATED(_type, _name, _nr)	\
+struct _name {	\
+	int nr;	\
+	int size;	\
+	_type *data;	\
+	_type preallocated[_nr];	\
+}
+
+#define MIN_HEAP(_type, _name) MIN_HEAP_PREALLOCATED(_type, _name, 0)
+
+typedef MIN_HEAP(char, min_heap_char) min_heap_char;
+
+#define __minheap_cast(_heap)		(typeof((_heap)->data[0]) *)
+#define __minheap_obj_size(_heap)	sizeof((_heap)->data[0])
 
 /**
  * struct min_heap_callbacks - Data/functions to customise the min_heap.
- * @elem_size: The nr of each element in bytes.
  * @less: Partial order function for this heap.
  * @swp: Swap elements function.
  */
 struct min_heap_callbacks {
-	int elem_size;
 	bool (*less)(const void *lhs, const void *rhs);
 	void (*swp)(void *lhs, void *rhs);
 };
 
 /* Sift the element at pos down the heap. */
 static __always_inline
-void min_heapify(struct min_heap *heap, int pos,
+void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
 		const struct min_heap_callbacks *func)
 {
 	void *left, *right;
 	void *data = heap->data;
-	void *root = data + pos * func->elem_size;
+	void *root = data + pos * elem_size;
 	int i = pos, j;
 
 	/* Find the sift-down path all the way to the leaves. */
 	for (;;) {
 		if (i * 2 + 2 >= heap->nr)
 			break;
-		left = data + (i * 2 + 1) * func->elem_size;
-		right = data + (i * 2 + 2) * func->elem_size;
+		left = data + (i * 2 + 1) * elem_size;
+		right = data + (i * 2 + 2) * elem_size;
 		i = func->less(left, right) ? i * 2 + 1 : i * 2 + 2;
 	}
 
@@ -54,31 +62,37 @@ void min_heapify(struct min_heap *heap, int pos,
 		i = i * 2 + 1;
 
 	/* Backtrack to the correct location. */
-	while (i != pos && func->less(root, data + i * func->elem_size))
+	while (i != pos && func->less(root, data + i * elem_size))
 		i = (i - 1) / 2;
 
 	/* Shift the element into its correct place. */
 	j = i;
 	while (i != pos) {
 		i = (i - 1) / 2;
-		func->swp(data + i * func->elem_size, data + j * func->elem_size);
+		func->swp(data + i * elem_size, data + j * elem_size);
 	}
 }
 
+#define min_heapify(_heap, _pos, _func)	\
+	__min_heapify((min_heap_char *)_heap, _pos, __minheap_obj_size(_heap), _func)
+
 /* Floyd's approach to heapification that is O(nr). */
 static __always_inline
-void min_heapify_all(struct min_heap *heap,
+void __min_heapify_all(min_heap_char *heap, size_t elem_size,
 		const struct min_heap_callbacks *func)
 {
 	int i;
 
 	for (i = heap->nr / 2 - 1; i >= 0; i--)
-		min_heapify(heap, i, func);
+		__min_heapify(heap, i, elem_size, func);
 }
 
+#define min_heapify_all(_heap, _func)	\
+	__min_heapify_all((min_heap_char *)_heap, __minheap_obj_size(_heap), _func)
+
 /* Remove minimum element from the heap, O(log2(nr)). */
 static __always_inline
-void min_heap_pop(struct min_heap *heap,
+void __min_heap_pop(min_heap_char *heap, size_t elem_size,
 		const struct min_heap_callbacks *func)
 {
 	void *data = heap->data;
@@ -88,27 +102,33 @@ void min_heap_pop(struct min_heap *heap,
 
 	/* Place last element at the root (position 0) and then sift down. */
 	heap->nr--;
-	memcpy(data, data + (heap->nr * func->elem_size), func->elem_size);
-	min_heapify(heap, 0, func);
+	memcpy(data, data + (heap->nr * elem_size), elem_size);
+	__min_heapify(heap, 0, elem_size, func);
 }
 
+#define min_heap_pop(_heap, _func)	\
+	__min_heap_pop((min_heap_char *)_heap, __minheap_obj_size(_heap), _func)
+
 /*
  * Remove the minimum element and then push the given element. The
  * implementation performs 1 sift (O(log2(nr))) and is therefore more
  * efficient than a pop followed by a push that does 2.
  */
 static __always_inline
-void min_heap_pop_push(struct min_heap *heap,
-		const void *element,
+void __min_heap_pop_push(min_heap_char *heap,
+		const void *element, size_t elem_size,
 		const struct min_heap_callbacks *func)
 {
-	memcpy(heap->data, element, func->elem_size);
-	min_heapify(heap, 0, func);
+	memcpy(heap->data, element, elem_size);
+	__min_heapify(heap, 0, elem_size, func);
 }
 
+#define min_heap_pop_push(_heap, _element, _func)	\
+	__min_heap_pop_push((min_heap_char *)_heap, _element, __minheap_obj_size(_heap), _func)
+
 /* Push an element on to the heap, O(log2(nr)). */
 static __always_inline
-void min_heap_push(struct min_heap *heap, const void *element,
+void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 		const struct min_heap_callbacks *func)
 {
 	void *data = heap->data;
@@ -120,17 +140,20 @@ void min_heap_push(struct min_heap *heap, const void *element,
 
 	/* Place at the end of data. */
 	pos = heap->nr;
-	memcpy(data + (pos * func->elem_size), element, func->elem_size);
+	memcpy(data + (pos * elem_size), element, elem_size);
 	heap->nr++;
 
 	/* Sift child at pos up. */
 	for (; pos > 0; pos = (pos - 1) / 2) {
-		child = data + (pos * func->elem_size);
-		parent = data + ((pos - 1) / 2) * func->elem_size;
+		child = data + (pos * elem_size);
+		parent = data + ((pos - 1) / 2) * elem_size;
 		if (func->less(parent, child))
 			break;
 		func->swp(parent, child);
 	}
 }
 
+#define min_heap_push(_heap, _element, _func)	\
+	__min_heap_push((min_heap_char *)_heap, _element, __minheap_obj_size(_heap), _func)
+
 #endif /* _LINUX_MIN_HEAP_H */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 10ac2db83f14..4b6a50b0fef0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3698,13 +3698,14 @@ static void swap_ptr(void *l, void *r)
 	swap(*lp, *rp);
 }
 
+MIN_HEAP(struct perf_event *, perf_event_min_heap);
+
 static const struct min_heap_callbacks perf_min_heap = {
-	.elem_size = sizeof(struct perf_event *),
 	.less = perf_less_group_idx,
 	.swp = swap_ptr,
 };
 
-static void __heap_add(struct min_heap *heap, struct perf_event *event)
+static void __heap_add(struct perf_event_min_heap *heap, struct perf_event *event)
 {
 	struct perf_event **itrs = heap->data;
 
@@ -3738,7 +3739,7 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
 	struct perf_cpu_context *cpuctx = NULL;
 	/* Space for per CPU and/or any CPU event iterators. */
 	struct perf_event *itrs[2];
-	struct min_heap event_heap;
+	struct perf_event_min_heap event_heap;
 	struct perf_event **evt;
 	int ret;
 
@@ -3747,11 +3748,9 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
 
 	if (!ctx->task) {
 		cpuctx = this_cpu_ptr(&perf_cpu_context);
-		event_heap = (struct min_heap){
-			.data = cpuctx->heap,
-			.nr = 0,
-			.size = cpuctx->heap_size,
-		};
+		event_heap.data = cpuctx->heap;
+		event_heap.nr = 0;
+		event_heap.size = cpuctx->heap_size;
 
 		lockdep_assert_held(&cpuctx->ctx.lock);
 
@@ -3760,11 +3759,9 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
 			css = &cpuctx->cgrp->css;
 #endif
 	} else {
-		event_heap = (struct min_heap){
-			.data = itrs,
-			.nr = 0,
-			.size = ARRAY_SIZE(itrs),
-		};
+		event_heap.data = itrs;
+		event_heap.nr = 0;
+		event_heap.size = ARRAY_SIZE(itrs);
 		/* Events not within a CPU context may be on any CPU. */
 		__heap_add(&event_heap, perf_event_groups_first(groups, -1, pmu, NULL));
 	}
diff --git a/lib/test_min_heap.c b/lib/test_min_heap.c
index 7b01b4387cfb..9e7642c3ef9e 100644
--- a/lib/test_min_heap.c
+++ b/lib/test_min_heap.c
@@ -11,6 +11,8 @@
 #include <linux/printk.h>
 #include <linux/random.h>
 
+MIN_HEAP(int, min_heap_test);
+
 static __init bool less_than(const void *lhs, const void *rhs)
 {
 	return *(int *)lhs < *(int *)rhs;
@@ -30,7 +32,7 @@ static __init void swap_ints(void *lhs, void *rhs)
 }
 
 static __init int pop_verify_heap(bool min_heap,
-				struct min_heap *heap,
+				struct min_heap_test *heap,
 				const struct min_heap_callbacks *funcs)
 {
 	int *values = heap->data;
@@ -63,13 +65,12 @@ static __init int test_heapify_all(bool min_heap)
 {
 	int values[] = { 3, 1, 2, 4, 0x8000000, 0x7FFFFFF, 0,
 			 -3, -1, -2, -4, 0x8000000, 0x7FFFFFF };
-	struct min_heap heap = {
-		.data = values,
-		.nr = ARRAY_SIZE(values),
-		.size =  ARRAY_SIZE(values),
-	};
+	struct min_heap_test heap;
+
+	heap.data = values;
+	heap.nr = ARRAY_SIZE(values);
+	heap.size =  ARRAY_SIZE(values);
 	struct min_heap_callbacks funcs = {
-		.elem_size = sizeof(int),
 		.less = min_heap ? less_than : greater_than,
 		.swp = swap_ints,
 	};
@@ -96,13 +97,12 @@ static __init int test_heap_push(bool min_heap)
 	const int data[] = { 3, 1, 2, 4, 0x80000000, 0x7FFFFFFF, 0,
 			     -3, -1, -2, -4, 0x80000000, 0x7FFFFFFF };
 	int values[ARRAY_SIZE(data)];
-	struct min_heap heap = {
-		.data = values,
-		.nr = 0,
-		.size =  ARRAY_SIZE(values),
-	};
+	struct min_heap_test heap;
+
+	heap.data = values;
+	heap.nr = 0;
+	heap.size =  ARRAY_SIZE(values);
 	struct min_heap_callbacks funcs = {
-		.elem_size = sizeof(int),
 		.less = min_heap ? less_than : greater_than,
 		.swp = swap_ints,
 	};
@@ -129,13 +129,12 @@ static __init int test_heap_pop_push(bool min_heap)
 	const int data[] = { 3, 1, 2, 4, 0x80000000, 0x7FFFFFFF, 0,
 			     -3, -1, -2, -4, 0x80000000, 0x7FFFFFFF };
 	int values[ARRAY_SIZE(data)];
-	struct min_heap heap = {
-		.data = values,
-		.nr = 0,
-		.size =  ARRAY_SIZE(values),
-	};
+	struct min_heap_test heap;
+
+	heap.data = values;
+	heap.nr = 0;
+	heap.size =  ARRAY_SIZE(values);
 	struct min_heap_callbacks funcs = {
-		.elem_size = sizeof(int),
 		.less = min_heap ? less_than : greater_than,
 		.swp = swap_ints,
 	};
-- 
2.34.1


