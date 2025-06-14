Return-Path: <linux-bcache+bounces-1136-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E900AD9FAF
	for <lists+linux-bcache@lfdr.de>; Sat, 14 Jun 2025 22:24:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 966233B7FC0
	for <lists+linux-bcache@lfdr.de>; Sat, 14 Jun 2025 20:24:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60D7117A30A;
	Sat, 14 Jun 2025 20:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kNPvHjlD"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E9F2E7F32;
	Sat, 14 Jun 2025 20:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749932669; cv=none; b=MuWbo93Lo/5QWqXCm5fzShRQi1K8po0ZnOmfW7U1LcXCgaqwDhwA2SPXfNFk+/L5A1jyKFPiem8/AUTh6bkU0LnI6CJmYd+Km5VqU83ReM9IU74Ts80WNYsr4R/6342qu/eK4UiC/aJncR6Hh2ktGCa/k/LFlw9CuaJvLOXlGhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749932669; c=relaxed/simple;
	bh=FF7UNhexBfgyailB1LL46EeXTPxhK/Q0SjOBKHX9JMo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F+fl3iUt1oS23NbW/jjBSCiruPJlkrq4eZsbOrFw3ijR8DwvFMaFgRYPoxTogfW1JV4kka794bPQuQYSrQoggCbD+SSUTPjzZCDPYZBWvQeKp3sj66Xjy1T1N0p3b5/2POTxj66Cd4PNyFF4xcEAm9HFQYrhKGB0/H7x9Z8JeCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kNPvHjlD; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7489dfb71a8so745335b3a.1;
        Sat, 14 Jun 2025 13:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749932667; x=1750537467; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DPUx8acHfFHm+lWLzhnb5FfTKvzuEm/rpMZ61FlXfd0=;
        b=kNPvHjlDIW3h+YD4mrq8DeqdSaSSYNjPJjTTe2fh2U1LfCA4GUAM8ykENs4P5q0aG+
         2fm6cEN1PWkSaxrLgF9tl7xIWdg6xfr6rh4RniRlVZ9oevzks/TQ5CvUWJBnl0/nIr+0
         wr3FCQAushIx2C4q1bEBgOJur3jY50U6EOI+SwCN+41bMqSdoR3ahbuPmvU/kh/gDZoQ
         nZWgMpH2/RXOBYfaySLKQd/6Fz1k8989S/JWGrRV2ul8m4BiQFjW19NydqtVYJZC45OG
         2kQXYERjvqNDi6AocOQscCz21ySnMWzU4x1KYIaWYl8Qgh9rMU9nffhequL0z2/ne1st
         ruxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749932667; x=1750537467;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DPUx8acHfFHm+lWLzhnb5FfTKvzuEm/rpMZ61FlXfd0=;
        b=bnmiu8TA+lRVjX46NQ+YEFV3RS15fGH8+z15R0VWmq4JV20mXA9A8wqABmY4SC8s+M
         pqUXU/X6gBUY0kkZ3kHSB+xjwAUBtoWFBjo+Dk0Yl474ofGDcXOBwzoJzAJp0D9Jd+kx
         zsV2m4QP7y8DvdMBK4xlYs2TdN3sIjrhvkkr5zRBsUX04UYQyiAio0wxpDs/lJt5MR06
         SLypEuRJ0NDWQf0DeEt1VqKIFcQ14MdR1M6nKLAJbIHjkMvqaLRIb7eA+tMK9xqeaX17
         45AVSRp23F4iWCG7BYZEUDl4NPW6xvtMDe6nxeyrUeGpZiV2UzHuZxEa9TdhnjgF02cP
         JPPg==
X-Forwarded-Encrypted: i=1; AJvYcCX0o0fFVCTwYe4Oq9pwoLdi/YF01cwOi48oKrNix+AN2VTymWAj38vPjEL/l9dNBZUTbdERXNA1@vger.kernel.org, AJvYcCXM2gAtJLmngJ1l/VzfOkhPHXPeEd8n4yyo2ksFj10GnMvhqprRHyAxgF55J0XNLMWDhSCXn74YEMLCIeM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6ScqGcPmNqBkbauceh/kMOKNwkLcMOR0hauZWp2efP97Tv5RI
	Mmbt7EfMCmssnHB4lq872lkcM+GeXF0oCEAsVMEKk9Jdxdw8N9MXbNyN
X-Gm-Gg: ASbGncuy6xplSFRsdVRB3xN7tGL/soTybFqrUCXNpYDSTUZJDtP2Eyt9M5weJCXvsaG
	uIpmc9MKVxNNN4dGn2jFHkfrrFEokvopakHBKXbemOEdiHV0UMTrFtHwLZVY5ZxfiMc5czUYpFc
	Uw4yWN6kaRl9naQvIZSZcrjwGuhszQzDwo4Hue1JKhNuvg3R1DvLyqnLM/E1NqvlrAWKyudn8Wv
	mTLOZhCaX3I4t/OEGqJCel8g3ipJhtb5zHr/F2gSR0S/eCldzjVTb4eprnwYXE4JLbZtJKaN/3B
	2GjS+qTyfpEEFnuus/MFwslYnQnAcfZAb9tF8B0LPJHzwOaoKq1z/U+qr2nT6ThQBm3AGCRbqBz
	8T74nz3WvSGN1mJxCLa98wpBk7H4=
X-Google-Smtp-Source: AGHT+IEUHsbrfOzRtJglTfXRv1dpILfhMUwCxuSEBswBFdDJupTBkHF2+V+10vsD7S3I7QtPnCxt/g==
X-Received: by 2002:a05:6a00:13a9:b0:740:9c57:3907 with SMTP id d2e1a72fcca58-7489d175260mr5215603b3a.19.1749932666778;
        Sat, 14 Jun 2025 13:24:26 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900d738esm3863351b3a.177.2025.06.14.13.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jun 2025 13:24:26 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: akpm@linux-foundation.org,
	colyli@kernel.org,
	kent.overstreet@linux.dev,
	robertpang@google.com
Cc: linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	jserv@ccns.ncku.edu.tw,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/3] Revert "bcache: update min_heap_callbacks to use default builtin swap"
Date: Sun, 15 Jun 2025 04:23:51 +0800
Message-Id: <20250614202353.1632957-2-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250614202353.1632957-1-visitorckw@gmail.com>
References: <20250614202353.1632957-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 3d8a9a1c35227c3f1b0bd132c9f0a80dbda07b65.

Although removing the custom swap function simplified the code, this
change is part of a broader migration to the generic min_heap API that
introduced significant performance regressions in bcache.

As reported by Robert, bcache now suffers from latency spikes, with
P100 (max) latency increasing from 600 ms to 2.4 seconds every 5
minutes. These regressions degrade bcache's effectiveness as a
low-latency cache layer and lead to frequent timeouts and application
stalls in production environments.

This revert is part of a series of changes to restore previous
performance by undoing the min_heap transition.

Link: https://lore.kernel.org/lkml/CAJhEC05+0S69z+3+FB2Cd0hD+pCRyWTKLEOsc8BOmH73p1m+KQ@mail.gmail.com
Fixes: 866898efbb25 ("bcache: remove heap-related macros and switch to generic min_heap")
Fixes: 92a8b224b833 ("lib/min_heap: introduce non-inline versions of min heap API functions")
Reported-by: Robert Pang <robertpang@google.com>
Closes: https://lore.kernel.org/linux-bcache/CAJhEC06F_AtrPgw2-7CvCqZgeStgCtitbD-ryuPpXQA-JG5XXw@mail.gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 drivers/md/bcache/alloc.c    | 11 +++++++++--
 drivers/md/bcache/bset.c     | 14 +++++++++++---
 drivers/md/bcache/extents.c  | 10 +++++++++-
 drivers/md/bcache/movinggc.c | 10 +++++++++-
 4 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 8998e61efa40..da50f6661bae 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -189,16 +189,23 @@ static inline bool new_bucket_min_cmp(const void *l, const void *r, void *args)
 	return new_bucket_prio(ca, *lhs) < new_bucket_prio(ca, *rhs);
 }
 
+static inline void new_bucket_swap(void *l, void *r, void __always_unused *args)
+{
+	struct bucket **lhs = l, **rhs = r;
+
+	swap(*lhs, *rhs);
+}
+
 static void invalidate_buckets_lru(struct cache *ca)
 {
 	struct bucket *b;
 	const struct min_heap_callbacks bucket_max_cmp_callback = {
 		.less = new_bucket_max_cmp,
-		.swp = NULL,
+		.swp = new_bucket_swap,
 	};
 	const struct min_heap_callbacks bucket_min_cmp_callback = {
 		.less = new_bucket_min_cmp,
-		.swp = NULL,
+		.swp = new_bucket_swap,
 	};
 
 	ca->heap.nr = 0;
diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index 68258a16e125..bd97d8626887 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -1093,6 +1093,14 @@ static inline bool new_btree_iter_cmp(const void *l, const void *r, void __alway
 	return bkey_cmp(_l->k, _r->k) <= 0;
 }
 
+static inline void new_btree_iter_swap(void *iter1, void *iter2, void __always_unused *args)
+{
+	struct btree_iter_set *_iter1 = iter1;
+	struct btree_iter_set *_iter2 = iter2;
+
+	swap(*_iter1, *_iter2);
+}
+
 static inline bool btree_iter_end(struct btree_iter *iter)
 {
 	return !iter->heap.nr;
@@ -1103,7 +1111,7 @@ void bch_btree_iter_push(struct btree_iter *iter, struct bkey *k,
 {
 	const struct min_heap_callbacks callbacks = {
 		.less = new_btree_iter_cmp,
-		.swp = NULL,
+		.swp = new_btree_iter_swap,
 	};
 
 	if (k != end)
@@ -1149,7 +1157,7 @@ static inline struct bkey *__bch_btree_iter_next(struct btree_iter *iter,
 	struct bkey *ret = NULL;
 	const struct min_heap_callbacks callbacks = {
 		.less = cmp,
-		.swp = NULL,
+		.swp = new_btree_iter_swap,
 	};
 
 	if (!btree_iter_end(iter)) {
@@ -1223,7 +1231,7 @@ static void btree_mergesort(struct btree_keys *b, struct bset *out,
 		: bch_ptr_invalid;
 	const struct min_heap_callbacks callbacks = {
 		.less = b->ops->sort_cmp,
-		.swp = NULL,
+		.swp = new_btree_iter_swap,
 	};
 
 	/* Heapify the iterator, using our comparison function */
diff --git a/drivers/md/bcache/extents.c b/drivers/md/bcache/extents.c
index 4b84fda1530a..a7221e5dbe81 100644
--- a/drivers/md/bcache/extents.c
+++ b/drivers/md/bcache/extents.c
@@ -266,12 +266,20 @@ static bool new_bch_extent_sort_cmp(const void *l, const void *r, void __always_
 	return !(c ? c > 0 : _l->k < _r->k);
 }
 
+static inline void new_btree_iter_swap(void *iter1, void *iter2, void __always_unused *args)
+{
+	struct btree_iter_set *_iter1 = iter1;
+	struct btree_iter_set *_iter2 = iter2;
+
+	swap(*_iter1, *_iter2);
+}
+
 static struct bkey *bch_extent_sort_fixup(struct btree_iter *iter,
 					  struct bkey *tmp)
 {
 	const struct min_heap_callbacks callbacks = {
 		.less = new_bch_extent_sort_cmp,
-		.swp = NULL,
+		.swp = new_btree_iter_swap,
 	};
 	while (iter->heap.nr > 1) {
 		struct btree_iter_set *top = iter->heap.data, *i = top + 1;
diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index 45ca134cbf02..d6c73dd8eb2b 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -190,6 +190,14 @@ static bool new_bucket_cmp(const void *l, const void *r, void __always_unused *a
 	return GC_SECTORS_USED(*_l) >= GC_SECTORS_USED(*_r);
 }
 
+static void new_bucket_swap(void *l, void *r, void __always_unused *args)
+{
+	struct bucket **_l = l;
+	struct bucket **_r = r;
+
+	swap(*_l, *_r);
+}
+
 static unsigned int bucket_heap_top(struct cache *ca)
 {
 	struct bucket *b;
@@ -204,7 +212,7 @@ void bch_moving_gc(struct cache_set *c)
 	unsigned long sectors_to_move, reserve_sectors;
 	const struct min_heap_callbacks callbacks = {
 		.less = new_bucket_cmp,
-		.swp = NULL,
+		.swp = new_bucket_swap,
 	};
 
 	if (!c->copy_gc_enabled)
-- 
2.34.1


