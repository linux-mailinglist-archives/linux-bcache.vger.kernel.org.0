Return-Path: <linux-bcache+bounces-378-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D44EF89AC49
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 18:51:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E94B282622
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 16:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CE6B56454;
	Sat,  6 Apr 2024 16:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FO4b3Yok"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF56654902;
	Sat,  6 Apr 2024 16:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712422130; cv=none; b=h6YdSLy5m2cVr5w4ujCmPuSlbvhspz21MK5ZClraUCb15Pc/C9Uekem0sOTd7Z+qbJeilVshPKRvxwH/l++64BY4OBc/a3z1Y2tm3de/w4LoxJHBYUL3dsddrlOIp+7x01ezmIjyb1I1de9UiYC8OfNoewhAG1K/jPAVOFDjS28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712422130; c=relaxed/simple;
	bh=cUOXm8PUXZY6Fju9709/MeuRssUa9uu6mwCwvhFly6U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=koxH7+gZvAXJp/QZr28at5OFK65yEcR2+D3p9ceBVG5jm0FnChVbpDWyeg2iszmE5EvL5TdDFdX5MuO7W9FOommmt7GzVQkBI5cJVjADXZkKqkVcsNu7BS80mcmirUzPkYmaYItpupVQRe86z+66ki3CwggqMIDQVAt1pDt1ue4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FO4b3Yok; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2a49986efc0so371214a91.0;
        Sat, 06 Apr 2024 09:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712422128; x=1713026928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AHNxZpx8u+XjZvJ2GIg35GcXEPPNsfxng7fyYMZIxlQ=;
        b=FO4b3YokEl7VCyFG0xd5D7OpJcxw+cAkRwOTQYZh0aFkX6cmCLFPSLe3edSJJngPfD
         Qh4O+w/ukgASE3o0ZsQMOIeokEg3lRHrfFrtmkd2VIoDNB2osYj9WqUqgKzv++pF7fYp
         zprh4EobzPYfD67+FJUNTj7JUDq3SDy58wDHxkKeRIWm0WNeVgNgwvk661nxj3SDzltV
         Bbgy0UI0w7CJ7g8wkiNTFHTmZiMY+72slGNW+xjfveGXWmULXoUBuFzzuwAVdf/ut9SK
         bzvU3dl/dza6L7CqATogILX6XIwGfn1IQ1Uo1WMBMs0fLptGzRCwYPaC0UrJSgXV4/fV
         1liw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712422128; x=1713026928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AHNxZpx8u+XjZvJ2GIg35GcXEPPNsfxng7fyYMZIxlQ=;
        b=DWH4Pr6qGQc6+U29z+2GWFHqmduKKXgH+y4l2QFIfVnhy1pTSMH8PwZqUv0dycy8JR
         YpjH+ZMkRLppL955ogiU5pL1bt/5wvrQFeltYTgDTxb+J0cRgAXhLeQ5DQmkTXCBFdIK
         7IPa9K/RP9E2SGm1SM8CY6UFaVU1PXpLXUNbIyY3w1pA6RdJf+6+OL8TeVMIekp3mrMW
         w3Lq6u0sW5NLTnLAOPEVTnkX8YM8GLWOpWWDqLqk+e/70J90rzy9r4/fwH3mflcpR7i2
         iEsQZQ5V+89UAB+H/8NdM50uidTJfCfzlMBQmx0mGwayUghgYAqkOA82MceHtUyvKLRJ
         q3Sw==
X-Forwarded-Encrypted: i=1; AJvYcCXzih6Dp7+5OviPTStSRsM0ti/iv2PO99D+yy8LpO0Qp+rt/uz6pHqowWHmEWjehnGE2EJidvZ3yT7C4Pjklkq4MWtB6DT3cpDr5bcK/AanxuQL9bZlRfBiAiOtbop3SPnlg44f0t6dHS9hdQARCeX56DB/MdRpi6xPId9Bi1BH9l3CvcvtMD22rQvPrXpZ9L1neaOwKkz/mz7g1Dthvj+MZ0Pz6Y6ocjR4jl1X
X-Gm-Message-State: AOJu0YySNTFiLKqxRFYk6sEjmDMADRzkv7zTo9nLw9GBqU+D/Uo+IK9I
	zC5oNWWBmjeZ5y+2u/pPnyUqMV6s+UueOxxYiEPNBI21K4igmUwG
X-Google-Smtp-Source: AGHT+IERQEN3/6uksLr3AQKyXLHAVa4zgVwAOUohwmgfNl0NRAk+e2fuL1w5v1WlyH3tZ6/U0YsU8Q==
X-Received: by 2002:a17:902:e811:b0:1e0:c887:f93f with SMTP id u17-20020a170902e81100b001e0c887f93fmr5627092plg.1.1712422127887;
        Sat, 06 Apr 2024 09:48:47 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b001e2b8c91f04sm3665068plb.22.2024.04.06.09.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 09:48:47 -0700 (PDT)
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
Subject: [PATCH v3 14/17] lib/test_min_heap: Use min_heap_init() for initializing
Date: Sun,  7 Apr 2024 00:47:24 +0800
Message-Id: <20240406164727.577914-15-visitorckw@gmail.com>
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

Replace direct assignment of values to heap data members with
min_heap_init() for better code readability and maintainability.

Link: https://lkml.kernel.org/CAP-5=fW+FvUu8JL+KrtVv5uC++4AW=VhyEOgmdWzpH1mswQNzw@mail.gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 lib/test_min_heap.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/lib/test_min_heap.c b/lib/test_min_heap.c
index cc7219b49ba7..67dd4f644f6c 100644
--- a/lib/test_min_heap.c
+++ b/lib/test_min_heap.c
@@ -67,9 +67,8 @@ static __init int test_heapify_all(bool min_heap)
 			 -3, -1, -2, -4, 0x8000000, 0x7FFFFFF };
 	struct min_heap_test heap;
 
-	heap.data = values;
+	min_heap_init(&heap, values, ARRAY_SIZE(values));
 	heap.nr = ARRAY_SIZE(values);
-	heap.size =  ARRAY_SIZE(values);
 	struct min_heap_callbacks funcs = {
 		.less = min_heap ? less_than : greater_than,
 		.swp = swap_ints,
@@ -99,9 +98,7 @@ static __init int test_heap_push(bool min_heap)
 	int values[ARRAY_SIZE(data)];
 	struct min_heap_test heap;
 
-	heap.data = values;
-	heap.nr = 0;
-	heap.size =  ARRAY_SIZE(values);
+	min_heap_init(&heap, values, ARRAY_SIZE(values));
 	struct min_heap_callbacks funcs = {
 		.less = min_heap ? less_than : greater_than,
 		.swp = swap_ints,
@@ -131,9 +128,7 @@ static __init int test_heap_pop_push(bool min_heap)
 	int values[ARRAY_SIZE(data)];
 	struct min_heap_test heap;
 
-	heap.data = values;
-	heap.nr = 0;
-	heap.size =  ARRAY_SIZE(values);
+	min_heap_init(&heap, values, ARRAY_SIZE(values));
 	struct min_heap_callbacks funcs = {
 		.less = min_heap ? less_than : greater_than,
 		.swp = swap_ints,
-- 
2.34.1


