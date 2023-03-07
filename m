Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77ADA6AE154
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Mar 2023 14:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbjCGNvt (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 7 Mar 2023 08:51:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbjCGNvc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 7 Mar 2023 08:51:32 -0500
Received: from mail-m3164.qiye.163.com (mail-m3164.qiye.163.com [103.74.31.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FA485A71
        for <linux-bcache@vger.kernel.org>; Tue,  7 Mar 2023 05:50:40 -0800 (PST)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m3164.qiye.163.com (Hmail) with ESMTPA id 5A2EA620332;
        Tue,  7 Mar 2023 21:49:04 +0800 (CST)
From:   mingzhe <mingzhe.zou@easystack.cn>
To:     colyli@suse.de, bcache@lists.ewheeler.net,
        andrea.tomassetti-opensource@devo.com
Cc:     linux-bcache@vger.kernel.org, zoumingzhe@qq.com
Subject: [PATCH v7 3/3] bcache: support online resizing of cached_dev
Date:   Tue,  7 Mar 2023 21:48:52 +0800
Message-Id: <20230307134852.8288-3-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1.windows.2
In-Reply-To: <20230307134852.8288-1-mingzhe.zou@easystack.cn>
References: <20230307134852.8288-1-mingzhe.zou@easystack.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlDSkMZVh1PTh8dTk5IH08eH1UZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hKQ1VKS0tVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MEk6SBw4IjIDAjYDHC43Ckg#
        NT0wCRRVSlVKTUxDSkJNQk9OS0lMVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBQ0JCSDcG
X-HM-Tid: 0a86bc552e8700a4kurm5a2ea620332
X-HM-MType: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

When partial_stripes_expensive is false, resizing causes nr_stripes to change.
So, stripe_sectors_dirty and full_dirty_stripes memory must be reallocated.
If the device is smaller, only nr_stripes need to be modified.

Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>

---
Changelog:
v6: Add resize in sysfs
v5: Update api calls.
v4: Fix up overflow and null pointer
v3: Fix up errors.
v2: Fix up errors.
v1: Original verison.
---
 drivers/md/bcache/bcache.h |  1 +
 drivers/md/bcache/btree.c  | 31 ++++++++++++++
 drivers/md/bcache/btree.h  |  2 +
 drivers/md/bcache/super.c  | 86 ++++++++++++++++++++++++++++++++++++++
 drivers/md/bcache/sysfs.c  | 22 +++++++++-
 5 files changed, 140 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index db3439d65582..74498cd53e2c 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -1021,6 +1021,7 @@ void bcache_write_super(struct cache_set *c);
 
 int bch_flash_dev_create(struct cache_set *c, uint64_t size);
 
+int bch_cached_dev_resize(struct cached_dev *dc, sector_t sectors);
 int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 			  uint8_t *set_uuid);
 void bch_cached_dev_detach(struct cached_dev *dc);
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 147c493a989a..07388e51ff9c 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -2467,6 +2467,37 @@ int bch_btree_insert(struct cache_set *c, struct keylist *keys,
 	return ret;
 }
 
+int bch_btree_insert_invalidate(struct cache_set *c, unsigned int inode,
+				sector_t offset, sector_t length)
+{
+	int ret = 0;
+	sector_t num;
+	struct keylist insert_keys;
+
+	bch_keylist_init(&insert_keys);
+	while (!ret && length) {
+		num = min_t(sector_t, length, 1U << (KEY_SIZE_BITS - 1));
+
+		if ((ret = __bch_keylist_realloc(&insert_keys, 2))) {
+			pr_err("cannot allocate memory");
+			break;
+		}
+
+		offset += num;
+		length -= num;
+
+		bch_keylist_add(&insert_keys, &KEY(inode, offset, num));
+		if ((ret = bch_btree_insert(c, &insert_keys, NULL, NULL))) {
+			pr_err("invalidating %llu sectors from %llu error %d",
+				num, offset - num, ret);
+			break;
+		}
+	}
+	bch_keylist_free(&insert_keys);
+
+	return ret;
+}
+
 void bch_btree_set_root(struct btree *b)
 {
 	unsigned int i;
diff --git a/drivers/md/bcache/btree.h b/drivers/md/bcache/btree.h
index 1b5fdbc0d83e..28c8885ecea1 100644
--- a/drivers/md/bcache/btree.h
+++ b/drivers/md/bcache/btree.h
@@ -276,6 +276,8 @@ int bch_btree_insert_check_key(struct btree *b, struct btree_op *op,
 			       struct bkey *check_key);
 int bch_btree_insert(struct cache_set *c, struct keylist *keys,
 		     atomic_t *journal_ref, struct bkey *replace_key);
+int bch_btree_insert_invalidate(struct cache_set *c, unsigned int inode,
+				sector_t offset, sector_t length);
 
 int bch_gc_thread_start(struct cache_set *c);
 void bch_initial_gc_finish(struct cache_set *c);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 6be02d6e0ba1..56535d79648d 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1345,6 +1345,92 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 	return 0;
 }
 
+int bch_cached_dev_resize(struct cached_dev *dc, sector_t sectors)
+{
+	struct cache_set *c = dc->disk.c;
+	uint64_t nr_stripes, n, i;
+	sector_t length, sectors_dirty;
+	atomic_t *stripe_sectors_dirty;
+	unsigned long *full_dirty_stripes;
+	const size_t max_stripes = min_t(size_t, INT_MAX,
+					 SIZE_MAX / sizeof(atomic_t));
+
+	/* Block writeback thread and all requests */
+	down_write(&dc->writeback_lock);
+
+	if (!dc->partial_stripes_expensive)
+		goto set_capacity;
+
+	nr_stripes = DIV_ROUND_UP_ULL(sectors, dc->disk.stripe_size);
+	if (!nr_stripes || nr_stripes > max_stripes) {
+		pr_err("nr_stripes too large or invalid: %llu", nr_stripes);
+		up_write(&dc->writeback_lock);
+		return -ENOMEM;
+	}
+
+	if (nr_stripes > dc->disk.nr_stripes)
+		goto realloc;
+
+	for (i = nr_stripes; i < dc->disk.nr_stripes; i++) {
+		sectors_dirty = atomic_read(dc->disk.stripe_sectors_dirty + i);
+		atomic_long_sub(sectors_dirty, &dc->disk.dirty_sectors);
+	}
+	goto nr_stripes;
+
+realloc:
+	n = nr_stripes * sizeof(atomic_t);
+	stripe_sectors_dirty = kvzalloc(n, GFP_KERNEL);
+	if (!stripe_sectors_dirty) {
+		up_write(&dc->writeback_lock);
+		return -ENOMEM;
+	}
+
+	n = BITS_TO_LONGS(nr_stripes) * sizeof(unsigned long);
+	full_dirty_stripes = kvzalloc(n, GFP_KERNEL);
+	if (!full_dirty_stripes) {
+		kvfree(stripe_sectors_dirty);
+		up_write(&dc->writeback_lock);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < dc->disk.nr_stripes; i++) {
+		sectors_dirty = atomic_read(dc->disk.stripe_sectors_dirty + i);
+		atomic_set(stripe_sectors_dirty + i, sectors_dirty);
+		if (sectors_dirty == dc->disk.stripe_size)
+			set_bit(i, full_dirty_stripes);
+	}
+
+	kvfree(dc->disk.full_dirty_stripes);
+	kvfree(dc->disk.stripe_sectors_dirty);
+	dc->disk.stripe_sectors_dirty = stripe_sectors_dirty;
+	dc->disk.full_dirty_stripes = full_dirty_stripes;
+
+nr_stripes:
+	dc->disk.nr_stripes = nr_stripes;
+
+set_capacity:
+	length = get_capacity(dc->disk.disk);
+	set_capacity_and_notify(dc->disk.disk, sectors);
+
+	if (!c || length <= sectors)
+		goto skip_invalidate;
+	length -= sectors;
+
+	/* invalidate dirty data not used */
+	pr_info("invalidating %llu sectors from %llu", length, sectors);
+	bch_btree_insert_invalidate(c, dc->disk.id, sectors, length);
+
+	/* recount dirty sectors */
+	if (!dc->partial_stripes_expensive) {
+		atomic_long_set(&dc->disk.dirty_sectors, 0);
+		bch_sectors_dirty_init(&dc->disk);
+	}
+
+skip_invalidate:
+	up_write(&dc->writeback_lock);
+	return 0;
+}
+
 /* when dc->disk.kobj released */
 void bch_cached_dev_release(struct kobject *kobj)
 {
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index c6f677059214..ee31b873ab2a 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -150,7 +150,9 @@ rw_attribute(btree_shrinker_disabled);
 rw_attribute(copy_gc_enabled);
 rw_attribute(idle_max_writeback_rate);
 rw_attribute(gc_after_writeback);
-rw_attribute(size);
+
+read_attribute(size);
+write_attribute(resize);
 
 static ssize_t bch_snprint_string_list(char *buf,
 				       size_t size,
@@ -194,6 +196,7 @@ SHOW(__bch_cached_dev)
 
 
 	sysfs_printf(data_csum,		"%i", dc->disk.data_csum);
+	sysfs_hprint(size,		get_capacity(dc->disk.disk) << 9);
 	var_printf(verify,		"%i");
 	var_printf(bypass_torture_test,	"%i");
 	var_printf(writeback_metadata,	"%i");
@@ -305,6 +308,18 @@ STORE(__cached_dev)
 #define d_strtoi_h(var)		sysfs_hatoi(var, dc->var)
 
 	sysfs_strtoul(data_csum,	dc->disk.data_csum);
+
+	if (attr == &sysfs_resize) {
+		ssize_t ret;
+		sector_t v, max, sectors;
+
+		strtoi_h_or_return(buf, v);
+		max = bdev_nr_sectors(dc->bdev) - dc->sb.data_offset;
+		sectors = clamp_t(sector_t, v >> 9, 0, max);
+		ret = bch_cached_dev_resize(dc, sectors);
+		return ret ? ret : size;
+	}
+
 	d_strtoul(verify);
 	sysfs_strtoul_bool(bypass_torture_test, dc->bypass_torture_test);
 	sysfs_strtoul_bool(writeback_metadata, dc->writeback_metadata);
@@ -535,6 +550,8 @@ static struct attribute *bch_cached_dev_attrs[] = {
 	&sysfs_running,
 	&sysfs_state,
 	&sysfs_label,
+	&sysfs_size,
+	&sysfs_resize,
 #ifdef CONFIG_BCACHE_DEBUG
 	&sysfs_verify,
 	&sysfs_bypass_torture_test,
@@ -577,7 +594,7 @@ STORE(__bch_flash_dev)
 
 	sysfs_strtoul(data_csum,	d->data_csum);
 
-	if (attr == &sysfs_size) {
+	if (attr == &sysfs_resize) {
 		uint64_t v;
 
 		strtoi_h_or_return(buf, v);
@@ -608,6 +625,7 @@ static struct attribute *bch_flash_dev_attrs[] = {
 #endif
 	&sysfs_label,
 	&sysfs_size,
+	&sysfs_resize,
 	NULL
 };
 ATTRIBUTE_GROUPS(bch_flash_dev);
-- 
2.17.1.windows.2

