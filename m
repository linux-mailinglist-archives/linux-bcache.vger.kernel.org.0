Return-Path: <linux-bcache+bounces-747-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77C6D99BAE7
	for <lists+linux-bcache@lfdr.de>; Sun, 13 Oct 2024 20:48:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3823B281715
	for <lists+linux-bcache@lfdr.de>; Sun, 13 Oct 2024 18:48:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E35B714AD2B;
	Sun, 13 Oct 2024 18:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ALsxcahm"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4924714AD22;
	Sun, 13 Oct 2024 18:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728845261; cv=none; b=L7cnt3oSx34ipx37wKY87bmQjRI4dNhOdMllx4AJtVYsWmCDfu24/d9VCnRbf0miHtWnx40M9CqB8iDE6RuXXnS2D44ER1qJmOvkmgxQSmwGXSYo2wVCqde969A2iGuEfSLoTQ3oRuGaiD9qa7d/7MxBF/rw/d8tiW8N0Wq/DFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728845261; c=relaxed/simple;
	bh=SNw/5o1lFuWyY9FK0pUzpASTqMzQQl0VMxj1R85JMxw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LWkcmUmK5B1X2UJIyspPaY1IQgH78kKE48IYPN+xBAj3cN1WBJO1Wz0y43sHP8GDJrnH5DRv6LbEZSKqVjqY9o+HKcFSJrgxb4DDaAe/zVg+jswA/EgXEVvOGF0Utgx/sRF6DfCXCYRzUXRGXjlg6XLsJNCsmtMPhiJeK45NRFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ALsxcahm; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-20c8b557f91so26393635ad.2;
        Sun, 13 Oct 2024 11:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728845259; x=1729450059; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xSgBUVDuaaQJ7aL+4KpOG9PFNPzYSqa7wdB4/0F3UqU=;
        b=ALsxcahmY98DPQ9jM6tNhENpj17DuoAqOn30MBaNdbxns4+EChWb+JWEEDzDr3jg15
         1vd+P8RFziQvCZ1qbLXgZJ6Ku2abHieYTHemGJH9GuMi6KUKoaMu8AwxaqSR4DR+rR0d
         EdBhTn9NBkEu3ZYfEpBNA4lK3y4IUv9EuxKIlyhTLiLY4PyGksRcbw6c1B5zPAelvl8Q
         7LudEn5J/yDsd22YvEDCdHFiLeIfFYwZt3NFAjpAGlvw3c6M6Ujor+rCtP892X6Dx6/M
         qtEhsHTqumS+PFJG3p/NbLg5gnLNhloPKKjLrayHTsb6IWYGCZkoJkPhHditCvpo6Hru
         Pb0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728845259; x=1729450059;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xSgBUVDuaaQJ7aL+4KpOG9PFNPzYSqa7wdB4/0F3UqU=;
        b=wzAwitmcNbDyi5IRj5AVKF3GJ3o8p5ERstK/3sLL5cgvqxUfzjbaPYfOYnyjY0Wx5p
         ksHYi+kCKsaFw9bPBLcEy8V9tTDrZ9lnqSIITdi86mgi4RAi7Jc7Ymr7Dq9Ci9eOkQZF
         7JsDk12AQ1xkXZj6L3h19QI4DiMiwieteEK94kl1d9pmhUV1Et1yht81Gjjepf8eIAUw
         ziAoaQV6Q6Mx5t5UQwiFhiUVznEeNCRjg3bgLXCSG4J0yWomSIDPy5cWK4tWBaVAvm+u
         B6OITWwVFA6/F5prA+Zx8dC4/m28wSy4eg4avDaX6GSgJrxoe3y4cq62y8bV7eZKw34e
         r3pA==
X-Forwarded-Encrypted: i=1; AJvYcCUkrD5Li5MxMOa/ZcER28ZNs55FiGlW24erJsyHgXI5g4jOLjIKdMzZWmng10G4GRMlWaiD1EIVpBtc2XPp9ig=@vger.kernel.org, AJvYcCUnDA6QWdEehasEednsNrXOrYwqyLnQEvjSsxd7IzsxQurp0e4wFz+2tp4UclqVUasxJzZd6TT+VZonVa8=@vger.kernel.org, AJvYcCVB9axldtF9/Ys8Zxd+HtDR+7niDzj2ZYySYxbjFndIrR2q9Csf8lAztfvLHzvWyTh6QcenrGTM0cpZlRSyBiJ4+Q==@vger.kernel.org, AJvYcCW0zuLj1o+3uU+FS9982lNqIaMTjamClfgDDtIGUOjiSPXNsVrtPhw5IJ7CaTXM2VkFDlT0VHDxl9q1D9Tm@vger.kernel.org, AJvYcCWWNvKm7itJ5eFBCQCXMFHvFYmlFCncByKe/b3VG2xEM0Jyrat91S5kjaTVcEDp/0waVN3euVWd6RlW@vger.kernel.org
X-Gm-Message-State: AOJu0YwDE8LXHe32kQgdp2SS7/gD8S8EVjCP5QwB1Z7rLojB5OVbSKY/
	AKazTOVRS3TWFzVJ+CkDLE5dHn6n+E0iT1Tkw2LiRocRpy5tiJIA
X-Google-Smtp-Source: AGHT+IHOX5mN/TiSS+Vhti8hnnhr5pq0lj2xSJGRFkcy9EAu/5N5LW4pl2hse1P41xIM98wo4LcDNg==
X-Received: by 2002:a17:902:da8e:b0:20c:d2e4:dc33 with SMTP id d9443c01a7336-20cd2e4ddc4mr67601575ad.14.1728845259628;
        Sun, 13 Oct 2024 11:47:39 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c348f41sm52681965ad.289.2024.10.13.11.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2024 11:47:39 -0700 (PDT)
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
	jserv@ccns.ncku.edu.tw,
	linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH 2/3] lib min_heap: Optimize min heap by prescaling counters for better performance
Date: Mon, 14 Oct 2024 02:47:02 +0800
Message-Id: <20241013184703.659652-3-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241013184703.659652-1-visitorckw@gmail.com>
References: <20241013184703.659652-1-visitorckw@gmail.com>
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
index 0abb21173979..bee28d7b6efc 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -73,38 +73,61 @@ bool __min_heap_full_inline(min_heap_char *heap)
 #define min_heap_full_inline(_heap)	\
 	__min_heap_full_inline((min_heap_char *)_heap)
 
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
 /* Sift the element at pos down the heap. */
 static __always_inline
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


