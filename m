Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9ADE2106DF
	for <lists+linux-bcache@lfdr.de>; Wed,  1 Jul 2020 11:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729115AbgGAJAD (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 1 Jul 2020 05:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729101AbgGAJAC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Jul 2020 05:00:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB635C03E979;
        Wed,  1 Jul 2020 02:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=h+zTEp6W7EJyyCCOp/IKx6w4eJjLDZBSmAu+cD30b/M=; b=CalUSBbjHhqEFYSwjrf91po0Aj
        2mtO3oUaBojx0m2g/BAyWJsMP3tiGWKJQ4vdeXV0J6l5yzw1NPped+yx7kKzY6UfiQmVeJG/2MoTJ
        CYmg79UM86ns6N5mu5W6MnFamxsohRNH0sjaU4F6tJ4fblYSvvNMmfCDS4T+HS7eNQZl2q7hNqIQ5
        kkM2CycE35Ez7Sj+87Mt3qKansh5lZtDVRHPVjrfWPp+4YHr5Zu0gljaa/iu5Zw+3mTQck2BXZSux
        Cr38RtHFy7pPcMkr2BrcGymI1OyaSqMtHmRY1010j+qOHwmiZKbAqO8Z2kyswVFO5T7VkCePn5yyV
        UOFpvqJg==;
Received: from [2001:4bb8:184:76e3:ea38:596b:3e9e:422a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqYb1-00088r-0A; Wed, 01 Jul 2020 08:59:59 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
        drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org
Subject: [PATCH 07/20] umem: stop using ->queuedata
Date:   Wed,  1 Jul 2020 10:59:34 +0200
Message-Id: <20200701085947.3354405-8-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701085947.3354405-1-hch@lst.de>
References: <20200701085947.3354405-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Instead of setting up the queuedata as well just use one private data
field.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/umem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index 1e2aa5ae27963c..5498f1cf36b3fe 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -521,7 +521,8 @@ static int mm_check_plugged(struct cardinfo *card)
 
 static blk_qc_t mm_make_request(struct request_queue *q, struct bio *bio)
 {
-	struct cardinfo *card = q->queuedata;
+	struct cardinfo *card = bio->bi_disk->private_data;
+
 	pr_debug("mm_make_request %llu %u\n",
 		 (unsigned long long)bio->bi_iter.bi_sector,
 		 bio->bi_iter.bi_size);
@@ -888,7 +889,6 @@ static int mm_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	card->queue = blk_alloc_queue(mm_make_request, NUMA_NO_NODE);
 	if (!card->queue)
 		goto failed_alloc;
-	card->queue->queuedata = card;
 
 	tasklet_init(&card->tasklet, process_page, (unsigned long)card);
 
-- 
2.26.2

