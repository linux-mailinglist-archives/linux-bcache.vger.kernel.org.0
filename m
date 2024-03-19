Return-Path: <linux-bcache+bounces-307-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75A5F88044C
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 19:04:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99CA71C22E0E
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 18:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06CDB37708;
	Tue, 19 Mar 2024 18:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i30JLY0f"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A62604C6;
	Tue, 19 Mar 2024 18:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710871278; cv=none; b=jMaM/sy/hRgBwnaFtgMcs2psjoJx5w5o5PvMWVmVA68iYqBDKO6sTKB2N923SChs4Q2JjAuQTZBrXes0iYkxg41JLc3TKtOefdpIOzev5Bzz906BP8DwnbQIrYQ4Qyb2CGn2/wHq3QEcTX43dOHEXCWMjb/RWUle4JDk4ztyShE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710871278; c=relaxed/simple;
	bh=+yEiZ43RB1kHULxTTuB/64NK5y0o51aXqEIqAtlaiH4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uSXUJkM/WL6eIWBYCgaF7Qv5Xpb9xKBTUP81BfpZOISrMxLiV5Hf/mFRXGP7TTYSYopZpi6+4CkF1WBdgVu1s/b4g4sdJAfBFABv5FDfTcm+tasi67vu3HxIa7/4bBgX4kTKQwZDrjA4SK3rWjxiVE6vwa3VUnUCX2J9Xc8BIIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i30JLY0f; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-5cfcf509fbdso831062a12.1;
        Tue, 19 Mar 2024 11:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710871276; x=1711476076; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hU4FK6Bj2mTXqR3yAD+6lLX+CSXCbIHfMQPQKJ2HSxw=;
        b=i30JLY0fMi+tIwqkxU6vnPXrDEkaGgn9cbEHx3HufEcHoxzpdVIvRWH6VJJSIou1aT
         li9eVxDTTZjrK5TgYHUxgCaEa92m5a1W9eFRHjP12VEml7cBhOqRl7/S523DsZiDYcoM
         BqMqWkJnn7T0O2f1Ox7FzFIZ/WF1LZ96VIRlRtxl9xwhCuh0bg0zqFhsJ0IFBgkH4Qss
         NhaK5M7vyWbTkVYgYr3sP5SN8Z0ymu8qUcCi9Xvu0Lz0f+ecUm4RwfzmgcxVAb/n+5iy
         JvM5lqo8RirRJZkX3ItZRsN7Rn0wbo+H4uFVTCvvZgB4CKEpb12OYqL9Yu4msYHv5POG
         +ekw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710871276; x=1711476076;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hU4FK6Bj2mTXqR3yAD+6lLX+CSXCbIHfMQPQKJ2HSxw=;
        b=ZIaiAEE61Z4RlwZVJou62yt4zjdh4wJA58BDspfDQuJUpQgJVY2mmkkzUZ9FKONbt7
         t+0NJ6T3EKmuseXwkQn8n8uq0kfm+l7oxUNGabjAc/9c4ISVsT4opQY4GVQCXODJGJRB
         8ptoJU0s010ignlX2DHerSRXLohE8hkzRBHlexzy8+ep+Q3OYVS+k3cTl1RFs2aJs57/
         dTrpwj1N3luUHOPLJf7qimN2AGpYoe8a+g3wcKHvOHAFUIAG+cRVDoYi9YxAvgw0zTxx
         laNRQ2AnhXbGUZ+2TBvuWdIddwxPrA7QDnu4f3s6X2oezF2hMBC/jOENkG+BgYH4rp3z
         F1lg==
X-Forwarded-Encrypted: i=1; AJvYcCUrgVNhiV2Drqn/6BtS1jEMCRYLdy6Bmx1EaUFUdHGRXJOZiDj7nwK5GPv1cKCp5DDGIWe1c/Bu410TIvsHAKQZ4X+oxDG7Au5ojJR2g+INKxD7uVRy3bHiikS6EXphG/aaXRFVMoOAmg3HDGpxQLmExu+Wca1KUTTnY20EVGjhLA6Pw2Zzlt3V4gwy9mM6k7qAYCD7EkNgTZBok0l7QUnJ9ql20N4ZAc0W7ENf
X-Gm-Message-State: AOJu0Yzh/l5cfT9ipdgJuifb2pt27PgTZ95MyiHJrcrhQYjZhpt9jVTe
	0who3fmbwzT9G0h0mbm3CvZ1iPxkH6bm/J/d2uptPrkNf0tl4uEB
X-Google-Smtp-Source: AGHT+IF5MYW1/my3A16x1xiJ2X9onBhMDXT1Q1JNKBukA3ROQE+f0XhQUeEXgXWNWSqq/75VhaWycw==
X-Received: by 2002:a17:903:244e:b0:1dd:7350:29f6 with SMTP id l14-20020a170903244e00b001dd735029f6mr3131478pls.3.1710871275782;
        Tue, 19 Mar 2024 11:01:15 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id u16-20020a17090341d000b001dd3bee3cd6sm5531359ple.219.2024.03.19.11.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 11:01:15 -0700 (PDT)
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
Subject: [PATCH 13/13] bcachefs: Remove heap-related macros and switch to generic min_heap
Date: Wed, 20 Mar 2024 02:00:05 +0800
Message-Id: <20240319180005.246930-14-visitorckw@gmail.com>
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

Drop the heap-related macros from bcachefs and replaces them with the
generic min_heap implementation from include/linux. This change
improves code readability by using functions instead of macros.

Link: https://lkml.kernel.org/ioyfizrzq7w7mjrqcadtzsfgpuntowtjdw5pgn4qhvsdp4mqqg@nrlek5vmisbu
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 fs/bcachefs/clock.c       |  53 +++++++++++-----
 fs/bcachefs/clock_types.h |   2 +-
 fs/bcachefs/ec.c          |  99 ++++++++++++++++++-----------
 fs/bcachefs/ec_types.h    |   2 +-
 fs/bcachefs/util.h        | 127 +++-----------------------------------
 5 files changed, 109 insertions(+), 174 deletions(-)

diff --git a/fs/bcachefs/clock.c b/fs/bcachefs/clock.c
index 363644451106..7a7d13f7a629 100644
--- a/fs/bcachefs/clock.c
+++ b/fs/bcachefs/clock.c
@@ -6,16 +6,29 @@
 #include <linux/kthread.h>
 #include <linux/preempt.h>
 
-static inline long io_timer_cmp(io_timer_heap *h,
-				struct io_timer *l,
-				struct io_timer *r)
+static inline bool io_timer_cmp(const void *l, const void *r, void *args)
 {
-	return l->expire - r->expire;
+	struct io_timer *_l = (struct io_timer *)l;
+	struct io_timer *_r = (struct io_timer *)r;
+
+	return _l->expire >= _r->expire;
+}
+
+static inline void io_timer_swp(void *l, void *r, void *args)
+{
+	struct io_timer *_l = (struct io_timer *)l;
+	struct io_timer *_r = (struct io_timer *)r;
+
+	swap(*_l, *_r);
 }
 
 void bch2_io_timer_add(struct io_clock *clock, struct io_timer *timer)
 {
 	size_t i;
+	const struct min_heap_callbacks callbacks = {
+		.less = io_timer_cmp,
+		.swp = io_timer_swp,
+	};
 
 	spin_lock(&clock->timer_lock);
 
@@ -26,11 +39,11 @@ void bch2_io_timer_add(struct io_clock *clock, struct io_timer *timer)
 		return;
 	}
 
-	for (i = 0; i < clock->timers.used; i++)
-		if (clock->timers.data[i] == timer)
+	for (i = 0; i < clock->timers.heap.nr; i++)
+		if (min_heap_peek(&clock->timers)[i] == timer)
 			goto out;
 
-	BUG_ON(!heap_add(&clock->timers, timer, io_timer_cmp, NULL));
+	BUG_ON(!min_heap_push(&clock->timers, &timer, &callbacks, NULL));
 out:
 	spin_unlock(&clock->timer_lock);
 }
@@ -38,12 +51,16 @@ void bch2_io_timer_add(struct io_clock *clock, struct io_timer *timer)
 void bch2_io_timer_del(struct io_clock *clock, struct io_timer *timer)
 {
 	size_t i;
+	const struct min_heap_callbacks callbacks = {
+		.less = io_timer_cmp,
+		.swp = io_timer_swp,
+	};
 
 	spin_lock(&clock->timer_lock);
 
-	for (i = 0; i < clock->timers.used; i++)
-		if (clock->timers.data[i] == timer) {
-			heap_del(&clock->timers, i, io_timer_cmp, NULL);
+	for (i = 0; i < clock->timers.heap.nr; i++)
+		if (min_heap_peek(&clock->timers)[i] == timer) {
+			min_heap_pop(&clock->timers, &callbacks, NULL);
 			break;
 		}
 
@@ -131,12 +148,16 @@ static struct io_timer *get_expired_timer(struct io_clock *clock,
 					  unsigned long now)
 {
 	struct io_timer *ret = NULL;
+	const struct min_heap_callbacks callbacks = {
+		.less = io_timer_cmp,
+		.swp = io_timer_swp,
+	};
 
 	spin_lock(&clock->timer_lock);
 
-	if (clock->timers.used &&
-	    time_after_eq(now, clock->timers.data[0]->expire))
-		heap_pop(&clock->timers, ret, io_timer_cmp, NULL);
+	if (clock->timers.heap.nr &&
+	    time_after_eq(now, min_heap_peek(&clock->timers)[0]->expire))
+		min_heap_pop(&clock->timers, &callbacks, NULL);
 
 	spin_unlock(&clock->timer_lock);
 
@@ -161,10 +182,10 @@ void bch2_io_timers_to_text(struct printbuf *out, struct io_clock *clock)
 	spin_lock(&clock->timer_lock);
 	now = atomic64_read(&clock->now);
 
-	for (i = 0; i < clock->timers.used; i++)
+	for (i = 0; i < clock->timers.heap.nr; i++)
 		prt_printf(out, "%ps:\t%li\n",
-		       clock->timers.data[i]->fn,
-		       clock->timers.data[i]->expire - now);
+		       min_heap_peek(&clock->timers)[i]->fn,
+		       min_heap_peek(&clock->timers)[i]->expire - now);
 	spin_unlock(&clock->timer_lock);
 	--out->atomic;
 }
diff --git a/fs/bcachefs/clock_types.h b/fs/bcachefs/clock_types.h
index 5fae0012d808..b02b24b9d74f 100644
--- a/fs/bcachefs/clock_types.h
+++ b/fs/bcachefs/clock_types.h
@@ -23,7 +23,7 @@ struct io_timer {
 /* Amount to buffer up on a percpu counter */
 #define IO_CLOCK_PCPU_SECTORS	128
 
-typedef HEAP(struct io_timer *)	io_timer_heap;
+typedef MIN_HEAP(struct io_timer *, io_timer_heap) io_timer_heap;
 
 struct io_clock {
 	atomic64_t		now;
diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index b98e2c2b8bf0..7b6a31237503 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -860,14 +860,14 @@ static int __ec_stripe_mem_alloc(struct bch_fs *c, size_t idx, gfp_t gfp)
 {
 	ec_stripes_heap n, *h = &c->ec_stripes_heap;
 
-	if (idx >= h->size) {
+	if (idx >= h->heap.size) {
 		if (!init_heap(&n, max(1024UL, roundup_pow_of_two(idx + 1)), gfp))
 			return -BCH_ERR_ENOMEM_ec_stripe_mem_alloc;
 
 		mutex_lock(&c->ec_stripes_heap_lock);
-		if (n.size > h->size) {
-			memcpy(n.data, h->data, h->used * sizeof(h->data[0]));
-			n.used = h->used;
+		if (n.heap.size > h->heap.size) {
+			memcpy(min_heap_peek(&n), min_heap_peek(h), h->heap.nr * sizeof(*min_heap_peek(h)));
+			n.heap.nr = h->heap.nr;
 			swap(*h, n);
 		}
 		mutex_unlock(&c->ec_stripes_heap_lock);
@@ -958,20 +958,21 @@ static u64 stripe_idx_to_delete(struct bch_fs *c)
 
 	lockdep_assert_held(&c->ec_stripes_heap_lock);
 
-	if (h->used &&
-	    h->data[0].blocks_nonempty == 0 &&
-	    !bch2_stripe_is_open(c, h->data[0].idx))
-		return h->data[0].idx;
+	if (h->heap.nr &&
+	    min_heap_peek(h)->blocks_nonempty == 0 &&
+	    !bch2_stripe_is_open(c, min_heap_peek(h)->idx))
+		return min_heap_peek(h)->idx;
 
 	return 0;
 }
 
-static inline int ec_stripes_heap_cmp(ec_stripes_heap *h,
-				      struct ec_stripe_heap_entry l,
-				      struct ec_stripe_heap_entry r)
+static inline bool ec_stripes_heap_cmp(const void *l, const void *r, void *args)
 {
-	return ((l.blocks_nonempty > r.blocks_nonempty) -
-		(l.blocks_nonempty < r.blocks_nonempty));
+	struct ec_stripe_heap_entry *_l = (struct ec_stripe_heap_entry *)l;
+	struct ec_stripe_heap_entry *_r = (struct ec_stripe_heap_entry *)r;
+
+	return ((_l->blocks_nonempty > _r->blocks_nonempty) >=
+		(_l->blocks_nonempty < _r->blocks_nonempty));
 }
 
 static inline void ec_stripes_heap_set_backpointer(ec_stripes_heap *h,
@@ -979,7 +980,21 @@ static inline void ec_stripes_heap_set_backpointer(ec_stripes_heap *h,
 {
 	struct bch_fs *c = container_of(h, struct bch_fs, ec_stripes_heap);
 
-	genradix_ptr(&c->stripes, h->data[i].idx)->heap_idx = i;
+	genradix_ptr(&c->stripes, min_heap_peek(h)[i].idx)->heap_idx = i;
+}
+
+static inline void ec_stripes_heap_swap(void *l, void *r, void *h)
+{
+	struct ec_stripe_heap_entry *_l = (struct ec_stripe_heap_entry *)l;
+	struct ec_stripe_heap_entry *_r = (struct ec_stripe_heap_entry *)r;
+	ec_stripes_heap *_h = (ec_stripes_heap *)h;
+	size_t i = _l - min_heap_peek(_h);
+	size_t j = _r - min_heap_peek(_h);
+
+	ec_stripes_heap_set_backpointer(_h, i);
+	ec_stripes_heap_set_backpointer(_h, j);
+
+	swap(*_l, *_r);
 }
 
 static void heap_verify_backpointer(struct bch_fs *c, size_t idx)
@@ -987,34 +1002,43 @@ static void heap_verify_backpointer(struct bch_fs *c, size_t idx)
 	ec_stripes_heap *h = &c->ec_stripes_heap;
 	struct stripe *m = genradix_ptr(&c->stripes, idx);
 
-	BUG_ON(m->heap_idx >= h->used);
-	BUG_ON(h->data[m->heap_idx].idx != idx);
+	BUG_ON(m->heap_idx >= h->heap.nr);
+	BUG_ON(min_heap_peek(h)[m->heap_idx].idx != idx);
 }
 
 void bch2_stripes_heap_del(struct bch_fs *c,
 			   struct stripe *m, size_t idx)
 {
+	const struct min_heap_callbacks callbacks = {
+		.less = ec_stripes_heap_cmp,
+		.swp = ec_stripes_heap_swap,
+	};
+
 	mutex_lock(&c->ec_stripes_heap_lock);
 	heap_verify_backpointer(c, idx);
 
-	heap_del(&c->ec_stripes_heap, m->heap_idx,
-		 ec_stripes_heap_cmp,
-		 ec_stripes_heap_set_backpointer);
+	min_heap_del(&c->ec_stripes_heap, m->heap_idx, &callbacks, &c->ec_stripes_heap);
 	mutex_unlock(&c->ec_stripes_heap_lock);
 }
 
 void bch2_stripes_heap_insert(struct bch_fs *c,
 			      struct stripe *m, size_t idx)
 {
+	const struct min_heap_callbacks callbacks = {
+		.less = ec_stripes_heap_cmp,
+		.swp = ec_stripes_heap_swap,
+	};
+
 	mutex_lock(&c->ec_stripes_heap_lock);
-	BUG_ON(heap_full(&c->ec_stripes_heap));
+	BUG_ON(min_heap_full(&c->ec_stripes_heap));
 
-	heap_add(&c->ec_stripes_heap, ((struct ec_stripe_heap_entry) {
+	genradix_ptr(&c->stripes, idx)->heap_idx = c->ec_stripes_heap.heap.nr;
+	min_heap_push(&c->ec_stripes_heap, &((struct ec_stripe_heap_entry) {
 			.idx = idx,
 			.blocks_nonempty = m->blocks_nonempty,
 		}),
-		 ec_stripes_heap_cmp,
-		 ec_stripes_heap_set_backpointer);
+		 &callbacks,
+		 &c->ec_stripes_heap);
 
 	heap_verify_backpointer(c, idx);
 	mutex_unlock(&c->ec_stripes_heap_lock);
@@ -1026,17 +1050,20 @@ void bch2_stripes_heap_update(struct bch_fs *c,
 	ec_stripes_heap *h = &c->ec_stripes_heap;
 	bool do_deletes;
 	size_t i;
+	const struct min_heap_callbacks callbacks = {
+		.less = ec_stripes_heap_cmp,
+		.swp = ec_stripes_heap_swap,
+	};
 
 	mutex_lock(&c->ec_stripes_heap_lock);
 	heap_verify_backpointer(c, idx);
 
-	h->data[m->heap_idx].blocks_nonempty = m->blocks_nonempty;
+	min_heap_peek(h)[m->heap_idx].blocks_nonempty = m->blocks_nonempty;
 
 	i = m->heap_idx;
-	heap_sift_up(h,	  i, ec_stripes_heap_cmp,
-		     ec_stripes_heap_set_backpointer);
-	heap_sift_down(h, i, ec_stripes_heap_cmp,
-		       ec_stripes_heap_set_backpointer);
+
+	min_heap_sift_up(h,	i, &callbacks, &c->ec_stripes_heap);
+	min_heapify(h, i, &callbacks, &c->ec_stripes_heap);
 
 	heap_verify_backpointer(c, idx);
 
@@ -1828,12 +1855,12 @@ static s64 get_existing_stripe(struct bch_fs *c,
 		return -1;
 
 	mutex_lock(&c->ec_stripes_heap_lock);
-	for (heap_idx = 0; heap_idx < h->used; heap_idx++) {
+	for (heap_idx = 0; heap_idx < h->heap.nr; heap_idx++) {
 		/* No blocks worth reusing, stripe will just be deleted: */
-		if (!h->data[heap_idx].blocks_nonempty)
+		if (!min_heap_peek(h)[heap_idx].blocks_nonempty)
 			continue;
 
-		stripe_idx = h->data[heap_idx].idx;
+		stripe_idx = min_heap_peek(h)[heap_idx].idx;
 
 		m = genradix_ptr(&c->stripes, stripe_idx);
 
@@ -2159,14 +2186,14 @@ void bch2_stripes_heap_to_text(struct printbuf *out, struct bch_fs *c)
 	size_t i;
 
 	mutex_lock(&c->ec_stripes_heap_lock);
-	for (i = 0; i < min_t(size_t, h->used, 50); i++) {
-		m = genradix_ptr(&c->stripes, h->data[i].idx);
+	for (i = 0; i < min_t(size_t, h->heap.nr, 50); i++) {
+		m = genradix_ptr(&c->stripes, min_heap_peek(h)[i].idx);
 
-		prt_printf(out, "%zu %u/%u+%u", h->data[i].idx,
-		       h->data[i].blocks_nonempty,
+		prt_printf(out, "%zu %u/%u+%u", min_heap_peek(h)[i].idx,
+		       min_heap_peek(h)[i].blocks_nonempty,
 		       m->nr_blocks - m->nr_redundant,
 		       m->nr_redundant);
-		if (bch2_stripe_is_open(c, h->data[i].idx))
+		if (bch2_stripe_is_open(c, min_heap_peek(h)[i].idx))
 			prt_str(out, " open");
 		prt_newline(out);
 	}
diff --git a/fs/bcachefs/ec_types.h b/fs/bcachefs/ec_types.h
index 976426da3a12..2ed67431a81c 100644
--- a/fs/bcachefs/ec_types.h
+++ b/fs/bcachefs/ec_types.h
@@ -36,6 +36,6 @@ struct ec_stripe_heap_entry {
 	unsigned		blocks_nonempty;
 };
 
-typedef HEAP(struct ec_stripe_heap_entry) ec_stripes_heap;
+typedef MIN_HEAP(struct ec_stripe_heap_entry, ec_stripes_heap) ec_stripes_heap;
 
 #endif /* _BCACHEFS_EC_TYPES_H */
diff --git a/fs/bcachefs/util.h b/fs/bcachefs/util.h
index 7ffbddb80400..c599dc5276ac 100644
--- a/fs/bcachefs/util.h
+++ b/fs/bcachefs/util.h
@@ -8,6 +8,7 @@
 #include <linux/errno.h>
 #include <linux/freezer.h>
 #include <linux/kernel.h>
+#include <linux/min_heap.h>
 #include <linux/sched/clock.h>
 #include <linux/llist.h>
 #include <linux/log2.h>
@@ -54,134 +55,20 @@ static inline size_t buf_pages(void *p, size_t len)
 			    PAGE_SIZE);
 }
 
-#define HEAP(type)							\
-struct {								\
-	size_t size, used;						\
-	type *data;							\
-}
-
-#define DECLARE_HEAP(type, name) HEAP(type) name
-
 #define init_heap(heap, _size, gfp)					\
 ({									\
-	(heap)->used = 0;						\
-	(heap)->size = (_size);						\
-	(heap)->data = kvmalloc((heap)->size * sizeof((heap)->data[0]),\
-				 (gfp));				\
-})
-
-#define free_heap(heap)							\
-do {									\
-	kvfree((heap)->data);						\
-	(heap)->data = NULL;						\
-} while (0)
-
-#define heap_set_backpointer(h, i, _fn)					\
-do {									\
-	void (*fn)(typeof(h), size_t) = _fn;				\
-	if (fn)								\
-		fn(h, i);						\
-} while (0)
-
-#define heap_swap(h, i, j, set_backpointer)				\
-do {									\
-	swap((h)->data[i], (h)->data[j]);				\
-	heap_set_backpointer(h, i, set_backpointer);			\
-	heap_set_backpointer(h, j, set_backpointer);			\
-} while (0)
-
-#define heap_peek(h)							\
-({									\
-	EBUG_ON(!(h)->used);						\
-	(h)->data[0];							\
-})
-
-#define heap_full(h)	((h)->used == (h)->size)
-
-#define heap_sift_down(h, i, cmp, set_backpointer)			\
-do {									\
-	size_t _c, _j = i;						\
-									\
-	for (; _j * 2 + 1 < (h)->used; _j = _c) {			\
-		_c = _j * 2 + 1;					\
-		if (_c + 1 < (h)->used &&				\
-		    cmp(h, (h)->data[_c], (h)->data[_c + 1]) >= 0)	\
-			_c++;						\
-									\
-		if (cmp(h, (h)->data[_c], (h)->data[_j]) >= 0)		\
-			break;						\
-		heap_swap(h, _c, _j, set_backpointer);			\
-	}								\
-} while (0)
-
-#define heap_sift_up(h, i, cmp, set_backpointer)			\
-do {									\
-	while (i) {							\
-		size_t p = (i - 1) / 2;					\
-		if (cmp(h, (h)->data[i], (h)->data[p]) >= 0)		\
-			break;						\
-		heap_swap(h, i, p, set_backpointer);			\
-		i = p;							\
-	}								\
-} while (0)
-
-#define __heap_add(h, d, cmp, set_backpointer)				\
-({									\
-	size_t _i = (h)->used++;					\
-	(h)->data[_i] = d;						\
-	heap_set_backpointer(h, _i, set_backpointer);			\
-									\
-	heap_sift_up(h, _i, cmp, set_backpointer);			\
-	_i;								\
-})
-
-#define heap_add(h, d, cmp, set_backpointer)				\
-({									\
-	bool _r = !heap_full(h);					\
-	if (_r)								\
-		__heap_add(h, d, cmp, set_backpointer);			\
-	_r;								\
+	void *data = kvmalloc(_size * sizeof(*min_heap_peek(heap)), (gfp));\
+	min_heap_init(heap, data, _size);				\
+	min_heap_peek(heap);						\
 })
 
-#define heap_add_or_replace(h, new, cmp, set_backpointer)		\
-do {									\
-	if (!heap_add(h, new, cmp, set_backpointer) &&			\
-	    cmp(h, new, heap_peek(h)) >= 0) {				\
-		(h)->data[0] = new;					\
-		heap_set_backpointer(h, 0, set_backpointer);		\
-		heap_sift_down(h, 0, cmp, set_backpointer);		\
-	}								\
-} while (0)
 
-#define heap_del(h, i, cmp, set_backpointer)				\
+#define free_heap(_heap)							\
 do {									\
-	size_t _i = (i);						\
-									\
-	BUG_ON(_i >= (h)->used);					\
-	(h)->used--;							\
-	if ((_i) < (h)->used) {						\
-		heap_swap(h, _i, (h)->used, set_backpointer);		\
-		heap_sift_up(h, _i, cmp, set_backpointer);		\
-		heap_sift_down(h, _i, cmp, set_backpointer);		\
-	}								\
+	kvfree((_heap)->heap.data);						\
+	(_heap)->heap.data = NULL;						\
 } while (0)
 
-#define heap_pop(h, d, cmp, set_backpointer)				\
-({									\
-	bool _r = (h)->used;						\
-	if (_r) {							\
-		(d) = (h)->data[0];					\
-		heap_del(h, 0, cmp, set_backpointer);			\
-	}								\
-	_r;								\
-})
-
-#define heap_resort(heap, cmp, set_backpointer)				\
-do {									\
-	ssize_t _i;							\
-	for (_i = (ssize_t) (heap)->used / 2 -  1; _i >= 0; --_i)	\
-		heap_sift_down(heap, _i, cmp, set_backpointer);		\
-} while (0)
 
 #define ANYSINT_MAX(t)							\
 	((((t) 1 << (sizeof(t) * 8 - 2)) - (t) 1) * (t) 2 + (t) 1)
-- 
2.34.1


