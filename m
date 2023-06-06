Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF54724035
	for <lists+linux-bcache@lfdr.de>; Tue,  6 Jun 2023 12:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236778AbjFFK5F (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 6 Jun 2023 06:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbjFFK4a (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 6 Jun 2023 06:56:30 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 388A2211C
        for <linux-bcache@vger.kernel.org>; Tue,  6 Jun 2023 03:53:16 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id D8DD81FD67;
        Tue,  6 Jun 2023 10:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686048794; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=w0VM1SlF9ZYM3ocAYoILa7DZH93wirgdobdI/T9iCrg=;
        b=EgM6AFyYBplkiDH4Rv4qNtgEayeXeSYhHlHpKR5vo84BTMbblOBmVwdEVTCeJ0rd/ueCav
        +Wcotrtxx2a3IzxSxpxVqs0vz4gDa18ouGr1uUDsu1LygGgy4/wfo+tXvsS2a37p1WiZ9/
        F/d2MARcJPQtlxPibK6RqxZ/eNycmNQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686048794;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=w0VM1SlF9ZYM3ocAYoILa7DZH93wirgdobdI/T9iCrg=;
        b=uvGSCYk36g5chcHwLUftQV3gzGZpjIPBpzP4ZJQbYQFiU5PTitM7QMbuvEeBVOgBNF6iS0
        qu1WiqnMZyekgmCg==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 3C0862C141;
        Tue,  6 Jun 2023 10:53:13 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Mingzhe Zou <mingzhe.zou@easystack.cn>
Subject: [PATCH] bcache: don't allocate full_dirty_stripes and stripe_sectors_dirty for flash device
Date:   Tue,  6 Jun 2023 18:52:05 +0800
Message-Id: <20230606105205.9161-1-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The flash device is a special bcache device which doesn't have backing
device and stores all data on cache set. Although its data is treated
as dirty data but the writeback to backing device never happens.

Therefore it is unncessary to always allocate memory for counters
full_dirty_stripes and stripe_sectors_dirty when the bcache device is
on flash only.

This patch avoids to allocate/free memory for full_dirty_stripes and
stripe_sectors_dirty in bcache_device_init() and bcache_device_free().
Also in bcache_dev_sectors_dirty_add(), if the data is written onto
flash device, avoid to update the counters in full_dirty_stripes and
stripe_sectors_dirty because they are not used at all.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Mingzhe Zou <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/super.c     | 18 ++++++++++++++----
 drivers/md/bcache/writeback.c |  8 +++++++-
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 077149c4050b..00edc093e544 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -887,12 +887,15 @@ static void bcache_device_free(struct bcache_device *d)
 	}
 
 	bioset_exit(&d->bio_split);
-	kvfree(d->full_dirty_stripes);
-	kvfree(d->stripe_sectors_dirty);
+	if (d->full_dirty_stripes)
+		kvfree(d->full_dirty_stripes);
+	if (d->stripe_sectors_dirty)
+		kvfree(d->stripe_sectors_dirty);
 
 	closure_debug_destroy(&d->cl);
 }
 
+
 static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 		sector_t sectors, struct block_device *cached_bdev,
 		const struct block_device_operations *ops)
@@ -914,6 +917,10 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 	}
 	d->nr_stripes = n;
 
+	/* Skip allocating stripes counters for flash device */
+	if (d->c && UUID_FLASH_ONLY(&d->c->uuids[d->id]))
+		goto get_idx;
+
 	n = d->nr_stripes * sizeof(atomic_t);
 	d->stripe_sectors_dirty = kvzalloc(n, GFP_KERNEL);
 	if (!d->stripe_sectors_dirty)
@@ -924,6 +931,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 	if (!d->full_dirty_stripes)
 		goto out_free_stripe_sectors_dirty;
 
+get_idx:
 	idx = ida_simple_get(&bcache_device_idx, 0,
 				BCACHE_DEVICE_IDX_MAX, GFP_KERNEL);
 	if (idx < 0)
@@ -981,9 +989,11 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 out_ida_remove:
 	ida_simple_remove(&bcache_device_idx, idx);
 out_free_full_dirty_stripes:
-	kvfree(d->full_dirty_stripes);
+	if (d->full_dirty_stripes)
+		kvfree(d->full_dirty_stripes);
 out_free_stripe_sectors_dirty:
-	kvfree(d->stripe_sectors_dirty);
+	if (d->stripe_sectors_dirty)
+		kvfree(d->stripe_sectors_dirty);
 	return -ENOMEM;
 
 }
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 24c049067f61..32a034e74622 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -607,8 +607,14 @@ void bcache_dev_sectors_dirty_add(struct cache_set *c, unsigned int inode,
 	if (stripe < 0)
 		return;
 
-	if (UUID_FLASH_ONLY(&c->uuids[inode]))
+	/*
+	 * The flash device doesn't have backing device to writeback,
+	 * it is unncessary to calculate stripes related stuffs.
+	 */
+	if (UUID_FLASH_ONLY(&c->uuids[inode])) {
 		atomic_long_add(nr_sectors, &c->flash_dev_dirty_sectors);
+		return;
+	}
 
 	stripe_offset = offset & (d->stripe_size - 1);
 
-- 
2.35.3

