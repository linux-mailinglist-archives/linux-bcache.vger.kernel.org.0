Return-Path: <linux-bcache+bounces-381-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6008989AC54
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 18:52:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9DC51F21305
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 16:52:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B0765F544;
	Sat,  6 Apr 2024 16:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jov4Arrb"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD015D731;
	Sat,  6 Apr 2024 16:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712422144; cv=none; b=giFYUbWIEA6WG2JLxcdp9R8+2aUPgag/rXYUrgKQPleHg/HrLNoG8MVkhXR+ldwv8VKKd13bE0y1Ba+v6EHxrhOJvg/JNPHBvYF0qVzrTv4nTl5ltJYGFYAt/9333DEJjau/WZWhhBlvWdH6XcPJhpzWIxMrloe41m0E60I833Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712422144; c=relaxed/simple;
	bh=h+XehoA9LdNS9hL8uunYNvcWW/80IE0+kfoE04EX+O4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qFyBCJEQhQw0RfpywsYSylIodiL6w923pKbZCUdCspQicCDoYJh7BV5+q3D9xD0oVjfn0M1SAhOTeXyLyM88PzhFaaWPb1U2vRWyxpnP+u9CxywO/ktjNezvqHV/0pGmxgeYauZuSGft+pg+Yf+2manz8TthiP11yiq6Ueb0cL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jov4Arrb; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6ecfea4f01cso484349b3a.0;
        Sat, 06 Apr 2024 09:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712422142; x=1713026942; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vlGmXCtgzURGTERGLYtOc+iv3C8hNBiorsfShg0hSpU=;
        b=jov4ArrbaYUEKCSf+ZaKkwK+grIP9fx7ELV+SiLOORymN6OTZQeL8FCQGtMNflPKQY
         hcNhMSk7S+asDd6OIJEPWfzjdJZdyGgXSz3ekM3QIo3XLqYNp6Rksonak1Zxy+DHrgNl
         Jl4x4iBUFWAaVmbW9QJVf9mjzf6+jRVr6uhg3zy5RxVP1dtdF3kTxI+KjTet5Xm2O7rs
         mk9kF7mZDRPmYSCf2a1617VqVUmePgQHlhmkpHt+GnOmk12tqsuM874pwKfA1+t1Zm8f
         7vg/SYrpfkj0xpjZsPLagdSPKYUnCtfE9PT25brXdSruzZsf7eSGWVNrMG0q1CYo7AoY
         plfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712422142; x=1713026942;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vlGmXCtgzURGTERGLYtOc+iv3C8hNBiorsfShg0hSpU=;
        b=suFXB/FXjDQSI2EHf/gLOMXWdu231SbsK7riRWM0DxY51PfIRqJS+cw7KFXC5/ZRtn
         VcYWKx1I8Gfv5f87lOlKC4Vkob/CzVno8XUU6M/qfEm8ffcg6FkMCn03pQYgnO4DR6Dy
         +XxFuUm9PvvnvC3Ufg3n+ZdYMusL6J8qJzz7oQRXMS3n0o5Ou3qgo+vYHppJyMYq0oIQ
         t3jWr6CBSiLN3vzwKZsbFQrZaw4EU1sXVihegCP4pKxStdVi6Wcs0yK9TrnaEPyz2E9j
         LTQ3XQlqqZXWHACHfteN5MDLpK/DX9aoVMFLUSc7jDRnzIJXyXjQo8JZUlzi7XnoTH4t
         o0KA==
X-Forwarded-Encrypted: i=1; AJvYcCXJ41WL2xM9i1YJrROS51GgRS1AjLvE5OyZxRFSl9eXWu01FLJHA05bnD5lnzGSQInZBGXYIQDkQT9JWEajqvc+Xy66Lo8zXDgINK2bIn+eab0igjihbbM2pbTWgIzLuPp4zo6i7WFnreqn2HwwdJke8vmOXDh3JqpnZF2JpjHw2yQ15S2AmKW+bG7hCWFW5MVsGJLnh9J2B9wgC+CZ7b5wcWiG71YvPU2Railk
X-Gm-Message-State: AOJu0Yy8+TfKc6Evzd7b3b9C+OMvjmEPtAvvlFfYDAqaNbU5zNNzg+lh
	s01b1eB8rgAyprkzS4dBK3bC3+OzPph/bf+tSwmWyRbxbLJLlHcq
X-Google-Smtp-Source: AGHT+IFCljFBOz2cdzxCQCqlN5fhikaRICtIKF/BhFfGVXGUpXsGXq1JPz2GF7MlkMaENuXBUZp3gg==
X-Received: by 2002:a17:902:e5c1:b0:1e0:c91b:b950 with SMTP id u1-20020a170902e5c100b001e0c91bb950mr5608910plf.5.1712422141897;
        Sat, 06 Apr 2024 09:49:01 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b001e2b8c91f04sm3665068plb.22.2024.04.06.09.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 09:49:01 -0700 (PDT)
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
Subject: [PATCH v3 17/17] bcachefs: Remove heap-related macros and switch to generic min_heap
Date: Sun,  7 Apr 2024 00:47:27 +0800
Message-Id: <20240406164727.577914-18-visitorckw@gmail.com>
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

Drop the heap-related macros from bcachefs and replacing them with the
generic min_heap implementation from include/linux. By doing so, code
readability is improved by using functions instead of macros. Moreover,
the min_heap implementation in include/linux adopts a bottom-up
variation compared to the textbook version currently used in bcachefs.
This bottom-up variation allows for approximately 50% reduction in the
number of comparison operations during heap siftdown, without changing
the number of swaps, thus making it more efficient.

Link: https://lkml.kernel.org/ioyfizrzq7w7mjrqcadtzsfgpuntowtjdw5pgn4qhvsdp4mqqg@nrlek5vmisbu
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
Changes in v3:
- Correct bugs where the parameter types in some compare functions
  should have been 'type **', but were mistakenly written as 'type *'.

 fs/bcachefs/clock.c       |  43 ++++++++++----
 fs/bcachefs/clock_types.h |   2 +-
 fs/bcachefs/ec.c          |  76 ++++++++++++++++--------
 fs/bcachefs/ec_types.h    |   2 +-
 fs/bcachefs/util.h        | 118 +-------------------------------------
 5 files changed, 87 insertions(+), 154 deletions(-)

diff --git a/fs/bcachefs/clock.c b/fs/bcachefs/clock.c
index 363644451106..3ec64fe6a064 100644
--- a/fs/bcachefs/clock.c
+++ b/fs/bcachefs/clock.c
@@ -6,16 +6,29 @@
 #include <linux/kthread.h>
 #include <linux/preempt.h>
 
-static inline long io_timer_cmp(io_timer_heap *h,
-				struct io_timer *l,
-				struct io_timer *r)
+static inline bool io_timer_cmp(const void *l, const void *r, void __always_unused *args)
 {
-	return l->expire - r->expire;
+	struct io_timer **_l = (struct io_timer **)l;
+	struct io_timer **_r = (struct io_timer **)r;
+
+	return (*_l)->expire < (*_r)->expire;
+}
+
+static inline void io_timer_swp(void *l, void *r, void __always_unused *args)
+{
+	struct io_timer **_l = (struct io_timer **)l;
+	struct io_timer **_r = (struct io_timer **)r;
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
+	for (i = 0; i < clock->timers.nr; i++)
 		if (clock->timers.data[i] == timer)
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
+	for (i = 0; i < clock->timers.nr; i++)
 		if (clock->timers.data[i] == timer) {
-			heap_del(&clock->timers, i, io_timer_cmp, NULL);
+			min_heap_del(&clock->timers, i, &callbacks, NULL);
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
+	if (clock->timers.nr &&
 	    time_after_eq(now, clock->timers.data[0]->expire))
-		heap_pop(&clock->timers, ret, io_timer_cmp, NULL);
+		min_heap_pop(&clock->timers, &callbacks, NULL);
 
 	spin_unlock(&clock->timer_lock);
 
@@ -161,7 +182,7 @@ void bch2_io_timers_to_text(struct printbuf *out, struct io_clock *clock)
 	spin_lock(&clock->timer_lock);
 	now = atomic64_read(&clock->now);
 
-	for (i = 0; i < clock->timers.used; i++)
+	for (i = 0; i < clock->timers.nr; i++)
 		prt_printf(out, "%ps:\t%li\n",
 		       clock->timers.data[i]->fn,
 		       clock->timers.data[i]->expire - now);
diff --git a/fs/bcachefs/clock_types.h b/fs/bcachefs/clock_types.h
index 5fae0012d808..59716e148645 100644
--- a/fs/bcachefs/clock_types.h
+++ b/fs/bcachefs/clock_types.h
@@ -23,7 +23,7 @@ struct io_timer {
 /* Amount to buffer up on a percpu counter */
 #define IO_CLOCK_PCPU_SECTORS	128
 
-typedef HEAP(struct io_timer *)	io_timer_heap;
+typedef MIN_HEAP(struct io_timer *, io_timer_heap)	io_timer_heap;
 
 struct io_clock {
 	atomic64_t		now;
diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index 082075244e16..f2d00dd9ca33 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -866,8 +866,8 @@ static int __ec_stripe_mem_alloc(struct bch_fs *c, size_t idx, gfp_t gfp)
 
 		mutex_lock(&c->ec_stripes_heap_lock);
 		if (n.size > h->size) {
-			memcpy(n.data, h->data, h->used * sizeof(h->data[0]));
-			n.used = h->used;
+			memcpy(n.data, h->data, h->nr * sizeof(h->data[0]));
+			n.nr = h->nr;
 			swap(*h, n);
 		}
 		mutex_unlock(&c->ec_stripes_heap_lock);
@@ -958,7 +958,7 @@ static u64 stripe_idx_to_delete(struct bch_fs *c)
 
 	lockdep_assert_held(&c->ec_stripes_heap_lock);
 
-	if (h->used &&
+	if (h->nr &&
 	    h->data[0].blocks_nonempty == 0 &&
 	    !bch2_stripe_is_open(c, h->data[0].idx))
 		return h->data[0].idx;
@@ -966,14 +966,6 @@ static u64 stripe_idx_to_delete(struct bch_fs *c)
 	return 0;
 }
 
-static inline int ec_stripes_heap_cmp(ec_stripes_heap *h,
-				      struct ec_stripe_heap_entry l,
-				      struct ec_stripe_heap_entry r)
-{
-	return ((l.blocks_nonempty > r.blocks_nonempty) -
-		(l.blocks_nonempty < r.blocks_nonempty));
-}
-
 static inline void ec_stripes_heap_set_backpointer(ec_stripes_heap *h,
 						   size_t i)
 {
@@ -982,39 +974,71 @@ static inline void ec_stripes_heap_set_backpointer(ec_stripes_heap *h,
 	genradix_ptr(&c->stripes, h->data[i].idx)->heap_idx = i;
 }
 
+static inline bool ec_stripes_heap_cmp(const void *l, const void *r, void __always_unused *args)
+{
+	struct ec_stripe_heap_entry *_l = (struct ec_stripe_heap_entry *)l;
+	struct ec_stripe_heap_entry *_r = (struct ec_stripe_heap_entry *)r;
+
+	return ((_l->blocks_nonempty > _r->blocks_nonempty) <
+		(_l->blocks_nonempty < _r->blocks_nonempty));
+}
+
+static inline void ec_stripes_heap_swap(void *l, void *r, void *h)
+{
+	struct ec_stripe_heap_entry *_l = (struct ec_stripe_heap_entry *)l;
+	struct ec_stripe_heap_entry *_r = (struct ec_stripe_heap_entry *)r;
+	ec_stripes_heap *_h = (ec_stripes_heap *)h;
+	size_t i = _l - _h->data;
+	size_t j = _r - _h->data;
+
+	ec_stripes_heap_set_backpointer(_h, i);
+	ec_stripes_heap_set_backpointer(_h, j);
+
+	swap(*_l, *_r);
+}
+
 static void heap_verify_backpointer(struct bch_fs *c, size_t idx)
 {
 	ec_stripes_heap *h = &c->ec_stripes_heap;
 	struct stripe *m = genradix_ptr(&c->stripes, idx);
 
-	BUG_ON(m->heap_idx >= h->used);
+	BUG_ON(m->heap_idx >= h->nr);
 	BUG_ON(h->data[m->heap_idx].idx != idx);
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
+	genradix_ptr(&c->stripes, idx)->heap_idx = c->ec_stripes_heap.nr;
+	min_heap_push(&c->ec_stripes_heap, &((struct ec_stripe_heap_entry) {
 			.idx = idx,
 			.blocks_nonempty = m->blocks_nonempty,
 		}),
-		 ec_stripes_heap_cmp,
-		 ec_stripes_heap_set_backpointer);
+		&callbacks,
+		&c->ec_stripes_heap);
 
 	heap_verify_backpointer(c, idx);
 	mutex_unlock(&c->ec_stripes_heap_lock);
@@ -1023,6 +1047,10 @@ void bch2_stripes_heap_insert(struct bch_fs *c,
 void bch2_stripes_heap_update(struct bch_fs *c,
 			      struct stripe *m, size_t idx)
 {
+	const struct min_heap_callbacks callbacks = {
+		.less = ec_stripes_heap_cmp,
+		.swp = ec_stripes_heap_swap,
+	};
 	ec_stripes_heap *h = &c->ec_stripes_heap;
 	bool do_deletes;
 	size_t i;
@@ -1033,10 +1061,8 @@ void bch2_stripes_heap_update(struct bch_fs *c,
 	h->data[m->heap_idx].blocks_nonempty = m->blocks_nonempty;
 
 	i = m->heap_idx;
-	heap_sift_up(h,	  i, ec_stripes_heap_cmp,
-		     ec_stripes_heap_set_backpointer);
-	heap_sift_down(h, i, ec_stripes_heap_cmp,
-		       ec_stripes_heap_set_backpointer);
+	min_heap_sift_up(h,	i, &callbacks, &c->ec_stripes_heap);
+	min_heap_sift_down(h, i, &callbacks, &c->ec_stripes_heap);
 
 	heap_verify_backpointer(c, idx);
 
@@ -1828,7 +1854,7 @@ static s64 get_existing_stripe(struct bch_fs *c,
 		return -1;
 
 	mutex_lock(&c->ec_stripes_heap_lock);
-	for (heap_idx = 0; heap_idx < h->used; heap_idx++) {
+	for (heap_idx = 0; heap_idx < h->nr; heap_idx++) {
 		/* No blocks worth reusing, stripe will just be deleted: */
 		if (!h->data[heap_idx].blocks_nonempty)
 			continue;
@@ -2159,7 +2185,7 @@ void bch2_stripes_heap_to_text(struct printbuf *out, struct bch_fs *c)
 	size_t i;
 
 	mutex_lock(&c->ec_stripes_heap_lock);
-	for (i = 0; i < min_t(size_t, h->used, 50); i++) {
+	for (i = 0; i < min_t(size_t, h->nr, 50); i++) {
 		m = genradix_ptr(&c->stripes, h->data[i].idx);
 
 		prt_printf(out, "%zu %u/%u+%u", h->data[i].idx,
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
index b7e7c29278fc..9757c2c1218e 100644
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
@@ -54,17 +55,9 @@ static inline size_t buf_pages(void *p, size_t len)
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
+	(heap)->nr = 0;						\
 	(heap)->size = (_size);						\
 	(heap)->data = kvmalloc((heap)->size * sizeof((heap)->data[0]),\
 				 (gfp));				\
@@ -76,113 +69,6 @@ do {									\
 	(heap)->data = NULL;						\
 } while (0)
 
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
-})
-
-#define heap_add_or_replace(h, new, cmp, set_backpointer)		\
-do {									\
-	if (!heap_add(h, new, cmp, set_backpointer) &&			\
-	    cmp(h, new, heap_peek(h)) >= 0) {				\
-		(h)->data[0] = new;					\
-		heap_set_backpointer(h, 0, set_backpointer);		\
-		heap_sift_down(h, 0, cmp, set_backpointer);		\
-	}								\
-} while (0)
-
-#define heap_del(h, i, cmp, set_backpointer)				\
-do {									\
-	size_t _i = (i);						\
-									\
-	BUG_ON(_i >= (h)->used);					\
-	(h)->used--;							\
-	if ((_i) < (h)->used) {						\
-		heap_swap(h, _i, (h)->used, set_backpointer);		\
-		heap_sift_up(h, _i, cmp, set_backpointer);		\
-		heap_sift_down(h, _i, cmp, set_backpointer);		\
-	}								\
-} while (0)
-
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
-
 #define ANYSINT_MAX(t)							\
 	((((t) 1 << (sizeof(t) * 8 - 2)) - (t) 1) * (t) 2 + (t) 1)
 
-- 
2.34.1


