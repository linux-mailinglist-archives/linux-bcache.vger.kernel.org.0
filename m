Return-Path: <linux-bcache+bounces-408-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5085A8B23CD
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 16:20:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04C131F23C99
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 14:20:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D80314D29B;
	Thu, 25 Apr 2024 14:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nMrMJ25G"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9346E14C5BA;
	Thu, 25 Apr 2024 14:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714054730; cv=none; b=j0oB9zvTnmRDtCgRMM+lSoVbiVSoHf2vNR98OLOEgaIFlkDxjoBQlc9x5XAhi5FvHaiyb/+vnWM7bw+SU8sB0sP2E2DDCLKYIAsDsh+nfW4XP9M7thBCpwhqry8IPj4TRzt8IWIaIi/V5f/h4vM9YxnIdPLWPBWgVEzr2+uED74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714054730; c=relaxed/simple;
	bh=F4H9nDZNXyr/ZsFI+cCJhr3OYw8PynR+1AAuPVXPV9M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VD9xaV7edg3lpA0j/teanCs0ie8I/2N+j5MEwzc3TBsrzDNHXhxv6qpJl6N0z+XpvkaLLLxk/0US0eF2T4efWvDZPTdFJYnJyUX7TTQui1OTmzTrUtx9Ug439RF1Zpb5Ovhjfyr0jt2USq9g4h8RH7yuhyivbVYPgaqJi3hBmSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nMrMJ25G; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1e7af7eb4ccso504645ad.1;
        Thu, 25 Apr 2024 07:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714054729; x=1714659529; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6mL/EL0d7nL6m0RFDxHa1SNm7xjXj5OmWxYW9IhbyI0=;
        b=nMrMJ25G1+GVM77ZhRT/z0f6RSJRzMEKlZMka6576JaQdU9h58CqXwi0wElgYoZtSs
         PbWv9e1ipA3eqpK9yxfTUGAJED9ypNaKr/CqDDMRM2pJ77AmJmZ7Eys2yyOBotdmd85q
         zG5g9btmIAXdD6orYrbkgMieQjWktWWpD04Xtd/iBLiZSr1kxungYVWy4R4QA8QBnnW1
         ZgwZHvmFO+qmLFqdZGLVZIBBqVJ9z1nQOSsWNONAOzhBvNjTNwtmP3p8IqnBGbnu9fLO
         o2LnGK0aTbH/+plOSTujZtDKnrtDoAvbkUdxjEW78RLfmMTAAzXPDavGSNm+X+wTGSaE
         H7kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714054729; x=1714659529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6mL/EL0d7nL6m0RFDxHa1SNm7xjXj5OmWxYW9IhbyI0=;
        b=H4Ye8lkpOb3E1PyxFI7kVy270Lqd+7yquFL7UUnHuqSzO49KEAS140W0RsDdkGq0+u
         hLzrtpzyUt5miNCrKXrrRGNZTq5xV4F/C6MqhCLa0GBpHw1yNEX55OHmANbu/OZL7ZjV
         3t+jqFGPd/UwG3NHO1qX9T4yobi/HJPDElHbNGbgspev6TBgeLjA3YrCBe+hn0C03vlZ
         li8f41znGed0mUNqyyxriZqim5DMHR9telmOK3M1myJSLL6gxxcyb2Odts7/jccIylHh
         QgsM/Lt+Q3CBPcb8/1QxwzXGPg4JBGEJQIO9zWSGMDiiY3Jx6ZGV0I2G6eS+WFdFzgbe
         DGYA==
X-Forwarded-Encrypted: i=1; AJvYcCW8WWbmns6gcowxTjwW2RvfP36t567BXkaoiVJZ8TyC7ei3PEaiUGsw8ZFccFmUyyNFlMzTNGr+l5ALqc3edy0dNASFqRP7tat11w2juHsmwRz4TsmMqGoC8t4wpReFSGu2GEO6vp9K9j/qvwJXbCGcU8GWAnSO+Jqs4QUUDyhm89zWh1cSHS8+jYTrT8c8dABQNR0i2YSeuw0e1XjodNDwtmH5tiAj+vkGPnfr
X-Gm-Message-State: AOJu0YyraULuXjCzjqxA0PYjcsu5m0ylXVufMkR8kCvj7XS9FiWRmN1h
	tyPjqqjdv4b4mjUj702bDEDFgVDh2AXS8QwFkKYt8fzEPIySYjDu
X-Google-Smtp-Source: AGHT+IFAco8SS+QgCQv0p+fueHlybivSKvhE5qQYuUi+dWforsZMvlEpw0tqxGG/Sh3EeDZa7lb0cg==
X-Received: by 2002:a05:6a00:8985:b0:6ec:f406:ab17 with SMTP id hx5-20020a056a00898500b006ecf406ab17mr6515587pfb.0.1714054728656;
        Thu, 25 Apr 2024 07:18:48 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id go20-20020a056a003b1400b006e6233563cesm13162397pfb.218.2024.04.25.07.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 07:18:48 -0700 (PDT)
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
Subject: [PATCH v4 03/16] bcachefs: Fix typo
Date: Thu, 25 Apr 2024 22:18:13 +0800
Message-Id: <20240425141826.840077-4-visitorckw@gmail.com>
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


