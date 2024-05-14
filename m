Return-Path: <linux-bcache+bounces-447-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 29C7C8C4DF6
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 10:49:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 69CD9B22E4B
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 08:49:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 050D738DE1;
	Tue, 14 May 2024 08:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iD2qLwAa"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2F023748;
	Tue, 14 May 2024 08:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676479; cv=none; b=YhVM6gZCxE1Qj2EL6MfVLhxccPj+qCLMszSOz6t4Gt7eZlNYG2/gGOw9G7Y2RCdvBjzc9wkmgZkWUPhU1bFbSq/6cGRpLSgIhwsywLWtJU2HPlleWfAfnDLXG+EWhWlka/TmXzeLGdXAPIZX1tnS4IScPydCzkRYcarjO0C04S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676479; c=relaxed/simple;
	bh=b5Qix40IYcfncBwAyPvMRSLFUIF05YVbAb9l7ZjOFyY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tFMZj2+iLzFvvsioj9nMiDFmfMiZq7fV1+FAZRj4ql9TG75NgBIMaCDI7Nst6K9yy9rnaKwG8acm+CZzqLo5WZPoEUbw77s6m3nD0lUSJxzcrt/MjInuaR/bSO37Oyic24QUoYnGyD2qeEEUx7/Rm23H3vMvvSuiDPZSdqmFcmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iD2qLwAa; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-64f12fc9661so65491a12.3;
        Tue, 14 May 2024 01:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676478; x=1716281278; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BrRuPk05kgYWrNF6DoThYuAvcZ8CXsiyshk2gqZWuIc=;
        b=iD2qLwAa3ERhvW+0J9cnaNLEQFHCOn7psY/Pl0tpkGb7Ak5ytJ5VCmxuzMiPHiWIBA
         ZpH0QxL+hU+UTUjUi7sN2yWCY+x+7E9ep42tYZ+I3J4VAgiqKbHcQoubhqwWa3Q109af
         8MMByEJcaAV14R/2gRppQwH8qBwVN3+xPmNf3yJd43sj/O3A2qMYEpSoJOzx9hGtPzPY
         RYV41OPEiGF0BOwFO5SgutsS8Sgfg61s5OHFqh3usHz1r7y3FxA27LT2eYZMTs2+BsY2
         NvyT29PXgdM4OYPX20hVmnIp5c8CADRZs+DaAK/FpuTe7qQ7F51LKFXwxx1L3vIfYFmF
         3biw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676478; x=1716281278;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BrRuPk05kgYWrNF6DoThYuAvcZ8CXsiyshk2gqZWuIc=;
        b=gUQ7fPUSSn50Rs48AUHF4vy8jZjIxqlqG7fv0qjgw1GhDJFQyKuKJSTZbIEoYIp0Hi
         RZY5FV5ctpaAk58K9w3A9yZ5vkmO+HZHBATKjx1j0yzNLwpEMH3Xp4stK5Rl0blcYWWn
         r1k4g7fz9APo18inunU0dNuC2xOX1QLnYUnl2qag4gjr3mcwArSOTx/NP/e60/h3TYEa
         xmS6Y4sYOBT4941dH2c2pnV3fB2DdksvqOdNwru40+v/qozQvi3O758k7Db2zUhvprt+
         e8kgEvrN2VnkMlEEeCEI54LbWMzh2P2rWR4dFjoEC7JN0AXKzDQgNh7cJzsSuKTArfc4
         ZU2Q==
X-Forwarded-Encrypted: i=1; AJvYcCVUqeke80y/Jj8ePaSO7VC6HgdddIqDdxepybPoDUfH8LhBLDCZ9OIasD7vO3R6YxNuB7dA8LLTQetKBP87FF6KspzVeWBNlj0zfhChAFuREc8Qb00i4eNxd+DmgIbmEMuNSTF6A/O/cStpJM9uL9Aodff98+KuCddPw0pOJMiCUDQcJEecd48pEXu9j3bPpAfXbASCITNyuZGWECjsqeoQqkyvSjK+QpY74sKA
X-Gm-Message-State: AOJu0YxiiKZl/vDx2blZMp2jkLcIKYZICi719XYD4YCLoAFwCskg//5Y
	yjUi6571q/fWoeVMMY4x/t1gvhFFBf6rsLY+1K/c7DQF6Qe0PZNO
X-Google-Smtp-Source: AGHT+IFna34DmfsGRr4HQsSkrsjPDrFZM+b+BeRj2Nqh3t73q4AJ1ts++l6Quzf18v9kLyQZ1vDgLg==
X-Received: by 2002:a05:6a21:8191:b0:1af:d51a:1b9d with SMTP id adf61e73a8af0-1afde09ec47mr12142159637.1.1715676478018;
        Tue, 14 May 2024 01:47:58 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b6711660fdsm9195597a91.16.2024.05.14.01.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:47:57 -0700 (PDT)
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
Subject: [RESEND PATCH v5 05/16] lib min_heap: Add min_heap_init()
Date: Tue, 14 May 2024 16:47:13 +0800
Message-Id: <20240514084724.557100-6-visitorckw@gmail.com>
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

Add min_heap_init() for initializing heap with data, nr, and size.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
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


