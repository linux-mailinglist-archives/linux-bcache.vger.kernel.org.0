Return-Path: <linux-bcache+bounces-264-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7BEB855B5B
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Feb 2024 08:11:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72ECD283F70
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Feb 2024 07:11:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE8401118C;
	Thu, 15 Feb 2024 07:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZgFJ50c1"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3129011183;
	Thu, 15 Feb 2024 07:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707981073; cv=none; b=a5YinMtZJteAgk4JAiaHZTUMVzTTQoF2AR2aaL6tR3ZdyCWFOAyDi5iipLLmMM+54B7MzPcQXJqxrNWuezEdPdA9aBqR1uYMarVXgaQkBeFRibuNM12q1Rl7KWvancLNyxG7dLYUydcCyWX9ip63h+CZrm9HPJDEroc1bFUXqaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707981073; c=relaxed/simple;
	bh=X35JyB3UVwLs3FrM6yLvBq9WOrg43YT+fRVMeQyuuFE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bFJ4IXfVvXmMt+EHFKzmM1x+V0ERsLKYR0LS2I7lMIHMPbotlujkUhjobQrmZxBHBhA1F0sjpL7n2WDF+JGcx9k8ms16JcuswxJEAO3hIZ00sI7Wy1aJRcRraTl4vGeGMPf7VRIvLndwpyGUErtrsLkKqfoHOZy/3uKpOmQA3DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZgFJ50c1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3vDprkSWlHgo/XhYJFBKuqiaP32VOD+kgbMfBP92msg=; b=ZgFJ50c1hYEdQqUpff6mSfoSyp
	z6Oou/Z5wPB5Bm0tB91rQQUoUWu6qaQL1gf8uKlagosMG6nRoB5TXzVi8LXrLuOhIzgDPCyqUFYFW
	2jLlQxLft6Ntlc5tPRuvcyatPjTFnMgQ7NAZPdRn/+yBgbmlqj9foRijUpuB66vDJpu+QVN9Ov0aG
	s9iPXry9Toi3NaNU4rGCt52Zq9gBbP24b8lU2fU2M8AXA4yYvTaIxLv2DS3ATqlxgS9DsUq+XMEKX
	aOz69ZksBcUoDDOHKuszOkRp5U0qalQI3OhPB0UchicZ6GKKp6kE8Ab86FNK34lUvOKpAHApNEJxS
	gqdU/bnA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVtm-0000000FCYF-0i6C;
	Thu, 15 Feb 2024 07:11:10 +0000
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
Subject: [PATCH 3/9] brd: pass queue_limits to blk_mq_alloc_disk
Date: Thu, 15 Feb 2024 08:10:49 +0100
Message-Id: <20240215071055.2201424-4-hch@lst.de>
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
 drivers/block/brd.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 689a3c0c31f8b4..e322cef6596bfa 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -318,6 +318,16 @@ static int brd_alloc(int i)
 	struct gendisk *disk;
 	char buf[DISK_NAME_LEN];
 	int err = -ENOMEM;
+	struct queue_limits lim = {
+		/*
+		 * This is so fdisk will align partitions on 4k, because of
+		 * direct_access API needing 4k alignment, returning a PFN
+		 * (This is only a problem on very small devices <= 4M,
+		 *  otherwise fdisk will align on 1M. Regardless this call
+		 *  is harmless)
+		 */
+		.physical_block_size	= PAGE_SIZE,
+	};
 
 	list_for_each_entry(brd, &brd_devices, brd_list)
 		if (brd->brd_number == i)
@@ -335,7 +345,7 @@ static int brd_alloc(int i)
 		debugfs_create_u64(buf, 0444, brd_debugfs_dir,
 				&brd->brd_nr_pages);
 
-	disk = brd->brd_disk = blk_alloc_disk(NULL, NUMA_NO_NODE);
+	disk = brd->brd_disk = blk_alloc_disk(&lim, NUMA_NO_NODE);
 	if (IS_ERR(disk)) {
 		err = PTR_ERR(disk);
 		goto out_free_dev;
@@ -348,15 +358,6 @@ static int brd_alloc(int i)
 	strscpy(disk->disk_name, buf, DISK_NAME_LEN);
 	set_capacity(disk, rd_size * 2);
 	
-	/*
-	 * This is so fdisk will align partitions on 4k, because of
-	 * direct_access API needing 4k alignment, returning a PFN
-	 * (This is only a problem on very small devices <= 4M,
-	 *  otherwise fdisk will align on 1M. Regardless this call
-	 *  is harmless)
-	 */
-	blk_queue_physical_block_size(disk->queue, PAGE_SIZE);
-
 	/* Tell the block layer that this is not a rotational device */
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, disk->queue);
 	blk_queue_flag_set(QUEUE_FLAG_SYNCHRONOUS, disk->queue);
-- 
2.39.2


