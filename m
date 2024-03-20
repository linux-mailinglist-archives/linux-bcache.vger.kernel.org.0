Return-Path: <linux-bcache+bounces-339-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F27538813E5
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 15:58:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1ECD61C22801
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 14:58:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35DCE5FBA0;
	Wed, 20 Mar 2024 14:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pqzek390"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAB15FB9C;
	Wed, 20 Mar 2024 14:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710946524; cv=none; b=Z8xgwHojBLRW3jeTn169YtzWMLHRZcVSO2g9PXqPuPk6UGaoXThzDta0SrAJzUi/HsPm4ToEvBsmY6iTPutlfWT1CFT3KujaPWhEbPB3b08bfu417EyrsOJt/O+Tbkvso5eolyUnlOsfLb7KxJifoM77PHPJzTlJQUnajbti9e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710946524; c=relaxed/simple;
	bh=nCQxYZsgsRAx/5f4AE04kZbnhBIilxiKGZiKSwq7sAs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fkuDRB/eC2WNUf9sacnHPSOfhw9oCyfWfScMwrxV22ObWFLbNhpoSjkb6EesyhW+93j4wnSVtKMY8XGBpO9Z9fsVh2dNpihFbhEv9gXRe6InZHKrQIEy8/IG9NSV2qUXOPr1nZjNT6mqWThf7RG2+z7NAusSp27N300WQUqopSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pqzek390; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1def81ee762so9761165ad.0;
        Wed, 20 Mar 2024 07:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710946522; x=1711551322; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HQTQoXpl9kZmZcCaoDjVcMBQxJEeqtUU5fbEvGOwL9A=;
        b=Pqzek3907vBez4C6PSU8c5k5qPitMFXDKkDx/0CDqia1xxxxcY9EU6rSavJLUq63CX
         40cpRtaha3vdrFAMOibZE7wwdvLpVyyMZb4wXoOGn1JQfE2x+ykVPe6FtqnJmK42eeHu
         JBDXQA/IKHbfG7VUb8gJuxufHmia9cbycabL15Kkiw56qbdNpRAl5KO7mD0iMgmh2Xzj
         tHJ75L1pUj68hVycINwRX/G5+88V+PxWC4bo8eJV2tiOm1xQKaFLpmrHpMP0AJFUcljG
         Crg4XgBU1OAhNYOPsy700S+noOHpPrrsV8nc6Ixbmp8zF4yL8PXDns6z8z4AlpMvpl5n
         mbUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710946522; x=1711551322;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HQTQoXpl9kZmZcCaoDjVcMBQxJEeqtUU5fbEvGOwL9A=;
        b=ItnT1XroVrVFI8yiigvzTJOirGQARFZEitA+Jwe+6g7dNJSThpnpBiPKiELVOopOt1
         5rlfR0ekuCKXSmVLU3KTQYYprBy+e11aH3lcV98C4JhlqduMcYxLnSLzobs0cqq++RHd
         ZsyPY2ejSdJhlLnG2gnnSxmeDL97aQCdP6Br4SvF2fw57mvSdeiseGtrSeT3uUQMH2Uw
         U0ph56iWkL3RMdHw7eW4YPHxiLQTAAsSsLz1Av7q0OFzhJoxQAMl7D7AnO24JGlJ9/YD
         WoN320wcQru/agvQRFGrDkzf5ZMhrGyw1C42Tmhsw8PEhjnS4WKqn/TnWcU3GaqRi3IG
         D4fg==
X-Forwarded-Encrypted: i=1; AJvYcCVmuIm16/q2bceSu2gkc/P2jXNb2N39MCXqBhnB9r+Vetm/PvKf/XyUfGKIuGxyAQ3ytbc9g5cJ0glpFw7U0LpAn9VZOdzSA+9pGYq/tQf2pU+SJbAEn4bzQ57UdWfA0F2sOFf0MUX52TqJh0LcmupMhIC041VizSEUnTtTbWYkNP3QjK5tUxfHIn1WxuZs54vuNy7a+1Nv2+eqeybkbqFsB0OYUNxQNdoxk+JY
X-Gm-Message-State: AOJu0Yz+lULmhkS5RXUEjR7w0QrohCyoK+WYUcQ59BO9gMk9N/PWSxpM
	T2NyzRBEffqdLKWwKRQPleXwUUVsmJwT1QEz/HCpCsv1nbQ5FtRn
X-Google-Smtp-Source: AGHT+IEVgULr7fKahVSqb9Mn8wh/rmuWNNtX4qJfG3yVKS6HTCYRncGWrGCpJXxKSTFPl2pdaEjEKw==
X-Received: by 2002:a17:902:c94d:b0:1dc:e469:6f5d with SMTP id i13-20020a170902c94d00b001dce4696f5dmr6104360pla.4.1710946521802;
        Wed, 20 Mar 2024 07:55:21 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id la11-20020a170902fa0b00b001dc30f13e6asm13719989plb.137.2024.03.20.07.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 07:55:21 -0700 (PDT)
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
	dm-devel@lists.linux.dev,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH v2 12/15] lib min_heap: Rename min_heapify() to min_heap_sift_down()
Date: Wed, 20 Mar 2024 22:54:14 +0800
Message-Id: <20240320145417.336208-13-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240320145417.336208-1-visitorckw@gmail.com>
References: <20240320145417.336208-1-visitorckw@gmail.com>
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
---
 drivers/md/dm-vdo/repair.c |  2 +-
 include/linux/min_heap.h   | 14 +++++++-------
 kernel/events/core.c       |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
index 6acaebcd305d..e99f908bbdb9 100644
--- a/drivers/md/dm-vdo/repair.c
+++ b/drivers/md/dm-vdo/repair.c
@@ -183,7 +183,7 @@ static struct numbered_block_mapping *sort_next_heap_element(struct repair_compl
 	 */
 	last = &repair->entries[--heap->heap.nr];
 	swap_mappings(heap->heap.data, last, NULL);
-	min_heapify(heap, 0, &repair_min_heap, NULL);
+	min_heap_sift_down(heap, 0, &repair_min_heap, NULL);
 	return last;
 }
 
diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 586965977104..436997070f4e 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -78,7 +78,7 @@ bool __min_heap_full(struct __min_heap *heap)
 
 /* Sift the element at pos down the heap. */
 static __always_inline
-void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
+void __min_heap_sift_down(struct __min_heap *heap, int pos, size_t elem_size,
 		const struct min_heap_callbacks *func, void *args)
 {
 	void *left, *right;
@@ -111,8 +111,8 @@ void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
 	}
 }
 
-#define min_heapify(_heap, _pos, _func, _args)	\
-	__min_heapify(&(_heap)->heap, _pos, __minheap_obj_size(_heap), _func, _args)
+#define min_heap_sift_down(_heap, _pos, _func, _args)	\
+	__min_heap_sift_down(&(_heap)->heap, _pos, __minheap_obj_size(_heap), _func, _args)
 
 /* Floyd's approach to heapification that is O(nr). */
 static __always_inline
@@ -122,7 +122,7 @@ void __min_heapify_all(struct __min_heap *heap, size_t elem_size,
 	int i;
 
 	for (i = heap->nr / 2 - 1; i >= 0; i--)
-		__min_heapify(heap, i, elem_size, func, args);
+		__min_heap_sift_down(heap, i, elem_size, func, args);
 }
 
 #define min_heapify_all(_heap, _func, _args)	\
@@ -141,7 +141,7 @@ bool __min_heap_pop(struct __min_heap *heap, size_t elem_size,
 	/* Place last element at the root (position 0) and then sift down. */
 	heap->nr--;
 	memcpy(data, data + (heap->nr * elem_size), elem_size);
-	__min_heapify(heap, 0, elem_size, func, args);
+	__min_heap_sift_down(heap, 0, elem_size, func, args);
 
 	return true;
 }
@@ -161,7 +161,7 @@ void __min_heap_pop_push(struct __min_heap *heap,
 		void *args)
 {
 	memcpy(heap->data, element, elem_size);
-	__min_heapify(heap, 0, elem_size, func, args);
+	__min_heap_sift_down(heap, 0, elem_size, func, args);
 }
 
 #define min_heap_pop_push(_heap, _element, _func, _args)	\
@@ -235,7 +235,7 @@ bool __min_heap_del(struct __min_heap *heap, size_t elem_size, size_t idx,
 		return true;
 	memcpy(data, data + (heap->nr * elem_size), elem_size);
 	__min_heap_sift_up(heap, elem_size, idx, func, args);
-	__min_heapify(heap, idx, elem_size, func, args);
+	__min_heap_sift_down(heap, idx, elem_size, func, args);
 
 	return true;
 }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index c32a78c489f3..314fb7ea4ec3 100644
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


