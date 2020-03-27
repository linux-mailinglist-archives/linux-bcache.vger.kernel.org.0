Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4E661952FA
	for <lists+linux-bcache@lfdr.de>; Fri, 27 Mar 2020 09:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgC0Iej (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 Mar 2020 04:34:39 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58230 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgC0Iei (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Mar 2020 04:34:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=draCaRBWqPiL4qJeKGcNAI+wVOSpvPcgOeWzZHQQqg0=; b=sOHrO1U+LiBdKsUhx1TbEJnwxp
        LwDVtGFQoyWfszbQt+8WWJE7BtHbrsVWXwA1u6gxRGLJyr1TnHlze1G8uizOFa4NluC7MKGAglTUl
        I/igpt+KsbdK4iFk2mjxWvvLTn3h8pD0Bqb7K2L37dxfSPnwXnEeFoSi2SLKcYBDWPWfKq67kQiA9
        m3M4cMYCBBDOzraI2iRPN5+4swmlkwhNGm7fcl+NTlH7pHN5+KumvQ2gAEgRkLDJNokNWWB7rbZ1q
        sWAGjZGPZCGM6lklZPUdND1ZhPKMheDpP5sGO9bhr6aWsMACZzGerLKvTl3LmI31lLiDjjtGXdL67
        j8FXFDhQ==;
Received: from 213-225-10-87.nat.highway.a1.net ([213.225.10.87] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHkRq-0007rc-88; Fri, 27 Mar 2020 08:34:38 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 1/5] block: add a blk_mq_init_queue_data helper
Date:   Fri, 27 Mar 2020 09:30:08 +0100
Message-Id: <20200327083012.1618778-2-hch@lst.de>
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

This allows a driver to pass a queuedata member before ->init_hctx is
called.  null_blk currently open codes this logic, but I'd rather have
it in the core to ease future maintainance.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c         | 10 +++++++++-
 include/linux/blk-mq.h |  2 ++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 745ec592a513..216bf62e88b6 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2724,13 +2724,15 @@ void blk_mq_release(struct request_queue *q)
 	blk_mq_sysfs_deinit(q);
 }
 
-struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
+struct request_queue *blk_mq_init_queue_data(struct blk_mq_tag_set *set,
+		void *queuedata)
 {
 	struct request_queue *uninit_q, *q;
 
 	uninit_q = blk_alloc_queue_node(GFP_KERNEL, set->numa_node);
 	if (!uninit_q)
 		return ERR_PTR(-ENOMEM);
+	uninit_q->queuedata = queuedata;
 
 	/*
 	 * Initialize the queue without an elevator. device_add_disk() will do
@@ -2742,6 +2744,12 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 
 	return q;
 }
+EXPORT_SYMBOL_GPL(blk_mq_init_queue_data);
+
+struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
+{
+	return blk_mq_init_queue_data(set, NULL);
+}
 EXPORT_SYMBOL(blk_mq_init_queue);
 
 /*
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 31344d5f83e2..f389d7c724bd 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -412,6 +412,8 @@ enum {
 		<< BLK_MQ_F_ALLOC_POLICY_START_BIT)
 
 struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *);
+struct request_queue *blk_mq_init_queue_data(struct blk_mq_tag_set *set,
+		void *queuedata);
 struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 						  struct request_queue *q,
 						  bool elevator_init);
-- 
2.25.1

