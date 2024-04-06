Return-Path: <linux-bcache+bounces-376-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 53EDF89AC43
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 18:51:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AD916B21F59
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 16:51:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E56C34BA94;
	Sat,  6 Apr 2024 16:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H0ZdPBWG"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5978E54663;
	Sat,  6 Apr 2024 16:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712422120; cv=none; b=NE+ujU6tZVy+HNbb8eH2YlW4g1qwDqKYvqiaRaeLdiZs/K33XeJK0Tiu2Gl3gfHkmFqNTELkKbON0/stea5rysk/3GRfYgfBO+gqlEZ0TPXGifWv4zfC3y5KUnZgCO2VrkOOWGhx4fj6jiWuH8oBKQf4hmBHP/LNoJMR5b9Pn9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712422120; c=relaxed/simple;
	bh=ILK0WtUWi96BNQKLJsyDtg90NnSDdPoSsO445/1dQII=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P74e+rHdJzUYRjiv9yHCTr9PJ6zwIr6VAAjUdpCcFnDvv8LdOYvYbaeUYOvCDuQm5ERi41K08FQZEfJ7fBoQuyhLQFQ5dfykIhABNV0ypGVk3ycv11LMgvQHCXa7bLPp+4Dl6m+z4FMxebvVc9sG+RXvCwkPIyZUI8xtSTmIGy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H0ZdPBWG; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-5d862e8b163so659553a12.1;
        Sat, 06 Apr 2024 09:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712422119; x=1713026919; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kgfux8MfAeQS6+qFfIDDQF2LPwPsL6hthHkisyhefZY=;
        b=H0ZdPBWGXd+TpmaN18NNwhN6Qi8rIE+XpoBXcxcahAK0tVuur+Js2QiBj27J3Z66vz
         /fqFqSKJE2wHM3PrKPgeIORyTzlW/RfxlVTVSdIb+A0leWexsj38PQH6388Rcgx3OT30
         YaGl9yBXksdoITpnFWl5vjZV9ZQVDeaQJvsJA9YJICTI/ozcoDVVVmqMtVh5DWp7ARzk
         cZnV8vdSZwjUA+r9Q2YOMwvUHwKElHBZ5WYMsDzEBQubxLqrb8wsWGGG1ZQmYO50sH11
         fgjc/6Hyq+qeDR6LDPtGqAA06pT9eY7qV5HZLMLW0V5kZwO1quqVTyN+dGnweXyVpWAm
         F06w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712422119; x=1713026919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kgfux8MfAeQS6+qFfIDDQF2LPwPsL6hthHkisyhefZY=;
        b=Wfabntj1rlBdg/c0GZAw4j7fcDZgVwadwRRtcZjg/HbYxMCIJs3ZP+H6n8SrnDC1nT
         bpm+9h+O+fMwKFIfkQsTy745CFO+NFQVYNOOiSW71Y0bAZX3nCZsO+mIouo3YrohQQSN
         iUdEAKX2WI62CGht3lBgC0mQrRmttNczU3OXCAkLfEHtOtFmrC0LdfTOXJMPl7sRL8OZ
         W8an6jNC8VG8J7ZG4CSQPyBFDFf989LxLktqEgijbZ48KMdkt1+tm67nDaNuXXn2ahIS
         rdlD/zduWaP+BblQcN4zu3v9PSwsjaNnJjIfIYWR6wY25btf4DzfV7fVu+P1gm8+AtMX
         pBCA==
X-Forwarded-Encrypted: i=1; AJvYcCV1NTLlVv9JaHPFoQugq/0MjhYqQFLi/GvBuTaXdvZP5AhIV0OYd4/2iXU2YkffDG7Kui4lH59ar4EVGbM8sFsZqJ2hs5fLlrmF744H1QQ5OqCjXc4dhZKUb8q7u4QTogwWKulc234UAy5vyKJos++MQKZMj5ypkjUczBUd1gHCk8Lw+UY16RS+MABX8p6S8KJFbZ3Mup1JKxLPndOiK83F8OohlI5LTgMkq1hA
X-Gm-Message-State: AOJu0Ywl0oKNjLOzQCUewKAy3IERODlizJvUKOcZaUSVpbK+fzB4F87g
	8a8MB4RZrBY02GKy1ghf5UaXGgztsPk07AEB8nZEcXaS7TVLTIkf
X-Google-Smtp-Source: AGHT+IHzFYEQ+Y8lB65YH/xq+fXDSfemv04Nu9isKsBYZjxWX2yXJ9bDEy0Igzc2DcHRS0YhkyUIZw==
X-Received: by 2002:a17:902:ecd2:b0:1dd:e128:16b1 with SMTP id a18-20020a170902ecd200b001dde12816b1mr5497792plh.6.1712422118743;
        Sat, 06 Apr 2024 09:48:38 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b001e2b8c91f04sm3665068plb.22.2024.04.06.09.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 09:48:38 -0700 (PDT)
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
Subject: [PATCH v3 12/17] lib min_heap: Rename min_heapify() to min_heap_sift_down()
Date: Sun,  7 Apr 2024 00:47:22 +0800
Message-Id: <20240406164727.577914-13-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240406164727.577914-1-visitorckw@gmail.com>
References: <20240406164727.577914-1-visitorckw@gmail.com>
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
index 5fe93868b33b..b7a66bfab9e6 100644
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
index 889d410862c7..3086612d7cd5 100644
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
 	memcpy(data + (idx * elem_size), data + (heap->nr * elem_size), elem_size);
 	__min_heap_sift_up(heap, elem_size, idx, func, args);
-	__min_heapify(heap, idx, elem_size, func, args);
+	__min_heap_sift_down(heap, idx, elem_size, func, args);
 
 	return true;
 }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 80f497683cf9..a64a8337d9df 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3788,7 +3788,7 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
 
 		*evt = perf_event_groups_next(*evt, pmu);
 		if (*evt)
-			min_heapify(&event_heap, 0, &perf_min_heap, NULL);
+			min_heap_sift_down(&event_heap, 0, &perf_min_heap, NULL);
 		else
 			min_heap_pop(&event_heap, &perf_min_heap, NULL);
 	}
-- 
2.34.1


