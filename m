Return-Path: <linux-bcache+bounces-528-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B33749030AB
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 07:26:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA4CB1C24E9F
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 05:26:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8C18171677;
	Tue, 11 Jun 2024 05:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tAuMhP51"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF00017C234;
	Tue, 11 Jun 2024 05:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718083246; cv=none; b=g6NbmgjKa/tlmFmelJ/c6ci3n9au5Kg8jkbo9o5oPBtZ+sHCLvSYPeXuoZvJX1/qo5U58fN5wRS9ih8AhQTQmjor2/Pa2tVyLJFZemSrC4BXnjVxcEQdUoRqNAfD6ABCU80NxphKijQg3GLlcilvYjiReLzijL2t7cVreh4/Wag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718083246; c=relaxed/simple;
	bh=DWb5ObXmY03G9SIBupULTwkAW/7GyvC/iOTqedp2Wxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwkoAFWLDxbnryBEayM9Kj6jLyUarKk/r/dCKGj+pHY2F5ZA/bsLBsJLlUddsFLFyE3wiPqKo+Aed8ZkdLPWf9UDz4ea6iEdHby8vEc5RT2ZKF2QU/ykn4H0AqnaVcVkrqM96IPEx1/5xQEfB6U5Taf1uosycULgZ2UVcHJxcQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tAuMhP51; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ShRCwrCpF80xuwktmYUd9TOxPwGnFgLSsg8hYRw+Pkc=; b=tAuMhP51GB5eMCe3QLYJStwXie
	NVsAmrkVPwA4BThIOeSWqMvoL7mHvdAM0pL1U6O6rQx0QcJyDhiWVJ/IYeSjOsDAXrwAvWSyzwkul
	lvfEjFTejjDUYSoDvBBSZhgGu5TxZXMe63GW9ckfBajgXTgJnVcbqwG4/Rm6LLrXNR1AelbMph8we
	AC5Xk/mK0OhKgbOuCkXuIa6c+/inoEp4DNhjvb4muIDBiiwivz+eM2856aMJk4o/UPlqbRrv5WX4F
	+VJdYqio9G+nzwlRfRsF9ZBhm2fWQ+4OHcaUl70wWT2qCEyw3t0sOqK0uoAxe9CItfywXTMzYzs3n
	S9mM0N3A==;
Received: from 2a02-8389-2341-5b80-cdb4-8e7d-405d-6b77.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:cdb4:8e7d:405d:6b77] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sGtvo-00000007RQZ-48Dr;
	Tue, 11 Jun 2024 05:20:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Richard Weinberger <richard@nod.at>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Ming Lei <ming.lei@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-m68k@lists.linux-m68k.org,
	linux-um@lists.infradead.org,
	drbd-dev@lists.linbit.com,
	nbd@other.debian.org,
	linuxppc-dev@lists.ozlabs.org,
	ceph-devel@vger.kernel.org,
	virtualization@lists.linux.dev,
	xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: [PATCH 19/26] block: move the nowait flag to queue_limits
Date: Tue, 11 Jun 2024 07:19:19 +0200
Message-ID: <20240611051929.513387-20-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240611051929.513387-1-hch@lst.de>
References: <20240611051929.513387-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move the nowait flag into the queue_limits feature field so that it
can be set atomically and all I/O is frozen when changing the flag.

Stacking drivers are simplified in that they now can simply set the
flag, and blk_stack_limits will clear it when the features is not
supported by any of the underlying devices.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq-debugfs.c        |  1 -
 block/blk-mq.c                |  2 +-
 block/blk-settings.c          |  9 +++++++++
 drivers/block/brd.c           |  4 ++--
 drivers/md/dm-table.c         | 16 ++--------------
 drivers/md/md.c               | 18 +-----------------
 drivers/nvme/host/multipath.c |  3 +--
 include/linux/blkdev.h        |  9 +++++----
 8 files changed, 21 insertions(+), 41 deletions(-)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 957774e40b1d0c..62b132e9a9ce3b 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -96,7 +96,6 @@ static const char *const blk_queue_flag_name[] = {
 	QUEUE_FLAG_NAME(ZONE_RESETALL),
 	QUEUE_FLAG_NAME(RQ_ALLOC_TIME),
 	QUEUE_FLAG_NAME(HCTX_ACTIVE),
-	QUEUE_FLAG_NAME(NOWAIT),
 	QUEUE_FLAG_NAME(SQ_SCHED),
 	QUEUE_FLAG_NAME(SKIP_TAGSET_QUIESCE),
 };
diff --git a/block/blk-mq.c b/block/blk-mq.c
index cf67dc13f7dd4c..43235acc87505f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4118,7 +4118,7 @@ struct request_queue *blk_mq_alloc_queue(struct blk_mq_tag_set *set,
 
 	if (!lim)
 		lim = &default_lim;
-	lim->features |= BLK_FEAT_IO_STAT;
+	lim->features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT;
 
 	q = blk_alloc_queue(lim, set->numa_node);
 	if (IS_ERR(q))
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 536ee202fcdccb..bf4622c19b5c09 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -459,6 +459,15 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 
 	t->features |= (b->features & BLK_FEAT_INHERIT_MASK);
 
+	/*
+	 * BLK_FEAT_NOWAIT needs to be supported both by the stacking driver
+	 * and all underlying devices.  The stacking driver sets the flag
+	 * before stacking the limits, and this will clear the flag if any
+	 * of the underlying devices does not support it.
+	 */
+	if (!(b->features & BLK_FEAT_NOWAIT))
+		t->features &= ~BLK_FEAT_NOWAIT;
+
 	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
 	t->max_user_sectors = min_not_zero(t->max_user_sectors,
 			b->max_user_sectors);
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index d77deb571dbd06..a300645cd9d4a5 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -335,7 +335,8 @@ static int brd_alloc(int i)
 		.max_hw_discard_sectors	= UINT_MAX,
 		.max_discard_segments	= 1,
 		.discard_granularity	= PAGE_SIZE,
-		.features		= BLK_FEAT_SYNCHRONOUS,
+		.features		= BLK_FEAT_SYNCHRONOUS |
+					  BLK_FEAT_NOWAIT,
 	};
 
 	list_for_each_entry(brd, &brd_devices, brd_list)
@@ -367,7 +368,6 @@ static int brd_alloc(int i)
 	strscpy(disk->disk_name, buf, DISK_NAME_LEN);
 	set_capacity(disk, rd_size * 2);
 	
-	blk_queue_flag_set(QUEUE_FLAG_NOWAIT, disk->queue);
 	err = add_disk(disk);
 	if (err)
 		goto out_cleanup_disk;
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index f4e1b50ffdcda5..eee43d27733f9a 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -582,7 +582,7 @@ int dm_split_args(int *argc, char ***argvp, char *input)
 static void dm_set_stacking_limits(struct queue_limits *limits)
 {
 	blk_set_stacking_limits(limits);
-	limits->features |= BLK_FEAT_IO_STAT;
+	limits->features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT;
 }
 
 /*
@@ -1746,12 +1746,6 @@ static bool dm_table_supports_write_zeroes(struct dm_table *t)
 	return true;
 }
 
-static int device_not_nowait_capable(struct dm_target *ti, struct dm_dev *dev,
-				     sector_t start, sector_t len, void *data)
-{
-	return !bdev_nowait(dev->bdev);
-}
-
 static bool dm_table_supports_nowait(struct dm_table *t)
 {
 	for (unsigned int i = 0; i < t->num_targets; i++) {
@@ -1759,10 +1753,6 @@ static bool dm_table_supports_nowait(struct dm_table *t)
 
 		if (!dm_target_supports_nowait(ti->type))
 			return false;
-
-		if (!ti->type->iterate_devices ||
-		    ti->type->iterate_devices(ti, device_not_nowait_capable, NULL))
-			return false;
 	}
 
 	return true;
@@ -1825,9 +1815,7 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	int r;
 
 	if (dm_table_supports_nowait(t))
-		blk_queue_flag_set(QUEUE_FLAG_NOWAIT, q);
-	else
-		blk_queue_flag_clear(QUEUE_FLAG_NOWAIT, q);
+		limits->features &= ~BLK_FEAT_NOWAIT;
 
 	if (!dm_table_supports_discards(t)) {
 		limits->max_hw_discard_sectors = 0;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8db0db8d5a27ac..f1c7d4f281c521 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5788,7 +5788,7 @@ struct mddev *md_alloc(dev_t dev, char *name)
 	int error;
 	struct queue_limits lim = {
 		.features		= BLK_FEAT_WRITE_CACHE | BLK_FEAT_FUA |
-					  BLK_FEAT_IO_STAT,
+					  BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT,
 	};
 
 	/*
@@ -6150,13 +6150,6 @@ int md_run(struct mddev *mddev)
 		}
 	}
 
-	if (!mddev_is_dm(mddev)) {
-		struct request_queue *q = mddev->gendisk->queue;
-
-		/* Set the NOWAIT flags if all underlying devices support it */
-		if (nowait)
-			blk_queue_flag_set(QUEUE_FLAG_NOWAIT, q);
-	}
 	if (pers->sync_request) {
 		if (mddev->kobj.sd &&
 		    sysfs_create_group(&mddev->kobj, &md_redundancy_group))
@@ -7115,15 +7108,6 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 	if (!mddev->thread)
 		md_update_sb(mddev, 1);
-	/*
-	 * If the new disk does not support REQ_NOWAIT,
-	 * disable on the whole MD.
-	 */
-	if (!bdev_nowait(rdev->bdev)) {
-		pr_info("%s: Disabling nowait because %pg does not support nowait\n",
-			mdname(mddev), rdev->bdev);
-		blk_queue_flag_clear(QUEUE_FLAG_NOWAIT, mddev->gendisk->queue);
-	}
 	/*
 	 * Kick recovery, maybe this spare has to be added to the
 	 * array immediately.
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 173796f2ddea9f..61a162c9cf4e6c 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -538,7 +538,7 @@ int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
 
 	blk_set_stacking_limits(&lim);
 	lim.dma_alignment = 3;
-	lim.features |= BLK_FEAT_IO_STAT;
+	lim.features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT;
 	if (head->ids.csi != NVME_CSI_ZNS)
 		lim.max_zone_append_sectors = 0;
 
@@ -550,7 +550,6 @@ int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
 	sprintf(head->disk->disk_name, "nvme%dn%d",
 			ctrl->subsys->instance, head->instance);
 
-	blk_queue_flag_set(QUEUE_FLAG_NOWAIT, head->disk->queue);
 	/*
 	 * This assumes all controllers that refer to a namespace either
 	 * support poll queues or not.  That is not a strict guarantee,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4d908e29c760da..59c2327692589b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -304,6 +304,9 @@ enum {
 
 	/* always completes in submit context */
 	BLK_FEAT_SYNCHRONOUS			= (1u << 6),
+
+	/* supports REQ_NOWAIT */
+	BLK_FEAT_NOWAIT				= (1u << 7),
 };
 
 /*
@@ -580,12 +583,10 @@ struct request_queue {
 #define QUEUE_FLAG_ZONE_RESETALL 26	/* supports Zone Reset All */
 #define QUEUE_FLAG_RQ_ALLOC_TIME 27	/* record rq->alloc_time_ns */
 #define QUEUE_FLAG_HCTX_ACTIVE	28	/* at least one blk-mq hctx is active */
-#define QUEUE_FLAG_NOWAIT       29	/* device supports NOWAIT */
 #define QUEUE_FLAG_SQ_SCHED     30	/* single queue style io dispatch */
 #define QUEUE_FLAG_SKIP_TAGSET_QUIESCE	31 /* quiesce_tagset skip the queue*/
 
-#define QUEUE_FLAG_MQ_DEFAULT	((1UL << QUEUE_FLAG_SAME_COMP) |	\
-				 (1UL << QUEUE_FLAG_NOWAIT))
+#define QUEUE_FLAG_MQ_DEFAULT	(1UL << QUEUE_FLAG_SAME_COMP)
 
 void blk_queue_flag_set(unsigned int flag, struct request_queue *q);
 void blk_queue_flag_clear(unsigned int flag, struct request_queue *q);
@@ -1349,7 +1350,7 @@ static inline bool bdev_fua(struct block_device *bdev)
 
 static inline bool bdev_nowait(struct block_device *bdev)
 {
-	return test_bit(QUEUE_FLAG_NOWAIT, &bdev_get_queue(bdev)->queue_flags);
+	return bdev->bd_disk->queue->limits.features & BLK_FEAT_NOWAIT;
 }
 
 static inline bool bdev_is_zoned(struct block_device *bdev)
-- 
2.43.0


