Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF5174D0FED
	for <lists+linux-bcache@lfdr.de>; Tue,  8 Mar 2022 07:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344395AbiCHGRV (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 8 Mar 2022 01:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344431AbiCHGRN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 8 Mar 2022 01:17:13 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282223BFA2;
        Mon,  7 Mar 2022 22:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=8X3c5XDqthuQdXMBmAKyJ50PsF74xYticZhjJF97a3o=; b=uITWO/byir10fw/w7iDmD1tNU+
        h4Rx6vQ8VwFOEAgn8RGFju0aeGxhCF9oHFGM5lIEQjGKVjufiRS3s7xY6x2DkMGWFx+IMthmluurN
        1tTw5NXlhIElgCKzH3KIXBwDpqigoQ6Kw1r8+ha1uWMHxm/Pzg7QGBdihic5MlrpUgq8aa/jyxOc1
        NcYvI8gbU9V5coVyE7Yd+PwoWLz2S2O7K3N0hwG9eUBffZdtKm1yyEH2fGnTJiG8cbasYZ+GwtLc0
        Y4TAGvAVwtdHCVt4h9qnhFVIeAYiQmS831f2T6Rer+6UXcoHLqyvX/aQUtXbUK5kSJrVYddH18//b
        roCZpysA==;
Received: from [2001:4bb8:184:7746:6f50:7a98:3141:c37b] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nRT8h-002lWm-QS; Tue, 08 Mar 2022 06:16:08 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, target-devel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 5/5] pktcdvd: stop using bio_reset
Date:   Tue,  8 Mar 2022 07:15:51 +0100
Message-Id: <20220308061551.737853-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220308061551.737853-1-hch@lst.de>
References: <20220308061551.737853-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Just initialize the bios on-demand.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/pktcdvd.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 5ab43f9027631..335099c4076ee 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -525,7 +525,6 @@ static struct packet_data *pkt_alloc_packet_data(int frames)
 	pkt->w_bio = bio_kmalloc(frames, GFP_KERNEL);
 	if (!pkt->w_bio)
 		goto no_bio;
-	bio_init(pkt->w_bio, NULL, pkt->w_bio->bi_inline_vecs, frames, 0);
 
 	for (i = 0; i < frames / FRAMES_PER_PAGE; i++) {
 		pkt->pages[i] = alloc_page(GFP_KERNEL|__GFP_ZERO);
@@ -537,26 +536,20 @@ static struct packet_data *pkt_alloc_packet_data(int frames)
 	bio_list_init(&pkt->orig_bios);
 
 	for (i = 0; i < frames; i++) {
-		struct bio *bio = bio_kmalloc(1, GFP_KERNEL);
-		if (!bio)
+		pkt->r_bios[i] = bio_kmalloc(1, GFP_KERNEL);
+		if (!pkt->r_bios[i])
 			goto no_rd_bio;
-		bio_init(bio, NULL, bio->bi_inline_vecs, 1, 0);
-		pkt->r_bios[i] = bio;
 	}
 
 	return pkt;
 
 no_rd_bio:
-	for (i = 0; i < frames; i++) {
-		if (pkt->r_bios[i])
-			bio_uninit(pkt->r_bios[i]);
+	for (i = 0; i < frames; i++)
 		kfree(pkt->r_bios[i]);
-	}
 no_page:
 	for (i = 0; i < frames / FRAMES_PER_PAGE; i++)
 		if (pkt->pages[i])
 			__free_page(pkt->pages[i]);
-	bio_uninit(pkt->w_bio);
 	kfree(pkt->w_bio);
 no_bio:
 	kfree(pkt);
@@ -571,13 +564,10 @@ static void pkt_free_packet_data(struct packet_data *pkt)
 {
 	int i;
 
-	for (i = 0; i < pkt->frames; i++) {
-		bio_uninit(pkt->r_bios[i]);
+	for (i = 0; i < pkt->frames; i++)
 		kfree(pkt->r_bios[i]);
-	}
 	for (i = 0; i < pkt->frames / FRAMES_PER_PAGE; i++)
 		__free_page(pkt->pages[i]);
-	bio_uninit(pkt->w_bio);
 	kfree(pkt->w_bio);
 	kfree(pkt);
 }
@@ -950,6 +940,7 @@ static void pkt_end_io_read(struct bio *bio)
 
 	if (bio->bi_status)
 		atomic_inc(&pkt->io_errors);
+	bio_uninit(bio);
 	if (atomic_dec_and_test(&pkt->io_wait)) {
 		atomic_inc(&pkt->run_sm);
 		wake_up(&pd->wqueue);
@@ -967,6 +958,7 @@ static void pkt_end_io_packet_write(struct bio *bio)
 
 	pd->stats.pkt_ended++;
 
+	bio_uninit(bio);
 	pkt_bio_finished(pd);
 	atomic_dec(&pkt->io_wait);
 	atomic_inc(&pkt->run_sm);
@@ -1021,7 +1013,7 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
 			continue;
 
 		bio = pkt->r_bios[f];
-		bio_reset(bio, pd->bdev, REQ_OP_READ);
+		bio_init(bio, pd->bdev, bio->bi_inline_vecs, 1, REQ_OP_READ);
 		bio->bi_iter.bi_sector = pkt->sector + f * (CD_FRAMESIZE >> 9);
 		bio->bi_end_io = pkt_end_io_read;
 		bio->bi_private = pkt;
@@ -1234,7 +1226,8 @@ static void pkt_start_write(struct pktcdvd_device *pd, struct packet_data *pkt)
 {
 	int f;
 
-	bio_reset(pkt->w_bio, pd->bdev, REQ_OP_WRITE);
+	bio_init(pkt->w_bio, pd->bdev, pkt->w_bio->bi_inline_vecs, pkt->frames,
+		 REQ_OP_WRITE);
 	pkt->w_bio->bi_iter.bi_sector = pkt->sector;
 	pkt->w_bio->bi_end_io = pkt_end_io_packet_write;
 	pkt->w_bio->bi_private = pkt;
-- 
2.30.2

