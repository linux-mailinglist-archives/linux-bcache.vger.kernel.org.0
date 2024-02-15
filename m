Return-Path: <linux-bcache+bounces-266-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21577855B61
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Feb 2024 08:11:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 548281C236F2
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Feb 2024 07:11:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7617BD2F7;
	Thu, 15 Feb 2024 07:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="euct3ZLG"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA30112E51;
	Thu, 15 Feb 2024 07:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707981078; cv=none; b=dFNSYr7MXC2D/aEOOQVyGMpi+DURwk7IWeP3g1nwzK89YLYji6t8JNrtLDfQmOtI3u64EvEkexsERNmv8SUavof5/HNLYLh+nser3omLPYW9urf6wSZ/yOAyA527pjBOTh8ECoOOem8tVeuFxnSHHHr58iU1ChW2NctZVWE1qf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707981078; c=relaxed/simple;
	bh=fIPgcPYRKW+g7VcsCs6JPum7nbot5tnLNW7FpMCyAUM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=geTea+r8fjDarGmudYh0U7SGHT3zOSNpJ+dMlwOoaCXVeJpFcfodBTwZKEPLqhjyhU5kAd5RBcgUkM9PnqoGJJwxFQThFYML65cKAIBbeXFV7wEZkwiihGrXdxnri2MJeu/WNDqZAu7wU7Dx9VQxWuy2xz3/COeugXl+W7+O16o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=euct3ZLG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=73uKDUHIHB3hr9q7GCyAIzCKHveE3ODF9X0ft0z2NpM=; b=euct3ZLGAvrNSHQ5uQqfL1M6Uc
	CBavzy1MvhTdoD2E8SIymJ3Tly1Iss+MeSOzmaLhFn9q7/kPIjnPa2XBQhwd6z0sjRNix09nimb08
	JMn3yQleGT6Pgf21DEdjQ+CqvIuCgvwvUzUUHzOSbEkb7HIMBoIFvZJtP9NWkC4YFf2D8S9JSabRV
	jmA2BOdGbHvQBjP+Ubs8Mo2veY/f+xYzY4x9l/D+e0gpxHysuuyzOu5xMbdYi9+DJv4/t2/fNiASQ
	qMA1INyt0PmeI2uxLdBcB0cN/YPWG8OJu6cftoL+xUau1G0ujJS/h+4QcliImcbZDxB+0fWiUBr05
	/0yFEUiw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVtr-0000000FCZD-11Bs;
	Thu, 15 Feb 2024 07:11:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Coly Li <colyli@suse.de>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	linux-m68k@lists.linux-m68k.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: [PATCH 5/9] zram: pass queue_limits to blk_mq_alloc_disk
Date: Thu, 15 Feb 2024 08:10:51 +0100
Message-Id: <20240215071055.2201424-6-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240215071055.2201424-1-hch@lst.de>
References: <20240215071055.2201424-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Pass the queue limits directly to blk_alloc_disk instead of setting them
one at a time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/zram/zram_drv.c | 47 +++++++++++++++++------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 84982221fc6620..8ee0f7bef19053 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2177,6 +2177,28 @@ ATTRIBUTE_GROUPS(zram_disk);
  */
 static int zram_add(void)
 {
+	struct queue_limits lim = {
+		.logical_block_size		= ZRAM_LOGICAL_BLOCK_SIZE,
+		/*
+		 * To ensure that we always get PAGE_SIZE aligned and
+		 * n*PAGE_SIZED sized I/O requests.
+		 */
+		.physical_block_size		= PAGE_SIZE,
+		.io_min				= PAGE_SIZE,
+		.io_opt				= PAGE_SIZE,
+		.max_hw_discard_sectors		= UINT_MAX,
+		/*
+		 * zram_bio_discard() will clear all logical blocks if logical
+		 * block size is identical with physical block size(PAGE_SIZE).
+		 * But if it is different, we will skip discarding some parts of
+		 * logical blocks in the part of the request range which isn't
+		 * aligned to physical block size.  So we can't ensure that all
+		 * discarded logical blocks are zeroed.
+		 */
+#if ZRAM_LOGICAL_BLOCK_SIZE == PAGE_SIZE
+		.max_write_zeroes_sectors	= UINT_MAX,
+#endif
+	};
 	struct zram *zram;
 	int ret, device_id;
 
@@ -2195,7 +2217,7 @@ static int zram_add(void)
 #endif
 
 	/* gendisk structure */
-	zram->disk = blk_alloc_disk(NULL, NUMA_NO_NODE);
+	zram->disk = blk_alloc_disk(&lim, NUMA_NO_NODE);
 	if (IS_ERR(zram->disk)) {
 		pr_err("Error allocating disk structure for device %d\n",
 			device_id);
@@ -2216,29 +2238,6 @@ static int zram_add(void)
 	/* zram devices sort of resembles non-rotational disks */
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, zram->disk->queue);
 	blk_queue_flag_set(QUEUE_FLAG_SYNCHRONOUS, zram->disk->queue);
-
-	/*
-	 * To ensure that we always get PAGE_SIZE aligned
-	 * and n*PAGE_SIZED sized I/O requests.
-	 */
-	blk_queue_physical_block_size(zram->disk->queue, PAGE_SIZE);
-	blk_queue_logical_block_size(zram->disk->queue,
-					ZRAM_LOGICAL_BLOCK_SIZE);
-	blk_queue_io_min(zram->disk->queue, PAGE_SIZE);
-	blk_queue_io_opt(zram->disk->queue, PAGE_SIZE);
-	blk_queue_max_discard_sectors(zram->disk->queue, UINT_MAX);
-
-	/*
-	 * zram_bio_discard() will clear all logical blocks if logical block
-	 * size is identical with physical block size(PAGE_SIZE). But if it is
-	 * different, we will skip discarding some parts of logical blocks in
-	 * the part of the request range which isn't aligned to physical block
-	 * size.  So we can't ensure that all discarded logical blocks are
-	 * zeroed.
-	 */
-	if (ZRAM_LOGICAL_BLOCK_SIZE == PAGE_SIZE)
-		blk_queue_max_write_zeroes_sectors(zram->disk->queue, UINT_MAX);
-
 	blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, zram->disk->queue);
 	ret = device_add_disk(NULL, zram->disk, zram_disk_groups);
 	if (ret)
-- 
2.39.2


