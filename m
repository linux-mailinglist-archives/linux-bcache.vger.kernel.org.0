Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45DE249AC1E
	for <lists+linux-bcache@lfdr.de>; Tue, 25 Jan 2022 07:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241777AbiAYGBd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 25 Jan 2022 01:01:33 -0500
Received: from mail-m2836.qiye.163.com ([103.74.28.36]:34114 "EHLO
        mail-m2836.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235276AbiAYF7E (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 25 Jan 2022 00:59:04 -0500
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Jan 2022 00:59:03 EST
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m2836.qiye.163.com (Hmail) with ESMTPA id 601BEC006E;
        Tue, 25 Jan 2022 13:49:23 +0800 (CST)
From:   Rui Xu <rui.xu@easystack.cn>
To:     linux-bcache@vger.kernel.org
Cc:     dongsheng.yang@easystack.cn, Rui Xu <rui.xu@easystack.cn>
Subject: [PATCH] bcache: shrink the scope of bch_register_lock
Date:   Tue, 25 Jan 2022 13:49:22 +0800
Message-Id: <20220125054922.1859923-1-rui.xu@easystack.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlCN1dZLVlBSVdZDwkaFQgSH1lBWRlJQxhWSx8YGEhJSkxKHR
        pCVRkRExYaEhckFA4PWVdZFhoPEhUdFFlBWVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OhA6MQw*FzIwESoWFVYPNR80
        ODwwFCNVSlVKTU9IS0NCTE1ITEpCVTMWGhIXVQkOElUDDjseGggCCA8aGBBVGBVFWVdZEgtZQVlJ
        SkNVQk9VSkpDVUJLWVdZCAFZQU5OQ0o3Bg++
X-HM-Tid: 0a7e8fc81cbd841ekuqw601bec006e
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

When we register a cache device, register_cache_set is called, but
it would be locked with bch_register_lock which is a global lock.

Consider a scenriao which multiple cache devices are registered
concurrently, it will block in register_cache because of
bch_register_lock, in fact, we don't need to lock run_cache_set
in register_cache_set, but only the operation of bch_cache_sets
list.

The patch shrink the scope of bch_register_lock in register_cache_set
so that run_cache_set of different cache devices can be performed
concurrently, it also add a cache_set_lock to ensure that
bch_cached_dev_attach and run_cache_set will not processed at the
same time.

Signed-off-by: Rui Xu <rui.xu@easystack.cn>
---
 drivers/md/bcache/bcache.h |  2 ++
 drivers/md/bcache/super.c  | 40 ++++++++++++++++++++++++++++----------
 2 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index ab3c552871df..4e37785eaa2a 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -551,6 +551,8 @@ struct cache_set {
 	/* For the btree cache and anything allocation related */
 	struct mutex		bucket_lock;
 
+	struct mutex		cache_set_lock;
+
 	/* log2(bucket_size), in sectors */
 	unsigned short		bucket_bits;
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 8e8297ef98e3..bf392638a969 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1390,8 +1390,11 @@ static int register_bdev(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 
 	list_add(&dc->list, &uncached_devices);
 	/* attach to a matched cache set if it exists */
-	list_for_each_entry(c, &bch_cache_sets, list)
+	list_for_each_entry(c, &bch_cache_sets, list) {
+		mutex_lock(&c->cache_set_lock);
 		bch_cached_dev_attach(dc, c, NULL);
+		mutex_unlock(&c->cache_set_lock);
+    }
 
 	if (BDEV_STATE(&dc->sb) == BDEV_STATE_NONE ||
 	    BDEV_STATE(&dc->sb) == BDEV_STATE_STALE) {
@@ -1828,6 +1831,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 
 	sema_init(&c->sb_write_mutex, 1);
 	mutex_init(&c->bucket_lock);
+       mutex_init(&c->cache_set_lock);
 	init_waitqueue_head(&c->btree_cache_wait);
 	spin_lock_init(&c->btree_cannibalize_lock);
 	init_waitqueue_head(&c->bucket_wait);
@@ -2076,13 +2080,18 @@ static const char *register_cache_set(struct cache *ca)
 	const char *err = "cannot allocate memory";
 	struct cache_set *c;
 
+	mutex_lock(&bch_register_lock);
 	list_for_each_entry(c, &bch_cache_sets, list)
 		if (!memcmp(c->sb.set_uuid, ca->sb.set_uuid, 16)) {
-			if (c->cache[ca->sb.nr_this_dev])
+			if (c->cache[ca->sb.nr_this_dev]) {
+			        mutex_unlock(&bch_register_lock);
 				return "duplicate cache set member";
+			}
 
-			if (!can_attach_cache(ca, c))
+			if (!can_attach_cache(ca, c)) {
+			        mutex_unlock(&bch_register_lock);
 				return "cache sb does not match set";
+			}
 
 			if (!CACHE_SYNC(&ca->sb))
 				SET_CACHE_SYNC(&c->sb, false);
@@ -2091,25 +2100,35 @@ static const char *register_cache_set(struct cache *ca)
 		}
 
 	c = bch_cache_set_alloc(&ca->sb);
-	if (!c)
+	if (!c) {
+	        mutex_unlock(&bch_register_lock);
 		return err;
+	}
 
 	err = "error creating kobject";
 	if (kobject_add(&c->kobj, bcache_kobj, "%pU", c->sb.set_uuid) ||
-	    kobject_add(&c->internal, &c->kobj, "internal"))
+	    kobject_add(&c->internal, &c->kobj, "internal")) {
+	        mutex_unlock(&bch_register_lock);
 		goto err;
+	}
 
-	if (bch_cache_accounting_add_kobjs(&c->accounting, &c->kobj))
+	if (bch_cache_accounting_add_kobjs(&c->accounting, &c->kobj)) {
+	        mutex_unlock(&bch_register_lock);
 		goto err;
+	}
 
 	bch_debug_init_cache_set(c);
 
 	list_add(&c->list, &bch_cache_sets);
 found:
+	mutex_lock(&c->cache_set_lock);
+	mutex_unlock(&bch_register_lock);
 	sprintf(buf, "cache%i", ca->sb.nr_this_dev);
 	if (sysfs_create_link(&ca->kobj, &c->kobj, "set") ||
-	    sysfs_create_link(&c->kobj, &ca->kobj, buf))
+	    sysfs_create_link(&c->kobj, &ca->kobj, buf)) {
+		mutex_unlock(&c->cache_set_lock);
 		goto err;
+	}
 
 	if (ca->sb.seq > c->sb.seq) {
 		c->sb.version		= ca->sb.version;
@@ -2126,10 +2145,13 @@ static const char *register_cache_set(struct cache *ca)
 
 	if (c->caches_loaded == c->sb.nr_in_set) {
 		err = "failed to run cache set";
-		if (run_cache_set(c) < 0)
+		if (run_cache_set(c) < 0) {
+			mutex_unlock(&c->cache_set_lock);
 			goto err;
+		}
 	}
 
+	mutex_unlock(&c->cache_set_lock);
 	return NULL;
 err:
 	bch_cache_set_unregister(c);
@@ -2338,9 +2360,7 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 		goto out;
 	}
 
-	mutex_lock(&bch_register_lock);
 	err = register_cache_set(ca);
-	mutex_unlock(&bch_register_lock);
 
 	if (err) {
 		ret = -ENODEV;
-- 
2.25.1

