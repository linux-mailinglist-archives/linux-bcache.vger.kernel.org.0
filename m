Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C400311BEE
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Feb 2021 08:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhBFHVe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 6 Feb 2021 02:21:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:48168 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhBFHVe (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 6 Feb 2021 02:21:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DC17DAE7D;
        Sat,  6 Feb 2021 07:20:18 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 5/6] bcache-tools: write nvm namespace super block on nvdimm
Date:   Sat,  6 Feb 2021 15:20:04 +0800
Message-Id: <20210206072005.24811-6-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210206072005.24811-1-colyli@suse.de>
References: <20210206072005.24811-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch adds following option to "bcache make",
        -M, --mdev              Format a cache nvmdimm-meta device

This option is used to specify a nvdimm device to store bcache mata
data. Once one or more nvdimm devices are specified as nvdimm-meta
device, routine write_nvm_namespace_sb() will write their super block
(defined by struct bch_nvm_pages_sb) into corresponding location on
the nvdimm-meta device.

Signed-off-by: Coly Li <colyli@suse.de>
---
 bcache.c |   1 +
 make.c   | 184 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 174 insertions(+), 11 deletions(-)

diff --git a/bcache.c b/bcache.c
index 5558914..def1e93 100644
--- a/bcache.c
+++ b/bcache.c
@@ -19,6 +19,7 @@
 #include <assert.h>
 
 #include "features.h"
+#include "nvm_pages.h"
 #include "show.h"
 
 #define BCACHE_TOOLS_VERSION	"1.1"
diff --git a/make.c b/make.c
index 92fe2a2..79ecada 100644
--- a/make.c
+++ b/make.c
@@ -13,6 +13,7 @@
 #define _FILE_OFFSET_BITS	64
 #define __USE_FILE_OFFSET64
 #define _XOPEN_SOURCE 600
+#define _DEFAULT_SOURCE
 
 #include <blkid/blkid.h>
 #include <ctype.h>
@@ -29,6 +30,7 @@
 #include <sys/ioctl.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <sys/mman.h>
 #include <unistd.h>
 #include <uuid/uuid.h>
 
@@ -36,6 +38,7 @@
 #include "lib.h"
 #include "bitwise.h"
 #include "zoned.h"
+#include "nvm_pages.h"
 
 struct sb_context {
 	unsigned int	block_size;
@@ -175,6 +178,7 @@ void usage(void)
 	fprintf(stderr,
 		   "Usage: make-bcache [options] device\n"
 	       "	-C, --cache		Format a cache device\n"
+	       "	-M, --mdev		Format a cache nvmdimm-meta device\n"
 	       "	-B, --bdev		Format a backing device\n"
 	       "	-b, --bucket		bucket size\n"
 	       "	-w, --block		block size (hard sector size of SSD, often 2k)\n"
@@ -409,6 +413,8 @@ static void write_sb(char *dev, struct sb_context *sbc, bool bdev, bool force)
 		sb.nr_in_set		= 1;
 		/* 23 is (SB_SECTOR + SB_SIZE) - 1 sectors */
 		sb.first_bucket		= (23 / sb.bucket_size) + 1;
+		if (nvdimm_meta)
+			sb.first_bucket += SB_JOURNAL_BUCKETS;
 
 		if (sb.nbuckets < 1 << 7) {
 			fprintf(stderr, "Not enough buckets: %llu, need %u\n",
@@ -477,6 +483,139 @@ static void write_sb(char *dev, struct sb_context *sbc, bool bdev, bool force)
 	close(fd);
 }
 
+static void write_nvm_namespace_sb(char *dev,
+				   int this_namespace_nr, int total_namespace_nr,
+				   struct sb_context *sbc, bool force)
+{
+	int fd;
+	struct bch_nvm_pages_sb *nvm_sb = NULL;
+	struct bch_owner_list_head owner_list_head;
+	struct bch_nvm_pages_owner_head system_owner_head;
+	struct bch_nvm_pgalloc_recs system_pgalloc_recs;
+	char uuid_str[40], nvm_pages_set_uuid_str[40];
+	int page_size = getpagesize();
+	void *start_addr = NULL;
+
+	memset(&owner_list_head, 0, sizeof(struct bch_owner_list_head));
+	memset(&system_owner_head, 0, sizeof(struct bch_nvm_pages_owner_head));
+	memset(&system_pgalloc_recs, 0, sizeof(struct bch_nvm_pgalloc_recs));
+
+	fd = open(dev, O_RDWR|O_EXCL);
+	if (fd < 0) {
+		printf("open %s failed: %s\n", dev, strerror(errno));
+		exit(EXIT_FAILURE);
+	}
+
+	start_addr = mmap(NULL, BCH_NVM_PAGES_OFFSET, PROT_READ | PROT_WRITE,
+			  MAP_SHARED, fd, 0);
+	if (start_addr == MAP_FAILED) {
+		printf("mmap to %s filed: %s\n", dev, strerror(errno));
+		exit(EXIT_FAILURE);
+	}
+
+	nvm_sb = (struct bch_nvm_pages_sb *)
+		(start_addr + BCH_NVM_PAGES_SB_OFFSET);
+
+	if ((!memcmp(nvm_sb->magic, bch_nvm_pages_magic, 16)) &&
+	    (!force)) {
+		fprintf(stderr, "Already a nvdimm meta device on %s,", dev);
+		fprintf(stderr, " overwrite with --force\n");
+		exit(EXIT_FAILURE);
+	}
+
+	memset(start_addr, 0, BCH_NVM_PAGES_OFFSET);
+
+	/* Initialize super block */
+	nvm_sb->sb_offset		= BCH_NVM_PAGES_SB_OFFSET;
+	nvm_sb->version			= BCH_NVM_PAGES_SB_VERSION;
+	memcpy(nvm_sb->magic,		bch_nvm_pages_magic, 16);
+	uuid_generate(nvm_sb->uuid);
+	/* Right now there is only one namespace in the nvm_pages set */
+	uuid_generate(nvm_sb->set_uuid);
+	nvm_sb->page_size		= page_size;
+	nvm_sb->total_namespaces_nr	= total_namespace_nr;
+	nvm_sb->this_namespace_nr	= this_namespace_nr;
+	nvm_sb->flags			= 0;
+	nvm_sb->seq			= 0;
+	nvm_sb->feature_compat		= 0;
+	nvm_sb->feature_incompat	= 0;
+	nvm_sb->feature_ro_compat	= 0;
+	nvm_sb->pages_offset		= BCH_NVM_PAGES_OFFSET;
+	nvm_sb->pages_total		= getblocks(fd) * 512 / page_size;
+
+	if (this_namespace_nr == 0)
+		nvm_sb->owner_list_head	= (struct bch_owner_list_head *)
+					BCH_NVM_PAGES_OWNER_LIST_HEAD_OFFSET;
+	else
+		nvm_sb->owner_list_head	= NULL;
+
+	/* Set checksum, don't modify nvm_sb anymore */
+	nvm_sb->csum = csum_set(nvm_sb);
+
+	uuid_unparse(nvm_sb->uuid, uuid_str);
+	uuid_unparse(nvm_sb->set_uuid, nvm_pages_set_uuid_str);
+
+	printf("Name			%s\n", dev);
+	printf("Type			nvdimm-meta\n");
+	printf("UUID:			%s\n"
+	       "NVM Set UUID:		%s\n"
+	       "version:		%u\n"
+	       "seq:			%u\n"
+	       "total_namespaces_nr:	%u\n"
+	       "this_namespace_nr:	%u\n"
+	       "ns_start:		N/A\n"
+	       "page_size:		%u\n"
+	       "pages_offset:		%llu\n"
+	       "pages_total:		%llu\n",
+	       uuid_str, nvm_pages_set_uuid_str,
+	       (unsigned int) nvm_sb->version,
+	       (unsigned int) nvm_sb->seq,
+	       nvm_sb->total_namespaces_nr,
+	       nvm_sb->this_namespace_nr,
+	       nvm_sb->page_size,
+	       nvm_sb->pages_offset,
+	       nvm_sb->pages_total);
+
+	memcpy(start_addr + BCH_NVM_PAGES_SB_OFFSET, nvm_sb,
+	       sizeof(struct bch_nvm_pages_sb));
+
+	/* Initialize bch_owner_list_head */
+	owner_list_head.size = (sizeof(struct bch_owner_list_head) -
+				offsetof(struct bch_owner_list_head, heads)) /
+			       sizeof(struct bch_nvm_pages_owner_head);
+	memcpy(system_owner_head.uuid, nvm_sb->set_uuid, sizeof(uuid_t));
+	snprintf(system_owner_head.label, BCH_NVM_PAGES_LABEL_SIZE - 1,
+		 "nvm_pages_internal");
+	system_owner_head.recs[0] = (struct bch_nvm_pgalloc_recs *)
+				    BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET;
+	owner_list_head.heads[0] = system_owner_head;
+	owner_list_head.used = 1;
+	memcpy(start_addr + BCH_NVM_PAGES_OWNER_LIST_HEAD_OFFSET,
+		&owner_list_head, sizeof(struct bch_nvm_pages_owner_head));
+
+	/*
+	 * Initialize bch_nvm_pages_owner_head.heads[0].recs[0]
+	 * - the system internal owner list
+	 */
+	system_pgalloc_recs.owner = (struct bch_nvm_pages_owner_head *)
+			(BCH_NVM_PAGES_OWNER_LIST_HEAD_OFFSET +
+			 offsetof(struct bch_owner_list_head, heads));
+	system_pgalloc_recs.next = NULL;
+	memcpy(system_pgalloc_recs.magic, bch_nvm_pages_pgalloc_magic, 16);
+	memcpy(system_pgalloc_recs.owner_uuid, system_owner_head.uuid, sizeof(uuid_t));
+	system_pgalloc_recs.size = (sizeof(struct bch_nvm_pgalloc_recs) -
+				    offsetof(struct bch_nvm_pgalloc_recs, recs)) /
+				   sizeof(struct bch_nvm_pgalloc_rec);
+	system_pgalloc_recs.used = 0;
+	memcpy(start_addr + BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET,
+	       &system_pgalloc_recs, sizeof(struct bch_nvm_pgalloc_recs));
+
+	msync(start_addr, BCH_NVM_PAGES_OFFSET, MS_SYNC);
+	munmap(start_addr, BCH_NVM_PAGES_OFFSET);
+
+	close(fd);
+}
+
 static unsigned int get_blocksize(const char *path)
 {
 	struct stat statbuf;
@@ -521,9 +660,13 @@ static unsigned int get_blocksize(const char *path)
 
 int make_bcache(int argc, char **argv)
 {
-	int c, bdev = -1;
-	unsigned int i, ncache_devices = 0, nbacking_devices = 0;
+	int c;
+	unsigned int i;
+	int cdev = -1, bdev = -1, mdev = -1;
+	unsigned int ncache_devices = 0, ncache_nvm_devices = 0;
+	unsigned int nbacking_devices = 0;
 	char *cache_devices[argc];
+	char *cache_nvm_devices[argc];
 	char *backing_devices[argc];
 	char label[SB_LABEL_SIZE] = { 0 };
 	unsigned int block_size = 0, bucket_size = 1024;
@@ -538,6 +681,7 @@ int make_bcache(int argc, char **argv)
 	struct option opts[] = {
 		{ "cache",		0, NULL,	'C' },
 		{ "bdev",		0, NULL,	'B' },
+		{ "nvdimm-meta",	0, NULL,	'M'},
 		{ "bucket",		1, NULL,	'b' },
 		{ "block",		1, NULL,	'w' },
 		{ "writeback",		0, &writeback,	1 },
@@ -554,16 +698,19 @@ int make_bcache(int argc, char **argv)
 		{ NULL,			0, NULL,	0 },
 	};
 
-	while ((c = getopt_long(argc, argv,
-				"-hCBUo:w:b:l:",
-				opts, NULL)) != -1)
+	while ((c = getopt_long(argc, argv, "-hCBMUo:w:b:l:",
+				opts, NULL)) != -1) {
+
 		switch (c) {
 		case 'C':
-			bdev = 0;
+			cdev = 1;
 			break;
 		case 'B':
 			bdev = 1;
 			break;
+		case 'M':
+			mdev = 1;
+			break;
 		case 'b':
 			bucket_size =
 				hatoi_validate(optarg, "bucket size", UINT_MAX);
@@ -610,19 +757,28 @@ int make_bcache(int argc, char **argv)
 			usage();
 			break;
 		case 1:
-			if (bdev == -1) {
-				fprintf(stderr, "Please specify -C or -B\n");
+			if (cdev == -1 && bdev == -1 && mdev == -1) {
+				fprintf(stderr, "Please specify -C, -B or -M\n");
 				exit(EXIT_FAILURE);
 			}
 
-			if (bdev)
+			if (bdev > 0) {
 				backing_devices[nbacking_devices++] = optarg;
-			else
+				printf("backing_devices[%d]: %s\n", nbacking_devices - 1, optarg);
+				bdev = -1;
+			} else if (cdev > 0) {
 				cache_devices[ncache_devices++] = optarg;
+				printf("cache_devices[%d]: %s\n", ncache_devices - 1, optarg);
+				cdev = -1;
+			} else if (mdev > 0) {
+				cache_nvm_devices[ncache_nvm_devices++] = optarg;
+				mdev = -1;
+			}
 			break;
 		}
+	} /* while */
 
-	if (!ncache_devices && !nbacking_devices) {
+	if (!ncache_devices && !ncache_nvm_devices && !nbacking_devices) {
 		fprintf(stderr, "Please supply a device\n");
 		usage();
 	}
@@ -657,6 +813,7 @@ int make_bcache(int argc, char **argv)
 	sbc.data_offset = data_offset;
 	memcpy(sbc.set_uuid, set_uuid, sizeof(sbc.set_uuid));
 	sbc.label = label;
+	sbc.nvdimm_meta = (ncache_nvm_devices > 0) ? true : false;
 
 	for (i = 0; i < ncache_devices; i++)
 		write_sb(cache_devices[i], &sbc, false, force);
@@ -668,5 +825,10 @@ int make_bcache(int argc, char **argv)
 		write_sb(backing_devices[i], &sbc, true, force);
 	}
 
+	for (i = 0; i < ncache_nvm_devices; i++) {
+		write_nvm_namespace_sb(cache_nvm_devices[i], i,
+				       ncache_nvm_devices, &sbc,
+				       force);
+	}
 	return 0;
 }
-- 
2.26.2

