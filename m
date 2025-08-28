Return-Path: <linux-bcache+bounces-1194-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 22F7EB3A5F3
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Aug 2025 18:17:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C21D188EDD9
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Aug 2025 16:17:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1278320CD8;
	Thu, 28 Aug 2025 16:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RLcYi0iS"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE2426CE11
	for <linux-bcache@vger.kernel.org>; Thu, 28 Aug 2025 16:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756397845; cv=none; b=lqYGcztWuy0kLw3y3jeiqmRCd+UJhXxBjQDQQHDqoT/QJumHFPY4VjjI4pvGtcXpFl5AN9/+Rs1kf73mNy+A3D7amYNW/uZPpgiZQsXAuZUecakrxcrfOfvdauWLpOxB51j5jrjL+3fCJnBb2Aks/tKW6pDae3ySv4UoxSEXXMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756397845; c=relaxed/simple;
	bh=3+5ToAT6pe2oK82eMMTf91+wBfdTAnwsn/FMs0eATEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eH2Y48mhVDpO1GOHbuK4rb8SLEMwVKjExKUFPsH/nmIi/YCyXul2gqPlrg6prOkkiDBNdbGj8j3EKVBpXdzmBV5Kl37ZRUxRZoAv3hcBq/ctzbGeuyOIP5a2n+1Gu+iaNRchBvo9WfzsevWfvKrAkxDvZOlfv0UYSW0hu0ZNN4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RLcYi0iS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F21C4CEEB;
	Thu, 28 Aug 2025 16:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756397845;
	bh=3+5ToAT6pe2oK82eMMTf91+wBfdTAnwsn/FMs0eATEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RLcYi0iSgSYbh3qeGh2Ih/WEDR/zI7piKEe6+wFJoBJGbzG/kup7QNxlQsX58GIob
	 krdp/YhZV8es5eEcGgendx3W9dkGeu0vbkLxtVroVAgDexIclpuzTISVoQ6EZhPOEf
	 RUqkT2W+afPGHDyXlpBVNw6d7U2KhqAchJbjzTK1FMKur3iSUDwC3GEf7gGUcDYYD5
	 mzXMbPOM2EqeJvqZpnrPLhKiFYEkW+1CUCWhMmHw8AwXy4kr2YI4aa7KVV9UadjB66
	 JfyR5gM5hqbwuwWq2F+AFJvebbZLhjBS2jK8IT0iK57WGQ9cN+yx7YMEYhQEtpuAeE
	 KoOK7/hXtFpBg==
From: colyli@kernel.org
To: linux-bcache@vger.kernel.org
Cc: Coly Li <colyli@suse.de>,
	Coly Li <colyli@fnnas.com>
Subject: [PATCH 3/4] bcache: drop discard sysfs interface
Date: Fri, 29 Aug 2025 00:17:16 +0800
Message-ID: <20250828161717.33518-3-colyli@kernel.org>
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
index 88fb9bb69ce9..f75417b8e228 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -448,8 +448,7 @@ struct cache {
 	 * free_inc: Incoming buckets - these are buckets that currently have
 	 * cached data in them, and we can't reuse them until after we write
 	 * their new gen to disk. After prio_write() finishes writing the new
-	 * gens/prios, they'll be moved to the free list (and possibly discarded
-	 * in the process)
+	 * gens/prios, they'll be moved to the free list.
 	 */
 	DECLARE_FIFO(long, free)[RESERVE_NR];
 	DECLARE_FIFO(long, free_inc);
@@ -468,8 +467,6 @@ struct cache {
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
index 4f0e47c841aa..32703a51e6ab 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -793,8 +793,7 @@ static int bch_writeback_thread(void *arg)
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
2.47.2


