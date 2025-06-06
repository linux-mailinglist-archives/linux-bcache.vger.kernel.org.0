Return-Path: <linux-bcache+bounces-1102-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EED4BACFD60
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Jun 2025 09:20:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5495C1895F3C
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Jun 2025 07:20:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F08C1C2335;
	Fri,  6 Jun 2025 07:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="muVd4TEY"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925521E8854
	for <linux-bcache@vger.kernel.org>; Fri,  6 Jun 2025 07:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749194427; cv=none; b=SpFzWjS4ZKODOcybfl0vPtpiowR/bZg00cW8HWHeWHaUkptObhGxrmLFODIfXAsTQyWCUq0Zmcp33FapP35WLhVl0Opf41XyyJ1mS0hOteP3OIAvP6maux/r9wCnoS0fto6wEjHX3GWW1lGa2cZ0DNfGBdwXV4ra1zlphYljvjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749194427; c=relaxed/simple;
	bh=GugkoFZZ9tLuZ4yFnCYlXil3BN/LNZay75F7PXTxksM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c9Eu2piiZ7jV/VqyBpm8Sn/fO8BGqCtLZsPzx4tbhwBtG/Wx1qcqYfnoWRdzai/feLj+YFoA3qmCUNbKN7m/GkvFjXuv5CxukjSf5YU604mxkNlf+AECbYdICg72niMTljhmUr2aVIdmZ//rlOFpS64Y1tHsw7mKjiDSfwgzPb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=muVd4TEY; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7429fc0bfc8so2491098b3a.1
        for <linux-bcache@vger.kernel.org>; Fri, 06 Jun 2025 00:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749194422; x=1749799222; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R+MQsLYJK9iDWmfHoRS+lW0KWVPZmuJGL/3gY5MM55w=;
        b=muVd4TEY4TfINFydcGIxiR9Tima8i1F9wrz/gyTtiPWokPEb6FkUIGy8OGQ5pJXN/Q
         arkVv+fH9VGUsy5bjV4A5/xa2Vyq2VOMOrnox+6sLCJb+wa5K2O3S7sgmHh2xfVFn1Gs
         QZjVMwlKxGRf9b7c6mgU1GBEmdUTF7GqQKMLeSyOM34QR3Mb7Pm4IEDHwpaH+GPym9Vy
         0A1GfbXlw27ZnvWdGA1CxCRfmWnMDwdXw1w0h47GLMz7JwX6sgv/0gdITIy/s5kwOmi8
         aqupvZ/TxLhb3BAHy7ZZj2hPW3xGlKFaTLZhOliwmWyBWnDmOj1gKqoCpqoRDPHQ4YbS
         dhjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749194422; x=1749799222;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R+MQsLYJK9iDWmfHoRS+lW0KWVPZmuJGL/3gY5MM55w=;
        b=bxqDOPelMxcro5eEt5GzwV83tbpBOyjja83E2LQBIyRulUGNGXmr2WRU3EFTq2sQxf
         6vVPk7iMQB+uuT7kfmzhS7+tJiGMpIRcOjUbbaOE83sVPV5i8ovOiHimHtYnL6e6U+1n
         x4/eRorzHf+5K/PwCVFH7dfFpXaq+pIZ75F4Xp1UlGnH/5JhphrmMIXqnDYlLLxpuDik
         /XD/JLTptJ7Jwfop3MFYvAnp22JvEux4Td+TQr+btutenQTEXv0sICtBL3vqI0uFoy4I
         9p/ThygjI60GPEPFunlJkHyMJ1RpKFN4YrKV35Gf8Jkca/5Mdqtx6xI8ER3SUTDZCOJ5
         Rweg==
X-Forwarded-Encrypted: i=1; AJvYcCWg3nKKIh/vEOwmhIQhJOMcHKQSl78I2u5ejCZOH0vOvoehv/HRbi8XSkwaD7yduYn0qEacKKhE5ytBL4w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsKwNaNiMSTTl+Qxk+AxOf5+w7If+n9lKo9BN/pNcF9xgDLnTs
	CXug50mXnmdV1wdBdPj54OcjIw1C2yaKV/qfJK3DLrw+/6gCt0bwKvo2AERO2MjgEuU3P7zpJyh
	jrDWMf+KEa+SlMma4q0Q4/Q==
X-Google-Smtp-Source: AGHT+IFCLQjRX0UIUS1/8wBoVmMPBgxFm2H6iYa9qLDd8yVxISkuaW+isycuNY7qzsSu0B+EYdj8m2cjG50TC7PB
X-Received: from pgmm38.prod.google.com ([2002:a05:6a02:5526:b0:b2f:64be:6881])
 (user=robertpang job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:12cb:b0:1f3:20be:c18a with SMTP id adf61e73a8af0-21ee25987demr2959978637.10.1749194421806;
 Fri, 06 Jun 2025 00:20:21 -0700 (PDT)
Date: Fri,  6 Jun 2025 00:19:44 -0700
In-Reply-To: <20250606071959.1685079-1-robertpang@google.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250606071959.1685079-1-robertpang@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250606071959.1685079-3-robertpang@google.com>
Subject: [PATCH 2/3] lib min_heap: add alternative APIs that use the
 conventional top-down strategy to sift down elements
From: Robert Pang <robertpang@google.com>
To: Coly Li <colyli@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcache@vger.kernel.org
Cc: Robert Pang <robertpang@google.com>, Kuan-Wei Chiu <visitorckw@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Add these min_heap functions that re-introduce the conventional top-down
strategy to sift down elements. This strategy offers significant performance
improvements for data that are mostly identical. [1]

- heapify_all_top_down
- heap_pop_top_down
- heap_pop_push_top_down
- heap_del_top_down

[1] https://lore.kernel.org/linux-bcache/wtfuhfntbi6yorxqtpcs4vg5w67mvyckp2a6jmxuzt2hvbw65t@gznwsae5653d/T/#m155a21be72ff0cc57d825affbcafc77ac5c2dd0d

Signed-off-by: Robert Pang <robertpang@google.com>
---
 include/linux/min_heap.h | 75 ++++++++++++++++++++++++++++++++++++++++
 lib/min_heap.c           |  7 ++++
 2 files changed, 82 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 1fe6772170e7..149069317bb3 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -494,4 +494,79 @@ bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
 	__min_heap_del(container_of(&(_heap)->nr, min_heap_char, nr),	\
 		       __minheap_obj_size(_heap), _idx, _func, _args, __min_heap_sift_down)
 
+static __always_inline
+void __min_heap_sift_down_top_down_inline(min_heap_char *heap, int pos, size_t elem_size,
+					  const struct min_heap_callbacks *func, void *args)
+{
+	void *data = heap->data;
+	void (*swp)(void *lhs, void *rhs, void *args) = func->swp;
+	/* pre-scale counters for performance */
+	size_t a = pos * elem_size;
+	size_t b, c, d, smallest;
+	size_t n = heap->nr * elem_size;
+
+	if (!swp)
+		swp = select_swap_func(data, elem_size);
+
+	for (;;) {
+		if (2 * a + elem_size >= n)
+			break;
+
+		c = 2 * a + elem_size;
+		b = a;
+		smallest = b;
+		if (func->less(data + c, data + smallest, args))
+			smallest = c;
+
+		if (c + elem_size < n) {
+			d = c + elem_size;
+			if (func->less(data + d, data + smallest, args))
+				smallest = d;
+		}
+		if (smallest == b)
+			break;
+		do_swap(data + smallest, data + b, elem_size, swp, args);
+		a = (smallest == c) ? c : d;
+	}
+}
+
+#define min_heap_sift_down_top_down_inline(_heap, _pos, _func, _args)	\
+	__min_heap_sift_down_top_down_inline(container_of(&(_heap)->nr, min_heap_char, nr),	\
+					     _pos, __minheap_obj_size(_heap), _func, _args)
+#define min_heapify_all_top_down_inline(_heap, _func, _args)	\
+	__min_heapify_all_inline(container_of(&(_heap)->nr, min_heap_char, nr),	\
+				 __minheap_obj_size(_heap), _func, _args,	\
+				 __min_heap_sift_down_top_down_inline)
+#define min_heap_pop_top_down_inline(_heap, _func, _args)	\
+	__min_heap_pop_inline(container_of(&(_heap)->nr, min_heap_char, nr),	\
+			      __minheap_obj_size(_heap), _func, _args,	\
+			      __min_heap_sift_down_top_down_inline)
+#define min_heap_pop_push_top_down_inline(_heap, _element, _func, _args)	\
+	__min_heap_pop_push_inline(container_of(&(_heap)->nr, min_heap_char, nr), _element,	\
+				   __minheap_obj_size(_heap), _func, _args,	\
+				   __min_heap_sift_down_top_down_inline)
+#define min_heap_del_top_down_inline(_heap, _idx, _func, _args)	\
+	__min_heap_del_inline(container_of(&(_heap)->nr, min_heap_char, nr),	\
+			      __minheap_obj_size(_heap), _idx, _func, _args,	\
+			      __min_heap_sift_down_top_down_inline))
+
+void __min_heap_sift_down_top_down(min_heap_char *heap, int pos, size_t elem_size,
+                                   const struct min_heap_callbacks *func, void *args);
+
+#define min_heap_sift_down_top_down(_heap, _pos, _func, _args)	\
+	__min_heap_sift_down(container_of(&(_heap)->nr, min_heap_char, nr), _pos,	\
+			     __minheap_obj_size(_heap), _func, _args)
+#define min_heapify_all_top_down(_heap, _func, _args)	\
+	__min_heapify_all(container_of(&(_heap)->nr, min_heap_char, nr),	\
+			  __minheap_obj_size(_heap), _func, _args, __min_heap_sift_down_top_down)
+#define min_heap_pop_top_down(_heap, _func, _args)	\
+	__min_heap_pop(container_of(&(_heap)->nr, min_heap_char, nr),	\
+		       __minheap_obj_size(_heap), _func, _args, __min_heap_sift_down_top_down)
+#define min_heap_pop_push_top_down(_heap, _element, _func, _args)	\
+	__min_heap_pop_push(container_of(&(_heap)->nr, min_heap_char, nr), _element,	\
+			    __minheap_obj_size(_heap), _func, _args, __min_heap_sift_down_top_down)
+#define min_heap_del_top_down(_heap, _idx, _func, _args)	\
+	__min_heap_del(container_of(&(_heap)->nr, min_heap_char, nr),	\
+		       __minheap_obj_size(_heap), _idx, _func, _args, __min_heap_sift_down_top_down)
+
 #endif /* _LINUX_MIN_HEAP_H */
diff --git a/lib/min_heap.c b/lib/min_heap.c
index 4ec425788783..a10d3a7cc525 100644
--- a/lib/min_heap.c
+++ b/lib/min_heap.c
@@ -27,6 +27,13 @@ void __min_heap_sift_down(min_heap_char *heap, int pos, size_t elem_size,
 }
 EXPORT_SYMBOL(__min_heap_sift_down);
 
+void __min_heap_sift_down_top_down(min_heap_char *heap, int pos, size_t elem_size,
+				   const struct min_heap_callbacks *func, void *args)
+{
+	__min_heap_sift_down_top_down_inline(heap, pos, elem_size, func, args);
+}
+EXPORT_SYMBOL(__min_heap_sift_down_top_down);
+
 void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
 			const struct min_heap_callbacks *func, void *args)
 {
-- 
2.50.0.rc1.591.g9c95f17f64-goog


