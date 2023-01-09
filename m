Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48442661C92
	for <lists+linux-bcache@lfdr.de>; Mon,  9 Jan 2023 04:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbjAIDLb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 8 Jan 2023 22:11:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233922AbjAIDLa (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 8 Jan 2023 22:11:30 -0500
Received: from mail-m3164.qiye.163.com (mail-m3164.qiye.163.com [103.74.31.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234B71057B
        for <linux-bcache@vger.kernel.org>; Sun,  8 Jan 2023 19:11:28 -0800 (PST)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m3164.qiye.163.com (Hmail) with ESMTPA id 872DE6201B1;
        Mon,  9 Jan 2023 11:11:26 +0800 (CST)
From:   mingzhe.zou@easystack.cn
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     zoumingzhe@qq.com, andrea.tomassetti-opensource@devo.com,
        bcache@lists.ewheeler.net
Subject: [PATCH v4 2/3] bcache: allocate stripe memory when partial_stripes_expensive is true
Date:   Mon,  9 Jan 2023 11:11:23 +0800
Message-Id: <20230109031124.2293-2-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230109031124.2293-1-mingzhe.zou@easystack.cn>
References: <20230109031124.2293-1-mingzhe.zou@easystack.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkZTEkZVh5PSENNTB5JQ0hIT1UZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hKTFVKS0tVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PE06DQw6UTJDMSkoSTEdCy0K
        FBQaFAJVSlVKTUxISUhIQ0NMT0tMVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBTU5LSDcG
X-HM-Tid: 0a859482edf700a4kurm872de6201b1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: mingzhe <mingzhe.zou@easystack.cn>

Currently, bcache_device (cached_dev and flash_dev) always allocate
memory for stripe_sectors_dirty and full_dirty_stripes, regardless of
whether partial_stripes_expensive is true or not. When the device's
partial_stripes_expensive is false, only bcache_dev_sectors_dirty_add()
will use stripe_sectors_dirty.

When stripe_size is 0, it is forced to 2^31, which is about 1T (2^31*512).
However, some non-raid devices (such as rbd) will provide non-zero io_opt.
In https://bugzilla.redhat.com/show_bug.cgi?id=1783075, some block devices
which large capacity (e.g. 8TB) but small io_opt size (e.g. 8 sectors), the
nr_stripes will be very large. Even though the overflow bug is fixed in
65f0f017e7be and 7a1481267999, it still returns an error when register.

I don't think it's necessary to allocate stripe memory for devices where
partial_stripes_expensive is false. This patch will allocate stripe memory
when partial_stripes_expensive is true.

Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>
---
Changelog:
v2: Fix up errors.
v1: Original verison.
---
 drivers/md/bcache/super.c     | 32 ++++++++++++++++++++++----------
 drivers/md/bcache/writeback.c | 14 ++++++++++----
 2 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a91a1c3f4055..125f607d58f0 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -887,15 +887,20 @@ static void bcache_device_free(struct bcache_device *d)
 	}
 
 	bioset_exit(&d->bio_split);
-	kvfree(d->full_dirty_stripes);
-	kvfree(d->stripe_sectors_dirty);
+
+	if (d->full_dirty_stripes)
+		kvfree(d->full_dirty_stripes);
+
+	if (d->stripe_sectors_dirty)
+		kvfree(d->stripe_sectors_dirty);
 
 	closure_debug_destroy(&d->cl);
 }
 
 static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
-		sector_t sectors, struct block_device *cached_bdev,
-		const struct block_device_operations *ops)
+			      sector_t sectors, bool enable_stripe,
+			      struct block_device *cached_bdev,
+			      const struct block_device_operations *ops)
 {
 	struct request_queue *q;
 	const size_t max_stripes = min_t(size_t, INT_MAX,
@@ -903,6 +908,9 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 	uint64_t n;
 	int idx;
 
+	if (!enable_stripe)
+		goto skip_stripe;
+
 	if (!d->stripe_size)
 		d->stripe_size = 1 << 31;
 
@@ -924,6 +932,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 	if (!d->full_dirty_stripes)
 		goto out_free_stripe_sectors_dirty;
 
+skip_stripe:
 	idx = ida_simple_get(&bcache_device_idx, 0,
 				BCACHE_DEVICE_IDX_MAX, GFP_KERNEL);
 	if (idx < 0)
@@ -982,9 +991,11 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 out_ida_remove:
 	ida_simple_remove(&bcache_device_idx, idx);
 out_free_full_dirty_stripes:
-	kvfree(d->full_dirty_stripes);
+	if (d->full_dirty_stripes)
+		kvfree(d->full_dirty_stripes);
 out_free_stripe_sectors_dirty:
-	kvfree(d->stripe_sectors_dirty);
+	if (d->stripe_sectors_dirty)
+		kvfree(d->stripe_sectors_dirty);
 	return -ENOMEM;
 
 }
@@ -1397,6 +1408,7 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
 	int ret;
 	struct io *io;
 	struct request_queue *q = bdev_get_queue(dc->bdev);
+	sector_t sectors = bdev_nr_sectors(dc->bdev) - dc->sb.data_offset;
 
 	__module_get(THIS_MODULE);
 	INIT_LIST_HEAD(&dc->list);
@@ -1422,9 +1434,9 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
 		dc->partial_stripes_expensive =
 			q->limits.raid_partial_stripes_expensive;
 
-	ret = bcache_device_init(&dc->disk, block_size,
-			 bdev_nr_sectors(dc->bdev) - dc->sb.data_offset,
-			 dc->bdev, &bcache_cached_ops);
+	ret = bcache_device_init(&dc->disk, block_size, sectors,
+				 dc->partial_stripes_expensive,
+				 dc->bdev, &bcache_cached_ops);
 	if (ret)
 		return ret;
 
@@ -1535,7 +1547,7 @@ static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
 
 	kobject_init(&d->kobj, &bch_flash_dev_ktype);
 
-	if (bcache_device_init(d, block_bytes(c->cache), u->sectors,
+	if (bcache_device_init(d, block_bytes(c->cache), u->sectors, false,
 			NULL, &bcache_flash_ops))
 		goto err;
 
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 7b5009e8b4ff..3f4af7ce6936 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -758,6 +758,7 @@ static void read_dirty(struct cached_dev *dc)
 void bcache_dev_sectors_dirty_add(struct cache_set *c, unsigned int inode,
 				  uint64_t offset, int nr_sectors)
 {
+	struct cached_dev *dc = NULL;
 	struct bcache_device *d = c->devices[inode];
 	unsigned int stripe_offset, sectors_dirty;
 	int stripe;
@@ -765,14 +766,19 @@ void bcache_dev_sectors_dirty_add(struct cache_set *c, unsigned int inode,
 	if (!d)
 		return;
 
-	stripe = offset_to_stripe(d, offset);
-	if (stripe < 0)
-		return;
-
 	atomic_long_add(nr_sectors, &d->dirty_sectors);
 
 	if (UUID_FLASH_ONLY(&c->uuids[inode]))
 		atomic_long_add(nr_sectors, &c->flash_dev_dirty_sectors);
+	else
+		dc = container_of(d, struct cached_dev, disk);
+
+	if (!dc || !dc->partial_stripes_expensive)
+		return;
+
+	stripe = offset_to_stripe(d, offset);
+	if (stripe < 0)
+		return;
 
 	stripe_offset = offset & (d->stripe_size - 1);
 
-- 
2.17.1

