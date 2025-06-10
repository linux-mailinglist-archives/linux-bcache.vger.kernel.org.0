Return-Path: <linux-bcache+bounces-1117-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 33C8CAD451E
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Jun 2025 23:56:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A520D3A30E1
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Jun 2025 21:55:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0E6128750F;
	Tue, 10 Jun 2025 21:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SqbVU2WX"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D592868B8;
	Tue, 10 Jun 2025 21:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749592546; cv=none; b=bSyJxSnq35lu9u7HQ+wDGAb+rdC7wU4vkL+pWzMb0FwJXSXMq8m+Vc+eDkmMVy0Gt8Oz5dmqQJDGJCPzPAMAH8NBPJFASs5sPWj2+qyF7+B+fJOApeyOiSL8En39uN/GGKSeH0ZYPfXK00WqT2wz97ry1GL+j71Fbg8EoB8Vaqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749592546; c=relaxed/simple;
	bh=xSFaRyhDOAam6TAkmDf6Ay5XVOGwTDA8ApGZTlJop40=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oS12wUiPr7ywwAXbQrvpzma8qw09VseISC8hdrHAbgk9kv/Wu9Iy8WSgJanMrD/xRutUkW9WoYAektBjk93A4Z8JlggJiDXIVPjmX/bt1IMdHCATAiFHijp0wi7YzfPxBGO8yAG0gRBLxJceNbbumfgxkRK12EF+DMD/la48IlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SqbVU2WX; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-747e41d5469so6414324b3a.3;
        Tue, 10 Jun 2025 14:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749592544; x=1750197344; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WBfxcFZ5TJu43c65Lqw/lArQXlQRpXwLpryErfl271U=;
        b=SqbVU2WXCW/7zzG7rVXxgcK4BLmsTWa/SA7D5AcrnLgaIrFAuJpufexT0E+2/VQCD3
         KUM8ZZwsEceRXNNcHabRvE27Y5xDS8DuU6br6s2hh8PQ8ZvbYyig+8yS3lIPSEjyQRgf
         effqcKdviFvMomlc7uBPNXHdJoxQs8QT7F66K+5icCIrSDpWE9cZjPb06YAqfCH/Mm2X
         bx73o3ZWg4NoinC7kIE0SNdHj75ncFgb6RAUvKU0M5GVywPkUBgW4qXicFGmaIQ3K8rw
         dtVLkegf2ldT5XYdvDl0SKLQPuz6rCHYgiwS1RXUPkMYLhQzNgPaBVvPG78zGBmk2K76
         /+vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749592544; x=1750197344;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WBfxcFZ5TJu43c65Lqw/lArQXlQRpXwLpryErfl271U=;
        b=iSXHOSt2ehzK0nLhQyMKJQQzxb6wndECDQ1OYH+PvNwoX4G1zKwD2+z+4czVNB36j3
         sN7VpKs/ewL3h5syRIIuvVVMfTDWUDjuWt+Kux69eicvMM6SpuCAXfG7DX13W69Z9Cod
         sbqLzH/SSvPo23zll9+SRM7QOT3GwvMZsnWb0f+3nFaDHFjShNxpLknXoT2eWPyDne9d
         ddT0LCxpmNwnJtYDbTsY8EXmy251L24PFSBI6+UrkBGo1UoIOSef6h/pKKI3VzSwIb9N
         7EV1v2iPupdxzySJaPgDD68rw0IDf1bJB4gAeFZfWBD+unaHqR1AweMuCADZElbMS+Rz
         Pong==
X-Forwarded-Encrypted: i=1; AJvYcCWYZ6N2wiPqSISQhyuHFOT3/9XG4vmuDoCP/IIOfnHWosdL/BXXrKGIhasSMnB6OYUk4UZnyLG5KjcB@vger.kernel.org, AJvYcCX7lRDeI7Fl0SNorA7HhrWwJtq+7U51OMNXM/nAYzkZcjZ1kO5P8OemkgroCyny5YnklvlxOPMHmtntMxk=@vger.kernel.org, AJvYcCXDV7XcDTTC/KNDDl7Mm4icPFAagveUrwGb8fFzmEq2jKfaiZ2kySpZz2tB638+P5FaeI2gmi1C@vger.kernel.org
X-Gm-Message-State: AOJu0YxFZ/GFS8C+B8BaLpo1NLUusAus7axx/niy6MWg4Vi6uhGPG9G9
	FpwFjTlVz4DeQlJ0bOzalhnctOUC37+44fOFgZEAMhWTI76cn73CDyqE
X-Gm-Gg: ASbGncvsK8wPWWlvsAsuALn2xouLm3d2heGCxdntnQlk9yKxyWgUGZ/W2gm2sMRFwHF
	S1TewJVmRxgO4tp9pC0TXZzBWQv/4f2WpYNbXJgNfgHzCwgOppJG2ve+EWxR5HRDnGDBQdG/Ae9
	dHkIN10JdD5mkJBtLIzg6PA2bqRIsMLk9ugiSbiHdTs1RR1CzAMRfAEu9m8nhgBUxRC30kZr+ZC
	0Ct7MwNhjv8tkxHttStADaL1IyDIaGHI2wsBrUFM77drjMsmuQ92waxAxDzZ+gmtFr8K5tLrIeo
	DoF5tJaIxYaoKWVbaA08893Ob00a6SeztooHg4bhA51WjvbmuHHYBaWrIe/2SdqSzzxH1K76DZr
	WP8Zq4FLUtO3zuuIBj7uiHFKaleA=
X-Google-Smtp-Source: AGHT+IHfwIigBjgibklgcJuguzrbWf6+UoX2nHOiZvQ6u6fCMZ4arEuQ36frRT0ygVJG9GPE/wUREg==
X-Received: by 2002:a05:6a00:22cf:b0:736:a8db:93b4 with SMTP id d2e1a72fcca58-7486cb7f7c3mr1408485b3a.2.1749592544457;
        Tue, 10 Jun 2025 14:55:44 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482af3a165sm8173936b3a.11.2025.06.10.14.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 14:55:44 -0700 (PDT)
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
Subject: [PATCH 1/8] lib min_heap: Add equal-elements-aware sift_down variant
Date: Wed, 11 Jun 2025 05:55:09 +0800
Message-Id: <20250610215516.1513296-2-visitorckw@gmail.com>
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

The existing min_heap_sift_down() uses the bottom-up heapify variant,
which reduces the number of comparisons from ~2 * log2(n) to
~1 * log2(n) when all elements are distinct. However, in workloads
where the heap contains many equal elements, this bottom-up variant
can degenerate and perform up to 2 * log2(n) comparisons, while the
traditional top-down variant needs only O(1) comparisons in such cases.

To address this, introduce min_heap_sift_down_eqaware(), a top-down
heapify variant optimized for scenarios with many equal elements. This
variant avoids unnecessary comparisons and swaps when elements are
already equal or in the correct position.

Cc: stable@vger.kernel.org # 6.11+
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 include/linux/min_heap.h | 51 ++++++++++++++++++++++++++++++++++++++++
 lib/min_heap.c           |  7 ++++++
 2 files changed, 58 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 79ddc0adbf2b..b0d603fe5379 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -292,6 +292,52 @@ void __min_heap_sift_down_inline(min_heap_char *heap, size_t pos, size_t elem_si
 	__min_heap_sift_down_inline(container_of(&(_heap)->nr, min_heap_char, nr), _pos,	\
 				    __minheap_obj_size(_heap), _func, _args)
 
+/*
+ * Sift the element at pos down the heap.
+ *
+ * Variants of heap functions using an equal-elements-aware sift_down.
+ * These may perform better when the heap contains many equal elements.
+ */
+static __always_inline
+void __min_heap_sift_down_eqaware_inline(min_heap_char * heap, size_t pos, size_t elem_size,
+					 const struct min_heap_callbacks *func, void *args)
+{
+	void *data = heap->data;
+	void (*swp)(void *lhs, void *rhs, void *args) = func->swp;
+	/* pre-scale counters for performance */
+	size_t a = pos * elem_size;
+	size_t b, c, smallest;
+	size_t n = heap->nr * elem_size;
+
+	if (!swp)
+		swp = select_swap_func(data, elem_size);
+
+	for (;;) {
+		b = 2 * a + elem_size;
+		c = b + elem_size;
+		smallest = a;
+
+		if (b >= n)
+			break;
+
+		if (func->less(data + b, data + smallest, args))
+			smallest = b;
+
+		if (c < n && func->less(data + c, data + smallest, args))
+			smallest = c;
+
+		if (smallest == a)
+			break;
+
+		do_swap(data + a, data + smallest, elem_size, swp, args);
+		a = smallest;
+	}
+}
+
+#define min_heap_sift_down_eqaware_inline(_heap, _pos, _func, _args)	\
+	__min_heap_sift_down_inline(container_of(&(_heap)->nr, min_heap_char, nr), _pos,	\
+				    __minheap_obj_size(_heap), _func, _args)
+
 /* Sift up ith element from the heap, O(log2(nr)). */
 static __always_inline
 void __min_heap_sift_up_inline(min_heap_char *heap, size_t elem_size, size_t idx,
@@ -433,6 +479,8 @@ void *__min_heap_peek(struct min_heap_char *heap);
 bool __min_heap_full(min_heap_char *heap);
 void __min_heap_sift_down(min_heap_char *heap, size_t pos, size_t elem_size,
 			  const struct min_heap_callbacks *func, void *args);
+void __min_heap_sift_down_eqaware(min_heap_char *heap, size_t pos, size_t elem_size,
+				  const struct min_heap_callbacks *func, void *args);
 void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
 			const struct min_heap_callbacks *func, void *args);
 void __min_heapify_all(min_heap_char *heap, size_t elem_size,
@@ -455,6 +503,9 @@ bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
 #define min_heap_sift_down(_heap, _pos, _func, _args)	\
 	__min_heap_sift_down(container_of(&(_heap)->nr, min_heap_char, nr), _pos,	\
 			     __minheap_obj_size(_heap), _func, _args)
+#define min_heap_sift_down_eqaware(_heap, _pos, _func, _args)	\
+	__min_heap_sift_down_eqaware(container_of(&(_heap)->nr, min_heap_char, nr), _pos,	\
+			     __minheap_obj_size(_heap), _func, _args)
 #define min_heap_sift_up(_heap, _idx, _func, _args)	\
 	__min_heap_sift_up(container_of(&(_heap)->nr, min_heap_char, nr),	\
 			   __minheap_obj_size(_heap), _idx, _func, _args)
diff --git a/lib/min_heap.c b/lib/min_heap.c
index 96f01a4c5fb6..2225f40d0d7a 100644
--- a/lib/min_heap.c
+++ b/lib/min_heap.c
@@ -27,6 +27,13 @@ void __min_heap_sift_down(min_heap_char *heap, size_t pos, size_t elem_size,
 }
 EXPORT_SYMBOL(__min_heap_sift_down);
 
+void __min_heap_sift_down_eqaware(min_heap_char *heap, size_t pos, size_t elem_size,
+				  const struct min_heap_callbacks *func, void *args)
+{
+	__min_heap_sift_down_eqaware_inline(heap, pos, elem_size, func, args);
+}
+EXPORT_SYMBOL(__min_heap_sift_down_eqaware);
+
 void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
 			const struct min_heap_callbacks *func, void *args)
 {
-- 
2.34.1


