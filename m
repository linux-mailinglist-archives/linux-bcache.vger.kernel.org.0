Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C607D3B0D60
	for <lists+linux-bcache@lfdr.de>; Tue, 22 Jun 2021 21:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbhFVTFT (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 22 Jun 2021 15:05:19 -0400
Received: from m15111.mail.126.com ([220.181.15.111]:57166 "EHLO
        m15111.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbhFVTFT (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 22 Jun 2021 15:05:19 -0400
X-Greylist: delayed 5409 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jun 2021 15:05:18 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=PjwTqKY8NvAoWllNHD
        KS/5Am0qvY87nCeu1f99QwIUw=; b=fnDSTmHDUb56AgVG+DqrdaiHJAQBUll7ra
        oEKaDxQJcVt1VlzwKFN+EeRR1gkSmlZiii8edRoE5SaaB7PaeHJt7PPIVzL3XE/A
        m7zzi8Y+qcuxggU5OFkQHOImHpZIyPAbUt2e9kI6HAUMyYLQhSxxK/UHgAIKGu3E
        cRW5+sD6k=
Received: from 192.168.137.133 (unknown [112.10.75.196])
        by smtp1 (Coremail) with SMTP id C8mowADXblu1B9JgHvJTSg--.5696S3;
        Tue, 22 Jun 2021 23:54:31 +0800 (CST)
From:   Xianting Tian <xianting_tian@126.com>
To:     colyli@suse.de, kent.overstreet@gmail.com, agk@redhat.com,
        snitzer@redhat.com, dm-devel@redhat.com, song@kernel.org
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org,
        Xianting Tian <xianting.tian@linux.alibaba.com>
Subject: [PATCH] md: use BLK_STS_OK instead of hardcode
Date:   Tue, 22 Jun 2021 11:54:01 -0400
Message-Id: <1624377241-8642-1-git-send-email-xianting_tian@126.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: C8mowADXblu1B9JgHvJTSg--.5696S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxZFWDGFWkKF47ZryUXFyfCrg_yoWrCFy8pa
        9rXrWfAw4rJw4UZF4DZaykua4rt3Z0grW7CFyxu3s3uFy5CF98ZF4UJFWUXr1DJFW3Ga42
        q3WDtw4DuF45tr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jaiifUUUUU=
X-Originating-IP: [112.10.75.196]
X-CM-SenderInfo: h0ld03plqjs3xldqqiyswou0bp/1tbi5he5pFpEBKr-xAAAsn
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

When setting io status, sometimes it uses BLK_STS_*, sometimes,
it uses hardcode 0.
Use the macro to replace hardcode in multiple places.

Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
---
 drivers/md/bcache/request.c  | 2 +-
 drivers/md/dm-clone-target.c | 2 +-
 drivers/md/dm-integrity.c    | 2 +-
 drivers/md/dm-mpath.c        | 2 +-
 drivers/md/dm-raid1.c        | 2 +-
 drivers/md/dm.c              | 2 +-
 drivers/md/raid1.c           | 4 ++--
 drivers/md/raid10.c          | 2 +-
 8 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 6d1de88..73ba5a6 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -790,7 +790,7 @@ static void cached_dev_read_error(struct closure *cl)
 		/* Retry from the backing device: */
 		trace_bcache_read_retry(s->orig_bio);
 
-		s->iop.status = 0;
+		s->iop.status = BLK_STS_OK;
 		do_bio_hook(s, s->orig_bio, backing_request_endio);
 
 		/* XXX: invalidate cache */
diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index a90bdf9..d3f1c67 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -684,7 +684,7 @@ static void hydration_init(struct dm_clone_region_hydration *hd, unsigned long r
 	hd->region_nr = region_nr;
 	hd->overwrite_bio = NULL;
 	bio_list_init(&hd->deferred_bios);
-	hd->status = 0;
+	hd->status = BLK_STS_OK;
 
 	INIT_LIST_HEAD(&hd->list);
 	INIT_HLIST_NODE(&hd->h);
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 20f2510..179e126 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1848,7 +1848,7 @@ static int dm_integrity_map(struct dm_target *ti, struct bio *bio)
 	sector_t area, offset;
 
 	dio->ic = ic;
-	dio->bi_status = 0;
+	dio->bi_status = BLK_STS_OK;
 	dio->op = bio_op(bio);
 
 	if (unlikely(dio->op == REQ_OP_DISCARD)) {
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index bced42f..50f5945 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -648,7 +648,7 @@ static int __multipath_map_bio(struct multipath *m, struct bio *bio,
 
 	mpio->pgpath = pgpath;
 
-	bio->bi_status = 0;
+	bio->bi_status = BLK_STS_OK;
 	bio_set_dev(bio, pgpath->path.dev->bdev);
 	bio->bi_opf |= REQ_FAILFAST_TRANSPORT;
 
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index b0a82f2..bf4d875 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1283,7 +1283,7 @@ static int mirror_end_io(struct dm_target *ti, struct bio *bio,
 
 			dm_bio_restore(bd, bio);
 			bio_record->details.bi_bdev = NULL;
-			bio->bi_status = 0;
+			bio->bi_status = BLK_STS_OK;
 
 			queue_bio(ms, bio, rw);
 			return DM_ENDIO_INCOMPLETE;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ca2aedd..3d2fe23 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -649,7 +649,7 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 
 	io = container_of(tio, struct dm_io, tio);
 	io->magic = DM_IO_MAGIC;
-	io->status = 0;
+	io->status = BLK_STS_OK;
 	atomic_set(&io->io_count, 1);
 	io->orig_bio = bio;
 	io->md = md;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index ced076b..418d789 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2081,7 +2081,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 		idx ++;
 	}
 	set_bit(R1BIO_Uptodate, &r1_bio->state);
-	bio->bi_status = 0;
+	bio->bi_status = BLK_STS_OK;
 	return 1;
 }
 
@@ -2144,7 +2144,7 @@ static void process_checks(struct r1bio *r1_bio)
 		if (sbio->bi_end_io != end_sync_read)
 			continue;
 		/* Now we can 'fixup' the error value */
-		sbio->bi_status = 0;
+		sbio->bi_status = BLK_STS_OK;
 
 		bio_for_each_segment_all(bi, sbio, iter_all)
 			page_len[j++] = bi->bv_len;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 13f5e6b..c9a146b 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3797,7 +3797,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 
 		if (bio->bi_end_io == end_sync_read) {
 			md_sync_acct_bio(bio, nr_sectors);
-			bio->bi_status = 0;
+			bio->bi_status = BLK_STS_OK;
 			submit_bio_noacct(bio);
 		}
 	}
-- 
1.8.3.1

