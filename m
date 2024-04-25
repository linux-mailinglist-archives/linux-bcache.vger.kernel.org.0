Return-Path: <linux-bcache+bounces-416-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BACE48B23EB
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 16:24:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A11EBB2B720
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 14:23:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D67FF152172;
	Thu, 25 Apr 2024 14:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LVJZjucF"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762DD152166;
	Thu, 25 Apr 2024 14:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714054767; cv=none; b=L5tlKRkjTwkcPOLKQ0nLPXlC0H7Y3S1H0xjCf24JfPbbDEMKfBNYOk+7UPoQqlPXR31ylCbv4dSsVPq2ia4wdLt3Sm62Y8JimDy/4PkPGRirUEDPeHDdrtQ4gllP70qFBTu+KK6f/XTvqkXNBcaeC6fJ13iTDmYe7tBPwgpkGso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714054767; c=relaxed/simple;
	bh=PtYRw7GsavxbiDyoXt/jBI3j/cXrR77rkoPNcWtU+qo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sHjzfk8Kk7rFQXRZalrNe5kG1mJhSwekArvBaYIu+4fKu4xtkW4e7kzn57Ms/b85AdEXLeBBfpOmZ4olmMx6PFDPpjrLcq/Ii0ixvDGp3thoL1Kj7Fnloix//FOmO/H4qHqkkb7P1PmWyzWHM7HOv5TioIVBigJ8uonQgNYGt/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LVJZjucF; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6f055602a7bso56763b3a.3;
        Thu, 25 Apr 2024 07:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714054766; x=1714659566; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7EphJEt3KUebjz7mwKYHv22rhUher1RghPLhkx5N+uY=;
        b=LVJZjucFECV1tPH9qc0cv16djppOMXX9Mz6l9jG0eihKfBL2uGl0GNU81eLuTtkPVt
         SLbcgelqKMGAtgQSeg9im8Z1jbXLWhTxmypo271rMTmCHTxFMq+qm2ZdHByoKUZTUwuO
         2fcOJ3yZfFYvKW3U7ANzl++2TUWXwEUXhiri8CrSfX7aFju2YbP9aMUYIeZnqjfz5OJ1
         1x/E1xDQi0LHiKjaXZ4v5a+Rp1HIlMqMR1A7Tkf5FpZBhTyboEi/4fEzHyTVgt5VIL45
         1nKBv2gWOnpsFLzN6C88NvY0kRv/swPJqSwVPORHLlGgekH9CfGx6ARdZN4fiR+fHTYK
         25lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714054766; x=1714659566;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7EphJEt3KUebjz7mwKYHv22rhUher1RghPLhkx5N+uY=;
        b=vrEl1wkRrpVe4CKdCXgDv7iAvDlQ3iOd6Fw6EmTsef8zYDGXun3jHruEDLY5OHHIov
         vP+nFeH9Catjpo8uWjfKQHvMBTJ/xN1QQIl/utbQtTXJ/d23Oi6Kf40nFJVUgH1SBFIa
         gaCaacnUUYtGuF7j87ytrHb5aL5iUoQ8dp+OePgUx5458xevQ4Bg4GDJanhF5pfbSbXH
         P43fGtwm9gOv/owAydhtgWYtxhw2hJGk6/7DN11E7wKZJ/SXyrhoOgvxoKe/6/nr5jSb
         CboGxM2KeSQjvX4scxrnJ5GPgRRfjfmHq2HEaMoy84Onoo/UFNB9e1X+JCLu0SqiMAMJ
         cpEg==
X-Forwarded-Encrypted: i=1; AJvYcCWlYuJGMZDQwBkLl3HX+nHS6MvXgSSkC29g2M37hc087klNV1tO3TjLBTo501EUXiGpy7pBXG2sgg90/okzaKvg7ehTDYyOjOCza4kt/fzoP4IP9Zcy/PQ97BFPGDdW00Ppwuai1nLwOhISqBtIWdedGE/7VrBS9/Etu/2BidFO+MPtTRUkwbVJ92oAbPCoJBgpdlKQpRKIHUUkJzYv1rVjdwQRsmoaRervXxYR
X-Gm-Message-State: AOJu0Yz3Kegjn1hvKTjuyoxcWvReZXHLw8oYdGWMfaJFqzzOEUvx4XhW
	emhsNgLBp9KXaXoIAbYBn73vHULODaRBCYAGxfH/As+mTGla+Bea
X-Google-Smtp-Source: AGHT+IH3qvR8DEaNgNGZh5Udg5FgEG5PQHj+EW7uZq/SkmKUq2NA7t4laHBCtISEgyrlq7ewHbhqhA==
X-Received: by 2002:a05:6a20:158c:b0:1aa:68c4:3271 with SMTP id h12-20020a056a20158c00b001aa68c43271mr7357457pzj.3.1714054765579;
        Thu, 25 Apr 2024 07:19:25 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id go20-20020a056a003b1400b006e6233563cesm13162397pfb.218.2024.04.25.07.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 07:19:25 -0700 (PDT)
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
Subject: [PATCH v4 11/16] lib min_heap: Update min_heap_push() and min_heap_pop() to return bool values
Date: Thu, 25 Apr 2024 22:18:21 +0800
Message-Id: <20240425141826.840077-12-visitorckw@gmail.com>
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


