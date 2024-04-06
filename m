Return-Path: <linux-bcache+bounces-364-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6B5789AC1D
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 18:47:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 411F6B21713
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 16:47:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCDB93FB01;
	Sat,  6 Apr 2024 16:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="duN/bI+M"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B163139E;
	Sat,  6 Apr 2024 16:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712422057; cv=none; b=jbdPobsADR2hBAlsoMzpIuVQP0RQjZ+haMf1Ng9VWnH3tHgKOmIus8t5qkYL8WGLPxJtBHwYU9AZ+RijbUo6KjTbOqeZBHl/jp6n102RGx1VOT7g1owDnKA8ErvuzAupVGQ/ARopOGX9q7kHRrxWj0aom/qkdq9o4UUM3ZcjwXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712422057; c=relaxed/simple;
	bh=vTmqSE7wAnAE8+B+Y3yoFSxDSGpnKR+fsqaoPnVYArs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=k/qIAYDLoqIYrt4NnpcsymCwXQRxO3FRqu24myg7TOtdM+TgHRMhEO/iIrRbWT5pSXLYCeuIgMopqIvlCZhgJ9Yeift2ZtDECBty+xBQ4f/BrKRyzkihAJQpC975Ad7S9TdS5v4ibdYWw3TrdZ6GLDH1/Y70tfpDg30UW0OUQe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=duN/bI+M; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2a49986efc0so370987a91.0;
        Sat, 06 Apr 2024 09:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712422056; x=1713026856; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LXiMDbiB/x5DZ2j0QmK3atJp6egNapD3JM96uIjg2CU=;
        b=duN/bI+M8c4sQIMkehFtPqcfJ7KjZVBlThQaBd3+KOIack8bLBpBdHxI4YNLiGkIha
         LHZxY8isXYAZp46tNy85OSUezCYxUZiePG9b9WvbiFZF3aYlMxCujDS25F8zJZ1Dwhke
         Cxnb4MXeWSqYWzlYW60RBM468MPCuc237DR+XAPJ7Sx3jcfgSBZYnPe9uit0K8/fmhu6
         OsI1LUTCSiWzFpwuHSO286yzVp/uWaQV3YoTBMXpvTwIWzuZd+Qg2eY7R4w70EKEuJr4
         mCO72gvfok5+Z5JV/VovKJf+RFSuuQ0WlshwMegEesYQwU5aCMZQ59iheLnRu9zdn4NP
         fEXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712422056; x=1713026856;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LXiMDbiB/x5DZ2j0QmK3atJp6egNapD3JM96uIjg2CU=;
        b=K8XN/1j43Ta38Q1yKp5Hrt2DqDFOZculbSCFIwIxWvxw3ubQBMy7fBQHCOeJEfJuji
         MK/5DKAm4X0x/ZY4+bf7LSZ1jp7qmWwkLmJnPe0PaK54sDa+LOEYVmtJEtzV+L73qKEU
         A0kVoXZ3KxS/6cGmEEDV4jtL9SqMOepJVrZxXbvu1JrkQ8YOFoXu7p5rUWeGwnf+RlBo
         +BumiAWjDLRtnp/KWpyI1iEEVWZZLlfRtKaZnJiV6+5OCG7b396HBgoQvOam+1tuKBBp
         6yDnTAY3vuqHfFlwsrACsc7lnE93/OI2DuTq51ggk9Xl1XtOV5/+wRfm5LgIVJYffadb
         t9jw==
X-Forwarded-Encrypted: i=1; AJvYcCXySi4mqsXwKzRncpkcwLBeUSTy5aYHWDPE6VTJFQi7XdfaCyUTRfHSB49oX0qkuizCAWGeytNaR4Xnt6p4hJLt/lXrf8nC32iuv7J/i7t1IUHy9g2Ee5nn6ae/sWyTCWgeyPgoTpFca28XDUu5h+Obg4dEvBM99neNXrJIndW/GU2gsNdfW/GcDWc8DlOINmc6QKkUVRD1G0Q5EHMyDaNRHHOlVOyPyEIzwVM5
X-Gm-Message-State: AOJu0YzVy79ZnOeEfZfRozZ/2RLy3Fva2tWZ8c9LLFQnRlT/Zo4G8HM7
	7lXM3K+u0eINSHjTnHzggH8gv2KyGlC3iaRxsUwoOhERvPZGRAMX
X-Google-Smtp-Source: AGHT+IF5yZWE/nH3lQ/PNSud/5+GtQE8udinS8rRocEV+8yNDQQAuZQpi6knx8jRNKwVpjM48kGkdA==
X-Received: by 2002:a17:902:e5c1:b0:1e0:c91b:b950 with SMTP id u1-20020a170902e5c100b001e0c91bb950mr5604914plf.5.1712422055551;
        Sat, 06 Apr 2024 09:47:35 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b001e2b8c91f04sm3665068plb.22.2024.04.06.09.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 09:47:35 -0700 (PDT)
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
Subject: [PATCH v3 00/17] treewide: Refactor heap related implementation
Date: Sun,  7 Apr 2024 00:47:10 +0800
Message-Id: <20240406164727.577914-1-visitorckw@gmail.com>
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

You can preview this patch series on the 'refactor-heap-v3' branch of
the repository at the following link:

https://github.com/visitorckw/linux.git

Changes in v3:
- Avoid heap->heap.nr to eliminate the nested types.
- Add MIN_HEAP_PREALLOCATED macro for preallocating some elements.
- Use min_heap_sift_up() in min_heap_push().
- Fix a bug in heap_del() where we should copy the last element to
  'data + idx * element_size' instead of 'data'.
- Add testcases for heap_del().
- Fix bugs in bcache/bcachefs patches where the parameter types in
  some compare functions should have been 'type **', but were
  mistakenly written as 'type *'.

Changes in v2:
- Add attribute __always_unused to the compare and swap functions
  that do not use the args parameter.
- Rename min_heapify() to min_heap_sift_down().
- Update lib/test_min_heap.c to use min_heap_init().
- Refine the commit message for bcache and bcachefs.
- Adjust the order of patches in the patch series.

Link to v2: https://lore.kernel.org/20240320145417.336208-1-visitorckw@gmail.com
Link to v1: https://lkml.kernel.org/20240319180005.246930-1-visitorckw@gmail.com

Kuan-Wei Chiu (17):
  perf/core: Fix several typos
  bcache: Fix typo
  bcachefs: Fix typo
  lib min_heap: Add type safe interface
  lib min_heap: Add min_heap_init()
  lib min_heap: Add min_heap_peek()
  lib min_heap: Add min_heap_full()
  lib min_heap: Add args for min_heap_callbacks
  lib min_heap: Add min_heap_sift_up()
  lib min_heap: Add min_heap_del()
  lib min_heap: Update min_heap_push() and min_heap_pop() to return bool
    values
  lib min_heap: Rename min_heapify() to min_heap_sift_down()
  lib min_heap: Update min_heap_push() to use min_heap_sift_up()
  lib/test_min_heap: Use min_heap_init() for initializing
  lib/test_min_heap: Add test for heap_del()
  bcache: Remove heap-related macros and switch to generic min_heap
  bcachefs: Remove heap-related macros and switch to generic min_heap

 drivers/md/bcache/alloc.c      |  64 ++++++++---
 drivers/md/bcache/bcache.h     |   2 +-
 drivers/md/bcache/bset.c       |  84 ++++++++++-----
 drivers/md/bcache/bset.h       |  14 +--
 drivers/md/bcache/btree.c      |  17 ++-
 drivers/md/bcache/extents.c    |  53 ++++++----
 drivers/md/bcache/movinggc.c   |  41 +++++--
 drivers/md/bcache/sysfs.c      |   2 +
 drivers/md/bcache/util.c       |   2 +-
 drivers/md/bcache/util.h       |  67 +-----------
 drivers/md/bcache/writeback.c  |   3 +
 drivers/md/dm-vdo/repair.c     |  25 +++--
 drivers/md/dm-vdo/slab-depot.c |  20 ++--
 fs/bcachefs/clock.c            |  43 ++++++--
 fs/bcachefs/clock_types.h      |   2 +-
 fs/bcachefs/ec.c               |  76 ++++++++-----
 fs/bcachefs/ec_types.h         |   2 +-
 fs/bcachefs/util.c             |   2 +-
 fs/bcachefs/util.h             | 118 +--------------------
 include/linux/min_heap.h       | 188 +++++++++++++++++++++++++--------
 kernel/events/core.c           |  41 ++++---
 lib/test_min_heap.c            |  94 +++++++++++------
 22 files changed, 537 insertions(+), 423 deletions(-)

-- 
2.34.1


