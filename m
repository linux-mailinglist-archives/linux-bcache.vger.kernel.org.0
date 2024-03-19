Return-Path: <linux-bcache+bounces-305-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12FBD880444
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 19:03:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4591B1C22F93
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 18:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CCF15FDA4;
	Tue, 19 Mar 2024 18:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vm5+tbWb"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D285FBA8;
	Tue, 19 Mar 2024 18:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710871268; cv=none; b=KLu3gNQTG24cy8Mh3GpwYSSD1FeJ0rZjpLU7hLm9BX3pJWeftpWSOzxIyjMSgJayZqaurxvMLNrqqv1lfTxF0mC7b1K/C+37w7cRUKecIm8JQAu39E1/uFOGzeoktZ2nhR1N8GDlHzCNTw3Scx6C6m9CNUg3VpLdmIpFUU3S1pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710871268; c=relaxed/simple;
	bh=DaiE46aVxWHt/auXpAOLOuGHx89UIZWSzrLRvoly4ig=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tkc+HF6oD2OYfrAxd4j26QLOHdlWXpK4xCk+ybt2VJvf+FaODEFrMIeO9EiGUz5e6nqvoyOZqZFLbUVxd2EHwHZP3I5SuReC/EqFaQ0tKgLtTyHAKo2Aa1Ra2WL9jIKm1O/I2xnsdgKNERyeZeivBW1mWf+KYVO7biA16iYwoOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vm5+tbWb; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1dee6672526so5309275ad.1;
        Tue, 19 Mar 2024 11:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710871266; x=1711476066; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JIhnZ2ZNiWUepm6TjWG9gskFjBN2pbtB8loOlyqrj3U=;
        b=Vm5+tbWbVIQ4W71mvXYphVzNIWVtixlWtrO0kOwFGDncmn8Wd92DvmvTr1aF5LHV0N
         i1oL8qXAsitgCyZgesDT6Hp5Jte8uRVUTPnHcZTxBAaJKqz0ymD7MN3X9kOjQGEBiJ2d
         3Vu3StrUXSQWaZkg/7trhBVrbT6Fdp6hueWCnA4a3fgfzmUi7nKTviAbVMNMvZG1SFGK
         xC2ZE/LrrMiRABeOxC8kWnOlU9ibwXHVlTBLXWm6gRCBzASDXkW5lxXLo9Xw/E5c6m3U
         UhPLuZu5mNHxLMsjpYWiIXZOeGktj4OydNT+7kW7y580/KMHyt1m6wJnjdKiEF9+wBRb
         dQWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710871266; x=1711476066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JIhnZ2ZNiWUepm6TjWG9gskFjBN2pbtB8loOlyqrj3U=;
        b=BvNzRKr7JgTzVdMTFzx65rt5OSmL+/VP/MWSBwE8UWTL/9I9JZTKb18qXsdL4EaUnb
         UJuxwk84HxlYYxvScbdXkDVTRjgL6RRaBHN93dzSPdeM+8O/yyEGpl+6ciEXoaew9U7f
         lzJrtCwx4iIaeq0bDAiSDnvbeQpibW2gGc5EiPovPiLz8QE/p4+5Aj3rK3GLzsLk73Hm
         w6mVNaTdLs3rGqdKMIUSb//hEPS9KqKtvx1g3ONb04lpVfNxnXTuvbJ/os9nw4ZHuVNz
         Lmwrz9UiyqXLkeTx5QLAGIMF4oAB6slus3IUN3xJgQTJ7cOkRqjodoDzq+mpVMY/ZdBU
         99LA==
X-Forwarded-Encrypted: i=1; AJvYcCWc0rUxn4N7KjNobZloTRm8T8PN1mwPMK9kNvAPX66tznMmosBWszfAp9vYuQuzsoW32s5rVNRGG1paIP/6kgEik8fai7mm4qoiGwengJnvbVcmZLK1LnlcsYJmcH4Q+Q+O2tjQH3m7FrRvhVwqZPFaHrwLck8ZgMZhLIhmcHRAUCjLQ7b1iIIStdKWXKCp2+q4HbeAOntODS1KN6w2WyVbcaXOubn7nz7xPE2+
X-Gm-Message-State: AOJu0Yw0HMUMiaFL5Nxyn3mAnd9xPmbilnc4tyS1xB8NFllk3Qnicf3X
	N/LiGSBGAQPav2TmHia3IPqLSrny3YNy9EzpMYnN5vmvjWU56xID
X-Google-Smtp-Source: AGHT+IG0Z0ZjYaV7oFCEX12jN1Clo3Wx+9dfnihvM1D8PQqVB+cVf/xolig1GQ3Nnap/p/L4r1uyiw==
X-Received: by 2002:a17:902:ce91:b0:1dc:df03:ad86 with SMTP id f17-20020a170902ce9100b001dcdf03ad86mr17605167plg.2.1710871266314;
        Tue, 19 Mar 2024 11:01:06 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id u16-20020a17090341d000b001dd3bee3cd6sm5531359ple.219.2024.03.19.11.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 11:01:05 -0700 (PDT)
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
Subject: [PATCH 11/13] lib min_heap: Add min_heap_del()
Date: Wed, 20 Mar 2024 02:00:03 +0800
Message-Id: <20240319180005.246930-12-visitorckw@gmail.com>
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

Add min_heap_del() to delete the element at index 'idx' in the heap.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 include/linux/min_heap.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 154ac2102114..ce085137fce7 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -199,4 +199,28 @@ bool __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_s
 #define min_heap_push(_heap, _element, _func, _args)	\
 	__min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(_heap), _func, _args)
 
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


