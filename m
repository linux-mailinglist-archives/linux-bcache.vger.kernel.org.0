Return-Path: <linux-bcache+bounces-417-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 437568B23EA
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 16:23:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF6F528686F
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 14:23:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEEC415252D;
	Thu, 25 Apr 2024 14:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TF+96Ggf"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AD4152166;
	Thu, 25 Apr 2024 14:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714054773; cv=none; b=axgAZc+7ehqdCq8/qupa8LpKOWekW6CpBjbCjwmm7vMVKgiQ12UuDuZwcCcT6eamEapE0EjmEn8XhJsOG2WR04YYpRQJx9/LB26KCRcIHDG3wJYQ752LA+BqZiwr63jQuvKSbjCZYHfT8wJ93hCfZmm2ftd7YOisBcQ+05HStM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714054773; c=relaxed/simple;
	bh=5dPWx/XCuPpHn/JbswVAX4unB6CSgL3H/O4srtepiqI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DmZTnA4PmGv1tfvnjEYQNm85cV512pNSv05kfMO4BESlNzIt4QYyc+fHbzdPBpYA5IvHIz9xOUeWhE5krBGNvyQ1DP3j3s3gTdQX9wy1J5jm/l+6bRhPWc8xrelKlMo0zItm+cNuHV3S867kdJNwDJugM6OuyNCs2Sor40OD3p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TF+96Ggf; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1e7af7eb4ccso508015ad.1;
        Thu, 25 Apr 2024 07:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714054770; x=1714659570; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qStH8dSNcDcItb1wA2JtX3YjxyreJTEee2fjqsXU5t0=;
        b=TF+96Ggfs/nQLY9BFcdcFWvzS2g2h6VfGzgiD0hbPKVxGLteihV4N0rUrvV1QUYM7U
         Ro13DP7DglIANAUQ2KzLYhMFzQtSFJ5ejvi48XbIZtAtTajvBjwG37Kv3fPvQHCT3HgC
         H0xI9Fnambpq0q8C8Akcr7VVB9VPXOw71p5M17n85Xtx5y1nyGSyKU79sT2d4hMv/Wj3
         2ZS6YMIR06ExCGjF7ym+QU5t+hbEe8mUHoPzWMJ8poi75N3WgVMwjhXtx8OyBNhIzkQW
         nnbQrn2oumZARraU2w/9YOfKMef3o42ZFf9PPKGHG9tm6Nojd8jFiecLm1MeKUhf0Irx
         pxjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714054770; x=1714659570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qStH8dSNcDcItb1wA2JtX3YjxyreJTEee2fjqsXU5t0=;
        b=XCf9PPsBxKRxzjzUxK0uU7AHjKITVUqmrSgN4nQjQaSsB3cZU4evVnocvf7ZCfbhRy
         rStSBO7tVRjJpFyKVwwEPwL0EndfcHvoRvasLatv3IHXFNiU2Q4ZM7TpNF1K5GKVAG4m
         j/rQZvq2P1viyesATX/tkL2lXr0XmQIxf4OsEBCHHkYJMfywGp8fgXK/FXav/JTkDMti
         U+WUdAVTwfSL+maTkco1giXpZL1WRcItJDjpvadU1iuuZpQnw+nfX7TgFsrmCfiUG4Yh
         OXKCFUVyq8KRpJPHOt20HqpLVyfoq1YCT7YufdlnCLBtg/Y01eXSd0JglZNaF5poRZzu
         awiA==
X-Forwarded-Encrypted: i=1; AJvYcCUAPnJduhCnUhalWMPUQ67l1ofpeOhf2kebRRPCGuIewaXnuvnBB3aAMiOyLyApK5zmvgqWW2AQPfyKlboHAmoT/E5E96vKEqV6ZoZyQquS3UhvWwI9Q+mq/+eYJ3sPmkxjkP+VeHD4F7JDAaPwIYZJ0xk/HIc2Vvre6RnY7CB1I84OFnMFEL8cRAcrBrPdyeBAAzn5Kvqqi3T+caauNc/+X1A1NEXWFH1gtYPU
X-Gm-Message-State: AOJu0YxZlXqcsaNeJ7ZEfbbXmX0oi2/WStLmxOUrAAnA9ojhkFT/FSMD
	Il5cxsqgNQJn7VI6e9/7t6aBcAtwwSApC/SxSCSSFA3GVampHvig
X-Google-Smtp-Source: AGHT+IEGyEh1HXQB5D75l1NpiLH+qNvawfkhTxq9Yiz7LQYh6fcgF54wNcIjLptvO8b3R2IbMMWmHA==
X-Received: by 2002:a05:6a00:718b:b0:6ea:df65:ff80 with SMTP id li11-20020a056a00718b00b006eadf65ff80mr6441795pfb.3.1714054770223;
        Thu, 25 Apr 2024 07:19:30 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id go20-20020a056a003b1400b006e6233563cesm13162397pfb.218.2024.04.25.07.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 07:19:29 -0700 (PDT)
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
	jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH v4 12/16] lib min_heap: Rename min_heapify() to min_heap_sift_down()
Date: Thu, 25 Apr 2024 22:18:22 +0800
Message-Id: <20240425141826.840077-13-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240425141826.840077-1-visitorckw@gmail.com>
References: <20240425141826.840077-1-visitorckw@gmail.com>
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


