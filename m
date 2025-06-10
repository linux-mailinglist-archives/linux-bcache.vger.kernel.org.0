Return-Path: <linux-bcache+bounces-1119-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CCDBEAD4527
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Jun 2025 23:56:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADC98189DB18
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Jun 2025 21:56:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D570288C37;
	Tue, 10 Jun 2025 21:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fxDzqCcd"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84040288C00;
	Tue, 10 Jun 2025 21:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749592553; cv=none; b=Gl/YTgqxdXIwwq+ZY+mCqbKIKcZAyILYMAffCuo9k1L5e943wExLAydSnccTGMpgqGOcuhWqOMtcE+mX5ZQljFnIIrx5g5w/8FS5CMe9TrUBFma0lCdcKYmmDqk1js0k3xru8xLmi99D3xJUXkSrewHGpqIVMun9nMmBSgBTE7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749592553; c=relaxed/simple;
	bh=Y+UPitxuPnSQD3MhPw5JIcyU1vXDtlvyzvdhusxr2Fk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AeGzn75/o3NUb6Ep7SkkDW++XNPyBnrsXIO5/DMFrmEvvrApESgJrJ/JIaQFkID5xgdVcIrw4ZJLg9vDkLt/98ka+tDxbQ3KqT4ppmcxYOaIjhQMUlmRQVI5OdhrBs9t/BEILdu5j9cTqbv8qc/TVBrM07tT6KDfzWlLlo+FBm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fxDzqCcd; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-745fe311741so6536299b3a.0;
        Tue, 10 Jun 2025 14:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749592551; x=1750197351; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2TAQRQZLsTcJLvoXFgshBC4GHe/WMIKfuLkFw+VPiR0=;
        b=fxDzqCcduxN2i8DM/GGfM7lg0ZbZ5+e4h1/wK1ZZwmbNZpb0WJ9weQuXcxGnFxDVWB
         VTenomm1DmXY0CrjIpRr8QRJMVaCMJBwzj9wsDacbP+EiRKyTGjQk93JvsFaguH0678S
         rSQ/aWf2vVE66Oe8kwtNUY/eroMhEFhIWjbuC1gKAof9TCnLxvZ1Pk5NAWb+cWEhcXL5
         WGRwCUv7jN3aCKKCwKpe+hixXvFe7qKHL0cwPVkPVQ98aVl7mh1qNvTa0SxufumqOLf0
         W7erqP/X4Ik1W3cqNgKq+AnWSnzctxfpCBAS/gM85ic5mHNDCxMsDuqFfWE09l/6dQJq
         WLAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749592551; x=1750197351;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2TAQRQZLsTcJLvoXFgshBC4GHe/WMIKfuLkFw+VPiR0=;
        b=PK+zVlgM29X4EGlQrYBtVAhn6MWVWIuOJ9pOZvMmkldjdvDk3iaLhs56KZXKhkfoKK
         5wpUiEi/qiTJ4FGwhWSLit8Jy/g8q/bzJFFILsOZYvbYpkpP+oOpGDEjPWcfRwqPXF5Z
         +yODOwtKUhrKSAP3yX430cBrfga87i5eweMuIL854LkzsLj3yBGf8+Zy4RP5ZD7EnKDv
         6U62i8ruU9ezKi+RUQFgJWYA4wMsn7TxbYxG4eLbWs/BGpv38/42kQIDnRobYJI95uXv
         yP3Z7s2ZVy3eguRjt1i3FpZK2KFv/nNwfaqntfYeutfA1Ww2D+HgPI8fP1H3mFqt1PjH
         KYog==
X-Forwarded-Encrypted: i=1; AJvYcCV4hkyFYhH9xX2YNQjVEptk0sjXL0QsdPo6i4sOQveqNLZt2auZH6JHkIPqIpzY31sZuPp4tjkyCTpe@vger.kernel.org, AJvYcCWSRTmLJxCHtPDEm52v/2NToNVWMCvJIehhFGFYwJKYUxHrwyjdR/HZc+w76qkD1DC1L605rAiW@vger.kernel.org, AJvYcCXkM7jsq5pngaarNlPQXvIWp/9ugoZ9Rsr+UJ2tuWjqr2uNES+AH9GBmrwSEItqWThUYJAzrR4Afn4rrjU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZJhmN0gcUSWaLSEYRevVPjr1I4HV/cVdXmXegqPcbSw7WADyW
	HcpLE3H7murWPMEvhTH513XbvsqZ0ROA0jDylfB0eMzmnczo8Q9hVg3r
X-Gm-Gg: ASbGnctEHKGzvzxaaAh7wmZhZLUSCE60I3zFB+H2FJm1mcYC4qAsjPJX1o5ORVPTWWL
	f9Q7rDZ+qOWLVDZLhrEjHMY14Bz4qYdn9CGo4W+Vp0bklMn8XXtE4c5t/FBbnV0hbhhQOjmkOSt
	kJHeLfg/gmAFgM5L3MYMmFlS4azofRBjSst3OMScwfkegn4htBjUkl4xkbxM4lj/nuh0z3vkWKP
	qXzLP1E3Hm9zTJJar81hkrYAsBG22HGuwNMkzbu0vvZhRMRv13If4COnmtVDBf3oq20iCFxMrYS
	kpWsbqxQMCvmeYTysmUx5jKcEcS9YMsoLAEQRBCPo/rp5cD+uhZXH3osmbQRRTxAEDxbRzAPsrt
	2LNI4C4ReX0jLW7Lr
X-Google-Smtp-Source: AGHT+IFW06kBchqN/i7/VJIqNBJDn3AyaGauP4nINNREfEpW9XlqotbLEMye0niWS0kAsKlPX18+kA==
X-Received: by 2002:a05:6a20:9146:b0:21f:4ecc:11b7 with SMTP id adf61e73a8af0-21f86752068mr1854118637.36.1749592550617;
        Tue, 10 Jun 2025 14:55:50 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482af3a165sm8173936b3a.11.2025.06.10.14.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 14:55:50 -0700 (PDT)
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
Subject: [PATCH 3/8] lib min_heap: add eqaware variant of min_heapify_all()
Date: Wed, 11 Jun 2025 05:55:11 +0800
Message-Id: <20250610215516.1513296-4-visitorckw@gmail.com>
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

Introduce min_heapify_all_eqaware() as a variant of min_heapify_all()
that uses the equality-aware version of sift_down, which is implemented
in a top-down manner.

This top-down sift_down reduces the number of comparisons from
O(log2(n)) to O(1) in cases where many elements have equal priority. It
enables more efficient heap construction when the heap contains a large
number of equal elements.

Cc: stable@vger.kernel.org # 6.11+
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 include/linux/min_heap.h | 19 ++++++++++++++-----
 lib/min_heap.c           |  4 ++--
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 4cd8fd9db259..c2f6e1450505 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -371,17 +371,23 @@ void __min_heap_sift_up_inline(min_heap_char *heap, size_t elem_size, size_t idx
 /* Floyd's approach to heapification that is O(nr). */
 static __always_inline
 void __min_heapify_all_inline(min_heap_char *heap, size_t elem_size,
-			      const struct min_heap_callbacks *func, void *args)
+			      const struct min_heap_callbacks *func, void *args, bool eqaware)
 {
 	ssize_t i;
+	siftdown_fn_t sift_down = eqaware ? __min_heap_sift_down_eqaware_inline :
+					    __min_heap_sift_down_inline;
 
 	for (i = heap->nr / 2 - 1; i >= 0; i--)
-		__min_heap_sift_down_inline(heap, i, elem_size, func, args);
+		sift_down(heap, i, elem_size, func, args);
 }
 
 #define min_heapify_all_inline(_heap, _func, _args)	\
 	__min_heapify_all_inline(container_of(&(_heap)->nr, min_heap_char, nr),	\
-				 __minheap_obj_size(_heap), _func, _args)
+				 __minheap_obj_size(_heap), _func, _args, false)
+
+#define min_heapify_all_eqaware_inline(_heap, _func, _args)	\
+	__min_heapify_all_inline(container_of(&(_heap)->nr, min_heap_char, nr),	\
+				 __minheap_obj_size(_heap), _func, _args, true)
 
 /* Remove minimum element from the heap, O(log2(nr)). */
 static __always_inline
@@ -487,7 +493,7 @@ void __min_heap_sift_down_eqaware(min_heap_char *heap, size_t pos, size_t elem_s
 void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
 			const struct min_heap_callbacks *func, void *args);
 void __min_heapify_all(min_heap_char *heap, size_t elem_size,
-		       const struct min_heap_callbacks *func, void *args);
+		       const struct min_heap_callbacks *func, void *args, bool eqaware);
 bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
 		    const struct min_heap_callbacks *func, void *args);
 void __min_heap_pop_push(min_heap_char *heap, const void *element, size_t elem_size,
@@ -514,7 +520,10 @@ bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
 			   __minheap_obj_size(_heap), _idx, _func, _args)
 #define min_heapify_all(_heap, _func, _args)	\
 	__min_heapify_all(container_of(&(_heap)->nr, min_heap_char, nr),	\
-			  __minheap_obj_size(_heap), _func, _args)
+			  __minheap_obj_size(_heap), _func, _args, false)
+#define min_heapify_all_eqaware(_heap, _func, _args)	\
+	__min_heapify_all(container_of(&(_heap)->nr, min_heap_char, nr),	\
+			  __minheap_obj_size(_heap), _func, _args, true)
 #define min_heap_pop(_heap, _func, _args)	\
 	__min_heap_pop(container_of(&(_heap)->nr, min_heap_char, nr),	\
 		       __minheap_obj_size(_heap), _func, _args)
diff --git a/lib/min_heap.c b/lib/min_heap.c
index 2225f40d0d7a..a422cfaff196 100644
--- a/lib/min_heap.c
+++ b/lib/min_heap.c
@@ -42,9 +42,9 @@ void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
 EXPORT_SYMBOL(__min_heap_sift_up);
 
 void __min_heapify_all(min_heap_char *heap, size_t elem_size,
-		       const struct min_heap_callbacks *func, void *args)
+		       const struct min_heap_callbacks *func, void *args, bool eqaware)
 {
-	__min_heapify_all_inline(heap, elem_size, func, args);
+	__min_heapify_all_inline(heap, elem_size, func, args, eqaware);
 }
 EXPORT_SYMBOL(__min_heapify_all);
 
-- 
2.34.1


