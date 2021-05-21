Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6BD238BE69
	for <lists+linux-bcache@lfdr.de>; Fri, 21 May 2021 07:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235792AbhEUFyO (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 21 May 2021 01:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235804AbhEUFxv (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 21 May 2021 01:53:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C588C06138F;
        Thu, 20 May 2021 22:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Dqzt1SgIuEv7176F2n2goXjtUgv5IYzpCnDSj1m18LI=; b=zbuRIfQxiNNx1Xt4keqjwvqG5+
        GpYWX+tYMl+zszl52DxPUhNljjrHazBTMZAsVnGGdP7pTPmVqt8MOybyaoFJ2sZ2WnpP09U+9rq2W
        kAR9KJuaSq8hqiT8PfZbqlpDd7Yu9tLXZxXNzJ1OlIomaoDXWhS1BIrrDbOu5sJL3RkgOM81Ee79j
        Ftg0HdTx2tJqsgrNqv8ugfIYFFqJCJFQO837B5dgogpmBiwJWJ3Yl7YOHQ6g/qHWYzhhe7MJZOPsj
        d6S5vZ60k9oOpp3j45PrXSGfcrmSAFFLyW+IkR1IijgDzLCdYYPyAdPt/Qsol4+8QJzXgwbvQoZss
        3hrezbFA==;
Received: from [2001:4bb8:180:5add:4fd7:4137:d2f2:46e6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1ljy50-00Gq7o-Ng; Fri, 21 May 2021 05:52:15 +0000
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
Subject: [PATCH 18/26] nvme-multipath: convert to blk_alloc_disk/blk_cleanup_disk
Date:   Fri, 21 May 2021 07:51:08 +0200
Message-Id: <20210521055116.1053587-19-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210521055116.1053587-1-hch@lst.de>
References: <20210521055116.1053587-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Convert the nvme-multipath driver to use the blk_alloc_disk and
blk_cleanup_disk helpers to simplify gendisk and request_queue
allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvdimm/pmem.c         |  1 -
 drivers/nvme/host/multipath.c | 45 ++++++++++-------------------------
 2 files changed, 13 insertions(+), 33 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 9fcd05084564..31f3c4bd6f72 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -472,7 +472,6 @@ static int pmem_attach_disk(struct device *dev,
 		blk_queue_flag_set(QUEUE_FLAG_DAX, q);
 
 	disk->fops		= &pmem_fops;
-	disk->queue		= q;
 	disk->private_data	= pmem;
 	nvdimm_namespace_disk_name(ndns, disk->disk_name);
 	set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index a5d02f236cca..b5fbdb416022 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -427,7 +427,6 @@ static void nvme_requeue_work(struct work_struct *work)
 
 int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
 {
-	struct request_queue *q;
 	bool vwc = false;
 
 	mutex_init(&head->lock);
@@ -443,33 +442,24 @@ int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
 	if (!(ctrl->subsys->cmic & NVME_CTRL_CMIC_MULTI_CTRL) || !multipath)
 		return 0;
 
-	q = blk_alloc_queue(ctrl->numa_node);
-	if (!q)
-		goto out;
-	blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
-	/* set to a default value for 512 until disk is validated */
-	blk_queue_logical_block_size(q, 512);
-	blk_set_stacking_limits(&q->limits);
-
-	/* we need to propagate up the VMC settings */
-	if (ctrl->vwc & NVME_CTRL_VWC_PRESENT)
-		vwc = true;
-	blk_queue_write_cache(q, vwc, vwc);
-
-	head->disk = alloc_disk(0);
+	head->disk = blk_alloc_disk(ctrl->numa_node);
 	if (!head->disk)
-		goto out_cleanup_queue;
+		return -ENOMEM;
 	head->disk->fops = &nvme_ns_head_ops;
 	head->disk->private_data = head;
-	head->disk->queue = q;
 	sprintf(head->disk->disk_name, "nvme%dn%d",
 			ctrl->subsys->instance, head->instance);
-	return 0;
 
-out_cleanup_queue:
-	blk_cleanup_queue(q);
-out:
-	return -ENOMEM;
+	blk_queue_flag_set(QUEUE_FLAG_NONROT, head->disk->queue);
+	/* set to a default value of 512 until the disk is validated */
+	blk_queue_logical_block_size(head->disk->queue, 512);
+	blk_set_stacking_limits(&head->disk->queue->limits);
+
+	/* we need to propagate up the VMC settings */
+	if (ctrl->vwc & NVME_CTRL_VWC_PRESENT)
+		vwc = true;
+	blk_queue_write_cache(head->disk->queue, vwc, vwc);
+	return 0;
 }
 
 static void nvme_mpath_set_live(struct nvme_ns *ns)
@@ -768,16 +758,7 @@ void nvme_mpath_remove_disk(struct nvme_ns_head *head)
 	/* make sure all pending bios are cleaned up */
 	kblockd_schedule_work(&head->requeue_work);
 	flush_work(&head->requeue_work);
-	blk_cleanup_queue(head->disk->queue);
-	if (!test_bit(NVME_NSHEAD_DISK_LIVE, &head->flags)) {
-		/*
-		 * if device_add_disk wasn't called, prevent
-		 * disk release to put a bogus reference on the
-		 * request queue
-		 */
-		head->disk->queue = NULL;
-	}
-	put_disk(head->disk);
+	blk_cleanup_disk(head->disk);
 }
 
 void nvme_mpath_init_ctrl(struct nvme_ctrl *ctrl)
-- 
2.30.2

