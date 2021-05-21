Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645F938BE42
	for <lists+linux-bcache@lfdr.de>; Fri, 21 May 2021 07:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235343AbhEUFxr (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 21 May 2021 01:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234701AbhEUFxe (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 21 May 2021 01:53:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA13C061763;
        Thu, 20 May 2021 22:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=WCiTFeRRCmPm+nfHSliHFDSxKf26wi9nawmdHHNIgbI=; b=EYWl9BhkusWNfViwIhy2fYdimJ
        pElzAlc1Jc778x09wwgZbCkU7tFkVDMGsaOPUeiPHpF8SfHxvjy5+EnVt5sJmTUXXO7Bb4W2j9ZV3
        djNOvZ2DsIiWx1AIw4tDAwxTWmYaUg09Ghj9J8yN7w5aB+RKjdRiAj3GunDCe9zE+2D1sPTmm4Epi
        Co+Wt7CskuaicsMJX8EFTU30JzTKGiEJ/b+lbbsJxbjTlMk/rLg08d2nbqVbr/RjGz3Fszax/vXHB
        h3n8bb3Z7LoieuPqAaCvkxBXuX14i6BY0o2UrqlupNWKNp7aVj0VF1Q1Xh6jDhoI2j3ZVCkDsltr+
        huw48rEA==;
Received: from [2001:4bb8:180:5add:4fd7:4137:d2f2:46e6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1ljy4f-00Gq0n-A1; Fri, 21 May 2021 05:51:53 +0000
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
Subject: [PATCH 11/26] lightnvm: convert to blk_alloc_disk/blk_cleanup_disk
Date:   Fri, 21 May 2021 07:51:01 +0200
Message-Id: <20210521055116.1053587-12-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210521055116.1053587-1-hch@lst.de>
References: <20210521055116.1053587-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Convert the lightnvm driver to use the blk_alloc_disk and blk_cleanup_disk
helpers to simplify gendisk and request_queue allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/lightnvm/core.c | 23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/lightnvm/core.c b/drivers/lightnvm/core.c
index e7dc539fc0ac..cf8a75494833 100644
--- a/drivers/lightnvm/core.c
+++ b/drivers/lightnvm/core.c
@@ -305,7 +305,6 @@ static int __nvm_config_extended(struct nvm_dev *dev,
 static int nvm_create_tgt(struct nvm_dev *dev, struct nvm_ioctl_create *create)
 {
 	struct nvm_ioctl_create_extended e;
-	struct request_queue *tqueue;
 	struct gendisk *tdisk;
 	struct nvm_tgt_type *tt;
 	struct nvm_target *t;
@@ -370,23 +369,16 @@ static int nvm_create_tgt(struct nvm_dev *dev, struct nvm_ioctl_create *create)
 		goto err_t;
 	}
 
-	tdisk = alloc_disk(0);
+	tdisk = blk_alloc_disk(dev->q->node);
 	if (!tdisk) {
 		ret = -ENOMEM;
 		goto err_dev;
 	}
 
-	tqueue = blk_alloc_queue(dev->q->node);
-	if (!tqueue) {
-		ret = -ENOMEM;
-		goto err_disk;
-	}
-
 	strlcpy(tdisk->disk_name, create->tgtname, sizeof(tdisk->disk_name));
 	tdisk->major = 0;
 	tdisk->first_minor = 0;
 	tdisk->fops = tt->bops;
-	tdisk->queue = tqueue;
 
 	targetdata = tt->init(tgt_dev, tdisk, create->flags);
 	if (IS_ERR(targetdata)) {
@@ -395,14 +387,14 @@ static int nvm_create_tgt(struct nvm_dev *dev, struct nvm_ioctl_create *create)
 	}
 
 	tdisk->private_data = targetdata;
-	tqueue->queuedata = targetdata;
+	tdisk->queue->queuedata = targetdata;
 
 	mdts = (dev->geo.csecs >> 9) * NVM_MAX_VLBA;
 	if (dev->geo.mdts) {
 		mdts = min_t(u32, dev->geo.mdts,
 				(dev->geo.csecs >> 9) * NVM_MAX_VLBA);
 	}
-	blk_queue_max_hw_sectors(tqueue, mdts);
+	blk_queue_max_hw_sectors(tdisk->queue, mdts);
 
 	set_capacity(tdisk, tt->capacity(targetdata));
 	add_disk(tdisk);
@@ -427,10 +419,7 @@ static int nvm_create_tgt(struct nvm_dev *dev, struct nvm_ioctl_create *create)
 	if (tt->exit)
 		tt->exit(targetdata, true);
 err_init:
-	blk_cleanup_queue(tqueue);
-	tdisk->queue = NULL;
-err_disk:
-	put_disk(tdisk);
+	blk_cleanup_disk(tdisk);
 err_dev:
 	nvm_remove_tgt_dev(tgt_dev, 0);
 err_t:
@@ -444,10 +433,8 @@ static void __nvm_remove_target(struct nvm_target *t, bool graceful)
 {
 	struct nvm_tgt_type *tt = t->type;
 	struct gendisk *tdisk = t->disk;
-	struct request_queue *q = tdisk->queue;
 
 	del_gendisk(tdisk);
-	blk_cleanup_queue(q);
 
 	if (tt->sysfs_exit)
 		tt->sysfs_exit(tdisk);
@@ -456,7 +443,7 @@ static void __nvm_remove_target(struct nvm_target *t, bool graceful)
 		tt->exit(tdisk->private_data, graceful);
 
 	nvm_remove_tgt_dev(t->dev, 1);
-	put_disk(tdisk);
+	blk_cleanup_disk(tdisk);
 	module_put(t->type->owner);
 
 	list_del(&t->list);
-- 
2.30.2

