Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D504B1EB7
	for <lists+linux-bcache@lfdr.de>; Fri, 11 Feb 2022 07:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346136AbiBKGtA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 11 Feb 2022 01:49:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346094AbiBKGs4 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 11 Feb 2022 01:48:56 -0500
X-Greylist: delayed 551 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Feb 2022 22:48:54 PST
Received: from mail-m2836.qiye.163.com (mail-m2836.qiye.163.com [103.74.28.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648B710EA
        for <linux-bcache@vger.kernel.org>; Thu, 10 Feb 2022 22:48:54 -0800 (PST)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m2836.qiye.163.com (Hmail) with ESMTPA id E02C4C03CD;
        Fri, 11 Feb 2022 14:39:39 +0800 (CST)
From:   mingzhe.zou@easystack.cn
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     zoumingzhe@qq.com, mingzhe.zou@easystack.cn
Subject: [PATCH] bcache: fixup multiple threads crash
Date:   Fri, 11 Feb 2022 14:39:15 +0800
Message-Id: <20220211063915.4101-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlCN1dZLVlBSVdZDwkaFQgSH1lBWUMdSB9WT01IGR9NGBhDSB
        1PVRkRExYaEhckFA4PWVdZFhoPEhUdFFlBWVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NTI6Nzo6NzIwGRQQFhQtFisK
        Ej1PCzdVSlVKTU9PTk1KTkNLSEpIVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSU1CTTcG
X-HM-Tid: 0a7ee782403f841ekuqwe02c4c03cd
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Mingzhe Zou <mingzhe.zou@easystack.cn>

When multiple threads to check btree nodes in parallel, the main
thread wait for all threads to stop or CACHE_SET_IO_DISABLE flag:

wait_event_interruptible(check_state->wait,
                         atomic_read(&check_state->started) == 0 ||
                         test_bit(CACHE_SET_IO_DISABLE, &c->flags));

However, the bch_btree_node_read and bch_btree_node_read_done
maybe call bch_cache_set_error, then the CACHE_SET_IO_DISABLE
will be set. If the flag already set, the main thread return
error. At the same time, maybe some threads still running and
read NULL pointer, the kernel will crash.

This patch change the event wait condition, the main thread must
wait for all threads to stop.

Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/btree.c     | 6 ++++--
 drivers/md/bcache/writeback.c | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 88c573eeb598..ad9f16689419 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -2060,9 +2060,11 @@ int bch_btree_check(struct cache_set *c)
 		}
 	}
 
+	/*
+	 * Must wait for all threads to stop.
+	 */
 	wait_event_interruptible(check_state->wait,
-				 atomic_read(&check_state->started) == 0 ||
-				  test_bit(CACHE_SET_IO_DISABLE, &c->flags));
+				 atomic_read(&check_state->started) == 0);
 
 	for (i = 0; i < check_state->total_threads; i++) {
 		if (check_state->infos[i].result) {
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index c7560f66dca8..68d3dd6b4f11 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -998,9 +998,11 @@ void bch_sectors_dirty_init(struct bcache_device *d)
 		}
 	}
 
+	/*
+	 * Must wait for all threads to stop.
+	 */
 	wait_event_interruptible(state->wait,
-		 atomic_read(&state->started) == 0 ||
-		 test_bit(CACHE_SET_IO_DISABLE, &c->flags));
+		 atomic_read(&state->started) == 0);
 
 out:
 	kfree(state);
-- 
2.17.1

