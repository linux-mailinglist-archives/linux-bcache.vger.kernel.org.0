Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42410311BE5
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Feb 2021 08:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhBFHVA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 6 Feb 2021 02:21:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:47944 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhBFHU7 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 6 Feb 2021 02:20:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3E3E5AE72;
        Sat,  6 Feb 2021 07:20:17 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 4/6] bcache-tools: move super block info display routines into show.c
Date:   Sat,  6 Feb 2021 15:20:03 +0800
Message-Id: <20210206072005.24811-5-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210206072005.24811-1-colyli@suse.de>
References: <20210206072005.24811-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch moves the following routines from bcache.c into show.c,
- show_bdevs_detail()
- show_bdevs()
- detail_single()

As side effect, in order to fix the calling dependences, these routines
are moved into lib.c,
- accepted_char()
- print_encode()
- free_dev()

Now following changes to show related routines won't make bcache.c more
complicated.

Signed-off-by: Coly Li <colyli@suse.de>
---
 Makefile            |   2 +-
 bcache-super-show.c |  24 ----
 bcache.c            | 278 +-------------------------------------------
 lib.c               |  97 +++++++++++++---
 lib.h               |   3 +
 make.c              |   1 -
 show.c              | 277 +++++++++++++++++++++++++++++++++++++++++++
 show.h              |  10 ++
 8 files changed, 371 insertions(+), 321 deletions(-)
 create mode 100644 show.c
 create mode 100644 show.h

diff --git a/Makefile b/Makefile
index d914200..5496c35 100644
--- a/Makefile
+++ b/Makefile
@@ -39,4 +39,4 @@ bcache-register: bcache-register.o
 bcache: CFLAGS += `pkg-config --cflags blkid uuid`
 bcache: LDLIBS += `pkg-config --libs blkid uuid`
 bcache: CFLAGS += -std=gnu99
-bcache: crc64.o lib.o make.o zoned.o features.o
+bcache: crc64.o lib.o make.o zoned.o features.o show.o
diff --git a/bcache-super-show.c b/bcache-super-show.c
index cc36029..407f418 100644
--- a/bcache-super-show.c
+++ b/bcache-super-show.c
@@ -33,30 +33,6 @@ static void usage()
 	fprintf(stderr, "Usage: bcache-super-show [-f] <device>\n");
 }
 
-
-static bool accepted_char(char c)
-{
-	if ('0' <= c && c <= '9')
-		return true;
-	if ('A' <= c && c <= 'Z')
-		return true;
-	if ('a' <= c && c <= 'z')
-		return true;
-	if (strchr(".-_", c))
-		return true;
-	return false;
-}
-
-static void print_encode(char* in)
-{
-	for (char* pos = in; *pos; pos++)
-		if (accepted_char(*pos))
-			putchar(*pos);
-		else
-			printf("%%%x", *pos);
-}
-
-
 int main(int argc, char **argv)
 {
 	bool force_csum = false;
diff --git a/bcache.c b/bcache.c
index 234702b..5558914 100644
--- a/bcache.c
+++ b/bcache.c
@@ -19,34 +19,10 @@
 #include <assert.h>
 
 #include "features.h"
+#include "show.h"
 
 #define BCACHE_TOOLS_VERSION	"1.1"
 
-//utils function
-static bool accepted_char(char c)
-{
-	if ('0' <= c && c <= '9')
-		return true;
-	if ('A' <= c && c <= 'Z')
-		return true;
-	if ('a' <= c && c <= 'z')
-		return true;
-	if (strchr(".-_", c))
-		return true;
-	return false;
-}
-
-static void print_encode(char *in)
-{
-	char *pos;
-
-	for (pos = in; *pos; pos++)
-		if (accepted_char(*pos))
-			putchar(*pos);
-		else
-			printf("%%%x", *pos);
-}
-
 bool bad_uuid(char *uuid)
 {
 	const char *pattern =
@@ -173,258 +149,6 @@ int version_usagee(void)
 	return EXIT_FAILURE;
 }
 
-void free_dev(struct list_head *head)
-{
-	struct dev *dev, *n;
-
-	list_for_each_entry_safe(dev, n, head, dev_list) {
-		free(dev);
-	}
-}
-
-int show_bdevs_detail(void)
-{
-	struct list_head head;
-	struct dev *devs, *n;
-
-	INIT_LIST_HEAD(&head);
-	int ret;
-
-	ret = list_bdevs(&head);
-	if (ret != 0) {
-		fprintf(stderr, "Failed to list devices\n");
-		return ret;
-	}
-	printf("Name\t\tUuid\t\t\t\t\tCset_Uuid\t\t\t\tType\t\t\tState");
-	printf("\t\t\tBname\t\tAttachToDev\tAttachToCset\n");
-	list_for_each_entry_safe(devs, n, &head, dev_list) {
-		printf("%s\t%s\t%s\t%lu", devs->name, devs->uuid,
-		       devs->cset, devs->version);
-		switch (devs->version) {
-			// These are handled the same by the kernel
-		case BCACHE_SB_VERSION_CDEV:
-		case BCACHE_SB_VERSION_CDEV_WITH_UUID:
-		case BCACHE_SB_VERSION_CDEV_WITH_FEATURES:
-			printf(" (cache)");
-			break;
-			// The second adds data offset supporet
-		case BCACHE_SB_VERSION_BDEV:
-		case BCACHE_SB_VERSION_BDEV_WITH_OFFSET:
-		case BCACHE_SB_VERSION_BDEV_WITH_FEATURES:
-			printf(" (data)");
-			break;
-		default:
-			printf(" (unknown)");
-			break;
-		}
-		printf("\t\t%-16s", devs->state);
-		printf("\t%-16s", devs->bname);
-		char attachdev[30];
-
-		if (strlen(devs->attachuuid) == 36) {
-			cset_to_devname(&head, devs->cset, attachdev);
-		} else if (devs->version == BCACHE_SB_VERSION_CDEV
-			   || devs->version ==
-			   BCACHE_SB_VERSION_CDEV_WITH_UUID) {
-			strcpy(attachdev, BCACHE_NO_SUPPORT);
-		} else {
-			strcpy(attachdev, BCACHE_ATTACH_ALONE);
-		}
-		printf("%-16s", attachdev);
-		printf("%s", devs->attachuuid);
-		putchar('\n');
-	}
-	free_dev(&head);
-	return 0;
-}
-
-
-int show_bdevs(void)
-{
-	struct list_head head;
-	struct dev *devs, *n;
-
-	INIT_LIST_HEAD(&head);
-	int ret;
-
-	ret = list_bdevs(&head);
-	if (ret != 0) {
-		fprintf(stderr, "Failed to list devices\n");
-		return ret;
-	}
-
-	printf("Name\t\tType\t\tState\t\t\tBname\t\tAttachToDev\n");
-	list_for_each_entry_safe(devs, n, &head, dev_list) {
-		printf("%s\t%lu", devs->name, devs->version);
-		switch (devs->version) {
-			// These are handled the same by the kernel
-		case BCACHE_SB_VERSION_CDEV:
-		case BCACHE_SB_VERSION_CDEV_WITH_UUID:
-		case BCACHE_SB_VERSION_CDEV_WITH_FEATURES:
-			printf(" (cache)");
-			break;
-
-			// The second adds data offset supporet
-		case BCACHE_SB_VERSION_BDEV:
-		case BCACHE_SB_VERSION_BDEV_WITH_OFFSET:
-		case BCACHE_SB_VERSION_BDEV_WITH_FEATURES:
-			printf(" (data)");
-			break;
-
-		default:
-			printf(" (unknown)");
-			break;
-		}
-
-		printf("\t%-16s", devs->state);
-		printf("\t%-16s", devs->bname);
-
-		char attachdev[30];
-
-		if (strlen(devs->attachuuid) == 36) {
-			cset_to_devname(&head, devs->cset, attachdev);
-		} else if (devs->version == BCACHE_SB_VERSION_CDEV
-			   || devs->version ==
-			   BCACHE_SB_VERSION_CDEV_WITH_UUID) {
-			strcpy(attachdev, BCACHE_NO_SUPPORT);
-		} else {
-			strcpy(attachdev, BCACHE_ATTACH_ALONE);
-		}
-		printf("%s", attachdev);
-		putchar('\n');
-	}
-	free_dev(&head);
-	return 0;
-}
-
-int detail_single(char *devname)
-{
-	struct bdev bd;
-	struct cdev cd;
-	int type = 1;
-	int ret;
-
-	ret = detail_dev(devname, &bd, &cd, &type);
-	if (ret != 0) {
-		fprintf(stderr, "Failed to detail device\n");
-		return ret;
-	}
-	if (type == BCACHE_SB_VERSION_BDEV ||
-	    type == BCACHE_SB_VERSION_BDEV_WITH_OFFSET ||
-	    type == BCACHE_SB_VERSION_BDEV_WITH_FEATURES) {
-		printf("sb.magic\t\t%s\n", bd.base.magic);
-		printf("sb.first_sector\t\t%" PRIu64 "\n",
-		       bd.base.first_sector);
-		printf("sb.csum\t\t\t%" PRIX64 "\n", bd.base.csum);
-		printf("sb.version\t\t%" PRIu64, bd.base.version);
-		printf(" [backing device]\n");
-		putchar('\n');
-		printf("dev.label\t\t");
-		if (*bd.base.label)
-			print_encode(bd.base.label);
-		else
-			printf("(empty)");
-		putchar('\n');
-		printf("dev.uuid\t\t%s\n", bd.base.uuid);
-		printf("dev.sectors_per_block\t%u\n"
-		       "dev.sectors_per_bucket\t%u\n",
-		       bd.base.sectors_per_block,
-		       bd.base.sectors_per_bucket);
-		printf("dev.data.first_sector\t%u\n"
-		       "dev.data.cache_mode\t%d",
-		       bd.first_sector, bd.cache_mode);
-		switch (bd.cache_mode) {
-		case CACHE_MODE_WRITETHROUGH:
-			printf(" [writethrough]\n");
-			break;
-		case CACHE_MODE_WRITEBACK:
-			printf(" [writeback]\n");
-			break;
-		case CACHE_MODE_WRITEAROUND:
-			printf(" [writearound]\n");
-			break;
-		case CACHE_MODE_NONE:
-			printf(" [no caching]\n");
-			break;
-		default:
-			putchar('\n');
-		}
-		printf("dev.data.cache_state\t%u", bd.cache_state);
-		switch (bd.cache_state) {
-		case BDEV_STATE_NONE:
-			printf(" [detached]\n");
-			break;
-		case BDEV_STATE_CLEAN:
-			printf(" [clean]\n");
-			break;
-		case BDEV_STATE_DIRTY:
-			printf(" [dirty]\n");
-			break;
-		case BDEV_STATE_STALE:
-			printf(" [inconsistent]\n");
-			break;
-		default:
-			putchar('\n');
-		}
-
-		putchar('\n');
-		printf("cset.uuid\t\t%s\n", bd.base.cset);
-	} else if (type == BCACHE_SB_VERSION_CDEV ||
-		   type == BCACHE_SB_VERSION_CDEV_WITH_UUID ||
-		   type == BCACHE_SB_VERSION_CDEV_WITH_FEATURES) {
-		printf("sb.magic\t\t%s\n", cd.base.magic);
-		printf("sb.first_sector\t\t%" PRIu64 "\n",
-		       cd.base.first_sector);
-		printf("sb.csum\t\t\t%" PRIX64 "\n", cd.base.csum);
-		printf("sb.version\t\t%" PRIu64, cd.base.version);
-		printf(" [cache device]\n");
-		print_cache_set_supported_feature_sets(&cd.base.sb);
-		putchar('\n');
-		printf("dev.label\t\t");
-		if (*cd.base.label)
-			print_encode(cd.base.label);
-		else
-			printf("(empty)");
-		putchar('\n');
-		printf("dev.uuid\t\t%s\n", cd.base.uuid);
-		printf("dev.sectors_per_block\t%u\n"
-		       "dev.sectors_per_bucket\t%u\n",
-		       cd.base.sectors_per_block,
-		       cd.base.sectors_per_bucket);
-		printf("dev.cache.first_sector\t%u\n"
-		       "dev.cache.cache_sectors\t%ju\n"
-		       "dev.cache.total_sectors\t%ju\n"
-		       "dev.cache.ordered\t%s\n"
-		       "dev.cache.discard\t%s\n"
-		       "dev.cache.pos\t\t%u\n"
-		       "dev.cache.replacement\t%d",
-		       cd.first_sector,
-		       cd.cache_sectors,
-		       cd.total_sectors,
-		       cd.ordered ? "yes" : "no",
-		       cd.discard ? "yes" : "no", cd.pos, cd.replacement);
-		switch (cd.replacement) {
-		case CACHE_REPLACEMENT_LRU:
-			printf(" [lru]\n");
-			break;
-		case CACHE_REPLACEMENT_FIFO:
-			printf(" [fifo]\n");
-			break;
-		case CACHE_REPLACEMENT_RANDOM:
-			printf(" [random]\n");
-			break;
-		default:
-			putchar('\n');
-		}
-
-		putchar('\n');
-		printf("cset.uuid\t\t%s\n", cd.base.cset);
-	} else {
-		return 1;
-	}
-	return 0;
-}
-
 void replace_line(char **dest, const char *from, const char *to)
 {
 	assert(strlen(from) == strlen(to));
diff --git a/lib.c b/lib.c
index b8487db..05ce9b9 100644
--- a/lib.c
+++ b/lib.c
@@ -84,6 +84,39 @@ bool prefix_with(char *dst, char *prefix)
 	return true;
 }
 
+void free_dev(struct list_head *head)
+{
+	struct dev *dev, *n;
+
+	list_for_each_entry_safe(dev, n, head, dev_list) {
+		free(dev);
+	}
+}
+
+bool accepted_char(char c)
+{
+	if ('0' <= c && c <= '9')
+		return true;
+	if ('A' <= c && c <= 'Z')
+		return true;
+	if ('a' <= c && c <= 'z')
+		return true;
+	if (strchr(".-_", c))
+		return true;
+	return false;
+}
+
+void print_encode(char *in)
+{
+	char *pos;
+
+	for (pos = in; *pos; pos++)
+		if (accepted_char(*pos))
+			putchar(*pos);
+		else
+			printf("%%%x", *pos);
+}
+
 bool part_of_disk(char *devname, char *partname)
 {
 	char pattern[40];
@@ -418,28 +451,17 @@ int list_bdevs(struct list_head *head)
 	return 0;
 }
 
-int detail_dev(char *devname, struct bdev *bd, struct cdev *cd, int *type)
+int __detail_dev(char *devname, struct cache_sb_disk *sb_disk,
+		 struct bdev *bd, struct cdev *cd, int *type)
 {
-	struct cache_sb_disk sb_disk;
 	struct cache_sb sb;
 	uint64_t expected_csum;
-	int fd = open(devname, O_RDONLY);
-
-	if (fd < 0) {
-		fprintf(stderr, "Error: Can't open dev  %s\n", devname);
-		return 1;
-	}
-
-	if (pread(fd, &sb_disk, sizeof(sb_disk), SB_START) != sizeof(sb_disk)) {
-		fprintf(stderr, "Couldn't read\n");
-		goto Fail;
-	}
 
-	to_cache_sb(&sb, &sb_disk);
+	to_cache_sb(&sb, sb_disk);
 
 	if (memcmp(sb.magic, bcache_magic, 16)) {
 		fprintf(stderr,
-			"Bad magic,make sure this is an bcache device\n");
+			"Bad magic, make sure this is an bcache device\n");
 		goto Fail;
 	}
 
@@ -448,8 +470,8 @@ int detail_dev(char *devname, struct bdev *bd, struct cdev *cd, int *type)
 		goto Fail;
 	}
 
-	expected_csum = csum_set(&sb_disk);
-	if (le64_to_cpu(sb_disk.csum) != expected_csum) {
+	expected_csum = csum_set(sb_disk);
+	if (le64_to_cpu(sb_disk->csum) != expected_csum) {
 		fprintf(stderr, "Csum is not match with expected one\n");
 		goto Fail;
 	}
@@ -509,10 +531,49 @@ int detail_dev(char *devname, struct bdev *bd, struct cdev *cd, int *type)
 	}
 	return 0;
 Fail:
-	close(fd);
 	return 1;
 }
 
+int detail_dev(char *devname, struct bdev *bd, struct cdev *cd, int *type)
+{
+	char *buf = NULL;
+	struct cache_sb_disk *sb_disk = NULL;
+	int buf_size = 16<<10, ret = 1;
+	int fd;
+
+	buf = malloc(buf_size);
+	if (buf == NULL) {
+		fprintf(stderr, "Error: fail to allocate read buffer\n");
+		goto out;
+	}
+
+	fd = open(devname, O_RDONLY);
+	if (fd < 0) {
+		fprintf(stderr, "Error: Can't open dev  %s\n", devname);
+		goto out;
+	}
+
+	memset(buf, 0, buf_size);
+	if (pread(fd, buf, buf_size, 0) != buf_size) {
+		fprintf(stderr, "Couldn't read\n");
+		goto out_memory;
+	}
+
+	/* Try whether it is bcache super block */
+	sb_disk = (struct cache_sb_disk *)(buf + SB_START);
+	if (!memcmp(sb_disk->magic, bcache_magic, 16)) {
+		ret = __detail_dev(devname, sb_disk, bd, cd, type);
+		goto out_memory;
+	}
+
+	fprintf(stderr, "Error: Bad magic, not bcache device\n");
+
+out_memory:
+	free(buf);
+out:
+	return ret;
+}
+
 int register_dev(char *devname)
 {
 	int fd;
diff --git a/lib.h b/lib.h
index 0357a11..4c8df97 100644
--- a/lib.h
+++ b/lib.h
@@ -57,6 +57,9 @@ int cset_to_devname(struct list_head *head, char *cset, char *devname);
 struct cache_sb *to_cache_sb(struct cache_sb *sb, struct cache_sb_disk *sb_disk);
 struct cache_sb_disk *to_cache_sb_disk(struct cache_sb_disk *sb_disk,struct cache_sb *sb);
 void set_bucket_size(struct cache_sb *sb, unsigned int bucket_size);
+void free_dev(struct list_head *head);
+void print_encode(char *in);
+bool accepted_char(char c);
 
 #define DEVLEN sizeof(struct dev)
 
diff --git a/make.c b/make.c
index 5c2c1dd..92fe2a2 100644
--- a/make.c
+++ b/make.c
@@ -657,7 +657,6 @@ int make_bcache(int argc, char **argv)
 	sbc.data_offset = data_offset;
 	memcpy(sbc.set_uuid, set_uuid, sizeof(sbc.set_uuid));
 	sbc.label = label;
-	sbc.nvdimm_meta = (mdev == 1) ? true : false;
 
 	for (i = 0; i < ncache_devices; i++)
 		write_sb(cache_devices[i], &sbc, false, force);
diff --git a/show.c b/show.c
new file mode 100644
index 0000000..ff49862
--- /dev/null
+++ b/show.c
@@ -0,0 +1,277 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _FILE_OFFSET_BITS       64
+#define __USE_FILE_OFFSET64
+#define _XOPEN_SOURCE 600
+#define _DEFAULT_SOURCE
+
+#include <stdio.h>
+#include <inttypes.h>
+#include <string.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <unistd.h>
+#include <locale.h>
+#include <limits.h>
+#include <assert.h>
+#include <blkid/blkid.h>
+#include <ctype.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <linux/fs.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+#include <uuid/uuid.h>
+
+#include "bcache.h"
+#include "lib.h"
+#include "bitwise.h"
+#include "zoned.h"
+#include "features.h"
+#include "list.h"
+
+int show_bdevs_detail(void)
+{
+	struct list_head head;
+	struct dev *devs, *n;
+
+	INIT_LIST_HEAD(&head);
+	int ret;
+
+	ret = list_bdevs(&head);
+	if (ret != 0) {
+		fprintf(stderr, "Failed to list devices\n");
+		return ret;
+	}
+	printf("Name\t\tUuid\t\t\t\t\tCset_Uuid\t\t\t\tType\t\t\tState");
+	printf("\t\t\tBname\t\tAttachToDev\tAttachToCset\n");
+	list_for_each_entry_safe(devs, n, &head, dev_list) {
+		printf("%s\t%s\t%s\t%lu", devs->name, devs->uuid,
+		       devs->cset, devs->version);
+		switch (devs->version) {
+			// These are handled the same by the kernel
+		case BCACHE_SB_VERSION_CDEV:
+		case BCACHE_SB_VERSION_CDEV_WITH_UUID:
+		case BCACHE_SB_VERSION_CDEV_WITH_FEATURES:
+			printf(" (cache)");
+			break;
+			// The second adds data offset supporet
+		case BCACHE_SB_VERSION_BDEV:
+		case BCACHE_SB_VERSION_BDEV_WITH_OFFSET:
+		case BCACHE_SB_VERSION_BDEV_WITH_FEATURES:
+			printf(" (data)");
+			break;
+		default:
+			printf(" (unknown)");
+			break;
+		}
+		printf("\t\t%-16s", devs->state);
+		printf("\t%-16s", devs->bname);
+		char attachdev[30];
+
+		if (strlen(devs->attachuuid) == 36) {
+			cset_to_devname(&head, devs->cset, attachdev);
+		} else if (devs->version == BCACHE_SB_VERSION_CDEV
+			   || devs->version ==
+			   BCACHE_SB_VERSION_CDEV_WITH_UUID) {
+			strcpy(attachdev, BCACHE_NO_SUPPORT);
+		} else {
+			strcpy(attachdev, BCACHE_ATTACH_ALONE);
+		}
+		printf("%-16s", attachdev);
+		printf("%s", devs->attachuuid);
+		putchar('\n');
+	}
+	free_dev(&head);
+	return 0;
+}
+
+
+int show_bdevs(void)
+{
+	struct list_head head;
+	struct dev *devs, *n;
+
+	INIT_LIST_HEAD(&head);
+	int ret;
+
+	ret = list_bdevs(&head);
+	if (ret != 0) {
+		fprintf(stderr, "Failed to list devices\n");
+		return ret;
+	}
+
+	printf("Name\t\tType\t\tState\t\t\tBname\t\tAttachToDev\n");
+	list_for_each_entry_safe(devs, n, &head, dev_list) {
+		printf("%s\t%lu", devs->name, devs->version);
+		switch (devs->version) {
+			// These are handled the same by the kernel
+		case BCACHE_SB_VERSION_CDEV:
+		case BCACHE_SB_VERSION_CDEV_WITH_UUID:
+		case BCACHE_SB_VERSION_CDEV_WITH_FEATURES:
+			printf(" (cache)");
+			break;
+
+			// The second adds data offset supporet
+		case BCACHE_SB_VERSION_BDEV:
+		case BCACHE_SB_VERSION_BDEV_WITH_OFFSET:
+		case BCACHE_SB_VERSION_BDEV_WITH_FEATURES:
+			printf(" (data)");
+			break;
+
+		default:
+			printf(" (unknown)");
+			break;
+		}
+
+		printf("\t%-16s", devs->state);
+		printf("\t%-16s", devs->bname);
+
+		char attachdev[30];
+
+		if (strlen(devs->attachuuid) == 36) {
+			cset_to_devname(&head, devs->cset, attachdev);
+		} else if (devs->version == BCACHE_SB_VERSION_CDEV
+			   || devs->version ==
+			   BCACHE_SB_VERSION_CDEV_WITH_UUID) {
+			strcpy(attachdev, BCACHE_NO_SUPPORT);
+		} else {
+			strcpy(attachdev, BCACHE_ATTACH_ALONE);
+		}
+		printf("%s", attachdev);
+		putchar('\n');
+	}
+	free_dev(&head);
+	return 0;
+}
+
+int detail_single(char *devname)
+{
+	struct bdev bd;
+	struct cdev cd;
+	int type = 1;
+	int ret;
+
+	ret = detail_dev(devname, &bd, &cd, &type);
+	if (ret != 0) {
+		fprintf(stderr, "Failed to detail device\n");
+		return ret;
+	}
+	if (type == BCACHE_SB_VERSION_BDEV ||
+	    type == BCACHE_SB_VERSION_BDEV_WITH_OFFSET ||
+	    type == BCACHE_SB_VERSION_BDEV_WITH_FEATURES) {
+		printf("sb.magic\t\t%s\n", bd.base.magic);
+		printf("sb.first_sector\t\t%" PRIu64 "\n",
+		       bd.base.first_sector);
+		printf("sb.csum\t\t\t%" PRIX64 "\n", bd.base.csum);
+		printf("sb.version\t\t%" PRIu64, bd.base.version);
+		printf(" [backing device]\n");
+		putchar('\n');
+		printf("dev.label\t\t");
+		if (*bd.base.label)
+			print_encode(bd.base.label);
+		else
+			printf("(empty)");
+		putchar('\n');
+		printf("dev.uuid\t\t%s\n", bd.base.uuid);
+		printf("dev.sectors_per_block\t%u\n"
+		       "dev.sectors_per_bucket\t%u\n",
+		       bd.base.sectors_per_block,
+		       bd.base.sectors_per_bucket);
+		printf("dev.data.first_sector\t%u\n"
+		       "dev.data.cache_mode\t%d",
+		       bd.first_sector, bd.cache_mode);
+		switch (bd.cache_mode) {
+		case CACHE_MODE_WRITETHROUGH:
+			printf(" [writethrough]\n");
+			break;
+		case CACHE_MODE_WRITEBACK:
+			printf(" [writeback]\n");
+			break;
+		case CACHE_MODE_WRITEAROUND:
+			printf(" [writearound]\n");
+			break;
+		case CACHE_MODE_NONE:
+			printf(" [no caching]\n");
+			break;
+		default:
+			putchar('\n');
+		}
+		printf("dev.data.cache_state\t%u", bd.cache_state);
+		switch (bd.cache_state) {
+		case BDEV_STATE_NONE:
+			printf(" [detached]\n");
+			break;
+		case BDEV_STATE_CLEAN:
+			printf(" [clean]\n");
+			break;
+		case BDEV_STATE_DIRTY:
+			printf(" [dirty]\n");
+			break;
+		case BDEV_STATE_STALE:
+			printf(" [inconsistent]\n");
+			break;
+		default:
+			putchar('\n');
+		}
+
+		putchar('\n');
+		printf("cset.uuid\t\t%s\n", bd.base.cset);
+	} else if (type == BCACHE_SB_VERSION_CDEV ||
+		   type == BCACHE_SB_VERSION_CDEV_WITH_UUID ||
+		   type == BCACHE_SB_VERSION_CDEV_WITH_FEATURES) {
+		printf("sb.magic\t\t%s\n", cd.base.magic);
+		printf("sb.first_sector\t\t%" PRIu64 "\n",
+		       cd.base.first_sector);
+		printf("sb.csum\t\t\t%" PRIX64 "\n", cd.base.csum);
+		printf("sb.version\t\t%" PRIu64, cd.base.version);
+		printf(" [cache device]\n");
+		print_cache_set_supported_feature_sets(&cd.base.sb);
+		putchar('\n');
+		printf("dev.label\t\t");
+		if (*cd.base.label)
+			print_encode(cd.base.label);
+		else
+			printf("(empty)");
+		putchar('\n');
+		printf("dev.uuid\t\t%s\n", cd.base.uuid);
+		printf("dev.sectors_per_block\t%u\n"
+		       "dev.sectors_per_bucket\t%u\n",
+		       cd.base.sectors_per_block,
+		       cd.base.sectors_per_bucket);
+		printf("dev.cache.first_sector\t%u\n"
+		       "dev.cache.cache_sectors\t%ju\n"
+		       "dev.cache.total_sectors\t%ju\n"
+		       "dev.cache.ordered\t%s\n"
+		       "dev.cache.discard\t%s\n"
+		       "dev.cache.pos\t\t%u\n"
+		       "dev.cache.replacement\t%d",
+		       cd.first_sector,
+		       cd.cache_sectors,
+		       cd.total_sectors,
+		       cd.ordered ? "yes" : "no",
+		       cd.discard ? "yes" : "no", cd.pos, cd.replacement);
+		switch (cd.replacement) {
+		case CACHE_REPLACEMENT_LRU:
+			printf(" [lru]\n");
+			break;
+		case CACHE_REPLACEMENT_FIFO:
+			printf(" [fifo]\n");
+			break;
+		case CACHE_REPLACEMENT_RANDOM:
+			printf(" [random]\n");
+			break;
+		default:
+			putchar('\n');
+		}
+
+		putchar('\n');
+		printf("cset.uuid\t\t%s\n", cd.base.cset);
+	} else {
+		return 1;
+	}
+	return 0;
+}
diff --git a/show.h b/show.h
new file mode 100644
index 0000000..5ab9933
--- /dev/null
+++ b/show.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _BCH_MAKE_H
+#define _BCH_MAKE_H
+
+int show_bdevs_detail(void);
+int show_bdevs(void);
+int detail_single(char *devname);
+
+#endif
-- 
2.26.2

