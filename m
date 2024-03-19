Return-Path: <linux-bcache+bounces-300-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D2737880434
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 19:02:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C62DC1C21FD1
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 18:02:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65F1D39FE0;
	Tue, 19 Mar 2024 18:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TY3jwtse"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48DE3B289;
	Tue, 19 Mar 2024 18:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710871245; cv=none; b=YcqQtMJ8C3tRaMlcqbtw+PdcPLxE2vkc0NjN8bkX6r9qiiMkuSnhyhY51rh9bgQon5DiMgIlCNdIuBBeUqb2rgu2aPNtdQuuKb0Mt3+v0LOSrlCmRGERm/a7S+JBTP4hAiIwc5N3aD+fsERuYYCLk49iGKQM6mEHxF1E0UGDlv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710871245; c=relaxed/simple;
	bh=n8NPWU7TPG0FYu6/1N5UcgjqvR4CgLcQsDnsmf28uBE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PFIW95ca6RebwYJ9D1G67XKTaB56JU2apdQRMjWxnhAiA10ovuCr+NJFDMJOLb1MQY2CwJh8KTxUq8kXsUZy27XyMhvRAr1/Ap/oms1iCCOkmWhuz8gHwkorztkymvaaKNinTcGW9fvLMCHMgU1ZLkHLoWP64CXPF1rlYMFkf9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TY3jwtse; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1def81ee762so8052735ad.0;
        Tue, 19 Mar 2024 11:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710871242; x=1711476042; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WFeAQpAK4aUBu/1PW+JMtASIBT0c/sUzFzsKvR09WTg=;
        b=TY3jwtseA353mYpDXImFu+7lKZmRF3o0JDxLHsHPAcM7MjWwgYcYfHj1NwyD1kSt1r
         Pi+M5CUiLoU/aX2C+j6/HJa0EccyFFVatxfruNlE4R5Q9hTATaU9EozWutG1DKB+hGck
         dFM1ThTgXxiWpk8BGBFUPx4lx9b7j5t9B22WHx+SuDidBwz3BobaQMcTfSOAfraT8jtF
         ul4xqBSt/ru13jRlwxyxZ5hVLJjkf4vHHqxrP41GyWuWcMCwNcrGY7QERL0ThU6SX/Zj
         G0utV4GF0WvVht3XZtbdkRLsPNJ5XrXlNESczRDS3pGeuvi2FqIJMVrFUvZosWBhV1ca
         xL+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710871242; x=1711476042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WFeAQpAK4aUBu/1PW+JMtASIBT0c/sUzFzsKvR09WTg=;
        b=kgWsjDQzex3/zd9Y9eu9VSgKKX5AC2wPUhmh1bQBC5IBcw0Vp+dGStPNIq+KNTIT/s
         l27JmFqDYxJNGiSYVQQJDmeXJvxtk9ELUzEKMncm6NL5olXJyZi0J7QdMSdWm0U3ytwt
         DbFIhQCB4PTa3ZK1XUbbMDw9hch3KonHXqozZKNNYoBz++KjSEf4XGlZK8aFUsNC53mv
         AzdQBQRSAcyRbihQYAeb/+9Qwr6q7yBNut3i/AvxdxJQN5LYhSGGw9vGJw376h82gDXu
         aZF3C/h+Vme1LJScGLKcGlhF+2uFo+QV5xZtF4UPj5VMRIoMsy6InvUQoWbnRb+lRK3M
         1Lpg==
X-Forwarded-Encrypted: i=1; AJvYcCXOvCoELgOqcKTXEFqQki9GajwKK6xB8+jTTWc7OaRPJKWlXHTT4zjPqGvFQ17mYrbALGWem6xTZit7ivUmlxT6b1HNxR4yn5xMN7ayRGMQkb+za7i851fgGIyaE1xAILIxrh2KcY5UO9/EE+SpHYD8p+j1VXoT/4pbZ9lB7TnUsise4doMI8CI4D0DkSq8FhscV00wxDHKjiNT6FvbjkTH8tjFm6PDMsmw+Eh7
X-Gm-Message-State: AOJu0Yx5hw3dQaxDGHX9oqIASYvkWB2K2kz+j8ustGJVitkHffEocPKj
	HsvQyvvrJNJ2wwgj4Cps5fNHcQZPHQTuVFBMbLpqZvt/OlJZB5zE
X-Google-Smtp-Source: AGHT+IFB+h3UiEYM4uOMtZyHElq0Cc/LqfYFRVzSSDBHrYR9QcIjIvtermmErDaKNfSoK+egpfDDig==
X-Received: by 2002:a17:902:d4d1:b0:1dd:6f1a:2106 with SMTP id o17-20020a170902d4d100b001dd6f1a2106mr3338647plg.0.1710871242213;
        Tue, 19 Mar 2024 11:00:42 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id u16-20020a17090341d000b001dd3bee3cd6sm5531359ple.219.2024.03.19.11.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 11:00:41 -0700 (PDT)
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
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH 06/13] lib min_heap: Add min_heap_peek()
Date: Wed, 20 Mar 2024 01:59:58 +0800
Message-Id: <20240319180005.246930-7-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240319180005.246930-1-visitorckw@gmail.com>
References: <20240319180005.246930-1-visitorckw@gmail.com>
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


