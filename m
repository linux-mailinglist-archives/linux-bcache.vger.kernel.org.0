Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E98301B05
	for <lists+linux-bcache@lfdr.de>; Sun, 24 Jan 2021 11:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbhAXKGL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 24 Jan 2021 05:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbhAXKGJ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 24 Jan 2021 05:06:09 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0363C061574;
        Sun, 24 Jan 2021 02:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=n2FZZN/iZm8LkwwLhaIyNJDcvAI4swAjjubRXsJSSw4=; b=iceyPcvqE+sR6/qCgeNY/bf/gz
        eG0a62Zz5YkiqIRfNnlqDcWvkc6nlQuWboPHrV+wIRuCYtaSu1QC3J4LmlB1nZrD5ksyCq4LKdbP7
        FdAG2vSUk3oGDisDCLjOP1OSjloCuFKxn9lxzrPrKd8m7OFO2fUjNJ9cAxTi/U2YkkPcd9Ct2OJKg
        0KD1wWIT4zwVkxd7I9PQ0+gAkqRvt4+GhNrYMaNVXtGx27dtjej4m9GUio4OsJWXWDmFZ+es+zruJ
        sbJnrmXfqt71VXvP06eLA4fsrlq9pDVd9ORrpelhsIhcz6AUNBb7BW6khQTxFzk8G5LXwJwMSHBDD
        X0za6teg==;
Received: from [2001:4bb8:188:1954:a3b3:627f:702b:2136] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l3cGU-002q7U-2G; Sun, 24 Jan 2021 10:05:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 01/10] brd: remove the end of device check in brd_do_bvec
Date:   Sun, 24 Jan 2021 11:02:32 +0100
Message-Id: <20210124100241.1167849-2-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210124100241.1167849-1-hch@lst.de>
References: <20210124100241.1167849-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The block layer already checks for this conditions in bio_check_eod
before calling the driver.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Tejun Heo <tj@kernel.org>
---
 drivers/block/brd.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index c43a6ab4b1f39f..c7c8214190795c 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -285,14 +285,10 @@ static int brd_do_bvec(struct brd_device *brd, struct page *page,
 static blk_qc_t brd_submit_bio(struct bio *bio)
 {
 	struct brd_device *brd = bio->bi_disk->private_data;
+	sector_t sector = bio->bi_iter.bi_sector;
 	struct bio_vec bvec;
-	sector_t sector;
 	struct bvec_iter iter;
 
-	sector = bio->bi_iter.bi_sector;
-	if (bio_end_sector(bio) > get_capacity(bio->bi_disk))
-		goto io_error;
-
 	bio_for_each_segment(bvec, bio, iter) {
 		unsigned int len = bvec.bv_len;
 		int err;
-- 
2.29.2

