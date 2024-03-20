Return-Path: <linux-bcache+bounces-335-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18F5E8813D8
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 15:57:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48CB01C223CC
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 14:56:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 644714F217;
	Wed, 20 Mar 2024 14:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bWrwRIa+"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65255730C;
	Wed, 20 Mar 2024 14:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710946505; cv=none; b=VQaFgONDMuwigpJq8DKPZ9lY0yLCNj70kmPFFK1Vb4y5PbvEQVX4k2PTDc+hC06kbQIyk/I7RZRzSPG4SQziiLPjvj+ohJ9hsymLKFzw5K3Kj+JtNhhPzEx2AAXPH8cr/aCsHxg9S1vsAxfLpLKMV3ALIewMUy48Tngv/bcDfe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710946505; c=relaxed/simple;
	bh=qteByzsELspBqYOuIARYBU2Zdpp8cSKVC+Oyjn250gs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rOWKuEwU1egLjLvYUndtCalgQaQaK82b2fUkYWl5qDB6BPWsbEFQrHnyw1jUo9tSlWzQhnIaGizM8d1KMbrx6pOwptSyLUIGPIPSxMaSwLD+3rW6F1pJOQ3i92oiKEcnY2yaM9FEBEr5JKPGUmkecJDEDdJz/qgaOg+jG/E5L8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bWrwRIa+; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1dd8ee2441dso11936795ad.1;
        Wed, 20 Mar 2024 07:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710946503; x=1711551303; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qQWgWJZiZRkB0L8mwTWbJhKi4LMazpagttqLDd/n3Ao=;
        b=bWrwRIa+VAQo+6LwHNKQlk1UhtYYgSo8OoF1+Sb0HAh/4nf/yrGBoiw4+FsN1KovBk
         e+JiVlTubeUMJU31Cpf/mUWr3vvBRvCU+3MknMX1uaEJeTvOxPos39b9fXZ9OEE5Bz3d
         n3vzsgobUao4ONeq/5fZL86cfMt0DfEPPLWm+XfoEq12gycojHhatHXk4TmLGPX0xAmh
         jp2GRNbIfOGlP4sejINPSD2X4iylZxr9ThEgISNerHg4iZeseNX2+VnyqY7sjkaRyO5J
         4rMkM55i8sL2QjJN55Hbi3w9dTRfSUGbLDnmSb5U2HOPYdNboRh19pybSz1g+kNANrP8
         QTwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710946503; x=1711551303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qQWgWJZiZRkB0L8mwTWbJhKi4LMazpagttqLDd/n3Ao=;
        b=Zt6WUSsA1PXwOrJqJHnN01Pmtleqo/9iIZ03M8c0Jruf4ro8eGIhhz1BHKagpQjRUx
         TdRsYh1CoYINzDbreR5zVrIN4M0ISefXHXiWlziJu0XjE9TWfDat/2J/onAZL6s95566
         Cd5bqgLfS46499/jvAGeUVwkOuvu7CK/JmNgw9gMVRFBVF/0O5D4ufr7X0zu069mfZ5I
         aC24VagKDOVtBXT2pl3Xk8Kw6yUkP54+D+bGZ3T+JWkjmoYqoNUxS25BB8gb/cUiZuI4
         mqu5voczCTE65IAo6z8B9uTJl/GU06ION2GZAwXKsxJM19se+ENqaf+QfyxxFbGDl5mK
         3Uig==
X-Forwarded-Encrypted: i=1; AJvYcCUNqC1WTCFRlxMKxh9XSgRU4nt6mD0W12Bur4l5qZfe4nioVCW1PTx18JDr73kAKq48fgZ57ANrjefMcbPWyHWeRmzs7rr4LnJBvn93wYI+eVHxjXAqDXrp06lkRN9wE9ZhkbwOerTj9o+MjYzqjNiGl+kzBYovX6XgvMk9wCofSkWx8hm7ET+gnkiHSbuye7VG2uxdBvoU+ACyE6pp6nTLiA4nAkS7DJs66Iur
X-Gm-Message-State: AOJu0Yws2hHBrrV9YPrA1DoUTzDlLMdVt+g+N55BM4lGuzwu4r2+qU24
	ObXWCI2WCeaPb8RYPQnVSktB4h37vcI780+kPAyUJ4Hp8+u1DkBI
X-Google-Smtp-Source: AGHT+IHQMu7VAPDiqxJgKvWwfBIcERpY9KKEw9e5I4279Pib64kSmLnENjmLOaIX8wFBH1sb7n9z5Q==
X-Received: by 2002:a17:902:c94d:b0:1dc:e469:6f5d with SMTP id i13-20020a170902c94d00b001dce4696f5dmr6103504pla.4.1710946503210;
        Wed, 20 Mar 2024 07:55:03 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id la11-20020a170902fa0b00b001dc30f13e6asm13719989plb.137.2024.03.20.07.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 07:55:02 -0700 (PDT)
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
Subject: [PATCH v2 08/15] lib min_heap: Add min_heap_del()
Date: Wed, 20 Mar 2024 22:54:10 +0800
Message-Id: <20240320145417.336208-9-visitorckw@gmail.com>
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

Add min_heap_del() to delete the element at index 'idx' in the heap.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index b1d874f4d536..36023e0be232 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -194,4 +194,28 @@ void __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_s
 #define min_heap_push(_heap, _element, _func)	\
 	__min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(_heap), _func)
 
+/* Remove ith element from the heap, O(log2(nr)). */
+static __always_inline
+bool __min_heap_del(struct __min_heap *heap, size_t elem_size, size_t idx,
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
+	memcpy(data, data + (heap->nr * elem_size), elem_size);
+	__min_heap_sift_up(heap, elem_size, idx, func, args);
+	__min_heapify(heap, idx, elem_size, func, args);
+
+	return true;
+}
+
+#define min_heap_del(_heap, _idx, _func, _args)	\
+	__min_heap_del(&(_heap)->heap, __minheap_obj_size(_heap), _idx, _func, _args)
+
 #endif /* _LINUX_MIN_HEAP_H */
-- 
2.34.1


