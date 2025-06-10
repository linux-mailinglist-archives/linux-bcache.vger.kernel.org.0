Return-Path: <linux-bcache+bounces-1122-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C5143AD4532
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Jun 2025 23:57:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 503A0189DF64
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Jun 2025 21:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 171D7286D55;
	Tue, 10 Jun 2025 21:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iFdMN45S"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56EDF289E0D;
	Tue, 10 Jun 2025 21:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749592562; cv=none; b=VGnP0dAguGUluDjs6riEt+MDT2LUH+JCCpQZWs5OJSdGcmg1bkdDYRasacv06rXYl6/B06WUL0jsw+B/1JnR767dYZaxomLna/uMrf3K6kgPy5q+27Cobt5WuvZt+GMzGgp8lxrMjFZITk28gotEQlq7pfUy5nK3RCea/7UReFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749592562; c=relaxed/simple;
	bh=6FjiVADOpffTB4OKsgReq4RSKaWa9lCG0AbMrz33DJw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qj9jiwXXbCyYktJlbR//UBUn/LuRH8sba+IDVAhAkFsfH3IarjHizx5g6kmheqUfSUL5Wb3S9ORFs4UEb9mgHfydZlglYt1ySVkzw0XxxRqiyMUH2TdoYGryiXHfPsVVE3z3Jyi/uwK6IXWsfuxA5TBsJql+sX2xcyFE8Gv9EVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iFdMN45S; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-747fc7506d4so5645673b3a.0;
        Tue, 10 Jun 2025 14:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749592560; x=1750197360; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V6jmS0+ScxTBm8NjCp8+r15uCKiXE5fpNNx5LvrjUOY=;
        b=iFdMN45Sa7WRyBguyICP4UjFXQcGu+hToqlvju+LcaowlJ0tiNv3qpD7UZKjv3/21l
         nJZiZ2muB4r/1Cf88Lra+M+76XmMv3hyhlxBr41iM2Y+KTRG7jgzpJmwK2RDOBP7LacS
         +qcxMcrkRuJPsyClsLpV/8pPb126meaW5gEZgWyixA9K4cRyyf2/99m8dwr1b8+oXAvh
         3bj6Cz2PRuZOodsMGRK9ML0kI0kC/uUlyAJYFdbyKPKQ2wP7SMVLVYVLkTVUbrv01lYq
         yLXnew+uZKqFpZcIWGCfYUTC4UzbCqgY1xJF5mc/jbsXTMYw4HIbsXyMazd9L4vQvEcY
         53RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749592560; x=1750197360;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V6jmS0+ScxTBm8NjCp8+r15uCKiXE5fpNNx5LvrjUOY=;
        b=FUPnnIJdfcJht7+NoOJC2c39F3m/GYNVazBf9aUhvt9qtFjyF5l+9UG/g8+e0+gZeL
         v8M83oGujkvjSXyJug/4IcTLH1KLAO2ZV+oAC6Pz44YaeFii/QWNCnMECa3NqAE0ubL7
         pCa5zjzzcla8KWd4mEpimNC3Q40JmAgnG1OwJt6ZHXn8+ypfOpSlGE8DN/PswWytImMM
         8HQdXc1XZTGx8jzU51Uj43/xttKcWGN478rgg08Mc4LKlPdE1DXR7Sf59CVBRdYwvAx8
         lWqP/qZhtAL3lKfz6quheDS4m09jFAIzLw2UJs6bbectQvhy3GvXa+FuTnfTnN8702Fd
         XOjg==
X-Forwarded-Encrypted: i=1; AJvYcCUaebO6B8tfF8vgTBFox8XonWOZ7di7I7N21nU8rBKlAVCekaz5r4D/5wGvJXJL8JnTF8E4MOqDCCqD@vger.kernel.org, AJvYcCWAYw5S9aH2UwnPhecFprJukbrfDV5dFdSoM/DQb/5OrlI+cTd1QKkV84dZKhwz+S8GWZ0fO2ubv8OfQ3c=@vger.kernel.org, AJvYcCXFKLjAV0ouK8MaBQoj3/VaanotSOB7n2wjdE9WIi7vr21D5vqsQTntJdsmjMBELfJBPtLtA4MF@vger.kernel.org
X-Gm-Message-State: AOJu0YyO9ITp1cgxR143/wM7ThqEj0itBmKmQ8dI3qA/9XMvj8o8gmGw
	x56oLbImoJQa1Ye9y1+VV4EOlMYjCs3Prs4H4djqCgLKIhMz9a7v7qyP
X-Gm-Gg: ASbGncs42T1i/JVmpW/FwSSTSqJ9XE1zzXiChBuhHwCyu3e9p4nOJkLe4BigwvG4sRN
	H08OdaU5GlyQqPG+iprgeU30YD4YRnOV2fyDv5Ad6prMDFA+VAgICOUwbpRU96JoQJVdRxAKyp6
	PN5jUn5wonBHQXG7h9zJ6n49dpNOhdyWMMe9Okg2hSzdNG2yf57pezxO+siRprZkaxCm02SRRX6
	wLGFx15N3YjU9U0hLCkw+SWQPk5q35YVd5kdVOvVPY1okeg9sTlfxUs+2QCYHH/IxNUewyn8gjU
	HNLzfbLkq9siQYH0lBdJGKYClup50tbmHCOHPSmq64PkHodi64nZD2pYYjF+ZrAqIkHY1q3V0dk
	1VGF62LSzNdlhU2qmbxOOh6lbE0g=
X-Google-Smtp-Source: AGHT+IFEWtDIB4I39e5rga0i+J3zViT0j9OTc1015dCmQIyX4iRajsViaEtHKF0u5yu+QSDAX7Uhxw==
X-Received: by 2002:a05:6a00:b91:b0:746:2a0b:3dc8 with SMTP id d2e1a72fcca58-7486ce65e9bmr1210787b3a.17.1749592559698;
        Tue, 10 Jun 2025 14:55:59 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482af3a165sm8173936b3a.11.2025.06.10.14.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 14:55:59 -0700 (PDT)
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
Subject: [PATCH 6/8] lib min_heap: add eqaware variant of min_heap_del()
Date: Wed, 11 Jun 2025 05:55:14 +0800
Message-Id: <20250610215516.1513296-7-visitorckw@gmail.com>
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

Introduce min_heap_del_eqaware() as a variant of min_heap_del() that
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
index d7bf8dd0f6b1..f34df8dd2e17 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -470,10 +470,12 @@ bool __min_heap_push_inline(min_heap_char *heap, const void *element, size_t ele
 /* Remove ith element from the heap, O(log2(nr)). */
 static __always_inline
 bool __min_heap_del_inline(min_heap_char *heap, size_t elem_size, size_t idx,
-			   const struct min_heap_callbacks *func, void *args)
+			   const struct min_heap_callbacks *func, void *args, bool eqaware)
 {
 	void *data = heap->data;
 	void (*swp)(void *lhs, void *rhs, void *args) = func->swp;
+	siftdown_fn_t sift_down = eqaware ? __min_heap_sift_down_eqaware_inline :
+					    __min_heap_sift_down_inline;
 
 	if (WARN_ONCE(heap->nr <= 0, "Popping an empty heap"))
 		return false;
@@ -487,14 +489,18 @@ bool __min_heap_del_inline(min_heap_char *heap, size_t elem_size, size_t idx,
 		return true;
 	do_swap(data + (idx * elem_size), data + (heap->nr * elem_size), elem_size, swp, args);
 	__min_heap_sift_up_inline(heap, elem_size, idx, func, args);
-	__min_heap_sift_down_inline(heap, idx, elem_size, func, args);
+	sift_down(heap, idx, elem_size, func, args);
 
 	return true;
 }
 
 #define min_heap_del_inline(_heap, _idx, _func, _args)	\
 	__min_heap_del_inline(container_of(&(_heap)->nr, min_heap_char, nr),	\
-			      __minheap_obj_size(_heap), _idx, _func, _args)
+			      __minheap_obj_size(_heap), _idx, _func, _args, false)
+
+#define min_heap_del_eqaware_inline(_heap, _idx, _func, _args)	\
+	__min_heap_del_inline(container_of(&(_heap)->nr, min_heap_char, nr),	\
+			      __minheap_obj_size(_heap), _idx, _func, _args, true)
 
 void __min_heap_init(min_heap_char *heap, void *data, size_t size);
 void *__min_heap_peek(struct min_heap_char *heap);
@@ -514,7 +520,7 @@ void __min_heap_pop_push(min_heap_char *heap, const void *element, size_t elem_s
 bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 		     const struct min_heap_callbacks *func, void *args);
 bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
-		    const struct min_heap_callbacks *func, void *args);
+		    const struct min_heap_callbacks *func, void *args, bool eqaware);
 
 #define min_heap_init(_heap, _data, _size)	\
 	__min_heap_init(container_of(&(_heap)->nr, min_heap_char, nr), _data, _size)
@@ -554,6 +560,9 @@ bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
 			__minheap_obj_size(_heap), _func, _args)
 #define min_heap_del(_heap, _idx, _func, _args)	\
 	__min_heap_del(container_of(&(_heap)->nr, min_heap_char, nr),	\
-		       __minheap_obj_size(_heap), _idx, _func, _args)
+		       __minheap_obj_size(_heap), _idx, _func, _args, false)
+#define min_heap_del_eqaware(_heap, _idx, _func, _args)	\
+	__min_heap_del(container_of(&(_heap)->nr, min_heap_char, nr),	\
+		       __minheap_obj_size(_heap), _idx, _func, _args, true)
 
 #endif /* _LINUX_MIN_HEAP_H */
diff --git a/lib/min_heap.c b/lib/min_heap.c
index a69d8b80d443..50f224f174d5 100644
--- a/lib/min_heap.c
+++ b/lib/min_heap.c
@@ -70,8 +70,8 @@ bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 EXPORT_SYMBOL(__min_heap_push);
 
 bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
-		    const struct min_heap_callbacks *func, void *args)
+		    const struct min_heap_callbacks *func, void *args, bool eqaware)
 {
-	return __min_heap_del_inline(heap, elem_size, idx, func, args);
+	return __min_heap_del_inline(heap, elem_size, idx, func, args, eqaware);
 }
 EXPORT_SYMBOL(__min_heap_del);
-- 
2.34.1


