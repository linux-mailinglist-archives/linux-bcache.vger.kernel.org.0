Return-Path: <linux-bcache+bounces-881-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ACB8A8A5E5
	for <lists+linux-bcache@lfdr.de>; Tue, 15 Apr 2025 19:43:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1CC0A4439E0
	for <lists+linux-bcache@lfdr.de>; Tue, 15 Apr 2025 17:43:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BA9D21C160;
	Tue, 15 Apr 2025 17:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t6z8wVvy"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9CC4D8CE
	for <linux-bcache@vger.kernel.org>; Tue, 15 Apr 2025 17:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744738972; cv=none; b=FnvLMOCTEy5jOmtzCXi76ottCwVuh2lH0or5OhxCwWmi7iMgit+Z6CQd0HR4zzmKMSoyycu3nMaj1tJLPEJ2KQD8E3FpwrXPrl3vgPo269M42V7QC5dzFFshZYIsqYwPuybaraA3CNLHVSXNxCDfIjpwueKtnFog5hgdz106pFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744738972; c=relaxed/simple;
	bh=saqD4/2cnRA4wMxPtE/9T0O1QMarNZRc8eweXImoehI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=bl3JsOVnlLgrz8fm/3NPWYY5ry267GF60trUzyKlRtHUByGO7CJpnVh5QH5PDhiUC8VIBrJkgeNDvSfFFAeWAqebg5nYaEcWy7nfBDUqnaJbckzdka6knwPkek7tdkv/wKYlUcGUQW0mfR4Pvz9SwmXsXKCuWZ+kpg1bAwQA9X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t6z8wVvy; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-af5a8c67707so3531370a12.1
        for <linux-bcache@vger.kernel.org>; Tue, 15 Apr 2025 10:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744738970; x=1745343770; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=S7GraCRdd2ihrmFba9Lx7z5JAv6Wo8aByo8kLXURkuY=;
        b=t6z8wVvyYCpukCKoxF2s2tWgRT+JWZSsTzSi974kHlphX2omYK2PPt3uol8B0VM1Mc
         Itc3zehFtV3KzKTbGG0f+4kb4RC5byyxBLMhxTpDESc8opA/qwYp6VySFkK1ZHy8vCQ/
         OV+Op2byiVjDEif2/twOq7lXBBAw3Xo0XiFg5ZKOmN9nJdv3pI8oCLD6iYkd1nsXKEfR
         d3Wgbz+1Cy2oEKSZYMumJrZ9FdGQoVpokUkvLZ3Ga/IpWtENESfgUE40A5NZmUVVSaI5
         dR/GiReRr2E7N0qVDi3WokOT5lEQqbz4jp58clWt94OU3KgJMKGa6c1r9HmKSV7EFh1t
         zJsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744738970; x=1745343770;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S7GraCRdd2ihrmFba9Lx7z5JAv6Wo8aByo8kLXURkuY=;
        b=T9Crx+mesWllGr5y16AOm86KmyV7fHfRa6d66S5njcuoa6lffBI4SBHoMHSyQSppu1
         Cw224X6ur1lILzX41hZl3aYHc/w8RJMNBjOSqhEkRx1ylbKJcz56uUg9vAmIpaZQNxYm
         sGozc8cVpRgaY43bxUl3hOTffbWJlDSZSSj09d42sUH5yUtHMQ+xc0BI4J4ovKXkAdf4
         Xrk7IJdTLiXsvskBqQ3dqKSGvcToUZQfms2RBXFK1g2cffJScxfpFPiBFuE3XWy8P4CJ
         mKcDNeQwXgQfRrVuMK3Nh/Mo2S8WGOYtFT3MHCbcbolpRRuVhYt2cEfQ2mmk4QLKZKaY
         skQw==
X-Forwarded-Encrypted: i=1; AJvYcCVVUUreezq4c6vsR8GiZADLZIFSAtqcdnEo62Tw1ZSRRLMg/qdnpvN2Q4+fGL8CRB2T/K2bIYPWDncb2tA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxyx8JkVwT5F8DMUfQGmxS4YsESkD4BCCj+Jq8woyDM9pXpIfeJ
	6sKcuQO5WHRymCGMOXUwCtlMBFWJE7nHB89cghyUTRNcm2E9XsdarOkce5UGWUGkxVzXKliXFfD
	/GBK4uVg+uqgaSqjUyw==
X-Google-Smtp-Source: AGHT+IG/ewfJqX5R1Wny51xmdGgxlc7AKgEFdy2OVOplIiaBDDFuPMoJIIm3yz84hpdTmCzBndSqr06YgyeRVPro
X-Received: from plsh9.prod.google.com ([2002:a17:902:b949:b0:21f:40e5:a651])
 (user=robertpang job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:230a:b0:223:fbc7:25f4 with SMTP id d9443c01a7336-22c318bbe09mr637805ad.14.1744738969900;
 Tue, 15 Apr 2025 10:42:49 -0700 (PDT)
Date: Tue, 15 Apr 2025 10:39:07 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.805.g082f7c87e0-goog
Message-ID: <20250415174145.346121-1-robertpang@google.com>
Subject: [PATCH v2 0/1] bcache: reduce front IO latency during GC
From: Robert Pang <robertpang@google.com>
To: Coly Li <colyli@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcache@vger.kernel.org
Cc: Robert Pang <robertpang@google.com>, Mingzhe Zou <mingzhe.zou@easystack.cn>
Content-Type: text/plain; charset="UTF-8"

In performance benchmarks on disks with bcache using the Linux 6.6 kernel, we
observe noticeable IO latency increase during btree garbage collection. The
increase ranges from high tens to hundreds of milliseconds, depending on the
size of the cache device. Further investigation reveals that it is the same
issue reported in [1], where the large number of nodes processed in each
incremental GC cycle causes the front IO latency.

Building upon the approach suggested in [1], this patch decomposes the
incremental GC process into more but smaller cycles. In contrast to [1], this
implementation adopts a simpler strategy by setting a lower limit of 10 nodes
per cycle to reduce front IO delay and introducing a fixed 10ms sleep per cycle
when front IO is in progress. Furthermore, when garbage collection statistics
are available, the number of nodes processed per cycle is dynamically rescaled
based on the average GC frequency to ensure GC completes well within the next
subsequent scheduled interval.

Testing with a 750GB NVMe cache and 256KB bucket size using the following fio
configuration demonstrates that our patch reduces front IO latency during GC
without significantly increasing GC duration.

ioengine=libaio
direct=1
bs=4k
size=900G
iodepth=10
readwrite=randwrite
log_avg_msec=10

Before:

time-ms,latency-ns,,,

12170, 285016, 1, 0, 0
12183, 296581, 1, 0, 0
12207, 6542725, 1, 0, 0
12242, 24483604, 1, 0, 0
12250, 1895628, 1, 0, 0
12260, 284854, 1, 0, 0
12270, 275513, 1, 0, 0

/sys/block/bcache0/bcache/cache/internal/btree_gc_average_duration_ms:2880
/sys/block/bcache0/bcache/cache/internal/btree_gc_average_frequency_sec:133
/sys/block/bcache0/bcache/cache/internal/btree_gc_last_sec:121
/sys/block/bcache0/bcache/cache/internal/btree_gc_max_duration_ms:3456

After:

12690, 378494, 1, 0, 0
12700, 413934, 1, 0, 0
12710, 661217, 1, 0, 0
12727, 354510, 1, 0, 0
12730, 1100768, 1, 0, 0
12742, 382484, 1, 0, 0
12750, 532679, 1, 0, 0
12760, 572758, 1, 0, 0
12773, 283416, 1, 0, 0

/sys/block/bcache0/bcache/cache/internal/btree_gc_average_duration_ms:3619
/sys/block/bcache0/bcache/cache/internal/btree_gc_average_frequency_sec:58
/sys/block/bcache0/bcache/cache/internal/btree_gc_last_sec:23
/sys/block/bcache0/bcache/cache/internal/btree_gc_max_duration_ms:3866

[1] https://lore.kernel.org/all/20220511073903.13568-1-mingzhe.zou@easystack.cn/

---

Changes in v2:
- Move the deletion of unused MAX_NEED_GC and MAX_SAVE_PRIO to a separate patch
- Add code comments to explain time_stat_average().

Robert Pang (1):
  bcache: process fewer btree nodes in incremental GC cycles

 drivers/md/bcache/btree.c | 36 +++++++++++++++++-------------------
 drivers/md/bcache/util.h  |  7 +++++++
 2 files changed, 24 insertions(+), 19 deletions(-)

-- 
2.49.0.805.g082f7c87e0-goog


