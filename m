Return-Path: <linux-bcache+bounces-333-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 058AD8813CF
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 15:56:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09EAE1C209CD
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 14:56:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26B034AEED;
	Wed, 20 Mar 2024 14:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RQYiSXJo"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0DC5645B;
	Wed, 20 Mar 2024 14:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710946495; cv=none; b=Q2IPkiT2zBhcDT83ML8gMD7xL8KWZZdb+YM4rt0XBSaZNJJccFhiz8e2xQyn+VfrsJMO/8AqRKRncKkKOdVmMv2bcpatVpFEKatFsTVcuy1m/gCTkLBV20CqxygzRL6AIwYd+zipWMx2R6LWXfEct5aP1yFEfnUrD0I5fQi+Uqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710946495; c=relaxed/simple;
	bh=8a68K+W3qZD++KgYqdJ8QFpXlGJ3ofQ9m/5i3nVK9u0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xjar9W0Dp6Dc6GldK1R94zhZc8Tn4T4d5EXHSDnVEhzq2rBT0FjWsBa1HqRz/zIzMUqol4wDPm6/f9MgbHUtFlrA36JRJwGd+k9Qpu/vIZBtuUmlE2PMY2hGmcAIqdKXCOK3mEJ64XoN5+8NquAu21XMn/2Tbw2T2ShfjqaHBSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RQYiSXJo; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1dee6672526so6079185ad.1;
        Wed, 20 Mar 2024 07:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710946493; x=1711551293; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g5/a5el4a61wFJIBzCgWNmWU3XZlSJ2PCR5OhDq59lw=;
        b=RQYiSXJoNzrTFJNriCDqofrrD38NwTxRhNaAAPZXA1Z1OTGi0oNAP18rp4rhWwLVHp
         fYNfKEry/ywdPVw5bv3Cv8mnSNSOxqCrUlGVTEh6Mi9rJOdd6TGC3kLZsoEDFMtLSPHd
         frfWsNRrv2Ep31Ie9uYxmVmcHSvUQDd1D2amVMu7WpLgVO9+NJZM5xzRbQyEon0dKg0m
         X8KdTHPswAOGV1WxcS+gu4YTRQmXLaJOvgyXadUNpUadeW6qW9lRF4jyTYzuVkeyg0zt
         hkEobPWyu4ktMP3PbRBsu7fbhnBRfA7+pqY/XwOKltBwPI1khifmIn0uk3iJ/WdCtngo
         VL1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710946493; x=1711551293;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g5/a5el4a61wFJIBzCgWNmWU3XZlSJ2PCR5OhDq59lw=;
        b=Af1kq0kmaqOSQfuoEQg3L40+ZfMAA7CBQNWZE/gQSyUYBS/A4TLNneZnv1YpD02JTb
         ZtVYgpfRS7M2nvVB/EJNf1sT9ypmzO/ehWzP6tswQQFdxyCtlv1jMnD6+o5FmN2ikDKl
         abKsWJKhzlSoPUgAxrX/UvOGrYVhvafV1ZIj7I7yQQO9BhwiBlIxdr+K2CX3yJU7JTkk
         9JrOaosd74JV+UkX5neAvL3eDY81Vj1Yv1G6he7FbbcKtGm6MURVjcDO1iCWK/AvH8Nh
         RrlS6LHPu9jUUtOmDrfwoMH7+rqObGEW8Pad9HhaoE/WLEcniYKC4vyOIH9pC2WOdUaR
         WtlA==
X-Forwarded-Encrypted: i=1; AJvYcCVL3fb4p6SfDaSOj/R2a7rl9j4kP32ouvTMey3pvrpqjYJuVr7L2f1okzMmQmnwyIB5fMHTCkANDXhr3HNz4S54dPMlhp3RnfDDRKV00SrLhYFpUqG5gtK2Ii6snI7J9mMhAnmkkQ/c4AY1RdVQIe0Tt1MngwwzenZrxKlxEwYwioYXn+ve4M77uPWqDqBEvF0CkkhhxO3SC5nFc+1b+piKpzRVVVpJXUqlDzEe
X-Gm-Message-State: AOJu0YxHya9CNCFjtJT15OUaBHqpbTXAs0AZbm8Y0oU87N99i35qthmR
	4tGnqb6+tn/PPmRVMpQDxh7bBe4M746d5nd7G0SFr7TVirGXDgZd
X-Google-Smtp-Source: AGHT+IGvhyqndniFbkMNrKQajfiHJUdmj6ZvIM3gEC4yAeOXQXFolKTC1Reahvgx53VYp1rBgyowXg==
X-Received: by 2002:a17:902:ce91:b0:1dc:df03:ad86 with SMTP id f17-20020a170902ce9100b001dcdf03ad86mr20347899plg.2.1710946492946;
        Wed, 20 Mar 2024 07:54:52 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id la11-20020a170902fa0b00b001dc30f13e6asm13719989plb.137.2024.03.20.07.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 07:54:52 -0700 (PDT)
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
Subject: [PATCH v2 06/15] lib min_heap: Add min_heap_peek()
Date: Wed, 20 Mar 2024 22:54:08 +0800
Message-Id: <20240320145417.336208-7-visitorckw@gmail.com>
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

Add min_heap_peek() function to retrieve a pointer to the smallest
element. The pointer is cast to the appropriate type of heap elements.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index ed462f194b88..7c1fd1ddc71a 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -56,6 +56,16 @@ void __min_heap_init(struct __min_heap *heap, void *data, int size)
 #define min_heap_init(_heap, _data, _size)	\
 	__min_heap_init(&(_heap)->heap, _data, _size)
 
+/* Get the minimum element from the heap. */
+static __always_inline
+void *__min_heap_peek(struct __min_heap *heap)
+{
+	return heap->nr ? heap->data : NULL;
+}
+
+#define min_heap_peek(_heap)	\
+	(__minheap_cast(_heap) __min_heap_peek(&(_heap)->heap))
+
 /* Sift the element at pos down the heap. */
 static __always_inline
 void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
-- 
2.34.1


