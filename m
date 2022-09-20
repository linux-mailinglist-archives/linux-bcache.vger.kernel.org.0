Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8B345BE46E
	for <lists+linux-bcache@lfdr.de>; Tue, 20 Sep 2022 13:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiITL24 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 20 Sep 2022 07:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiITL2y (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 20 Sep 2022 07:28:54 -0400
Received: from mail-m31114.qiye.163.com (mail-m31114.qiye.163.com [103.74.31.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26F46BD76
        for <linux-bcache@vger.kernel.org>; Tue, 20 Sep 2022 04:28:53 -0700 (PDT)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m31114.qiye.163.com (Hmail) with ESMTPA id CCED85C01AC;
        Tue, 20 Sep 2022 19:28:51 +0800 (CST)
From:   mingzhe.zou@easystack.cn
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     zoumingzhe@qq.com
Subject: [PATCH v3 3/3] bcache: check bch_cached_dev_attach() return value
Date:   Tue, 20 Sep 2022 19:28:50 +0800
Message-Id: <20220920112850.13157-3-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220920112850.13157-1-mingzhe.zou@easystack.cn>
References: <20220920112850.13157-1-mingzhe.zou@easystack.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlCTkhOVkNPQ0xMTkhNQhkfSlUZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hKTFVKS0tVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6K1E6TRw5DjITMygXGhQJFC5L
        E00KCzlVSlVKTU1ITUxISEhJSUxMVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSElJTTcG
X-HM-Tid: 0a835aa870df00c3kurmcced85c01ac
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: ZouMingzhe <mingzhe.zou@easystack.cn>

handle error when call bch_cached_dev_attach() function

Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/super.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 9dcffeb4c182..14cd5e5dc65b 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1458,7 +1458,7 @@ static int register_bdev(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 {
 	const char *err = "cannot allocate memory";
 	struct cache_set *c;
-	int ret = -ENOMEM;
+	int ret = -ENOMEM, ret_tmp;
 
 	memcpy(&dc->sb, sb, sizeof(struct cache_sb));
 	dc->bdev = bdev;
@@ -1478,8 +1478,14 @@ static int register_bdev(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 
 	list_add(&dc->list, &uncached_devices);
 	/* attach to a matched cache set if it exists */
-	list_for_each_entry(c, &bch_cache_sets, list)
-		bch_cached_dev_attach(dc, c, NULL);
+	err = "failed to attach cached device";
+	list_for_each_entry(c, &bch_cache_sets, list) {
+		ret_tmp = bch_cached_dev_attach(dc, c, NULL);
+		if (ret_tmp)
+			ret = ret_tmp;
+	}
+	if (ret)
+		goto err;
 
 	if (BDEV_STATE(&dc->sb) == BDEV_STATE_NONE ||
 	    BDEV_STATE(&dc->sb) == BDEV_STATE_STALE) {
@@ -1979,6 +1985,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 
 static int run_cache_set(struct cache_set *c)
 {
+	int ret = -EIO, ret_tmp;
 	const char *err = "cannot allocate memory";
 	struct cached_dev *dc, *t;
 	struct cache *ca = c->cache;
@@ -2131,8 +2138,14 @@ static int run_cache_set(struct cache_set *c)
 	if (bch_has_feature_obso_large_bucket(&c->cache->sb))
 		pr_err("Detect obsoleted large bucket layout, all attached bcache device will be read-only\n");
 
-	list_for_each_entry_safe(dc, t, &uncached_devices, list)
-		bch_cached_dev_attach(dc, c, NULL);
+	err = "failed to attach cached device";
+	list_for_each_entry_safe(dc, t, &uncached_devices, list) {
+		ret_tmp = bch_cached_dev_attach(dc, c, NULL);
+		if (ret_tmp)
+			ret = ret_tmp;
+	}
+	if (ret)
+		goto err;
 
 	flash_devs_run(c);
 
@@ -2150,7 +2163,7 @@ static int run_cache_set(struct cache_set *c)
 
 	bch_cache_set_error(c, "%s", err);
 
-	return -EIO;
+	return ret;
 }
 
 static const char *register_cache_set(struct cache *ca)
-- 
2.17.1

