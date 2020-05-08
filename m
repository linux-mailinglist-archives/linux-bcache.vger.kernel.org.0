Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04641CB4AF
	for <lists+linux-bcache@lfdr.de>; Fri,  8 May 2020 18:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbgEHQPo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 8 May 2020 12:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbgEHQPj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 8 May 2020 12:15:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B4FC061A0C;
        Fri,  8 May 2020 09:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=JJDsTQG2WuX2Hfjn7XLSnlrlNtlau+gOH2Oma/tnLmg=; b=D3QjHEC4QJz4rkREwbiLAaUYFw
        6DTHKw4J1ct6q1i+SlnGr1Toj6g6jVpVNOjnmLPj0MkWzavfgntJOJbl4jEh9H12NJTT3Snf9hAC7
        12WxL2XlMs0viOn+Bc6uOChJ8EKgZVRZzrnATqxfwnKW3NRter37n8zs85SYQrd15nHboM80VT+OE
        UsQw5x5qgqT6lNUFzQElkLspTSizqyVq9MnEthzp8w3miwhhpOu9U85IFAYW/C/dRSBTAZ7q/2X1f
        PRUs9FVyRvt39ZuANXMVUgSfFX5eVZEW3/+1dmIEjAGDBO8Pu1HHKU8j3xy8Q4Gr1ayfbPa3VHlQz
        2iHjjsGw==;
Received: from [2001:4bb8:180:9d3f:90d7:9df8:7cd:3504] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jX5eu-0004bZ-JJ; Fri, 08 May 2020 16:15:33 +0000
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
Subject: [PATCH 04/15] null_blk: stop using ->queuedata for bio mode
Date:   Fri,  8 May 2020 18:15:06 +0200
Message-Id: <20200508161517.252308-5-hch@lst.de>
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
 drivers/block/null_blk_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index 8efd8778e2095..d14df79feca89 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -1365,7 +1365,7 @@ static blk_qc_t null_queue_bio(struct request_queue *q, struct bio *bio)
 {
 	sector_t sector = bio->bi_iter.bi_sector;
 	sector_t nr_sectors = bio_sectors(bio);
-	struct nullb *nullb = q->queuedata;
+	struct nullb *nullb = bio->bi_disk->private_data;
 	struct nullb_queue *nq = nullb_to_queue(nullb);
 	struct nullb_cmd *cmd;
 
-- 
2.26.2

