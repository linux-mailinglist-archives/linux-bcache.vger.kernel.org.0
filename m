Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBA2210733
	for <lists+linux-bcache@lfdr.de>; Wed,  1 Jul 2020 11:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbgGAJB0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 1 Jul 2020 05:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729125AbgGAJAE (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Jul 2020 05:00:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC54C061755;
        Wed,  1 Jul 2020 02:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=t6BqkN6Yxn/8o7GWQerTXSXZiT8M8tft7EnhoW3IIiE=; b=hAcTP892NCCovzX2RpSmkixMog
        HbSnGhzmiEi7CnPF5n2sxdgakapG2OHqqw5H6XKqc+ghl6qYzfNMLDnMaO1cBG69NDChGRSYU+UOH
        hQeiL/X6/qDLMAZoZHKVKkAKNRq83YhtRRPLSYV7C+e3TxLyt4WbCjNMs1CVf+mzmrs6yA0IRGK/a
        68kq/4RTXTzlT/aia1gZYh618fXe7Lfwpp2DSJuejMw4sErcKJz3WQY2UbphgLA0imC8+URm/7LX4
        1GYzzIg3zotDYqxd8qFVl4y4yd3DRKsYQunww+RsVy9GpkXOhrWRpW52iSzbH5TZxIHTdqsBscTPV
        u324UHxA==;
Received: from [2001:4bb8:184:76e3:ea38:596b:3e9e:422a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqYb2-00089D-BO; Wed, 01 Jul 2020 09:00:00 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
        drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org
Subject: [PATCH 08/20] zram: stop using ->queuedata
Date:   Wed,  1 Jul 2020 10:59:35 +0200
Message-Id: <20200701085947.3354405-9-hch@lst.de>
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

Instead of setting up the queuedata as well just use one private data
field.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/zram/zram_drv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 6e2ad90b17a376..0564e3f384089e 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1586,7 +1586,7 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
  */
 static blk_qc_t zram_make_request(struct request_queue *queue, struct bio *bio)
 {
-	struct zram *zram = queue->queuedata;
+	struct zram *zram = bio->bi_disk->private_data;
 
 	if (!valid_io_request(zram, bio->bi_iter.bi_sector,
 					bio->bi_iter.bi_size)) {
@@ -1912,7 +1912,6 @@ static int zram_add(void)
 	zram->disk->first_minor = device_id;
 	zram->disk->fops = &zram_devops;
 	zram->disk->queue = queue;
-	zram->disk->queue->queuedata = zram;
 	zram->disk->private_data = zram;
 	snprintf(zram->disk->disk_name, 16, "zram%d", device_id);
 
-- 
2.26.2

