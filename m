Return-Path: <linux-bcache+bounces-484-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 24A6E8CE80A
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 17:34:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD3CC1F22C74
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 15:34:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B642F131BA2;
	Fri, 24 May 2024 15:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hwY+A9zx"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EDA13173A;
	Fri, 24 May 2024 15:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564662; cv=none; b=VyWOpKVKE9Qmy0zYvR4GkG3Hdc8bzBbS1K/AFvjbE9hDn9WnuU+a4z3bHGPk75a1GX+QzZpBr3ozpg8Ecmb4hjQveH4ZNGWUKJaoUENMyIDaGtc3yPWOsuHaXAp0J3I21xxbYhZlzdzfhPeWOGByAMtI4Q84Kk5jAld3huLlJGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564662; c=relaxed/simple;
	bh=FajLBoy+P54V5d595ptYE3zStWRI7+JF3jA/AgpkBC8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JZO7WFcGwoasPQZkGJOMkWyxLsJ+RbGikDKwzeeUKKsZ0R9/FL9VA0Bvfv7ddrjx/Z/pSfArMQ1OF27dv+zod4HMdaUJe4TR1lMyvlArQwS49TOSyHKd/bo3OIqWsnXGVXX82X1IDsKFT7ZA8aA7a03AN3kwkQOHjCHHQ0RqKr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hwY+A9zx; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-667fbbbf36dso348878a12.1;
        Fri, 24 May 2024 08:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716564660; x=1717169460; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fHh8oRo5IgsV+IU2cDnhd1mUOloCdZwamTIL5z7K9Kg=;
        b=hwY+A9zx0WxIsqgpUM4Y92npaDfNVZCLxZdEdM0SCn/pobZTahcgyixcsH7fSegwv0
         7HPB3cQTJK7ohunB/QW8cIjXQtgMfccc3dKthd4jQ47iYkzKzCLwqNt8fH0KMkvxrQ9A
         7ND5xsqq/H57JMGImaenTTe6YVWKW1niSEGRkBRdoeHEMNbKS3FLa2+sFlVv3+eN/aCf
         UBA1KOCnQBnKEuSkFuyz7fgiWYOi7HSxG4wL2/PKGsDGbMuBaah+Pp8Nyr1PK75oLHwn
         VTmz1glY23d3vWTWeoiF3TfOrBtzAPm11w2Sj7Z6f9mkw73LuTD/M4S1VwXIyX6rX5hm
         2nKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716564660; x=1717169460;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fHh8oRo5IgsV+IU2cDnhd1mUOloCdZwamTIL5z7K9Kg=;
        b=HUDp8o7/tbBsHbUNXwgW5VWjmYXwtbnJ5CUzcFeEIibYVbrx1iHrMfaRXz7t44Ls7S
         h7uWhKL7SpvEqLah2rVxnMZhX28lcjTZTUbD0ISVhnx97cIPGYm+ieBgc241/T3S/eKL
         taytDI6dZbkNy+Depsgn0yR8OyqBOz8AERCQSTX1jms0dC6UZr3fWZTRCGNCU9/e9znm
         c4orI543SuyBFdkia8mFIu2XUY/9ub5/U8ad/I/VCNFYb/GsvaaHvASshqQ3Mi7h8SwX
         GZuk1s96dc9dr92Mq8SwqUrB3nNRXzEIiw1A5HIAsu96HkADnXa+FKS9AXfQflc7/9ig
         +G0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUk3L2j/EjMzRbqWQIV6fLlQQHHdIVY8102BDsvH1mD2P1UY8NLyhz9Qdp/oW6sFsQWhgn/6JubCKhxRy1VhACKJdKCvJdC5fPtk+hkElrjC6zSKmtzvb9rCqCSYcHjgDtsmovSx+2CkZFU43+na8li4QEx9gw0NDBM18tN2gtbv0MirN81aGfaVBY5+kI3Idq13zb+CAnX+DGnYhGjvYs+hDGYrtUIUmz2EUxu
X-Gm-Message-State: AOJu0Yxckcrxsp9Ijk7s8qGEEM3yZVVUhy7VdLctxIR6JzR6T+qBuI2w
	NWfUzWY0ldkn2NjXZi0OpC1Ov3VC6jWrhYTjNIVaUGI9YdlfaOt6
X-Google-Smtp-Source: AGHT+IFciQWF2Y7yTOkGCbHq/4hq/tcnGDrn20ayUbkM9iebbc5ly95hjv5xZNwCquKeXBM/4haULQ==
X-Received: by 2002:a17:90b:230e:b0:2bd:76ee:48c2 with SMTP id 98e67ed59e1d1-2bf5e0a7a56mr2495670a91.0.1716564660327;
        Fri, 24 May 2024 08:31:00 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f50d294sm1525556a91.20.2024.05.24.08.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 08:30:59 -0700 (PDT)
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
Subject: [PATCH v6 11/16] lib min_heap: Update min_heap_push() and min_heap_pop() to return bool values
Date: Fri, 24 May 2024 23:29:53 +0800
Message-Id: <20240524152958.919343-12-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240524152958.919343-1-visitorckw@gmail.com>
References: <20240524152958.919343-1-visitorckw@gmail.com>
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
index 98e838195e7e..3410a5f907ad 100644
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


