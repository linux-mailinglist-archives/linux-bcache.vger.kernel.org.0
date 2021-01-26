Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC90304080
	for <lists+linux-bcache@lfdr.de>; Tue, 26 Jan 2021 15:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404403AbhAZOhD (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 26 Jan 2021 09:37:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404955AbhAZOgz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 26 Jan 2021 09:36:55 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E30C0611BD;
        Tue, 26 Jan 2021 06:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=uAijLOVlzlFNtFA5epK1dLVk2Tr9v2ryv/7iM8cK8Zo=; b=Ovbezc3+HTgEaW4815+0vDmjXn
        f7s6rCMADSJtocBqb/jiquCUK3OOt4DBLalRbHTj4mi7j8HVLi2jj4DEscvd79lqopS07NoC9wD+/
        7oBLkWs3uJV2RX9tp9QFMtde8dMiQW6+JXxIiKDGKbClw/LgdNRX5DytSPRibTFd4/x6XExaVAD+x
        PQ6H7hF1grNMuD6XU5e7uGVlqZYAno94gsGlCf3dAhlydV2EU12gv87EBzouilzkpXDWcCe/kiAip
        oCB8Kp1eGFvttT7bmdQsQEGmUrZnd0AyPzgnrFeS1RXyUN8nnNqSLiDQGCOOnHl4AzEbe33FrtyFQ
        12/d7R5w==;
Received: from [2001:4bb8:191:e347:5918:ac86:61cb:8801] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l4PQm-005kHu-Tg; Tue, 26 Jan 2021 14:35:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-bcache@vger.kernel.org
Subject: [PATCH 1/3] nvme: use bio_set_dev to assign ->bi_bdev
Date:   Tue, 26 Jan 2021 15:33:06 +0100
Message-Id: <20210126143308.1960860-2-hch@lst.de>
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
 drivers/nvme/host/core.c      | 2 +-
 drivers/nvme/host/lightnvm.c  | 2 +-
 drivers/nvme/host/multipath.c | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index eb7963fb167b56..ba5df80881ea98 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1133,7 +1133,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 		if (ret)
 			goto out;
 		bio = req->bio;
-		bio->bi_bdev = bdev;
+		bio_set_dev(bio, bdev);
 		if (bdev && meta_buffer && meta_len) {
 			meta = nvme_add_user_metadata(bio, meta_buffer, meta_len,
 					meta_seed, write);
diff --git a/drivers/nvme/host/lightnvm.c b/drivers/nvme/host/lightnvm.c
index ec38128f51e994..b705988629f224 100644
--- a/drivers/nvme/host/lightnvm.c
+++ b/drivers/nvme/host/lightnvm.c
@@ -816,7 +816,7 @@ static int nvme_nvm_submit_user_cmd(struct request_queue *q,
 			vcmd->ph_rw.metadata = cpu_to_le64(metadata_dma);
 		}
 
-		bio->bi_bdev = ns->disk->part0;
+		bio_set_dev(bio, ns->disk->part0);
 	}
 
 	blk_execute_rq(NULL, rq, 0);
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index a6d44e7a775f54..65bd6efa5e1c69 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -312,7 +312,7 @@ blk_qc_t nvme_ns_head_submit_bio(struct bio *bio)
 	srcu_idx = srcu_read_lock(&head->srcu);
 	ns = nvme_find_path(head);
 	if (likely(ns)) {
-		bio->bi_bdev = ns->disk->part0;
+		bio_set_dev(bio, ns->disk->part0);
 		bio->bi_opf |= REQ_NVME_MPATH;
 		trace_block_bio_remap(bio, disk_devt(ns->head->disk),
 				      bio->bi_iter.bi_sector);
@@ -352,7 +352,7 @@ static void nvme_requeue_work(struct work_struct *work)
 		 * Reset disk to the mpath node and resubmit to select a new
 		 * path.
 		 */
-		bio->bi_bdev = head->disk->part0;
+		bio_set_dev(bio, head->disk->part0);
 		submit_bio_noacct(bio);
 	}
 }
-- 
2.29.2

