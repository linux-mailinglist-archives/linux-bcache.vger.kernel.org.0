Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD29407573
	for <lists+linux-bcache@lfdr.de>; Sat, 11 Sep 2021 09:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235309AbhIKHlC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 11 Sep 2021 03:41:02 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9417 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233040AbhIKHlC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 11 Sep 2021 03:41:02 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4H64K90RnGz8xZP;
        Sat, 11 Sep 2021 15:35:25 +0800 (CST)
Received: from dggpeml500019.china.huawei.com (7.185.36.137) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 11 Sep 2021 15:39:48 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500019.china.huawei.com
 (7.185.36.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Sat, 11 Sep
 2021 15:39:47 +0800
From:   Wu Bo <wubo40@huawei.com>
To:     <colyli@suse.de>, <kent.overstreet@gmail.com>
CC:     <linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linfeilong@huawei.com>, <wubo40@huawei.com>
Subject: [PATCH] bcache: Fix memory leak when cache_alloc() return failed
Date:   Sat, 11 Sep 2021 16:08:54 +0800
Message-ID: <1631347734-9950-1-git-send-email-wubo40@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500019.china.huawei.com (7.185.36.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Wu Bo <wubo40@huawei.com>

If cache_alloc() get error when register a cache device,
the ca->kobj is not initialized, the bch_cache_release() no chance 
to be called. So "ca" object will not be released.

In addition, if register_cache_set() return failed 
when register a cache device, kobject_put(&ca->kobj) will be called 
and "ca" objects will be released in bch_cache_release() function. 
But pr_notice() called after kobject_put(&ca->kobj),
the "ca->cache_dev_name" access memory that has been freed.

Signed-off-by: Wu Bo <wubo40@huawei.com>
---
 drivers/md/bcache/super.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index f2874c7..30569f4 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2366,13 +2366,17 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 		 * explicitly call blkdev_put() here.
 		 */
 		blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
+		if (ca->sb_disk)
+			put_page(virt_to_page(ca->sb_disk));
 		if (ret == -ENOMEM)
 			err = "cache_alloc(): -ENOMEM";
 		else if (ret == -EPERM)
 			err = "cache_alloc(): cache device is too small";
 		else
 			err = "cache_alloc(): unknown error";
-		goto err;
+		pr_notice("error %s: %s\n", ca->cache_dev_name, err);
+		kfree(ca);
+		return ret;
 	}
 
 	if (kobject_add(&ca->kobj, bdev_kobj(bdev), "bcache")) {
@@ -2393,11 +2397,9 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 	pr_info("registered cache device %s\n", ca->cache_dev_name);
 
 out:
-	kobject_put(&ca->kobj);
-
-err:
 	if (err)
 		pr_notice("error %s: %s\n", ca->cache_dev_name, err);
+	kobject_put(&ca->kobj);
 
 	return ret;
 }
-- 
1.8.3.1

