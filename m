Return-Path: <linux-bcache+bounces-371-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AAC089AC35
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 18:49:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55B25282017
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 16:49:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43CE74F8A2;
	Sat,  6 Apr 2024 16:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FrKBeobG"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F0950275;
	Sat,  6 Apr 2024 16:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712422099; cv=none; b=UK/lYNQ/8MLUNgruj3aSiMGIwxP45ny+MMiCrZCtGZhH9ZRRHiMiP8G3SBd33pePin2KTFGTE5DIx12kXP4xorxbHKyQCkUrM5XaPhwgbNM+ZC9TiS/HOZOPDcdUtLVBJFjCJh1Lt3urShKUtlaCbjN+aUJC+T78J6zoEjBXLCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712422099; c=relaxed/simple;
	bh=45DqO8bF1UCi5bfdHVSu4s8AvmjNFknYLPsfVsf4ic0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Cf2bqztRM7EYsA0sHXgwG7A9uJD+i4P9BrRrzyV/NwFLHA1oz0M2KQQbtSCCJVOiPXgpV1+Btr04KyzWVQw9NespkcfjioO0wI7TtXaRCHq0jpKnGXCE+THVZ8fafylxydD4TGXOQVN+I3Jm2dLAjSGo1smPrYoqVmr7HWhKjgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FrKBeobG; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6ecfea4f01cso484106b3a.0;
        Sat, 06 Apr 2024 09:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712422096; x=1713026896; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vKi/lHC5XFLRvEUBusUUTA5MCG5n2IA6GUULUt/TPRk=;
        b=FrKBeobGpvxDStCPzJSZgxbXcUBz/d3D7ddH52D8eln8/DR4lywyCros0oMIZozVwp
         GeyjzLKkLrR46Fm17YCcE9D+kwI5R3NdijM/RS3pHb3NwcMLDdbWsNGf/YyZiPoxJY4C
         uuPN0yNib4TOdGMa6Ym+C92ADcS2EDEPInynCZSs1JRNjBP+0n6BIBOWMV/Og/1vRp+c
         Z64+7lX43R9t+iswGamhmXTXyAhtQ1C2ohvWs1RAM67rPpB3r0cA2Kg0XCpHfotDNUOB
         J2Y8nc/xtaXNgdkVL2RMVI7Jv4vw+fdwu1gG+t30TWUgsC7hpOkInTUNUtx7HMGAmNhl
         P3Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712422096; x=1713026896;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vKi/lHC5XFLRvEUBusUUTA5MCG5n2IA6GUULUt/TPRk=;
        b=LwvA5nXc0dfxn+HvqEIEo/t+pdNY89LaQ3pNy4WtHThbH+B7eBEPp/QDrMwSrP+L2C
         yHHAD5JN7XQ0pXexsd/rPB/PI8fiuySFpCbfbLS1x3mQ/6dd/kWeEX4syLpMnXdDj2W+
         u6R079ViKTgS5Cu9PkRgt8e4fEZfojgjF1MTzZjtxHS1oioWXArWXII6InmUgG91Q7I1
         mU/qCjOSOupXJ411JhAHCMO6dMDC9u4rwNU4goKZl/HQzyhs1I0n83HgZ7H0ZqAcFy06
         LxM9zPk8db7FlGDpiucshy6uWVvS4oyXGuA3CfXFgvSAxaTxRYCu58WPGnDElU3rOCXd
         jvuw==
X-Forwarded-Encrypted: i=1; AJvYcCU6LpVkX9UZQYVVFA4TdGIVQ/bBEE06bsrDdL23lfKnRnyK8elWkGZf7hLRjJWlXnCRZW2wQzLFTS/fKqpo5ewKvriiXR/7rD4cm4FS2owVznRbQPcoJtWFbzEkcMsZHJ57NRe4zEIvf9t2gSBnd9V9/3xxOrkMJJy20OJlSAZqE+PyUXQIbYTJFWnke3mm8yaW+7jOqCoCCcVly89da9vTeRjrONYJWg4uXUNE
X-Gm-Message-State: AOJu0YxsLCjqCDElB3T/HIuqdkCLu+HdXzqDjT3gS5JptBV1vDIdatId
	FJURgREOZxVv2DYBDbq5xNmETdxrh83kL7GA3yWAbvq5okqyeiHE
X-Google-Smtp-Source: AGHT+IENEdTgv8ntqVO1lAQSXYbpZoDkpljQUWa9D+grA8nMWQft+HCdVeMd2pRFMDlJsaRZRQvFGg==
X-Received: by 2002:a17:902:ce87:b0:1db:ce31:96b1 with SMTP id f7-20020a170902ce8700b001dbce3196b1mr5553914plg.6.1712422096122;
        Sat, 06 Apr 2024 09:48:16 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b001e2b8c91f04sm3665068plb.22.2024.04.06.09.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 09:48:15 -0700 (PDT)
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
Subject: [PATCH v3 07/17] lib min_heap: Add min_heap_full()
Date: Sun,  7 Apr 2024 00:47:17 +0800
Message-Id: <20240406164727.577914-8-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240406164727.577914-1-visitorckw@gmail.com>
References: <20240406164727.577914-1-visitorckw@gmail.com>
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


