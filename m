Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E00C9146EF0
	for <lists+linux-bcache@lfdr.de>; Thu, 23 Jan 2020 18:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730002AbgAWRCG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 23 Jan 2020 12:02:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:51306 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728899AbgAWRCG (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 23 Jan 2020 12:02:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7FE84AD73;
        Thu, 23 Jan 2020 17:02:04 +0000 (UTC)
From:   colyli@suse.de
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Coly Li <colyli@suse.de>
Subject: [PATCH 02/17] bcache: use a separate data structure for the on-disk super block
Date:   Fri, 24 Jan 2020 01:01:27 +0800
Message-Id: <20200123170142.98974-3-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200123170142.98974-1-colyli@suse.de>
References: <20200123170142.98974-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Split out an on-disk version struct cache_sb with the proper endianness
annotations.  This fixes a fair chunk of sparse warnings, but there are
some left due to the way the checksum is defined.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c   |  6 +++---
 include/uapi/linux/bcache.h | 51 +++++++++++++++++++++++++++++++++++++++++++++
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
2.16.4

