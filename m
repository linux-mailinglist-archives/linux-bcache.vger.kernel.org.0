Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402962CA8E8
	for <lists+linux-bcache@lfdr.de>; Tue,  1 Dec 2020 17:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391971AbgLAQzR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 1 Dec 2020 11:55:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390702AbgLAQzQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 1 Dec 2020 11:55:16 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639B4C0617A7;
        Tue,  1 Dec 2020 08:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=trDJN9jf107lr9q4qKjq5B1p8JdkI22oraIg+sR37JI=; b=vlCm7OawCO5a2tbFWJ6oyOKRgI
        lYB3HD4aGXt9gIVsxogZJtl2e+j8HZGrTXpaLmOSOcCy0uwzoLHDKJwm9NgdY645RYSp49Jd3qbam
        2SxeQU9SIzhu+pPf+T2YGR8ujWUjk7wk8Xu6CTDRlE7kFqlDfi5HrqKtihY38M0ry5SkbNsUfvsJo
        k3sSYv4Ez4LKTQZ5lFV4fIaWTFMhvB0bPnlKmMl2bEzMWcGhiiP18a4YMKSnlq0QuAW50GWFV/B+p
        Upbt45qF4NvQKhYnPoDsfBXVb2cBZCs/m3Y9vI9x3LWDXWSSeSXjsYnyCJySsN3FCjr9Zc9URY7uF
        3SWOL6zQ==;
Received: from [2001:4bb8:184:6389:bbd8:a1c2:99e0:f58a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kk8v9-0005ZH-8n; Tue, 01 Dec 2020 16:54:31 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 4/9] block: simplify submit_bio_checks a bit
Date:   Tue,  1 Dec 2020 17:54:19 +0100
Message-Id: <20201201165424.2030647-5-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201165424.2030647-1-hch@lst.de>
References: <20201201165424.2030647-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Merge a few checks for whole devices vs partitions to streamline the
sanity checks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c | 40 ++++++++++++++--------------------------
 1 file changed, 14 insertions(+), 26 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 95005a8db5ab2f..3a8fef64d36bc1 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -691,11 +691,9 @@ static inline bool should_fail_request(struct block_device *part,
 
 #endif /* CONFIG_FAIL_MAKE_REQUEST */
 
-static inline bool bio_check_ro(struct bio *bio, struct block_device *part)
+static inline bool bio_check_ro(struct bio *bio)
 {
-	const int op = bio_op(bio);
-
-	if (part->bd_read_only && op_is_write(op)) {
+	if (op_is_write(bio_op(bio)) && bio->bi_bdev->bd_read_only) {
 		char b[BDEVNAME_SIZE];
 
 		if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
@@ -703,7 +701,7 @@ static inline bool bio_check_ro(struct bio *bio, struct block_device *part)
 
 		WARN_ONCE(1,
 		       "Trying to write to read-only block-device %s (partno %d)\n",
-			bio_devname(bio, b), part->bd_partno);
+			bio_devname(bio, b), bio->bi_bdev->bd_partno);
 		/* Older lvm-tools actually trigger this */
 		return false;
 	}
@@ -724,8 +722,9 @@ ALLOW_ERROR_INJECTION(should_fail_bio, ERRNO);
  * This may well happen - the kernel calls bread() without checking the size of
  * the device, e.g., when mounting a file system.
  */
-static inline int bio_check_eod(struct bio *bio, sector_t maxsector)
+static inline int bio_check_eod(struct bio *bio)
 {
+	sector_t maxsector = bdev_nr_sectors(bio->bi_bdev);
 	unsigned int nr_sectors = bio_sectors(bio);
 
 	if (nr_sectors && maxsector &&
@@ -740,27 +739,20 @@ static inline int bio_check_eod(struct bio *bio, sector_t maxsector)
 /*
  * Remap block n of partition p to block n+start(p) of the disk.
  */
-static inline int blk_partition_remap(struct bio *bio)
+static int blk_partition_remap(struct bio *bio)
 {
 	struct block_device *p = bio->bi_bdev;
-	int ret = -EIO;
 
 	if (unlikely(should_fail_request(p, bio->bi_iter.bi_size)))
-		goto out;
-	if (unlikely(bio_check_ro(bio, p)))
-		goto out;
+		return -EIO;
 
 	if (bio_sectors(bio)) {
-		if (bio_check_eod(bio, bdev_nr_sectors(p)))
-			goto out;
 		bio->bi_iter.bi_sector += p->bd_start_sect;
 		trace_block_bio_remap(bio, p->bd_dev,
 				      bio->bi_iter.bi_sector -
 				      p->bd_start_sect);
 	}
-	ret = 0;
-out:
-	return ret;
+	return 0;
 }
 
 /*
@@ -820,16 +812,12 @@ static noinline_for_stack bool submit_bio_checks(struct bio *bio)
 
 	if (should_fail_bio(bio))
 		goto end_io;
-
-	if (bio->bi_bdev->bd_partno) {
-		if (unlikely(blk_partition_remap(bio)))
-			goto end_io;
-	} else {
-		if (unlikely(bio_check_ro(bio, bdev_whole(bdev))))
-			goto end_io;
-		if (unlikely(bio_check_eod(bio, get_capacity(bdev->bd_disk))))
-			goto end_io;
-	}
+	if (unlikely(bio_check_ro(bio)))
+		goto end_io;
+	if (unlikely(bio_check_eod(bio)))
+		goto end_io;
+	if (bio->bi_bdev->bd_partno && unlikely(blk_partition_remap(bio)))
+		goto end_io;
 
 	/*
 	 * Filter flush bio's early so that bio based drivers without flush
-- 
2.29.2

