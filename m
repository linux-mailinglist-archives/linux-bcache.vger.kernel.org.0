Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5756973A666
	for <lists+linux-bcache@lfdr.de>; Thu, 22 Jun 2023 18:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjFVQrE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 22 Jun 2023 12:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbjFVQrC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 22 Jun 2023 12:47:02 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93038E42;
        Thu, 22 Jun 2023 09:47:00 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B816A21C96;
        Thu, 22 Jun 2023 16:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1687452418; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3LRoZWXHfZd+7dNHbIoqZ0TZe/GD5cIwqG6qzogCaew=;
        b=fhdd2Q7Gl/yuv5JiYy5REYhkvMz28ip+fbKhg9N7gonX2lwGv7ejO0GRtATEq0gORFOlbc
        R39meyZeVxtY5U+dsQ+/UOREDFds/3STt9pI9U3DOdqa519Gau3ByGtzLPZA+MoQBAg0DJ
        Oq0OjyUwg3KRaydhbta+o7cMq0Dn75M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1687452418;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3LRoZWXHfZd+7dNHbIoqZ0TZe/GD5cIwqG6qzogCaew=;
        b=4zStbAoxmRxEqIvgqGZaGDdTYDEzK2xHKvKVOSKTB32CIkHxzGHsw5HEfkG/PYEeh3b+AM
        aM20WlBFwnCOdoAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A908F13A6F;
        Thu, 22 Jun 2023 16:46:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ciU/KQJ7lGSISwAAMHmgww
        (envelope-from <jack@suse.cz>); Thu, 22 Jun 2023 16:46:58 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 26D9DA0660; Thu, 22 Jun 2023 18:46:58 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        <linux-block@vger.kernel.org>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH v2 1/2] bcache: Alloc holder object before async registration
Date:   Thu, 22 Jun 2023 18:46:54 +0200
Message-Id: <20230622164658.12861-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230622164149.17134-1-jack@suse.cz>
References: <20230622164149.17134-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4896; i=jack@suse.cz; h=from:subject; bh=wwP7Ac/wRl4ZCJg9yakql11C47nYllFwsaq5HKY0jlg=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBklHr9GJwmLO8dTgAMwbUR+T6DhQB6JEFdktOeDsJ+ aQ+K3suJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCZJR6/QAKCRCcnaoHP2RA2folB/ 9eHDXpToaZYE8C4Tlg/brJhjCSPoSzNGNtKc1PRQJXe2Z1pquJNWIGldJM4LWwHmL3w6ne3TOxC2eT lWA2G6gp92EIQ8WCocinIVtZzEvcx2JUKksPT2v/ws47xzp/WDxY9CCnMVfAdEyUVui4Gmkd/q0DGu DS1MJwG62E1FKEKv21XGE6QeF7/kh4SRi+I3iUWK4k7/aba4PQBm+8JI6dL6bL7ppyNDcnVmwTc0Gb hLstx7SMGH+OmAKcwjKqngFaLfVuhD8A8vkr+SBvAyRXDx5gdJnR01fIB3iU+stVvdzSI53x+XFKyM CZC8pZdu5oasKyxkdgA0KijFLmjHY0
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Allocate holder object (cache or cached_dev) before offloading the
rest of the startup to async work. This will allow us to open the block
block device with proper holder.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/md/bcache/super.c | 66 +++++++++++++++------------------------
 1 file changed, 25 insertions(+), 41 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index e2a803683105..913dd94353b6 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2448,6 +2448,7 @@ struct async_reg_args {
 	struct cache_sb *sb;
 	struct cache_sb_disk *sb_disk;
 	struct block_device *bdev;
+	void *holder;
 };
 
 static void register_bdev_worker(struct work_struct *work)
@@ -2455,22 +2456,13 @@ static void register_bdev_worker(struct work_struct *work)
 	int fail = false;
 	struct async_reg_args *args =
 		container_of(work, struct async_reg_args, reg_work.work);
-	struct cached_dev *dc;
-
-	dc = kzalloc(sizeof(*dc), GFP_KERNEL);
-	if (!dc) {
-		fail = true;
-		put_page(virt_to_page(args->sb_disk));
-		blkdev_put(args->bdev, bcache_kobj);
-		goto out;
-	}
 
 	mutex_lock(&bch_register_lock);
-	if (register_bdev(args->sb, args->sb_disk, args->bdev, dc) < 0)
+	if (register_bdev(args->sb, args->sb_disk, args->bdev, args->holder)
+	    < 0)
 		fail = true;
 	mutex_unlock(&bch_register_lock);
 
-out:
 	if (fail)
 		pr_info("error %s: fail to register backing device\n",
 			args->path);
@@ -2485,21 +2477,11 @@ static void register_cache_worker(struct work_struct *work)
 	int fail = false;
 	struct async_reg_args *args =
 		container_of(work, struct async_reg_args, reg_work.work);
-	struct cache *ca;
-
-	ca = kzalloc(sizeof(*ca), GFP_KERNEL);
-	if (!ca) {
-		fail = true;
-		put_page(virt_to_page(args->sb_disk));
-		blkdev_put(args->bdev, bcache_kobj);
-		goto out;
-	}
 
 	/* blkdev_put() will be called in bch_cache_release() */
-	if (register_cache(args->sb, args->sb_disk, args->bdev, ca) != 0)
+	if (register_cache(args->sb, args->sb_disk, args->bdev, args->holder))
 		fail = true;
 
-out:
 	if (fail)
 		pr_info("error %s: fail to register cache device\n",
 			args->path);
@@ -2520,6 +2502,13 @@ static void register_device_async(struct async_reg_args *args)
 	queue_delayed_work(system_wq, &args->reg_work, 10);
 }
 
+static void *alloc_holder_object(struct cache_sb *sb)
+{
+	if (SB_IS_BDEV(sb))
+		return kzalloc(sizeof(struct cached_dev), GFP_KERNEL);
+	return kzalloc(sizeof(struct cache), GFP_KERNEL);
+}
+
 static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 			       const char *buffer, size_t size)
 {
@@ -2528,6 +2517,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	struct cache_sb *sb;
 	struct cache_sb_disk *sb_disk;
 	struct block_device *bdev;
+	void *holder;
 	ssize_t ret;
 	bool async_registration = false;
 
@@ -2585,6 +2575,13 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	if (err)
 		goto out_blkdev_put;
 
+	holder = alloc_holder_object(sb);
+	if (!holder) {
+		ret = -ENOMEM;
+		err = "cannot allocate memory";
+		goto out_put_sb_page;
+	}
+
 	err = "failed to register device";
 
 	if (async_registration) {
@@ -2595,44 +2592,29 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 		if (!args) {
 			ret = -ENOMEM;
 			err = "cannot allocate memory";
-			goto out_put_sb_page;
+			goto out_free_holder;
 		}
 
 		args->path	= path;
 		args->sb	= sb;
 		args->sb_disk	= sb_disk;
 		args->bdev	= bdev;
+		args->holder	= holder;
 		register_device_async(args);
 		/* No wait and returns to user space */
 		goto async_done;
 	}
 
 	if (SB_IS_BDEV(sb)) {
-		struct cached_dev *dc = kzalloc(sizeof(*dc), GFP_KERNEL);
-
-		if (!dc) {
-			ret = -ENOMEM;
-			err = "cannot allocate memory";
-			goto out_put_sb_page;
-		}
-
 		mutex_lock(&bch_register_lock);
-		ret = register_bdev(sb, sb_disk, bdev, dc);
+		ret = register_bdev(sb, sb_disk, bdev, holder);
 		mutex_unlock(&bch_register_lock);
 		/* blkdev_put() will be called in cached_dev_free() */
 		if (ret < 0)
 			goto out_free_sb;
 	} else {
-		struct cache *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
-
-		if (!ca) {
-			ret = -ENOMEM;
-			err = "cannot allocate memory";
-			goto out_put_sb_page;
-		}
-
 		/* blkdev_put() will be called in bch_cache_release() */
-		ret = register_cache(sb, sb_disk, bdev, ca);
+		ret = register_cache(sb, sb_disk, bdev, holder);
 		if (ret)
 			goto out_free_sb;
 	}
@@ -2644,6 +2626,8 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 async_done:
 	return size;
 
+out_free_holder:
+	kfree(holder);
 out_put_sb_page:
 	put_page(virt_to_page(sb_disk));
 out_blkdev_put:
-- 
2.35.3

