Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC3F11D129
	for <lists+linux-bcache@lfdr.de>; Thu, 12 Dec 2019 16:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729352AbfLLPgU (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 12 Dec 2019 10:36:20 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:50040 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729347AbfLLPgU (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 12 Dec 2019 10:36:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=k5RsMEOMJaFsRNBGR/bElLkw+x3AOqjk9Txrf4p1gxY=; b=bGpqOf31Eoxlehjn+aTfwzcN4u
        92/ADFxm79QvnAtApagws2AZMjsqTDluYxAU/sD8yIwFRZ8xD2RlLuEgu2ABAv9M5aZmZ6zssrspg
        ZsOKdlwZ95N/Tg4M8kQHDoY0nY+6cxNzPwUT+llcf6JQ23c1pLivE+qLvJ8sP0kaPFVZe01P8iJA0
        JL1tKZpxqLdHEpdr8DmjFMWTg9BJo0jnRst3uAnYfKz6zeElrc9gvA/Ug6OkYhD0ReB3Y5sug/HXL
        X4OKyxU9+yoaNa1vkKY9S7yMyop+u9jIiq26qG5i2YycdWovXwGjrans5ecfB+4Pvt8gc86ptmcpc
        jY/jGdbw==;
Received: from [2001:4bb8:188:2b00:20e6:8b5a:ed96:f9da] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ifQVl-0007Jl-KZ; Thu, 12 Dec 2019 15:36:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     colyli@suse.de
Cc:     kent.overstreet@gmail.com, liangchen.linux@gmail.com,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 4/7] bcache: transfer the sb_page reference to register_{bdev,cache}
Date:   Thu, 12 Dec 2019 16:36:01 +0100
Message-Id: <20191212153604.19540-5-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191212153604.19540-1-hch@lst.de>
References: <20191212153604.19540-1-hch@lst.de>
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

