Return-Path: <linux-bcache+bounces-767-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 795CD9A523C
	for <lists+linux-bcache@lfdr.de>; Sun, 20 Oct 2024 06:03:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DC2C1C2130E
	for <lists+linux-bcache@lfdr.de>; Sun, 20 Oct 2024 04:03:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF2452E3EB;
	Sun, 20 Oct 2024 04:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FZR9PCsV"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14AC405F7;
	Sun, 20 Oct 2024 04:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729396963; cv=none; b=DYteKKFfiVIj7tmLZNsL2+eAp9Ed0qH9Sw0rflPgWQC8q9SppKUkk1IY3n84QupAd4lwQ4lP3qoMrA31CHCfadAMXkbTkkzu/90Ihaxs0LLpvUVnLgeDic86p3JmpUoNIcTuXirOjgklKevvr9Z60pGJ+80Ad4mp2aQadHuHoD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729396963; c=relaxed/simple;
	bh=uWD7X4+G72y+WuvTqwWeg7t00M9IRkb3ifQpqG/L/hM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZWCmIeXCl8wI2jR40aOmyEPO+tYdLTY1etYUSYv8QbHFY6yzwkjdBWyJ+S/rAgOR2wWdAdc3drwyYP+FMuxDOnMYnBfdNEkHCZ3+J11LVCRfk4o8hzFoFRq1DPkYwHL+5j0yNpJaR8gQO7GsAQ7GupIFzeNGlSh1CFtB5cba1Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FZR9PCsV; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2e2ed59a35eso2850458a91.0;
        Sat, 19 Oct 2024 21:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729396961; x=1730001761; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rSsO9eyAnWGRK9JqMw2hZIz60NRvRqk+DUJGCBdVXsc=;
        b=FZR9PCsVf24aV2gjAIHIKHWyKwuD4RDde/bFZTpg96gotr35huELc5CGTSsQ/L1fu6
         /SNOtV/2CPpnWCI79wjVcqHllWtTIp3ZQJH93iGebYop+NP38Uesb8fivwZmTuTW/qbd
         30RBrSgwNuOeOC5uQAzg0SuRAKxZvvYN1mtjP0ZA8G9W0d1RNmJSDxJePsB6hRn1PbQU
         6eNfhohMUXTgjRG2MCwRanlZMsMjnUopgXA4ZnhWBhks533A+LYErA0AjrHsWBeEV4SP
         NdsFBfznUtLlV2nSRGzcUTliDMshk3fTN6xLyEc9P+fpnM1m0wf4+mazzku6VRSlrROT
         4jhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729396961; x=1730001761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rSsO9eyAnWGRK9JqMw2hZIz60NRvRqk+DUJGCBdVXsc=;
        b=SkO0CPYENl6vIADWfv9HZ2ZVEBRm0mIx6fotfFsivsesEN6fLqOOLud0rhuldrKUIB
         kb5CZMveNunvBUN8me7mSyrXxeEGfCBNIjdBUZp3TzS5VExN1GIpv9cfak1i7yeed1w+
         41HooNpRxfUh7Up/A8WTx9S5qN4asuKvUpYemR6KxFEafP64butuHutbtQwOVVqAwEjz
         LHpTjSwA3Vj2+FzodQ+uxcajTmkrxFxNhgJRj0PYAh8C6sf9ddgBuIgnuwya+H0baM8d
         p3reLwO81/LOqotmjLevHeT5gxvA4UNIt6ouVNfJaPC9r986HzmZLGP6jENu1vtWX8KJ
         uZGA==
X-Forwarded-Encrypted: i=1; AJvYcCU+UxMKMkS1IWqK/M+2km4jYk9R8vddYAUSpMm7G9WWona3ATYH7CtcSJXkCoppG74f3cJTdu0Xn+YvbcAu@vger.kernel.org, AJvYcCUndL8z9XRqPUKoA+M3/KuDigZvz9ynvXlMAzE6n9vm2oV3CHr76nq/gfa97BaRchtxJ0aqvRkVS4O2qLKBjCddOQ==@vger.kernel.org, AJvYcCWxFG444jbvQKuvN9W4J4nUzeK2b9Ed/sH4ElAY12pK2qSvLiHV8rJIPmClfb00ycmp25FHE8MXrKAeImLnqvM=@vger.kernel.org, AJvYcCXFNSkcWXH8p6XsmkAFuIP+8ibG27RbLAf3VZtgdeUbaWKKVaGsEA+swfK2Z7e/1PoQ1a79Vp0B0ZrRilg=@vger.kernel.org, AJvYcCXSnpfxitL5Ek9lWssiqROPwVY9WTw4iN97IY6mQMre4L7Ph9+GJE60l9D08bv5QCqf+jEiVeJdPJV6@vger.kernel.org
X-Gm-Message-State: AOJu0YwXGNXzRdsdN13R5+R/Xqm6SoY3HJhLjN90DPIdJ6ly8vak4Y5+
	IP9KabnmmQX/aMrLn88o/sNtOfdBiq0thvmFa2Pj9os72g/QysZN
X-Google-Smtp-Source: AGHT+IGdWI08SJwvOyOfpihMxUYT3OOzFomu22UrUlY7s271MCitpKDj02EZ1IaoGzOFhlnHCnE38Q==
X-Received: by 2002:a17:90b:3c47:b0:2e2:bd68:b8d8 with SMTP id 98e67ed59e1d1-2e5616dea4dmr8067411a91.8.1729396961160;
        Sat, 19 Oct 2024 21:02:41 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad3678d3sm633668a91.24.2024.10.19.21.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2024 21:02:40 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: colyli@suse.de,
	kent.overstreet@linux.dev,
	msakai@redhat.com,
	corbet@lwn.net,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	akpm@linux-foundation.org
Cc: mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	kan.liang@linux.intel.com,
	willy@infradead.org,
	jserv@ccns.ncku.edu.tw,
	linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH v2 04/10] lib/test_min_heap: Update min_heap_callbacks to use default builtin swap
Date: Sun, 20 Oct 2024 12:01:54 +0800
Message-Id: <20241020040200.939973-5-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241020040200.939973-1-visitorckw@gmail.com>
References: <20241020040200.939973-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the swp function pointer in the min_heap_callbacks of
test_min_heap with NULL, allowing direct usage of the default builtin
swap implementation. This modification simplifies the code and improves
performance by removing unnecessary function indirection.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
Tested with test_min_heap module.

 lib/test_min_heap.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/lib/test_min_heap.c b/lib/test_min_heap.c
index 64c877e73b64..e6fbb798558b 100644
--- a/lib/test_min_heap.c
+++ b/lib/test_min_heap.c
@@ -23,14 +23,6 @@ static __init bool greater_than(const void *lhs, const void *rhs, void __always_
 	return *(int *)lhs > *(int *)rhs;
 }
 
-static __init void swap_ints(void *lhs, void *rhs, void __always_unused *args)
-{
-	int temp = *(int *)lhs;
-
-	*(int *)lhs = *(int *)rhs;
-	*(int *)rhs = temp;
-}
-
 static __init int pop_verify_heap(bool min_heap,
 				struct min_heap_test *heap,
 				const struct min_heap_callbacks *funcs)
@@ -72,7 +64,7 @@ static __init int test_heapify_all(bool min_heap)
 	};
 	struct min_heap_callbacks funcs = {
 		.less = min_heap ? less_than : greater_than,
-		.swp = swap_ints,
+		.swp = NULL,
 	};
 	int i, err;
 
@@ -104,7 +96,7 @@ static __init int test_heap_push(bool min_heap)
 	};
 	struct min_heap_callbacks funcs = {
 		.less = min_heap ? less_than : greater_than,
-		.swp = swap_ints,
+		.swp = NULL,
 	};
 	int i, temp, err;
 
@@ -136,7 +128,7 @@ static __init int test_heap_pop_push(bool min_heap)
 	};
 	struct min_heap_callbacks funcs = {
 		.less = min_heap ? less_than : greater_than,
-		.swp = swap_ints,
+		.swp = NULL,
 	};
 	int i, temp, err;
 
@@ -175,7 +167,7 @@ static __init int test_heap_del(bool min_heap)
 	heap.nr = ARRAY_SIZE(values);
 	struct min_heap_callbacks funcs = {
 		.less = min_heap ? less_than : greater_than,
-		.swp = swap_ints,
+		.swp = NULL,
 	};
 	int i, err;
 
-- 
2.34.1


