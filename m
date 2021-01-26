Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25CA30408F
	for <lists+linux-bcache@lfdr.de>; Tue, 26 Jan 2021 15:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405921AbhAZOib (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 26 Jan 2021 09:38:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405909AbhAZOh5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 26 Jan 2021 09:37:57 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452BDC0611BD;
        Tue, 26 Jan 2021 06:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=2XqxOZtHM5Bw3MRdYJR44mpyg5vHzYUaISWk2JVAadc=; b=edrJAdJuPY6f6qVPJO4fPTtVAX
        iMRzc0A+vsa3NTAFYev7OmOY7x/E+P9UHYBInZlxwfF+EBNsvbnmn9tf4WQPAufCPbH7rZZnlL7hY
        TUeviDNB5qbrRbIxoFaukOhCRra93/besKn1YtVMHtXkCnzAczbRJVsi9kxZb2A6zHWZWNz+Oxpg0
        G0AVtYRsexRC2I6frlCUwMxznPmpGRqgV0MUeIi6JB5uce57AAmjBls4yBJNQW/PVL7eJtXRgDygM
        kcS6hKjuc/axg0POGV6FZKmqSMx0LsWogSMRvCMHl6s2th3Uph1VeDgLRTWYNCWuhadNK/ZtYyY5A
        nNPdeXjQ==;
Received: from [2001:4bb8:191:e347:5918:ac86:61cb:8801] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l4PRk-005kQp-5o; Tue, 26 Jan 2021 14:36:14 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-bcache@vger.kernel.org
Subject: [PATCH 2/3] bcache: use bio_set_dev to assign ->bi_bdev
Date:   Tue, 26 Jan 2021 15:33:07 +0100
Message-Id: <20210126143308.1960860-3-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126143308.1960860-1-hch@lst.de>
References: <20210126143308.1960860-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Always use the bio_set_dev helper to assign ->bi_bdev to make sure
other state related to the device is uptodate.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 058dd80144281e..63e809f38e3f51 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -114,7 +114,7 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
 	check = bio_kmalloc(GFP_NOIO, bio_segments(bio));
 	if (!check)
 		return;
-	check->bi_bdev = bio->bi_bdev;
+	bio_set_dev(check, bio->bi_bdev);
 	check->bi_opf = REQ_OP_READ;
 	check->bi_iter.bi_sector = bio->bi_iter.bi_sector;
 	check->bi_iter.bi_size = bio->bi_iter.bi_size;
-- 
2.29.2

