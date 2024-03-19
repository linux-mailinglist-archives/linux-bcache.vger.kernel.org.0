Return-Path: <linux-bcache+bounces-303-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EB7F88043E
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 19:03:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3ECA283E44
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 18:03:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2D815FB86;
	Tue, 19 Mar 2024 18:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WOsHWhXu"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF90208D0;
	Tue, 19 Mar 2024 18:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710871258; cv=none; b=eEo3BAA7ndSW7MhBPhEjWi/QIpfjPANHTSenYfnW1sfleRIVbxElrUxWTbbs1J7IZj6IGAF8Ah8niQo6sCjwXp4N1vWb5BpGU3opFJs9KwX6FBXKJdeLv8Men0WxnWZS5mSP+6qqw9K1dt55LDRpQ8R2hBMG7pUpx6EsCDA8H4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710871258; c=relaxed/simple;
	bh=B6aRAqV6zp5QyTg3WPpruzaUQrG1xvKUJStbcNeX4Hc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QdsT3l86t28mc2g5FycbpWll6aEUONdcTfUhLScZj4JFMMMtXTo5kSRSuoIzJshopPbzC7W+BUmGspyuFOOcc0NG8YJEU/QhV2SY/F13CFr+xlWBbtT71tpobPX+TYKn9mhxJnCAbaGlKpeBxT638iSpY0vYu0YN8JCPSrDik9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WOsHWhXu; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1dd3c6c8dbbso3191895ad.1;
        Tue, 19 Mar 2024 11:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710871256; x=1711476056; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vXm1fu9C4vX46h0sj29/lTEeornZUsKUb3fjEsz6jiw=;
        b=WOsHWhXukUbB0mi5ivzNGywXZqHcyMWjU3zQDYYMHiQsVQCzgwg9vFpuChxVBc9wTL
         9FkNGGaszolwQmd9HooDYcLY+iRHq8hpqEz/Rrsjtl8iu9o5djlykw8+F2SGkzjqcxXX
         PpIAIwF7VjvyF70cbz08m6J7wfIj2tgcuNDJh5oLqO3uJ6CEpFwMlWrWiuyEK6JxuvFD
         g70iUYcvhirdy5XChbtI5JCrWmy9Qgae3sLvFzwCEBgW/NWQAWUNbJncJ7GbviYoOWuQ
         A7o97R78snbOifAt7QbZjpfsTf6U7ZWsaGKBMvcrcipJvJs8ohmUpcI4/aKbvPBMAQ/A
         xT6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710871256; x=1711476056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vXm1fu9C4vX46h0sj29/lTEeornZUsKUb3fjEsz6jiw=;
        b=Kp3LP64uCrSroVH68fg0aiUSzHxvGeuuMQH9E43ffWHaTzXeXV2Lg06hkPAbrqhr5u
         vayZAJpTe874cZwAL+WDhL6ga3Zw77wJxnG0C/B5z46NGK31X1QBfHIQ7rrb+zNZm5tD
         v0YuIHKT+LaWOBZc0hM0omJZLAThfybvAalYwxitcf4N59cfCtCbliQjHI+FjwdFamvo
         sHX0xrgBQ1RnD/OTmLkMJXdYXHpZyeFa+tBqZeXuvWNbT56k5Ndv5jEyTr2qPuH72wGZ
         f5nx7acZSyeUv0SG5/h6BgWx0wqRNLSrBXR+ECN3yu89wg8culPQU/vcRqtndtyaZRAB
         xTKA==
X-Forwarded-Encrypted: i=1; AJvYcCU7IUXfMGZSprtc1JBJkwK7votJYqvuEZjy0wheFN3KeOUeC4dVNFe0gX3Y44UMc2vye+m5a/4TYRLdbzjofrj+i4fnZsjAD29YNetiQK2lGiTWznqjdMxtMH7nxV8U0vSJle0XLht2UlakbZ9/d1fh4gUnzGRPK3VuTUMFDSpAR1WKACyqhkPZexEaDAY2LhEmJDVO6FnmSIuAFdRwAXv2abwJcWQ1OeOyh045
X-Gm-Message-State: AOJu0Yz1w+fmAZsKIn7X4PQtljamYMBYj9qYv+3ztPL7UVqwyaDndU0E
	WJm0rLBLmuBcl3qyodMUCPnawLaMAGQBtHwG1OwJT0oGoqX+zaJ1
X-Google-Smtp-Source: AGHT+IHz2e9HCL5b8g4rCYp5kejors7FezHFbQ8oKlKDPjYAYoLpn1/27z4UODGEQE8Y/aKdKY5Jfw==
X-Received: by 2002:a17:902:e84a:b0:1dd:b883:3398 with SMTP id t10-20020a170902e84a00b001ddb8833398mr3095419plg.4.1710871256326;
        Tue, 19 Mar 2024 11:00:56 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id u16-20020a17090341d000b001dd3bee3cd6sm5531359ple.219.2024.03.19.11.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 11:00:55 -0700 (PDT)
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
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH 09/13] lib min_heap: Update min_heap_push() and min_heap_pop() to return bool values
Date: Wed, 20 Mar 2024 02:00:01 +0800
Message-Id: <20240319180005.246930-10-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240319180005.246930-1-visitorckw@gmail.com>
References: <20240319180005.246930-1-visitorckw@gmail.com>
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
---
 include/linux/min_heap.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 97d8ba5c32e6..154ac2102114 100644
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


