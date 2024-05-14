Return-Path: <linux-bcache+bounces-441-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A45BC8C4DD4
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 10:42:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E6771F22B3F
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 08:42:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DA2D1DDF6;
	Tue, 14 May 2024 08:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j6gv49mc"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2191A1799B;
	Tue, 14 May 2024 08:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676154; cv=none; b=Ik3ijEBC9/VBOk85bsGhJ36GuJPcUaVXci43XSrsyFJbg28ltI4/31/1cwDzaHgB2MH79SqvP2dE/bl+qRI4HzaXWPKaknriWYuwuWJAlFK7+y2zQMmx8xu82yNFMp5h+lVId7a1gFnm/6Qc/01TY3lgGIMrWK3eV0bxCSG3YoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676154; c=relaxed/simple;
	bh=UN1Xetleeq5Nz5tLKfuxk8/opVO9kM/FjVJ/CVGswXI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NksaGIogc8baLbsujXb7CQPX0Qx1m8UYoc3yqg0mRaIOigXt1AhoeZDK5DKI71hoZAdZma+cJpLJ9X23DwLbSd+jISiOK8ShC6NvT7ybPj/Asql4wgw8dBQxM4DWu/yX4QuhjB4AJQr98w6bcg5ab01xpFRpjOTAmVZ6KMPOpcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j6gv49mc; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2b8efd5ee5dso529214a91.3;
        Tue, 14 May 2024 01:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676151; x=1716280951; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/7grr21+dk77QDv4Gfk7ePfGBs40BXM1/CLzaulLK98=;
        b=j6gv49mcQ+RSx88xaF1YBosa3sqOgo06gd1o6fy7ytVprR6FGuCyDC81hck2XizBds
         DdCD7em78PTe8PIOLfyX8UIIY23GFNOux15o7X0vbr78HrHTZ5NNBWUpaovOesIZ+EzJ
         R6KoNEmG3XqDROVzx28aUU7wCLpGBXJ4h63an2ekb1cFzZDP43lNeZiPd+IkjFjgRmCx
         nfYbmKzUjCQPfYIcBJlmDxta+JFR5Un+n6upnPFz0yIaJkH0Mx2QRTrOZY+jBvKgId0B
         ljdIiKCAAU3rRvpHH/ELA7mICJSDYg6evp+qMxOlUN2FxWXt43kXWfClQsyxBCq3dePI
         JvYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676151; x=1716280951;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/7grr21+dk77QDv4Gfk7ePfGBs40BXM1/CLzaulLK98=;
        b=ABEGwQQoWkKGpXsp/JF3KyOltcSaRP25oVNXYj24B0SAKEQSa0jxf18v1k737nU9l1
         BNSMk/BSTXS8Zb76XLg5ifSuDdHtCnfNWLfRyKOlK6xm7wYg1RmVS8Darb0hD4K5ATAN
         ybQr9jXj7W+CLtZAUWFIw//mLV7Qp/SIaHkZ/GGcbikNni0HHT6J7d5YKDjkUjCzs1by
         KB/6uVP8tU5waQyWob/von0AHrZ8OWIk7W55Vn+ioAgKSw1Jrnh+dDU4O1PtA0Zx+oBb
         N1oEYHJLUY6E5VqpP1YHcHWJmHZwTWEX3l+UUlDMFPpIhxjsBSIqqlS2TD67Ekvit+1J
         1OOg==
X-Forwarded-Encrypted: i=1; AJvYcCXqGwWzbdNh+kgEv5CIV+yEKu4zjODTCfiiC/K2XjCO4gd3ngPPxis2ovczmTGoWh3Ivacpuz+T0NC8RUxD8ut+H+6FdDVZTIEQEQhiGLcF0sWsxdNXIUfpYD12TZttficwu03PoRhYS4/wI2K986xbriJMr8+P2XSkAaRtXZj+O80VfDnD5DMtOkea2UOAmqtOhiA4+RFfHWKd4XjoyUGYGy/rSFOIvVHbeKRo
X-Gm-Message-State: AOJu0YzzWevW9o7N3blqd2mUeKHt/4lbbhntO7ghpu9QB22OjScX8U+i
	EJRiRhXhJBmFnz40bcEkYIwQAcqTc8CxesjiuUMixaxVgO5KPUZU
X-Google-Smtp-Source: AGHT+IHMszeOY4aAAdI/i4ffwzMWNliSsPw3Q+23+WsNGHJxJXzXpy97GENiceXTiX672LAowbBt0w==
X-Received: by 2002:a17:902:d507:b0:1dd:b883:3398 with SMTP id d9443c01a7336-1ef44059da0mr141304555ad.4.1715676149503;
        Tue, 14 May 2024 01:42:29 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0bf30f96sm92411045ad.179.2024.05.14.01.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:42:29 -0700 (PDT)
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
Subject: [PATCH v5 02/16] bcache: Fix typo
Date: Tue, 14 May 2024 16:41:55 +0800
Message-Id: <20240514084209.556112-3-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240514084209.556112-1-visitorckw@gmail.com>
References: <20240514084209.556112-1-visitorckw@gmail.com>
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


