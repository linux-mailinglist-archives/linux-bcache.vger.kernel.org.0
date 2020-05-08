Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1B71CB499
	for <lists+linux-bcache@lfdr.de>; Fri,  8 May 2020 18:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728509AbgEHQQD (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 8 May 2020 12:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728501AbgEHQQC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 8 May 2020 12:16:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02175C061A0C;
        Fri,  8 May 2020 09:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=reoioN+SzUTCBcbV1XFXAraZxNdP1dP6cCeZt13G6tA=; b=fK2aBIt0vzlaWJtBvexdAvJMAe
        S6cYDoV3UE72OWzzPYY4edNpTfoOTq7IOZGfcsghCdgzVFGyK0VVaSUDHuAlolBqdDM4GeAktdy5p
        bu9ycf3ZbUnayKti5+mUhsIpbtX7ZBNtsu4urRUK3quNTS59x8GSvPOos6l115fjOKLGtS2IXMfeg
        nOY4PMbqzyodo8tx0Pwr/3ViI5fQ9jWmIYNPMIaHCNMLcBLeNywPpwUc+3nHx4Htb5rL5g99NAouU
        lhjL0sTDMnJP5/r3qy8gYL8e8SMtdvgE8S2GdEPFK/RtT/8JZxdKTgVOabQ4uZ6GSFIOTjZK90dkg
        YgZr48QA==;
Received: from [2001:4bb8:180:9d3f:90d7:9df8:7cd:3504] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jX5fJ-0004mp-7m; Fri, 08 May 2020 16:15:57 +0000
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
Subject: [PATCH 12/15] md: stop using ->queuedata
Date:   Fri,  8 May 2020 18:15:14 +0200
Message-Id: <20200508161517.252308-13-hch@lst.de>
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
 drivers/md/md.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 271e8a5873549..c079ecf77c564 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -466,7 +466,7 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
 {
 	const int rw = bio_data_dir(bio);
 	const int sgrp = op_stat_group(bio_op(bio));
-	struct mddev *mddev = q->queuedata;
+	struct mddev *mddev = bio->bi_disk->private_data;
 	unsigned int sectors;
 
 	if (unlikely(test_bit(MD_BROKEN, &mddev->flags)) && (rw == WRITE)) {
@@ -5626,7 +5626,6 @@ static int md_alloc(dev_t dev, char *name)
 	mddev->queue = blk_alloc_queue(md_make_request, NUMA_NO_NODE);
 	if (!mddev->queue)
 		goto abort;
-	mddev->queue->queuedata = mddev;
 
 	blk_set_stacking_limits(&mddev->queue->limits);
 
-- 
2.26.2

