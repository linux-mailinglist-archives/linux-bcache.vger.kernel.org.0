Return-Path: <linux-bcache+bounces-479-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E51548CE7F9
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 17:32:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7AE56B22953
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 15:32:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18209130A5D;
	Fri, 24 May 2024 15:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BxoOblvg"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70BD12DDAB;
	Fri, 24 May 2024 15:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564639; cv=none; b=Hb6LGbmi0VLJgKlvrPO9nuk3dkREOrNVHyj2a46I9IA8aTxdDSV/6ziCluEV8e7TTR10zCQa8Zavws/fI8yv3ZRMGw0hnjJNbggnsyUwJMP2C773Fy29i7dJXBg7jaZoNx9opaPLBmhxuL9CV34U6cd9fazOAlFm3s0vsgF30nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564639; c=relaxed/simple;
	bh=CtmjnUhCovWSsS0eLtHZkP1gRg/+o2/rih6xjavgouM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tV/WnlX5EkpCIhbl5/MzGX8c5o9DwUijFJbU+c1wbMfbNFrPCk6doiZly7S97hnrHiemNu2uY7Pz6hG29MRnfzj4pdIxxmDro/GxArJ3JpAwdy/OqaZXZaWamal3Ikh8zCoTbFft8b8mo4vpIBTVWg7tKARLPUAqWCJ2l/Vxbjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BxoOblvg; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2bf5baa5b76so103284a91.0;
        Fri, 24 May 2024 08:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716564637; x=1717169437; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cYJrwbsUSMlgZtHUd20UudtqnzPzA+Nu3Je7Gypyz6k=;
        b=BxoOblvgWca93mml1Z8752CixmUuvnRuoFqphVkZnqlGWli8wcNzz+S5faEHTxT/Zw
         GJxFGG1vInrZgWZYJCewA1Ph3/iSpoaRsFYoi70mx5rvNC7mpqvcAEoiy6YJV+mFtKOm
         TvymQYjRpOqXZ+7UafNCc9TtOUuO8jQIP7XWjZj2QkM6ZiFMzM/I7jWPuaJOZbRZLibW
         kyO4oErn2M1aW/+xzx/+tqNurFpff1Pnhs9KKFWRM6IqAqlcKISpfi4BEnFFBcfjqnRk
         MDQIlzikp59nqpmrtP44i4cTh54gtbOCFmLQFFSpUuw4buTkF/o2zsQ0K79HqKfriZN2
         L9FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716564637; x=1717169437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cYJrwbsUSMlgZtHUd20UudtqnzPzA+Nu3Je7Gypyz6k=;
        b=N+5Jal0CEyCI83dVF2MR+wu85DH9pznsbWhL0MiyuTtSFDxG6Idg/KeMQY4vBNHTPE
         l8bJ5ACqZXWiftkpWHIjGVWl6s7J9EEwvIsdxVUTQhMoRQvjW9AXuP4kOYTwJUTa30G2
         Awy+XvMJNqOGQdrJ9S5xDpfNh9uo9UHLgkEPMwjlQVidPOUSg3OpOgnOd1DKz3VTMMKD
         zAWOo6VGkMWrmZG2McmqPW/ayVmlMk+1q2oDOvw6cBkKcV/jY1/gJR2kQKMW8TNF4APW
         FmfOi2fmJzFo03ier9QUi+swXiZ3cTgYX+/YCGFP+d1+UG+ltqvuempWxYovV2xosOdF
         OeVg==
X-Forwarded-Encrypted: i=1; AJvYcCXLZPXhCH5T9fLBNSJlAFscAp/b7XJ4eQ/2qaiNZRb1kPVnY3ty+7vYWodmgOIXoSmoj3b4UwYjYC0ONbJWE4qUc6z1bS/8KOBV8MeDMvHutyUoDYRa3w3s5V5OjCVBbpihXFhNuIuV3UIqrQRJmQaeTCCSHAxbOyvxyPyy9zblQcSBoZxhb2u1Esci+aJCeKiQdOE5lms6H1/mQhyNZ5azqZ6Q/cddcP3Lf/2r
X-Gm-Message-State: AOJu0Yxh2rAQ45AD7DfGCVgGopxLzrPOe2zLP9enaSBg2QZuHZs0wsaG
	SepotaUxRvjkiwfozhmByMCQHUvWyz9W9gyWSY2LjLV4ZgEXXk0G
X-Google-Smtp-Source: AGHT+IHoYwOCUaxc1eEkPVdFwpRkMAzYQsOk0wv11TzpiDNFWzl8TbRA7I/ssjXw7Wzjhb+pC2mgVw==
X-Received: by 2002:a17:90b:2286:b0:2bd:e806:49e4 with SMTP id 98e67ed59e1d1-2bf5f511c5amr2497068a91.4.1716564636772;
        Fri, 24 May 2024 08:30:36 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f50d294sm1525556a91.20.2024.05.24.08.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 08:30:36 -0700 (PDT)
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
Subject: [PATCH v6 06/16] lib min_heap: Add min_heap_peek()
Date: Fri, 24 May 2024 23:29:48 +0800
Message-Id: <20240524152958.919343-7-visitorckw@gmail.com>
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

Add min_heap_peek() function to retrieve a pointer to the smallest
element. The pointer is cast to the appropriate type of heap elements.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index b384a4ea2afa..d9c4ae7ad0cc 100644
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


