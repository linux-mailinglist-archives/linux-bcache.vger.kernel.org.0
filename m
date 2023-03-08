Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB3CD6B02B7
	for <lists+linux-bcache@lfdr.de>; Wed,  8 Mar 2023 10:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjCHJU7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 8 Mar 2023 04:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbjCHJU5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 8 Mar 2023 04:20:57 -0500
Received: from mail-m3164.qiye.163.com (mail-m3164.qiye.163.com [103.74.31.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C40395BE6
        for <linux-bcache@vger.kernel.org>; Wed,  8 Mar 2023 01:20:55 -0800 (PST)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m3164.qiye.163.com (Hmail) with ESMTPA id 3D6266202B1;
        Wed,  8 Mar 2023 17:20:48 +0800 (CST)
From:   mingzhe <mingzhe.zou@easystack.cn>
To:     colyli@suse.de, bcache@lists.ewheeler.net
Cc:     linux-bcache@vger.kernel.org, zoumingzhe@qq.com
Subject: [PATCH] bcache: set io_disable to true when stop bcache device
Date:   Wed,  8 Mar 2023 17:20:36 +0800
Message-Id: <20230308092036.11024-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1.windows.2
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkaTh5IVk1PGkxKQktOHkJKHlUZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hKTFVKS0tVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MEk6Igw4FTJMFjUQLw04L0k8
        NjYKFCJVSlVKTUxDSU1MSU9DQ01DVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSElDQjcG
X-HM-Tid: 0a86c085ef2b00a4kurm3d6266202b1
X-HM-MType: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Stop is an operation that cannot be aborted. If there are still
IO requests being processed, we can never stop the device.
So, all new IO requests should fail when we set io_disable to true.
However, sysfs has been unlinked at this time, user cannot modify
io_disable via sysfs.

Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/request.c | 16 ++++++++++++++++
 drivers/md/bcache/super.c   |  9 +++++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 67a2e29e0b40..9b85aad20022 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -758,6 +758,15 @@ static void cached_dev_bio_complete(struct closure *cl)
 	search_free(cl);
 }
 
+static void cached_dev_bio_fail(struct closure *cl)
+{
+	struct search *s = container_of(cl, struct search, cl);
+	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
+
+	s->iop.status = BLK_STS_IOERR;
+	cached_dev_bio_complete(cl);
+}
+
 /* Process reads */
 
 static void cached_dev_read_error_done(struct closure *cl)
@@ -971,6 +980,9 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
 	struct bkey start = KEY(dc->disk.id, bio->bi_iter.bi_sector, 0);
 	struct bkey end = KEY(dc->disk.id, bio_end_sector(bio), 0);
 
+	if (unlikely((dc->io_disable)))
+		goto fail_bio;
+
 	bch_keybuf_check_overlapping(&s->iop.c->moving_gc_keys, &start, &end);
 
 	down_read_non_owner(&dc->writeback_lock);
@@ -1046,6 +1058,10 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
 insert_data:
 	closure_call(&s->iop.cl, bch_data_insert, NULL, cl);
 	continue_at(cl, cached_dev_write_complete, NULL);
+	return;
+
+fail_bio:
+	continue_at(cl, cached_dev_bio_fail, NULL);
 }
 
 static void cached_dev_nodata(struct closure *cl)
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index ba3909bb6bea..a2a82942f85b 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1389,6 +1389,15 @@ static void cached_dev_flush(struct closure *cl)
 	bch_cache_accounting_destroy(&dc->accounting);
 	kobject_del(&d->kobj);
 
+	/*
+	 * Stop is an operation that cannot be aborted. If there are still
+	 * IO requests being processed, we can never stop the device.
+	 * So, all new IO requests should fail when we set io_disable to true.
+	 * However, sysfs has been unlinked at this time, user cannot modify
+	 * io_disable via sysfs.
+	 */
+	dc->io_disable = true;
+
 	continue_at(cl, cached_dev_free, system_wq);
 }
 
-- 
2.17.1.windows.2

