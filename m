Return-Path: <linux-bcache+bounces-1103-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 531E0ACFD61
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Jun 2025 09:20:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D57B11895FA6
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Jun 2025 07:20:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA0DA1E8854;
	Fri,  6 Jun 2025 07:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oT+hFb5W"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0691E2853
	for <linux-bcache@vger.kernel.org>; Fri,  6 Jun 2025 07:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749194429; cv=none; b=eNoRxOxaTL0rjjW8knGq130OvFRsA2cUjUiQovPja+FBEjxi1mm7wUnbyi1GDNzj6Iljm6WAANujCHj4+zUeJ3UIdbSLIj+uyhFjMx6bdK/yMhmW1svvxILPzVqc1M4s+EyAsRYJvbivFj74vNH8oPcQr+PGx/1vRfmY/crz39Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749194429; c=relaxed/simple;
	bh=KmxE+/7VI19APyTH9KJFVCMZP798yNnhjikCnchBM/g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SYk9k/SzKDMQPjKHFBR71XtV/RYhTYntOsTU+ZoK3e+HArr1NFroMN3AGXOJhI93/EWFkYBxOndP1zyFnK/370dNCK6JjPRagxE3IH3q3CLYOJfkkzSTEx/W3LUwinODrBiD9MML/pYd/IV6NtOiae7WsPajL+Pk4zHtX/Ig9Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oT+hFb5W; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311b6d25163so1796799a91.0
        for <linux-bcache@vger.kernel.org>; Fri, 06 Jun 2025 00:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749194427; x=1749799227; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uyWBa20yBi9DnblLqopo+Wg40oKL0xv1/Nu3jqyH8qk=;
        b=oT+hFb5WecDotFuG5s9QIEisoHY14aB30IBjitqKDbWtpcDwzVIDY268iTKQsoUHmh
         PvyoPXI4UaChxtqY1jM7D+tA7qCzv667o8cuDixejBCEC9PplZN1YOXK7Eu/Csn7+YHb
         VqcsbcxGj2ziYBwRZtkvkoDe5f2fPHoDb+VcQTSrP2MKii9A8i+XOogyheZ2qyAVRK0G
         qJp2qCNdzHlVB3yOG6TD4bkT1FvP5H/TMgXwoZeyu5fZWxV70Qeel8CsMgSE7SYFnN3C
         onbayyFhV8DN5Z60EBOBUg5RSqTwoIlIeyJ6lhz4FF30rF9vw43n6b7zPxT12NE+KjeK
         6FJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749194427; x=1749799227;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uyWBa20yBi9DnblLqopo+Wg40oKL0xv1/Nu3jqyH8qk=;
        b=siSO5YUdg08JXD0lote6sORsHibIjp9ubfgsbgMn1p+wtmcZZlkwlpi46L3sQ5HOnS
         AXj+8UC5lompDQaypxdzHKwC2gdLbXsxTeqtOGEVDkKhVPwL3+jceD4Xr3VYAHSmwAeL
         EmKgYVevmFHcFw6v8PMxQbvC3dc6AfeHMeMxXAG0uDT0bZBqSjupcEQ0a3N+sqmWCGu1
         5cEl8HzeQo3zuMWH1PxbEmHaiYJ1RUOnMDx9eS27bpL8jwm8y1pDltKN65m1jriQdB1m
         QBF6UF6jqUihkGbSxL02F0mYhb+cpY5AhPKZUz9sahWiqlC77T5B7DgbbrL3dwLf3Sk5
         I+AQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNsLYL4iSn10x10SH5+EvkFZ4XMjB/pKTvubGETGWIRX/0DUVMAwJzkdj+5eLhvVLPWjwvSU4dwXQU+b0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmrDfI4DdmsA9p2Sjc1FRXpIO5dd4YRIEi7BdfitgyVvFtj1LP
	z02w9/GOuHdnbtoDGlNm8rFKEVzWQ9W7w59BQ0X0MkFJ+IKYYxaQGQ+QJO8+YUqrMcHCdyJCmUz
	KJb5hYdbLM0MhdJSTpZzrZw==
X-Google-Smtp-Source: AGHT+IFiAFjSIMAwlVU4rWADOFz13O/IIJuhorYZOxFffNvls78MtYmweZKT0udNHjLKDhHgvb17WTrO8272Zzb8
X-Received: from pjbta6.prod.google.com ([2002:a17:90b:4ec6:b0:312:eaf7:aa0d])
 (user=robertpang job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:57cf:b0:313:15fe:4c13 with SMTP id 98e67ed59e1d1-31346f5a893mr3809310a91.27.1749194427413;
 Fri, 06 Jun 2025 00:20:27 -0700 (PDT)
Date: Fri,  6 Jun 2025 00:19:45 -0700
In-Reply-To: <20250606071959.1685079-1-robertpang@google.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250606071959.1685079-1-robertpang@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250606071959.1685079-4-robertpang@google.com>
Subject: [PATCH 3/3] bcache: Fix the tail IO latency regression due to the use
 of lib min_heap
From: Robert Pang <robertpang@google.com>
To: Coly Li <colyli@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcache@vger.kernel.org
Cc: Robert Pang <robertpang@google.com>, Kuan-Wei Chiu <visitorckw@gmail.com>
Content-Type: text/plain; charset="UTF-8"

In commit "lib/min_heap: introduce non-inline versions of min heap API functions"
(92a8b22), bcache migrates to the generic lib min_heap for all heap operations.
This causes sizeable the tail IO latency regression during the cache replacement.

This commit updates invalidate_buckets_lru() to use the alternative APIs that
sift down elements using the top-down approach like bcache's own original heap
implementation.

[1] https://lore.kernel.org/linux-bcache/wtfuhfntbi6yorxqtpcs4vg5w67mvyckp2a6jmxuzt2hvbw65t@gznwsae5653d/T/#me50a9ddd0386ce602b2f17415e02d33b8e29f533

Signed-off-by: Robert Pang <robertpang@google.com>
---
 drivers/md/bcache/alloc.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 8998e61efa40..547d1cd0c7c2 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -207,15 +207,15 @@ static void invalidate_buckets_lru(struct cache *ca)
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
+			min_heap_sift_down_top_down_inline(&ca->heap, 0, &bucket_max_cmp_callback, ca);
 		}
 	}
 
-	min_heapify_all(&ca->heap, &bucket_min_cmp_callback, ca);
+	min_heapify_all_top_down_inline(&ca->heap, &bucket_min_cmp_callback, ca);
 
 	while (!fifo_full(&ca->free_inc)) {
 		if (!ca->heap.nr) {
@@ -227,8 +227,8 @@ static void invalidate_buckets_lru(struct cache *ca)
 			wake_up_gc(ca->set);
 			return;
 		}
-		b = min_heap_peek(&ca->heap)[0];
-		min_heap_pop(&ca->heap, &bucket_min_cmp_callback, ca);
+		b = min_heap_peek_inline(&ca->heap)[0];
+		min_heap_pop_top_down_inline(&ca->heap, &bucket_min_cmp_callback, ca);
 
 		bch_invalidate_one_bucket(ca, b);
 	}
-- 
2.50.0.rc1.591.g9c95f17f64-goog


