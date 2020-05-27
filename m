Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E501E37E9
	for <lists+linux-bcache@lfdr.de>; Wed, 27 May 2020 07:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbgE0FYg (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 27 May 2020 01:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728975AbgE0FYd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 May 2020 01:24:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B728CC061A0F;
        Tue, 26 May 2020 22:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=BoE9LPw2oUO3NHvNjCZuG9y6ne8/lIjQVC7yN88KH00=; b=au7HokE0bZOtEUIYi9XKtdmXJh
        iILFYm6nSw4YwEgYmqWTci3irvj6mGEu0DIOyoOLaZBJyQYGhxSVuuKNsaWqlWe0RIKauXSfrRBqE
        IvNdBZ5NNmeuUaIMQvVMRdzITUPU9BltNAHbol/EHeS1+TUcfMNOnvcHBpK1UspVIum+bX8Oqnv8O
        HrovPzyj17VacYYIiWjIJmULkhYr6pOri2dEv837UAOnlQAcOPbfIF5YlFuuhCFf9GiNj0B2FTBss
        cVNMAZoff+zoSDx1GMWkM+iNBbm0jZnHF9MWPOhXzlZf21SnmYJ6THHJVZpm7FTr5Ks3pOKtiCp+X
        q0iuPy3A==;
Received: from [2001:4bb8:18c:5da7:8164:affc:3c20:853d] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jdoYI-0000nL-5P; Wed, 27 May 2020 05:24:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
        linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/16] rsxx: use bio_{start,end}_io_acct
Date:   Wed, 27 May 2020 07:24:06 +0200
Message-Id: <20200527052419.403583-4-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527052419.403583-1-hch@lst.de>
References: <20200527052419.403583-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Switch rsxx to use the nicer bio accounting helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 drivers/block/rsxx/dev.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/block/rsxx/dev.c b/drivers/block/rsxx/dev.c
index 8ffa8260dcafe..3ba07ab30c84f 100644
--- a/drivers/block/rsxx/dev.c
+++ b/drivers/block/rsxx/dev.c
@@ -96,20 +96,6 @@ static const struct block_device_operations rsxx_fops = {
 	.ioctl		= rsxx_blkdev_ioctl,
 };
 
-static void disk_stats_start(struct rsxx_cardinfo *card, struct bio *bio)
-{
-	generic_start_io_acct(card->queue, bio_op(bio), bio_sectors(bio),
-			     &card->gendisk->part0);
-}
-
-static void disk_stats_complete(struct rsxx_cardinfo *card,
-				struct bio *bio,
-				unsigned long start_time)
-{
-	generic_end_io_acct(card->queue, bio_op(bio),
-			    &card->gendisk->part0, start_time);
-}
-
 static void bio_dma_done_cb(struct rsxx_cardinfo *card,
 			    void *cb_data,
 			    unsigned int error)
@@ -121,7 +107,7 @@ static void bio_dma_done_cb(struct rsxx_cardinfo *card,
 
 	if (atomic_dec_and_test(&meta->pending_dmas)) {
 		if (!card->eeh_state && card->gendisk)
-			disk_stats_complete(card, meta->bio, meta->start_time);
+			bio_end_io_acct(meta->bio, meta->start_time);
 
 		if (atomic_read(&meta->error))
 			bio_io_error(meta->bio);
@@ -167,10 +153,9 @@ static blk_qc_t rsxx_make_request(struct request_queue *q, struct bio *bio)
 	bio_meta->bio = bio;
 	atomic_set(&bio_meta->error, 0);
 	atomic_set(&bio_meta->pending_dmas, 0);
-	bio_meta->start_time = jiffies;
 
 	if (!unlikely(card->halt))
-		disk_stats_start(card, bio);
+		bio_meta->start_time = bio_start_io_acct(bio);
 
 	dev_dbg(CARD_TO_DEV(card), "BIO[%c]: meta: %p addr8: x%llx size: %d\n",
 		 bio_data_dir(bio) ? 'W' : 'R', bio_meta,
-- 
2.26.2

