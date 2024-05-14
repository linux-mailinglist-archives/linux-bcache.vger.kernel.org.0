Return-Path: <linux-bcache+bounces-457-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D66E78C4E1C
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 10:52:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 027C11C215AF
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 08:52:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17E1A381BA;
	Tue, 14 May 2024 08:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ED0mPTpf"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E439224CE;
	Tue, 14 May 2024 08:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676531; cv=none; b=mInKCpRQzgPTb2rdUXB80VCEx59gB8PtVmGjnAH3HVlsxNPr+1LBxVm8j4y0sc+2muWw2DhskDQbxy0UyZ6b9wM5zFBh3ac8o4B+dsy06gI26mOVGo6NPisZre4TMwK9yUV3Bvgu4V98FqXxidCsrab+/iWMhOhmEJfQPw83s/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676531; c=relaxed/simple;
	bh=oUBQ93RlORVgLLzujf/bPzqsBV7gnhox2bJaWTkJJcM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UhiVD4OU0jABpXQ+AzJXAYsyH+vgSTbkniskHcc1jig8SwNWgddxoFJYrKdEe2XNB3oiec1cVE7la3KQtK+L/lLUQ40FzR1sWZf8OC7m5dkeZJGJMWDAMhRWcLbnI5ylvIbuajlB+wpfHuPZ6DAQZiUkfPNhhcG+1y6cLusu9m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ED0mPTpf; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2b4b30702a5so1342853a91.1;
        Tue, 14 May 2024 01:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676528; x=1716281328; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kAQqvLmnTydFnAC2eV9eKYPVBSe1+sbe73fPu9TJR3o=;
        b=ED0mPTpfTln+E6MjqP4ZWyaTmTRm1wH3dyfXlb1WdtEQJQwnTvhlRxHBA5OzVXNQVU
         c8Xt97NopQXlCfarFecKLq/h81GP9cKBVe7ImPayQrnPi+0NlatBt/ZDlu6SLBlInxj+
         vnkfrIIXaR9b7ScUh3QJAcsUv+U8a/+ulluP0a3p4gSvCg1VnDHJUpk98XCGlynhtf0g
         JC11fZrUNTNzYyAmAK1uBNe/wXYD7g2e8TKYeihsONuSAY1iXyw02kLPDK2gXn+DtMaD
         NPJ3M/5qGF5wljaaAkT5l27lLJJqVrn0d3qSIYzv9HYekCbQ89rAedtFVEXcSs9lx0+x
         ckxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676528; x=1716281328;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kAQqvLmnTydFnAC2eV9eKYPVBSe1+sbe73fPu9TJR3o=;
        b=TVwidiCOPEhjMYL2T1ij4S5qSIhiTdLFPyCDYC9DoOnlqVMVeOZ4eqq6GJYUuaialh
         WclowOl9yWIwYKzVaIxf0WjMaTdhM/WyOaJHi4arFybZE/I/o4hTvSSXmCfzzqTg9GVr
         Sy60L+YzOjKyDnD3ocJVxT4GdSGuZDgGTfK5IICYGkyE9r3XmuTLYCyk4W+rbYO/Tlcn
         IFkv6JHC7H1B2ztzxoRgAzoZpokJPuaXBN0zGZ3x7bo05QKt8WVPto0mNiyyTaT4FXnT
         LvsgRmt7o9t6mWGuSTSBgXynuo2Acnk+0JEYADzmBDKvmsgUtdLR1jsvrD8a56DE6oXs
         BQug==
X-Forwarded-Encrypted: i=1; AJvYcCU4iNthomZc+QbLFBBCXn4O7V+k5xYSxjm1qs1YjemYYa+pl+Z0ikQntfMXFJzcwU/3D/wUTr97K2Gwr4PJ7MEH4EvxzTdeeklPwfkqwaLDyViMAvrY2HiTcWHTVuFT4T1rFAScU3ABpmmpc0i2X3xz+1uAu3zftxiU+mrjY8QF0CgtpGRiRmM4U9bf2Fghvw0w0Uo/4vwuZSgyRZ11LwTUJpB78z6+DIjSu1k1
X-Gm-Message-State: AOJu0Yypeli+GQ193rXFB/0XaR7wYT5IwGVwBAuU2ROlxgiGpKHdEeLs
	vWIRfNY1AGRzmRtGTVYXa9nDXVeove7TNY1Tp2FFTpQEZB1lxU3nV/G5Ag==
X-Google-Smtp-Source: AGHT+IHWD4pNXGVxuwpDdsvPIK4+Z4KHjKYIxQH6YdLfOcCIhIPdY0VsL47/jkRUxblI2TA+IN4OTA==
X-Received: by 2002:a05:6a21:6da1:b0:1af:cd45:59a9 with SMTP id adf61e73a8af0-1afde0b7213mr14735963637.2.1715676527366;
        Tue, 14 May 2024 01:48:47 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b6711660fdsm9195597a91.16.2024.05.14.01.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:48:46 -0700 (PDT)
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
	bagasdotme@gmail.com,
	jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [RESEND PATCH v5 15/16] bcache: Remove heap-related macros and switch to generic min_heap
Date: Tue, 14 May 2024 16:47:23 +0800
Message-Id: <20240514084724.557100-16-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240514084724.557100-1-visitorckw@gmail.com>
References: <20240514084724.557100-1-visitorckw@gmail.com>
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
Changes in v5:
- Rebase on the block tree to resolve the conflict in bcache.
- Fix missing initialization for heap data pointer in bcache's
  bch_btree_node_read_done().

 drivers/md/bcache/alloc.c     |  64 +++++++++++++-----
 drivers/md/bcache/bcache.h    |   2 +-
 drivers/md/bcache/bset.c      | 124 ++++++++++++++++++++++------------
 drivers/md/bcache/bset.h      |  40 +++++------
 drivers/md/bcache/btree.c     |  69 +++++++++++--------
 drivers/md/bcache/extents.c   |  53 +++++++++------
 drivers/md/bcache/movinggc.c  |  41 ++++++++---
 drivers/md/bcache/super.c     |   3 +-
 drivers/md/bcache/sysfs.c     |   4 +-
 drivers/md/bcache/util.h      |  67 +-----------------
 drivers/md/bcache/writeback.c |  13 ++--
 11 files changed, 263 insertions(+), 217 deletions(-)

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
index 463eb13bd0b2..bd97d8626887 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -54,9 +54,11 @@ void bch_dump_bucket(struct btree_keys *b)
 int __bch_count_data(struct btree_keys *b)
 {
 	unsigned int ret = 0;
-	struct btree_iter_stack iter;
+	struct btree_iter iter;
 	struct bkey *k;
 
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
+
 	if (b->ops->is_extents)
 		for_each_key(b, k, &iter)
 			ret += KEY_SIZE(k);
@@ -67,9 +69,11 @@ void __bch_check_keys(struct btree_keys *b, const char *fmt, ...)
 {
 	va_list args;
 	struct bkey *k, *p = NULL;
-	struct btree_iter_stack iter;
+	struct btree_iter iter;
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
@@ -879,12 +883,14 @@ unsigned int bch_btree_insert_key(struct btree_keys *b, struct bkey *k,
 	unsigned int status = BTREE_INSERT_STATUS_NO_INSERT;
 	struct bset *i = bset_tree_last(b)->data;
 	struct bkey *m, *prev = NULL;
-	struct btree_iter_stack iter;
+	struct btree_iter iter;
 	struct bkey preceding_key_on_stack = ZERO_KEY;
 	struct bkey *preceding_key_p = &preceding_key_on_stack;
 
 	BUG_ON(b->ops->is_extents && !KEY_SIZE(k));
 
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
+
 	/*
 	 * If k has preceding key, preceding_key_p will be set to address
 	 *  of k's preceding key; otherwise preceding_key_p will be set
@@ -895,9 +901,9 @@ unsigned int bch_btree_insert_key(struct btree_keys *b, struct bkey *k,
 	else
 		preceding_key(k, &preceding_key_p);
 
-	m = bch_btree_iter_stack_init(b, &iter, preceding_key_p);
+	m = bch_btree_iter_init(b, &iter, preceding_key_p);
 
-	if (b->ops->insert_fixup(b, k, &iter.iter, replace_key))
+	if (b->ops->insert_fixup(b, k, &iter, replace_key))
 		return status;
 
 	status = BTREE_INSERT_STATUS_INSERT;
@@ -1077,79 +1083,102 @@ struct bkey *__bch_bset_search(struct btree_keys *b, struct bset_tree *t,
 
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
 
-static struct bkey *__bch_btree_iter_stack_init(struct btree_keys *b,
-						struct btree_iter_stack *iter,
-						struct bkey *search,
-						struct bset_tree *start)
+static struct bkey *__bch_btree_iter_init(struct btree_keys *b,
+					  struct btree_iter *iter,
+					  struct bkey *search,
+					  struct bset_tree *start)
 {
 	struct bkey *ret = NULL;
 
-	iter->iter.size = ARRAY_SIZE(iter->stack_data);
-	iter->iter.used = 0;
+	iter->heap.size = ARRAY_SIZE(iter->heap.preallocated);
+	iter->heap.nr = 0;
 
 #ifdef CONFIG_BCACHE_DEBUG
-	iter->iter.b = b;
+	iter->b = b;
 #endif
 
 	for (; start <= bset_tree_last(b); start++) {
 		ret = bch_bset_search(b, start, search);
-		bch_btree_iter_push(&iter->iter, ret, bset_bkey_last(start->data));
+		bch_btree_iter_push(iter, ret, bset_bkey_last(start->data));
 	}
 
 	return ret;
 }
 
-struct bkey *bch_btree_iter_stack_init(struct btree_keys *b,
-				 struct btree_iter_stack *iter,
+struct bkey *bch_btree_iter_init(struct btree_keys *b,
+				 struct btree_iter *iter,
 				 struct bkey *search)
 {
-	return __bch_btree_iter_stack_init(b, iter, search, b->set);
+	return __bch_btree_iter_init(b, iter, search, b->set);
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
@@ -1293,10 +1324,11 @@ void bch_btree_sort_partial(struct btree_keys *b, unsigned int start,
 			    struct bset_sort_state *state)
 {
 	size_t order = b->page_order, keys = 0;
-	struct btree_iter_stack iter;
+	struct btree_iter iter;
 	int oldsize = bch_count_data(b);
 
-	__bch_btree_iter_stack_init(b, &iter, NULL, &b->set[start]);
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
+	__bch_btree_iter_init(b, &iter, NULL, &b->set[start]);
 
 	if (start) {
 		unsigned int i;
@@ -1307,7 +1339,7 @@ void bch_btree_sort_partial(struct btree_keys *b, unsigned int start,
 		order = get_order(__set_bytes(b->set->data, keys));
 	}
 
-	__btree_sort(b, &iter.iter, start, order, false, state);
+	__btree_sort(b, &iter, start, order, false, state);
 
 	EBUG_ON(oldsize >= 0 && bch_count_data(b) != oldsize);
 }
@@ -1323,11 +1355,13 @@ void bch_btree_sort_into(struct btree_keys *b, struct btree_keys *new,
 			 struct bset_sort_state *state)
 {
 	uint64_t start_time = local_clock();
-	struct btree_iter_stack iter;
+	struct btree_iter iter;
+
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
 
-	bch_btree_iter_stack_init(b, &iter, NULL);
+	bch_btree_iter_init(b, &iter, NULL);
 
-	btree_mergesort(b, new->set->data, &iter.iter, false, true);
+	btree_mergesort(b, new->set->data, &iter, false, true);
 
 	bch_time_stats_update(&state->time, start_time);
 
diff --git a/drivers/md/bcache/bset.h b/drivers/md/bcache/bset.h
index 011f6062c4c0..f79441acd4c1 100644
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
@@ -312,23 +313,17 @@ enum {
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
-	} data[];
-};
-
-/* Fixed-size btree_iter that can be allocated on the stack */
-
-struct btree_iter_stack {
-	struct btree_iter iter;
-	struct btree_iter_set stack_data[MAX_BSETS];
+	MIN_HEAP_PREALLOCATED(struct btree_iter_set, btree_iter_heap, MAX_BSETS) heap;
 };
 
 typedef bool (*ptr_filter_fn)(struct btree_keys *b, const struct bkey *k);
@@ -340,9 +335,9 @@ struct bkey *bch_btree_iter_next_filter(struct btree_iter *iter,
 
 void bch_btree_iter_push(struct btree_iter *iter, struct bkey *k,
 			 struct bkey *end);
-struct bkey *bch_btree_iter_stack_init(struct btree_keys *b,
-				       struct btree_iter_stack *iter,
-				       struct bkey *search);
+struct bkey *bch_btree_iter_init(struct btree_keys *b,
+				 struct btree_iter *iter,
+				 struct bkey *search);
 
 struct bkey *__bch_bset_search(struct btree_keys *b, struct bset_tree *t,
 			       const struct bkey *search);
@@ -357,14 +352,13 @@ static inline struct bkey *bch_bset_search(struct btree_keys *b,
 	return search ? __bch_bset_search(b, t, search) : t->data->start;
 }
 
-#define for_each_key_filter(b, k, stack_iter, filter)                      \
-	for (bch_btree_iter_stack_init((b), (stack_iter), NULL);           \
-	     ((k) = bch_btree_iter_next_filter(&((stack_iter)->iter), (b), \
-					       filter));)
+#define for_each_key_filter(b, k, iter, filter)				\
+	for (bch_btree_iter_init((b), (iter), NULL);			\
+	     ((k) = bch_btree_iter_next_filter((iter), (b), filter));)
 
-#define for_each_key(b, k, stack_iter)                           \
-	for (bch_btree_iter_stack_init((b), (stack_iter), NULL); \
-	     ((k) = bch_btree_iter_next(&((stack_iter)->iter)));)
+#define for_each_key(b, k, iter)					\
+	for (bch_btree_iter_init((b), (iter), NULL);			\
+	     ((k) = bch_btree_iter_next(iter));)
 
 /* Sorting */
 
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index d011a7154d33..ce9d729bc8ff 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -149,19 +149,19 @@ void bch_btree_node_read_done(struct btree *b)
 {
 	const char *err = "bad btree header";
 	struct bset *i = btree_bset_first(b);
-	struct btree_iter *iter;
+	struct btree_iter iter;
 
 	/*
 	 * c->fill_iter can allocate an iterator with more memory space
 	 * than static MAX_BSETS.
 	 * See the comment arount cache_set->fill_iter.
 	 */
-	iter = mempool_alloc(&b->c->fill_iter, GFP_NOIO);
-	iter->size = b->c->cache->sb.bucket_size / b->c->cache->sb.block_size;
-	iter->used = 0;
+	iter.heap.data = mempool_alloc(&b->c->fill_iter, GFP_NOIO);
+	iter.heap.size = b->c->cache->sb.bucket_size / b->c->cache->sb.block_size;
+	iter.heap.nr = 0;
 
 #ifdef CONFIG_BCACHE_DEBUG
-	iter->b = &b->keys;
+	iter.b = &b->keys;
 #endif
 
 	if (!i->seq)
@@ -199,7 +199,7 @@ void bch_btree_node_read_done(struct btree *b)
 		if (i != b->keys.set[0].data && !i->keys)
 			goto err;
 
-		bch_btree_iter_push(iter, i->start, bset_bkey_last(i));
+		bch_btree_iter_push(&iter, i->start, bset_bkey_last(i));
 
 		b->written += set_blocks(i, block_bytes(b->c->cache));
 	}
@@ -211,7 +211,7 @@ void bch_btree_node_read_done(struct btree *b)
 		if (i->seq == b->keys.set[0].data->seq)
 			goto err;
 
-	bch_btree_sort_and_fix_extents(&b->keys, iter, &b->c->sort);
+	bch_btree_sort_and_fix_extents(&b->keys, &iter, &b->c->sort);
 
 	i = b->keys.set[0].data;
 	err = "short btree key";
@@ -223,7 +223,7 @@ void bch_btree_node_read_done(struct btree *b)
 		bch_bset_init_next(&b->keys, write_block(b),
 				   bset_magic(&b->c->cache->sb));
 out:
-	mempool_free(iter, &b->c->fill_iter);
+	mempool_free(iter.heap.data, &b->c->fill_iter);
 	return;
 err:
 	set_btree_node_io_error(b);
@@ -1309,9 +1309,11 @@ static bool btree_gc_mark_node(struct btree *b, struct gc_stat *gc)
 	uint8_t stale = 0;
 	unsigned int keys = 0, good_keys = 0;
 	struct bkey *k;
-	struct btree_iter_stack iter;
+	struct btree_iter iter;
 	struct bset_tree *t;
 
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
+
 	gc->nodes++;
 
 	for_each_key_filter(&b->keys, k, &iter, bch_ptr_invalid) {
@@ -1570,9 +1572,11 @@ static int btree_gc_rewrite_node(struct btree *b, struct btree_op *op,
 static unsigned int btree_gc_count_keys(struct btree *b)
 {
 	struct bkey *k;
-	struct btree_iter_stack iter;
+	struct btree_iter iter;
 	unsigned int ret = 0;
 
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
+
 	for_each_key_filter(&b->keys, k, &iter, bch_ptr_bad)
 		ret += bkey_u64s(k);
 
@@ -1611,18 +1615,18 @@ static int btree_gc_recurse(struct btree *b, struct btree_op *op,
 	int ret = 0;
 	bool should_rewrite;
 	struct bkey *k;
-	struct btree_iter_stack iter;
+	struct btree_iter iter;
 	struct gc_merge_info r[GC_MERGE_NODES];
 	struct gc_merge_info *i, *last = r + ARRAY_SIZE(r) - 1;
 
-	bch_btree_iter_stack_init(&b->keys, &iter, &b->c->gc_done);
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
+	bch_btree_iter_init(&b->keys, &iter, &b->c->gc_done);
 
 	for (i = r; i < r + ARRAY_SIZE(r); i++)
 		i->b = ERR_PTR(-EINTR);
 
 	while (1) {
-		k = bch_btree_iter_next_filter(&iter.iter, &b->keys,
-					       bch_ptr_bad);
+		k = bch_btree_iter_next_filter(&iter, &b->keys, bch_ptr_bad);
 		if (k) {
 			r->b = bch_btree_node_get(b->c, op, k, b->level - 1,
 						  true, b);
@@ -1912,7 +1916,9 @@ static int bch_btree_check_recurse(struct btree *b, struct btree_op *op)
 {
 	int ret = 0;
 	struct bkey *k, *p = NULL;
-	struct btree_iter_stack iter;
+	struct btree_iter iter;
+
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
 
 	for_each_key_filter(&b->keys, k, &iter, bch_ptr_invalid)
 		bch_initial_mark_key(b->c, b->level, k);
@@ -1920,10 +1926,10 @@ static int bch_btree_check_recurse(struct btree *b, struct btree_op *op)
 	bch_initial_mark_key(b->c, b->level + 1, &b->key);
 
 	if (b->level) {
-		bch_btree_iter_stack_init(&b->keys, &iter, NULL);
+		bch_btree_iter_init(&b->keys, &iter, NULL);
 
 		do {
-			k = bch_btree_iter_next_filter(&iter.iter, &b->keys,
+			k = bch_btree_iter_next_filter(&iter, &b->keys,
 						       bch_ptr_bad);
 			if (k) {
 				btree_node_prefetch(b, k);
@@ -1951,7 +1957,7 @@ static int bch_btree_check_thread(void *arg)
 	struct btree_check_info *info = arg;
 	struct btree_check_state *check_state = info->state;
 	struct cache_set *c = check_state->c;
-	struct btree_iter_stack iter;
+	struct btree_iter iter;
 	struct bkey *k, *p;
 	int cur_idx, prev_idx, skip_nr;
 
@@ -1959,9 +1965,11 @@ static int bch_btree_check_thread(void *arg)
 	cur_idx = prev_idx = 0;
 	ret = 0;
 
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
+
 	/* root node keys are checked before thread created */
-	bch_btree_iter_stack_init(&c->root->keys, &iter, NULL);
-	k = bch_btree_iter_next_filter(&iter.iter, &c->root->keys, bch_ptr_bad);
+	bch_btree_iter_init(&c->root->keys, &iter, NULL);
+	k = bch_btree_iter_next_filter(&iter, &c->root->keys, bch_ptr_bad);
 	BUG_ON(!k);
 
 	p = k;
@@ -1979,7 +1987,7 @@ static int bch_btree_check_thread(void *arg)
 		skip_nr = cur_idx - prev_idx;
 
 		while (skip_nr) {
-			k = bch_btree_iter_next_filter(&iter.iter,
+			k = bch_btree_iter_next_filter(&iter,
 						       &c->root->keys,
 						       bch_ptr_bad);
 			if (k)
@@ -2052,9 +2060,11 @@ int bch_btree_check(struct cache_set *c)
 	int ret = 0;
 	int i;
 	struct bkey *k = NULL;
-	struct btree_iter_stack iter;
+	struct btree_iter iter;
 	struct btree_check_state check_state;
 
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
+
 	/* check and mark root node keys */
 	for_each_key_filter(&c->root->keys, k, &iter, bch_ptr_invalid)
 		bch_initial_mark_key(c, c->root->level, k);
@@ -2548,11 +2558,12 @@ static int bch_btree_map_nodes_recurse(struct btree *b, struct btree_op *op,
 
 	if (b->level) {
 		struct bkey *k;
-		struct btree_iter_stack iter;
+		struct btree_iter iter;
 
-		bch_btree_iter_stack_init(&b->keys, &iter, from);
+		min_heap_init(&iter.heap, NULL, MAX_BSETS);
+		bch_btree_iter_init(&b->keys, &iter, from);
 
-		while ((k = bch_btree_iter_next_filter(&iter.iter, &b->keys,
+		while ((k = bch_btree_iter_next_filter(&iter, &b->keys,
 						       bch_ptr_bad))) {
 			ret = bcache_btree(map_nodes_recurse, k, b,
 				    op, from, fn, flags);
@@ -2581,12 +2592,12 @@ int bch_btree_map_keys_recurse(struct btree *b, struct btree_op *op,
 {
 	int ret = MAP_CONTINUE;
 	struct bkey *k;
-	struct btree_iter_stack iter;
+	struct btree_iter iter;
 
-	bch_btree_iter_stack_init(&b->keys, &iter, from);
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
+	bch_btree_iter_init(&b->keys, &iter, from);
 
-	while ((k = bch_btree_iter_next_filter(&iter.iter, &b->keys,
-					       bch_ptr_bad))) {
+	while ((k = bch_btree_iter_next_filter(&iter, &b->keys, bch_ptr_bad))) {
 		ret = !b->level
 			? fn(op, b, k)
 			: bcache_btree(map_keys_recurse, k,
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
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index cba09660148a..c6f5592996a8 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1914,8 +1914,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 	INIT_LIST_HEAD(&c->btree_cache_freed);
 	INIT_LIST_HEAD(&c->data_buckets);
 
-	iter_size = sizeof(struct btree_iter) +
-		    ((meta_bucket_pages(sb) * PAGE_SECTORS) / sb->block_size) *
+	iter_size = ((meta_bucket_pages(sb) * PAGE_SECTORS) / sb->block_size) *
 			    sizeof(struct btree_iter_set);
 
 	c->devices = kcalloc(c->nr_uuids, sizeof(void *), GFP_KERNEL);
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 826b14cae4e5..e8f696cb58c0 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -660,7 +660,9 @@ static unsigned int bch_root_usage(struct cache_set *c)
 	unsigned int bytes = 0;
 	struct bkey *k;
 	struct btree *b;
-	struct btree_iter_stack iter;
+	struct btree_iter iter;
+
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
 
 	goto lock_root;
 
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
index 792e070ccf38..c1d28e365910 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -908,15 +908,16 @@ static int bch_dirty_init_thread(void *arg)
 	struct dirty_init_thrd_info *info = arg;
 	struct bch_dirty_init_state *state = info->state;
 	struct cache_set *c = state->c;
-	struct btree_iter_stack iter;
+	struct btree_iter iter;
 	struct bkey *k, *p;
 	int cur_idx, prev_idx, skip_nr;
 
 	k = p = NULL;
 	prev_idx = 0;
 
-	bch_btree_iter_stack_init(&c->root->keys, &iter, NULL);
-	k = bch_btree_iter_next_filter(&iter.iter, &c->root->keys, bch_ptr_bad);
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
+	bch_btree_iter_init(&c->root->keys, &iter, NULL);
+	k = bch_btree_iter_next_filter(&iter, &c->root->keys, bch_ptr_bad);
 	BUG_ON(!k);
 
 	p = k;
@@ -930,7 +931,7 @@ static int bch_dirty_init_thread(void *arg)
 		skip_nr = cur_idx - prev_idx;
 
 		while (skip_nr) {
-			k = bch_btree_iter_next_filter(&iter.iter,
+			k = bch_btree_iter_next_filter(&iter,
 						       &c->root->keys,
 						       bch_ptr_bad);
 			if (k)
@@ -979,11 +980,13 @@ void bch_sectors_dirty_init(struct bcache_device *d)
 	int i;
 	struct btree *b = NULL;
 	struct bkey *k = NULL;
-	struct btree_iter_stack iter;
+	struct btree_iter iter;
 	struct sectors_dirty_init op;
 	struct cache_set *c = d->c;
 	struct bch_dirty_init_state state;
 
+	min_heap_init(&iter.heap, NULL, MAX_BSETS);
+
 retry_lock:
 	b = c->root;
 	rw_lock(0, b, b->level);
-- 
2.34.1


