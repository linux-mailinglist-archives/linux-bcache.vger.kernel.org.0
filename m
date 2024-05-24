Return-Path: <linux-bcache+bounces-486-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E7DE8CE814
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 17:35:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FA751C22560
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 15:35:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F76E132494;
	Fri, 24 May 2024 15:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GmM3o9zS"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8914132483;
	Fri, 24 May 2024 15:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564672; cv=none; b=QmPs2X6WVhfRQBNZaYw4y75n1vrGfgepgsyqFVZdMP/oOK858qYyNHeXbsfTrYvn0rbNwWiPUBMGQO1Dle0kIN3oteFH8LJOEXOTC7WfLsGBE6PFjvkZbMwdsUs0i2Z3RSow3k4dzQb5xY+F46VOde/qr61sAADB9Wk4BdB3c6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564672; c=relaxed/simple;
	bh=77HUtebVrJzxuUnhxHqdoyCrlqlYVs7r4OSNokoaFRU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BrrPsPUWeaYKNsyn05vBXt2yrJGMyM3hD0Sw2zzp+JoNjmDT38TK64Xrh2U5c6WReQ/Mo4za09MC1vSbHWRqgR/7SB/k6wVfrVKipj3HRH1tSuHq8AozSVJ0WLh5iMLpKt575TGz5HcLIEexzhhA4vCMp8CxS/6iX7umcv0QDaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GmM3o9zS; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2bdf439c664so314861a91.3;
        Fri, 24 May 2024 08:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716564670; x=1717169470; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JeiLg0XMliHOkIglYnFk3DvCIMxfANwaibZSEhPQVEc=;
        b=GmM3o9zSn15kPTaCsWavxPrfFkiZFrWPF4l5WHJhPCIvrxCjPbaawtwodzBfUviywB
         c8C7OSG8o8+RMcZCX8O+NmOO+msU4ty6KBTbQFK2wWuvc2JFUpfR88i/lK/XXbZae2Rc
         qaMpGaDgomlx1upCi1Na9PQ6xtxFPQrqoVYv64DP8p2b1zSI3dBOVpuHhv3Y6Q/fxjbh
         rsHswsWWkus2381hEirmaB5y83sGXCnwMLJKd5/dq+xkw+gnE/VEhFiq+RZUPBBvs/aL
         VK1Tboa8XlIz7BAu7sn4Hrd5BGvMZ+NztWqWEDPXNd8JXFn84E5kJSyMY2sdBLmxOME+
         dg2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716564670; x=1717169470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JeiLg0XMliHOkIglYnFk3DvCIMxfANwaibZSEhPQVEc=;
        b=B4rUsaBJe/rGhxzIuUsMND5z4SZaY7XKz0/zNgTKp6zSz3oJEzQJomI4SuG8WsAqi8
         Tx6ORfF4FUl+tbfSYnnXt5QW4uUEqReiSa7yvqEcjzoMHyva0moqhQehAUfRWGOlEcdj
         womqowgCi3Efw5au6nou8UBQVtPlt95+g4yMIqXRa6dbetNe7fuRt2zQfL/NYKFpKj7K
         +gFwW5ret2/xcH9lRvF8vhbxiFH75aPOCA7AUXTfWZS34nf5F2t4X42kbDzQil3ofP0N
         WapBUuQzReeNSkginDb2nARwWsMmPqkgWPMDjp7qOt40ARZrwdgRdsme0Nb18q0ND7Q9
         KQiw==
X-Forwarded-Encrypted: i=1; AJvYcCX95IOpv7PL+RMgYF/IZktTVjpqMeMq0YV+5pJj4A8huL83LkP8V7mx8MQwac5tCST1PI5EKIxsDSfHfmfJ/GQ9SxLyMTxj3vYYasmyZnc8/haolKcOJEZYTITOhDUJCRRxPBhuDB9nu/bIdipXEkxJzPjuMztlMjpOoALBPtl8xQyS9qadtd8UclnML35gz4ahvX2jKXcyzl0IKj+UOzxi1bPPAGZTb/ul5eNi
X-Gm-Message-State: AOJu0YxOKSc1ToVQGtqhuGrCY3TrFcWQivDq/584xeYSjOh4QOet6ODO
	NfTZTUSD63JtkPX1qjSUBOxDU9RIPckgSZMLoCXGRE7uijJx2+gN
X-Google-Smtp-Source: AGHT+IHbcXWiDmwxfe4l1q+/LLknHHuRnxu4d+1rEJ1rLFTk0UBMcC74U6va1+XSc6Jx655Pg8nFDA==
X-Received: by 2002:a17:90b:8b:b0:2bf:7c50:1f6c with SMTP id 98e67ed59e1d1-2bf7c502036mr785217a91.2.1716564670052;
        Fri, 24 May 2024 08:31:10 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f50d294sm1525556a91.20.2024.05.24.08.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 08:31:09 -0700 (PDT)
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
Subject: [PATCH v6 13/16] lib min_heap: Update min_heap_push() to use min_heap_sift_up()
Date: Fri, 24 May 2024 23:29:55 +0800
Message-Id: <20240524152958.919343-14-visitorckw@gmail.com>
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

Update min_heap_push() to use min_heap_sift_up() rather than its origin
inline version.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 0baee5787247..43a7b9dcf15e 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -190,7 +190,6 @@ bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 		const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
-	void *child, *parent;
 	int pos;
 
 	if (WARN_ONCE(heap->nr >= heap->size, "Pushing on a full heap"))
@@ -202,13 +201,7 @@ bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 	heap->nr++;
 
 	/* Sift child at pos up. */
-	for (; pos > 0; pos = (pos - 1) / 2) {
-		child = data + (pos * elem_size);
-		parent = data + ((pos - 1) / 2) * elem_size;
-		if (func->less(parent, child, args))
-			break;
-		func->swp(parent, child, args);
-	}
+	__min_heap_sift_up(heap, elem_size, pos, func, args);
 
 	return true;
 }
-- 
2.34.1


