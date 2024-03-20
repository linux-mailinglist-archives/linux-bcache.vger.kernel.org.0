Return-Path: <linux-bcache+bounces-338-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F7828813E2
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 15:57:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04BC91F22A68
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 14:57:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59F8759154;
	Wed, 20 Mar 2024 14:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mDdxyqsA"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD54E50249;
	Wed, 20 Mar 2024 14:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710946519; cv=none; b=qZ8X+11laInzDHOUKNynAXet+9yJxprqTz4TyQhyAWUNqnzUFL2z0kVhnvr2x6+jWyE/Ze+ncfw4HpA4qnvl39PaF0ztaQyBJSDQ+9WbXra9rth9LIQdJ8WOEuujMLhuqBPFlcJCTCpB5J/bUyNEIXHpIHfN0DGb8OJzw+ky4hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710946519; c=relaxed/simple;
	bh=syfYOYnUwJ/5pwXO5mVU6Pp5rxMGLYlg5kt0rZBWh54=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sE2R4QyS19swMh7Ian1/L6xTJuxM+5C2ETxQM7HXeMIU4OS4wTq2Vb6jLVpG2m96TBPDazOZjtM1Slqz9M6CnrlCOHqfcQQKzGDBdHcHW/wJg/6a0dKYwkzlKsFyMVkz9Xl4piVHr7o4Gv7aNsJNRybCemwbH2YHqOn0KQDIdrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mDdxyqsA; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1def81ee762so9761025ad.0;
        Wed, 20 Mar 2024 07:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710946517; x=1711551317; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cESTsZP2b4VWyk/Zv78LUG0DCiwWqDlR4UPH+ifArVI=;
        b=mDdxyqsAqH30h6hhKeEEnoiq49V1YJ+0agI6zENvZAZxWoaoHPfx9r6qEMJfWktF4L
         IucScylHFmSsyb5UfbxBc0Vq2+jTgACxdv6isAe/noQ3W/RtVWp8Yqwz0WWwvp+SaG+t
         WD1K1krEoYV4xmIxbJKuiyWufHZP30iYhs/QvAw9qEZWm01Cdldfdj4J/IUfDX9dtyCY
         x2dJTR5h8k3BBi49cvuBUViB7lXxWPau4459wj0W3hQIKX9E2TBVHrrDikYj1JN8IrmH
         kD54LBLboQYuyc13Kfhu7V23MaipTGVf/ITxTuNcArSvKGAirLB3DeDIbCOprMMyjqhp
         hwyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710946517; x=1711551317;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cESTsZP2b4VWyk/Zv78LUG0DCiwWqDlR4UPH+ifArVI=;
        b=o50FQM5RdmP7Ql5NDjpBUisqCaz79uKwOPGtZ1cJvdhuMvvg50//ILpdr3Qde1jkIz
         xKIXc4wx5XXxPJfIh20B+F880hg5Vuxcs5p7GBG+z0tt+hYGTs632K1asi0ObG4UVQ+0
         3SPp10/BJDmvJytJi1T3g9cFq12ofp1S+XYfGTWVNgv2BjHR/4jJRTY/WwdGuzTVApMA
         7TLkrO+DF6fJP2YF8+O3Bnc0HY/TEPiJ+wxBL0pAHogR1x/OkDf4MJNstKgq0JQOJF6S
         Oy7CzFD+vq14ul34yLZWTt3ISYyvVcrEeKaEKdh6lk1ipc17VVMxEnAZvQjiZ9Vbqu4j
         KXHA==
X-Forwarded-Encrypted: i=1; AJvYcCWncLqloJZuepHnLcvfh3Zz9nV6kcRq/Skr7HlX5/lBd7cFrSOjxVUi7PFbszQKtD36c32Nq+hvlES44itBOewMp5y1i+wUMU3iR00NME/qK/DLJNGiq9ds7LX7AmHeeXO+WmXg/iLomDzSlBzh24fqq7vcmlglrSaYyB6SzfWw7CCrTCWblN/cXNfGQlzlqZ3cKzgB12TfIfmy2wjxoymxqOBIfcqFKuJ61Glr
X-Gm-Message-State: AOJu0Yz4+fjSWZKwafIgfAxqtjXYf5oV1csrf7I+e+jec+EWefnx1z4g
	TSZxsl9gdFDCfUdekrCjX258X23ttdZ6Ihm8st97flQmnNC+d7Ky
X-Google-Smtp-Source: AGHT+IFyBgv5oFc1N7tzqDalBpTJCZL08QL7Xi0JuKEsJZmPb5q63CmqPKSNUk+sFsubtLKiucyg1g==
X-Received: by 2002:a17:903:2292:b0:1dd:5a49:7a98 with SMTP id b18-20020a170903229200b001dd5a497a98mr6117689plh.3.1710946517076;
        Wed, 20 Mar 2024 07:55:17 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id la11-20020a170902fa0b00b001dc30f13e6asm13719989plb.137.2024.03.20.07.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 07:55:16 -0700 (PDT)
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
Subject: [PATCH v2 11/15] lib min_heap: Update min_heap_push() and min_heap_pop() to return bool values
Date: Wed, 20 Mar 2024 22:54:13 +0800
Message-Id: <20240320145417.336208-12-visitorckw@gmail.com>
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

Modify the min_heap_push() and min_heap_pop() to return a boolean
value. They now return false when the operation fails and true when it
succeeds.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 879a9d12e030..586965977104 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -130,18 +130,20 @@ void __min_heapify_all(struct __min_heap *heap, size_t elem_size,
 
 /* Remove minimum element from the heap, O(log2(nr)). */
 static __always_inline
-void __min_heap_pop(struct __min_heap *heap, size_t elem_size,
+bool __min_heap_pop(struct __min_heap *heap, size_t elem_size,
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
@@ -167,7 +169,7 @@ void __min_heap_pop_push(struct __min_heap *heap,
 
 /* Push an element on to the heap, O(log2(nr)). */
 static __always_inline
-void __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_size,
+bool __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_size,
 		const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
@@ -175,7 +177,7 @@ void __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_s
 	int pos;
 
 	if (WARN_ONCE(heap->nr >= heap->size, "Pushing on a full heap"))
-		return;
+		return false;
 
 	/* Place at the end of data. */
 	pos = heap->nr;
@@ -190,6 +192,8 @@ void __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_s
 			break;
 		func->swp(parent, child, args);
 	}
+
+	return true;
 }
 
 #define min_heap_push(_heap, _element, _func, _args)	\
-- 
2.34.1


