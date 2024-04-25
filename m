Return-Path: <linux-bcache+bounces-411-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CDE08B23D6
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 16:21:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 146E82851A0
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 14:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D60B14E2CA;
	Thu, 25 Apr 2024 14:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nl3eAChe"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278B814E2D2;
	Thu, 25 Apr 2024 14:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714054744; cv=none; b=YABO8QgALBUoquyJwHh0uRYrV0GauhkE5+EEV6GUPVaD9cyoYGUkNOKT59ucmYf9pLVgKkAJyR+Gf1GtgQgwuzdFsADj51fI4gf7uoJQKjmMd2xA2Bq8zylL77Kx1+fcWRUiRhda0XNqHmTjUJ7iH2BjE/fQ1exj5vb6/l6j5y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714054744; c=relaxed/simple;
	bh=9tjNBJoFW/M4N3UyhM3SbO6qdcqZWdxAoa5Ri1G9BtM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=adFqn0/IrX1xklOWzagA/SSS7pYn2hwOZf38lJn8fjg2/i+G+XmGBf0P2qY0rCjfDYmIJI/0OwUKTYprYfVwolGBhgmjl8M6qD4+w6OhlM0sGqG/St1lj1YoltFpnVeKWGFspQMshi5o2QgaIM/LyMjX8hkC0sjzBJwSM5kS2j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nl3eAChe; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1e825c89532so163495ad.2;
        Thu, 25 Apr 2024 07:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714054742; x=1714659542; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0J0f9A/bhPWWSuBlnbsdq0jeNHFHB9IJoCtvcFhHPOw=;
        b=nl3eAChe4R2s4eRxYoU6+gkuTEcVMxtF1kkL1wiUHBZRjWmTP8rq2oTwB4ypSlatXs
         L+T4KdwSFLAcaOYDyOwq2G3O1DIC4a1TjAspUY96KlIZWyZ+XgBHOlPTAWmtvsJ9i4Tm
         rEhT3zl3TXnQblk0oPMVYJ7lzXAOyoWsmZj6bwTpLVVKaMM2BFCQi5aD0OpSJjG4Pw9f
         EI8bUSkjrpg++Rx7rGugaBYvo/6RWhKbtcXzZ//OF6oPIeTDD3MZN+1aGyzV+WpgiHRI
         ZLl4AhkFhiOMKrTiJx+xM3t15QjzDb/AruF+jBs691TjPduEkFzWR7l2MmBUfUPrXlmP
         UKFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714054742; x=1714659542;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0J0f9A/bhPWWSuBlnbsdq0jeNHFHB9IJoCtvcFhHPOw=;
        b=tgxyB6ooTMkihaldLIbr0ZxZl62FEf0JDQwHhINEFiVtn/B9SeU4Mp0CTrejX/JJDi
         iCJ18dACbj2VHeyyZgczHp9F/5TVV2XxjTFzcNIBPyQytbvQbPl86UU73/ixC9cesF/x
         uK0TOhDirxzsjGie8JgU4f5crUlEx8EM4zJmO+Rqni1eAuqFnjzos2MGM87tOHEPSWZY
         slSMBYzHJ3uORt172w3YsDR1YSDBV7oLh8auHuEI3wRhfQsUOBVDVfC7iDcdSB6SAIXw
         17Pw+kdxBV5zUH8EtOFqLCrljLtddaYWh0ip/V3ao3nhZwzvlb4QQbGiPGmsRed9+lEj
         uJ6g==
X-Forwarded-Encrypted: i=1; AJvYcCV09xKwtON05ZxTWqdOOmU687n+Fce9/fWJEakfS+gsQ+FBu0F4IbPMIszy9SrHkiwTQ1aV+qYDQRCe7pP2dBFIBsTIvdQAz1UTaxGGWevcnuBaERWz6BrrJpFVgJbwL3nGhdMvGDCq4pQzjVkYm2gPvP5KObqSw76N9lIh3eCpfWJl+onzEZVGSJwfMRFPhKbPl0kZ4+Zl5ajsdyfWMeuEm7u2nEwRCcScaESZ
X-Gm-Message-State: AOJu0Yy0sTVZ567CWw+/Swx7Ia4h9PcLoR8DasIb8fUoYMmj9ldJ506E
	h7L+uaQFPN2subo7jD+PHlMqIxX1ziLUX7eEt1xFOGuILa560T1c
X-Google-Smtp-Source: AGHT+IFDcj8+z0jNjqj12s9jll0rXA6fAY20FeZPShgwWxxNRxyTRdtb76w4a8W5EzTpPoYKO1G3kw==
X-Received: by 2002:a05:6a20:86a1:b0:1ae:3504:c5e with SMTP id k33-20020a056a2086a100b001ae35040c5emr472761pze.4.1714054742438;
        Thu, 25 Apr 2024 07:19:02 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id go20-20020a056a003b1400b006e6233563cesm13162397pfb.218.2024.04.25.07.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 07:19:01 -0700 (PDT)
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
Subject: [PATCH v4 06/16] lib min_heap: Add min_heap_peek()
Date: Thu, 25 Apr 2024 22:18:16 +0800
Message-Id: <20240425141826.840077-7-visitorckw@gmail.com>
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


