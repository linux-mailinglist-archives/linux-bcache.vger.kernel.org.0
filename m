Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A022465FA
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Aug 2020 14:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgHQMGj (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 17 Aug 2020 08:06:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:53580 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbgHQMGi (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Aug 2020 08:06:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 45005AFF7
        for <linux-bcache@vger.kernel.org>; Mon, 17 Aug 2020 12:07:02 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>
Subject: [PATCH 8/8] bcache-tools: add print_cache_set_supported_feature_sets() in lib.c
Date:   Mon, 17 Aug 2020 20:05:58 +0800
Message-Id: <20200817120558.4491-9-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200817120558.4491-1-colyli@suse.de>
References: <20200817120558.4491-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

print_cache_set_supported_feature_sets() is used to print out feature
set strings for a specified cache device super block. It can be used
when make a bcache cache device, or show a super block information of
a bcache cache device.

Signed-off-by: Coly Li <colyli@suse.de>
---
 bcache-super-show.c |  2 ++
 bcache.c            | 15 +++++++++++---
 features.c          | 50 +++++++++++++++++++++++++++++++++++++++++++++
 features.h          |  8 ++++++++
 lib.c               | 20 +++++++++++-------
 lib.h               |  4 ++++
 6 files changed, 89 insertions(+), 10 deletions(-)
 create mode 100644 features.h

diff --git a/bcache-super-show.c b/bcache-super-show.c
index 883410f..cc36029 100644
--- a/bcache-super-show.c
+++ b/bcache-super-show.c
@@ -134,12 +134,14 @@ int main(int argc, char **argv)
 		// These are handled the same by the kernel
 		case BCACHE_SB_VERSION_CDEV:
 		case BCACHE_SB_VERSION_CDEV_WITH_UUID:
+		case BCACHE_SB_VERSION_CDEV_WITH_FEATURES:
 			printf(" [cache device]\n");
 			break;
 
 		// The second adds data offset support
 		case BCACHE_SB_VERSION_BDEV:
 		case BCACHE_SB_VERSION_BDEV_WITH_OFFSET:
+		case BCACHE_SB_VERSION_BDEV_WITH_FEATURES:
 			printf(" [backing device]\n");
 			break;
 
diff --git a/bcache.c b/bcache.c
index b866271..50e3a88 100644
--- a/bcache.c
+++ b/bcache.c
@@ -18,6 +18,7 @@
 #include "list.h"
 #include <limits.h>
 
+#include "features.h"
 
 #define BCACHE_TOOLS_VERSION	"1.1"
 
@@ -203,11 +204,13 @@ int show_bdevs_detail(void)
 			// These are handled the same by the kernel
 		case BCACHE_SB_VERSION_CDEV:
 		case BCACHE_SB_VERSION_CDEV_WITH_UUID:
+		case BCACHE_SB_VERSION_CDEV_WITH_FEATURES:
 			printf(" (cache)");
 			break;
 			// The second adds data offset supporet
 		case BCACHE_SB_VERSION_BDEV:
 		case BCACHE_SB_VERSION_BDEV_WITH_OFFSET:
+		case BCACHE_SB_VERSION_BDEV_WITH_FEATURES:
 			printf(" (data)");
 			break;
 		default:
@@ -257,12 +260,14 @@ int show_bdevs(void)
 			// These are handled the same by the kernel
 		case BCACHE_SB_VERSION_CDEV:
 		case BCACHE_SB_VERSION_CDEV_WITH_UUID:
+		case BCACHE_SB_VERSION_CDEV_WITH_FEATURES:
 			printf(" (cache)");
 			break;
 
 			// The second adds data offset supporet
 		case BCACHE_SB_VERSION_BDEV:
 		case BCACHE_SB_VERSION_BDEV_WITH_OFFSET:
+		case BCACHE_SB_VERSION_BDEV_WITH_FEATURES:
 			printf(" (data)");
 			break;
 
@@ -304,7 +309,9 @@ int detail_single(char *devname)
 		fprintf(stderr, "Failed to detail device\n");
 		return ret;
 	}
-	if (type == BCACHE_SB_VERSION_BDEV) {
+	if (type == BCACHE_SB_VERSION_BDEV ||
+	    type == BCACHE_SB_VERSION_BDEV_WITH_OFFSET ||
+	    type == BCACHE_SB_VERSION_BDEV_WITH_FEATURES) {
 		printf("sb.magic\t\t%s\n", bd.base.magic);
 		printf("sb.first_sector\t\t%" PRIu64 "\n",
 		       bd.base.first_sector);
@@ -362,14 +369,16 @@ int detail_single(char *devname)
 
 		putchar('\n');
 		printf("cset.uuid\t\t%s\n", bd.base.cset);
-	} else if (type == BCACHE_SB_VERSION_CDEV
-		   || type == BCACHE_SB_VERSION_CDEV_WITH_UUID) {
+	} else if (type == BCACHE_SB_VERSION_CDEV ||
+		   type == BCACHE_SB_VERSION_CDEV_WITH_UUID ||
+		   type == BCACHE_SB_VERSION_CDEV_WITH_FEATURES) {
 		printf("sb.magic\t\t%s\n", cd.base.magic);
 		printf("sb.first_sector\t\t%" PRIu64 "\n",
 		       cd.base.first_sector);
 		printf("sb.csum\t\t\t%" PRIX64 "\n", cd.base.csum);
 		printf("sb.version\t\t%" PRIu64, cd.base.version);
 		printf(" [cache device]\n");
+		print_cache_set_supported_feature_sets(&cd.base.sb);
 		putchar('\n');
 		printf("dev.label\t\t");
 		if (*cd.base.label)
diff --git a/features.c b/features.c
index df15862..181e348 100644
--- a/features.c
+++ b/features.c
@@ -7,7 +7,9 @@
  */
 #include <stdbool.h>
 #include <stdint.h>
+#include <stdio.h>
 #include <sys/types.h>
+#include <string.h>
 
 #include "bcache.h"
 
@@ -22,3 +24,51 @@ static struct feature feature_list[] = {
 		"large_bucket"},
 	{0, 0, 0 },
 };
+
+#define compose_feature_string(type, header)				\
+({									\
+	struct feature *f;						\
+	bool first = true;						\
+									\
+	for (f = &feature_list[0]; f->compat != 0; f++) {		\
+		if (f->compat != BCH_FEATURE_ ## type)			\
+			continue;					\
+		if (!(BCH_HAS_ ## type ## _FEATURE(sb, f->mask)))	\
+			continue;					\
+									\
+		if (first) {						\
+			out += snprintf(out, buf + size - out,		\
+					"%s:\t", (header));		\
+			first = false;					\
+		} else {						\
+			out += snprintf(out, buf + size - out, " ");	\
+		}							\
+									\
+		out += snprintf(out, buf + size - out, "%s", f->string);\
+									\
+	}								\
+	if (!first)							\
+		out += snprintf(out, buf + size - out, "\n");		\
+})
+
+void print_cache_set_supported_feature_sets(struct cache_sb *sb)
+{
+	char buf[4096];
+	char *out;
+	int size = sizeof(buf) - 1;
+
+	out = buf;
+	memset(buf, 0, sizeof(buf));
+	compose_feature_string(COMPAT, "sb.feature_compat");
+	printf("%s", buf);
+
+	out = buf;
+	memset(buf, 0, sizeof(buf));
+	compose_feature_string(RO_COMPAT, "sb.feature_ro_compat");
+	printf("%s", buf);
+
+	out = buf;
+	memset(buf, 0, sizeof(buf));
+	compose_feature_string(INCOMPAT, "sb.feature_incompat");
+	printf("%s", buf);
+}
diff --git a/features.h b/features.h
new file mode 100644
index 0000000..028b774
--- /dev/null
+++ b/features.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _BCACHE_FEATURES_H
+#define _BCACHE_FEATURES_H
+
+void print_cache_set_supported_feature_sets(struct cache_sb *sb);
+
+#endif
diff --git a/lib.c b/lib.c
index efabeb1..29172f5 100644
--- a/lib.c
+++ b/lib.c
@@ -192,11 +192,13 @@ int get_cachedev_state(char *cset_id, char *state)
 
 int get_state(struct dev *dev, char *state)
 {
-	if (dev->version == BCACHE_SB_VERSION_CDEV
-	    || dev->version == BCACHE_SB_VERSION_CDEV_WITH_UUID)
+	if (dev->version == BCACHE_SB_VERSION_CDEV ||
+	    dev->version == BCACHE_SB_VERSION_CDEV_WITH_UUID ||
+	    dev->version == BCACHE_SB_VERSION_CDEV_WITH_FEATURES)
 		return get_cachedev_state(dev->cset, state);
-	else if (dev->version == BCACHE_SB_VERSION_BDEV
-		   || dev->version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET)
+	else if (dev->version == BCACHE_SB_VERSION_BDEV ||
+		 dev->version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET ||
+		 dev->version == BCACHE_SB_VERSION_BDEV_WITH_FEATURES)
 		return get_backdev_state(dev->name, state);
 	else
 		return 1;
@@ -291,6 +293,7 @@ int detail_base(char *devname, struct cache_sb sb, struct dev *base)
 {
 	int ret;
 
+	base->sb = sb;
 	strcpy(base->name, devname);
 	base->magic = "ok";
 	base->first_sector = SB_SECTOR;
@@ -440,13 +443,16 @@ int detail_dev(char *devname, struct bdev *bd, struct cdev *cd, int *type)
 	}
 
 	*type = sb.version;
-	if (sb.version == BCACHE_SB_VERSION_BDEV) {
+	if (sb.version == BCACHE_SB_VERSION_BDEV ||
+	    sb.version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET ||
+	    sb.version == BCACHE_SB_VERSION_BDEV_WITH_FEATURES) {
 		detail_base(devname, sb, &bd->base);
 		bd->first_sector = BDEV_DATA_START_DEFAULT;
 		bd->cache_mode = BDEV_CACHE_MODE(&sb);
 		bd->cache_state = BDEV_STATE(&sb);
-	} else if (sb.version == BCACHE_SB_VERSION_CDEV
-		   || sb.version == BCACHE_SB_VERSION_CDEV_WITH_UUID) {
+	} else if (sb.version == BCACHE_SB_VERSION_CDEV ||
+		   sb.version == BCACHE_SB_VERSION_CDEV_WITH_UUID ||
+		   sb.version == BCACHE_SB_VERSION_CDEV_WITH_FEATURES) {
 		detail_base(devname, sb, &cd->base);
 		cd->first_sector = sb.bucket_size * sb.first_bucket;
 		cd->cache_sectors =
diff --git a/lib.h b/lib.h
index 1dd2bfe..9b5ed02 100644
--- a/lib.h
+++ b/lib.h
@@ -4,6 +4,7 @@
 #include "list.h"
 
 struct dev {
+	struct cache_sb	sb;
 	char		name[40];
 	char		*magic;
 	uint64_t	first_sector;
@@ -17,6 +18,9 @@ struct dev {
 	char		state[40];
 	char		bname[40];
 	char		attachuuid[40];
+	uint64_t	feature_compat;
+	uint64_t	feature_ro_compat;
+	uint64_t	feature_incompat;
 	struct	list_head	dev_list;
 };
 
-- 
2.26.2

