Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2522E86A0
	for <lists+linux-bcache@lfdr.de>; Sat,  2 Jan 2021 08:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbhABHNT (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 2 Jan 2021 02:13:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:47628 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbhABHNT (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 2 Jan 2021 02:13:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 54C65AD60;
        Sat,  2 Jan 2021 07:12:37 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 4/4] bcache: set bcache device into read-only mode for BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET
Date:   Sat,  2 Jan 2021 15:12:23 +0800
Message-Id: <20210102071223.58303-5-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210102071223.58303-1-colyli@suse.de>
References: <20210102071223.58303-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

If BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET is set in incompat feature
set, it means the cache device is created with obsoleted layout with
obso_bucket_site_hi. Now bcache does not support this feature bit, a new
BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE incompat feature bit is added
for a better layout to support large bucket size.

For the legacy compatibility purpose, if a cache device created with
obsoleted BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET feature bit, all bcache
devices attached to this cache set should be set to read-only. Then the
dirty data can be written back to backing device before re-create the
cache device with BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE feature bit
by the latest bcache-tools.

This patch checks BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET feature bit
when running a cache set and attach a bcache device to the cache set. If
this bit is set,
- When run a cache set, print an error kernel message to indicate all
  following attached bcache device will be read-only.
- When attach a bcache device, print an error kernel message to indicate
  the attached bcache device will be read-only, and ask users to update
  to latest bcache-tools.

Such change is only for cache device whose bucket size >= 32MB, this is
for the zoned SSD and almost nobody uses such large bucket size at this
moment. If you don't explicit set a large bucket size for a zoned SSD,
such change is totally transparent to your bcache device.

Fixes: ffa470327572 ("bcache: add bucket_size_hi into struct cache_sb_disk for large bucket")
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index d742eb5dc2e5..6cb8a591cefc 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1332,6 +1332,12 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 	bcache_device_link(&dc->disk, c, "bdev");
 	atomic_inc(&c->attached_dev_nr);
 
+	if (bch_has_feature_obso_large_bucket(&(c->cache->sb))) {
+		pr_err("The obsoleted large bucket layout is unsupported, set the bcache device into read-only\n");
+		pr_err("Please update to the latest bcache-tools to create the cache device\n");
+		set_disk_ro(dc->disk.disk, 1);
+	}
+
 	/* Allow the writeback thread to proceed */
 	up_write(&dc->writeback_lock);
 
@@ -1554,6 +1560,12 @@ static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
 
 	bcache_device_link(d, c, "volume");
 
+	if (bch_has_feature_obso_large_bucket(&c->cache->sb)) {
+		pr_err("The obsoleted large bucket layout is unsupported, set the bcache device into read-only\n");
+		pr_err("Please update to the latest bcache-tools to create the cache device\n");
+		set_disk_ro(d->disk, 1);
+	}
+
 	return 0;
 err:
 	kobject_put(&d->kobj);
@@ -2113,6 +2125,9 @@ static int run_cache_set(struct cache_set *c)
 	c->cache->sb.last_mount = (u32)ktime_get_real_seconds();
 	bcache_write_super(c);
 
+	if (bch_has_feature_obso_large_bucket(&c->cache->sb))
+		pr_err("Detect obsoleted large bucket layout, all attached bcache device will be read-only\n");
+
 	list_for_each_entry_safe(dc, t, &uncached_devices, list)
 		bch_cached_dev_attach(dc, c, NULL);
 
-- 
2.26.2

