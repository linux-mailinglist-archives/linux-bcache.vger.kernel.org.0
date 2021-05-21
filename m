Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED3F38BE39
	for <lists+linux-bcache@lfdr.de>; Fri, 21 May 2021 07:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235617AbhEUFxm (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 21 May 2021 01:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234762AbhEUFx0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 21 May 2021 01:53:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E83C06138F;
        Thu, 20 May 2021 22:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=na1gVK/Uvz1C5Ztq4vI/ysulNB3a+rE/fXbvB7pq9l8=; b=yfHrGxUkSmc5Hn7zzaexXBWgta
        CeZJ3MBhS+i4WqMWIaelrt+VybQGYbilPlFxfS3Mayis9zYVIwn2QqKUw510UcxkpsX0Dlpj9E5CG
        CaHoGB88tWYgCtQz+lbssxU6x8327gfQMz/LobXR+/UYq4mT6gjcOnkhEgbYGAqoEy14Fgdn0cuSy
        E9jxBXAc+lQeBFBvp3Ea8X3ye1PTm67P6c4KoAR+wLwEmAG5DYX8iyYcuPEm5LW02xHu/yxDUUpK4
        7Hz5NazvSDgvvYUVoAGOWC3Nfwkl1ekQfIi8fT8BHsZU3CUOVe3m2q92oT0NwIlHiA2JVv+DR6zYh
        KsMXDbeg==;
Received: from [2001:4bb8:180:5add:4fd7:4137:d2f2:46e6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1ljy4Y-00GpzX-VL; Fri, 21 May 2021 05:51:47 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jim Paris <jim@jtan.com>,
        Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.ibm.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Matias Bjorling <mb@lightnvm.io>, Coly Li <colyli@suse.de>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Alex Dubov <oakad@yahoo.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
        drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mmc@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org
Subject: [PATCH 09/26] rsxx: convert to blk_alloc_disk/blk_cleanup_disk
Date:   Fri, 21 May 2021 07:50:59 +0200
Message-Id: <20210521055116.1053587-10-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210521055116.1053587-1-hch@lst.de>
References: <20210521055116.1053587-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Convert the rsxx driver to use the blk_alloc_disk and blk_cleanup_disk
helpers to simplify gendisk and request_queue allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/rsxx/dev.c       | 39 +++++++++++++---------------------
 drivers/block/rsxx/rsxx_priv.h |  1 -
 2 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/drivers/block/rsxx/dev.c b/drivers/block/rsxx/dev.c
index 9a28322a8cd8..1cc40b0ea761 100644
--- a/drivers/block/rsxx/dev.c
+++ b/drivers/block/rsxx/dev.c
@@ -236,47 +236,40 @@ int rsxx_setup_dev(struct rsxx_cardinfo *card)
 		return -ENOMEM;
 	}
 
-	card->queue = blk_alloc_queue(NUMA_NO_NODE);
-	if (!card->queue) {
-		dev_err(CARD_TO_DEV(card), "Failed queue alloc\n");
-		unregister_blkdev(card->major, DRIVER_NAME);
-		return -ENOMEM;
-	}
-
-	card->gendisk = alloc_disk(blkdev_minors);
+	card->gendisk = blk_alloc_disk(blkdev_minors);
 	if (!card->gendisk) {
 		dev_err(CARD_TO_DEV(card), "Failed disk alloc\n");
-		blk_cleanup_queue(card->queue);
 		unregister_blkdev(card->major, DRIVER_NAME);
 		return -ENOMEM;
 	}
 
 	if (card->config_valid) {
 		blk_size = card->config.data.block_size;
-		blk_queue_dma_alignment(card->queue, blk_size - 1);
-		blk_queue_logical_block_size(card->queue, blk_size);
+		blk_queue_dma_alignment(card->gendisk->queue, blk_size - 1);
+		blk_queue_logical_block_size(card->gendisk->queue, blk_size);
 	}
 
-	blk_queue_max_hw_sectors(card->queue, blkdev_max_hw_sectors);
-	blk_queue_physical_block_size(card->queue, RSXX_HW_BLK_SIZE);
+	blk_queue_max_hw_sectors(card->gendisk->queue, blkdev_max_hw_sectors);
+	blk_queue_physical_block_size(card->gendisk->queue, RSXX_HW_BLK_SIZE);
 
-	blk_queue_flag_set(QUEUE_FLAG_NONROT, card->queue);
-	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, card->queue);
+	blk_queue_flag_set(QUEUE_FLAG_NONROT, card->gendisk->queue);
+	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, card->gendisk->queue);
 	if (rsxx_discard_supported(card)) {
-		blk_queue_flag_set(QUEUE_FLAG_DISCARD, card->queue);
-		blk_queue_max_discard_sectors(card->queue,
+		blk_queue_flag_set(QUEUE_FLAG_DISCARD, card->gendisk->queue);
+		blk_queue_max_discard_sectors(card->gendisk->queue,
 						RSXX_HW_BLK_SIZE >> 9);
-		card->queue->limits.discard_granularity = RSXX_HW_BLK_SIZE;
-		card->queue->limits.discard_alignment   = RSXX_HW_BLK_SIZE;
+		card->gendisk->queue->limits.discard_granularity =
+			RSXX_HW_BLK_SIZE;
+		card->gendisk->queue->limits.discard_alignment =
+			RSXX_HW_BLK_SIZE;
 	}
 
 	snprintf(card->gendisk->disk_name, sizeof(card->gendisk->disk_name),
 		 "rsxx%d", card->disk_id);
 	card->gendisk->major = card->major;
-	card->gendisk->first_minor = 0;
+	card->gendisk->minors = blkdev_minors;
 	card->gendisk->fops = &rsxx_fops;
 	card->gendisk->private_data = card;
-	card->gendisk->queue = card->queue;
 
 	return 0;
 }
@@ -286,10 +279,8 @@ void rsxx_destroy_dev(struct rsxx_cardinfo *card)
 	if (!enable_blkdev)
 		return;
 
-	put_disk(card->gendisk);
+	blk_cleanup_disk(card->gendisk);
 	card->gendisk = NULL;
-
-	blk_cleanup_queue(card->queue);
 	unregister_blkdev(card->major, DRIVER_NAME);
 }
 
diff --git a/drivers/block/rsxx/rsxx_priv.h b/drivers/block/rsxx/rsxx_priv.h
index 6147977994ff..26c320c0d924 100644
--- a/drivers/block/rsxx/rsxx_priv.h
+++ b/drivers/block/rsxx/rsxx_priv.h
@@ -154,7 +154,6 @@ struct rsxx_cardinfo {
 	bool			bdev_attached;
 	int			disk_id;
 	int			major;
-	struct request_queue	*queue;
 	struct gendisk		*gendisk;
 	struct {
 		/* Used to convert a byte address to a device address. */
-- 
2.30.2

