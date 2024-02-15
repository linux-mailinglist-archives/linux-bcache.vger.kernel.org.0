Return-Path: <linux-bcache+bounces-265-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 36F66855B5D
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Feb 2024 08:11:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 699DD1C2304E
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Feb 2024 07:11:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49140D2E0;
	Thu, 15 Feb 2024 07:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Us5EK64n"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10ED11CB7;
	Thu, 15 Feb 2024 07:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707981076; cv=none; b=gd8KnwrsCghsrU3Ui3H8CCrdnB9nZYqgEbozBk0lWoJZAkZrMGLeVdJs/OG8/JGQiJhEjV5e5N3YV7zVeiO0DNeZsdfdxiAhCUptT2U/WovDXu64hqczh41hOAYVafq/OW59ztXMf6iGd/AEU43FGhA3o8HfHLoOg8XcXFsAMMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707981076; c=relaxed/simple;
	bh=Pfy9XKNvJU/RsFWMgzTZqxdYHTTqleli92wXJDVVvS4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JkZcMEDlZjb6ghT9neDPgsKm5vMn7b46sRWAAYUliZtS8dQIiXCYLhnUgD2nJVGNLdHyQbcfKeERYr2g3o91eg4C+pi4tcXypBIGoi6POygENRorPBoNt35U2zpS4KzCcuZoikqIg3AF248+J7XdVrYNNZ/6KJM9ZB7YUe5YDek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Us5EK64n; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hUDA5m9qR9thHoN5iaqnGtULQwzeS0J1nV9LG/t9rp0=; b=Us5EK64njf1TmaqSjp8AqCRevS
	ZXqBwGFs3Xla3K1oieanL3O6KCLeEH6js9flQ+98Jk1iSTdDj+bvjpuIFknGrI3bvYjhrSHOUW9FN
	5IC8RkbogI40KBttSe84u8ORIclAbB2+EE4bNraEUKG1Ax+XCOyqH/K6NECtafFo8gQVRBAIrDP0K
	j+7Y3OFymbTnBSbiuw7tlj8N+VBjyWBnGDVZig4XfMATnCck57m3eRHLM0WG/pD/xSw7Ua7lZPY9I
	t3U0r852/7LlsTRVRl9ag0VW3NEDD3EC4gpxp6Dj5UKWbjglhKypdvC2AA2em87E6I9MPL2j5hSNt
	9GctiJdQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVto-0000000FCYU-3Hpk;
	Thu, 15 Feb 2024 07:11:13 +0000
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
Subject: [PATCH 4/9] n64cart: pass queue_limits to blk_mq_alloc_disk
Date: Thu, 15 Feb 2024 08:10:50 +0100
Message-Id: <20240215071055.2201424-5-hch@lst.de>
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
 drivers/block/n64cart.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/block/n64cart.c b/drivers/block/n64cart.c
index c64d7ee7a44db5..27b2187e7a6d55 100644
--- a/drivers/block/n64cart.c
+++ b/drivers/block/n64cart.c
@@ -114,6 +114,10 @@ static const struct block_device_operations n64cart_fops = {
  */
 static int __init n64cart_probe(struct platform_device *pdev)
 {
+	struct queue_limits lim = {
+		.physical_block_size	= 4096,
+		.logical_block_size	= 4096,
+	};
 	struct gendisk *disk;
 	int err = -ENOMEM;
 
@@ -131,7 +135,7 @@ static int __init n64cart_probe(struct platform_device *pdev)
 	if (IS_ERR(reg_base))
 		return PTR_ERR(reg_base);
 
-	disk = blk_alloc_disk(NULL, NUMA_NO_NODE);
+	disk = blk_alloc_disk(&lim, NUMA_NO_NODE);
 	if (IS_ERR(disk)) {
 		err = PTR_ERR(disk);
 		goto out;
@@ -147,8 +151,6 @@ static int __init n64cart_probe(struct platform_device *pdev)
 	set_disk_ro(disk, 1);
 
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, disk->queue);
-	blk_queue_physical_block_size(disk->queue, 4096);
-	blk_queue_logical_block_size(disk->queue, 4096);
 
 	err = add_disk(disk);
 	if (err)
-- 
2.39.2


