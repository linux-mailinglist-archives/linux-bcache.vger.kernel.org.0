Return-Path: <linux-bcache+bounces-369-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7DC789AC2E
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 18:49:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F703282650
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 16:49:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4A8F4E1D0;
	Sat,  6 Apr 2024 16:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YnEsgxtR"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6234437B;
	Sat,  6 Apr 2024 16:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712422088; cv=none; b=pA4Kf+FCy+omFqRYLKBa63vMjijHpk23aehhnxEBHKqA/JltLMQx/ijVHAidJZPq7QtM2JKEP70SyrW+55E8rJVhzpp4mhfbKsGQF0CKC4YJVBBHmOGmvKhFl/n6RXJtvMvsyM7hyIGOCqWipzCKmEnliR/NMvIKwPUo8QR9Ym8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712422088; c=relaxed/simple;
	bh=41wIMMrsMcV2JAh2IuFxgje7q/XR6YKUnX/6Mr8hZpU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QKOoKPi+rW3Z/hlS8hT3n36zFxFZ+KPzguowzsnOsIO8L8jVXRW9OqvxfROWhE24742Nx5GUzIB+3nl0nX0pqegoYEJ9XL3Liy4SoMTo47lITreNkMtNApx1Tu1PDbyexxb+6tsMyYIx4+JMqntxSct/30YBzBVScA/ToaxTTvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YnEsgxtR; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1e2a307902cso4970575ad.1;
        Sat, 06 Apr 2024 09:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712422087; x=1713026887; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mUGTczp2Kn8XprLlzlIe26wHtjou4WYa/rxGIi1PK80=;
        b=YnEsgxtRVE7LGfHefhht1EoCIj/69mtTl/j2id6dGHkCn8CTjUd9IUmLyUl1S2G+oR
         zkx2UxMA36nKRONALOBn+h04yP6dDmfQZHRMbFMEtYvj2+XaQbevwSaMiMaacG2ER7mc
         KZUvNhG8ydtmxqosQ2ZKGc3TsaVSI1xS0vm1YepcRpUh4IkhfxSrwbkhwfRfY9AE2Etk
         NYLnFMWDlz/nbn5+SqX0Wc1NPDngnREKJcybpxyqPnj1xelebXYfubHZn8qjLJkLv8zm
         u9PdRmTVZO+RTbS85WwK+HfDMXWwRvTAXerq75xtQBQF6EHinnisFuM62bc02cpdGw90
         LRww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712422087; x=1713026887;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mUGTczp2Kn8XprLlzlIe26wHtjou4WYa/rxGIi1PK80=;
        b=K3LBxJb/m/Ly7Mx4k6NgFoCHrxUgdlPPs8kCHVEFPYLFV0Lt+Izs8o9fkE1qLK2dTK
         b3itDhnOBeyRDDoyFh4lHsoQbXb+199xb4SveLlZK5xw2mpjFaZSnuAgBOByDqAVyLfu
         zr42su3eEkOmcy+dJg4Co3dLw7S6BgcpiImzdffsOy4EBcR9/sLJFnrDOXY8hDcwBjIZ
         O5PsnWP+7pyw1ULwg9TTqt5gKoIOhTSohEMhwBynby4MZJrjSfWfUiYR03M5X+75feGW
         MIKxuxleUHcCTwOmfwb0nRcYLjpbc8U+YHlnEAxOdhzvwVXxUgl4FW7Byf3/cQlZm7ib
         bDgA==
X-Forwarded-Encrypted: i=1; AJvYcCVOBVIuvDg9L29zZmpmHvvLVBWY6qAe/adnJyJjPOTiTcnmRdzjU8EGAwH6285nxh7ZgRGQG5FIRcbuT3yxx/DlS1elggbg90rxSdP6Lb2MafJcTh8laC5HZb2NI5X9RMAxfjoaV5ZdKh6NCravsy6aQ6CijZUPirMzpjSDN562L9e8rK3+9YH6hKfYW94oF56QVJ0QIU/xDfa0X1TJlvnefkBIostRPsh/vEZv
X-Gm-Message-State: AOJu0Yy5vziL3NZ9ylBmi9gMFb2XXQHw8LCzLxf9uxiAnh5X9my+MeMj
	EhESry1jqoJn/syFiNYpRfVczo2JLFMW5YrXXdSIq9XT/s2wFuc1
X-Google-Smtp-Source: AGHT+IEfdT0u+GNUvqc2IQqievgBGrYbYzE6csgkYg+ooNoxAHp4tOGUzoKNnscpqMdglSVxGHUWwA==
X-Received: by 2002:a17:902:ea01:b0:1e2:c1ce:5b9d with SMTP id s1-20020a170902ea0100b001e2c1ce5b9dmr5303688plg.2.1712422086668;
        Sat, 06 Apr 2024 09:48:06 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b001e2b8c91f04sm3665068plb.22.2024.04.06.09.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 09:48:06 -0700 (PDT)
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
Subject: [PATCH v3 05/17] lib min_heap: Add min_heap_init()
Date: Sun,  7 Apr 2024 00:47:15 +0800
Message-Id: <20240406164727.577914-6-visitorckw@gmail.com>
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

Add min_heap_init() for initializing heap with data, nr, and size.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
Changes in v3:
- If the 'data' parameter is NULL, we now make the data pointer in the
  heap point to the preallocated.

 include/linux/min_heap.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 87737cadb9a5..f6b07fb8b2d3 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -38,6 +38,21 @@ struct min_heap_callbacks {
 	void (*swp)(void *lhs, void *rhs);
 };
 
+/* Initialize a min-heap. */
+static __always_inline
+void __min_heap_init(min_heap_char *heap, void *data, int size)
+{
+	heap->nr = 0;
+	heap->size = size;
+	if (data)
+		heap->data = data;
+	else
+		heap->data = heap->preallocated;
+}
+
+#define min_heap_init(_heap, _data, _size)	\
+	__min_heap_init((min_heap_char *)_heap, _data, _size)
+
 /* Sift the element at pos down the heap. */
 static __always_inline
 void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
-- 
2.34.1


