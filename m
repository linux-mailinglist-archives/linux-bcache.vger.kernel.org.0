Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8EE2CA8E3
	for <lists+linux-bcache@lfdr.de>; Tue,  1 Dec 2020 17:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391990AbgLAQzR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 1 Dec 2020 11:55:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390685AbgLAQzP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 1 Dec 2020 11:55:15 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90151C0617A6;
        Tue,  1 Dec 2020 08:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=IVAiR/5EBbH9VxN9lxbQLCTkk81ZOuRFYA9YZtOf8x4=; b=MEEeMs+IN9pux7xZMfswtKb/lc
        ynLY06460gePuqWvpWslMSJ/yrHuBTYTFx3TrLjpHq4ddp/sWzp+T1TUcVQlpEy/QPrIHMv7WOrIO
        nZRGl5RXd24KXaBhAHfkr0F7LzvXlFuuv91HSG3c0bIEvEtzMWmbsRGO1ZdMWFD4TOX1gcyFihtck
        nrV0cSiYwwXvxHmwwGo+mbYqkXz3/TXz3BkWLZBuV5er/4h2TYiBbREubCBy8AamDQHpSwHWwWefy
        KaKIdA/THuw0ASwg2bwu05OfOwktwFFKgx3QR+RJo7vkWmkzAqhFeVEmNuaGsmcxAVKixgnSFiecO
        f8Rqfh4A==;
Received: from [2001:4bb8:184:6389:bbd8:a1c2:99e0:f58a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kk8v6-0005Z2-1u; Tue, 01 Dec 2020 16:54:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 2/9] dcssblk: remove the end of device check in brd_do_bvec
Date:   Tue,  1 Dec 2020 17:54:17 +0100
Message-Id: <20201201165424.2030647-3-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201165424.2030647-1-hch@lst.de>
References: <20201201165424.2030647-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The block layer already checks for this conditions in bio_check_eod
before calling the driver.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/s390/block/dcssblk.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 299e77ec2c4163..5c5cff3f237452 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -886,10 +886,6 @@ dcssblk_submit_bio(struct bio *bio)
 	    (bio->bi_iter.bi_size & 4095) != 0)
 		/* Request is not page-aligned. */
 		goto fail;
-	if (bio_end_sector(bio) > get_capacity(bio->bi_disk)) {
-		/* Request beyond end of DCSS segment. */
-		goto fail;
-	}
 	/* verify data transfer direction */
 	if (dev_info->is_shared) {
 		switch (dev_info->segment_type) {
-- 
2.29.2

