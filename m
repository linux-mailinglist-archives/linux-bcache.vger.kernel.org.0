Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D1C301B16
	for <lists+linux-bcache@lfdr.de>; Sun, 24 Jan 2021 11:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbhAXKHA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 24 Jan 2021 05:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbhAXKGo (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 24 Jan 2021 05:06:44 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6563AC0613ED;
        Sun, 24 Jan 2021 02:05:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=+C1WbEDt8bDZJfBsa8pBygC2sdTHVEwbwKUtsHvNJpI=; b=jJL+eqGysGfOJp3LpA1p82bAph
        SQz7HMhZIvq1kGR1dnYAWjgLLpnUFnN6u4r0BEYxabwZszZ5rYSu0gXqxPAy9eJw3kntHBqpLXUEc
        04FBvuqefx01gQQUAFuIGuKs2PupMo11uCl1aj9Lxe/qAz/WQPDCGkCG/ThzyTXc+xPGSHco/Kl8f
        2wK/ydFfvgMXGA8VeWrZzEmfD0sxNeTuRh5AfmqavYFP+lYOmn1EYtqFGcP2JV33T6zldthwYU3s5
        B8Ql0stlBvT7m85ra3JC8vcEXBW9ZLL2J9ZgIYQ2jIhf+ItuDY76DOdIfz+BhMBd/hcQv5CEUZXzH
        LEwSIfBg==;
Received: from [2001:4bb8:188:1954:a3b3:627f:702b:2136] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l3cH5-002q9k-0b; Sun, 24 Jan 2021 10:05:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 05/10] block: do not reassig ->bi_bdev when partition remapping
Date:   Sun, 24 Jan 2021 11:02:36 +0100
Message-Id: <20210124100241.1167849-6-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210124100241.1167849-1-hch@lst.de>
References: <20210124100241.1167849-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

There is no good reason to reassign ->bi_bdev when remapping the
partition-relative block number to the device wide one, as all the
information required by the drivers comes from the gendisk anyway.

Keeping the original ->bi_bdev alive will allow to greatly simplify
the partition-away I/O accounting.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c          | 5 +++--
 include/linux/bio.h       | 2 ++
 include/linux/blk_types.h | 1 +
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 64f69022de9627..1c1b97a82caa2e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -752,7 +752,7 @@ static int blk_partition_remap(struct bio *bio)
 				      bio->bi_iter.bi_sector -
 				      p->bd_start_sect);
 	}
-	bio->bi_bdev = bdev_whole(p);
+	bio_set_flag(bio, BIO_REMAPPED);
 	return 0;
 }
 
@@ -817,7 +817,8 @@ static noinline_for_stack bool submit_bio_checks(struct bio *bio)
 		goto end_io;
 	if (unlikely(bio_check_eod(bio)))
 		goto end_io;
-	if (bio->bi_bdev->bd_partno && unlikely(blk_partition_remap(bio)))
+	if (bio->bi_bdev->bd_partno && !bio_flagged(bio, BIO_REMAPPED) &&
+	    unlikely(blk_partition_remap(bio)))
 		goto end_io;
 
 	/*
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 12af7aa5db3778..2f1155eabaff29 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -485,6 +485,7 @@ extern const char *bio_devname(struct bio *bio, char *buffer);
 
 #define bio_set_dev(bio, bdev) 				\
 do {							\
+	bio_clear_flag(bio, BIO_REMAPPED);		\
 	if ((bio)->bi_bdev != (bdev))			\
 		bio_clear_flag(bio, BIO_THROTTLED);	\
 	(bio)->bi_bdev = (bdev);			\
@@ -493,6 +494,7 @@ do {							\
 
 #define bio_copy_dev(dst, src)			\
 do {						\
+	bio_clear_flag(dst, BIO_REMAPPED);		\
 	(dst)->bi_bdev = (src)->bi_bdev;	\
 	bio_clone_blkg_association(dst, src);	\
 } while (0)
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 8ebd8be3e05082..1bc6f6a01070fc 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -303,6 +303,7 @@ enum {
 				 * of this bio. */
 	BIO_CGROUP_ACCT,	/* has been accounted to a cgroup */
 	BIO_TRACKED,		/* set if bio goes through the rq_qos path */
+	BIO_REMAPPED,
 	BIO_FLAG_LAST
 };
 
-- 
2.29.2

