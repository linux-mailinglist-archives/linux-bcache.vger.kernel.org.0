Return-Path: <linux-bcache+bounces-1118-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D486AD4522
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Jun 2025 23:56:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 533E53A33E7
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Jun 2025 21:55:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3E0B288503;
	Tue, 10 Jun 2025 21:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iqXOimAH"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581DD2882AA;
	Tue, 10 Jun 2025 21:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749592549; cv=none; b=Hkuf9rDWEZNnj6YZKD9X5d1Vd82npeWC4QDY/LLvamEETUfilkjilcx7mzyKV0F72GVU+TTrBwYs1nyQC+d53SzsDPZjRGg5A/ROL+lQ4D9hiwKVLHI5zjjtjW5C/1wfBB8WNW+EQRAg0d577GPJmxNnamobPWAeos7+zgs64Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749592549; c=relaxed/simple;
	bh=CdFMvOh1D27GtMT3HsdTzWf6XCyndLLIlrXlv5JSftc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JAR+45ESs1XxH19gjP7elbb0HqzjT2mCSq/HlrQv9KCF1NSpEUf/97C6nu+w84UDQXcrJnrtKSpb+I2bG+dvjHsh9azcqzJbM/Esndw3IYYIRtZAH/oDNRweY3B36jkjTsGB8t0Ec8yJcrt7KS7IUcZrbjB10EKGojk3AOKbD3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iqXOimAH; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-739b3fe7ce8so4694176b3a.0;
        Tue, 10 Jun 2025 14:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749592547; x=1750197347; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RYeWDvuYH1WzAk5I425o+mEgBxifUaXFRCTqxbugmfo=;
        b=iqXOimAHLptteW3Zt8Qmx6DyLZ50HtI8GhCIQ32GKr3N2XrUmdaF6//dOFhRmtppKE
         /8jPB+N4avklXzG6xC92nyREkLOCRBHZy0hQ9KUTKJ2qGAf/F+CjGyFDyd97Gcvy78rm
         FNa3z+gWZA/KJI+gXGriOzBNOi3S2UicbTfTeQIuPiqaSXlHlo78347h2aWZyQEswbkO
         6I1V5dO9TXFtCY7ty5vyyfgjmyLeIzcyWaeWSEjb98IypiA/+uD2Z0uYnT2eZZdK9Fyh
         xP5CZMQ1dfVy/EvZJ/zXaoLdpUrxgIKitCEPKvnVBfuuwB+JlqxudOzWkawH3wRzjrW/
         hMwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749592547; x=1750197347;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RYeWDvuYH1WzAk5I425o+mEgBxifUaXFRCTqxbugmfo=;
        b=WVZ/wps8Rp8Xj2OaQ2yDKQCba2cL484pEWBUK7YSqVbtRymeAeqVLwa/Ed/2ryhaeU
         a3HOwXunCSfkdPklbebTIBmaznfT+MnH26jvB271m6QBHDEVMlIs8y235bSw8HJcUtvK
         qJGlZ5IGiNm7A+A2ARdpSYYaAaWKdRhnv3E4212rfKt+1jz6xzqtViDcFlzmfw7NC8Cs
         1iKXdJ4pGe5jvI/k2dwL0LOBn+bcjfdz4QD+VM92oDEu4YP9WTD+2pd3WkRTqldR2zhW
         Fbe6KqA+kJLd/Ew9K9lielez+ptgoAHucUEOUgS4OscnhHeCJt12P7pkPTQuoYFeFQR6
         /tsg==
X-Forwarded-Encrypted: i=1; AJvYcCUKh9yGjku0bmSFwGAb1x7Z8zUtijXpLoDWNnf+3INzK8Cl66W99OLb8uX4ceRpNKuK9mXTqty7md7I@vger.kernel.org, AJvYcCUO1bmdy1H0XTPvbZNdNUMHUbiqrxZDitOgvuwqBt+VhKZSkOdoh/iuarorUljIxkwCyeFVVnpF4YAKYp8=@vger.kernel.org, AJvYcCVzNvQwCvKyGyVd02h4G9uU8EXjQRnXPuHOSPy6VXJ1yZnfrx8Yhu0KRwstbh0jQXDNN/ylkHOa@vger.kernel.org
X-Gm-Message-State: AOJu0YzPwq2lc1jZXxRn1B5GtKQdva0Q7aPgt8LuySzgp9aEYvnpGwFG
	z01in+ZBFyaKZKh/iV7zw7j5+MjvnW4Twmz6oftMrdirkZA+dmQLDSFJ
X-Gm-Gg: ASbGnctnFNILlAlznhf88kIo5JhweotwPivpNCBwSagbN9KDbd1JtgW83RN7ayl6JE7
	7ZvzeQrhOgcCSWJDGeMNCsSqmoTzOZtsohGyJ5hs8AtFmgl3P7VI1ve5FuhLDYbcHTs8QSNpJZr
	QPQNjRf0XV0X+GAW/9N8jWdSfAF+uxkcc0RL4N5NXMm4UcxJ9fiT+1JGPT4E3ruFn30os6paJJQ
	usD6QogtV6gLRlcjxQSu8m2cKUm1Jf4EOhfm83Ua1D5Xupj1ElwTjA7ownZyVsU5y5vG2PHFliA
	+z5bj0YHalEHVL9/BzLN15ZZuA235PpMvsuOXC4KhFYE4CS/dv7BoduRt+3neHDqPsT9cB59pZ5
	9t81jcSn9E0QoF5a+
X-Google-Smtp-Source: AGHT+IHjIoIASCOJJKdd+gaGt1nQQ0c4Mj1lsywbLZDyvnJgWu+4KNEegczHkPEWFba1gcpeYAbhjA==
X-Received: by 2002:a05:6a00:3d0a:b0:746:cc71:cc0d with SMTP id d2e1a72fcca58-7486cbbf67cmr1474821b3a.12.1749592547517;
        Tue, 10 Jun 2025 14:55:47 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482af3a165sm8173936b3a.11.2025.06.10.14.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 14:55:47 -0700 (PDT)
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
Subject: [PATCH 2/8] lib min_heap: Add typedef for sift_down function pointer
Date: Wed, 11 Jun 2025 05:55:10 +0800
Message-Id: <20250610215516.1513296-3-visitorckw@gmail.com>
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

Several min-heap operations such as min_heapify_all(), min_heap_pop(),
min_heap_pop_push(), and min_heap_del() use min_heap_sift_down()
internally. With the addition of the equal-elements-aware variant
min_heap_sift_down_eqaware(), these functions now need to choose
between multiple sift_down implementations.

Introduce a siftdown_fn_t typedef to represent the function pointer
type for sift_down routines. This avoids repeating verbose function
pointer declarations and simplifies code that dynamically selects the
appropriate implementation based on heap characteristics.

Cc: stable@vger.kernel.org # 6.11+
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 include/linux/min_heap.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index b0d603fe5379..4cd8fd9db259 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -49,6 +49,9 @@ struct min_heap_callbacks {
 	void (*swp)(void *lhs, void *rhs, void *args);
 };
 
+typedef void (*siftdown_fn_t)(min_heap_char *heap, size_t pos, size_t elem_size,
+			    const struct min_heap_callbacks *func, void *args);
+
 /**
  * is_aligned - is this pointer & size okay for word-wide copying?
  * @base: pointer to data
-- 
2.34.1


