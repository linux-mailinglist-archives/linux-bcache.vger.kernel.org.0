Return-Path: <linux-bcache+bounces-366-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 96CFB89AC25
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 18:48:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 371671F2186E
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 16:48:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C8C8481AE;
	Sat,  6 Apr 2024 16:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IeYu5oTN"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3068E40841;
	Sat,  6 Apr 2024 16:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712422074; cv=none; b=bpXviYHuHkJtM6cfv7HP2zQpAzKrVLS3SZYLXTGro4Wv2glj34xKMdtgjtKOvdrsfnx8MAjvepCZdVRSPrOCTUNVAft4hDZYZaUw/XvvxccJZd589D9aBG/ISMYdTEMi7ZmXbO2AwpbZvalLz9sMFmKWeYR8CkB6osDnzg/xVj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712422074; c=relaxed/simple;
	bh=ccFsqSUbNmoZfjXj/UyIC9+OiMIUuYR/yY6H+xsWda4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Rx0wPDHzAU2rRmwNbvqtNEgvfdx/ttyt31UY0FJQfIcgoUCrtdt5XehzTPhTDdV8lVdqBoaFi/GgmM+NbzcfRAkwjbHEjF3uaUyzy4CTpzxweJF+zGDbs3MITC2jx0bEDYsVR1Q03OVGidOldJs4mku1hQfZ5g4CS3vsTJze+Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IeYu5oTN; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2a2d2120284so590012a91.1;
        Sat, 06 Apr 2024 09:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712422072; x=1713026872; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vCMluLf0OPIP5MvhSlBnewMLss6iSf4B08EHRoBbLMI=;
        b=IeYu5oTNWwsbOxTPjxqorL2lPyctLEELvS5hjsGKQ1hiYObgvjKROkFTGh8HKr3T/W
         u88uPrHZQ2aMSgaNwxCCAvvKePhlx0CO81+F2rTHXOy0bnlJyB+yNnzsSVEhospfDOqN
         hmrOoqWadETiCkvbuwBYlwugNBKLzNmkGbcnGdLyCfLdXCfzNoouW68Xgc2h13njmi/I
         3CELdrNcRbLACpy1ZhqaUiAMVoO0ccSa8BAaotVbwbFSvVpg2y5H9KGF8xaGT3qKihPA
         9RltYJazg7JNMW2rPXCcGsO3JD3pQ+5G6sv1W87dGk8yvMD17VXemdy8AzaCMV7uwF6Q
         Nirg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712422072; x=1713026872;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vCMluLf0OPIP5MvhSlBnewMLss6iSf4B08EHRoBbLMI=;
        b=j8VqCoAX4x9G5a8M1cLzC8QEwIDlCrBvgoUrtdrqUoPylxLs760jGiYq6PpyWZPdfY
         DBm8HKMIGrkQt7maBXHWsnglShcFWaUH2ALTbexmYOMLQcLY11uOHNJ/L+De+ulUFAAp
         BZM4p+qFcXYTkGSgT1uyv/BCQpX3jgQxfznWSBUN+Ktf+mO01mCfmjlT9x7xpmRI1sf3
         g/GJG+HfpVzhJDLGS6TVwUTNackA3rK1MhJlVm5Xfb0Xg8HOCe5pMRcKSMOR10shj0I/
         yA2mB4MY0NEauYBEM87DihYfWgnxZuyIvLlwWi94OSwzIY1PkiyX2fYu2YS6JYyHxqvx
         IvKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZYfOnwFbotqzIKSwIHKtkUjwqCbQd4kQxyDTaj6DjrutvgNmzQAvz4vQTkoob4uMVJ1WEguYIq77LUUYCSo120mq5His0E1YB1A/rUP0uPWvVvwopZK5xnmsFY2v7aXvHqfc4aRQS1555ajE8scd7TMt0ESib7ulTwZPeinA2A5lSrNunXN7o95DVWySHmPruXjBUV7rdIMeGQkE8E40ZFzb5tYmyIQyflOpe
X-Gm-Message-State: AOJu0YyvzIvAXd7OhunqSx6uJo+5btOLWITWl3tuIxNsIlWms6EX+djY
	mlM9Uc8QGTu1N3lNE+JEUEGBmCi3LVdhN1LidEB3rF03Og8KIhvP
X-Google-Smtp-Source: AGHT+IESrQr1BMS174R7mCr2kWozgHGWkRclCRX2j+JKeepJa2bhuAUkxjh7AUA1DUqBQHFdW+tuww==
X-Received: by 2002:a17:902:e84f:b0:1de:ddc6:27a6 with SMTP id t15-20020a170902e84f00b001deddc627a6mr5190843plg.2.1712422072419;
        Sat, 06 Apr 2024 09:47:52 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b001e2b8c91f04sm3665068plb.22.2024.04.06.09.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 09:47:51 -0700 (PDT)
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
Subject: [PATCH v3 02/17] bcache: Fix typo
Date: Sun,  7 Apr 2024 00:47:12 +0800
Message-Id: <20240406164727.577914-3-visitorckw@gmail.com>
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


