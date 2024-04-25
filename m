Return-Path: <linux-bcache+bounces-420-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2FA78B23F5
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 16:24:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99E19286AE9
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 14:24:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FD93154C02;
	Thu, 25 Apr 2024 14:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tiki8xqT"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBAC14AD3A;
	Thu, 25 Apr 2024 14:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714054789; cv=none; b=WAHFeDqxO0Osn/vFi0/CLG8lJpGLhON/6DkVewYLL+nGI+FiKfLqNu0lkIH4aDTr4IH76hculh2tSxRCd8Rtj4caL52nnfe5uT+hmuJ7ycfJ33/6eUYYl9+fDDzn9nB6kBkIWrbjIpDwRaehSrB0c94i0KT+J9PqwoDRGDrwclM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714054789; c=relaxed/simple;
	bh=eBsSINQpfUw2knfqZ46/sz6JrgzrMA+szIiOKC8yAjo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hkzmOffs+a6v68RMHPyz/HP1Pxe2iOBaf6G+7ZApSwtjzdDLFE2E8rKOvOUBcrDoruYf47Xf+4wqavrEPdvQoNuJ4K5Wj/WHr86REwoiPkiPjd01ILcqJsKqxoeKsUsajMDAfivuvG4jKaENdpTeyOgCkYhFFed4j3kpMyNVe5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tiki8xqT; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6f013c304bbso76189b3a.1;
        Thu, 25 Apr 2024 07:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714054785; x=1714659585; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j1lt3vXCm88uSeUAOFNaV+qax3qBG7zS/iOIdgqCm+s=;
        b=Tiki8xqTN5WC4oD6lh0LAy2IilOpPA1dZsfFGU6JQSYcENKTBmKO9HkxHJ1I4YL1Zg
         q5KibuIgrspHqFsg4ZJSL8auuJricEhoYB455LtYBLhCcqMTzD/A8WHu0UaPNyajoVGR
         a713GMq26plC2gmtRWE31o59LdWi7nzNamUoDGIm9iZWPqtrKqQxQF243TL/Bx7cx1Zs
         geYVQPELfer4W49d+uMiakLqyOInMHIk0yD9bFwp+w5fmL4VkgkoRkP8sM6EJyVfLgiT
         k49hgrICrnhXkPSpMMIAyMNIujYm8ei412oe09mg2WjdJePeZ7NPiPq3uofrywOmZKuq
         dggQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714054785; x=1714659585;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j1lt3vXCm88uSeUAOFNaV+qax3qBG7zS/iOIdgqCm+s=;
        b=b/ig8dnFjWd7z3S4ew0U++7XrMqbLgPUTDZ1flLL6J8iIjUbe+jZJvTPQI9BQI4qY4
         nV9lbuFBU/wYkK7bxc3p9c3ehTL9RGrxJXep55+xBPNsjsG62S44nHYr3aWvg7mIWWRE
         YcdgwscOyYcjAoCsrs3fWGZJAR6PWdBd5vkfDVJnw/80vwXMNklNtKJJhk3QgDD3vUnD
         ShdCeEPa3G1rM8zwSFFZZIxFkFCR8+g/QjShctu46Kj0G0QZ7KzKg653difxgHS1I680
         VOr5dZMa1I73OhmJKG3rLl8Mwq5lAmaVi5Uyhx6aC0L0rdYNDcsNBcSe980Vg1HnWLXa
         vAHA==
X-Forwarded-Encrypted: i=1; AJvYcCWlmbAsiPgte7KkFkmj8/L3oI9l1bqS8HhNYyhyFvDWHvDPiFJ109+V33X+ll2xvqLy8uPVmCfBMckg7GCjMaz1OAyF2+QFQ4cqENlfPJQQ8P60dDJbFRKTS+OEscC9hPYbgAp5VcdXvELgBIOoqzrmEZd8t5BlX5uR9Kf3m+Dw+MAerXCfGT7uTZTrQgmZqJoqvshlYguctokBZLj3DAruC/BDiKfSc/aTNprp
X-Gm-Message-State: AOJu0Ywz1bWewFcANJK2PBDmAMC3VOTT+tXygw5x5AJi3EKWT4H2Prsx
	9rWIwX+09EQ6JrmlmhvU0puX0TEw/EbNFdiAWrKP366kMl2q2WwV
X-Google-Smtp-Source: AGHT+IFa2LoTY8DvhCvOupa5u6JZdUu37oEXGEjx97qVXZ8or1FVRa6V6ToTglPVXJ+5Xn3lP6LtLA==
X-Received: by 2002:a05:6a21:2717:b0:1ad:7e79:e291 with SMTP id rm23-20020a056a21271700b001ad7e79e291mr5983363pzb.0.1714054784850;
        Thu, 25 Apr 2024 07:19:44 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id go20-20020a056a003b1400b006e6233563cesm13162397pfb.218.2024.04.25.07.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 07:19:44 -0700 (PDT)
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
Subject: [PATCH v4 15/16] bcache: Remove heap-related macros and switch to generic min_heap
Date: Thu, 25 Apr 2024 22:18:25 +0800
Message-Id: <20240425141826.840077-16-visitorckw@gmail.com>
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

Drop the heap-related macros from bcache and replacing them with the
generic min_heap implementation from include/linux. By doing so, code
readability is improved by using functions instead of macros. Moreover,
the min_heap implementation in include/linux adopts a bottom-up
variation compared to the textbook version currently used in bcache.
This bottom-up variation allows for approximately 50% reduction in the
number of comparison operations during heap siftdown, without changing
the number of swaps, thus making it more efficient.

Link: https://lkml.kernel.org/ioyfizrzq7w7mjrqcadtzsfgpuntowtjdw5pgn4qhvsdp4mqqg@nrlek5vmisbu
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Acked-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/alloc.c     | 64 +++++++++++++++++++-------
 drivers/md/bcache/bcache.h    |  2 +-
 drivers/md/bcache/bset.c      | 84 ++++++++++++++++++++++++-----------
 drivers/md/bcache/bset.h      | 14 +++---
 drivers/md/bcache/btree.c     | 17 ++++++-
 drivers/md/bcache/extents.c   | 53 ++++++++++++++--------
 drivers/md/bcache/movinggc.c  | 41 ++++++++++++-----
 drivers/md/bcache/sysfs.c     |  2 +
 drivers/md/bcache/util.h      | 67 +---------------------------
 drivers/md/bcache/writeback.c |  3 ++
 10 files changed, 202 insertions(+), 145 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index ce13c272c387..8cfa15ea32b4 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -166,40 +166,68 @@ static void bch_invalidate_one_bucket(struct cache *ca, struct bucket *b)
  * prio is worth 1/8th of what INITIAL_PRIO is worth.
  */
 
-#define bucket_prio(b)							\
-({									\
-	unsigned int min_prio = (INITIAL_PRIO - ca->set->min_prio) / 8;	\
-									\
-	(b->prio - ca->set->min_prio + min_prio) * GC_SECTORS_USED(b);	\
-})
+static inline unsigned int new_bucket_prio(struct cache *ca, struct bucket *b)
+{
+	unsigned int min_prio = (INITIAL_PRIO - ca->set->min_prio) / 8;
+
+	return (b->prio - ca->set->min_prio + min_prio) * GC_SECTORS_USED(b);
+}
+
+static inline bool new_bucket_max_cmp(const void *l, const void *r, void *args)
+{
+	struct bucket **lhs = (struct bucket **)l;
+	struct bucket **rhs = (struct bucket **)r;
+	struct cache *ca = args;
+
+	return new_bucket_prio(ca, *lhs) > new_bucket_prio(ca, *rhs);
+}
 
-#define bucket_max_cmp(l, r)	(bucket_prio(l) < bucket_prio(r))
-#define bucket_min_cmp(l, r)	(bucket_prio(l) > bucket_prio(r))
+static inline bool new_bucket_min_cmp(const void *l, const void *r, void *args)
+{
+	struct bucket **lhs = (struct bucket **)l;
+	struct bucket **rhs = (struct bucket **)r;
+	struct cache *ca = args;
+
+	return new_bucket_prio(ca, *lhs) < new_bucket_prio(ca, *rhs);
+}
+
+static inline void new_bucket_swap(void *l, void *r, void __always_unused *args)
+{
+	struct bucket **lhs = l, **rhs = r;
+
+	swap(*lhs, *rhs);
+}
 
 static void invalidate_buckets_lru(struct cache *ca)
 {
 	struct bucket *b;
-	ssize_t i;
+	const struct min_heap_callbacks bucket_max_cmp_callback = {
+		.less = new_bucket_max_cmp,
+		.swp = new_bucket_swap,
+	};
+	const struct min_heap_callbacks bucket_min_cmp_callback = {
+		.less = new_bucket_min_cmp,
+		.swp = new_bucket_swap,
+	};
 
-	ca->heap.used = 0;
+	ca->heap.nr = 0;
 
 	for_each_bucket(b, ca) {
 		if (!bch_can_invalidate_bucket(ca, b))
 			continue;
 
-		if (!heap_full(&ca->heap))
-			heap_add(&ca->heap, b, bucket_max_cmp);
-		else if (bucket_max_cmp(b, heap_peek(&ca->heap))) {
+		if (!min_heap_full(&ca->heap))
+			min_heap_push(&ca->heap, &b, &bucket_max_cmp_callback, ca);
+		else if (!new_bucket_max_cmp(&b, min_heap_peek(&ca->heap), ca)) {
 			ca->heap.data[0] = b;
-			heap_sift(&ca->heap, 0, bucket_max_cmp);
+			min_heap_sift_down(&ca->heap, 0, &bucket_max_cmp_callback, ca);
 		}
 	}
 
-	for (i = ca->heap.used / 2 - 1; i >= 0; --i)
-		heap_sift(&ca->heap, i, bucket_min_cmp);
+	min_heapify_all(&ca->heap, &bucket_min_cmp_callback, ca);
 
 	while (!fifo_full(&ca->free_inc)) {
-		if (!heap_pop(&ca->heap, b, bucket_min_cmp)) {
+		if (!ca->heap.nr) {
 			/*
 			 * We don't want to be calling invalidate_buckets()
 			 * multiple times when it can't do anything
@@ -208,6 +236,8 @@ static void invalidate_buckets_lru(struct cache *ca)
 			wake_up_gc(ca->set);
 			return;
 		}
+		b = min_heap_peek(&ca->heap)[0];
+		min_heap_pop(&ca->heap, &bucket_min_cmp_callback, ca);
 
 		bch_invalidate_one_bucket(ca, b);
 	}
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 4e6afa89921f..575d1e3a5217 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -457,7 +457,7 @@ struct cache {
 	/* Allocation stuff: */
 	struct bucket		*buckets;
 
-	DECLARE_HEAP(struct bucket *, heap);
+	MIN_HEAP(struct bucket *, cache_heap) heap;
 
 	/*
 	 * If nonzero, we know we aren't going to find any buckets to invalidate
diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index 2bba4d6aaaa2..bd97d8626887 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -57,6 +57,8 @@ int __bch_count_data(struct btree_keys *b)
 	struct btree_iter iter;
 	struct bkey *k;
 
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
+
 	if (b->ops->is_extents)
 		for_each_key(b, k, &iter)
 			ret += KEY_SIZE(k);
@@ -70,6 +72,8 @@ void __bch_check_keys(struct btree_keys *b, const char *fmt, ...)
 	struct btree_iter iter;
 	const char *err;
 
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
+
 	for_each_key(b, k, &iter) {
 		if (b->ops->is_extents) {
 			err = "Keys out of order";
@@ -110,9 +114,9 @@ void __bch_check_keys(struct btree_keys *b, const char *fmt, ...)
 
 static void bch_btree_iter_next_check(struct btree_iter *iter)
 {
-	struct bkey *k = iter->data->k, *next = bkey_next(k);
+	struct bkey *k = iter->heap.data->k, *next = bkey_next(k);
 
-	if (next < iter->data->end &&
+	if (next < iter->heap.data->end &&
 	    bkey_cmp(k, iter->b->ops->is_extents ?
 		     &START_KEY(next) : next) > 0) {
 		bch_dump_bucket(iter->b);
@@ -885,6 +889,8 @@ unsigned int bch_btree_insert_key(struct btree_keys *b, struct bkey *k,
 
 	BUG_ON(b->ops->is_extents && !KEY_SIZE(k));
 
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
+
 	/*
 	 * If k has preceding key, preceding_key_p will be set to address
 	 *  of k's preceding key; otherwise preceding_key_p will be set
@@ -1077,27 +1083,42 @@ struct bkey *__bch_bset_search(struct btree_keys *b, struct bset_tree *t,
 
 /* Btree iterator */
 
-typedef bool (btree_iter_cmp_fn)(struct btree_iter_set,
-				 struct btree_iter_set);
+typedef bool (new_btree_iter_cmp_fn)(const void *, const void *, void *);
+
+static inline bool new_btree_iter_cmp(const void *l, const void *r, void __always_unused *args)
+{
+	const struct btree_iter_set *_l = l;
+	const struct btree_iter_set *_r = r;
+
+	return bkey_cmp(_l->k, _r->k) <= 0;
+}
 
-static inline bool btree_iter_cmp(struct btree_iter_set l,
-				  struct btree_iter_set r)
+static inline void new_btree_iter_swap(void *iter1, void *iter2, void __always_unused *args)
 {
-	return bkey_cmp(l.k, r.k) > 0;
+	struct btree_iter_set *_iter1 = iter1;
+	struct btree_iter_set *_iter2 = iter2;
+
+	swap(*_iter1, *_iter2);
 }
 
 static inline bool btree_iter_end(struct btree_iter *iter)
 {
-	return !iter->used;
+	return !iter->heap.nr;
 }
 
 void bch_btree_iter_push(struct btree_iter *iter, struct bkey *k,
 			 struct bkey *end)
 {
+	const struct min_heap_callbacks callbacks = {
+		.less = new_btree_iter_cmp,
+		.swp = new_btree_iter_swap,
+	};
+
 	if (k != end)
-		BUG_ON(!heap_add(iter,
-				 ((struct btree_iter_set) { k, end }),
-				 btree_iter_cmp));
+		BUG_ON(!min_heap_push(&iter->heap,
+				 &((struct btree_iter_set) { k, end }),
+				 &callbacks,
+				 NULL));
 }
 
 static struct bkey *__bch_btree_iter_init(struct btree_keys *b,
@@ -1107,8 +1128,8 @@ static struct bkey *__bch_btree_iter_init(struct btree_keys *b,
 {
 	struct bkey *ret = NULL;
 
-	iter->size = ARRAY_SIZE(iter->data);
-	iter->used = 0;
+	iter->heap.size = ARRAY_SIZE(iter->heap.preallocated);
+	iter->heap.nr = 0;
 
 #ifdef CONFIG_BCACHE_DEBUG
 	iter->b = b;
@@ -1130,26 +1151,34 @@ struct bkey *bch_btree_iter_init(struct btree_keys *b,
 }
 
 static inline struct bkey *__bch_btree_iter_next(struct btree_iter *iter,
-						 btree_iter_cmp_fn *cmp)
+						 new_btree_iter_cmp_fn *cmp)
 {
 	struct btree_iter_set b __maybe_unused;
 	struct bkey *ret = NULL;
+	const struct min_heap_callbacks callbacks = {
+		.less = cmp,
+		.swp = new_btree_iter_swap,
+	};
 
 	if (!btree_iter_end(iter)) {
 		bch_btree_iter_next_check(iter);
 
-		ret = iter->data->k;
-		iter->data->k = bkey_next(iter->data->k);
+		ret = iter->heap.data->k;
+		iter->heap.data->k = bkey_next(iter->heap.data->k);
 
-		if (iter->data->k > iter->data->end) {
+		if (iter->heap.data->k > iter->heap.data->end) {
 			WARN_ONCE(1, "bset was corrupt!\n");
-			iter->data->k = iter->data->end;
+			iter->heap.data->k = iter->heap.data->end;
 		}
 
-		if (iter->data->k == iter->data->end)
-			heap_pop(iter, b, cmp);
+		if (iter->heap.data->k == iter->heap.data->end) {
+			if (iter->heap.nr) {
+				b = min_heap_peek(&iter->heap)[0];
+				min_heap_pop(&iter->heap, &callbacks, NULL);
+			}
+		}
 		else
-			heap_sift(iter, 0, cmp);
+			min_heap_sift_down(&iter->heap, 0, &callbacks, NULL);
 	}
 
 	return ret;
@@ -1157,7 +1186,7 @@ static inline struct bkey *__bch_btree_iter_next(struct btree_iter *iter,
 
 struct bkey *bch_btree_iter_next(struct btree_iter *iter)
 {
-	return __bch_btree_iter_next(iter, btree_iter_cmp);
+	return __bch_btree_iter_next(iter, new_btree_iter_cmp);
 
 }
 
@@ -1195,16 +1224,18 @@ static void btree_mergesort(struct btree_keys *b, struct bset *out,
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
+		.swp = new_btree_iter_swap,
+	};
 
 	/* Heapify the iterator, using our comparison function */
-	for (i = iter->used / 2 - 1; i >= 0; --i)
-		heap_sift(iter, i, b->ops->sort_cmp);
+	min_heapify_all(&iter->heap, &callbacks, NULL);
 
 	while (!btree_iter_end(iter)) {
 		if (b->ops->sort_fixup && fixup)
@@ -1296,6 +1327,7 @@ void bch_btree_sort_partial(struct btree_keys *b, unsigned int start,
 	struct btree_iter iter;
 	int oldsize = bch_count_data(b);
 
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
 	__bch_btree_iter_init(b, &iter, NULL, &b->set[start]);
 
 	if (start) {
@@ -1325,6 +1357,8 @@ void bch_btree_sort_into(struct btree_keys *b, struct btree_keys *new,
 	uint64_t start_time = local_clock();
 	struct btree_iter iter;
 
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
+
 	bch_btree_iter_init(b, &iter, NULL);
 
 	btree_mergesort(b, new->set->data, &iter, false, true);
diff --git a/drivers/md/bcache/bset.h b/drivers/md/bcache/bset.h
index d795c84246b0..f79441acd4c1 100644
--- a/drivers/md/bcache/bset.h
+++ b/drivers/md/bcache/bset.h
@@ -187,8 +187,9 @@ struct bset_tree {
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
@@ -312,16 +313,17 @@ enum {
 	BTREE_INSERT_STATUS_FRONT_MERGE,
 };
 
+struct btree_iter_set {
+	struct bkey *k, *end;
+};
+
 /* Btree key iteration */
 
 struct btree_iter {
-	size_t size, used;
 #ifdef CONFIG_BCACHE_DEBUG
 	struct btree_keys *b;
 #endif
-	struct btree_iter_set {
-		struct bkey *k, *end;
-	} data[MAX_BSETS];
+	MIN_HEAP_PREALLOCATED(struct btree_iter_set, btree_iter_heap, MAX_BSETS) heap;
 };
 
 typedef bool (*ptr_filter_fn)(struct btree_keys *b, const struct bkey *k);
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 196cdacce38f..a2bb86d52ad4 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -157,8 +157,8 @@ void bch_btree_node_read_done(struct btree *b)
 	 * See the comment arount cache_set->fill_iter.
 	 */
 	iter = mempool_alloc(&b->c->fill_iter, GFP_NOIO);
-	iter->size = b->c->cache->sb.bucket_size / b->c->cache->sb.block_size;
-	iter->used = 0;
+	iter->heap.size = b->c->cache->sb.bucket_size / b->c->cache->sb.block_size;
+	iter->heap.nr = 0;
 
 #ifdef CONFIG_BCACHE_DEBUG
 	iter->b = &b->keys;
@@ -1312,6 +1312,8 @@ static bool btree_gc_mark_node(struct btree *b, struct gc_stat *gc)
 	struct btree_iter iter;
 	struct bset_tree *t;
 
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
+
 	gc->nodes++;
 
 	for_each_key_filter(&b->keys, k, &iter, bch_ptr_invalid) {
@@ -1573,6 +1575,8 @@ static unsigned int btree_gc_count_keys(struct btree *b)
 	struct btree_iter iter;
 	unsigned int ret = 0;
 
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
+
 	for_each_key_filter(&b->keys, k, &iter, bch_ptr_bad)
 		ret += bkey_u64s(k);
 
@@ -1615,6 +1619,7 @@ static int btree_gc_recurse(struct btree *b, struct btree_op *op,
 	struct gc_merge_info r[GC_MERGE_NODES];
 	struct gc_merge_info *i, *last = r + ARRAY_SIZE(r) - 1;
 
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
 	bch_btree_iter_init(&b->keys, &iter, &b->c->gc_done);
 
 	for (i = r; i < r + ARRAY_SIZE(r); i++)
@@ -1913,6 +1918,8 @@ static int bch_btree_check_recurse(struct btree *b, struct btree_op *op)
 	struct bkey *k, *p = NULL;
 	struct btree_iter iter;
 
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
+
 	for_each_key_filter(&b->keys, k, &iter, bch_ptr_invalid)
 		bch_initial_mark_key(b->c, b->level, k);
 
@@ -1958,6 +1965,8 @@ static int bch_btree_check_thread(void *arg)
 	cur_idx = prev_idx = 0;
 	ret = 0;
 
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
+
 	/* root node keys are checked before thread created */
 	bch_btree_iter_init(&c->root->keys, &iter, NULL);
 	k = bch_btree_iter_next_filter(&iter, &c->root->keys, bch_ptr_bad);
@@ -2054,6 +2063,8 @@ int bch_btree_check(struct cache_set *c)
 	struct btree_iter iter;
 	struct btree_check_state check_state;
 
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
+
 	/* check and mark root node keys */
 	for_each_key_filter(&c->root->keys, k, &iter, bch_ptr_invalid)
 		bch_initial_mark_key(c, c->root->level, k);
@@ -2549,6 +2560,7 @@ static int bch_btree_map_nodes_recurse(struct btree *b, struct btree_op *op,
 		struct bkey *k;
 		struct btree_iter iter;
 
+		min_heap_init(&iter.heap, NULL, MAX_BSETS);
 		bch_btree_iter_init(&b->keys, &iter, from);
 
 		while ((k = bch_btree_iter_next_filter(&iter, &b->keys,
@@ -2582,6 +2594,7 @@ int bch_btree_map_keys_recurse(struct btree *b, struct btree_op *op,
 	struct bkey *k;
 	struct btree_iter iter;
 
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
 	bch_btree_iter_init(&b->keys, &iter, from);
 
 	while ((k = bch_btree_iter_next_filter(&iter, &b->keys, bch_ptr_bad))) {
diff --git a/drivers/md/bcache/extents.c b/drivers/md/bcache/extents.c
index d626ffcbecb9..a7221e5dbe81 100644
--- a/drivers/md/bcache/extents.c
+++ b/drivers/md/bcache/extents.c
@@ -33,15 +33,16 @@ static void sort_key_next(struct btree_iter *iter,
 	i->k = bkey_next(i->k);
 
 	if (i->k == i->end)
-		*i = iter->data[--iter->used];
+		*i = iter->heap.data[--iter->heap.nr];
 }
 
-static bool bch_key_sort_cmp(struct btree_iter_set l,
-			     struct btree_iter_set r)
+static bool new_bch_key_sort_cmp(const void *l, const void *r, void *args)
 {
-	int64_t c = bkey_cmp(l.k, r.k);
+	struct btree_iter_set *_l = (struct btree_iter_set *)l;
+	struct btree_iter_set *_r = (struct btree_iter_set *)r;
+	int64_t c = bkey_cmp(_l->k, _r->k);
 
-	return c ? c > 0 : l.k < r.k;
+	return !(c ? c > 0 : _l->k < _r->k);
 }
 
 static bool __ptr_invalid(struct cache_set *c, const struct bkey *k)
@@ -238,7 +239,7 @@ static bool bch_btree_ptr_insert_fixup(struct btree_keys *bk,
 }
 
 const struct btree_keys_ops bch_btree_keys_ops = {
-	.sort_cmp	= bch_key_sort_cmp,
+	.sort_cmp	= new_bch_key_sort_cmp,
 	.insert_fixup	= bch_btree_ptr_insert_fixup,
 	.key_invalid	= bch_btree_ptr_invalid,
 	.key_bad	= bch_btree_ptr_bad,
@@ -255,22 +256,36 @@ const struct btree_keys_ops bch_btree_keys_ops = {
  * Necessary for btree_sort_fixup() - if there are multiple keys that compare
  * equal in different sets, we have to process them newest to oldest.
  */
-static bool bch_extent_sort_cmp(struct btree_iter_set l,
-				struct btree_iter_set r)
+
+static bool new_bch_extent_sort_cmp(const void *l, const void *r, void __always_unused *args)
+{
+	struct btree_iter_set *_l = (struct btree_iter_set *)l;
+	struct btree_iter_set *_r = (struct btree_iter_set *)r;
+	int64_t c = bkey_cmp(&START_KEY(_l->k), &START_KEY(_r->k));
+
+	return !(c ? c > 0 : _l->k < _r->k);
+}
+
+static inline void new_btree_iter_swap(void *iter1, void *iter2, void __always_unused *args)
 {
-	int64_t c = bkey_cmp(&START_KEY(l.k), &START_KEY(r.k));
+	struct btree_iter_set *_iter1 = iter1;
+	struct btree_iter_set *_iter2 = iter2;
 
-	return c ? c > 0 : l.k < r.k;
+	swap(*_iter1, *_iter2);
 }
 
 static struct bkey *bch_extent_sort_fixup(struct btree_iter *iter,
 					  struct bkey *tmp)
 {
-	while (iter->used > 1) {
-		struct btree_iter_set *top = iter->data, *i = top + 1;
-
-		if (iter->used > 2 &&
-		    bch_extent_sort_cmp(i[0], i[1]))
+	const struct min_heap_callbacks callbacks = {
+		.less = new_bch_extent_sort_cmp,
+		.swp = new_btree_iter_swap,
+	};
+	while (iter->heap.nr > 1) {
+		struct btree_iter_set *top = iter->heap.data, *i = top + 1;
+
+		if (iter->heap.nr > 2 &&
+		    !new_bch_extent_sort_cmp(&i[0], &i[1], NULL))
 			i++;
 
 		if (bkey_cmp(top->k, &START_KEY(i->k)) <= 0)
@@ -278,7 +293,7 @@ static struct bkey *bch_extent_sort_fixup(struct btree_iter *iter,
 
 		if (!KEY_SIZE(i->k)) {
 			sort_key_next(iter, i);
-			heap_sift(iter, i - top, bch_extent_sort_cmp);
+			min_heap_sift_down(&iter->heap, i - top, &callbacks, NULL);
 			continue;
 		}
 
@@ -288,7 +303,7 @@ static struct bkey *bch_extent_sort_fixup(struct btree_iter *iter,
 			else
 				bch_cut_front(top->k, i->k);
 
-			heap_sift(iter, i - top, bch_extent_sort_cmp);
+			min_heap_sift_down(&iter->heap, i - top, &callbacks, NULL);
 		} else {
 			/* can't happen because of comparison func */
 			BUG_ON(!bkey_cmp(&START_KEY(top->k), &START_KEY(i->k)));
@@ -298,7 +313,7 @@ static struct bkey *bch_extent_sort_fixup(struct btree_iter *iter,
 
 				bch_cut_back(&START_KEY(i->k), tmp);
 				bch_cut_front(i->k, top->k);
-				heap_sift(iter, 0, bch_extent_sort_cmp);
+				min_heap_sift_down(&iter->heap, 0, &callbacks, NULL);
 
 				return tmp;
 			} else {
@@ -618,7 +633,7 @@ static bool bch_extent_merge(struct btree_keys *bk,
 }
 
 const struct btree_keys_ops bch_extent_keys_ops = {
-	.sort_cmp	= bch_extent_sort_cmp,
+	.sort_cmp	= new_bch_extent_sort_cmp,
 	.sort_fixup	= bch_extent_sort_fixup,
 	.insert_fixup	= bch_extent_insert_fixup,
 	.key_invalid	= bch_extent_invalid,
diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index ebd500bdf0b2..7f482729c56d 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -182,16 +182,27 @@ err:		if (!IS_ERR_OR_NULL(w->private))
 	closure_sync(&cl);
 }
 
-static bool bucket_cmp(struct bucket *l, struct bucket *r)
+static bool new_bucket_cmp(const void *l, const void *r, void __always_unused *args)
 {
-	return GC_SECTORS_USED(l) < GC_SECTORS_USED(r);
+	struct bucket **_l = (struct bucket **)l;
+	struct bucket **_r = (struct bucket **)r;
+
+	return GC_SECTORS_USED(*_l) >= GC_SECTORS_USED(*_r);
+}
+
+static void new_bucket_swap(void *l, void *r, void __always_unused *args)
+{
+	struct bucket **_l = l;
+	struct bucket **_r = r;
+
+	swap(*_l, *_r);
 }
 
 static unsigned int bucket_heap_top(struct cache *ca)
 {
 	struct bucket *b;
 
-	return (b = heap_peek(&ca->heap)) ? GC_SECTORS_USED(b) : 0;
+	return (b = min_heap_peek(&ca->heap)[0]) ? GC_SECTORS_USED(b) : 0;
 }
 
 void bch_moving_gc(struct cache_set *c)
@@ -199,6 +210,10 @@ void bch_moving_gc(struct cache_set *c)
 	struct cache *ca = c->cache;
 	struct bucket *b;
 	unsigned long sectors_to_move, reserve_sectors;
+	const struct min_heap_callbacks callbacks = {
+		.less = new_bucket_cmp,
+		.swp = new_bucket_swap,
+	};
 
 	if (!c->copy_gc_enabled)
 		return;
@@ -209,7 +224,7 @@ void bch_moving_gc(struct cache_set *c)
 	reserve_sectors = ca->sb.bucket_size *
 			     fifo_used(&ca->free[RESERVE_MOVINGGC]);
 
-	ca->heap.used = 0;
+	ca->heap.nr = 0;
 
 	for_each_bucket(b, ca) {
 		if (GC_MARK(b) == GC_MARK_METADATA ||
@@ -218,25 +233,31 @@ void bch_moving_gc(struct cache_set *c)
 		    atomic_read(&b->pin))
 			continue;
 
-		if (!heap_full(&ca->heap)) {
+		if (!min_heap_full(&ca->heap)) {
 			sectors_to_move += GC_SECTORS_USED(b);
-			heap_add(&ca->heap, b, bucket_cmp);
-		} else if (bucket_cmp(b, heap_peek(&ca->heap))) {
+			min_heap_push(&ca->heap, &b, &callbacks, NULL);
+		} else if (!new_bucket_cmp(&b, min_heap_peek(&ca->heap), ca)) {
 			sectors_to_move -= bucket_heap_top(ca);
 			sectors_to_move += GC_SECTORS_USED(b);
 
 			ca->heap.data[0] = b;
-			heap_sift(&ca->heap, 0, bucket_cmp);
+			min_heap_sift_down(&ca->heap, 0, &callbacks, NULL);
 		}
 	}
 
 	while (sectors_to_move > reserve_sectors) {
-		heap_pop(&ca->heap, b, bucket_cmp);
+		if (ca->heap.nr) {
+			b = min_heap_peek(&ca->heap)[0];
+			min_heap_pop(&ca->heap, &callbacks, NULL);
+		}
 		sectors_to_move -= GC_SECTORS_USED(b);
 	}
 
-	while (heap_pop(&ca->heap, b, bucket_cmp))
+	while (ca->heap.nr) {
+		b = min_heap_peek(&ca->heap)[0];
+		min_heap_pop(&ca->heap, &callbacks, NULL);
 		SET_GC_MOVE(b, 1);
+	}
 
 	mutex_unlock(&c->bucket_lock);
 
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 6956beb55326..e8f696cb58c0 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -662,6 +662,8 @@ static unsigned int bch_root_usage(struct cache_set *c)
 	struct btree *b;
 	struct btree_iter iter;
 
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
+
 	goto lock_root;
 
 	do {
diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index f61ab1bada6c..539454d8e2d0 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -9,6 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/sched/clock.h>
 #include <linux/llist.h>
+#include <linux/min_heap.h>
 #include <linux/ratelimit.h>
 #include <linux/vmalloc.h>
 #include <linux/workqueue.h>
@@ -30,16 +31,10 @@ struct closure;
 
 #endif
 
-#define DECLARE_HEAP(type, name)					\
-	struct {							\
-		size_t size, used;					\
-		type *data;						\
-	} name
-
 #define init_heap(heap, _size, gfp)					\
 ({									\
 	size_t _bytes;							\
-	(heap)->used = 0;						\
+	(heap)->nr = 0;						\
 	(heap)->size = (_size);						\
 	_bytes = (heap)->size * sizeof(*(heap)->data);			\
 	(heap)->data = kvmalloc(_bytes, (gfp) & GFP_KERNEL);		\
@@ -52,64 +47,6 @@ do {									\
 	(heap)->data = NULL;						\
 } while (0)
 
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
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 8827a6f130ad..c1d28e365910 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -915,6 +915,7 @@ static int bch_dirty_init_thread(void *arg)
 	k = p = NULL;
 	prev_idx = 0;
 
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
 	bch_btree_iter_init(&c->root->keys, &iter, NULL);
 	k = bch_btree_iter_next_filter(&iter, &c->root->keys, bch_ptr_bad);
 	BUG_ON(!k);
@@ -984,6 +985,8 @@ void bch_sectors_dirty_init(struct bcache_device *d)
 	struct cache_set *c = d->c;
 	struct bch_dirty_init_state state;
 
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
+
 retry_lock:
 	b = c->root;
 	rw_lock(0, b, b->level);
-- 
2.34.1


