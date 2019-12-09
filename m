Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8BE711698C
	for <lists+linux-bcache@lfdr.de>; Mon,  9 Dec 2019 10:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbfLIJiq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 9 Dec 2019 04:38:46 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57890 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727535AbfLIJiq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Dec 2019 04:38:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VjdPr9OrAuY0Ld8Hux4ijcPz0qDx6b6t3wYpglKBgZo=; b=X+V8WHV5Vy7SK5H830D8nxKgyQ
        YQt/txEeGduHSOr1nwcG90oLodAffKcnnhE4LL7+Oo2a2dknXmXZHrNhu+48HdMiIhjZQtwSqLVzd
        YK/lfQ0ien4Kr6UkcTeuBqwER+U5qQxrUHVLGrrr9rPfJG9rPWFAHTkI1eEjs3B/5IfEyezTWx58N
        5WRqy7jHSHAlcy5ljkbpIz8YJfuV01raMXeibyV+IjT5+eXJ2COYvN+4TMDJkpc10Uz8ofJbgOzTW
        ATecTmTVU3jNZhYOa+SRLmX311FW52MSNaCuuCnJqhvCFkpYkcEakThGrs8uVRbRvpPWKDX9GBFUc
        hHrZkJ0g==;
Received: from [2001:4bb8:188:2b00:20e6:8b5a:ed96:f9da] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ieFV7-0002hJ-8p; Mon, 09 Dec 2019 09:38:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     colyli@suse.de
Cc:     kent.overstreet@gmail.com, liangchen.linux@gmail.com,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 5/7] bcache: return a pointer to the on-disk sb from read_super
Date:   Mon,  9 Dec 2019 10:38:27 +0100
Message-Id: <20191209093829.19703-6-hch@lst.de>
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

Returning the properly typed actual data structure insteaf of the
containing struct page will save the callers some work going
forward.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/super.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index c11bc0135ae6..0b7620d9f087 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -60,7 +60,7 @@ struct workqueue_struct *bch_journal_wq;
 /* Superblock */
 
 static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
-			      struct page **res)
+			      struct cache_sb_disk **res)
 {
 	const char *err;
 	struct cache_sb_disk *s;
@@ -191,7 +191,7 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
 	err = NULL;
 
 	get_page(bh->b_page);
-	*res = bh->b_page;
+	*res = s;
 err:
 	put_bh(bh);
 	return err;
@@ -1353,7 +1353,7 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
 
 /* Cached device - bcache superblock */
 
-static int register_bdev(struct cache_sb *sb, struct page *sb_page,
+static int register_bdev(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 				 struct block_device *bdev,
 				 struct cached_dev *dc)
 {
@@ -1367,7 +1367,7 @@ static int register_bdev(struct cache_sb *sb, struct page *sb_page,
 	dc->bdev->bd_holder = dc;
 
 	bio_init(&dc->sb_bio, dc->sb_bio.bi_inline_vecs, 1);
-	bio_first_bvec_all(&dc->sb_bio)->bv_page = sb_page;
+	bio_first_bvec_all(&dc->sb_bio)->bv_page = virt_to_page(sb_disk);
 
 	if (cached_dev_init(dc, sb->block_size << 9))
 		goto err;
@@ -2260,7 +2260,7 @@ static int cache_alloc(struct cache *ca)
 	return ret;
 }
 
-static int register_cache(struct cache_sb *sb, struct page *sb_page,
+static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 				struct block_device *bdev, struct cache *ca)
 {
 	const char *err = NULL; /* must be set for any error case */
@@ -2272,7 +2272,7 @@ static int register_cache(struct cache_sb *sb, struct page *sb_page,
 	ca->bdev->bd_holder = ca;
 
 	bio_init(&ca->sb_bio, ca->sb_bio.bi_inline_vecs, 1);
-	bio_first_bvec_all(&ca->sb_bio)->bv_page = sb_page;
+	bio_first_bvec_all(&ca->sb_bio)->bv_page = virt_to_page(sb_disk);
 
 	if (blk_queue_discard(bdev_get_queue(bdev)))
 		ca->discard = CACHE_DISCARD(&ca->sb);
@@ -2375,8 +2375,8 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	const char *err;
 	char *path;
 	struct cache_sb *sb;
+	struct cache_sb_disk *sb_disk;
 	struct block_device *bdev;
-	struct page *sb_page;
 	ssize_t ret;
 
 	ret = -EBUSY;
@@ -2424,7 +2424,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	if (set_blocksize(bdev, 4096))
 		goto out_blkdev_put;
 
-	err = read_super(sb, bdev, &sb_page);
+	err = read_super(sb, bdev, &sb_disk);
 	if (err)
 		goto out_blkdev_put;
 
@@ -2436,7 +2436,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 			goto out_put_sb_page;
 
 		mutex_lock(&bch_register_lock);
-		ret = register_bdev(sb, sb_page, bdev, dc);
+		ret = register_bdev(sb, sb_disk, bdev, dc);
 		mutex_unlock(&bch_register_lock);
 		/* blkdev_put() will be called in cached_dev_free() */
 		if (ret < 0)
@@ -2448,7 +2448,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 			goto out_put_sb_page;
 
 		/* blkdev_put() will be called in bch_cache_release() */
-		if (register_cache(sb, sb_page, bdev, ca) != 0)
+		if (register_cache(sb, sb_disk, bdev, ca) != 0)
 			goto out_free_sb;
 	}
 
@@ -2459,7 +2459,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	return size;
 
 out_put_sb_page:
-	put_page(sb_page);
+	put_page(virt_to_page(sb_disk));
 out_blkdev_put:
 	blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 out_free_sb:
-- 
2.20.1

