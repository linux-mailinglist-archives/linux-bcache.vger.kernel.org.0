Return-Path: <linux-bcache+bounces-1208-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4985B56A9B
	for <lists+linux-bcache@lfdr.de>; Sun, 14 Sep 2025 18:32:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95A7E3A98C9
	for <lists+linux-bcache@lfdr.de>; Sun, 14 Sep 2025 16:32:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E534D2DCBF4;
	Sun, 14 Sep 2025 16:32:24 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1AA1EA7CE
	for <linux-bcache@vger.kernel.org>; Sun, 14 Sep 2025 16:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757867544; cv=none; b=ZB+Mb2suwUtjRo65CPhmRqqK4Dv8g97ir1kiTZQpMKFUDrMrKbzRXDlxF28sgXW+ZeYXVBjeRud78U9X9fBSc9RRemYslLta322hdr60xLflzBzRGu1f4lJmvdBcfk+4ZS+oADBWAEfbLcIdRlEGS62pjX9q4AHtj1QiW2aEtXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757867544; c=relaxed/simple;
	bh=jOoDbp6fAgesc1rlON005ue+v2QyXSdaDaWUcVv8+YY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6BbFwTwpNVo1O1u/pkjafebaXq/hdnVp1Qw3bAG0Rs9eMoKjXG2hMcv0TnSJDWKkEOUnERMrJPJNnBGKwEpk8bKn3db6bbYIXS5w7xafrXPr2UomMXuxgDBXbMwxhOktbNHHWr0Xo5I7dJUB2jDZXI5mpsXflDj3NvrbWpgRuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30CEC4CEF1;
	Sun, 14 Sep 2025 16:32:23 +0000 (UTC)
From: colyli@fnnas.com
To: linux-bcache@vger.kernel.org
Cc: Coly Li <colyli@fnnas.com>
Subject: [PATCH 4/4] bcache: remove discard sysfs interface document
Date: Mon, 15 Sep 2025 00:32:16 +0800
Message-ID: <20250914163216.115036-4-colyli@fnnas.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250914163216.115036-1-colyli@fnnas.com>
References: <20250914163216.115036-1-colyli@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Coly Li <colyli@fnnas.com>

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
2.47.3


