Return-Path: <linux-bcache+bounces-445-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A36248C4DEF
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 10:48:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2AA11B22A6A
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 08:48:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD5FC21360;
	Tue, 14 May 2024 08:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j9DHORh/"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862BF37160;
	Tue, 14 May 2024 08:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676469; cv=none; b=kO2Qv9k5yq46l74LcINccov3JbIxAnb+ZIayk1nE2Ux6gXpcJznLUdDoBVqSp8MrNFuophXyZZONlxnTXL9H8MDL725X5Bx4sgYspuj6x6MUShaXEwfD1OEny8cuFBxS0FSVd9Tl8Gjwgd2VCMt7RBVy8Qaqd7Csw9ZMQVYBMys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676469; c=relaxed/simple;
	bh=F4H9nDZNXyr/ZsFI+cCJhr3OYw8PynR+1AAuPVXPV9M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dEqoDRY8YTW+f/o8CVMyvXtF0obF1VLnwZMxgTIRXSnN4wU/rlpmnuLAhNlAn11LrmG6mBlyucH7cdi1sbIHYxmCGoo459uv0VsHwHqUU/fKvwtf/x8axs/xJwbCeCtqm3y5g2ACNSZeFHe/I5NTwwMCN1/fdCrpOqZfvrDKKSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j9DHORh/; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2b33953a163so1332850a91.2;
        Tue, 14 May 2024 01:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676468; x=1716281268; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6mL/EL0d7nL6m0RFDxHa1SNm7xjXj5OmWxYW9IhbyI0=;
        b=j9DHORh/TfBQfUfCmINWevT9ZjTENN8quwfAKqCtL1kB/Z/tJCl9GsNA0T3KKph2vq
         qX+9qaxGWozH1GX8fFu9ZRrysEBxXbN3dzjrE4hqifOk35RuOjjduLGWQ2iGqyzjhxcI
         1b84kI3ozwoSXSX93hdBhrqx+YuYRvB8QX+PT1MKcJUhbVqD8eDsRBfxA6E89nsqXC7F
         y7dEus1dmD/K1URdA/O8Hj6g7Fd2ZsCc5r1VY9smwe2Q26OjwwXgYG/32wKP2fYS8CNT
         P4SIG+IIFxDWiVbvb6c6Oct/B5fe0nCKif8f6KP7ajfuy5+WbKWq1mvxDXCydW6ntoJ8
         diwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676468; x=1716281268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6mL/EL0d7nL6m0RFDxHa1SNm7xjXj5OmWxYW9IhbyI0=;
        b=WIFS48uoWCQIrIaH/QkcffjFRAyzg6zQA3l1rJzYSB/EaOv+X518YYt8ml7LAE2yRc
         ZEajARNPnS6k1to0BbdXRPwlQAmzO7bmD2Q9C/C+vmGffqS0zNJq/EGh9KW3bc+65rgy
         5DOGqu/nuPzssZch6FllSe6wat4/w8j3EkCs/79vRHYlmqt5VeQlY58rGJRhbrFqpSyR
         SNpP7PR3KAxBSn4qnXXJXq4GeYPFo7B0EdL+AiP9TNyro5/ebmdOUtnCSNGYqH6kNlS5
         1Vita+5nLtamDv0zCdWM37P1/DPjq6vmNRRoSHDEETwJ2Pun5bcByYu6QJyazaGCx4BE
         NljQ==
X-Forwarded-Encrypted: i=1; AJvYcCWVg5MsvxaDf9rIPj2aYTZ0PqwMpX6uUcnBdxpLWu3VcwPEpizbDftv5EzJHxfveQzTX7hl6lyWFuIs63T7bbyXIwNtNj3lgTB/g4Ns2eFWvDj6WWd2L2nyK8KQJDhfnI8MKUJ10Hud38c8ED/aLXEi7t9VeSkmWUMeHL4L/t/JDNrhntM5LTuyeUzZbtKZQKkExljwyXJVD28Gtn1TxpPvplW3L6zyVwVD7OBU
X-Gm-Message-State: AOJu0YxxpDKR6NJSh6gH1vbgVgUeMJA/3PSo8pGfzfEJTns0O1vRwWC6
	nvtIXR3Vel97ZmWeGmGH08iHq8HyCgMI3Iw7tZHi6P8gy7crI2Bj
X-Google-Smtp-Source: AGHT+IHT5Fm+YDGnCec0X1e+f4cxpGHHD4p8mj7Rb98W/3AbFrtGCShFZxSTzr0614+V0BxS0fadUw==
X-Received: by 2002:a17:90a:bd0f:b0:2b2:4bff:67b7 with SMTP id 98e67ed59e1d1-2b6ccef5a6emr11238648a91.3.1715676467913;
        Tue, 14 May 2024 01:47:47 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b6711660fdsm9195597a91.16.2024.05.14.01.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:47:47 -0700 (PDT)
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
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [RESEND PATCH v5 03/16] bcachefs: Fix typo
Date: Tue, 14 May 2024 16:47:11 +0800
Message-Id: <20240514084724.557100-4-visitorckw@gmail.com>
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

Replace 'utiility' with 'utility'.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
---
 fs/bcachefs/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index 92c6ad75e702..05ac1b3b0604 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
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


