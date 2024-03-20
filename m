Return-Path: <linux-bcache+bounces-337-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3140B8813E0
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 15:57:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC863284A19
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 14:57:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25E1A524AE;
	Wed, 20 Mar 2024 14:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g7KBIJ4d"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0D458AAB;
	Wed, 20 Mar 2024 14:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710946515; cv=none; b=CYFcwswUrVVkBYBqjPwvPjWHmn0M9Rcz4NQqPn1C/P8G4b6LVOuL9jhgIzF+t4+t/yZF9VftwsjmJVmpSrfRpOfymKwvdUQTyD6TMkk0TW74cpWcwG9i0c4+BpyFDMc9EuVnwg21ZsG5+9IkkXFVDyYKpn5csRW+U75gDaLxvxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710946515; c=relaxed/simple;
	bh=v2QDGboZDpSdtXVf/44hZgB01YixUJPmq1o6qcA+7gA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kR5UyvIOb6vU/o2xlHGA85UlfWzGz+aOSRsteU9G4O2/M8e0KXtqQICyhIA2odITU5HFBTjfU4byQjhnJkWPyva0g1T2pHGIegJ7WhQsf9FZXs+GOE74CwCNiSWWPfaOOWBJ4daN2YQaAm7TJ48GlOBXfyXpaSStE7WRhhDy86U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g7KBIJ4d; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6e72123e12dso532630b3a.0;
        Wed, 20 Mar 2024 07:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710946512; x=1711551312; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3j4BwpnzsCTFbTLEfHkq7OVaw0zB9zsQ8DozRNlNpcs=;
        b=g7KBIJ4dYsL3EOXdkGBbqQy2AkHQx5ojnLCroHj1hYsEotOAbQF9DFvchuxZKSjg3k
         Vbz0kCPI4W/RE+z0Hup7FA7fGBjNJ0fMdhhFSBvsSDPh+NKXvkOj4Agr5lBd9Ei9Vu9P
         Zk30D81HYlODCmruOybYrlCEiYE5LCCYWreMcSUbfvD5hObrtN0agHZt0KoBvbzUBDUJ
         dlZBqs7lAxewCB23ypzdnmq+4U7QikzUmmL54fj2NzbLDGEf9502Nrqk4JvZbcqsw78O
         esXq70I7hD6/NBsIkgh0LL3wZVzotHubnD06aWR4zMBNAKoK7fy90YI/8VupAiR1BXs9
         69EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710946512; x=1711551312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3j4BwpnzsCTFbTLEfHkq7OVaw0zB9zsQ8DozRNlNpcs=;
        b=cSlFPBH2HDmwcwWXdWh1MZqzuCwHtE3nSasOUoY+RgQO9bLbSuqsqf4OxbgxnrCpld
         cHzkQSBreKekpL+4dxJPSshutgO7TXP0FQyyJfkbS4Nfq4MPwGrUYxdIxhKpN3KtP4xz
         GiVdHtAOATe1I+dPzVflbPmMUhQgjvUcuDpGyIj6PqA+WCi3fMQbaUawRqu7Py2NJiI3
         IhEi6PC8s1RbGA+77lPk+Sr0Dee0D80Uo2Y7bFh2Ukv4xqpsNKM9xQtaxZT2HC2AmbBr
         6mu0fPoufpkdLUsAavsgMxvWDzoUFgtMe/UVKXqLWbYVpHreVzmLjwUy952ODWBOTJIV
         Iz4w==
X-Forwarded-Encrypted: i=1; AJvYcCWePBpHUzhfs2phGbPBUGC13Gr+taGAzgp09w0solUe3A3wJOBQcCP6zvsmh8rSKlmkMoc3nZ6sd4Ob3scCiEQqUIm3LuYO1zWQfQR5hqYOUygmbrmnnYPcOvC5p1yERodJYihMUmX5ry/7QeoCR3/xOQpHE0fkRSMyuoD8tbargKCJQMufozWPV7xX7Bd+ZIQ2hdVeq02IhhGkM1e7bzOKscQl9YgjEr/HH2Kx
X-Gm-Message-State: AOJu0Yz1vKFBnRq2IFPhdDpXu69DILQU49qbfW4nwyBXi+aOz2bbdVxN
	VhoZj1tOKHdtsKyNc3TXHiZeBYwC6M6fDZqcDFd1rzurVhJqGBql
X-Google-Smtp-Source: AGHT+IEjtfUBQQINRHbNCFh+4mc0PM0bj31+zrpBMLrSahwyX96NxG1VTkI8k/KehbVPts8K4VsiIA==
X-Received: by 2002:a05:6a20:7f8f:b0:1a3:4721:ded3 with SMTP id d15-20020a056a207f8f00b001a34721ded3mr6093871pzj.1.1710946512376;
        Wed, 20 Mar 2024 07:55:12 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id la11-20020a170902fa0b00b001dc30f13e6asm13719989plb.137.2024.03.20.07.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 07:55:11 -0700 (PDT)
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
	dm-devel@lists.linux.dev,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH v2 10/15] lib min_heap: Add args for min_heap_callbacks
Date: Wed, 20 Mar 2024 22:54:12 +0800
Message-Id: <20240320145417.336208-11-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240320145417.336208-1-visitorckw@gmail.com>
References: <20240320145417.336208-1-visitorckw@gmail.com>
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
---
Changes in v2:
- Add attribute __always_unused to the compare and swap functions that
  do not use the args parameter.

 drivers/md/dm-vdo/repair.c     | 10 +++----
 drivers/md/dm-vdo/slab-depot.c |  9 +++---
 include/linux/min_heap.h       | 51 +++++++++++++++++-----------------
 kernel/events/core.c           | 10 +++----
 lib/test_min_heap.c            | 26 ++++++++---------
 5 files changed, 54 insertions(+), 52 deletions(-)

diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
index 7663fa2098f4..6acaebcd305d 100644
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
 	last = &repair->entries[--heap->heap.nr];
-	swap_mappings(heap->heap.data, last);
-	min_heapify(heap, 0, &repair_min_heap);
+	swap_mappings(heap->heap.data, last, NULL);
+	min_heapify(heap, 0, &repair_min_heap, NULL);
 	return last;
 }
 
@@ -1121,7 +1121,7 @@ static void recover_block_map(struct vdo_completion *completion)
 	repair->replay_heap.heap.data = repair->entries;
 	repair->replay_heap.heap.nr = repair->block_map_entry_count;
 	repair->replay_heap.heap.size = repair->block_map_entry_count;
-	min_heapify_all(&repair->replay_heap, &repair_min_heap);
+	min_heapify_all(&repair->replay_heap, &repair_min_heap, NULL);
 
 	vdo_log_info("Replaying %zu recovery entries into block map",
 		     repair->block_map_entry_count);
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index 3309480170c3..102f492bb1f8 100644
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
@@ -3523,7 +3524,7 @@ static int __must_check vdo_prepare_slabs_for_allocation(struct block_allocator
 	heap.heap.data = slab_statuses;
 	heap.heap.nr = allocator->slab_count;
 	heap.heap.size = allocator->slab_count;
-	min_heapify_all(&heap, &slab_status_min_heap);
+	min_heapify_all(&heap, &slab_status_min_heap, NULL);
 
 	while (heap.heap.nr > 0) {
 		bool high_priority;
@@ -3531,7 +3532,7 @@ static int __must_check vdo_prepare_slabs_for_allocation(struct block_allocator
 		struct slab_journal *journal;
 
 		current_slab_status = slab_statuses[0];
-		min_heap_pop(&heap, &slab_status_min_heap);
+		min_heap_pop(&heap, &slab_status_min_heap, NULL);
 		slab = depot->slabs[current_slab_status.slab_number];
 
 		if ((depot->load_type == VDO_SLAB_DEPOT_REBUILD_LOAD) ||
diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index af12531474a4..879a9d12e030 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -40,8 +40,8 @@ struct _name {				\
  * @swp: Swap elements function.
  */
 struct min_heap_callbacks {
-	bool (*less)(const void *lhs, const void *rhs);
-	void (*swp)(void *lhs, void *rhs);
+	bool (*less)(const void *lhs, const void *rhs, void *args);
+	void (*swp)(void *lhs, void *rhs, void *args);
 };
 
 /* Initialize a min-heap. */
@@ -79,7 +79,7 @@ bool __min_heap_full(struct __min_heap *heap)
 /* Sift the element at pos down the heap. */
 static __always_inline
 void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
-		const struct min_heap_callbacks *func)
+		const struct min_heap_callbacks *func, void *args)
 {
 	void *left, *right;
 	void *data = heap->data;
@@ -92,7 +92,7 @@ void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
 			break;
 		left = data + (i * 2 + 1) * elem_size;
 		right = data + (i * 2 + 2) * elem_size;
-		i = func->less(left, right) ? i * 2 + 1 : i * 2 + 2;
+		i = func->less(left, right, args) ? i * 2 + 1 : i * 2 + 2;
 	}
 
 	/* Special case for the last leaf with no sibling. */
@@ -100,38 +100,38 @@ void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
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
-	__min_heapify(&(_heap)->heap, _pos, __minheap_obj_size(_heap), _func)
+#define min_heapify(_heap, _pos, _func, _args)	\
+	__min_heapify(&(_heap)->heap, _pos, __minheap_obj_size(_heap), _func, _args)
 
 /* Floyd's approach to heapification that is O(nr). */
 static __always_inline
 void __min_heapify_all(struct __min_heap *heap, size_t elem_size,
-		const struct min_heap_callbacks *func)
+		const struct min_heap_callbacks *func, void *args)
 {
 	int i;
 
 	for (i = heap->nr / 2 - 1; i >= 0; i--)
-		__min_heapify(heap, i, elem_size, func);
+		__min_heapify(heap, i, elem_size, func, args);
 }
 
-#define min_heapify_all(_heap, _func)	\
-	__min_heapify_all(&(_heap)->heap, __minheap_obj_size(_heap), _func)
+#define min_heapify_all(_heap, _func, _args)	\
+	__min_heapify_all(&(_heap)->heap, __minheap_obj_size(_heap), _func, _args)
 
 /* Remove minimum element from the heap, O(log2(nr)). */
 static __always_inline
 void __min_heap_pop(struct __min_heap *heap, size_t elem_size,
-		const struct min_heap_callbacks *func)
+		const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
 
@@ -141,11 +141,11 @@ void __min_heap_pop(struct __min_heap *heap, size_t elem_size,
 	/* Place last element at the root (position 0) and then sift down. */
 	heap->nr--;
 	memcpy(data, data + (heap->nr * elem_size), elem_size);
-	__min_heapify(heap, 0, elem_size, func);
+	__min_heapify(heap, 0, elem_size, func, args);
 }
 
-#define min_heap_pop(_heap, _func)	\
-	__min_heap_pop(&(_heap)->heap, __minheap_obj_size(_heap), _func)
+#define min_heap_pop(_heap, _func, _args)	\
+	__min_heap_pop(&(_heap)->heap, __minheap_obj_size(_heap), _func, _args)
 
 /*
  * Remove the minimum element and then push the given element. The
@@ -155,19 +155,20 @@ void __min_heap_pop(struct __min_heap *heap, size_t elem_size,
 static __always_inline
 void __min_heap_pop_push(struct __min_heap *heap,
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
-	__min_heap_pop_push(&(_heap)->heap, _element, __minheap_obj_size(_heap), _func)
+#define min_heap_pop_push(_heap, _element, _func, _args)	\
+	__min_heap_pop_push(&(_heap)->heap, _element, __minheap_obj_size(_heap), _func, _args)
 
 /* Push an element on to the heap, O(log2(nr)). */
 static __always_inline
 void __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_size,
-		const struct min_heap_callbacks *func)
+		const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
 	void *child, *parent;
@@ -185,14 +186,14 @@ void __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_s
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
-	__min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(_heap), _func)
+#define min_heap_push(_heap, _element, _func, _args)	\
+	__min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(_heap), _func, _args)
 
 /* Sift up ith element from the heap, O(log2(nr)). */
 static __always_inline
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 065dfaa8b009..c32a78c489f3 100644
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
 
@@ -3779,7 +3779,7 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
 		perf_assert_pmu_disabled((*evt)->pmu_ctx->pmu);
 	}
 
-	min_heapify_all(&event_heap, &perf_min_heap);
+	min_heapify_all(&event_heap, &perf_min_heap, NULL);
 
 	while (event_heap.heap.nr) {
 		ret = func(*evt, data);
@@ -3788,9 +3788,9 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
 
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
index af2e446034d8..062e908e9fa3 100644
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
 	while (heap->heap.nr > 0) {
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
 	for (i = 0; i < heap.heap.nr; i++)
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
 	while (heap.heap.nr < heap.heap.size) {
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
 
 	heap.heap.nr = 0;
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


