Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4246EE274
	for <lists+linux-bcache@lfdr.de>; Tue, 25 Apr 2023 15:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbjDYNEu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 25 Apr 2023 09:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233685AbjDYNEq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 25 Apr 2023 09:04:46 -0400
X-Greylist: delayed 495 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 25 Apr 2023 06:04:43 PDT
Received: from mail-m2838.qiye.163.com (mail-m2838.qiye.163.com [103.74.28.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E0310C
        for <linux-bcache@vger.kernel.org>; Tue, 25 Apr 2023 06:04:43 -0700 (PDT)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m2838.qiye.163.com (Hmail) with ESMTPA id 837613C0582;
        Tue, 25 Apr 2023 20:56:22 +0800 (CST)
From:   Mingzhe Zou <mingzhe.zou@easystack.cn>
To:     colyli@suse.de, bcache@lists.ewheeler.net,
        linux-bcache@vger.kernel.org
Cc:     zoumingzhe@qq.com
Subject: [PATCH] bcache: fix up kthread_stop crash in cached_dev_free()
Date:   Tue, 25 Apr 2023 20:56:11 +0800
Message-Id: <20230425125611.8821-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlCGB1DVkhJTRpDGUoeQh5NGlUZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpJS0NOTVVKS0tVS1kG
X-HM-Tid: 0a87b87c8ba08420kuqw837613c0582
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mww6Sio6AjICTjAtHBAQKxkp
        IxgKFE5VSlVKTUNJT0lMSENISk5NVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSk1OSjcG
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In bch_cached_dev_attach(), writeback kthread stopped if
bch_cached_dev_run() returns error. Then, cached_dev_free()
will stop writeback kthread again and crash.

This patch set dc->writeback_thread to null after call kthread_stop().

Fixes: 5c2a634cbfaf ("bcache: stop writeback kthread and kworker when bch_cached_dev_run() failed")
Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index ba3909bb6bea..7b6e533b0339 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1310,6 +1310,7 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 		 * have to be stopped manually here.
 		 */
 		kthread_stop(dc->writeback_thread);
+		dc->writeback_thread = NULL;
 		cancel_writeback_rate_update_dwork(dc);
 		pr_err("Couldn't run cached device %pg\n", dc->bdev);
 		return ret;
-- 
2.17.1.windows.2

