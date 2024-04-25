Return-Path: <linux-bcache+bounces-412-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89F718B23D8
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 16:22:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 405FD285D7A
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 14:22:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3341214E2F6;
	Thu, 25 Apr 2024 14:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lc2fCxJv"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F7814E2F7;
	Thu, 25 Apr 2024 14:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714054749; cv=none; b=I9+tUMORKzmabhe/p9Ph/Oi2VNtJKoK0XpxpjK3A4WMrYNHc4KY+0eBwbFOZ57IF4RL6VN8b4bcXkJta2WctcRuuGbBKMoj7xHbSe1l8zADS/FzWeHi1WChkU+BqfFWizzmUxpSG/7M6VXOUkiu+/4K/7WO+vyL8nRGWzKeSrOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714054749; c=relaxed/simple;
	bh=45DqO8bF1UCi5bfdHVSu4s8AvmjNFknYLPsfVsf4ic0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HayMj6IjByWOcZOoQNPFJuSFuprKt4prEm/u0wBB9MAg9dowiQt/q/m2wKOa0h/x/IKaJ7UnkLv9uvwu/fqM0gBMpXAoJJP5oInR9fBJ/raZ87xWDArp1gV0ncsSnk9jPaCPH9QoOdyC/M6GCzSZBxaOPLVgdqjpbLWukynjEXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lc2fCxJv; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5fcf7352086so2144a12.2;
        Thu, 25 Apr 2024 07:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714054747; x=1714659547; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vKi/lHC5XFLRvEUBusUUTA5MCG5n2IA6GUULUt/TPRk=;
        b=lc2fCxJvVSABJ3ZcBbMeIttAn5L5VRz8YvWYgLz3gUU+PU5JAK3Gf5TlY/C/pLkj58
         B247lTKa98c7b3UlPrc+CPhttnrAFF2TUSd4eeKN/7Tc5HPuwD0c26IATZFwfPDz3Z+X
         oOM4ywJVEk0WWZRGsRNGyvVbzy71YXQ0DBT7znc31xlCw1reXhMvdiFOHapvxm3eYwGl
         ej0/smWSUs28aYroCmeJVz5gL3cJWR2EHaGJhJqCgx2GqqUku/8tYcZE1I5cfh2M8Lyp
         CiwAuVP0s4KCb2iLt6u1nTk4GUJIyM6VhEYUkJ/E9tTizHdXQUDAW34qQIBaSSsOvcTP
         YhDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714054747; x=1714659547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vKi/lHC5XFLRvEUBusUUTA5MCG5n2IA6GUULUt/TPRk=;
        b=KZcEXTAjikvmsryyjQySHXZHYcHvmPH2LB9fcvaXNKFVir6WqpOtRmEDgvFSF31BHQ
         ZAiqAk+EICNCu1n9GOjzSL/bgCKaqI4spKy7GexWe1+QWn5fMa8CMCyJ4fv7078BJy1+
         CM/vJM3DPMcrLP/NIIwWMqSnaTU1DOGAwv8JIAVH6Ubm19H0rNY1lCcMERQQ1tLWVG8i
         7v5Cr3wy5bss3HO10WOnQ212eGT/gffL23TfqDewZD7jUVOLfw7NIT8X+OTyRAvX9b74
         IaYd/mS52t0dWJFpb7iSOWwY8Iy9mMpFW+ZXReW26ayH1bkE9dCHiUI5DdCDcdv2Dd4K
         VJ1g==
X-Forwarded-Encrypted: i=1; AJvYcCX/pnlXjxuFANUpSztHEPvwHH4c6ynjETYLGDMiGZ+A0Kac17AnhTSHqBeKrKYtHC1m3RARY+FXi00Q6wJoPD4ajLGMQmBk8mcIwhqEdDTHEgaDZvUJxtpOYJIntudVIuoHufzY+QHNoyc2UI0CS23Gs7ywkiIgS1bjuAQGrm+kiktoXBJEZqXZ3c7amozyde0Mna+3zn7zLG6tr40iK7+L2XvcenaPbgzsygzS
X-Gm-Message-State: AOJu0YzntjgFaCSCi/zsHZYGnHbB5bsM6o1sXDrp8EcoVdBWE5v9n+YS
	cJuX4zO8dn0BK+V2C06zssVz19SCo8l3UGXW0B+I0Dc+H/m3a0Dv
X-Google-Smtp-Source: AGHT+IHbFk/N9guTteitPafMYA5bav92kY4dltbvdi7nyN6glbatnc04gQtL0rpO2VJnaOdbsFB4Wg==
X-Received: by 2002:a05:6a00:1792:b0:6ec:ee44:17bb with SMTP id s18-20020a056a00179200b006ecee4417bbmr6445854pfg.2.1714054747037;
        Thu, 25 Apr 2024 07:19:07 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id go20-20020a056a003b1400b006e6233563cesm13162397pfb.218.2024.04.25.07.19.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 07:19:06 -0700 (PDT)
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
Subject: [PATCH v4 07/16] lib min_heap: Add min_heap_full()
Date: Thu, 25 Apr 2024 22:18:17 +0800
Message-Id: <20240425141826.840077-8-visitorckw@gmail.com>
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


