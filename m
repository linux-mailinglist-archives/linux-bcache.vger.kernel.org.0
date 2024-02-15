Return-Path: <linux-bcache+bounces-267-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C151855B63
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Feb 2024 08:11:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9EED81C22849
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Feb 2024 07:11:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E182DDAB;
	Thu, 15 Feb 2024 07:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ERS9qXH6"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BE0134A0;
	Thu, 15 Feb 2024 07:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707981081; cv=none; b=qldGQdPzKquDvtfPrMq67kGCtDGS7HdYtTtx1gzGhpiWEZwoAnYWIwZRuro19t6jBNVFPlATKQClMFB9CUgSD8DwhEFjzaO8cRy5JNnyJg+NYdoEFovgeH1uL9lXZGwxZso3aToO/LS/Qv382Q/EizLxmz6Wjq3Dr5ryKuL1GNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707981081; c=relaxed/simple;
	bh=GkG2ypgcim35ise0/pPSk+AlhhoTcU6rVEtGpA/cYqQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nyPErdMraiImAT6I7Piw9JjQPNbmZq757AbS5SWXglkI/NTzzb73bp1tnTuqF9iESQWgEcdalJQLbejFRaLX6sEf6m9gyl5uMKwxe9YXSi0M/okqs0SwZBWcwfCO7P3GvLdr0TfaPRCF7siWZ+IO/VbV8eZJxOwaveVov6m39co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ERS9qXH6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Jg/+EkI+mjlyyE41ldptuoP+ameGxINu7/PLIemR/2Q=; b=ERS9qXH6C3QwsKGv62oUn/K3JC
	f28GvorS7f9pkABsGw1/0ilYmcEDB+IcF7nnPc7m9Ll3iNXny/Y6PHe9CdOJcud5/8yy1CmW2lmES
	FfD22dM9hGfsRnar1pwtrk2Mfh81K7v6z0Cdun7TTn+3QYjJHGNG2op7dULlSgpelB88DkTDPzwBO
	QQUMRzrsLyvRG0Rtm5K1C8CdbN0uk+H28A+CeVQPB3pDfmCFnESPazoEent+vLP3GDfd7P1VXeKGx
	fcMemxnk2om9WdlICMCmUJRSn9CIPFPXSD7NjElIT77rRTl2C75olJ6a/IdU0HEq4aNIjIB2CFq50
	8L/n5IYA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVtt-0000000FCZj-2uoM;
	Thu, 15 Feb 2024 07:11:18 +0000
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
Subject: [PATCH 6/9] bcache: pass queue_limits to blk_mq_alloc_disk
Date: Thu, 15 Feb 2024 08:10:52 +0100
Message-Id: <20240215071055.2201424-7-hch@lst.de>
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
 drivers/md/bcache/super.c | 46 ++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 9955ecff383966..d06a9649d30269 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -900,6 +900,16 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 	struct request_queue *q;
 	const size_t max_stripes = min_t(size_t, INT_MAX,
 					 SIZE_MAX / sizeof(atomic_t));
+	struct queue_limits lim = {
+		.max_hw_sectors		= UINT_MAX,
+		.max_sectors		= UINT_MAX,
+		.max_segment_size	= UINT_MAX,
+		.max_segments		= BIO_MAX_VECS,
+		.max_hw_discard_sectors	= UINT_MAX,
+		.io_min			= block_size,
+		.logical_block_size	= block_size,
+		.physical_block_size	= block_size,
+	};
 	uint64_t n;
 	int idx;
 
@@ -935,7 +945,20 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
 		goto out_ida_remove;
 
-	d->disk = blk_alloc_disk(NULL, NUMA_NO_NODE);
+	if (lim.logical_block_size > PAGE_SIZE && cached_bdev) {
+		/*
+		 * This should only happen with BCACHE_SB_VERSION_BDEV.
+		 * Block/page size is checked for BCACHE_SB_VERSION_CDEV.
+		 */
+		pr_info("bcache%i: sb/logical block size (%u) greater than page size (%lu) falling back to device logical block size (%u)\n",
+			idx, lim.logical_block_size,
+			PAGE_SIZE, bdev_logical_block_size(cached_bdev));
+
+		/* This also adjusts physical block size/min io size if needed */
+		lim.logical_block_size = bdev_logical_block_size(cached_bdev);
+	}
+
+	d->disk = blk_alloc_disk(&lim, NUMA_NO_NODE);
 	if (IS_ERR(d->disk))
 		goto out_bioset_exit;
 
@@ -949,27 +972,6 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 	d->disk->private_data	= d;
 
 	q = d->disk->queue;
-	q->limits.max_hw_sectors	= UINT_MAX;
-	q->limits.max_sectors		= UINT_MAX;
-	q->limits.max_segment_size	= UINT_MAX;
-	q->limits.max_segments		= BIO_MAX_VECS;
-	blk_queue_max_discard_sectors(q, UINT_MAX);
-	q->limits.io_min		= block_size;
-	q->limits.logical_block_size	= block_size;
-	q->limits.physical_block_size	= block_size;
-
-	if (q->limits.logical_block_size > PAGE_SIZE && cached_bdev) {
-		/*
-		 * This should only happen with BCACHE_SB_VERSION_BDEV.
-		 * Block/page size is checked for BCACHE_SB_VERSION_CDEV.
-		 */
-		pr_info("%s: sb/logical block size (%u) greater than page size (%lu) falling back to device logical block size (%u)\n",
-			d->disk->disk_name, q->limits.logical_block_size,
-			PAGE_SIZE, bdev_logical_block_size(cached_bdev));
-
-		/* This also adjusts physical block size/min io size if needed */
-		blk_queue_logical_block_size(q, bdev_logical_block_size(cached_bdev));
-	}
 
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, d->disk->queue);
 
-- 
2.39.2


