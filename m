Return-Path: <linux-bcache+bounces-769-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B6FC9A5244
	for <lists+linux-bcache@lfdr.de>; Sun, 20 Oct 2024 06:04:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 027511F22E1E
	for <lists+linux-bcache@lfdr.de>; Sun, 20 Oct 2024 04:04:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6C9EEADA;
	Sun, 20 Oct 2024 04:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bqz++SX8"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826407DA82;
	Sun, 20 Oct 2024 04:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729396975; cv=none; b=QkKyaWf7LgZgk67x6DDK0hmvtZvNpx+zpj/3whQ8NjiytNhyiqfMNy2+IUcuzaKAyJzwjKsClhBMvR4Zjcc5USps9G6xLqyGGVt+sPIC+VeMUbf07wgtYiLpXM6gYcAi8S/t55gOOHh1VM03NE+bnPY9FVYf1FqdSUjZx4tdLNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729396975; c=relaxed/simple;
	bh=/9mUaFvmlKksdPlONLh36cpvswwCLSGpPrI0BGH0Huo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uMsWJrWZ2/kdp8LTWm6s6642d+mVJ+LtYZ7mHLwmtR+3sxdgoxNmHnz7pj2KhEQvCSzxXUq7qe5XxfAYTB1b5Gd1UFZIUtwvk54AmxSS53/kjYZxbMrhziuI/CYJF1WQ/lQ7jPNMr3EaTr1OScQtTZ3FsWUW5SHZrdvefP6V6e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bqz++SX8; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2e3010478e6so2789536a91.1;
        Sat, 19 Oct 2024 21:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729396972; x=1730001772; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rziSmC5tfzn2cnt/wqwyaZwuuHhuMcA3Csb1Fp91fpY=;
        b=bqz++SX8QG0mmMXZFez34zqjXHawDgQcVsFTXl3zpIRJLyug8eDowqI8QbE5arzv/T
         zHY+txYz7iLqcG+vMn4mNZ1KPOpM6mntSzNVGcAS7bEnWucyKaPnZAfRbRwHcbsmJrNO
         k/ENZtlBfMRo75ywKIcib3vBTo/ss8ZP8d8Q1Ckc8pTIvEop4PbjC/PpGqy4vzofIMx9
         8oTXcoKw2j0iMeK5nnx6o4VsamPK3qisL1agMSwuGnB5EnkXSCngUh+Ge8ul602lb1ZK
         nSnt8IBw1B0Y8GoL89OBl5gM+K6q4VGh5LUJj8lde1gvBqHmJYI/9M/zgx/6wudypmT9
         sy2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729396972; x=1730001772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rziSmC5tfzn2cnt/wqwyaZwuuHhuMcA3Csb1Fp91fpY=;
        b=B0Zw761pWugZ6E06e0oQRvC5Wy3fNc1cGMBBjotRQBVZxUzJZAhS5xz+pE9PEyNmwM
         8VjXkouqbOf1+2pNCXqwzqe+u40uKxeacxEPqPFUmxvwDwfY1S8smnnSJvli7q+AN5ff
         u9IXd3ge/JNyM6R6aLsicRyEX6N3+3TdrzoDPu2XYZSwjDkKE7M2bllov1yi6TuKRIeL
         dAomajDFZZWAJz4Vsss547vUkOaJ5jwva4S/+tnv7NPkg4ZaMbzPe8xQtbbwVUrZWG8u
         HttbaBwTX4GAwT36T7mJwOhgW77yikrXZsUA0s9sPHhw0gY+X0S5KKTrPdAnErrALyUD
         EprA==
X-Forwarded-Encrypted: i=1; AJvYcCUmZd+XqqCDieDpxwV6Yi8pXQLK2oXiRUbTRJ0JY2JW2Zo3W9R6ZbSwD6oDFroSCN95WxGe1xc5AH3xrSXseGMchg==@vger.kernel.org, AJvYcCV2WoXraTKItwzdN+wP/nHfbCN1HiiZkjCZhS6Gt+PE1DfCMclSY+jrYo1ANdKOOV7PfIC9YvPa0q9Mkf4yZJk=@vger.kernel.org, AJvYcCVSrQb2DqFmkQ7C0vs51cdg+PToFRB/6qkUTA5MQ3s4fFx8OQ/upfDhPAvl2bpg3zxLriDZMaRp2QQd0iZQ@vger.kernel.org, AJvYcCVl4n/4ZZnuPFqUzQhex/6Vr8z3WMqElGaB7k4CP5ec0DHEum8WD26CGH5WG+uU3r/98CQnUhITdUL0MxY=@vger.kernel.org, AJvYcCWfsABFPdN5PjfWj5NAAfY81/H8qchLRHmkQLXZEH4dGPEqoNRl7+cDpFKw9Hnb6Xjmc++7gmDUS62k@vger.kernel.org
X-Gm-Message-State: AOJu0YxZlK5U5Y2phtjSFjy0XmKALH33h81aJ8xW//kUl8C9SeX6sN0p
	OZcO4+ETW1LtAvErryDjwZw0gQfsVLnH/X68+CSMxuSLkIl55yeP
X-Google-Smtp-Source: AGHT+IHMW+qjGNk25MwSR4+vnQ0D8s1Tp6FfxwQfHJa9nSOWn+djBGN5YnBTiCdS6y5VPlsk0p2NZQ==
X-Received: by 2002:a17:90b:3658:b0:2e2:cd6b:c6ca with SMTP id 98e67ed59e1d1-2e5618f0839mr8748941a91.25.1729396971559;
        Sat, 19 Oct 2024 21:02:51 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad3678d3sm633668a91.24.2024.10.19.21.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2024 21:02:51 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: colyli@suse.de,
	kent.overstreet@linux.dev,
	msakai@redhat.com,
	corbet@lwn.net,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	akpm@linux-foundation.org
Cc: mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	kan.liang@linux.intel.com,
	willy@infradead.org,
	jserv@ccns.ncku.edu.tw,
	linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH v2 06/10] dm vdo: Update min_heap_callbacks to use default builtin swap
Date: Sun, 20 Oct 2024 12:01:56 +0800
Message-Id: <20241020040200.939973-7-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241020040200.939973-1-visitorckw@gmail.com>
References: <20241020040200.939973-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the swp function pointer in the min_heap_callbacks of dm-vdo
with NULL, allowing direct usage of the default builtin swap
implementation. This modification simplifies the code and improves
performance by removing unnecessary function indirection.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 drivers/md/dm-vdo/repair.c     |  2 +-
 drivers/md/dm-vdo/slab-depot.c | 10 +---------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
index ffff2c999518..8c006fb3afcf 100644
--- a/drivers/md/dm-vdo/repair.c
+++ b/drivers/md/dm-vdo/repair.c
@@ -166,7 +166,7 @@ static void swap_mappings(void *item1, void *item2, void __always_unused *args)
 
 static const struct min_heap_callbacks repair_min_heap = {
 	.less = mapping_is_less_than,
-	.swp = swap_mappings,
+	.swp = NULL,
 };
 
 static struct numbered_block_mapping *sort_next_heap_element(struct repair_completion *repair)
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index 274f9ccd072f..ccf7b2eac131 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -3301,17 +3301,9 @@ static bool slab_status_is_less_than(const void *item1, const void *item2,
 	return info1->slab_number < info2->slab_number;
 }
 
-static void swap_slab_statuses(void *item1, void *item2, void __always_unused *args)
-{
-	struct slab_status *info1 = item1;
-	struct slab_status *info2 = item2;
-
-	swap(*info1, *info2);
-}
-
 static const struct min_heap_callbacks slab_status_min_heap = {
 	.less = slab_status_is_less_than,
-	.swp = swap_slab_statuses,
+	.swp = NULL,
 };
 
 /* Inform the slab actor that a action has finished on some slab; used by apply_to_slabs(). */
-- 
2.34.1


