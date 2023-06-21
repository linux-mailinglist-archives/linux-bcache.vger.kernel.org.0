Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8834A738AF9
	for <lists+linux-bcache@lfdr.de>; Wed, 21 Jun 2023 18:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbjFUQYD (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 21 Jun 2023 12:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbjFUQXj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Jun 2023 12:23:39 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC4E19A1;
        Wed, 21 Jun 2023 09:23:35 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3357E21F37;
        Wed, 21 Jun 2023 16:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1687364614; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3LRoZWXHfZd+7dNHbIoqZ0TZe/GD5cIwqG6qzogCaew=;
        b=PHYiQwsYqy05FCAYOVb9Shxu1I9fhByuuY2AuvkHdB86FOuP4gbTUoVJkYARQ9Z/UyUYKY
        jtrXs34U0OP+Ut9009ibcr/YNGnjRdNesI+idh+xggU99wphX/irytOthjw2TdoGlBrEp+
        O5RJFgti+LpR5VyyLF5t44vitMejSA8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1687364614;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3LRoZWXHfZd+7dNHbIoqZ0TZe/GD5cIwqG6qzogCaew=;
        b=tJB9t89xrBLjcL8ZbT74SurLx9Huzuxetp1RvJteyHu5VD9k051zcXCuSQ2qk9EVRl4RdP
        i+3hMozI8hAFyIDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 24EE513A6D;
        Wed, 21 Jun 2023 16:23:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id cispCQYkk2TGPQAAMHmgww
        (envelope-from <jack@suse.cz>); Wed, 21 Jun 2023 16:23:34 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 88CB3A054C; Wed, 21 Jun 2023 18:23:33 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>,
        <linux-block@vger.kernel.org>, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] bcache: Alloc holder object before async registration
Date:   Wed, 21 Jun 2023 18:23:26 +0200
Message-Id: <20230621162333.30027-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230621162024.29310-1-jack@suse.cz>
References: <20230621162024.29310-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4896; i=jack@suse.cz; h=from:subject; bh=wwP7Ac/wRl4ZCJg9yakql11C47nYllFwsaq5HKY0jlg=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBkkyP9GJwmLO8dTgAMwbUR+T6DhQB6JEFdktOeDsJ+ aQ+K3suJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCZJMj/QAKCRCcnaoHP2RA2fS2CA Cl5b/R+QBKCKomW3GLT/b9DHViVr8tavQV7M8a5hvtx8O2SqfNZviWIiSo1cMD2J4B7+8UN18NOrOW U80KR3X7kE3TYj+yC2/F6JIhk7gizmNlaDQxWFBEHkViNS/D3WntFFGJVJ9VTVY5/SivpOBeze4h7G wNds1jzubL2jfdidU6JL2B4vZcv9UBQWnpTuWGpoyq+XKh5cOHZmT/OM6/ypzy5YSB+mvT9XW1XzNJ mGoUPS7W59d5PqfpQKpXbPvN+SH9+FsIl0FoK6stTKGUokoWzAa/HJdH6/1mgtZzSBtZtKJvrznuUp ZgLV7sbOX/evMiLrnCF4xxNXe1SNwA
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
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

