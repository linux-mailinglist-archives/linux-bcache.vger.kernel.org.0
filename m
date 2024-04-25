Return-Path: <linux-bcache+bounces-415-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F14D38B23E3
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 16:23:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A42AC2851B5
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 14:23:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FAED1514D9;
	Thu, 25 Apr 2024 14:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BlDx4JO+"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894EC14A4DC;
	Thu, 25 Apr 2024 14:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714054763; cv=none; b=mk9YHO0qnzcr0SZRtWMu1m3gTC0xOHaDWKTTrddtL24YtqNx03lES+EDtI2wb3XMaheoKT4T6tqfE0zkSnZeiu5YqIuLIDvFpQgjEdmqKVbIuCcte1xtGBeJuOOs9BBiVOpoCsWNDoQ1cgdi44rrEmPu24dQwRlKy7q2Yi65DUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714054763; c=relaxed/simple;
	bh=tJ7jRhX3JE0weNjdlxeuKf0kQodyCJ3KEJ6yl72FH+o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GxmmSLZjYvj7fZLvpDoqMpciubf0GlS0td3/Ruf16d0XSQNe/IhaTzChh+uAs9/x38w2f7qI5d4FDXXXF43sw8FWHSAM4bCTa0rXdTAveVPefs6iJIa1dx3YiUzHE45Lo4do1aLjL10FJMxAHJN1xfQuxNX7hV8szj+caqJovK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BlDx4JO+; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1ead2c5f3f0so109905ad.0;
        Thu, 25 Apr 2024 07:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714054761; x=1714659561; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5hB1FNdY/u34MXPrD/nJEK2rp5x/YUSa36ZwVtrLJjE=;
        b=BlDx4JO+BNw8M0T8OOVyUrOWxVudQVcBA1GSqLNcRMktvMhBPlLAO7zWiXcy57mRq8
         vxLIGKVLptjuwWPrcxa1qZiqIul/1wlkbEf2D6D1alAOdboH8VryGk149HpbXzubeQAR
         PKuwvkq/8b+wYAFIJ+UNfCykMLWUZkHQB71U4lh2ypU30yvm5u0gQCxIi/t/SBIYmcX1
         s6gaRHgKFJCUlj5bxthVZXNK2Hp1QpKdJvnTSrjcWhYWP/j+iz+Si00bdqrCbxY8Xobt
         Me1icMfQLuICmTbftVfVHiWXORStj/uhsEVqClM0k8iXpyFMVvJjc9m/NMv7YDxQyyRc
         cRRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714054761; x=1714659561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5hB1FNdY/u34MXPrD/nJEK2rp5x/YUSa36ZwVtrLJjE=;
        b=Z0SWJmLXVgGWsTywzW1QOFY1EDtQOYVpizJ3LYGWIY98AzErz4mjFXqOlcG9YsihsK
         WywVX4BgWeUrdhfB10o3dEEHWCajgYONkKWHsXf183iwb3GL9RGfLR1FxvUjL8tonDoR
         DQVeqk2Z395k3RwEAMlH00m6vqNaRQnJ7zu7068pONCnhBxKszDwfuuI6Ed0CxpCCr4I
         97b5124uiUsBEyibCK91KjSTVRNsOU5Y/n0zq/xb1Os9OQMX0x3jpx3AY55dqSlWHEb2
         2vuJ8QlpCGO0Rno9IuZwFKYD2XHWcMzFfE8BTw6Urj3pVKXJEovTsnWwGIWUtoKioLiX
         ju0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWCIr2U1AGDwwQt9r4V/yR+wx5edgIhRgoQ76V37vHTUhn6CmseozLjJj3fUZW0+jk1dsoYcXLabgiMM1iVgVuwo9Cx9BGFxrckuBWfiit0952iixsbK3hpyfi36OoVngGfJZbGZybaw49r3pUda8my2odPkUWVrhn8LqYwMvtKl9Cr63AyVq0V4jUxN5zA2f/BDbcJeH+PYmY5Nh0sV2evAfi2uJBpFZLQw9FV
X-Gm-Message-State: AOJu0YyJu/a1AV0iiPiKtMRQa2IGvlb01mKpI8m3rB0U/4Ju9WTjqtQn
	PJKd7Rk3u5m06jIcHbC3J0aW7ROVfSy05CLztxRhQCgWsnKEQ7GE
X-Google-Smtp-Source: AGHT+IGPJ9qEIg5OOvnVBaHQxsAeXsNBJGcq6V1gONZPwX1npRJHljeenUCpAetAla6YwfnwY4G9iQ==
X-Received: by 2002:a05:6a20:12cb:b0:1ad:8df7:6127 with SMTP id v11-20020a056a2012cb00b001ad8df76127mr4575398pzg.0.1714054760834;
        Thu, 25 Apr 2024 07:19:20 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id go20-20020a056a003b1400b006e6233563cesm13162397pfb.218.2024.04.25.07.19.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 07:19:20 -0700 (PDT)
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
Subject: [PATCH v4 10/16] lib min_heap: Add min_heap_del()
Date: Thu, 25 Apr 2024 22:18:20 +0800
Message-Id: <20240425141826.840077-11-visitorckw@gmail.com>
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

Add min_heap_del() to delete the element at index 'idx' in the heap.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
Changes in v4:
- Replace memcpy() with func->swp() in heap_del() due to issues with
  set_backpointer in bcachefs when setting idx.

 include/linux/min_heap.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 201f59cb3558..c94f9d303205 100644
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


