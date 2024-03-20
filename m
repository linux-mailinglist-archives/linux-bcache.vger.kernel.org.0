Return-Path: <linux-bcache+bounces-330-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7308D8813C6
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 15:55:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB1A0B23730
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 14:55:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB43D53E09;
	Wed, 20 Mar 2024 14:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="man5qzQT"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723AC1799B;
	Wed, 20 Mar 2024 14:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710946480; cv=none; b=GYjnIgBaYu1PyrVuowfvFK/aJii3frN+QE6kUQj2qWlFKExhGssdZRlyxvIqL0rarCyHwS1M4X89tr52voG8Yiw9VL7UHCUL4mWxQvhMMDfecEAC94qTUS6T7RJwW4ijI9UviJkmIruko1jqqwPZGnCIVQMYCKIdZ9soIc0r4Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710946480; c=relaxed/simple;
	bh=06vCmwEx1RrMDZDf+vtsHJ5OiX/iBIhb0hcMuWL3G6A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GLrUf4N8+rwS67ASZtsFMak3ugVFPrpFfVViENizl+SHFxrgPjHJYmTZfg5oR8oqE2oJyyvwxCdo6opRrteYCmNZO7c/y1PYxWT4E8rJbVJwuX7yqqRqTF4tCnq+v45635vOKNfkQy0N7AcclKRKBooxXRgMAHhNagaRx1zblbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=man5qzQT; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-55b5a37acb6so1194119a12.0;
        Wed, 20 Mar 2024 07:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710946479; x=1711551279; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NTsQEVNVJaaM77/A8IxlTDaKS3O7Y7L1hXdgoCCnWBw=;
        b=man5qzQTvQ25D7dJ1BedJgaHEbFheCltWsrw/Td8C+Yc1m/4SF/Hy7cJ/Up/pJwqA/
         PAuBUyvUqN/4SovDVejsEN7PraRALA4Vj7dqhTJysLSBmV0iC/ZFT5kt+RsjfsqUz4Sr
         yrV7W7tZk1e9bCnnEn/1L+Uy972JV3pEX5SFXbJbLUvMiTSyMzJ2AkCfvIj0fGnAuMh6
         O6Z5aXVXy8o8ot+X7QL0xVk5YlUGPfkcSbLor41SVunkl+lfa0TXcP4gUbcPBCReT0Qp
         g7ZGHYoa5cQqTpeisALsNvHOSyjEdJj0QrEDZ3eiiZmwMdzndL0n585jRYsEj1U3L4VJ
         dM/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710946479; x=1711551279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NTsQEVNVJaaM77/A8IxlTDaKS3O7Y7L1hXdgoCCnWBw=;
        b=uzEg+YDKhXO6qYjYcGw8o1bkxsWAGYLpurTjvXNbL7wlv3Znkcn7NyG/eo5fHomDhJ
         +7FjXedoIs8EChyR80iEh6SemrUKR9bylXvPQhpzurKB0TG5+oV+nppN56/xlmYjarDF
         7W1dY7S3zqt0GbKD1qDQOXHzY71zIRXyGG7AYEwR6xbrdhNUhv1XURrTE8ooAxzB+OvU
         iCLMdkUjx95aZnDBQQRCnK3ObLq2E67CHvOhZvY3nJr6OqOaF9MEo3ES5G6NgJyb6RkW
         c1qfSBO+mHrI6m9bDs63zNJf5vSFcjfkNwtgEop0xQyCmBOvb/qg1r/QeS5Xse+o6h0m
         OCRw==
X-Forwarded-Encrypted: i=1; AJvYcCVzYmawAxymVo/ejw4fM7nRAMShEdLnk7ElMV542LBeQFJqkfRyGb/a/zWj84g5+9oXVPh/m9Vj34w6IvkM+8lh6YiycRXubIRsWMd/YvI7xRwNj307IqWkeQKh2lLvrqYFcYr3y6jUYKCow/RzV4ydCalPq3tOJoyTutc3xPPPc9BoqZoC59sg4JO6kruTWBC3p/TSv2gNDcq67nSecprPXpx12EQ2/1DIYNho
X-Gm-Message-State: AOJu0YwvBBZmjAB3YY1tJtrYfG5KSHhj1eZxOWBJy20xazfnR5jd1GCR
	2+hbHyfHZBo4Y0MZ8aBCHmFNvjfxAfN7lUle2NcyHKb0Uv4uxcJt
X-Google-Smtp-Source: AGHT+IGB07JOeLXyWGxhruoog8ATzipnYUw/ZWM4f99QwxnPadWqwP8bL4PFsFnlu/KaSWs0YM/T5Q==
X-Received: by 2002:a17:903:2290:b0:1dd:7350:29f6 with SMTP id b16-20020a170903229000b001dd735029f6mr1956561plh.3.1710946478818;
        Wed, 20 Mar 2024 07:54:38 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id la11-20020a170902fa0b00b001dc30f13e6asm13719989plb.137.2024.03.20.07.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 07:54:38 -0700 (PDT)
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
Subject: [PATCH v2 03/15] bcachefs: Fix typo
Date: Wed, 20 Mar 2024 22:54:05 +0800
Message-Id: <20240320145417.336208-4-visitorckw@gmail.com>
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
 fs/bcachefs/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index 216fadf16928..f5a16ad65424 100644
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


