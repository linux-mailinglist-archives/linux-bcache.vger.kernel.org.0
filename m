Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1772838BE59
	for <lists+linux-bcache@lfdr.de>; Fri, 21 May 2021 07:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235637AbhEUFx6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 21 May 2021 01:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235701AbhEUFxn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 21 May 2021 01:53:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC0BC06138D;
        Thu, 20 May 2021 22:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=3SQMZdLsYr85yTNLOVEF4u3M4EL06PaPJgSyKW20iCs=; b=1eBy0ty2TbKICfoccGpOySQF5l
        71HLAfoqxFE9+B7ygkyjVOVx3vwD0bu3TNqIUlyQijIi8C+PSVcj3uLS6LLAx8YVrkyjbTQKU7b6F
        N5roDq487qYMRL+lK69xjE/aWqHtKyvJRNFi9y4/zQZPh+s6WrnxCMOYVv1R3ZhKDlqlsLA+BEUWb
        sfWHvtkaiAtFf0s3SBrlC1FzeNeEncdcRfnNUEDW0MfhEWZvZRr3Yx1hP+gBsPiMqtBkFXarsmJZl
        2OQyw0HWIyil2Ons2+K3d1gRMZAd/FIIBv0x9cVAtmlO2wrzsftMYEK854GI1z3HwbSns7V81c7qA
        aNeDf+Ag==;
Received: from [2001:4bb8:180:5add:4fd7:4137:d2f2:46e6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1ljy4r-00Gq5E-Cc; Fri, 21 May 2021 05:52:05 +0000
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
Subject: [PATCH 15/26] nvdimm-blk: convert to blk_alloc_disk/blk_cleanup_disk
Date:   Fri, 21 May 2021 07:51:05 +0200
Message-Id: <20210521055116.1053587-16-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210521055116.1053587-1-hch@lst.de>
References: <20210521055116.1053587-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Convert the nvdimm-blk driver to use the blk_alloc_disk and
blk_cleanup_disk helpers to simplify gendisk and request_queue
allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvdimm/blk.c | 26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 7ba446d224fb..088d3dd6f6fa 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -228,48 +228,34 @@ static const struct block_device_operations nd_blk_fops = {
 	.submit_bio =  nd_blk_submit_bio,
 };
 
-static void nd_blk_release_queue(void *q)
-{
-	blk_cleanup_queue(q);
-}
-
 static void nd_blk_release_disk(void *disk)
 {
 	del_gendisk(disk);
-	put_disk(disk);
+	blk_cleanup_disk(disk);
 }
 
 static int nsblk_attach_disk(struct nd_namespace_blk *nsblk)
 {
 	struct device *dev = &nsblk->common.dev;
 	resource_size_t available_disk_size;
-	struct request_queue *q;
 	struct gendisk *disk;
 	u64 internal_nlba;
 
 	internal_nlba = div_u64(nsblk->size, nsblk_internal_lbasize(nsblk));
 	available_disk_size = internal_nlba * nsblk_sector_size(nsblk);
 
-	q = blk_alloc_queue(NUMA_NO_NODE);
-	if (!q)
-		return -ENOMEM;
-	if (devm_add_action_or_reset(dev, nd_blk_release_queue, q))
-		return -ENOMEM;
-
-	blk_queue_max_hw_sectors(q, UINT_MAX);
-	blk_queue_logical_block_size(q, nsblk_sector_size(nsblk));
-	blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
-
-	disk = alloc_disk(0);
+	disk = blk_alloc_disk(NUMA_NO_NODE);
 	if (!disk)
 		return -ENOMEM;
 
-	disk->first_minor	= 0;
 	disk->fops		= &nd_blk_fops;
-	disk->queue		= q;
 	disk->private_data	= nsblk;
 	nvdimm_namespace_disk_name(&nsblk->common, disk->disk_name);
 
+	blk_queue_max_hw_sectors(disk->queue, UINT_MAX);
+	blk_queue_logical_block_size(disk->queue, nsblk_sector_size(nsblk));
+	blk_queue_flag_set(QUEUE_FLAG_NONROT, disk->queue);
+
 	if (devm_add_action_or_reset(dev, nd_blk_release_disk, disk))
 		return -ENOMEM;
 
-- 
2.30.2

