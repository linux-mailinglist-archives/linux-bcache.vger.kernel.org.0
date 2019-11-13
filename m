Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48043FABBA
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Nov 2019 09:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfKMIF4 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 13 Nov 2019 03:05:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:53368 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726613AbfKMIF4 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 13 Nov 2019 03:05:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CC2DEAC44;
        Wed, 13 Nov 2019 08:05:53 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 09/12] bcache: add idle_max_writeback_rate sysfs interface
Date:   Wed, 13 Nov 2019 16:03:23 +0800
Message-Id: <20191113080326.69989-10-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191113080326.69989-1-colyli@suse.de>
References: <20191113080326.69989-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

For writeback mode, if there is no regular I/O request for a while,
the writeback rate will be set to the maximum value (1TB/s for now).
This is good for most of the storage workload, but there are still
people don't what the maximum writeback rate in I/O idle time.

This patch adds a sysfs interface file idle_max_writeback_rate to
permit people to disable maximum writeback rate. Then the minimum
writeback rate can be advised by writeback_rate_minimum in the
bcache device's sysfs interface.

Reported-by: Christian Balzer <chibi@gol.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/bcache.h    | 1 +
 drivers/md/bcache/super.c     | 1 +
 drivers/md/bcache/sysfs.c     | 7 +++++++
 drivers/md/bcache/writeback.c | 4 ++++
 4 files changed, 13 insertions(+)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 50241e045c70..9198c1b480d9 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -724,6 +724,7 @@ struct cache_set {
 	unsigned int		gc_always_rewrite:1;
 	unsigned int		shrinker_disabled:1;
 	unsigned int		copy_gc_enabled:1;
+	unsigned int		idle_max_writeback_rate_enabled:1;
 
 #define BUCKET_HASH_BITS	12
 	struct hlist_head	bucket_hash[1 << BUCKET_HASH_BITS];
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index d1352fcc6ff2..77e9869345e7 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1834,6 +1834,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 	c->congested_read_threshold_us	= 2000;
 	c->congested_write_threshold_us	= 20000;
 	c->error_limit	= DEFAULT_IO_ERROR_LIMIT;
+	c->idle_max_writeback_rate_enabled = 1;
 	WARN_ON(test_and_clear_bit(CACHE_SET_IO_DISABLE, &c->flags));
 
 	return c;
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 627dcea0f5b6..733e2ddf3c78 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -134,6 +134,7 @@ rw_attribute(expensive_debug_checks);
 rw_attribute(cache_replacement_policy);
 rw_attribute(btree_shrinker_disabled);
 rw_attribute(copy_gc_enabled);
+rw_attribute(idle_max_writeback_rate);
 rw_attribute(gc_after_writeback);
 rw_attribute(size);
 
@@ -747,6 +748,8 @@ SHOW(__bch_cache_set)
 	sysfs_printf(gc_always_rewrite,		"%i", c->gc_always_rewrite);
 	sysfs_printf(btree_shrinker_disabled,	"%i", c->shrinker_disabled);
 	sysfs_printf(copy_gc_enabled,		"%i", c->copy_gc_enabled);
+	sysfs_printf(idle_max_writeback_rate,	"%i",
+		     c->idle_max_writeback_rate_enabled);
 	sysfs_printf(gc_after_writeback,	"%i", c->gc_after_writeback);
 	sysfs_printf(io_disable,		"%i",
 		     test_bit(CACHE_SET_IO_DISABLE, &c->flags));
@@ -864,6 +867,9 @@ STORE(__bch_cache_set)
 	sysfs_strtoul_bool(gc_always_rewrite,	c->gc_always_rewrite);
 	sysfs_strtoul_bool(btree_shrinker_disabled, c->shrinker_disabled);
 	sysfs_strtoul_bool(copy_gc_enabled,	c->copy_gc_enabled);
+	sysfs_strtoul_bool(idle_max_writeback_rate,
+			   c->idle_max_writeback_rate_enabled);
+
 	/*
 	 * write gc_after_writeback here may overwrite an already set
 	 * BCH_DO_AUTO_GC, it doesn't matter because this flag will be
@@ -954,6 +960,7 @@ static struct attribute *bch_cache_set_internal_files[] = {
 	&sysfs_gc_always_rewrite,
 	&sysfs_btree_shrinker_disabled,
 	&sysfs_copy_gc_enabled,
+	&sysfs_idle_max_writeback_rate,
 	&sysfs_gc_after_writeback,
 	&sysfs_io_disable,
 	&sysfs_cutoff_writeback,
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index d60268fe49e1..4a40f9eadeaf 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -122,6 +122,10 @@ static void __update_writeback_rate(struct cached_dev *dc)
 static bool set_at_max_writeback_rate(struct cache_set *c,
 				       struct cached_dev *dc)
 {
+	/* Don't sst max writeback rate if it is disabled */
+	if (!c->idle_max_writeback_rate_enabled)
+		return false;
+
 	/* Don't set max writeback rate if gc is running */
 	if (!c->gc_mark_valid)
 		return false;
-- 
2.16.4

