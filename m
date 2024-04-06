Return-Path: <linux-bcache+bounces-379-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E2BD889AC4E
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 18:52:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 826511F21D55
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 16:52:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CE075786A;
	Sat,  6 Apr 2024 16:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZfhVTYTV"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084D75810F;
	Sat,  6 Apr 2024 16:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712422134; cv=none; b=O19VQ5qpUDv1Ml0XM2L1jJvxihB6HOYGRn6kLQVM635k4vu+g7ivXVK7qqQI2yiZV5veDMCqZCvuPGULt5gqFX2r1m41nfTSkXL6OLepVniMCL06/90DWjkrJkv/d9rWEFVrkFx+N+LEj70p0bv/2Xphcw5OlfAmSM44i0L9LYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712422134; c=relaxed/simple;
	bh=nGzZ5R9SZdgLiSQrHDAKei5XKniCC8VqmnZwC34Exuk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kOPvlEWi5jzbjVfr9h0yrUJNgoqW/KBgKk1pGsTNPmB0JMPZZYdJ7BEypbZRFEFqLeqBKiC9fIN08COWnr8+pehgcSD09Ay6kQbxOa2QlDruzNfgwgsp6jqSlpc91p5ROmySiHFkPjPqZ3+dnBsaEUaF6lmuIX7i47J83aFGmqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZfhVTYTV; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1e2a307902cso4973295ad.1;
        Sat, 06 Apr 2024 09:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712422132; x=1713026932; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pUFbtjS0qmDCTon3KqdyHnzuILiHtuPCl7OJb9nludU=;
        b=ZfhVTYTVKzM6cpLoTfAkDZRZ/CGnp2MMlmFwnyo7dFa/u+YI3nyjgs9lS9H3jYMT9l
         KsYRn6wd4ejiK+WDXXZpiynd4xRhvRFxIH5SB2VyEzFmEQFJuclkwUEdF91Y8b3SBRwA
         4emcswfnTiad9d0AWxtFHfj96P6ALb/VWQh2fwBAeTHg1HJeQ9PZgFQf6+TGl1U7jmXj
         ak/hm/5qi75QShZm5zOn2bY/BisHGLiyIN7ppUNtBIQN1fgOtfFHkuc3YaPVpw9iGei4
         YIygflHuyxPtSsHBg9PXLlgkdIS9Y7CxwTGI7QPwXcal0fWah7NSJoN7yrYhGkzEp3kD
         RQPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712422132; x=1713026932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pUFbtjS0qmDCTon3KqdyHnzuILiHtuPCl7OJb9nludU=;
        b=Hxgyj6FvvTPFLd+Vee+tw0SOdiFAKqVMaVKvSsQioPxEGLV2+4WOYpjcvjn6TiCQUD
         rznRI/6E66ZHkYC+rgU0GWY6QGgr9UwAbt4lw1/ihZiNd4tyGguPs2rxl80UhWxcmpX1
         WH9Uh+LekPBJHa1BZdCLqe31kboyeN6p2FHDaEB3jpoQhSFlC7qeHHQE6hlYgvx3ttlK
         6GHtSkLpZfyqNrNtzRh5CoCfg73NIdxQwQVdZEKlAFBUQN1sJXqwEb/BwKxn6F5mMwny
         5KCD8I+nYyOIYIV8oeAjYpUb+W2KyfK8aYpDd6TjemXFH8pEOoEfIB6QCM56dvyxpPBY
         1oyg==
X-Forwarded-Encrypted: i=1; AJvYcCWKBCV48VmtVCGX5gLcCoXXRfwXtjetG3s7K7IK/+sCJ/ZO6f41zJGuvnLH6b/iIhnlZ34z6vXOfP3e3c8iqiQJABGtZJfEeSZh0BabozD5x+PskGCdTQkFH0PGWzpaKIEp1bNXc9zUpbYb2UwxZlzuPedmtKhHDi6oCLL5Toa+gPXRYTzK11FsyNHLqcSdJtjlPAz5PXWmmOKVA4oR+UhO5cwxImI/ixMksz5a
X-Gm-Message-State: AOJu0YzI/7EqfkylQgs7efQuV3P8mFp8D9fMllkw+V636d8/6k6VvQrA
	iWoxEW7C+M/vptzxEybx42MFTjTkyEj4GVKeU72+0UqqNtwUj+Gr
X-Google-Smtp-Source: AGHT+IFn7ROdpfvq4Af61VXP9NL1gvD2SbKlCYOri0wmXqQgy51gfkXMrEA0iklwvkQSiS1rBr8X0w==
X-Received: by 2002:a17:902:e811:b0:1dd:da28:e5ca with SMTP id u17-20020a170902e81100b001ddda28e5camr5421423plg.0.1712422132369;
        Sat, 06 Apr 2024 09:48:52 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b001e2b8c91f04sm3665068plb.22.2024.04.06.09.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 09:48:51 -0700 (PDT)
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
Subject: [PATCH v3 15/17] lib/test_min_heap: Add test for heap_del()
Date: Sun,  7 Apr 2024 00:47:25 +0800
Message-Id: <20240406164727.577914-16-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240406164727.577914-1-visitorckw@gmail.com>
References: <20240406164727.577914-1-visitorckw@gmail.com>
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
---
 lib/test_min_heap.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/lib/test_min_heap.c b/lib/test_min_heap.c
index 67dd4f644f6c..9d4bbb590a49 100644
--- a/lib/test_min_heap.c
+++ b/lib/test_min_heap.c
@@ -160,6 +160,40 @@ static __init int test_heap_pop_push(bool min_heap)
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
@@ -170,6 +204,8 @@ static int __init test_min_heap_init(void)
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


