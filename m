Return-Path: <linux-bcache+bounces-456-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 850D58C4E18
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 10:52:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 267291F210FA
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 08:52:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87CD67581B;
	Tue, 14 May 2024 08:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bD4qyzc4"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC3E381A4;
	Tue, 14 May 2024 08:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676524; cv=none; b=SzEy7Um+8hJvAhDtg+/ujXt0JLP7jkSCu6+fnRwPuX/8oYJBtYJSGnMCA7hebvByxhqk1Bpf/kgtKaI/kqN0x/Ob3rGLFfwLfvTpBVHfmBJ6f+c5C0oOinOI351ikynd6lsfKwIG6SoZ2a1X29CJmdBHINUMskQ33tYI8pqbl+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676524; c=relaxed/simple;
	bh=6RI5jUBlTt+5u3rxYbD5uAwV2PYZJ9bmstimem/yPPk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XR7el/5Jx9T/nDguwfjcw1ukPWGItarSmjY9lkWIrwawTe+oxTqwXd/Shp2eF4NYLTQ23bvdnZ2+YR01T4EnZyB4/AdLjRZ8xq6EzWiWC+JUE95PEXvv1cfeOi/PTrOrCPAvRgSfGb7i9K/eb6FL9zAHbNNkpBYmRZkZ4zeqYxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bD4qyzc4; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2b370e63d96so1332569a91.3;
        Tue, 14 May 2024 01:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676522; x=1716281322; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nfNQplMLN+Frp8NNBnHt1wiGD5SxoB711mIx7353U+s=;
        b=bD4qyzc4uVivwLgRnlvoR+0qu+8pyybyLIPHNRVkKhx/0aTL4yzoILrGBPVPjFKiQ7
         nm9K0/8B2yjCekHLNmppbSktifzr8dQYFUYGezTLRv8BKUJVNeT2TSUGTbSG2ZvotAbi
         N9kO8r0Gr+9syGJECZeNFoTj2tg9xGnI2x/ETvha+bzf56bTLPzf2TIKAXc4TnUdozbg
         WqInWyTNTsbW1arLGi2rG8JiNmz6YW4/+YjdukqvNPkpyjwpNT2GUDGJtDfLyFPn72Oh
         dfDm48gtSJKr/tZbUs9PCV6FekzDUtO824gEjVL+MDOzLj2DCyncoLvoS50MGozgawTO
         fMJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676522; x=1716281322;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nfNQplMLN+Frp8NNBnHt1wiGD5SxoB711mIx7353U+s=;
        b=Lnb9BPn9hb+t9ltj3RiK2R+HFO/jodWbumqOg5C42vKgJm5Vx3dgEdD3RtOCFbE17a
         3Jef+8bWqBcGK1UZw3P4AAyGJtzAPSbtM1nMR9AhdsTNI27TrstgiSAKVUIRfxzCGa11
         FnOuV5F92BpVebMVrRoCR9z05jGxgzRbjj+bmQVRdOLBYi+jHpd939lXoojdG+YJ1iN/
         FCbdTjPEfadnW1enVrtVXn3ROqdEubHcZKRHwFv7ae7e+t+qGewWtS5UC1fgLdVD0+zb
         85wWG4TNA8i8kcOlKNlm1YJptX4MRaHVqcFte3376D1CY0glCz/lq2M+QCVs8Wp748Lh
         PAsg==
X-Forwarded-Encrypted: i=1; AJvYcCXaNJa8Pn6M1bR+6qCyFWcz36gpBcX/dx1M2mVfQKkK6P5Q6hHDyjg4ECXRrN/OZPgSZkmczAiU/GqgoDLenMuiQFKTl/NHpwAKveMJTAIBjyK0QeKhi7G/wABhTxdpxlBK1iU+/HlDC1jAjKZEpH7mTwzGcqXB7/pRITud0oRbG5cRUJWZ4A4m+5neXXsOrZRcqA0ZWL6sm2y070TAgBCZs9AZNzAt4iH9zcIt
X-Gm-Message-State: AOJu0YwGc3fdIF7ZTxgieHyBBmxVc4SrNCa/Z5UI5C9SNOMaSKx7b5+Q
	hYWHxd3Nk4D98s4D76OSIBKWoP/mZUNLI6of/JdH35RYjxuLB6Zh
X-Google-Smtp-Source: AGHT+IE/+k5Tsbp6nBIgFMfvySLFamCErRWzUfdGi9BOaWec59ZSeEqFgNaFrSCJw9WqKK0Y18a7cw==
X-Received: by 2002:a05:6a21:7896:b0:1af:cefe:dba3 with SMTP id adf61e73a8af0-1afddee489emr15338579637.0.1715676522439;
        Tue, 14 May 2024 01:48:42 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b6711660fdsm9195597a91.16.2024.05.14.01.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:48:41 -0700 (PDT)
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
Subject: [RESEND PATCH v5 14/16] lib/test_min_heap: Add test for heap_del()
Date: Tue, 14 May 2024 16:47:22 +0800
Message-Id: <20240514084724.557100-15-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240514084724.557100-1-visitorckw@gmail.com>
References: <20240514084724.557100-1-visitorckw@gmail.com>
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
index 0b5037b4bd68..d40851cfd824 100644
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


