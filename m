Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B143F1E0D01
	for <lists+linux-bcache@lfdr.de>; Mon, 25 May 2020 13:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390169AbgEYLaY (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 25 May 2020 07:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388136AbgEYLaY (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 25 May 2020 07:30:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD3CC061A0E;
        Mon, 25 May 2020 04:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Qq+ysHCZAJr0PvG5gfgqqhpu5RG6xW5L1GPGYv1gJ58=; b=cVeRwyZx3qs12+4yP+KFnmEkSG
        0YiUHPJL9TZ7gnDcdyd6bDcciUc/cQpB3zbhRBE8CSaKRzHpKPl4/o+i2gOrcs9hLZM8/HmwQtR9l
        L2RJ4eS9uw4NHF3UQmgBaT05Nv5Z7b1PQAUad+lCHhn29pb7VT4xuFhbOFoY2LTEN+Zpn+0BNvq4I
        lcxBQh6pZk9GDuGwx/nSObjwTVMyq8w8uhab0tV/LgOSLFmxR59GTzr5ln3QyyjeVi7pAcl101KGQ
        zy6XcJUqvBVMNq8vK+6CtnHSfzxxrpKTF/8llZRtqco83nwMsUeoTYvtbvcH54OnGdlVuMhRoW8P1
        +aCTN/8A==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jdBJE-0002N7-4N; Mon, 25 May 2020 11:30:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
        linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/16] block: add disk/bio-based accounting helpers
Date:   Mon, 25 May 2020 13:29:59 +0200
Message-Id: <20200525113014.345997-2-hch@lst.de>
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

Add two new helpers to simplify I/O accounting for bio based drivers.
Currently these drivers use the generic_start_io_acct and
generic_end_io_acct helpers which have very cumbersome calling
conventions, don't actually return the time they started accounting,
and try to deal with accounting for partitions, which can't happen
for bio based drivers.  The new helpers will be used to subsequently
replace uses of the old helpers.

The main function is the bio based wrappes in blkdev.h, but for zram
which wants to account rw_page based I/O lower level routines are
provided as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c       | 34 ++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h | 26 ++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 77e57c2e8d602..8973104f88d90 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1432,6 +1432,40 @@ void blk_account_io_start(struct request *rq, bool new_io)
 	part_stat_unlock();
 }
 
+unsigned long disk_start_io_acct(struct gendisk *disk, unsigned int sectors,
+		unsigned int op)
+{
+	struct hd_struct *part = &disk->part0;
+	const int sgrp = op_stat_group(op);
+	unsigned long now = READ_ONCE(jiffies);
+
+	part_stat_lock();
+	update_io_ticks(part, now, false);
+	part_stat_inc(part, ios[sgrp]);
+	part_stat_add(part, sectors[sgrp], sectors);
+	part_stat_local_inc(part, in_flight[op_is_write(op)]);
+	part_stat_unlock();
+
+	return now;
+}
+EXPORT_SYMBOL(disk_start_io_acct);
+
+void disk_end_io_acct(struct gendisk *disk, unsigned int op,
+		unsigned long start_time)
+{
+	struct hd_struct *part = &disk->part0;
+	const int sgrp = op_stat_group(op);
+	unsigned long now = READ_ONCE(jiffies);
+	unsigned long duration = now - start_time;
+
+	part_stat_lock();
+	update_io_ticks(part, now, true);
+	part_stat_add(part, nsecs[sgrp], jiffies_to_nsecs(duration));
+	part_stat_local_dec(part, in_flight[op_is_write(op)]);
+	part_stat_unlock();
+}
+EXPORT_SYMBOL(disk_end_io_acct);
+
 /*
  * Steal bios from a request and add them to a bio list.
  * The request must not have been partially completed before.
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7d10f4e632325..76d01a8a13b80 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1892,4 +1892,30 @@ static inline void blk_wake_io_task(struct task_struct *waiter)
 		wake_up_process(waiter);
 }
 
+unsigned long disk_start_io_acct(struct gendisk *disk, unsigned int sectors,
+		unsigned int op);
+void disk_end_io_acct(struct gendisk *disk, unsigned int op,
+		unsigned long start_time);
+
+/**
+ * bio_start_io_acct - start I/O accounting for bio based drivers
+ * @bio:	bio to start account for
+ *
+ * Returns the start time that should be passed back to bio_end_io_acct().
+ */
+static inline unsigned long bio_start_io_acct(struct bio *bio)
+{
+	return disk_start_io_acct(bio->bi_disk, bio_sectors(bio), bio_op(bio));
+}
+
+/**
+ * bio_end_io_acct - end I/O accounting for bio based drivers
+ * @bio:	bio to end account for
+ * @start:	start time returned by bio_start_io_acct()
+ */
+static inline void bio_end_io_acct(struct bio *bio, unsigned long start_time)
+{
+	return disk_end_io_acct(bio->bi_disk, bio_op(bio), start_time);
+}
+
 #endif
-- 
2.26.2

