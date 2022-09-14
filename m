Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A10E5B816E
	for <lists+linux-bcache@lfdr.de>; Wed, 14 Sep 2022 08:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiINGPY (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 14 Sep 2022 02:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiINGPQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 14 Sep 2022 02:15:16 -0400
X-Greylist: delayed 493 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 13 Sep 2022 23:15:13 PDT
Received: from mail-m31106.qiye.163.com (mail-m31106.qiye.163.com [103.74.31.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C961C937
        for <linux-bcache@vger.kernel.org>; Tue, 13 Sep 2022 23:15:13 -0700 (PDT)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m31106.qiye.163.com (Hmail) with ESMTPA id 3615EA0317;
        Wed, 14 Sep 2022 14:06:58 +0800 (CST)
From:   mingzhe.zou@easystack.cn
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     zoumingzhe@qq.com
Subject: [PATCH] bcache: limit multiple flash devices size
Date:   Wed, 14 Sep 2022 14:06:57 +0800
Message-Id: <20220914060657.22102-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkaGUNKVh1ISkxKTx4eHkkZHlUZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hKQ1VKS0tZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Oj46TDo*ITIILzBNHzUSCw09
        PEoKFDZVSlVKTU1ISkhOTUpDTE1JVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBT0hJSjcG
X-HM-Tid: 0a833a9b951b00fekurm3615ea0317
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FILL_THIS_FORM,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: mingzhe <mingzhe.zou@easystack.cn>

Bcache allows multiple flash devices to be created on the same cache.
We can create multiple flash devices, and the total size larger than
cache device's actual size.
```
[root@zou ~]# lsblk /dev/vdd
NAME       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
vdd        252:48   0  100G  0 disk
[root@zou ~]# echo 50G > /sys/block/vdd/bcache/set/flash_vol_create
[root@zou ~]# lsblk /dev/vdd
NAME       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
vdd        252:48   0  100G  0 disk
└─bcache1  251:128  0   50G  0 disk
[root@zou ~]# echo 50G > /sys/block/vdd/bcache/set/flash_vol_create
[root@zou ~]# lsblk /dev/vdd
NAME       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
vdd        252:48   0  100G  0 disk
├─bcache2  251:256  0   50G  0 disk
└─bcache1  251:128  0   50G  0 disk
[root@zou ~]# echo 50G > /sys/block/vdd/bcache/set/flash_vol_create
[root@zou ~]# lsblk /dev/vdd
NAME       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
vdd        252:48   0  100G  0 disk
├─bcache3  251:256  0   50G  0 disk
├─bcache2  251:256  0   50G  0 disk
└─bcache1  251:128  0   50G  0 disk
```

This patch will limit the total size of multi-flash device, until no
free space to create a new flash device with an error.
```
[root@zou ~]# lsblk /dev/vdd
NAME       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
vdd        252:48   0  100G  0 disk
[root@zou ~]# echo 50G > /sys/block/vdd/bcache/set/flash_vol_create
[root@zou ~]# lsblk /dev/vdd
NAME       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
vdd        252:48   0  100G  0 disk
└─bcache1  251:128  0   50G  0 disk
[root@zou ~]# echo 50G > /sys/block/vdd/bcache/set/flash_vol_create
[root@zou ~]# lsblk /dev/vdd
NAME       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
vdd        252:48   0  100G  0 disk
├─bcache2  251:256  0 39.9G  0 disk
└─bcache1  251:128  0   50G  0 disk
[root@zou ~]# echo 50G > /sys/block/vdd/bcache/set/flash_vol_create
-bash: echo: write error: Invalid argument
[root@zou ~]# lsblk /dev/vdd
NAME       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
vdd        252:48   0  100G  0 disk
├─bcache2  251:256  0 39.9G  0 disk
└─bcache1  251:128  0   50G  0 disk
```

Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/super.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 214a384dc1d7..e019cfd793eb 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1581,13 +1581,20 @@ static int flash_devs_run(struct cache_set *c)
 
 static inline sector_t flash_dev_max_sectors(struct cache_set *c)
 {
+	sector_t sectors;
+	struct uuid_entry *u;
 	size_t avail_nbuckets;
 	struct cache *ca = c->cache;
 	size_t first_bucket = ca->sb.first_bucket;
 	size_t njournal_buckets = ca->sb.njournal_buckets;
 
 	avail_nbuckets = c->nbuckets - first_bucket - njournal_buckets;
-	return bucket_to_sector(c, avail_nbuckets / 100 * FLASH_DEV_AVAILABLE_RATIO);
+	sectors = bucket_to_sector(c, avail_nbuckets / 100 * FLASH_DEV_AVAILABLE_RATIO);
+
+	for (u = c->uuids; u < c->uuids + c->nr_uuids && sectors > 0; u++)
+		if (UUID_FLASH_ONLY(u))
+			sectors -= min(u->sectors, sectors);
+	return sectors;
 }
 
 int bch_flash_dev_create(struct cache_set *c, uint64_t size)
@@ -1612,6 +1619,10 @@ int bch_flash_dev_create(struct cache_set *c, uint64_t size)
 
 	SET_UUID_FLASH_ONLY(u, 1);
 	u->sectors = min(flash_dev_max_sectors(c), size >> 9);
+	if (!u->sectors) {
+		pr_err("Can't create volume, no free space");
+		return -EINVAL;
+	}
 
 	bch_uuid_write(c);
 
-- 
2.17.1

