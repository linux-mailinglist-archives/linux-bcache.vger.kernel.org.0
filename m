Return-Path: <linux-bcache+bounces-1124-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D1D9AD4537
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Jun 2025 23:57:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4C6E17D151
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Jun 2025 21:57:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FE9628B7ED;
	Tue, 10 Jun 2025 21:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GtwohTrZ"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695962874EA;
	Tue, 10 Jun 2025 21:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749592567; cv=none; b=r6nNy0PzlJ0x8PURTbHblr4qBJ1VtVCiK1rKW8HNQLrsh+gH9cqVTfxZn8sMPh+bsW0cMy+T/dw9Wv/4ibmIJWQa4y2Llaj9rSpGqzm9tydx4M6vy5ENN56KR8fXAYuCuD0CuTodEXcZ5sLbuSVFdNFZAizF/AStsAKWcCaKDN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749592567; c=relaxed/simple;
	bh=BcO/N3oLniwVCzGot81EJud0xDOAiwYCU0xsTlvrqoI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Roev8hdIxnhG8Eoj0YAU0ZxLWlO4iT9CT+hv6cHjsczwmDcRtNEELjdWvElpy8MYlz2M5CtyrwDOtzFQQ/c4/oX4U3C1mYqkkwUC6K8v7kJfvJ9/qKALuM+zLDa2RQa/9DXj1ZV8vEKWSJO6IPhkz3LscMFfqtIi2UnAzVjAY6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GtwohTrZ; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7390d21bb1cso4910010b3a.2;
        Tue, 10 Jun 2025 14:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749592566; x=1750197366; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mh8dL2G7ps6auhPCbV2SxnoFMaxmQBWO6t4lRq5+ZGg=;
        b=GtwohTrZJEWHeNo8T4XyRbfdMjetNE+2tvnQIHG3Bn6WxGBKIL8+efmZM6R1jeIK5o
         oHOfp+gd0xMVbJsolR71hAizt8JyhL6NC4Kwq4oKVl2L/EMd7SKV3y9xvhJiHIvPHqUa
         HAGOegSq8BPFuuQy9rpyzSFdzkeKV/42Ho+a2RgVff2yr31Yk1Rs1KYu99fLrIij0wUX
         UNqoshrRGVXQ07YtL6SbIArDCe6Fp4ft4BMWbbMRvAkN2mZMvIQFX4H31UK1UAwpg+Vs
         M/Z2u8YdbZqhIfmYc4zYtuncD7cREb+ChCOhwaGhHqFc+AIKAHTkkl7rsbPVsQrNFFOu
         L07A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749592566; x=1750197366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mh8dL2G7ps6auhPCbV2SxnoFMaxmQBWO6t4lRq5+ZGg=;
        b=DVyYe8vxro0zaGQZazQBX1bf48YaqSjQZCJtm0y4Uzw2o4QdLES9vCCyXcYyPMsAFT
         msRPHc1dcyHuDYOjNAdmqPtfPhGsOBAiY8cKC4574nsAY+KrDCpdRsI13+NDaes0XZAS
         T0tRIv2FuayORe1CxHBacKhPWlaE6x3GsqFMqyMp3KDoAzFb4CcX5Kzi+XbYIs+3gPxE
         F7kVMVb/AEvO5UMinEEPEQl2i18ZZ5DME16hc+oniYNrhiEOtMSjt5+lt1/DYtxoSEmZ
         MqV2P4fcYpL5eMhprBAmubq4QGkp/1xHS96m+X2o2qE9haQAOIMcnSCGhoNFVI9TI+II
         72nA==
X-Forwarded-Encrypted: i=1; AJvYcCVB36YQy0O/KpdPVLX/jOPTcIJ0SsBvtgnAXg92GIw/VUxC9CYEAAN4Hw8R9C5VhPlV9x4TI2W3@vger.kernel.org, AJvYcCVEHeQM41tN+ynmdPypglkL+Jgu+rY2LC//Dk9OzirpdiSuYCVU5XUHv/VlCeayE/kQ0LLdcnVoQe0X@vger.kernel.org, AJvYcCVL2CZ44aOeFgHSPXB8GKuWu2gmHoVWXJnwQ/rW0WxAW6Rwhh060RSpa0XXbnHgIUR8ZQDc6dGg6v9jntw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyhdsdo+aKKTxPZoO85lreUpBFsoyzb3RAHvHUiL3WggNCKvOXN
	KKBoxFTN01BK1DXNjE8sojy9zq1YeYtbNgkrW7PSoj/i0LmksgUu54VX
X-Gm-Gg: ASbGncvHtktUnI5YZD4BibN4psP175zRKY8kBnxLZJTjJsK+uKKX8Krv7r8ikj03mXW
	kzR3xo8PkRufNFQLfUjAxvsa1KT1VgATn7TCGmfqTf9GhnstoXTajyDNMZ6e+4pcjuwZppBUetJ
	jYrRCQTDM9QbTOL+j+DImlWZ/XzJuw5bppYeSDl0Al8Jr3Cu5PqEfVwPTx0uwzKOjnt2KPo3bBc
	Gf88FvdQJhPwNf1A/PQHYiy935pqIrIkirrUL5skQO8ZKD68VqZR6MOiq06GN5MWHCrJXmp46HY
	BVYqWt/j8MXNzblMeaZ2V3H+GJCT3Jj7HG0sLVQpNtVSP0pw/Kl08C6B8qZA0Hmx7BjTbqGnURW
	dmFMIy59akN5LHVeNzMhJIwASJzs=
X-Google-Smtp-Source: AGHT+IF50qUKlnQbr9poW8unnzpE8c0mhNlT5avVy2a6dY7Fsb+ssIhW5QF+vzmXtbCwaGQl4JUDKw==
X-Received: by 2002:a05:6a00:17a4:b0:736:b101:aed3 with SMTP id d2e1a72fcca58-7486cb44948mr1406040b3a.1.1749592565674;
        Tue, 10 Jun 2025 14:56:05 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482af3a165sm8173936b3a.11.2025.06.10.14.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 14:56:05 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: corbet@lwn.net,
	colyli@kernel.org,
	kent.overstreet@linux.dev,
	akpm@linux-foundation.org,
	robertpang@google.com
Cc: linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	jserv@ccns.ncku.edu.tw,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 8/8] bcache: Fix the tail IO latency regression by using equality-aware min heap API
Date: Wed, 11 Jun 2025 05:55:16 +0800
Message-Id: <20250610215516.1513296-9-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250610215516.1513296-1-visitorckw@gmail.com>
References: <20250610215516.1513296-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 866898efbb25 ("bcache: remove heap-related macros and switch to
generic min_heap") replaced the original top-down heap macros in bcache
with the generic min heap library, which uses a bottom-up heapify
strategy. However, in scenarios like invalidate_buckets_lru() -
especially before the cache is fully populated - many buckets remain
unfilled. This causes new_bucket_prio() to frequently return zero,
leading to a high rate of equal comparisons.

Bottom-up sift_down performs up to 2 * log2(n) comparisons in such
cases, resulting in a performance regression.

Switch to the _eqaware variants of the min heap API to restore the
original top-down sift_down behavior, which requires only O(1)
comparisons when many elements are equal.

Also use the inline versions of the heap functions to avoid performance
degradation introduced by commit 92a8b224b833 ("lib/min_heap: introduce
non-inline versions of min heap API functions"), as
invalidate_buckets_lru() is on a performance-critical hot path.

Fixes: 866898efbb25 ("bcache: remove heap-related macros and switch to generic min_heap")
Fixes: 92a8b224b833 ("lib/min_heap: introduce non-inline versions of min heap API functions")
Reported-by: Robert Pang <robertpang@google.com>
Closes: https://lore.kernel.org/linux-bcache/CAJhEC06F_AtrPgw2-7CvCqZgeStgCtitbD-ryuPpXQA-JG5XXw@mail.gmail.com
Cc: stable@vger.kernel.org # 6.11+
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 drivers/md/bcache/alloc.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 8998e61efa40..625c5c4eb962 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -207,15 +207,16 @@ static void invalidate_buckets_lru(struct cache *ca)
 		if (!bch_can_invalidate_bucket(ca, b))
 			continue;
 
-		if (!min_heap_full(&ca->heap))
-			min_heap_push(&ca->heap, &b, &bucket_max_cmp_callback, ca);
-		else if (!new_bucket_max_cmp(&b, min_heap_peek(&ca->heap), ca)) {
+		if (!min_heap_full_inline(&ca->heap))
+			min_heap_push_inline(&ca->heap, &b, &bucket_max_cmp_callback, ca);
+		else if (!new_bucket_max_cmp(&b, min_heap_peek_inline(&ca->heap), ca)) {
 			ca->heap.data[0] = b;
-			min_heap_sift_down(&ca->heap, 0, &bucket_max_cmp_callback, ca);
+			min_heap_sift_down_eqaware_inline(&ca->heap, 0, &bucket_max_cmp_callback,
+							  ca);
 		}
 	}
 
-	min_heapify_all(&ca->heap, &bucket_min_cmp_callback, ca);
+	min_heapify_all_eqaware_inline(&ca->heap, &bucket_min_cmp_callback, ca);
 
 	while (!fifo_full(&ca->free_inc)) {
 		if (!ca->heap.nr) {
@@ -227,8 +228,8 @@ static void invalidate_buckets_lru(struct cache *ca)
 			wake_up_gc(ca->set);
 			return;
 		}
-		b = min_heap_peek(&ca->heap)[0];
-		min_heap_pop(&ca->heap, &bucket_min_cmp_callback, ca);
+		b = min_heap_peek_inline(&ca->heap)[0];
+		min_heap_pop_eqaware_inline(&ca->heap, &bucket_min_cmp_callback, ca);
 
 		bch_invalidate_one_bucket(ca, b);
 	}
-- 
2.34.1


