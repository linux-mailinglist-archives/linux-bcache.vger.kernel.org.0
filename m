Return-Path: <linux-bcache+bounces-374-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00A7589AC3E
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 18:50:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 93E03B21F64
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 16:50:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3911535BA;
	Sat,  6 Apr 2024 16:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X3QzukkF"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CDF524A2;
	Sat,  6 Apr 2024 16:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712422112; cv=none; b=ODPsATq/gkGhuPoOANJwdYsMv/Vd1w6R65U38OSo5W2lKmw0OI2MvjbcCsjVtnkFnTOmUx2wj7nkq/E1pJonIhoRVSR1v72hDkADJXMYtpQJN2MicGi+RdSszop44Y5pTvfycpGQ9qGhTHFEBXf38kRKMpvsgRxng5BMFcJpOZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712422112; c=relaxed/simple;
	bh=XnBpK2mdTSiNk8pOWsUbLfl/33hQsrGUFpWaVX3xAZw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lTcsTSNh34k93wxAiv0isiSX1Z1Hskt0jdwRNw76NoLHxCKl4DCh5h84TNc7p3A4QdrCSHwbnYhdsHzGEM33f18TbN6DEBBUx8/qGRdBAnzDUcztnW+NyoGL+y6Dof8nLI0+HzYLZ7yw8N+h9xgBqZoXS0yscBLZhrXr4nnydWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X3QzukkF; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2a2cced7482so744167a91.0;
        Sat, 06 Apr 2024 09:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712422110; x=1713026910; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cVjY2hsEP5GavYAiFg2PbPm4ktH1C0XXWqyfqIoZqfc=;
        b=X3QzukkFLGun4zBmXIQyXj02IOmTLcp5+b6UMPhmkvj/6nn2pCO0Xn5UhbhdwQGS4n
         AXHUQL5gydSRI32RAzgoPpH/VKcJK8Zn4cElHMoAS5+o+mKr/ceMhGVJXc5hpLUpXdML
         5H6XKObTryas8vN4BItlAOeH5JGc7PnUQc1nihQQBcE8+ThqJApWXee8+o38DXLTJyHH
         JVdec2UPoxk0Ucq+AITs8q/VJyqsSZPM+yCBbCTBrqTEMSBxQYHVv5/vzqH8TH3mcDkA
         peBJMhfkySvHPRIhGBc7kegJoSea+S4U2g1JXj6qCmNeoAcit3dnTJVqyefSJ0gemhbA
         GDsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712422110; x=1713026910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cVjY2hsEP5GavYAiFg2PbPm4ktH1C0XXWqyfqIoZqfc=;
        b=pArc1sIympHP7HBZzig60oU7pOi/F+/5nFGVpVPo3xSDtqNLjURL25rfqkui6kF1aT
         /lK0SjWU6xroB006I5Dedfe8WLVxxZUN/O4r8u9gUq1XL78jsjeddJbqSutZozXK19qJ
         B0C1S7+XV+GeIbJ74LT9DPAS48aaahmkwgdGvv4OaD4SGFxrsasSBPBCCh6hrnPuvVJw
         WTWqSzBM0Q0bKxBxOZFeR1IjVnl7y+bz1EGSbQ9/Kntx+uDqSDyTcJ4T0SCNbxyK9eH2
         bE0Bcy/0d8g8hk1exLYBQL16QE+JAy4E4rwGpTzJ1bL7qEGPCi10oQoRmZ08ouqMwTBQ
         miKw==
X-Forwarded-Encrypted: i=1; AJvYcCXAh1s4SqJRdEqOwbwWBmDRDBed+1BNvLfdw74muRrUR1ecvtrYnZG4G4JHFpZ8tdn7tAdMtZdhxpLFgwWJX30gjKn6sF/8kvXHw2OkloGGWdnlJUGPApZObdNXqj9adOMf5aFSapM8d3sMCIk8l7sgs+yirDRyriz6lmrp517gV98NaLZl66s5xyopD4c+AsP1SlgQFg1L6K43kO30/RuHGW2xlLJdLq1Xs+KB
X-Gm-Message-State: AOJu0YxGQnCAx+O4tkdhIpK2zpY/lTpjcGe+u0vrj+SQxhBVkGZRRaWq
	vgAtgDsXa1TtQoBSCzJPMz5+fr50Qr9Gikll9c4Ve5hWFPJ/V8J0
X-Google-Smtp-Source: AGHT+IEcyJ578ps9gq2LX604ohNhbPbzLtuv6Y3D4F0mKoW9u6iZ8nNcsVBv7jisetv3NOIFQl16OA==
X-Received: by 2002:a17:902:f68e:b0:1dd:a3d6:3aff with SMTP id l14-20020a170902f68e00b001dda3d63affmr5471402plg.3.1712422109909;
        Sat, 06 Apr 2024 09:48:29 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b001e2b8c91f04sm3665068plb.22.2024.04.06.09.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 09:48:29 -0700 (PDT)
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
Subject: [PATCH v3 10/17] lib min_heap: Add min_heap_del()
Date: Sun,  7 Apr 2024 00:47:20 +0800
Message-Id: <20240406164727.577914-11-visitorckw@gmail.com>
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

Add min_heap_del() to delete the element at index 'idx' in the heap.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
Changes in v3:
- Fix a bug where we should copy the last element to
  'data + idx * element_size' instead of 'data'.

 include/linux/min_heap.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 201f59cb3558..2aee024ca883 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -212,4 +212,28 @@ void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 #define min_heap_push(_heap, _element, _func, _args)	\
 	__min_heap_push((min_heap_char *)_heap, _element, __minheap_obj_size(_heap), _func, _args)
 
+/* Remove ith element from the heap, O(log2(nr)). */
+static __always_inline
+bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
+		const struct min_heap_callbacks *func, void *args)
+{
+	void *data = heap->data;
+
+	if (WARN_ONCE(heap->nr <= 0, "Popping an empty heap"))
+		return false;
+
+	/* Place last element at the root (position 0) and then sift down. */
+	heap->nr--;
+	if (idx == heap->nr)
+		return true;
+	memcpy(data + (idx * elem_size), data + (heap->nr * elem_size), elem_size);
+	__min_heap_sift_up(heap, elem_size, idx, func, args);
+	__min_heapify(heap, idx, elem_size, func, args);
+
+	return true;
+}
+
+#define min_heap_del(_heap, _idx, _func, _args)	\
+	__min_heap_del((min_heap_char *)_heap, __minheap_obj_size(_heap), _idx, _func, _args)
+
 #endif /* _LINUX_MIN_HEAP_H */
-- 
2.34.1


