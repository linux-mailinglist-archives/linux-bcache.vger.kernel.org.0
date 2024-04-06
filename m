Return-Path: <linux-bcache+bounces-373-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A03A89AC3A
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 18:50:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F3E5CB21E37
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 16:50:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56675524BC;
	Sat,  6 Apr 2024 16:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jziC5GiP"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D1B524A2;
	Sat,  6 Apr 2024 16:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712422107; cv=none; b=thbE6sFKLlZbUbVg3f3xYCcpSuZKqtA5bHSVnmBAZmdD3RaBSH9odYUvKmfZbuesoUYbU+olTGM9brULAX7RuwSQFNjAWuGR3ImMRfjyoFn1Nax9Rp7PCIv/HdhOYwkOzz3S0+4ko5wWzg26wJWGGPQEFhC135bosaOxeUYtR5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712422107; c=relaxed/simple;
	bh=jqo3ElORw266U/MGKhXJRdr9MiE1XqbwT/kp886Mo2s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KEpZdFiMymOI9u8SFTvfHKOFhaz4m4D+FZ9PRQJ2JLnXwXI5aP/AhN9PdDEx70Z6EKBEKgFfqrlITZjAI4RHK5ge8jr1u2iMWESEUFISa1vPLRM5VRR9T97KmfN/n3mFFBRrZweVRV0t1H6RyCV1LJIHKF/s2jVBJCPM8F5/QO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jziC5GiP; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1e2a307902cso4972795ad.1;
        Sat, 06 Apr 2024 09:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712422105; x=1713026905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kzwb7BmcuGuHI8BmCOZ60hhRkppr+jH4uHUv532UMj4=;
        b=jziC5GiPHi1U5CoEPSkA18Zxiq0K8BSW5q9DzOKP/pEIgFHr+p/+RbF9A/tIV9Q9Yo
         Q3IPNHTzxfwkXMfRkzbYN3c2q+LcADonvBtlmUepKO4Ow/Lhj+yGIbhd2XKdBdCsi18A
         nVXC9Sck3PlObgMv7qDsbpi7ZygRmz/e/l/m0DL/JU1JLIMbDILKTmdmCAHGXlk3I0zq
         T0Iw8yk2/EZl46P3tuAfbujnzXj9ty+aa6WRuIt9J+th8TdunQgPtyCp/Zx+4ZGB75fQ
         1SyjCIRH18Q4OZr112IUe9l4Oy46YWbo6Nb3hnh2zXIgin1x7IEdu27bdy7bfkqM6dtI
         gDHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712422105; x=1713026905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kzwb7BmcuGuHI8BmCOZ60hhRkppr+jH4uHUv532UMj4=;
        b=CkUO4NiYWq0eP3WQF1jNEGPkXbFNZ6THKYEm25fuOzX7S+t/CWSyEcifwL684QHcCP
         +VLsL1d9CZoCxIUQYWeTomSGpwHjhau9NvKgo+7YYXuSTMu5Fxw/LfW01EXQOQ98lH5H
         5N0bwM0HQ0sjK8khJAafya0cvItaf1WzltKxUzwjv426wCjo+rFTeCR+eCOVFsSMokA3
         IhQdF9uc3ViAMmfSypQrcxCZ4OpTQDMy7pWAHnSYmcVmOaI2hpG+eExpNt3C/hNnsWR2
         o5xPR/Li9RZbYxLmk+QMgwuzpwFhP83dCF6r+3XIwKUbsynO+baoCIxsWd214XIkc8cq
         VOUg==
X-Forwarded-Encrypted: i=1; AJvYcCVKURsezSwg1aXOiH1j3MPU1uZSBrIkKx3pzVvRZ4TV+CM5eeO/JeyMVB7PjKOffJ740pZIQUF5AxYObCKAMfN2Klk99LKxUNgFSSXj7L1xA18tA8C5HavFPUW6/wA7e5GarotdaagA9MfFHF67Hc871Z57DMIjVrftd+DNGWFb412SLMc4/Fjx2QHtrx3XN8EG/XcyhYZPXqcGcjVs5pk09kf3Vx13c5b6SMFV
X-Gm-Message-State: AOJu0YxXfKwFGToVNhQI15a3QFPUauGyIsmKMVXI81lPGCaGIh3C0kXS
	MynAuMXlzToMv/aoXA/7ZLUzrSC5Wnap2Dr6OomwZu2wyBKaFyen
X-Google-Smtp-Source: AGHT+IECRUIgpwBjY9GlZnxntOAI/Gdn79r75bpaZK5qjV3HmrL7hNrxJ0ZSi2AQZhcLSinS0naEIQ==
X-Received: by 2002:a17:903:22c5:b0:1e3:e08e:d812 with SMTP id y5-20020a17090322c500b001e3e08ed812mr1765450plg.5.1712422105286;
        Sat, 06 Apr 2024 09:48:25 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b001e2b8c91f04sm3665068plb.22.2024.04.06.09.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 09:48:24 -0700 (PDT)
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
Subject: [PATCH v3 09/17] lib min_heap: Add min_heap_sift_up()
Date: Sun,  7 Apr 2024 00:47:19 +0800
Message-Id: <20240406164727.577914-10-visitorckw@gmail.com>
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

Add min_heap_sift_up() to sift up the element at index 'idx' in the
heap.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
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


