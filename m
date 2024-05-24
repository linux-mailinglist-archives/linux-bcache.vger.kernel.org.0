Return-Path: <linux-bcache+bounces-489-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 332458CE81C
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 17:36:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D555928112B
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 15:36:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C64513329E;
	Fri, 24 May 2024 15:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MXBorRCB"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D51C12F381;
	Fri, 24 May 2024 15:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564689; cv=none; b=ROMYmHj2V3olwIbhE6dVa3wZ7kOXpnQ+lkUzCHEgxeamraWVGVAUdI2xhbe+DHt0WKuf5J+urLYfCV/CqSoIyzNrn1eVBsl2oyN5CoB4PnV/RyhaHKNAxuQJH6nQU40xQqg8spzL+B43PXLVNyeibhI8hSQOSIzPKA2WixQiiY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564689; c=relaxed/simple;
	bh=A6nkXhDo3vRgC0ouJzd/jrZPACR0P+/9713U0Tn3QY0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GIQL49sSm94Slv76nDpWhuzUBCbUv3dZtlgb9E2mPSyEexoojey9diQwNAuiAQwJrc931Csp8WE9cbWuGYfFb9tQYncUVsd/Tu/j1Bfv4ZstXjsKah+L9Nirl9A77qU3hrk/WOJYFQMqfEDqZfjTkEpUFN1et2yxNwpuZSZ0TVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MXBorRCB; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2bf5baa5b76so103453a91.0;
        Fri, 24 May 2024 08:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716564687; x=1717169487; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5uL7niTDxIwgtvT483XQdSOjcKJiY9fkFNHM4CoL7As=;
        b=MXBorRCB8HdkiB+c7iTIlj1BHW2VeMCxoCQQRNaCL6+Jyz2XOm4RdxFUFthEtOwCVe
         cArT/puBgdO36T1ytiD/wbafihoVb4uwwEC7muEh+SQeN/1pRa/eF5yR3z1ZZgdppkvg
         LmnC0i+r1Wx9RDdhNNnuFnJZnwcNroIPJIB/ZqBijn7zQd/1QGHNVDjiADbEqVuvCd3r
         RlqT8mDl7YXJcxn3BJBzKCVAfmkQxhO0DRqZn48HCzwiySlYBJGrdglHmQ+GXffdJsUi
         ieHVKQLCGING4d+5cDdj/g9rUJhH5e+mnEkKTTdIGxanT8OUsPfQXJ4bXW2sOsa7cl6q
         7NJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716564687; x=1717169487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5uL7niTDxIwgtvT483XQdSOjcKJiY9fkFNHM4CoL7As=;
        b=oyi0D1Z+xaaeB8Khn/4WRvakzy/r3IRhlGw5WXPl5rfupaOcVWx/hOkONnNEZR3TnF
         UgfinEZkiQ1eryzRATbFKdGh51wUw0kI9bwGjAY/aA2W2mSh7y4KCSjaSQDQKIsnv9uf
         0RYfMX10uOslvpIbuvBSVFaz2fsZRIYk43T0zQZ+0Ha6euYDiGayfQF36HkD0qTy1az9
         P1MeiCWAWK0v+xPOCQVvUhzzL8AB7blkwN/OsnahmdKX3Or2B/JQk+CXuT/uWxi+gtjj
         MeWOxwE/klrXlKrpsPhZVVRJMRDEMRiaw4sBchOV/BW2pakga6dOipBX7PTj9fnCGIta
         obyw==
X-Forwarded-Encrypted: i=1; AJvYcCVKfwqzZS7Qs4H7KufUxq2oqdB34iQ5Jpcgvxj1UMVnSZEQSIoYMf+3KyX1IKyhZqdXKKX4JzH7jJMSadbHfygcXqCS1XbtykYJayGaGCpSosLeTj7w3uxjdy3bVlPyQ1OfYBcjpAydrJuq7AtMYUM956blK/TeCglwxardzeQ9AvwFGAI+gIPeTExnNFq778AKRlLkW/tnzy/y4alRQ8BCD6LNAlkQ/RQvQORz
X-Gm-Message-State: AOJu0YxT6eG0RzaLuAql9iRio2Liivi3KnBMmYhVYB+Yaw+Cq1P+KNlR
	K4auQV100wFtQFG1TBLkegd/BUoeopZx2u7whRAZCMZhgwtbC7wf4YidAA==
X-Google-Smtp-Source: AGHT+IGHGxs6xYS1pxOoTReksRT5lb2eG9Sec99+HTPhjDOGe5bGI7HQWqGqKuRY3Cvudglt4fu64g==
X-Received: by 2002:a17:90b:3110:b0:2bd:8b85:d7ca with SMTP id 98e67ed59e1d1-2bf5e0a753emr2553910a91.0.1716564686682;
        Fri, 24 May 2024 08:31:26 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f50d294sm1525556a91.20.2024.05.24.08.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 08:31:24 -0700 (PDT)
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
Subject: [PATCH v6 16/16] bcachefs: Remove heap-related macros and switch to generic min_heap
Date: Fri, 24 May 2024 23:29:58 +0800
Message-Id: <20240524152958.919343-17-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240524152958.919343-1-visitorckw@gmail.com>
References: <20240524152958.919343-1-visitorckw@gmail.com>
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
Acked-by: Kent Overstreet <kent.overstreet@linux.dev>
---
Changes in v6:
- Rename the MIN_HEAP() macro to DEFINE_MIN_HEAP().

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
index 5fae0012d808..f2c8a25b7079 100644
--- a/fs/bcachefs/clock_types.h
+++ b/fs/bcachefs/clock_types.h
@@ -23,7 +23,7 @@ struct io_timer {
 /* Amount to buffer up on a percpu counter */
 #define IO_CLOCK_PCPU_SECTORS	128
 
-typedef HEAP(struct io_timer *)	io_timer_heap;
+typedef DEFINE_MIN_HEAP(struct io_timer *, io_timer_heap)	io_timer_heap;
 
 struct io_clock {
 	atomic64_t		now;
diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index b26dc7424662..797cb389cf3f 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -896,8 +896,8 @@ static int __ec_stripe_mem_alloc(struct bch_fs *c, size_t idx, gfp_t gfp)
 
 		mutex_lock(&c->ec_stripes_heap_lock);
 		if (n.size > h->size) {
-			memcpy(n.data, h->data, h->used * sizeof(h->data[0]));
-			n.used = h->used;
+			memcpy(n.data, h->data, h->nr * sizeof(h->data[0]));
+			n.nr = h->nr;
 			swap(*h, n);
 		}
 		mutex_unlock(&c->ec_stripes_heap_lock);
@@ -988,7 +988,7 @@ static u64 stripe_idx_to_delete(struct bch_fs *c)
 
 	lockdep_assert_held(&c->ec_stripes_heap_lock);
 
-	if (h->used &&
+	if (h->nr &&
 	    h->data[0].blocks_nonempty == 0 &&
 	    !bch2_stripe_is_open(c, h->data[0].idx))
 		return h->data[0].idx;
@@ -996,14 +996,6 @@ static u64 stripe_idx_to_delete(struct bch_fs *c)
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
@@ -1012,39 +1004,71 @@ static inline void ec_stripes_heap_set_backpointer(ec_stripes_heap *h,
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
@@ -1053,6 +1077,10 @@ void bch2_stripes_heap_insert(struct bch_fs *c,
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
@@ -1063,10 +1091,8 @@ void bch2_stripes_heap_update(struct bch_fs *c,
 	h->data[m->heap_idx].blocks_nonempty = m->blocks_nonempty;
 
 	i = m->heap_idx;
-	heap_sift_up(h,	  i, ec_stripes_heap_cmp,
-		     ec_stripes_heap_set_backpointer);
-	heap_sift_down(h, i, ec_stripes_heap_cmp,
-		       ec_stripes_heap_set_backpointer);
+	min_heap_sift_up(h,	i, &callbacks, &c->ec_stripes_heap);
+	min_heap_sift_down(h, i, &callbacks, &c->ec_stripes_heap);
 
 	heap_verify_backpointer(c, idx);
 
@@ -1859,7 +1885,7 @@ static s64 get_existing_stripe(struct bch_fs *c,
 		return -1;
 
 	mutex_lock(&c->ec_stripes_heap_lock);
-	for (heap_idx = 0; heap_idx < h->used; heap_idx++) {
+	for (heap_idx = 0; heap_idx < h->nr; heap_idx++) {
 		/* No blocks worth reusing, stripe will just be deleted: */
 		if (!h->data[heap_idx].blocks_nonempty)
 			continue;
@@ -2190,7 +2216,7 @@ void bch2_stripes_heap_to_text(struct printbuf *out, struct bch_fs *c)
 	size_t i;
 
 	mutex_lock(&c->ec_stripes_heap_lock);
-	for (i = 0; i < min_t(size_t, h->used, 50); i++) {
+	for (i = 0; i < min_t(size_t, h->nr, 50); i++) {
 		m = genradix_ptr(&c->stripes, h->data[i].idx);
 
 		prt_printf(out, "%zu %u/%u+%u", h->data[i].idx,
diff --git a/fs/bcachefs/ec_types.h b/fs/bcachefs/ec_types.h
index 976426da3a12..1df03dccfc72 100644
--- a/fs/bcachefs/ec_types.h
+++ b/fs/bcachefs/ec_types.h
@@ -36,6 +36,6 @@ struct ec_stripe_heap_entry {
 	unsigned		blocks_nonempty;
 };
 
-typedef HEAP(struct ec_stripe_heap_entry) ec_stripes_heap;
+typedef DEFINE_MIN_HEAP(struct ec_stripe_heap_entry, ec_stripes_heap) ec_stripes_heap;
 
 #endif /* _BCACHEFS_EC_TYPES_H */
diff --git a/fs/bcachefs/util.h b/fs/bcachefs/util.h
index 5d2c470a49ac..d0d99400f986 100644
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


