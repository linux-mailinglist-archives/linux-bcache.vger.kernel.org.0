Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51EC0245471
	for <lists+linux-bcache@lfdr.de>; Sun, 16 Aug 2020 00:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729352AbgHOWYH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 15 Aug 2020 18:24:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:37952 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728755AbgHOWXq (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 15 Aug 2020 18:23:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 21E4CB1C7;
        Sat, 15 Aug 2020 12:48:20 +0000 (UTC)
From:   colyli@suse.de
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH v1 04/14] bcache: add set_uuid in struct cache_set
Date:   Sat, 15 Aug 2020 20:47:33 +0800
Message-Id: <20200815124743.115270-5-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200815124743.115270-1-colyli@suse.de>
References: <20200815124743.115270-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

This patch adds a separated set_uuid[16] in struct cache_set, to store
the uuid of the cache set. This is the preparation to remove the
embedded struct cache_sb from struct cache_set.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/bcache.h    |  1 +
 drivers/md/bcache/debug.c     |  2 +-
 drivers/md/bcache/super.c     | 24 ++++++++++++------------
 include/trace/events/bcache.h |  4 ++--
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 7ffe6b2d179b..94a62acac4fc 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -668,6 +668,7 @@ struct cache_set {
 	struct mutex		verify_lock;
 #endif
 
+	uint8_t			set_uuid[16];
 	unsigned int		nr_uuids;
 	struct uuid_entry	*uuids;
 	BKEY_PADDED(uuid_bucket);
diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 336f43910383..0ccc1b0baa42 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -238,7 +238,7 @@ void bch_debug_init_cache_set(struct cache_set *c)
 	if (!IS_ERR_OR_NULL(bcache_debug)) {
 		char name[50];
 
-		snprintf(name, 50, "bcache-%pU", c->sb.set_uuid);
+		snprintf(name, 50, "bcache-%pU", c->set_uuid);
 		c->debug = debugfs_create_file(name, 0400, bcache_debug, c,
 					       &cache_set_debug_ops);
 	}
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 91883d5c4b62..90a419ad6445 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1189,8 +1189,8 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 	struct cached_dev *exist_dc, *t;
 	int ret = 0;
 
-	if ((set_uuid && memcmp(set_uuid, c->sb.set_uuid, 16)) ||
-	    (!set_uuid && memcmp(dc->sb.set_uuid, c->sb.set_uuid, 16)))
+	if ((set_uuid && memcmp(set_uuid, c->set_uuid, 16)) ||
+	    (!set_uuid && memcmp(dc->sb.set_uuid, c->set_uuid, 16)))
 		return -ENOENT;
 
 	if (dc->disk.c) {
@@ -1262,7 +1262,7 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 		u->first_reg = u->last_reg = rtime;
 		bch_uuid_write(c);
 
-		memcpy(dc->sb.set_uuid, c->sb.set_uuid, 16);
+		memcpy(dc->sb.set_uuid, c->set_uuid, 16);
 		SET_BDEV_STATE(&dc->sb, BDEV_STATE_CLEAN);
 
 		bch_write_bdev_super(dc, &cl);
@@ -1324,7 +1324,7 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 	pr_info("Caching %s as %s on set %pU\n",
 		dc->backing_dev_name,
 		dc->disk.disk->disk_name,
-		dc->disk.c->sb.set_uuid);
+		dc->disk.c->set_uuid);
 	return 0;
 }
 
@@ -1632,7 +1632,7 @@ bool bch_cache_set_error(struct cache_set *c, const char *fmt, ...)
 	vaf.va = &args;
 
 	pr_err("error on %pU: %pV, disabling caching\n",
-	       c->sb.set_uuid, &vaf);
+	       c->set_uuid, &vaf);
 
 	va_end(args);
 
@@ -1685,7 +1685,7 @@ static void cache_set_free(struct closure *cl)
 	list_del(&c->list);
 	mutex_unlock(&bch_register_lock);
 
-	pr_info("Cache set %pU unregistered\n", c->sb.set_uuid);
+	pr_info("Cache set %pU unregistered\n", c->set_uuid);
 	wake_up(&unregister_wait);
 
 	closure_debug_destroy(&c->cl);
@@ -1755,7 +1755,7 @@ static void conditional_stop_bcache_device(struct cache_set *c,
 {
 	if (dc->stop_when_cache_set_failed == BCH_CACHED_DEV_STOP_ALWAYS) {
 		pr_warn("stop_when_cache_set_failed of %s is \"always\", stop it for failed cache set %pU.\n",
-			d->disk->disk_name, c->sb.set_uuid);
+			d->disk->disk_name, c->set_uuid);
 		bcache_device_stop(d);
 	} else if (atomic_read(&dc->has_dirty)) {
 		/*
@@ -1862,7 +1862,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 
 	bch_cache_accounting_init(&c->accounting, &c->cl);
 
-	memcpy(c->sb.set_uuid, sb->set_uuid, 16);
+	memcpy(c->set_uuid, sb->set_uuid, 16);
 	c->sb.block_size	= sb->block_size;
 	c->sb.bucket_size	= sb->bucket_size;
 	c->sb.nr_in_set		= sb->nr_in_set;
@@ -2145,7 +2145,7 @@ static const char *register_cache_set(struct cache *ca)
 	struct cache_set *c;
 
 	list_for_each_entry(c, &bch_cache_sets, list)
-		if (!memcmp(c->sb.set_uuid, ca->sb.set_uuid, 16)) {
+		if (!memcmp(c->set_uuid, ca->sb.set_uuid, 16)) {
 			if (c->cache)
 				return "duplicate cache set member";
 
@@ -2163,7 +2163,7 @@ static const char *register_cache_set(struct cache *ca)
 		return err;
 
 	err = "error creating kobject";
-	if (kobject_add(&c->kobj, bcache_kobj, "%pU", c->sb.set_uuid) ||
+	if (kobject_add(&c->kobj, bcache_kobj, "%pU", c->set_uuid) ||
 	    kobject_add(&c->internal, &c->kobj, "internal"))
 		goto err;
 
@@ -2188,7 +2188,7 @@ static const char *register_cache_set(struct cache *ca)
 	 */
 	if (ca->sb.seq > c->sb.seq || c->sb.seq == 0) {
 		c->sb.version		= ca->sb.version;
-		memcpy(c->sb.set_uuid, ca->sb.set_uuid, 16);
+		memcpy(c->set_uuid, ca->sb.set_uuid, 16);
 		c->sb.flags             = ca->sb.flags;
 		c->sb.seq		= ca->sb.seq;
 		pr_debug("set version = %llu\n", c->sb.version);
@@ -2698,7 +2698,7 @@ static ssize_t bch_pending_bdevs_cleanup(struct kobject *k,
 	list_for_each_entry_safe(pdev, tpdev, &pending_devs, list) {
 		list_for_each_entry_safe(c, tc, &bch_cache_sets, list) {
 			char *pdev_set_uuid = pdev->dc->sb.set_uuid;
-			char *set_uuid = c->sb.uuid;
+			char *set_uuid = c->set_uuid;
 
 			if (!memcmp(pdev_set_uuid, set_uuid, 16)) {
 				list_del(&pdev->list);
diff --git a/include/trace/events/bcache.h b/include/trace/events/bcache.h
index 0bddea663b3b..e41c611d6d3b 100644
--- a/include/trace/events/bcache.h
+++ b/include/trace/events/bcache.h
@@ -164,7 +164,7 @@ TRACE_EVENT(bcache_write,
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->uuid, c->sb.set_uuid, 16);
+		memcpy(__entry->uuid, c->set_uuid, 16);
 		__entry->inode		= inode;
 		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->nr_sector	= bio->bi_iter.bi_size >> 9;
@@ -200,7 +200,7 @@ DECLARE_EVENT_CLASS(cache_set,
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->uuid, c->sb.set_uuid, 16);
+		memcpy(__entry->uuid, c->set_uuid, 16);
 	),
 
 	TP_printk("%pU", __entry->uuid)
-- 
2.26.2

