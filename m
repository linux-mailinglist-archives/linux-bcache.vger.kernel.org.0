Return-Path: <linux-bcache+bounces-485-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 563AA8CE80E
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 17:34:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C4A728268D
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 15:34:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41FF6131E24;
	Fri, 24 May 2024 15:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kmNfQ3Im"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81E4131BDA;
	Fri, 24 May 2024 15:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564667; cv=none; b=p9fCFZkNWm/eNOs3TD6rFG+fwK/sI86ohH6b+2UJ2O34AhyvhOHXgjhqbRcsooyxN2HzoJRI1O/O8mZH918MQBiuTp1OD/I14VT35N5uudabptZ2cKx2IsLTkyWzpiICRe1Z2oAB2pdV0KBPmL+mCtb+3TaSWV0vMtxcNiI0J14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564667; c=relaxed/simple;
	bh=XBbTFxTKTTd12S0apVryE3PcI4APeLL8xosQ1q7yRmI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DzS+aX8Y5heC+xRXn2kn847Kngbz8K4OZdp5CuxiCrDbJmpDtH/W2lwHMwHmrvdkBtAWovfyAGBaVbfTtkzddFVQQ8/gVt1KcPox029qkHtEWMrNh91DYt3V4afr+zQ2hMfQL0GWXcbd7QklB8KCZHjyQ1D49Pi3M3EYsnLbgGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kmNfQ3Im; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2bf196037a7so247031a91.1;
        Fri, 24 May 2024 08:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716564665; x=1717169465; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eJxc7A3KFbtC/I5z6jADokbslyusd4Od8ho0PKKKHBc=;
        b=kmNfQ3ImZkb1iN+NVvPO2x6ppJxwfv8scIu626kf8RZ/XRI6fkUn5EcheK1urcY51Z
         3AxPwEN+NyviUKpOdr/OwWe8vT2v0oWRnCbz5vHFW7rPu76Pw2UHX5qQpbLaTLQrEB0c
         9DRYdLEukpXrAwywRAh+4JOXaDjDRGcrD1uZj0QXtrcu7HfirU5lAx9yvfgmfBHA0VyI
         M0pK/v7bELMm9tyDSaeEGkdyuJwctXfg7KLfcNT9wiEUyUVtJPy3ILEQb1jg6ahOg49i
         E/a5YMyfZ2QUiAeBG2IdMWZXDI59Apy46eabo+BwIy8ENSXw3Jq4He8X8A559PAjoJC4
         Ix/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716564665; x=1717169465;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eJxc7A3KFbtC/I5z6jADokbslyusd4Od8ho0PKKKHBc=;
        b=qj4s22HNNjWrVRfbZzlgfcWd/k+rD3UZmJoWBzAWGJCbSzkpyb/+i4jc/iojn4Jzzm
         nJwZjEjresk+zB7IAH5t3EBpSgBzQL127Y60UqwZCpXLwtnBxW8bx5n43cAWYD7V90pW
         n6+0ynz7UzjfCLoYnoBU/MHglfb2Ykq5ynsR6CzkvfRxM63fg/NwpNfoFvMyb4xWbt2s
         LWfYr1jOnQQiON/IFAXjIezJ4kvZJ1LXMw2RDng0GIhZ1apgFRCB7/ldcOJhYDK4Q7CD
         fQ+ty/jslNLWztbAsa1DUrPTAxnYbT9XHBVwqjKcDtIq6sW5aNBJoyH4DJYOMr51RKtr
         eVhQ==
X-Forwarded-Encrypted: i=1; AJvYcCUd1TGGjYa8X3jIHCZbwcDrRV9uYnIXJqSn3lQJKUivLSnlw3Ez8VYsPo9BlhJoKYsPdjmNonLj2HD9SaGhQlQl8T1yuaSX+IZoxolksl1Bx3AKJGRtxNDwy76r+YQ1oq6QyPBlExRnJMbuVLTBUuupgVZ6QMtOpWArDWhOEqmlZTg8zhPOVr4weM+1C3qJyu85eQcd8UVk5d6qjt6M4TD5cguaNvn7dkluY+Jv
X-Gm-Message-State: AOJu0YwN9XfCCxxMlpDfCQH3tFCbQjMIHSiXqsKNJYLSK9lT4Vmuv2a6
	T5dyCAT4qq0qRYUvNKyQ+rGeVzTvWngoTBpJSXUwHxY4XvaKqgq5
X-Google-Smtp-Source: AGHT+IEuU6jpX9orINJlPXkOYySiaFGvoUViUJAIEwsd0ETqDsNgaoXn1NDqH0zGyIfxWZx4lsu+oQ==
X-Received: by 2002:a17:90b:4fc8:b0:2af:6b92:ff6a with SMTP id 98e67ed59e1d1-2bf5f30e8a2mr2443714a91.3.1716564665094;
        Fri, 24 May 2024 08:31:05 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f50d294sm1525556a91.20.2024.05.24.08.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 08:31:04 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: colyli@suse.de,
	kent.overstreet@linux.dev,
	msakai@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	akpm@linux-foundation.org
Cc: bfoster@redhat.com,
	mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	bagasdotme@gmail.com,
	jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH v6 12/16] lib min_heap: Rename min_heapify() to min_heap_sift_down()
Date: Fri, 24 May 2024 23:29:54 +0800
Message-Id: <20240524152958.919343-13-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240524152958.919343-1-visitorckw@gmail.com>
References: <20240524152958.919343-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After adding min_heap_sift_up(), the naming convention has been
adjusted to maintain consistency with the min_heap_sift_up().
Consequently, min_heapify() has been renamed to min_heap_sift_down().

Link: https://lkml.kernel.org/CAP-5=fVcBAxt8Mw72=NCJPRJfjDaJcqk4rjbadgouAEAHz_q1A@mail.gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 drivers/md/dm-vdo/repair.c |  2 +-
 include/linux/min_heap.h   | 14 +++++++-------
 kernel/events/core.c       |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
index eae990859db4..ff09e4a14333 100644
--- a/drivers/md/dm-vdo/repair.c
+++ b/drivers/md/dm-vdo/repair.c
@@ -183,7 +183,7 @@ static struct numbered_block_mapping *sort_next_heap_element(struct repair_compl
 	 */
 	last = &repair->entries[--heap->nr];
 	swap_mappings(heap->data, last, NULL);
-	min_heapify(heap, 0, &repair_min_heap, NULL);
+	min_heap_sift_down(heap, 0, &repair_min_heap, NULL);
 	return last;
 }
 
diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 3410a5f907ad..0baee5787247 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -75,7 +75,7 @@ bool __min_heap_full(min_heap_char *heap)
 
 /* Sift the element at pos down the heap. */
 static __always_inline
-void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
+void __min_heap_sift_down(min_heap_char *heap, int pos, size_t elem_size,
 		const struct min_heap_callbacks *func, void *args)
 {
 	void *left, *right;
@@ -108,8 +108,8 @@ void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
 	}
 }
 
-#define min_heapify(_heap, _pos, _func, _args)	\
-	__min_heapify((min_heap_char *)_heap, _pos, __minheap_obj_size(_heap), _func, _args)
+#define min_heap_sift_down(_heap, _pos, _func, _args)	\
+	__min_heap_sift_down((min_heap_char *)_heap, _pos, __minheap_obj_size(_heap), _func, _args)
 
 /* Sift up ith element from the heap, O(log2(nr)). */
 static __always_inline
@@ -139,7 +139,7 @@ void __min_heapify_all(min_heap_char *heap, size_t elem_size,
 	int i;
 
 	for (i = heap->nr / 2 - 1; i >= 0; i--)
-		__min_heapify(heap, i, elem_size, func, args);
+		__min_heap_sift_down(heap, i, elem_size, func, args);
 }
 
 #define min_heapify_all(_heap, _func, _args)	\
@@ -158,7 +158,7 @@ bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
 	/* Place last element at the root (position 0) and then sift down. */
 	heap->nr--;
 	memcpy(data, data + (heap->nr * elem_size), elem_size);
-	__min_heapify(heap, 0, elem_size, func, args);
+	__min_heap_sift_down(heap, 0, elem_size, func, args);
 
 	return true;
 }
@@ -178,7 +178,7 @@ void __min_heap_pop_push(min_heap_char *heap,
 		void *args)
 {
 	memcpy(heap->data, element, elem_size);
-	__min_heapify(heap, 0, elem_size, func, args);
+	__min_heap_sift_down(heap, 0, elem_size, func, args);
 }
 
 #define min_heap_pop_push(_heap, _element, _func, _args)	\
@@ -232,7 +232,7 @@ bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
 		return true;
 	func->swp(data + (idx * elem_size), data + (heap->nr * elem_size), args);
 	__min_heap_sift_up(heap, elem_size, idx, func, args);
-	__min_heapify(heap, idx, elem_size, func, args);
+	__min_heap_sift_down(heap, idx, elem_size, func, args);
 
 	return true;
 }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index c843af8fa6f0..fad272aaeb65 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3795,7 +3795,7 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
 
 		*evt = perf_event_groups_next(*evt, pmu);
 		if (*evt)
-			min_heapify(&event_heap, 0, &perf_min_heap, NULL);
+			min_heap_sift_down(&event_heap, 0, &perf_min_heap, NULL);
 		else
 			min_heap_pop(&event_heap, &perf_min_heap, NULL);
 	}
-- 
2.34.1


