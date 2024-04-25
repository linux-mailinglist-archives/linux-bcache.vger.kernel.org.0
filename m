Return-Path: <linux-bcache+bounces-414-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B0C98B23DE
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 16:22:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0354A285CDF
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 14:22:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3739214F10D;
	Thu, 25 Apr 2024 14:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dJrIm4Rb"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C577514EC6D;
	Thu, 25 Apr 2024 14:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714054758; cv=none; b=l7m1pZCYGhp5SiBlictCoKgQoia6mh4qAJqbe76CtAn6mVLiP7ROYX/0eVs9nXu3KHXjcqRB4R0P0J7/1ugLxvyNlEu5FeIC8UAWRfHX6xwE8ReP2/KZ1VaJjNGRd39cWO6S7k4wKNuRmAXf6dbquqIlFZoz3zM6F2RvG4gLACI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714054758; c=relaxed/simple;
	bh=4BdmZ42eGYqkHh7DqsaJJxnA5TQhEtJiFDSi25byrow=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R3wDVdDbsdjUQS73glUsc2nK7WR8afCxh4cvPxnt9wLPVIM2LK01N0MYa5FfudezzWT+MjZlTiEzOc8+WnOhUVS58KYsvX1aOeLinmGpzt/KjV2DuGmhv9SWjWvgxKy/PJCq5hiJEZyUby06i1xyL9FY/myRkYoZ2g1D4SCNeqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dJrIm4Rb; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6f055602a7aso61025b3a.2;
        Thu, 25 Apr 2024 07:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714054756; x=1714659556; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zYBPuzAS4rfB8ctDvp2HjPAauLmNAXnRoi+vJxjVmnw=;
        b=dJrIm4Rbp2MsCnm3P4uO8Trt4y+/HyVxf76Tg0Pu3D2G/4K2xxXqntI+iSnOsbEXlV
         3k/26TTa4ftjDl2bTCEyFRcaJbODhK1DARU5zPpAsWbQVPaQcopY2y8A3j2OW3VG3loc
         nG1U7kzwypr5PxbWE40BFBGQ8gWdDNV9C4epCFqLehG710FIW1G7EBxzxK2KazfvdNU/
         CTXYFWUUIooA55D5mkoPTl7FlJP3+cWKSa3G22AWgWRL9q2Is7d/kkSJz6xP0t+Zms5y
         6l18VOK2AnqBmkIeBpN0Du+F8mOvYW6V9FmurQel6NLlFRaghoeWC1X0BeXxqMh6WEM6
         ubLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714054756; x=1714659556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zYBPuzAS4rfB8ctDvp2HjPAauLmNAXnRoi+vJxjVmnw=;
        b=YtrCKeoq6dyxdFTYNPTqkzlBQh8NaH/XvvLen2cbTAa2rchA0qe+7wqSaEiC/pwm8B
         OfDYbUhyzoYm8xi4eEp3S+MekgSt58Q1cZgcGQ6DlGkX3FqA4/jtBndJOUOuSaBeWpcz
         tA9jKPqkErLQOVx8dRj6gMyz3xNySP3igu52yEbsMmFaYyrJ7JexMFtvQDd4EyYcpvBo
         eWVC1I1JOxs8YLRxpTZxk+Qpe3OEOtqJG5B53gE+yBYKO2ickOSCnPmNvfW82IOufGbd
         5VCX54dNbFO3ikq1bwuz+NRihn2TdRhuJaX7g7WR94vn+IeNuQ04uGUrp9c4g39MmJ2m
         8lDQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/xGNS+1Pzlfj+RAVReLOwdQ500xrymY7BPFL6M1LQ/qs5BObN9GTJU5i2Dv32VIveEDXGGHSVPppW2NU9LlM6JKUGuYFbixizvUcTCTpKw3DBSW3L22xFW+uV6YpkbqfTzDFpm/AfWvjE9ySsu00l6lO1I/C88qOEE1yrnMBlvDclqr37qnSwJI8z5Wuzns53P9+VJMZGCdpGdaSH2AiIzyd+/HouhMXU/9SM
X-Gm-Message-State: AOJu0Yzi12XNUnRohA+lxiuyGMnLc9YVy3Rk5fDRL4gS1YASP5wdX9at
	3ubHurXO7aP2lEfQCQSMWi794CeHkC2dftGTpNmwUKqZ4CALXVkrGCanUkGI
X-Google-Smtp-Source: AGHT+IHCs2mP2PBWPDpj/ZpcI0qR5WUF5wl8AmiCcNh9Yd7tWrXz9C1cdR5glM/73f83lz2U/XWXhQ==
X-Received: by 2002:a05:6a20:a3a0:b0:1ad:cdc1:a418 with SMTP id w32-20020a056a20a3a000b001adcdc1a418mr876921pzk.5.1714054756137;
        Thu, 25 Apr 2024 07:19:16 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id go20-20020a056a003b1400b006e6233563cesm13162397pfb.218.2024.04.25.07.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 07:19:15 -0700 (PDT)
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
Subject: [PATCH v4 09/16] lib min_heap: Add min_heap_sift_up()
Date: Thu, 25 Apr 2024 22:18:19 +0800
Message-Id: <20240425141826.840077-10-visitorckw@gmail.com>
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

Add min_heap_sift_up() to sift up the element at index 'idx' in the
heap.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 9391f7cc9da9..201f59cb3558 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -111,6 +111,26 @@ void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
 #define min_heapify(_heap, _pos, _func, _args)	\
 	__min_heapify((min_heap_char *)_heap, _pos, __minheap_obj_size(_heap), _func, _args)
 
+/* Sift up ith element from the heap, O(log2(nr)). */
+static __always_inline
+void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
+		const struct min_heap_callbacks *func, void *args)
+{
+	void *data = heap->data;
+	size_t parent;
+
+	while (idx) {
+		parent = (idx - 1) / 2;
+		if (func->less(data + parent * elem_size, data + idx * elem_size, args))
+			break;
+		func->swp(data + parent * elem_size, data + idx * elem_size, args);
+		idx = parent;
+	}
+}
+
+#define min_heap_sift_up(_heap, _idx, _func, _args)	\
+	__min_heap_sift_up((min_heap_char *)_heap, __minheap_obj_size(_heap), _idx, _func, _args)
+
 /* Floyd's approach to heapification that is O(nr). */
 static __always_inline
 void __min_heapify_all(min_heap_char *heap, size_t elem_size,
-- 
2.34.1


