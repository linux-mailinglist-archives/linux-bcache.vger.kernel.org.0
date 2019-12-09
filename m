Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC7F9116988
	for <lists+linux-bcache@lfdr.de>; Mon,  9 Dec 2019 10:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbfLIJil (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 9 Dec 2019 04:38:41 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57870 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727160AbfLIJil (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Dec 2019 04:38:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=D/780rQVU69TfporsGchYf6GlKn19xD5+Y2QNaWjyg4=; b=sF7YgK5x2wWW9gDz6nmR8pCZvh
        7DAdyXWwkIWrkI6jg4hpnmkIw07w+DJpHwTVKon9aX/fItsqBgm1kdLCdohVOkzMLIK/Nex5SN8RW
        +laz2dlcXQ34nd9zN6savS7UBbsDAMDUqUxnkxITmMiUt2GY9OBeyYS+clrOIYlLyDoW/gXiQQhAt
        x5kmH76ERwEZd9eF1ps64qXafO2mZfcjDVIt0J6IhgsNu3yGgdo/tUmnrUCohjbJCJrTWCGASDP0k
        fEbqdGNvcv+xQafNViLQej2qbVLzntNOJpxwKJ0EoZElTHv+/SL0Y5yR1OznIGRBH2XYKBpiOmqsA
        2CmVMXBw==;
Received: from [2001:4bb8:188:2b00:20e6:8b5a:ed96:f9da] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ieFV2-0002gW-4J; Mon, 09 Dec 2019 09:38:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     colyli@suse.de
Cc:     kent.overstreet@gmail.com, liangchen.linux@gmail.com,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 3/7] bcache: rework error unwinding in register_bcache
Date:   Mon,  9 Dec 2019 10:38:25 +0100
Message-Id: <20191209093829.19703-4-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191209093829.19703-1-hch@lst.de>
References: <20191209093829.19703-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Split the successful and error return path, and use one goto label for each
resource to unwind.  This also fixes some small errors like leaking the
module reference count in the reboot case (which seems entirely harmless)
or printing the wrong warning messages for early failures.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/super.c | 75 +++++++++++++++++++++++----------------
 1 file changed, 45 insertions(+), 30 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 3045f27e0d67..e8013e1b0a14 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2375,29 +2375,33 @@ static bool bch_is_open(struct block_device *bdev)
 static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 			       const char *buffer, size_t size)
 {
-	ssize_t ret = -EINVAL;
-	const char *err = "cannot allocate memory";
-	char *path = NULL;
-	struct cache_sb *sb = NULL;
+	const char *err;
+	char *path;
+	struct cache_sb *sb;
 	struct block_device *bdev = NULL;
-	struct page *sb_page = NULL;
+	struct page *sb_page;
+	ssize_t ret;
 
+	ret = -EBUSY;
 	if (!try_module_get(THIS_MODULE))
-		return -EBUSY;
+		goto out;
 
 	/* For latest state of bcache_is_reboot */
 	smp_mb();
 	if (bcache_is_reboot)
-		return -EBUSY;
+		goto out_module_put;
 
+	ret = -ENOMEM;
+	err = "cannot allocate memory";
 	path = kstrndup(buffer, size, GFP_KERNEL);
 	if (!path)
-		goto err;
+		goto out_module_put;
 
 	sb = kmalloc(sizeof(struct cache_sb), GFP_KERNEL);
 	if (!sb)
-		goto err;
+		goto out_free_path;
 
+	ret = -EINVAL;
 	err = "failed to open device";
 	bdev = blkdev_get_by_path(strim(path),
 				  FMODE_READ|FMODE_WRITE|FMODE_EXCL,
@@ -2414,57 +2418,68 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 			if (!IS_ERR(bdev))
 				bdput(bdev);
 			if (attr == &ksysfs_register_quiet)
-				goto quiet_out;
+				goto done;
 		}
-		goto err;
+		goto out_free_sb;
 	}
 
 	err = "failed to set blocksize";
 	if (set_blocksize(bdev, 4096))
-		goto err_close;
+		goto out_blkdev_put;
 
 	err = read_super(sb, bdev, &sb_page);
 	if (err)
-		goto err_close;
+		goto out_blkdev_put;
 
 	err = "failed to register device";
 	if (SB_IS_BDEV(sb)) {
 		struct cached_dev *dc = kzalloc(sizeof(*dc), GFP_KERNEL);
 
 		if (!dc)
-			goto err_close;
+			goto out_put_sb_page;
 
 		mutex_lock(&bch_register_lock);
 		ret = register_bdev(sb, sb_page, bdev, dc);
 		mutex_unlock(&bch_register_lock);
 		/* blkdev_put() will be called in cached_dev_free() */
-		if (ret < 0)
-			goto err;
+		if (ret < 0) {
+			bdev = NULL;
+			goto out_put_sb_page;
+		}
 	} else {
 		struct cache *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
 
 		if (!ca)
-			goto err_close;
+			goto out_put_sb_page;
 
 		/* blkdev_put() will be called in bch_cache_release() */
-		if (register_cache(sb, sb_page, bdev, ca) != 0)
-			goto err;
+		if (register_cache(sb, sb_page, bdev, ca) != 0) {
+			bdev = NULL;
+			goto out_put_sb_page;
+		}
 	}
-quiet_out:
-	ret = size;
-out:
-	if (sb_page)
-		put_page(sb_page);
+
+	put_page(sb_page);
+done:
 	kfree(sb);
 	kfree(path);
 	module_put(THIS_MODULE);
-	return ret;
-
-err_close:
-	blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
-err:
+	return size;
+
+out_put_sb_page:
+	put_page(sb_page);
+out_blkdev_put:
+	if (bdev)
+		blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
+out_free_sb:
+	kfree(sb);
+out_free_path:
+	kfree(path);
+out_module_put:
+	module_put(THIS_MODULE);
+out:
 	pr_info("error %s: %s", path, err);
-	goto out;
+	return ret;
 }
 
 
-- 
2.20.1

