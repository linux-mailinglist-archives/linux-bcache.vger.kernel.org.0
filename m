Return-Path: <linux-bcache+bounces-270-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A1694855B6C
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Feb 2024 08:11:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D429F1C231C1
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Feb 2024 07:11:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D7A9DF60;
	Thu, 15 Feb 2024 07:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4wIQuCo0"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0639813AC6;
	Thu, 15 Feb 2024 07:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707981088; cv=none; b=bmVHDbeJFDoN8yZTpPuOEnEE+4OOxgho+YQAU2gLFLS8iCY56K5mXjRKFp9svoB5OiI+REhhXjyfN8lFXQY9fMga7Nu6LuoA523hUfutnvnAmTuSnr7Hik3I/kVS6J/e00HoXppGLfAfY5UY4fYUH/oE+4Mz+SmvGIdrQveU6Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707981088; c=relaxed/simple;
	bh=mUQ6qR1VcZlsa80hsbyzs7x83EgfVJ4CEIp0+7G3LpU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R54v/UBjXUPimX2+G83UpCumGNTF3wm4osd66oY0CJXs1TtAa++PBY5OXddPbEUFvNcfBTn+QnE739PlYDShgm/qD92NWwVZpozzB6wDU5pbdQ1HuRVa4CtDVg+hqA61wTM4ObKV+tHNWpfAuYUv0/n0Dd6aq17yh88eQXTGHJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4wIQuCo0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=pnXzo7LJP4uipI+1tMWvmV+hmJq5LEF/ccT/cYRw3UY=; b=4wIQuCo0hhJt0bS8FfIcEoZZzg
	ppDkiLp2/RwrR7jhZsmfYuTLoywwRD7OpxAIDDHEmOBuNxTDzEi+84LSTFxLs+8q3nJgBaIE/fMB4
	RhKGO2PThpNXLNSQhocr7Sv7J1GRW14WyLt7HIYH7wicxN7tlQnQgDPcVO4vFBdt3pAD7xRZGd/mo
	Y5Q5HZ+CrksXeQdJn4DzYFUuuS8pcS88oZGhep/ECjpRENt6XkdCtt9LYAuLz/Gf8DDOw70dCUC+G
	6ITMc2vpGjJ3DD3EBUBFpyYPLDrAZAiAf+a4XpP1e3NLdKLm3ib7rQxabPjeA7MFQ9gsoLAolOnlb
	7irv8ecw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVu1-0000000FCbr-0TlZ;
	Thu, 15 Feb 2024 07:11:25 +0000
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
Subject: [PATCH 9/9] dcssblk: pass queue_limits to blk_mq_alloc_disk
Date: Thu, 15 Feb 2024 08:10:55 +0100
Message-Id: <20240215071055.2201424-10-hch@lst.de>
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
 drivers/s390/block/dcssblk.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 0903b432ea9740..9c8f529b827cb3 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -546,6 +546,9 @@ static const struct attribute_group *dcssblk_dev_attr_groups[] = {
 static ssize_t
 dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
 {
+	struct queue_limits lim = {
+		.logical_block_size	= 4096,
+	};
 	int rc, i, j, num_of_segments;
 	struct dcssblk_dev_info *dev_info;
 	struct segment_info *seg_info, *temp;
@@ -629,7 +632,7 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	dev_info->dev.release = dcssblk_release_segment;
 	dev_info->dev.groups = dcssblk_dev_attr_groups;
 	INIT_LIST_HEAD(&dev_info->lh);
-	dev_info->gd = blk_alloc_disk(NULL, NUMA_NO_NODE);
+	dev_info->gd = blk_alloc_disk(&lim, NUMA_NO_NODE);
 	if (IS_ERR(dev_info->gd)) {
 		rc = PTR_ERR(dev_info->gd);
 		goto seg_list_del;
@@ -639,7 +642,6 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	dev_info->gd->fops = &dcssblk_devops;
 	dev_info->gd->private_data = dev_info;
 	dev_info->gd->flags |= GENHD_FL_NO_PART;
-	blk_queue_logical_block_size(dev_info->gd->queue, 4096);
 	blk_queue_flag_set(QUEUE_FLAG_DAX, dev_info->gd->queue);
 
 	seg_byte_size = (dev_info->end - dev_info->start + 1);
-- 
2.39.2


