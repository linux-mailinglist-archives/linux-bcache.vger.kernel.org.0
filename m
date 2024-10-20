Return-Path: <linux-bcache+bounces-771-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 813749A524C
	for <lists+linux-bcache@lfdr.de>; Sun, 20 Oct 2024 06:05:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37F662816B5
	for <lists+linux-bcache@lfdr.de>; Sun, 20 Oct 2024 04:05:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CA1C18754F;
	Sun, 20 Oct 2024 04:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AgqeJI36"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D6015E90;
	Sun, 20 Oct 2024 04:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729396984; cv=none; b=XfhwxJt2JBv5ldqCCaORAcs6FvjNNTiS/QOv0/XpYiuS4D4gMRlVbmLtWkyinYe+6ehtCpHh11yozvHnSPQciBrJdA9AoJ1LYHGCrMnsuMaM7297v+AIpB9osGDv1tZ+eVXOVP7oHwBQxsAXvqOyiUVWY3SPal9gatBVN+UXY90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729396984; c=relaxed/simple;
	bh=n8isBE3MN50NKJqA8PJEYk21R5urgQClhVIMe0Dv/fw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HBxsipTaWboB19k9qk3yVYjwq2YZpEsdv12RZh3TjdMawXlKgYBc8s2+CopV4DueH9pdKbDcCI5wdXuohCOL2lsfE7nsf7CtQZOCm59DM1xBOp16ruYCacjx9qly/o3DWcD+VtfbokajJ41uTiYNUmmYN3/rNzQe5yjIwNFDNEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AgqeJI36; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2e5a0177531so312167a91.2;
        Sat, 19 Oct 2024 21:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729396982; x=1730001782; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y2WpY9CipWcCt1Q+dpvLbF+kv/AA/FlDoXHDWd/V5GE=;
        b=AgqeJI36E0s2uZkAXeNGqkulb8QXEMYErJKXBlq+/0v+nu67Ex5wQXaSWGcqKo7FpG
         5o7K8uwarn998hw6DTDatlbMcjwSa+En+OYoop3qi/JGm1OzqUB6IRsX/qAjwD+6+UF8
         W2lTkFlPBN41ck1z77ZNWb7YOm6oYY1TgWw5SZvsQ1UvqUIT9qKVD8Eci0oaI9mvcAwf
         OiP8j0wjd5zaGBC8ymYv55hJKB8v8tSTfaClEZ3lG84WgTBHx3jPW8ePPdFZfKzlxUQ+
         ZYZIiklWuffv3VM7UJXqgWzfDtLkkpTkmrTc1gPz3MBOuFMKDB0QO+g+3GMGzwHa/h/E
         +eeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729396982; x=1730001782;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y2WpY9CipWcCt1Q+dpvLbF+kv/AA/FlDoXHDWd/V5GE=;
        b=s29fz/wg5LgLDkkqEzOFuzaoVXGrr2Bb4/9NDe3ZDxnPxJVDxCQx20O38zx/56ZqaZ
         Q5NQpK/Bzd2AgMT/po8Nx4WZv9PHNAZmrJlo8SOHDWoNPaNQ3n07VFGbfQWu8SvVqa48
         HDWmihbngGX+U0C8xoJRzuD6eY2xXbz15BjjLLHciP3P/UFbcRj8IJKVWf1vFXhcuC/f
         MVn8uP6dk3QiroQSo234PDulL9BEQTYU7aFTcwH1moK1viIwN8LdKJ64d61+3/+zyxBj
         p3e9W5UXWdjDg6dep6WRBkEiROLzMWI9U5w7wI6ggSMi4oabqfCHFMABOtqJAblJhQEH
         Nc6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUawB3eC+yf1C2j/NS5UAgKngwNvrE8KFu9aP8g+XUKY9MU8Iy9BEYaijveA0hupuE57jj0GiDDCOngARjQFDjGUw==@vger.kernel.org, AJvYcCVH1bzwLf1QaevLvbkMYydvWOWFc44b76M0wmnTyOv7aevXUGOy2MPHKu0XaoIIIs8fGoJDm/NAUvGYrGPi@vger.kernel.org, AJvYcCWYYhzW4uBoKn37j6L7npge5WSWiYFwkP2Kgb7yhSOpUaKrEYsR9PVK9VzqKc7D++qdOB7cPFS025j8@vger.kernel.org, AJvYcCX9vLooMVGbhBWLfgY5vR2RWawnPTecovUpOQjf8D/nKHbJhOlS73SCcQcE8Ik09QkeivC7yEyKpKu9sUM=@vger.kernel.org, AJvYcCXVydNr9JCyXciFcdQ2lWQ9cgr4lI+Arpki9s6YiAbEH6mpWjy4JgeaaC/Q7JogQcQye+7zS0n612sCvTV4SMA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1fQ/k89V9xcrt1XUb7HkquIxPyPtmNrBtDXLoXksZ3IgWucN8
	FEtbL+VBfgSig9uDfWxjeiwoGZYsBZHA4jNu9aHpkYPPF0QYtUI/
X-Google-Smtp-Source: AGHT+IH54s8bJnfmuveWObV3S7Rz7YBN+EE45vAptSs0RDb+pOmoExhRB5pOMmx0MvRYyg7vgzn+7w==
X-Received: by 2002:a17:90b:3002:b0:2e2:e6bf:534b with SMTP id 98e67ed59e1d1-2e56172c054mr7219281a91.40.1729396981742;
        Sat, 19 Oct 2024 21:03:01 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad3678d3sm633668a91.24.2024.10.19.21.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2024 21:03:01 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: colyli@suse.de,
	kent.overstreet@linux.dev,
	msakai@redhat.com,
	corbet@lwn.net,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	akpm@linux-foundation.org
Cc: mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	kan.liang@linux.intel.com,
	willy@infradead.org,
	jserv@ccns.ncku.edu.tw,
	linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH v2 08/10] bcachefs: Clean up duplicate min_heap_callbacks declarations
Date: Sun, 20 Oct 2024 12:01:58 +0800
Message-Id: <20241020040200.939973-9-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241020040200.939973-1-visitorckw@gmail.com>
References: <20241020040200.939973-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the bcachefs code to remove multiple redundant declarations of
min_heap_callbacks, ensuring that each unique declaration appears only
once.

Link: https://lore.kernel.org/20241017095520.GV16066@noisy.programming.kicks-ass.net
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 fs/bcachefs/clock.c | 19 +++++--------------
 fs/bcachefs/ec.c    | 19 +++++--------------
 2 files changed, 10 insertions(+), 28 deletions(-)

diff --git a/fs/bcachefs/clock.c b/fs/bcachefs/clock.c
index 1d6b691e8da6..1fcfcb5fd44f 100644
--- a/fs/bcachefs/clock.c
+++ b/fs/bcachefs/clock.c
@@ -22,13 +22,13 @@ static inline void io_timer_swp(void *l, void *r, void __always_unused *args)
 	swap(*_l, *_r);
 }
 
+static const struct min_heap_callbacks callbacks = {
+	.less = io_timer_cmp,
+	.swp = io_timer_swp,
+};
+
 void bch2_io_timer_add(struct io_clock *clock, struct io_timer *timer)
 {
-	const struct min_heap_callbacks callbacks = {
-		.less = io_timer_cmp,
-		.swp = io_timer_swp,
-	};
-
 	spin_lock(&clock->timer_lock);
 
 	if (time_after_eq64((u64) atomic64_read(&clock->now), timer->expire)) {
@@ -48,11 +48,6 @@ void bch2_io_timer_add(struct io_clock *clock, struct io_timer *timer)
 
 void bch2_io_timer_del(struct io_clock *clock, struct io_timer *timer)
 {
-	const struct min_heap_callbacks callbacks = {
-		.less = io_timer_cmp,
-		.swp = io_timer_swp,
-	};
-
 	spin_lock(&clock->timer_lock);
 
 	for (size_t i = 0; i < clock->timers.nr; i++)
@@ -142,10 +137,6 @@ void bch2_kthread_io_clock_wait(struct io_clock *clock,
 static struct io_timer *get_expired_timer(struct io_clock *clock, u64 now)
 {
 	struct io_timer *ret = NULL;
-	const struct min_heap_callbacks callbacks = {
-		.less = io_timer_cmp,
-		.swp = io_timer_swp,
-	};
 
 	if (clock->timers.nr &&
 	    time_after_eq64(now, clock->timers.data[0]->expire)) {
diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index e410cfe37b1a..c88f10d0606f 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -1057,6 +1057,11 @@ static inline void ec_stripes_heap_swap(void *l, void *r, void *h)
 	ec_stripes_heap_set_backpointer(_h, j);
 }
 
+static const struct min_heap_callbacks callbacks = {
+	.less = ec_stripes_heap_cmp,
+	.swp = ec_stripes_heap_swap,
+};
+
 static void heap_verify_backpointer(struct bch_fs *c, size_t idx)
 {
 	ec_stripes_heap *h = &c->ec_stripes_heap;
@@ -1069,11 +1074,6 @@ static void heap_verify_backpointer(struct bch_fs *c, size_t idx)
 void bch2_stripes_heap_del(struct bch_fs *c,
 			   struct stripe *m, size_t idx)
 {
-	const struct min_heap_callbacks callbacks = {
-		.less = ec_stripes_heap_cmp,
-		.swp = ec_stripes_heap_swap,
-	};
-
 	mutex_lock(&c->ec_stripes_heap_lock);
 	heap_verify_backpointer(c, idx);
 
@@ -1084,11 +1084,6 @@ void bch2_stripes_heap_del(struct bch_fs *c,
 void bch2_stripes_heap_insert(struct bch_fs *c,
 			      struct stripe *m, size_t idx)
 {
-	const struct min_heap_callbacks callbacks = {
-		.less = ec_stripes_heap_cmp,
-		.swp = ec_stripes_heap_swap,
-	};
-
 	mutex_lock(&c->ec_stripes_heap_lock);
 	BUG_ON(min_heap_full(&c->ec_stripes_heap));
 
@@ -1107,10 +1102,6 @@ void bch2_stripes_heap_insert(struct bch_fs *c,
 void bch2_stripes_heap_update(struct bch_fs *c,
 			      struct stripe *m, size_t idx)
 {
-	const struct min_heap_callbacks callbacks = {
-		.less = ec_stripes_heap_cmp,
-		.swp = ec_stripes_heap_swap,
-	};
 	ec_stripes_heap *h = &c->ec_stripes_heap;
 	bool do_deletes;
 	size_t i;
-- 
2.34.1


