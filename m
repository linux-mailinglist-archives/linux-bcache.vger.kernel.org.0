Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67C7511698A
	for <lists+linux-bcache@lfdr.de>; Mon,  9 Dec 2019 10:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbfLIJio (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 9 Dec 2019 04:38:44 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57880 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727535AbfLIJin (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Dec 2019 04:38:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=k5RsMEOMJaFsRNBGR/bElLkw+x3AOqjk9Txrf4p1gxY=; b=lXKWFRmZ5IjR3pzBstgsFnO52R
        uYArPqQsesBRP7YW965Eg0m3VEXdzOf8oPbI6vcAwZrSM7mfCE4aX5LAL72YvI6tdeWP3yUSWj7c5
        URZYD4DMtFJ1uMeynr9Ve3GoDTLrHOGVZ2ethFwho0Sa3YyYLHBMCgOzsBpMzxw5Iq1/JxDaFqZEh
        PxN0SZgfcGHGdYLEi4p1sHKef80ulTsN9BpDq4h0aNg/Flg1KaAY72QdH73W6K+JCHFHGrmje93lm
        fvrrsKahFK29Ut4dx8+xzgxtVTHnyNkcby6gTGMUQ15UK7d45JXExd5iVZyj2ncDF422uNdaOOtPY
        bDw2XvGA==;
Received: from [2001:4bb8:188:2b00:20e6:8b5a:ed96:f9da] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ieFV4-0002gt-Lk; Mon, 09 Dec 2019 09:38:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     colyli@suse.de
Cc:     kent.overstreet@gmail.com, liangchen.linux@gmail.com,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 4/7] bcache: transfer the sb_page reference to register_{bdev,cache}
Date:   Mon,  9 Dec 2019 10:38:26 +0100
Message-Id: <20191209093829.19703-5-hch@lst.de>
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

Avoid an extra reference count roundtrip by transferring the sb_page
ownership to the lower level register helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/super.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index e8013e1b0a14..c11bc0135ae6 100644
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
 	char *path;
 	struct cache_sb *sb;
-	struct block_device *bdev = NULL;
+	struct block_device *bdev;
 	struct page *sb_page;
 	ssize_t ret;
 
@@ -2442,10 +2439,8 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
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
 
@@ -2453,13 +2448,10 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
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
@@ -2469,8 +2461,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
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
2.20.1

