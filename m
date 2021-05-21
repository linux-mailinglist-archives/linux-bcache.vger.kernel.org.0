Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D2838BE5F
	for <lists+linux-bcache@lfdr.de>; Fri, 21 May 2021 07:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236449AbhEUFyF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 21 May 2021 01:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234762AbhEUFxq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 21 May 2021 01:53:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE6DC06138E;
        Thu, 20 May 2021 22:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=cnFkamdyBwhugZvXvRRdxXiTplAOXNiEyXjejTqBf0Q=; b=vswXqLNKeTkO++OJRgqusiThgv
        R3kKJse+UVOa9QgB0uYAZF2OeTSIspzdy3z9TezXTUf8p7cUVvuCqtLV5Yxn6Nz2JGkpGZ7W+hPuA
        zuR9a+humHVGmamIRj18D3F0KYd77bXsJFLQ+Yh1xRgLuSd2lGdoGpE2XQJ7Bo8ujxVL2cQhumvU2
        wDEtQQPOyITvBRf1+Bt/DigZISJi+s75KsOjEhPubMb6qTK/EsJkUTHGSILMau/p8N9gwkzeMG2Nr
        90/YvxcnwlQImqPn68Em4TPUkZeb6OLzsitHcOKcILtBsJqvOOwhzJP+xg3ChixMbqwETMWd2AqNE
        Cml3+33Q==;
Received: from [2001:4bb8:180:5add:4fd7:4137:d2f2:46e6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1ljy4u-00Gq5s-1t; Fri, 21 May 2021 05:52:08 +0000
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
Subject: [PATCH 16/26] nvdimm-btt: convert to blk_alloc_disk/blk_cleanup_disk
Date:   Fri, 21 May 2021 07:51:06 +0200
Message-Id: <20210521055116.1053587-17-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210521055116.1053587-1-hch@lst.de>
References: <20210521055116.1053587-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Convert the nvdimm-btt driver to use the blk_alloc_disk and
blk_cleanup_disk helpers to simplify gendisk and request_queue
allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvdimm/btt.c | 24 +++++++-----------------
 drivers/nvdimm/btt.h |  2 --
 2 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 1741a7b0b30f..92dec4952297 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1521,34 +1521,25 @@ static int btt_blk_init(struct btt *btt)
 	struct nd_btt *nd_btt = btt->nd_btt;
 	struct nd_namespace_common *ndns = nd_btt->ndns;
 
-	/* create a new disk and request queue for btt */
-	btt->btt_queue = blk_alloc_queue(NUMA_NO_NODE);
-	if (!btt->btt_queue)
+	btt->btt_disk = blk_alloc_disk(NUMA_NO_NODE);
+	if (!btt->btt_disk)
 		return -ENOMEM;
 
-	btt->btt_disk = alloc_disk(0);
-	if (!btt->btt_disk) {
-		blk_cleanup_queue(btt->btt_queue);
-		return -ENOMEM;
-	}
-
 	nvdimm_namespace_disk_name(ndns, btt->btt_disk->disk_name);
 	btt->btt_disk->first_minor = 0;
 	btt->btt_disk->fops = &btt_fops;
 	btt->btt_disk->private_data = btt;
-	btt->btt_disk->queue = btt->btt_queue;
 
-	blk_queue_logical_block_size(btt->btt_queue, btt->sector_size);
-	blk_queue_max_hw_sectors(btt->btt_queue, UINT_MAX);
-	blk_queue_flag_set(QUEUE_FLAG_NONROT, btt->btt_queue);
+	blk_queue_logical_block_size(btt->btt_disk->queue, btt->sector_size);
+	blk_queue_max_hw_sectors(btt->btt_disk->queue, UINT_MAX);
+	blk_queue_flag_set(QUEUE_FLAG_NONROT, btt->btt_disk->queue);
 
 	if (btt_meta_size(btt)) {
 		int rc = nd_integrity_init(btt->btt_disk, btt_meta_size(btt));
 
 		if (rc) {
 			del_gendisk(btt->btt_disk);
-			put_disk(btt->btt_disk);
-			blk_cleanup_queue(btt->btt_queue);
+			blk_cleanup_disk(btt->btt_disk);
 			return rc;
 		}
 	}
@@ -1563,8 +1554,7 @@ static int btt_blk_init(struct btt *btt)
 static void btt_blk_cleanup(struct btt *btt)
 {
 	del_gendisk(btt->btt_disk);
-	put_disk(btt->btt_disk);
-	blk_cleanup_queue(btt->btt_queue);
+	blk_cleanup_disk(btt->btt_disk);
 }
 
 /**
diff --git a/drivers/nvdimm/btt.h b/drivers/nvdimm/btt.h
index aa53e0b769bd..0c76c0333f6e 100644
--- a/drivers/nvdimm/btt.h
+++ b/drivers/nvdimm/btt.h
@@ -201,7 +201,6 @@ struct badblocks;
 /**
  * struct btt - handle for a BTT instance
  * @btt_disk:		Pointer to the gendisk for BTT device
- * @btt_queue:		Pointer to the request queue for the BTT device
  * @arena_list:		Head of the list of arenas
  * @debugfs_dir:	Debugfs dentry
  * @nd_btt:		Parent nd_btt struct
@@ -219,7 +218,6 @@ struct badblocks;
  */
 struct btt {
 	struct gendisk *btt_disk;
-	struct request_queue *btt_queue;
 	struct list_head arena_list;
 	struct dentry *debugfs_dir;
 	struct nd_btt *nd_btt;
-- 
2.30.2

