Return-Path: <linux-bcache+bounces-1195-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BBD37B3A5F4
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Aug 2025 18:17:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C71BA04CB8
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Aug 2025 16:17:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26949321425;
	Thu, 28 Aug 2025 16:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t5EQ2c0n"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0241A320CD5
	for <linux-bcache@vger.kernel.org>; Thu, 28 Aug 2025 16:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756397847; cv=none; b=kUufWZbVU/g6Dmmhz3o7XDmemRGzHND8ff2lqgAldKrJT3i52me3esZjml3bTBcPmhW8ZAS3R9T3+wyRvzxUBAIKl92CGwuakDpLrChtW9kNPwg01fho8zejQPYsl+Ludac2UEr8HbhCCBTfSUdZBosJoO5MeeSRYrEMHNWZ6rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756397847; c=relaxed/simple;
	bh=PR3vY5ffYK40VuRGUutilQROvTUZuOeCaQGWI91oB1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCoXTzmwtQB1F7rnYcfxqB7hYKJgdTFk/2TncCFO37AeUZxBNa+2fzclSWYyhnuOKGEuXkw3H3LVfvLlvNGT6KSDdUlOu0HZ0run0UDTEaoww1chTXSHnU5GTVZCBl8NrZSgTUILJCjKsDP5fAUK2U/oAmmdUtZG/Ek4YgFLNWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t5EQ2c0n; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FEBC4CEEB;
	Thu, 28 Aug 2025 16:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756397846;
	bh=PR3vY5ffYK40VuRGUutilQROvTUZuOeCaQGWI91oB1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t5EQ2c0nOb9V8OYy4Jh03UxeBludwOBAPPGbI4fI0LOYSVw2O388XEvYw02n+t/kR
	 mwAjGb4iVIsZnt+HSx2PY4X5geSEK/g65Lj+ocF43iyKKcXC/TGb54Bj9E2zoVNlrk
	 Jk4vs9podKWvrvuRxVP4iaTzaacOhFiQplQu7R9QrRfZ+6r+GmvAGdULBaJFOjJV3S
	 h8/vvmC9S6x8Fh2P+MFCwFs2DFugwLHVzrKBx1YfYIOPmm36b/+GICS+MLlTdm/WWm
	 p2k/2rS4w9vbGA2DL4DoIzYqPlv+EtpUElcSvhSZhJWdNA5UG9OG/M8veY+/Z4SEuQ
	 GhJbEJdaHxazQ==
From: colyli@kernel.org
To: linux-bcache@vger.kernel.org
Cc: Coly Li <colyli@suse.de>,
	Coly Li <colyli@fnnas.com>
Subject: [PATCH 4/4] bcache: remove discard sysfs interface document
Date: Fri, 29 Aug 2025 00:17:17 +0800
Message-ID: <20250828161717.33518-4-colyli@kernel.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250828161717.33518-1-colyli@kernel.org>
References: <20250828161717.33518-1-colyli@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Coly Li <colyli@suse.de>

This patch removes documents of bcache discard sysfs interface, it
drops discard related sections from,
- Documentation/ABI/testing/sysfs-block-bcache
- Documentation/admin-guide/bcache.rst

Signed-off-by: Coly Li <colyli@fnnas.com>
---
 Documentation/ABI/testing/sysfs-block-bcache |  7 -------
 Documentation/admin-guide/bcache.rst         | 13 ++-----------
 2 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-block-bcache b/Documentation/ABI/testing/sysfs-block-bcache
index 9e4bbc5d51fd..9344a657ca70 100644
--- a/Documentation/ABI/testing/sysfs-block-bcache
+++ b/Documentation/ABI/testing/sysfs-block-bcache
@@ -106,13 +106,6 @@ Description:
 		will be discarded from the cache. Should not be turned off with
 		writeback caching enabled.
 
-What:		/sys/block/<disk>/bcache/discard
-Date:		November 2010
-Contact:	Kent Overstreet <kent.overstreet@gmail.com>
-Description:
-		For a cache, a boolean allowing discard/TRIM to be turned off
-		or back on if the device supports it.
-
 What:		/sys/block/<disk>/bcache/bucket_size
 Date:		November 2010
 Contact:	Kent Overstreet <kent.overstreet@gmail.com>
diff --git a/Documentation/admin-guide/bcache.rst b/Documentation/admin-guide/bcache.rst
index 6fdb495ac466..f71f349553e4 100644
--- a/Documentation/admin-guide/bcache.rst
+++ b/Documentation/admin-guide/bcache.rst
@@ -17,8 +17,7 @@ The latest bcache kernel code can be found from mainline Linux kernel:
 It's designed around the performance characteristics of SSDs - it only allocates
 in erase block sized buckets, and it uses a hybrid btree/log to track cached
 extents (which can be anywhere from a single sector to the bucket size). It's
-designed to avoid random writes at all costs; it fills up an erase block
-sequentially, then issues a discard before reusing it.
+designed to avoid random writes at all costs.
 
 Both writethrough and writeback caching are supported. Writeback defaults to
 off, but can be switched on and off arbitrarily at runtime. Bcache goes to
@@ -618,19 +617,11 @@ bucket_size
 cache_replacement_policy
   One of either lru, fifo or random.
 
-discard
-  Boolean; if on a discard/TRIM will be issued to each bucket before it is
-  reused. Defaults to off, since SATA TRIM is an unqueued command (and thus
-  slow).
-
 freelist_percent
   Size of the freelist as a percentage of nbuckets. Can be written to to
   increase the number of buckets kept on the freelist, which lets you
   artificially reduce the size of the cache at runtime. Mostly for testing
-  purposes (i.e. testing how different size caches affect your hit rate), but
-  since buckets are discarded when they move on to the freelist will also make
-  the SSD's garbage collection easier by effectively giving it more reserved
-  space.
+  purposes (i.e. testing how different size caches affect your hit rate).
 
 io_errors
   Number of errors that have occurred, decayed by io_error_halflife.
-- 
2.47.2


