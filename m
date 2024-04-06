Return-Path: <linux-bcache+bounces-370-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 522E789AC31
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 18:49:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E5B928254B
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 16:49:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7B504594C;
	Sat,  6 Apr 2024 16:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UjsoCI/0"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742D04F201;
	Sat,  6 Apr 2024 16:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712422093; cv=none; b=W3kraIrrzAWtPLi4Tpx3wFKHxXEqz7b8E2yA8vWLpXkA7GuCTz8Vf6CydYBXl7GeZENP2BBYpjNOBTwad1v3TLyGfowo+M7LuKh9BhQnSWVhj+nTToW53ncLe3skLMjxn8jNRR515wwROztD/khuHDLEolO143dTjdmT8lR+b5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712422093; c=relaxed/simple;
	bh=9tjNBJoFW/M4N3UyhM3SbO6qdcqZWdxAoa5Ri1G9BtM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Oobgmu8hb9Cgguh8qJLNg9qu91OhchloGR/SPm90cRCcuyMrG6oV2mp1/QSwt2hmidIM6dMtswuB1ZLXTTFR9hSDagpREPXg3VIhu0evqITAmQ3PQ2KUobOzSKCJyarL3VNq51spOUWwGjJk+gDYw2ltrCxKU2Sk3mgmvB6QsIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UjsoCI/0; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2a49986efc0so371119a91.0;
        Sat, 06 Apr 2024 09:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712422092; x=1713026892; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0J0f9A/bhPWWSuBlnbsdq0jeNHFHB9IJoCtvcFhHPOw=;
        b=UjsoCI/0gHLMjML819DguWER5kw5ZuaZHnj9/D4maElnvuqNal3hCIvO4FoMKtTMpq
         yxHsUS7jOvtwhtp34q1vM7aUp+P5JQedZmHwfikSXH7eD6fKSSvZBCV62snn/j6mbjmC
         sXFrEi08Xfr7yKtn69Irc16jgM8ZWP/w8z3h5AVXn/f3EJhkHzcHI14z1BstIo4H+hmi
         18ZZdegVQzYSC43HcbcAsWl4O+9fXF8ycvGTBFGqggz6t9rBhDEQXwpVZyQlauAsA4Ka
         fcWTrxkBqvwG2evFbN/LpwlaJkJ5wOTJaWwmnKC+Rb6BOIlQXed85q6QFU4MxYTByqYm
         BFOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712422092; x=1713026892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0J0f9A/bhPWWSuBlnbsdq0jeNHFHB9IJoCtvcFhHPOw=;
        b=PHktvlxH681GoTk/h+f/hQYyMg+a0j1vhcUvqeLrR7XQnvfG9Z/Tk07UITAXiQyWtB
         kLzH9ZwGHUO7K1OIJavExgG1xVM4Pme4YcDAz9nfm7l/N68KHeqHzH1ELBEZmdn+giJ0
         OLSdXAzHFDio3RUc7FY3+YT98FdjZ9L4thQIFA1FZLuHqfjjKM0MF6OlVL2OcBIVfMyx
         wskzUctBKYSigOGAnzlfWWTcV8o3ohwABjDl78CeekoaLKe2c+cSnmxO7E+KhLZrKXGx
         0MVA94rMLbjVzGneRGFw2DRhx7yYDUyJWcJZ/Ovfu19m+CuaOAQ0sA57OQ0a4LIkJhpS
         xCSw==
X-Forwarded-Encrypted: i=1; AJvYcCW1fPSV9A/9v3Ul2LsRtiyBjEuVeVPBu40Rqx3+8mVI0v0JbURKxkpRlxE6J4+XMMy6RgzNHTACFUC/SEPJ/3k6uUIA5Q2XwTIMRjSiRD2klnIn68l1GcBNO+Gc79UKvvq6i9chj25lW97hbidLrQ+MeQHhdpcY1xWRpHMov++pSAS1bnynsUv+s0pt5zKYMcMC+0i84IcBdKzf20oib1i/FeI4FOM9bv7M0b/t
X-Gm-Message-State: AOJu0YwnhtHhgmjv6PNqXqcW/XGZBp6pEqCVOyV4F084rHkBuTem9sy7
	PX+OKCuQnyoCGFIvjxKfx7reAiETj/7KmrPc7OYPUZY94rPzGnNv
X-Google-Smtp-Source: AGHT+IHNQdh+85x0jYef49alqMxJn+SN5Nch0RwAutvyCaUxP71hmbuD4ujDNqcWCeX9cqd56fRLlQ==
X-Received: by 2002:a17:902:e5c1:b0:1e0:c91b:b950 with SMTP id u1-20020a170902e5c100b001e0c91bb950mr5606643plf.5.1712422091701;
        Sat, 06 Apr 2024 09:48:11 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b001e2b8c91f04sm3665068plb.22.2024.04.06.09.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 09:48:11 -0700 (PDT)
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
Subject: [PATCH v3 06/17] lib min_heap: Add min_heap_peek()
Date: Sun,  7 Apr 2024 00:47:16 +0800
Message-Id: <20240406164727.577914-7-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240406164727.577914-1-visitorckw@gmail.com>
References: <20240406164727.577914-1-visitorckw@gmail.com>
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


