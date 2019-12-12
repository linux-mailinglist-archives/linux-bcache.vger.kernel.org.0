Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35CA511D125
	for <lists+linux-bcache@lfdr.de>; Thu, 12 Dec 2019 16:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729467AbfLLPgN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 12 Dec 2019 10:36:13 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:50020 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729139AbfLLPgN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 12 Dec 2019 10:36:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=z5SqYxBc20ZtJeYLFWSJn+m4xIWIMXSiyPkl1DObGx8=; b=kTqjrh1bWhd/r3ptX7TMMNMwkE
        wb7Nh1cFx+2NJQwIu8x5N91JvKT/2EsUngv1MxK1zQ8K/646VXJL0WUAIyYNGa8+rEzH+04fYs8sw
        TX5T5LBkzwP6vBaa1ZEcnT9hJF1eGJNkqJh1JsbMhP2mUOWxbjPOYHpx4r+E3/pGJJkC4lE3wWMYe
        I28cDAVTy4i+zBel92hZ1Z3YfzQGkB3cewZfyJ1ypNJs3KsAN3TkWBVgwfbyAWJ2yT2+ue1g0tYWz
        hgrfyRe2513Sm6qldY06sXdnfZC+pZscrwVnNM8apFCbmLnM8DaoONG/y3kxTnoEIlHa8xNbKKh6a
        FivmB5bw==;
Received: from [2001:4bb8:188:2b00:20e6:8b5a:ed96:f9da] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ifQVg-0007Iu-60; Thu, 12 Dec 2019 15:36:12 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     colyli@suse.de
Cc:     kent.overstreet@gmail.com, liangchen.linux@gmail.com,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 2/7] bcache: use a separate data structure for the on-disk super block
Date:   Thu, 12 Dec 2019 16:35:59 +0100
Message-Id: <20191212153604.19540-3-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191212153604.19540-1-hch@lst.de>
References: <20191212153604.19540-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Split out an on-disk version struct cache_sb with the proper endianess
annotations.  This fixes a fair chunk of sparse warnings, but there are
some left due to the way the checksum is defined.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/super.c   |  6 ++---
 include/uapi/linux/bcache.h | 51 +++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a573ce1d85aa..3045f27e0d67 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -63,14 +63,14 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
 			      struct page **res)
 {
 	const char *err;
-	struct cache_sb *s;
+	struct cache_sb_disk *s;
 	struct buffer_head *bh = __bread(bdev, 1, SB_SIZE);
 	unsigned int i;
 
 	if (!bh)
 		return "IO error";
 
-	s = (struct cache_sb *) bh->b_data;
+	s = (struct cache_sb_disk *)bh->b_data;
 
 	sb->offset		= le64_to_cpu(s->offset);
 	sb->version		= le64_to_cpu(s->version);
@@ -209,7 +209,7 @@ static void write_bdev_super_endio(struct bio *bio)
 
 static void __write_super(struct cache_sb *sb, struct bio *bio)
 {
-	struct cache_sb *out = page_address(bio_first_page_all(bio));
+	struct cache_sb_disk *out = page_address(bio_first_page_all(bio));
 	unsigned int i;
 
 	bio->bi_iter.bi_sector	= SB_SECTOR;
diff --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h
index 5d4f58e059fd..1d8b3a9fc080 100644
--- a/include/uapi/linux/bcache.h
+++ b/include/uapi/linux/bcache.h
@@ -156,6 +156,57 @@ static inline struct bkey *bkey_idx(const struct bkey *k, unsigned int nr_keys)
 
 #define BDEV_DATA_START_DEFAULT		16	/* sectors */
 
+struct cache_sb_disk {
+	__le64			csum;
+	__le64			offset;	/* sector where this sb was written */
+	__le64			version;
+
+	__u8			magic[16];
+
+	__u8			uuid[16];
+	union {
+		__u8		set_uuid[16];
+		__le64		set_magic;
+	};
+	__u8			label[SB_LABEL_SIZE];
+
+	__le64			flags;
+	__le64			seq;
+	__le64			pad[8];
+
+	union {
+	struct {
+		/* Cache devices */
+		__le64		nbuckets;	/* device size */
+
+		__le16		block_size;	/* sectors */
+		__le16		bucket_size;	/* sectors */
+
+		__le16		nr_in_set;
+		__le16		nr_this_dev;
+	};
+	struct {
+		/* Backing devices */
+		__le64		data_offset;
+
+		/*
+		 * block_size from the cache device section is still used by
+		 * backing devices, so don't add anything here until we fix
+		 * things to not need it for backing devices anymore
+		 */
+	};
+	};
+
+	__le32			last_mount;	/* time overflow in y2106 */
+
+	__le16			first_bucket;
+	union {
+		__le16		njournal_buckets;
+		__le16		keys;
+	};
+	__le64			d[SB_JOURNAL_BUCKETS];	/* journal buckets */
+};
+
 struct cache_sb {
 	__u64			csum;
 	__u64			offset;	/* sector where this sb was written */
-- 
2.20.1

