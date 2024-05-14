Return-Path: <linux-bcache+bounces-439-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 867A78C4DCD
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 10:42:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC6C8B219A2
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 08:42:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABA0C18E20;
	Tue, 14 May 2024 08:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V+3Zr/i/"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDE31097B;
	Tue, 14 May 2024 08:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676139; cv=none; b=F0wzl9dXO4YzDvnNhkq/3AwK24I+wApGvX/Wr0v7Jwk9r3AbqxeXfOvoIRPzAMbJqM0cD+u69x3ddVSGgwJTMcpSq8WaadO3bq8NjImZNs8F44A0MsMPZ0dLBZS5AWJcKhZGKaQxMiIAo6ztmCadwVE5hklp6w5b5lYxRS0tiDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676139; c=relaxed/simple;
	bh=1Q8a5Z18ALAPhprhT5LIOTCIVJQtLeVbMK0iySVFvAs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FX13ZtvDXhBfWN016avB2v1pW/OGkhBXSAGPiG7NIyIrVajcnh0jWn2oojlc3pqybKvZz9NyD8L8qP6oyhoyRhtTJKi1jZHBsIb058UmhQ0B50+OeRffJnUGehcEXiBTEX8A+qApHfzUNaquci8fnVaNHouDlatiCK5qiaka9c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V+3Zr/i/; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2b516b36acfso1393048a91.2;
        Tue, 14 May 2024 01:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715676138; x=1716280938; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Js4BUNSWfE5GqATWlKw/AIzixsydTldCYIC+ryzPwtQ=;
        b=V+3Zr/i/5DS65g/8KoxcCa5oMW2fMw0CLm/5WqsKWD3aHGSmzlg30XtY1u/xCUOYpl
         Si7Cmj7kc0HkiuHcgsVrS43kq1lSsAzbrT3driS2k4fv17/oWtIxMkbHmnQoyFC5gQjG
         ty+P7NP6lazYpA28IFiMB7if4/5DKJ7wUxK/4MVlKyAY+dGW1GHiPXdyEqalCzlYFIZt
         b5yOvb4mY0b2/d0RLcIcnPPCQP3gUAM2PwjLFjdd2rbeg3cY8U80N8SiqxZGg0fyxU53
         1IBdGPjH0qspXnH2rzMOU8Vy9KzLz0YbqNcjGJCz6XUt2jEY/lwbW6cfplyp6AfZNN/L
         D+ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715676138; x=1716280938;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Js4BUNSWfE5GqATWlKw/AIzixsydTldCYIC+ryzPwtQ=;
        b=rbeBWujhP8pN0OpGtZnSKyfaD+3qtUD0mczSn+wjP0FGAF+RfkrzuhKnCyI5AS/MC8
         EPHRkp0U7VFvAw/B1cyBuDto+rjuxxZlLaUHeJaqU4VbSEFj9PybkorjpGljFl5Epub5
         QhqAkMS+VeA/dFr5JMhQBPF8X4oe+EzCD6X1otp2JMey3RxK0jO0YtrnrbZccmQmi9f0
         fwcNAJ2q1Ny7yA217M5Y0xW3lPF39lMBPU42x32LBJLGg9KpYA2iObkIIa0aAoVUVc40
         f7xoc9pyY71Hhqg8C1a91gtnmgKI3CsYtJLLAOGWzHTjigE5tQzMNoB7MKMtY7Ub5j90
         NYsg==
X-Forwarded-Encrypted: i=1; AJvYcCXTbby/zmyQbzJGV6lXEqyUDVB6cldyc4t0esDkJu5o0yzibTwztTJGRaI3N1EXnOyVxBz0CBecwXu8Zx2du9TuK08VIeiNhk9WQpYiRwT+OyRiKhZIiNjb39b/k6cWVWcoIFdc/opxMnpU3LLrt/I4ly8texmVzepDwtHcmZ2Vk+acmVip5uCdxSsJ5zTb5cW9HNIvawFPXRXnWyl3PiiuakyDmv6Sm1rf5WYn
X-Gm-Message-State: AOJu0YzJJzWtoqVxdKp/tzgKdUlrSteQLxzLtQ5E40bFeuYloJ2b1Q4B
	NANT6WZUSBHiLJh5mBSqFRLq6GvBf2Tw7pAGUp3g2jJMjF/12/xk
X-Google-Smtp-Source: AGHT+IH4kRyXrCykJ3Dzb4hLqTyjLiHwbobj+9ip7Io2bJaePb+G2VRr/GHX1RuW09L7x7aUOrtPYQ==
X-Received: by 2002:a17:903:2444:b0:1e2:c544:9bb0 with SMTP id d9443c01a7336-1ef433d37a2mr142421475ad.0.1715676137502;
        Tue, 14 May 2024 01:42:17 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0bf30f96sm92411045ad.179.2024.05.14.01.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 01:42:16 -0700 (PDT)
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
Subject: [PATCH v5 00/16] treewide: Refactor heap related implementation
Date: Tue, 14 May 2024 16:41:53 +0800
Message-Id: <20240514084209.556112-1-visitorckw@gmail.com>
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


