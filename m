Return-Path: <linux-bcache+bounces-1120-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E01BAD452B
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Jun 2025 23:56:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E27D2189DC11
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Jun 2025 21:57:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ED6328935F;
	Tue, 10 Jun 2025 21:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dmjRq7R8"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D643288C97;
	Tue, 10 Jun 2025 21:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749592556; cv=none; b=giGiZ1C3hOe6IS0g+wLUHxGRcJu6qp6cvDJ+q+SxP32v6L7IjkfKBmNqRFDSTtQOg61eqaphYxalUtX6sHnW2weciPHBVRw73e0mhoxmymYH+yIiOu04gZkNYAokWDn342KilLD+hxtO4nJ5x8rZ4kEtt0mBMAubHgVErAc7VgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749592556; c=relaxed/simple;
	bh=fUeS6/Vyn/oNJQVYOs02gdftCzFaXcIHbY3SNFQncaM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZsPbdq0OAobfD+9nnBLoISjVqwUF4nbOZCtI+BYpsdSGGItvAI3ws8Cs0bt1tRKTXPN4SZkSjpHZvTAuLSUyJmBd2zC/10gj2r1a7KJB9eGrwRYlzOLNszTapUQbajevWMYy9Eei/21bbdmTtETTMAN8S++F4sjDKDilN/M94oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dmjRq7R8; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-747fba9f962so287374b3a.0;
        Tue, 10 Jun 2025 14:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749592554; x=1750197354; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1G7eaRRqGjkGvebk6j0la3Mkm/63JnRkY3vM18k9jZI=;
        b=dmjRq7R86Q4vqFppa91ebNXCylNsXlE+67kBVfAiryeK+n3qxmU/Ani6Ej2sbM/S3X
         rHImkpd04nSARyXVskSq77phjmlfguzxith+FBGwCsHzPVt5iOH1wCHUavI6ol7GdD/q
         R9v4q6CMkhohvQO8GS1/BrEP3lWc19hRkWAfnuRNTMKm3FPNFcHkIFGTwKxdJcg0VHb4
         JUp/B9TYmyTC6xzfeMbBlltoYzgmgXrCPhHCaP4Iz4ROa4Yg0uKvnzEzkd/q9w6T++Kp
         atAWldDR1v8xJ4R26UWC47ylEZ5Rws9a6PFo+DogNBdxvysv/br8PKdOm8Hl9+TA+8R+
         zfUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749592554; x=1750197354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1G7eaRRqGjkGvebk6j0la3Mkm/63JnRkY3vM18k9jZI=;
        b=nGPmg0C/9Q2ky/0rn57wZlzYgy4YDUDxqIWCzwTAwFoqUllpSEc0z6gMXMy1y+/iBn
         kwbBfxVfbWwqNT82eyNArAK18FB01tOGMbELz2aF24msYxuk1xBrfFjoIjhEE5AAH8yu
         S3YlKbpfuwdcyA2cs9tv4/dPcIfXJwq/c+o4EJtHBIfuF7X7Vh+TyRh7X7Cc3YDOv1OW
         SlEyJGa878VrjKc+/bMzcm3GUgpU9aOVlwQ3NPbAVgVo1tSUuhfczG9a09rSTPdZNqH7
         S28m6BHJrettvnDzFbWG2a9+s+K2AWI/SS+w0O1q1wg4DXQHsB1BRFUQ/HoamaIAtTEa
         rdOw==
X-Forwarded-Encrypted: i=1; AJvYcCVwnxJsTcJehJiWh6iDtbtpHsQn1+cufSUHdMrP11XEOeRBed4j/tXec0lRA55QACx44xPCq8aCn0xH@vger.kernel.org, AJvYcCWMj7QD4cKOFmAcJGHYagPYXAEVw4pOHscgmfinpxxY/Ll1SL3C+NIbnmKDLwxN/LWxT9l+/I/JP5nzDEY=@vger.kernel.org, AJvYcCXuiOfGm6AwWG0MK1ue9jku8a5Opf/FlWJHvhcRzu5cQzhggbLDQX1l0wsWrgqkqWsHA0XwMGOL@vger.kernel.org
X-Gm-Message-State: AOJu0YzuXoMUD4RC74tu0vc/OsJwANEwOj/j2U0pC2t0wRzfxZB5FIGj
	jvasxW3R/QOd68M6k8LtGEl8qVDA6yQro5aE6m8poDRJQGLYUCoi0uAT
X-Gm-Gg: ASbGncvwu08aW/Wu4um9IBbIPqcp8r3BaZTkEsDpCCRdpQ6ULlPJ1HQrkjDUwoDqbXl
	jMqsu/x8k45mj27xUOuHv8s2Duk5OCsEmn0KaI+akAw6nEFMv7M5hzDx9fsB80Gkx/VMudrMR8Z
	K1ajhL40TxhMWhNMf+zArYsYqEdOmYGwWs5uvQZm2W6ADCtcZ5dW1XvoQCEGmAtJPEgKVkDdlYu
	J49A67nam41GbGnrtRsKZj9AUqWxO7z5F+amTkka04Sy0V4Ksf6r25aD+atYv7CHItQ+y9Jh0Mb
	hOq+Ph29kRubrDWa6SjXNi4EYmAgc62b6Du6SMmqv/gpq9wGGtn9tMSI/LKnUQS+Lj+Z/238TJh
	4Qs3v0Zv89qwH7HXD
X-Google-Smtp-Source: AGHT+IHyIdD3/Aq06IxXb9ae11pBBcRrtkebaArhqrFX1tAmaLQXcbx/2DQWgBoMZ17+AqWIBY0ksQ==
X-Received: by 2002:a05:6a20:3d8b:b0:215:d41d:9183 with SMTP id adf61e73a8af0-21f86ddf674mr1409019637.1.1749592553691;
        Tue, 10 Jun 2025 14:55:53 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482af3a165sm8173936b3a.11.2025.06.10.14.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 14:55:53 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: corbet@lwn.net,
	colyli@kernel.org,
	kent.overstreet@linux.dev,
	akpm@linux-foundation.org,
	robertpang@google.com
Cc: linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	jserv@ccns.ncku.edu.tw,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 4/8] lib min_heap: add eqaware variant of min_heap_pop()
Date: Wed, 11 Jun 2025 05:55:12 +0800
Message-Id: <20250610215516.1513296-5-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250610215516.1513296-1-visitorckw@gmail.com>
References: <20250610215516.1513296-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce min_heap_pop_eqaware() as a variant of min_heap_pop() that
uses the equality-aware version of sift_down, which is implemented in a
top-down manner.

This top-down sift_down reduces the number of comparisons from
O(log2(n)) to O(1) in cases where many elements have equal priority. It
enables more efficient heap construction when the heap contains a large
number of equal elements.

Cc: stable@vger.kernel.org # 6.11+
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 include/linux/min_heap.h | 19 ++++++++++++++-----
 lib/min_heap.c           |  4 ++--
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index c2f6e1450505..6c45d617b027 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -392,9 +392,11 @@ void __min_heapify_all_inline(min_heap_char *heap, size_t elem_size,
 /* Remove minimum element from the heap, O(log2(nr)). */
 static __always_inline
 bool __min_heap_pop_inline(min_heap_char *heap, size_t elem_size,
-			   const struct min_heap_callbacks *func, void *args)
+			   const struct min_heap_callbacks *func, void *args, bool eqaware)
 {
 	void *data = heap->data;
+	siftdown_fn_t sift_down = eqaware ? __min_heap_sift_down_eqaware_inline :
+					    __min_heap_sift_down_inline;
 
 	if (WARN_ONCE(heap->nr <= 0, "Popping an empty heap"))
 		return false;
@@ -402,14 +404,18 @@ bool __min_heap_pop_inline(min_heap_char *heap, size_t elem_size,
 	/* Place last element at the root (position 0) and then sift down. */
 	heap->nr--;
 	memcpy(data, data + (heap->nr * elem_size), elem_size);
-	__min_heap_sift_down_inline(heap, 0, elem_size, func, args);
+	sift_down(heap, 0, elem_size, func, args);
 
 	return true;
 }
 
 #define min_heap_pop_inline(_heap, _func, _args)	\
 	__min_heap_pop_inline(container_of(&(_heap)->nr, min_heap_char, nr),	\
-			      __minheap_obj_size(_heap), _func, _args)
+			      __minheap_obj_size(_heap), _func, _args, false)
+
+#define min_heap_pop_eqaware_inline(_heap, _func, _args)	\
+	__min_heap_pop_inline(container_of(&(_heap)->nr, min_heap_char, nr),	\
+			      __minheap_obj_size(_heap), _func, _args, true)
 
 /*
  * Remove the minimum element and then push the given element. The
@@ -495,7 +501,7 @@ void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
 void __min_heapify_all(min_heap_char *heap, size_t elem_size,
 		       const struct min_heap_callbacks *func, void *args, bool eqaware);
 bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
-		    const struct min_heap_callbacks *func, void *args);
+		    const struct min_heap_callbacks *func, void *args, bool eqaware);
 void __min_heap_pop_push(min_heap_char *heap, const void *element, size_t elem_size,
 			 const struct min_heap_callbacks *func, void *args);
 bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
@@ -526,7 +532,10 @@ bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
 			  __minheap_obj_size(_heap), _func, _args, true)
 #define min_heap_pop(_heap, _func, _args)	\
 	__min_heap_pop(container_of(&(_heap)->nr, min_heap_char, nr),	\
-		       __minheap_obj_size(_heap), _func, _args)
+		       __minheap_obj_size(_heap), _func, _args, false)
+#define min_heap_pop_eqaware(_heap, _func, _args)	\
+	__min_heap_pop(container_of(&(_heap)->nr, min_heap_char, nr),	\
+		       __minheap_obj_size(_heap), _func, _args, true)
 #define min_heap_pop_push(_heap, _element, _func, _args)	\
 	__min_heap_pop_push(container_of(&(_heap)->nr, min_heap_char, nr), _element,	\
 			    __minheap_obj_size(_heap), _func, _args)
diff --git a/lib/min_heap.c b/lib/min_heap.c
index a422cfaff196..dae3ed39421a 100644
--- a/lib/min_heap.c
+++ b/lib/min_heap.c
@@ -49,9 +49,9 @@ void __min_heapify_all(min_heap_char *heap, size_t elem_size,
 EXPORT_SYMBOL(__min_heapify_all);
 
 bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
-		    const struct min_heap_callbacks *func, void *args)
+		    const struct min_heap_callbacks *func, void *args, bool eqaware)
 {
-	return __min_heap_pop_inline(heap, elem_size, func, args);
+	return __min_heap_pop_inline(heap, elem_size, func, args, eqaware);
 }
 EXPORT_SYMBOL(__min_heap_pop);
 
-- 
2.34.1


