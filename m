Return-Path: <linux-bcache+bounces-876-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DA10A88F37
	for <lists+linux-bcache@lfdr.de>; Tue, 15 Apr 2025 00:45:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E1C017A830
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Apr 2025 22:45:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 021431F5434;
	Mon, 14 Apr 2025 22:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jsqRMeaG"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647BD156236
	for <linux-bcache@vger.kernel.org>; Mon, 14 Apr 2025 22:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744670704; cv=none; b=ltXms9CgJn33D99407j0sYiLbVDH+IF1/dr8eXmxXQYFbrtoaTm1keNEMoL3qu9VnGhkILwIEBKi+oXh+Go9wb8NrPMMYNElWd1B6vBKv7/BQFx+1lRGkkRF+58F3TnVFY5dhuCILTDRJKaSBvgTav+snAGbLqcnswvty7Q2U1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744670704; c=relaxed/simple;
	bh=zw/n2N7JURMiQRG9bl1juAk9vzfyeTsSHtz9OpdXLos=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lgzr7yZlhsJyI55Zw5G4I5vZr9EtjTApoyq8pyRrsl1n6iBPzHKrfXP4aQ4nhuOTs/BWUKaR6v99dIuc6dkQI7IPXBaa09lXe4sCXyPUPhXA/dIhZFCakMYALPQ8u2uktnHeAveoG1hfvX+c7FoS+7eH5PMtuX0PiYq3/Og9PKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jsqRMeaG; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-224192ff68bso43592035ad.1
        for <linux-bcache@vger.kernel.org>; Mon, 14 Apr 2025 15:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744670702; x=1745275502; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oQL5iE8iu4N7wtUpRL7nyZZob3Xe8+1lMJ49N5BPB/4=;
        b=jsqRMeaGmojH2gKtlW3mwwBrLy8oWXyCzXjU6+OIgG+2TAONZOpIIxdkVWVAQWnKKK
         7EGzid5pnDVaJvkTrNTP9679X+LgI1BGaJK4AQd5v7Sjl8DLoiLWznInidF8XI8Jy+JQ
         BwLJHZFgSXCcszC2Z2qy4BuWVoxpXIX4yqWgd9+C9nY1vu+XAZe6E8+yJli84alxFN1/
         8nuJjKd+UD4/zCOmsM5mQHbKisrfSW7FDL5rnQS2bmcOlmfcFuBsi2w+yW5n6biHwqgj
         cd3OxQX4t8XP82Aj3/Jquo6EZRtlYX2gnQy9fF3GiXXlfPFKpKR00kxe9Rh51GPxWOd1
         BZDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744670702; x=1745275502;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oQL5iE8iu4N7wtUpRL7nyZZob3Xe8+1lMJ49N5BPB/4=;
        b=MIJ77xFkWWjpu3oTyemU/STaXWlST0UfJDqxbYDdZL+wRAyxuIcQJ2nsp/cDpja0Om
         7UzHIB2moHH3gj4e1y9KpArwMJoxT5mP9P6VP80cwKU4i4HMVlTgzMK7pFyIskesoHWc
         r3wFuv8Fa06TbzmjFRB+7v8asMw2DFZVyFSMdu9xTzOAFYn4q7h6+hVMf9QxJE+33vgu
         KgY0IFhGZQVP4CF0hB1AaxePD3D7s2AUb2S5yKSlOB6Tl2TEnNh+ESkapCelrCwhtXTv
         ULKiiT2MhOrPwC1QFtEBYy3uVbma3yul3RqplOV9pNdGBc6p6CsydapPfnymuDotdYG1
         gL+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWUiZvCBe9KzQzVNj9nZ59HZ+H0baZt6f0sCfeKhl+qAJeO48DoUX7mISVhbCnO8V/PE/GhaQ+/MUxMa4o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/eD6oYkJODQtyugUAnOZgGfduR22TaRxkzdAgZ828UaNYEoHt
	/hfESeYzT17nhZKnGhRz9h9a20L1H9DfMtAzPoCqnxbOqLFdNeQpqXLmrqf4AhvZXEAxLcM06O5
	8RZ3a/hVRPwgkXlmamw==
X-Google-Smtp-Source: AGHT+IEL8qpLuzaC6fF+2lW6VQ9RCuQGUoXZwOzN+llm30ZMw4f65KFsji9rbltq+SBOiaEEfLSKmb7E+5Fj88Nx
X-Received: from plbkt3.prod.google.com ([2002:a17:903:883:b0:223:67ac:e082])
 (user=robertpang job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2a8f:b0:220:ce37:e31f with SMTP id d9443c01a7336-22bea4acc69mr192428135ad.17.1744670702638;
 Mon, 14 Apr 2025 15:45:02 -0700 (PDT)
Date: Mon, 14 Apr 2025 15:44:04 -0700
In-Reply-To: <20250414224415.77926-1-robertpang@google.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250414224415.77926-1-robertpang@google.com>
X-Mailer: git-send-email 2.49.0.604.gff1f9ca942-goog
Message-ID: <20250414224415.77926-2-robertpang@google.com>
Subject: [PATCH 1/1] bcache: process fewer btree nodes in incremental GC cycles
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
 drivers/md/bcache/btree.c | 38 +++++++++++++++++---------------------
 drivers/md/bcache/util.h  |  3 +++
 2 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index ed40d8600656..093e1edcaa53 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -88,11 +88,8 @@
  * Test module load/unload
  */
 
-#define MAX_NEED_GC		64
-#define MAX_SAVE_PRIO		72
-#define MAX_GC_TIMES		100
-#define MIN_GC_NODES		100
-#define GC_SLEEP_MS		100
+#define GC_MIN_NODES		10
+#define GC_SLEEP_MS		10
 
 #define PTR_DIRTY_BIT		(((uint64_t) 1 << 36))
 
@@ -1585,25 +1582,24 @@ static unsigned int btree_gc_count_keys(struct btree *b)
 
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
index 539454d8e2d0..21a370f444b7 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -305,6 +305,9 @@ static inline unsigned int local_clock_us(void)
 #define NSEC_PER_ms			NSEC_PER_MSEC
 #define NSEC_PER_sec			NSEC_PER_SEC
 
+#define time_stat_average(stats, stat, units)				\
+	div_u64((stats)->average_ ## stat >> 8, NSEC_PER_ ## units)
+
 #define __print_time_stat(stats, name, stat, units)			\
 	sysfs_print(name ## _ ## stat ## _ ## units,			\
 		    div_u64((stats)->stat >> 8, NSEC_PER_ ## units))
-- 
2.49.0.604.gff1f9ca942-goog


