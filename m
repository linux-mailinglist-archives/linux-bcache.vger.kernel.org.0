Return-Path: <linux-bcache+bounces-268-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 35EEB855B67
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Feb 2024 08:11:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BAD5EB27C36
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Feb 2024 07:11:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E76ED518;
	Thu, 15 Feb 2024 07:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="S5NxrJgp"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FE8134A0;
	Thu, 15 Feb 2024 07:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707981083; cv=none; b=NJUePKwUOz6/KnPlrwAGzV4QJxmoZHFKCydMTibXi63x27R2tKUWmPKerrNjfq3t0aWdlJ/xVHI5FXJoMMMrKXguA65j6TuDteCoLD/n+wxb32movSYE0/R5Ehl/vVWyR4wl6Vxbq+7ppUhtr5aDqhUXfmUKHe4eNpCTv3eW57U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707981083; c=relaxed/simple;
	bh=HTCKsDl22c/8bXcPnbZJCxw99dbYj2vCcDmkb8u6psE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OY8sUaj8Dz0ZvcJ3cqOkL/so/H3Ms3Q1UUeGA8uKJ8jTKGCvirp7xNL35R1LLlu3leuhOpJTTcwH4uV3U7pswfIymzr5TkNK3FDIopc6v/xV2sMZErftVUld0Js3TrfnjRcqzu0VBhM0UTDFYLtZIlhJ8DsQr/QvOk3je1dJEhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=S5NxrJgp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FXOq6Cp6lJXNIAeRYiXsCAnDeUKBcZpVeocLCiobIqw=; b=S5NxrJgplCGkhUoExuvwWfTUft
	DUHBKB407ZG8otwh64vcW5NzwgOXtWV5FeccESpf58V4NQttIFLwI81Vz9xPgVGFlgn8k6LlilGdM
	418JpRF6KK8uwmHuGNLQmZJu6gimQoxmMtIXx3A0ea6SNrSm6SSG7l8Lkma9yntQhUGxnio2PSl47
	6h45wLy5tQMQaTUBGXnkkWj8MOgW5i+icQQoo+KyYEbzbOX9i6jj9BdpjzU6Z6leO3o+3UROiAEc0
	U8j8EqErTmOEv4l4pOuRLsJG1aOBo6LcYyNPzmrEtaI6J9zMVRcjuXwt2wQR1542q7IBPKmtikpc1
	wtp40M4g==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVtw-0000000FCaS-0fOo;
	Thu, 15 Feb 2024 07:11:20 +0000
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
Subject: [PATCH 7/9] btt: pass queue_limits to blk_mq_alloc_disk
Date: Thu, 15 Feb 2024 08:10:53 +0100
Message-Id: <20240215071055.2201424-8-hch@lst.de>
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
 drivers/nvdimm/btt.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 9a0eae01d5986e..4d0c527e857678 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1496,9 +1496,13 @@ static int btt_blk_init(struct btt *btt)
 {
 	struct nd_btt *nd_btt = btt->nd_btt;
 	struct nd_namespace_common *ndns = nd_btt->ndns;
+	struct queue_limits lim = {
+		.logical_block_size	= btt->sector_size,
+		.max_hw_sectors		= UINT_MAX,
+	};
 	int rc;
 
-	btt->btt_disk = blk_alloc_disk(NULL, NUMA_NO_NODE);
+	btt->btt_disk = blk_alloc_disk(&lim, NUMA_NO_NODE);
 	if (IS_ERR(btt->btt_disk))
 		return PTR_ERR(btt->btt_disk);
 
@@ -1507,8 +1511,6 @@ static int btt_blk_init(struct btt *btt)
 	btt->btt_disk->fops = &btt_fops;
 	btt->btt_disk->private_data = btt;
 
-	blk_queue_logical_block_size(btt->btt_disk->queue, btt->sector_size);
-	blk_queue_max_hw_sectors(btt->btt_disk->queue, UINT_MAX);
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, btt->btt_disk->queue);
 	blk_queue_flag_set(QUEUE_FLAG_SYNCHRONOUS, btt->btt_disk->queue);
 
-- 
2.39.2


