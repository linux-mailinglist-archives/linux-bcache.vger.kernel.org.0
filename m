Return-Path: <linux-bcache+bounces-332-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EA458813CC
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 15:56:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFFD21C22908
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 14:56:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CA6954F86;
	Wed, 20 Mar 2024 14:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IMu6Y8v0"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C0554BFD;
	Wed, 20 Mar 2024 14:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710946490; cv=none; b=ifTXbI4TNdc8t+z6rb9ZGjY/Ii3AOKor7rrSymoER6pcoet2qboUa2Ky3h10luJM4qL29CqSL1If6aRcjbHn3hIGKRIsTWFy70zUIQR0q8+9K1LzARhuU2JJ6pgHqP47gZ+yR3vUibD+iQXSa8LvSZlAHtH0ESwnDMDfaSZ+HF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710946490; c=relaxed/simple;
	bh=1kcI5O448ZoSUJqM7Fwo+CLjTMdYaBqUzIGDOV4I8Wc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oqMih5p39KvVozBkmZi7lSJSnws0hInsoU2pM9pZ3JRq0qTOmpv/tKT0Xx8eLJFfKd5NGOztEehF3QS+Dq30uiCqDYq55N6hRDuYRS7m3MMcd10NbOHXLxLx6+7d9/kZwY33zNqCMJNLMaF0dpJfjJHY/UsG5ha0mbialW20egY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IMu6Y8v0; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1def81ee762so9760245ad.0;
        Wed, 20 Mar 2024 07:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710946488; x=1711551288; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wIY+iLTtXDqlHadPKUvUaL+ptK+GK0/HaTJmss4inJc=;
        b=IMu6Y8v0GfXtnfOVsPBV4wYmiQvoxlxDW/i8zST25L/EOpELz0uQOZE1BV62ADzGGl
         rAx0yhFaL4peXgtgSMifq0iK0U+oqOyI/HqZl3Oytl8NFYlCkCvqn2SV/ul1Xl1MFn+9
         QoNUQTK6r9FiUaoGzkPUz+OHouJC572rI4x9hyV+fQzX0qJpvCjHykf55bS14HqNCKaP
         /E37SNDq7DrPk6gSHV/30VyQvv6cO5T2LGJzstJn3nFb3KTypKb4FEurV1MoLsps9Vfy
         wxI7ZQX0DSBo/YMrOUwgoGaR2xYqgMy3f5NB5/1TpIBD0eCBZpwpHiX2wnpqN97GDtCT
         dWzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710946488; x=1711551288;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wIY+iLTtXDqlHadPKUvUaL+ptK+GK0/HaTJmss4inJc=;
        b=eoNnhlcMFYhtV5LQ7pcyyUbwEST2IFPyHJ7W80pGk00rT3HKOrQSSr64I+eVbq1mEV
         78vabdiCDgh1ot3gaEzipO8W/sOwLiso9b1BDkAxm6qaZMaRxh/lkR/CRijYJL2JxZDr
         YldDoct+AEA10RL51IiUbzDivpaFDuEjaJiYTMGwnelC4qc769M8nfBMJDJMioO4ftBZ
         oSqFtWtB4z+KdQ6p0MZ4Pw8SXcd6rvlTvTqGHfj8IIjqQ9gTLRK3pSJAP6XkuZoyCrDc
         9sgaO3MRtKXvPaBXv4oq2rTC/sZWPbIDtfqFEpAf3yJnPeBeEvnuNBEhbELl++AsvED4
         lDwA==
X-Forwarded-Encrypted: i=1; AJvYcCWIi7cJAecUuenAfhLm2f90wIrKfXq+kX6UnBZJ2gst5yqCP22Hvw1QPZ52utysae9u6wtnWH+79yKPY42NQaGYQ2YvYKShH4Q/pVbaBXeSLOPuJ3/h4mZX/SWKnjwymfJ3LIZ47XsR97sfhkYA6QQ0QsUsejmEB0m70eGW9gxGFYJpbrLBIf7hwoQ7z/cK5tLHn8tx+x4T3Mg09B6dFjdKadzS7rnVRP4fkuBf
X-Gm-Message-State: AOJu0YxB0CM2FljKwTXNqtJkASTxcMEyVSAhjYgbCbn176fER9/N6aj7
	ZMoDuJundHbzIPgFY0+b1wVGGgZDVjESUqDOLySpzjtcbxLd+oQ8
X-Google-Smtp-Source: AGHT+IGcYha2L/klvjE95SX1NwjIcrrjx6lhQgqEP8rC4e+/MaAzigVjqy5yAHiaD5OOHjIki9QMLg==
X-Received: by 2002:a17:902:d4d1:b0:1dd:6f1a:2106 with SMTP id o17-20020a170902d4d100b001dd6f1a2106mr6183213plg.0.1710946488296;
        Wed, 20 Mar 2024 07:54:48 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id la11-20020a170902fa0b00b001dc30f13e6asm13719989plb.137.2024.03.20.07.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 07:54:47 -0700 (PDT)
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
Subject: [PATCH v2 05/15] lib min_heap: Add min_heap_init()
Date: Wed, 20 Mar 2024 22:54:07 +0800
Message-Id: <20240320145417.336208-6-visitorckw@gmail.com>
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

Add min_heap_init() for initializing heap with data, nr, and size.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 include/linux/min_heap.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index c3635a7fdb88..ed462f194b88 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -44,6 +44,18 @@ struct min_heap_callbacks {
 	void (*swp)(void *lhs, void *rhs);
 };
 
+/* Initialize a min-heap. */
+static __always_inline
+void __min_heap_init(struct __min_heap *heap, void *data, int size)
+{
+	heap->data = data;
+	heap->nr = 0;
+	heap->size = size;
+}
+
+#define min_heap_init(_heap, _data, _size)	\
+	__min_heap_init(&(_heap)->heap, _data, _size)
+
 /* Sift the element at pos down the heap. */
 static __always_inline
 void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
-- 
2.34.1


