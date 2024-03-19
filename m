Return-Path: <linux-bcache+bounces-297-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 005C0880429
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 19:01:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 84D5CB2388D
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 18:01:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B63B42B9C5;
	Tue, 19 Mar 2024 18:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aBbZCe9h"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4451C37719;
	Tue, 19 Mar 2024 18:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710871230; cv=none; b=X5fMvkmneX+fnkfzjmHX+Vx0cKm/aPkPA7VnICImPOdt+73J03p8kRVQ6Ev/cekLtwzz1Y7Yy8/liemPPkZBeECHINGi6tm5jFI76NlDVKePx28+590AC2wW2pd1glAKUAz2ptZkChmodJ0sNtNdoZTNXtoHeBfbV95+AFSBQjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710871230; c=relaxed/simple;
	bh=LuMWxrm74Ksk4iutH9RtN0QFCEVnpht0zuIdBSGgoFI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZnWKYFcwvFEmGBica0iJAMhAhBYOjhAr8YC7GdwZn20iy4AbknRbZBQSq3vfNtKyY9QltlgyoIM+TqqUfvja2mIMnypQHje/UTD37bgfCZrRe+ldycC8sB9Dyb5tKRXNL+A37rOJNkPH4jRDUrnmnBqUjqDQuY6kwQh6B/HrqoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aBbZCe9h; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-58962bf3f89so598972a12.0;
        Tue, 19 Mar 2024 11:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710871229; x=1711476029; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rP9XXgpmCWqpAAlyRPQQqYMsXW7o57+TdtdVf+VR+ZM=;
        b=aBbZCe9hN+HoF5p1Hih1RIrJ9bnZ8ilq6+tJeZSW23QPRewfabewwD6eToIusTktmO
         gGIg7sT8MT5WTGiu2ggPTMr9VTpTaTw8ohczVYynNLwYit2+NngagjWQVZKKXqkBvVdL
         DWckC3YYM9ZTe3nk+mPWYF0kTq4lrtQwWPVG2RRV/kQmfYGtyeuVa4wv/QhINPJMcX8Q
         t6Anxvidvu4mcx4TQ/P2IZgNFBxQ0/C1fH97FBebir6c0SqHHqqvlE/ySxKlr83f9DFL
         jzyrxD/Ioi4k8HPejHrsz3kbEcJRWG8IH4WfQo12CmvevNK/M41i6hS0wnfun39kXs5B
         5fOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710871229; x=1711476029;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rP9XXgpmCWqpAAlyRPQQqYMsXW7o57+TdtdVf+VR+ZM=;
        b=pQypvCDAmoVo3fpQj0oDwMLdCiRfS7eqGXhvXTH4TkYSN9aZysz4DFswF2uxkGts+u
         fK4516VHOvtGHNPIG6NKUK9RoJZv8a3Ib2/TMlvcFuSlUnD+SDKsu+LPetCBtZoNidHR
         d0ReCzA0JcBJ1bpkxVkb/oFEJVF8KTFlu+0hX8asZSBvx7mD9dV39plNxCpmXRtGvPSE
         GdxucmoCA/56ZU+xlb3AIcnBjyc1bVxD3kLxD0EVnt7+f4LgR/IyEz9LSt7+/qc+xpvc
         reoKLk/ekw5a6bIrPp5XPk3bPyNUAtA0ynoAfgV5QC5eLL8D8kVhbJDKpAkblqaEkQE6
         wU/g==
X-Forwarded-Encrypted: i=1; AJvYcCWF/HMM+55wUL/y6zxADutNYUPvoO+LZbAZ3t0jjckgM27ZMhRtsEdkaXomaxa4Afo54Z0gVfNnWJSW4rCyoXB8fMBS5lmCVXRmD2gxfwVtcKbOMWDMHpZyEYUFeJaC3ZApGjM0KNijCiWqozRsUjwWDGB/IfrQATusaSd+eSPGKQz+bopNvCacrBbhD2d8SFPlKtxnNrYcBfWRrf537KhzkZipcgUwg1M8u/Im
X-Gm-Message-State: AOJu0Yw9OEZIb8fyOstgbFkAeQzqQ3kh7wXPYQ+QFy9/r44iG1vN+oYI
	Jbp/isD/7DZPnZUY0h3r+ANNCFd7D1gvqeL42y6z/hqNqEo6Ki41
X-Google-Smtp-Source: AGHT+IF2whbQ9aCeS6gfzji2YFu/DVbEgj2n4mByZSc6EsUXDmYi9IvKNiXNRkgK5ItMhYIsEOJuCg==
X-Received: by 2002:a05:6a21:a584:b0:1a3:673b:627d with SMTP id gd4-20020a056a21a58400b001a3673b627dmr3461387pzc.1.1710871228645;
        Tue, 19 Mar 2024 11:00:28 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id u16-20020a17090341d000b001dd3bee3cd6sm5531359ple.219.2024.03.19.11.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 11:00:28 -0700 (PDT)
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
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH 03/13] bcachefs: Fix typo
Date: Wed, 20 Mar 2024 01:59:55 +0800
Message-Id: <20240319180005.246930-4-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240319180005.246930-1-visitorckw@gmail.com>
References: <20240319180005.246930-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace 'utiility' with 'utility'.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
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


