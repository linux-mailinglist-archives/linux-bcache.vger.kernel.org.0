Return-Path: <linux-bcache+bounces-765-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 91CA79A5233
	for <lists+linux-bcache@lfdr.de>; Sun, 20 Oct 2024 06:03:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 142931F22BFE
	for <lists+linux-bcache@lfdr.de>; Sun, 20 Oct 2024 04:03:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 211F217543;
	Sun, 20 Oct 2024 04:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AS3cRmF+"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34778FC0A;
	Sun, 20 Oct 2024 04:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729396954; cv=none; b=JmJGsNTeRbJI7+O3f7NYXRGVg7ERwYL87vkuOLGVSK6/IWxybYzA1JDlE9hjZrln7mbxOamsOv53BmimXcxo/zUqLxur5uxWgzBe0xYguffAYzICIerueYN4btqAO5PiOjDoQQ0VHfsilDPRKrSMqkILNRzpSFn84cGe9fxy4CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729396954; c=relaxed/simple;
	bh=bcureVGzcJTl4EGz6UOvdZmrS2DwQAd4xqIXv8oXxmU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=c5Q6i9tvbmjXCkdBWuuAiDuXefGddchn9L65/2hMN1kiKnAco9cLdpOmxfr0SFQYIHXm/dR8s3BQ4IDS6e8Wzb3pJDIyodD+pyn8k9yeh5mqELhYTCK54RJdRv71Vpb7poUuoHVKD4F6SPWsh/AePLwDaHIgCIhax2/jfsqMOaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AS3cRmF+; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-20c77459558so29499835ad.0;
        Sat, 19 Oct 2024 21:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729396951; x=1730001751; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kEpu7Ky7AWCWOFJdxOuINvLNFSfvYS/gqDPpnqne2TQ=;
        b=AS3cRmF+sv9t5aNlEzJq91n0KbEJj7TA3PR2/HCLir5fmChkbOQnTcQuloNt1w0Se0
         dABn6e6puwx8K92v/iKN7q8DzLBA+vO4Iu3hA7LDpq6SUe4VEZQp49b/sQvjp7nmfzXm
         0FB84y0ovezaGC5oA0DNAUhYYX/NYC6POJc8gDliPr0TE4UjhMqkg7ErRSaILOiAJvzb
         7xxd6SR+Vwj5xHVGILmPo80NInm+fvwK1+YxGYI/jJdzGGZPE7tHh7tzC5EnR5r+q8GK
         eIm0wwLJx0zpvoqR7+Nqo1QVWoVPTAyMyefa1yAn8Tb6DQwUOZW5jD0Og+L6HYpPl9rG
         8LnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729396951; x=1730001751;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kEpu7Ky7AWCWOFJdxOuINvLNFSfvYS/gqDPpnqne2TQ=;
        b=TRPfhMYscsXuGOFZFYNwTOi3pCqbfnNx7EY4FWcKVCholFyqli3oDk7HnvxHWUbpiG
         ZOnm46WQmKI6UsoiwCynB/o4KPGBeUasEp6KUOrkOM5z78u6QZOUsCy4arPqJoGOAhYy
         EsJCmc9kAW8kKo1RiWj2Eo1XKLmyQEFklfER6kMWArS8kHgUt6nrdZn89iPOIQBnrUv5
         wgw7nzLDvvwoj22qVzs9AP5SniZtC57cm+izN3VtSlQoiAl67Nczx+fCgKyo2HmCTch7
         bf8w8FmaF8qgkipz+AzHQzOkiuzjOK3Igs3AKMxjn2T9PZ4HETjfJynsFSiRusUKupgw
         GtBg==
X-Forwarded-Encrypted: i=1; AJvYcCUkJkgR4mq9g3HBu+kFopd2kwNucnWnNop2pcIrgskQZS7k54RmkZ15SkM46IXOJTe7rK3cNYgro808@vger.kernel.org, AJvYcCVADfvtwSFYV2B+cv/moQMuOJG6OzuExpTfhzRSqgnimODLpNrZ+kzU50wxRQCd5TGwD4B2TAFy37GoVOOt@vger.kernel.org, AJvYcCVR4tmF+LRAJvSuSAGnmBaUH0sk+Z8HY6grOgxE3Ul7qDyJLoOfaptlLDzYCvKjz+1GmoW/I23cQ+N39AoZIoM=@vger.kernel.org, AJvYcCVUp+mX93WylHa03kn2UUTzyveWLkqKyQ5z8N5FS1Yyw4euDCbDBLG7edNmODbTwqjx03rQtHZ9aVp8mGU=@vger.kernel.org, AJvYcCVksjVEFDiectwkj+XzbN3BPhYBd6ivMiw7dhb8OBN8hLiu5gViCaG/Q31dRWh5tbaelSaNNJ0i7E0S1WLRNq//oA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9eRh6wnSQr3yYfSvMCcUwYfCHBi5visq0MbNANSebzUSDjokA
	IAiFZb+812hn1QwlFoGtoFCozpGdhwdBjb8KyA80wIiYFLKaHo2M
X-Google-Smtp-Source: AGHT+IFk+ATyk4pJ+7WvwCX9XmFve66rkS7xXAujAtf2P3tgkVxx6WRk8TPvXLHd3k4vmtAoyRXaJA==
X-Received: by 2002:a17:90a:ab0e:b0:2e0:74c9:ecf1 with SMTP id 98e67ed59e1d1-2e561718d7amr5493762a91.10.1729396951374;
        Sat, 19 Oct 2024 21:02:31 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad3678d3sm633668a91.24.2024.10.19.21.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2024 21:02:30 -0700 (PDT)
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
Subject: [PATCH v2 02/10] lib min_heap: Optimize min heap by prescaling counters for better performance
Date: Sun, 20 Oct 2024 12:01:52 +0800
Message-Id: <20241020040200.939973-3-visitorckw@gmail.com>
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

Improve the efficiency of the min heap by prescaling counters,
eliminating the need to repeatedly compute 'index * element_size' when
accessing elements. By doing so, we avoid the overhead associated with
recalculating the byte offset for each heap operation.

However, with prescaling, the calculation for the parent element's
location is no longer as simple as '(i - 1) / 2'. To address this, we
copy the parent function from 'lib/sort.c', which calculates the parent
offset in a branchless manner without using any division instructions.

This optimization should result in a more efficient heap implementation
by reducing the computational overhead of finding parent and child
offsets.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
Tested with test_min_heap module.

 include/linux/min_heap.h | 73 +++++++++++++++++++++++++++-------------
 1 file changed, 49 insertions(+), 24 deletions(-)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 0abb21173979..41b092a14238 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -38,6 +38,32 @@ struct min_heap_callbacks {
 	void (*swp)(void *lhs, void *rhs, void *args);
 };
 
+/**
+ * parent - given the offset of the child, find the offset of the parent.
+ * @i: the offset of the heap element whose parent is sought.  Non-zero.
+ * @lsbit: a precomputed 1-bit mask, equal to "size & -size"
+ * @size: size of each element
+ *
+ * In terms of array indexes, the parent of element j = @i/@size is simply
+ * (j-1)/2.  But when working in byte offsets, we can't use implicit
+ * truncation of integer divides.
+ *
+ * Fortunately, we only need one bit of the quotient, not the full divide.
+ * @size has a least significant bit.  That bit will be clear if @i is
+ * an even multiple of @size, and set if it's an odd multiple.
+ *
+ * Logically, we're doing "if (i & lsbit) i -= size;", but since the
+ * branch is unpredictable, it's done with a bit of clever branch-free
+ * code instead.
+ */
+__attribute_const__ __always_inline
+static size_t parent(size_t i, unsigned int lsbit, size_t size)
+{
+	i -= size;
+	i -= size & -(i & lsbit);
+	return i / 2;
+}
+
 /* Initialize a min-heap. */
 static __always_inline
 void __min_heap_init_inline(min_heap_char *heap, void *data, int size)
@@ -78,33 +104,30 @@ static __always_inline
 void __min_heap_sift_down_inline(min_heap_char *heap, int pos, size_t elem_size,
 				 const struct min_heap_callbacks *func, void *args)
 {
-	void *left, *right;
+	const unsigned long lsbit = elem_size & -elem_size;
 	void *data = heap->data;
-	void *root = data + pos * elem_size;
-	int i = pos, j;
+	/* pre-scale counters for performance */
+	size_t a = pos * elem_size;
+	size_t b, c, d;
+	size_t n = heap->nr * elem_size;
 
 	/* Find the sift-down path all the way to the leaves. */
-	for (;;) {
-		if (i * 2 + 2 >= heap->nr)
-			break;
-		left = data + (i * 2 + 1) * elem_size;
-		right = data + (i * 2 + 2) * elem_size;
-		i = func->less(left, right, args) ? i * 2 + 1 : i * 2 + 2;
-	}
+	for (b = a; c = 2 * b + elem_size, (d = c + elem_size) < n;)
+		b = func->less(data + c, data + d, args) ? c : d;
 
 	/* Special case for the last leaf with no sibling. */
-	if (i * 2 + 2 == heap->nr)
-		i = i * 2 + 1;
+	if (d == n)
+		b = c;
 
 	/* Backtrack to the correct location. */
-	while (i != pos && func->less(root, data + i * elem_size, args))
-		i = (i - 1) / 2;
+	while (b != a && func->less(data + a, data + b, args))
+		b = parent(b, lsbit, elem_size);
 
 	/* Shift the element into its correct place. */
-	j = i;
-	while (i != pos) {
-		i = (i - 1) / 2;
-		func->swp(data + i * elem_size, data + j * elem_size, args);
+	c = b;
+	while (b != a) {
+		b = parent(b, lsbit, elem_size);
+		func->swp(data + b, data + c, args);
 	}
 }
 
@@ -117,15 +140,17 @@ static __always_inline
 void __min_heap_sift_up_inline(min_heap_char *heap, size_t elem_size, size_t idx,
 			       const struct min_heap_callbacks *func, void *args)
 {
+	const unsigned long lsbit = elem_size & -elem_size;
 	void *data = heap->data;
-	size_t parent;
+	/* pre-scale counters for performance */
+	size_t a = idx * elem_size, b;
 
-	while (idx) {
-		parent = (idx - 1) / 2;
-		if (func->less(data + parent * elem_size, data + idx * elem_size, args))
+	while (a) {
+		b = parent(a, lsbit, elem_size);
+		if (func->less(data + b, data + a, args))
 			break;
-		func->swp(data + parent * elem_size, data + idx * elem_size, args);
-		idx = parent;
+		func->swp(data + a, data + b, args);
+		a = b;
 	}
 }
 
-- 
2.34.1


