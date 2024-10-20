Return-Path: <linux-bcache+bounces-773-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 43C049A5254
	for <lists+linux-bcache@lfdr.de>; Sun, 20 Oct 2024 06:05:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B34F51F218F1
	for <lists+linux-bcache@lfdr.de>; Sun, 20 Oct 2024 04:05:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A49A41922C4;
	Sun, 20 Oct 2024 04:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="juge8A1b"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2313192599;
	Sun, 20 Oct 2024 04:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729396995; cv=none; b=kyi5VR939HKCDH9n4BfP7uxBV1IEP9T4NIo94R2RHO1ogQumW2Zd2orPJsDKAdI9v9ZQo5SguFMVyjIRE2nE97Gnc2eMB42ybGnB82jj48d3Twf4uIBTXoKB7zvF7mRDP2JvdupTrlk2XmJc7BxNoEV0+uuyszHn4znv8YFmKEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729396995; c=relaxed/simple;
	bh=P8v7bl0HUC8PgdWG90Udu7/e7VMI09byj7xPkrgmymQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MsYDMmLnDXyXq2RnDJB/ejM+cFekfDKnY1744DxhdUZGOmR46VKDaC1qNlyfDOp8nnkfb4H1PWBG1Re5EhLwPAy2Z6U0Kd8Kszv60iFGgL8OGBxzBeeQI1pae4fbeFDpCvItiri9GZAzZaaUu0JlVsor2A2891GrC3m4D+F8pX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=juge8A1b; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2e2cc47f1d7so2297366a91.0;
        Sat, 19 Oct 2024 21:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729396992; x=1730001792; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PfhCaNqjkwqDBbL7z5yBWj9nWr3RVKAleAhUoJxmWMY=;
        b=juge8A1bmvXp2101xxV3EFFfJ9cbNHMIM4Q0XHcX3EnXdb0yLPKJG2gCx1NRPWt/EK
         NehL892Tl0mv2J0PlNWJisx5Eus46QCQfqc6DV1+wxG/ValwhNjQYFjq+UYsFzjkqzrN
         9SqwZ8Vqjyr8m0Jd+mkUoDU1nzTRyILZHvkBm8kFZWsYVicErBp/CQrhLtIe10cy5TqM
         xJOrLJ21iFxXM9bwWPYfZjSqEfcdS8w/obPB/9fuTIv56muIJ2xcOQ43tXyTEPpPPCqt
         CZEpLW2sUzb1XdCmV4k/NYZ5nIL+dTEEBtJalAySBZEcAKZs3P+zEZ16SSRwPAu02j3o
         4bTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729396992; x=1730001792;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PfhCaNqjkwqDBbL7z5yBWj9nWr3RVKAleAhUoJxmWMY=;
        b=QyW2MybuWUqRYDqMojfI2wkT/JYR5Jj3ZZO2jp7Bodn9+NJkEPr5UHnMl7gZPLGNt0
         Wzdk7XzYvXTtivXqgQgqTuwXPRVm4a+qbYu/XvCPdd1aT6uc1xZ28Y2b/Fz695U09ap1
         MHyUpqsbe1OoIRGBJw8XTd/8BScRItoBQLGqUxHsUjb9Aift4BsN8W/LnR4O2VFerPrj
         lwyADjJZZFM0YUsOyQvhDsHdxM00xgGJm2XnQiKTPfvp/kKMq0bCc9JyiAZt1NszzJNV
         qdtkZzfreCDt1zSBc4upkYM87hnfXvXgeSA/2mpt5fbaA/Np88GTvOTT6/09U4PaecSa
         FCCA==
X-Forwarded-Encrypted: i=1; AJvYcCU/W4KktdXKLk6GPEIfGsEBRhC0LGkdnVGBYgIErQPgaMfrYBQxsOUdfQ9km+ylJz+32hiC2UUdNqPbep0=@vger.kernel.org, AJvYcCUdNQyo21qE7wi7U2e2G62M2SyghArqKn0ja94QZoNuNjz7l/naB4lvFTvf8/ZuOa9YfZOsPlFkcS+E@vger.kernel.org, AJvYcCVlJMuiXqjK0KFLeYSiK005t9VfEwAD4IwMXrbXw9ZWAHOsLIfG+D/JJXjO/DmnqLaRnSjEhhUmzaGtaWwQ@vger.kernel.org, AJvYcCWED+yOJhONk8HEdlnu0SpckezsHsoJh3ahVdoCOjINXn/twwNtOLscai4pUhkVwLEhUZFb7zDlNN/ljzLN/9vX6g==@vger.kernel.org, AJvYcCXrS8Pfk2k33xB6KIdRDnu1UWdCp39yd+IodpiOu5AJ2sMkLFE6ynoYzjtF+2wBsy1BJIt5vaIHKzx70ELAelg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9FK1QEEW99cRyjjt7Tep7HcQBoJvRjab43h3GflRca/i+L9yv
	UARqJJarADbyaCKzAlgvZJ0Qaj3JEWbwzex/38wvDBJcfGsKN2cC
X-Google-Smtp-Source: AGHT+IGRS93cFoJkaSz24BSwCStwXbRxjwOMLShcvR70iLhHYFKXqmS8/9zXr3Tt016pUsTc/n4+5g==
X-Received: by 2002:a17:90b:4c12:b0:2e3:bc3e:feef with SMTP id 98e67ed59e1d1-2e5644991c9mr10156817a91.3.1729396991894;
        Sat, 19 Oct 2024 21:03:11 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad3678d3sm633668a91.24.2024.10.19.21.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2024 21:03:11 -0700 (PDT)
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
Subject: [PATCH v2 10/10] Documentation/core-api: Add min heap API introduction
Date: Sun, 20 Oct 2024 12:02:00 +0800
Message-Id: <20241020040200.939973-11-visitorckw@gmail.com>
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

Introduce an overview of the min heap API, detailing its usage and
functionality. The documentation aims to provide developers with a
clear understanding of how to implement and utilize min heaps within
the Linux kernel, enhancing the overall accessibility of this data
structure.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
Changes in v2:
- Wrapped lines at 80 columns.
- Updated Example Usage.
- Added documentation for the ability to pass NULL to the swp in
  min_heap_callbacks to use the builtin swap.

 Documentation/core-api/index.rst    |   1 +
 Documentation/core-api/min_heap.rst | 300 ++++++++++++++++++++++++++++
 2 files changed, 301 insertions(+)
 create mode 100644 Documentation/core-api/min_heap.rst

diff --git a/Documentation/core-api/index.rst b/Documentation/core-api/index.rst
index 6a875743dd4b..563b8fc0002f 100644
--- a/Documentation/core-api/index.rst
+++ b/Documentation/core-api/index.rst
@@ -52,6 +52,7 @@ Library functionality that is used throughout the kernel.
    wrappers/atomic_bitops
    floating-point
    union_find
+   min_heap
 
 Low level entry and exit
 ========================
diff --git a/Documentation/core-api/min_heap.rst b/Documentation/core-api/min_heap.rst
new file mode 100644
index 000000000000..0c636c8b7aa5
--- /dev/null
+++ b/Documentation/core-api/min_heap.rst
@@ -0,0 +1,300 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+============
+Min Heap API
+============
+
+Introduction
+============
+
+The Min Heap API provides a set of functions and macros for managing min-heaps
+in the Linux kernel. A min-heap is a binary tree structure where the value of
+each node is less than or equal to the values of its children, ensuring that
+the smallest element is always at the root.
+
+This document provides a guide to the Min Heap API, detailing how to define and
+use min-heaps. Users should not directly call functions with **__min_heap_*()**
+prefixes, but should instead use the provided macro wrappers.
+
+In addition to the standard version of the functions, the API also includes a
+set of inline versions for performance-critical scenarios. These inline
+functions have the same names as their non-inline counterparts but include an
+**_inline** suffix. For example, **__min_heap_init_inline** and its
+corresponding macro wrapper **min_heap_init_inline**. The inline versions allow
+custom comparison and swap functions to be called directly, rather than through
+indirect function calls. This can significantly reduce overhead, especially
+when CONFIG_MITIGATION_RETPOLINE is enabled, as indirect function calls become
+more expensive. As with the non-inline versions, it is important to use the
+macro wrappers for inline functions instead of directly calling the functions
+themselves.
+
+Data Structures
+===============
+
+Min-Heap Definition
+-------------------
+
+The core data structure for representing a min-heap is defined using the
+**MIN_HEAP_PREALLOCATED** and **DEFINE_MIN_HEAP** macros. These macros allow
+you to define a min-heap with a preallocated buffer or dynamically allocated
+memory.
+
+Example:
+
+.. code-block:: c
+
+    #define MIN_HEAP_PREALLOCATED(_type, _name, _nr)
+    struct _name {
+        int nr;         /* Number of elements in the heap */
+        int size;       /* Maximum number of elements that can be held */
+        _type *data;    /* Pointer to the heap data */
+        _type preallocated[_nr];  /* Static preallocated array */
+    }
+
+    #define DEFINE_MIN_HEAP(_type, _name) MIN_HEAP_PREALLOCATED(_type, _name, 0)
+
+A typical heap structure will include a counter for the number of elements
+(`nr`), the maximum capacity of the heap (`size`), and a pointer to an array of
+elements (`data`). Optionally, you can specify a static array for preallocated
+heap storage using **MIN_HEAP_PREALLOCATED**.
+
+Min Heap Callbacks
+------------------
+
+The **struct min_heap_callbacks** provides customization options for ordering
+elements in the heap and swapping them. It contains two function pointers:
+
+.. code-block:: c
+
+    struct min_heap_callbacks {
+        bool (*less)(const void *lhs, const void *rhs, void *args);
+        void (*swp)(void *lhs, void *rhs, void *args);
+    };
+
+- **less** is the comparison function used to establish the order of elements.
+- **swp** is a function for swapping elements in the heap. If swp is set to
+  NULL, the default swap function will be used, which swaps the elements based on their size
+
+Macro Wrappers
+==============
+
+The following macro wrappers are provided for interacting with the heap in a
+user-friendly manner. Each macro corresponds to a function that operates on the
+heap, and they abstract away direct calls to internal functions.
+
+Each macro accepts various parameters that are detailed below.
+
+Heap Initialization
+--------------------
+
+.. code-block:: c
+
+    min_heap_init(heap, data, size);
+
+- **heap**: A pointer to the min-heap structure to be initialized.
+- **data**: A pointer to the buffer where the heap elements will be stored. If
+  `NULL`, the preallocated buffer within the heap structure will be used.
+- **size**: The maximum number of elements the heap can hold.
+
+This macro initializes the heap, setting its initial state. If `data` is
+`NULL`, the preallocated memory inside the heap structure will be used for
+storage. Otherwise, the user-provided buffer is used. The operation is **O(1)**.
+
+**Inline Version:** min_heap_init_inline(heap, data, size)
+
+Accessing the Top Element
+-------------------------
+
+.. code-block:: c
+
+    element = min_heap_peek(heap);
+
+- **heap**: A pointer to the min-heap from which to retrieve the smallest
+  element.
+
+This macro returns a pointer to the smallest element (the root) of the heap, or
+`NULL` if the heap is empty. The operation is **O(1)**.
+
+**Inline Version:** min_heap_peek_inline(heap)
+
+Heap Insertion
+--------------
+
+.. code-block:: c
+
+    success = min_heap_push(heap, element, callbacks, args);
+
+- **heap**: A pointer to the min-heap into which the element should be inserted.
+- **element**: A pointer to the element to be inserted into the heap.
+- **callbacks**: A pointer to a `struct min_heap_callbacks` providing the
+  `less` and `swp` functions.
+- **args**: Optional arguments passed to the `less` and `swp` functions.
+
+This macro inserts an element into the heap. It returns `true` if the insertion
+was successful and `false` if the heap is full. The operation is **O(log n)**.
+
+**Inline Version:** min_heap_push_inline(heap, element, callbacks, args)
+
+Heap Removal
+------------
+
+.. code-block:: c
+
+    success = min_heap_pop(heap, callbacks, args);
+
+- **heap**: A pointer to the min-heap from which to remove the smallest element.
+- **callbacks**: A pointer to a `struct min_heap_callbacks` providing the
+  `less` and `swp` functions.
+- **args**: Optional arguments passed to the `less` and `swp` functions.
+
+This macro removes the smallest element (the root) from the heap. It returns
+`true` if the element was successfully removed, or `false` if the heap is
+empty. The operation is **O(log n)**.
+
+**Inline Version:** min_heap_pop_inline(heap, callbacks, args)
+
+Heap Maintenance
+----------------
+
+You can use the following macros to maintain the heap's structure:
+
+.. code-block:: c
+
+    min_heap_sift_down(heap, pos, callbacks, args);
+
+- **heap**: A pointer to the min-heap.
+- **pos**: The index from which to start sifting down.
+- **callbacks**: A pointer to a `struct min_heap_callbacks` providing the
+  `less` and `swp` functions.
+- **args**: Optional arguments passed to the `less` and `swp` functions.
+
+This macro restores the heap property by moving the element at the specified
+index (`pos`) down the heap until it is in the correct position. The operation
+is **O(log n)**.
+
+**Inline Version:** min_heap_sift_down_inline(heap, pos, callbacks, args)
+
+.. code-block:: c
+
+    min_heap_sift_up(heap, idx, callbacks, args);
+
+- **heap**: A pointer to the min-heap.
+- **idx**: The index of the element to sift up.
+- **callbacks**: A pointer to a `struct min_heap_callbacks` providing the
+  `less` and `swp` functions.
+- **args**: Optional arguments passed to the `less` and `swp` functions.
+
+This macro restores the heap property by moving the element at the specified
+index (`idx`) up the heap. The operation is **O(log n)**.
+
+**Inline Version:** min_heap_sift_up_inline(heap, idx, callbacks, args)
+
+.. code-block:: c
+
+    min_heapify_all(heap, callbacks, args);
+
+- **heap**: A pointer to the min-heap.
+- **callbacks**: A pointer to a `struct min_heap_callbacks` providing the
+  `less` and `swp` functions.
+- **args**: Optional arguments passed to the `less` and `swp` functions.
+
+This macro ensures that the entire heap satisfies the heap property. It is
+called when the heap is built from scratch or after many modifications. The
+operation is **O(n)**.
+
+**Inline Version:** min_heapify_all_inline(heap, callbacks, args)
+
+Removing Specific Elements
+--------------------------
+
+.. code-block:: c
+
+    success = min_heap_del(heap, idx, callbacks, args);
+
+- **heap**: A pointer to the min-heap.
+- **idx**: The index of the element to delete.
+- **callbacks**: A pointer to a `struct min_heap_callbacks` providing the
+  `less` and `swp` functions.
+- **args**: Optional arguments passed to the `less` and `swp` functions.
+
+This macro removes an element at the specified index (`idx`) from the heap and
+restores the heap property. The operation is **O(log n)**.
+
+**Inline Version:** min_heap_del_inline(heap, idx, callbacks, args)
+
+Other Utilities
+===============
+
+- **min_heap_full(heap)**: Checks whether the heap is full.
+  Complexity: **O(1)**.
+
+.. code-block:: c
+
+    bool full = min_heap_full(heap);
+
+- `heap`: A pointer to the min-heap to check.
+
+This macro returns `true` if the heap is full, otherwise `false`.
+
+**Inline Version:** min_heap_full_inline(heap)
+
+- **min_heap_empty(heap)**: Checks whether the heap is empty.
+  Complexity: **O(1)**.
+
+.. code-block:: c
+
+    bool empty = min_heap_empty(heap);
+
+- `heap`: A pointer to the min-heap to check.
+
+This macro returns `true` if the heap is empty, otherwise `false`.
+
+**Inline Version:** min_heap_empty_inline(heap)
+
+Example Usage
+=============
+
+An example usage of the min-heap API would involve defining a heap structure,
+initializing it, and inserting and removing elements as needed.
+
+.. code-block:: c
+
+    #include <linux/min_heap.h>
+
+    int my_less_function(const void *lhs, const void *rhs, void *args) {
+        return (*(int *)lhs < *(int *)rhs);
+    }
+
+    struct min_heap_callbacks heap_cb = {
+        .less = my_less_function,    /* Comparison function for heap order */
+        .swp  = NULL,                /* Use default swap function */
+    };
+
+    void example_usage(void) {
+        /* Pre-populate the buffer with elements */
+        int buffer[5] = {5, 2, 8, 1, 3};
+        /* Declare a min-heap */
+        DEFINE_MIN_HEAP(int, my_heap);
+
+        /* Initialize the heap with preallocated buffer and size */
+        min_heap_init(&my_heap, buffer, 5);
+
+        /* Build the heap using min_heapify_all */
+        my_heap.nr = 5;  /* Set the number of elements in the heap */
+        min_heapify_all(&my_heap, &heap_cb, NULL);
+
+        /* Peek at the top element (should be 1 in this case) */
+        int *top = min_heap_peek(&my_heap);
+        pr_info("Top element: %d\n", *top);
+
+        /* Pop the top element (1) and get the new top (2) */
+        min_heap_pop(&my_heap, &heap_cb, NULL);
+        top = min_heap_peek(&my_heap);
+        pr_info("New top element: %d\n", *top);
+
+        /* Insert a new element (0) and recheck the top */
+        int new_element = 0;
+        min_heap_push(&my_heap, &new_element, &heap_cb, NULL);
+        top = min_heap_peek(&my_heap);
+        pr_info("Top element after insertion: %d\n", *top);
+    }
-- 
2.34.1


