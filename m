Return-Path: <linux-bcache+bounces-329-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A06C8813C2
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 15:55:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75976284597
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 14:55:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 851BB4EB58;
	Wed, 20 Mar 2024 14:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GfAu5X43"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138B051C50;
	Wed, 20 Mar 2024 14:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710946476; cv=none; b=EDuV7L9fJna4VNPcPfHPdZjbfG/FRJsuDDA/ppIse6qYLDigy28uOM5AfEhyk/b/LDCFBQlEiwbUe1WziGcsCjSX30MsKyteIYZc2hCva016C1eBety5z6c7fsClTswQ2xBdjaB72y4nvhzz1hBqIMmMs3s9jJVXrvNxCbPqKYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710946476; c=relaxed/simple;
	bh=ccFsqSUbNmoZfjXj/UyIC9+OiMIUuYR/yY6H+xsWda4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MCl4J82Lw+nuqDaRHdHk5Ys5PfMVL7O8/UrTnhnke5t+WluDFOjHpVPH8LLMEn1y3YZczjlkERjjuqL6hiPRgc8/DUxbLAQU9473Cio8BDn//A54TuMwqHBRNmkiYFb0ZeNoEnQD7ciADoWFQGHULgWtGDQGJngZghgHgiAXZrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GfAu5X43; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1e0678265b3so617515ad.0;
        Wed, 20 Mar 2024 07:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710946474; x=1711551274; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vCMluLf0OPIP5MvhSlBnewMLss6iSf4B08EHRoBbLMI=;
        b=GfAu5X43mJ7Y1Rl4AlGJdKu9keWS5qNXHfXwdZsd6jrUyqFRz62I78y8BgIkVEM3xL
         4Ilf8tfIdSLx7wTtXxAa/IazxRNPMUAIMnoQnsiYLykxw2DG5poELK4VTRTnqC1KEVnJ
         hUh+Nhgvziy3ktM+D7KHG4Je0PfNjXUsKuj2wlngC7CdL2fDfIm0S5+8fSDhlWLmWOQQ
         xtaY05mLxaD5LVFaUFvGS6c5wNp2w/CmtjroIsha1UB6ea1TadG0kmvGloLYUIqmFA1D
         Av8WVw/eH2ajhSXJ82nOMsKkd4OeYqPdms+ZQO+XE6KGPMcuM0YLxGtkULFVA/Bj4Rod
         sKJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710946474; x=1711551274;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vCMluLf0OPIP5MvhSlBnewMLss6iSf4B08EHRoBbLMI=;
        b=Ef+yhBE31ePjF9l2Ur0m723jPoB5+UV6mwTDvrCW9pPCBy6kdIenOT4qpi425ScD1g
         scBItUNSH9uei0wGD4vE7IGcQZu0PyHZVLBgcFzoGboYMLxInAmOIdKlbFPa17InS5lO
         BSLKjNPworz4vYDV3wOXh+KhKoIATJLbzEkBip6Wsn4/QfnGD34+FaGB2yz9L/Gyx9QI
         J6iINV2cilmfJ1+VHVZ45dw9n/gl7ijNAl7TZn6sZCw+2u/QV0+vcg4YG5Py6+PFGdK9
         b9nc5cnmoHIObGdmilJR8XWRq3vLqO8U4z7p7LYIBppCUIvmd2n3iCbPeiuLDEkQV0Ox
         hBdA==
X-Forwarded-Encrypted: i=1; AJvYcCW9k2AAfoMPvFwp486GcktfpjV4qFLoJqyegfqMejs1gRq2QHHTtP9zQ0UEogdCnSLKcE5gReSlFG+sDAiZ8EeZLwYVYeupiZ+30JIp3u3qmmFjj0ZENprXzBOaBm8Q+JYI7QjemQRpE1X1NHUWBgZV+aBuFCRtBrntpR/0jY2EHNbxsQ7B1ciEi6djpsmlb3QAKmiK9gC2GSmaGY4wB9wAWsbfoSOFcSmR4jhk
X-Gm-Message-State: AOJu0Yzs2+os9HGvAcUzviFJ16Fhnk37p+TeGiufLgMGbwT3rA0Xt5jr
	vWSe3qF0rNHwpyj2hHMPBN+ZOHLPC/ARbiKOfOFQXeDH4zo3kW+jeJE+501l67w3tQ==
X-Google-Smtp-Source: AGHT+IEnN4HYZbE2rHcsFmRm8DkhdOasT2m/ZrfFc02i9m2gwbsINOw3gtS3SpqFPr7j1X9xPow9nw==
X-Received: by 2002:a17:902:ce91:b0:1dc:df03:ad86 with SMTP id f17-20020a170902ce9100b001dcdf03ad86mr20347085plg.2.1710946474388;
        Wed, 20 Mar 2024 07:54:34 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id la11-20020a170902fa0b00b001dc30f13e6asm13719989plb.137.2024.03.20.07.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 07:54:33 -0700 (PDT)
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
Subject: [PATCH v2 02/15] bcache: Fix typo
Date: Wed, 20 Mar 2024 22:54:04 +0800
Message-Id: <20240320145417.336208-3-visitorckw@gmail.com>
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

Replace 'utiility' with 'utility'.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 drivers/md/bcache/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
index ae380bc3992e..410d8cb49e50 100644
--- a/drivers/md/bcache/util.c
+++ b/drivers/md/bcache/util.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * random utiility code, for bcache but in theory not specific to bcache
+ * random utility code, for bcache but in theory not specific to bcache
  *
  * Copyright 2010, 2011 Kent Overstreet <kent.overstreet@gmail.com>
  * Copyright 2012 Google, Inc.
-- 
2.34.1


