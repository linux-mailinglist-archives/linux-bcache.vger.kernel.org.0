Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6A9195302
	for <lists+linux-bcache@lfdr.de>; Fri, 27 Mar 2020 09:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgC0Ies (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 Mar 2020 04:34:48 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58258 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbgC0Ies (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Mar 2020 04:34:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Jt9i1NsLFjDZFicQmyR2ncTTXuWWfB02Jo58bbAb1Wc=; b=EBSuJkz3JlVPGFXjTM22rg8f9T
        XImg++ZOd6t1A37PkQ7DosivXOLwTtbYoNzHtil25I6xs/B6CBMSD2XBQq3dU5tfNpk8KAMkOqQJx
        GhPhJFfOdjLxDJb9qltBXKmuEOPj9JlD962v1xdopqb4SvE1jsJKasyJdp0VGw+NsXDvxKcFhnaaf
        h4iHeiuex6OTuAqtrdItuX7Xzsib/FM6Ruws3Wg44dbKCn8TK8681rTMh9gDNBj9NCItD0oRKJgoG
        eOvR0EimzKrOK1x14EiL7j+la9W1X8IQabrwg6UdyOWypuZ8tdJy1WofQVX5bJnq5vYL4VPEyCE8g
        o3ZARsgg==;
Received: from [2001:4bb8:18c:2a9e:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHkS0-0007tH-17; Fri, 27 Mar 2020 08:34:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 5/5] Revert "blkdev: check for valid request queue before issuing flush"
Date:   Fri, 27 Mar 2020 09:30:12 +0100
Message-Id: <20200327083012.1618778-6-hch@lst.de>
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

This reverts commit f10d9f617a65905c556c3b37c9b9646ae7d04ed7.

We can't have queues without a make_request_fn any more (and the
loop device uses blk-mq these days anyway..).

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-flush.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 843d25683691..c7f396e3d5e2 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -454,15 +454,6 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 	if (!q)
 		return -ENXIO;
 
-	/*
-	 * some block devices may not have their queue correctly set up here
-	 * (e.g. loop device without a backing file) and so issuing a flush
-	 * here will panic. Ensure there is a request function before issuing
-	 * the flush.
-	 */
-	if (!q->make_request_fn)
-		return -ENXIO;
-
 	bio = bio_alloc(gfp_mask, 0);
 	bio_set_dev(bio, bdev);
 	bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
-- 
2.25.1

