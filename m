Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8080D1E37FF
	for <lists+linux-bcache@lfdr.de>; Wed, 27 May 2020 07:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729010AbgE0FYt (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 27 May 2020 01:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728990AbgE0FYm (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 May 2020 01:24:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0253C03E96E;
        Tue, 26 May 2020 22:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=vFOxaeomnXbJ8W08WAqr52lHk9RJsAZ/1N3x9Xkju10=; b=OhTmjQSRXVaxotYxGsOXSMHrQC
        amZN/Dp3D9XGupkYbCp1d9amADvB7j8K16cmCS/ZwM10M9U4hHXJxdCHCwWzOwiiXzsl3lMBrPUnB
        KPFAX6IE+Bqk2Sk3s1RJXUVzXR+iGPbtFC4DQwSMrrF+2BzArKyrjspmjB41GZ0DSyHvL62KbYhy7
        8auUOJ0kW4ayFuHzKvodYui/yG6Kd2FTIMPuxZeKTLhpNHxc44kpLAErS4FPlGc/NDYSP1fr2XzEY
        WVa8w2i1LCBGZhYK0djo3Ca6ifRi/SoC4tR+8CmE/HwU913N5aDuwK1AXwXG+oLebgQVcmqgm+qYV
        4kA00gHA==;
Received: from [2001:4bb8:18c:5da7:8164:affc:3c20:853d] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jdoYQ-0000oi-QS; Wed, 27 May 2020 05:24:39 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
        linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/16] dm: use bio_{start,end}_io_acct
Date:   Wed, 27 May 2020 07:24:09 +0200
Message-Id: <20200527052419.403583-7-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527052419.403583-1-hch@lst.de>
References: <20200527052419.403583-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Switch dm to use the nicer bio accounting helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 drivers/md/dm.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f215b86664484..3f39fa1ac756e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -681,11 +681,7 @@ static void start_io_acct(struct dm_io *io)
 	struct mapped_device *md = io->md;
 	struct bio *bio = io->orig_bio;
 
-	io->start_time = jiffies;
-
-	generic_start_io_acct(md->queue, bio_op(bio), bio_sectors(bio),
-			      &dm_disk(md)->part0);
-
+	io->start_time = bio_start_io_acct(bio);
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
 				    bio->bi_iter.bi_sector, bio_sectors(bio),
@@ -698,8 +694,7 @@ static void end_io_acct(struct dm_io *io)
 	struct bio *bio = io->orig_bio;
 	unsigned long duration = jiffies - io->start_time;
 
-	generic_end_io_acct(md->queue, bio_op(bio), &dm_disk(md)->part0,
-			    io->start_time);
+	bio_end_io_acct(bio, io->start_time);
 
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
-- 
2.26.2

