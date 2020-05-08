Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3CB1CB4B5
	for <lists+linux-bcache@lfdr.de>; Fri,  8 May 2020 18:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgEHQPz (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 8 May 2020 12:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728418AbgEHQPt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 8 May 2020 12:15:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E948C061A0C;
        Fri,  8 May 2020 09:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=IPRG+JDqkx1viJ/AMjzU5O6Pl2NB/T/FRb+DBspvmGU=; b=lK8ZNxOsc1ITEEKH7PjirEwIjK
        OwCQ+1EoGDndvVM4y3SjpiZhfHWzaZQ1IFmZtvcORUIwiVxWH5I4Fs8xZq/FghsmwLxIQp4ZRpzyW
        ST0Kk6+py/T5zYQn4svEwiTfAZhJN6p6zy9KwIwYUlfqNSr5XN/UqH0OjhhghPQDrymdXLL/YsAFO
        PCe09qBSQho7zUnWU/oNsYd67E9k7WOpOwpZzBV4BFoNV3dvWLGpbkDyERxea3ldLMqFbgowFXhVp
        Lmlzkhui6FVKhiJFYmRwspKFZ8pnp1a2HmlZrA7yqVLSThE604XkJ1wNbYZt3mPuAwJDyju2pYnen
        eibxtaOw==;
Received: from [2001:4bb8:180:9d3f:90d7:9df8:7cd:3504] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jX5f3-0004hP-5Q; Fri, 08 May 2020 16:15:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Jim Paris <jim@jtan.com>, Geoff Levand <geoff@infradead.org>,
        Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.ibm.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com,
        linux-block@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvdimm@lists.01.org
Subject: [PATCH 07/15] umem: stop using ->queuedata
Date:   Fri,  8 May 2020 18:15:09 +0200
Message-Id: <20200508161517.252308-8-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508161517.252308-1-hch@lst.de>
References: <20200508161517.252308-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/umem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index d84e8a878df24..e59bff24e02cf 100644
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

