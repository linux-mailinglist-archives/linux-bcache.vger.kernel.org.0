Return-Path: <linux-bcache+bounces-453-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BEA958C4E09
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 10:50:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70A9E282AFF
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 08:50:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4309564CCC;
	Tue, 14 May 2024 08:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KczmbKJf"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7726BFA8;
	Tue, 14 May 2024 08:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676510; cv=none; b=Dh2P9A6/QXPg8VuNKy7U2+3hb/dG+/hXYEk4H9u3g0pB13YuXVp4N2/iX04YGhwMQDQNxjukzddwQr2ZC5QG+t6ETrbV2OZAPC0u2aYDjT3gj8Ve+tTvotvs5Ox9TtmA+f2xHqndizuciIPFKw48aFSWrsqXGLJewJHwRjJOhRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676510; c=relaxed/simple;
	bh=PtYRw7GsavxbiDyoXt/jBI3j/cXrR77rkoPNcWtU+qo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TQtSd2QKlUQx6yicxKQkUJ3LGxPULPrpsXHzwrlAcXtQCSMA6qgWux9uJPF12/98OX+5RQDEKWXWvzuMMwTw7AXyfjOJ7Q3Ng0scV0olAhZ6oN46RU7qnGHDA8TbhUy0B9BHPSd4dQ1FaOpr1m5bjGd4Ec4KWGRiVg+DQM/KStY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KczmbKJf; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2b432ae7dabso1398327a91.0;
        Tue, 14 May 2024 01:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676507; x=1716281307; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7EphJEt3KUebjz7mwKYHv22rhUher1RghPLhkx5N+uY=;
        b=KczmbKJfkJKLcFv/xaqOqEMRIwl4gaZso5N5q/RB2hXwuhg0nXnBLJ8RU00DWpGfVi
         cLH6YnNl91XjKskdlxn8+5ip2ztjEQ4enCRwlUx5dYvQS713Pj7jhI6K8UK3pi0fNK22
         Z96wlJT6y5rf+VbtuZwOndnNuHn2rNG3FZKBqZgQ7cXJGh4JQvGcJrzA2gERvGOoNKJa
         Yd7sYi2lyxVQtJcQ9v0fWhMMTqDHsvRyA0WO/yz/92maaYxAlIovE6+iGX5aO10M1O8L
         Lz+KBMpH8fVgO36HtSvpghmk/2yw8GfzK6iGuyQm3qK8OJlXkBm4q29/kqbxvX8dLEXx
         oyDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676507; x=1716281307;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7EphJEt3KUebjz7mwKYHv22rhUher1RghPLhkx5N+uY=;
        b=F7FC18dKyp1in47pZU2XlkkXi82iKKgz+UI6xVP3tFG+5JgGmd6oF1/DCyTjjjF/y2
         mXX6aop24u0Sxp1TzyUph1Tv9IpCn5RjfDci0D72tGeyz+szu8G9Wq9ddxFjnvqWiByf
         RKEUyQsZeSuHFht6pQCMKOxxJi70NpROfHbVkC9JcPH5WkXid5Bx5JnY6u+QkzPy2yXc
         a1oymT3lWHm+OrvfVS8gv8Nx7ACIx2b6P2kP7H6qofDkSWmtqnRzC3s5D8n6EgFV/Nrt
         U3q54d4aWnVbQaTndbO1xPR+UMZnbyj9PQqDCRHeMdYBV+T/qa3eJqp6zv1H8jEHFcUy
         RGQA==
X-Forwarded-Encrypted: i=1; AJvYcCW/QAvCBcNRHRm290r6+nOxQ1OE/s8sdjY9PC118MQ+5W1LW3LGnsvYnpFRTwznB1e/XsLS4GYmzEjngmYUuKaKGmghu/VkRUw7Vp9nfYbTtw0O1VPBAKn3/R1BXe0Gpmjv+mCnhE3QkFtWKIxV+wR6QexoZRCUIhsvjj3Z9AywsxMsFhI8f4DcOcrs8EkAsPmhQUIeQ0sqwxlnFdJ9fJuwlSDZmInpE0ckZxFS
X-Gm-Message-State: AOJu0YwneqS/gfLVYVx8dDGTmmi7CrWmQ+AAg2tVRIqtTcKq7IGtHJDD
	gLmwYPedd84T9NKjqXinZzQcA9CCnZUw4nswcgSSSTo5ngl4O9Gm
X-Google-Smtp-Source: AGHT+IGfQAYvZHJMtREHiuCy2r7Eecel/8/3etErb19WpLLlg8BfpElH6/usKz1uG/RUviA8uzRF3A==
X-Received: by 2002:a17:90a:e2cd:b0:2b1:88bb:20ed with SMTP id 98e67ed59e1d1-2b6ccd69770mr11166476a91.2.1715676507633;
        Tue, 14 May 2024 01:48:27 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b6711660fdsm9195597a91.16.2024.05.14.01.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:48:26 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: colyli@suse.de,
	kent.overstreet@linux.dev,
	msakai@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	akpm@linux-foundation.org
Cc: bfoster@redhat.com,
	mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	bagasdotme@gmail.com,
	jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [RESEND PATCH v5 11/16] lib min_heap: Update min_heap_push() and min_heap_pop() to return bool values
Date: Tue, 14 May 2024 16:47:19 +0800
Message-Id: <20240514084724.557100-12-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240514084724.557100-1-visitorckw@gmail.com>
References: <20240514084724.557100-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Modify the min_heap_push() and min_heap_pop() to return a boolean
value. They now return false when the operation fails and true when it
succeeds.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index c94f9d303205..2d080f85ad0d 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -147,18 +147,20 @@ void __min_heapify_all(min_heap_char *heap, size_t elem_size,
 
 /* Remove minimum element from the heap, O(log2(nr)). */
 static __always_inline
-void __min_heap_pop(min_heap_char *heap, size_t elem_size,
+bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
 		const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
 
 	if (WARN_ONCE(heap->nr <= 0, "Popping an empty heap"))
-		return;
+		return false;
 
 	/* Place last element at the root (position 0) and then sift down. */
 	heap->nr--;
 	memcpy(data, data + (heap->nr * elem_size), elem_size);
 	__min_heapify(heap, 0, elem_size, func, args);
+
+	return true;
 }
 
 #define min_heap_pop(_heap, _func, _args)	\
@@ -184,7 +186,7 @@ void __min_heap_pop_push(min_heap_char *heap,
 
 /* Push an element on to the heap, O(log2(nr)). */
 static __always_inline
-void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
+bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 		const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
@@ -192,7 +194,7 @@ void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 	int pos;
 
 	if (WARN_ONCE(heap->nr >= heap->size, "Pushing on a full heap"))
-		return;
+		return false;
 
 	/* Place at the end of data. */
 	pos = heap->nr;
@@ -207,6 +209,8 @@ void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 			break;
 		func->swp(parent, child, args);
 	}
+
+	return true;
 }
 
 #define min_heap_push(_heap, _element, _func, _args)	\
-- 
2.34.1


