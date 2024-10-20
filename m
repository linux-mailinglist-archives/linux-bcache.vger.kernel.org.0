Return-Path: <linux-bcache+bounces-764-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C20BD9A522D
	for <lists+linux-bcache@lfdr.de>; Sun, 20 Oct 2024 06:02:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CE41283E55
	for <lists+linux-bcache@lfdr.de>; Sun, 20 Oct 2024 04:02:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8692B5228;
	Sun, 20 Oct 2024 04:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H4T01970"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D81EAF6;
	Sun, 20 Oct 2024 04:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729396949; cv=none; b=nccee95m9iULy20DIce24mdt7EI8AU8XOr7lvo38KgYvJQTwPe7EV2m2isqRCnhFaFurb9vwmFDJt0R8hVk4ngWM+hJf62kb99RZBt0xWKLVvLX9uAN1mDaFnYYaPSWuPeHHYXb9vz7lrXP8I/RWt6hR7X1i9P48Giu334tOZJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729396949; c=relaxed/simple;
	bh=AuW17kDORWd0KDHQZdR2xWDyCr+wDKId6jBES0rwfzA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RUKYM8CTB82iOoL+sWb1yZcLkIZdhlIF6hPetU6KQhCy/pF4a5gDq6yhaliyC6Ly+GoDcEUqZOf9hAjgi7HS9HrzztUn0NVKHyxBSjIESVUMtV0e0BKGqLfp3ZJoORqWdxeL1Pp6XqaSgSjx7o0ExPSHVvO8jqggHoovhY4cKss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H4T01970; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2e2c6bc4840so2516064a91.2;
        Sat, 19 Oct 2024 21:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729396946; x=1730001746; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ocJAjO3VEDnwWXU1UORPzcLbPWZJaMhjLdoDnx0hezA=;
        b=H4T019700x/QgcZn3ayKCMtkFrt1KJtTL8rbLEnguH/SewTCn3MZmgNqKaBoyjwa5/
         0DrxcyNiCu+IcdJWKTBE/OSrl8PhGNBxp8PYH10HCNsnz+YLuLzg5FvBdsTNsgTHSoI0
         nRIWH7IoIApGGSvzO7Gv9kqGINXQiRWV0VMPS3k47Ygb968NxQpUtmIkXN62v8yzXRXW
         mbm/KbInLra1Z1zPb7Paajmna307LVoyo3eavtYqsCV6ota3QEMccsoxI7WmZEsM1ygh
         t1xl3g3wMOpLVWE2eR4DrPWJWV1PqEWUM1LCBVLyy5i0YLFDp0u71LD0GflgVwiYKZg/
         eWuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729396946; x=1730001746;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ocJAjO3VEDnwWXU1UORPzcLbPWZJaMhjLdoDnx0hezA=;
        b=hUV139QZHMHOJhC+o7ppkq+utQL59vmZmdk0PpSGu95l59GAK7SHSYL2lKkbt5lANX
         WmeVd87rPrLfgFTehEZVQI5XuyBkX0giRCQenZCL17WHg/X2r5TlTTDEWCyC1+Ir03aH
         /ZotKaB2kva6jVd+g1hlw8ZXSW3BYeBxUbwwGeqtyBvAZ0G9depAQBnqbHO4whqa4i+r
         V5TQBBi8+L5pdP/KrsPoovCNMQMJXNboiJvNy131b2X1/BiLvGKlGiW88Ahl3XQlSqvO
         UHQr2iMrAX45sBQNOBqBXNq2rsxQC7p+a7dEN+3o56wo9FjtS8sfgfD4w1u8fwAtCmh+
         nQ8A==
X-Forwarded-Encrypted: i=1; AJvYcCUTKG508wQcw/A4CeisotlaQr/7jZa9/DI1H97qra2FTWlQrt2snVaRvnsGPl4MFuoa31Uc7F+e9wvf@vger.kernel.org, AJvYcCUZxjBoeMzCka7mxNyCA5lUYIv+pCt5fpEsQzrZ/5KWk+E7/1brURlaBGglPDf2bhoQeYuR9qQOB8YZrW5C@vger.kernel.org, AJvYcCVlE4+eM1aU1oVAnqNL8hejq4DWiDL/FR1bgmrrtAhC4h1x35Q6JW90J7YbczDoUJO71MBSJEF+I7d8tPQ=@vger.kernel.org, AJvYcCW9Z01prlVY9adRQz8WU+hy6g2LPhI78jNiGjJ3u2Ag8FCj7/tTM1JRkHyUwe0qCYcbJD5e9bmkqIVg4IEqc4U=@vger.kernel.org, AJvYcCXhjQsuZ9rwS+Crl8C/fRjsiFscjfjnNhlzknKZUnU1uNxBWqBVt14cE/VKkWnYVpjQQrKIiFE7rZB2Strarpr0Dw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9oEVjJGPzvLFjcO+HtoSUo7ApR1WXxcDQLlzeV19HXz6GQWB9
	o4AJm0LXuVQxFfWvL8zTDJxPzeV3Ed3Bo91JUI3VPkw93oWSrjoY
X-Google-Smtp-Source: AGHT+IFVG/U8s3V87FeUqj8Nc4N7rb/VosY5/redFg5afiXWk0Rer4YIpFZdFk+EoegzMF4SH9tSTw==
X-Received: by 2002:a17:90b:4b4a:b0:2e2:b211:a4da with SMTP id 98e67ed59e1d1-2e5616ec45bmr9059569a91.14.1729396945986;
        Sat, 19 Oct 2024 21:02:25 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad3678d3sm633668a91.24.2024.10.19.21.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2024 21:02:25 -0700 (PDT)
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
Subject: [PATCH v2 01/10] lib/min_heap: Introduce non-inline versions of min heap API functions
Date: Sun, 20 Oct 2024 12:01:51 +0800
Message-Id: <20241020040200.939973-2-visitorckw@gmail.com>
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

All current min heap API functions are marked with '__always_inline'.
However, as the number of users increases, inlining these functions
everywhere leads to a increase in kernel size.

In performance-critical paths, such as when perf events are enabled and
min heap functions are called on every context switch, it is important
to retain the inline versions for optimal performance. To balance this,
the original inline functions are kept, and additional non-inline
versions of the functions have been added in lib/min_heap.c.

Link: https://lore.kernel.org/20240522161048.8d8bbc7b153b4ecd92c50666@linux-foundation.org
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
Code size for bcache:
Before:
   text	   data	    bss	    dec	    hex	filename
   7257	    302	      0	   7559	   1d87	./drivers/md/bcache/alloc.o
  10786	    515	      0	  11301	   2c25	./drivers/md/bcache/bset.o
  33246	   1596	      8	  34850	   8822	./drivers/md/bcache/btree.o
   7195	    256	      0	   7451	   1d1b	./drivers/md/bcache/extents.o
   3524	    174	      0	   3698	    e72	./drivers/md/bcache/movinggc.o
  17424	   2816	      0	  20240	   4f10	./drivers/md/bcache/sysfs.o
   8994	    328	      0	   9322	   246a	./drivers/md/bcache/writeback.o
After:
   text	   data	    bss	    dec	    hex	filename
   6339	    300	      0	   6639	   19ef	./drivers/md/bcache/alloc.o
  10428	    537	      0	  10965	   2ad5	./drivers/md/bcache/bset.o
  33134	   1596	      8	  34738	   87b2	./drivers/md/bcache/btree.o
   6619	    264	      0	   6883	   1ae3	./drivers/md/bcache/extents.o
   2958	    152	      0	   3110	    c26	./drivers/md/bcache/movinggc.o
  17408	   2816	      0	  20224	   4f00	./drivers/md/bcache/sysfs.o
   8962	    328	      0	   9290	   244a	./drivers/md/bcache/writeback.o

Code size for bcachefs:
Before:
   text	   data	    bss	    dec	    hex	filename
   2286	    155	      0	   2441	    989	./fs/bcachefs/clock.o
  41481	   1634	     20	  43135	   a87f	./fs/bcachefs/ec.o
After:
   text	   data	    bss	    dec	    hex	filename
   1928	    132	      0	   2060	    80c	./fs/bcachefs/clock.o
  40259	   1624	     20	  41903	   a3af	./fs/bcachefs/ec.o

Code size for dm-vdo:
Before:
   text	   data	    bss	    dec	    hex	filename
  14047	    264	      0	  14311	   37e7	./drivers/md/dm-vdo/repair.o
  37432	    944	      0	  38376	   95e8	./drivers/md/dm-vdo/slab-depot.o
After:
   text	   data	    bss	    dec	    hex	filename
  13697	    264	      0	  13961	   3689	./drivers/md/dm-vdo/repair.o
  37074	    960	      0	  38034	   9492	./drivers/md/dm-vdo/slab-depot.o

Code size for test_min_heap:
Before:
   text	   data	    bss	    dec	    hex	filename
   5499	    171	      0	   5670	   1626	./lib/test_min_heap.o
After:
   text	   data	    bss	    dec	    hex	filename
   2581	     96	      0	   2677	    a75	./lib/test_min_heap.o

 drivers/md/bcache/Kconfig |   1 +
 drivers/md/dm-vdo/Kconfig |   1 +
 fs/bcachefs/Kconfig       |   1 +
 include/linux/min_heap.h  | 129 +++++++++++++++++++++++++-------------
 kernel/events/core.c      |   6 +-
 lib/Kconfig               |   3 +
 lib/Kconfig.debug         |   1 +
 lib/Makefile              |   1 +
 lib/min_heap.c            |  70 +++++++++++++++++++++
 9 files changed, 167 insertions(+), 46 deletions(-)
 create mode 100644 lib/min_heap.c

diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
index b2d10063d35f..d4697e79d5a3 100644
--- a/drivers/md/bcache/Kconfig
+++ b/drivers/md/bcache/Kconfig
@@ -5,6 +5,7 @@ config BCACHE
 	select BLOCK_HOLDER_DEPRECATED if SYSFS
 	select CRC64
 	select CLOSURES
+	select MIN_HEAP
 	help
 	Allows a block device to be used as cache for other devices; uses
 	a btree for indexing and the layout is optimized for SSDs.
diff --git a/drivers/md/dm-vdo/Kconfig b/drivers/md/dm-vdo/Kconfig
index 111ecd2c2a24..2400b2bc4bc7 100644
--- a/drivers/md/dm-vdo/Kconfig
+++ b/drivers/md/dm-vdo/Kconfig
@@ -7,6 +7,7 @@ config DM_VDO
 	select DM_BUFIO
 	select LZ4_COMPRESS
 	select LZ4_DECOMPRESS
+	select MIN_HEAP
 	help
 	  This device mapper target presents a block device with
 	  deduplication, compression and thin-provisioning.
diff --git a/fs/bcachefs/Kconfig b/fs/bcachefs/Kconfig
index 5bac803ea367..ab6c95b895b3 100644
--- a/fs/bcachefs/Kconfig
+++ b/fs/bcachefs/Kconfig
@@ -24,6 +24,7 @@ config BCACHEFS_FS
 	select XXHASH
 	select SRCU
 	select SYMBOLIC_ERRNAME
+	select MIN_HEAP
 	help
 	The bcachefs filesystem - a modern, copy on write filesystem, with
 	support for multiple devices, compression, checksumming, etc.
diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 43a7b9dcf15e..0abb21173979 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -40,7 +40,7 @@ struct min_heap_callbacks {
 
 /* Initialize a min-heap. */
 static __always_inline
-void __min_heap_init(min_heap_char *heap, void *data, int size)
+void __min_heap_init_inline(min_heap_char *heap, void *data, int size)
 {
 	heap->nr = 0;
 	heap->size = size;
@@ -50,33 +50,33 @@ void __min_heap_init(min_heap_char *heap, void *data, int size)
 		heap->data = heap->preallocated;
 }
 
-#define min_heap_init(_heap, _data, _size)	\
-	__min_heap_init((min_heap_char *)_heap, _data, _size)
+#define min_heap_init_inline(_heap, _data, _size)	\
+	__min_heap_init_inline((min_heap_char *)_heap, _data, _size)
 
 /* Get the minimum element from the heap. */
 static __always_inline
-void *__min_heap_peek(struct min_heap_char *heap)
+void *__min_heap_peek_inline(struct min_heap_char *heap)
 {
 	return heap->nr ? heap->data : NULL;
 }
 
-#define min_heap_peek(_heap)	\
-	(__minheap_cast(_heap) __min_heap_peek((min_heap_char *)_heap))
+#define min_heap_peek_inline(_heap)	\
+	(__minheap_cast(_heap) __min_heap_peek_inline((min_heap_char *)_heap))
 
 /* Check if the heap is full. */
 static __always_inline
-bool __min_heap_full(min_heap_char *heap)
+bool __min_heap_full_inline(min_heap_char *heap)
 {
 	return heap->nr == heap->size;
 }
 
-#define min_heap_full(_heap)	\
-	__min_heap_full((min_heap_char *)_heap)
+#define min_heap_full_inline(_heap)	\
+	__min_heap_full_inline((min_heap_char *)_heap)
 
 /* Sift the element at pos down the heap. */
 static __always_inline
-void __min_heap_sift_down(min_heap_char *heap, int pos, size_t elem_size,
-		const struct min_heap_callbacks *func, void *args)
+void __min_heap_sift_down_inline(min_heap_char *heap, int pos, size_t elem_size,
+				 const struct min_heap_callbacks *func, void *args)
 {
 	void *left, *right;
 	void *data = heap->data;
@@ -108,13 +108,14 @@ void __min_heap_sift_down(min_heap_char *heap, int pos, size_t elem_size,
 	}
 }
 
-#define min_heap_sift_down(_heap, _pos, _func, _args)	\
-	__min_heap_sift_down((min_heap_char *)_heap, _pos, __minheap_obj_size(_heap), _func, _args)
+#define min_heap_sift_down_inline(_heap, _pos, _func, _args)	\
+	__min_heap_sift_down_inline((min_heap_char *)_heap, _pos, __minheap_obj_size(_heap),	\
+				    _func, _args)
 
 /* Sift up ith element from the heap, O(log2(nr)). */
 static __always_inline
-void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
-		const struct min_heap_callbacks *func, void *args)
+void __min_heap_sift_up_inline(min_heap_char *heap, size_t elem_size, size_t idx,
+			       const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
 	size_t parent;
@@ -128,27 +129,28 @@ void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
 	}
 }
 
-#define min_heap_sift_up(_heap, _idx, _func, _args)	\
-	__min_heap_sift_up((min_heap_char *)_heap, __minheap_obj_size(_heap), _idx, _func, _args)
+#define min_heap_sift_up_inline(_heap, _idx, _func, _args)	\
+	__min_heap_sift_up_inline((min_heap_char *)_heap, __minheap_obj_size(_heap), _idx,	\
+				  _func, _args)
 
 /* Floyd's approach to heapification that is O(nr). */
 static __always_inline
-void __min_heapify_all(min_heap_char *heap, size_t elem_size,
-		const struct min_heap_callbacks *func, void *args)
+void __min_heapify_all_inline(min_heap_char *heap, size_t elem_size,
+			      const struct min_heap_callbacks *func, void *args)
 {
 	int i;
 
 	for (i = heap->nr / 2 - 1; i >= 0; i--)
-		__min_heap_sift_down(heap, i, elem_size, func, args);
+		__min_heap_sift_down_inline(heap, i, elem_size, func, args);
 }
 
-#define min_heapify_all(_heap, _func, _args)	\
-	__min_heapify_all((min_heap_char *)_heap, __minheap_obj_size(_heap), _func, _args)
+#define min_heapify_all_inline(_heap, _func, _args)	\
+	__min_heapify_all_inline((min_heap_char *)_heap, __minheap_obj_size(_heap), _func, _args)
 
 /* Remove minimum element from the heap, O(log2(nr)). */
 static __always_inline
-bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
-		const struct min_heap_callbacks *func, void *args)
+bool __min_heap_pop_inline(min_heap_char *heap, size_t elem_size,
+			   const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
 
@@ -158,13 +160,13 @@ bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
 	/* Place last element at the root (position 0) and then sift down. */
 	heap->nr--;
 	memcpy(data, data + (heap->nr * elem_size), elem_size);
-	__min_heap_sift_down(heap, 0, elem_size, func, args);
+	__min_heap_sift_down_inline(heap, 0, elem_size, func, args);
 
 	return true;
 }
 
-#define min_heap_pop(_heap, _func, _args)	\
-	__min_heap_pop((min_heap_char *)_heap, __minheap_obj_size(_heap), _func, _args)
+#define min_heap_pop_inline(_heap, _func, _args)	\
+	__min_heap_pop_inline((min_heap_char *)_heap, __minheap_obj_size(_heap), _func, _args)
 
 /*
  * Remove the minimum element and then push the given element. The
@@ -172,22 +174,21 @@ bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
  * efficient than a pop followed by a push that does 2.
  */
 static __always_inline
-void __min_heap_pop_push(min_heap_char *heap,
-		const void *element, size_t elem_size,
-		const struct min_heap_callbacks *func,
-		void *args)
+void __min_heap_pop_push_inline(min_heap_char *heap, const void *element, size_t elem_size,
+				const struct min_heap_callbacks *func, void *args)
 {
 	memcpy(heap->data, element, elem_size);
-	__min_heap_sift_down(heap, 0, elem_size, func, args);
+	__min_heap_sift_down_inline(heap, 0, elem_size, func, args);
 }
 
-#define min_heap_pop_push(_heap, _element, _func, _args)	\
-	__min_heap_pop_push((min_heap_char *)_heap, _element, __minheap_obj_size(_heap), _func, _args)
+#define min_heap_pop_push_inline(_heap, _element, _func, _args)	\
+	__min_heap_pop_push_inline((min_heap_char *)_heap, _element, __minheap_obj_size(_heap),	\
+				   _func, _args)
 
 /* Push an element on to the heap, O(log2(nr)). */
 static __always_inline
-bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
-		const struct min_heap_callbacks *func, void *args)
+bool __min_heap_push_inline(min_heap_char *heap, const void *element, size_t elem_size,
+			    const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
 	int pos;
@@ -201,18 +202,19 @@ bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 	heap->nr++;
 
 	/* Sift child at pos up. */
-	__min_heap_sift_up(heap, elem_size, pos, func, args);
+	__min_heap_sift_up_inline(heap, elem_size, pos, func, args);
 
 	return true;
 }
 
-#define min_heap_push(_heap, _element, _func, _args)	\
-	__min_heap_push((min_heap_char *)_heap, _element, __minheap_obj_size(_heap), _func, _args)
+#define min_heap_push_inline(_heap, _element, _func, _args)	\
+	__min_heap_push_inline((min_heap_char *)_heap, _element, __minheap_obj_size(_heap),	\
+			       _func, _args)
 
 /* Remove ith element from the heap, O(log2(nr)). */
 static __always_inline
-bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
-		const struct min_heap_callbacks *func, void *args)
+bool __min_heap_del_inline(min_heap_char *heap, size_t elem_size, size_t idx,
+			   const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
 
@@ -224,12 +226,53 @@ bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
 	if (idx == heap->nr)
 		return true;
 	func->swp(data + (idx * elem_size), data + (heap->nr * elem_size), args);
-	__min_heap_sift_up(heap, elem_size, idx, func, args);
-	__min_heap_sift_down(heap, idx, elem_size, func, args);
+	__min_heap_sift_up_inline(heap, elem_size, idx, func, args);
+	__min_heap_sift_down_inline(heap, idx, elem_size, func, args);
 
 	return true;
 }
 
+#define min_heap_del_inline(_heap, _idx, _func, _args)	\
+	__min_heap_del_inline((min_heap_char *)_heap, __minheap_obj_size(_heap), _idx,	\
+			      _func, _args)
+
+void __min_heap_init(min_heap_char *heap, void *data, int size);
+void *__min_heap_peek(struct min_heap_char *heap);
+bool __min_heap_full(min_heap_char *heap);
+void __min_heap_sift_down(min_heap_char *heap, int pos, size_t elem_size,
+			  const struct min_heap_callbacks *func, void *args);
+void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
+			const struct min_heap_callbacks *func, void *args);
+void __min_heapify_all(min_heap_char *heap, size_t elem_size,
+		       const struct min_heap_callbacks *func, void *args);
+bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
+		    const struct min_heap_callbacks *func, void *args);
+void __min_heap_pop_push(min_heap_char *heap, const void *element, size_t elem_size,
+			 const struct min_heap_callbacks *func, void *args);
+bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
+		     const struct min_heap_callbacks *func, void *args);
+bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
+		    const struct min_heap_callbacks *func, void *args);
+
+#define min_heap_init(_heap, _data, _size)	\
+	__min_heap_init((min_heap_char *)_heap, _data, _size)
+#define min_heap_peek(_heap)	\
+	(__minheap_cast(_heap) __min_heap_peek((min_heap_char *)_heap))
+#define min_heap_full(_heap)	\
+	__min_heap_full((min_heap_char *)_heap)
+#define min_heap_sift_down(_heap, _pos, _func, _args)	\
+	__min_heap_sift_down((min_heap_char *)_heap, _pos, __minheap_obj_size(_heap), _func, _args)
+#define min_heap_sift_up(_heap, _idx, _func, _args)	\
+	__min_heap_sift_up((min_heap_char *)_heap, __minheap_obj_size(_heap), _idx, _func, _args)
+#define min_heapify_all(_heap, _func, _args)	\
+	__min_heapify_all((min_heap_char *)_heap, __minheap_obj_size(_heap), _func, _args)
+#define min_heap_pop(_heap, _func, _args)	\
+	__min_heap_pop((min_heap_char *)_heap, __minheap_obj_size(_heap), _func, _args)
+#define min_heap_pop_push(_heap, _element, _func, _args)	\
+	__min_heap_pop_push((min_heap_char *)_heap, _element, __minheap_obj_size(_heap),	\
+			    _func, _args)
+#define min_heap_push(_heap, _element, _func, _args)	\
+	__min_heap_push((min_heap_char *)_heap, _element, __minheap_obj_size(_heap), _func, _args)
 #define min_heap_del(_heap, _idx, _func, _args)	\
 	__min_heap_del((min_heap_char *)_heap, __minheap_obj_size(_heap), _idx, _func, _args)
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index e3589c4287cb..cbf365e67f6e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3870,7 +3870,7 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
 		perf_assert_pmu_disabled((*evt)->pmu_ctx->pmu);
 	}
 
-	min_heapify_all(&event_heap, &perf_min_heap, NULL);
+	min_heapify_all_inline(&event_heap, &perf_min_heap, NULL);
 
 	while (event_heap.nr) {
 		ret = func(*evt, data);
@@ -3879,9 +3879,9 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
 
 		*evt = perf_event_groups_next(*evt, pmu);
 		if (*evt)
-			min_heap_sift_down(&event_heap, 0, &perf_min_heap, NULL);
+			min_heap_sift_down_inline(&event_heap, 0, &perf_min_heap, NULL);
 		else
-			min_heap_pop(&event_heap, &perf_min_heap, NULL);
+			min_heap_pop_inline(&event_heap, &perf_min_heap, NULL);
 	}
 
 	return 0;
diff --git a/lib/Kconfig b/lib/Kconfig
index b38849af6f13..037a84731b7d 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -777,3 +777,6 @@ config POLYNOMIAL
 
 config FIRMWARE_TABLE
 	bool
+
+config MIN_HEAP
+	bool
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 7312ae7c3cc5..c9e6ce184044 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2279,6 +2279,7 @@ config TEST_LIST_SORT
 config TEST_MIN_HEAP
 	tristate "Min heap test"
 	depends on DEBUG_KERNEL || m
+	select MIN_HEAP
 	help
 	  Enable this to turn on min heap function tests. This test is
 	  executed only once during system boot (so affects only boot time),
diff --git a/lib/Makefile b/lib/Makefile
index 773adf88af41..e7ffee03e186 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -39,6 +39,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 
 lib-$(CONFIG_PRINTK) += dump_stack.o
 lib-$(CONFIG_SMP) += cpumask.o
+lib-$(CONFIG_MIN_HEAP) += min_heap.o
 
 lib-y	+= kobject.o klist.o
 obj-y	+= lockref.o
diff --git a/lib/min_heap.c b/lib/min_heap.c
new file mode 100644
index 000000000000..4485372ff3b1
--- /dev/null
+++ b/lib/min_heap.c
@@ -0,0 +1,70 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/export.h>
+#include <linux/min_heap.h>
+
+void __min_heap_init(min_heap_char *heap, void *data, int size)
+{
+	__min_heap_init_inline(heap, data, size);
+}
+EXPORT_SYMBOL(__min_heap_init);
+
+void *__min_heap_peek(struct min_heap_char *heap)
+{
+	return __min_heap_peek_inline(heap);
+}
+EXPORT_SYMBOL(__min_heap_peek);
+
+bool __min_heap_full(min_heap_char *heap)
+{
+	return __min_heap_full_inline(heap);
+}
+EXPORT_SYMBOL(__min_heap_full);
+
+void __min_heap_sift_down(min_heap_char *heap, int pos, size_t elem_size,
+			  const struct min_heap_callbacks *func, void *args)
+{
+	__min_heap_sift_down_inline(heap, pos, elem_size, func, args);
+}
+EXPORT_SYMBOL(__min_heap_sift_down);
+
+void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
+			const struct min_heap_callbacks *func, void *args)
+{
+	__min_heap_sift_up_inline(heap, elem_size, idx, func, args);
+}
+EXPORT_SYMBOL(__min_heap_sift_up);
+
+void __min_heapify_all(min_heap_char *heap, size_t elem_size,
+		       const struct min_heap_callbacks *func, void *args)
+{
+	__min_heapify_all_inline(heap, elem_size, func, args);
+}
+EXPORT_SYMBOL(__min_heapify_all);
+
+bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
+		    const struct min_heap_callbacks *func, void *args)
+{
+	return __min_heap_pop_inline(heap, elem_size, func, args);
+}
+EXPORT_SYMBOL(__min_heap_pop);
+
+void __min_heap_pop_push(min_heap_char *heap, const void *element, size_t elem_size,
+			 const struct min_heap_callbacks *func, void *args)
+{
+	__min_heap_pop_push_inline(heap, element, elem_size, func, args);
+}
+EXPORT_SYMBOL(__min_heap_pop_push);
+
+bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
+		     const struct min_heap_callbacks *func, void *args)
+{
+	return __min_heap_push_inline(heap, element, elem_size, func, args);
+}
+EXPORT_SYMBOL(__min_heap_push);
+
+bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
+		    const struct min_heap_callbacks *func, void *args)
+{
+	return __min_heap_del_inline(heap, elem_size, idx, func, args);
+}
+EXPORT_SYMBOL(__min_heap_del);
-- 
2.34.1


