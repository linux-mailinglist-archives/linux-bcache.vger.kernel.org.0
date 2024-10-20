Return-Path: <linux-bcache+bounces-770-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A1A49A5247
	for <lists+linux-bcache@lfdr.de>; Sun, 20 Oct 2024 06:04:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA99228418A
	for <lists+linux-bcache@lfdr.de>; Sun, 20 Oct 2024 04:04:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 856B814D6F9;
	Sun, 20 Oct 2024 04:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T6UulojL"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD8413B7BD;
	Sun, 20 Oct 2024 04:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729396979; cv=none; b=ZNex0ZQIy+tgikPagsEc/Rie6NBaa2lUiohXAgGmzn3CX33+jBeeCNQGtEgAzs7+P8sjxGiaCaK+ZtjQNZwALqXqDLEp53JSMZQwGi88hZBCLas52LPug701QAMARLEM+PeDBfqASs8So1WFhs2Jm91ZR/WMpJIiO9Fov3CImAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729396979; c=relaxed/simple;
	bh=FXrcKA4kv0Y0H6AHaICGqhxwnnRf14RLEiJ/iEAwoxU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j4eCYjggR6sm+nLvNmYTp1aKy1aaUaOVtMjpi3l4S8ZCwiD2krRgmn0Z2nA4MTc4ZvQgV+BPVzpmvA2OT6sZb4WvWXyohHIfE6TLtgZ09l3dvYZJEhnmIIfSCW/ore39mlYaUTtD78lEND4CjlB2DstAgguBuT06Gxm4gAp2svs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T6UulojL; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-7ea68af2f62so2685001a12.3;
        Sat, 19 Oct 2024 21:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729396977; x=1730001777; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gLYYPN6VMSbce5qBI6UYe5zetX0JUYbruyELXEOs2l4=;
        b=T6UulojLMd+5lVczZZg/tSV8Sk+snQr3l0hwrecOte5dK/rAKwR62bGNVnfWvC73Bv
         sHbshMoK1/BXkD57FiLhJkkCYhGbEd95PE6DlsWdHkbJvpNpW/U6D38wzEy6IRdYYsOD
         FpA4zMq3/MYSSX1cKbtLIXm9yYZsWPz+BsiM0JGRYFcgry0JuabTJwHboKMb9DqpC+Sr
         kqnwSIsqI3tKPooWRuwMmwG+xczKsp6EkMsgeM5qxl+ebe8KN2XhEgbUfxFCPT1Fg3jW
         arPCsUwKOm/AhoSmvnSTvyPjJntUz7SB4tZgpFXejmViFUfDDO+/J+aFdkNPls4Vo4Tb
         N1Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729396977; x=1730001777;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gLYYPN6VMSbce5qBI6UYe5zetX0JUYbruyELXEOs2l4=;
        b=IGQoVKuOUq1IEqI9oG01dzKtW417sLv4U/eWECVijWzwFQk81XoMaRB7PmNhCJNa+i
         pbEfTivGKTkV5wdPmHVpwtWy2+QoI6atb2pYnRq9lSm+nGIs0Spyu1l8SLxZys2NtDp7
         bhHrxha3/21jLPSSAnvAdmqeMJcrJbwJO88fMAFSBjckWB1wJiK7TdSy8XmfZL6lLTar
         C0pGX4lVpyK9qZZ5O4HByljL0SKxh4+Vt3HAaas2jQzHm3tQUVQLTeAu87S2qhVnRCCn
         XXTZRA+41mHm4offkntC9pOO9OVdlA9Ob9CS5zlwxjuVmBoXdq7rYru0Gy6/47yAwoRu
         BkQQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0IlgHuoCOCXp9mSHvxVa6O6DiUf6542j6FSkdvh0qK3W+nz+p4JVDlnlCPy3YwAxB7tOdpwNJW28gXKk=@vger.kernel.org, AJvYcCUgtTt4reecQnOsCFZUTXYBNT2yxjkuXx79sTc85w5pDF39pI8n6elfR0MysJO+3mEoMqhvSrNHTwCvvTKswpk=@vger.kernel.org, AJvYcCWLb4mkY3kp9UwV2ihnj7YPY0SXxygRyL8k73CzP7OiYN0oRTfP+zLX76BRdTvDtH1utQIzTN9E7U1flxXC@vger.kernel.org, AJvYcCWtpmRNA1cpQdwTWfRb1iC8gid2UwjLdihWyjsY6+3DNjVeKSYoklZ5FPAQR7MYNcNR7BTECj4GEOKq@vger.kernel.org, AJvYcCXKszG+9jv4kEgsBRSaE0XrRNu9tOKi0yROFzsj5RsTkUujTyPg7FRCGKMexxeuMoGelpJYTwXJV2PPvEl5X0WoRw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxrXa7NB+ZkgWcolREEkZ6u1LDXRQLaNHeS/uzyIN2D+7q5Bovk
	VLrdOQ0lj08odOXS+MykLDB7Bh193A0n8qw1RLUu84NRY+WZN6hF
X-Google-Smtp-Source: AGHT+IGmB89UrsezcJFZU2nJR9oDRLe6wYCSOkA1vdtsM80cdAb4yFIlb3IMQvYcc+0FOIBAkWPSGw==
X-Received: by 2002:a17:90b:4b0c:b0:2e2:c681:51ce with SMTP id 98e67ed59e1d1-2e5616c6659mr9349283a91.1.1729396976634;
        Sat, 19 Oct 2024 21:02:56 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad3678d3sm633668a91.24.2024.10.19.21.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2024 21:02:56 -0700 (PDT)
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
Subject: [PATCH v2 07/10] bcache: Update min_heap_callbacks to use default builtin swap
Date: Sun, 20 Oct 2024 12:01:57 +0800
Message-Id: <20241020040200.939973-8-visitorckw@gmail.com>
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

Replace the swp function pointer in the min_heap_callbacks of bcache
with NULL, allowing direct usage of the default builtin swap
implementation. This modification simplifies the code and improves
performance by removing unnecessary function indirection.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 drivers/md/bcache/alloc.c    | 11 ++---------
 drivers/md/bcache/bset.c     | 14 +++-----------
 drivers/md/bcache/extents.c  | 10 +---------
 drivers/md/bcache/movinggc.c | 10 +---------
 4 files changed, 7 insertions(+), 38 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index da50f6661bae..8998e61efa40 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -189,23 +189,16 @@ static inline bool new_bucket_min_cmp(const void *l, const void *r, void *args)
 	return new_bucket_prio(ca, *lhs) < new_bucket_prio(ca, *rhs);
 }
 
-static inline void new_bucket_swap(void *l, void *r, void __always_unused *args)
-{
-	struct bucket **lhs = l, **rhs = r;
-
-	swap(*lhs, *rhs);
-}
-
 static void invalidate_buckets_lru(struct cache *ca)
 {
 	struct bucket *b;
 	const struct min_heap_callbacks bucket_max_cmp_callback = {
 		.less = new_bucket_max_cmp,
-		.swp = new_bucket_swap,
+		.swp = NULL,
 	};
 	const struct min_heap_callbacks bucket_min_cmp_callback = {
 		.less = new_bucket_min_cmp,
-		.swp = new_bucket_swap,
+		.swp = NULL,
 	};
 
 	ca->heap.nr = 0;
diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index bd97d8626887..68258a16e125 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -1093,14 +1093,6 @@ static inline bool new_btree_iter_cmp(const void *l, const void *r, void __alway
 	return bkey_cmp(_l->k, _r->k) <= 0;
 }
 
-static inline void new_btree_iter_swap(void *iter1, void *iter2, void __always_unused *args)
-{
-	struct btree_iter_set *_iter1 = iter1;
-	struct btree_iter_set *_iter2 = iter2;
-
-	swap(*_iter1, *_iter2);
-}
-
 static inline bool btree_iter_end(struct btree_iter *iter)
 {
 	return !iter->heap.nr;
@@ -1111,7 +1103,7 @@ void bch_btree_iter_push(struct btree_iter *iter, struct bkey *k,
 {
 	const struct min_heap_callbacks callbacks = {
 		.less = new_btree_iter_cmp,
-		.swp = new_btree_iter_swap,
+		.swp = NULL,
 	};
 
 	if (k != end)
@@ -1157,7 +1149,7 @@ static inline struct bkey *__bch_btree_iter_next(struct btree_iter *iter,
 	struct bkey *ret = NULL;
 	const struct min_heap_callbacks callbacks = {
 		.less = cmp,
-		.swp = new_btree_iter_swap,
+		.swp = NULL,
 	};
 
 	if (!btree_iter_end(iter)) {
@@ -1231,7 +1223,7 @@ static void btree_mergesort(struct btree_keys *b, struct bset *out,
 		: bch_ptr_invalid;
 	const struct min_heap_callbacks callbacks = {
 		.less = b->ops->sort_cmp,
-		.swp = new_btree_iter_swap,
+		.swp = NULL,
 	};
 
 	/* Heapify the iterator, using our comparison function */
diff --git a/drivers/md/bcache/extents.c b/drivers/md/bcache/extents.c
index a7221e5dbe81..4b84fda1530a 100644
--- a/drivers/md/bcache/extents.c
+++ b/drivers/md/bcache/extents.c
@@ -266,20 +266,12 @@ static bool new_bch_extent_sort_cmp(const void *l, const void *r, void __always_
 	return !(c ? c > 0 : _l->k < _r->k);
 }
 
-static inline void new_btree_iter_swap(void *iter1, void *iter2, void __always_unused *args)
-{
-	struct btree_iter_set *_iter1 = iter1;
-	struct btree_iter_set *_iter2 = iter2;
-
-	swap(*_iter1, *_iter2);
-}
-
 static struct bkey *bch_extent_sort_fixup(struct btree_iter *iter,
 					  struct bkey *tmp)
 {
 	const struct min_heap_callbacks callbacks = {
 		.less = new_bch_extent_sort_cmp,
-		.swp = new_btree_iter_swap,
+		.swp = NULL,
 	};
 	while (iter->heap.nr > 1) {
 		struct btree_iter_set *top = iter->heap.data, *i = top + 1;
diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index 7f482729c56d..ef6abf33f926 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -190,14 +190,6 @@ static bool new_bucket_cmp(const void *l, const void *r, void __always_unused *a
 	return GC_SECTORS_USED(*_l) >= GC_SECTORS_USED(*_r);
 }
 
-static void new_bucket_swap(void *l, void *r, void __always_unused *args)
-{
-	struct bucket **_l = l;
-	struct bucket **_r = r;
-
-	swap(*_l, *_r);
-}
-
 static unsigned int bucket_heap_top(struct cache *ca)
 {
 	struct bucket *b;
@@ -212,7 +204,7 @@ void bch_moving_gc(struct cache_set *c)
 	unsigned long sectors_to_move, reserve_sectors;
 	const struct min_heap_callbacks callbacks = {
 		.less = new_bucket_cmp,
-		.swp = new_bucket_swap,
+		.swp = NULL,
 	};
 
 	if (!c->copy_gc_enabled)
-- 
2.34.1


