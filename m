Return-Path: <linux-bcache+bounces-407-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D5D58B23C9
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 16:20:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B083D1F23CB3
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 14:20:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F37E14BF9B;
	Thu, 25 Apr 2024 14:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PY5QkQkE"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B2114B08F;
	Thu, 25 Apr 2024 14:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714054727; cv=none; b=C/HiddxS9G5vcFhY8U4+HFrpuVlMiy/T3TZzTedxI8CtGUsMTD0epgG/KS8UzwLkmWWPuilAzQE2pAK7RrFc8bOLajWG7QBF9Nu7OM+VautiL9Te04MN0PI61hqNEvnQ0DbiXT+kG6fQuQldSy+OCgg1nxyAoBJ2NdSOYoGoXvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714054727; c=relaxed/simple;
	bh=UN1Xetleeq5Nz5tLKfuxk8/opVO9kM/FjVJ/CVGswXI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cchGpGjHvnS0qFM+iJQgCmlAD3VlqcqK75hgRhE7XtVs9+8si5JjzF+DBuQRtHAWLWC0PMS0XpU+iLivLxgU5xlfeV/GOHwrloJFdCFYsWWLr8CfPjcVzg5bdUUgqESlbG5yON+TeNqorFd8Sk7WykiV21KOPvnnEW2sygGh4dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PY5QkQkE; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2af71daeec1so279645a91.0;
        Thu, 25 Apr 2024 07:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714054724; x=1714659524; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/7grr21+dk77QDv4Gfk7ePfGBs40BXM1/CLzaulLK98=;
        b=PY5QkQkEbMlCIyLkp7UL6aA4dQvBNyAA6ZXOqUqyEfjhC1uqotPo3r/I0Gc3GqoCrW
         8v5VZHPjGrG8ax1TkdwuZIHrATLGi9VQeCgZp3gfxoQVJXFA7+N4doR4Yig5HjXgEROJ
         WkrAtj7zauB+Cs+JAldbyxeoUjWEBDNoV+ZrmRsM5ORpPqzxgLuNt7Y7EgNHRJmKfSdE
         zwFWqItzicgsI2YjXBbI1KxVjcROfgpmIUildGcBu6wyY6VJWioNDwTbBKmSrrD6Tkb0
         m1ENsStgacUiAt1NiFNtJLilUgmw1yKTAzrDWWs6iW5kGxt/bHySQg2MlNMQkZsLjIaY
         /KdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714054724; x=1714659524;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/7grr21+dk77QDv4Gfk7ePfGBs40BXM1/CLzaulLK98=;
        b=MUKDfCESSut6AUzH5yCz0fcr09buW5JWfIutINNuT83AI9ZWJiK/bUKOSDDkLv69yn
         k+ZCGOe9ipP/cVjyKSR0BQZdoTQrtT05FWkwTh9/buunOUmxwn6iDbrXieww3MM+GxlB
         1VMcAF7qOJw74XH3jtGSBK+XLflMQGZ+9cA9kOx4/u7lY/oY0SbZcID0MKQCjZlFdeOC
         0RFdi0uH3xgMq8/cbEWz/i4SsbJrGXxvPqT2s2NXmujf3ajBvnzxuwTc27cL+r549FhO
         5bjVJtW3sGRmjN6YsVKiLo/Y75rMbX5YpWWUem2+eSfEAyuq0qBbKoDD1eQA+GUJ2Tw4
         xLIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVkyY6n1B6HI9P91VP1xoMVhBXUwRIBRrLXYlP3cWS2CQ380Ms6KjfZyIb8J55SgIwAz6I0cMK4hl9mFCyriPUkOfZZXVT79HMn57DZiHCSzulytrQFe5u7774M6xa/zj+XVDzer7jIReP5yKERJKauf828jul3KZIEfJnWt3BV5nYHZWZa6R8ezEpkej1J6myLbBF67r8fXpnO+M6JtWanhy8E0zOdavAUPZ8T
X-Gm-Message-State: AOJu0Yxg9jO7JXPpEbkejTOBCf+7YJaK1F4Sk1h9Y0pVwc3JklT7WLxO
	wFiU7yDQpzdxrB+8Sa6PUnyh7rLpbPTGD6cFU9q7Cd9wF3qzckkr
X-Google-Smtp-Source: AGHT+IEQD11OltUE11ifdg6XbUXWB+Wv3EwPvaLgQGSfd4UJ7AD3kkEQJxgz0+FjABEIMkzUpKhT0w==
X-Received: by 2002:aa7:8d15:0:b0:6ec:f5d2:f641 with SMTP id j21-20020aa78d15000000b006ecf5d2f641mr6842102pfe.1.1714054724050;
        Thu, 25 Apr 2024 07:18:44 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id go20-20020a056a003b1400b006e6233563cesm13162397pfb.218.2024.04.25.07.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 07:18:43 -0700 (PDT)
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
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v4 02/16] bcache: Fix typo
Date: Thu, 25 Apr 2024 22:18:12 +0800
Message-Id: <20240425141826.840077-3-visitorckw@gmail.com>
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

Replace 'utiility' with 'utility'.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
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


