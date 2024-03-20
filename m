Return-Path: <linux-bcache+bounces-336-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5198B8813DC
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 15:57:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8427CB22C08
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 14:57:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D0FC58120;
	Wed, 20 Mar 2024 14:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YhYVipQO"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D8D5730C;
	Wed, 20 Mar 2024 14:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710946510; cv=none; b=jrzgLyM9ODlZbFUK7yCMnIPM93FhFzbAqM7HT406vXZBFFs6wQc5kspcJlizGmqKPmw2hr8dScT2g1X9EpnJkIId1pMRUEUFJNRicgLb5Xh8ZKdwYR9RgGKMLcEF1AJb+UMNdS1UZ7wjRM3WCbVGguDqagiCpWE7QCaFis7qB3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710946510; c=relaxed/simple;
	bh=3u7SHTx5BWR6PFeMX82UOtRGC+rWOaoSO0kUgAe6Dt4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Jamp1Y09y3mu9DBDbgN3wt789FwcFKgJoPrguhtoWC6vlgUIOaujjtBDyzaP8KXFg7v0PS3IkaOs4oT/IFyUQ+HOtBT88uG3SuDo0BB0NGBv1tS8eZFq8I/wTijtt2vVrku5ssEPXsGY8qtgx+rywKbyrTt4LQiwt74b2Ooilt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YhYVipQO; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1dee5daedf6so8924585ad.0;
        Wed, 20 Mar 2024 07:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710946508; x=1711551308; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BaX+3tHSfR6Y1hlzEWAzFG8m2A4U3O7BTlzKixVR79s=;
        b=YhYVipQOajWgnE6rMetXJwNYrJS+OBn9AAFLiWtY5Uiqmjw6n01NmJ2NUcLFRgSBDA
         L5JmWteRldspjtev1qw1xjqVKjzUZJYtoqAp03gWZXW6YFyQFjN0IzUQnQOoslZVHEqd
         O+G7SYNWv7unmG4Jymgdzy2kzMqwrEYa0PFWFmG+dhrtfzyXo667Ha73x9zl+Qk3dlZF
         9JqOp18CfmFK7oTjxlSXzVU3IZ09t/6GMBurIPl8cXY41xOOqGDi8KQqMI1YtqVNTPG2
         7yUreZZxnmpw9G7fKHSbmLqevuuEUv5E9tH5+jE8CGDqILz9mgFp0jm/5Ob2RPjVA8mZ
         30+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710946508; x=1711551308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BaX+3tHSfR6Y1hlzEWAzFG8m2A4U3O7BTlzKixVR79s=;
        b=XfKwkzx44gOCoS5qD7uS3h1FBKbROAJizC3U7AMfkd8a/CGesmk/f5HiEveY1IvQTP
         LPUPtAX4d/STSOe5V6CzbZ0k+jXoRUInr0ZKj75MMcX9CUeoj6WI6c/QTX5zL9WUJncy
         7JpNkZ0/aYu8M2ddg17lihOAG4NW+j3IdaqIaZvYq0EWQc2foFOU7CC5cNJjxhlWU2yE
         WlOCb4x1g0Q/rgQQ5BfdnAXixf8vLjoBaBMUqJRp+IlO2fMBbp12xLHBVJKM1DOAeozp
         VyaTkaLRESOubU9zpxBCntD0Cv1orZ6McYoU+ItRP3RN5H18jXUNtUUTtPG2cDnQQd4x
         dK0w==
X-Forwarded-Encrypted: i=1; AJvYcCU8A5Rg7ory3gYHjth8AKTjnLL748l89L3yaSZmZpGt5Eir3LIsYfRzM0wKj+m8AtjED3+z5aDoJVoaCFUD7ZbW9W1NZ8MK+5YGNmUd8vYc6Gu5UnqFSSVVAB9qDef/yeObAUqGxwXouAMQYOAhLGJ5Wrk69vT0/oCgyY/BT0mR5PbzYgOw2ywslOC5A5CXar6X58aSeyAPLTjM5ubHaCN9UCxcVIRcDz4LNxAX
X-Gm-Message-State: AOJu0YxPh6L1dgYSTx0g8mxKKP5cpFWYtI1OAfCwT5sMYkEbTYkKcALn
	4otUL9+xDz7Me5jx21E8LrzQ2HVg2uYwUi6l1MOnp23MVqJQaS/+
X-Google-Smtp-Source: AGHT+IGd6DO4qwAk4p4e7JmQ1R4ZPRJj4m0jMv3XVjEK0nV1sCafyICIXS1wY7+2qQE9k1iEQlC2Rw==
X-Received: by 2002:a17:903:18e:b0:1dd:b54c:df51 with SMTP id z14-20020a170903018e00b001ddb54cdf51mr6005831plg.4.1710946507885;
        Wed, 20 Mar 2024 07:55:07 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id la11-20020a170902fa0b00b001dc30f13e6asm13719989plb.137.2024.03.20.07.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 07:55:07 -0700 (PDT)
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
Subject: [PATCH v2 09/15] lib min_heap: Add min_heap_sift_up()
Date: Wed, 20 Mar 2024 22:54:11 +0800
Message-Id: <20240320145417.336208-10-visitorckw@gmail.com>
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

Add min_heap_sift_up() to sift up the element at index 'idx' in the
heap.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 include/linux/min_heap.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 36023e0be232..af12531474a4 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -194,6 +194,26 @@ void __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_s
 #define min_heap_push(_heap, _element, _func)	\
 	__min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(_heap), _func)
 
+/* Sift up ith element from the heap, O(log2(nr)). */
+static __always_inline
+void __min_heap_sift_up(struct __min_heap *heap, size_t elem_size, size_t idx,
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
+	__min_heap_sift_up(&(_heap)->heap, __minheap_obj_size(_heap), _idx, _func, _args)
+
 /* Remove ith element from the heap, O(log2(nr)). */
 static __always_inline
 bool __min_heap_del(struct __min_heap *heap, size_t elem_size, size_t idx,
-- 
2.34.1


