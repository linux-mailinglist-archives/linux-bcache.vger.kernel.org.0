Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD5A4FF6E7
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Apr 2022 14:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbiDMMis (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 13 Apr 2022 08:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbiDMMis (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 13 Apr 2022 08:38:48 -0400
Received: from mail-m2836.qiye.163.com (mail-m2836.qiye.163.com [103.74.28.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CD1434B7
        for <linux-bcache@vger.kernel.org>; Wed, 13 Apr 2022 05:36:26 -0700 (PDT)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m2836.qiye.163.com (Hmail) with ESMTPA id E3DC1C0A92;
        Wed, 13 Apr 2022 20:36:22 +0800 (CST)
From:   mingzhe.zou@easystack.cn
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     zoumingzhe@qq.com, ZouMingzhe <mingzhe.zou@easystack.cn>
Subject: [PATCH v3] bcache: check bch_cached_dev_attach() return value
Date:   Wed, 13 Apr 2022 20:36:08 +0800
Message-Id: <20220413123608.26740-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220411030417.7222-3-mingzhe.zou@easystack.cn>
References: <20220411030417.7222-3-mingzhe.zou@easystack.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlCN1dZLVlBSVdZDwkaFQgSH1lBWRpJS05WSh5JSkoZQhofQ0
        tLVRkRExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktISkxVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NBg6Pww4STIuMS1DFCI3ITxJ
        NCswCi1VSlVKTU9CQ05ISENISU1MVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSEhJTzcG
X-HM-Tid: 0a8022ecc197841ekuqwe3dc1c0a92
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: ZouMingzhe <mingzhe.zou@easystack.cn>

handle error when call bch_cached_dev_attach() function

Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/super.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index e4a53c849fa6..82be0ec83e1f 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1460,7 +1460,7 @@ static int register_bdev(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 {
 	const char *err = "cannot allocate memory";
 	struct cache_set *c;
-	int ret = -ENOMEM;
+	int ret = -ENOMEM, ret_tmp;
 
 	memcpy(&dc->sb, sb, sizeof(struct cache_sb));
 	dc->bdev = bdev;
@@ -1480,8 +1480,15 @@ static int register_bdev(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 
 	list_add(&dc->list, &uncached_devices);
 	/* attach to a matched cache set if it exists */
-	list_for_each_entry(c, &bch_cache_sets, list)
-		bch_cached_dev_attach(dc, c, NULL);
+	ret = 0;
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
@@ -1981,6 +1988,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 
 static int run_cache_set(struct cache_set *c)
 {
+	int ret = -EIO, ret_tmp;
 	const char *err = "cannot allocate memory";
 	struct cached_dev *dc, *t;
 	struct cache *ca = c->cache;
@@ -2133,8 +2141,15 @@ static int run_cache_set(struct cache_set *c)
 	if (bch_has_feature_obso_large_bucket(&c->cache->sb))
 		pr_err("Detect obsoleted large bucket layout, all attached bcache device will be read-only\n");
 
-	list_for_each_entry_safe(dc, t, &uncached_devices, list)
-		bch_cached_dev_attach(dc, c, NULL);
+	ret = 0;
+	err = "failed to attach cached device";
+	list_for_each_entry_safe(dc, t, &uncached_devices, list) {
+		ret_tmp = bch_cached_dev_attach(dc, c, NULL);
+		if (ret_tmp)
+			ret = ret_tmp;
+	}
+	if (ret)
+		goto err;
 
 	flash_devs_run(c);
 
@@ -2151,7 +2166,7 @@ static int run_cache_set(struct cache_set *c)
 
 	bch_cache_set_error(c, "%s", err);
 
-	return -EIO;
+	return ret;
 }
 
 static const char *register_cache_set(struct cache *ca)
-- 
2.17.1

