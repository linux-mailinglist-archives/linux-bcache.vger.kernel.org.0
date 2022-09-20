Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4DB5BE46D
	for <lists+linux-bcache@lfdr.de>; Tue, 20 Sep 2022 13:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiITL2z (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 20 Sep 2022 07:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiITL2y (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 20 Sep 2022 07:28:54 -0400
Received: from mail-m31114.qiye.163.com (mail-m31114.qiye.163.com [103.74.31.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4677A6C10B
        for <linux-bcache@vger.kernel.org>; Tue, 20 Sep 2022 04:28:53 -0700 (PDT)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m31114.qiye.163.com (Hmail) with ESMTPA id 22C6A5C01AB;
        Tue, 20 Sep 2022 19:28:51 +0800 (CST)
From:   mingzhe.zou@easystack.cn
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     zoumingzhe@qq.com
Subject: [PATCH v3 2/3] bcache: check bch_sectors_dirty_init() return value
Date:   Tue, 20 Sep 2022 19:28:49 +0800
Message-Id: <20220920112850.13157-2-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220920112850.13157-1-mingzhe.zou@easystack.cn>
References: <20220920112850.13157-1-mingzhe.zou@easystack.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkZTRlMVhgfTUkeT01CHUhJGVUZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hKTFVKS0tVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MTI6Kio*AzILGSg9Cgk3FCMw
        HTJPFB9VSlVKTU1ITUxISEhKTE1OVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSEtMTDcG
X-HM-Tid: 0a835aa86f1700c3kurm22c6a5c01ab
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: ZouMingzhe <mingzhe.zou@easystack.cn>

handle error when call bch_sectors_dirty_init() function

Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/super.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index ba3909bb6bea..9dcffeb4c182 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1298,21 +1298,17 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
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
@@ -1332,6 +1328,18 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
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
@@ -1540,7 +1548,9 @@ static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
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

