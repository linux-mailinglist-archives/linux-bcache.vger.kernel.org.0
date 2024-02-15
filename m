Return-Path: <linux-bcache+bounces-269-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40C69855B69
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Feb 2024 08:11:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 742CC1C22C6D
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Feb 2024 07:11:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF90EDDDC;
	Thu, 15 Feb 2024 07:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T+fI2qvn"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63EB5134A0;
	Thu, 15 Feb 2024 07:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707981085; cv=none; b=BghNkeYwam2ztde8Z0nubFJ9sEDMWm6xWgJj5O/TQCL7Spf2VvkwsBrGncuQM7fp2wM86zsTKRxajOZ1RdOr/1A1LTjcHmIWPeJ5w7CcuhEv4erSdS4EFqIVFvA6ld0fBrbYyEmN3LCDQLxOxnFPQwEoBwZgk+fzaizxgvK0WXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707981085; c=relaxed/simple;
	bh=zv+6Y3jwQieBiFlPdNPa93Gs4sxAq0XWugQ6wYXjZ6Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=swSMKYGOlQ3JSvJF+gxc3Qnj5oXSTpWeaSJgpLjS9K9RH+PfGYShiOmRm+y1XuM0xbcow7nhp7sZpfwftMkoy2P8xA+kr6wfCpVH2N4trFFRBgHws1GVbkhVfBGkA6K89ImyziHuhRjOj58i/vpOjRf0sLNF2sJ1eJ5Pj6pBLP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=T+fI2qvn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Wab7g7EEaEpEW3bxWcsblSBsIYi0PEh5n/BKg0X8qdQ=; b=T+fI2qvnSxBimL63YZuqKpYOFF
	i4cYK4/rRqu0uE/MY9+UOJ6L1IItyhqYQIJPMO49+TO8vPs1q2TjNVtdpwFPxBmB86inghhkWS4ws
	qjNz0V/CUKF0cHxZl+teKBv0oUO4LPUuyfqkptFPWUW/QnfSKufiPxdSU+RCRXYLZ6NP1ShrAadnU
	gB9kIXItghUr6Eh3QhztuelNHx1pnTKKLXG/g1/Xxt74qZXJ9U6hP3yZvzS1FcWCKU6UIWSOQJHfv
	otUx3Kd96CgXAmhLTvPou2pLLvyNPXP+33yirXv69aamzhY5bZAelb2SRH830ZctlbZTO5lLN62s5
	e2TYAAyA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVty-0000000FCb7-2g7h;
	Thu, 15 Feb 2024 07:11:23 +0000
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
Subject: [PATCH 8/9] pmem: pass queue_limits to blk_mq_alloc_disk
Date: Thu, 15 Feb 2024 08:10:54 +0100
Message-Id: <20240215071055.2201424-9-hch@lst.de>
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
 drivers/nvdimm/pmem.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 3a5df8d467c507..8dcc10b6db5b12 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -451,6 +451,11 @@ static int pmem_attach_disk(struct device *dev,
 {
 	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
 	struct nd_region *nd_region = to_nd_region(dev->parent);
+	struct queue_limits lim = {
+		.logical_block_size	= pmem_sector_size(ndns),
+		.physical_block_size	= PAGE_SIZE,
+		.max_hw_sectors		= UINT_MAX,
+	};
 	int nid = dev_to_node(dev), fua;
 	struct resource *res = &nsio->res;
 	struct range bb_range;
@@ -497,7 +502,7 @@ static int pmem_attach_disk(struct device *dev,
 		return -EBUSY;
 	}
 
-	disk = blk_alloc_disk(NULL, nid);
+	disk = blk_alloc_disk(&lim, nid);
 	if (IS_ERR(disk))
 		return PTR_ERR(disk);
 	q = disk->queue;
@@ -539,9 +544,6 @@ static int pmem_attach_disk(struct device *dev,
 	pmem->virt_addr = addr;
 
 	blk_queue_write_cache(q, true, fua);
-	blk_queue_physical_block_size(q, PAGE_SIZE);
-	blk_queue_logical_block_size(q, pmem_sector_size(ndns));
-	blk_queue_max_hw_sectors(q, UINT_MAX);
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
 	blk_queue_flag_set(QUEUE_FLAG_SYNCHRONOUS, q);
 	if (pmem->pfn_flags & PFN_MAP)
-- 
2.39.2


