Return-Path: <linux-bcache+bounces-473-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FB7F8CE7E5
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 17:30:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB23028225E
	for <lists+linux-bcache@lfdr.de>; Fri, 24 May 2024 15:30:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43D9812C805;
	Fri, 24 May 2024 15:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TlN3ISxp"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63C71EA80;
	Fri, 24 May 2024 15:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564609; cv=none; b=FnSaj9invG2g4c6EpQsGDUqfU1uA+0RBCeYjb+5CbpJwNXxDK+93eD5CQJOLlPm8p8gqMA/kJNJ7Uc+l6xXyZLMHrbRnG9CzdrNqtCRGVJSS0Oz8HjljtzbaDMXLPxDn8faOfW0Dhjt5E0417PP8LsBjU0lxvz28/bEqLTDuXXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564609; c=relaxed/simple;
	bh=1UgP6eazdUc8pLVw/Wqd33LMXd5ofZAnC5HL+Lqzbnw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DY6mFzUb+rZBl5+K8JVFqxTqGbTqQCxszwNoudm4xMR3+wyHz2fN1ecUiJJ8/ZIT2UkaaXYrodMgaLqsXlzaoHTwk3rhuOMkTRW46HLd9R4MuilZKb7UNWOOu5l7Ij+gJn1DpvtAsEvAhK2D3lnFmvIr7tqe7UgT8cicOvR8AP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TlN3ISxp; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2bf5ba9a2c5so184458a91.0;
        Fri, 24 May 2024 08:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716564607; x=1717169407; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XSUhRbM/RHyP+JVF4HXLWv//N2kHCiRdWq6jevFx+Co=;
        b=TlN3ISxpr6AsTpIXalwdTunwXyOyRIlgNk/fq89ADbUHqiefW+XH+iXl2imOWm3xpF
         h2FZY3SRYB91LDUg3FFlB/cze/jSXXE1HZcd/mBUITw3AvBjzaIJ8thn2r6Lk55Ipjvp
         1glm9c1pK0IgSIUZKlexNPg4/cOjCrufub9eBh+HKN+wnjXa6nByRQkSQ3JIk0FhwOXh
         9Yp1auvNVhrTk3p8h/yyCtSfj2T4esuyCkAKksIZN8zamUds8aRdKQsxHDfQHhL582+N
         vut9Y5yXf61XgfTlEpK44RMUYHMs+8814pAPq+Xdun4oXHDpX93CdiU0lI7FUN6H6ucm
         Mq3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716564607; x=1717169407;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XSUhRbM/RHyP+JVF4HXLWv//N2kHCiRdWq6jevFx+Co=;
        b=M9j4i2+lhFltbKZEW+W7PhGFHbKl4YZ//lZhBe94D+MY5whGpuSwr+RM2WkLdfyYZH
         ZVcBPJuBLYYhfvB+k+qfSCTiP4aJPR3SQNwymgtpSE55i2RpXxvEYHjVfme4g8xkhAou
         V06wTc/VSieApGHzyrC0wyOhPJJuxVg4zMY5y5wb3E6OidvIAdeAnFRkWjrxEi4HbmH5
         lFgoozq5ukehzVi2MFXAKSsKd7TemFvpAc21FouwbeEl9aVqStzWP7QHsLwwPExFDFme
         dOYs6c7mlPme9ElyxDwwNLGgpsC/fGcORBDEiFpVvsIgPLZwjP7TEMV9EWcoN+z54evW
         UtcQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0f6xq+H1fIWszaUDyuZBy0i4r+QEppAgrZZO/T9LQ3m+8M48QlpIYufKE3f3QWXOii9OS+6wjBMgS/5e9ozqEXok1+HbNaCcNSkWkNxfGsdMQVrXTtGUxe5bDgFSLssc8tAB7S8nxkRCxhFbHruc2GB4UuJARaOUq9feyAy2Mr9T9aQFpvPLVLjdhethPVlIzaolQwIL/p++XtB/WTh15MDl/nLzLKBvvaJX/
X-Gm-Message-State: AOJu0Yz5eyXBkMvd+KO7wgRitGrvtKDwCwaij4JfC3vMjf4fLSTjjDPN
	EB/3siZrGQol587fHxw4kXxq0cPtd0WyTP3WnjrPUm01PHiW/w75
X-Google-Smtp-Source: AGHT+IFY2ykJWU+aoDHZLEqKR0HSYpOf1JXuTKCB+Q07O2E7ikwkDfmbO8ZGWvz3URAGCeWk8pt3fg==
X-Received: by 2002:a17:90a:f411:b0:2b5:1cdc:9ac8 with SMTP id 98e67ed59e1d1-2bf5f5186bcmr2532463a91.4.1716564606899;
        Fri, 24 May 2024 08:30:06 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f50d294sm1525556a91.20.2024.05.24.08.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 08:30:06 -0700 (PDT)
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
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH v6 00/16] treewide: Refactor heap related implementation
Date: Fri, 24 May 2024 23:29:42 +0800
Message-Id: <20240524152958.919343-1-visitorckw@gmail.com>
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

You can preview this patch series on the 'refactor-heap' branch of
the repository at the following link:

https://github.com/visitorckw/linux

Changes in v6:
- Rename the MIN_HEAP() macro to DEFINE_MIN_HEAP().

Changes in RESEND v5:
- Resend because the mail service failed to send out all patches.

Changes in v5:
- Rebase on the block tree to resolve the conflict in bcache.
- Fix missing initialization for heap data pointer in bcache's
  bch_btree_node_read_done().

Changes in v4:
- Change struct initializations to use designated initializers.
- Replace memcpy() with func->swp() in heap_del() due to issues with
  set_backpointer in bcachefs when setting idx.
- Fix an error in ec_stripes_heap_swap() where
  ec_stripes_heap_set_backpointer() should be called after swapping.

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

Link to resend v5: https://lore.kernel.org/20240514084724.557100-1-visitorckw@gmail.com
Link to v5: https://lore.kernel.org/20240514084209.556112-1-visitorckw@gmail.com
Link to v4: https://lore.kernel.org/20240425141826.840077-1-visitorckw@gmail.com
Link to v3: https://lore.kernel.org/20240406164727.577914-1-visitorckw@gmail.com
Link to v2: https://lore.kernel.org/20240320145417.336208-1-visitorckw@gmail.com
Link to v1: https://lkml.kernel.org/20240319180005.246930-1-visitorckw@gmail.com

Kuan-Wei Chiu (16):
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
  lib/test_min_heap: Add test for heap_del()
  bcache: Remove heap-related macros and switch to generic min_heap
  bcachefs: Remove heap-related macros and switch to generic min_heap

 drivers/md/bcache/alloc.c      |  64 ++++++++---
 drivers/md/bcache/bcache.h     |   2 +-
 drivers/md/bcache/bset.c       | 124 ++++++++++++++--------
 drivers/md/bcache/bset.h       |  40 +++----
 drivers/md/bcache/btree.c      |  69 +++++++-----
 drivers/md/bcache/extents.c    |  53 ++++++----
 drivers/md/bcache/movinggc.c   |  41 +++++--
 drivers/md/bcache/super.c      |   3 +-
 drivers/md/bcache/sysfs.c      |   4 +-
 drivers/md/bcache/util.c       |   2 +-
 drivers/md/bcache/util.h       |  67 +-----------
 drivers/md/bcache/writeback.c  |  13 ++-
 drivers/md/dm-vdo/repair.c     |  19 ++--
 drivers/md/dm-vdo/slab-depot.c |  14 +--
 fs/bcachefs/clock.c            |  43 ++++++--
 fs/bcachefs/clock_types.h      |   2 +-
 fs/bcachefs/ec.c               |  76 ++++++++-----
 fs/bcachefs/ec_types.h         |   2 +-
 fs/bcachefs/util.c             |   2 +-
 fs/bcachefs/util.h             | 118 +--------------------
 include/linux/min_heap.h       | 188 +++++++++++++++++++++++++--------
 kernel/events/core.c           |  29 ++---
 lib/test_min_heap.c            |  75 +++++++++----
 23 files changed, 583 insertions(+), 467 deletions(-)

-- 
2.34.1


