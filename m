Return-Path: <linux-bcache+bounces-1121-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 92465AD452E
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Jun 2025 23:57:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E8069188A080
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Jun 2025 21:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EDB7289824;
	Tue, 10 Jun 2025 21:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aJ/M21Q7"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C6F28980E;
	Tue, 10 Jun 2025 21:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749592559; cv=none; b=W4kH5U1F/aNrKQkNDMpM9qcVIlkeY8vgB9yclYAUT3wi/k+3NqvJzq4IJL2NGmu51QZM7BfzxOPvHHSPyU2o6gPaOBihyael3Yh3yYVthI7Hy9MjJ2LTzFqW6TycRHtwNuy9yth+w3lPYdn0vXSyZD8KQMKPpA45FyacI6zpZKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749592559; c=relaxed/simple;
	bh=hW2fZUEDQaFktP5Vtr+9Yl7P4kGi1EPcEwv3Y16UAYk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LonWYLcIOObYhdjAS/d9e9y0Ot/JoM/7mpOhvxIbFiYS7e2MXsOWbuGmaubJzwjLWoLKzBcWc4conMcgtlqFXyiahmIpOfiigMpkL2BXE9s2Cc3p6CV1N0VVIJtGFTMsJoLMjHypjeEapwRUoW+H8b2sJWoYe05/kdBr/NjVOfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aJ/M21Q7; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-742c73f82dfso4916705b3a.2;
        Tue, 10 Jun 2025 14:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749592557; x=1750197357; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BtakGyg52Wz02P8YR6DX5ZIEzU9byszu4duVnMtZc5w=;
        b=aJ/M21Q7pP0oR2neaCVA+cH1EvzT12Th7ipLQfN6Gtpe+SHn7a6imB1KxcStvjKohD
         7zXeeTn1st3058RrIv7aOAnEqtyHj7+VUfWG0X12ZEjpeCcH3ar7BPTvkKU4PjaGrUhB
         kL22Vm1ih+8V/5nOHQzXLxIJQEC6KAip1I4ISaj9mpsYuExClScE86uUEtyg1ZR/sM6i
         OnY8SelMxoRHujHzKKtF9gJh7P53zh937SAzjlaB0F7z5omogOU7iqQhqKwg97O0PiyN
         gQDo/Sdj6kiQB7YaaiHP1hT1pKbxxwPx2HOmSQv0BA+IZRvPZQ9x6zeqVPVnBvdsWlVZ
         Ayqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749592557; x=1750197357;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BtakGyg52Wz02P8YR6DX5ZIEzU9byszu4duVnMtZc5w=;
        b=r6Md0MVtZBERmUT8bC0PTspnJVwVJ9FimUg5JhLkBgk7m0D4VW5zEoB0Flc1w/rtWf
         jJzWykURSPkG48CaWfYbD46DZsPKb9bpwInq4LLJFlpPaE6nlWPc2rzqAfMaEsmT4Fly
         4l5drtKxGKYG4dR+m7Nc0CL5pQA/y6Ln49BEPw1jUPiqSaqP2Zkcuj1b+HQmWP/GVK4C
         +t9cgJPMx73i4PmFiOZHdVQ9IM0pEUD/G8/fLYtg8rnaDTOz/bNKl7uuAhxt9mAq6jvE
         lSeS6JNaZ19klvG4iy/9Kv/JK5x8FMN7rs3GGJSQ1D7GpCtsQQO0aId3Z4ii3hIyasF2
         tYSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgZewhgasD8emEDjGTAiCiX8PgtRRUDNKP9H+TqJX8wRrlG7+or1LHuVTVImCfM7MU2OpkmXlx@vger.kernel.org, AJvYcCXhtYuir3gHwcOQL/sjIK5DwlbzbvEZ6myqy7lDxdt39XepjKmYh4FxnVBjW7zl1HH5tEDf668JGZiAucU=@vger.kernel.org, AJvYcCXhxnDQDcaPEPcwqHPikyXMj53MacKTGzQuTYDd0/8hD2hmNfEUcGmgKdPxi+xAmRU25Oh1VWKVSZNF@vger.kernel.org
X-Gm-Message-State: AOJu0YwaByl9EVpcoi1dMGiU2WKptclfFh79eMsrW2ixtSyneG68YsWS
	OAkyHPn5cvFGuFvo5xGNgcCc51J3D2u6AQAobUuebgLUu+bzaOOv/yqN
X-Gm-Gg: ASbGncvXSsWTRxldNNtua6pjZWAMirGE3TvOPau54nsrrC0RfZm/SSJy/oHWy3f3/Ad
	An8ZGn/Jj3H2Cda6X01RTn/Vg0me7VQSHiGk9MhgQETtSuoncVMcXdUYz7ELS8Op/idKfBNFBov
	Y82WXq4IWE5rkGDmUqgumW/N4iTMtjsl76fk1abL99ViGFJc6kxBv5MyCcHQhf6JDdc5xoNhZVD
	sKd4DAcH0DOfQshzLT/+HCxElkK+MVwMd2mycH8I30O/HSZboRGmipCKZU0hlyNYfbUfF+/ajzV
	qD3QD0LWG/Mg7aTGuqqOfWeumUUdYjJalbwaadL0F7pO1wQVmq2HA5O/5NDUp73prAN1I0bsGdf
	ZqVU6NxqPLkMjDX7sKte1SC4ri7k=
X-Google-Smtp-Source: AGHT+IGQHld1qf30FkznFT4c/oq1R9BvUHCzEDFJUwbNqEzD2CIQqJSwKoOf8lub0QtTer7TZsWN2A==
X-Received: by 2002:a05:6a20:3ca5:b0:218:bb70:bd23 with SMTP id adf61e73a8af0-21f86746e08mr1315798637.42.1749592556661;
        Tue, 10 Jun 2025 14:55:56 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482af3a165sm8173936b3a.11.2025.06.10.14.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 14:55:56 -0700 (PDT)
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
Subject: [PATCH 5/8] lib min_heap: add eqaware variant of min_heap_pop_push()
Date: Wed, 11 Jun 2025 05:55:13 +0800
Message-Id: <20250610215516.1513296-6-visitorckw@gmail.com>
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

Introduce min_heap_pop_push_eqaware() as a variant of
min_heap_pop_push() that uses the equality-aware version of sift_down,
which is implemented in a top-down manner.

This top-down sift_down reduces the number of comparisons from
O(log2(n)) to O(1) in cases where many elements have equal priority. It
enables more efficient heap construction when the heap contains a large
number of equal elements.

Cc: stable@vger.kernel.org # 6.11+
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 include/linux/min_heap.h | 20 +++++++++++++++-----
 lib/min_heap.c           |  4 ++--
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 6c45d617b027..d7bf8dd0f6b1 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -424,15 +424,22 @@ bool __min_heap_pop_inline(min_heap_char *heap, size_t elem_size,
  */
 static __always_inline
 void __min_heap_pop_push_inline(min_heap_char *heap, const void *element, size_t elem_size,
-				const struct min_heap_callbacks *func, void *args)
+				const struct min_heap_callbacks *func, void *args, bool eqaware)
 {
+	siftdown_fn_t sift_down = eqaware ? __min_heap_sift_down_eqaware_inline :
+					    __min_heap_sift_down_inline;
+
 	memcpy(heap->data, element, elem_size);
-	__min_heap_sift_down_inline(heap, 0, elem_size, func, args);
+	sift_down(heap, 0, elem_size, func, args);
 }
 
 #define min_heap_pop_push_inline(_heap, _element, _func, _args)	\
 	__min_heap_pop_push_inline(container_of(&(_heap)->nr, min_heap_char, nr), _element,	\
-				   __minheap_obj_size(_heap), _func, _args)
+				   __minheap_obj_size(_heap), _func, _args, false)
+
+#define min_heap_pop_push_eqaware_inline(_heap, _element, _func, _args)	\
+	__min_heap_pop_push_inline(container_of(&(_heap)->nr, min_heap_char, nr), _element,	\
+				   __minheap_obj_size(_heap), _func, _args, true)
 
 /* Push an element on to the heap, O(log2(nr)). */
 static __always_inline
@@ -503,7 +510,7 @@ void __min_heapify_all(min_heap_char *heap, size_t elem_size,
 bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
 		    const struct min_heap_callbacks *func, void *args, bool eqaware);
 void __min_heap_pop_push(min_heap_char *heap, const void *element, size_t elem_size,
-			 const struct min_heap_callbacks *func, void *args);
+			 const struct min_heap_callbacks *func, void *args, bool eqaware);
 bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 		     const struct min_heap_callbacks *func, void *args);
 bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
@@ -538,7 +545,10 @@ bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
 		       __minheap_obj_size(_heap), _func, _args, true)
 #define min_heap_pop_push(_heap, _element, _func, _args)	\
 	__min_heap_pop_push(container_of(&(_heap)->nr, min_heap_char, nr), _element,	\
-			    __minheap_obj_size(_heap), _func, _args)
+			    __minheap_obj_size(_heap), _func, _args, false)
+#define min_heap_pop_push_eqaware(_heap, _element, _func, _args)	\
+	__min_heap_pop_push(container_of(&(_heap)->nr, min_heap_char, nr), _element,	\
+			    __minheap_obj_size(_heap), _func, _args, true)
 #define min_heap_push(_heap, _element, _func, _args)	\
 	__min_heap_push(container_of(&(_heap)->nr, min_heap_char, nr), _element,	\
 			__minheap_obj_size(_heap), _func, _args)
diff --git a/lib/min_heap.c b/lib/min_heap.c
index dae3ed39421a..a69d8b80d443 100644
--- a/lib/min_heap.c
+++ b/lib/min_heap.c
@@ -56,9 +56,9 @@ bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
 EXPORT_SYMBOL(__min_heap_pop);
 
 void __min_heap_pop_push(min_heap_char *heap, const void *element, size_t elem_size,
-			 const struct min_heap_callbacks *func, void *args)
+			 const struct min_heap_callbacks *func, void *args, bool eqaware)
 {
-	__min_heap_pop_push_inline(heap, element, elem_size, func, args);
+	__min_heap_pop_push_inline(heap, element, elem_size, func, args, eqaware);
 }
 EXPORT_SYMBOL(__min_heap_pop_push);
 
-- 
2.34.1


