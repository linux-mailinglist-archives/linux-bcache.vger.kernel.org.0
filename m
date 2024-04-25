Return-Path: <linux-bcache+bounces-410-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21D2F8B23D3
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 16:21:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3950E1C219E3
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 14:21:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2533414D707;
	Thu, 25 Apr 2024 14:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TZ5RK2Iq"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C6514D6FF;
	Thu, 25 Apr 2024 14:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714054740; cv=none; b=G9cHScgwHVoNtrfjtVpV7qgUsxWN9dMl6YQ06+0GDRpNWDabGPiFfQIczmc9202XKdgKvYXnofjyKWeChFZf2WyyT1BxdWOy0K1mFKbaE46YtMNNUJlyFNVZjuqBHQfp1J1tUXtt2b0V7YIZ6SQTslzidWWCNDS2JvmiN4/Ls1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714054740; c=relaxed/simple;
	bh=b5Qix40IYcfncBwAyPvMRSLFUIF05YVbAb9l7ZjOFyY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z0fcDvvDGcXKgM1tJJNvUIJOutct38Q0j06EuZvD4mPb0jy5YjylgF0fJLRENmVOEFRKeNK6mafHZCarkto6aZ4hSLm2P9ZR4m3KSJEYGCSe13lB5GoYF4yTV/XJqNNP8aGBrsmJ9+Yl0Cwz7gKWT3VU5A8mVHQ04RQdOL0ExxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TZ5RK2Iq; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6f0556080a0so52321b3a.2;
        Thu, 25 Apr 2024 07:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714054738; x=1714659538; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BrRuPk05kgYWrNF6DoThYuAvcZ8CXsiyshk2gqZWuIc=;
        b=TZ5RK2IqGjQX4xM2GZFQwzN4Nh3AfrWz6BRHAOYsFqJ7I7Q0gifpjpZbS+6uV+kFu0
         vcKGdGfj4FIkD7mBjlvdmEdyMo3UWz98ymqbeczwyqA/tmzeoJqzyTFdpUYjLQY/jDyS
         PE1CvtAVz1ujV4AvGFUHzYqM3krwV/zfwa1UaogbzeZdWbFt0Fs9ByH1fryrEeGVSXEt
         nsjIT1qxnLRZc/3vahcho+0kFfaakI+TZo7qjp0lieHrhYBOv4t0d7VXkBPvnVNat/4N
         zj9+AVtmMbc7tOYegd31C5D+ieYwrpXzFbXgqVJKJx1IIkFxIUD4jS+KDyPN4xldXIyD
         M8jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714054738; x=1714659538;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BrRuPk05kgYWrNF6DoThYuAvcZ8CXsiyshk2gqZWuIc=;
        b=U5voa94Agee2jy5IWSJnkxWGjJhMEx1II+MWI3eQTL4V4EF0XU6BBARemZ6tQvkZEz
         3olhifEBCMPT8siVFdHDopAzSwSrqfdsbrX1iFedOoYT2cgv3w+ASzdxC60oqVj7+qA0
         05yelDjQbtByiH4MtlRnwBTHMMYajHFkXREO9fKTXy7uE9rXsMddScs6i/ESLLy6REHj
         AQwjsizEk8ySebNgujG3xV1scAdYQSQHAqz/idUmeZ/XxQV2pS9HEoWrtXviJ6zU5HGb
         sUiHfG90EVfAesAFJjjJBz2o1u6ZcrgAJgQUpMB53XggUOLw+BQ5yJX5UW/LPzl16ztd
         cBlA==
X-Forwarded-Encrypted: i=1; AJvYcCV/zb603JWZaLSTxvbtpAYOU25eEUmaFkTi5uubk51lMr4i+nSS2AMe5dbEzCQGOSn7mZcQJ79nGRwdR7lHp6GQsxFqJjIEEz8wZbevtdB5UZMe+ERBX+PjWk+TFhMqc8B47edgzAzSmyU32t4yMLbJOztq8vxvstj1qXpSC61+dWu9b7K/ZTiJxoMqG3PjsrbaCR+Q7tF1PazNJwhB0vVVNKkT1Yf8/qoU5xgr
X-Gm-Message-State: AOJu0Yzjs8jZIEzf0ipIQcj2FHyGdfEtiwbzC8/bw0IJHZBriUWr5g1R
	TNEamY8GE1xShVknzUV46ZUGQNZcq09j/Te5g5qxfxqsTnF8ItqQ
X-Google-Smtp-Source: AGHT+IGXAZ+ZP5Nps5IYlgwSWGtymGMbytP6tQx4Ugz1Rte5D4xcYm+mR/lUyzNPTJOSXRVvfLBAGA==
X-Received: by 2002:a05:6a00:99a:b0:6ed:cc50:36cd with SMTP id u26-20020a056a00099a00b006edcc5036cdmr6925931pfg.2.1714054737797;
        Thu, 25 Apr 2024 07:18:57 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id go20-20020a056a003b1400b006e6233563cesm13162397pfb.218.2024.04.25.07.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 07:18:57 -0700 (PDT)
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
Subject: [PATCH v4 05/16] lib min_heap: Add min_heap_init()
Date: Thu, 25 Apr 2024 22:18:15 +0800
Message-Id: <20240425141826.840077-6-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240425141826.840077-1-visitorckw@gmail.com>
References: <20240425141826.840077-1-visitorckw@gmail.com>
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


