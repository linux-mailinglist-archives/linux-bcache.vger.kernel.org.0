Return-Path: <linux-bcache+bounces-766-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B49419A5237
	for <lists+linux-bcache@lfdr.de>; Sun, 20 Oct 2024 06:03:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA3BF1C21217
	for <lists+linux-bcache@lfdr.de>; Sun, 20 Oct 2024 04:03:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37D05F9D6;
	Sun, 20 Oct 2024 04:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VdpKhCLf"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A91229CE7;
	Sun, 20 Oct 2024 04:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729396959; cv=none; b=QUIaUB6i2c3CMFXanB9XbpxLEF4Z42DA6DKTY/8Z0YjQxrsLmhZqm0aayv2N4KOtaBvxrM/jzABjxXGH8hH9SFjlMow8EIR2/u0k+1lzCH3F03BFy9v9RYIL3AtC/hO7pLYEGy/JaDypjABTXsulHFGGaPvwUlu099XqdT2u69w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729396959; c=relaxed/simple;
	bh=qw7hRUVQUjmF1vm384Re4kBa8L2DFdqc5hxtKTyAUBc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fpjYiJ+6vT4tHcFgi5g5AOF81gPc3PsSiN0VY4WIw5OPPJgcuuNavaspXMewG1g69rnIDxYtrYjCjScuBd/5rgFsfQaranPmXsBHdaYGc9IPspevGgn3Vy8UEobBTlTPQCR6Lj5xspfduzEMnbfMGWVc5vPd3r8Ye5bwHuVmWKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VdpKhCLf; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-7db908c9c83so2156840a12.2;
        Sat, 19 Oct 2024 21:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729396956; x=1730001756; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y6nVlRSYluEaO2jXun3j/1xuNdrqdaSLggEauAQK2do=;
        b=VdpKhCLfZxoY2kVgdl1E7VD0I2A4L51eyL9RzRRGHgHqfa06wX7/KPqJXSAvnv0S6K
         B5sdfq1wHqDtJjqTDmGp20eGipoPrZF6THFng5nA3oyGqMJVeBIXPNf7KPMaOsyMm0v/
         hj5Ga/0YvcFQd/CZHasWxT62/apxSt4IlGWOCleuNwI0ohZICSJ6OD1rzEqcgGHvpuAe
         uPJc8wofygrJ22rkWhwW+G4m2XtJO3bW8N2HFFnE90y4r7Y6H4ZZm7cl63/Lbo4cQRY2
         XFJi7N0UNuXI38PZOsellWToTdi1LE0mcoFmw5MRVM2Pnb9FEhNI3dAZfsSWSf5i67z/
         8O/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729396956; x=1730001756;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y6nVlRSYluEaO2jXun3j/1xuNdrqdaSLggEauAQK2do=;
        b=veq9ywHEQf1PKIGuVTwDXW/dKN4fLyoP0qWurfZ74ghEu9FTBc3pxD4d5Gn1IrAWzE
         Cr4PYCC1F+W75DudCIfbVg2TBJjoBAVZdH28xTXUYdx9jxNyrvxCY/3RnCDPXIHmKuMH
         ny+WTFb/5NB4MZNQpzzvEbE7Y69TyDUZ7L1zYYeAryV3NaGPT0V0CAh25En3TwPxVPyk
         YWbUjflPWeYOw01OOLHu05bvfVDs5r5WNsKIGHf1plijSAhyIumPYwaCFS5gB4V7qBwU
         qkmMIXs2RGmgSeYKWaGT3THGJNVRhL9EAeqxA7ut3u12U7/1gF+lp+RraYxFtZ9zAtrg
         dm2g==
X-Forwarded-Encrypted: i=1; AJvYcCU5W11L23oD1XlMXcN8rAqRjmR0irznd4JkPyAg5W8z6oDYIMtZe88V2jPLy+TZdHsnJOuVYdZ94aKEZapIxiD+nQ==@vger.kernel.org, AJvYcCUWSK/INRBZznTUud+WcngoixBwMe7MGeA224am0VP7Y8WXmfsirsCfH6eIxAr/O7vVLBEb15ZzmIqs@vger.kernel.org, AJvYcCVVO0aRqhD6T9gAAjs2uBMq/58cJlcVgZxB+j4hOo1RQpYEl4HgG6iMKRf0lT65tiGqYiMytSf/VztSreFl@vger.kernel.org, AJvYcCVx/EKJVqTtPBJkGGj/pf3Nr/NWj1ycQLDvdRZY0vBjok6HqC00rsjBreOEa8oowoacwcQ/zWVkoPw/8q2rc8Q=@vger.kernel.org, AJvYcCXyRUju3rTd0jKBhONJ3oprqlltbNBSF6HUfmP4TaKVMLv4/aOM4Kgx1syowmAiDVGWWTy0hehqNyh8Lgk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWp30Cinni3ScNENXUCtZz5J/MC5IxOhS7CmBo68rEb6t1aCj6
	1imYE6rIdxliim37gi74E0IvyrXsl6nAiR6V/HXNVPvHP4mtKCsL
X-Google-Smtp-Source: AGHT+IGJ0QD1dssfSeCndTdayTApxMhbahdeVkUz635rlYogw/K2EEenKLVPZ19fI4axaD2q8F/SrA==
X-Received: by 2002:a17:90b:1183:b0:2e1:ce7b:6069 with SMTP id 98e67ed59e1d1-2e56190237fmr8607444a91.33.1729396956275;
        Sat, 19 Oct 2024 21:02:36 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad3678d3sm633668a91.24.2024.10.19.21.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2024 21:02:35 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: colyli@suse.de,
	kent.overstreet@linux.dev,
	msakai@redhat.com,
	corbet@lwn.net,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	akpm@linux-foundation.org
Cc: mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	kan.liang@linux.intel.com,
	willy@infradead.org,
	jserv@ccns.ncku.edu.tw,
	linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH v2 03/10] lib min_heap: Avoid indirect function call by providing default swap
Date: Sun, 20 Oct 2024 12:01:53 +0800
Message-Id: <20241020040200.939973-4-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241020040200.939973-1-visitorckw@gmail.com>
References: <20241020040200.939973-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The non-inline min heap API can result in an indirect function call to
the custom swap function. This becomes particularly costly when
CONFIG_MITIGATION_RETPOLINE is enabled, as indirect function calls are
expensive in this case.

To address this, copy the code from lib/sort.c and provide a default
builtin swap implementation that performs element swaps based on the
element size. This change allows most users to avoid the overhead of
indirect function calls, improving efficiency.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 include/linux/min_heap.h | 159 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 156 insertions(+), 3 deletions(-)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 41b092a14238..e781727c8916 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -38,6 +38,147 @@ struct min_heap_callbacks {
 	void (*swp)(void *lhs, void *rhs, void *args);
 };
 
+/**
+ * is_aligned - is this pointer & size okay for word-wide copying?
+ * @base: pointer to data
+ * @size: size of each element
+ * @align: required alignment (typically 4 or 8)
+ *
+ * Returns true if elements can be copied using word loads and stores.
+ * The size must be a multiple of the alignment, and the base address must
+ * be if we do not have CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS.
+ *
+ * For some reason, gcc doesn't know to optimize "if (a & mask || b & mask)"
+ * to "if ((a | b) & mask)", so we do that by hand.
+ */
+__attribute_const__ __always_inline
+static bool is_aligned(const void *base, size_t size, unsigned char align)
+{
+	unsigned char lsbits = (unsigned char)size;
+
+	(void)base;
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	lsbits |= (unsigned char)(uintptr_t)base;
+#endif
+	return (lsbits & (align - 1)) == 0;
+}
+
+/**
+ * swap_words_32 - swap two elements in 32-bit chunks
+ * @a: pointer to the first element to swap
+ * @b: pointer to the second element to swap
+ * @n: element size (must be a multiple of 4)
+ *
+ * Exchange the two objects in memory.  This exploits base+index addressing,
+ * which basically all CPUs have, to minimize loop overhead computations.
+ *
+ * For some reason, on x86 gcc 7.3.0 adds a redundant test of n at the
+ * bottom of the loop, even though the zero flag is still valid from the
+ * subtract (since the intervening mov instructions don't alter the flags).
+ * Gcc 8.1.0 doesn't have that problem.
+ */
+static __always_inline
+void swap_words_32(void *a, void *b, size_t n)
+{
+	do {
+		u32 t = *(u32 *)(a + (n -= 4));
+		*(u32 *)(a + n) = *(u32 *)(b + n);
+		*(u32 *)(b + n) = t;
+	} while (n);
+}
+
+/**
+ * swap_words_64 - swap two elements in 64-bit chunks
+ * @a: pointer to the first element to swap
+ * @b: pointer to the second element to swap
+ * @n: element size (must be a multiple of 8)
+ *
+ * Exchange the two objects in memory.  This exploits base+index
+ * addressing, which basically all CPUs have, to minimize loop overhead
+ * computations.
+ *
+ * We'd like to use 64-bit loads if possible.  If they're not, emulating
+ * one requires base+index+4 addressing which x86 has but most other
+ * processors do not.  If CONFIG_64BIT, we definitely have 64-bit loads,
+ * but it's possible to have 64-bit loads without 64-bit pointers (e.g.
+ * x32 ABI).  Are there any cases the kernel needs to worry about?
+ */
+static __always_inline
+void swap_words_64(void *a, void *b, size_t n)
+{
+	do {
+#ifdef CONFIG_64BIT
+		u64 t = *(u64 *)(a + (n -= 8));
+		*(u64 *)(a + n) = *(u64 *)(b + n);
+		*(u64 *)(b + n) = t;
+#else
+		/* Use two 32-bit transfers to avoid base+index+4 addressing */
+		u32 t = *(u32 *)(a + (n -= 4));
+		*(u32 *)(a + n) = *(u32 *)(b + n);
+		*(u32 *)(b + n) = t;
+
+		t = *(u32 *)(a + (n -= 4));
+		*(u32 *)(a + n) = *(u32 *)(b + n);
+		*(u32 *)(b + n) = t;
+#endif
+	} while (n);
+}
+
+/**
+ * swap_bytes - swap two elements a byte at a time
+ * @a: pointer to the first element to swap
+ * @b: pointer to the second element to swap
+ * @n: element size
+ *
+ * This is the fallback if alignment doesn't allow using larger chunks.
+ */
+static __always_inline
+void swap_bytes(void *a, void *b, size_t n)
+{
+	do {
+		char t = ((char *)a)[--n];
+		((char *)a)[n] = ((char *)b)[n];
+		((char *)b)[n] = t;
+	} while (n);
+}
+
+/*
+ * The values are arbitrary as long as they can't be confused with
+ * a pointer, but small integers make for the smallest compare
+ * instructions.
+ */
+#define SWAP_WORDS_64 ((void (*)(void *, void *, void *))0)
+#define SWAP_WORDS_32 ((void (*)(void *, void *, void *))1)
+#define SWAP_BYTES    ((void (*)(void *, void *, void *))2)
+
+/*
+ * Selects the appropriate swap function based on the element size.
+ */
+static __always_inline
+void *select_swap_func(const void *base, size_t size)
+{
+	if (is_aligned(base, size, 8))
+		return SWAP_WORDS_64;
+	else if (is_aligned(base, size, 4))
+		return SWAP_WORDS_32;
+	else
+		return SWAP_BYTES;
+}
+
+static __always_inline
+void do_swap(void *a, void *b, size_t size, void (*swap_func)(void *lhs, void *rhs, void *args),
+	     void *priv)
+{
+	if (swap_func == SWAP_WORDS_64)
+		swap_words_64(a, b, size);
+	else if (swap_func == SWAP_WORDS_32)
+		swap_words_32(a, b, size);
+	else if (swap_func == SWAP_BYTES)
+		swap_bytes(a, b, size);
+	else
+		swap_func(a, b, priv);
+}
+
 /**
  * parent - given the offset of the child, find the offset of the parent.
  * @i: the offset of the heap element whose parent is sought.  Non-zero.
@@ -106,11 +247,15 @@ void __min_heap_sift_down_inline(min_heap_char *heap, int pos, size_t elem_size,
 {
 	const unsigned long lsbit = elem_size & -elem_size;
 	void *data = heap->data;
+	void (*swp)(void *lhs, void *rhs, void *args) = func->swp;
 	/* pre-scale counters for performance */
 	size_t a = pos * elem_size;
 	size_t b, c, d;
 	size_t n = heap->nr * elem_size;
 
+	if (!swp)
+		swp = select_swap_func(data, elem_size);
+
 	/* Find the sift-down path all the way to the leaves. */
 	for (b = a; c = 2 * b + elem_size, (d = c + elem_size) < n;)
 		b = func->less(data + c, data + d, args) ? c : d;
@@ -127,7 +272,7 @@ void __min_heap_sift_down_inline(min_heap_char *heap, int pos, size_t elem_size,
 	c = b;
 	while (b != a) {
 		b = parent(b, lsbit, elem_size);
-		func->swp(data + b, data + c, args);
+		do_swap(data + b, data + c, elem_size, swp, args);
 	}
 }
 
@@ -142,14 +287,18 @@ void __min_heap_sift_up_inline(min_heap_char *heap, size_t elem_size, size_t idx
 {
 	const unsigned long lsbit = elem_size & -elem_size;
 	void *data = heap->data;
+	void (*swp)(void *lhs, void *rhs, void *args) = func->swp;
 	/* pre-scale counters for performance */
 	size_t a = idx * elem_size, b;
 
+	if (!swp)
+		swp = select_swap_func(data, elem_size);
+
 	while (a) {
 		b = parent(a, lsbit, elem_size);
 		if (func->less(data + b, data + a, args))
 			break;
-		func->swp(data + a, data + b, args);
+		do_swap(data + a, data + b, elem_size, swp, args);
 		a = b;
 	}
 }
@@ -242,15 +391,19 @@ bool __min_heap_del_inline(min_heap_char *heap, size_t elem_size, size_t idx,
 			   const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
+	void (*swp)(void *lhs, void *rhs, void *args) = func->swp;
 
 	if (WARN_ONCE(heap->nr <= 0, "Popping an empty heap"))
 		return false;
 
+	if (!swp)
+		swp = select_swap_func(data, elem_size);
+
 	/* Place last element at the root (position 0) and then sift down. */
 	heap->nr--;
 	if (idx == heap->nr)
 		return true;
-	func->swp(data + (idx * elem_size), data + (heap->nr * elem_size), args);
+	do_swap(data + (idx * elem_size), data + (heap->nr * elem_size), elem_size, swp, args);
 	__min_heap_sift_up_inline(heap, elem_size, idx, func, args);
 	__min_heap_sift_down_inline(heap, idx, elem_size, func, args);
 
-- 
2.34.1


