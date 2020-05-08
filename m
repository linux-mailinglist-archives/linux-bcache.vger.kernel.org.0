Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7DFC1CB4AB
	for <lists+linux-bcache@lfdr.de>; Fri,  8 May 2020 18:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbgEHQPc (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 8 May 2020 12:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727105AbgEHQPb (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 8 May 2020 12:15:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F70C061A0C;
        Fri,  8 May 2020 09:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=qdYWLNhq6AYzQRc2x28TBNIUBfuKUw2o/UwXGfr0pxM=; b=oGeRkJlPxCrwCXqudpdswPTJw4
        /7Ft+aEzCwiGSaMG2qWCqHijVBZPCn+IfXnlhUF+wo7lPFJ4m99u6S66QoPK6k7W700TOXtaBqwVC
        HLubG1RPmdNbx51WdW3dp9myMyflbkJ4QrSTpNsQLVlgYLqJx0DdeBqjeV5i5p6DlslfzweATAKwZ
        p6drssAMDn7pmbyUv2tH+tczcsE3UxC/UkqVlkUyHRiWQzYMxgpR7HJbCMm5Hsxjngd4kYXgkm5EC
        zihUFUpaL4QtulvwqKjA0+0XnD7lTYIFapYgOPJKhawbF/AOJmNqgBhlfdN6rTEjVDN0iAr987svI
        3YvFd1Sg==;
Received: from [2001:4bb8:180:9d3f:90d7:9df8:7cd:3504] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jX5en-0004Ry-OW; Fri, 08 May 2020 16:15:26 +0000
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
Subject: [PATCH 02/15] simdisk: stop using ->queuedata
Date:   Fri,  8 May 2020 18:15:04 +0200
Message-Id: <20200508161517.252308-3-hch@lst.de>
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
 arch/xtensa/platforms/iss/simdisk.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/xtensa/platforms/iss/simdisk.c b/arch/xtensa/platforms/iss/simdisk.c
index 49322b66cda93..31b5020077a05 100644
--- a/arch/xtensa/platforms/iss/simdisk.c
+++ b/arch/xtensa/platforms/iss/simdisk.c
@@ -103,7 +103,7 @@ static void simdisk_transfer(struct simdisk *dev, unsigned long sector,
 
 static blk_qc_t simdisk_make_request(struct request_queue *q, struct bio *bio)
 {
-	struct simdisk *dev = q->queuedata;
+	struct simdisk *dev = bio->bi_disk->private_data;
 	struct bio_vec bvec;
 	struct bvec_iter iter;
 	sector_t sector = bio->bi_iter.bi_sector;
@@ -273,8 +273,6 @@ static int __init simdisk_setup(struct simdisk *dev, int which,
 		goto out_alloc_queue;
 	}
 
-	dev->queue->queuedata = dev;
-
 	dev->gd = alloc_disk(SIMDISK_MINORS);
 	if (dev->gd == NULL) {
 		pr_err("alloc_disk failed\n");
-- 
2.26.2

