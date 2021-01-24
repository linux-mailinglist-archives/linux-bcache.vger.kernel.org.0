Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF87301B27
	for <lists+linux-bcache@lfdr.de>; Sun, 24 Jan 2021 11:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbhAXKH5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 24 Jan 2021 05:07:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726793AbhAXKG6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 24 Jan 2021 05:06:58 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E61C061573;
        Sun, 24 Jan 2021 02:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=/EYk+0P96lR/mC5Sas0GCCBCqytAW3UF4FS5EfHCsd8=; b=tHgzV1Qgpoq+wIM+i7/OFCqeVb
        AMG4zclGEMAKTAHZY3WwOem5zSbUy6r3io0PIIqV4pb4b4Lo+9XtQFTv2WL8EZhU6W+AtW7XunQab
        l1IAC7bUoJJqeEZBZQekM8VGbfJKeNhM8bMHuUxBjrudTqDcsW9CATlcTX3nFWiVAPdVZ6UR5ugni
        +tmAjPT0SMOUEF9vlGJkCPwIQMq3GuZd7b8oUSF2x0H3iNAUXswl9+lb8OspDSXu/+FWJfikFVpsG
        7ko98GKzvF/nHFIgPr1x8xai6rjCkr7xoEFF++ACCF8G/XPAaiT+F0QGvj+5bA929d1Z7O0AeuNU4
        NzwXF9Ow==;
Received: from [2001:4bb8:188:1954:a3b3:627f:702b:2136] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l3cHK-002qAP-RM; Sun, 24 Jan 2021 10:05:56 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 09/10] block: remove DISK_PITER_REVERSE
Date:   Sun, 24 Jan 2021 11:02:40 +0100
Message-Id: <20210124100241.1167849-10-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210124100241.1167849-1-hch@lst.de>
References: <20210124100241.1167849-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

There is good reason to iterate backwards when deleting all partitions in
del_gendisk, just like we don't in blk_drop_partitions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/genhd.c         | 37 +++++++------------------------------
 include/linux/genhd.h |  1 -
 2 files changed, 7 insertions(+), 31 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 7094612c7510a8..1832add5c73849 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -184,24 +184,13 @@ static struct block_device *__disk_get_part(struct gendisk *disk, int partno)
 void disk_part_iter_init(struct disk_part_iter *piter, struct gendisk *disk,
 			  unsigned int flags)
 {
-	struct disk_part_tbl *ptbl;
-
-	rcu_read_lock();
-	ptbl = rcu_dereference(disk->part_tbl);
-
 	piter->disk = disk;
 	piter->part = NULL;
-
-	if (flags & DISK_PITER_REVERSE)
-		piter->idx = ptbl->len - 1;
-	else if (flags & (DISK_PITER_INCL_PART0 | DISK_PITER_INCL_EMPTY_PART0))
+	if (flags & (DISK_PITER_INCL_PART0 | DISK_PITER_INCL_EMPTY_PART0))
 		piter->idx = 0;
 	else
 		piter->idx = 1;
-
 	piter->flags = flags;
-
-	rcu_read_unlock();
 }
 
 /**
@@ -216,7 +205,6 @@ void disk_part_iter_init(struct disk_part_iter *piter, struct gendisk *disk,
 struct block_device *disk_part_iter_next(struct disk_part_iter *piter)
 {
 	struct disk_part_tbl *ptbl;
-	int inc, end;
 
 	/* put the last partition */
 	disk_part_iter_exit(piter);
@@ -225,21 +213,8 @@ struct block_device *disk_part_iter_next(struct disk_part_iter *piter)
 	rcu_read_lock();
 	ptbl = rcu_dereference(piter->disk->part_tbl);
 
-	/* determine iteration parameters */
-	if (piter->flags & DISK_PITER_REVERSE) {
-		inc = -1;
-		if (piter->flags & (DISK_PITER_INCL_PART0 |
-				    DISK_PITER_INCL_EMPTY_PART0))
-			end = -1;
-		else
-			end = 0;
-	} else {
-		inc = 1;
-		end = ptbl->len;
-	}
-
 	/* iterate to the next partition */
-	for (; piter->idx != end; piter->idx += inc) {
+	for (; piter->idx != ptbl->len; piter->idx += 1) {
 		struct block_device *part;
 
 		part = rcu_dereference(ptbl->part[piter->idx]);
@@ -257,7 +232,10 @@ struct block_device *disk_part_iter_next(struct disk_part_iter *piter)
 			continue;
 		}
 
-		piter->idx += inc;
+		piter->part = bdgrab(part);
+		if (!piter->part)
+			continue;
+		piter->idx += 1;
 		break;
 	}
 
@@ -781,8 +759,7 @@ void del_gendisk(struct gendisk *disk)
 	down_write(&bdev_lookup_sem);
 
 	/* invalidate stuff */
-	disk_part_iter_init(&piter, disk,
-			     DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
+	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY);
 	while ((part = disk_part_iter_next(&piter))) {
 		invalidate_partition(part);
 		delete_partition(part);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 670eaef0e87622..51609133c9a347 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -218,7 +218,6 @@ void disk_uevent(struct gendisk *disk, enum kobject_action action);
 /*
  * Smarter partition iterator without context limits.
  */
-#define DISK_PITER_REVERSE	(1 << 0) /* iterate in the reverse direction */
 #define DISK_PITER_INCL_EMPTY	(1 << 1) /* include 0-sized parts */
 #define DISK_PITER_INCL_PART0	(1 << 2) /* include partition 0 */
 #define DISK_PITER_INCL_EMPTY_PART0 (1 << 3) /* include empty partition 0 */
-- 
2.29.2

