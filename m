Return-Path: <linux-bcache+bounces-449-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 799178C4DFB
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 10:49:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D5D1FB22063
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 08:49:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90B3628680;
	Tue, 14 May 2024 08:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KqZxdO/9"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDD93C092;
	Tue, 14 May 2024 08:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676489; cv=none; b=gIZS/6E0ChmNlyYnkbURA7D0p04uNca9F6qCZgpcamCtclpYgSLqDaaQC8iGwDiKw0VXxDhhbuzWLh3M/r0CpWWch7aiuPE9ig9IipBaAY28OeYow7i03c1jsoZN8DdenVACWbTW6xp6dPpMD6gmM2PU1/4fXSDIbOMq36yq3Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676489; c=relaxed/simple;
	bh=45DqO8bF1UCi5bfdHVSu4s8AvmjNFknYLPsfVsf4ic0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ALVD6ZMzhZMtmBKQVLxAi5RoEqTew3xkIqY6EOe/uX9SXhhhjIgPs1O26JF2RF2n+kbWU/Rigo2ifbGZ5XGGmxQsPFqBEo1x+KyfISCsBuD1YI7v6JEZ5uKuyvDckZC9ka5zh+l+F/eiDur4nPFmqtDqMdlEV5/Fmolwd13Imow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KqZxdO/9; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2b345894600so1226989a91.2;
        Tue, 14 May 2024 01:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676487; x=1716281287; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vKi/lHC5XFLRvEUBusUUTA5MCG5n2IA6GUULUt/TPRk=;
        b=KqZxdO/9ZINYevd3me0+cRkUXGLq4zZ/ZVNPDKHKvihdLj4xx9pxoUlrNsADju+Q0d
         ysdvVZcZnojGJxFWxx1L9sAfCEfCWFsnr9xny8bprs9/ZCkvCXHFBTLPtI77ckANCWE2
         63R9m213YtKf8SSwM2AhPWyOOPJz1vrNyIwzrVJN1oL3M+lYHlmhKoAL05NMUWvHMAtz
         NACK4xOtZ10znpUuvNJCj8rA9ilsIfNkINMnGfTRBHtRrN6dSfutSZfEJ/hD2yMAwzpb
         fkzRxDD2r4+eLJM/N9iBrPS68Es+JpaDajFbuId8QFhShgXBcGH5SpWqVKUjari0wU4s
         jzHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676487; x=1716281287;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vKi/lHC5XFLRvEUBusUUTA5MCG5n2IA6GUULUt/TPRk=;
        b=X/Po6+dLuDd6ceuvjrYYHJccDWjEzn1JDea0tXdNY0yOmm5zr/uADlyP8op1YW9j0o
         OSIusKCFlbMad2lQM68iW0JmgnrmZ8HyulUup5wTjVO99B0bTj+Oyhxx75xoPbOffpYL
         1JiW1GAin0XFyLyN8h3eU+/ltwG+iQPZ6mbQIlmE5e4pR6emCvSRZshgkjpMKmX3qosw
         nGiYU1qdi3372C4hDG0AJJpZeEu3uUmnY76TJcxK7XsY55CKmsCrmuM7xhCHfeSeAnRe
         5XC/W6PWKnUbIeL13ZXDeBsI4eSZDlJmq5o0weODac0tYdxvDoOU/aqDoqoT+TznOrOV
         MhuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqkxITC0BfP96ntCa/QyVUyHjvdds+jo7+4scN3Se69bM++o5/xzmg11q73+f27JjvheA3aHjPav2/hlFlYQjW8TqGkbnV+TuJ07RRzaM5/MZCJ8Jq9eOIRcNbMzQRKaYu3NIGZtKjcRfO+LtNDEo1nKtw+S4ABETv1RvV7DJU2HPi56cp460cL1bnNNRedrmauOjE+IDbHmqRp4lD49Z/Ou/I6oc7h4z/Uwgf
X-Gm-Message-State: AOJu0YxhCHXndodq6ASOdhXZBaSy4lZpoyhZNRnSXUfrJQwbJMVJ6NUT
	R0cPVV7R35lMEwYFsmNGLEie9n5gmZQvWjj0hSON2nCs4HBkpp2ycUSQbw==
X-Google-Smtp-Source: AGHT+IFfbcYjY4P31J+W01r/olfC4xhBU+O158w6dnsjPNmjyg3v+UZI7gGddaCiTE5ahTFLgPOTnQ==
X-Received: by 2002:a17:90a:f3d3:b0:2b4:329e:eac5 with SMTP id 98e67ed59e1d1-2b6cceb5dd3mr11609526a91.2.1715676487641;
        Tue, 14 May 2024 01:48:07 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b6711660fdsm9195597a91.16.2024.05.14.01.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:48:06 -0700 (PDT)
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
Subject: [RESEND PATCH v5 07/16] lib min_heap: Add min_heap_full()
Date: Tue, 14 May 2024 16:47:15 +0800
Message-Id: <20240514084724.557100-8-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240514084724.557100-1-visitorckw@gmail.com>
References: <20240514084724.557100-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add min_heap_full() which returns a boolean value indicating whether
the heap has reached its maximum capacity.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 043de539bf71..d4ec7e749280 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -63,6 +63,16 @@ void *__min_heap_peek(struct min_heap_char *heap)
 #define min_heap_peek(_heap)	\
 	(__minheap_cast(_heap) __min_heap_peek((min_heap_char *)_heap))
 
+/* Check if the heap is full. */
+static __always_inline
+bool __min_heap_full(min_heap_char *heap)
+{
+	return heap->nr == heap->size;
+}
+
+#define min_heap_full(_heap)	\
+	__min_heap_full((min_heap_char *)_heap)
+
 /* Sift the element at pos down the heap. */
 static __always_inline
 void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
-- 
2.34.1


