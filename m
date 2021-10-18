Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8583431032
	for <lists+linux-bcache@lfdr.de>; Mon, 18 Oct 2021 08:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhJRGMA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 18 Oct 2021 02:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhJRGMA (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 Oct 2021 02:12:00 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05BA3C06161C
        for <linux-bcache@vger.kernel.org>; Sun, 17 Oct 2021 23:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=jtOS5hXWNS4RmaUN4KZSqNR+YdWZNoMQ7s0jog8tZ88=; b=Ra0iKky6HFPIKMq188GqNqCLSd
        0vuQZe5qMFRZkMaSSJGsIhOvLm325evHvIkMlG0RMZoCG5XtHmVESrnGWt1XBqsPa8pA7NdBoBFa8
        TkB9h9K5d+6BBxABLsQkBzGuUERZ02BJmjUrsnImQNP9i3xgVH7gxOJe+dvM4alPY/cwoJCdV8OOP
        76OAg7dwjmmknQ3fGjHFKaWyhwfddxumDb6LlthBLiJYrRfVqzXHI1x9dVCWN3XrrAJ9viumywbLH
        KLkcf1v8+mPVWwC0iH8yDLXr3Llh0WFWY+YhbHwjkOhI98DrlNuMeHHimNr5AUO9lbRXslmcN5wvP
        HBEqnN+w==;
Received: from 089144211028.atnat0020.highway.a1.net ([89.144.211.28] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mcLqH-00EHjn-8v; Mon, 18 Oct 2021 06:09:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Subject: [PATCH 3/4] bcache: use bvec_kmap_local in bch_data_verify
Date:   Mon, 18 Oct 2021 08:09:33 +0200
Message-Id: <20211018060934.1816088-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211018060934.1816088-1-hch@lst.de>
References: <20211018060934.1816088-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Using local kmaps slightly reduces the chances to stray writes, and
the bvec interface cleans up the code a little bit.

Also switch from page_address to bvec_kmap_local for cbv to be on the
safe side and to avoid pointlessly poking into bvec internals.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/debug.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index e803cad864be7..6230dfdd9286e 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -127,21 +127,20 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
 
 	citer.bi_size = UINT_MAX;
 	bio_for_each_segment(bv, bio, iter) {
-		void *p1 = kmap_atomic(bv.bv_page);
+		void *p1 = bvec_kmap_local(&bv);
 		void *p2;
 
 		cbv = bio_iter_iovec(check, citer);
-		p2 = page_address(cbv.bv_page);
+		p2 = bvec_kmap_local(&cbv);
 
-		cache_set_err_on(memcmp(p1 + bv.bv_offset,
-					p2 + bv.bv_offset,
-					bv.bv_len),
+		cache_set_err_on(memcmp(p1, p2, bv.bv_len),
 				 dc->disk.c,
 				 "verify failed at dev %pg sector %llu",
 				 dc->bdev,
 				 (uint64_t) bio->bi_iter.bi_sector);
 
-		kunmap_atomic(p1);
+		kunmap_local(p2);
+		kunmap_local(p1);
 		bio_advance_iter(check, &citer, bv.bv_len);
 	}
 
-- 
2.30.2

