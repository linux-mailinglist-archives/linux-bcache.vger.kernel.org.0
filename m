Return-Path: <linux-bcache+bounces-185-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 125A181F5B4
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Dec 2023 08:56:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCDE81F21B77
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Dec 2023 07:56:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2E574401;
	Thu, 28 Dec 2023 07:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="h+Oyfw7R"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6515963A8;
	Thu, 28 Dec 2023 07:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=itdVUuZkm0LZ+weCUcEbxBOsHJ+rlR6exlHXpKSCP7g=; b=h+Oyfw7RYjWrkcTN2ba1o6EmFf
	zZ1BqSX5hlE3Q3lGi2pIkJn+HHR2Jigaci2ap0d1mJmuEBORpqUJSPvoCBApTo0QFlEFzzt90Culh
	4WjaZp8N9tOuW2aV3D68CYbH9eFdVvXw1xnRMvJr8leIYQ+qjVA4W3W8yk3VthWhU3J4D70XMpgvR
	vjQ+u1RxROAiQaM2LM5C9KhUHgHI+MAvhfkWkJ9Q1+lNgANNbKaS5dV8WtaeEmyPgXsDhYwpQ5K1A
	iwBEmV+2ZT/xZ3aB2o7KyOe3Z9fnwSK6CcCVYQA+2VcymmPF457UuJDTbV6TXbtUZDZv1TyjTGx5H
	Gk4aqomg==;
Received: from 213-147-167-209.nat.highway.webapn.at ([213.147.167.209] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rIlFZ-00GMvn-2n;
	Thu, 28 Dec 2023 07:56:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Coly Li <colyli@suse.de>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	linux-um@lists.infradead.org,
	linux-block@vger.kernel.org,
	nbd@other.debian.org,
	linux-bcache@vger.kernel.org,
	linux-mtd@lists.infradead.org
Subject: [PATCH 5/9] nbd: use the default discard granularity
Date: Thu, 28 Dec 2023 07:55:41 +0000
Message-Id: <20231228075545.362768-6-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231228075545.362768-1-hch@lst.de>
References: <20231228075545.362768-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The discard granularity now defaults to a single sector, so don't set
that value explicitly.  Also don't bother clearing it as a discard
granularity without discard_sectors doesn't mean anything.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/nbd.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index b6414e1e645b76..4e72ec4e25ac5a 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -334,10 +334,8 @@ static int nbd_set_size(struct nbd_device *nbd, loff_t bytesize,
 	if (!nbd->pid)
 		return 0;
 
-	if (nbd->config->flags & NBD_FLAG_SEND_TRIM) {
-		nbd->disk->queue->limits.discard_granularity = blksize;
+	if (nbd->config->flags & NBD_FLAG_SEND_TRIM)
 		blk_queue_max_discard_sectors(nbd->disk->queue, UINT_MAX);
-	}
 	blk_queue_logical_block_size(nbd->disk->queue, blksize);
 	blk_queue_physical_block_size(nbd->disk->queue, blksize);
 
@@ -1357,7 +1355,6 @@ static void nbd_config_put(struct nbd_device *nbd)
 		nbd->config = NULL;
 
 		nbd->tag_set.timeout = 0;
-		nbd->disk->queue->limits.discard_granularity = 0;
 		blk_queue_max_discard_sectors(nbd->disk->queue, 0);
 
 		mutex_unlock(&nbd->config_lock);
@@ -1850,7 +1847,6 @@ static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
 	 * Tell the block layer that we are not a rotational device
 	 */
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, disk->queue);
-	disk->queue->limits.discard_granularity = 0;
 	blk_queue_max_discard_sectors(disk->queue, 0);
 	blk_queue_max_segment_size(disk->queue, UINT_MAX);
 	blk_queue_max_segments(disk->queue, USHRT_MAX);
-- 
2.39.2


