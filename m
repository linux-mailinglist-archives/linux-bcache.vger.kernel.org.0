Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5218B21073A
	for <lists+linux-bcache@lfdr.de>; Wed,  1 Jul 2020 11:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgGAJBk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 1 Jul 2020 05:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729080AbgGAI77 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Jul 2020 04:59:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2919EC03E979;
        Wed,  1 Jul 2020 01:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=x/Lapiju/RCIeWIuz3o8sd6pkgFSKFSdWu2H7EUGYIE=; b=cUbn7Pxl3iVIktS63nJOjTDhdj
        CfyO1exZuxlh1JTjnZcHfOk9yHVqjEWcViE8zZCbBBD3GXQYi/MTmpBuPjUDMw2Wa4XSvPxrryj3s
        +6nt9I1whJaM+9EbgTix65yH/OCDuOmII1bxFx0Ld/UtuF3OaOm1ahW7UrzPmD0YIS6pu26Vo9qw+
        sQt0dJJFtA9hIqHf4548XR65FQ6n+eFn7Og7Ox2Pi9nK2nV7JLpXxh+QjwclNNOIZAwkU8zAUi1qk
        KhPBZghQeL9IpqMWdpQXiMIordOsXNOIW5luE/k8g8DuBcRRZebGPUK43sxdftZJI1Woo/J9tAeLJ
        R/Y4MCfQ==;
Received: from [2001:4bb8:184:76e3:ea38:596b:3e9e:422a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqYay-000882-6q; Wed, 01 Jul 2020 08:59:56 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
        drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org
Subject: [PATCH 05/20] ps3vram: stop using ->queuedata
Date:   Wed,  1 Jul 2020 10:59:32 +0200
Message-Id: <20200701085947.3354405-6-hch@lst.de>
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
 drivers/block/ps3vram.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index 821d4d8b1d763e..5a1d1d137c7248 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -587,7 +587,7 @@ static struct bio *ps3vram_do_bio(struct ps3_system_bus_device *dev,
 
 static blk_qc_t ps3vram_make_request(struct request_queue *q, struct bio *bio)
 {
-	struct ps3_system_bus_device *dev = q->queuedata;
+	struct ps3_system_bus_device *dev = bio->bi_disk->private_data;
 	struct ps3vram_priv *priv = ps3_system_bus_get_drvdata(dev);
 	int busy;
 
@@ -745,7 +745,6 @@ static int ps3vram_probe(struct ps3_system_bus_device *dev)
 	}
 
 	priv->queue = queue;
-	queue->queuedata = dev;
 	blk_queue_max_segments(queue, BLK_MAX_SEGMENTS);
 	blk_queue_max_segment_size(queue, BLK_MAX_SEGMENT_SIZE);
 	blk_queue_max_hw_sectors(queue, BLK_SAFE_MAX_SECTORS);
-- 
2.26.2

