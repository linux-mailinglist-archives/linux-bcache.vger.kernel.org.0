Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1EB311BEC
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Feb 2021 08:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhBFHVe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 6 Feb 2021 02:21:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:48170 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229629AbhBFHVd (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 6 Feb 2021 02:21:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 87F03AE85;
        Sat,  6 Feb 2021 07:20:20 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 6/6] bcache-tools: support "bcache show -d" for nvdimm-meta device
Date:   Sat,  6 Feb 2021 15:20:05 +0800
Message-Id: <20210206072005.24811-7-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210206072005.24811-1-colyli@suse.de>
References: <20210206072005.24811-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch adds support to display detail information of a nvdimm-meta
device by command "bcache show -d".

struct mdev is added into lib.h to represent nvdimm-meta device
information.

At this moment, commands "bcache show" and "bcache show -m" don't
support nvdimm-meta device yet.

Signed-off-by: Coly Li <colyli@suse.de>
---
 bcache.c |  10 ++---
 lib.c    |  63 ++++++++++++++++++++++++++-
 lib.h    |  25 ++++++++++-
 make.c   |   2 +-
 show.c   | 128 +++++++++++++++++++++++++++++++++++++------------------
 5 files changed, 178 insertions(+), 50 deletions(-)

diff --git a/bcache.c b/bcache.c
index def1e93..044d401 100644
--- a/bcache.c
+++ b/bcache.c
@@ -220,7 +220,7 @@ int attach_both(char *cdev, char *backdev)
 	int ret;
 	char buf[100];
 
-	ret = detail_dev(backdev, &bd, &cd, &type);
+	ret = detail_dev(backdev, &bd, &cd, NULL, &type);
 	if (ret != 0)
 		return ret;
 	if (type != BCACHE_SB_VERSION_BDEV
@@ -235,7 +235,7 @@ int attach_both(char *cdev, char *backdev)
 	}
 
 	if (strlen(cdev) != 36) {
-		ret = detail_dev(cdev, &bd, &cd, &type);
+		ret = detail_dev(cdev, &bd, &cd, NULL, &type);
 		if (type != BCACHE_SB_VERSION_CDEV
 		    && type != BCACHE_SB_VERSION_CDEV_WITH_UUID) {
 			fprintf(stderr, "%s is not an cache device\n", cdev);
@@ -349,7 +349,7 @@ int main(int argc, char **argv)
 		int type = 1;
 		int ret;
 
-		ret = detail_dev(devname, &bd, &cd, &type);
+		ret = detail_dev(devname, &bd, &cd, NULL, &type);
 		if (ret != 0)
 			return ret;
 		if (type == BCACHE_SB_VERSION_BDEV) {
@@ -394,7 +394,7 @@ int main(int argc, char **argv)
 		int type = 1;
 		int ret;
 
-		ret = detail_dev(devname, &bd, &cd, &type);
+		ret = detail_dev(devname, &bd, &cd, NULL, &type);
 		if (ret != 0) {
 			fprintf(stderr,
 			"This device doesn't exist or failed to receive info from this device\n");
@@ -420,7 +420,7 @@ int main(int argc, char **argv)
 		int type = 5;
 		int ret;
 
-		ret = detail_dev(devname, &bd, &cd, &type);
+		ret = detail_dev(devname, &bd, &cd, NULL, &type);
 		if (ret != 0) {
 			fprintf(stderr,
 		"This device doesn't exist or failed to receive info from this device\n");
diff --git a/lib.c b/lib.c
index 05ce9b9..6341c61 100644
--- a/lib.c
+++ b/lib.c
@@ -13,10 +13,14 @@
 #include <string.h>
 #include <malloc.h>
 #include <regex.h>
+#include <libgen.h>
 
 #include "bcache.h"
+#include "nvm_pages.h"
 #include "lib.h"
 #include "bitwise.h"
+
+
 /*
  * utils function
  */
@@ -534,10 +538,59 @@ Fail:
 	return 1;
 }
 
-int detail_dev(char *devname, struct bdev *bd, struct cdev *cd, int *type)
+int __detail_mdev(char *devname, struct bch_nvm_pages_sb *nvm_sb, struct mdev *md)
+{
+	uint64_t expected_csum;
+	int ret = 1;
+
+	if (memcmp(nvm_sb->magic, bch_nvm_pages_magic, 16)) {
+		fprintf(stderr,
+			"Bad magic, make sure this is an bcache nvdimm meta device\n");
+		goto out;
+	}
+
+	if (nvm_sb->sb_offset != BCH_NVM_PAGES_SB_OFFSET) {
+		fprintf(stderr, "Invalid superblock (bad sector)\n");
+		goto out;
+	}
+
+	expected_csum = csum_set(nvm_sb);
+	if (expected_csum != nvm_sb->csum) {
+		fprintf(stderr, "Csum is not match with expected one\n");
+		goto out;
+	}
+
+	memset(md, 0, sizeof(struct mdev));
+
+	md->magic		= "ok";
+	md->csum		= nvm_sb->csum;
+	md->ns_start		= nvm_sb->ns_start;
+	md->sb_offset		= nvm_sb->sb_offset;
+	md->version		= nvm_sb->version;
+	uuid_unparse(nvm_sb->uuid, md->uuid);
+	md->page_size		= nvm_sb->page_size;
+	md->total_namespaces_nr	= nvm_sb->total_namespaces_nr;
+	md->this_namespace_nr	= nvm_sb->this_namespace_nr;
+	uuid_unparse(nvm_sb->set_uuid, md->set_uuid);
+	md->seq			= nvm_sb->seq;
+	strncpy(md->bname,	basename(devname), 40);
+	md->feature_compat	= nvm_sb->feature_compat;
+	md->feature_ro_compat	= nvm_sb->feature_ro_compat;
+	md->feature_incompat	= nvm_sb->feature_incompat;
+	md->pages_offset	= nvm_sb->pages_offset;
+	md->pages_total		= nvm_sb->pages_total;
+
+	ret = 0;
+out:
+	return ret;
+}
+
+int detail_dev(char *devname, struct bdev *bd, struct cdev *cd,
+	       struct mdev *md, int *type)
 {
 	char *buf = NULL;
 	struct cache_sb_disk *sb_disk = NULL;
+	struct bch_nvm_pages_sb *nvm_sb = NULL;
 	int buf_size = 16<<10, ret = 1;
 	int fd;
 
@@ -566,6 +619,14 @@ int detail_dev(char *devname, struct bdev *bd, struct cdev *cd, int *type)
 		goto out_memory;
 	}
 
+	/* Try whether it is nvm_pages super block */
+	nvm_sb = (struct bch_nvm_pages_sb *)(buf + BCH_NVM_PAGES_SB_OFFSET);
+	if (!memcmp(nvm_sb->magic, bch_nvm_pages_magic, 16)) {
+		ret = __detail_mdev(devname, nvm_sb, md);
+		*type = -1;
+		goto out_memory;
+	}
+
 	fprintf(stderr, "Error: Bad magic, not bcache device\n");
 
 out_memory:
diff --git a/lib.h b/lib.h
index 4c8df97..152d9e8 100644
--- a/lib.h
+++ b/lib.h
@@ -43,9 +43,32 @@ struct cdev {
 	unsigned int	replacement;
 };
 
+struct mdev {
+	struct cache_sb		*sb;
+	uint64_t		csum;
+	uint64_t		ns_start;
+	uint64_t		sb_offset;
+	uint64_t		version;
+	char			*magic;
+	char			uuid[40];
+	uint32_t		page_size;
+	uint32_t		total_namespaces_nr;
+	uint32_t		this_namespace_nr;
+	union {
+		char		set_uuid[40];
+		uint64_t	set_magic;
+	};
+	uint64_t		seq;
+	char			bname[40];
+	uint64_t		feature_compat;
+	uint64_t		feature_ro_compat;
+	uint64_t		feature_incompat;
+	uint64_t		pages_offset;
+	uint64_t		pages_total;
+};
 
 int list_bdevs(struct list_head *head);
-int detail_dev(char *devname, struct bdev *bd, struct cdev *cd, int *type);
+int detail_dev(char *devname, struct bdev *bd, struct cdev *cd, struct mdev *md, int *type);
 int register_dev(char *devname);
 int stop_backdev(char *devname);
 int unregister_cset(char *cset);
diff --git a/make.c b/make.c
index 79ecada..447c946 100644
--- a/make.c
+++ b/make.c
@@ -269,7 +269,7 @@ static void write_sb(char *dev, struct sb_context *sbc, bool bdev, bool force)
 			int type = 1;
 			int ret;
 
-			ret = detail_dev(dev, &bd, &cd, &type);
+			ret = detail_dev(dev, &bd, &cd, NULL, &type);
 			if (ret != 0)
 				exit(EXIT_FAILURE);
 			if (type == BCACHE_SB_VERSION_BDEV) {
diff --git a/show.c b/show.c
index ff49862..6175f3f 100644
--- a/show.c
+++ b/show.c
@@ -148,43 +148,33 @@ int show_bdevs(void)
 	return 0;
 }
 
-int detail_single(char *devname)
+int detail_single_dev(char *devname, struct bdev *bd, struct cdev *cd, int type)
 {
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
 	if (type == BCACHE_SB_VERSION_BDEV ||
 	    type == BCACHE_SB_VERSION_BDEV_WITH_OFFSET ||
 	    type == BCACHE_SB_VERSION_BDEV_WITH_FEATURES) {
-		printf("sb.magic\t\t%s\n", bd.base.magic);
+		printf("sb.magic\t\t%s\n", bd->base.magic);
 		printf("sb.first_sector\t\t%" PRIu64 "\n",
-		       bd.base.first_sector);
-		printf("sb.csum\t\t\t%" PRIX64 "\n", bd.base.csum);
-		printf("sb.version\t\t%" PRIu64, bd.base.version);
+		       bd->base.first_sector);
+		printf("sb.csum\t\t\t%" PRIX64 "\n", bd->base.csum);
+		printf("sb.version\t\t%" PRIu64, bd->base.version);
 		printf(" [backing device]\n");
 		putchar('\n');
 		printf("dev.label\t\t");
-		if (*bd.base.label)
-			print_encode(bd.base.label);
+		if (*bd->base.label)
+			print_encode(bd->base.label);
 		else
 			printf("(empty)");
 		putchar('\n');
-		printf("dev.uuid\t\t%s\n", bd.base.uuid);
+		printf("dev.uuid\t\t%s\n", bd->base.uuid);
 		printf("dev.sectors_per_block\t%u\n"
 		       "dev.sectors_per_bucket\t%u\n",
-		       bd.base.sectors_per_block,
-		       bd.base.sectors_per_bucket);
+		       bd->base.sectors_per_block,
+		       bd->base.sectors_per_bucket);
 		printf("dev.data.first_sector\t%u\n"
 		       "dev.data.cache_mode\t%d",
-		       bd.first_sector, bd.cache_mode);
-		switch (bd.cache_mode) {
+		       bd->first_sector, bd->cache_mode);
+		switch (bd->cache_mode) {
 		case CACHE_MODE_WRITETHROUGH:
 			printf(" [writethrough]\n");
 			break;
@@ -200,8 +190,8 @@ int detail_single(char *devname)
 		default:
 			putchar('\n');
 		}
-		printf("dev.data.cache_state\t%u", bd.cache_state);
-		switch (bd.cache_state) {
+		printf("dev.data.cache_state\t%u", bd->cache_state);
+		switch (bd->cache_state) {
 		case BDEV_STATE_NONE:
 			printf(" [detached]\n");
 			break;
@@ -219,29 +209,29 @@ int detail_single(char *devname)
 		}
 
 		putchar('\n');
-		printf("cset.uuid\t\t%s\n", bd.base.cset);
+		printf("cset.uuid\t\t%s\n", bd->base.cset);
 	} else if (type == BCACHE_SB_VERSION_CDEV ||
 		   type == BCACHE_SB_VERSION_CDEV_WITH_UUID ||
 		   type == BCACHE_SB_VERSION_CDEV_WITH_FEATURES) {
-		printf("sb.magic\t\t%s\n", cd.base.magic);
+		printf("sb.magic\t\t%s\n", cd->base.magic);
 		printf("sb.first_sector\t\t%" PRIu64 "\n",
-		       cd.base.first_sector);
-		printf("sb.csum\t\t\t%" PRIX64 "\n", cd.base.csum);
-		printf("sb.version\t\t%" PRIu64, cd.base.version);
+		       cd->base.first_sector);
+		printf("sb.csum\t\t\t%" PRIX64 "\n", cd->base.csum);
+		printf("sb.version\t\t%" PRIu64, cd->base.version);
 		printf(" [cache device]\n");
-		print_cache_set_supported_feature_sets(&cd.base.sb);
+		print_cache_set_supported_feature_sets(&cd->base.sb);
 		putchar('\n');
 		printf("dev.label\t\t");
-		if (*cd.base.label)
-			print_encode(cd.base.label);
+		if (*cd->base.label)
+			print_encode(cd->base.label);
 		else
 			printf("(empty)");
 		putchar('\n');
-		printf("dev.uuid\t\t%s\n", cd.base.uuid);
+		printf("dev.uuid\t\t%s\n", cd->base.uuid);
 		printf("dev.sectors_per_block\t%u\n"
 		       "dev.sectors_per_bucket\t%u\n",
-		       cd.base.sectors_per_block,
-		       cd.base.sectors_per_bucket);
+		       cd->base.sectors_per_block,
+		       cd->base.sectors_per_bucket);
 		printf("dev.cache.first_sector\t%u\n"
 		       "dev.cache.cache_sectors\t%ju\n"
 		       "dev.cache.total_sectors\t%ju\n"
@@ -249,12 +239,12 @@ int detail_single(char *devname)
 		       "dev.cache.discard\t%s\n"
 		       "dev.cache.pos\t\t%u\n"
 		       "dev.cache.replacement\t%d",
-		       cd.first_sector,
-		       cd.cache_sectors,
-		       cd.total_sectors,
-		       cd.ordered ? "yes" : "no",
-		       cd.discard ? "yes" : "no", cd.pos, cd.replacement);
-		switch (cd.replacement) {
+		       cd->first_sector,
+		       cd->cache_sectors,
+		       cd->total_sectors,
+		       cd->ordered ? "yes" : "no",
+		       cd->discard ? "yes" : "no", cd->pos, cd->replacement);
+		switch (cd->replacement) {
 		case CACHE_REPLACEMENT_LRU:
 			printf(" [lru]\n");
 			break;
@@ -269,9 +259,63 @@ int detail_single(char *devname)
 		}
 
 		putchar('\n');
-		printf("cset.uuid\t\t%s\n", cd.base.cset);
+		printf("cset.uuid\t\t%s\n", cd->base.cset);
 	} else {
 		return 1;
 	}
 	return 0;
 }
+
+int detail_single_mdev(char *devname, struct mdev *md)
+{
+	printf(	"sb.magic\t\t%s\n"
+		"sb.csum\t\t\t%" PRIX64 "\n"
+		"sb.ns_start\t\t0x%" PRIX64 "\n"
+		"sb.sb_offset\t\t0x%" PRIX64 "\n"
+		"sb.version\t\t%" PRIu64 " [nvdimm-meta device]\n"
+		"sb.uuid\t\t\t%s\n"
+		"sb.page_size\t\t%u\n"
+		"sb.total_namespaces_nr\t%u\n"
+		"sb.this_namespace_nr\t%u\n"
+		"sb.set_uuid\t\t%s\n"
+		"sb.seq\t\t\t%" PRIX64 "\n"
+		"sb.pages_offset\t\t0x%" PRIX64 "\n"
+		"sb.pages_total\t\t%" PRIu64 "\n",
+		md->magic,
+		md->csum,
+		md->ns_start,
+		md->sb_offset,
+		md->version,
+		md->uuid,
+		md->page_size,
+		md->total_namespaces_nr,
+		md->this_namespace_nr,
+		md->set_uuid,
+		md->seq,
+		md->pages_offset,
+		md->pages_total);
+	putchar('\n');
+
+	return 0;
+}
+
+int detail_single(char *devname)
+{
+	struct bdev bd;
+	struct cdev cd;
+	struct mdev md;
+	int type = 0;
+	int ret = 0;
+
+	ret = detail_dev(devname, &bd, &cd, &md, &type);
+	if (ret != 0)
+		goto out;
+
+	if (type >= 0 && type <= BCACHE_SB_MAX_VERSION)
+		ret = detail_single_dev(devname, &bd, &cd, type);
+	else
+		ret = detail_single_mdev(devname, &md);
+
+out:
+	return ret;
+}
-- 
2.26.2

