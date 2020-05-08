Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1EC41CB484
	for <lists+linux-bcache@lfdr.de>; Fri,  8 May 2020 18:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgEHQPd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 8 May 2020 12:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728303AbgEHQPc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 8 May 2020 12:15:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A062C061A0C;
        Fri,  8 May 2020 09:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=+w3aKUmo+E4cbsZchg/SnVwLEhA0lhm/Wi56atvtt5I=; b=HwTEnunIUALPlgY76Kl8id0RPA
        UWr36N9mJr1n+MMnNfktvvNowAGBoDXkgJhz8sx8z3xrPZ6azYSBKdeaAKjZHZjgl9rypLB4D3sxQ
        WN9f/z0r3zUCkPBaX0lKBJ9SoFlPcJkNznFOQc+koJmz52sZ4zcS92i7iq/0Yg6zrLw28uZXWngDj
        8BX2u0vlQWCO/A0xMoHk3gyigAudO0kqJp8olAEZC7yCOfzuEBmJIALvHoR/ScznvwrgWiJ8XPUXJ
        O82v/E/V5FG5gZ8g9SJ/VwMQN+vlXbBQR5jjrY6BxXz7grNbuqIyG94WsD9WkHaJHYWhAUMqPFMP9
        GhVTVOOg==;
Received: from [2001:4bb8:180:9d3f:90d7:9df8:7cd:3504] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jX5ek-0004NS-RK; Fri, 08 May 2020 16:15:23 +0000
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
Subject: [PATCH 01/15] nfblock: use gendisk private_data
Date:   Fri,  8 May 2020 18:15:03 +0200
Message-Id: <20200508161517.252308-2-hch@lst.de>
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
 arch/m68k/emu/nfblock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/emu/nfblock.c b/arch/m68k/emu/nfblock.c
index c3a630440512e..5c6f04b00e866 100644
--- a/arch/m68k/emu/nfblock.c
+++ b/arch/m68k/emu/nfblock.c
@@ -61,7 +61,7 @@ struct nfhd_device {
 
 static blk_qc_t nfhd_make_request(struct request_queue *queue, struct bio *bio)
 {
-	struct nfhd_device *dev = queue->queuedata;
+	struct nfhd_device *dev = bio->bi_disk->private_data;
 	struct bio_vec bvec;
 	struct bvec_iter iter;
 	int dir, len, shift;
@@ -122,7 +122,6 @@ static int __init nfhd_init_one(int id, u32 blocks, u32 bsize)
 	if (dev->queue == NULL)
 		goto free_dev;
 
-	dev->queue->queuedata = dev;
 	blk_queue_logical_block_size(dev->queue, bsize);
 
 	dev->disk = alloc_disk(16);
@@ -136,6 +135,7 @@ static int __init nfhd_init_one(int id, u32 blocks, u32 bsize)
 	sprintf(dev->disk->disk_name, "nfhd%u", dev_id);
 	set_capacity(dev->disk, (sector_t)blocks * (bsize / 512));
 	dev->disk->queue = dev->queue;
+	dev->disk->private_data = dev;
 
 	add_disk(dev->disk);
 
-- 
2.26.2

