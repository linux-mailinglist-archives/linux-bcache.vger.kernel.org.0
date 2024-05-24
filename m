Return-Path: <linux-bcache+bounces-482-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C52738CE804
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 17:33:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 027701C20E3F
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 15:33:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D95871311A7;
	Fri, 24 May 2024 15:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fc+sFDaS"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D52C131195;
	Fri, 24 May 2024 15:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564652; cv=none; b=C0FsD8uEIvMihdnKvvrDWPZLCvi6TM06nbp7+YCWQOuUvF+7tm05ZZhnpx0abBKEUw7y6Pdx5hyg/+/b/qoGAQE4ObHorMagCrVOMsL8+87qNlxTCgkjV6TY4f7pI15+5ownxVLo+tyTExylDK8htEmDF0ZJ8YctymHs1B9EDfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564652; c=relaxed/simple;
	bh=tby2ZpUX+BlnLTwxvgk6fPnVU4TaOjJxMlCJa4gIREI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eHjC8JWhFHakWcIB9uBNzsLAbMo0zDYCGVV7pZM5VxOhOzFOQw46TvsgnoQ44yGRZq3d+6L5JacbR4JFNs8B+6WvPUBJyCwNPc/aqeQhM5nMRrQwNHdmKlmRdQ93uWtGGWsyQARXO1CDHdm5AM+mmravOaJwKpjOqeGvz21ciXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fc+sFDaS; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2bded7f6296so212194a91.1;
        Fri, 24 May 2024 08:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716564651; x=1717169451; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uvl2xRBhY8ekhTJXesACHkl46vqc2VrA3GO40P8QBlE=;
        b=Fc+sFDaSuP8YoWpUM8hRd1qaVY2/VxEeBb5yy90799vN74b7xGNZ/6VsnPghqf/X8D
         sx2Smb0dRyxSDKGVLJwREc+SgzeL4BO5GL9fo/HSGMq0CLZazTga5JF+W94018C2Dix9
         sSb2tCE55P+ocUIiZO5DaCOW062l9PXSL2fY1i9qIJf/G3fL35ldBgj8g9/yJ7Lqk6wM
         ZrXfmLRrIZ4GDo9Q+R2OXv9ODoSEPXzz1zWE9gO10CGO9/p0AmapgyMMXhHhuWyDvxpw
         aD/juetLT84kHAoQjpiplxPUOZ2IECSwDoGXIuy1Mx8s+sCf64zft8EMEe0Qi9yDVtw8
         y7Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716564651; x=1717169451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uvl2xRBhY8ekhTJXesACHkl46vqc2VrA3GO40P8QBlE=;
        b=IP06gu5uSA+nvXzwfC0T9qfcSB5LsyS8HhTz/4aBZgrBJZ/eY/A8cr6I4JxRRRraH1
         a/TfddoJsEatzf+xx8VAtPrh0GATPrXFTQan2ckg1AgpHQ6HRrLGrlrHyxHi/tu3w25w
         +ktZKEEnc5myiFj/tDusclvhg7lYoSuqgSxPFzWQoxpETp4KDSKP53qHg6ughFmnAlEa
         LKU3s0rX7maCaOxi+Qh0AdF+h+jbhPflAL6pIqNz8s/uwH6vvyNsOwCZEe7zTpe3zHrf
         MmJnlsLEvGXZqNdzJwtuakzhOXxJoS/KJgTAlLlub9YO5jmdJZquUpeup8R20U2qxN6f
         +nXw==
X-Forwarded-Encrypted: i=1; AJvYcCWHnQ3mBwoj8PkDghS6ZoPzd3YTgAQG4MhdZ4GBxytdtHmKnQnhSEQ8oDXd+dOeF7t5YVYDYCZiFQgPSUIX4GWNzMQqm44Mcu4avEx/HOuH8zPlc63EzhH8bpghZzH1C+r+aezq+1Rd0Y6zw6ITllBbo8B3woWgMUWW+QoXk8Xszgmg9suWgol8xYzRqiKB2v38QFl3vwn1SSBAROZv65irZ5Ib+bOqQnX038vX
X-Gm-Message-State: AOJu0Yx21SLYEC1X9yurf1KhpnsGGZ3UXykCBqEk2QGYh9JXUjtDQZKT
	lWgLq9f0++AMTbPBwUvrqOKHgNyXTn4bYyG1yyNch4B1nAE5NN4C
X-Google-Smtp-Source: AGHT+IFsxgebjZlr1dxx1chJSleAIrK43REkyeW81P4lfYkP9NwmgKQYjYTGz/eljOWV8fOLiCwwGQ==
X-Received: by 2002:a17:90b:24c:b0:2b4:329e:eac5 with SMTP id 98e67ed59e1d1-2bf5f202ac5mr2505679a91.2.1716564650793;
        Fri, 24 May 2024 08:30:50 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f50d294sm1525556a91.20.2024.05.24.08.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 08:30:50 -0700 (PDT)
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
Subject: [PATCH v6 09/16] lib min_heap: Add min_heap_sift_up()
Date: Fri, 24 May 2024 23:29:51 +0800
Message-Id: <20240524152958.919343-10-visitorckw@gmail.com>
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

Add min_heap_sift_up() to sift up the element at index 'idx' in the
heap.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 4acd0f4b3faf..ddd0186afb77 100644
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


