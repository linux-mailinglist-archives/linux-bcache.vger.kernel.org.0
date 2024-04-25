Return-Path: <linux-bcache+bounces-421-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6A758B23F7
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 16:24:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E5A91F2115D
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 14:24:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2AF9155391;
	Thu, 25 Apr 2024 14:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rp4QPFv2"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE89314B065;
	Thu, 25 Apr 2024 14:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714054791; cv=none; b=ZUfNLd9T88uTeZHw9RxS8q0aSiQg/ok6bBShEgf8Z7TbcX1+i394HeeoSVhdn6S+COSMR7+ODn3p49vAI2FdQakrC8o+yHYE/e98gtS6Bb10h8N00dUyhDICo2us3Fye9UKtppJ7rtvxZu7l+TMjUF92xdFIZq6TBO8I+MfTllc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714054791; c=relaxed/simple;
	bh=zdDqeX1+1QEGuoTmK2ZnrwD+LKYtS8f4ZXb8ed+Eme8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OWtK3gRmab4s7Ffoltf05fQOsXaLOHZ9wf5AfD77nzma1XUVcK0GDNjklkmdr9Va6SZMeB6qM4d5szeNN7vGUndWXgASAyCK/WRCTBIfR626pckDeh1v8pNCc72/lVhSe6K+mT6tvtejs61jJbNKIsNNtBrWlUTSxDFWAb43lH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rp4QPFv2; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1e825c65c9bso116605ad.2;
        Thu, 25 Apr 2024 07:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714054789; x=1714659589; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J6NqyQrctkzCfziO6/T6yC8PVEhcoyrj5OJlrdP0FjI=;
        b=Rp4QPFv2b5A6YzaKFkYYRsi+uoK8TcY/RJCI6VLLJvALP01OpL+IT4VtUAihaY2e/W
         xAHS1p+h9yGjdOYGQi1N4PEchlU+Ft/hzCE1YkAOeqz4OZjvBxfhpjikjqBlYTYtNSVe
         n25sdFHtnzQGad37k1JszhGujM6oX3YKPVFagBPFEFJJFK5I+Nohg45KQG2sWoiJU5ae
         u9hz44/tPhlxkRhX4sdM8rdeXpyoZN77ZXkZn/xsyAWA8TpqJs/1kqAgbV3cBPruyQWZ
         s7MztL8ekOxCH8QCkiFGRy7OqbLTj+RkECVMM/ghpoG/pYHhhJjmUQjgETxdlMb/FIWt
         r6WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714054789; x=1714659589;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J6NqyQrctkzCfziO6/T6yC8PVEhcoyrj5OJlrdP0FjI=;
        b=JvF/roPB32yoVUSsAIHLYjD+YYzzhhmFOgcnwDahYiDImoIF9T7iDZPCJ2BIK7wvG5
         c+SigA/MtCcDSiz4xuPBPmen+IpE27k97JETEM2jNvV3PWT3kZpy+6aD2ELQNrFer8kc
         TJhBN67Q1Xu7SVNX0qI8jjO+Q1nP06sNXJ1oEpLwtrJlzqR7kBzvljZ1OXIxnP77U+Pc
         xPj1edxfcs/oMsA7Jy1Wg1Flk3gzgxk5EncqsDrW3NQ5WCZRYHsNUGiocLvayaDGyOUM
         xkygqis0m4CqdTvNiM9YXG8wjkN/OW/pwP156P/1QarhtSKE/VhLoHm2588k7f7xo0vY
         kpPw==
X-Forwarded-Encrypted: i=1; AJvYcCWzuitaEYS5m8hguIBvpMFQj1WlADASHqyN2Sj2X4kBcDlBblfNesOjfkqwz0nbGqHFrTjKnpsxmZh8OQR13mi0oMQTk3l+iFdrqh0Of6pQwyHi1W66Ixhriqj4m9ZA+ORHjnEgXnuh4CMfkUYgc9hWeqhXkFiZjY1oTEYbSUZ0eMA+Wy8KOn19dNdZOxjQIZhp7k/QOw2q+53CYvfzzGm80nK0gkUhqrZdZ4QP
X-Gm-Message-State: AOJu0YyaX8VuxaVqaBh4rjHMswIbl7KqJi9sLSO8SZo1l4O+S8SjZWRX
	e/AAH8n9JjBA7QTIJUfnnldfiOfLfGCs4F534g2WaUC8ambg5Urb
X-Google-Smtp-Source: AGHT+IGR7S4gQOtrTx60AMKLS4Us1wyxOR35cVJGcCQLsECmLozBJyTOCovG6de7BwCtzwBjCkWqtA==
X-Received: by 2002:a05:6a20:68a8:b0:1ad:df1:c05d with SMTP id n40-20020a056a2068a800b001ad0df1c05dmr5208221pzj.3.1714054789305;
        Thu, 25 Apr 2024 07:19:49 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id go20-20020a056a003b1400b006e6233563cesm13162397pfb.218.2024.04.25.07.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 07:19:48 -0700 (PDT)
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
Subject: [PATCH v4 16/16] bcachefs: Remove heap-related macros and switch to generic min_heap
Date: Thu, 25 Apr 2024 22:18:26 +0800
Message-Id: <20240425141826.840077-17-visitorckw@gmail.com>
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
Changes in v4:
- Fix an error in ec_stripes_heap_swap() where
  ec_stripes_heap_set_backpointer() should be called after swapping.

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
index 556a217108d3..0831e745dd12 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -868,8 +868,8 @@ static int __ec_stripe_mem_alloc(struct bch_fs *c, size_t idx, gfp_t gfp)
 
 		mutex_lock(&c->ec_stripes_heap_lock);
 		if (n.size > h->size) {
-			memcpy(n.data, h->data, h->used * sizeof(h->data[0]));
-			n.used = h->used;
+			memcpy(n.data, h->data, h->nr * sizeof(h->data[0]));
+			n.nr = h->nr;
 			swap(*h, n);
 		}
 		mutex_unlock(&c->ec_stripes_heap_lock);
@@ -960,7 +960,7 @@ static u64 stripe_idx_to_delete(struct bch_fs *c)
 
 	lockdep_assert_held(&c->ec_stripes_heap_lock);
 
-	if (h->used &&
+	if (h->nr &&
 	    h->data[0].blocks_nonempty == 0 &&
 	    !bch2_stripe_is_open(c, h->data[0].idx))
 		return h->data[0].idx;
@@ -968,14 +968,6 @@ static u64 stripe_idx_to_delete(struct bch_fs *c)
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
@@ -984,39 +976,71 @@ static inline void ec_stripes_heap_set_backpointer(ec_stripes_heap *h,
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
+	swap(*_l, *_r);
+
+	ec_stripes_heap_set_backpointer(_h, i);
+	ec_stripes_heap_set_backpointer(_h, j);
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
@@ -1025,6 +1049,10 @@ void bch2_stripes_heap_insert(struct bch_fs *c,
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
@@ -1035,10 +1063,8 @@ void bch2_stripes_heap_update(struct bch_fs *c,
 	h->data[m->heap_idx].blocks_nonempty = m->blocks_nonempty;
 
 	i = m->heap_idx;
-	heap_sift_up(h,	  i, ec_stripes_heap_cmp,
-		     ec_stripes_heap_set_backpointer);
-	heap_sift_down(h, i, ec_stripes_heap_cmp,
-		       ec_stripes_heap_set_backpointer);
+	min_heap_sift_up(h,	i, &callbacks, &c->ec_stripes_heap);
+	min_heap_sift_down(h, i, &callbacks, &c->ec_stripes_heap);
 
 	heap_verify_backpointer(c, idx);
 
@@ -1830,7 +1856,7 @@ static s64 get_existing_stripe(struct bch_fs *c,
 		return -1;
 
 	mutex_lock(&c->ec_stripes_heap_lock);
-	for (heap_idx = 0; heap_idx < h->used; heap_idx++) {
+	for (heap_idx = 0; heap_idx < h->nr; heap_idx++) {
 		/* No blocks worth reusing, stripe will just be deleted: */
 		if (!h->data[heap_idx].blocks_nonempty)
 			continue;
@@ -2161,7 +2187,7 @@ void bch2_stripes_heap_to_text(struct printbuf *out, struct bch_fs *c)
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
index 5cf885b09986..d5a1f1e29013 100644
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


