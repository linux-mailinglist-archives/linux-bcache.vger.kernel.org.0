Return-Path: <linux-bcache+bounces-294-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 31BF488041F
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 19:00:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BEE3283F46
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 18:00:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1E8325605;
	Tue, 19 Mar 2024 18:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P28VbwyB"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F0A2C18E;
	Tue, 19 Mar 2024 18:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710871216; cv=none; b=s4RyljexK8obcUo7Chjzva1qg3yPhMkJTivzzLepFuxcBOaieQuZf7jBciuIL63dtnpyIOPWiAo5ezNH1w59QdLEF+nO32uiM5xhuyhvi3QrFCE4K+Sq/5wsg9jbuiPCQgZtcrRfHcdrnNDT5HiEp/sILkOGqTCupB0eUFNkjHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710871216; c=relaxed/simple;
	bh=m6qS5617TuTpmfK97/po0jJIyNcw9wN2GHQJwTKGgww=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YgNU7whFRFdBmSLXS/O/gJ9dTZNrioF5K5ii8+iwqz0fSqsriPM/BIsD+OZBfUjAerkpliorTpnAvQxEyZrAZW87xoybggZ80ZxXQrviPiNURz4dBU9DU/UTXOLezrvrW1obw9/c6/94G/udLiH3DyiZqjgOED1aYt8PUJLB9dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P28VbwyB; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1dee5daedf6so7810645ad.0;
        Tue, 19 Mar 2024 11:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710871215; x=1711476015; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/7BfNykyTLG5a+/FmijDVcSSld3Qh/CcbfWa98bWLIQ=;
        b=P28VbwyBAyTRH+x0rSgK34ROjRqFr1yL00lFZjp3aaXgpXEb18eEbakS5Btk/or8Lb
         hAyWAPFNFCpdHqMJTAGf0ut2f0FYF7dWWisTnnuKgYxZmLzRQjG5omG9Xuoaw+NTYlnT
         5d2TqrxyVACfSeUSqng3fpS0ObQpFI22mhaDOb7bIfEVYQQYi9i5kD2AGDp1M76GoFsX
         jnLbF8W8cjY7wbq+SNgBpj0e58AwKUNJK56Ghr+ozMbcj6gJeaaMPtp+qRxRT8PGytwG
         rgrOj2Y8rvMFsEYZuMxiHnHs06XGEj8ey0q+KOMWCOY6YvowFq8y6hUi/3Q+SOS0gyFr
         ynJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710871215; x=1711476015;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/7BfNykyTLG5a+/FmijDVcSSld3Qh/CcbfWa98bWLIQ=;
        b=mEqsUQLG/FU3YPSrB1M6djBjqoQ27JrkRMbzwM0QtXo6Q5U0cXzuqqDdyRU48MVxpL
         tH2pqZqI/hwEk5Bfk+3QmhOnusJZ+MP0S+2o0smxwVPnrz4fpflN0H4sDLhCtsg5yMnj
         KfO1RbJ8N4bk3pk3YVlxF3nc9/VPSP32AYjCUowFFybIY7b0rkQBGU9riSU9jyYbsq/C
         dXH5J49IQtMxoxKD7fBotfj9yFLTc4ZUJKwUU2o57x7BP9+6dm2hRApjhnze+3D+FbdD
         9ZBgGUh9VrjQS73qfxURkeGZVK0DE+3GlKeqYQF9YcP5R7TpFVFG9+fXlTur12lTr3UR
         G6/g==
X-Forwarded-Encrypted: i=1; AJvYcCUQ7GK43co8a28dgK+OKjNrJFrJkxyqEfZyJ2XMOOCnSDCBHuPFxqf2jOWRar2rb1wLhUdt6ikIjjleRzLCC9vc/0NTTsU48T0PPegSx1/eTk4aQZMEyhnFLlySTI2U+X7YAfQ7KR7iohRTSXOEDUHqwKhWjTED4lRXrxvnSmuodVVh0ci5HdLHl/2Rh8AXjscmCwlglL+q/jgTtRD9Y1v5ZHzUgC2ED2pAJFcM
X-Gm-Message-State: AOJu0Yw5iOxD9WJD0kQYY5rX8hQMzyK9dVv7j3Y+AKNRf22kKG55aziw
	TUxirhrwoevl/JGrZSe2djhgwTM26PX9vD8E+W1x5XWwNZVysdr4
X-Google-Smtp-Source: AGHT+IHe8YREwchsBs/MaMDuaMAMnJOq1i+WfWlbqsJTZbtd+9d60AYKAxpEKoD2MKO4iTbMEMZ5oA==
X-Received: by 2002:a17:903:2448:b0:1dd:85eb:b11 with SMTP id l8-20020a170903244800b001dd85eb0b11mr3178823pls.1.1710871214158;
        Tue, 19 Mar 2024 11:00:14 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id u16-20020a17090341d000b001dd3bee3cd6sm5531359ple.219.2024.03.19.11.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 11:00:13 -0700 (PDT)
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
Subject: [PATCH 00/13] treewide: Refactor heap related implementation
Date: Wed, 20 Mar 2024 01:59:52 +0800
Message-Id: <20240319180005.246930-1-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

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

Kuan-Wei Chiu (13):
  perf/core: Fix several typos
  bcache: Fix typo
  bcachefs: Fix typo
  lib min_heap: Add type safe interface
  lib min_heap: Add min_heap_init()
  lib min_heap: Add min_heap_peek()
  lib min_heap: Add min_heap_full()
  lib min_heap: Add args for min_heap_callbacks
  lib min_heap: Update min_heap_push() and min_heap_pop() to return bool
    values
  bcache: Remove heap-related macros and switch to generic min_heap
  lib min_heap: Add min_heap_del()
  lib min_heap: Add min_heap_sift_up()
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
 drivers/md/dm-vdo/slab-depot.c |  21 ++--
 fs/bcachefs/clock.c            |  53 +++++++---
 fs/bcachefs/clock_types.h      |   2 +-
 fs/bcachefs/ec.c               |  99 +++++++++++-------
 fs/bcachefs/ec_types.h         |   2 +-
 fs/bcachefs/util.c             |   2 +-
 fs/bcachefs/util.h             | 127 ++---------------------
 include/linux/min_heap.h       | 180 ++++++++++++++++++++++++++-------
 kernel/events/core.c           |  53 +++++-----
 lib/test_min_heap.c            |  75 +++++++-------
 22 files changed, 565 insertions(+), 470 deletions(-)

-- 
2.34.1


