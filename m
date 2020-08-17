Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D082465F7
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Aug 2020 14:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgHQMGZ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 17 Aug 2020 08:06:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:53466 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbgHQMGY (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Aug 2020 08:06:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 89273AEDA
        for <linux-bcache@vger.kernel.org>; Mon, 17 Aug 2020 12:06:47 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>
Subject: [PATCH 5/8] bcache-tools: define separated super block for in-memory and on-disk format
Date:   Mon, 17 Aug 2020 20:05:55 +0800
Message-Id: <20200817120558.4491-6-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200817120558.4491-1-colyli@suse.de>
References: <20200817120558.4491-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch syncrhonizes the super block definition from bcache kernel
code, now the original super block structure is changed into two,
- struct cache_sb_disk
  This is for on-disk bcache super block format, which is exactly same
  as original struct cache_sb.
- struct cache_sb
  This is only for in-memory super block, it is no longer exactly
  mapping to the members and offsets to the cache_sb_disk.

Most part of the patch is to make source code to be consistent to the
data structures change.

Signed-off-by: Coly Li <colyli@suse.de>
---
 Makefile            |  2 +-
 bcache-super-show.c | 22 +++++++++++--------
 bcache.h            | 49 ++++++++++++++++++++++--------------------
 lib.c               | 18 +++++++++++-----
 make.c              | 52 ++++++++++-----------------------------------
 probe-bcache.c      |  8 +++----
 6 files changed, 68 insertions(+), 83 deletions(-)

diff --git a/Makefile b/Makefile
index 2c326cf..b4546a1 100644
--- a/Makefile
+++ b/Makefile
@@ -31,7 +31,7 @@ probe-bcache: CFLAGS += `pkg-config --cflags uuid blkid`
 
 bcache-super-show: LDLIBS += `pkg-config --libs uuid`
 bcache-super-show: CFLAGS += -std=gnu99
-bcache-super-show: crc64.o
+bcache-super-show: crc64.o lib.o
 
 bcache-register: bcache-register.o
 
diff --git a/bcache-super-show.c b/bcache-super-show.c
index 26cc40e..883410f 100644
--- a/bcache-super-show.c
+++ b/bcache-super-show.c
@@ -25,7 +25,8 @@
 #include <uuid/uuid.h>
 
 #include "bcache.h"
-
+#include "lib.h"
+#include "bitwise.h"
 
 static void usage()
 {
@@ -61,6 +62,7 @@ int main(int argc, char **argv)
 	bool force_csum = false;
 	int o;
 	extern char *optarg;
+	struct cache_sb_disk sb_disk;
 	struct cache_sb sb;
 	char uuid[40];
 	uint64_t expected_csum;
@@ -90,11 +92,13 @@ int main(int argc, char **argv)
 		exit(2);
 	}
 
-	if (pread(fd, &sb, sizeof(sb), SB_START) != sizeof(sb)) {
+	if (pread(fd, &sb_disk, sizeof(sb_disk), SB_START) != sizeof(sb_disk)) {
 		fprintf(stderr, "Couldn't read\n");
 		exit(2);
 	}
 
+	to_cache_sb(&sb, &sb_disk);
+
 	printf("sb.magic\t\t");
 	if (!memcmp(sb.magic, bcache_magic, 16)) {
 		printf("ok\n");
@@ -104,7 +108,7 @@ int main(int argc, char **argv)
 		exit(2);
 	}
 
-	printf("sb.first_sector\t\t%" PRIu64, sb.offset);
+	printf("sb.first_sector\t\t%llu", sb.offset);
 	if (sb.offset == SB_SECTOR) {
 		printf(" [match]\n");
 	} else {
@@ -113,9 +117,9 @@ int main(int argc, char **argv)
 		exit(2);
 	}
 
-	printf("sb.csum\t\t\t%" PRIX64, sb.csum);
-	expected_csum = csum_set(&sb);
-	if (sb.csum == expected_csum) {
+	printf("sb.csum\t\t\t%llx", le64_to_cpu(sb_disk.csum));
+	expected_csum = csum_set(&sb_disk);
+	if (le64_to_cpu(sb_disk.csum) == expected_csum) {
 		printf(" [match]\n");
 	} else {
 		printf(" [expected %" PRIX64 "]\n", expected_csum);
@@ -125,7 +129,7 @@ int main(int argc, char **argv)
 		}
 	}
 
-	printf("sb.version\t\t%" PRIu64, sb.version);
+	printf("sb.version\t\t%llu", sb.version);
 	switch (sb.version) {
 		// These are handled the same by the kernel
 		case BCACHE_SB_VERSION_CDEV:
@@ -168,8 +172,8 @@ int main(int argc, char **argv)
 	if (!SB_IS_BDEV(&sb)) {
 		// total_sectors includes the superblock;
 		printf("dev.cache.first_sector\t%u\n"
-		       "dev.cache.cache_sectors\t%ju\n"
-		       "dev.cache.total_sectors\t%ju\n"
+		       "dev.cache.cache_sectors\t%llu\n"
+		       "dev.cache.total_sectors\t%llu\n"
 		       "dev.cache.ordered\t%s\n"
 		       "dev.cache.discard\t%s\n"
 		       "dev.cache.pos\t\t%u\n"
diff --git a/bcache.h b/bcache.h
index 82fe580..250da9d 100644
--- a/bcache.h
+++ b/bcache.h
@@ -94,38 +94,41 @@ struct cache_sb_disk {
 	__le64			d[SB_JOURNAL_BUCKETS];	/* journal buckets */
 };
 
+/*
+ * This is for in-memory bcache super block.
+ * NOTE: cache_sb is NOT exactly mapping to cache_sb_disk, the member
+ *       size, ordering and even whole struct size may be different
+ *       from cache_sb_disk.
+ */
 struct cache_sb {
-	uint64_t		csum;
-	uint64_t		offset;	/* sector where this sb was written */
-	uint64_t		version;
+	__u64			offset; /* sector where this sb was written */
+	__u64			version;
 
-	uint8_t			magic[16];
+	__u8			magic[16];
 
-	uint8_t			uuid[16];
+	__u8			uuid[16];
 	union {
-		uint8_t		set_uuid[16];
-		uint64_t	set_magic;
+		__u8		set_uuid[16];
+		__u64		set_magic;
 	};
-	uint8_t			label[SB_LABEL_SIZE];
+	__u8			label[SB_LABEL_SIZE];
 
-	uint64_t		flags;
-	uint64_t		seq;
-	uint64_t		pad[8];
+	__u64			flags;
+	__u64			seq;
 
 	union {
 	struct {
 		/* Cache devices */
-		uint64_t	nbuckets;	/* device size */
-
-		uint16_t	block_size;	/* sectors */
-		uint16_t	bucket_size;	/* sectors */
+		__u64		nbuckets;	/* device size */
 
-		uint16_t	nr_in_set;
-		uint16_t	nr_this_dev;
+		__u16		block_size;	/* sectors */
+		__u16		nr_in_set;
+		__u16		nr_this_dev;
+		__u32		bucket_size;	/* sectors */
 	};
 	struct {
 		/* Backing devices */
-		uint64_t	data_offset;
+		__u64		data_offset;
 
 		/*
 		 * block_size from the cache device section is still used by
@@ -135,14 +138,14 @@ struct cache_sb {
 	};
 	};
 
-	uint32_t		last_mount;	/* time_t */
+	__u32			last_mount;	/* time overflow in y2106 */
 
-	uint16_t		first_bucket;
+	__u16			first_bucket;
 	union {
-		uint16_t	njournal_buckets;
-		uint16_t	keys;
+		__u16		njournal_buckets;
+		__u16		keys;
 	};
-	uint64_t		d[SB_JOURNAL_BUCKETS];	/* journal buckets */
+	__u64			d[SB_JOURNAL_BUCKETS];  /* journal buckets */
 };
 
 static inline bool SB_IS_BDEV(const struct cache_sb *sb)
diff --git a/lib.c b/lib.c
index 542f115..9a2fa26 100644
--- a/lib.c
+++ b/lib.c
@@ -293,7 +293,6 @@ int detail_base(char *devname, struct cache_sb sb, struct dev *base)
 	strcpy(base->name, devname);
 	base->magic = "ok";
 	base->first_sector = SB_SECTOR;
-	base->csum = sb.csum;
 	base->version = sb.version;
 
 	strncpy(base->label, (char *) sb.label, SB_LABEL_SIZE);
@@ -325,6 +324,7 @@ int detail_base(char *devname, struct cache_sb sb, struct dev *base)
 
 int may_add_item(char *devname, struct list_head *head)
 {
+	struct cache_sb_disk sb_disk;
 	struct cache_sb sb;
 
 	if (strcmp(devname, ".") == 0 || strcmp(devname, "..") == 0)
@@ -336,10 +336,13 @@ int may_add_item(char *devname, struct list_head *head)
 
 	if (fd == -1)
 		return 0;
-	if (pread(fd, &sb, sizeof(sb), SB_START) != sizeof(sb)) {
+	if (pread(fd, &sb_disk, sizeof(sb_disk), SB_START) != sizeof(sb_disk)) {
 		close(fd);
 		return 0;
 	}
+
+	to_cache_sb(&sb, &sb_disk);
+
 	if (memcmp(sb.magic, bcache_magic, 16)) {
 		close(fd);
 		return 0;
@@ -348,6 +351,8 @@ int may_add_item(char *devname, struct list_head *head)
 	int ret;
 
 	tmp = (struct dev *) malloc(DEVLEN);
+
+	tmp->csum = le64_to_cpu(sb_disk.csum);
 	ret = detail_base(dev, sb, tmp);
 	if (ret != 0) {
 		fprintf(stderr, "Failed to get information for %s\n", dev);
@@ -399,6 +404,7 @@ int list_bdevs(struct list_head *head)
 
 int detail_dev(char *devname, struct bdev *bd, struct cdev *cd, int *type)
 {
+	struct cache_sb_disk sb_disk;
 	struct cache_sb sb;
 	uint64_t expected_csum;
 	int fd = open(devname, O_RDONLY);
@@ -408,11 +414,13 @@ int detail_dev(char *devname, struct bdev *bd, struct cdev *cd, int *type)
 		return 1;
 	}
 
-	if (pread(fd, &sb, sizeof(sb), SB_START) != sizeof(sb)) {
+	if (pread(fd, &sb_disk, sizeof(sb_disk), SB_START) != sizeof(sb_disk)) {
 		fprintf(stderr, "Couldn't read\n");
 		goto Fail;
 	}
 
+	to_cache_sb(&sb, &sb_disk);
+
 	if (memcmp(sb.magic, bcache_magic, 16)) {
 		fprintf(stderr,
 			"Bad magic,make sure this is an bcache device\n");
@@ -424,8 +432,8 @@ int detail_dev(char *devname, struct bdev *bd, struct cdev *cd, int *type)
 		goto Fail;
 	}
 
-	expected_csum = csum_set(&sb);
-	if (!(sb.csum == expected_csum)) {
+	expected_csum = csum_set(&sb_disk);
+	if (le64_to_cpu(sb_disk.csum) != expected_csum) {
 		fprintf(stderr, "Csum is not match with expected one\n");
 		goto Fail;
 	}
diff --git a/make.c b/make.c
index cc76863..a239023 100644
--- a/make.c
+++ b/make.c
@@ -223,35 +223,6 @@ err:
 	return -1;
 }
 
-static void swap_sb(struct cache_sb *sb, int write_cdev_super)
-{
-	int i;
-
-	/* swap to little endian byte order to write */
-	sb->offset		= cpu_to_le64(sb->offset);
-	sb->version		= cpu_to_le64(sb->version);
-	sb->flags		= cpu_to_le64(sb->flags);
-	sb->seq			= cpu_to_le64(sb->seq);
-	sb->last_mount		= cpu_to_le32(sb->last_mount);
-	sb->first_bucket	= cpu_to_le16(sb->first_bucket);
-	sb->keys		= cpu_to_le16(sb->keys);
-	sb->block_size		= cpu_to_le16(sb->block_size);
-
-	for (i = 0; i < SB_JOURNAL_BUCKETS; i++)
-		sb->d[i]	= cpu_to_le64(sb->d[i]);
-
-	if (write_cdev_super) {
-		/* Cache devices */
-		sb->nbuckets	= cpu_to_le64(sb->nbuckets);
-		sb->bucket_size	= cpu_to_le16(sb->bucket_size);
-		sb->nr_in_set	= cpu_to_le16(sb->nr_in_set);
-		sb->nr_this_dev	= cpu_to_le16(sb->nr_this_dev);
-	} else {
-		/* Backing devices */
-		sb->data_offset	= cpu_to_le64(sb->data_offset);
-	}
-}
-
 static void write_sb(char *dev, unsigned int block_size,
 			unsigned int bucket_size,
 			bool writeback, bool discard, bool wipe_bcache,
@@ -261,9 +232,9 @@ static void write_sb(char *dev, unsigned int block_size,
 {
 	int fd;
 	char uuid_str[40], set_uuid_str[40], zeroes[SB_START] = {0};
+	struct cache_sb_disk sb_disk;
 	struct cache_sb sb;
 	blkid_probe pr;
-	int write_cdev_super = 1;
 
 	fd = open(dev, O_RDWR|O_EXCL);
 
@@ -320,13 +291,13 @@ static void write_sb(char *dev, unsigned int block_size,
 	if (force)
 		wipe_bcache = true;
 
-	if (pread(fd, &sb, sizeof(sb), SB_START) != sizeof(sb))
+	if (pread(fd, &sb_disk, sizeof(sb_disk), SB_START) != sizeof(sb_disk))
 		exit(EXIT_FAILURE);
 
-	if (!memcmp(sb.magic, bcache_magic, 16)) {
+	if (!memcmp(sb_disk.magic, bcache_magic, 16)) {
 		if (wipe_bcache) {
-			if (pwrite(fd, zeroes, sizeof(sb),
-				SB_START) != sizeof(sb)) {
+			if (pwrite(fd, zeroes, sizeof(sb_disk),
+				SB_START) != sizeof(sb_disk)) {
 				fprintf(stderr,
 					"Failed to erase super block for %s\n",
 					dev);
@@ -355,6 +326,7 @@ static void write_sb(char *dev, unsigned int block_size,
 		exit(EXIT_FAILURE);
 	}
 
+	memset(&sb_disk, 0, sizeof(struct cache_sb_disk));
 	memset(&sb, 0, sizeof(struct cache_sb));
 
 	sb.offset	= SB_SECTOR;
@@ -373,8 +345,6 @@ static void write_sb(char *dev, unsigned int block_size,
 	uuid_unparse(sb.set_uuid, set_uuid_str);
 
 	if (SB_IS_BDEV(&sb)) {
-		write_cdev_super = 0;
-
 		SET_BDEV_CACHE_MODE(&sb, writeback ?
 			CACHE_MODE_WRITEBACK : CACHE_MODE_WRITETHROUGH);
 
@@ -415,7 +385,7 @@ static void write_sb(char *dev, unsigned int block_size,
 		sb.first_bucket		= (23 / sb.bucket_size) + 1;
 
 		if (sb.nbuckets < 1 << 7) {
-			fprintf(stderr, "Not enough buckets: %ju, need %u\n",
+			fprintf(stderr, "Not enough buckets: %llu, need %u\n",
 			       sb.nbuckets, 1 << 7);
 			exit(EXIT_FAILURE);
 		}
@@ -429,7 +399,7 @@ static void write_sb(char *dev, unsigned int block_size,
 		printf("UUID:			%s\n"
 		       "Set UUID:		%s\n"
 		       "version:		%u\n"
-		       "nbuckets:		%ju\n"
+		       "nbuckets:		%llu\n"
 		       "block_size_in_sectors:	%u\n"
 		       "bucket_size_in_sectors:	%u\n"
 		       "nr_in_set:		%u\n"
@@ -462,17 +432,17 @@ static void write_sb(char *dev, unsigned int block_size,
 	 * Swap native bytes order to little endian for writing
 	 * the super block out.
 	 */
-	swap_sb(&sb, write_cdev_super);
+	to_cache_sb_disk(&sb_disk, &sb);
 
 	/* write csum */
-	sb.csum = csum_set(&sb);
+	sb_disk.csum = cpu_to_le64(csum_set(&sb_disk));
 	/* Zero start of disk */
 	if (pwrite(fd, zeroes, SB_START, 0) != SB_START) {
 		perror("write error\n");
 		exit(EXIT_FAILURE);
 	}
 	/* Write superblock */
-	if (pwrite(fd, &sb, sizeof(sb), SB_START) != sizeof(sb)) {
+	if (pwrite(fd, &sb_disk, sizeof(sb_disk), SB_START) != sizeof(sb_disk)) {
 		perror("write error\n");
 		exit(EXIT_FAILURE);
 	}
diff --git a/probe-bcache.c b/probe-bcache.c
index c94c972..a640046 100644
--- a/probe-bcache.c
+++ b/probe-bcache.c
@@ -29,7 +29,7 @@ int main(int argc, char **argv)
 	bool udev = false;
 	int i, o;
 	extern char *optarg;
-	struct cache_sb sb;
+	struct cache_sb_disk sb_disk;
 	char uuid[40];
 	blkid_probe pr;
 
@@ -66,13 +66,13 @@ int main(int argc, char **argv)
 			continue;
 		}
 
-		if (pread(fd, &sb, sizeof(sb), SB_START) != sizeof(sb))
+		if (pread(fd, &sb_disk, sizeof(sb_disk), SB_START) != sizeof(sb_disk))
 			continue;
 
-		if (memcmp(sb.magic, bcache_magic, 16))
+		if (memcmp(sb_disk.magic, bcache_magic, 16))
 			continue;
 
-		uuid_unparse(sb.uuid, uuid);
+		uuid_unparse(sb_disk.uuid, uuid);
 
 		if (udev)
 			printf("ID_FS_UUID=%s\n"
-- 
2.26.2

