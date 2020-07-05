Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E55214DEC
	for <lists+linux-bcache@lfdr.de>; Sun,  5 Jul 2020 18:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgGEQE6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 5 Jul 2020 12:04:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:39574 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727773AbgGEQE6 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 5 Jul 2020 12:04:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1EEF6ACFE;
        Sun,  5 Jul 2020 16:04:55 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [RFC PATCH 4/4] bcache-tools: add large_bucket incompat feature
Date:   Mon,  6 Jul 2020 00:04:40 +0800
Message-Id: <20200705160440.5801-5-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200705160440.5801-1-colyli@suse.de>
References: <20200705160440.5801-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This feature adds uint32_t bucket_size_hi into struct cache_sb, permit
bucket size to be 32bit width. Current maximum bucket size is 32MB,
extend it to 32bits will permit much large bucket size which is
desired by zoned SSD devices (a typical zone size is 256MB).

When setting a bucket size > 32MB, large_bucket feature will be set
automatically and the super block version will also be set to
BCACHE_SB_VERSION_CDEV_WITH_FEATURES.

Signed-off-by: Coly Li <colyli@suse.de>
---
 bcache.h        | 10 +++++++++-
 features.c      |  2 ++
 lib.c           | 24 ++++++++++++++++++++++++
 lib.h           |  2 ++
 make.c          | 28 ++++++++++++++++++----------
 struct_offset.c |  1 +
 6 files changed, 56 insertions(+), 11 deletions(-)

diff --git a/bcache.h b/bcache.h
index 3695712..6e1563b 100644
--- a/bcache.h
+++ b/bcache.h
@@ -101,7 +101,8 @@ struct cache_sb {
 	};
 	/* journal buckets */
 /*0d0*/	uint64_t		d[SB_JOURNAL_BUCKETS];
-/*8d0*/
+/*8d0*/	uint32_t		bucket_size_hi;
+/*8d4*/
 };
 
 static inline bool SB_IS_BDEV(const struct cache_sb *sb)
@@ -155,6 +156,11 @@ uint64_t crc64(const void *data, size_t len);
 /* Feature set definition */
 
 
+/* Feature set definition */
+
+/* Incompat feature set */
+#define BCH_FEATURE_INCOMPAT_LARGE_BUCKET	0x0001 /* 32bit bucket size */
+
 #define BCH_FEATURE_COMPAT_FUNCS(name, flagname) \
 static inline int bch_has_feature_##name(struct cache_sb *sb) \
 { \
@@ -206,4 +212,6 @@ static inline void bch_clear_feature_##name(struct cache_sb *sb) \
 		~BCH##_FEATURE_INCOMPAT_##flagname; \
 }
 
+BCH_FEATURE_INCOMPAT_FUNCS(large_bucket, LARGE_BUCKET);
+
 #endif
diff --git a/features.c b/features.c
index 013a5ca..9b6e93d 100644
--- a/features.c
+++ b/features.c
@@ -18,5 +18,7 @@ struct feature {
 };
 
 static struct feature feature_list[] = {
+	{BCH_FEATURE_COMPAT, BCH_FEATURE_INCOMPAT_LARGE_BUCKET,
+		"large_bucket"},
 	{0, 0, 0 },
 };
diff --git a/lib.c b/lib.c
index 9e69419..76e8b0d 100644
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
@@ -681,3 +682,26 @@ int set_label(char *devname, char *label)
 	close(fd);
 	return 0;
 }
+
+void set_bucket_size(struct cache_sb *sb, unsigned int bucket_size)
+{
+	if (bucket_size > USHRT_MAX) {
+		sb->version = BCACHE_SB_VERSION_CDEV_WITH_FEATURES;
+		bch_set_feature_large_bucket(sb);
+		sb->bucket_size = (uint16_t)bucket_size;
+		sb->bucket_size_hi = (uint32_t)(bucket_size >> 16);
+	} else {
+		sb->bucket_size = bucket_size;
+	}
+}
+
+unsigned int get_bucket_size(struct cache_sb *sb)
+{
+	unsigned int bucket_size = sb->bucket_size;
+
+	if (sb->version >= BCACHE_SB_VERSION_CDEV_WITH_FEATURES &&
+	    bch_has_feature_large_bucket(sb))
+		bucket_size |= sb->bucket_size_hi << 16;
+
+	return bucket_size;
+}
diff --git a/lib.h b/lib.h
index d4537b0..a69e1b8 100644
--- a/lib.h
+++ b/lib.h
@@ -50,6 +50,8 @@ int detach_backdev(char *devname);
 int set_backdev_cachemode(char *devname, char *cachemode);
 int set_label(char *devname, char *label);
 int cset_to_devname(struct list_head *head, char *cset, char *devname);
+void set_bucket_size(struct cache_sb *sb, unsigned int bucket_size);
+unsigned int get_bucket_size(struct cache_sb *sb);
 
 
 #define DEVLEN sizeof(struct dev)
diff --git a/make.c b/make.c
index 6d37532..b788de1 100644
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
@@ -229,7 +231,6 @@ static void swap_sb(struct cache_sb *sb, int write_cdev_super)
 
 	/* swap to little endian byte order to write */
 	sb->offset		= cpu_to_le64(sb->offset);
-	sb->version		= cpu_to_le64(sb->version);
 	sb->flags		= cpu_to_le64(sb->flags);
 	sb->seq			= cpu_to_le64(sb->seq);
 	sb->last_mount		= cpu_to_le32(sb->last_mount);
@@ -244,6 +245,9 @@ static void swap_sb(struct cache_sb *sb, int write_cdev_super)
 		/* Cache devices */
 		sb->nbuckets	= cpu_to_le64(sb->nbuckets);
 		sb->bucket_size	= cpu_to_le16(sb->bucket_size);
+		if (sb->version >= BCACHE_SB_VERSION_CDEV_WITH_FEATURES &&
+		    bch_has_feature_large_bucket(sb))
+			sb->bucket_size_hi = cpu_to_le32(sb->bucket_size_hi);
 		sb->nr_in_set	= cpu_to_le16(sb->nr_in_set);
 		sb->nr_this_dev	= cpu_to_le16(sb->nr_this_dev);
 	} else {
@@ -374,7 +378,7 @@ static void write_sb(char *dev, unsigned int block_size,
 	uuid_generate(sb.uuid);
 	memcpy(sb.set_uuid, set_uuid, sizeof(sb.set_uuid));
 
-	sb.bucket_size	= bucket_size;
+	set_bucket_size(&sb, bucket_size);
 	sb.block_size	= block_size;
 
 	uuid_unparse(sb.uuid, uuid_str);
@@ -400,7 +404,8 @@ static void write_sb(char *dev, unsigned int block_size,
 		}
 
 		if (data_offset != BDEV_DATA_START_DEFAULT) {
-			sb.version = BCACHE_SB_VERSION_BDEV_WITH_OFFSET;
+			if (sb.version < BCACHE_SB_VERSION_BDEV_WITH_OFFSET)
+				sb.version = BCACHE_SB_VERSION_BDEV_WITH_OFFSET;
 			sb.data_offset = data_offset;
 		}
 
@@ -418,9 +423,10 @@ static void write_sb(char *dev, unsigned int block_size,
 		       data_offset);
 		putchar('\n');
 	} else {
-		sb.nbuckets		= getblocks(fd) / sb.bucket_size;
+		sb.nbuckets		= getblocks(fd) / get_bucket_size(&sb);
 		sb.nr_in_set		= 1;
-		sb.first_bucket		= (23 / sb.bucket_size) + 1;
+		/* 23 is (SB_SECTOR + SB_SIZE) - 1 sectors */
+		sb.first_bucket		= (23 / get_bucket_size(&sb)) + 1;
 
 		if (sb.nbuckets < 1 << 7) {
 			fprintf(stderr, "Not enough buckets: %ju, need %u\n",
@@ -447,7 +453,7 @@ static void write_sb(char *dev, unsigned int block_size,
 		       (unsigned int) sb.version,
 		       sb.nbuckets,
 		       sb.block_size,
-		       sb.bucket_size,
+		       get_bucket_size(&sb),
 		       sb.nr_in_set,
 		       sb.nr_this_dev,
 		       sb.first_bucket);
@@ -576,10 +582,12 @@ int make_bcache(int argc, char **argv)
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
diff --git a/struct_offset.c b/struct_offset.c
index 54d4a34..4ffacf7 100644
--- a/struct_offset.c
+++ b/struct_offset.c
@@ -52,6 +52,7 @@ void print_cache_sb()
 	printf("/* %3.3lx */         	uint16_t	keys;\n", OFF_SB(keys));
 	printf("                  };\n");
 	printf("/* %3.3lx */         uint64_t		d[%u];\n", OFF_SB(d), SB_JOURNAL_BUCKETS);
+	printf("/* %3.3lx */         uint32_t		bucket_size_hi;\n", OFF_SB(bucket_size_hi));
 	printf("/* %3.3lx */ }\n", sizeof(struct cache_sb));
 }
 
-- 
2.26.2

