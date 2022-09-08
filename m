Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5845B1453
	for <lists+linux-bcache@lfdr.de>; Thu,  8 Sep 2022 08:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiIHGDC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 8 Sep 2022 02:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiIHGC7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 8 Sep 2022 02:02:59 -0400
Received: from mail-m2838.qiye.163.com (mail-m2838.qiye.163.com [103.74.28.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA519CAC56
        for <linux-bcache@vger.kernel.org>; Wed,  7 Sep 2022 23:02:56 -0700 (PDT)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m2838.qiye.163.com (Hmail) with ESMTPA id 56F9D3C0109;
        Thu,  8 Sep 2022 14:02:54 +0800 (CST)
From:   mingzhe.zou@easystack.cn
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     zoumingzhe@qq.com
Subject: [PATCH v2] bcache: limit create flash device size
Date:   Thu,  8 Sep 2022 14:02:52 +0800
Message-Id: <20220908060252.11195-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkaGhkdVkxOHR1OHx5DQkkeQlUZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hKQ1VKS0tZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6ODY6Sgw4VjILFT5LTws6K0sO
        DCEKCyFVSlVKTU1JTUpNQkxPQ09JVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSE1OSjcG
X-HM-Tid: 0a831bb1b49e8420kuqw56f9d3c0109
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: mingzhe <mingzhe.zou@easystack.cn>

Currently, size is specified and not checked when creating a flash device.
This will cause a problem, IO maybe hang when creating a flash device with
the actual size of the device.

```
	if (attr == &sysfs_flash_vol_create) {
		int r;
		uint64_t v;

		strtoi_h_or_return(buf, v);

		r = bch_flash_dev_create(c, v);
		if (r)
			return r;
	}
```

Because the flash device needs some space for superblock, journal and btree.
If the size of data reaches the available size, the new IO cannot allocate
space and will hang. At this time, the gc thread will be started frequently.

Even more unreasonable, we can create flash devices larger than actual size.

```
[root@zou ~]# echo 2G > /sys/block/vdb/bcache/set/flash_vol_create
[root@zou ~]# lsblk /dev/vdb
NAME       MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
vdb        252:16   0   1G  0 disk
└─bcache0  251:0    0   2G  0 disk
```

This patch will limit the size of flash device, reserving a portion of
available size for the btree, available ratio can be modified by macro.

```
[root@zou ~]# echo 2G > /sys/block/vdb/bcache/set/flash_vol_create
[root@zou ~]# lsblk /dev/vdb
NAME       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
vdb        252:16   0    1G  0 disk
└─bcache0  251:0    0  900M  0 disk
```

Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/bcache.h |  1 +
 drivers/md/bcache/super.c  | 13 ++++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 2acda9cea0f9..f4436229cd83 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -525,6 +525,7 @@ struct cache_set {
 
 	struct cache		*cache;
 
+#define FLASH_DEV_AVAILABLE_RATIO	90
 	struct bcache_device	**devices;
 	unsigned int		devices_max_used;
 	atomic_t		attached_dev_nr;
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index ba3909bb6bea..214a384dc1d7 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1579,6 +1579,17 @@ static int flash_devs_run(struct cache_set *c)
 	return ret;
 }
 
+static inline sector_t flash_dev_max_sectors(struct cache_set *c)
+{
+	size_t avail_nbuckets;
+	struct cache *ca = c->cache;
+	size_t first_bucket = ca->sb.first_bucket;
+	size_t njournal_buckets = ca->sb.njournal_buckets;
+
+	avail_nbuckets = c->nbuckets - first_bucket - njournal_buckets;
+	return bucket_to_sector(c, avail_nbuckets / 100 * FLASH_DEV_AVAILABLE_RATIO);
+}
+
 int bch_flash_dev_create(struct cache_set *c, uint64_t size)
 {
 	struct uuid_entry *u;
@@ -1600,7 +1611,7 @@ int bch_flash_dev_create(struct cache_set *c, uint64_t size)
 	u->first_reg = u->last_reg = cpu_to_le32((u32)ktime_get_real_seconds());
 
 	SET_UUID_FLASH_ONLY(u, 1);
-	u->sectors = size >> 9;
+	u->sectors = min(flash_dev_max_sectors(c), size >> 9);
 
 	bch_uuid_write(c);
 
-- 
2.17.1

