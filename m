Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27CCB1952FC
	for <lists+linux-bcache@lfdr.de>; Fri, 27 Mar 2020 09:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbgC0Iel (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 Mar 2020 04:34:41 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58238 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbgC0Iel (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Mar 2020 04:34:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=nz27Uvmyc/vUdhbwVvwTMBXiAmjERylOb13XJg4FpTo=; b=H9tf+nUEXlnCK0KIE5JwRnZyBn
        jcaUDd0j6gJSTxxmdFurhTkzeMyjMIzNMrs9nTNB1sAA+knh0fAHA85k+eR+Hbzqhnjgucdm4cJXV
        HVUPst/Q+UKPkuuTRDCSKDzDsgHcAIQ2txeOFtjnDgh2stP/6Ikku/mrX6nPH2a6bW7mmNk6rp+99
        F6uPyY5tjoLjeN/In/UmV3r3xNbrHXMWv6ZmLCMDQuriIMghXYnJtyF4JGMTrRkrSkpPNBx1wVrQm
        zVJEI6yl6vOGZYi5do6fJdREMMhAxeX8q6p0BhNEgVNFs8/kGMU9z9mSsMERvZgwYyrorrg5XfgRG
        nT7LAbNQ==;
Received: from [2001:4bb8:18c:2a9e:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHkRs-0007s1-VN; Fri, 27 Mar 2020 08:34:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 2/5] null_blk: use blk_mq_init_queue_data
Date:   Fri, 27 Mar 2020 09:30:09 +0100
Message-Id: <20200327083012.1618778-3-hch@lst.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200327083012.1618778-1-hch@lst.de>
References: <20200327083012.1618778-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Use the new blk_mq_init_queue_data instead of open coding the queue
allocation and initialization.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/null_blk_main.c | 23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index 89bb16a99007..2f864782550d 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -1698,27 +1698,6 @@ static bool null_setup_fault(void)
 	return true;
 }
 
-/*
- * This function is identical to blk_mq_init_queue() except that it sets
- * queuedata before .init_hctx is called.
- */
-static struct request_queue *nullb_alloc_queue(struct nullb *nullb)
-{
-	struct request_queue *uninit_q, *q;
-	struct blk_mq_tag_set *set = nullb->tag_set;
-
-	uninit_q = blk_alloc_queue_node(GFP_KERNEL, set->numa_node);
-	if (!uninit_q)
-		return ERR_PTR(-ENOMEM);
-
-	uninit_q->queuedata = nullb;
-	q = blk_mq_init_allocated_queue(set, uninit_q, false);
-	if (IS_ERR(q))
-		blk_cleanup_queue(uninit_q);
-
-	return q;
-}
-
 static int null_add_dev(struct nullb_device *dev)
 {
 	struct nullb *nullb;
@@ -1758,7 +1737,7 @@ static int null_add_dev(struct nullb_device *dev)
 			goto out_cleanup_queues;
 
 		nullb->tag_set->timeout = 5 * HZ;
-		nullb->q = nullb_alloc_queue(nullb);
+		nullb->q = blk_mq_init_queue_data(nullb->tag_set, nullb);
 		if (IS_ERR(nullb->q)) {
 			rv = -ENOMEM;
 			goto out_cleanup_tags;
-- 
2.25.1

