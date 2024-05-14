Return-Path: <linux-bcache+bounces-451-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3772F8C4E01
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 10:50:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 634A61C21912
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 08:50:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C4C04CE13;
	Tue, 14 May 2024 08:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i+bj6yIh"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC7D208CA;
	Tue, 14 May 2024 08:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676499; cv=none; b=i9r7ShmZAuqLdOzAMOOvmHC8MWD98oiJtV8i7oC7P0yuhKkHUSNy5SRjdRIrH5a9thEAtrQYOjAoclPAW4HFylPY8sTmDjk46tYO9B0ShyoEU6Wn18HyBwif/QD0ICR9Lh5Ew/nkR0769KL338cAwSoIq/hLwCabL961cXQjLoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676499; c=relaxed/simple;
	bh=4BdmZ42eGYqkHh7DqsaJJxnA5TQhEtJiFDSi25byrow=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t89TDqXxdSgOf3Hf0N/mTB32xPb8+5WP30AR6pmnYvPtJTKwOEvN6ak7+46lk0nfhtltwmMRKm17vpeNh3fkUFi5tZAtpRdYAAfskLU4Zc1snGelo3Hx9z9Lle/e9+py4QZ5xbLGOlLYFwJyMXoceMEdud92+UH44X7FsoPbfzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i+bj6yIh; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2b620b0662dso1336902a91.0;
        Tue, 14 May 2024 01:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676497; x=1716281297; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zYBPuzAS4rfB8ctDvp2HjPAauLmNAXnRoi+vJxjVmnw=;
        b=i+bj6yIhQnGeCDbQqc/ztYs5tfQRQXgXxklYWFEr7YxDy4zpAd16ruQzSv2DL7U1lr
         oel/fwpuDR8npabDbKMNB9Y8oElqBf1Ym0m5ODpUkmizUk7Orj3PlgEMdmV4uy+ZXC8A
         A1Q5MfE4AG+LzbRaTMtDCBw1roRwJUmy0Me+9DAafqU7G00LJBcfKY2yQqF9Zlg+4m5Z
         wwWZaMT6utpzPSob/g3BgaKjee++12sTx9bzHh5HJGuVQyloBkZJ47O3ZcDlHnYlU1Qm
         hw9g1g9eO08H60YqAC++zxMsxqqkcq2HCojwRNbnZ4UNvFvAqC/BB2RMnUATLNmo4sEA
         gkHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676497; x=1716281297;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zYBPuzAS4rfB8ctDvp2HjPAauLmNAXnRoi+vJxjVmnw=;
        b=cZpaVYL1/Q/opAI52kWH+f0ONgQqOuWMSpMR/CYdRHdOQF0VPSZV9TZ0xEkPvxS71e
         +AZpJgvrkj8u1ZYhTqxbYJRbHBp0meCWeytJuWujjtY03Akhb0h0dTrK/CMIavVIE5lm
         HmlTlLx7psbpZ5A+9wdNkcoRoimzoOHOg5BUcdNjpAHupAiJwtXvPC8WWs0DQ9Uh/l1j
         2Al5a5Yn+VcYmcaj3ju6w1VaxcvBQTgMYnpsLA/kfLb4Txp+Ygur8NzxzYMQCFdrrU6+
         Ge+Xlnv720yVRXhcuFqv2cEhDJ0HBW+nDQZxSytHwwsTEH9kY4ld7SHGtqusWkyttW2m
         WSFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWWKY2sElNgbP8Ur7DQT/FkHRKeSa25gsU3NEG37X5sIUpPqSZGuCFrALpKhYdsO7q8enoWerJ0fWw9DPGZHyWjM8ITV0gp2Dxd+TgGl8Aba+vZYLts5MbyxEEuXQuanZX0ej8oSc/IgxoQEMOmuVsyM9HF2LqgtMZ4bvA6IZfGU1KmssNRAAQ0lBgKqe6y1Vu2rpWvcML7/I6/luWiyiSzFHSU8d5648MS3YY
X-Gm-Message-State: AOJu0YwFiusYLKJvl5Gjyc9j4vJvjXesRicNo89sxHX7ZxQ5Qmrh1k7E
	SmvQ6uCFOwsEGAbfbYUhJ/I79f0KrTWZgnoDoLGxTJIBsFyOR8/5
X-Google-Smtp-Source: AGHT+IF1tB3asVOcIehbdULs2Db+i3/DdCJln4N3P8SkwIhnJXqJQWr4URVvswDXe1xPOx3i62bGnQ==
X-Received: by 2002:a05:6a21:329d:b0:1af:a5e8:d184 with SMTP id adf61e73a8af0-1afde224bd1mr14425374637.5.1715676497576;
        Tue, 14 May 2024 01:48:17 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b6711660fdsm9195597a91.16.2024.05.14.01.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:48:16 -0700 (PDT)
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
Subject: [RESEND PATCH v5 09/16] lib min_heap: Add min_heap_sift_up()
Date: Tue, 14 May 2024 16:47:17 +0800
Message-Id: <20240514084724.557100-10-visitorckw@gmail.com>
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

Add min_heap_sift_up() to sift up the element at index 'idx' in the
heap.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 9391f7cc9da9..201f59cb3558 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -111,6 +111,26 @@ void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
 #define min_heapify(_heap, _pos, _func, _args)	\
 	__min_heapify((min_heap_char *)_heap, _pos, __minheap_obj_size(_heap), _func, _args)
 
+/* Sift up ith element from the heap, O(log2(nr)). */
+static __always_inline
+void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
+		const struct min_heap_callbacks *func, void *args)
+{
+	void *data = heap->data;
+	size_t parent;
+
+	while (idx) {
+		parent = (idx - 1) / 2;
+		if (func->less(data + parent * elem_size, data + idx * elem_size, args))
+			break;
+		func->swp(data + parent * elem_size, data + idx * elem_size, args);
+		idx = parent;
+	}
+}
+
+#define min_heap_sift_up(_heap, _idx, _func, _args)	\
+	__min_heap_sift_up((min_heap_char *)_heap, __minheap_obj_size(_heap), _idx, _func, _args)
+
 /* Floyd's approach to heapification that is O(nr). */
 static __always_inline
 void __min_heapify_all(min_heap_char *heap, size_t elem_size,
-- 
2.34.1


