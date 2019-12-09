Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85CF611698E
	for <lists+linux-bcache@lfdr.de>; Mon,  9 Dec 2019 10:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbfLIJit (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 9 Dec 2019 04:38:49 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57906 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727160AbfLIJis (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Dec 2019 04:38:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IZxug+0KrtZa2OFd6Z6MxBFUSPcGj4RHumNLw1e2ciQ=; b=Mup2qQgbSPkutpq7C/wUKLkRdf
        WP019VlOmm7vtWIoDXgFsM2onWX913RHyq788DmRNJomDF39OVBgN8XxoCJtuIzy02bGuokLaakQH
        si39rNad4rAp+VzQaXOWnnKXDeK+ye639Xbj4SQAWwS/IWIe+Ac1ZFEWHIl2BU/2emKEq83IQJpVn
        eUkmGvEx/QkWcFb699O9Mge3ns5vam9ajKhhbDgqXiljDJ5Ral8vdQx2/TLD2japZHOIF1XOoqs9t
        YeFLC6nNtnIR7BqyeW8FNytOR7KnBgUeQM1vlDbSvmHNqE2HNX3xTQh58ZP0H+r5syD8XENScu7/s
        O6sAp1Ww==;
Received: from [2001:4bb8:188:2b00:20e6:8b5a:ed96:f9da] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ieFV9-0002hf-Qv; Mon, 09 Dec 2019 09:38:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     colyli@suse.de
Cc:     kent.overstreet@gmail.com, liangchen.linux@gmail.com,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 6/7] bcache: store a pointer to the on-disk sb in the cache and cached_dev structures
Date:   Mon,  9 Dec 2019 10:38:28 +0100
Message-Id: <20191209093829.19703-7-hch@lst.de>
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

This allows to properly build the superblock bio including the offset in the
page using the normal bio helpers.  This fixes writing the superblock for
page sizes larger than 4k where the sb write bio would need an offset in the
bio_vec.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/bcache.h |  2 ++
 drivers/md/bcache/super.c  | 32 +++++++++++++-------------------
 2 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 9198c1b480d9..adf26a21fcd1 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -301,6 +301,7 @@ struct cached_dev {
 	struct block_device	*bdev;
 
 	struct cache_sb		sb;
+	struct cache_sb_disk	*sb_disk;
 	struct bio		sb_bio;
 	struct bio_vec		sb_bv[1];
 	struct closure		sb_write;
@@ -403,6 +404,7 @@ enum alloc_reserve {
 struct cache {
 	struct cache_set	*set;
 	struct cache_sb		sb;
+	struct cache_sb_disk	*sb_disk;
 	struct bio		sb_bio;
 	struct bio_vec		sb_bv[1];
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 0b7620d9f087..df41d103fa34 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -207,15 +207,15 @@ static void write_bdev_super_endio(struct bio *bio)
 	closure_put(&dc->sb_write);
 }
 
-static void __write_super(struct cache_sb *sb, struct bio *bio)
+static void __write_super(struct cache_sb *sb, struct cache_sb_disk *out,
+		struct bio *bio)
 {
-	struct cache_sb_disk *out = page_address(bio_first_page_all(bio));
 	unsigned int i;
 
+	bio->bi_opf = REQ_OP_WRITE | REQ_SYNC | REQ_META;
 	bio->bi_iter.bi_sector	= SB_SECTOR;
-	bio->bi_iter.bi_size	= SB_SIZE;
-	bio_set_op_attrs(bio, REQ_OP_WRITE, REQ_SYNC|REQ_META);
-	bch_bio_map(bio, NULL);
+	__bio_add_page(bio, virt_to_page(out), SB_SIZE,
+			offset_in_page(out));
 
 	out->offset		= cpu_to_le64(sb->offset);
 	out->version		= cpu_to_le64(sb->version);
@@ -257,14 +257,14 @@ void bch_write_bdev_super(struct cached_dev *dc, struct closure *parent)
 	down(&dc->sb_write_mutex);
 	closure_init(cl, parent);
 
-	bio_reset(bio);
+	bio_init(bio, dc->sb_bv, 1);
 	bio_set_dev(bio, dc->bdev);
 	bio->bi_end_io	= write_bdev_super_endio;
 	bio->bi_private = dc;
 
 	closure_get(cl);
 	/* I/O request sent to backing device */
-	__write_super(&dc->sb, bio);
+	__write_super(&dc->sb, dc->sb_disk, bio);
 
 	closure_return_with_destructor(cl, bch_write_bdev_super_unlock);
 }
@@ -306,13 +306,13 @@ void bcache_write_super(struct cache_set *c)
 
 		SET_CACHE_SYNC(&ca->sb, CACHE_SYNC(&c->sb));
 
-		bio_reset(bio);
+		bio_init(bio, ca->sb_bv, 1);
 		bio_set_dev(bio, ca->bdev);
 		bio->bi_end_io	= write_super_endio;
 		bio->bi_private = ca;
 
 		closure_get(cl);
-		__write_super(&ca->sb, bio);
+		__write_super(&ca->sb, ca->sb_disk, bio);
 	}
 
 	closure_return_with_destructor(cl, bcache_write_super_unlock);
@@ -1275,8 +1275,8 @@ static void cached_dev_free(struct closure *cl)
 
 	mutex_unlock(&bch_register_lock);
 
-	if (dc->sb_bio.bi_inline_vecs[0].bv_page)
-		put_page(bio_first_page_all(&dc->sb_bio));
+	if (dc->sb_disk)
+		put_page(virt_to_page(dc->sb_disk));
 
 	if (!IS_ERR_OR_NULL(dc->bdev))
 		blkdev_put(dc->bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
@@ -1366,9 +1366,6 @@ static int register_bdev(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 	dc->bdev = bdev;
 	dc->bdev->bd_holder = dc;
 
-	bio_init(&dc->sb_bio, dc->sb_bio.bi_inline_vecs, 1);
-	bio_first_bvec_all(&dc->sb_bio)->bv_page = virt_to_page(sb_disk);
-
 	if (cached_dev_init(dc, sb->block_size << 9))
 		goto err;
 
@@ -2137,8 +2134,8 @@ void bch_cache_release(struct kobject *kobj)
 	for (i = 0; i < RESERVE_NR; i++)
 		free_fifo(&ca->free[i]);
 
-	if (ca->sb_bio.bi_inline_vecs[0].bv_page)
-		put_page(bio_first_page_all(&ca->sb_bio));
+	if (ca->sb_disk)
+		put_page(virt_to_page(ca->sb_disk));
 
 	if (!IS_ERR_OR_NULL(ca->bdev))
 		blkdev_put(ca->bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
@@ -2271,9 +2268,6 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 	ca->bdev = bdev;
 	ca->bdev->bd_holder = ca;
 
-	bio_init(&ca->sb_bio, ca->sb_bio.bi_inline_vecs, 1);
-	bio_first_bvec_all(&ca->sb_bio)->bv_page = virt_to_page(sb_disk);
-
 	if (blk_queue_discard(bdev_get_queue(bdev)))
 		ca->discard = CACHE_DISCARD(&ca->sb);
 
-- 
2.20.1

