Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C0C301B1E
	for <lists+linux-bcache@lfdr.de>; Sun, 24 Jan 2021 11:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbhAXKH1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 24 Jan 2021 05:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbhAXKGu (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 24 Jan 2021 05:06:50 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7CEC061788;
        Sun, 24 Jan 2021 02:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=R07IFtQfXacVQDxk19nqMxD6tPMi0nElxJ2fP9Ofuvw=; b=Ik1rCDi+2s2e018DnBY7Z/ZV+q
        HY9WjXtx9i9LXYFhnx72KLCj4EbexL5AbTowqA2ji7H+nrgv5DplR2RacGnl/zAYLxIFxID2mHbjg
        ftuy8i6dVtqZrsTW8pGOzCZ+wPc+hTzH7SBbxfdGTnGjk1SB1Nf5bTAW0AIhEaoIlrflE7Zbn+yRD
        s4h9k0Bdzmns2Qjd9Obo8pwq3mawhTS+o1sn0ugPKSYoiUg+6+ziU5Xk5r1RrDpHWW0dylu5Ty4v0
        jWYgslYxV+hQUEicAZusc9gSRcJSGwG2CGf1UDPdTe4aZ7WbHstwSskxsPNl/JCH1Y+09x1JCK32Y
        9a9vLsnA==;
Received: from [2001:4bb8:188:1954:a3b3:627f:702b:2136] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l3cHD-002qA0-TP; Sun, 24 Jan 2021 10:05:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 07/10] blk-mq: use ->bi_bdev for I/O accounting
Date:   Sun, 24 Jan 2021 11:02:38 +0100
Message-Id: <20210124100241.1167849-8-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210124100241.1167849-1-hch@lst.de>
References: <20210124100241.1167849-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Remove the reverse map from a sector to a partition for I/O accounting by
simply using ->bi_bdev.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c |  6 +++++-
 block/blk.h      |  2 --
 block/genhd.c    | 48 ------------------------------------------------
 3 files changed, 5 insertions(+), 51 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 9315311c27a913..6dfbdde6b9ff84 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1298,7 +1298,11 @@ void blk_account_io_start(struct request *rq)
 	if (!blk_do_io_stat(rq))
 		return;
 
-	rq->part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
+	/* passthrough requests can hold bios that do not have ->bi_bdev set */
+	if (rq->bio && rq->bio->bi_bdev)
+		rq->part = rq->bio->bi_bdev;
+	else
+		rq->part = rq->rq_disk->part0;
 
 	part_stat_lock();
 	update_io_ticks(rq->part, jiffies, false);
diff --git a/block/blk.h b/block/blk.h
index 10ab7c0d0766f0..d965cacc5bdaa1 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -333,8 +333,6 @@ void blk_queue_free_zone_bitmaps(struct request_queue *q);
 static inline void blk_queue_free_zone_bitmaps(struct request_queue *q) {}
 #endif
 
-struct block_device *disk_map_sector_rcu(struct gendisk *disk, sector_t sector);
-
 int blk_alloc_devt(struct block_device *part, dev_t *devt);
 void blk_free_devt(dev_t devt);
 char *disk_name(struct gendisk *hd, int partno, char *buf);
diff --git a/block/genhd.c b/block/genhd.c
index e536d0b4bbae34..e46de616a19e59 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -285,54 +285,6 @@ void disk_part_iter_exit(struct disk_part_iter *piter)
 }
 EXPORT_SYMBOL_GPL(disk_part_iter_exit);
 
-static inline int sector_in_part(struct block_device *part, sector_t sector)
-{
-	return part->bd_start_sect <= sector &&
-		sector < part->bd_start_sect + bdev_nr_sectors(part);
-}
-
-/**
- * disk_map_sector_rcu - map sector to partition
- * @disk: gendisk of interest
- * @sector: sector to map
- *
- * Find out which partition @sector maps to on @disk.  This is
- * primarily used for stats accounting.
- *
- * CONTEXT:
- * RCU read locked.
- *
- * RETURNS:
- * Found partition on success, part0 is returned if no partition matches
- * or the matched partition is being deleted.
- */
-struct block_device *disk_map_sector_rcu(struct gendisk *disk, sector_t sector)
-{
-	struct disk_part_tbl *ptbl;
-	struct block_device *part;
-	int i;
-
-	rcu_read_lock();
-	ptbl = rcu_dereference(disk->part_tbl);
-
-	part = rcu_dereference(ptbl->last_lookup);
-	if (part && sector_in_part(part, sector))
-		goto out_unlock;
-
-	for (i = 1; i < ptbl->len; i++) {
-		part = rcu_dereference(ptbl->part[i]);
-		if (part && sector_in_part(part, sector)) {
-			rcu_assign_pointer(ptbl->last_lookup, part);
-			goto out_unlock;
-		}
-	}
-
-	part = disk->part0;
-out_unlock:
-	rcu_read_unlock();
-	return part;
-}
-
 /**
  * disk_has_partitions
  * @disk: gendisk of interest
-- 
2.29.2

