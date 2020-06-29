Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52B820DA74
	for <lists+linux-bcache@lfdr.de>; Mon, 29 Jun 2020 22:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729852AbgF2T5R (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 29 Jun 2020 15:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387625AbgF2TkV (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:21 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1EC7C03E97A;
        Mon, 29 Jun 2020 12:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=h+zTEp6W7EJyyCCOp/IKx6w4eJjLDZBSmAu+cD30b/M=; b=GQnyDm2o+GV/m44kJo73rQbyyY
        CS2sHCEwS8wh1STubXfBJkUPk2IZPYLIPi4e9a7KG+UeX25Lp2VRuz11pt+f9FXui6PoRry8OOViP
        TyoocBmXvvZO1dNjya8W2lzx2yipPGwRF6f+aIdjcFsh351oRVn12ZFIW22Q1ouRbAgydqDTFbxi3
        LpX57W+IhOy2hIKfepxZQfUT464GV3mQHTx5RNWnbLZLAolO21/hOjbEIXgXxKBYQxecx1ZnkM9Ox
        6jCOOQxE2EiIYC6kFiqJ5z5lBZ/RVXb9SHmHf+MvPazB/JE2c7CL2/5cU+L4WPR0brqHq4xkPOee0
        NSPWoETA==;
Received: from [2001:4bb8:184:76e3:fcca:c8dc:a4bf:12fa] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jpzdK-0004Gw-70; Mon, 29 Jun 2020 19:40:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
        drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org
Subject: [PATCH 07/20] umem: stop using ->queuedata
Date:   Mon, 29 Jun 2020 21:39:34 +0200
Message-Id: <20200629193947.2705954-8-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200629193947.2705954-1-hch@lst.de>
References: <20200629193947.2705954-1-hch@lst.de>
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

