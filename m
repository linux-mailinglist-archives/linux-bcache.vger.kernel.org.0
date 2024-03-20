Return-Path: <linux-bcache+bounces-327-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF3A98813B9
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 15:54:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3066EB210EC
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 14:54:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 773E54AEC3;
	Wed, 20 Mar 2024 14:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f5rYFRej"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D134879E;
	Wed, 20 Mar 2024 14:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710946467; cv=none; b=FtZXB5ajhofNWVZEwpez0Fm/nfLTfK9RTmY7w6nbGwgTUES+Z0yLdxrhhIOkheXTa/Sne1UzYUJEjtL4fxXQ3TTC4fxwJqorwI01DxO/+5l7cS8VAidSNOCINTHj1sn/lf2kQHqYAoQI8vc4s1UJ1Lq/p/L28MKb+YGsmftc1AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710946467; c=relaxed/simple;
	bh=IYecSohcwpGyIXoXSq7rCQyR8nAeqM8KbTlKn0CKjQQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jHurPcCeQd9zX2giXx1xOKfgb3dOqk3NdQPnL+Ye76UKJnsbzqJsHvoG+pDl1X5N7SyNKJnwC5XPfHAEVzHVqdcd4AJ1sOS6ez+ZbF7vUQwdQJn73HDXgVS+RbwcH8RzcgrlgZRUw+3o2f1gOOarc9gwRVEDl9LUODTC/xcBTDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f5rYFRej; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1e0678265b3so616985ad.0;
        Wed, 20 Mar 2024 07:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710946465; x=1711551265; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=H9pPYTnULGauSrpbFS5pR787jIzr/dKzPEq/yKn+20k=;
        b=f5rYFRejUcoPRn0BmE52+FfJHFPTjxdW3FEU6gpBXiB4Ko9iCtDqBE4LHw5d59LYGy
         eNqpSuGbqjGZ4BKZeOuQwaRjrygLx74AU5RV0YDnw0KzcMAHuHrYbpI5psJvZuw5de1n
         f7kIK+0iVziALT21uOKNAOvbyQhfW4be1AJCL9F1E7H1YapXAo9mdtykFElH2Edoyr4J
         Ddxz2IxcJUv2MPfDYp2eB161nSOZoagKwG5WRgsnpd1EVzOGBqYWg3+G9bj8/KpaLUGo
         XETCxIsDHw+Ac/mFTbUTVZVFqHw33UWpQBsUrvFYfwq79JBvkq1lXEm6sVDZaWYfzfEY
         g3Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710946465; x=1711551265;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H9pPYTnULGauSrpbFS5pR787jIzr/dKzPEq/yKn+20k=;
        b=S1wEbcRN8FG3j9CKMKk4vPFpEJGE/gRKDgza5WmBW9brmCumbULqEVX5/7SyrGolDz
         MuHyIkFXW6Mc1w2sy44w+bOJ+ici0PR3MZu4E+p/5+6h3j2pd6tASJBRrOEAWDvohUwQ
         JxL0oiq5udwkIPoY24xRMfi/Xo3qum3IEDNks85iFGCF86WL+1OfjgGR5OLKXuNfKO11
         klbzKt1QaD5cl6OoCGQbfDtjXBu7w4vCsqPcLSysHnYGfp4sTAz845XtMTWobSAZ8LE1
         swcwYA5HqJlo+9L99luMfqrMKop/HFfZVJHRtohDl8l8FfrqBVzxvNckIBDfCxID0ZXA
         q6SA==
X-Forwarded-Encrypted: i=1; AJvYcCXoMk4rVwAI5pTgoDk6edpbl3HBcI500NSQ7UewC9WTNr2La7BVcZS/OD1Z/tcGcC1VROSEF608QwSD+rRROvs8zdB0Gqpqj+9S16W/cy0KV+NyM5tlVF1XUgFBHs8WSMiQBwIsOaRqeocK4tk0NQmNd5syQwa2R2ksFLRLr/HdJ0Y1vExkCM2sRgBsMQ6qY8LnO0ryLYoEyeaesS57z0FRmZxpHhDST57urQtg
X-Gm-Message-State: AOJu0YwTieqnmcH9YgejHL1XYqUs+8iQCMasIdgu29/jFZJ0cmBkilie
	SnEBE/0qvxW9ZhI5U2ibGJRYGQ2L3N9gy70pl0zpoAERCZsVZ9Il
X-Google-Smtp-Source: AGHT+IEKS3qkVwmOq9hl/R6NzZ7V12FfqonEGI+lod4HJvjLgBZVIKQsxp+rc4s699c4UI2aCaWBjg==
X-Received: by 2002:a17:903:24f:b0:1dd:7d66:bfc0 with SMTP id j15-20020a170903024f00b001dd7d66bfc0mr19432256plh.4.1710946465092;
        Wed, 20 Mar 2024 07:54:25 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id la11-20020a170902fa0b00b001dc30f13e6asm13719989plb.137.2024.03.20.07.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 07:54:24 -0700 (PDT)
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
Subject: [PATCH v2 00/15] treewide: Refactor heap related implementation
Date: Wed, 20 Mar 2024 22:54:02 +0800
Message-Id: <20240320145417.336208-1-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series focuses on several adjustments related to heap
implementation. Firstly, a type-safe interface has been added to the
min_heap, along with the introduction of several new functions to
enhance its functionality. Additionally, the heap implementation for
bcache and bcachefs has been replaced with the generic min_heap
implementation from include/linux. Furthermore, several typos have been
corrected.

Previous discussion with Kent Overstreet:
https://lkml.kernel.org/ioyfizrzq7w7mjrqcadtzsfgpuntowtjdw5pgn4qhvsdp4mqqg@nrlek5vmisbu

Regards,
Kuan-Wei

---

You can preview this patch series on the 'refactor-heap-v2' branch of
the repository at the following link:

https://github.com/visitorckw/linux.git

Changes in v2:
- Add attribute __always_unused to the compare and swap functions
  that do not use the args parameter.
- Rename min_heapify() to min_heap_sift_down().
- Update lib/test_min_heap.c to use min_heap_init().
- Refine the commit message for bcache and bcachefs.
- Adjust the order of patches in the patch series.

Link to v1: https://lkml.kernel.org/20240319180005.246930-1-visitorckw@gmail.com

Kuan-Wei Chiu (15):
  perf/core: Fix several typos
  bcache: Fix typo
  bcachefs: Fix typo
  lib min_heap: Add type safe interface
  lib min_heap: Add min_heap_init()
  lib min_heap: Add min_heap_peek()
  lib min_heap: Add min_heap_full()
  lib min_heap: Add min_heap_del()
  lib min_heap: Add min_heap_sift_up()
  lib min_heap: Add args for min_heap_callbacks
  lib min_heap: Update min_heap_push() and min_heap_pop() to return bool
    values
  lib min_heap: Rename min_heapify() to min_heap_sift_down()
  lib/test_min_heap: Use min_heap_init() for initializing
  bcache: Remove heap-related macros and switch to generic min_heap
  bcachefs: Remove heap-related macros and switch to generic min_heap

 drivers/md/bcache/alloc.c      |  66 ++++++++----
 drivers/md/bcache/bcache.h     |   2 +-
 drivers/md/bcache/bset.c       |  73 ++++++++-----
 drivers/md/bcache/bset.h       |  38 ++++---
 drivers/md/bcache/btree.c      |  27 ++++-
 drivers/md/bcache/extents.c    |  44 ++++----
 drivers/md/bcache/movinggc.c   |  40 ++++++--
 drivers/md/bcache/super.c      |  16 +++
 drivers/md/bcache/sysfs.c      |   3 +
 drivers/md/bcache/util.c       |   2 +-
 drivers/md/bcache/util.h       |  81 +--------------
 drivers/md/dm-vdo/repair.c     |  29 +++---
 drivers/md/dm-vdo/slab-depot.c |  22 ++--
 fs/bcachefs/clock.c            |  53 +++++++---
 fs/bcachefs/clock_types.h      |   2 +-
 fs/bcachefs/ec.c               | 100 +++++++++++-------
 fs/bcachefs/ec_types.h         |   2 +-
 fs/bcachefs/util.c             |   2 +-
 fs/bcachefs/util.h             | 127 ++---------------------
 include/linux/min_heap.h       | 180 ++++++++++++++++++++++++++-------
 kernel/events/core.c           |  53 +++++-----
 lib/test_min_heap.c            |  70 ++++++-------
 22 files changed, 562 insertions(+), 470 deletions(-)

-- 
2.34.1


