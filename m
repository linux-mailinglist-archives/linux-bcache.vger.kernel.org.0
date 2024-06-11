Return-Path: <linux-bcache+bounces-535-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C42D4903107
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 07:29:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7625F1F29655
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 05:29:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDEBF17D8BF;
	Tue, 11 Jun 2024 05:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4T9NMLhZ"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5351C17D899;
	Tue, 11 Jun 2024 05:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718083272; cv=none; b=HelRNwBqnxuwzW+xPRi4xjJpeEAftplcAHi1AXA2PJEBoqC3N7nrHNPmCc3m4VVkAFznQnz6KA8oKr+exkCDQtGVEgsBy703rvsm7QVd/VSHuDNe/gsYBoae64noLz8fZM9S+ivDMOVqiuGan/3WVMGljU5enxYGps9KoBTAG8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718083272; c=relaxed/simple;
	bh=pSzE7POP0IbcApaWAG28mx8JR4h3Qp2KDPweIs4v+So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnmOnI6RbXX+QCX+xdDNFl0gw4t/2gcttIy81HcqqUblSMAEOe8AjIULTj/nqDBP0xlLW63DtU8l2D8zhHTu6GUz6qMPfwQwrYqC53qTiAYbAjdkngcvWh2SaG4ZpYrlNqj+GTZ/syXMcowlr4QzSx0qJUmAbHoHVP/7O63u4v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4T9NMLhZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=xY3slEHkiIq7NT2sGuMOxA8hJLcOIj4MfNseHu5TMns=; b=4T9NMLhZ85LGaZsJ9WbdPngt7y
	Lg47NyWbOusFuIcnPlTazNjFjWXkT5yAEsdF2Tng0oqqiQUya3UrgF3lv0cr8mioMxIZ95opUklxw
	3M1OWMNS18z5UDDHYnISdGZR4enIuBTfKqZeh9NEHC/wwn7yQffyG8jZyBMEHv7CUIPTauCM/4A4t
	uZ54Izj2QaXtkwLI0uaSn4JJf/3BR911bsG/t7tsxTYATIA0iybKQ85jYBhiCUPleyeGd+jL60ZaI
	wLfr7z+VuHHqSsgF7BQktz3lOGgIphJl2pF+e1sp4qBMFXL07QcuVEXmkU7DDi+7mFGg/G/7yUWm6
	lSBsjOfg==;
Received: from 2a02-8389-2341-5b80-cdb4-8e7d-405d-6b77.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:cdb4:8e7d:405d:6b77] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sGtwA-00000007RkZ-1jS3;
	Tue, 11 Jun 2024 05:20:58 +0000
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
Subject: [PATCH 26/26] block: move the bounce flag into the feature field
Date: Tue, 11 Jun 2024 07:19:26 +0200
Message-ID: <20240611051929.513387-27-hch@lst.de>
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

Move the bounce field into the flags field to reclaim a little bit of
space.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-settings.c    | 1 -
 block/blk.h             | 2 +-
 drivers/scsi/scsi_lib.c | 2 +-
 include/linux/blkdev.h  | 6 ++++--
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 96e07f24bd9aa1..d0e9096f93ca8a 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -479,7 +479,6 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 					b->max_write_zeroes_sectors);
 	t->max_zone_append_sectors = min(queue_limits_max_zone_append_sectors(t),
 					 queue_limits_max_zone_append_sectors(b));
-	t->bounce = max(t->bounce, b->bounce);
 
 	t->seg_boundary_mask = min_not_zero(t->seg_boundary_mask,
 					    b->seg_boundary_mask);
diff --git a/block/blk.h b/block/blk.h
index 79e8d5d4fe0caf..fa32f7fad5d7e6 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -394,7 +394,7 @@ struct bio *__blk_queue_bounce(struct bio *bio, struct request_queue *q);
 static inline bool blk_queue_may_bounce(struct request_queue *q)
 {
 	return IS_ENABLED(CONFIG_BOUNCE) &&
-		q->limits.bounce == BLK_BOUNCE_HIGH &&
+		(q->limits.features & BLK_FEAT_BOUNCE_HIGH) &&
 		max_low_pfn >= max_pfn;
 }
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 54f771ec8cfb5e..e2f7bfb2b9e450 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1986,7 +1986,7 @@ void scsi_init_limits(struct Scsi_Host *shost, struct queue_limits *lim)
 		shost->dma_alignment, dma_get_cache_alignment() - 1);
 
 	if (shost->no_highmem)
-		lim->bounce = BLK_BOUNCE_HIGH;
+		lim->features |= BLK_FEAT_BOUNCE_HIGH;
 
 	dma_set_seg_boundary(dev, shost->dma_boundary);
 	dma_set_max_seg_size(dev, shost->max_segment_size);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d7ad25def6e50b..d1d9787e76ce73 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -325,6 +325,9 @@ enum {
 
 	/* skip this queue in blk_mq_(un)quiesce_tagset */
 	BLK_FEAT_SKIP_TAGSET_QUIESCE		= (1u << 13),
+
+	/* bounce all highmem pages */
+	BLK_FEAT_BOUNCE_HIGH			= (1u << 14),
 };
 
 /*
@@ -332,7 +335,7 @@ enum {
  */
 #define BLK_FEAT_INHERIT_MASK \
 	(BLK_FEAT_WRITE_CACHE | BLK_FEAT_FUA | BLK_FEAT_ROTATIONAL | \
-	 BLK_FEAT_STABLE_WRITES | BLK_FEAT_ZONED)
+	 BLK_FEAT_STABLE_WRITES | BLK_FEAT_ZONED | BLK_FEAT_BOUNCE_HIGH)
 
 /* internal flags in queue_limits.flags */
 enum {
@@ -352,7 +355,6 @@ enum blk_bounce {
 struct queue_limits {
 	unsigned int		features;
 	unsigned int		flags;
-	enum blk_bounce		bounce;
 	unsigned long		seg_boundary_mask;
 	unsigned long		virt_boundary_mask;
 
-- 
2.43.0


