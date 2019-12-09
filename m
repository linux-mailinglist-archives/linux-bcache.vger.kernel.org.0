Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF33116994
	for <lists+linux-bcache@lfdr.de>; Mon,  9 Dec 2019 10:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbfLIJiw (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 9 Dec 2019 04:38:52 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57924 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727370AbfLIJiv (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Dec 2019 04:38:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1ce+EBx9Wv/nKl91zuHIgQqitgsBwml/5YDS48TEz4U=; b=aujYUB0ViHJFkNt3aDpnZLGuiT
        WjqBEev2PCokKK7J/zWv7+roDQE8hO3hA0bnvZRj00/1+Y6Rkol6NQxV3RO4qtCP7O7u6MPW+Svng
        1brSfPp9bqVrXE2pr5e0wtO4zvvFpkh03Uk5c+LuQp/UNGrNNDZZXjEiHvLm7B2Vrt54sblIO8ph6
        GGHprdQh6XiQwMxpLpWMDFQpUvW4VQ1udi5hN8cYtPbNw4EFjsNSiXSOQd9dQTujxaS5nci54rYnw
        w9VjW2pkmylGo4D+4GwBc3DAu6cBPQrbXpC4UwicNKyHbThWSjAUn1LJD1jrtpYJMi9GHQHOOwo7o
        H62fIu8g==;
Received: from [2001:4bb8:188:2b00:20e6:8b5a:ed96:f9da] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ieFVC-0002iL-Ci; Mon, 09 Dec 2019 09:38:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     colyli@suse.de
Cc:     kent.overstreet@gmail.com, liangchen.linux@gmail.com,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 7/7] bcache: use read_cache_page_gfp to read the superblock
Date:   Mon,  9 Dec 2019 10:38:29 +0100
Message-Id: <20191209093829.19703-8-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191209093829.19703-1-hch@lst.de>
References: <20191209093829.19703-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Avoid a pointless dependency on buffer heads in bcache by simply open
coding reading a single page.  Also add a SB_OFFSET define for the
byte offset of the superblock instead of using magic numbers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/super.c   | 16 +++++++---------
 include/uapi/linux/bcache.h |  1 +
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index df41d103fa34..ecb24316381f 100644
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
2.20.1

