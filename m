Return-Path: <linux-bcache+bounces-882-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AC616A8A5E6
	for <lists+linux-bcache@lfdr.de>; Tue, 15 Apr 2025 19:43:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E72821896114
	for <lists+linux-bcache@lfdr.de>; Tue, 15 Apr 2025 17:43:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31CBF21E097;
	Tue, 15 Apr 2025 17:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DKbxNJhp"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C36321D5BF
	for <linux-bcache@vger.kernel.org>; Tue, 15 Apr 2025 17:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744738985; cv=none; b=CBtDgkDr/7f4Skp3pHcCDZh31B7Gso5bFR1x5QnZRXm8izNBB6ghKdVTrl5N4Rs9l+BqTasVEgoHTilNVzeoTdjSmej0Q8kOjmGWwnrtj/oizrFxVi+vzPrlyILSirRYvLFzPPtDMQ+V6fBirNIzFuJ4iBr91jmuL2xo2aS6vRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744738985; c=relaxed/simple;
	bh=F1Fv8oyCntCLpob9zvC06u/9FsLpuuy3zqtyVRyop8A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N6LF37o2Nw9aNFtBXE7K8g0t+6lOn+GE9cEbems7MlC0mZpnTh3PDMVDn9ZajzQrY+iU5DzOWo/2lbRTCA64qfEUaQVg2EwsEwafqORBxTe8kY7ob8Y6QCFInxDrH60OyBwvqo0EGDWv+4PtxMU/qm+O0rdnoBnobb7PbKwEqz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DKbxNJhp; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30566e34290so6261712a91.3
        for <linux-bcache@vger.kernel.org>; Tue, 15 Apr 2025 10:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744738983; x=1745343783; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l1Qi9zPEd5/T7S5hiyXX85XzN8s+0kKiCVZwAPa9EAI=;
        b=DKbxNJhprbNYFKhBARcfOf6ssxya2gPfUu+13HAHSO69spuarDmVQyUJVuaYF1CYY8
         FNdv94GzlTnSq1vzxSGZTAohrdXqprMne1/YY6NvJ6/0oyAorCMCaHSckTbUPPQn0RQe
         RKvNvcjRzanfJcovDkj3kWkICiL9J0GJEWdGWebJNtvEsQCX5HQPdAb5acP3M3FXCvDp
         ybc17LKiyVk5QAtyRebhmKZ80XU7tOS6aAAA2NwqfvZpxvKjxw9GepPYICVfb8On/Ooa
         DCXk3fjhp0cBvwUtjZO58AIokQlvgRPpA1o6CJsHC30EdrUIzvh3OEe4n5UvmyJmBWox
         9Bog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744738983; x=1745343783;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l1Qi9zPEd5/T7S5hiyXX85XzN8s+0kKiCVZwAPa9EAI=;
        b=VkZuRVfm3izDqHkZPBI4R6xCkhQZc9Dug/DJ+rTyaYH5L2ynD9RfYa5yVfGjeZ6SVV
         wWdJPHzy3O74EOVX2JMPn/mzdlTtJtfmQlpquFODdck7J4R51LBlm+RNQjxubGxa2+Yq
         asCerFznImbHrxrW6J1kXeDz1YnnSzEjjJopfaL4yv5ohs1zzeR2aVvtiBEYdyP/AUDH
         wvTpwBm+2H7eTurgTk2hL7EpyPGDVko4IpHmVn6TUTLOMiTj+eHGvXl5r3D85FyMYcCc
         PZW+DF5+JznH6GbeGx7TpHEg8LZMVgzg6KWyU4qbRi0zZ+yiDtoeZsdoxcfGw8/ogdXs
         bfZg==
X-Forwarded-Encrypted: i=1; AJvYcCVPcJYcj5zSHv/hEXOe/RXAOnma+WjCpeeq0kFZI+Pe7LsFkweff+AU/HPfWMbxgv2av0lXSDRR8RuG5NM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmQmHnv72H47QYOMBS69DApz5gVIJJuJOJvaCaD2KHtmdxKmPL
	e6gqrzsdE+8EF76GmgVrKRl9MFJ5xFlnvQxpZo42excaLp/XHHsZ5kO5wQveM6T7lZu1sup4wQQ
	2a0B/dUNjOHsDPIHOFg==
X-Google-Smtp-Source: AGHT+IHI8vO1GKMOmZatJOA32Pq8ZToscgPiyKF/QV5xWnWUof3jBRMe4E8DWmlncBS5i4Fy5utMKpp5bPi5u3/J
X-Received: from pjbsf1.prod.google.com ([2002:a17:90b:51c1:b0:2ef:d283:5089])
 (user=robertpang job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2dca:b0:2fe:8902:9ecd with SMTP id 98e67ed59e1d1-3085eeee7d5mr43231a91.1.1744738982840;
 Tue, 15 Apr 2025 10:43:02 -0700 (PDT)
Date: Tue, 15 Apr 2025 10:39:08 -0700
In-Reply-To: <20250415174145.346121-1-robertpang@google.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250415174145.346121-1-robertpang@google.com>
X-Mailer: git-send-email 2.49.0.805.g082f7c87e0-goog
Message-ID: <20250415174145.346121-2-robertpang@google.com>
Subject: [PATCH v2 1/1] bcache: process fewer btree nodes in incremental GC cycles
From: Robert Pang <robertpang@google.com>
To: Coly Li <colyli@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcache@vger.kernel.org
Cc: Robert Pang <robertpang@google.com>, Mingzhe Zou <mingzhe.zou@easystack.cn>
Content-Type: text/plain; charset="UTF-8"

Current incremental GC processes a minimum of 100 btree nodes per cycle,
followed by a 100ms sleep. For NVMe cache devices, where the average node
processing time is ~1ms, this leads to front-side I/O latency potentially
reaching tens or hundreds of milliseconds during GC execution.

This commit resolves this latency issue by reducing the minimum node processing
count per cycle to 10 and the inter-cycle sleep duration to 10ms. It also
integrates a check of existing GC statistics to re-scale the number of nodes
processed per sleep interval when needed, ensuring GC finishes well before the
next GC is due.

Signed-off-by: Robert Pang <robertpang@google.com>
---
 drivers/md/bcache/btree.c | 36 +++++++++++++++++-------------------
 drivers/md/bcache/util.h  |  7 +++++++
 2 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index ed40d8600656..447c79157d0e 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -90,9 +90,8 @@
 
 #define MAX_NEED_GC		64
 #define MAX_SAVE_PRIO		72
-#define MAX_GC_TIMES		100
-#define MIN_GC_NODES		100
-#define GC_SLEEP_MS		100
+#define GC_MIN_NODES		10
+#define GC_SLEEP_MS		10
 
 #define PTR_DIRTY_BIT		(((uint64_t) 1 << 36))
 
@@ -1585,25 +1584,24 @@ static unsigned int btree_gc_count_keys(struct btree *b)
 
 static size_t btree_gc_min_nodes(struct cache_set *c)
 {
-	size_t min_nodes;
+	size_t min_nodes = GC_MIN_NODES;
+	uint64_t gc_max_ms = time_stat_average(&c->btree_gc_time, frequency, ms) / 2;
 
 	/*
-	 * Since incremental GC would stop 100ms when front
-	 * side I/O comes, so when there are many btree nodes,
-	 * if GC only processes constant (100) nodes each time,
-	 * GC would last a long time, and the front side I/Os
-	 * would run out of the buckets (since no new bucket
-	 * can be allocated during GC), and be blocked again.
-	 * So GC should not process constant nodes, but varied
-	 * nodes according to the number of btree nodes, which
-	 * realized by dividing GC into constant(100) times,
-	 * so when there are many btree nodes, GC can process
-	 * more nodes each time, otherwise, GC will process less
-	 * nodes each time (but no less than MIN_GC_NODES)
+	 * The incremental garbage collector operates by processing
+	 * GC_MIN_NODES at a time, pausing for GC_SLEEP_MS between
+	 * each interval. If historical garbage collection statistics
+	 * (btree_gc_time) is available, the maximum allowable GC
+	 * duration is set to half of this observed frequency. To
+	 * prevent exceeding this maximum duration, the number of
+	 * nodes processed in the current step may be increased if
+	 * the projected completion time based on the current pace
+	 * extends beyond the allowed limit. This ensures timely GC
+	 * completion before the next GC is due.
 	 */
-	min_nodes = c->gc_stats.nodes / MAX_GC_TIMES;
-	if (min_nodes < MIN_GC_NODES)
-		min_nodes = MIN_GC_NODES;
+	if ((gc_max_ms >= GC_SLEEP_MS) &&
+	    (GC_SLEEP_MS * (c->gc_stats.nodes / min_nodes)) > gc_max_ms)
+		min_nodes = c->gc_stats.nodes / (gc_max_ms / GC_SLEEP_MS);
 
 	return min_nodes;
 }
diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index 539454d8e2d0..ba2e6de5ec71 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -305,6 +305,13 @@ static inline unsigned int local_clock_us(void)
 #define NSEC_PER_ms			NSEC_PER_MSEC
 #define NSEC_PER_sec			NSEC_PER_SEC
 
+/*
+ * time_stat_average - return the average duration/frequency stat of a time
+ * stats in the desired unit.
+ */
+#define time_stat_average(stats, stat, units)				\
+	div_u64((stats)->average_ ## stat >> 8, NSEC_PER_ ## units)
+
 #define __print_time_stat(stats, name, stat, units)			\
 	sysfs_print(name ## _ ## stat ## _ ## units,			\
 		    div_u64((stats)->stat >> 8, NSEC_PER_ ## units))
-- 
2.49.0.805.g082f7c87e0-goog


