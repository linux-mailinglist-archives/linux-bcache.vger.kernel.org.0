Return-Path: <linux-bcache+bounces-480-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B569E8CE7FC
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 17:32:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E69841C22328
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 15:32:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F0DF130ADE;
	Fri, 24 May 2024 15:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R8U3o2Ie"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31848130ACF;
	Fri, 24 May 2024 15:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564643; cv=none; b=QTyx3A7tF571G6aLdTexG5jyCIZTVBUSnzc0Y0Pi8c0QC/XnYbjWpSXKZcD74QDrpmrTl0TivYG/Y8jb85iY8xO56VsjrqUbN/wkrWCq1jlkbRrfOy0P8BEsLmOb/X/BUVW+cfcn66SNN+n8FrwZjOhgXLBaiq3OFlPxSSyd0W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564643; c=relaxed/simple;
	bh=KituFP5FWvyk4tf0TCLoKJP1Ug399E1uez9KXSPSXO0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fsPzdOs8fGcqDSKHm6KZ76HeeBU2cQh9f1tRDPLVZmwfDVIu9yU70w51EanBI7UV3ssmNNe42xppATNFa9f1ORSj/oVOPI0LJ3KzFJuQsPIHgU60wZFYJi/f2n7krMbIhYJbLFoiGJAHcAjEck6yTwPSBFI56d5T2rHJQs+8Hxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R8U3o2Ie; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2bf5baa5b76so103306a91.0;
        Fri, 24 May 2024 08:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716564641; x=1717169441; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L6wGqg1Bkc6VloO/r5wptzdiAzti723DW6TYEbY9ymY=;
        b=R8U3o2IechSXYCc2t9e+2bV7+BR8oV5zWVDFmXgJ2xQQcsFvIX3rOKn8xcnjb1ZLbC
         yV8joStOtlxdWO5OO4oggyOdVZNqnv/gaQN4hTzmNJpaM91oW6zrDMYjd5x/meT3aEFz
         wLFBDGE/kwhCqxlW3r4x32KYP/mU7CWQZ2E8E2VePmV1W1VJWm1zuAw6YArPPC/OTzXN
         QTGmH6vUOKw9EZ6Uj2uG+T6BuRwxBETQ/t5+Z/L1FVc5xWW9Cvc2eMXKBdI4XaqNpjrO
         UKjoMm+jY3nMhtBxyhEv6xpkUO8Xvgff01UUbsUmKU9DBd9DqThjrzokGfJefEAj+GwT
         emRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716564641; x=1717169441;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L6wGqg1Bkc6VloO/r5wptzdiAzti723DW6TYEbY9ymY=;
        b=uInm1J4IVwhrwWtifgiQrwq/Lm4uWZ2yccWq/lvZYGgNtKUphh849aLRkU4iYuHa0r
         23jy1b0b+vX6Ydr+t3ehIpd/g5XulzNKHG9WT4A0kM82KSmmlfUpjmWyaLk4HpqokYYd
         L3igPr4UB6jN3U5SV++4ewnBJLll+9HnxXr4KRdComYTHMu4PAvoFILxUSj1UOKrWfBe
         USx+vj13kFy5Gbv4wOhAw5l7eBQT6ANZDl7esUX/hEZzWYdhbiJAULA9f8fwqSXfm2QH
         eqy6OUZxgDbyNn5rsT7J86Bzsq9aEhRIJuTdRuJrlqV50yqXmQCnMVhKA8oxh7mcYrs1
         MD9w==
X-Forwarded-Encrypted: i=1; AJvYcCUMHrrBp4z3C+zwBSqQlsHGEUEnHlATc0MudJPpYei2RlAfEfH5vWFFnEKRXOWGXduV3Sm86xMVxGssAucTDUpbufC1hg8jo9fkM8dyKG4Hyx0S4JSg3wYbZbfSEofLaVUoH/2PqSr6W78lX5GZmRXMB8AUwHDqxTAVp7kCcKbBN8eN7tYjdgmidw7OSi8dqqWlxVBHfBh2FUhrpp0qp1rKY7LnLNsj2/UzJ2En
X-Gm-Message-State: AOJu0YwNddzvlX+WNnDGVbGCIjeM4d9XQytQulqPutQgxRB8X/CphG3k
	3dRhRcmajeNzqIB+SOiS5FkibQrr6lgh/UdIpDPuQm16U2pxP+HB
X-Google-Smtp-Source: AGHT+IEFZigwBsVU3DQ0U9XwesSc/pScEk6hYtsY4XibOuLDALe7YcoghUfWtHqjA5Lb2EftoZr+ZA==
X-Received: by 2002:a17:90b:24c:b0:2b4:329e:eac5 with SMTP id 98e67ed59e1d1-2bf5f202ac5mr2505228a91.2.1716564641436;
        Fri, 24 May 2024 08:30:41 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f50d294sm1525556a91.20.2024.05.24.08.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 08:30:41 -0700 (PDT)
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
Subject: [PATCH v6 07/16] lib min_heap: Add min_heap_full()
Date: Fri, 24 May 2024 23:29:49 +0800
Message-Id: <20240524152958.919343-8-visitorckw@gmail.com>
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

Add min_heap_full() which returns a boolean value indicating whether
the heap has reached its maximum capacity.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index d9c4ae7ad0cc..f41898c05f5a 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -63,6 +63,16 @@ void *__min_heap_peek(struct min_heap_char *heap)
 #define min_heap_peek(_heap)	\
 	(__minheap_cast(_heap) __min_heap_peek((min_heap_char *)_heap))
 
+/* Check if the heap is full. */
+static __always_inline
+bool __min_heap_full(min_heap_char *heap)
+{
+	return heap->nr == heap->size;
+}
+
+#define min_heap_full(_heap)	\
+	__min_heap_full((min_heap_char *)_heap)
+
 /* Sift the element at pos down the heap. */
 static __always_inline
 void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
-- 
2.34.1


