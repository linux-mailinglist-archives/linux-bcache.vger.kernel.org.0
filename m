Return-Path: <linux-bcache+bounces-262-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BCAA855B54
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Feb 2024 08:11:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4D16283C07
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Feb 2024 07:11:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A3AFD53E;
	Thu, 15 Feb 2024 07:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QW7g7bsV"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769F3D51C;
	Thu, 15 Feb 2024 07:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707981070; cv=none; b=syzP63XVfDSu9OOipNXVXC1cxmfeLNGwIy87RzCuXcUHzOkt6iUU1Ymsi2PRSqaWbdC/moXc0WUi1a+or0p9RDsDLKeRHJgcrvwuHdz1srp94q/QJf/BDgjMk+4K2ZH9kw4odnOcwGRZok7G1GvuP8cFwwjmREHTKRROHYq3hxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707981070; c=relaxed/simple;
	bh=yqyMXy0LTCcuoIWvhnpcsYUQMAv/omKBSzR0P+7PQbA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pRcxTcdO3Djh7xdCCDANB85aklbv/k6uldbjiimLi46ubmHjb2Aof48WRt4VKbpFNfdJ41c6BVoA5TzQ5QZPXqKYdMWaHogZle/tWjaHdb19joIoDGLyAPgh8EepGH0OVQ1G7o2mhoz33MDv8zxEvSQnyLuoALi6+HjiQzar8K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QW7g7bsV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=41CsfLGSXJzjMmt4/M7fHOUYGoUTGss7MgyhcmruR0g=; b=QW7g7bsVMIhYQU5P2eAoPd4xEA
	Pa1xtqOy7dynM17aPfPv4pVagvdbx4XS4y3GgUH197R4mda5aj2ZPuo4YzpiwD2QYBauv6yLUKnVY
	dejUB1m62VUPaugSi9R051j29xEhGD4atWe4TOlwKgYnztB2iZMBsPK+vPxV1d53bbFtzIBP6PZfP
	khkS/MStiPA7lZbYoQMpb1jE9DfTLZgIouuyQn9DtXq1o5eEuW5y7Cf91SBzDwU6AMheOHnnuUEiA
	01JliL04potfk2smOtVh9kC4zvf0ZSczm/nmWLaI262npT9k7mfIsmQnFgo6JPDJzyIuz6uEErpvB
	CNkCCxhQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVtj-0000000FCY3-2tbJ;
	Thu, 15 Feb 2024 07:11:08 +0000
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
Subject: [PATCH 2/9] nfblock: pass queue_limits to blk_mq_alloc_disk
Date: Thu, 15 Feb 2024 08:10:48 +0100
Message-Id: <20240215071055.2201424-3-hch@lst.de>
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
 arch/m68k/emu/nfblock.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/emu/nfblock.c b/arch/m68k/emu/nfblock.c
index 539ff56b6968d0..642fb80c5c4e31 100644
--- a/arch/m68k/emu/nfblock.c
+++ b/arch/m68k/emu/nfblock.c
@@ -96,6 +96,9 @@ static const struct block_device_operations nfhd_ops = {
 
 static int __init nfhd_init_one(int id, u32 blocks, u32 bsize)
 {
+	struct queue_limits lim = {
+		.logical_block_size	= bsize,
+	};
 	struct nfhd_device *dev;
 	int dev_id = id - NFHD_DEV_OFFSET;
 	int err = -ENOMEM;
@@ -117,7 +120,7 @@ static int __init nfhd_init_one(int id, u32 blocks, u32 bsize)
 	dev->bsize = bsize;
 	dev->bshift = ffs(bsize) - 10;
 
-	dev->disk = blk_alloc_disk(NULL, NUMA_NO_NODE);
+	dev->disk = blk_alloc_disk(&lim, NUMA_NO_NODE);
 	if (IS_ERR(dev->disk)) {
 		err = PTR_ERR(dev->disk);
 		goto free_dev;
@@ -130,7 +133,6 @@ static int __init nfhd_init_one(int id, u32 blocks, u32 bsize)
 	dev->disk->private_data = dev;
 	sprintf(dev->disk->disk_name, "nfhd%u", dev_id);
 	set_capacity(dev->disk, (sector_t)blocks * (bsize / 512));
-	blk_queue_logical_block_size(dev->disk->queue, bsize);
 	err = add_disk(dev->disk);
 	if (err)
 		goto out_cleanup_disk;
-- 
2.39.2


