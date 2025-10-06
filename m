Return-Path: <linux-bcache+bounces-1210-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEB53BBFC2C
	for <lists+linux-bcache@lfdr.de>; Tue, 07 Oct 2025 01:19:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9519F3BEE87
	for <lists+linux-bcache@lfdr.de>; Mon,  6 Oct 2025 23:19:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC42F18C02E;
	Mon,  6 Oct 2025 23:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G4QG5NRj"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A039B661
	for <linux-bcache@vger.kernel.org>; Mon,  6 Oct 2025 23:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759792747; cv=none; b=CWQ5nW1MlDEjYhcJ9hWbgQWqCqxTxx7HWYyFNFwJ6icrdLjwItPqrGGeI63ICOuQYpqFQY4EsyjkMNpYlhDxRQzIFuoadKplcIFxkFnb+zA7EB9MGpDdNZNhrWtc5r7leI1f58qlW57ELT6nDKl//zwYJADQ4wOLHNbFI5hWryA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759792747; c=relaxed/simple;
	bh=vM3gR2lTp4Oe3so2Fi9UTw6e0Q6vUpcZr1VOn05eD4U=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=dxA6GlDR73Vc4CvwHe438V70k4tTJghY1ULINUq0Qs8AsUROSE2dpJjQ+20LjvaTmuvCu+lmpA1QOlMeDB/NCj0gwjz4oNpHc4A6k1OFwPIqnkYFnhuco6Jyq0DtPIljfNhLe6lyHU+3YkOHzcweRkfCa7chjFe/f8z6/obcDvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G4QG5NRj; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-78427dae77eso4558007b3a.3
        for <linux-bcache@vger.kernel.org>; Mon, 06 Oct 2025 16:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759792744; x=1760397544; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4ICaunvcTNzioB2csrgVGJSTIahocAF7LkiUszCDNWo=;
        b=G4QG5NRj0yvfOyJgbjoOF1Cxf5GU/Zt8LADpnnSB6f9u8IYt3xMGVXFLFsgTwsZojo
         fyq7g6JKEGiq6nYEEXh0ioZC+2VXN3tHBRHze+kTUoZDgNpiJx4ds13MloT7z+5FuZUQ
         DkdIAKDqpVoJ14evjF5e+DG0QOv6Isz9OpGfs4uUY21ZlE9Z2Ul6y7kNLlHl7/UNKNGD
         +eJk4v61wsKmYHz8Shoh12PW5MOUyM2mTotkSK4Xb4BAARJDO0GN5Mgxc0MgquFtF9dU
         t/ZTQm91UjXq8jefi6nTjyUWxtJuOLWHGx2CVyyRLL5zwkTpFKljeh9Af0tacDg+tJ1H
         Hwjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759792744; x=1760397544;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4ICaunvcTNzioB2csrgVGJSTIahocAF7LkiUszCDNWo=;
        b=lW8skRGri3hDadG06nFuzNRazJMcZv3nR5ZexNsVyqpiQp0nIvwbL7LUjhG6cOqR9f
         AkdkQp13ihZI03+4dZU0wtp5/X02nRTDvv5nvi7BvWIHZk+NXK6F4AymRTAseWc7Dw1o
         R4vEGbwOJmnzBhIQRoH1spDnoR7+QzRBj3oAXxSg3kdA7H1PdaU7mDiFZLL5Qi7eBF3f
         qYZn3eVRcUgoIaua0+p54Q6gC+ggg672J/w5KV17bY/NtVWrUviIq/tTwVAOqSBN0Xp7
         cVZ2w8tM6Dk3aV57S8V2rkxjL61+Ed0+7R9rUaJKH7+eE6tFVlv3arVUXSPKruwMPtDu
         aDWg==
X-Gm-Message-State: AOJu0YyESX6/UCuV1pywm865O9dNnuE5xccsKsDohQZobv2cboL2Wi/5
	zTrnSiCNoeqsPhL/eF2JhlD0PUz/HrIri9yRtgaoBHd0ph9Zz3B3U93b+Ep6JQnEGArBVY7UB1F
	2xMiEcI5b5xOYWQUVnBkK/g==
X-Google-Smtp-Source: AGHT+IGxVmZG4v8SFhHKuWnMm6Yo6Tgn6NgC8qM5J6B9M55B98D7V3HoQTkoVvUFGa+qqd9ie/S+4z5cQ6AJQ/mN
X-Received: from pgnq10.prod.google.com ([2002:a63:8c4a:0:b0:b55:1545:5a8d])
 (user=robertpang job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:6a09:b0:2f6:14c6:95ea with SMTP id adf61e73a8af0-32b61e78f14mr20281500637.20.1759792744504;
 Mon, 06 Oct 2025 16:19:04 -0700 (PDT)
Date: Mon,  6 Oct 2025 16:18:46 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251006231845.3082485-2-robertpang@google.com>
Subject: [PATCH] bcache: add "clock" cache replacement policy
From: Robert Pang <robertpang@google.com>
To: Coly Li <colyli@fnnas.com>, Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Robert Pang <robertpang@google.com>
Content-Type: text/plain; charset="UTF-8"

This new policy extends the FIFO policy to approximate the classic clock policy
(O(n) time complexity) by considering bucket priority, similar to the LRU
policy.

This policy addresses the high IO latency (1-2 seconds) experienced on
multi-terabyte cache devices when the free list is empty. The default LRU
policy's O(n log n) complexity for sorting priorities for the entire bucket
list causes this delay.

Signed-off-by: Robert Pang <robertpang@google.com>
---
 drivers/md/bcache/alloc.c         | 34 +++++++++++++++++++++++++++----
 drivers/md/bcache/bcache_ondisk.h |  1 +
 drivers/md/bcache/sysfs.c         |  1 +
 3 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 48ce750bf70a..c65c48eab169 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -69,7 +69,8 @@
 #include <linux/random.h>
 #include <trace/events/bcache.h>
 
-#define MAX_OPEN_BUCKETS 128
+#define MAX_OPEN_BUCKETS	128
+#define CHECK_PRIO_SLICES	16
 
 /* Bucket heap / gen */
 
@@ -211,19 +212,41 @@ static void invalidate_buckets_lru(struct cache *ca)
 	}
 }
 
-static void invalidate_buckets_fifo(struct cache *ca)
+/*
+ * When check_prio is true, this FIFO policy examines the priority of the
+ * buckets and invalidates only the ones below a threshold in the priority
+ * ladder. As it goes, the threshold will be raised if not enough buckets are
+ * invalidated. Empty buckets are also invalidated. This evaulation resembles
+ * the LRU policy, and is used to approximate the classic clock-sweep cache
+ * replacement algorithm.
+ */
+static void invalidate_buckets_fifo(struct cache *ca, bool check_prio)
 {
 	struct bucket *b;
 	size_t checked = 0;
+	size_t check_quota = 0;
+	uint16_t prio_threshold = ca->set->min_prio;
 
 	while (!fifo_full(&ca->free_inc)) {
 		if (ca->fifo_last_bucket <  ca->sb.first_bucket ||
 		    ca->fifo_last_bucket >= ca->sb.nbuckets)
 			ca->fifo_last_bucket = ca->sb.first_bucket;
 
+		if (check_prio && checked >= check_quota) {
+			BUG_ON(ca->set->min_prio > INITIAL_PRIO);
+			prio_threshold +=
+				DIV_ROUND_UP(INITIAL_PRIO - ca->set->min_prio,
+					     CHECK_PRIO_SLICES);
+			check_quota += DIV_ROUND_UP(ca->sb.nbuckets,
+						    CHECK_PRIO_SLICES);
+		}
+
 		b = ca->buckets + ca->fifo_last_bucket++;
 
-		if (bch_can_invalidate_bucket(ca, b))
+		if (bch_can_invalidate_bucket(ca, b) &&
+		    (!check_prio ||
+		     b->prio <= prio_threshold ||
+		     !GC_SECTORS_USED(b)))
 			bch_invalidate_one_bucket(ca, b);
 
 		if (++checked >= ca->sb.nbuckets) {
@@ -269,11 +292,14 @@ static void invalidate_buckets(struct cache *ca)
 		invalidate_buckets_lru(ca);
 		break;
 	case CACHE_REPLACEMENT_FIFO:
-		invalidate_buckets_fifo(ca);
+		invalidate_buckets_fifo(ca, false);
 		break;
 	case CACHE_REPLACEMENT_RANDOM:
 		invalidate_buckets_random(ca);
 		break;
+	case CACHE_REPLACEMENT_CLOCK:
+		invalidate_buckets_fifo(ca, true);
+		break;
 	}
 }
 
diff --git a/drivers/md/bcache/bcache_ondisk.h b/drivers/md/bcache/bcache_ondisk.h
index 6620a7f8fffc..d45794e01fe1 100644
--- a/drivers/md/bcache/bcache_ondisk.h
+++ b/drivers/md/bcache/bcache_ondisk.h
@@ -288,6 +288,7 @@ BITMASK(CACHE_REPLACEMENT,		struct cache_sb, flags, 2, 3);
 #define CACHE_REPLACEMENT_LRU		0U
 #define CACHE_REPLACEMENT_FIFO		1U
 #define CACHE_REPLACEMENT_RANDOM	2U
+#define CACHE_REPLACEMENT_CLOCK		3U
 
 BITMASK(BDEV_CACHE_MODE,		struct cache_sb, flags, 0, 4);
 #define CACHE_MODE_WRITETHROUGH		0U
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 826b14cae4e5..c8617bad0648 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -45,6 +45,7 @@ static const char * const cache_replacement_policies[] = {
 	"lru",
 	"fifo",
 	"random",
+	"clock",
 	NULL
 };
 
-- 
2.51.0.710.ga91ca5db03-goog


