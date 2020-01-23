Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D12B146EFD
	for <lists+linux-bcache@lfdr.de>; Thu, 23 Jan 2020 18:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729652AbgAWRCp (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 23 Jan 2020 12:02:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:51668 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729335AbgAWRCp (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 23 Jan 2020 12:02:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E8DB8AE2A;
        Thu, 23 Jan 2020 17:02:42 +0000 (UTC)
From:   colyli@suse.de
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Coly Li <colyli@suse.de>
Subject: [PATCH 07/17] bcache: return a pointer to the on-disk sb from read_super
Date:   Fri, 24 Jan 2020 01:01:32 +0800
Message-Id: <20200123170142.98974-8-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200123170142.98974-1-colyli@suse.de>
References: <20200123170142.98974-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Returning the properly typed actual data structure insteaf of the
containing struct page will save the callers some work going
forward.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index cf2cafef381f..b30e4c6011d2 100644
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
 	char *path = NULL;
 	struct cache_sb *sb;
+	struct cache_sb_disk *sb_disk;
 	struct block_device *bdev;
-	struct page *sb_page;
 	ssize_t ret;
 
 	ret = -EBUSY;
@@ -2426,7 +2426,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	if (set_blocksize(bdev, 4096))
 		goto out_blkdev_put;
 
-	err = read_super(sb, bdev, &sb_page);
+	err = read_super(sb, bdev, &sb_disk);
 	if (err)
 		goto out_blkdev_put;
 
@@ -2438,7 +2438,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 			goto out_put_sb_page;
 
 		mutex_lock(&bch_register_lock);
-		ret = register_bdev(sb, sb_page, bdev, dc);
+		ret = register_bdev(sb, sb_disk, bdev, dc);
 		mutex_unlock(&bch_register_lock);
 		/* blkdev_put() will be called in cached_dev_free() */
 		if (ret < 0)
@@ -2450,7 +2450,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 			goto out_put_sb_page;
 
 		/* blkdev_put() will be called in bch_cache_release() */
-		if (register_cache(sb, sb_page, bdev, ca) != 0)
+		if (register_cache(sb, sb_disk, bdev, ca) != 0)
 			goto out_free_sb;
 	}
 
@@ -2461,7 +2461,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	return size;
 
 out_put_sb_page:
-	put_page(sb_page);
+	put_page(virt_to_page(sb_disk));
 out_blkdev_put:
 	blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 out_free_sb:
-- 
2.16.4

