Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06322783DC6
	for <lists+linux-bcache@lfdr.de>; Tue, 22 Aug 2023 12:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234701AbjHVKUP (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 22 Aug 2023 06:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233252AbjHVKUO (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 22 Aug 2023 06:20:14 -0400
Received: from mail-m2835.qiye.163.com (mail-m2835.qiye.163.com [103.74.28.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385811B2
        for <linux-bcache@vger.kernel.org>; Tue, 22 Aug 2023 03:20:11 -0700 (PDT)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m2835.qiye.163.com (Hmail) with ESMTPA id 82BD88A00AA;
        Tue, 22 Aug 2023 18:20:07 +0800 (CST)
From:   Mingzhe Zou <mingzhe.zou@easystack.cn>
To:     colyli@suse.de, bcache@lists.ewheeler.net,
        linux-bcache@vger.kernel.org
Cc:     zoumingzhe@qq.com, Mingzhe Zou <mingzhe.zou@easystack.cn>
Subject: [PATCH] bcache: fixup init dirty data errors
Date:   Tue, 22 Aug 2023 18:19:58 +0800
Message-Id: <20230822101958.2577-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlCTR1KVkpCQkNLGE5NThlKGFUZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpNT0lMTlVKS0tVSkJLS1kG
X-HM-Tid: 0a8a1cc242b8841dkuqw82bd88a00aa
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6K0k6Ihw5KzE*IRwVCjxNHgwU
        FBIKCzJVSlVKTUJJTUJCTUtDSU1JVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSUlITTcG
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

We found that after long run, the dirty_data of the bcache device
will have errors. This error cannot be eliminated unless re-register.

We also found that reattach after detach, this error can accumulate.

In bch_sectors_dirty_init(), all inode <= d->id keys will be recounted
again. This is wrong, we only need to count the keys of the current
device.

Fixes: b144e45fc576 ("bcache: make bch_sectors_dirty_init() to be multithreaded")
Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/writeback.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 24c049067f61..71d0dabcbf9d 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -983,6 +983,8 @@ void bch_sectors_dirty_init(struct bcache_device *d)
 	struct cache_set *c = d->c;
 	struct bch_dirty_init_state state;
 
+	atomic_long_set(&d->dirty_sectors, 0);
+
 	/* Just count root keys if no leaf node */
 	rw_lock(0, c->root, c->root->level);
 	if (c->root->level == 0) {
@@ -991,8 +993,11 @@ void bch_sectors_dirty_init(struct bcache_device *d)
 		op.count = 0;
 
 		for_each_key_filter(&c->root->keys,
-				    k, &iter, bch_ptr_invalid)
+				    k, &iter, bch_ptr_invalid) {
+			if (KEY_INODE(k) != op.inode)
+				continue;
 			sectors_dirty_init_fn(&op.op, c->root, k);
+		}
 
 		rw_unlock(0, c->root);
 		return;
-- 
2.17.1.windows.2

