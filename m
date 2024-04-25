Return-Path: <linux-bcache+bounces-405-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA9028B23BE
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 16:19:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2168C28793E
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 14:19:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2EB114A08B;
	Thu, 25 Apr 2024 14:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mi+I7ng9"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A8E149E0C;
	Thu, 25 Apr 2024 14:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714054716; cv=none; b=TMkHDJHbkov98GX9F7jmqkk5HPA+1pU0XnjqVH7tr3ZX6yLi9aRG5w0bKsVeWZf8AntbEOJ6z4huIG2mRkZV7cpWny1bzNqTxaI30Xe1kww3YHOKPTSCiGDe+tf+fFFB/4MRhcBjBvWiyvSPZuJqgtPoIBRML1o4wdQPTqXZzQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714054716; c=relaxed/simple;
	bh=nxOjcL0P74qvHOhUa3G1KBblKkFTMO6kAC1ncKWnWeE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Jp5HCvq7lzz3JZzrgOEqMgPLHQNOXWke4EdfGvd0mGDFbAEzkT4ZATq+NfHYGQHW3C1RA/hmoarAuFFnHuW+kHdEfNNkBcE/cdc/1F2sD2l9oltRsaXSLbY6rxX657TCoHbrvSvIpNeNWXVF8SSCyBh4nQ0xBAVY7DHT56yu+Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mi+I7ng9; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1ead2c5f3f0so107855ad.0;
        Thu, 25 Apr 2024 07:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714054714; x=1714659514; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SpcFxjVoRf/8zZFpl0pURM6bbS9rd+3CtG1qRJbE4oM=;
        b=mi+I7ng9P0wPJThgggB3DA6prhhWagplopwMYLvf382EdbmbVYm4tUfV1ZHiTNdMCz
         ivyaWj6owGJs+KTRU/y//yz7d6tGdPirMW82tG8+MC6bjcfTFU+bozo6lLmiQ0THOnXB
         pVTi8ZX5JJXEyCUyROCujb1RN1ME611Mpm/zn6G1+Fs1/E1/OqNwP/KNsmeH2Urff4Nx
         VICQ51CxjcGFNuVE6CeRzTKajI1Tsh27P0kUXiISzN4DtHs4ErRvjBW3F3vkg25fgY+l
         ijYV2B5f+CnqnYftEnjxXVoYowx9Z6Z4M/qGBxxBZgQ1X46+VE4bXOy0JnHHVb63sjIo
         llNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714054714; x=1714659514;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SpcFxjVoRf/8zZFpl0pURM6bbS9rd+3CtG1qRJbE4oM=;
        b=mEcuTSG0syPAKuHLIMVkkXJzf24Iaz9SKRMBLNjwq8ymm0/p6jxwUVcOlngMZgVtup
         +zAVjLdKKZbjcZ545fLi8xC1a6DyN4MTno/FpJjyeA5C+qW3J48DHWWFtwoTDwh0rhkd
         kqDa58ry7Y+yI4VQZqk9eklhQuo7UHd9uuVNgWLvMMKY1RBHrEoUeIaPHgzrycqZ4yGa
         FIGfrvqS90BJM77p26Bmnjt+LNDNQNfYPYsZzczgmwZnwNxY1x/L5F3nWWyVxafD4tt6
         686JpercvnKXK5flXxEF7UlY9zMqQRq4wkX5g1bB3jEYfBLPWdugGXaYmRYlX2voaoPn
         MmJw==
X-Forwarded-Encrypted: i=1; AJvYcCWBIcjQ9VQh5URWOWAyhz7wP+Neq5TjwLmzvvhIrBFu4TQ7ffHKzvoVKdjir8BFHw15rQN/UQJsx/CO3WGtPqBi8ioFRslUTwXoDzwbK4WZ1QSa9JFMN7hIP675UD5+LkFqi0RPs+N+oE5DzLsyJsBjJxZkcF1Z3rT1w2j75pDvwqmQx4dt91eWqDzXwrnaCJ4WJYpzP/1WtOf03TNjhVBft3W5LFzRk3xiJI4F
X-Gm-Message-State: AOJu0YzGi1bbjiOvK2W7ozEgdRHQSoIyIov2mbUrSn7BLhltcOxei7+F
	IfqGwswHeaulxkZzzxTfZK7gJhCJfA7/EoOYw4Y/gL2OZ+rSRT57
X-Google-Smtp-Source: AGHT+IFFwWUen0aR7eKwdpRgMzVD+6uL8RAt9TmXJdXVYBDk+NjjHhRAaa/zcyng5BqcXFQvtoTOsA==
X-Received: by 2002:aa7:8a50:0:b0:6ec:ceb5:e5de with SMTP id n16-20020aa78a50000000b006ecceb5e5demr7018753pfa.0.1714054714442;
        Thu, 25 Apr 2024 07:18:34 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id go20-20020a056a003b1400b006e6233563cesm13162397pfb.218.2024.04.25.07.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 07:18:33 -0700 (PDT)
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
Subject: [PATCH v4 00/16] treewide: Refactor heap related implementation
Date: Thu, 25 Apr 2024 22:18:10 +0800
Message-Id: <20240425141826.840077-1-visitorckw@gmail.com>
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

You can preview this patch series on the 'refactor-heap-v4' branch of
the repository at the following link:

https://github.com/visitorckw/linux.git

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
 drivers/md/bcache/bset.c       |  84 ++++++++++-----
 drivers/md/bcache/bset.h       |  14 +--
 drivers/md/bcache/btree.c      |  17 ++-
 drivers/md/bcache/extents.c    |  53 ++++++----
 drivers/md/bcache/movinggc.c   |  41 +++++--
 drivers/md/bcache/sysfs.c      |   2 +
 drivers/md/bcache/util.c       |   2 +-
 drivers/md/bcache/util.h       |  67 +-----------
 drivers/md/bcache/writeback.c  |   3 +
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
 22 files changed, 522 insertions(+), 395 deletions(-)

-- 
2.34.1


