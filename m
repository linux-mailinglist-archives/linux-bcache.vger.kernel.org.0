Return-Path: <linux-bcache+bounces-895-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC5FEA912A0
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Apr 2025 07:26:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AE083BC83E
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Apr 2025 05:26:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBC1E1DE3CE;
	Thu, 17 Apr 2025 05:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XI7F1bn2"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6214618DB2B
	for <linux-bcache@vger.kernel.org>; Thu, 17 Apr 2025 05:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744867610; cv=none; b=KYQSLsAOPNjtDQX1hxWO98Pk2zPryV5X5UW2Bnbc8cEk0KjgL58gEq0mS8D8sCI5/bSZwmpwSlAzQCoGPj//oCPV8u+mBcGb5YvSIIZi+x3T6WQf2PDdj/vgb2s5SzZD3D89dvqtMydgFGGLe5kspy48+jycfAU8kud3DxP8UtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744867610; c=relaxed/simple;
	bh=NS3VoIX6Qik95EAN0OC6tAToa9r6MiR2JKzptl6KAxM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EKVBCFgGCQ5gwo3OGrEOM2nneXVi92lsnZ6a9G3aulgAA3TCAP++BfxMGnvZTn9WkGgAKCis/5sfzwPNZ7SXrCKoHvigYa4ZD8fsSegdE8q1AN0l3wr3PDqPEVXcRphfmTETKzR5rqtVZtg521e1RTmAvG9K4Kn/FvE6SxL7Eos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XI7F1bn2; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736b22717f1so1023878b3a.1
        for <linux-bcache@vger.kernel.org>; Wed, 16 Apr 2025 22:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744867609; x=1745472409; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JQBDaafvUHo7p4Y/gnL32Fg1nucAOBN52d7P+K3rLEs=;
        b=XI7F1bn2qNDAHFCv3mpUHQWmKG1vjEoJwk2z63GRi1UknHwupX68ffLrtY5LuHkFTp
         fj0QU1nSgBGjVYlmrD9stiqTcndowPArjb/gbqFTmGRkNBB6Dzm+nWrxiI/PaQQRvHRi
         u3mR1JD0P4fsQvWWnZKQbQiYdAfzbqPLWspqjF6QaLY1Xe7RdWJt85RxhesSwf1MUSxS
         DFNOZmVdKnp/lVK9A85m8ycCr0kB4eR5hXh3D16EiR9AOEIGD2a3vMq05gDcHG7aKHwC
         krxRDMbkGu1aY0LiR/hzPwhydFlsMa7b4mPkyYJ4AYPFyAW8LGqX/H3kkxJN9XRLaUg9
         /IIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744867609; x=1745472409;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JQBDaafvUHo7p4Y/gnL32Fg1nucAOBN52d7P+K3rLEs=;
        b=XV9wd1PSZgN/hpvzJTIexWBEKIhhB+bY4MbjgQKk1DnE32utYt4VdOTTdRTz0vKScR
         GgNZWIjdZtplXkepDGzz9uMkgtgcWUZcOz4i5A0pe1otzItnnGvm+xSUBbiDU+L4a39U
         aiQndOLgjpTPqZqo/sn+f0iWlS6eIeoIH4OL2j3PHBuscxcssWPo2Qz6Uxo/2G7Gmm3J
         OekqBOB5HnzDIuY8/XBCzkUKktTiK3H63OieEsQGatlqBgyCzXi9rdJbVz6KCITwNDgu
         weowfjMs3T6bDdXyW4FINdkhAiwHNYy+n0ReaqEF4O04u6XtbYS0lG2OVwog+4DqkM0N
         tsmQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYXdkSO9JjeMY6v8pVK8HgVZr5d+3VOFmpjfCm0UB7toDs3wJj/IcNkJxfSsSaCA2LUU43oLRBzFXHD7M=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMDwfCE8VL64CH0yDUeirUHC8GLS+vlU1460xE2AF9FqnLj6ok
	01bUZz7XMW9+LBc1XTbUacj9qUU2V/xEEcYKj1CmamnTtGSm6y/Clr/dmpV7NiktUbBT67Q6f8w
	mXKC7eA+t14H+e3I0Qg==
X-Google-Smtp-Source: AGHT+IFW7/uCoF6EpuzmBlzP/vwB3IHB/x8NMSjpTlQQrI4fzP/5ssRw2s+XZN9bYh61CIc+BINA6HB3v9LwGzEt
X-Received: from pfbkq19.prod.google.com ([2002:a05:6a00:4b13:b0:73c:26bd:133c])
 (user=robertpang job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1796:b0:737:cd8:2484 with SMTP id d2e1a72fcca58-73cdbf19b7bmr2213138b3a.6.1744867608680;
 Wed, 16 Apr 2025 22:26:48 -0700 (PDT)
Date: Wed, 16 Apr 2025 22:25:35 -0700
In-Reply-To: <20250417052553.1015905-1-robertpang@google.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250417052553.1015905-1-robertpang@google.com>
X-Mailer: git-send-email 2.49.0.777.g153de2bbd5-goog
Message-ID: <20250417052553.1015905-2-robertpang@google.com>
Subject: [PATCH v3 1/1] bcache: process fewer btree nodes in incremental GC cycles
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
 drivers/md/bcache/btree.c | 37 ++++++++++++++++++-------------------
 drivers/md/bcache/util.h  |  7 +++++++
 2 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index ed40d8600656..d6d9ed43740b 100644
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
 
@@ -1585,25 +1584,25 @@ static unsigned int btree_gc_count_keys(struct btree *b)
 
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
+		min_nodes = div64_u64(c->gc_stats.nodes,
+				      div_u64(gc_max_ms, GC_SLEEP_MS));
 
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
2.49.0.777.g153de2bbd5-goog


