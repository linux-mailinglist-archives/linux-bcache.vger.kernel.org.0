Return-Path: <linux-bcache+bounces-340-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C1FC78813E8
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 15:58:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 755251F216A9
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 14:58:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF44D535D0;
	Wed, 20 Mar 2024 14:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nqVyH86y"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA315FDA7;
	Wed, 20 Mar 2024 14:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710946528; cv=none; b=jUyse1GOOH2ldmUZQCYfR7Ujtj2fO6mmRfzsIhyiUal/JhSXtuNLotDUlNdxPzavP3ImdhDF1ZliUD6uRccyGp3jpekxvKVUDfjeJp3dTaSUfkDP/aMig7Bpz3y9KBdsrJ5lrdgN4Z/R7CttZowGPE/IehfJhYZ1GIwUSo1DnuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710946528; c=relaxed/simple;
	bh=GQUVsfUcpz8LUorm5To23Yew7xCHJVZumueYQTygjj8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bRwEFiBfKxFslTswaYYIp3VyK4JIhjIoBY6fj1nDL+K8eHMq2SxGm4JsZ6zr9+HmGN5IeB/oJEXw1mMR1qXTrCqGbRVhsOqter4R4URCZHLQycIe4xdtokq88pOw1u7ihrpPWAx+MqnZAjCmh+CXYjqcMaRSCcbLXe5Bwh/Gyx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nqVyH86y; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1dee6672526so6080105ad.1;
        Wed, 20 Mar 2024 07:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710946526; x=1711551326; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zmVSQEC3TeRF4GcV4dCeypJopsqrkB0AwEs9FDrz4eI=;
        b=nqVyH86yJct1WUode4SMJgT5vFb7XnuI05Ro7iDK/ad4PbdFPsZXfzbxVx8ivkIhxj
         gXG0PybtYydj/yuuIVGrvD10q6vu8WVPqU3cJ8Vjiqb7Gc4uUfQ0+XTAV23PBSVqshKy
         Ed2VgaJxOmvAQhCc8TQupzZ85lj7P1Ki1JOqOsRW2WkWk66cUHCItBsLilSO/r8CPFXZ
         P8A6FMCHf+Xj30IFpyirx13HtRvMSgpARyUVl+7rPzyn1d1kWj5mbTK6yo3dj0/I7SV+
         pwZjYE+XJBocjUEwVCS/UbWrCnhLjDnxJcbNnxSfR0/jmlBjIqqZjeE/RKdPXNrI2XvC
         m15g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710946526; x=1711551326;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zmVSQEC3TeRF4GcV4dCeypJopsqrkB0AwEs9FDrz4eI=;
        b=kj0zMCk5ZgRGySOyqlNeQ0myGX+hbc7ZK3qUtqwBq7GY8K6YiMuGG11lVJd+AIqWJb
         6qOjcg/AelFwwK9jV7sOeIA5hpzoXaxvfDvdsbuJ2oFb9sND6eIag3L17nVfeURgi6HJ
         gtxJm/hFLZiwzVQW/N1xEWAMnF6aLd0sylZx82SkAxFs9XygepsZp3cxTxoJn8o75c4C
         9VGkzRFCVBDxMwAGTXYfmXOYOUHS7L6pNOWp80i7YWX4+jK6iKDH0eHP0KaMoyqLZntN
         LAAAgkjm+8MtqAhbVLe2SIrxff7FQx3iIeVbBL/3qu5UFZayLwCTjJZ+4iFIQzMidIKd
         JvDA==
X-Forwarded-Encrypted: i=1; AJvYcCXr7ajBnrZLgaV3iRre5K/lRsGGj83LQyXkMQbMi5aQDwuRATVUj6B2O9nYXYh0bzVNtZlZ9WQOngc+5H79pHWe10mTeNmf9H3k2lPUYuLSaAqxQApeQNaqyxHza3xTwOyUwpBQWhrPIPtYTcG8Qggw12GRWs1jAUrlRYORCFWpdCphb3nkHaVZL7L7hwh6FEUCKNKfNualgF98v9+75tsiIUB+5SHmB54H9PHa
X-Gm-Message-State: AOJu0YwCHZy67y1CXU1OYEImGzM1Spy+SbAexhoxoW9sXbpYpIeMLIUk
	+gpzPang+1dJ4b1lYwbjO8BsiG7si24m5ILf2SMpNdEXvg5sY1jP
X-Google-Smtp-Source: AGHT+IH+g3VQKU1UT+u7hlzLEfuAex2ovVYbYrYQpeOaTt68BlJN4QEvWb+lKyawL0mHCNYzU4yQXQ==
X-Received: by 2002:a17:903:1c1:b0:1dd:7c4c:c6b6 with SMTP id e1-20020a17090301c100b001dd7c4cc6b6mr19251572plh.5.1710946526585;
        Wed, 20 Mar 2024 07:55:26 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id la11-20020a170902fa0b00b001dc30f13e6asm13719989plb.137.2024.03.20.07.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 07:55:26 -0700 (PDT)
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
Subject: [PATCH v2 13/15] lib/test_min_heap: Use min_heap_init() for initializing
Date: Wed, 20 Mar 2024 22:54:15 +0800
Message-Id: <20240320145417.336208-14-visitorckw@gmail.com>
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

Replace direct assignment of values to heap data members with
min_heap_init() for better code readability and maintainability.

Link: https://lkml.kernel.org/CAP-5=fW+FvUu8JL+KrtVv5uC++4AW=VhyEOgmdWzpH1mswQNzw@mail.gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 lib/test_min_heap.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/lib/test_min_heap.c b/lib/test_min_heap.c
index 062e908e9fa3..8d25fc8256db 100644
--- a/lib/test_min_heap.c
+++ b/lib/test_min_heap.c
@@ -67,9 +67,8 @@ static __init int test_heapify_all(bool min_heap)
 			 -3, -1, -2, -4, 0x8000000, 0x7FFFFFF };
 	struct min_heap_test heap;
 
-	heap.heap.data = values;
+	min_heap_init(&heap, values, ARRAY_SIZE(values));
 	heap.heap.nr = ARRAY_SIZE(values);
-	heap.heap.size =  ARRAY_SIZE(values);
 	struct min_heap_callbacks funcs = {
 		.less = min_heap ? less_than : greater_than,
 		.swp = swap_ints,
@@ -99,9 +98,7 @@ static __init int test_heap_push(bool min_heap)
 	int values[ARRAY_SIZE(data)];
 	struct min_heap_test heap;
 
-	heap.heap.data = values;
-	heap.heap.nr = 0;
-	heap.heap.size =  ARRAY_SIZE(values);
+	min_heap_init(&heap, values, ARRAY_SIZE(values));
 	struct min_heap_callbacks funcs = {
 		.less = min_heap ? less_than : greater_than,
 		.swp = swap_ints,
@@ -131,9 +128,7 @@ static __init int test_heap_pop_push(bool min_heap)
 	int values[ARRAY_SIZE(data)];
 	struct min_heap_test heap;
 
-	heap.heap.data = values;
-	heap.heap.nr = 0;
-	heap.heap.size =  ARRAY_SIZE(values);
+	min_heap_init(&heap, values, ARRAY_SIZE(values));
 	struct min_heap_callbacks funcs = {
 		.less = min_heap ? less_than : greater_than,
 		.swp = swap_ints,
-- 
2.34.1


