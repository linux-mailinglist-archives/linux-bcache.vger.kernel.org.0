Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41271CB4CE
	for <lists+linux-bcache@lfdr.de>; Fri,  8 May 2020 18:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgEHQQ7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 8 May 2020 12:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728367AbgEHQPn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 8 May 2020 12:15:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96760C061A0C;
        Fri,  8 May 2020 09:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=z+5kJZZyByJU3IJf1jfbVMQe+NBGne9Opxw8kiFryiE=; b=cG6SbF5PQ7oinj68xTV0bxGkzU
        sSFsFa44SLrYmDofMrNmW8/LDzdnOfreAd34wq44I/1C58olU5fTmwxxvc2B3BLkoYp24cMIakjwn
        DaECxZsQupFliUoUpSvJgMyluftD2dNLF34WVal/3hfin8pJeMaS00hYZT0pweKml+djpcE8eMEX1
        VemE6evj0iMC5TESsIOKRLOOyJYG5I7PnVDdIt9FC27a9d5Qua4My20QC83rXzH7Zfm/+r1oJlXeU
        4oxyUY2LxQKfpZN1tlAi/NjGwh64ftFg2BXDbO0lSq8bR+qqkurXuUJryI+ffIUyDPbDDZfLND+9T
        k2rxQMVw==;
Received: from [2001:4bb8:180:9d3f:90d7:9df8:7cd:3504] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jX5f0-0004fd-7i; Fri, 08 May 2020 16:15:38 +0000
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
Subject: [PATCH 06/15] rsxx: stop using ->queuedata
Date:   Fri,  8 May 2020 18:15:08 +0200
Message-Id: <20200508161517.252308-7-hch@lst.de>
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
 drivers/block/rsxx/dev.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/block/rsxx/dev.c b/drivers/block/rsxx/dev.c
index 8ffa8260dcafe..6dde80b096c62 100644
--- a/drivers/block/rsxx/dev.c
+++ b/drivers/block/rsxx/dev.c
@@ -133,7 +133,7 @@ static void bio_dma_done_cb(struct rsxx_cardinfo *card,
 
 static blk_qc_t rsxx_make_request(struct request_queue *q, struct bio *bio)
 {
-	struct rsxx_cardinfo *card = q->queuedata;
+	struct rsxx_cardinfo *card = bio->bi_disk->private_data;
 	struct rsxx_bio_meta *bio_meta;
 	blk_status_t st = BLK_STS_IOERR;
 
@@ -282,8 +282,6 @@ int rsxx_setup_dev(struct rsxx_cardinfo *card)
 		card->queue->limits.discard_alignment   = RSXX_HW_BLK_SIZE;
 	}
 
-	card->queue->queuedata = card;
-
 	snprintf(card->gendisk->disk_name, sizeof(card->gendisk->disk_name),
 		 "rsxx%d", card->disk_id);
 	card->gendisk->major = card->major;
@@ -304,7 +302,6 @@ void rsxx_destroy_dev(struct rsxx_cardinfo *card)
 	card->gendisk = NULL;
 
 	blk_cleanup_queue(card->queue);
-	card->queue->queuedata = NULL;
 	unregister_blkdev(card->major, DRIVER_NAME);
 }
 
-- 
2.26.2

