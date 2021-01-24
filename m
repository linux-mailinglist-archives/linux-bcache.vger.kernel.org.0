Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7BA301B19
	for <lists+linux-bcache@lfdr.de>; Sun, 24 Jan 2021 11:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbhAXKHS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 24 Jan 2021 05:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbhAXKGo (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 24 Jan 2021 05:06:44 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8558AC061786;
        Sun, 24 Jan 2021 02:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=fF4LgAuflzfSMa50jca4zVDBd+HGbIj8VQMctaD18uc=; b=BhwQ082TMQWiz+W8M52gH6BEC8
        sfE2G4ff1OWTxmzOtIlmLujHJI/+6FJ54iE4eNYeirGTi+8C3V3piNpLbRDiLBtIcW8MivwB4n/9d
        fyiWqAd/Zo6wFv8AD6IOd+mRcagmYQOqExnbHfxoGyBLIqMGne4W1JB5xszq5ynI2I34LAeWIR6jV
        qMkATDdmFjS8epQvGFumUJo/iVoeeHhhBTF/ZuEKw8xPvq6n3cqYHSjcRlhKOTX6CNn4zL92PHogX
        eaEzCxvfv3NC2FFqSlJhPXgwZ8akSGF+VRsDBuAaKlcD8Zc6pxXWagFyZncX3oU+Pkc4/pLc2sf83
        EHBqnyzg==;
Received: from [2001:4bb8:188:1954:a3b3:627f:702b:2136] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l3cH7-002q9r-Ll; Sun, 24 Jan 2021 10:05:44 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 06/10] block: use ->bi_bdev for bio based I/O accounting
Date:   Sun, 24 Jan 2021 11:02:37 +0100
Message-Id: <20210124100241.1167849-7-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210124100241.1167849-1-hch@lst.de>
References: <20210124100241.1167849-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Rework the I/O accounting for bio based drivers to use ->bi_bdev.  This
means all drivers can now simply use bio_start_io_acct to start
accounting, and it will take partitions into account automatically.  To
end I/O account either bio_end_io_acct can be used if the driver never
remaps I/O to a different device, or bio_end_io_acct_remapped if the
driver did remap the I/O.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c            | 23 +++++++++++++----------
 drivers/md/bcache/request.c | 34 +++++++++++++++++++++-------------
 drivers/md/md.c             |  8 ++++----
 include/linux/blkdev.h      | 21 ++++-----------------
 4 files changed, 42 insertions(+), 44 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1c1b97a82caa2e..9315311c27a913 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1321,14 +1321,17 @@ static unsigned long __part_start_io_acct(struct block_device *part,
 	return now;
 }
 
-unsigned long part_start_io_acct(struct gendisk *disk, struct block_device **part,
-				 struct bio *bio)
+/**
+ * bio_start_io_acct - start I/O accounting for bio based drivers
+ * @bio:	bio to start account for
+ *
+ * Returns the start time that should be passed back to bio_end_io_acct().
+ */
+unsigned long bio_start_io_acct(struct bio *bio)
 {
-	*part = disk_map_sector_rcu(disk, bio->bi_iter.bi_sector);
-
-	return __part_start_io_acct(*part, bio_sectors(bio), bio_op(bio));
+	return __part_start_io_acct(bio->bi_bdev, bio_sectors(bio), bio_op(bio));
 }
-EXPORT_SYMBOL_GPL(part_start_io_acct);
+EXPORT_SYMBOL_GPL(bio_start_io_acct);
 
 unsigned long disk_start_io_acct(struct gendisk *disk, unsigned int sectors,
 				 unsigned int op)
@@ -1351,12 +1354,12 @@ static void __part_end_io_acct(struct block_device *part, unsigned int op,
 	part_stat_unlock();
 }
 
-void part_end_io_acct(struct block_device *part, struct bio *bio,
-		      unsigned long start_time)
+void bio_end_io_acct_remapped(struct bio *bio, unsigned long start_time,
+		struct block_device *orig_bdev)
 {
-	__part_end_io_acct(part, bio_op(bio), start_time);
+	__part_end_io_acct(orig_bdev, bio_op(bio), start_time);
 }
-EXPORT_SYMBOL_GPL(part_end_io_acct);
+EXPORT_SYMBOL_GPL(bio_end_io_acct_remapped);
 
 void disk_end_io_acct(struct gendisk *disk, unsigned int op,
 		      unsigned long start_time)
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index dfc35d6d05ed1c..29c231758293e2 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -475,7 +475,7 @@ struct search {
 	unsigned int		read_dirty_data:1;
 	unsigned int		cache_missed:1;
 
-	struct block_device	*part;
+	struct block_device	*orig_bdev;
 	unsigned long		start_time;
 
 	struct btree_op		op;
@@ -670,8 +670,8 @@ static void bio_complete(struct search *s)
 {
 	if (s->orig_bio) {
 		/* Count on bcache device */
-		part_end_io_acct(s->part, s->orig_bio, s->start_time);
-
+		bio_end_io_acct_remapped(s->orig_bio, s->start_time,
+					 s->orig_bdev);
 		trace_bcache_request_end(s->d, s->orig_bio);
 		s->orig_bio->bi_status = s->iop.status;
 		bio_endio(s->orig_bio);
@@ -714,7 +714,8 @@ static void search_free(struct closure *cl)
 }
 
 static inline struct search *search_alloc(struct bio *bio,
-					  struct bcache_device *d)
+		struct bcache_device *d, struct block_device *orig_bdev,
+		unsigned long start_time)
 {
 	struct search *s;
 
@@ -732,7 +733,8 @@ static inline struct search *search_alloc(struct bio *bio,
 	s->write		= op_is_write(bio_op(bio));
 	s->read_dirty_data	= 0;
 	/* Count on the bcache device */
-	s->start_time		= part_start_io_acct(d->disk, &s->part, bio);
+	s->orig_bdev		= orig_bdev;
+	s->start_time		= start_time;
 	s->iop.c		= d->c;
 	s->iop.bio		= NULL;
 	s->iop.inode		= d->id;
@@ -1074,7 +1076,7 @@ struct detached_dev_io_private {
 	unsigned long		start_time;
 	bio_end_io_t		*bi_end_io;
 	void			*bi_private;
-	struct block_device	*part;
+	struct block_device	*orig_bdev;
 };
 
 static void detached_dev_end_io(struct bio *bio)
@@ -1086,7 +1088,7 @@ static void detached_dev_end_io(struct bio *bio)
 	bio->bi_private = ddip->bi_private;
 
 	/* Count on the bcache device */
-	part_end_io_acct(ddip->part, bio, ddip->start_time);
+	bio_end_io_acct_remapped(bio, ddip->start_time, ddip->orig_bdev);
 
 	if (bio->bi_status) {
 		struct cached_dev *dc = container_of(ddip->d,
@@ -1099,7 +1101,8 @@ static void detached_dev_end_io(struct bio *bio)
 	bio->bi_end_io(bio);
 }
 
-static void detached_dev_do_request(struct bcache_device *d, struct bio *bio)
+static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
+		struct block_device *orig_bdev, unsigned long start_time)
 {
 	struct detached_dev_io_private *ddip;
 	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
@@ -1112,7 +1115,8 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio)
 	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
 	ddip->d = d;
 	/* Count on the bcache device */
-	ddip->start_time = part_start_io_acct(d->disk, &ddip->part, bio);
+	ddip->orig_bdev = orig_bdev;
+	ddip->start_time = start_time;
 	ddip->bi_end_io = bio->bi_end_io;
 	ddip->bi_private = bio->bi_private;
 	bio->bi_end_io = detached_dev_end_io;
@@ -1168,8 +1172,10 @@ static void quit_max_writeback_rate(struct cache_set *c,
 blk_qc_t cached_dev_submit_bio(struct bio *bio)
 {
 	struct search *s;
-	struct bcache_device *d = bio->bi_bdev->bd_disk->private_data;
+	struct block_device *orig_bdev = bio->bi_bdev;
+	struct bcache_device *d = orig_bdev->bd_disk->private_data;
 	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
+	unsigned long start_time;
 	int rw = bio_data_dir(bio);
 
 	if (unlikely((d->c && test_bit(CACHE_SET_IO_DISABLE, &d->c->flags)) ||
@@ -1194,11 +1200,13 @@ blk_qc_t cached_dev_submit_bio(struct bio *bio)
 		}
 	}
 
+	start_time = bio_start_io_acct(bio);
+
 	bio_set_dev(bio, dc->bdev);
 	bio->bi_iter.bi_sector += dc->sb.data_offset;
 
 	if (cached_dev_get(dc)) {
-		s = search_alloc(bio, d);
+		s = search_alloc(bio, d, orig_bdev, start_time);
 		trace_bcache_request_start(s->d, bio);
 
 		if (!bio->bi_iter.bi_size) {
@@ -1219,7 +1227,7 @@ blk_qc_t cached_dev_submit_bio(struct bio *bio)
 		}
 	} else
 		/* I/O request sent to backing device */
-		detached_dev_do_request(d, bio);
+		detached_dev_do_request(d, bio, orig_bdev, start_time);
 
 	return BLK_QC_T_NONE;
 }
@@ -1283,7 +1291,7 @@ blk_qc_t flash_dev_submit_bio(struct bio *bio)
 		return BLK_QC_T_NONE;
 	}
 
-	s = search_alloc(bio, d);
+	s = search_alloc(bio, d, bio->bi_bdev, bio_start_io_acct(bio));
 	cl = &s->cl;
 	bio = &s->bio.bio;
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index ade2b99c51d390..5dd0c5e4c7632b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -463,8 +463,8 @@ struct md_io {
 	struct mddev *mddev;
 	bio_end_io_t *orig_bi_end_io;
 	void *orig_bi_private;
+	struct block_device *orig_bi_bdev;
 	unsigned long start_time;
-	struct block_device *part;
 };
 
 static void md_end_io(struct bio *bio)
@@ -472,7 +472,7 @@ static void md_end_io(struct bio *bio)
 	struct md_io *md_io = bio->bi_private;
 	struct mddev *mddev = md_io->mddev;
 
-	part_end_io_acct(md_io->part, bio, md_io->start_time);
+	bio_end_io_acct_remapped(bio, md_io->start_time, md_io->orig_bi_bdev);
 
 	bio->bi_end_io = md_io->orig_bi_end_io;
 	bio->bi_private = md_io->orig_bi_private;
@@ -514,12 +514,12 @@ static blk_qc_t md_submit_bio(struct bio *bio)
 		md_io->mddev = mddev;
 		md_io->orig_bi_end_io = bio->bi_end_io;
 		md_io->orig_bi_private = bio->bi_private;
+		md_io->orig_bi_bdev = bio->bi_bdev;
 
 		bio->bi_end_io = md_end_io;
 		bio->bi_private = md_io;
 
-		md_io->start_time = part_start_io_acct(mddev->gendisk,
-						       &md_io->part, bio);
+		md_io->start_time = bio_start_io_acct(bio);
 	}
 
 	/* bio could be mergeable after passing to underlayer */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b55bd534b2e1e2..4526b9ef8edbe3 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1954,22 +1954,9 @@ unsigned long disk_start_io_acct(struct gendisk *disk, unsigned int sectors,
 void disk_end_io_acct(struct gendisk *disk, unsigned int op,
 		unsigned long start_time);
 
-unsigned long part_start_io_acct(struct gendisk *disk,
-		struct block_device **part, struct bio *bio);
-void part_end_io_acct(struct block_device *part, struct bio *bio,
-		      unsigned long start_time);
-
-/**
- * bio_start_io_acct - start I/O accounting for bio based drivers
- * @bio:	bio to start account for
- *
- * Returns the start time that should be passed back to bio_end_io_acct().
- */
-static inline unsigned long bio_start_io_acct(struct bio *bio)
-{
-	return disk_start_io_acct(bio->bi_bdev->bd_disk, bio_sectors(bio),
-				  bio_op(bio));
-}
+unsigned long bio_start_io_acct(struct bio *bio);
+void bio_end_io_acct_remapped(struct bio *bio, unsigned long start_time,
+		struct block_device *orig_bdev);
 
 /**
  * bio_end_io_acct - end I/O accounting for bio based drivers
@@ -1978,7 +1965,7 @@ static inline unsigned long bio_start_io_acct(struct bio *bio)
  */
 static inline void bio_end_io_acct(struct bio *bio, unsigned long start_time)
 {
-	return disk_end_io_acct(bio->bi_bdev->bd_disk, bio_op(bio), start_time);
+	return bio_end_io_acct_remapped(bio, start_time, bio->bi_bdev);
 }
 
 int bdev_read_only(struct block_device *bdev);
-- 
2.29.2

