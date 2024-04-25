Return-Path: <linux-bcache+bounces-419-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C4068B23F1
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 16:24:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D77FD1F23F67
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 14:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45EC7153824;
	Thu, 25 Apr 2024 14:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xmqio8+5"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE60515380D;
	Thu, 25 Apr 2024 14:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714054782; cv=none; b=nnhOPJyXaD8nNCl9Yo69t7KuLy48+j/du39hVEv6K9G3iEMm2s5Zycx7sQBkEg0r5L5qbum3LPI2W4Jm+cGs0SYH8FPhTC9AirrnFFk+0ipYXTWA/2qPMz39iITdpkTv7fGZUga8YtaTlm/WBxr4SRkmQ5xid1IHApSqw2U+BLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714054782; c=relaxed/simple;
	bh=6RI5jUBlTt+5u3rxYbD5uAwV2PYZJ9bmstimem/yPPk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L0gAYll+KWdqtStLzBEXHTYW/LTWWadWTCJLgzwgwt6gkufZL20bIRlJphyRXMx8c/GLwzNajT4vryUO24SUFEPSUkqraM6GVcGUG6LCSN/JRxwBv2cm2g9l72nHgBOVIaqsX3t82CJyc/A8/3WtWHb/kS9aDk5YKxHihS9ZgoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xmqio8+5; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2af71daeec1so280038a91.0;
        Thu, 25 Apr 2024 07:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714054780; x=1714659580; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nfNQplMLN+Frp8NNBnHt1wiGD5SxoB711mIx7353U+s=;
        b=Xmqio8+5bH6kqmIs9997MXyiKwfVNyhyYem1MwCDaOf35G2g858sjhRFQZGL1MQGVK
         gLRNOVDD4y/Lvv3CDxzjm1SQzhSHz1Pm0g1JIyvUW54rg2VVo1w0fHG8/OoNyALw+SoJ
         7ZyNmo/U7qWFyYACs5VFRwOPNeyv0LFpF9A6qZbkmuVxhbq83A1Kqr8WMvnT+7OmHNBc
         S2nEkq1suNGymqAZzGhvOsupoLzdcLdjjyFVdpEj0F0FLhcImYQGQoKT4obrGNNfpCT3
         wg5hXIVlVugZvyGaAqmPGlNH23JwyyY95u4t2vqTJbFpgsd6mglNRAqkErbTNgfPvpY7
         Kigw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714054780; x=1714659580;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nfNQplMLN+Frp8NNBnHt1wiGD5SxoB711mIx7353U+s=;
        b=AECzI3tW7VSeTcTYSgSHur9GF7M3FyXTfqPiWr8G8pQHr7ZNW8M831ylXoHC1FaxFM
         O1fuYJ2iPJ9MmVnlaXiw2m1LzzBuG+QluJJdG59qqLoY7lKLAWirW8VKm9oJScVGr/1e
         OhmWXHPhAS5urQKJ13sVbEdOEqnQytfpCn97WDtcm4pyY82+YDx/c8rXVb8/rmNaDYPF
         DHIY7q8UNET2nmdWwo6e5gKK999Kt332l6qGMHyGoTA3x5A399EobnED8ViLZNi8LHzP
         qLBs1/DkDYxF896mJ0Kn0eeAm9FtVQ/S+2U9OxE/ECvs7+DPLdv4OxBWDsUwHRp/q5rl
         BblQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlxSLz4SsuqOYENd7rBQU7WlOwICcu4O4LzP0qofBPv5kUlROhv13OgNy8aLZRu2b4VWoQ2iGWtRmAI4wqKkg5FEtJAtT999jdQY7mSEcZOCwprtsZq0U85OeoqyA1z3G6QRGpqxTt30IZ2orzhDVrZQ3aCu40fQYAJbrZMuqLeYzaRz5NuAwV1I2WFb2yu/O4mWuSuz3Obyhx31CP3F9xR/1iExJg3X3lGevD
X-Gm-Message-State: AOJu0YyV1fNlcJIkw09U8QC5ySCFXBEb0JcGNX8a8aKp1ONuvtksYAOH
	ft/SK0K/UNDiYWp1sHW4foNoyctkqC2nhmvB/fxYJcK9grbYHEgG
X-Google-Smtp-Source: AGHT+IGLtr8gNAowqrhYxdb7nL/pPUMKK9j1lIpP3T8Y0HSP5yJ+WzDtVU99hrbxcwsvMSorDEfYsA==
X-Received: by 2002:a05:6a20:2624:b0:1ac:41c7:d2e2 with SMTP id i36-20020a056a20262400b001ac41c7d2e2mr5389786pze.0.1714054780149;
        Thu, 25 Apr 2024 07:19:40 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id go20-20020a056a003b1400b006e6233563cesm13162397pfb.218.2024.04.25.07.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 07:19:39 -0700 (PDT)
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
Subject: [PATCH v4 14/16] lib/test_min_heap: Add test for heap_del()
Date: Thu, 25 Apr 2024 22:18:24 +0800
Message-Id: <20240425141826.840077-15-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240425141826.840077-1-visitorckw@gmail.com>
References: <20240425141826.840077-1-visitorckw@gmail.com>
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


