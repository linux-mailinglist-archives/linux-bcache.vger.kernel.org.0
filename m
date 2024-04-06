Return-Path: <linux-bcache+bounces-375-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C5EA189AC40
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 18:50:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E97781C210F0
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 16:50:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 828AB5380F;
	Sat,  6 Apr 2024 16:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YrxlRi9L"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CDC537E4;
	Sat,  6 Apr 2024 16:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712422116; cv=none; b=BeRTqUOR2fdy5F6rEkW6n0wI563cpkrD5Mf6HTTbpNSadxpk1Wvaxg6RE7MnJG800RrQq3d9kw4vERpBIe5qBYPMDUQbVLStr3uoJZahB4xeUqAjBz1c5RzuWidz09wyog2NO46jdsRgh6ZY0GuBhS6Yy2NlW//kBxi63sYDaKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712422116; c=relaxed/simple;
	bh=P6OD1w/ffLuZA93dq3GjSiXVcdPqNBMmEYdRRZgPTYU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=c5ZEcDLI+ymZCFzP/MmZL1GN2U1dAw8enwxxudTsKnoliBXHlu5DqBOkRqK6d6PZdrjcD0wwChT3C/PpT3JHQ5kRl+UmZY5Lheb3foprYPHcHfGeGyQOlSZiR78W+RhzvmqPH4MYLDYKezsrTxCBHGmVaPCVGEIQWVJ5Pg8Y3Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YrxlRi9L; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1e2ae3a3f66so5428905ad.0;
        Sat, 06 Apr 2024 09:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712422114; x=1713026914; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3v/S/N1hN0Q2k246igfeXq323YyFr+V6BvOJzuDRd68=;
        b=YrxlRi9LNfwm4aUasgZjBJRRCHLYnyiB+ltRyy2PCmAn2WYJ9IcmLIF6r/GEUb22I5
         QwK8FwDscVC5CHS8L05KM5Tb8HR2TGCvvZmCQwjte0C0cVvIzTePBmSib/PZNbd5ulyJ
         BFouW81DsVq9vaRmBn7v0uVfNQciN6jOpAMJxpWqZBx3PUv9k8JYL7SwOyFixNUyPTK7
         a4IKpe/IK3zpd5sclBt3TPtx/Qv6Gd6GoVvlExl0AY2R7sF7lK3XLu3MtsJSi8BDahb0
         8eEDfVrS03QkWmfnzrBWnRKV7mBw5080pJAn0iwYn0L/1tSaGbAXN5FYfNY1GoW8oWG0
         5aUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712422114; x=1713026914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3v/S/N1hN0Q2k246igfeXq323YyFr+V6BvOJzuDRd68=;
        b=sD6zIUj8/TCyQyjIeD2kXbgcmzARL7e+nPdZ+DoOhT94XXb2OZ/1rHSvg8Emk0I6JU
         OYVVljVw7e4Zpp3JG4K9kcjQJP3jOdQA9AXAlLWa5N+18EVMRruANrjww9Eq6Vc48//f
         ab3NAwqPF0Cn+XToh9/jjycoQW6MRRendFty7rflOybzAuDr6AH6nI2BlxxSSs4+hPGw
         /a7dlKFq4/JdNPIfg3fAjeDjcdTGkVF0sCU5faq9iOvjbwxR5nS2cs+7OK7KDVIf+QGM
         S9X3TV8IYB2DD+0F4WO93NzrnPdJ88UZkYZrQSO0TA4rTMn5iQ4WD4tzGcHZ1O749p+f
         jhYw==
X-Forwarded-Encrypted: i=1; AJvYcCVERmMcmcY+MFA/BVDuqLHhBTNcOgjanXlmEoKI2DeY6XzvOYSTI7AwziNI2mZRepICl8PHohfemQUKpNk8tAJWonqbZ87H1a/4+G4qU+Wc2YrW2o3DjukDDTlAhB6FyZGrHSObtGH+85hzV/mH14kZGwu7Vj1E8DoHgLl/LCyLwis/5l1m0G0/iYMiU+DvDFlDb+JqQNO99GhrvRY7r2CCl8sN3RlCnsLsRA8S
X-Gm-Message-State: AOJu0YzzLg5JHE1RtIPYfba+SAFwEYzRXZLykc1MuFmpZCsc7ivTmhbk
	9IXTEHoIcXX6I4Ft8VMyrk62i66hL7rf0Im3ymPeMmOVOOUDhTPG
X-Google-Smtp-Source: AGHT+IEnvMJdcT9OxwgIRlFw/EFRCmFP3zZM4r7rk+irBAJtT3Oz4tYkzVHkMXa+EYYD8N3SS8ILGQ==
X-Received: by 2002:a17:902:e5c1:b0:1e0:99b2:8a91 with SMTP id u1-20020a170902e5c100b001e099b28a91mr5339831plf.4.1712422114345;
        Sat, 06 Apr 2024 09:48:34 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b001e2b8c91f04sm3665068plb.22.2024.04.06.09.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 09:48:33 -0700 (PDT)
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
Subject: [PATCH v3 11/17] lib min_heap: Update min_heap_push() and min_heap_pop() to return bool values
Date: Sun,  7 Apr 2024 00:47:21 +0800
Message-Id: <20240406164727.577914-12-visitorckw@gmail.com>
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

Modify the min_heap_push() and min_heap_pop() to return a boolean
value. They now return false when the operation fails and true when it
succeeds.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 2aee024ca883..889d410862c7 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -147,18 +147,20 @@ void __min_heapify_all(min_heap_char *heap, size_t elem_size,
 
 /* Remove minimum element from the heap, O(log2(nr)). */
 static __always_inline
-void __min_heap_pop(min_heap_char *heap, size_t elem_size,
+bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
 		const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
 
 	if (WARN_ONCE(heap->nr <= 0, "Popping an empty heap"))
-		return;
+		return false;
 
 	/* Place last element at the root (position 0) and then sift down. */
 	heap->nr--;
 	memcpy(data, data + (heap->nr * elem_size), elem_size);
 	__min_heapify(heap, 0, elem_size, func, args);
+
+	return true;
 }
 
 #define min_heap_pop(_heap, _func, _args)	\
@@ -184,7 +186,7 @@ void __min_heap_pop_push(min_heap_char *heap,
 
 /* Push an element on to the heap, O(log2(nr)). */
 static __always_inline
-void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
+bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 		const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
@@ -192,7 +194,7 @@ void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 	int pos;
 
 	if (WARN_ONCE(heap->nr >= heap->size, "Pushing on a full heap"))
-		return;
+		return false;
 
 	/* Place at the end of data. */
 	pos = heap->nr;
@@ -207,6 +209,8 @@ void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 			break;
 		func->swp(parent, child, args);
 	}
+
+	return true;
 }
 
 #define min_heap_push(_heap, _element, _func, _args)	\
-- 
2.34.1


