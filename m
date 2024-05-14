Return-Path: <linux-bcache+bounces-452-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 120E08C4E05
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 10:50:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A4AAAB232C1
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 08:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79D1D55C0A;
	Tue, 14 May 2024 08:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iLCSfCOj"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255E336126;
	Tue, 14 May 2024 08:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676504; cv=none; b=sG5U5TpLj4MAMJki2NicKn28dHJVLvjn6fRK0CxQapvIr34JiKdHdZB9HLVdc3uaRALJ8NS1hcTBJMpT4urO8gPtd/EHv1IMXMNJCfRetmddrRBjB13SLO2s02zkeYqiGLlqpswDXm7SmlxQzq7jfAESM73WXEzqrBFPCXtwVZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676504; c=relaxed/simple;
	bh=8grIJogka79sG9/+DDK77OmBdavevP9vGHfoCgHyPhY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YxKvD4hSri60fL3zQTsm/5SHKR2+3aifdqmc+kRbaggxjs4PyLUTn8vWQwFWhPGTXL2/mDnlgYJx1wFA6otTDiL6uPVQCA0sdWbg/ZuBaBSSUVOY9MB0ChBG+qdFzGHMNJS97OqDMTZvNst70gnl9r9/ZyguVgAZsTIngwO9DTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iLCSfCOj; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2b2aab2d46dso1233027a91.0;
        Tue, 14 May 2024 01:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676502; x=1716281302; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zSnssd6hPC3K4+9QwFoXbrNCoJbqsVd1VI58MolSit4=;
        b=iLCSfCOjKZJ463irV+9X/JMvFQB8sygWVtqMSR8fNoprVaDz0KNm9HiKed0xbQZ72K
         XMxc2w0Vho/DVbzb7UwYOOwFTshTnSTpD6pHYYKY9sFHCwt5J30uTBriOWpuXYVddctJ
         UVo5RcMh7EUvunbN9BmIEnSpYgWfmbncHola5tsmLfjvUB0VLO1ystYEnhf+3QHOr/0f
         0IXxD2IbtYxWpI53nQSJqBvUZkCvXUQm1RK7czESJm4E8H7LiSU1690Pu1s7hDKfDxqE
         82qVDIdgTAggFBeTFIcrhCjiA6WSXKu5pkD+6W4IFtD0CCLvHKEUdS+FyTpXDk3P40qk
         gGvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676502; x=1716281302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zSnssd6hPC3K4+9QwFoXbrNCoJbqsVd1VI58MolSit4=;
        b=Q4SjMX63GNGYeRL27pqEO+TSjseWhSjh3fYfZsO1U5mIXV9nKGBpFInEHu3AevSQlc
         y3LDVKWjNNH/vFj+JpMw2YagzmYmU5xOqUV+Ygm1Ms3CmQvOTmXBaKSBa3BxNyATa/KC
         bwSfASA3YxCte7NjblZ2QpAsdXXoQ/bxvjbpJAl+VETb+LAfRN1XAv7RxAKzCDmh5S3k
         DRqiZWfpQcQud7IgH017NMrFS2wJ6XccnxV/qiqoM3ZU8kAMtxPgUUOyrPoCR+/Ds+mF
         aHMVLhlxOFaSyvn5XsyMqk87c1b0UYE63/chWA72hVC4MndqDQpcfiILmy5csUE5U7tI
         uopA==
X-Forwarded-Encrypted: i=1; AJvYcCXV74e5/ATqLoiHwsQ5u1mQZF2B73viXxa7Mf2A6/+pLSzE6wqJ9XaoIuyYNw9DzvomKS2txvvPZ2t1YNeLLMNhsf7HV6GjMw2qR3qWgvAxxg249MvEpsFvTHMXvyWelJpK+Pvp16xVb+za5wIYXglKl1Jtv112UnRLqxDflBmPfelOmS3hseqnxHl4Ya2u6+aQEPUUxR4vkQOr+hnnF4wYEwbZF+aIoaY5IfVG
X-Gm-Message-State: AOJu0Yx4dMrh0n7DcGbmfUlc52SdQ160DpMJAD8/5KmR6O3aYtJ/TI7q
	HsWfJcoNDJYcrnqqebZwc5NpMPl9uAmCVTlMrD4lCS9B3kSidGlF
X-Google-Smtp-Source: AGHT+IFPNI9RtyTNoKPikm+afe8TVCRh8CRN1TwrBLiqKxWH2jb9eMRvsssng1X4+/efPHjACEXLew==
X-Received: by 2002:a17:90b:354e:b0:2b5:fce8:59ef with SMTP id 98e67ed59e1d1-2b6cc452fb7mr11632747a91.1.1715676502501;
        Tue, 14 May 2024 01:48:22 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b6711660fdsm9195597a91.16.2024.05.14.01.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:48:21 -0700 (PDT)
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
Subject: [RESEND PATCH v5 10/16] lib min_heap: Add min_heap_del()
Date: Tue, 14 May 2024 16:47:18 +0800
Message-Id: <20240514084724.557100-11-visitorckw@gmail.com>
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

Add min_heap_del() to delete the element at index 'idx' in the heap.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 201f59cb3558..c94f9d303205 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -212,4 +212,28 @@ void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 #define min_heap_push(_heap, _element, _func, _args)	\
 	__min_heap_push((min_heap_char *)_heap, _element, __minheap_obj_size(_heap), _func, _args)
 
+/* Remove ith element from the heap, O(log2(nr)). */
+static __always_inline
+bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
+		const struct min_heap_callbacks *func, void *args)
+{
+	void *data = heap->data;
+
+	if (WARN_ONCE(heap->nr <= 0, "Popping an empty heap"))
+		return false;
+
+	/* Place last element at the root (position 0) and then sift down. */
+	heap->nr--;
+	if (idx == heap->nr)
+		return true;
+	func->swp(data + (idx * elem_size), data + (heap->nr * elem_size), args);
+	__min_heap_sift_up(heap, elem_size, idx, func, args);
+	__min_heapify(heap, idx, elem_size, func, args);
+
+	return true;
+}
+
+#define min_heap_del(_heap, _idx, _func, _args)	\
+	__min_heap_del((min_heap_char *)_heap, __minheap_obj_size(_heap), _idx, _func, _args)
+
 #endif /* _LINUX_MIN_HEAP_H */
-- 
2.34.1


