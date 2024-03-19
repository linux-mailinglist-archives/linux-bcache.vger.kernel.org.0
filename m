Return-Path: <linux-bcache+bounces-306-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FAD0880449
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 19:04:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A4ABAB23F84
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 18:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC52F60263;
	Tue, 19 Mar 2024 18:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T0BZ5/DP"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193385FF0C;
	Tue, 19 Mar 2024 18:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710871273; cv=none; b=uvbfiXWQXkG7ljnZd+R9QHT3n3nfU9pVW+HKKQtoeQIEeO57WRcXRJovHl8DnG/md8EoKDuvOtUrShidFtCsvSIwSJeWitrIR85SO0uEpCioNqdTK29CbSA8DJBzpiCsASKpGV5aCYGMR5XCO2cHj38M4oDHwfjdg67BnNU7Uh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710871273; c=relaxed/simple;
	bh=zN440LBYznGYuwtfOCQ791ERSZb6vpOQUzA6Ge0oSZQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dvdeeHvf06WXDKkmEszRcr75Sh9zc8nNSmdjdZAxnOwqVLt06Hx2abJn0CHzTG+DexcOMR2XYv9eVUCBTnPMxcEEyhlLS8uoQCjx2D6bPacWGz0DDklMHaF7KkfdgHApwl6RrL2bzITAiwUevtZmhbzUuz/DT59/DdINA0IBwkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T0BZ5/DP; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1def81ee762so8054205ad.0;
        Tue, 19 Mar 2024 11:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710871271; x=1711476071; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EpLdHE6T1HFPzXRXZUEmHqfSXSlfR4maqjXPuXkrLoU=;
        b=T0BZ5/DPV51IZc+InZPeOzUyhrZu5sH4Audvl0rVoJQ4jfG2z+F5s4FfjRhLmofB+t
         Nk2ApwBRy1eG69PAWUSVfyJdWp2Gal2dsZFkwD81T+LysrRa9CcllJNwM48C2lSHNYl1
         F3BBqzCWQDt6jRX7Vk7+uQNJzrS5c1mwpf/yukqUOhJDF5zuwRo6iludjwfY1Wn7DSbk
         GxEoMS8ao9+KIPv9R8r7mH3ivj19IWWiI77K3OmSO9/OjpuagS9+SzfXUy161ESoNaBZ
         mFexFvrbBXlshRG21pef94HbcyEK3kxUu7f7JnEpDK2nt0lMjvrlG0ne8A3faykft+1J
         NtaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710871271; x=1711476071;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EpLdHE6T1HFPzXRXZUEmHqfSXSlfR4maqjXPuXkrLoU=;
        b=oc4/9goF1Gbtb1nLoot5EsD16QzxT1nofXEjuegIZmVPp7OTCTsQzwHPeshaS2c4RM
         m+sU/1I5cgQEnwUFxsl8tDcbLN3LQ2anOeq/7W5o34e4fAqX2rNpgy+KLhjmaXZQqnAn
         PY9erin6+gi4sE+FISpmkS9SfR3+pC0yevpyhvsiSN3wyIRZobM7ZBY1INUM9nPTcGYm
         jtNksfdMr4J/JtTyPtFHoYcSfia8Hn/n40aaqOMpHeuWQrO1aB7nBDzaM+oFC3u0WYwR
         mAxRKao6woRVb6MVGUATEXVTg1C46Lg5H3KFIDSSBknU7RexVuNwDsvDnADjY7c1WknS
         Fezg==
X-Forwarded-Encrypted: i=1; AJvYcCWIUOrBm3r/boydDo3mm78qjQSgempEudYnMNNucugbSjmgvXOHvCmHLZ3X6Qeyhv/QFugtyN9oL9v+Btzsq2tQyLDrme/sXOQWY5OwScilYU4akZBwwjKMywSwAtz9CMmo+sTi3Nddj+RueTURYHbKDtoTrjSZAVoaz9oENEVI4/IOy7IoNak3pa4PE4YWDzTfBG80Y00Wic0hnEHmIjnwYzxJPWr78/j+jorg
X-Gm-Message-State: AOJu0YzRrlr+mD2ZenRRF4hZovC6bXnjTGMTlj0LX1IKQUDnWSht588K
	Uq0GwjE82jgIdJQIZZfVQzN6KZKZquHtdxor3DWSYhr5Gp/ZMPvC
X-Google-Smtp-Source: AGHT+IGw1tSDvoLNGEGY0M0BpGhYAxmYXXUZM6IM61Eb1OllvzIJtHYB3YwGJRIcRAUGbxId1L1ZfA==
X-Received: by 2002:a17:902:ec8e:b0:1db:ce31:96b1 with SMTP id x14-20020a170902ec8e00b001dbce3196b1mr3201058plg.6.1710871270937;
        Tue, 19 Mar 2024 11:01:10 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id u16-20020a17090341d000b001dd3bee3cd6sm5531359ple.219.2024.03.19.11.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 11:01:10 -0700 (PDT)
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
Subject: [PATCH 12/13] lib min_heap: Add min_heap_sift_up()
Date: Wed, 20 Mar 2024 02:00:04 +0800
Message-Id: <20240319180005.246930-13-visitorckw@gmail.com>
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

Add min_heap_sift_up() to sift up the element at index 'idx' in the
heap.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 include/linux/min_heap.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index ce085137fce7..586965977104 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -199,6 +199,26 @@ bool __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_s
 #define min_heap_push(_heap, _element, _func, _args)	\
 	__min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(_heap), _func, _args)
 
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


