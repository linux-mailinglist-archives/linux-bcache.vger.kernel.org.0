Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6FC2106EE
	for <lists+linux-bcache@lfdr.de>; Wed,  1 Jul 2020 11:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729231AbgGAJAS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 1 Jul 2020 05:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729167AbgGAJAO (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Jul 2020 05:00:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADFAC061755;
        Wed,  1 Jul 2020 02:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=llOojDD3lqJfk9XWeWL9pqlJf45UocCmu2uEUE0dVqA=; b=pGlUJrbOxh0JwXeTwQoJpYf2F/
        Wj1CCsNV+D84p9IQoC65j7VZnlNqsrYsLYThDSTFAmKMsEUR9St/lgE0ZmSPIQQCuP7dgvSl2ZuCN
        qmHjB/58qr1vtBaiVphQaEP9vrD2GonVUZUsFfMDwdCYWZmTuiqkDgguyEU9GJPldWF1NUiFWd5Tm
        PuuqBh6fEuRMCrVHN8SIXYmkZ8bhrPxFnV6RVSwro1PKig0pS+Kd1OL4Q1S+1+uAY1tH2+UawdfXw
        RbbQhCUERQ3oGJvZGCbwR4bKQ7UF6Akd/eN6H9X2jHLGH0eeFYrqjDeKzOU7MKgBYWr9GW+QGURtd
        0nPrWjmA==;
Received: from [2001:4bb8:184:76e3:ea38:596b:3e9e:422a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqYbC-0008Ex-2b; Wed, 01 Jul 2020 09:00:10 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
        drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org
Subject: [PATCH 14/20] block: remove the NULL queue check in generic_make_request_checks
Date:   Wed,  1 Jul 2020 10:59:41 +0200
Message-Id: <20200701085947.3354405-15-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701085947.3354405-1-hch@lst.de>
References: <20200701085947.3354405-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

All registers disks must have a valid queue pointer, so don't bother to
log a warning for that case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 95dca74534ff73..37435d0d433564 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -973,22 +973,12 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
 static noinline_for_stack bool
 generic_make_request_checks(struct bio *bio)
 {
-	struct request_queue *q;
+	struct request_queue *q = bio->bi_disk->queue;
 	int nr_sectors = bio_sectors(bio);
 	blk_status_t status = BLK_STS_IOERR;
-	char b[BDEVNAME_SIZE];
 
 	might_sleep();
 
-	q = bio->bi_disk->queue;
-	if (unlikely(!q)) {
-		printk(KERN_ERR
-		       "generic_make_request: Trying to access "
-			"nonexistent block-device %s (%Lu)\n",
-			bio_devname(bio, b), (long long)bio->bi_iter.bi_sector);
-		goto end_io;
-	}
-
 	/*
 	 * For a REQ_NOWAIT based request, return -EOPNOTSUPP
 	 * if queue is not a request based queue.
-- 
2.26.2

