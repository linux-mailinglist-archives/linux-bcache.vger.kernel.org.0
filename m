Return-Path: <linux-bcache+bounces-444-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E8118C4DEC
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 10:48:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 14A891F22AA8
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 08:48:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD89A2CCA0;
	Tue, 14 May 2024 08:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BuV0UYxY"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3D2200C3;
	Tue, 14 May 2024 08:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676464; cv=none; b=NQiGvq7UYUN2J/D8cCnlAH7zzdRgAwNMp3TfZyj2QJdWyERiRmElKPSfA01a9xvM+oxAM34vDZVz8P0GdNcb/ExX05vfWjpp5zcP9NvMaKzWJi5PbvpKBNzsc/APPBy9I70Bc5hntV+5WMVzVD0Yok1iEViUk7Wbaww7r6y7cLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676464; c=relaxed/simple;
	bh=UN1Xetleeq5Nz5tLKfuxk8/opVO9kM/FjVJ/CVGswXI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AHd2AMCFrfBKI/kEqT4oOpW2XWhTotj7yaAVt7Ni0UwjCahSSEGMuf5Z68ywwBpqAMUOGcVUky8YJso+59Q+lU02lQjNWOTTUQyYyZKhG4R6FsqLuquy6XLblZ7JrrCm+XILgVWxYn95BHz5aXlAn0Eyp+tjex1KKBp96erRY30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BuV0UYxY; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2b6215bcd03so1229299a91.1;
        Tue, 14 May 2024 01:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676463; x=1716281263; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/7grr21+dk77QDv4Gfk7ePfGBs40BXM1/CLzaulLK98=;
        b=BuV0UYxYjUplMYGuP5g3agOlb2JAk30NFmafFnXGPbM010iPOooVpXxs5QHhR2Rcmh
         dymUSqT437+QoiZkk/gngGtS3dljqz6eJmtVwC2O30u1R9y17aZPK6zz5Al+1QsA7kMg
         cOOpnvFOG7r47v+LAmopnFeblIUoEs/HdkzPi49MQ2EYFbSrZCE2Y/nJ1l9UWmGTB1dc
         XCrRIIYJmnZTpTt1jkcRCVFAAjBJqEtyc5FFrrMPXZtLA9EtZG3RbOhsjV0o7neFDezK
         XTDS7PgoslOJCgrI/ANO7fMEvFtsWLnlZu72dtZJJoirBOij3qT3EzEj1KGvrBTPL/ct
         rg7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676463; x=1716281263;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/7grr21+dk77QDv4Gfk7ePfGBs40BXM1/CLzaulLK98=;
        b=KpKu8dx1cIbXoYv0PcObxH4r9dSqGbEt0MSrn0QJMjPMLiqb/KuQaOuoi/nNDRpwMr
         Q+O5rMZbzaCzSVvfssxjNfKSmsh/cx98kUoYviaxkBTuDlUTpx5WSHTpE0c71qsA7aRu
         oN2fzCmMbc4OMNcA86DW4TUnLKh2oG3dwubhdHH1K1sBuy3Rr8mGfC+zrDmzPA3W1wna
         mYW25ffnhlyYZIYjMy9zQHRmG3S/U2u0zZOBtg+nOHdo8Lu90uDNPEzjbEFjr1RcnxZu
         cvGPYgoNuIGEDPbE2Qj8zc6FSxp1UWhcZCBWv1I++9Nw6S+8HMJJMwImnloyU2A1pG0D
         36YA==
X-Forwarded-Encrypted: i=1; AJvYcCX+E2cKZfhyu3EUywRnxzBxAj9j8PcP3vMzvJgQXLhy+TkDMZUkm6oRIEY37eCtLpy676LtWbliLTIKHqZxcicja5fuOUe44FHQi/Qe5q1MGFL/saNfq22k9gJLqRVp4bmHbDxzZGPc1ldrEcaSoztvDyNNZWSv00Yu5Hqy3SCStHpDcuOMd8VcLnzXmBte+ERU+RMEzbd1qBaqm7UcbHt9iEY5crXc1+HsEsSE
X-Gm-Message-State: AOJu0YwsWdX8lqABHo4l2h7qlO3bDPl47IWFxIyk6fOjwx3tPJEPjE4Q
	BN9jQZRu7vEgFKmNNNoTDI044ov/4FaJJ/nF4eNgbyX1yfo5Ki+c
X-Google-Smtp-Source: AGHT+IEMUmx+37VSqc6GRGyY4pOmP+xoAi9mzpeZ5gYRml7jxeXeFDC0FyBMpm/Kb0QmMkl9TuNysw==
X-Received: by 2002:a17:90a:3d83:b0:2b6:5b13:b3b0 with SMTP id 98e67ed59e1d1-2b6cd30d2c3mr11588329a91.4.1715676462694;
        Tue, 14 May 2024 01:47:42 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b6711660fdsm9195597a91.16.2024.05.14.01.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:47:42 -0700 (PDT)
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
Subject: [RESEND PATCH v5 02/16] bcache: Fix typo
Date: Tue, 14 May 2024 16:47:10 +0800
Message-Id: <20240514084724.557100-3-visitorckw@gmail.com>
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


