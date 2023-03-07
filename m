Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2403F6AE15A
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Mar 2023 14:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbjCGNwG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 7 Mar 2023 08:52:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbjCGNvu (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 7 Mar 2023 08:51:50 -0500
Received: from mail-m3164.qiye.163.com (mail-m3164.qiye.163.com [103.74.31.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8D121972
        for <linux-bcache@vger.kernel.org>; Tue,  7 Mar 2023 05:51:07 -0800 (PST)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m3164.qiye.163.com (Hmail) with ESMTPA id 2E9AD620356;
        Tue,  7 Mar 2023 21:49:03 +0800 (CST)
From:   mingzhe <mingzhe.zou@easystack.cn>
To:     colyli@suse.de, bcache@lists.ewheeler.net,
        andrea.tomassetti-opensource@devo.com
Cc:     linux-bcache@vger.kernel.org, zoumingzhe@qq.com
Subject: [PATCH v7 1/3] bcache: add dirty_data in struct bcache_device
Date:   Tue,  7 Mar 2023 21:48:50 +0800
Message-Id: <20230307134852.8288-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1.windows.2
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlCGRgeVkgYGkhCTBkaQktKH1UZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hKTFVKS0tVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ok06MDo4GTJINDZODCMpCkoq
        MzIaCQpVSlVKTUxDSkJNQk9ITUNMVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSUNMSTcG
X-HM-Tid: 0a86bc5529f700a4kurm2e9ad620356
X-HM-MType: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Currently, the dirty_data of cached_dev and flash_dev depend on the stripe.

Since the flash device supports resize, it may cause a bug (resize the flash
from 1T to 2T, and nr_stripes from 1 to 2).

The patch add dirty_data in struct bcache_device, we can get the value of
dirty_data quickly and fixes the bug of resize flash device.

Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>

---
Changelog:
v7: Fix up the bug abort git am patch.
v1: Original verison.
---
 drivers/md/bcache/bcache.h    | 1 +
 drivers/md/bcache/writeback.c | 2 ++
 drivers/md/bcache/writeback.h | 7 +------
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index aebb7ef10e63..db3439d65582 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -268,6 +268,7 @@ struct bcache_device {
 	unsigned int		stripe_size;
 	atomic_t		*stripe_sectors_dirty;
 	unsigned long		*full_dirty_stripes;
+	atomic_long_t		dirty_sectors;
 
 	struct bio_set		bio_split;
 
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index d4a5fc0650bb..65c997b25cca 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -607,6 +607,8 @@ void bcache_dev_sectors_dirty_add(struct cache_set *c, unsigned int inode,
 	if (stripe < 0)
 		return;
 
+	atomic_long_add(nr_sectors, &d->dirty_sectors);
+
 	if (UUID_FLASH_ONLY(&c->uuids[inode]))
 		atomic_long_add(nr_sectors, &c->flash_dev_dirty_sectors);
 
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index 31df716951f6..a5bb1caa6c6e 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -48,12 +48,7 @@ struct bch_dirty_init_state {
 
 static inline uint64_t bcache_dev_sectors_dirty(struct bcache_device *d)
 {
-	uint64_t i, ret = 0;
-
-	for (i = 0; i < d->nr_stripes; i++)
-		ret += atomic_read(d->stripe_sectors_dirty + i);
-
-	return ret;
+	return atomic_long_read(&d->dirty_sectors);
 }
 
 static inline int offset_to_stripe(struct bcache_device *d,
-- 
2.17.1.windows.2

