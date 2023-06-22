Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDA773A661
	for <lists+linux-bcache@lfdr.de>; Thu, 22 Jun 2023 18:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjFVQrD (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 22 Jun 2023 12:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbjFVQrC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 22 Jun 2023 12:47:02 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4E1D3;
        Thu, 22 Jun 2023 09:47:00 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id BB93221CBF;
        Thu, 22 Jun 2023 16:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1687452418; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N7F0EKIZlmyobpd43iXvYg9XdRNVHFzLmZDplSjqY9Q=;
        b=GB+5oAAGUFHqwNtdT07w4Hb8C+UFD9q/cjg02zcr1AqJfApNaPtESisrIhU/2bEdkgJces
        y6DRx4spV+4HAzIP5M+4PA/2te2r4uCu2/RV1ivyCkEk5cFCZvUqHTi4Q8Z3cxYXFdSKdi
        B7i/8RZKPmcp1TLbqPMr331f5Ch2vWk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1687452418;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N7F0EKIZlmyobpd43iXvYg9XdRNVHFzLmZDplSjqY9Q=;
        b=aBYobvqRbKRa30J+/N7xTT6dWFGF9IazeEcUOKmvzfMn+jFOfzSTEWnsTGhJd0a3wVMIs5
        f2bQXIyaQjoxQgDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id ABC4B13A76;
        Thu, 22 Jun 2023 16:46:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id zNhwKQJ7lGSJSwAAMHmgww
        (envelope-from <jack@suse.cz>); Thu, 22 Jun 2023 16:46:58 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 2C701A0762; Thu, 22 Jun 2023 18:46:58 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        <linux-block@vger.kernel.org>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH v2 2/2] bcache: Fix bcache device claiming
Date:   Thu, 22 Jun 2023 18:46:55 +0200
Message-Id: <20230622164658.12861-2-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230622164149.17134-1-jack@suse.cz>
References: <20230622164149.17134-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5624; i=jack@suse.cz; h=from:subject; bh=S73/rHQIHtjz3aReLeRjgK308IcQMM4/uuTvBKwbiCg=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBklHr+E+R5bZdD5Nf/x8WlzxepzWvn1D0NT6Cq0fww 1VeohI6JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCZJR6/gAKCRCcnaoHP2RA2Xt+B/ oCduNCwNeMR6jL8FLNxdXI4TTuK4WMVAMwnbjfPds5Kbki9oci6ggFLQN4ptzp0Auet1d83V1xjeWC gmGk+Hb4S3m5XU90ZJqPMQgTwf+tC0OAF41qTliQvOqS/E7I7FPpfXmTn+yZ5eg1KoYgDQwUHKSsuI Xp5pB49SnphPxAchU9bpb/+obZDTGastP50L7j0zdRXsPnXsU2B09AM7QY/yZWQQdV8Eqe2a0tLl+W VgWCrlLbVcwrvqQVGpWGgMiYPO+RRaUCOz+BZ9yQAKbGAkzYfNUUYW6eaeHoZnJDbr2lz4HheVvOSG 6Rc9SwFQcVVoAlSW2ZU3DLZkBJX5oX
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Commit 2736e8eeb0cc ("block: use the holder as indication for exclusive
opens") introduced a change that blkdev_put() has to get exclusive
holder of the bdev as an argument. However it overlooked that
register_bdev() and register_cache() overwrite the bdev->bd_holder field
in the block device to point to the real owning object which was not
available at the time we called blkdev_get_by_path(). Messing with bdev
internals like this is a layering violation and it also causes
blkdev_put() to issue warning about mismatching holders.

Fix bcache to reopen the block device with appropriate holder once it is
available which also restores the behavior that multiple bcache caches
cannot claim the same device which was broken by commit 29499ab060fe
("bcache: don't pass a stack address to blkdev_get_by_path").

Fixes: 2736e8eeb0cc ("block: use the holder as indication for exclusive opens")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/md/bcache/super.c | 65 +++++++++++++++++++++++----------------
 1 file changed, 38 insertions(+), 27 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 913dd94353b6..0ae2b3676293 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1369,7 +1369,7 @@ static void cached_dev_free(struct closure *cl)
 		put_page(virt_to_page(dc->sb_disk));
 
 	if (!IS_ERR_OR_NULL(dc->bdev))
-		blkdev_put(dc->bdev, bcache_kobj);
+		blkdev_put(dc->bdev, dc);
 
 	wake_up(&unregister_wait);
 
@@ -1453,7 +1453,6 @@ static int register_bdev(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 
 	memcpy(&dc->sb, sb, sizeof(struct cache_sb));
 	dc->bdev = bdev;
-	dc->bdev->bd_holder = dc;
 	dc->sb_disk = sb_disk;
 
 	if (cached_dev_init(dc, sb->block_size << 9))
@@ -2218,7 +2217,7 @@ void bch_cache_release(struct kobject *kobj)
 		put_page(virt_to_page(ca->sb_disk));
 
 	if (!IS_ERR_OR_NULL(ca->bdev))
-		blkdev_put(ca->bdev, bcache_kobj);
+		blkdev_put(ca->bdev, ca);
 
 	kfree(ca);
 	module_put(THIS_MODULE);
@@ -2345,7 +2344,6 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 
 	memcpy(&ca->sb, sb, sizeof(struct cache_sb));
 	ca->bdev = bdev;
-	ca->bdev->bd_holder = ca;
 	ca->sb_disk = sb_disk;
 
 	if (bdev_max_discard_sectors((bdev)))
@@ -2359,7 +2357,7 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 		 * call blkdev_put() to bdev in bch_cache_release(). So we
 		 * explicitly call blkdev_put() here.
 		 */
-		blkdev_put(bdev, bcache_kobj);
+		blkdev_put(bdev, ca);
 		if (ret == -ENOMEM)
 			err = "cache_alloc(): -ENOMEM";
 		else if (ret == -EPERM)
@@ -2516,10 +2514,11 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	char *path = NULL;
 	struct cache_sb *sb;
 	struct cache_sb_disk *sb_disk;
-	struct block_device *bdev;
-	void *holder;
+	struct block_device *bdev, *bdev2;
+	void *holder = NULL;
 	ssize_t ret;
 	bool async_registration = false;
+	bool quiet = false;
 
 #ifdef CONFIG_BCACHE_ASYNC_REGISTRATION
 	async_registration = true;
@@ -2548,24 +2547,9 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 
 	ret = -EINVAL;
 	err = "failed to open device";
-	bdev = blkdev_get_by_path(strim(path), BLK_OPEN_READ | BLK_OPEN_WRITE,
-				  bcache_kobj, NULL);
-	if (IS_ERR(bdev)) {
-		if (bdev == ERR_PTR(-EBUSY)) {
-			dev_t dev;
-
-			mutex_lock(&bch_register_lock);
-			if (lookup_bdev(strim(path), &dev) == 0 &&
-			    bch_is_open(dev))
-				err = "device already registered";
-			else
-				err = "device busy";
-			mutex_unlock(&bch_register_lock);
-			if (attr == &ksysfs_register_quiet)
-				goto done;
-		}
+	bdev = blkdev_get_by_path(strim(path), BLK_OPEN_READ, NULL, NULL);
+	if (IS_ERR(bdev))
 		goto out_free_sb;
-	}
 
 	err = "failed to set blocksize";
 	if (set_blocksize(bdev, 4096))
@@ -2582,6 +2566,32 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 		goto out_put_sb_page;
 	}
 
+	/* Now reopen in exclusive mode with proper holder */
+	bdev2 = blkdev_get_by_dev(bdev->bd_dev, BLK_OPEN_READ | BLK_OPEN_WRITE,
+				  holder, NULL);
+	blkdev_put(bdev, NULL);
+	bdev = bdev2;
+	if (IS_ERR(bdev)) {
+		ret = PTR_ERR(bdev);
+		bdev = NULL;
+		if (ret == -EBUSY) {
+			dev_t dev;
+
+			mutex_lock(&bch_register_lock);
+			if (lookup_bdev(strim(path), &dev) == 0 &&
+			    bch_is_open(dev))
+				err = "device already registered";
+			else
+				err = "device busy";
+			mutex_unlock(&bch_register_lock);
+			if (attr == &ksysfs_register_quiet) {
+				quiet = true;
+				ret = size;
+			}
+		}
+		goto out_free_holder;
+	}
+
 	err = "failed to register device";
 
 	if (async_registration) {
@@ -2619,7 +2629,6 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 			goto out_free_sb;
 	}
 
-done:
 	kfree(sb);
 	kfree(path);
 	module_put(THIS_MODULE);
@@ -2631,7 +2640,8 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 out_put_sb_page:
 	put_page(virt_to_page(sb_disk));
 out_blkdev_put:
-	blkdev_put(bdev, register_bcache);
+	if (bdev)
+		blkdev_put(bdev, holder);
 out_free_sb:
 	kfree(sb);
 out_free_path:
@@ -2640,7 +2650,8 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 out_module_put:
 	module_put(THIS_MODULE);
 out:
-	pr_info("error %s: %s\n", path?path:"", err);
+	if (!quiet)
+		pr_info("error %s: %s\n", path?path:"", err);
 	return ret;
 }
 
-- 
2.35.3

