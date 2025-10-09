Return-Path: <linux-bcache+bounces-1215-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DBA2FBC7A68
	for <lists+linux-bcache@lfdr.de>; Thu, 09 Oct 2025 09:17:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AC9F84E1527
	for <lists+linux-bcache@lfdr.de>; Thu,  9 Oct 2025 07:17:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EA992459D7;
	Thu,  9 Oct 2025 07:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Txsynlg+"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A29D222586
	for <linux-bcache@vger.kernel.org>; Thu,  9 Oct 2025 07:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759994233; cv=none; b=OrnCTJ910zcbW2TbBp1puM/OAXSwTCVJSX4LWvsqESszQUlrDHGhSBCjdhlGN4bR3IedJdHqEe8zCYxxCPqybCSIHsRTIg0ezWkrUNuSKCdLM6/wxgwaJrwA9uvYAitZTBkBIevEcSkExcLmt0AFYRQKS4fkMCq8a84XN1dyEyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759994233; c=relaxed/simple;
	bh=pyoY7Vdb/vrxexDLvTLQr++x6nZEjYln58xGU51a3xo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=mGoIIYRctuwHSgFV3QDReuuAteZ756p9pifw5YiRCqrwo/DY8nw1YqQSBhnhEpEbBhE2jkVb57nMkHTd4zdU6x9aqP2eRknvaPMCANfKu85XY06xjNsCjjeKhgad91pvYREYXv8doOIhUsRJjpnPB4NXPKgp61Dj9QzhzpE6tYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Txsynlg+; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2697410e7f9so24744525ad.2
        for <linux-bcache@vger.kernel.org>; Thu, 09 Oct 2025 00:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759994231; x=1760599031; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=an5olBL0QCgABLe+u/QkmrVEliUFVAllfnPaZoexj58=;
        b=Txsynlg+GTfmxQNtJnrE6eFbCN9Dd7wlGfXI7H1qpeSJEzsqQ0CAswFLNgXreCnB4/
         SJsoeQVxgoQ6XhjGvhC95dZLObdrpjokl77I1BHVMRAn2OyV8FNi7UxCfQ63mDLm0uzt
         Ty9L6lCKeUUE4TpO13arEmovYTmhCvA9C3aq1jMDXUKwuBeN7p97yuZwemytn2pIKOI6
         d0DelUqBpHfkFbnaCvKz74xGCuFfPWySQcZz3tEnkCwuSNxeNRlk0H8P5dwNbK4QyXKb
         6A3d19ZVYrAdsl+roMsv6MKnF3pDRt0hV8+Z+pyQ3cZ1Bj86tiR4trJItq4j1WGIbwXr
         4r1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759994231; x=1760599031;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=an5olBL0QCgABLe+u/QkmrVEliUFVAllfnPaZoexj58=;
        b=TshAm4HIx2mZyPeFCEKQvH1kZIvG9477soXIWFxW59V2qTHnfaY8GDC6vgVGo8rq2j
         9zEALG5Xb7pHO5re+mPnVhzf2x4QUgNUXTOeudTgDk5WNs9sJmvIkfUBjdzcSkS4sQBY
         9VSojvIu8Yrf0fQGza8pAQpK1S0tgtEqWeI5OXel1fvyDI0VaIeHzpGVfFy6kZ3n8TUs
         RaH424llDLgKj7EeKl5z65/sbDeKfFAdJXDjDcLY0+NTCUU8svtZ1lCDf4tCCGNo5IAp
         QeJWTluGz56syMskEp/pKC5bzXDM3o8zn6Rvx3jRkTt2ToWA6DzBU3HUt3x7xP6+QV02
         3Qjg==
X-Gm-Message-State: AOJu0YwcBBwruor6FJmYB0WhmZAdtoP0NXZhbEcnX13BsT/q7o1RWnVX
	oIncOI0tRj6CzJCnFY55IICK3/T41TYTfApLZE2zgXRkOQMWpd9rUFxmURDuI4qeWAOMdEB5mAm
	jZQC6FaDd9QbBGiicikXkqg==
X-Google-Smtp-Source: AGHT+IFb5kfHyM2soXec2fgkjexLNWkRXOtWPknbYmahZAmxEpU45pp0Y+kfn1jlX78K8pz3g5ZpNyDN46ZqMxY9
X-Received: from plsk2.prod.google.com ([2002:a17:902:ba82:b0:268:1af:fcff])
 (user=robertpang job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:3885:b0:256:9c51:d752 with SMTP id d9443c01a7336-290273069bbmr84639355ad.56.1759994230783;
 Thu, 09 Oct 2025 00:17:10 -0700 (PDT)
Date: Thu,  9 Oct 2025 00:15:13 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251009071512.3952240-2-robertpang@google.com>
Subject: [PATCH v2] bcache: add "clock" cache replacement policy
From: Robert Pang <robertpang@google.com>
To: Coly Li <colyli@fnnas.com>, Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Robert Pang <robertpang@google.com>
Content-Type: text/plain; charset="UTF-8"

This new policy extends the FIFO policy to approximate the classic clock policy
(O(n) time complexity) by considering bucket priority, similar to the LRU
policy.

This clock policy addresses the high IO latency (1-2 seconds) experienced on
multi-terabyte cache devices when the free list is empty due to the default LRU
policy. The LRU policy's O(n log n) complexity for sorting priorities for the
entire bucket list causes this delay.

Here are the average execution times (in microseconds) of the LRU and the clock
replacement policies:

SSD Size  Bucket Count  LRU (us)  Clock (us)
375 GB      1536000       58292        1163
750 GB      3072000      121769        1729
1.5 TB      6144000      244012        3862
3 TB       12288000      496569        6428
6 TB       24576000     1067628       14298
9 TB       36864000     1564348       25763

Signed-off-by: Robert Pang <robertpang@google.com>
---
 Documentation/admin-guide/bcache.rst |  2 +-
 drivers/md/bcache/alloc.c            | 34 ++++++++++++++++++++++++----
 drivers/md/bcache/bcache_ondisk.h    |  1 +
 drivers/md/bcache/sysfs.c            |  1 +
 4 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/bcache.rst b/Documentation/admin-guide/bcache.rst
index 6fdb495ac466..2be2999c7de4 100644
--- a/Documentation/admin-guide/bcache.rst
+++ b/Documentation/admin-guide/bcache.rst
@@ -616,7 +616,7 @@ bucket_size
   Size of buckets
 
 cache_replacement_policy
-  One of either lru, fifo or random.
+  One of either lru, fifo, random or clock.
 
 discard
   Boolean; if on a discard/TRIM will be issued to each bucket before it is
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


