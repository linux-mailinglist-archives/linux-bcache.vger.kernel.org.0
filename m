Return-Path: <linux-bcache+bounces-768-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 506E29A5240
	for <lists+linux-bcache@lfdr.de>; Sun, 20 Oct 2024 06:04:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9CED1F22DDF
	for <lists+linux-bcache@lfdr.de>; Sun, 20 Oct 2024 04:04:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C37C68121F;
	Sun, 20 Oct 2024 04:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jvC1IltM"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F9A7DA82;
	Sun, 20 Oct 2024 04:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729396968; cv=none; b=MMzenqhgRobA2TI/hZjLoEdcEjMIf9PZhj5bEvvWCz7Dk0IrXa5S7ylsXXHo0GGNHM/yx09DAmYA+XFIgdWFXKCIAJ+tA7YSADFmi9Xd1MoFNlnoDWHyD3fHcF42I8tWmrm4bvH5Su1p4rodAlI/akTUV5r4lt/h/nnm80zoDfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729396968; c=relaxed/simple;
	bh=gyiMjnOkGCmWLW5uchvMDnKTgZ6y7fEOmN1SFiFPiH4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qXJ+E1P7KgAYq26apSoLC34bqXyHmcSoJHjI6pSAsK25+INyUv/kv/oB2b8TJPK5xipn+9qszAXYLu9g6RCqQj3LHTqhqku7JCykqNGLew9xHq9/XXczS5ZF3Hx9U2RzXnzqu+hU6BLMMI4sHXAjHHZkmKQ+xZgTlcDh3Asg2jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jvC1IltM; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2e30db524c2so2522475a91.1;
        Sat, 19 Oct 2024 21:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729396966; x=1730001766; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6iUBoTJj+mB6KW0shlxuElBqdCTCqkeGFMIEQuiMOBQ=;
        b=jvC1IltMi5UyaN1iQ5EfWbzHrnSeViIljtMxvwezYL5zZ0RhBdBx1vC91Jmg8adFsH
         2EhMM+1nw7/8/k0JfEV41QSeJxBeAEjPwgD7clnk+yeKsYrdsMJNiHMYzBaozYbxhrtu
         7eGDBm6kY1zTlQRflroEwu6J4E2aKk04qdXu7G0AqwpxGxbjmr+3HUJaUup0soI7ixYf
         elaj1iGWsT2Ogn8W5Plt6k8ZVkLBPY/5lWy9cZpXF6219Jx39bRjTGA/MuRgagMs2ENu
         06UUdhDrGQWIHb5JxlreZ4naFYsrv8eQmvfc82S4GtRufEsj1ASa8Vx3RNI/mIWcBcqx
         j2Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729396966; x=1730001766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6iUBoTJj+mB6KW0shlxuElBqdCTCqkeGFMIEQuiMOBQ=;
        b=M5n760EBEYEZ5AK4gSm/laSKFeCFst6ZIrEyZc/+I6Wygc6SLT0t57Xxb65g7l3w5+
         E0UiTr2nrJLcoHbit9xp+MdrE2AfAXqMvdtiQgQf3UlLs0gnYxzTO6ZnaQXC4HwMupaq
         BtL8kgCr0nh9wXKnGdkjNPz4ESYURTZY51RaU704E5cvuB3PahleYL8Ik3voihEt7feO
         xa4P37HOHfOndemegyMUVbRPEr6K7gszUkGWXEg0o8hOcn4xxn0DOqCQggrnfHOu2ZqL
         h4WimqUoy0xiN5vfN0RrP85tqOHCkI73ZvRZAeJWwNvOVTWge3XbeE17S2L0a/1lr3rv
         kgMg==
X-Forwarded-Encrypted: i=1; AJvYcCU1VeG63HfzruYCg2QwXazdyjBIsv8aPS0nNyYblt0UeLBCtFEIUzhbywaNyx3PX1GvLT9B/dIO6ex2iz4Q3Hc=@vger.kernel.org, AJvYcCU4Y57cvJkA6Cw/bqYC3VrNUHRtosYjXnb0e/J7V5pIapG/5GJxzRQwyOUlz9qS4Y1aNWCUbEc/cfie@vger.kernel.org, AJvYcCUScZ2a9ZDuOr9WMJYQzXo9uC1PZ47efxnEoXxLm4xCqbjTQBqslqavk7j3II07gYMOleSuICgPunGbUxk=@vger.kernel.org, AJvYcCUaDlf7xqu1iEhADiHKL6tlnK4zGxkXLtBrq1biznmeWjCwLwOsyfU9LuLfdIvNZ5gu9k0pH84FCm7yZt+k@vger.kernel.org, AJvYcCV8zdy/Vuzhb9trGXx3LGpGQGsGbTNejGOfvoTnOzbBcsYJyIEpV0cpfRHSd3nlrzU00iVjbby5br+zPiW2VlaGLA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyUJiNh3uZY2+S6Bv+8/OJQILqvtIHlzJ2imQ8dn5e/v3JzPisG
	MbF4GxsaYXdA1ryukguI6cRamhoXPHdbMSZMqy0caa8poDE1DpYj
X-Google-Smtp-Source: AGHT+IFe5P6BuiYtbffd1mimYFoXtDFoEUK324MarnzRvMXI0QJHbhnkpia1+tu9/eVZZvKy7OgAww==
X-Received: by 2002:a17:90b:4b4a:b0:2e2:b211:a4da with SMTP id 98e67ed59e1d1-2e5616ec45bmr9060331a91.14.1729396966000;
        Sat, 19 Oct 2024 21:02:46 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad3678d3sm633668a91.24.2024.10.19.21.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2024 21:02:45 -0700 (PDT)
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
Subject: [PATCH v2 05/10] perf/core: Update min_heap_callbacks to use default builtin swap
Date: Sun, 20 Oct 2024 12:01:55 +0800
Message-Id: <20241020040200.939973-6-visitorckw@gmail.com>
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

After introducing the default builtin swap implementation, update the
min_heap_callbacks to replace the swp function pointer with NULL. This
change allows the min heap to directly utilize the builtin swap,
simplifying the code.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 kernel/events/core.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index cbf365e67f6e..0e9be5b323e4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3778,18 +3778,11 @@ static bool perf_less_group_idx(const void *l, const void *r, void __always_unus
 	return le->group_index < re->group_index;
 }
 
-static void swap_ptr(void *l, void *r, void __always_unused *args)
-{
-	void **lp = l, **rp = r;
-
-	swap(*lp, *rp);
-}
-
 DEFINE_MIN_HEAP(struct perf_event *, perf_event_min_heap);
 
 static const struct min_heap_callbacks perf_min_heap = {
 	.less = perf_less_group_idx,
-	.swp = swap_ptr,
+	.swp = NULL,
 };
 
 static void __heap_add(struct perf_event_min_heap *heap, struct perf_event *event)
-- 
2.34.1


