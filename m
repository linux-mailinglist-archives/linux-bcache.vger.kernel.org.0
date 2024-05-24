Return-Path: <linux-bcache+bounces-478-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE0F08CE7F5
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 17:31:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93B14281C06
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 15:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF14913049C;
	Fri, 24 May 2024 15:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ds5O3Zkp"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8D0130484;
	Fri, 24 May 2024 15:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564633; cv=none; b=K7UuR8mKxjXYunR/xntXZXC4TJj5b+LnyjSBpVeFfWF4/rNvBjEcB+vb3sivAzlRQWse8qwFjY++qL2F46iSisDlaSqADB9l34V48s1hXzv0oZKEkhcBptlz/3O3M7J3RUzpqfmZYGksYHAfiy+kmWoZO9Fjh3E9KMri4UBufQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564633; c=relaxed/simple;
	bh=3Cv/NEYxtL7rses18dsQW99Ih1hbxSO8VST7jRlzjCU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GsGRT7I3UBf3+QUz0wWLItOwsqWsJ4bAib2Z8FoakGRFTzvM60qyJiKIidfvYOMd4pNV+GbdlwtV/oMGRSLSAoDZeIrSWG8JHjtZ5zSk61MmoDAtYIBgwtvSUPkEHJIYqK+3ZAS40ZvgsKRR1KYIKgaoDH7G8Ei4IOkZQJXBbZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ds5O3Zkp; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2bf5baa6034so216150a91.0;
        Fri, 24 May 2024 08:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716564632; x=1717169432; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T0fYqR9rcSvYbrkD+sBe/h5jrjzbrTBXD1r+tuRTAZk=;
        b=Ds5O3Zkpr94eCX52WOGzUVrJedFZvUbUzyJRh0KkXcQA6cN4IGv/4Yi2UiIPQDKMl2
         gRRLuewm7yLyDs9cXYZFoRbpRdxg6Gw/mBW9j8cbfXsRce6xLOdA/nPzTYVO9dZ8P3E9
         ZAV4hI4p0ujntcHnVRGzreVxgoZju9RrvVGY4JorvT/rnj0ZXYdOKZhcMTn5KN2sX4k2
         s6qgwLAqXG0lJrIboF/6eL5kvEBx1+3rJtM1bW43DtMLVtMVpZjKtW/znfGtqeOApoZg
         rznm9WhI4y8gkRk5vzPxshed3GNhC4IHVUrvMdGao8vSRy8KFTnsnbzBYN8Z/0B0LpWL
         6gYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716564632; x=1717169432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T0fYqR9rcSvYbrkD+sBe/h5jrjzbrTBXD1r+tuRTAZk=;
        b=tgefL3nVn07vZF8VG/hRyhki3qPfPrcG4p1fyiyKvHyuotC+QyuGm2B47orsXMnedM
         kOHCi2RamJFOCucTCXLlT9mt0sX7pKcGpiyYklYyrLc5lmf1Wjap4nVCSKb19ImE5fVD
         jp/SfRO244jKSIrZbbEhtQvKDBHfNRrsc28RXraTDMsLdnxxQ7DxITZEayUavgFSBJJl
         91OxSKHPlcV81aDZQF0wY1/NGm01ARMYm81foOpc/c/C8wjuaSzm59AO2jv851sAQw3B
         RTz8NooNN10xNaT2rBJtKUPn/vdceIwyN5AQX1JgYnSoDRjedP2sR79dPn1PT3fz4YBo
         q7wg==
X-Forwarded-Encrypted: i=1; AJvYcCVSzvKZxQXRQ5bqCCkIr+KizOqUcWTZBXAofTWijhSzej7bUO4/Gj4RtJp3lv1enPbQ4NwoCGZSuXzhmsCCG3Yw1SKYPpUZTxKi+ikQr7FvrfX2JOrHi1Z8/buVmo/uVlqB5eZ1zT9ol6vU3RifJHNHuO7DxH+DP7qtVbqDyePxR2YXva3845znWUpxmTQE7O+ZRfIUQ3nV8+508hSkXNKMhiobqMsvBWoKcb5O
X-Gm-Message-State: AOJu0YxMSQV7N0bJEwgTh5VKvmlaQEhOPHnsfZQp6i2VpMA4mevGCHAa
	x+B8pTakknKpBn1GH25X9VPEW2znPfKb/qW+g6OMgzDm7VBieIbo
X-Google-Smtp-Source: AGHT+IF8luE1cdHm1AfcM0WoDjZHudhzFqofZ1FcFKJ69yRGqwL7AZUhIIsbkDXV3LM7TdHAleFXCQ==
X-Received: by 2002:a17:90b:230e:b0:2bd:76ee:48c2 with SMTP id 98e67ed59e1d1-2bf5e0a7a56mr2494152a91.0.1716564631729;
        Fri, 24 May 2024 08:30:31 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f50d294sm1525556a91.20.2024.05.24.08.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 08:30:31 -0700 (PDT)
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
Subject: [PATCH v6 05/16] lib min_heap: Add min_heap_init()
Date: Fri, 24 May 2024 23:29:47 +0800
Message-Id: <20240524152958.919343-6-visitorckw@gmail.com>
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

Add min_heap_init() for initializing heap with data, nr, and size.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 92830f41642a..b384a4ea2afa 100644
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


