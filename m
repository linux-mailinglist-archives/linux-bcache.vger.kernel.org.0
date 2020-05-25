Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83CFD1E0D42
	for <lists+linux-bcache@lfdr.de>; Mon, 25 May 2020 13:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390286AbgEYLal (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 25 May 2020 07:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390236AbgEYLal (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 25 May 2020 07:30:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9ECAC05BD43;
        Mon, 25 May 2020 04:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=v0186iGSqwpARGzc7KINAxQMJdy88hv4ZSp1TLxcph8=; b=C3HXaSgydTdPnNhbbqlKc29mMr
        BV8upwmLHyhsrC8k+c203Qz+HXjo5uv7zs/ybS6kup7SzPfR2S71ehMjYo6bso2vAHO98rivXTR6q
        soGtaWhjVwIIR8wUI6G2q36asr3NG1dkzHr2k4Jg3TlR7YgBCaKU7G8YUg9huM2K8qTg5iSKHi3QH
        OaT84T3cBe3SEmzsrjw+u8Pk2LexKtKqMNI0spxmqryoJmt+xl20bX2J8hodH64jimYm2XZmbc5gS
        LDNbzf1jGLIyzHhJMclLSqjQ8vRuXzLjiUk7sg1K0b9QX8ZoAjLcTMKIOXwkEWywr0FeSumaOHC7Q
        v66ZRuww==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jdBJV-0002Qh-Hx; Mon, 25 May 2020 11:30:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
        linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/16] nvdimm: use bio_{start,end}_io_acct
Date:   Mon, 25 May 2020 13:30:05 +0200
Message-Id: <20200525113014.345997-8-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200525113014.345997-1-hch@lst.de>
References: <20200525113014.345997-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Switch dm to use the nicer bio accounting helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvdimm/blk.c  |  6 ++++--
 drivers/nvdimm/btt.c  |  6 ++++--
 drivers/nvdimm/nd.h   | 19 -------------------
 drivers/nvdimm/pmem.c |  6 ++++--
 4 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 43751fab9d36a..036e23aef9b04 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -178,7 +178,9 @@ static blk_qc_t nd_blk_make_request(struct request_queue *q, struct bio *bio)
 	bip = bio_integrity(bio);
 	nsblk = q->queuedata;
 	rw = bio_data_dir(bio);
-	do_acct = nd_iostat_start(bio, &start);
+	do_acct = blk_queue_io_stat(bio->bi_disk->queue);
+	if (do_acct)
+		start = bio_start_io_acct(bio);
 	bio_for_each_segment(bvec, bio, iter) {
 		unsigned int len = bvec.bv_len;
 
@@ -195,7 +197,7 @@ static blk_qc_t nd_blk_make_request(struct request_queue *q, struct bio *bio)
 		}
 	}
 	if (do_acct)
-		nd_iostat_end(bio, start);
+		bio_end_io_acct(bio, start);
 
 	bio_endio(bio);
 	return BLK_QC_T_NONE;
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 3b09419218d6f..90c0c4bbe77b9 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1452,7 +1452,9 @@ static blk_qc_t btt_make_request(struct request_queue *q, struct bio *bio)
 	if (!bio_integrity_prep(bio))
 		return BLK_QC_T_NONE;
 
-	do_acct = nd_iostat_start(bio, &start);
+	do_acct = blk_queue_io_stat(bio->bi_disk->queue);
+	if (do_acct)
+		start = bio_start_io_acct(bio);
 	bio_for_each_segment(bvec, bio, iter) {
 		unsigned int len = bvec.bv_len;
 
@@ -1477,7 +1479,7 @@ static blk_qc_t btt_make_request(struct request_queue *q, struct bio *bio)
 		}
 	}
 	if (do_acct)
-		nd_iostat_end(bio, start);
+		bio_end_io_acct(bio, start);
 
 	bio_endio(bio);
 	return BLK_QC_T_NONE;
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 85dbb2a322b9b..85c1ae813ea31 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -396,25 +396,6 @@ static inline int nvdimm_setup_pfn(struct nd_pfn *nd_pfn,
 #endif
 int nd_blk_region_init(struct nd_region *nd_region);
 int nd_region_activate(struct nd_region *nd_region);
-void __nd_iostat_start(struct bio *bio, unsigned long *start);
-static inline bool nd_iostat_start(struct bio *bio, unsigned long *start)
-{
-	struct gendisk *disk = bio->bi_disk;
-
-	if (!blk_queue_io_stat(disk->queue))
-		return false;
-
-	*start = jiffies;
-	generic_start_io_acct(disk->queue, bio_op(bio), bio_sectors(bio),
-			      &disk->part0);
-	return true;
-}
-static inline void nd_iostat_end(struct bio *bio, unsigned long start)
-{
-	struct gendisk *disk = bio->bi_disk;
-
-	generic_end_io_acct(disk->queue, bio_op(bio), &disk->part0, start);
-}
 static inline bool is_bad_pmem(struct badblocks *bb, sector_t sector,
 		unsigned int len)
 {
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 2df6994acf836..97f948f8f4e62 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -202,7 +202,9 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 	if (bio->bi_opf & REQ_PREFLUSH)
 		ret = nvdimm_flush(nd_region, bio);
 
-	do_acct = nd_iostat_start(bio, &start);
+	do_acct = blk_queue_io_stat(bio->bi_disk->queue);
+	if (do_acct)
+		start = bio_start_io_acct(bio);
 	bio_for_each_segment(bvec, bio, iter) {
 		if (op_is_write(bio_op(bio)))
 			rc = pmem_do_write(pmem, bvec.bv_page, bvec.bv_offset,
@@ -216,7 +218,7 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 		}
 	}
 	if (do_acct)
-		nd_iostat_end(bio, start);
+		bio_end_io_acct(bio, start);
 
 	if (bio->bi_opf & REQ_FUA)
 		ret = nvdimm_flush(nd_region, bio);
-- 
2.26.2

