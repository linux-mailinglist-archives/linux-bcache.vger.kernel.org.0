Return-Path: <linux-bcache+bounces-304-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51911880441
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 19:03:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75D3B1C2311C
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 18:03:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 012F728383;
	Tue, 19 Mar 2024 18:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RHUc0mcV"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAABD5FBB0;
	Tue, 19 Mar 2024 18:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710871264; cv=none; b=n7xSP8rPSDa/PPwmcvO3aAwz1POwU1sFsy4fuCVfxW3be1NHhMxK0Wz0j7vb5oZiwmJSE5nE5CZLpwB6OdHeVzvDKOcQcBIvn8R/3q7TMKusqcmR0YTtKrfxAhfiejoynsVZjfxv8JmEHq2YM3x9+p/lYKF0YZLMoOE6ybMxYPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710871264; c=relaxed/simple;
	bh=SzanTHe8fdFsJ1zQGSsmKZgt9X9060jgJj3kTq+QswU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sq4CI97UKO926t5OchKtpwpEOckT5nBCh1bE25jWFSyR9AIeUNvPzq8r4E60yqzjTZi/XhUbsefywpdQuzpZOC5J01Zkps1DOWTMjroyFdJfToyASpHnBVaqL6nQ+sxL5m2R3fEeFrVKNuVDOB5j0X8eMGd1F0poAx/RSYBWUJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RHUc0mcV; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-55b5a37acb6so972953a12.0;
        Tue, 19 Mar 2024 11:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710871262; x=1711476062; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gkwrjYgr25pJtFwXmJg3BLDTHaaMD3X5YVpDc57d3mA=;
        b=RHUc0mcV81U5q6169gSnzjpPTY36EHTb9yotyv5fUZyZpGQ94hf2mVZoQTyxJns0+S
         1+CZ+HyMfDbZy0InMuvBeJ4RLrMVO+lol1ZkbbyngE6EykyyqIPQV4cfxfEKTBTXAg1I
         LoMV6FY8RC2UY3oWp4gml9ElBAYGsGvb2LIuKUc8heddgmaLMqo7PnS/AGHHNgJgozt0
         oEIC1WmvL22bM1xWj2KIY6n8RnpgH/+HjapnI8J7mtin2+OI0X2p68UE150ncArX4K7o
         OSet1L2hUaX9AQ7RSs/8WO2FluoSPCHaSa0XY4XK1BPlObk9GfOHI043ZYxwLafGKbrX
         4SNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710871262; x=1711476062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gkwrjYgr25pJtFwXmJg3BLDTHaaMD3X5YVpDc57d3mA=;
        b=kj/6/hOYsgOkdNkGLVUGpxPywj515/iOuJwxrZg+YM/RcKpFQfddAMB3IXF+vdIqJG
         IxCsVbW2VALx/orrWg4zorTSN8+4wB8H45GSEn67C5YwprjTRpXAGz6OofgOfq2ljRhu
         SNyuokfbNdSLj7NK4FMcF8jpMO0BavkvmwP/A+SZTQeUWL5+dbrRl82q6aZyC3iy5A02
         x11/+kQSwuK6HddkNPWZL75CYnLfVtgrm4zUPfi58DVcIqmvpIq2GY2jHPk3IKsPYWhp
         bv+DLyPbenfY/K155aHCoJSdZyfY81oWPf3bu1fJeaYypMWMQMRhCQBkSJDlgnYvg+Wh
         UW7g==
X-Forwarded-Encrypted: i=1; AJvYcCWPS9pHiRPuXnOWdxz5qwxcWCLiSgI4uCD9B4wyr9yxp/3Mjbuwo8FKfIAPxqsQSb1Kp0Fa/MON/DoGK70/oSEJQnm4EHqAvE82+/0hABxffNY9ZSPxvgj++nrNzVPYPL3f8zQLb3gaMhelUjoZmzIWG84YafEuS3q9aPLgkxe5ygHx+l+9C+fkorhhKEuZ9Jz8TB6U9olZ0YmdvZaMUv+1sX8HLXo0avvemuIN
X-Gm-Message-State: AOJu0Yy3T4dSk0I/NCh26WZB+N+I9o4JkduiW66aU+E0tsBXI1nDDGf2
	qdsIrTimxXT/lORcgLavjK4+m3qWgjzLbE4r6fTA/sOaI8+SzXQD
X-Google-Smtp-Source: AGHT+IEQoC3G2d7Vh94gAFRltAWkbPmppCp4u9RKwbHK3LEGrzFm0t6A8thqcrG44aQaQjyjuh+ssg==
X-Received: by 2002:a17:903:244e:b0:1dd:7350:29f6 with SMTP id l14-20020a170903244e00b001dd735029f6mr3130430pls.3.1710871261193;
        Tue, 19 Mar 2024 11:01:01 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id u16-20020a17090341d000b001dd3bee3cd6sm5531359ple.219.2024.03.19.11.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 11:01:00 -0700 (PDT)
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
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH 10/13] bcache: Remove heap-related macros and switch to generic min_heap
Date: Wed, 20 Mar 2024 02:00:02 +0800
Message-Id: <20240319180005.246930-11-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240319180005.246930-1-visitorckw@gmail.com>
References: <20240319180005.246930-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drop the heap-related macros from bcache and replaces them with the
generic min_heap implementation from include/linux. This change
improves code readability by using functions instead of macros.

Link: https://lkml.kernel.org/ioyfizrzq7w7mjrqcadtzsfgpuntowtjdw5pgn4qhvsdp4mqqg@nrlek5vmisbu
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 drivers/md/bcache/alloc.c    | 66 +++++++++++++++++++++--------
 drivers/md/bcache/bcache.h   |  2 +-
 drivers/md/bcache/bset.c     | 73 ++++++++++++++++++++++----------
 drivers/md/bcache/bset.h     | 38 ++++++++++-------
 drivers/md/bcache/btree.c    | 27 +++++++++++-
 drivers/md/bcache/extents.c  | 44 ++++++++++++--------
 drivers/md/bcache/movinggc.c | 40 +++++++++++++-----
 drivers/md/bcache/super.c    | 16 +++++++
 drivers/md/bcache/sysfs.c    |  3 ++
 drivers/md/bcache/util.h     | 81 +-----------------------------------
 10 files changed, 224 insertions(+), 166 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index ce13c272c387..e0459826788e 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -166,40 +166,70 @@ static void bch_invalidate_one_bucket(struct cache *ca, struct bucket *b)
  * prio is worth 1/8th of what INITIAL_PRIO is worth.
  */
 
-#define bucket_prio(b)							\
-({									\
-	unsigned int min_prio = (INITIAL_PRIO - ca->set->min_prio) / 8;	\
-									\
-	(b->prio - ca->set->min_prio + min_prio) * GC_SECTORS_USED(b);	\
-})
+static inline unsigned int bucket_prio(struct cache *ca, struct bucket *b)
+{
+	unsigned int min_prio = (INITIAL_PRIO - ca->set->min_prio) / 8;
+
+	return (b->prio - ca->set->min_prio + min_prio) * GC_SECTORS_USED(b);
+
+}
+
+static inline bool bucket_max_cmp(const void *l, const void *r, void *args)
+{
+	struct bucket *lhs = (struct bucket *)l;
+	struct bucket *rhs = (struct bucket *)r;
+	struct cache *ca = args;
+
+	return bucket_prio(ca, lhs) > bucket_prio(ca, rhs);
+}
+
+static inline bool bucket_min_cmp(const void *l, const void *r, void *args)
+{
+	struct bucket *lhs = (struct bucket *)l;
+	struct bucket *rhs = (struct bucket *)r;
+	struct cache *ca = args;
+
+	return bucket_prio(ca, lhs) < bucket_prio(ca, rhs);
+}
+
+static inline void bucket_swap(void *l, void *r, void *args)
+{
+	struct bucket *lhs = l, *rhs = r;
 
-#define bucket_max_cmp(l, r)	(bucket_prio(l) < bucket_prio(r))
-#define bucket_min_cmp(l, r)	(bucket_prio(l) > bucket_prio(r))
+	swap(*lhs, *rhs);
+}
 
 static void invalidate_buckets_lru(struct cache *ca)
 {
 	struct bucket *b;
-	ssize_t i;
+	const struct min_heap_callbacks bucket_max_cmp_callback = {
+		.less = bucket_max_cmp,
+		.swp = bucket_swap,
+	};
+	const struct min_heap_callbacks bucket_min_cmp_callback = {
+		.less = bucket_min_cmp,
+		.swp = bucket_swap,
+	};
 
-	ca->heap.used = 0;
+	ca->heap.heap.nr = 0;
 
 	for_each_bucket(b, ca) {
 		if (!bch_can_invalidate_bucket(ca, b))
 			continue;
 
-		if (!heap_full(&ca->heap))
-			heap_add(&ca->heap, b, bucket_max_cmp);
-		else if (bucket_max_cmp(b, heap_peek(&ca->heap))) {
-			ca->heap.data[0] = b;
-			heap_sift(&ca->heap, 0, bucket_max_cmp);
+		if (!min_heap_full(&ca->heap))
+			min_heap_push(&ca->heap, b, &bucket_max_cmp_callback, ca);
+		else if (!bucket_max_cmp(b, min_heap_peek(&ca->heap), ca)) {
+			*min_heap_peek(&ca->heap) = b;
+			min_heapify(&ca->heap, 0, &bucket_max_cmp_callback, ca);
 		}
 	}
 
-	for (i = ca->heap.used / 2 - 1; i >= 0; --i)
-		heap_sift(&ca->heap, i, bucket_min_cmp);
+	min_heapify_all(&ca->heap, &bucket_min_cmp_callback, ca);
 
 	while (!fifo_full(&ca->free_inc)) {
-		if (!heap_pop(&ca->heap, b, bucket_min_cmp)) {
+		b = *min_heap_peek(&ca->heap);
+		if (!min_heap_pop(&ca->heap, &bucket_min_cmp_callback, ca)) {
 			/*
 			 * We don't want to be calling invalidate_buckets()
 			 * multiple times when it can't do anything
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 4e6afa89921f..97b0a1768ba7 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -457,7 +457,7 @@ struct cache {
 	/* Allocation stuff: */
 	struct bucket		*buckets;
 
-	DECLARE_HEAP(struct bucket *, heap);
+	MIN_HEAP(struct bucket *, heap) heap;
 
 	/*
 	 * If nonzero, we know we aren't going to find any buckets to invalidate
diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index 2bba4d6aaaa2..04187f800c78 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -56,7 +56,9 @@ int __bch_count_data(struct btree_keys *b)
 	unsigned int ret = 0;
 	struct btree_iter iter;
 	struct bkey *k;
+	struct btree_iter_set data[MAX_BSETS];
 
+	iter.heap.heap.data = data;
 	if (b->ops->is_extents)
 		for_each_key(b, k, &iter)
 			ret += KEY_SIZE(k);
@@ -69,6 +71,9 @@ void __bch_check_keys(struct btree_keys *b, const char *fmt, ...)
 	struct bkey *k, *p = NULL;
 	struct btree_iter iter;
 	const char *err;
+	struct btree_iter_set data[MAX_BSETS];
+
+	iter.heap.heap.data = data;
 
 	for_each_key(b, k, &iter) {
 		if (b->ops->is_extents) {
@@ -110,9 +115,9 @@ void __bch_check_keys(struct btree_keys *b, const char *fmt, ...)
 
 static void bch_btree_iter_next_check(struct btree_iter *iter)
 {
-	struct bkey *k = iter->data->k, *next = bkey_next(k);
+	struct bkey *k = min_heap_peek(&iter->heap)->k, *next = bkey_next(k);
 
-	if (next < iter->data->end &&
+	if (next < min_heap_peek(&iter->heap)->end &&
 	    bkey_cmp(k, iter->b->ops->is_extents ?
 		     &START_KEY(next) : next) > 0) {
 		bch_dump_bucket(iter->b);
@@ -882,6 +887,9 @@ unsigned int bch_btree_insert_key(struct btree_keys *b, struct bkey *k,
 	struct btree_iter iter;
 	struct bkey preceding_key_on_stack = ZERO_KEY;
 	struct bkey *preceding_key_p = &preceding_key_on_stack;
+	struct btree_iter_set data[MAX_BSETS];
+
+	iter.heap.heap.data = data;
 
 	BUG_ON(b->ops->is_extents && !KEY_SIZE(k));
 
@@ -1077,27 +1085,34 @@ struct bkey *__bch_bset_search(struct btree_keys *b, struct bset_tree *t,
 
 /* Btree iterator */
 
-typedef bool (btree_iter_cmp_fn)(struct btree_iter_set,
-				 struct btree_iter_set);
+typedef bool (btree_iter_cmp_fn)(const void *, const void *, void *);
 
-static inline bool btree_iter_cmp(struct btree_iter_set l,
-				  struct btree_iter_set r)
+static inline bool btree_iter_cmp(const void *l, const void *r, void *args)
 {
-	return bkey_cmp(l.k, r.k) > 0;
+	const struct btree_iter_set *_l = l;
+	const struct btree_iter_set *_r = r;
+
+	return bkey_cmp(_l->k, _r->k) <= 0;
 }
 
 static inline bool btree_iter_end(struct btree_iter *iter)
 {
-	return !iter->used;
+	return !iter->heap.heap.nr;
 }
 
 void bch_btree_iter_push(struct btree_iter *iter, struct bkey *k,
 			 struct bkey *end)
 {
+	const struct min_heap_callbacks callbacks = {
+		.less = btree_iter_cmp,
+		.swp = btree_iter_swap,
+	};
+
 	if (k != end)
-		BUG_ON(!heap_add(iter,
-				 ((struct btree_iter_set) { k, end }),
-				 btree_iter_cmp));
+		BUG_ON(!min_heap_push(&iter->heap,
+				 &((struct btree_iter_set){ k, end }),
+				 &callbacks,
+				 NULL));
 }
 
 static struct bkey *__bch_btree_iter_init(struct btree_keys *b,
@@ -1107,8 +1122,8 @@ static struct bkey *__bch_btree_iter_init(struct btree_keys *b,
 {
 	struct bkey *ret = NULL;
 
-	iter->size = ARRAY_SIZE(iter->data);
-	iter->used = 0;
+	iter->heap.heap.size = MAX_BSETS;
+	iter->heap.heap.nr = 0;
 
 #ifdef CONFIG_BCACHE_DEBUG
 	iter->b = b;
@@ -1134,22 +1149,28 @@ static inline struct bkey *__bch_btree_iter_next(struct btree_iter *iter,
 {
 	struct btree_iter_set b __maybe_unused;
 	struct bkey *ret = NULL;
+	const struct min_heap_callbacks callbacks = {
+		.less = cmp,
+		.swp = btree_iter_swap,
+	};
 
 	if (!btree_iter_end(iter)) {
 		bch_btree_iter_next_check(iter);
 
-		ret = iter->data->k;
-		iter->data->k = bkey_next(iter->data->k);
+		ret = min_heap_peek(&iter->heap)->k;
+		min_heap_peek(&iter->heap)->k = bkey_next(min_heap_peek(&iter->heap)->k);
 
-		if (iter->data->k > iter->data->end) {
+		if (min_heap_peek(&iter->heap)->k > min_heap_peek(&iter->heap)->end) {
 			WARN_ONCE(1, "bset was corrupt!\n");
-			iter->data->k = iter->data->end;
+			min_heap_peek(&iter->heap)->k = min_heap_peek(&iter->heap)->end;
 		}
 
-		if (iter->data->k == iter->data->end)
-			heap_pop(iter, b, cmp);
+		if (min_heap_peek(&iter->heap)->k == min_heap_peek(&iter->heap)->end) {
+			b = *min_heap_peek(&iter->heap);
+			min_heap_pop(&iter->heap, &callbacks, NULL);
+		}
 		else
-			heap_sift(iter, 0, cmp);
+			min_heapify(&iter->heap, 0, &callbacks, NULL);
 	}
 
 	return ret;
@@ -1195,16 +1216,18 @@ static void btree_mergesort(struct btree_keys *b, struct bset *out,
 			    struct btree_iter *iter,
 			    bool fixup, bool remove_stale)
 {
-	int i;
 	struct bkey *k, *last = NULL;
 	BKEY_PADDED(k) tmp;
 	bool (*bad)(struct btree_keys *, const struct bkey *) = remove_stale
 		? bch_ptr_bad
 		: bch_ptr_invalid;
+	const struct min_heap_callbacks callbacks = {
+		.less = b->ops->sort_cmp,
+		.swp = btree_iter_swap,
+	};
 
 	/* Heapify the iterator, using our comparison function */
-	for (i = iter->used / 2 - 1; i >= 0; --i)
-		heap_sift(iter, i, b->ops->sort_cmp);
+	min_heapify_all(&iter->heap, &callbacks, NULL);
 
 	while (!btree_iter_end(iter)) {
 		if (b->ops->sort_fixup && fixup)
@@ -1295,7 +1318,9 @@ void bch_btree_sort_partial(struct btree_keys *b, unsigned int start,
 	size_t order = b->page_order, keys = 0;
 	struct btree_iter iter;
 	int oldsize = bch_count_data(b);
+	struct btree_iter_set data[MAX_BSETS];
 
+	iter.heap.heap.data = data;
 	__bch_btree_iter_init(b, &iter, NULL, &b->set[start]);
 
 	if (start) {
@@ -1324,7 +1349,9 @@ void bch_btree_sort_into(struct btree_keys *b, struct btree_keys *new,
 {
 	uint64_t start_time = local_clock();
 	struct btree_iter iter;
+	struct btree_iter_set data[MAX_BSETS];
 
+	iter.heap.heap.data = data;
 	bch_btree_iter_init(b, &iter, NULL);
 
 	btree_mergesort(b, new->set->data, &iter, false, true);
diff --git a/drivers/md/bcache/bset.h b/drivers/md/bcache/bset.h
index d795c84246b0..c764127937df 100644
--- a/drivers/md/bcache/bset.h
+++ b/drivers/md/bcache/bset.h
@@ -152,6 +152,19 @@ struct btree_iter;
 struct btree_iter_set;
 struct bkey_float;
 
+/* Btree key iteration */
+
+struct btree_iter_set {
+	struct bkey *k, *end;
+};
+
+struct btree_iter {
+#ifdef CONFIG_BCACHE_DEBUG
+	struct btree_keys *b;
+#endif
+	MIN_HEAP(struct btree_iter_set, btree_iter_heap) heap;
+};
+
 #define MAX_BSETS		4U
 
 struct bset_tree {
@@ -187,8 +200,9 @@ struct bset_tree {
 };
 
 struct btree_keys_ops {
-	bool		(*sort_cmp)(struct btree_iter_set l,
-				    struct btree_iter_set r);
+	bool		(*sort_cmp)(const void *l,
+				    const void *r,
+					void *args);
 	struct bkey	*(*sort_fixup)(struct btree_iter *iter,
 				       struct bkey *tmp);
 	bool		(*insert_fixup)(struct btree_keys *b,
@@ -258,6 +272,14 @@ static inline unsigned int bset_sector_offset(struct btree_keys *b,
 	return bset_byte_offset(b, i) >> 9;
 }
 
+static inline void btree_iter_swap(void *iter1, void *iter2, void *args)
+{
+	struct btree_iter_set *_iter1 = iter1;
+	struct btree_iter_set *_iter2 = iter2;
+
+	swap(*_iter1, *_iter2);
+}
+
 #define __set_bytes(i, k)	(sizeof(*(i)) + (k) * sizeof(uint64_t))
 #define set_bytes(i)		__set_bytes(i, i->keys)
 
@@ -312,18 +334,6 @@ enum {
 	BTREE_INSERT_STATUS_FRONT_MERGE,
 };
 
-/* Btree key iteration */
-
-struct btree_iter {
-	size_t size, used;
-#ifdef CONFIG_BCACHE_DEBUG
-	struct btree_keys *b;
-#endif
-	struct btree_iter_set {
-		struct bkey *k, *end;
-	} data[MAX_BSETS];
-};
-
 typedef bool (*ptr_filter_fn)(struct btree_keys *b, const struct bkey *k);
 
 struct bkey *bch_btree_iter_next(struct btree_iter *iter);
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 196cdacce38f..e7333a8c4819 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -157,8 +157,8 @@ void bch_btree_node_read_done(struct btree *b)
 	 * See the comment arount cache_set->fill_iter.
 	 */
 	iter = mempool_alloc(&b->c->fill_iter, GFP_NOIO);
-	iter->size = b->c->cache->sb.bucket_size / b->c->cache->sb.block_size;
-	iter->used = 0;
+	iter->heap.heap.size = b->c->cache->sb.bucket_size / b->c->cache->sb.block_size;
+	iter->heap.heap.nr = 0;
 
 #ifdef CONFIG_BCACHE_DEBUG
 	iter->b = &b->keys;
@@ -1311,6 +1311,9 @@ static bool btree_gc_mark_node(struct btree *b, struct gc_stat *gc)
 	struct bkey *k;
 	struct btree_iter iter;
 	struct bset_tree *t;
+	struct btree_iter_set data[MAX_BSETS];
+
+	iter.heap.heap.data = data;
 
 	gc->nodes++;
 
@@ -1572,6 +1575,9 @@ static unsigned int btree_gc_count_keys(struct btree *b)
 	struct bkey *k;
 	struct btree_iter iter;
 	unsigned int ret = 0;
+	struct btree_iter_set data[MAX_BSETS];
+
+	iter.heap.heap.data = data;
 
 	for_each_key_filter(&b->keys, k, &iter, bch_ptr_bad)
 		ret += bkey_u64s(k);
@@ -1614,6 +1620,9 @@ static int btree_gc_recurse(struct btree *b, struct btree_op *op,
 	struct btree_iter iter;
 	struct gc_merge_info r[GC_MERGE_NODES];
 	struct gc_merge_info *i, *last = r + ARRAY_SIZE(r) - 1;
+	struct btree_iter_set data[MAX_BSETS];
+
+	iter.heap.heap.data = data;
 
 	bch_btree_iter_init(&b->keys, &iter, &b->c->gc_done);
 
@@ -1912,6 +1921,9 @@ static int bch_btree_check_recurse(struct btree *b, struct btree_op *op)
 	int ret = 0;
 	struct bkey *k, *p = NULL;
 	struct btree_iter iter;
+	struct btree_iter_set data[MAX_BSETS];
+
+	iter.heap.heap.data = data;
 
 	for_each_key_filter(&b->keys, k, &iter, bch_ptr_invalid)
 		bch_initial_mark_key(b->c, b->level, k);
@@ -1953,7 +1965,9 @@ static int bch_btree_check_thread(void *arg)
 	struct btree_iter iter;
 	struct bkey *k, *p;
 	int cur_idx, prev_idx, skip_nr;
+	struct btree_iter_set data[MAX_BSETS];
 
+	iter.heap.heap.data = data;
 	k = p = NULL;
 	cur_idx = prev_idx = 0;
 	ret = 0;
@@ -2053,6 +2067,9 @@ int bch_btree_check(struct cache_set *c)
 	struct bkey *k = NULL;
 	struct btree_iter iter;
 	struct btree_check_state check_state;
+	struct btree_iter_set data[MAX_BSETS];
+
+	iter.heap.heap.data = data;
 
 	/* check and mark root node keys */
 	for_each_key_filter(&c->root->keys, k, &iter, bch_ptr_invalid)
@@ -2548,6 +2565,9 @@ static int bch_btree_map_nodes_recurse(struct btree *b, struct btree_op *op,
 	if (b->level) {
 		struct bkey *k;
 		struct btree_iter iter;
+		struct btree_iter_set data[MAX_BSETS];
+
+		iter.heap.heap.data = data;
 
 		bch_btree_iter_init(&b->keys, &iter, from);
 
@@ -2581,6 +2601,9 @@ int bch_btree_map_keys_recurse(struct btree *b, struct btree_op *op,
 	int ret = MAP_CONTINUE;
 	struct bkey *k;
 	struct btree_iter iter;
+	struct btree_iter_set data[MAX_BSETS];
+
+	iter.heap.heap.data = data;
 
 	bch_btree_iter_init(&b->keys, &iter, from);
 
diff --git a/drivers/md/bcache/extents.c b/drivers/md/bcache/extents.c
index d626ffcbecb9..ee6057558d4b 100644
--- a/drivers/md/bcache/extents.c
+++ b/drivers/md/bcache/extents.c
@@ -32,16 +32,19 @@ static void sort_key_next(struct btree_iter *iter,
 {
 	i->k = bkey_next(i->k);
 
-	if (i->k == i->end)
-		*i = iter->data[--iter->used];
+	if (i->k == i->end) {
+		struct btree_iter_set *data = iter->heap.heap.data;
+		*i = data[--iter->heap.heap.nr];
+	}
 }
 
-static bool bch_key_sort_cmp(struct btree_iter_set l,
-			     struct btree_iter_set r)
+static bool bch_key_sort_cmp(const void *l, const void *r, void *args)
 {
-	int64_t c = bkey_cmp(l.k, r.k);
+	struct btree_iter_set *_l = (struct btree_iter_set *)l;
+	struct btree_iter_set *_r = (struct btree_iter_set *)r;
+	int64_t c = bkey_cmp(_l->k, _r->k);
 
-	return c ? c > 0 : l.k < r.k;
+	return !(c ? c > 0 : _l->k < _r->k);
 }
 
 static bool __ptr_invalid(struct cache_set *c, const struct bkey *k)
@@ -255,22 +258,29 @@ const struct btree_keys_ops bch_btree_keys_ops = {
  * Necessary for btree_sort_fixup() - if there are multiple keys that compare
  * equal in different sets, we have to process them newest to oldest.
  */
-static bool bch_extent_sort_cmp(struct btree_iter_set l,
-				struct btree_iter_set r)
+static bool bch_extent_sort_cmp(const void *l, const void *r, void *args)
 {
-	int64_t c = bkey_cmp(&START_KEY(l.k), &START_KEY(r.k));
+	struct btree_iter_set *_l = (struct btree_iter_set *)l;
+	struct btree_iter_set *_r = (struct btree_iter_set *)r;
+
+	int64_t c = bkey_cmp(&START_KEY(_l->k), &START_KEY(_r->k));
 
-	return c ? c > 0 : l.k < r.k;
+	return !(c ? c > 0 : _l->k < _r->k);
 }
 
 static struct bkey *bch_extent_sort_fixup(struct btree_iter *iter,
 					  struct bkey *tmp)
 {
-	while (iter->used > 1) {
-		struct btree_iter_set *top = iter->data, *i = top + 1;
+	const struct min_heap_callbacks callbacks = {
+		.less = bch_extent_sort_cmp,
+		.swp = btree_iter_swap,
+	};
+
+	while (iter->heap.heap.nr > 1) {
+		struct btree_iter_set *top = min_heap_peek(&iter->heap), *i = top + 1;
 
-		if (iter->used > 2 &&
-		    bch_extent_sort_cmp(i[0], i[1]))
+		if (iter->heap.heap.nr > 2 &&
+		    !bch_extent_sort_cmp(&i[0], &i[1], NULL))
 			i++;
 
 		if (bkey_cmp(top->k, &START_KEY(i->k)) <= 0)
@@ -278,7 +288,7 @@ static struct bkey *bch_extent_sort_fixup(struct btree_iter *iter,
 
 		if (!KEY_SIZE(i->k)) {
 			sort_key_next(iter, i);
-			heap_sift(iter, i - top, bch_extent_sort_cmp);
+			min_heapify(&iter->heap, i - top, &callbacks, NULL);
 			continue;
 		}
 
@@ -288,7 +298,7 @@ static struct bkey *bch_extent_sort_fixup(struct btree_iter *iter,
 			else
 				bch_cut_front(top->k, i->k);
 
-			heap_sift(iter, i - top, bch_extent_sort_cmp);
+			min_heapify(&iter->heap, i - top, &callbacks, NULL);
 		} else {
 			/* can't happen because of comparison func */
 			BUG_ON(!bkey_cmp(&START_KEY(top->k), &START_KEY(i->k)));
@@ -298,7 +308,7 @@ static struct bkey *bch_extent_sort_fixup(struct btree_iter *iter,
 
 				bch_cut_back(&START_KEY(i->k), tmp);
 				bch_cut_front(i->k, top->k);
-				heap_sift(iter, 0, bch_extent_sort_cmp);
+				min_heapify(&iter->heap, 0, &callbacks, NULL);
 
 				return tmp;
 			} else {
diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index ebd500bdf0b2..9f8aaf0845dc 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -182,16 +182,27 @@ err:		if (!IS_ERR_OR_NULL(w->private))
 	closure_sync(&cl);
 }
 
-static bool bucket_cmp(struct bucket *l, struct bucket *r)
+static bool bucket_cmp(const void *l, const void *r, void *args)
 {
-	return GC_SECTORS_USED(l) < GC_SECTORS_USED(r);
+	struct bucket *_l = (struct bucket *)l;
+	struct bucket *_r = (struct bucket *)r;
+
+	return GC_SECTORS_USED(_l) >= GC_SECTORS_USED(_r);
+}
+
+static void bucket_swap(void *l, void *r, void *args)
+{
+	struct bucket *_l = l;
+	struct bucket *_r = r;
+
+	swap(*_l, *_r);
 }
 
 static unsigned int bucket_heap_top(struct cache *ca)
 {
 	struct bucket *b;
 
-	return (b = heap_peek(&ca->heap)) ? GC_SECTORS_USED(b) : 0;
+	return (b = *min_heap_peek(&ca->heap)) ? GC_SECTORS_USED(b) : 0;
 }
 
 void bch_moving_gc(struct cache_set *c)
@@ -199,6 +210,10 @@ void bch_moving_gc(struct cache_set *c)
 	struct cache *ca = c->cache;
 	struct bucket *b;
 	unsigned long sectors_to_move, reserve_sectors;
+	const struct min_heap_callbacks callbacks = {
+		.less = bucket_cmp,
+		.swp = bucket_swap,
+	};
 
 	if (!c->copy_gc_enabled)
 		return;
@@ -209,7 +224,7 @@ void bch_moving_gc(struct cache_set *c)
 	reserve_sectors = ca->sb.bucket_size *
 			     fifo_used(&ca->free[RESERVE_MOVINGGC]);
 
-	ca->heap.used = 0;
+	ca->heap.heap.nr = 0;
 
 	for_each_bucket(b, ca) {
 		if (GC_MARK(b) == GC_MARK_METADATA ||
@@ -218,25 +233,28 @@ void bch_moving_gc(struct cache_set *c)
 		    atomic_read(&b->pin))
 			continue;
 
-		if (!heap_full(&ca->heap)) {
+		if (!min_heap_full(&ca->heap)) {
 			sectors_to_move += GC_SECTORS_USED(b);
-			heap_add(&ca->heap, b, bucket_cmp);
-		} else if (bucket_cmp(b, heap_peek(&ca->heap))) {
+			min_heap_push(&ca->heap, b, &callbacks, NULL);
+		} else if (!bucket_cmp(b, min_heap_peek(&ca->heap), NULL)) {
 			sectors_to_move -= bucket_heap_top(ca);
 			sectors_to_move += GC_SECTORS_USED(b);
 
-			ca->heap.data[0] = b;
-			heap_sift(&ca->heap, 0, bucket_cmp);
+			*min_heap_peek(&ca->heap) = b;
+			min_heapify(&ca->heap, 0, &callbacks, NULL);
 		}
 	}
 
 	while (sectors_to_move > reserve_sectors) {
-		heap_pop(&ca->heap, b, bucket_cmp);
+		b = *min_heap_peek(&ca->heap);
+		min_heap_pop(&ca->heap, &callbacks, NULL);
 		sectors_to_move -= GC_SECTORS_USED(b);
 	}
 
-	while (heap_pop(&ca->heap, b, bucket_cmp))
+	while ((b = *min_heap_peek(&ca->heap))) {
+		min_heap_pop(&ca->heap, &callbacks, NULL);
 		SET_GC_MOVE(b, 1);
+	}
 
 	mutex_unlock(&c->bucket_lock);
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 330bcd9ea4a9..1c6aeeff2cc3 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2193,6 +2193,22 @@ static const char *register_cache_set(struct cache *ca)
 	return err;
 }
 
+static inline bool init_heap(struct heap *heap, size_t size, gfp_t gfp)
+{
+	size_t bytes = size * sizeof(struct bucket *);
+	void *data = kvmalloc(bytes, (gfp) & GFP_KERNEL);
+
+	min_heap_init(heap, data, size);
+
+	return data;
+}
+
+static inline void free_heap(struct heap *heap)
+{
+	kvfree(heap->heap.data);
+	heap->heap.data = NULL;
+}
+
 /* Cache device */
 
 /* When ca->kobj released */
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 6956beb55326..eac2039c2cad 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -661,6 +661,9 @@ static unsigned int bch_root_usage(struct cache_set *c)
 	struct bkey *k;
 	struct btree *b;
 	struct btree_iter iter;
+	struct btree_iter_set data[MAX_BSETS];
+
+	iter.heap.heap.data = data;
 
 	goto lock_root;
 
diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index f61ab1bada6c..fa928d1d327a 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -7,6 +7,7 @@
 #include <linux/closure.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
+#include <linux/min_heap.h>
 #include <linux/sched/clock.h>
 #include <linux/llist.h>
 #include <linux/ratelimit.h>
@@ -30,86 +31,6 @@ struct closure;
 
 #endif
 
-#define DECLARE_HEAP(type, name)					\
-	struct {							\
-		size_t size, used;					\
-		type *data;						\
-	} name
-
-#define init_heap(heap, _size, gfp)					\
-({									\
-	size_t _bytes;							\
-	(heap)->used = 0;						\
-	(heap)->size = (_size);						\
-	_bytes = (heap)->size * sizeof(*(heap)->data);			\
-	(heap)->data = kvmalloc(_bytes, (gfp) & GFP_KERNEL);		\
-	(heap)->data;							\
-})
-
-#define free_heap(heap)							\
-do {									\
-	kvfree((heap)->data);						\
-	(heap)->data = NULL;						\
-} while (0)
-
-#define heap_swap(h, i, j)	swap((h)->data[i], (h)->data[j])
-
-#define heap_sift(h, i, cmp)						\
-do {									\
-	size_t _r, _j = i;						\
-									\
-	for (; _j * 2 + 1 < (h)->used; _j = _r) {			\
-		_r = _j * 2 + 1;					\
-		if (_r + 1 < (h)->used &&				\
-		    cmp((h)->data[_r], (h)->data[_r + 1]))		\
-			_r++;						\
-									\
-		if (cmp((h)->data[_r], (h)->data[_j]))			\
-			break;						\
-		heap_swap(h, _r, _j);					\
-	}								\
-} while (0)
-
-#define heap_sift_down(h, i, cmp)					\
-do {									\
-	while (i) {							\
-		size_t p = (i - 1) / 2;					\
-		if (cmp((h)->data[i], (h)->data[p]))			\
-			break;						\
-		heap_swap(h, i, p);					\
-		i = p;							\
-	}								\
-} while (0)
-
-#define heap_add(h, d, cmp)						\
-({									\
-	bool _r = !heap_full(h);					\
-	if (_r) {							\
-		size_t _i = (h)->used++;				\
-		(h)->data[_i] = d;					\
-									\
-		heap_sift_down(h, _i, cmp);				\
-		heap_sift(h, _i, cmp);					\
-	}								\
-	_r;								\
-})
-
-#define heap_pop(h, d, cmp)						\
-({									\
-	bool _r = (h)->used;						\
-	if (_r) {							\
-		(d) = (h)->data[0];					\
-		(h)->used--;						\
-		heap_swap(h, 0, (h)->used);				\
-		heap_sift(h, 0, cmp);					\
-	}								\
-	_r;								\
-})
-
-#define heap_peek(h)	((h)->used ? (h)->data[0] : NULL)
-
-#define heap_full(h)	((h)->used == (h)->size)
-
 #define DECLARE_FIFO(type, name)					\
 	struct {							\
 		size_t front, back, size, mask;				\
-- 
2.34.1


