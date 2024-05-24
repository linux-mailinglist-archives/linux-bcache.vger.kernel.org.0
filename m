Return-Path: <linux-bcache+bounces-475-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59BC98CE7EC
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 17:31:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C023AB22E22
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 15:30:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F26412EBDC;
	Fri, 24 May 2024 15:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GFZgBhED"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C48412E1F0;
	Fri, 24 May 2024 15:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564619; cv=none; b=Vnh6rvvabZcIYFVVcVYLotHXS4EBzXuAY55u9lemY1Ap3z1Tnl1XMROTuA3XRrft17WB5/75AvUS0AY+ibML+ikJ7OE2SIRb9UVn6d5ZfY5rR5wO4BZk5K9fKsQvmhwjyC3yOqDI4pXl8/NYv9xSnA1h9v2A2YUS2hXpRgZfd/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564619; c=relaxed/simple;
	bh=UN1Xetleeq5Nz5tLKfuxk8/opVO9kM/FjVJ/CVGswXI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CQbHdIGkn94GZSVq74akq/pdl5ECb8JUSd5Fzmxh9bTyqggARuJN3QvjolRB0uSDiX5NAY0IBlM7IEVxd3746SUq49DhGsOo0UeppQAmjm3JbZI5Mpl6uwdb3gdorTYEXhrC9nyAX92mJN07PM1vhIty8W4Q7IwA/XY1yRIIyek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GFZgBhED; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2bded7f6296so212082a91.1;
        Fri, 24 May 2024 08:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716564617; x=1717169417; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/7grr21+dk77QDv4Gfk7ePfGBs40BXM1/CLzaulLK98=;
        b=GFZgBhEDWMktf6tWuHX5kTvTLxir43nfLnRK1R/sYQ3+aaMTgbLkWHcvSw2IDvrxGA
         wwpNv8HfvWPoEvGSLe7Jx7IAJqYa6z+KvFoceKcp5ztzj4ajHciMq/TTaySJH6ZjMk1F
         MS0d0IJLXaMaY0MG6GUz2hZm81q7bML1eyLlVrqs44y5eVvuiYzttiLxIP5yKpIGWdR6
         0WUVrwOlITq0fpLy+KL1c9MWihw7EJeGTr1HZNXveYLzQZXL3YysEuFM61ZVcJfcQKve
         VGKqgtST7zIBW9dnOG7TR07nMH5UabRL2CZrqUxqpYw0pLd29CAWQIfhbg6ljTxlO/zU
         8iNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716564617; x=1717169417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/7grr21+dk77QDv4Gfk7ePfGBs40BXM1/CLzaulLK98=;
        b=Efdwvn/+OpRnUvIbD/ftMXB+IrMYLRL13yCT6DmduIXg2D+0+0FqGn7nJbuXoyQvxC
         zg4RuqFQ6Dpxk6orRHUEuC+g8Dk0gVFw16h6UYU4h+aFZpLaeWs1pC1lbWebVAuMd3iz
         YyYwVACpJiSUc5cz7IQ7vSHzxZQ/f+/oQZ4yW+zn50bUboJqmDiisyoIiRR4kt18+pRx
         OlPy38r+fNE9GD4sRJ9bLdjCQ5gPDtADxI+O86HAJcoRGswsvLBrdrL5pT+kNjHFlQUQ
         4Eucel/o3IkRXCySKOxX+j71Gxuu0BmkFRj+DYHY5QFQX21xRSQVlHeW4n6Mot8xyDGZ
         Fv8w==
X-Forwarded-Encrypted: i=1; AJvYcCX9vSGYh37Zozw43X1WkiEJHU4DBFHjaKMpwlTbt0XN9I3v/oeXpTARd8/x8TA3V1FXBH9gr0Mh9o1YdaQiGeMymuOC2u2XqHEaSKjMSqYFs4gJo1zV/ESO+LqkN6RiB3XHQb4dDoV7wv04spEL1A2LgrQmyyFyiSglrNCIom+QCQL0556UfXPI01BKApaQrZd5hnv3Jq80GUNYWLDntDSEVaImH5QxoppVTP/W
X-Gm-Message-State: AOJu0YxReUukqHDkowoABqs3ayp+lYLr/8LaptbLe48W5uRIqP81lyIb
	5UWvaySUj+ye0JL3JsA85u8PS/hpq7VEn6Km8al0mux/aQtB0TBv
X-Google-Smtp-Source: AGHT+IHJimdIMmMybcJm9rH5sITCKczMXcjO3LFGPLj00xSs2zLYla0SwJEjxRlWlGP0XYpBUqSPBA==
X-Received: by 2002:a17:90b:24c:b0:2b4:329e:eac5 with SMTP id 98e67ed59e1d1-2bf5f202ac5mr2504048a91.2.1716564617341;
        Fri, 24 May 2024 08:30:17 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f50d294sm1525556a91.20.2024.05.24.08.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 08:30:16 -0700 (PDT)
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
Subject: [PATCH v6 02/16] bcache: Fix typo
Date: Fri, 24 May 2024 23:29:44 +0800
Message-Id: <20240524152958.919343-3-visitorckw@gmail.com>
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


