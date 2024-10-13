Return-Path: <linux-bcache+bounces-746-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 80BD099BAE2
	for <lists+linux-bcache@lfdr.de>; Sun, 13 Oct 2024 20:47:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8ECB21C20C69
	for <lists+linux-bcache@lfdr.de>; Sun, 13 Oct 2024 18:47:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9725514A4D0;
	Sun, 13 Oct 2024 18:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jdTcsgmc"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C5F14A4C1;
	Sun, 13 Oct 2024 18:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728845254; cv=none; b=YK5sH+ApbVzEJzT+k6gFnba/jDrTUB6Rfr993txivrL0qNucTSKMrDshgVfQWcwD6g2dbx31SUTjWya9KPwZ5MOs0+7OSBFG/N58R7lk/A3gqATxY+U4pAVEYIGoJmX+wHjmKQ7MwPwzi+cyydjowxTtG4ZwcB5Rvn8Vlaz+iHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728845254; c=relaxed/simple;
	bh=EZ17iVx1S5EmAG0qSQL78S0bek1tN2ZbE1JpNX94hyo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uEIMzfx7xXV+q6xS+bLvOA4lQVh5Rj3x1NW6DhqlP3rW4UmeaU0nafGG2FHWJfJ99THUEhTvaSuiOhtt8aKksKYwNN6kFEd5nqNjrZEkwSJIne3rGq6NJ1r8H7mLRd8yJQ6hHJbgU6RElHV1GRVdhlV/PN/22Apzpl8C6vuHl/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jdTcsgmc; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-20c77459558so27459095ad.0;
        Sun, 13 Oct 2024 11:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728845252; x=1729450052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x22YH2oKJ+m/PKql5G0+yADoV320o3RMXRRRh7K19Nk=;
        b=jdTcsgmc7KJglW1DkjFBuw6+FKi/9AuBdAV4mZONBk6nhUf4JhP+SJXEYTc/VhtXsk
         gCgcWWc8CkL1NNKKiVv6ysj+niZTY+KQ/JDRvWsmg7vKmAmOUEWbkd/zMdfy7mSqKTtA
         g3Q78d/L4EZ3QmTWMxabtZCtwxhvNBv3E8KKavLEjmEw2j7rL94LewYqN1hEqUetmJa+
         Zgxr2S8TtBymY4q24Wq2BmI2QI0K/QHfnp0XG+9vRD47RUaHGOL60wrExALw82GX3Ltl
         iO4bW0ixcNmB7r8/8cO//yAHCfrKMY1YwulX2+9BuugeDyYlj9L82DbCo5ujDyhywTJZ
         XnIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728845252; x=1729450052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x22YH2oKJ+m/PKql5G0+yADoV320o3RMXRRRh7K19Nk=;
        b=KCbRad94bS03e5oEcijaIM+L5rBKSKa+2yjLySqU/+T5uJN1x26h4dNN9AZUcXK0hY
         eis6znIlLk/jziKx/qbH6O1QQ3ctc6lcOr5QGVp7xuKm2UnlfRVMbTGPFgAXOGYOIW7D
         Z7HohMisI9iTvUwaMXurI5ZzmETevj/3/lCIICrwexiPaG8xBiyIezhMuvaAHgeM+kYN
         PZkf7hHvBIW+Cejp2cyRYXxafY4s+Wi9EpvaW9F1wJJx3387EqD0Uiomi+4SAr+35rsW
         84zHz6kTCvL9oQVNW98iSkNjqPTLcq8YlReyW0r66vYuEJf3U2Lsk2lY7OqzeJkILavf
         xpIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUoRpfXpG2uHUzobtF7+eXst1mlhDFyg3GONu8FO7FCri9sg2JqJ2kDPCsTbkZDCDa4XVETfy/XGO+xWZlZOUg=@vger.kernel.org, AJvYcCUuLqQyQ1Xx64XP7Z8cV9tahrMT9neBd5/YjrA1+8nuiJwUpTgZ996SOCbX9kCz9LmiaDQ/dNU1z7GQ@vger.kernel.org, AJvYcCV7/liyCnaSi6pXr/RAVghDRDavNmgU5hzyjS2E7a75D5lmiLV8fpGsP3M3g84oP/GdvqLECT3F1oe1OXU=@vger.kernel.org, AJvYcCW24e17FmyA5Pjs1+gaAYWfda+GpNd5OdEIlO6su1Tuij9TjlIYs0GubbtPuBbsyURFLg1d8aUlYDCN53uu@vger.kernel.org, AJvYcCWYovufG4d3pWRDoTvCJC4ebWO3M/q+Roi0dbQKcRg3DBtOaX300dIMd3VKaq5hFmx7CyXypT/CS13GPCXXvx/jfg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzfrNGJNr47N86ueduA09yI9vouuTgOkQ7uricU6nQZYbQIwc5Z
	j4u4sYSRtZ7Fm1YkG/Ohn3jo+O94MZxl7wgVYhd8cDZwm8Lgeepb
X-Google-Smtp-Source: AGHT+IFFjIiNZ6hVLt8fi/ZvTmt9fC1vLU7epNQVpG7NK03s1C2PpXEl0QeJIAPPQaOgf4wn+YZqSg==
X-Received: by 2002:a17:902:c951:b0:20c:e65c:8c70 with SMTP id d9443c01a7336-20ce65c8e2dmr24446685ad.32.1728845251678;
        Sun, 13 Oct 2024 11:47:31 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c348f41sm52681965ad.289.2024.10.13.11.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2024 11:47:31 -0700 (PDT)
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
Subject: [PATCH 1/3] lib/min_heap: Introduce non-inline versions of min heap API functions
Date: Mon, 14 Oct 2024 02:47:01 +0800
Message-Id: <20241013184703.659652-2-visitorckw@gmail.com>
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

All current min heap API functions are marked with '__always_inline'.
However, as the number of users increases, inlining these functions
everywhere leads to a significant increase in kernel size.

In performance-critical paths, such as when perf events are enabled and
min heap functions are called on every context switch, it is important
to retain the inline versions for optimal performance. To balance this,
the original inline functions are kept, and additional non-inline
versions of the functions have been added in lib/min_heap.c.

Link: https://lore.kernel.org/20240522161048.8d8bbc7b153b4ecd92c50666@linux-foundation.org
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---


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
index 7315f643817a..a9b375cf9784 100644
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


