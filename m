Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 733156445E6
	for <lists+linux-bcache@lfdr.de>; Tue,  6 Dec 2022 15:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbiLFOlJ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 6 Dec 2022 09:41:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiLFOlI (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 6 Dec 2022 09:41:08 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514AB1275E;
        Tue,  6 Dec 2022 06:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=3bLqs13PpyfTzvuG10t33NPo/Pm8V+s3TDruy9c4hbQ=; b=Ei+Uu6m5C0p3u7YW58rqYm0UHN
        rMI5Ab2YO+y6sokCnWoS3FTZQrruPq3ai4SzcX9/Atp/xauNuT1Vddf1CEllEH7Zw+CUP85/zoloo
        8V7RfS38GPvVsihNpCHM6KmLcXjIOjM5iwPk2Bt7jzmYST8oqlQ7Gk5QABMAKaoEyBz478h1RaggM
        uEK/5WMppqCTllhZ1yA/sl9+AvANhD0caH2tNo9HLAnbhh8BHETfPo/eh+empfRUJUF65xcj80l1o
        Cifrgq1Wrm3Si1iaV2U+gg4AqWFSU2/D/BJZrYfC+0E+prGeumWK/lFQ9kirIK4vGp7YIBbnIiYaA
        zIXndYyg==;
Received: from [2001:4bb8:19a:6deb:96e2:518:dd92:8fb1] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p2Z7z-00BJhE-SS; Tue, 06 Dec 2022 14:41:00 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     axboe@kernel.dk, snitzer@kernel.org
Cc:     colyli@suse.de, song@kernel.org, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com
Subject: [PATCH] block: remove bio_set_op_attrs
Date:   Tue,  6 Dec 2022 15:40:57 +0100
Message-Id: <20221206144057.720846-1-hch@lst.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This macro is obsolete, so replace the last few uses with open coded
bi_opf assignments.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/movinggc.c  |  2 +-
 drivers/md/bcache/request.c   |  2 +-
 drivers/md/bcache/writeback.c |  4 ++--
 drivers/md/dm-thin.c          |  2 +-
 drivers/md/raid1.c            | 12 ++++++------
 drivers/md/raid10.c           | 18 +++++++++---------
 include/linux/blk_types.h     |  7 -------
 7 files changed, 20 insertions(+), 27 deletions(-)

diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index 99499d1f6e6666..9f32901fdad102 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -160,7 +160,7 @@ static void read_moving(struct cache_set *c)
 		moving_init(io);
 		bio = &io->bio.bio;
 
-		bio_set_op_attrs(bio, REQ_OP_READ, 0);
+		bio->bi_opf = REQ_OP_READ;
 		bio->bi_end_io	= read_moving_endio;
 
 		if (bch_bio_alloc_pages(bio, GFP_KERNEL))
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 3427555b0ccae4..39c7b607f8aad8 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -244,7 +244,7 @@ static void bch_data_insert_start(struct closure *cl)
 		trace_bcache_cache_insert(k);
 		bch_keylist_push(&op->insert_keys);
 
-		bio_set_op_attrs(n, REQ_OP_WRITE, 0);
+		n->bi_opf = REQ_OP_WRITE;
 		bch_submit_bbio(n, op->c, k, 0);
 	} while (n != bio);
 
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 0285b676e9834a..d4a5fc0650bb29 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -434,7 +434,7 @@ static void write_dirty(struct closure *cl)
 	 */
 	if (KEY_DIRTY(&w->key)) {
 		dirty_init(w);
-		bio_set_op_attrs(&io->bio, REQ_OP_WRITE, 0);
+		io->bio.bi_opf = REQ_OP_WRITE;
 		io->bio.bi_iter.bi_sector = KEY_START(&w->key);
 		bio_set_dev(&io->bio, io->dc->bdev);
 		io->bio.bi_end_io	= dirty_endio;
@@ -547,7 +547,7 @@ static void read_dirty(struct cached_dev *dc)
 			io->sequence    = sequence++;
 
 			dirty_init(w);
-			bio_set_op_attrs(&io->bio, REQ_OP_READ, 0);
+			io->bio.bi_opf = REQ_OP_READ;
 			io->bio.bi_iter.bi_sector = PTR_OFFSET(&w->key, 0);
 			bio_set_dev(&io->bio, dc->disk.c->cache->bdev);
 			io->bio.bi_end_io	= read_dirty_endio;
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index e76c96c760a9b5..c2b5a537f5b8ad 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -410,7 +410,7 @@ static void end_discard(struct discard_op *op, int r)
 		 * need to wait for the chain to complete.
 		 */
 		bio_chain(op->bio, op->parent_bio);
-		bio_set_op_attrs(op->bio, REQ_OP_DISCARD, 0);
+		op->bio->bi_opf = REQ_OP_DISCARD;
 		submit_bio(op->bio);
 	}
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 58f705f4294801..68a9e2d9985b2f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1321,7 +1321,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	read_bio->bi_iter.bi_sector = r1_bio->sector +
 		mirror->rdev->data_offset;
 	read_bio->bi_end_io = raid1_end_read_request;
-	bio_set_op_attrs(read_bio, op, do_sync);
+	read_bio->bi_opf = op | do_sync;
 	if (test_bit(FailFast, &mirror->rdev->flags) &&
 	    test_bit(R1BIO_FailFast, &r1_bio->state))
 	        read_bio->bi_opf |= MD_FAILFAST;
@@ -2254,7 +2254,7 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
 			continue;
 		}
 
-		bio_set_op_attrs(wbio, REQ_OP_WRITE, 0);
+		wbio->bi_opf = REQ_OP_WRITE;
 		if (test_bit(FailFast, &conf->mirrors[i].rdev->flags))
 			wbio->bi_opf |= MD_FAILFAST;
 
@@ -2419,7 +2419,7 @@ static int narrow_write_error(struct r1bio *r1_bio, int i)
 					       GFP_NOIO, &mddev->bio_set);
 		}
 
-		bio_set_op_attrs(wbio, REQ_OP_WRITE, 0);
+		wbio->bi_opf = REQ_OP_WRITE;
 		wbio->bi_iter.bi_sector = r1_bio->sector;
 		wbio->bi_iter.bi_size = r1_bio->sectors << 9;
 
@@ -2770,7 +2770,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 			if (i < conf->raid_disks)
 				still_degraded = 1;
 		} else if (!test_bit(In_sync, &rdev->flags)) {
-			bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
+			bio->bi_opf = REQ_OP_WRITE;
 			bio->bi_end_io = end_sync_write;
 			write_targets ++;
 		} else {
@@ -2797,7 +2797,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 					if (disk < 0)
 						disk = i;
 				}
-				bio_set_op_attrs(bio, REQ_OP_READ, 0);
+				bio->bi_opf = REQ_OP_READ;
 				bio->bi_end_io = end_sync_read;
 				read_targets++;
 			} else if (!test_bit(WriteErrorSeen, &rdev->flags) &&
@@ -2809,7 +2809,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 				 * if we are doing resync or repair. Otherwise, leave
 				 * this device alone for this sync request.
 				 */
-				bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
+				bio->bi_opf = REQ_OP_WRITE;
 				bio->bi_end_io = end_sync_write;
 				write_targets++;
 			}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 9a6503f5cb982e..6c66357f92f559 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1254,7 +1254,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	read_bio->bi_iter.bi_sector = r10_bio->devs[slot].addr +
 		choose_data_offset(r10_bio, rdev);
 	read_bio->bi_end_io = raid10_end_read_request;
-	bio_set_op_attrs(read_bio, op, do_sync);
+	read_bio->bi_opf = op | do_sync;
 	if (test_bit(FailFast, &rdev->flags) &&
 	    test_bit(R10BIO_FailFast, &r10_bio->state))
 	        read_bio->bi_opf |= MD_FAILFAST;
@@ -1301,7 +1301,7 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 	mbio->bi_iter.bi_sector	= (r10_bio->devs[n_copy].addr +
 				   choose_data_offset(r10_bio, rdev));
 	mbio->bi_end_io	= raid10_end_write_request;
-	bio_set_op_attrs(mbio, op, do_sync | do_fua);
+	mbio->bi_opf = op | do_sync | do_fua;
 	if (!replacement && test_bit(FailFast,
 				     &conf->mirrors[devnum].rdev->flags)
 			 && enough(conf, devnum))
@@ -2933,7 +2933,7 @@ static int narrow_write_error(struct r10bio *r10_bio, int i)
 		wsector = r10_bio->devs[i].addr + (sector - r10_bio->sector);
 		wbio->bi_iter.bi_sector = wsector +
 				   choose_data_offset(r10_bio, rdev);
-		bio_set_op_attrs(wbio, REQ_OP_WRITE, 0);
+		wbio->bi_opf = REQ_OP_WRITE;
 
 		if (submit_bio_wait(wbio) < 0)
 			/* Failure! */
@@ -3542,7 +3542,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				bio->bi_next = biolist;
 				biolist = bio;
 				bio->bi_end_io = end_sync_read;
-				bio_set_op_attrs(bio, REQ_OP_READ, 0);
+				bio->bi_opf = REQ_OP_READ;
 				if (test_bit(FailFast, &rdev->flags))
 					bio->bi_opf |= MD_FAILFAST;
 				from_addr = r10_bio->devs[j].addr;
@@ -3567,7 +3567,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 					bio->bi_next = biolist;
 					biolist = bio;
 					bio->bi_end_io = end_sync_write;
-					bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
+					bio->bi_opf = REQ_OP_WRITE;
 					bio->bi_iter.bi_sector = to_addr
 						+ mrdev->data_offset;
 					bio_set_dev(bio, mrdev->bdev);
@@ -3588,7 +3588,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				bio->bi_next = biolist;
 				biolist = bio;
 				bio->bi_end_io = end_sync_write;
-				bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
+				bio->bi_opf = REQ_OP_WRITE;
 				bio->bi_iter.bi_sector = to_addr +
 					mreplace->data_offset;
 				bio_set_dev(bio, mreplace->bdev);
@@ -3742,7 +3742,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			bio->bi_next = biolist;
 			biolist = bio;
 			bio->bi_end_io = end_sync_read;
-			bio_set_op_attrs(bio, REQ_OP_READ, 0);
+			bio->bi_opf = REQ_OP_READ;
 			if (test_bit(FailFast, &rdev->flags))
 				bio->bi_opf |= MD_FAILFAST;
 			bio->bi_iter.bi_sector = sector + rdev->data_offset;
@@ -3764,7 +3764,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			bio->bi_next = biolist;
 			biolist = bio;
 			bio->bi_end_io = end_sync_write;
-			bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
+			bio->bi_opf = REQ_OP_WRITE;
 			if (test_bit(FailFast, &rdev->flags))
 				bio->bi_opf |= MD_FAILFAST;
 			bio->bi_iter.bi_sector = sector + rdev->data_offset;
@@ -4970,7 +4970,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 		b->bi_iter.bi_sector = r10_bio->devs[s/2].addr +
 			rdev2->new_data_offset;
 		b->bi_end_io = end_reshape_write;
-		bio_set_op_attrs(b, REQ_OP_WRITE, 0);
+		b->bi_opf = REQ_OP_WRITE;
 		b->bi_next = blist;
 		blist = b;
 	}
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index e0b098089ef2b7..99be590f952f6e 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -472,13 +472,6 @@ static inline enum req_op bio_op(const struct bio *bio)
 	return bio->bi_opf & REQ_OP_MASK;
 }
 
-/* obsolete, don't use in new code */
-static inline void bio_set_op_attrs(struct bio *bio, enum req_op op,
-				    blk_opf_t op_flags)
-{
-	bio->bi_opf = op | op_flags;
-}
-
 static inline bool op_is_write(blk_opf_t op)
 {
 	return !!(op & (__force blk_opf_t)1);
-- 
2.35.1

