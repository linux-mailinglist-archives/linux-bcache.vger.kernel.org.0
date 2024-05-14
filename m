Return-Path: <linux-bcache+bounces-454-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C2D08C4E0C
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 10:51:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6FF691F22C0C
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 08:51:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8A716D1A0;
	Tue, 14 May 2024 08:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PBu+EX1k"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4921734CE5;
	Tue, 14 May 2024 08:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676515; cv=none; b=NdL1T6cftDsBCmW7iomv6RMagmXG9NTM6zHkDGsMlvg1o+PrTys2IbiMrBenu1MvZ0u41n8X1SXVQXwwOsmY26bdP10BByueTfNZjQlSq00eee9FRUwwEvQOVV0bc1iUwHYZo3sRRDQpCZqSBMrrpr6PtpSgEGEmx+Wy4CbLwI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676515; c=relaxed/simple;
	bh=5dPWx/XCuPpHn/JbswVAX4unB6CSgL3H/O4srtepiqI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LbUkqX4sqFql3w5V+u+/AJAnYkjtEuzVVYS0TAKVGosUt9tHUZBYXl3umRB6YwwGeUAqpxSuX9kJ07VIMboxG84enybghOiWkN8c8Uqyn4wtLVpqPYARvxeZMJYdblt0XeRbXUx+0J25HR9tdS3DrAzY3ycZ6l7pvc0V3/nUJ2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PBu+EX1k; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2b6215bcd03so1229406a91.1;
        Tue, 14 May 2024 01:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676512; x=1716281312; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qStH8dSNcDcItb1wA2JtX3YjxyreJTEee2fjqsXU5t0=;
        b=PBu+EX1koj1DTkwA0/tjAmqR9kBa6OuIhRdM7SeXsoMGzHpSSAyIP5/8MguMXcT6Eo
         OdowTid81AWdG3AY+G+BcQUhCTyaalpp7bb5zHBdWTXHJUFSOH9siY9gYCwKSxuK1dzJ
         XokrWFnCCwqsCzD4sFRvF3pEvuSAy9koWQq7TXM7EIjf0UE6I6oktSCOITBVyC4AJUkP
         BE82ONShnuRMLhPYJc4lkbaNwylYi4BpcJ/VO37X1vr8aPbRaBD9tCaydT9Yw6Yrj7BL
         5IDIs/zNYjdlCzFbcQj/MlFrixRQftNy75NU0lwAyblWs6Ek5OPzmrb+/0iFAvrg4elq
         Ja0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676512; x=1716281312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qStH8dSNcDcItb1wA2JtX3YjxyreJTEee2fjqsXU5t0=;
        b=t4ZjIxl6t9W18Epro3UiMObC/M4gDEf4Osqllr+lN2TufZJik0/oTezoTiZ67VdBQW
         QcSbk8CgwK+a5EFk5iw6erUpwaDRhX21DA901DT19Oq2ghr6SfLxiFUJHbYZ7zrDoYAC
         sHIhvSQHd5Spy09CZFM+8cOVr9x8Jz9lcUZt37UpJQBXRbXnfhHlbnQCFOKcaeqVwTDL
         eKdoaI13z5Fz4ZDOK8OrXHXXf+mBdH9fuQt/ww2b5JAtC4pYY8ee8I0PTjRRiVNeDxkf
         ODIJIiDtxR5EcJNnQwyEmtFtTC111teY8z9zGLyJJj2H5laHMSydnPS8jl5lzrCBNcXr
         mEUA==
X-Forwarded-Encrypted: i=1; AJvYcCXPHweic/uhd+lfTio4Ux0fG93y980UCSs+l6RBfVzGFMZbxLiTK7Lf2C7AUpe1y3I1CvZ+D1yJsCp3eJdcLh7BI3TpxY+LVu1gi7B1IECXw5AV/P9Lew/CIGyXHTc/pD4wVIlFD4g4wJ36lrTz03iQUMjzWT+Mw2sXhFN49u6g1s1hJeFX/YHXkgduk2EULwOINWqJQa7i8nm9I6ZxadFUovMY7lfZrQlnHZQa
X-Gm-Message-State: AOJu0YwTS2ncrYRhElSSl2/kXaQLpJ/Q4fZ0yuSvSYhxD+0yZmLW2fLR
	rf+UyTIfksUUTDliOKG0ASy85JpFK0MGoFEc0jmk1lsuR7AdRw6w
X-Google-Smtp-Source: AGHT+IHAEeLtnkJPSridXVxcM1Lek6wVLa4/x7IxnsemEK0CxdtUzekeg322+ZCpZ1YXDs/kefgzeA==
X-Received: by 2002:a17:90b:354e:b0:2b5:fce8:59ef with SMTP id 98e67ed59e1d1-2b6cc452fb7mr11632999a91.1.1715676512627;
        Tue, 14 May 2024 01:48:32 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b6711660fdsm9195597a91.16.2024.05.14.01.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:48:31 -0700 (PDT)
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
Subject: [RESEND PATCH v5 12/16] lib min_heap: Rename min_heapify() to min_heap_sift_down()
Date: Tue, 14 May 2024 16:47:20 +0800
Message-Id: <20240514084724.557100-13-visitorckw@gmail.com>
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

After adding min_heap_sift_up(), the naming convention has been
adjusted to maintain consistency with the min_heap_sift_up().
Consequently, min_heapify() has been renamed to min_heap_sift_down().

Link: https://lkml.kernel.org/CAP-5=fVcBAxt8Mw72=NCJPRJfjDaJcqk4rjbadgouAEAHz_q1A@mail.gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 drivers/md/dm-vdo/repair.c |  2 +-
 include/linux/min_heap.h   | 14 +++++++-------
 kernel/events/core.c       |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
index c1ed3ae823bf..941ac9eda8ca 100644
--- a/drivers/md/dm-vdo/repair.c
+++ b/drivers/md/dm-vdo/repair.c
@@ -183,7 +183,7 @@ static struct numbered_block_mapping *sort_next_heap_element(struct repair_compl
 	 */
 	last = &repair->entries[--heap->nr];
 	swap_mappings(heap->data, last, NULL);
-	min_heapify(heap, 0, &repair_min_heap, NULL);
+	min_heap_sift_down(heap, 0, &repair_min_heap, NULL);
 	return last;
 }
 
diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 2d080f85ad0d..f907c694e852 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -75,7 +75,7 @@ bool __min_heap_full(min_heap_char *heap)
 
 /* Sift the element at pos down the heap. */
 static __always_inline
-void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
+void __min_heap_sift_down(min_heap_char *heap, int pos, size_t elem_size,
 		const struct min_heap_callbacks *func, void *args)
 {
 	void *left, *right;
@@ -108,8 +108,8 @@ void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
 	}
 }
 
-#define min_heapify(_heap, _pos, _func, _args)	\
-	__min_heapify((min_heap_char *)_heap, _pos, __minheap_obj_size(_heap), _func, _args)
+#define min_heap_sift_down(_heap, _pos, _func, _args)	\
+	__min_heap_sift_down((min_heap_char *)_heap, _pos, __minheap_obj_size(_heap), _func, _args)
 
 /* Sift up ith element from the heap, O(log2(nr)). */
 static __always_inline
@@ -139,7 +139,7 @@ void __min_heapify_all(min_heap_char *heap, size_t elem_size,
 	int i;
 
 	for (i = heap->nr / 2 - 1; i >= 0; i--)
-		__min_heapify(heap, i, elem_size, func, args);
+		__min_heap_sift_down(heap, i, elem_size, func, args);
 }
 
 #define min_heapify_all(_heap, _func, _args)	\
@@ -158,7 +158,7 @@ bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
 	/* Place last element at the root (position 0) and then sift down. */
 	heap->nr--;
 	memcpy(data, data + (heap->nr * elem_size), elem_size);
-	__min_heapify(heap, 0, elem_size, func, args);
+	__min_heap_sift_down(heap, 0, elem_size, func, args);
 
 	return true;
 }
@@ -178,7 +178,7 @@ void __min_heap_pop_push(min_heap_char *heap,
 		void *args)
 {
 	memcpy(heap->data, element, elem_size);
-	__min_heapify(heap, 0, elem_size, func, args);
+	__min_heap_sift_down(heap, 0, elem_size, func, args);
 }
 
 #define min_heap_pop_push(_heap, _element, _func, _args)	\
@@ -232,7 +232,7 @@ bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
 		return true;
 	func->swp(data + (idx * elem_size), data + (heap->nr * elem_size), args);
 	__min_heap_sift_up(heap, elem_size, idx, func, args);
-	__min_heapify(heap, idx, elem_size, func, args);
+	__min_heap_sift_down(heap, idx, elem_size, func, args);
 
 	return true;
 }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index dfd7b5748cbb..82f329c8caea 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3792,7 +3792,7 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
 
 		*evt = perf_event_groups_next(*evt, pmu);
 		if (*evt)
-			min_heapify(&event_heap, 0, &perf_min_heap, NULL);
+			min_heap_sift_down(&event_heap, 0, &perf_min_heap, NULL);
 		else
 			min_heap_pop(&event_heap, &perf_min_heap, NULL);
 	}
-- 
2.34.1


