Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24BE20D9BD
	for <lists+linux-bcache@lfdr.de>; Mon, 29 Jun 2020 22:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgF2Tu2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 29 Jun 2020 15:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387739AbgF2Tkf (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:35 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD21FC08C5DB;
        Mon, 29 Jun 2020 12:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=MVPFkWqT27H+EK/gr/8Zgz6Ls+wUfbhG+l5NiS06UDM=; b=cWpKHTPUn3rA32xoo333LDplGG
        /0xAWYcWkkFDjIBXGHO+45kIoIvtpWwTdJKbTnhm3os86dmo4mBSUI/NlHDdmV2gaqavEMZMtq3gr
        M3snlpc+56l3kOCu7MnQN7N8WQWb3nphprLavnWPrBA4mxdkJSQ8Tut/tMvH3ls/uG8kN7J9CITXs
        A7iClohCANn04aASv5Pb/v3HjCVtqEJIIyqmnMeFPQEhuHkV0uuQWfF7wIH1afLqTWPS6uIq2i+kb
        8Tr2FGLqiWdoGJayxvKNyukUZkTuV8pg9R5jKUz7TmEOASWR1oATE02aF8Ax3xwDPyvtVg3FdUUNQ
        Bmg5Q2MA==;
Received: from [2001:4bb8:184:76e3:fcca:c8dc:a4bf:12fa] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jpzdY-0004MD-RU; Mon, 29 Jun 2020 19:40:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
        drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org
Subject: [PATCH 15/20] block: remove the nr_sectors variable in generic_make_request_checks
Date:   Mon, 29 Jun 2020 21:39:42 +0200
Message-Id: <20200629193947.2705954-16-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200629193947.2705954-1-hch@lst.de>
References: <20200629193947.2705954-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The variable is only used once, so just open code the bio_sector()
there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 37435d0d433564..28f60985dc75cc 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -974,7 +974,6 @@ static noinline_for_stack bool
 generic_make_request_checks(struct bio *bio)
 {
 	struct request_queue *q = bio->bi_disk->queue;
-	int nr_sectors = bio_sectors(bio);
 	blk_status_t status = BLK_STS_IOERR;
 
 	might_sleep();
@@ -1007,7 +1006,7 @@ generic_make_request_checks(struct bio *bio)
 	if (op_is_flush(bio->bi_opf) &&
 	    !test_bit(QUEUE_FLAG_WC, &q->queue_flags)) {
 		bio->bi_opf &= ~(REQ_PREFLUSH | REQ_FUA);
-		if (!nr_sectors) {
+		if (!bio_sectors(bio)) {
 			status = BLK_STS_OK;
 			goto end_io;
 		}
-- 
2.26.2

