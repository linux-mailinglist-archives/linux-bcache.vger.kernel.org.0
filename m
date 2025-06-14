Return-Path: <linux-bcache+bounces-1135-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0176AAD9FAD
	for <lists+linux-bcache@lfdr.de>; Sat, 14 Jun 2025 22:24:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 863C91758DB
	for <lists+linux-bcache@lfdr.de>; Sat, 14 Jun 2025 20:24:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4EB519CC37;
	Sat, 14 Jun 2025 20:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GURsOUSP"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F75411CBA;
	Sat, 14 Jun 2025 20:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749932663; cv=none; b=bKbN0B5NtOCXMuMCeiNm9A3xxp98A8QXGVKidX+VEwymKbNOiAToCDJ0MdImrNDLdb3VxJd+TkbbUaunr6ITVH5jCAm+zfSlyxn1YJ/l2psEXsg2/dePDCZlTeWXKBxnVgI6duFMpcB8A+wttQrrBkZWYYw/dyRDlvpSvzIGrUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749932663; c=relaxed/simple;
	bh=7PXLGqUqQ0UqO6yC4+uUksATWBhaDmb8sXQP4kOQOyw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BXdSj5LUlfCJlh3HvpMzIfyxzzfGdQNoheVZmjjMEsi1XYl0OZe3SuApqjPVUQYu2NbIljJE53RTgAA0IEDKFegZOY4/8Dl7BCB+VNxD8hsKESz0//t9UL5joRxjNIbkkJKxmqBM7Yr2vLUIHwohEsAoODeyxDe/L9MXY9/y+y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GURsOUSP; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-747fc77ba9eso2826579b3a.0;
        Sat, 14 Jun 2025 13:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749932661; x=1750537461; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cEJWImNKI/Mo4L81F7iSo/k8ivjp2qlIjkSlWqFvS4Y=;
        b=GURsOUSPQzB5Z8p13ArP8oSSB/QgIe5Nnxcz9EpfBgXHIDVRrKIGSddqIj/S1PaMJs
         w3S1+3GBkMXM0/CSfBSYnZNH+QMvKLdzZWxOjGpS/KZS6+SobIjlnwPg28Zi0xgC6Cff
         glDgGTwGDRBOZ59I0OZppUgYlEmObWWWfDXFL0E3Q3X2AGXsQDdqltAscMhzjyJ887hq
         2xml94Obtut51JEMf0DPG4UWZdXD7c1K3azXBpw4lrwx3qizMOA4dix1Quap0o1SC2RX
         n4WkJU+J5JHGlcflnys/eKTOPT1Vrp1BCNHGhBZVPNlwQD81bL8AkbqrMFn3JRVbj/1j
         P0QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749932661; x=1750537461;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cEJWImNKI/Mo4L81F7iSo/k8ivjp2qlIjkSlWqFvS4Y=;
        b=NYOv26cTAgV5qJrxWoRXb+fx3ONcu8a0xFHmtNfe1QKHwqyp3kDaubeLExJVtbpc/6
         8LOaj6fWcu8YjiUkTRy/sQ6RpOtxpKFGa+AoYifbttJLsXSbhJXQzf/tBtoFMCgNqiPV
         fraZe3v6Ot1x09yMayYPkxWGCaRXjkBScetdXfB2YK8NR6k0ZfF/mN6cP0HMQLefgHt3
         q7CZehMcSvfB68dem/pjroeNjF2MGVRAllcNHdiJMtKck7r9tQpzO+yKUZL2at/JVftY
         H80f9sKaNCjtqt+meEplEklYSA9bPq68MHfWPa0ib9xhHdQCuDa7Wi29PhsnipbZ284F
         4Fbw==
X-Forwarded-Encrypted: i=1; AJvYcCUbLmyN88MNW+52Z9mUmiOHDLLTY9rto/fy9p3J3r3zhXywI1f88W1LNw8zazTn1p/UEUzrHly6sy2EgEg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzssMAKbNa2ckQM2QPX241eWeNwA+Otu0B18xf255m2Hk/ekko9
	LS09qe1RwLZFLofDYMnCDHEf7i9G6KGy+8GmtWOegfk/Wa/g/GfCGEM9
X-Gm-Gg: ASbGncttEex4dSW8IM8kxxfEQQISTIwb+h05xM+zzYxO61paa3R85z0w7pSRA75DdpQ
	N5VB9S6g4cYIitpZTuCCOVxBav8g/oPbNHA8IeFrUmwD20gTBiZ3ecnZFn/SVhqJDEiKFhL4SS9
	l1jBUABvi+0Vjyw/x7u5r71m1Gc4PeEPWyfaojrD0QFCKtEq3XR6TdZLO663C+JSW9nmwCjA5PZ
	UnPtPwYFUAbf8dMkjGO7bYkdUztSjH3FVzGS5hz5UatL41xvju1AXQsd9qHlCzkp2wasHwr2rYy
	mV7RdVWdXjRIuD7ktsxKIZkm1auc4gqOgWQsstaspI12lUp/l2u23IEo1+xg5EmbyPhCahF5PvS
	zrgx1tYRlwHEujScfUbTm330E3wg=
X-Google-Smtp-Source: AGHT+IHiNpVBdvskW2kbjdynxVZGERG6iJbNNILPkhdXSNAAEHiRBDaYcoXIp7Iun9Q/dvJlTJa00Q==
X-Received: by 2002:a05:6a00:4b0f:b0:73d:fefb:325 with SMTP id d2e1a72fcca58-7489cdee02dmr5077491b3a.5.1749932661281;
        Sat, 14 Jun 2025 13:24:21 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900d738esm3863351b3a.177.2025.06.14.13.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jun 2025 13:24:20 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: akpm@linux-foundation.org,
	colyli@kernel.org,
	kent.overstreet@linux.dev,
	robertpang@google.com
Cc: linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	jserv@ccns.ncku.edu.tw,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH v2 0/3] bcache: Revert min_heap migration due to performance regression
Date: Sun, 15 Jun 2025 04:23:50 +0800
Message-Id: <20250614202353.1632957-1-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series reverts the migration of bcache from its original
heap implementation to the generic min_heap library. While the original
change aimed to simplify the code and improve maintainability, it
introduced a severe performance regression in real-world scenarios.

As reported by Robert, systems using bcache now suffer from periodic
latency spikes, with P100 (max) latency increasing from 600 ms to
2.4 seconds every 5 minutes. This degrades bcache's value as a
low-latency caching layer, and leads to frequent timeouts and
application stalls in production environments.

The primary cause of this regression is the behavior of the generic
min_heap implementation's bottom-up sift_down, which performs up to
2 * log2(n) comparisons when many elements are equal. The original
top-down variant used by bcache only required O(1) comparisons in such
cases. The issue was further exacerbated by commit 92a8b224b833
("lib/min_heap: introduce non-inline versions of min heap API
functions"), which introduced non-inlined versions of the min_heap API,
adding function call overhead to a performance-critical hot path.
---

Changes in v2:
- Drop the proposed new min_heap API approach.
- Replace with full reverts of the min_heap-related changes in bcache.

v1: https://lore.kernel.org/lkml/20250610215516.1513296-1-visitorckw@gmail.com

Note: I'm aware that this revert series changes more than 100 lines of
code, which exceeds the typical guideline for stable backports.
However, introducing new generic APIs to fix this regression would also
involve over 100 lines of changes and add new features. In contrast,
reverting to a previously known-good state is a safer and more
straightforward solution in this case.

Kuan-Wei Chiu (3):
  Revert "bcache: update min_heap_callbacks to use default builtin swap"
  Revert "bcache: remove heap-related macros and switch to generic
    min_heap"
  bcache: Remove unnecessary select MIN_HEAP

 drivers/md/bcache/Kconfig     |   1 -
 drivers/md/bcache/alloc.c     |  57 +++++------------
 drivers/md/bcache/bcache.h    |   2 +-
 drivers/md/bcache/bset.c      | 116 +++++++++++++---------------------
 drivers/md/bcache/bset.h      |  40 +++++++-----
 drivers/md/bcache/btree.c     |  69 +++++++++-----------
 drivers/md/bcache/extents.c   |  45 ++++++-------
 drivers/md/bcache/movinggc.c  |  33 +++-------
 drivers/md/bcache/super.c     |   3 +-
 drivers/md/bcache/sysfs.c     |   4 +-
 drivers/md/bcache/util.h      |  67 +++++++++++++++++++-
 drivers/md/bcache/writeback.c |  13 ++--
 12 files changed, 217 insertions(+), 233 deletions(-)

-- 
2.34.1


