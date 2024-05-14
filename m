Return-Path: <linux-bcache+bounces-448-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A7BA78C4DF8
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 10:49:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D93631C2166A
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 08:49:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D40AA3A1DB;
	Tue, 14 May 2024 08:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PXttNeeC"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81374286A6;
	Tue, 14 May 2024 08:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676484; cv=none; b=PcEt3IHpzcpqI/PA/rXtWBqwQ/4zNYlwTVuO8wwLEBuaKICtmnDFns4rvvK/EttOSZIvcudCTWdOIpsYBs2+eXKfOvk8ZBHUTyKob8KY8M+ju7geckCz64ZeJI4Gx31uKlawwYdEGmh3h6uYgXGEXwsE2gwz7lfSLrHkY+RwC+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676484; c=relaxed/simple;
	bh=9tjNBJoFW/M4N3UyhM3SbO6qdcqZWdxAoa5Ri1G9BtM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dJQgBQiBGVWCeNjGzPs0JhYjRclltIzNhY0BAtXFQTdxFeotphsTB3X1cb5B3mJ4LBSynt04lPYRBAzXz4fntXQCpzn1K+wDL6V+UdXmpOAg3SaH95jYitYI7wGDPNXGYaoTVdkaVtVWUaza6HiWF3K6pCd9z7dSA/gLE51luzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PXttNeeC; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2b516b36acfso1394434a91.2;
        Tue, 14 May 2024 01:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676483; x=1716281283; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0J0f9A/bhPWWSuBlnbsdq0jeNHFHB9IJoCtvcFhHPOw=;
        b=PXttNeeCUzORSBKG7aSYMJYw1UmPuzK+ATYY7miXxlZgZ0qq+1pcp45lY2BO93nlCH
         rll7CkbiB29t285X2MyCklNj7BOuP3+0PQeTs159CHsX3HvmQxZtBjVFDJSUyil6aT+E
         pZWkdTaVALma1YvLT2u49UDGocOzh4pln5LlLIKKyF6CPflZCj7RrWtCRyWLFAe2HDhL
         0rnVfipH4peWNDvAhpN163mhwPsJJzC/6tmLlRVg4QPP0JMBCeir/yzxs3hPihTAFAp2
         JToNyVpSfJnnCJFDKjroGUvUGmBxgtKgzgMhr8jftaastsRyOUmeDc6TWlfNzjsgmlG/
         GZjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676483; x=1716281283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0J0f9A/bhPWWSuBlnbsdq0jeNHFHB9IJoCtvcFhHPOw=;
        b=N6sV7fjWw8fOkQnnYZnAv+TGWQVaYGA/ACaMCjwcAkP1Syhi5Nz4LJg79iIlW2jyDr
         mQBBnafUDXWoAgFQOWmCQeqCiLk2AjcLGAV+3cBHxiYzQDs/cMrGyl9C3ijTDY6K5+Fr
         tQR+OvyG+7UDll1GrTwfSna97969ZB+zfS2zeGQhoqDkxFLPUAqxHtXPhZ52f16z1G5V
         ASshyJCb0vJNg1nw2317TKtORY+R579P5Ut8L2qzRx1U4GT41XfYgD3NZlZ620ZPFfkd
         QtLmZPS6X+E+2GrJSb/qPBjtZh/aMapnNcwQJILtrU3AApkCqw206Gym8tmHIW0t4KPz
         /Zjw==
X-Forwarded-Encrypted: i=1; AJvYcCU4tEvNf/MyCK3MgoAHRoLsUQPyBpT0Dg6dZP9yAKLQvjsWlqPSUd/Yl+QGajxZMFt5RBjw8CFLaaBEYJg6dhvPqQOCGGp1Efj3ZMrIlSSS5PfoILPZDZbImBn1OomfGwFqhcAchUizHcBAXXZCrlSHOy8CSIbpOwtlb8fXhr1/JTlCwV91LzB0plvB1OMPymKqjv9x8k0I7onDbr/C5kKvRn7Z+Bn3Ck/gydvz
X-Gm-Message-State: AOJu0YyKiyTanFJ+GsXlq5e5OPuZHR+HIyPaeo/nCy1g5CGlB2FsBzMg
	ZLMJYakkj7WI4YXFeu8w2fzIYtsodKka6KUTOB5jcVjvHTeDZHir
X-Google-Smtp-Source: AGHT+IE1patJmPNchHUnX39Zems7iVVjiSomR0wHWIH7h7asJlDmxjS39dyTAxeWrilwIpfx2hdfuQ==
X-Received: by 2002:a05:6a21:7896:b0:1ae:42c8:4f69 with SMTP id adf61e73a8af0-1afddf12a2cmr15147500637.0.1715676482845;
        Tue, 14 May 2024 01:48:02 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b6711660fdsm9195597a91.16.2024.05.14.01.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:48:02 -0700 (PDT)
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
Subject: [RESEND PATCH v5 06/16] lib min_heap: Add min_heap_peek()
Date: Tue, 14 May 2024 16:47:14 +0800
Message-Id: <20240514084724.557100-7-visitorckw@gmail.com>
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

Add min_heap_peek() function to retrieve a pointer to the smallest
element. The pointer is cast to the appropriate type of heap elements.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index f6b07fb8b2d3..043de539bf71 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -53,6 +53,16 @@ void __min_heap_init(min_heap_char *heap, void *data, int size)
 #define min_heap_init(_heap, _data, _size)	\
 	__min_heap_init((min_heap_char *)_heap, _data, _size)
 
+/* Get the minimum element from the heap. */
+static __always_inline
+void *__min_heap_peek(struct min_heap_char *heap)
+{
+	return heap->nr ? heap->data : NULL;
+}
+
+#define min_heap_peek(_heap)	\
+	(__minheap_cast(_heap) __min_heap_peek((min_heap_char *)_heap))
+
 /* Sift the element at pos down the heap. */
 static __always_inline
 void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
-- 
2.34.1


