Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0EB2465F9
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Aug 2020 14:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgHQMGg (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 17 Aug 2020 08:06:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:53554 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbgHQMGg (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Aug 2020 08:06:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 44EBAAFF8
        for <linux-bcache@vger.kernel.org>; Mon, 17 Aug 2020 12:06:59 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>
Subject: [PATCH 7/8] bcache-tools: add large_bucket incompat feature
Date:   Mon, 17 Aug 2020 20:05:57 +0800
Message-Id: <20200817120558.4491-8-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200817120558.4491-1-colyli@suse.de>
References: <20200817120558.4491-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This feature adds __le16 bucket_size_hi into struct cache_sb_disk, to
permit bucket size to be 32bit width. Current maximum bucket size is
16MB, extend it to 32bits will permit much large bucket size which is
desired by zoned SSD devices (a typical zone size is 256MB).

When setting a bucket size > 16MB, large_bucket feature will be set
automatically and the super block version will also be set to
BCACHE_SB_VERSION_CDEV_WITH_FEATURES.

Signed-off-by: Coly Li <colyli@suse.de>
---
 bcache.h   |  8 ++++++++
 features.c |  2 ++
 lib.c      | 19 +++++++++++++++++++
 lib.h      |  1 +
 make.c     | 18 ++++++++++++------
 5 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/bcache.h b/bcache.h
index 9d969e1..6aef9c4 100644
--- a/bcache.h
+++ b/bcache.h
@@ -100,6 +100,7 @@ struct cache_sb_disk {
 		__le16		keys;
 	};
 	__le64			d[SB_JOURNAL_BUCKETS];	/* journal buckets */
+	__le16			bucket_size_hi;
 };
 
 /*
@@ -210,6 +211,11 @@ uint64_t crc64(const void *data, size_t len);
 #define BCH_HAS_INCOMPAT_FEATURE(sb, mask) \
 		((sb)->feature_incompat & (mask))
 
+/* Feature set definition */
+
+/* Incompat feature set */
+#define BCH_FEATURE_INCOMPAT_LARGE_BUCKET	0x0001 /* 32bit bucket size */
+
 #define BCH_FEATURE_COMPAT_FUNCS(name, flagname) \
 static inline int bch_has_feature_##name(struct cache_sb *sb) \
 { \
@@ -261,4 +267,6 @@ static inline void bch_clear_feature_##name(struct cache_sb *sb) \
 		~BCH##_FEATURE_INCOMPAT_##flagname; \
 }
 
+BCH_FEATURE_INCOMPAT_FUNCS(large_bucket, LARGE_BUCKET);
+
 #endif
diff --git a/features.c b/features.c
index a1c9884..df15862 100644
--- a/features.c
+++ b/features.c
@@ -18,5 +18,7 @@ struct feature {
 };
 
 static struct feature feature_list[] = {
+	{BCH_FEATURE_INCOMPAT, BCH_FEATURE_INCOMPAT_LARGE_BUCKET,
+		"large_bucket"},
 	{0, 0, 0 },
 };
diff --git a/lib.c b/lib.c
index dcf752c..efabeb1 100644
--- a/lib.c
+++ b/lib.c
@@ -4,6 +4,7 @@
 #include <stdbool.h>
 #include <blkid.h>
 #include <dirent.h>
+#include <limits.h>
 #include <sys/types.h>
 #include <unistd.h>
 #include <stdio.h>
@@ -736,6 +737,10 @@ struct cache_sb *to_cache_sb(struct cache_sb *sb,
 		sb->feature_ro_compat = le64_to_cpu(sb_disk->feature_ro_compat);
 	}
 
+	if (sb->version >= BCACHE_SB_VERSION_CDEV_WITH_FEATURES &&
+	    bch_has_feature_large_bucket(sb))
+		sb->bucket_size += le16_to_cpu(sb_disk->bucket_size_hi) << 16;
+
 	return sb;
 }
 
@@ -784,5 +789,19 @@ struct cache_sb_disk *to_cache_sb_disk(struct cache_sb_disk *sb_disk,
 		sb_disk->feature_ro_compat = cpu_to_le64(sb->feature_ro_compat);
 	}
 
+	if (sb->version >= BCACHE_SB_VERSION_CDEV_WITH_FEATURES &&
+	    bch_has_feature_large_bucket(sb))
+		sb_disk->bucket_size_hi = cpu_to_le16(sb->bucket_size >> 16);
+
 	return sb_disk;
 }
+
+void set_bucket_size(struct cache_sb *sb, unsigned int bucket_size)
+{
+	if (bucket_size > USHRT_MAX) {
+		sb->version = BCACHE_SB_VERSION_CDEV_WITH_FEATURES;
+		bch_set_feature_large_bucket(sb);
+	}
+
+	sb->bucket_size = bucket_size;
+}
diff --git a/lib.h b/lib.h
index b37608e..1dd2bfe 100644
--- a/lib.h
+++ b/lib.h
@@ -52,6 +52,7 @@ int set_label(char *devname, char *label);
 int cset_to_devname(struct list_head *head, char *cset, char *devname);
 struct cache_sb *to_cache_sb(struct cache_sb *sb, struct cache_sb_disk *sb_disk);
 struct cache_sb_disk *to_cache_sb_disk(struct cache_sb_disk *sb_disk,struct cache_sb *sb);
+void set_bucket_size(struct cache_sb *sb, unsigned int bucket_size);
 
 #define DEVLEN sizeof(struct dev)
 
diff --git a/make.c b/make.c
index a239023..9631857 100644
--- a/make.c
+++ b/make.c
@@ -83,7 +83,9 @@ uint64_t hatoi(const char *s)
 	return i;
 }
 
-unsigned int hatoi_validate(const char *s, const char *msg)
+unsigned int hatoi_validate(const char *s,
+			    const char *msg,
+			    unsigned long max)
 {
 	uint64_t v = hatoi(s);
 
@@ -94,7 +96,7 @@ unsigned int hatoi_validate(const char *s, const char *msg)
 
 	v /= 512;
 
-	if (v > USHRT_MAX) {
+	if (v > max) {
 		fprintf(stderr, "%s too large\n", msg);
 		exit(EXIT_FAILURE);
 	}
@@ -338,7 +340,7 @@ static void write_sb(char *dev, unsigned int block_size,
 	uuid_generate(sb.uuid);
 	memcpy(sb.set_uuid, set_uuid, sizeof(sb.set_uuid));
 
-	sb.bucket_size	= bucket_size;
+	set_bucket_size(&sb, bucket_size);
 	sb.block_size	= block_size;
 
 	uuid_unparse(sb.uuid, uuid_str);
@@ -362,7 +364,8 @@ static void write_sb(char *dev, unsigned int block_size,
 		}
 
 		if (data_offset != BDEV_DATA_START_DEFAULT) {
-			sb.version = BCACHE_SB_VERSION_BDEV_WITH_OFFSET;
+			if (sb.version < BCACHE_SB_VERSION_BDEV_WITH_OFFSET)
+				sb.version = BCACHE_SB_VERSION_BDEV_WITH_OFFSET;
 			sb.data_offset = data_offset;
 		}
 
@@ -382,6 +385,7 @@ static void write_sb(char *dev, unsigned int block_size,
 	} else {
 		sb.nbuckets		= getblocks(fd) / sb.bucket_size;
 		sb.nr_in_set		= 1;
+		/* 23 is (SB_SECTOR + SB_SIZE) - 1 sectors */
 		sb.first_bucket		= (23 / sb.bucket_size) + 1;
 
 		if (sb.nbuckets < 1 << 7) {
@@ -538,10 +542,12 @@ int make_bcache(int argc, char **argv)
 			bdev = 1;
 			break;
 		case 'b':
-			bucket_size = hatoi_validate(optarg, "bucket size");
+			bucket_size =
+				hatoi_validate(optarg, "bucket size", UINT_MAX);
 			break;
 		case 'w':
-			block_size = hatoi_validate(optarg, "block size");
+			block_size =
+				hatoi_validate(optarg, "block size", USHRT_MAX);
 			break;
 #if 0
 		case 'U':
-- 
2.26.2

