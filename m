Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C470B210701
	for <lists+linux-bcache@lfdr.de>; Wed,  1 Jul 2020 11:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729281AbgGAJAZ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 1 Jul 2020 05:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729254AbgGAJAW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Jul 2020 05:00:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7179FC061755;
        Wed,  1 Jul 2020 02:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=EAMIpv1ziuqNgf5ZNOHoxjY+dqzuD4FouWA6YFyHhkE=; b=qMNQ5x4RLz46SfC5VFJYmHu5Nx
        xI0sjPMkrZu4JzWH34erLzcJLJaVi42hoTRxgTqPpAaZ10BnqAfleFt5C4BDjFM7Jqls0VeMH/gqf
        JA3ksJqj7QKrohDk4U7Nu5sAUxcmERKiJBmNcC4cwjoQwwewNksjinjd1ESmGAyAqTxprSKh519+R
        qO3AP4glQ4JIPWzLlAmJTJ/p5U8MhH7mj4rvJOfk+i3Ndn0uebCLnEpXHTGMMoRlA6B0XeegOCH4b
        q01IOa4xLW4RLaoayu0NTlJoWxQpHxYHTgi94RpyBco2yaAblICORPz0jkVk33ytG9sq9oRItFIdp
        U2gEkKCg==;
Received: from [2001:4bb8:184:76e3:ea38:596b:3e9e:422a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqYbK-0008Hs-Cg; Wed, 01 Jul 2020 09:00:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
        drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org
Subject: [PATCH 19/20] block: shortcut __submit_bio_noacct for blk-mq drivers
Date:   Wed,  1 Jul 2020 10:59:46 +0200
Message-Id: <20200701085947.3354405-20-hch@lst.de>
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

For blk-mq drivers bios can only be inserted for the same queue.  So
bypass the complicated sorting logic in __submit_bio_noacct with
a blk-mq simpler submission helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 57b5dc00d44cb1..2ff166f0d24ee3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1152,6 +1152,34 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
 	return ret;
 }
 
+static blk_qc_t __submit_bio_noacct_mq(struct bio *bio)
+{
+	struct gendisk *disk = bio->bi_disk;
+	struct bio_list bio_list;
+	blk_qc_t ret = BLK_QC_T_NONE;
+
+	bio_list_init(&bio_list);
+	current->bio_list = &bio_list;
+
+	do {
+		WARN_ON_ONCE(bio->bi_disk != disk);
+
+		if (unlikely(bio_queue_enter(bio) != 0))
+			continue;
+
+		if (!blk_crypto_bio_prep(&bio)) {
+			blk_queue_exit(disk->queue);
+			ret = BLK_QC_T_NONE;
+			continue;
+		}
+
+		ret = blk_mq_submit_bio(bio);
+	} while ((bio = bio_list_pop(&bio_list)));
+
+	current->bio_list = NULL;
+	return ret;
+}
+
 /**
  * submit_bio_noacct - re-submit a bio to the block device layer for I/O
  * @bio:  The bio describing the location in memory and on the device.
@@ -1177,6 +1205,8 @@ blk_qc_t submit_bio_noacct(struct bio *bio)
 		return BLK_QC_T_NONE;
 	}
 
+	if (!bio->bi_disk->fops->submit_bio)
+		return __submit_bio_noacct_mq(bio);
 	return __submit_bio_noacct(bio);
 }
 EXPORT_SYMBOL(submit_bio_noacct);
-- 
2.26.2

