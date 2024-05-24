Return-Path: <linux-bcache+bounces-487-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 380B38CE816
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 17:35:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6CF7282642
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 15:35:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EE23132808;
	Fri, 24 May 2024 15:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JpH8LH9G"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27C5132483;
	Fri, 24 May 2024 15:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564677; cv=none; b=rWK5a8wuugJpY9cOKhLlK7TKRcYG2g7QG95WyiC8aHSxsXsl5+bgo2wuJ1bhr1/zbAH4srMmzSIUNkfhlUkT4LsOVadop1Z0z6XOlKjJb2KTwRSL2iNx9yoOI4qibDCcxw9roALBPP72DAsc9IFIevxtpfOMWcfp0uBHxAAn/DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564677; c=relaxed/simple;
	bh=C6lI1Yu2VUekRoVzlYxR8HKgrkH4BaCTdukv7Ke6t5U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DsgletLguZlSC/0RJH8gRAOWB6f87RM+2LTxnpVuzT65LVsF8laHn6p9vSv83Lt0IS1HM3Dl91wZjVJ6rQt9qac2XZLK/5MItMAtrMVDYAfopTM7Gysncsdhhmxo6vyBPZClDUOLxvW6w/t9BirYbqG8yPgsVWbHjKVrAcUHqTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JpH8LH9G; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2bde4d15867so247322a91.3;
        Fri, 24 May 2024 08:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716564675; x=1717169475; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4zTq8cqNIQvJ49hOaLr5qxuS4444ShA09a0gTe29cD8=;
        b=JpH8LH9GFbdOp39a2TjUhlS2O0WBNHTPOUo39d/eJ7uF8S86/vjCkdX3C0WP28xPEB
         TKYPllqs9tQ2h1nQFjiWT5l2EAAGSV7OsBAjn+GZJuQu/S+H+5GXHAt3JFoTNyvbUk2j
         bmrcsbTeBLiOFw/KqtthmlXtSa8bsfcfnTrG2YtYZxK+5NtBoU4wJ6rYsBkFXUEpuuD9
         14KdCbEYZ6gSgE1IhZEj6+Ml7gUJ6dkA/SL/avu2CTR0PXhqleWJWmDwmTFyt02SABv/
         psrUvghlXa9YKHwthvDnrQME57SJmQrCsoVWZLmQOq3vTndCQ5q+NxDf8xc4faV+9gID
         kzLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716564675; x=1717169475;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4zTq8cqNIQvJ49hOaLr5qxuS4444ShA09a0gTe29cD8=;
        b=Fx4KboBAOQCDOohoNsCjU2P+H857gmyV0rtnXwXvs/A9TWz8qLMNLu9qKVdUy+bK0A
         ruzmTNYR/KalUCbua61ZRC1g9vZzepmA6DoaAmhMxNamfOki9eWigJUN9rV+YVi97eJC
         JZFgJHtUi8/3Y1bMXyZcWnjHwrnwdcvx70JaAszQVEXMbgbTIaXkUA7A6WOj5WSyb2MY
         mHGOIIJ575TDIDShvk1tJUCZN5yRlRh51Dz42ec0ecPTQw7SQTtD6LsgmnrP9um5TgtE
         rZU8m5ZZTxgVlEB093/oKmqtsvKilQWKnLDyPUD/YHVBfErZWhLG26kUUB6HLeMUWD37
         zjFA==
X-Forwarded-Encrypted: i=1; AJvYcCVrWgw632KmofPuAjqmR/rRVkB1l03IH9qDF+DooHv4CBPjuwbZms2X6PBvQpjXMHjwGKDABLwsJtlLHMbdYjSj9KqexkvttFAsBlYrOTYynryqaiP9/X7PR1qAdjq1zU5fUv2XwVkuqjoYbagbtVLlsiDk7H9nJqL3vvrRfxRQe+3a1bfCfPlKtMOj4cmk0XuQpr4RlS+F10rRT6cGOElvJsLGgNjefyibdto+
X-Gm-Message-State: AOJu0YwRgmOHKT/DBhiePBZvcqxAuhFsA6JwH/MC4JgklFhtg3Y6ymSP
	sSQS8LntlVvOCLRz4xE+H4TX/boMAYxNA+UAfIWwMzr0Ffd3E5Vw
X-Google-Smtp-Source: AGHT+IEeQ+fm8GB2+MgEGzsYh4oQsjju6O48NEnmfaOO2wHIeT/FbppTUO/N8jps5HE+L8khfiX4jw==
X-Received: by 2002:a17:90b:3d10:b0:2bd:feb6:b09b with SMTP id 98e67ed59e1d1-2bf5e161326mr2523612a91.1.1716564675125;
        Fri, 24 May 2024 08:31:15 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f50d294sm1525556a91.20.2024.05.24.08.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 08:31:14 -0700 (PDT)
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
Subject: [PATCH v6 14/16] lib/test_min_heap: Add test for heap_del()
Date: Fri, 24 May 2024 23:29:56 +0800
Message-Id: <20240524152958.919343-15-visitorckw@gmail.com>
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

Add test cases for the min_heap_del() to ensure its functionality is
thoroughly tested.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 lib/test_min_heap.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/lib/test_min_heap.c b/lib/test_min_heap.c
index f59638cf5dfa..9e1feb9b679c 100644
--- a/lib/test_min_heap.c
+++ b/lib/test_min_heap.c
@@ -165,6 +165,40 @@ static __init int test_heap_pop_push(bool min_heap)
 	return err;
 }
 
+static __init int test_heap_del(bool min_heap)
+{
+	int values[] = { 3, 1, 2, 4, 0x8000000, 0x7FFFFFF, 0,
+			 -3, -1, -2, -4, 0x8000000, 0x7FFFFFF };
+	struct min_heap_test heap;
+
+	min_heap_init(&heap, values, ARRAY_SIZE(values));
+	heap.nr = ARRAY_SIZE(values);
+	struct min_heap_callbacks funcs = {
+		.less = min_heap ? less_than : greater_than,
+		.swp = swap_ints,
+	};
+	int i, err;
+
+	/* Test with known set of values. */
+	min_heapify_all(&heap, &funcs, NULL);
+	for (i = 0; i < ARRAY_SIZE(values) / 2; i++)
+		min_heap_del(&heap, get_random_u32() % heap.nr, &funcs, NULL);
+	err = pop_verify_heap(min_heap, &heap, &funcs);
+
+
+	/* Test with randomly generated values. */
+	heap.nr = ARRAY_SIZE(values);
+	for (i = 0; i < heap.nr; i++)
+		values[i] = get_random_u32();
+	min_heapify_all(&heap, &funcs, NULL);
+
+	for (i = 0; i < ARRAY_SIZE(values) / 2; i++)
+		min_heap_del(&heap, get_random_u32() % heap.nr, &funcs, NULL);
+	err += pop_verify_heap(min_heap, &heap, &funcs);
+
+	return err;
+}
+
 static int __init test_min_heap_init(void)
 {
 	int err = 0;
@@ -175,6 +209,8 @@ static int __init test_min_heap_init(void)
 	err += test_heap_push(false);
 	err += test_heap_pop_push(true);
 	err += test_heap_pop_push(false);
+	err += test_heap_del(true);
+	err += test_heap_del(false);
 	if (err) {
 		pr_err("test failed with %d errors\n", err);
 		return -EINVAL;
-- 
2.34.1


