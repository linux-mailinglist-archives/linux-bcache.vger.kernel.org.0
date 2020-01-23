Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9991146F01
	for <lists+linux-bcache@lfdr.de>; Thu, 23 Jan 2020 18:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729764AbgAWRCv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 23 Jan 2020 12:02:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:51742 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729396AbgAWRCv (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 23 Jan 2020 12:02:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6023EAD78;
        Thu, 23 Jan 2020 17:02:49 +0000 (UTC)
From:   colyli@suse.de
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Coly Li <colyli@suse.de>
Subject: [PATCH 09/17] bcache: use read_cache_page_gfp to read the superblock
Date:   Fri, 24 Jan 2020 01:01:34 +0800
Message-Id: <20200123170142.98974-10-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200123170142.98974-1-colyli@suse.de>
References: <20200123170142.98974-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Avoid a pointless dependency on buffer heads in bcache by simply open
coding reading a single page.  Also add a SB_OFFSET define for the
byte offset of the superblock instead of using magic numbers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c   | 16 +++++++---------
 include/uapi/linux/bcache.h |  1 +
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 5797c03f993e..3dea1d5acd5c 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -15,7 +15,6 @@
 #include "writeback.h"
 
 #include <linux/blkdev.h>
-#include <linux/buffer_head.h>
 #include <linux/debugfs.h>
 #include <linux/genhd.h>
 #include <linux/idr.h>
@@ -64,13 +63,14 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
 {
 	const char *err;
 	struct cache_sb_disk *s;
-	struct buffer_head *bh = __bread(bdev, 1, SB_SIZE);
+	struct page *page;
 	unsigned int i;
 
-	if (!bh)
+	page = read_cache_page_gfp(bdev->bd_inode->i_mapping,
+				   SB_OFFSET >> PAGE_SHIFT, GFP_KERNEL);
+	if (IS_ERR(page))
 		return "IO error";
-
-	s = (struct cache_sb_disk *)bh->b_data;
+	s = page_address(page) + offset_in_page(SB_OFFSET);
 
 	sb->offset		= le64_to_cpu(s->offset);
 	sb->version		= le64_to_cpu(s->version);
@@ -188,12 +188,10 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
 	}
 
 	sb->last_mount = (u32)ktime_get_real_seconds();
-	err = NULL;
-
-	get_page(bh->b_page);
 	*res = s;
+	return NULL;
 err:
-	put_bh(bh);
+	put_page(page);
 	return err;
 }
 
diff --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h
index 1d8b3a9fc080..9a1965c6c3d0 100644
--- a/include/uapi/linux/bcache.h
+++ b/include/uapi/linux/bcache.h
@@ -148,6 +148,7 @@ static inline struct bkey *bkey_idx(const struct bkey *k, unsigned int nr_keys)
 #define BCACHE_SB_MAX_VERSION		4
 
 #define SB_SECTOR			8
+#define SB_OFFSET			(SB_SECTOR << SECTOR_SHIFT)
 #define SB_SIZE				4096
 #define SB_LABEL_SIZE			32
 #define SB_JOURNAL_BUCKETS		256U
-- 
2.16.4

