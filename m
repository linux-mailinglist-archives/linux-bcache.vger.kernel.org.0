Return-Path: <linux-bcache+bounces-483-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C44ED8CE807
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 17:34:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 34508B228BA
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 15:34:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BF4213173D;
	Fri, 24 May 2024 15:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EA4UTc3X"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CBD13173A;
	Fri, 24 May 2024 15:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564657; cv=none; b=hVF8UZVcQNs3rMEfbnEY76pv5hszIn0wA+ql2mXXQSjp1q0G6U6y9Qdhbwd1AXoea8N/NKRdLoqV9XpcU0CzIHOOIkAQCEBgUT92242VuFBV3txjz4PTtkY7Dx1EuhiOx6IzirPm+LzwnP36f+sPfdaGqfDCfIjWggZa1odxrXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564657; c=relaxed/simple;
	bh=sJJvbSyrqr9RfqPlGBQxs9diGbsYUKhy8zMD1EMctXM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X0swQvJQ+FSnHbaCXS1MpNKVF5MoXPB6u13fpHE+eHkpnUnhNF9/jlYYdyotx7NfcyBL7Y+UBro0O+1QMHOYd4RyIOv36aRtBj3uACMPnN1FscAb0d6ds7GEbnkz3Z5toczLsDKv69csWanCiY+D/UtMixoyn+WloYNsFq3+cqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EA4UTc3X; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2bde4d15867so247252a91.3;
        Fri, 24 May 2024 08:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716564655; x=1717169455; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5lfmbsG5rvd+B8+9dE2AYffkU5kvksfUycCfh2ZKaE4=;
        b=EA4UTc3XhW0yt1ktCzdFOpnVVhdDjdZeB14UUWor17OpP58shereyfIufWfcNlXGl7
         uLEvFVzHxGgA7zlUgHVqaCkh7ZnNixsasmxrpIELEkLvvHUxznhrerU06kWO5aiLDXTW
         BfgwWqK6qmiRJ5Cz5HUQQm04PHXguHRtLZrBcT7tauvAV71edkv8Pri0qD4UIu1mmQjV
         bL4x6Ibt3BzBRX2sAnztpbsDZ68o8re6vYHdR8v5FfnthUNZZ02H9/mujs7o10AoA5es
         d0jsoxrD1zr3YORB4hUxY/avzBoZxjR+HRw9WBe3wZ+v+ok6ZEPYSDNQd0+ItUBCtY/c
         Qocg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716564655; x=1717169455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5lfmbsG5rvd+B8+9dE2AYffkU5kvksfUycCfh2ZKaE4=;
        b=vjOxjx1O9F3BwMP8krnhiKetmoLmP+7yhV6fijFAn8xSYsiJwlHy7y67fEXHQU7Nj6
         oOCmACIOMSFXLSV3SF5teRX8zNQkPnBPx/IlOIkllUY1cfYZyCv4BX7t1lFiu8zFAise
         SwgOeWMj0mw5CuxWb6FLJYA2vyFtBM8cK0Hy51n8dFkFoWJsGE3ZwY+ZagRUExtF2tRz
         jwIRUrLT+Cf80HVhHuPOtyr0bZAYpSGQ6i/KMZyaaQumwQZD53GTlUOCXDo5cnG4PMCE
         iFS3kJFNynkqjZDCcNDFl2GxIw9SNLBCUCDCxGGv4CC6eToo1bxFwxmXxMpYqUh7pbSV
         rT6w==
X-Forwarded-Encrypted: i=1; AJvYcCVIC1MEP7Y3szPXql+iy/OVd+nwzXQsCzSMRcB6VdFIIHmDX40AlYfNKMwQwZPIZsFdBqc+lXMXZQ9f4x7OuxSmOX1hToDT5ASm1oAgOfm8BtzFyflll72oVuxWQxuSsEspl4w6BbppLkG+rVW7h0OPQwF2XX8QFxs+avb6sARmde+Hmn5bBvhb6cUpt2ujQETmG5qBMfu0Annf/W182GgZc2aqCWN4xvq7qiZm
X-Gm-Message-State: AOJu0Yxhiy5nVs3P0BN/Ms/ObqHSAONvywMDuDGp0IcLPEnmQhvr6hWf
	6vvLadc7QVIVyfUm7TdcsuMhIucv+RDJthxz02Y1cnHhJr5e/8VK
X-Google-Smtp-Source: AGHT+IGLW9yYebnTwkf31N4DQ42MfzPeT3rNQKrGi7/d2boEiBvS/PxpOdbDpM6nd0O3UUnbvMIB5A==
X-Received: by 2002:a17:90b:24c:b0:2b4:329e:eac5 with SMTP id 98e67ed59e1d1-2bf5f202ac5mr2505960a91.2.1716564655542;
        Fri, 24 May 2024 08:30:55 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f50d294sm1525556a91.20.2024.05.24.08.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 08:30:55 -0700 (PDT)
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
Subject: [PATCH v6 10/16] lib min_heap: Add min_heap_del()
Date: Fri, 24 May 2024 23:29:52 +0800
Message-Id: <20240524152958.919343-11-visitorckw@gmail.com>
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

Add min_heap_del() to delete the element at index 'idx' in the heap.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index ddd0186afb77..98e838195e7e 100644
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
+	func->swp(data + (idx * elem_size), data + (heap->nr * elem_size), args);
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


