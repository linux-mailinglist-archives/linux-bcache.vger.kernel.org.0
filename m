Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50E72CA8F5
	for <lists+linux-bcache@lfdr.de>; Tue,  1 Dec 2020 17:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392153AbgLAQzh (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 1 Dec 2020 11:55:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390685AbgLAQzg (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 1 Dec 2020 11:55:36 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFDCC061A04;
        Tue,  1 Dec 2020 08:54:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=f7RaRem2seQyQ1o9ZlBUoXDlUClxMQOxOmsqc5+NUjg=; b=cVd0Tg2IMroP2f1mDuMwMcxp3o
        +rT0YT0aXrjRV0NO/L2OIu0py6Mro1Z+0viiNxWKsDns7m72OQOhK1nZ7e8uNfdxqujBKKPb7nGNU
        0+8xoUDwOis3JKDmu9lp+0TYX8ZVzHfgrISzYgnYriqikPcwdQ1qpeVhAp+WdroKW83evkg1WRYVr
        t4HJ8nyzg9TraCMHCOOH54r1fOTTOCFOlvpx8uiCQC4pvOxQc0mV3o7QRqnHphjSp4IbmHceeuBrM
        aPInAjkn8xTvK1IFeDFGjDHbqC07ukls/xkEviH+KYi/r70qvH7p3mquPqVkk51krOTKuGHO1dUOw
        Oxw2z7yw==;
Received: from [2001:4bb8:184:6389:bbd8:a1c2:99e0:f58a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kk8v7-0005Z9-OS; Tue, 01 Dec 2020 16:54:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 3/9] block: store a block_device pointer in struct bio
Date:   Tue,  1 Dec 2020 17:54:18 +0100
Message-Id: <20201201165424.2030647-4-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201165424.2030647-1-hch@lst.de>
References: <20201201165424.2030647-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Replace the gendisk pointer in struct bio with a pointer to the newly
improved struct block device.  From that the gendisk can be trivially
accessed with an extra indirection, but it also allows to directly
look up all information related to partition remapping.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/m68k/emu/nfblock.c             |  2 +-
 arch/xtensa/platforms/iss/simdisk.c |  2 +-
 block/bio-integrity.c               | 18 +++++++--------
 block/bio.c                         | 31 +++++++++----------------
 block/blk-cgroup.c                  |  7 +++---
 block/blk-core.c                    | 36 +++++++++++++----------------
 block/blk-crypto-fallback.c         |  2 +-
 block/blk-crypto.c                  |  2 +-
 block/blk-merge.c                   | 17 +++++++-------
 block/blk-mq.c                      |  2 +-
 block/blk-throttle.c                |  2 +-
 block/blk.h                         |  6 ++---
 block/bounce.c                      |  2 +-
 block/genhd.c                       |  2 +-
 drivers/block/brd.c                 |  2 +-
 drivers/block/drbd/drbd_int.h       |  4 ++--
 drivers/block/drbd/drbd_req.c       |  2 +-
 drivers/block/null_blk_main.c       |  2 +-
 drivers/block/pktcdvd.c             |  4 ++--
 drivers/block/ps3vram.c             |  2 +-
 drivers/block/rsxx/dev.c            |  2 +-
 drivers/block/umem.c                |  2 +-
 drivers/block/zram/zram_drv.c       |  2 +-
 drivers/lightnvm/pblk-init.c        |  2 +-
 drivers/md/bcache/debug.c           |  2 +-
 drivers/md/bcache/request.c         |  7 +++---
 drivers/md/dm-bio-record.h          |  9 +++-----
 drivers/md/dm-raid1.c               | 10 ++++----
 drivers/md/dm.c                     | 14 +++++------
 drivers/md/md-linear.c              |  2 +-
 drivers/md/md.c                     |  2 +-
 drivers/md/md.h                     |  6 ++---
 drivers/md/raid1.c                  |  6 ++---
 drivers/md/raid10.c                 | 12 +++++-----
 drivers/md/raid5.c                  |  2 +-
 drivers/nvdimm/blk.c                |  4 ++--
 drivers/nvdimm/btt.c                |  4 ++--
 drivers/nvdimm/pmem.c               |  4 ++--
 drivers/nvme/host/core.c            |  6 ++---
 drivers/nvme/host/lightnvm.c        |  3 +--
 drivers/nvme/host/multipath.c       |  6 ++---
 drivers/nvme/host/rdma.c            |  2 +-
 drivers/s390/block/dcssblk.c        |  2 +-
 drivers/s390/block/xpram.c          |  2 +-
 fs/btrfs/check-integrity.c          | 10 ++++----
 fs/btrfs/raid56.c                   |  7 ++----
 fs/btrfs/scrub.c                    |  2 +-
 fs/direct-io.c                      |  2 +-
 fs/f2fs/data.c                      | 12 +---------
 include/linux/bio.h                 | 18 +++++++--------
 include/linux/blk_types.h           |  3 +--
 include/linux/blkdev.h              |  5 ++--
 kernel/trace/blktrace.c             | 16 +++++++------
 mm/page_io.c                        |  2 +-
 54 files changed, 153 insertions(+), 184 deletions(-)

diff --git a/arch/m68k/emu/nfblock.c b/arch/m68k/emu/nfblock.c
index 92d26c81244134..ba808543161a02 100644
--- a/arch/m68k/emu/nfblock.c
+++ b/arch/m68k/emu/nfblock.c
@@ -61,7 +61,7 @@ struct nfhd_device {
 
 static blk_qc_t nfhd_submit_bio(struct bio *bio)
 {
-	struct nfhd_device *dev = bio->bi_disk->private_data;
+	struct nfhd_device *dev = bio->bi_bdev->bd_disk->private_data;
 	struct bio_vec bvec;
 	struct bvec_iter iter;
 	int dir, len, shift;
diff --git a/arch/xtensa/platforms/iss/simdisk.c b/arch/xtensa/platforms/iss/simdisk.c
index 3447556d276d32..fc09be7b13479c 100644
--- a/arch/xtensa/platforms/iss/simdisk.c
+++ b/arch/xtensa/platforms/iss/simdisk.c
@@ -103,7 +103,7 @@ static void simdisk_transfer(struct simdisk *dev, unsigned long sector,
 
 static blk_qc_t simdisk_submit_bio(struct bio *bio)
 {
-	struct simdisk *dev = bio->bi_disk->private_data;
+	struct simdisk *dev = bio->bi_bdev->bd_disk->private_data;
 	struct bio_vec bvec;
 	struct bvec_iter iter;
 	sector_t sector = bio->bi_iter.bi_sector;
diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 9ffd7e28955476..c3e5abcfdc98c3 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -140,7 +140,7 @@ int bio_integrity_add_page(struct bio *bio, struct page *page,
 	iv = bip->bip_vec + bip->bip_vcnt;
 
 	if (bip->bip_vcnt &&
-	    bvec_gap_to_prev(bio->bi_disk->queue,
+	    bvec_gap_to_prev(bio->bi_bdev->bd_disk->queue,
 			     &bip->bip_vec[bip->bip_vcnt - 1], offset))
 		return 0;
 
@@ -162,7 +162,7 @@ EXPORT_SYMBOL(bio_integrity_add_page);
 static blk_status_t bio_integrity_process(struct bio *bio,
 		struct bvec_iter *proc_iter, integrity_processing_fn *proc_fn)
 {
-	struct blk_integrity *bi = blk_get_integrity(bio->bi_disk);
+	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
 	struct blk_integrity_iter iter;
 	struct bvec_iter bviter;
 	struct bio_vec bv;
@@ -171,7 +171,7 @@ static blk_status_t bio_integrity_process(struct bio *bio,
 	void *prot_buf = page_address(bip->bip_vec->bv_page) +
 		bip->bip_vec->bv_offset;
 
-	iter.disk_name = bio->bi_disk->disk_name;
+	iter.disk_name = bio->bi_bdev->bd_disk->disk_name;
 	iter.interval = 1 << bi->interval_exp;
 	iter.seed = proc_iter->bi_sector;
 	iter.prot_buf = prot_buf;
@@ -208,8 +208,8 @@ static blk_status_t bio_integrity_process(struct bio *bio,
 bool bio_integrity_prep(struct bio *bio)
 {
 	struct bio_integrity_payload *bip;
-	struct blk_integrity *bi = blk_get_integrity(bio->bi_disk);
-	struct request_queue *q = bio->bi_disk->queue;
+	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
+	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
 	void *buf;
 	unsigned long start, end;
 	unsigned int len, nr_pages;
@@ -329,7 +329,7 @@ static void bio_integrity_verify_fn(struct work_struct *work)
 	struct bio_integrity_payload *bip =
 		container_of(work, struct bio_integrity_payload, bip_work);
 	struct bio *bio = bip->bip_bio;
-	struct blk_integrity *bi = blk_get_integrity(bio->bi_disk);
+	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
 
 	/*
 	 * At the moment verify is called bio's iterator was advanced
@@ -355,7 +355,7 @@ static void bio_integrity_verify_fn(struct work_struct *work)
  */
 bool __bio_integrity_endio(struct bio *bio)
 {
-	struct blk_integrity *bi = blk_get_integrity(bio->bi_disk);
+	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
 	struct bio_integrity_payload *bip = bio_integrity(bio);
 
 	if (bio_op(bio) == REQ_OP_READ && !bio->bi_status &&
@@ -381,7 +381,7 @@ bool __bio_integrity_endio(struct bio *bio)
 void bio_integrity_advance(struct bio *bio, unsigned int bytes_done)
 {
 	struct bio_integrity_payload *bip = bio_integrity(bio);
-	struct blk_integrity *bi = blk_get_integrity(bio->bi_disk);
+	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
 	unsigned bytes = bio_integrity_bytes(bi, bytes_done >> 9);
 
 	bip->bip_iter.bi_sector += bytes_done >> 9;
@@ -397,7 +397,7 @@ void bio_integrity_advance(struct bio *bio, unsigned int bytes_done)
 void bio_integrity_trim(struct bio *bio)
 {
 	struct bio_integrity_payload *bip = bio_integrity(bio);
-	struct blk_integrity *bi = blk_get_integrity(bio->bi_disk);
+	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
 
 	bip->bip_iter.bi_size = bio_integrity_bytes(bi, bio_sectors(bio));
 }
diff --git a/block/bio.c b/block/bio.c
index ebb18136b86f2f..a58afe4a50dc7a 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -607,16 +607,7 @@ void bio_truncate(struct bio *bio, unsigned new_size)
  */
 void guard_bio_eod(struct bio *bio)
 {
-	sector_t maxsector;
-	struct block_device *part;
-
-	rcu_read_lock();
-	part = __disk_get_part(bio->bi_disk, bio->bi_partno);
-	if (part)
-		maxsector = bdev_nr_sectors(part);
-	else	
-		maxsector = get_capacity(bio->bi_disk);
-	rcu_read_unlock();
+	sector_t maxsector = bdev_nr_sectors(bio->bi_bdev);
 
 	if (!maxsector)
 		return;
@@ -676,11 +667,10 @@ void __bio_clone_fast(struct bio *bio, struct bio *bio_src)
 	BUG_ON(bio->bi_pool && BVEC_POOL_IDX(bio));
 
 	/*
-	 * most users will be overriding ->bi_disk with a new target,
+	 * most users will be overriding ->bi_bdev with a new target,
 	 * so we don't set nor calculate new physical/hw segment counts here
 	 */
-	bio->bi_disk = bio_src->bi_disk;
-	bio->bi_partno = bio_src->bi_partno;
+	bio->bi_bdev = bio_src->bi_bdev;
 	bio_set_flag(bio, BIO_CLONED);
 	if (bio_flagged(bio_src, BIO_THROTTLED))
 		bio_set_flag(bio, BIO_THROTTLED);
@@ -730,7 +720,7 @@ EXPORT_SYMBOL(bio_clone_fast);
 
 const char *bio_devname(struct bio *bio, char *buf)
 {
-	return disk_name(bio->bi_disk, bio->bi_partno, buf);
+	return bdevname(bio->bi_bdev, buf);
 }
 EXPORT_SYMBOL(bio_devname);
 
@@ -1037,7 +1027,7 @@ static int __bio_iov_append_get_pages(struct bio *bio, struct iov_iter *iter)
 {
 	unsigned short nr_pages = bio->bi_max_vecs - bio->bi_vcnt;
 	unsigned short entries_left = bio->bi_max_vecs - bio->bi_vcnt;
-	struct request_queue *q = bio->bi_disk->queue;
+	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
 	unsigned int max_append_sectors = queue_max_zone_append_sectors(q);
 	struct bio_vec *bv = bio->bi_io_vec + bio->bi_vcnt;
 	struct page **pages = (struct page **)bv;
@@ -1145,7 +1135,8 @@ static void submit_bio_wait_endio(struct bio *bio)
  */
 int submit_bio_wait(struct bio *bio)
 {
-	DECLARE_COMPLETION_ONSTACK_MAP(done, bio->bi_disk->lockdep_map);
+	DECLARE_COMPLETION_ONSTACK_MAP(done,
+			bio->bi_bdev->bd_disk->lockdep_map);
 	unsigned long hang_check;
 
 	bio->bi_private = &done;
@@ -1422,8 +1413,8 @@ void bio_endio(struct bio *bio)
 	if (!bio_integrity_endio(bio))
 		return;
 
-	if (bio->bi_disk)
-		rq_qos_done_bio(bio->bi_disk->queue, bio);
+	if (bio->bi_bdev)
+		rq_qos_done_bio(bio->bi_bdev->bd_disk->queue, bio);
 
 	/*
 	 * Need to have a real endio function for chained bios, otherwise
@@ -1438,8 +1429,8 @@ void bio_endio(struct bio *bio)
 		goto again;
 	}
 
-	if (bio->bi_disk && bio_flagged(bio, BIO_TRACE_COMPLETION)) {
-		trace_block_bio_complete(bio->bi_disk->queue, bio);
+	if (bio->bi_bdev && bio_flagged(bio, BIO_TRACE_COMPLETION)) {
+		trace_block_bio_complete(bio->bi_bdev->bd_disk->queue, bio);
 		bio_clear_flag(bio, BIO_TRACE_COMPLETION);
 	}
 
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 031114d454a604..3465d6ee708edf 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1800,7 +1800,8 @@ static inline struct blkcg_gq *blkg_tryget_closest(struct bio *bio,
 	struct blkcg_gq *blkg, *ret_blkg = NULL;
 
 	rcu_read_lock();
-	blkg = blkg_lookup_create(css_to_blkcg(css), bio->bi_disk->queue);
+	blkg = blkg_lookup_create(css_to_blkcg(css),
+				  bio->bi_bdev->bd_disk->queue);
 	while (blkg) {
 		if (blkg_tryget(blkg)) {
 			ret_blkg = blkg;
@@ -1836,8 +1837,8 @@ void bio_associate_blkg_from_css(struct bio *bio,
 	if (css && css->parent) {
 		bio->bi_blkg = blkg_tryget_closest(bio, css);
 	} else {
-		blkg_get(bio->bi_disk->queue->root_blkg);
-		bio->bi_blkg = bio->bi_disk->queue->root_blkg;
+		blkg_get(bio->bi_bdev->bd_disk->queue->root_blkg);
+		bio->bi_blkg = bio->bi_bdev->bd_disk->queue->root_blkg;
 	}
 }
 EXPORT_SYMBOL_GPL(bio_associate_blkg_from_css);
diff --git a/block/blk-core.c b/block/blk-core.c
index 96e5fcd7f071b6..95005a8db5ab2f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -475,7 +475,7 @@ int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 
 static inline int bio_queue_enter(struct bio *bio)
 {
-	struct request_queue *q = bio->bi_disk->queue;
+	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
 	bool nowait = bio->bi_opf & REQ_NOWAIT;
 	int ret;
 
@@ -713,7 +713,7 @@ static inline bool bio_check_ro(struct bio *bio, struct block_device *part)
 
 static noinline int should_fail_bio(struct bio *bio)
 {
-	if (should_fail_request(bio->bi_disk->part0, bio->bi_iter.bi_size))
+	if (should_fail_request(bdev_whole(bio->bi_bdev), bio->bi_iter.bi_size))
 		return -EIO;
 	return 0;
 }
@@ -742,13 +742,9 @@ static inline int bio_check_eod(struct bio *bio, sector_t maxsector)
  */
 static inline int blk_partition_remap(struct bio *bio)
 {
-	struct block_device *p;
+	struct block_device *p = bio->bi_bdev;
 	int ret = -EIO;
 
-	rcu_read_lock();
-	p = __disk_get_part(bio->bi_disk, bio->bi_partno);
-	if (unlikely(!p))
-		goto out;
 	if (unlikely(should_fail_request(p, bio->bi_iter.bi_size)))
 		goto out;
 	if (unlikely(bio_check_ro(bio, p)))
@@ -762,10 +758,8 @@ static inline int blk_partition_remap(struct bio *bio)
 				      bio->bi_iter.bi_sector -
 				      p->bd_start_sect);
 	}
-	bio->bi_partno = 0;
 	ret = 0;
 out:
-	rcu_read_unlock();
 	return ret;
 }
 
@@ -806,7 +800,8 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
 
 static noinline_for_stack bool submit_bio_checks(struct bio *bio)
 {
-	struct request_queue *q = bio->bi_disk->queue;
+	struct block_device *bdev = bio->bi_bdev;
+	struct request_queue *q = bdev->bd_disk->queue;
 	blk_status_t status = BLK_STS_IOERR;
 	struct blk_plug *plug;
 
@@ -826,13 +821,13 @@ static noinline_for_stack bool submit_bio_checks(struct bio *bio)
 	if (should_fail_bio(bio))
 		goto end_io;
 
-	if (bio->bi_partno) {
+	if (bio->bi_bdev->bd_partno) {
 		if (unlikely(blk_partition_remap(bio)))
 			goto end_io;
 	} else {
-		if (unlikely(bio_check_ro(bio, bio->bi_disk->part0)))
+		if (unlikely(bio_check_ro(bio, bdev_whole(bdev))))
 			goto end_io;
-		if (unlikely(bio_check_eod(bio, get_capacity(bio->bi_disk))))
+		if (unlikely(bio_check_eod(bio, get_capacity(bdev->bd_disk))))
 			goto end_io;
 	}
 
@@ -925,7 +920,7 @@ static noinline_for_stack bool submit_bio_checks(struct bio *bio)
 
 static blk_qc_t __submit_bio(struct bio *bio)
 {
-	struct gendisk *disk = bio->bi_disk;
+	struct gendisk *disk = bio->bi_bdev->bd_disk;
 	blk_qc_t ret = BLK_QC_T_NONE;
 
 	if (blk_crypto_bio_prep(&bio)) {
@@ -967,7 +962,7 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
 	current->bio_list = bio_list_on_stack;
 
 	do {
-		struct request_queue *q = bio->bi_disk->queue;
+		struct request_queue *q = bio->bi_bdev->bd_disk->queue;
 		struct bio_list lower, same;
 
 		if (unlikely(bio_queue_enter(bio) != 0))
@@ -988,7 +983,7 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
 		bio_list_init(&lower);
 		bio_list_init(&same);
 		while ((bio = bio_list_pop(&bio_list_on_stack[0])) != NULL)
-			if (q == bio->bi_disk->queue)
+			if (q == bio->bi_bdev->bd_disk->queue)
 				bio_list_add(&same, bio);
 			else
 				bio_list_add(&lower, bio);
@@ -1013,7 +1008,7 @@ static blk_qc_t __submit_bio_noacct_mq(struct bio *bio)
 	current->bio_list = bio_list;
 
 	do {
-		struct gendisk *disk = bio->bi_disk;
+		struct gendisk *disk = bio->bi_bdev->bd_disk;
 
 		if (unlikely(bio_queue_enter(bio) != 0))
 			continue;
@@ -1056,7 +1051,7 @@ blk_qc_t submit_bio_noacct(struct bio *bio)
 		return BLK_QC_T_NONE;
 	}
 
-	if (!bio->bi_disk->fops->submit_bio)
+	if (!bio->bi_bdev->bd_disk->fops->submit_bio)
 		return __submit_bio_noacct_mq(bio);
 	return __submit_bio_noacct(bio);
 }
@@ -1068,7 +1063,7 @@ EXPORT_SYMBOL(submit_bio_noacct);
  *
  * submit_bio() is used to submit I/O requests to block devices.  It is passed a
  * fully set up &struct bio that describes the I/O that needs to be done.  The
- * bio will be send to the device described by the bi_disk and bi_partno fields.
+ * bio will be send to the device described by the bi_bdev field.
  *
  * The success/failure status of the request, along with notification of
  * completion, is delivered asynchronously through the ->bi_end_io() callback
@@ -1088,7 +1083,8 @@ blk_qc_t submit_bio(struct bio *bio)
 		unsigned int count;
 
 		if (unlikely(bio_op(bio) == REQ_OP_WRITE_SAME))
-			count = queue_logical_block_size(bio->bi_disk->queue) >> 9;
+			count = queue_logical_block_size(
+					bio->bi_bdev->bd_disk->queue) >> 9;
 		else
 			count = bio_sectors(bio);
 
diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index c162b754efbd6a..8f1e1817673115 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -167,7 +167,7 @@ static struct bio *blk_crypto_clone_bio(struct bio *bio_src)
 	bio = bio_alloc_bioset(GFP_NOIO, bio_segments(bio_src), NULL);
 	if (!bio)
 		return NULL;
-	bio->bi_disk		= bio_src->bi_disk;
+	bio->bi_bdev		= bio_src->bi_bdev;
 	bio->bi_opf		= bio_src->bi_opf;
 	bio->bi_ioprio		= bio_src->bi_ioprio;
 	bio->bi_write_hint	= bio_src->bi_write_hint;
diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 5da43f0973b46b..09fcb18fa778fa 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -280,7 +280,7 @@ bool __blk_crypto_bio_prep(struct bio **bio_ptr)
 	 * Success if device supports the encryption context, or if we succeeded
 	 * in falling back to the crypto API.
 	 */
-	if (blk_ksm_crypto_cfg_supported(bio->bi_disk->queue->ksm,
+	if (blk_ksm_crypto_cfg_supported(bio->bi_bdev->bd_disk->queue->ksm,
 					 &bc_key->crypto_cfg))
 		return true;
 
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 7497d86fff3834..30707a4acd1f9b 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -290,14 +290,13 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
  * Split a bio into two bios, chain the two bios, submit the second half and
  * store a pointer to the first half in *@bio. If the second bio is still too
  * big it will be split by a recursive call to this function. Since this
- * function may allocate a new bio from @bio->bi_disk->queue->bio_split, it is
- * the responsibility of the caller to ensure that
- * @bio->bi_disk->queue->bio_split is only released after processing of the
- * split bio has finished.
+ * function may allocate a new bio from q->bio_split, it is the responsibility
+ * of the caller to ensure that q->bio_split is only released after processing
+ * of the split bio has finished.
  */
 void __blk_queue_split(struct bio **bio, unsigned int *nr_segs)
 {
-	struct request_queue *q = (*bio)->bi_disk->queue;
+	struct request_queue *q = (*bio)->bi_bdev->bd_disk->queue;
 	struct bio *split = NULL;
 
 	switch (bio_op(*bio)) {
@@ -350,9 +349,9 @@ void __blk_queue_split(struct bio **bio, unsigned int *nr_segs)
  *
  * Split a bio into two bios, chains the two bios, submit the second half and
  * store a pointer to the first half in *@bio. Since this function may allocate
- * a new bio from @bio->bi_disk->queue->bio_split, it is the responsibility of
- * the caller to ensure that @bio->bi_disk->queue->bio_split is only released
- * after processing of the split bio has finished.
+ * a new bio from q->bio_split, it is the responsibility of the caller to ensure
+ * that q->bio_split is only released after processing of the split bio has
+ * finished.
  */
 void blk_queue_split(struct bio **bio)
 {
@@ -858,7 +857,7 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 		return false;
 
 	/* must be same device */
-	if (rq->rq_disk != bio->bi_disk)
+	if (rq->rq_disk != bio->bi_bdev->bd_disk)
 		return false;
 
 	/* only merge integrity protected bio into ditto rq */
diff --git a/block/blk-mq.c b/block/blk-mq.c
index bb669b415a387e..e9e5c0487d2813 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2146,7 +2146,7 @@ static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
  */
 blk_qc_t blk_mq_submit_bio(struct bio *bio)
 {
-	struct request_queue *q = bio->bi_disk->queue;
+	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
 	const int is_sync = op_is_sync(bio->bi_opf);
 	const int is_flush_fua = op_is_flush(bio->bi_opf);
 	struct blk_mq_alloc_data data = {
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index b771c42999827c..73589f8e187ebd 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2172,7 +2172,7 @@ static inline void throtl_update_latency_buckets(struct throtl_data *td)
 
 bool blk_throtl_bio(struct bio *bio)
 {
-	struct request_queue *q = bio->bi_disk->queue;
+	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
 	struct blkcg_gq *blkg = bio->bi_blkg;
 	struct throtl_qnode *qn = NULL;
 	struct throtl_grp *tg = blkg_to_tg(blkg);
diff --git a/block/blk.h b/block/blk.h
index 98f0b1ae264120..64dc8e5a3f44cb 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -99,8 +99,8 @@ static inline void blk_rq_bio_prep(struct request *rq, struct bio *bio,
 	rq->bio = rq->biotail = bio;
 	rq->ioprio = bio_prio(bio);
 
-	if (bio->bi_disk)
-		rq->rq_disk = bio->bi_disk;
+	if (bio->bi_bdev)
+		rq->rq_disk = bio->bi_bdev->bd_disk;
 }
 
 #ifdef CONFIG_BLK_DEV_INTEGRITY
@@ -215,8 +215,6 @@ static inline void elevator_exit(struct request_queue *q,
 	__elevator_exit(q, e);
 }
 
-struct block_device *__disk_get_part(struct gendisk *disk, int partno);
-
 ssize_t part_size_show(struct device *dev, struct device_attribute *attr,
 		char *buf);
 ssize_t part_stat_show(struct device *dev, struct device_attribute *attr,
diff --git a/block/bounce.c b/block/bounce.c
index d3f51acd6e3b51..a22a8a1942b24f 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -246,7 +246,7 @@ static struct bio *bounce_clone_bio(struct bio *bio_src, gfp_t gfp_mask,
 	bio = bio_alloc_bioset(gfp_mask, bio_segments(bio_src), bs);
 	if (!bio)
 		return NULL;
-	bio->bi_disk		= bio_src->bi_disk;
+	bio->bi_bdev		= bio_src->bi_bdev;
 	bio->bi_opf		= bio_src->bi_opf;
 	bio->bi_ioprio		= bio_src->bi_ioprio;
 	bio->bi_write_hint	= bio_src->bi_write_hint;
diff --git a/block/genhd.c b/block/genhd.c
index b84b8671e6270a..57c709a9f90267 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -159,7 +159,7 @@ static void part_in_flight_rw(struct block_device *part,
 		inflight[1] = 0;
 }
 
-struct block_device *__disk_get_part(struct gendisk *disk, int partno)
+static struct block_device *__disk_get_part(struct gendisk *disk, int partno)
 {
 	struct disk_part_tbl *ptbl = rcu_dereference(disk->part_tbl);
 
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index c7c8214190795c..18bf9990666207 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -284,7 +284,7 @@ static int brd_do_bvec(struct brd_device *brd, struct page *page,
 
 static blk_qc_t brd_submit_bio(struct bio *bio)
 {
-	struct brd_device *brd = bio->bi_disk->private_data;
+	struct brd_device *brd = bio->bi_bdev->bd_disk->private_data;
 	sector_t sector = bio->bi_iter.bi_sector;
 	struct bio_vec bvec;
 	struct bvec_iter iter;
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 8f879e5c2f6706..b2c93a29c251fd 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1579,8 +1579,8 @@ static inline void drbd_submit_bio_noacct(struct drbd_device *device,
 					     int fault_type, struct bio *bio)
 {
 	__release(local);
-	if (!bio->bi_disk) {
-		drbd_err(device, "drbd_submit_bio_noacct: bio->bi_disk == NULL\n");
+	if (!bio->bi_bdev) {
+		drbd_err(device, "drbd_submit_bio_noacct: bio->bi_bdev == NULL\n");
 		bio->bi_status = BLK_STS_IOERR;
 		bio_endio(bio);
 		return;
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 330f851cb8f0b0..ea0f31ab334361 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1595,7 +1595,7 @@ void do_submit(struct work_struct *ws)
 
 blk_qc_t drbd_submit_bio(struct bio *bio)
 {
-	struct drbd_device *device = bio->bi_disk->private_data;
+	struct drbd_device *device = bio->bi_bdev->bd_disk->private_data;
 	unsigned long start_jif;
 
 	blk_queue_split(&bio);
diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index 4685ea401d5b12..783a9629e2944e 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -1418,7 +1418,7 @@ static blk_qc_t null_submit_bio(struct bio *bio)
 {
 	sector_t sector = bio->bi_iter.bi_sector;
 	sector_t nr_sectors = bio_sectors(bio);
-	struct nullb *nullb = bio->bi_disk->private_data;
+	struct nullb *nullb = bio->bi_bdev->bd_disk->private_data;
 	struct nullb_queue *nq = nullb_to_queue(nullb);
 	struct nullb_cmd *cmd;
 
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index b8bb8ec7538d9b..658a0981cb5471 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2374,7 +2374,7 @@ static blk_qc_t pkt_submit_bio(struct bio *bio)
 
 	blk_queue_split(&bio);
 
-	pd = bio->bi_disk->queue->queuedata;
+	pd = bio->bi_bdev->bd_disk->queue->queuedata;
 	if (!pd) {
 		pr_err("%s incorrect request queue\n", bio_devname(bio, b));
 		goto end_io;
@@ -2418,7 +2418,7 @@ static blk_qc_t pkt_submit_bio(struct bio *bio)
 			split = bio;
 		}
 
-		pkt_make_request_write(bio->bi_disk->queue, split);
+		pkt_make_request_write(bio->bi_bdev->bd_disk->queue, split);
 	} while (split != bio);
 
 	return BLK_QC_T_NONE;
diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index 1088798c8dd0c9..511403cc6317a1 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -581,7 +581,7 @@ static struct bio *ps3vram_do_bio(struct ps3_system_bus_device *dev,
 
 static blk_qc_t ps3vram_submit_bio(struct bio *bio)
 {
-	struct ps3_system_bus_device *dev = bio->bi_disk->private_data;
+	struct ps3_system_bus_device *dev = bio->bi_bdev->bd_disk->private_data;
 	struct ps3vram_priv *priv = ps3_system_bus_get_drvdata(dev);
 	int busy;
 
diff --git a/drivers/block/rsxx/dev.c b/drivers/block/rsxx/dev.c
index edacefff6e355b..9a28322a8cd893 100644
--- a/drivers/block/rsxx/dev.c
+++ b/drivers/block/rsxx/dev.c
@@ -122,7 +122,7 @@ static void bio_dma_done_cb(struct rsxx_cardinfo *card,
 
 static blk_qc_t rsxx_submit_bio(struct bio *bio)
 {
-	struct rsxx_cardinfo *card = bio->bi_disk->private_data;
+	struct rsxx_cardinfo *card = bio->bi_bdev->bd_disk->private_data;
 	struct rsxx_bio_meta *bio_meta;
 	blk_status_t st = BLK_STS_IOERR;
 
diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index 2b95d7b33b9186..982732dbe82e69 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -521,7 +521,7 @@ static int mm_check_plugged(struct cardinfo *card)
 
 static blk_qc_t mm_submit_bio(struct bio *bio)
 {
-	struct cardinfo *card = bio->bi_disk->private_data;
+	struct cardinfo *card = bio->bi_bdev->bd_disk->private_data;
 
 	pr_debug("mm_make_request %llu %u\n",
 		 (unsigned long long)bio->bi_iter.bi_sector,
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index b0701bae6e9800..f2807fd98e703c 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1581,7 +1581,7 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
  */
 static blk_qc_t zram_submit_bio(struct bio *bio)
 {
-	struct zram *zram = bio->bi_disk->private_data;
+	struct zram *zram = bio->bi_bdev->bd_disk->private_data;
 
 	if (!valid_io_request(zram, bio->bi_iter.bi_sector,
 					bio->bi_iter.bi_size)) {
diff --git a/drivers/lightnvm/pblk-init.c b/drivers/lightnvm/pblk-init.c
index b6246f73895cf8..5924f09c217b62 100644
--- a/drivers/lightnvm/pblk-init.c
+++ b/drivers/lightnvm/pblk-init.c
@@ -49,7 +49,7 @@ struct bio_set pblk_bio_set;
 
 static blk_qc_t pblk_submit_bio(struct bio *bio)
 {
-	struct pblk *pblk = bio->bi_disk->queue->queuedata;
+	struct pblk *pblk = bio->bi_bdev->bd_disk->queue->queuedata;
 
 	if (bio_op(bio) == REQ_OP_DISCARD) {
 		pblk_discard(pblk, bio);
diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index b00fd08d696b5f..058dd80144281e 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -114,7 +114,7 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
 	check = bio_kmalloc(GFP_NOIO, bio_segments(bio));
 	if (!check)
 		return;
-	check->bi_disk = bio->bi_disk;
+	check->bi_bdev = bio->bi_bdev;
 	check->bi_opf = REQ_OP_READ;
 	check->bi_iter.bi_sector = bio->bi_iter.bi_sector;
 	check->bi_iter.bi_size = bio->bi_iter.bi_size;
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 85b1f2a9b72d68..dfc35d6d05ed1c 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -894,7 +894,8 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
 	    !(bio->bi_opf & (REQ_META|REQ_PRIO)) &&
 	    s->iop.c->gc_stats.in_use < CUTOFF_CACHE_READA)
 		reada = min_t(sector_t, dc->readahead >> 9,
-			      get_capacity(bio->bi_disk) - bio_end_sector(bio));
+			      get_capacity(bio->bi_bdev->bd_disk) -
+			      bio_end_sector(bio));
 
 	s->insert_bio_sectors = min(sectors, bio_sectors(bio) + reada);
 
@@ -1167,7 +1168,7 @@ static void quit_max_writeback_rate(struct cache_set *c,
 blk_qc_t cached_dev_submit_bio(struct bio *bio)
 {
 	struct search *s;
-	struct bcache_device *d = bio->bi_disk->private_data;
+	struct bcache_device *d = bio->bi_bdev->bd_disk->private_data;
 	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
 	int rw = bio_data_dir(bio);
 
@@ -1274,7 +1275,7 @@ blk_qc_t flash_dev_submit_bio(struct bio *bio)
 {
 	struct search *s;
 	struct closure *cl;
-	struct bcache_device *d = bio->bi_disk->private_data;
+	struct bcache_device *d = bio->bi_bdev->bd_disk->private_data;
 
 	if (unlikely(d->c && test_bit(CACHE_SET_IO_DISABLE, &d->c->flags))) {
 		bio->bi_status = BLK_STS_IOERR;
diff --git a/drivers/md/dm-bio-record.h b/drivers/md/dm-bio-record.h
index 2ea0360108e1d4..a3b71350eec84e 100644
--- a/drivers/md/dm-bio-record.h
+++ b/drivers/md/dm-bio-record.h
@@ -18,8 +18,7 @@
  */
 
 struct dm_bio_details {
-	struct gendisk *bi_disk;
-	u8 bi_partno;
+	struct block_device *bi_bdev;
 	int __bi_remaining;
 	unsigned long bi_flags;
 	struct bvec_iter bi_iter;
@@ -31,8 +30,7 @@ struct dm_bio_details {
 
 static inline void dm_bio_record(struct dm_bio_details *bd, struct bio *bio)
 {
-	bd->bi_disk = bio->bi_disk;
-	bd->bi_partno = bio->bi_partno;
+	bd->bi_bdev = bio->bi_bdev;
 	bd->bi_flags = bio->bi_flags;
 	bd->bi_iter = bio->bi_iter;
 	bd->__bi_remaining = atomic_read(&bio->__bi_remaining);
@@ -44,8 +42,7 @@ static inline void dm_bio_record(struct dm_bio_details *bd, struct bio *bio)
 
 static inline void dm_bio_restore(struct dm_bio_details *bd, struct bio *bio)
 {
-	bio->bi_disk = bd->bi_disk;
-	bio->bi_partno = bd->bi_partno;
+	bio->bi_bdev = bd->bi_bdev;
 	bio->bi_flags = bd->bi_flags;
 	bio->bi_iter = bd->bi_iter;
 	atomic_set(&bio->__bi_remaining, bd->__bi_remaining);
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index fa09bc4e4c54a1..b0a82f29a2e451 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -145,7 +145,7 @@ static void dispatch_bios(void *context, struct bio_list *bio_list)
 
 struct dm_raid1_bio_record {
 	struct mirror *m;
-	/* if details->bi_disk == NULL, details were not saved */
+	/* if details->bi_bdev == NULL, details were not saved */
 	struct dm_bio_details details;
 	region_t write_region;
 };
@@ -1190,7 +1190,7 @@ static int mirror_map(struct dm_target *ti, struct bio *bio)
 	struct dm_raid1_bio_record *bio_record =
 	  dm_per_bio_data(bio, sizeof(struct dm_raid1_bio_record));
 
-	bio_record->details.bi_disk = NULL;
+	bio_record->details.bi_bdev = NULL;
 
 	if (rw == WRITE) {
 		/* Save region for mirror_end_io() handler */
@@ -1257,7 +1257,7 @@ static int mirror_end_io(struct dm_target *ti, struct bio *bio,
 		goto out;
 
 	if (unlikely(*error)) {
-		if (!bio_record->details.bi_disk) {
+		if (!bio_record->details.bi_bdev) {
 			/*
 			 * There wasn't enough memory to record necessary
 			 * information for a retry or there was no other
@@ -1282,7 +1282,7 @@ static int mirror_end_io(struct dm_target *ti, struct bio *bio,
 			bd = &bio_record->details;
 
 			dm_bio_restore(bd, bio);
-			bio_record->details.bi_disk = NULL;
+			bio_record->details.bi_bdev = NULL;
 			bio->bi_status = 0;
 
 			queue_bio(ms, bio, rw);
@@ -1292,7 +1292,7 @@ static int mirror_end_io(struct dm_target *ti, struct bio *bio,
 	}
 
 out:
-	bio_record->details.bi_disk = NULL;
+	bio_record->details.bi_bdev = NULL;
 
 	return DM_ENDIO_DONE;
 }
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 5181907dc59537..1c8a8c3c1aca0e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -977,16 +977,17 @@ static void clone_endio(struct bio *bio)
 	struct mapped_device *md = tio->io->md;
 	dm_endio_fn endio = tio->ti->type->end_io;
 	struct bio *orig_bio = io->orig_bio;
+	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
 
 	if (unlikely(error == BLK_STS_TARGET)) {
 		if (bio_op(bio) == REQ_OP_DISCARD &&
-		    !bio->bi_disk->queue->limits.max_discard_sectors)
+		    !q->limits.max_discard_sectors)
 			disable_discard(md);
 		else if (bio_op(bio) == REQ_OP_WRITE_SAME &&
-			 !bio->bi_disk->queue->limits.max_write_same_sectors)
+			 !q->limits.max_write_same_sectors)
 			disable_write_same(md);
 		else if (bio_op(bio) == REQ_OP_WRITE_ZEROES &&
-			 !bio->bi_disk->queue->limits.max_write_zeroes_sectors)
+			 !q->limits.max_write_zeroes_sectors)
 			disable_write_zeroes(md);
 	}
 
@@ -996,7 +997,7 @@ static void clone_endio(struct bio *bio)
 	 */
 	if (bio_op(orig_bio) == REQ_OP_ZONE_APPEND) {
 		sector_t written_sector = bio->bi_iter.bi_sector;
-		struct request_queue *q = orig_bio->bi_disk->queue;
+		struct request_queue *q = orig_bio->bi_bdev->bd_disk->queue;
 		u64 mask = (u64)blk_queue_zone_sectors(q) - 1;
 
 		orig_bio->bi_iter.bi_sector += written_sector & mask;
@@ -1421,8 +1422,7 @@ static int __send_empty_flush(struct clone_info *ci)
 	 */
 	bio_init(&flush_bio, NULL, 0);
 	flush_bio.bi_opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC;
-	flush_bio.bi_disk = ci->io->md->disk;
-	bio_associate_blkg(&flush_bio);
+	bio_set_dev(&flush_bio, ci->io->md->disk->part0);
 
 	ci->bio = &flush_bio;
 	ci->sector_count = 0;
@@ -1625,7 +1625,7 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
 
 static blk_qc_t dm_submit_bio(struct bio *bio)
 {
-	struct mapped_device *md = bio->bi_disk->private_data;
+	struct mapped_device *md = bio->bi_bdev->bd_disk->private_data;
 	blk_qc_t ret = BLK_QC_T_NONE;
 	int srcu_idx;
 	struct dm_table *map;
diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 68cac7d1927823..63ed8329a98d01 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -252,7 +252,7 @@ static bool linear_make_request(struct mddev *mddev, struct bio *bio)
 		start_sector + data_offset;
 
 	if (unlikely((bio_op(bio) == REQ_OP_DISCARD) &&
-		     !blk_queue_discard(bio->bi_disk->queue))) {
+		     !blk_queue_discard(bio->bi_bdev->bd_disk->queue))) {
 		/* Just ignore it */
 		bio_endio(bio);
 	} else {
diff --git a/drivers/md/md.c b/drivers/md/md.c
index c555be0a8dce78..3e72fc24f80f57 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -486,7 +486,7 @@ static void md_end_io(struct bio *bio)
 static blk_qc_t md_submit_bio(struct bio *bio)
 {
 	const int rw = bio_data_dir(bio);
-	struct mddev *mddev = bio->bi_disk->private_data;
+	struct mddev *mddev = bio->bi_bdev->bd_disk->private_data;
 
 	if (mddev == NULL || mddev->pers == NULL) {
 		bio_io_error(bio);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ccfb69868c2ec9..b6939df0754d25 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -556,7 +556,7 @@ static inline void md_sync_acct(struct block_device *bdev, unsigned long nr_sect
 
 static inline void md_sync_acct_bio(struct bio *bio, unsigned long nr_sectors)
 {
-	atomic_add(nr_sectors, &bio->bi_disk->sync_io);
+	md_sync_acct(bio->bi_bdev, nr_sectors);
 }
 
 struct md_personality
@@ -795,14 +795,14 @@ static inline void mddev_clear_unsupported_flags(struct mddev *mddev,
 static inline void mddev_check_writesame(struct mddev *mddev, struct bio *bio)
 {
 	if (bio_op(bio) == REQ_OP_WRITE_SAME &&
-	    !bio->bi_disk->queue->limits.max_write_same_sectors)
+	    !bio->bi_bdev->bd_disk->queue->limits.max_write_same_sectors)
 		mddev->queue->limits.max_write_same_sectors = 0;
 }
 
 static inline void mddev_check_write_zeroes(struct mddev *mddev, struct bio *bio)
 {
 	if (bio_op(bio) == REQ_OP_WRITE_ZEROES &&
-	    !bio->bi_disk->queue->limits.max_write_zeroes_sectors)
+	    !bio->bi_bdev->bd_disk->queue->limits.max_write_zeroes_sectors)
 		mddev->queue->limits.max_write_zeroes_sectors = 0;
 }
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index c0347997f6ff73..3b19141cdb4bc2 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -794,13 +794,13 @@ static void flush_bio_list(struct r1conf *conf, struct bio *bio)
 
 	while (bio) { /* submit pending writes */
 		struct bio *next = bio->bi_next;
-		struct md_rdev *rdev = (void *)bio->bi_disk;
+		struct md_rdev *rdev = (void *)bio->bi_bdev;
 		bio->bi_next = NULL;
 		bio_set_dev(bio, rdev->bdev);
 		if (test_bit(Faulty, &rdev->flags)) {
 			bio_io_error(bio);
 		} else if (unlikely((bio_op(bio) == REQ_OP_DISCARD) &&
-				    !blk_queue_discard(bio->bi_disk->queue)))
+				    !blk_queue_discard(bio->bi_bdev->bd_disk->queue)))
 			/* Just ignore it */
 			bio_endio(bio);
 		else
@@ -1520,7 +1520,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 			trace_block_bio_remap(mbio, disk_devt(mddev->gendisk),
 					      r1_bio->sector);
 		/* flush_pending_writes() needs access to the rdev so...*/
-		mbio->bi_disk = (void *)conf->mirrors[i].rdev;
+		mbio->bi_bdev = (void *)conf->mirrors[i].rdev;
 
 		cb = blk_check_plugged(raid1_unplug, mddev, sizeof(*plug));
 		if (cb)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a6f99fa0b32cfc..34f8116c88ddb3 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -881,13 +881,13 @@ static void flush_pending_writes(struct r10conf *conf)
 
 		while (bio) { /* submit pending writes */
 			struct bio *next = bio->bi_next;
-			struct md_rdev *rdev = (void*)bio->bi_disk;
+			struct md_rdev *rdev = (void*)bio->bi_bdev;
 			bio->bi_next = NULL;
 			bio_set_dev(bio, rdev->bdev);
 			if (test_bit(Faulty, &rdev->flags)) {
 				bio_io_error(bio);
 			} else if (unlikely((bio_op(bio) ==  REQ_OP_DISCARD) &&
-					    !blk_queue_discard(bio->bi_disk->queue)))
+					    !blk_queue_discard(bio->bi_bdev->bd_disk->queue)))
 				/* Just ignore it */
 				bio_endio(bio);
 			else
@@ -1074,13 +1074,13 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
 
 	while (bio) { /* submit pending writes */
 		struct bio *next = bio->bi_next;
-		struct md_rdev *rdev = (void*)bio->bi_disk;
+		struct md_rdev *rdev = (void*)bio->bi_bdev;
 		bio->bi_next = NULL;
 		bio_set_dev(bio, rdev->bdev);
 		if (test_bit(Faulty, &rdev->flags)) {
 			bio_io_error(bio);
 		} else if (unlikely((bio_op(bio) ==  REQ_OP_DISCARD) &&
-				    !blk_queue_discard(bio->bi_disk->queue)))
+				    !blk_queue_discard(bio->bi_bdev->bd_disk->queue)))
 			/* Just ignore it */
 			bio_endio(bio);
 		else
@@ -1252,7 +1252,7 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 		trace_block_bio_remap(mbio, disk_devt(conf->mddev->gendisk),
 				      r10_bio->sector);
 	/* flush_pending_writes() needs access to the rdev so...*/
-	mbio->bi_disk = (void *)rdev;
+	mbio->bi_bdev = (void *)rdev;
 
 	atomic_inc(&r10_bio->remaining);
 
@@ -3311,7 +3311,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 
 	/* Again, very different code for resync and recovery.
 	 * Both must result in an r10bio with a list of bios that
-	 * have bi_end_io, bi_sector, bi_disk set,
+	 * have bi_end_io, bi_sector, bi_bdev set,
 	 * and bi_private set to the r10bio.
 	 * For recovery, we may actually create several r10bios
 	 * with 2 bios in each, that correspond to the bios in the main one.
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3a90cc0e43ca8e..f411b9e5c332f4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5310,7 +5310,7 @@ static int in_chunk_boundary(struct mddev *mddev, struct bio *bio)
 	unsigned int chunk_sectors;
 	unsigned int bio_sectors = bio_sectors(bio);
 
-	WARN_ON_ONCE(bio->bi_partno);
+	WARN_ON_ONCE(bio->bi_bdev->bd_partno);
 
 	chunk_sectors = min(conf->chunk_sectors, conf->prev_chunk_sectors);
 	return  chunk_sectors >=
diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 22e5617b2cea14..e03a1f38d75040 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -165,7 +165,7 @@ static int nsblk_do_bvec(struct nd_namespace_blk *nsblk,
 static blk_qc_t nd_blk_submit_bio(struct bio *bio)
 {
 	struct bio_integrity_payload *bip;
-	struct nd_namespace_blk *nsblk = bio->bi_disk->private_data;
+	struct nd_namespace_blk *nsblk = bio->bi_bdev->bd_disk->private_data;
 	struct bvec_iter iter;
 	unsigned long start;
 	struct bio_vec bvec;
@@ -177,7 +177,7 @@ static blk_qc_t nd_blk_submit_bio(struct bio *bio)
 
 	bip = bio_integrity(bio);
 	rw = bio_data_dir(bio);
-	do_acct = blk_queue_io_stat(bio->bi_disk->queue);
+	do_acct = blk_queue_io_stat(bio->bi_bdev->bd_disk->queue);
 	if (do_acct)
 		start = bio_start_io_acct(bio);
 	bio_for_each_segment(bvec, bio, iter) {
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 12ff6f8784ac11..41aa1f01fc0752 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1442,7 +1442,7 @@ static int btt_do_bvec(struct btt *btt, struct bio_integrity_payload *bip,
 static blk_qc_t btt_submit_bio(struct bio *bio)
 {
 	struct bio_integrity_payload *bip = bio_integrity(bio);
-	struct btt *btt = bio->bi_disk->private_data;
+	struct btt *btt = bio->bi_bdev->bd_disk->private_data;
 	struct bvec_iter iter;
 	unsigned long start;
 	struct bio_vec bvec;
@@ -1452,7 +1452,7 @@ static blk_qc_t btt_submit_bio(struct bio *bio)
 	if (!bio_integrity_prep(bio))
 		return BLK_QC_T_NONE;
 
-	do_acct = blk_queue_io_stat(bio->bi_disk->queue);
+	do_acct = blk_queue_io_stat(bio->bi_bdev->bd_disk->queue);
 	if (do_acct)
 		start = bio_start_io_acct(bio);
 	bio_for_each_segment(bvec, bio, iter) {
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 875076b0ea6c13..72740835c85c9b 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -197,13 +197,13 @@ static blk_qc_t pmem_submit_bio(struct bio *bio)
 	unsigned long start;
 	struct bio_vec bvec;
 	struct bvec_iter iter;
-	struct pmem_device *pmem = bio->bi_disk->private_data;
+	struct pmem_device *pmem = bio->bi_bdev->bd_disk->private_data;
 	struct nd_region *nd_region = to_region(pmem);
 
 	if (bio->bi_opf & REQ_PREFLUSH)
 		ret = nvdimm_flush(nd_region, bio);
 
-	do_acct = blk_queue_io_stat(bio->bi_disk->queue);
+	do_acct = blk_queue_io_stat(bio->bi_bdev->bd_disk->queue);
 	if (do_acct)
 		start = bio_start_io_acct(bio);
 	bio_for_each_segment(bvec, bio, iter) {
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index bc89e8659c403f..daeb011666463c 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1050,7 +1050,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 {
 	bool write = nvme_is_write(cmd);
 	struct nvme_ns *ns = q->queuedata;
-	struct gendisk *disk = ns ? ns->disk : NULL;
+	struct block_device *bdev = ns ? ns->disk->part0 : NULL;
 	struct request *req;
 	struct bio *bio = NULL;
 	void *meta = NULL;
@@ -1069,8 +1069,8 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 		if (ret)
 			goto out;
 		bio = req->bio;
-		bio->bi_disk = disk;
-		if (disk && meta_buffer && meta_len) {
+		bio->bi_bdev = bdev;
+		if (bdev && meta_buffer && meta_len) {
 			meta = nvme_add_user_metadata(bio, meta_buffer, meta_len,
 					meta_seed, write);
 			if (IS_ERR(meta)) {
diff --git a/drivers/nvme/host/lightnvm.c b/drivers/nvme/host/lightnvm.c
index 8e562d0f2c3014..3752cc349a157b 100644
--- a/drivers/nvme/host/lightnvm.c
+++ b/drivers/nvme/host/lightnvm.c
@@ -757,7 +757,6 @@ static int nvme_nvm_submit_user_cmd(struct request_queue *q,
 {
 	bool write = nvme_is_write((struct nvme_command *)vcmd);
 	struct nvm_dev *dev = ns->ndev;
-	struct gendisk *disk = ns->disk;
 	struct request *rq;
 	struct bio *bio = NULL;
 	__le64 *ppa_list = NULL;
@@ -817,7 +816,7 @@ static int nvme_nvm_submit_user_cmd(struct request_queue *q,
 			vcmd->ph_rw.metadata = cpu_to_le64(metadata_dma);
 		}
 
-		bio->bi_disk = disk;
+		bio->bi_bdev = ns->disk->part0;
 	}
 
 	blk_execute_rq(q, NULL, rq, 0);
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 106cf5c44ee7ab..78f992ef7bf361 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -294,7 +294,7 @@ static bool nvme_available_path(struct nvme_ns_head *head)
 
 blk_qc_t nvme_ns_head_submit_bio(struct bio *bio)
 {
-	struct nvme_ns_head *head = bio->bi_disk->private_data;
+	struct nvme_ns_head *head = bio->bi_bdev->bd_disk->private_data;
 	struct device *dev = disk_to_dev(head->disk);
 	struct nvme_ns *ns;
 	blk_qc_t ret = BLK_QC_T_NONE;
@@ -310,7 +310,7 @@ blk_qc_t nvme_ns_head_submit_bio(struct bio *bio)
 	srcu_idx = srcu_read_lock(&head->srcu);
 	ns = nvme_find_path(head);
 	if (likely(ns)) {
-		bio->bi_disk = ns->disk;
+		bio->bi_bdev = ns->disk->part0;
 		bio->bi_opf |= REQ_NVME_MPATH;
 		trace_block_bio_remap(bio, disk_devt(ns->head->disk),
 				      bio->bi_iter.bi_sector);
@@ -350,7 +350,7 @@ static void nvme_requeue_work(struct work_struct *work)
 		 * Reset disk to the mpath node and resubmit to select a new
 		 * path.
 		 */
-		bio->bi_disk = head->disk;
+		bio->bi_bdev = head->disk->part0;
 		submit_bio_noacct(bio);
 	}
 }
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 65e3d0ef36e1a3..e01592d60a86dd 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1461,7 +1461,7 @@ static int nvme_rdma_map_sg_pi(struct nvme_rdma_queue *queue,
 	if (unlikely(nr))
 		goto mr_put;
 
-	nvme_rdma_set_sig_attrs(blk_get_integrity(bio->bi_disk), c,
+	nvme_rdma_set_sig_attrs(blk_get_integrity(bio->bi_bdev->bd_disk), c,
 				req->mr->sig_attrs, ns->pi_type);
 	nvme_rdma_set_prot_checks(c, &req->mr->sig_attrs->check_mask);
 
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 5c5cff3f237452..da33cb4cba28eb 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -879,7 +879,7 @@ dcssblk_submit_bio(struct bio *bio)
 	blk_queue_split(&bio);
 
 	bytes_done = 0;
-	dev_info = bio->bi_disk->private_data;
+	dev_info = bio->bi_bdev->bd_disk->private_data;
 	if (dev_info == NULL)
 		goto fail;
 	if ((bio->bi_iter.bi_sector & 7) != 0 ||
diff --git a/drivers/s390/block/xpram.c b/drivers/s390/block/xpram.c
index c2536f7767b366..d1ed39162943d5 100644
--- a/drivers/s390/block/xpram.c
+++ b/drivers/s390/block/xpram.c
@@ -184,7 +184,7 @@ static unsigned long xpram_highest_page_index(void)
  */
 static blk_qc_t xpram_submit_bio(struct bio *bio)
 {
-	xpram_device_t *xdev = bio->bi_disk->private_data;
+	xpram_device_t *xdev = bio->bi_bdev->bd_disk->private_data;
 	struct bio_vec bvec;
 	struct bvec_iter iter;
 	unsigned int index;
diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 81a8c87a5afbb2..8791ad9b3ca5be 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -2677,7 +2677,7 @@ static void __btrfsic_submit_bio(struct bio *bio)
 	mutex_lock(&btrfsic_mutex);
 	/* since btrfsic_submit_bio() is also called before
 	 * btrfsic_mount(), this might return NULL */
-	dev_state = btrfsic_dev_state_lookup(bio_dev(bio) + bio->bi_partno);
+	dev_state = btrfsic_dev_state_lookup(bio->bi_bdev->bd_dev);
 	if (NULL != dev_state &&
 	    (bio_op(bio) == REQ_OP_WRITE) && bio_has_data(bio)) {
 		unsigned int i = 0;
@@ -2693,10 +2693,10 @@ static void __btrfsic_submit_bio(struct bio *bio)
 		bio_is_patched = 0;
 		if (dev_state->state->print_mask &
 		    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
-			pr_info("submit_bio(rw=%d,0x%x, bi_vcnt=%u, bi_sector=%llu (bytenr %llu), bi_disk=%p)\n",
+			pr_info("submit_bio(rw=%d,0x%x, bi_vcnt=%u, bi_sector=%llu (bytenr %llu), bi_bdev=%p)\n",
 			       bio_op(bio), bio->bi_opf, segs,
 			       (unsigned long long)bio->bi_iter.bi_sector,
-			       dev_bytenr, bio->bi_disk);
+			       dev_bytenr, bio->bi_bdev);
 
 		mapped_datav = kmalloc_array(segs,
 					     sizeof(*mapped_datav), GFP_NOFS);
@@ -2725,8 +2725,8 @@ static void __btrfsic_submit_bio(struct bio *bio)
 	} else if (NULL != dev_state && (bio->bi_opf & REQ_PREFLUSH)) {
 		if (dev_state->state->print_mask &
 		    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
-			pr_info("submit_bio(rw=%d,0x%x FLUSH, disk=%p)\n",
-			       bio_op(bio), bio->bi_opf, bio->bi_disk);
+			pr_info("submit_bio(rw=%d,0x%x FLUSH, bdev=%p)\n",
+			       bio_op(bio), bio->bi_opf, bio->bi_bdev);
 		if (!dev_state->dummy_block_for_bio_bh_flush.is_iodone) {
 			if ((dev_state->state->print_mask &
 			     (BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH |
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 255490f42b5d5b..2a4d4484500a4f 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1105,8 +1105,7 @@ static int rbio_add_io_page(struct btrfs_raid_bio *rbio,
 		 * devices or if they are not contiguous
 		 */
 		if (last_end == disk_start && !last->bi_status &&
-		    last->bi_disk == stripe->dev->bdev->bd_disk &&
-		    last->bi_partno == stripe->dev->bdev->bd_partno) {
+		    last->bi_bdev == stripe->dev->bdev) {
 			ret = bio_add_page(last, page, PAGE_SIZE, 0);
 			if (ret == PAGE_SIZE)
 				return 0;
@@ -1357,9 +1356,7 @@ static int find_bio_stripe(struct btrfs_raid_bio *rbio,
 	for (i = 0; i < rbio->bbio->num_stripes; i++) {
 		stripe = &rbio->bbio->stripes[i];
 		if (in_range(physical, stripe->physical, rbio->stripe_len) &&
-		    stripe->dev->bdev &&
-		    bio->bi_disk == stripe->dev->bdev->bd_disk &&
-		    bio->bi_partno == stripe->dev->bdev->bd_partno) {
+		    stripe->dev->bdev && bio->bi_bdev == stripe->dev->bdev) {
 			return i;
 		}
 	}
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index e71e7586e9eb06..45d6f770ccdce1 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1698,7 +1698,7 @@ static void scrub_wr_submit(struct scrub_ctx *sctx)
 
 	sbio = sctx->wr_curr_bio;
 	sctx->wr_curr_bio = NULL;
-	WARN_ON(!sbio->bio->bi_disk);
+	WARN_ON(!sbio->bio->bi_bdev);
 	scrub_pending_bio_inc(sctx);
 	/* process all writes in a single worker thread. Then the block layer
 	 * orders the requests before sending them to the driver which
diff --git a/fs/direct-io.c b/fs/direct-io.c
index d53fa92a1ab656..2660e744da2d81 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -434,7 +434,7 @@ static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
 	if (dio->is_async && dio->op == REQ_OP_READ && dio->should_dirty)
 		bio_set_pages_dirty(bio);
 
-	dio->bio_disk = bio->bi_disk;
+	dio->bio_disk = bio->bi_bdev->bd_disk;
 
 	if (sdio->submit_io) {
 		sdio->submit_io(bio, dio->inode, sdio->logical_offset_in_bio);
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index be4da52604edc1..9a2936187d8585 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -427,16 +427,6 @@ int f2fs_target_device_index(struct f2fs_sb_info *sbi, block_t blkaddr)
 	return 0;
 }
 
-/*
- * Return true, if pre_bio's bdev is same as its target device.
- */
-static bool __same_bdev(struct f2fs_sb_info *sbi,
-				block_t blk_addr, struct bio *bio)
-{
-	struct block_device *b = f2fs_target_device(sbi, blk_addr, NULL);
-	return bio->bi_disk == b->bd_disk && bio->bi_partno == b->bd_partno;
-}
-
 static struct bio *__bio_alloc(struct f2fs_io_info *fio, int npages)
 {
 	struct f2fs_sb_info *sbi = fio->sbi;
@@ -738,7 +728,7 @@ static bool page_is_mergeable(struct f2fs_sb_info *sbi, struct bio *bio,
 {
 	if (last_blkaddr + 1 != cur_blkaddr)
 		return false;
-	return __same_bdev(sbi, cur_blkaddr, bio);
+	return bio->bi_bdev == f2fs_target_device(sbi, cur_blkaddr, NULL);
 }
 
 static bool io_type_is_mergeable(struct f2fs_bio_info *io,
diff --git a/include/linux/bio.h b/include/linux/bio.h
index ecf67108f091d7..149e367619fcbe 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -470,24 +470,22 @@ extern void bvec_free(mempool_t *, struct bio_vec *, unsigned int);
 extern unsigned int bvec_nr_vecs(unsigned short idx);
 extern const char *bio_devname(struct bio *bio, char *buffer);
 
-#define bio_set_dev(bio, bdev) 			\
-do {						\
-	if ((bio)->bi_disk != (bdev)->bd_disk)	\
-		bio_clear_flag(bio, BIO_THROTTLED);\
-	(bio)->bi_disk = (bdev)->bd_disk;	\
-	(bio)->bi_partno = (bdev)->bd_partno;	\
-	bio_associate_blkg(bio);		\
+#define bio_set_dev(bio, bdev) 				\
+do {							\
+	if ((bio)->bi_bdev != (bdev))			\
+		bio_clear_flag(bio, BIO_THROTTLED);	\
+	(bio)->bi_bdev = (bdev);			\
+	bio_associate_blkg(bio);			\
 } while (0)
 
 #define bio_copy_dev(dst, src)			\
 do {						\
-	(dst)->bi_disk = (src)->bi_disk;	\
-	(dst)->bi_partno = (src)->bi_partno;	\
+	(dst)->bi_bdev = (src)->bi_bdev;	\
 	bio_clone_blkg_association(dst, src);	\
 } while (0)
 
 #define bio_dev(bio) \
-	disk_devt((bio)->bi_disk)
+	disk_devt((bio)->bi_bdev->bd_disk)
 
 #ifdef CONFIG_BLK_CGROUP
 void bio_associate_blkg(struct bio *bio);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 866f74261b3ba8..8ebd8be3e05082 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -222,7 +222,7 @@ static inline void bio_issue_init(struct bio_issue *issue,
  */
 struct bio {
 	struct bio		*bi_next;	/* request queue link */
-	struct gendisk		*bi_disk;
+	struct block_device	*bi_bdev;
 	unsigned int		bi_opf;		/* bottom bits req flags,
 						 * top bits REQ_OP. Use
 						 * accessors.
@@ -231,7 +231,6 @@ struct bio {
 	unsigned short		bi_ioprio;
 	unsigned short		bi_write_hint;
 	blk_status_t		bi_status;
-	u8			bi_partno;
 	atomic_t		__bi_remaining;
 
 	struct bvec_iter	bi_iter;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 17cedf0dc83db0..989c5d19eb7d2d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1956,7 +1956,8 @@ void part_end_io_acct(struct block_device *part, struct bio *bio,
  */
 static inline unsigned long bio_start_io_acct(struct bio *bio)
 {
-	return disk_start_io_acct(bio->bi_disk, bio_sectors(bio), bio_op(bio));
+	return disk_start_io_acct(bio->bi_bdev->bd_disk, bio_sectors(bio),
+				  bio_op(bio));
 }
 
 /**
@@ -1966,7 +1967,7 @@ static inline unsigned long bio_start_io_acct(struct bio *bio)
  */
 static inline void bio_end_io_acct(struct bio *bio, unsigned long start_time)
 {
-	return disk_end_io_acct(bio->bi_disk, bio_op(bio), start_time);
+	return disk_end_io_acct(bio->bi_bdev->bd_disk, bio_op(bio), start_time);
 }
 
 int bdev_read_only(struct block_device *bdev);
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 7839a78205c243..774f965d9aca3c 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -903,7 +903,7 @@ static void blk_add_trace_bio(struct request_queue *q, struct bio *bio,
 
 static void blk_add_trace_bio_bounce(void *ignore, struct bio *bio)
 {
-	blk_add_trace_bio(bio->bi_disk->queue, bio, BLK_TA_BOUNCE, 0);
+	blk_add_trace_bio(bio->bi_bdev->bd_disk->queue, bio, BLK_TA_BOUNCE, 0);
 }
 
 static void blk_add_trace_bio_complete(void *ignore,
@@ -915,22 +915,24 @@ static void blk_add_trace_bio_complete(void *ignore,
 
 static void blk_add_trace_bio_backmerge(void *ignore, struct bio *bio)
 {
-	blk_add_trace_bio(bio->bi_disk->queue, bio, BLK_TA_BACKMERGE, 0);
+	blk_add_trace_bio(bio->bi_bdev->bd_disk->queue, bio, BLK_TA_BACKMERGE,
+			0);
 }
 
 static void blk_add_trace_bio_frontmerge(void *ignore, struct bio *bio)
 {
-	blk_add_trace_bio(bio->bi_disk->queue, bio, BLK_TA_FRONTMERGE, 0);
+	blk_add_trace_bio(bio->bi_bdev->bd_disk->queue, bio, BLK_TA_FRONTMERGE,
+			0);
 }
 
 static void blk_add_trace_bio_queue(void *ignore, struct bio *bio)
 {
-	blk_add_trace_bio(bio->bi_disk->queue, bio, BLK_TA_QUEUE, 0);
+	blk_add_trace_bio(bio->bi_bdev->bd_disk->queue, bio, BLK_TA_QUEUE, 0);
 }
 
 static void blk_add_trace_getrq(void *ignore, struct bio *bio)
 {
-	blk_add_trace_bio(bio->bi_disk->queue, bio, BLK_TA_GETRQ, 0);
+	blk_add_trace_bio(bio->bi_bdev->bd_disk->queue, bio, BLK_TA_GETRQ, 0);
 }
 
 static void blk_add_trace_plug(void *ignore, struct request_queue *q)
@@ -967,7 +969,7 @@ static void blk_add_trace_unplug(void *ignore, struct request_queue *q,
 
 static void blk_add_trace_split(void *ignore, struct bio *bio, unsigned int pdu)
 {
-	struct request_queue *q = bio->bi_disk->queue;
+	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
 	struct blk_trace *bt;
 
 	rcu_read_lock();
@@ -997,7 +999,7 @@ static void blk_add_trace_split(void *ignore, struct bio *bio, unsigned int pdu)
 static void blk_add_trace_bio_remap(void *ignore, struct bio *bio, dev_t dev,
 				    sector_t from)
 {
-	struct request_queue *q = bio->bi_disk->queue;
+	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
 	struct blk_trace *bt;
 	struct blk_io_trace_remap r;
 
diff --git a/mm/page_io.c b/mm/page_io.c
index 433df126334958..cf3c997d2b49d9 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -431,7 +431,7 @@ int swap_readpage(struct page *page, bool synchronous)
 		ret = -ENOMEM;
 		goto out;
 	}
-	disk = bio->bi_disk;
+	disk = bio->bi_bdev->bd_disk;
 	/*
 	 * Keep this task valid during swap readpage because the oom killer may
 	 * attempt to access it in the page fault retry time check.
-- 
2.29.2

