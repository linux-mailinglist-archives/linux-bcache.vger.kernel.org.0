Return-Path: <linux-bcache+bounces-748-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D3FC99BAEB
	for <lists+linux-bcache@lfdr.de>; Sun, 13 Oct 2024 20:48:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CA87DB211BA
	for <lists+linux-bcache@lfdr.de>; Sun, 13 Oct 2024 18:48:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F7A414A0AA;
	Sun, 13 Oct 2024 18:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SjTWfyHP"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1C014A099;
	Sun, 13 Oct 2024 18:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728845268; cv=none; b=c/vGwiH/czfGI78IxZ83JCmuqBLjf6M/MmgXgT3jG4T6/hCxH8j243d0lwPpjCyWCiEAyefrokoFxvgPZeTOJDMX7vDJrAkk+ceI/fo6dW9GX6BNZJlTAjSe3G6/BoNIoOTgRzshSJEnB3TCZjMKMT7BBiS/Ti5DM7Lwk5/fFb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728845268; c=relaxed/simple;
	bh=c7WKBTPrmngq9myKPpfy/pZOPQyNCg+U1tfIRJk85Bg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q5eeb4N3/3c5mlE0IZ28yn0wjA/cDIua4AtBH911Q0gRUclcSRUk1xDGz9lnsK34oyUgyx6H+4R9JmZD1Cl0RICRIyuIvEhM01GYfYBhVRH3YgCeKr2Bn+uKhCUtizTvWUddlUKCkxrwMRgCG+vW/ld6FmQ1rIOaKQwIPs50LfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SjTWfyHP; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-20ce5e3b116so2379645ad.1;
        Sun, 13 Oct 2024 11:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728845266; x=1729450066; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1/mFOHpPMXuU8k7f+cnkaZVTuGcgYo1bsIZNqqH7oLs=;
        b=SjTWfyHPMjUOz65Ike3G3C+EiIVyK1bFFw1r0zBzapjMcY6re7jP2LOrmX5WtjIWpt
         lW1jWt6nBlujIbFEXgZpsQNNdBcK/97r15Gg9+r7gUcS865bwbh10TXYx9Nu/ENIvNio
         A0h7tVgEPrsBcA9RUvfz+EXB2Zu7LxIQACLvVlIDXh1ypsuUZk5iOqR50AiM+MGjtX7z
         t3eTcgOw7zycCWPzyy3FZlCh6I4Jc+TH6WhbSPYhmGpCNUC/v5uOWx57JA1kmUrZCyEK
         zTHhxz1IOA6/C22EAVODcS24zrSEiyuOfWMuimrB3goXJxUfyblDk2tY1c3cwVWPuIrp
         rAYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728845266; x=1729450066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1/mFOHpPMXuU8k7f+cnkaZVTuGcgYo1bsIZNqqH7oLs=;
        b=QbKzoFYwMfqCZkU9Qn1DGG22YptMGxodfD+gNUV1NxG0UiSw4/t6SXRYC9ofbSyWqb
         0I9EI7Gzkfag01kbFJ7KmkwiuUd1xGUUlK6XNArCY/iDE7hJFYEpVZHyMBqV2eOtYaYT
         AoVAyXr5tbhw1xbdVWpA4A8+K4bp1bKt7h7zAcvLD/Xq933dJ/N1RhF60LjH5JpoVJU6
         IquT+qDaAEHZKeVNc2iRPBt4vNlBMW/2far1qT5zG4MjhmhIdB9xJehO+ia/ZNNcxd2b
         9IY9vVdNFCcOnlQaT4x1l+x4t2PKrvhU5ycnhTTtnFrOleMBl2k0X98tpyLblM4EC9fB
         8s7A==
X-Forwarded-Encrypted: i=1; AJvYcCUC7gkah3J3+u4gTISPTKSwQrh9zfI8ZHeoAhGS+9De2xaJxFSAF4c6vcGqS5AU28sf6Qhj9fC5opXWvXXqEdE=@vger.kernel.org, AJvYcCVFnV5+s+rnF4BiRscbyAL++2rE56OoO1frqTnwt+wi9FapX9MfrleIxVnfW/1U4NsuSwDcS9lXvoU/0iM0@vger.kernel.org, AJvYcCVHYlQEGNnt10ujCj2yuAr/od+FbCp9/6tlcwljZyNvpsSUInzo9HDZRL1P/0ZnLYOxDkuZMyFapNvZOuw=@vger.kernel.org, AJvYcCW7/Xf/PMrUvb3+dD7wjc81XdibSLJROMUPD2n0Z41k/hD3n8cSa8sDsC6yf0Zbuxe0FfWqI7A18Xbo@vger.kernel.org, AJvYcCW9JvGMjm3UVmcUykP9X6XRh5hT9Y7oj+8xG3EF8unzMbVn3nOhUQDYoMJ4aJ0zQZI3JwvJUdJvqW3F02u8oCc4pg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyZ3KrctzWX5Htka0fdAPEfO6bat6i5+Jp/CaOnpHB6T9cC3G+D
	98EVckdIOtgp3ieQE8Kmn+FIY9UHWxzgXtV/1fagSIq/hW9bzOHO
X-Google-Smtp-Source: AGHT+IHrJrJ/x7XXN2RAQDJ5hnFXXhKF8r06t7Er8uLmJc/maAa5w8TH/7bHy/qsVMx3a1vWpKIQSQ==
X-Received: by 2002:a17:903:32c9:b0:20c:528d:7063 with SMTP id d9443c01a7336-20cbb196046mr94002585ad.19.1728845265938;
        Sun, 13 Oct 2024 11:47:45 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c348f41sm52681965ad.289.2024.10.13.11.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2024 11:47:45 -0700 (PDT)
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
Subject: [PATCH 3/3] Documentation/core-api: Add min heap API introduction
Date: Mon, 14 Oct 2024 02:47:03 +0800
Message-Id: <20241013184703.659652-4-visitorckw@gmail.com>
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

Introduce an overview of the min heap API, detailing its usage and
functionality. The documentation aims to provide developers with a
clear understanding of how to implement and utilize min heaps within
the Linux kernel, enhancing the overall accessibility of this data
structure.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 Documentation/core-api/index.rst    |   1 +
 Documentation/core-api/min_heap.rst | 291 ++++++++++++++++++++++++++++
 2 files changed, 292 insertions(+)
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
index 000000000000..dd2cc5a32fd7
--- /dev/null
+++ b/Documentation/core-api/min_heap.rst
@@ -0,0 +1,291 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+============
+Min Heap API
+============
+
+Introduction
+============
+
+The Min Heap API provides a set of functions and macros for managing min-heaps in the Linux kernel.
+A min-heap is a binary tree structure where the value of each node is less than or equal to the
+values of its children, ensuring that the smallest element is always at the root.
+
+This API supports efficient insertion, deletion, and access to the minimum element. It is optimized
+for use in systems with performance constraints and is suitable for scenarios where the minimum
+element needs to be accessed or updated frequently.
+
+This document provides a guide to the Min Heap API, detailing how to define and use min-heaps.
+Please note that users should not directly call functions with **__min_heap_*()** names, but should
+instead use the provided macro wrappers.
+
+In addition to the standard version of the functions, the API also includes a set of inline
+versions for performance-critical scenarios. These inline functions have the same names as their
+non-inline counterparts but include an **_inline** suffix. For example, **__min_heap_init_inline**
+and its corresponding macro wrapper **min_heap_init_inline**. As with the non-inline versions, it
+is important to use the macro wrappers for inline functions instead of directly calling the
+functions themselves.
+
+Data Structures
+===============
+
+Min-Heap Definition
+-------------------
+
+The core data structure for representing a min-heap is defined using the **MIN_HEAP_PREALLOCATED**
+and **DEFINE_MIN_HEAP** macros. These macros allow you to define a min-heap with a preallocated
+buffer or dynamically allocated memory.
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
+A typical heap structure will include a counter for the number of elements (`nr`), the maximum
+capacity of the heap (`size`), and a pointer to an array of elements (`data`). Optionally, you can
+specify a static array for preallocated heap storage using **MIN_HEAP_PREALLOCATED**.
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
+- **swp** is a function for swapping elements in the heap.
+
+Macro Wrappers
+==============
+
+The following macro wrappers are provided for interacting with the heap in a user-friendly manner.
+Each macro corresponds to a function that operates on the heap, and they abstract away direct calls
+to internal functions.
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
+- **data**: A pointer to the buffer where the heap elements will be stored. If `NULL`, the preallocated buffer within the heap structure will be used.
+- **size**: The maximum number of elements the heap can hold.
+
+This macro initializes the heap, setting its initial state. If `data` is `NULL`, the preallocated
+memory inside the heap structure will be used for storage. Otherwise, the user-provided buffer is
+used. The operation is **O(1)**.
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
+- **heap**: A pointer to the min-heap from which to retrieve the smallest element.
+
+This macro returns a pointer to the smallest element (the root) of the heap, or `NULL` if the heap
+is empty. The operation is **O(1)**.
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
+- **callbacks**: A pointer to a `struct min_heap_callbacks` providing the `less` and `swp` functions.
+- **args**: Optional arguments passed to the `less` and `swp` functions.
+
+This macro inserts an element into the heap. It returns `true` if the insertion was successful and
+`false` if the heap is full. The operation is **O(log n)**.
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
+- **callbacks**: A pointer to a `struct min_heap_callbacks` providing the `less` and `swp` functions.
+- **args**: Optional arguments passed to the `less` and `swp` functions.
+
+This macro removes the smallest element (the root) from the heap. It returns `true` if the element
+was successfully removed, or `false` if the heap is empty. The operation is **O(log n)**.
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
+- **callbacks**: A pointer to a `struct min_heap_callbacks` providing the `less` and `swp` functions.
+- **args**: Optional arguments passed to the `less` and `swp` functions.
+
+This macro restores the heap property by moving the element at the specified index (`pos`) down the
+heap until it is in the correct position. The operation is **O(log n)**.
+
+**Inline Version:** min_heap_sift_down_inline(heap, pos, callbacks, args)
+
+.. code-block:: c
+
+    min_heap_sift_up(heap, idx, callbacks, args);
+
+- **heap**: A pointer to the min-heap.
+- **idx**: The index of the element to sift up.
+- **callbacks**: A pointer to a `struct min_heap_callbacks` providing the `less` and `swp` functions.
+- **args**: Optional arguments passed to the `less` and `swp` functions.
+
+This macro restores the heap property by moving the element at the specified index (`idx`) up the
+heap. The operation is **O(log n)**.
+
+**Inline Version:** min_heap_sift_up_inline(heap, idx, callbacks, args)
+
+.. code-block:: c
+
+    min_heapify_all(heap, callbacks, args);
+
+- **heap**: A pointer to the min-heap.
+- **callbacks**: A pointer to a `struct min_heap_callbacks` providing the `less` and `swp` functions.
+- **args**: Optional arguments passed to the `less` and `swp` functions.
+
+This macro ensures that the entire heap satisfies the heap property. It is called when the heap is
+built from scratch or after many modifications. The  operation is **O(n)**.
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
+- **callbacks**: A pointer to a `struct min_heap_callbacks` providing the `less` and `swp` functions.
+- **args**: Optional arguments passed to the `less` and `swp` functions.
+
+This macro removes an element at the specified index (`idx`) from the heap and restores the heap
+property. The operation is **O(log n)**.
+
+**Inline Version:** min_heap_del_inline(heap, idx, callbacks, args)
+
+Other Utilities
+===============
+
+- **min_heap_full(heap)**: Checks whether the heap is full. Complexity: **O(1)**.
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
+- **min_heap_empty(heap)**: Checks whether the heap is empty. Complexity: **O(1)**.
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
+    /* Define a preallocated heap for storing up to 10 elements */
+    MIN_HEAP_PREALLOCATED(int, my_heap, 10);
+
+    struct min_heap_callbacks callbacks = {
+        .less = my_less,  /* Custom comparison function */
+        .swp = my_swap,   /* Custom swap function */
+    };
+
+    /* Initialize the heap using the preallocated buffer */
+    min_heap_init(&my_heap, NULL, ARRAY_SIZE(my_heap.preallocated));
+
+    /* If we have an external buffer, we can use it instead */
+    int external_buffer[20];
+    min_heap_init(&my_heap, external_buffer, ARRAY_SIZE(external_buffer));
+
+    /* Insert elements into the heap */
+    int new_element = 5;
+    if (!min_heap_full(&my_heap)) {
+        min_heap_push(&my_heap, &new_element, &callbacks, NULL);
+    }
+
+    /* Peek at the minimum element (without removing it) */
+    int *min_element = min_heap_peek(&my_heap);
+
+    /* Replace the root of the heap with a new element */
+    int replacement_element = 3;
+    min_heap_pop_push(&my_heap, &replacement_element, &callbacks, NULL);
+
+    /* Reorder the heap by sifting down from a given position */
+    min_heap_sift_down(&my_heap, 0, &callbacks, NULL);
+
+    /* Remove the minimum element from the heap */
+    if (!min_heap_empty(&my_heap)) {
+        min_heap_pop(&my_heap, &callbacks, NULL);
+    }
+
+    /* Insert more elements into the heap */
+    new_element = 8;
+    if (!min_heap_full(&my_heap)) {
+        min_heap_push(&my_heap, &new_element, &callbacks, NULL);
+    }
+
+    /* Delete an element from the heap at a specific index */
+    int idx_to_delete = 2;
+    min_heap_del(&my_heap, idx_to_delete, &callbacks, NULL);
+
+    /* Ensure the entire heap maintains heap order */
+    min_heapify_all(&my_heap, &callbacks, NULL);
-- 
2.34.1


