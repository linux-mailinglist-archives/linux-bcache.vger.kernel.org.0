Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B038E1CB4AD
	for <lists+linux-bcache@lfdr.de>; Fri,  8 May 2020 18:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgEHQPn (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 8 May 2020 12:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728303AbgEHQPm (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 8 May 2020 12:15:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E5AC05BD43;
        Fri,  8 May 2020 09:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=HlFUrIsXXrT3FGrj+t+2DKf1Ayrd2rUUKJZx0tnooCU=; b=EQcZ9lcqIhWgf/a/iJ5DwA6Sha
        gf5uSVNmMUlw/jcl7YXUEXqIvr35+7/BPF/sSeZgUIasRrdGT3lJKB2He50QRRCKRH1dLZmua8m6U
        8QtgqejzYZhRdvlnGTbjG43/Hdnmr/yTsWBMA+jTTsVn4N24woLZ6Vc2MiSoaJ6sHFGYy75Q9VGfN
        agxyJrMo1YhMzpkn3R/wcC/3D+Pp4oswvBfwzZcGpq5Lolc/Gj3m19SLY3qHxMmkDg9TLYsrGfJkl
        vvKoXFnApy0vHbmezAu7Iygy0vujNJDawqRbRhk+sJ6Cjd9r0hMZsACikt79mNY0/96JbqiHoHGTh
        wQoQLnog==;
Received: from [2001:4bb8:180:9d3f:90d7:9df8:7cd:3504] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jX5ex-0004dV-CD; Fri, 08 May 2020 16:15:36 +0000
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
Subject: [PATCH 05/15] ps3vram: stop using ->queuedata
Date:   Fri,  8 May 2020 18:15:07 +0200
Message-Id: <20200508161517.252308-6-hch@lst.de>
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
 drivers/block/ps3vram.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index 821d4d8b1d763..5a1d1d137c724 100644
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

