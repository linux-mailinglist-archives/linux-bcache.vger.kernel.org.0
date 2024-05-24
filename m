Return-Path: <linux-bcache+bounces-476-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D24768CE7EF
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 17:31:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 89C511F22738
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 15:31:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4644F12F379;
	Fri, 24 May 2024 15:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CNBuae5x"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2FB12E1F0;
	Fri, 24 May 2024 15:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564624; cv=none; b=XOrXvjVZ9fP8idzO9F2DEaWl+z/EXomjstoV0nCYt8m0Boq4ANNB9k+sjdEjPprq8MBPWjv7ckvyzALYLxXMsiTj1LaSCGCThelETIpb5GxJmQCSyXc1n9T501eoZ27tKT62SgbAH9SvX9jeK9rMgPsjYwjOJTMHg+TSscXzfCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564624; c=relaxed/simple;
	bh=QITT4KyTCrPxTa74Hi4WwUV4Z/BKsxAIzezFgyBB9RY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ivlf+s6XAg3bsq9MCnGxzdLwxQeJdxREykqlJ2ErR4R4uECJbZQI2speXUZ1c2JTKZw5J4TWST/qvsL7vZc0u4Tp4v2WXYWUJrB9L5VG00oEl87cywOlw3UspcqBcdgsVAjZDZWQ0qFG9VZBE6LvooldBp4FV3qVXUHUq/G987s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CNBuae5x; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2bde32de7c6so339672a91.0;
        Fri, 24 May 2024 08:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716564622; x=1717169422; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7KHs5Ddv3q6AjsWj+2TI+65ShPcrkPx2MBMg1+BRFwU=;
        b=CNBuae5xzT1d3f2ezSRbXQ8mnWYGffW1rAeG7nAnlAO9JJQSivv5CGwEGiVeT5JgTp
         KfRAQYLbncF57SanQ9nR8OA32AUcmfl7sq8cleUgGIRrQfPK074+4d0q7stB3B2313mH
         jdNbiMCZ4/v2KJBplnKRliPVpAMV1xG8ausgG2P6KUBFfsvKIEPsYRaVkLPNWwkoirYP
         GBn0AfVZIlWL5qcCew0mpxXdlS4MG3M9XFY85kuLECZBxGdjSGtc6dmr4Qnptg0ic5ax
         oeDjhr0SsrCJYphYwFlmtXJ1eo/QKK9kjEgoW48eIDU2GpecpPmys+ym3cRW6aWaxu5I
         Wa2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716564622; x=1717169422;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7KHs5Ddv3q6AjsWj+2TI+65ShPcrkPx2MBMg1+BRFwU=;
        b=cz/u6b/IrVn2a1ppeXs5b2dpVS6eisODc853ShucbV1H5BUD0plX6zQeDyuTT0TmbO
         zqyp9lPjBxcg9QkUbLdlwo7DJ1m6YCCg5m2cESh5/wkhgh0kECByfW3vd8dIFX4yYJp7
         e8ZxMIGPtU6TlHJwuo77ZLlW29ac7BW3m6/Vt/EgtcOlsdsEgnMfbJWXZPoM3aRBlmZ1
         YeTsJ//7SxNK6Hq+g27uam7RiwMIAVrQIo/qPfZAAzYWoELmylmm4724wCX8KNzrWAqo
         2OqMB4bgqUsIldp3ny1zXJ/3cVUgGPRx0WUPv/c6eQfDwtgVRdHVUvjuMMt3aODLqdKr
         fHfA==
X-Forwarded-Encrypted: i=1; AJvYcCWTqt9R+JN4PuI8weNjottkNEls14QCRtcQT5rQROTRTD2RPpfv6jzdIMZ1x6k6KwI0+Yd/fQpu2ICZELblLKZZuh7sBchuqsDWHNPqMuokmv0zdWRr9GZ1MuFh0MhvKa5QA0PV0GRZOoK78VD97wQ4r9ucHDTOjHliqLPom4zXeUlaB7fQfImRz+g7c0muGy49VSS/K3g5hosSDu+vid6p6W3PterCbwJoQCp2
X-Gm-Message-State: AOJu0YyjaG8CNhT4qyr+WZ9k6c2pxX/oed/wjGe9RVzMqMJS4T403X1u
	IbgUQO533lIJ2mpN5/eJxCW5N8QSijA2UBdS+Ec9rQP/kCMySoH2
X-Google-Smtp-Source: AGHT+IFVINOfwr0HWjlNIswXxzjjUbfsZzMCUUBzLvajmMapEMWFdTSr6TxSvcR9NlquE4fAbl3ZAw==
X-Received: by 2002:a17:90a:ac05:b0:2bd:f770:f95e with SMTP id 98e67ed59e1d1-2bf5e068cd9mr2464878a91.0.1716564622110;
        Fri, 24 May 2024 08:30:22 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f50d294sm1525556a91.20.2024.05.24.08.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 08:30:21 -0700 (PDT)
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
Subject: [PATCH v6 03/16] bcachefs: Fix typo
Date: Fri, 24 May 2024 23:29:45 +0800
Message-Id: <20240524152958.919343-4-visitorckw@gmail.com>
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
 fs/bcachefs/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index de331dec2a99..65d42206703c 100644
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


