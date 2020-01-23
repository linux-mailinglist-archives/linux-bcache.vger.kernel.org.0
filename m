Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4623146EFB
	for <lists+linux-bcache@lfdr.de>; Thu, 23 Jan 2020 18:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbgAWRCm (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 23 Jan 2020 12:02:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:51634 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729335AbgAWRCm (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 23 Jan 2020 12:02:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7B867AE61;
        Thu, 23 Jan 2020 17:02:40 +0000 (UTC)
From:   colyli@suse.de
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Coly Li <colyli@suse.de>
Subject: [PATCH 06/17] bcache: transfer the sb_page reference to register_{bdev,cache}
Date:   Fri, 24 Jan 2020 01:01:31 +0800
Message-Id: <20200123170142.98974-7-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200123170142.98974-1-colyli@suse.de>
References: <20200123170142.98974-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Avoid an extra reference count roundtrip by transferring the sb_page
ownership to the lower level register helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index fad9c6cbee5e..cf2cafef381f 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1368,8 +1368,6 @@ static int register_bdev(struct cache_sb *sb, struct page *sb_page,
 
 	bio_init(&dc->sb_bio, dc->sb_bio.bi_inline_vecs, 1);
 	bio_first_bvec_all(&dc->sb_bio)->bv_page = sb_page;
-	get_page(sb_page);
-
 
 	if (cached_dev_init(dc, sb->block_size << 9))
 		goto err;
@@ -2275,7 +2273,6 @@ static int register_cache(struct cache_sb *sb, struct page *sb_page,
 
 	bio_init(&ca->sb_bio, ca->sb_bio.bi_inline_vecs, 1);
 	bio_first_bvec_all(&ca->sb_bio)->bv_page = sb_page;
-	get_page(sb_page);
 
 	if (blk_queue_discard(bdev_get_queue(bdev)))
 		ca->discard = CACHE_DISCARD(&ca->sb);
@@ -2378,7 +2375,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	const char *err;
 	char *path = NULL;
 	struct cache_sb *sb;
-	struct block_device *bdev = NULL;
+	struct block_device *bdev;
 	struct page *sb_page;
 	ssize_t ret;
 
@@ -2444,10 +2441,8 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 		ret = register_bdev(sb, sb_page, bdev, dc);
 		mutex_unlock(&bch_register_lock);
 		/* blkdev_put() will be called in cached_dev_free() */
-		if (ret < 0) {
-			bdev = NULL;
-			goto out_put_sb_page;
-		}
+		if (ret < 0)
+			goto out_free_sb;
 	} else {
 		struct cache *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
 
@@ -2455,13 +2450,10 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 			goto out_put_sb_page;
 
 		/* blkdev_put() will be called in bch_cache_release() */
-		if (register_cache(sb, sb_page, bdev, ca) != 0) {
-			bdev = NULL;
-			goto out_put_sb_page;
-		}
+		if (register_cache(sb, sb_page, bdev, ca) != 0)
+			goto out_free_sb;
 	}
 
-	put_page(sb_page);
 done:
 	kfree(sb);
 	kfree(path);
@@ -2471,8 +2463,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 out_put_sb_page:
 	put_page(sb_page);
 out_blkdev_put:
-	if (bdev)
-		blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
+	blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 out_free_sb:
 	kfree(sb);
 out_free_path:
-- 
2.16.4

