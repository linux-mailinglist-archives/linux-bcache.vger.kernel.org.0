Return-Path: <linux-bcache+bounces-1101-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C9213ACFD5F
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Jun 2025 09:20:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 408F67A148F
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Jun 2025 07:19:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 624181C2335;
	Fri,  6 Jun 2025 07:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PfSRjBVk"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CA33596A
	for <linux-bcache@vger.kernel.org>; Fri,  6 Jun 2025 07:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749194422; cv=none; b=F/l3bb/DReF5LuueRkkpc0YNn1OcXLkbXX3VPS/4a9hYVfK6mMRWQDcccVnWTcLZ1bAXQ1x+XbavOaaZTQ4WhWUsrPVNCD1te0lP/H+Bb7QenO/HRBM+4SO96Z7ZUaB6rf+iUm0R4PUlBwfpMXvcuIcCrnkzfnfJqd7vMfBNFcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749194422; c=relaxed/simple;
	bh=1lLi+l7+UFA3E6vjRr2q9S4QjO8PvR55ztN4B8vHHq4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rh2yIxBhbeEnqdA1qL2RbJzWLoySMvidcmlwYD03C2xvCE7yrosoUet1RZpVzW885yzYfuPQl7b0+nSd7EINp3+149/GVL1U/bGWYVljOWBARMvWi2LzdhsfQw73AAFWKzhtmuYkMUUlxfvDLa7967QQiwJJSv3qcqNPjlANu1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PfSRjBVk; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2358ddcb1e3so26418625ad.3
        for <linux-bcache@vger.kernel.org>; Fri, 06 Jun 2025 00:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749194419; x=1749799219; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZbcIXDVy0FMxl2nW8wVsCrtg6d0IW8hUy/lRrMCIxsY=;
        b=PfSRjBVkRNAIf8RIZiOpINRlPSo0gmUP58LVDHVyVL5hAHKKuRgb3cDq3hOIG3s+oY
         NNMQB3bBZgBbU9cDlgUN4PuWDVeQMWNzRIqZC5mODr0Tjja18xTfZBpTcf267OkqgtSi
         0I5ESwppROzdiFjeZxzVmABFeDjpxCsteXxe25AHJgH+SJEvDe1rs1784H3EOjsMZSK0
         FTVwRL1wPMhhc4eYIQ9CbJEXr57X8YyJqzO2Wgcow7Q3sWnrs5i13hJJb71kT+T5rdIa
         U736tUUcEqO276PhthmZK/2bz9f/3Jj2v9YagPOAZhweFfJBU8/mgrKRWguZ/SBAb06Q
         eiQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749194419; x=1749799219;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZbcIXDVy0FMxl2nW8wVsCrtg6d0IW8hUy/lRrMCIxsY=;
        b=JfkTkf8OqYuXqxtUItMqmcsuea88PUtotRkzOqRIgTR1pMAnQiInsDfG3KCsUSQUIv
         Jnc0P40nD7ye/y9ziL3H038hqJU9SE4ZLOhIL6dlGd57mnwqP3ljfwf5BIQsCsoh9oMy
         pQbDwKW6p6C3f/WDqQzrg8yt1Tujgrpsu+kf3eIjfK0uwpIxNaniZtER9r+Gaj3Rb8h8
         XHgn1jFNHCfDJMcjEzPkLp7iyqKx+OdbDSIU6fm1PmvB+SoQk4HYERlGkks2u49Kd3LX
         OS2EjAHYqOYaVlBYcWIJ3s0qr2tOTdaoBT4TAoiGn76jZ92SCsvN0ZZPtutsSLRQgpvj
         FMGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXdN0msxZIg/bmoAU6cNzIkKeYy8cKQpV7lsk7H0dEr7KoxkBUxgK3FUECdyY/Iy5v0Wudx+tua8cglSk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTlOm8Hi0edIeVGqtErpFSwrL8Rif+1O3dZ2FvrJbktvntvYSl
	aRYTG7ZIJiQxhTunotoHTFwNs1Mb7u7l/1mo/HzLHM+i+0Zhv4By9EWRB6eR8mGpx05yOMQDfkN
	+jsgRfpvMKB7KB0VoQMJRVA==
X-Google-Smtp-Source: AGHT+IGAF6ewttenRkml+xaJJ/R1IedLOwiGhVw0tnETAJ0OvOvKYYqUvVxcQ+fedR1ppVyyO7A1xYhoa8CnYTLk
X-Received: from pgbcs2.prod.google.com ([2002:a05:6a02:4182:b0:b2c:4bbc:1ed5])
 (user=robertpang job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:234d:b0:235:27b6:a891 with SMTP id d9443c01a7336-23601d13526mr34953925ad.28.1749194418848;
 Fri, 06 Jun 2025 00:20:18 -0700 (PDT)
Date: Fri,  6 Jun 2025 00:19:43 -0700
In-Reply-To: <20250606071959.1685079-1-robertpang@google.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250606071959.1685079-1-robertpang@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250606071959.1685079-2-robertpang@google.com>
Subject: [PATCH 1/3] lib min_heap: refactor min_heap to allow the alternative
 sift-down function to be used
From: Robert Pang <robertpang@google.com>
To: Coly Li <colyli@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcache@vger.kernel.org
Cc: Robert Pang <robertpang@google.com>, Kuan-Wei Chiu <visitorckw@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Refactor these min_heap's internal functions that require sifting down elements
to take the sift-down function to use. This change will allow for the use of
alternative sift-down strategies, potentially offering significant performance
improvements for certain data distributions compared to the current bottom-up
approach.

- heapify_all
- heap_pop
- heap_pop_push
- heap_del

Signed-off-by: Robert Pang <robertpang@google.com>
---
 include/linux/min_heap.h | 60 ++++++++++++++++++++++++++--------------
 lib/min_heap.c           | 24 ++++++++++------
 2 files changed, 56 insertions(+), 28 deletions(-)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 1160bed6579e..1fe6772170e7 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -322,22 +322,27 @@ void __min_heap_sift_up_inline(min_heap_char *heap, size_t elem_size, size_t idx
 /* Floyd's approach to heapification that is O(nr). */
 static __always_inline
 void __min_heapify_all_inline(min_heap_char *heap, size_t elem_size,
-			      const struct min_heap_callbacks *func, void *args)
+			      const struct min_heap_callbacks *func, void *args,
+			      void (*sift_down)(min_heap_char *heap, int pos, size_t elem_size,
+                                                const struct min_heap_callbacks *func, void *args))
 {
 	int i;
 
 	for (i = heap->nr / 2 - 1; i >= 0; i--)
-		__min_heap_sift_down_inline(heap, i, elem_size, func, args);
+		sift_down(heap, i, elem_size, func, args);
 }
 
 #define min_heapify_all_inline(_heap, _func, _args)	\
 	__min_heapify_all_inline(container_of(&(_heap)->nr, min_heap_char, nr),	\
-				 __minheap_obj_size(_heap), _func, _args)
+				 __minheap_obj_size(_heap), _func, _args,	\
+				 __min_heap_sift_down_inline)
 
 /* Remove minimum element from the heap, O(log2(nr)). */
 static __always_inline
 bool __min_heap_pop_inline(min_heap_char *heap, size_t elem_size,
-			   const struct min_heap_callbacks *func, void *args)
+			   const struct min_heap_callbacks *func, void *args,
+			   void (*sift_down)(min_heap_char *heap, int pos, size_t elem_size,
+                                             const struct min_heap_callbacks *func, void *args))
 {
 	void *data = heap->data;
 
@@ -347,14 +352,15 @@ bool __min_heap_pop_inline(min_heap_char *heap, size_t elem_size,
 	/* Place last element at the root (position 0) and then sift down. */
 	heap->nr--;
 	memcpy(data, data + (heap->nr * elem_size), elem_size);
-	__min_heap_sift_down_inline(heap, 0, elem_size, func, args);
+	sift_down(heap, 0, elem_size, func, args);
 
 	return true;
 }
 
 #define min_heap_pop_inline(_heap, _func, _args)	\
 	__min_heap_pop_inline(container_of(&(_heap)->nr, min_heap_char, nr),	\
-			      __minheap_obj_size(_heap), _func, _args)
+			      __minheap_obj_size(_heap), _func, _args,	\
+			      __min_heap_sift_down_inline)
 
 /*
  * Remove the minimum element and then push the given element. The
@@ -363,15 +369,18 @@ bool __min_heap_pop_inline(min_heap_char *heap, size_t elem_size,
  */
 static __always_inline
 void __min_heap_pop_push_inline(min_heap_char *heap, const void *element, size_t elem_size,
-				const struct min_heap_callbacks *func, void *args)
+				const struct min_heap_callbacks *func, void *args,
+				void (*sift_down)(min_heap_char *heap, int pos, size_t elem_size,
+                                                  const struct min_heap_callbacks *func, void *args))
 {
 	memcpy(heap->data, element, elem_size);
-	__min_heap_sift_down_inline(heap, 0, elem_size, func, args);
+	sift_down(heap, 0, elem_size, func, args);
 }
 
 #define min_heap_pop_push_inline(_heap, _element, _func, _args)	\
 	__min_heap_pop_push_inline(container_of(&(_heap)->nr, min_heap_char, nr), _element,	\
-				   __minheap_obj_size(_heap), _func, _args)
+				   __minheap_obj_size(_heap), _func, _args,	\
+				   __min_heap_sift_down_inline)
 
 /* Push an element on to the heap, O(log2(nr)). */
 static __always_inline
@@ -402,7 +411,9 @@ bool __min_heap_push_inline(min_heap_char *heap, const void *element, size_t ele
 /* Remove ith element from the heap, O(log2(nr)). */
 static __always_inline
 bool __min_heap_del_inline(min_heap_char *heap, size_t elem_size, size_t idx,
-			   const struct min_heap_callbacks *func, void *args)
+			   const struct min_heap_callbacks *func, void *args,
+			   void (*sift_down)(min_heap_char *heap, int pos, size_t elem_size,
+                                             const struct min_heap_callbacks *func, void *args))
 {
 	void *data = heap->data;
 	void (*swp)(void *lhs, void *rhs, void *args) = func->swp;
@@ -419,14 +430,15 @@ bool __min_heap_del_inline(min_heap_char *heap, size_t elem_size, size_t idx,
 		return true;
 	do_swap(data + (idx * elem_size), data + (heap->nr * elem_size), elem_size, swp, args);
 	__min_heap_sift_up_inline(heap, elem_size, idx, func, args);
-	__min_heap_sift_down_inline(heap, idx, elem_size, func, args);
+	sift_down(heap, idx, elem_size, func, args);
 
 	return true;
 }
 
 #define min_heap_del_inline(_heap, _idx, _func, _args)	\
 	__min_heap_del_inline(container_of(&(_heap)->nr, min_heap_char, nr),	\
-			      __minheap_obj_size(_heap), _idx, _func, _args)
+			      __minheap_obj_size(_heap), _idx, _func, _args,	\
+			      __min_heap_sift_down_inline))
 
 void __min_heap_init(min_heap_char *heap, void *data, int size);
 void *__min_heap_peek(struct min_heap_char *heap);
@@ -436,15 +448,23 @@ void __min_heap_sift_down(min_heap_char *heap, int pos, size_t elem_size,
 void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
 			const struct min_heap_callbacks *func, void *args);
 void __min_heapify_all(min_heap_char *heap, size_t elem_size,
-		       const struct min_heap_callbacks *func, void *args);
+		       const struct min_heap_callbacks *func, void *args,
+                       void (*sift_down)(min_heap_char *heap, int pos, size_t elem_size,
+                                         const struct min_heap_callbacks *func, void *args));
 bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
-		    const struct min_heap_callbacks *func, void *args);
+		    const struct min_heap_callbacks *func, void *args,
+                    void (*sift_down)(min_heap_char *heap, int pos, size_t elem_size,
+                                      const struct min_heap_callbacks *func, void *args));
 void __min_heap_pop_push(min_heap_char *heap, const void *element, size_t elem_size,
-			 const struct min_heap_callbacks *func, void *args);
+			 const struct min_heap_callbacks *func, void *args,
+                         void (*sift_down)(min_heap_char *heap, int pos, size_t elem_size,
+                                           const struct min_heap_callbacks *func, void *args));
 bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 		     const struct min_heap_callbacks *func, void *args);
 bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
-		    const struct min_heap_callbacks *func, void *args);
+		    const struct min_heap_callbacks *func, void *args,
+                    void (*sift_down)(min_heap_char *heap, int pos, size_t elem_size,
+                                      const struct min_heap_callbacks *func, void *args));
 
 #define min_heap_init(_heap, _data, _size)	\
 	__min_heap_init(container_of(&(_heap)->nr, min_heap_char, nr), _data, _size)
@@ -460,18 +480,18 @@ bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
 			   __minheap_obj_size(_heap), _idx, _func, _args)
 #define min_heapify_all(_heap, _func, _args)	\
 	__min_heapify_all(container_of(&(_heap)->nr, min_heap_char, nr),	\
-			  __minheap_obj_size(_heap), _func, _args)
+			  __minheap_obj_size(_heap), _func, _args, __min_heap_sift_down)
 #define min_heap_pop(_heap, _func, _args)	\
 	__min_heap_pop(container_of(&(_heap)->nr, min_heap_char, nr),	\
-		       __minheap_obj_size(_heap), _func, _args)
+		       __minheap_obj_size(_heap), _func, _args, __min_heap_sift_down)
 #define min_heap_pop_push(_heap, _element, _func, _args)	\
 	__min_heap_pop_push(container_of(&(_heap)->nr, min_heap_char, nr), _element,	\
-			    __minheap_obj_size(_heap), _func, _args)
+			    __minheap_obj_size(_heap), _func, _args, __min_heap_sift_down)
 #define min_heap_push(_heap, _element, _func, _args)	\
 	__min_heap_push(container_of(&(_heap)->nr, min_heap_char, nr), _element,	\
 			__minheap_obj_size(_heap), _func, _args)
 #define min_heap_del(_heap, _idx, _func, _args)	\
 	__min_heap_del(container_of(&(_heap)->nr, min_heap_char, nr),	\
-		       __minheap_obj_size(_heap), _idx, _func, _args)
+		       __minheap_obj_size(_heap), _idx, _func, _args, __min_heap_sift_down)
 
 #endif /* _LINUX_MIN_HEAP_H */
diff --git a/lib/min_heap.c b/lib/min_heap.c
index 4485372ff3b1..4ec425788783 100644
--- a/lib/min_heap.c
+++ b/lib/min_heap.c
@@ -35,23 +35,29 @@ void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
 EXPORT_SYMBOL(__min_heap_sift_up);
 
 void __min_heapify_all(min_heap_char *heap, size_t elem_size,
-		       const struct min_heap_callbacks *func, void *args)
+		       const struct min_heap_callbacks *func, void *args,
+		       void (*sift_down)(min_heap_char *heap, int pos, size_t elem_size,
+                                         const struct min_heap_callbacks *func, void *args))
 {
-	__min_heapify_all_inline(heap, elem_size, func, args);
+	__min_heapify_all_inline(heap, elem_size, func, args, sift_down);
 }
 EXPORT_SYMBOL(__min_heapify_all);
 
 bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
-		    const struct min_heap_callbacks *func, void *args)
+		    const struct min_heap_callbacks *func, void *args,
+		    void (*sift_down)(min_heap_char *heap, int pos, size_t elem_size,
+                                      const struct min_heap_callbacks *func, void *args))
 {
-	return __min_heap_pop_inline(heap, elem_size, func, args);
+	return __min_heap_pop_inline(heap, elem_size, func, args, sift_down);
 }
 EXPORT_SYMBOL(__min_heap_pop);
 
 void __min_heap_pop_push(min_heap_char *heap, const void *element, size_t elem_size,
-			 const struct min_heap_callbacks *func, void *args)
+			 const struct min_heap_callbacks *func, void *args,
+			 void (*sift_down)(min_heap_char *heap, int pos, size_t elem_size,
+                                           const struct min_heap_callbacks *func, void *args))
 {
-	__min_heap_pop_push_inline(heap, element, elem_size, func, args);
+	__min_heap_pop_push_inline(heap, element, elem_size, func, args, sift_down);
 }
 EXPORT_SYMBOL(__min_heap_pop_push);
 
@@ -63,8 +69,10 @@ bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 EXPORT_SYMBOL(__min_heap_push);
 
 bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
-		    const struct min_heap_callbacks *func, void *args)
+		    const struct min_heap_callbacks *func, void *args,
+		    void (*sift_down)(min_heap_char *heap, int pos, size_t elem_size,
+                                      const struct min_heap_callbacks *func, void *args))
 {
-	return __min_heap_del_inline(heap, elem_size, idx, func, args);
+	return __min_heap_del_inline(heap, elem_size, idx, func, args, sift_down);
 }
 EXPORT_SYMBOL(__min_heap_del);
-- 
2.50.0.rc1.591.g9c95f17f64-goog


