Return-Path: <linux-bcache+bounces-301-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F350880437
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 19:02:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8AC32B245E4
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 18:02:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 270F13BBC0;
	Tue, 19 Mar 2024 18:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MTUPKdR5"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD1939FFD;
	Tue, 19 Mar 2024 18:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710871249; cv=none; b=JAD52OIB7g16zuoghMM1F7Xvje2r3E+PGfmaaIl69y/s2+m5sqTWb7g0Utm+bvoBCH/Mg2A1Ye/1GX4YTu6K/qRu5EqkpxMX0Amr2PSXxfat7TaR3/dFVoOEm//5BtXnog5qpL6YIOdLwmxSNWA+a6qhI3HECYtD3qnYx0lb/kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710871249; c=relaxed/simple;
	bh=yTJX4YtdwgEulmGVYBrgLkPT5pZIiK7xGcI0Hsz9HoI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RR5dONb+P4Oer2uX2wYT8MG8dpv51X9Vya7iO5747c2VVbiHYA0VfLZMczp8JrtbpNefUhEAWnT+s30sRmquvURuGDmTVH0cr56CM2uROclt+M3kuYxxqs4DXvvB2zzDqKguMtLbz9Iy50Fq9VBuIk3dc+/2eHBe+etIUIQ8gTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MTUPKdR5; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1dee5daedf6so7812795ad.0;
        Tue, 19 Mar 2024 11:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710871247; x=1711476047; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0us8+h8cbtOm/cTnK778odLRaJj/mu367/JnBXEvBM0=;
        b=MTUPKdR5l67aQ4OWCvb/S2oHxjatZ0NIuhM+qsq0au1WmY1OeizWffNV7z64dQ6kjE
         rm0RUIATfIZm/vKT9/zEtkdIY+czkevuARrlF6lwksTIcrnasG/NDXBrH80+kZFYGk1z
         864TwglifgaVEKnr1skAF7pjst3/KV9nDujj1q14HkQw8mwBcA7s21CgjJ3qfjaP+OYQ
         GbWQV7hfjp8e2AAOqLnhTADLfA0wlePpbhEYxO3Rx+Y2oWaT1TgQVKItJqyxqvlcQSMj
         R7EpJh+n1TF7srjaDJmlDb3dCtfQhxxgHTAUAaUjCRsjFq2YoxQRPnuUVkKiae8CfvOK
         AvIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710871247; x=1711476047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0us8+h8cbtOm/cTnK778odLRaJj/mu367/JnBXEvBM0=;
        b=RZIyrUkHQY2YdyvkI/7sXNqzr5GjEr8NMuQZERttKQ+vvxxc27B19CZO/TblqFBfAo
         SRHQw8ls//PHfu2TXL12pLEXQ0hoBqPX5aBhk5F3UGop1goKcI4NdGZD9+PhUmYPjJJO
         c7Pyg5HObFoOUKYSOnlIKEE2Jip5eWVfouYHBUAji1qSdLQlLjWUiBOKh4/c4HP82as8
         dCutrRhbzKx+oOVFQZ/9JPpXygsSim6le7sHJXrWaoMnJ+0DsbQwAcQDMJ3yEb6kKeWy
         4fjRBszBPd7qlnBoaVXbST9zjuHogg7jNLo1Zl/g9HCx9NUdGUFf88gqUodncfzggq9B
         b4aw==
X-Forwarded-Encrypted: i=1; AJvYcCWMlc+mq17NA4/w/4uUqFwPMxBa5ofsBx9oVLfwLUURIKqosVbcw3zzDCFMc7TKowLspJJeNP97veXb7p16jNXgPcdpjp1faxSLHyhSFREQfkPkmGfrH6EOD5dNaM79ffLLi2dDgwqIfJedup97LlJ7YfIYlpnFZ1Xq4vi4JIdG8va2nHsMvedr/zuO4NrMIXhWE483qcRigeyjyWS+c+W5Y5gOzJo2aLJwAJmW
X-Gm-Message-State: AOJu0Yy0atW1Wp9B32RddRBw44jTsEysWqRcIoOzFLZsv5VKbMQfkQTs
	unpBtFrmnOEf3PKfHxyGzTgIjGZeqNlUZozCnG2aTFeYFYXmzmbM
X-Google-Smtp-Source: AGHT+IFaDQPKXrZW+fS7R5CytoBAvc38atn+/rwr+gJqsg0kfZROW3rrwE051quXouo0EjA3EYSr5A==
X-Received: by 2002:a17:902:d4c6:b0:1dd:e128:16b1 with SMTP id o6-20020a170902d4c600b001dde12816b1mr3109208plg.6.1710871247072;
        Tue, 19 Mar 2024 11:00:47 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id u16-20020a17090341d000b001dd3bee3cd6sm5531359ple.219.2024.03.19.11.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 11:00:46 -0700 (PDT)
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
Subject: [PATCH 07/13] lib min_heap: Add min_heap_full()
Date: Wed, 20 Mar 2024 01:59:59 +0800
Message-Id: <20240319180005.246930-8-visitorckw@gmail.com>
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

Add min_heap_full() which returns a boolean value indicating whether
the heap has reached its maximum capacity.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 include/linux/min_heap.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 7c1fd1ddc71a..b1d874f4d536 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -66,6 +66,16 @@ void *__min_heap_peek(struct __min_heap *heap)
 #define min_heap_peek(_heap)	\
 	(__minheap_cast(_heap) __min_heap_peek(&(_heap)->heap))
 
+/* Check if the heap is full. */
+static __always_inline
+bool __min_heap_full(struct __min_heap *heap)
+{
+	return heap->nr == heap->size;
+}
+
+#define min_heap_full(_heap)	\
+	__min_heap_full(&(_heap)->heap)
+
 /* Sift the element at pos down the heap. */
 static __always_inline
 void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
-- 
2.34.1


