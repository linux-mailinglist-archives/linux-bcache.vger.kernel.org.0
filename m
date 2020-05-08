Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4521CB4C9
	for <lists+linux-bcache@lfdr.de>; Fri,  8 May 2020 18:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbgEHQQj (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 8 May 2020 12:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728485AbgEHQP6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 8 May 2020 12:15:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895F5C061A0C;
        Fri,  8 May 2020 09:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=j5nrzAlvNQFEC2KON7qkpQkXIXdfboSiMBR3IvqeqYg=; b=MZaYZgws8RyRNk7JmFkevJM5QG
        XkP/5QQ+KcB03US1KdXYdVY4JWMd45+cQiqhbpJ2aisOmBp9lOOd4kfjkyTkjQwbZkkZrq450qSNz
        0y+mklGTu6scOtDYJLkdl7wTCN9XMTxpbIQBHXEJpAvwuhpuK2AAll78bcBvs+NRHP1WHn24osKJD
        +hBLRYfPBBwcRMGtWvC/ZB/eiukX+tAZRYobW/Vc17N2qUlFsAfCNtu1m53RPB6+kmGJVLmIZUBJa
        rOfp4vdPLFhYMyKQ5cFw70aiKXFCl3jZXbIboLehfTk7XajvhEJiY/3q4vycGCJ2WbOoWFzQnh9zZ
        x80RGkzQ==;
Received: from [2001:4bb8:180:9d3f:90d7:9df8:7cd:3504] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jX5fG-0004lz-8s; Fri, 08 May 2020 16:15:54 +0000
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
Subject: [PATCH 11/15] dm: stop using ->queuedata
Date:   Fri,  8 May 2020 18:15:13 +0200
Message-Id: <20200508161517.252308-12-hch@lst.de>
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
 drivers/md/dm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 0eb93da44ea2a..2aaae6c1ed312 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1783,7 +1783,7 @@ static blk_qc_t dm_process_bio(struct mapped_device *md,
 
 static blk_qc_t dm_make_request(struct request_queue *q, struct bio *bio)
 {
-	struct mapped_device *md = q->queuedata;
+	struct mapped_device *md = bio->bi_disk->private_data;
 	blk_qc_t ret = BLK_QC_T_NONE;
 	int srcu_idx;
 	struct dm_table *map;
@@ -1980,7 +1980,6 @@ static struct mapped_device *alloc_dev(int minor)
 	md->queue = blk_alloc_queue(dm_make_request, numa_node_id);
 	if (!md->queue)
 		goto bad;
-	md->queue->queuedata = md;
 
 	md->disk = alloc_disk_node(1, md->numa_node_id);
 	if (!md->disk)
-- 
2.26.2

