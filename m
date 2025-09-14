Return-Path: <linux-bcache+bounces-1207-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E59A1B56A9C
	for <lists+linux-bcache@lfdr.de>; Sun, 14 Sep 2025 18:32:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F2207AD8A5
	for <lists+linux-bcache@lfdr.de>; Sun, 14 Sep 2025 16:30:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D26302C325D;
	Sun, 14 Sep 2025 16:32:23 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0031EA7CE
	for <linux-bcache@vger.kernel.org>; Sun, 14 Sep 2025 16:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757867543; cv=none; b=KJFuCVtmtN71QOE+JqSR7U8KWNDGTD0FIzJZCBJN1B8QpVgvBPMWWw8Rndz2hHZoqH7hAai1UqEPvDkkbWVPaiQ5xg0Q8vRQyHY1bPOZL6E5s3tvMPAU5X3vYKtoRPO49jgdwFVcO5AVAt1sgRToDoiWTYYbnN8loXbk/i9+fK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757867543; c=relaxed/simple;
	bh=/fEjM9Qs4uVXgQ8hhlSwPcGyw/gv6wdtHZ/i9/b0HkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9Z+I7C+MAfsTxDHd/NvAUqxBILpTJT6oZg/otZwlbqKYoojlsfDZxA3UpNz9RUdoC9X/IZbyQ7NOqoRGryPgBDPuXk1xUVp+TlzEqeYzq9Kd8kgKM2ojxJuLZ4/1zy+mh71rOvoOw8aGPhsopFBe4u9uUAkyfLSGfwQsmzlKyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9C5C4CEF1;
	Sun, 14 Sep 2025 16:32:22 +0000 (UTC)
From: colyli@fnnas.com
To: linux-bcache@vger.kernel.org
Cc: Coly Li <colyli@fnnas.com>
Subject: [PATCH 3/4] bcache: drop discard sysfs interface
Date: Mon, 15 Sep 2025 00:32:15 +0800
Message-ID: <20250914163216.115036-3-colyli@fnnas.com>
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

Since discard code is removed, now the sysfs interface to enable discard
is useless. This patch removes the corresponding sysfs entry, and remove
bool variable 'discard' from struct cache as well.

Signed-off-by: Coly Li <colyli@fnnas.com>
---
 drivers/md/bcache/bcache.h    |  5 +----
 drivers/md/bcache/super.c     |  3 ---
 drivers/md/bcache/sysfs.c     | 15 ---------------
 drivers/md/bcache/writeback.c |  3 +--
 4 files changed, 2 insertions(+), 24 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 1d33e40d26ea..b8bd6d4a4298 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -447,8 +447,7 @@ struct cache {
 	 * free_inc: Incoming buckets - these are buckets that currently have
 	 * cached data in them, and we can't reuse them until after we write
 	 * their new gen to disk. After prio_write() finishes writing the new
-	 * gens/prios, they'll be moved to the free list (and possibly discarded
-	 * in the process)
+	 * gens/prios, they'll be moved to the free list.
 	 */
 	DECLARE_FIFO(long, free)[RESERVE_NR];
 	DECLARE_FIFO(long, free_inc);
@@ -467,8 +466,6 @@ struct cache {
 	 */
 	unsigned int		invalidate_needs_gc;
 
-	bool			discard; /* Get rid of? */
-
 	struct journal_device	journal;
 
 	/* The rest of this all shows up in sysfs */
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 1492c8552255..2c17231762c1 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2382,9 +2382,6 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 	ca->bdev = file_bdev(bdev_file);
 	ca->sb_disk = sb_disk;
 
-	if (bdev_max_discard_sectors(file_bdev(bdev_file)))
-		ca->discard = CACHE_DISCARD(&ca->sb);
-
 	ret = cache_alloc(ca);
 	if (ret != 0) {
 		if (ret == -ENOMEM)
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 826b14cae4e5..72f38e5b6f5c 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -134,7 +134,6 @@ read_attribute(partial_stripes_expensive);
 rw_attribute(synchronous);
 rw_attribute(journal_delay_ms);
 rw_attribute(io_disable);
-rw_attribute(discard);
 rw_attribute(running);
 rw_attribute(label);
 rw_attribute(errors);
@@ -1036,7 +1035,6 @@ SHOW(__bch_cache)
 	sysfs_hprint(bucket_size,	bucket_bytes(ca));
 	sysfs_hprint(block_size,	block_bytes(ca));
 	sysfs_print(nbuckets,		ca->sb.nbuckets);
-	sysfs_print(discard,		ca->discard);
 	sysfs_hprint(written, atomic_long_read(&ca->sectors_written) << 9);
 	sysfs_hprint(btree_written,
 		     atomic_long_read(&ca->btree_sectors_written) << 9);
@@ -1142,18 +1140,6 @@ STORE(__bch_cache)
 	if (bcache_is_reboot)
 		return -EBUSY;
 
-	if (attr == &sysfs_discard) {
-		bool v = strtoul_or_return(buf);
-
-		if (bdev_max_discard_sectors(ca->bdev))
-			ca->discard = v;
-
-		if (v != CACHE_DISCARD(&ca->sb)) {
-			SET_CACHE_DISCARD(&ca->sb, v);
-			bcache_write_super(ca->set);
-		}
-	}
-
 	if (attr == &sysfs_cache_replacement_policy) {
 		v = __sysfs_match_string(cache_replacement_policies, -1, buf);
 		if (v < 0)
@@ -1185,7 +1171,6 @@ static struct attribute *bch_cache_attrs[] = {
 	&sysfs_block_size,
 	&sysfs_nbuckets,
 	&sysfs_priority_stats,
-	&sysfs_discard,
 	&sysfs_written,
 	&sysfs_btree_written,
 	&sysfs_metadata_written,
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 302e75f1fc4b..59cd0c3f8ce9 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -805,8 +805,7 @@ static int bch_writeback_thread(void *arg)
 			 * may set BCH_ENABLE_AUTO_GC via sysfs, then when
 			 * BCH_DO_AUTO_GC is set, garbage collection thread
 			 * will be wake up here. After moving gc, the shrunk
-			 * btree and discarded free buckets SSD space may be
-			 * helpful for following write requests.
+			 * btree may be helpful for following write requests.
 			 */
 			if (c->gc_after_writeback ==
 			    (BCH_ENABLE_AUTO_GC|BCH_DO_AUTO_GC)) {
-- 
2.47.3


