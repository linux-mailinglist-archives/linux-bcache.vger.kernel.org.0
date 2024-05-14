Return-Path: <linux-bcache+bounces-442-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AB9E88C4DE5
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 10:47:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3883C1F22961
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 08:47:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 485421D54B;
	Tue, 14 May 2024 08:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QSf+rOBP"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D523A17BB9;
	Tue, 14 May 2024 08:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676454; cv=none; b=kyKZuJ89aVyr3X58sOhMN86DyaYopttwThqzD6s5Y0KZXxVA/tceLUmnzf3nwzA0+r1XStfCk+tnU/LydNhXrGrTiaYEXGIJ9vglm+e4r/W1Fm2uaBLZ9NwXGk1rJlHqOyoeDES+sb4+nsVpQYRF/a88tw+2FnBlcX5aWynkap4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676454; c=relaxed/simple;
	bh=txf3GnyQFLfXu7zMmkhDi/TH0fKi1KIpohTmThZbPuE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=snUuYs9z9uhNph0dTGWC5i5bMfqIQVTBorluWS4wVceCg2bFnWD0j0DxKSbjGwWw/ooIUZtphrp7x2fDs8l1AVUUJ3XtnL9fN6jHb+iL6Ahx3r1oAeZd2p0aSIWm2zGUfPiRJKXmebNNxfyQ1DRd4T2MajOjsoVYSFqyKRI+bD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QSf+rOBP; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2b360096cc4so1334560a91.1;
        Tue, 14 May 2024 01:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676452; x=1716281252; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GgH4hDCrjzNiv2eZBuWZJDEdDc4793wBYCaaGxBbWOA=;
        b=QSf+rOBPdDRtd8v7GlgvazcWu14Mplf4fZVlDkO6oERT9MMjKI9kJMm4dUdKo0ugiD
         iVTXI89G2eo/6djKW+BBkjmAQvphT9F9RRxzLbQoGAUORFkTWXl4YmKiM30NYXtRzski
         baJ2Rtabc7PtrzfRWhnkq0D6WwRwlr+Q3MLTl6XV+g3k7N91+utQQtkjuNBVbhszFavZ
         /9rcX90Ufn6h2On4FjvXgRSyU5xxAmnk4dd7rIr+NUNQ1xSvabFjrDxuQ4FKVQnhsqdN
         HlP97jYEfHDJT8xI6cVRdlSxryUWfMVj8FzTnnpf42tYtJfhmRtWQ0gFy9qY7j6WCOVe
         x0YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676452; x=1716281252;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GgH4hDCrjzNiv2eZBuWZJDEdDc4793wBYCaaGxBbWOA=;
        b=eU5c0PFfSEz7g6otD4Frj9egC5kmuJgBj6hJqAoSxxnIcUGAuu0rRTmsaEWUSuBsMf
         wwoEkVYtryX1uEJP4JXkMaJI1vwqega0aQdXSxMuOMAO6hFucmNkXp1a1JHKsv7aIfwF
         P262HxFkA1kIqx6qgci0bldcwlq87ALNfape/hC8EHb1k3nHTBIDKytLgS2wZihhFgMj
         K1cN7EvFingVDD1Sm0a/um3NL/I9+F/YvOLC2+u5vLS4p1alsD28m7+TAfFojUVWEJRt
         s0kQtQsQeFsCdr26UusLkMq4A7RYcFoyvgMngp6eLsqAgaP1hty7uRpMCUYp3Dc7M/m4
         VfhQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMAMW6RJfXWxaCPPGj1rIvna89IKS0nBa6N/5VQT1n/K50mY/RI8XtgSBPBWgo6ZezQne5Kz/mUbhujObNubzTg3h7wak7ILheS5R/7N/04b6C+CXZgxgSrpaj0tVKD2SCcqyZFTgbCLm/oSLbus/sv77VTA3uCsSP4PEGBl83toHGb2UcO9FkZieb/wmj+RwRjmiSNXuo0Ya9CHn72GShQeUeZoylxrz9SlFk
X-Gm-Message-State: AOJu0Yxt7XXcKYO7Qp9avClH6EuSyA+XrvULMQbDxRJNsSVw7k5UADJz
	9M7Q7DF5Pj/XvDlE0lc6riCtJi1N1/Jc9Stk9X89A6w/rlogQH9R
X-Google-Smtp-Source: AGHT+IHUKv+JLvDL8auK7rPdX3rN7CfOHjH/bzG9rOw8hKZ9CUUBFDIf3ULxRf72o6QfdJIwlXiLPg==
X-Received: by 2002:a17:90a:f10d:b0:2b2:916d:d89b with SMTP id 98e67ed59e1d1-2b6cb7c7dc7mr11296654a91.0.1715676452068;
        Tue, 14 May 2024 01:47:32 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b6711660fdsm9195597a91.16.2024.05.14.01.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:47:31 -0700 (PDT)
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
Subject: [RESEND PATCH v5 00/16] treewide: Refactor heap related implementation
Date: Tue, 14 May 2024 16:47:08 +0800
Message-Id: <20240514084724.557100-1-visitorckw@gmail.com>
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


