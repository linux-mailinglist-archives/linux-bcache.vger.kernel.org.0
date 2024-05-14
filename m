Return-Path: <linux-bcache+bounces-455-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 146F68C4E10
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 10:51:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4049E1C21919
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 08:51:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70DA36F085;
	Tue, 14 May 2024 08:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B4wIXKS5"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2194B6E615;
	Tue, 14 May 2024 08:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676519; cv=none; b=OXJvoA2a9ZqySgGecJAqkXds/zB1bLCrXnRTin2zQohML9mXtQ2JHibPGteIN5x8pz0Pbz1ippKqrVUpY/YtWwGNoN8bp5UCryCUAnjbncEfHWgH+G3F77U4IXoOrrfz0tOUppPT4QvKOXYLL5/vJ5NvPBn3Z2rKcEx5eNn4bjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676519; c=relaxed/simple;
	bh=T8bV4BnctbyRNeSPAOZwi+czorsklhrFY1lqJqcqucQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rFqDir17ZcIUAnfXUuQFKdTFHHeSwfjgUIZXgFRhywQrhzbP0KK6me9bv+4Wze/2X+wAxmTJ2sWT8Oq+USIWW7DIjFNMMM0xTO8t6oX1GiegjfZr3Exx+7U0vjyMoj5hfJU88fZYVclvX1D0Q/xNGtVBjRVumhtqcj0olkt49Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B4wIXKS5; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2b8fb581e77so513567a91.1;
        Tue, 14 May 2024 01:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676517; x=1716281317; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8RRhCYNi4OEA45vqDvulwCxtOU91F7rHv4uIJxFLbAA=;
        b=B4wIXKS5Ih04dr4mB6VJVSiQvrAJTyI7ym1kQHCAbd7XVkDmdNa7tLin0V09XvEylx
         4MQNqELPQmAlYiHsnjfHfdcnQ8/YQmK6pxggxqNJUn481n/f9OOxoGAaoMTBUIn2ub4t
         L3jZAVH4W3WcBJJ8VTH+X/xMJ7wFk2+o3gLuYMmv0ADm8b5OU/epb3hii1Symf17Z5LL
         z0TsbK9yZv4nvoi6tCD4x/F/wrdzKwDWnlxlD7t62c4KgeKsaRWIpEOuDSC1U+pYJSIU
         GDe2L4SNhvda1JogSC9jZK3kvdPZ9TpuBwu2dpDklDQeZyI2+XFf7jXdg5FmtZehYEt2
         zevg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676517; x=1716281317;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8RRhCYNi4OEA45vqDvulwCxtOU91F7rHv4uIJxFLbAA=;
        b=ZHbO3CFnAg9Lz6LCxTeW3eKpHGr+1xSEqnDoZvQS/1GF/PWrgikeWqdHsMBLTAvbSB
         D8UpgQrWwsS0ZhoZLpywV52x8nBttY5V6BtWvNegkWn5rvqMiQ6umw8vTPr/pxH4oL6S
         03H6+rlD++s4Bg4uRsgOwhp0Jd41JhNX8tPxY4HlvtRTRGJf7RSp4hoj9vyV1F+2sNPj
         ZBzGMOWUGZqan1G2dI06JeYUE0HrjdVu1pWnyJ6nSG1OXJt/zcPjzk238g00VQl8XZmL
         S9mQDgRQczUpexF4Be6/wu+3uUgXAbGByQ6500rr/pEjw374H/QuLQ/t5qiJZX8Mqe/E
         kmxw==
X-Forwarded-Encrypted: i=1; AJvYcCXqjHtvB7k4nTsmPEqUHG47n+nfQSU7KFKUsIwKdH9CQgQAli7m2qOqkqrV/EF6QqNrNAPMgfMQa0lhwXsbk2+HeLyAAZ2lStTfDKlY5VHV0fneQXZlPiIrzE5TsOP3XW5klbRrrSO4OXoESktBbr5SCg+8LFIuKTx4RF26WTtPa2o9KeI2enpGt96L+Zsxs6/6m68+U27TwFOnzGDma2Acz924vtJZ7R1yf1Or
X-Gm-Message-State: AOJu0Yw2hdwslVd9cDTHK9h6qGk6iLjgzkFysBTfBF0XjChOExXAoGxA
	zfCuBcSpGjtYI1EawNCscMtPmVTAIlKaWJSpkaxIaMP1k9B8hDle
X-Google-Smtp-Source: AGHT+IEzlf/04lUJoXxSbnAU7zQCtwIAC9yXyQQEJzVOzxmc9j9IenXqL82SIeeytIkK98ac7sU06g==
X-Received: by 2002:a17:90a:e2cd:b0:2b1:88bb:20ed with SMTP id 98e67ed59e1d1-2b6ccd69770mr11166692a91.2.1715676517541;
        Tue, 14 May 2024 01:48:37 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b6711660fdsm9195597a91.16.2024.05.14.01.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:48:36 -0700 (PDT)
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
Subject: [RESEND PATCH v5 13/16] lib min_heap: Update min_heap_push() to use min_heap_sift_up()
Date: Tue, 14 May 2024 16:47:21 +0800
Message-Id: <20240514084724.557100-14-visitorckw@gmail.com>
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

Update min_heap_push() to use min_heap_sift_up() rather than its origin
inline version.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index f907c694e852..78de60f6ef1c 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -190,7 +190,6 @@ bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 		const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
-	void *child, *parent;
 	int pos;
 
 	if (WARN_ONCE(heap->nr >= heap->size, "Pushing on a full heap"))
@@ -202,13 +201,7 @@ bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 	heap->nr++;
 
 	/* Sift child at pos up. */
-	for (; pos > 0; pos = (pos - 1) / 2) {
-		child = data + (pos * elem_size);
-		parent = data + ((pos - 1) / 2) * elem_size;
-		if (func->less(parent, child, args))
-			break;
-		func->swp(parent, child, args);
-	}
+	__min_heap_sift_up(heap, elem_size, pos, func, args);
 
 	return true;
 }
-- 
2.34.1


