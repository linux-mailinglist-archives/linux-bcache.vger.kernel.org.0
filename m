Return-Path: <linux-bcache+bounces-296-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ADC48880426
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 19:00:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF7271C22C02
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 18:00:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52C7C25619;
	Tue, 19 Mar 2024 18:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OdbdK5Ba"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66F02E62B;
	Tue, 19 Mar 2024 18:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710871226; cv=none; b=ccZduOeQzvpJAiCGHgVnP1JhnDRU85uhQcO1o4D+TCP1LMlLszZOFZ9Fub7ED8obJOndoyx660hWPfMuHjULEbZuYXl92BHDL1aevAuWnvfzIZHVgsHzz/OT45JaQoaSRbq02tr44i4lwgngNw4QdEpjOxEW13XBc1XTGZMrc/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710871226; c=relaxed/simple;
	bh=fgS7YoHkqd6Gk9OHy+FkIeSgxsebxOkghiQdONm8t5g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Jl2rs1jlTDkcZQKKQKrETP5awPokZqd3LlEq3ELZPyjkPlzu/yCodADoEHo6IW69UYuCMttg6WEHz7Iv2P5jo4hrgSuIK/kBk7FvJc15vuGGz3qjPDnJNlJiRkYtifsKCwkmzmCLI+XH7hUDewleU5jsKUhQzC146gphFb5GXpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OdbdK5Ba; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1dee6672526so5305025ad.1;
        Tue, 19 Mar 2024 11:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710871224; x=1711476024; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MhM32UpnGJPnLVyVQuYFJmPAIet94tyo1EZagEt6PY4=;
        b=OdbdK5Batpoz4NqNLwAmr1pS4IZfQB8j49HZVvcxfr1EnAaeODWR8CtDeL7ATqh7/l
         IwTcAStY2138KQtjWtoak7vHSt5oaSBVLya+aTUKZwhYLlbPHku701oGgn+twVAZnOm5
         hSfovGd7MPfNCApaKeTEcXqs8CndjU3kH2SvB7I9jN4gParZK23Bw7O6m65sWs6M00xe
         k67J5qJ+7mHm8EAJcpJrzd6nePn1MVYT+Gp/stgqSAMbtpfV0iYzGc27PUvm7ZXRs8Nr
         6gVmPDWY2aXYbCaOM98sbFOEKEqexEHU3rQe+fjrOKU77xOa7Njg2FjVaTsAmpMkAcFB
         9pjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710871224; x=1711476024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MhM32UpnGJPnLVyVQuYFJmPAIet94tyo1EZagEt6PY4=;
        b=ehfJBes7pvQ1R2wrPa3+M/YXMj3FFX69h5lftbLVBh7Bm+4FOSsdu/rzrwDDFdOe0k
         u7VRs3x0ZiiN83S0R8LJG2QyHx6eJLlELiX2PfGgvuIc6L6Eh/ZnpYAy1QEnTrp/rV2W
         k8lkzWckOImOZaWmDZoLctVwJU1KNrGisWdWcuOpgFzJQ18oZONF9VbtHTBjk8ZRMutw
         SdsojEA4qDpcH74YK87rUULDX73wqN6L7MKRfKkzr+1hWEwDwKUFhxEehcRsOY5LQC8s
         OEDxdsZ6oZ+sKw0bJAOGyqytwxUWIngGXrbHTZW6QVXGALTiB6G88Qjd6/pe0pewi4aC
         Ke0g==
X-Forwarded-Encrypted: i=1; AJvYcCXxare8wC1/K0B6XgLucw+3C+e+O+p8VzAYBFRzk6mYYhGmnhMbt5SuBjLOfF7JrqePnG0l6Gp3SoLnEd9tlujZTwsTTBc4ZqcSxZ1uWnU4HyRGdE2ywgW8Wdc1qMP/YJ4oiJchHlLYLBBL4BIiA6+OgEJvD+kCnzqOsKdnXoVl+Zw67XBPcQ9ILi3qmevadiHhoLz8FZzAqSSXvu0u42K/q2hzdRYNjg/8qjfx
X-Gm-Message-State: AOJu0Yxkgd0N+NsZjGCFBOb9ipNlI7ZbBasSpGdkxjPl72AFRu/kWjgE
	AOayYUgNVZ+xhfaGXIpEZchP0cfNhyO9PD2yNb9POz28VlyNREE3
X-Google-Smtp-Source: AGHT+IH2KN8j2I6RFIqMV16DYXyC+c50lnC7pdEn/IN/+1SE4kATVcjPSy+d91Y1ECfUYLZTXBbVKQ==
X-Received: by 2002:a17:903:24f:b0:1dd:7d66:bfc0 with SMTP id j15-20020a170903024f00b001dd7d66bfc0mr16665032plh.4.1710871223988;
        Tue, 19 Mar 2024 11:00:23 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id u16-20020a17090341d000b001dd3bee3cd6sm5531359ple.219.2024.03.19.11.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 11:00:23 -0700 (PDT)
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
Subject: [PATCH 02/13] bcache: Fix typo
Date: Wed, 20 Mar 2024 01:59:54 +0800
Message-Id: <20240319180005.246930-3-visitorckw@gmail.com>
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

Replace 'utiility' with 'utility'.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
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


