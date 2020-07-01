Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1933210705
	for <lists+linux-bcache@lfdr.de>; Wed,  1 Jul 2020 11:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbgGAJA0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 1 Jul 2020 05:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729257AbgGAJAX (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Jul 2020 05:00:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259CCC03E97E;
        Wed,  1 Jul 2020 02:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=jQY+NtFCO+7CU3/nFb1b4IXvqab2qyR+s502t/FTrN0=; b=uk7IalP7MNGMM6uU4dAQlW8WyT
        wAAF3+qlfzX6YNhcR3wK+W1kCSwSAAIh+p6a51QmR/WkvI5iNXX6RT/rUdJ1Xa1ZGQGj78s7Yqvqv
        apKuRzsOW0hTYSSpzgapI7XjWd8J5KsEfQ3xUFfoxf0IJVlsoz/OdGiccYlHINoaSVCTGbcgukSEb
        eDReKFk2IXHSvZ0m2RrUUS0NHvjl0G8Haam0Ucf3tnKRRxbqUGybDQOBJMKimJ9oSqmYsG3MeDOsT
        +mgRZL3+n+xb4vpMz97ijSIURtS2Bit7lRbBO0vSx/zQv2yJuSSYpUXX7qRfYpSCkzrXWbLSNMus7
        gE2BAOEw==;
Received: from [2001:4bb8:184:76e3:ea38:596b:3e9e:422a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqYbL-0008II-NY; Wed, 01 Jul 2020 09:00:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
        drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org
Subject: [PATCH 20/20] block: remove direct_make_request
Date:   Wed,  1 Jul 2020 10:59:47 +0200
Message-Id: <20200701085947.3354405-21-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701085947.3354405-1-hch@lst.de>
References: <20200701085947.3354405-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Now that submit_bio_noacct has a decent blk-mq fast path there is no
more need for this bypass.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c              | 28 ----------------------------
 drivers/md/dm.c               |  5 +----
 drivers/nvme/host/multipath.c |  2 +-
 include/linux/blkdev.h        |  1 -
 4 files changed, 2 insertions(+), 34 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2ff166f0d24ee3..bf882b8d84450c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1211,34 +1211,6 @@ blk_qc_t submit_bio_noacct(struct bio *bio)
 }
 EXPORT_SYMBOL(submit_bio_noacct);
 
-/**
- * direct_make_request - hand a buffer directly to its device driver for I/O
- * @bio:  The bio describing the location in memory and on the device.
- *
- * This function behaves like submit_bio_noacct(), but does not protect
- * against recursion.  Must only be used if the called driver is known
- * to be blk-mq based.
- */
-blk_qc_t direct_make_request(struct bio *bio)
-{
-	struct gendisk *disk = bio->bi_disk;
-
-	if (WARN_ON_ONCE(!disk->queue->mq_ops)) {
-		bio_io_error(bio);
-		return BLK_QC_T_NONE;
-	}
-	if (!submit_bio_checks(bio))
-		return BLK_QC_T_NONE;
-	if (unlikely(bio_queue_enter(bio)))
-		return BLK_QC_T_NONE;
-	if (!blk_crypto_bio_prep(&bio)) {
-		blk_queue_exit(disk->queue);
-		return BLK_QC_T_NONE;
-	}
-	return blk_mq_submit_bio(bio);
-}
-EXPORT_SYMBOL_GPL(direct_make_request);
-
 /**
  * submit_bio - submit a bio to the block device layer for I/O
  * @bio: The &struct bio which describes the I/O
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b32b539dbace56..2cb33896198c4c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1302,10 +1302,7 @@ static blk_qc_t __map_bio(struct dm_target_io *tio)
 		/* the bio has been remapped so dispatch it */
 		trace_block_bio_remap(clone->bi_disk->queue, clone,
 				      bio_dev(io->orig_bio), sector);
-		if (md->type == DM_TYPE_NVME_BIO_BASED)
-			ret = direct_make_request(clone);
-		else
-			ret = submit_bio_noacct(clone);
+		ret = submit_bio_noacct(clone);
 		break;
 	case DM_MAPIO_KILL:
 		free_tio(tio);
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index f07fa47c251d9d..a986ac52c4cc7f 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -314,7 +314,7 @@ blk_qc_t nvme_ns_head_submit_bio(struct bio *bio)
 		trace_block_bio_remap(bio->bi_disk->queue, bio,
 				      disk_devt(ns->head->disk),
 				      bio->bi_iter.bi_sector);
-		ret = direct_make_request(bio);
+		ret = submit_bio_noacct(bio);
 	} else if (nvme_available_path(head)) {
 		dev_warn_ratelimited(dev, "no usable path - requeuing I/O\n");
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b73cfa6a5141df..1cc913ffdbe21e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -853,7 +853,6 @@ static inline void rq_flush_dcache_pages(struct request *rq)
 extern int blk_register_queue(struct gendisk *disk);
 extern void blk_unregister_queue(struct gendisk *disk);
 blk_qc_t submit_bio_noacct(struct bio *bio);
-extern blk_qc_t direct_make_request(struct bio *bio);
 extern void blk_rq_init(struct request_queue *q, struct request *rq);
 extern void blk_put_request(struct request *);
 extern struct request *blk_get_request(struct request_queue *, unsigned int op,
-- 
2.26.2

