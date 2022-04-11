Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E05EE4FB222
	for <lists+linux-bcache@lfdr.de>; Mon, 11 Apr 2022 05:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbiDKDGs (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 10 Apr 2022 23:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238402AbiDKDGq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 10 Apr 2022 23:06:46 -0400
Received: from mail-m2835.qiye.163.com (mail-m2835.qiye.163.com [103.74.28.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DACBC13
        for <linux-bcache@vger.kernel.org>; Sun, 10 Apr 2022 20:04:31 -0700 (PDT)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m2835.qiye.163.com (Hmail) with ESMTPA id 6823C8A02F0;
        Mon, 11 Apr 2022 11:04:28 +0800 (CST)
From:   mingzhe.zou@easystack.cn
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     zoumingzhe@qq.com, ZouMingzhe <mingzhe.zou@easystack.cn>
Subject: [PATCH v2 2/3] bcache: check bch_sectors_dirty_init() return value
Date:   Mon, 11 Apr 2022 11:04:16 +0800
Message-Id: <20220411030417.7222-2-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220411030417.7222-1-mingzhe.zou@easystack.cn>
References: <20220401122725.17725-1-mingzhe.zou@easystack.cn>
 <20220411030417.7222-1-mingzhe.zou@easystack.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlCN1dZLVlBSVdZDwkaFQgSH1lBWRkaShpWSh9NGEJLTk0fH0
        0eVRkRExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktISkxVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PTY6FAw*CTIZKSgyOSFNQgMW
        PD0aCk9VSlVKTU9CTU9NSU1DQkNPVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSElOTDcG
X-HM-Tid: 0a80169470eb841dkuqw6823c8a02f0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: ZouMingzhe <mingzhe.zou@easystack.cn>

handle error when call bch_sectors_dirty_init() function

Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/super.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index bf3de149d3c9..e4a53c849fa6 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1300,21 +1300,17 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 		bch_writeback_queue(dc);
 	}
 
-	bch_sectors_dirty_init(&dc->disk);
+	ret = bch_sectors_dirty_init(&dc->disk);
+	if (ret) {
+		pr_err("Fails in sectors dirty init for %s\n",
+		       dc->disk.disk->disk_name);
+		goto err;
+	}
 
 	ret = bch_cached_dev_run(dc);
 	if (ret && (ret != -EBUSY)) {
-		up_write(&dc->writeback_lock);
-		/*
-		 * bch_register_lock is held, bcache_device_stop() is not
-		 * able to be directly called. The kthread and kworker
-		 * created previously in bch_cached_dev_writeback_start()
-		 * have to be stopped manually here.
-		 */
-		kthread_stop(dc->writeback_thread);
-		cancel_writeback_rate_update_dwork(dc);
 		pr_err("Couldn't run cached device %pg\n", dc->bdev);
-		return ret;
+		goto err;
 	}
 
 	bcache_device_link(&dc->disk, c, "bdev");
@@ -1334,6 +1330,18 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 		dc->disk.disk->disk_name,
 		dc->disk.c->set_uuid);
 	return 0;
+
+err:
+	up_write(&dc->writeback_lock);
+	/*
+	 * bch_register_lock is held, bcache_device_stop() is not
+	 * able to be directly called. The kthread and kworker
+	 * created previously in bch_cached_dev_writeback_start()
+	 * have to be stopped manually here.
+	 */
+	kthread_stop(dc->writeback_thread);
+	cancel_writeback_rate_update_dwork(dc);
+	return ret;
 }
 
 /* when dc->disk.kobj released */
@@ -1542,7 +1550,9 @@ static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
 		goto err;
 
 	bcache_device_attach(d, c, u - c->uuids);
-	bch_sectors_dirty_init(d);
+	err = bch_sectors_dirty_init(d);
+	if (err)
+		goto err;
 	bch_flash_dev_request_init(d);
 	err = add_disk(d->disk);
 	if (err)
-- 
2.17.1

