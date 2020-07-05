Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA05214DC7
	for <lists+linux-bcache@lfdr.de>; Sun,  5 Jul 2020 17:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgGEP40 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 5 Jul 2020 11:56:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:38096 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727834AbgGEP4Z (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 5 Jul 2020 11:56:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BECABAC37;
        Sun,  5 Jul 2020 15:56:22 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [RFC PATCH 06/16] bcache: increase super block version for cache device and backing device
Date:   Sun,  5 Jul 2020 23:55:51 +0800
Message-Id: <20200705155601.5404-7-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200705155601.5404-1-colyli@suse.de>
References: <20200705155601.5404-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The new added super block version BCACHE_SB_VERSION_BDEV_WITH_FEATURES
(5) BCACHE_SB_VERSION_CDEV_WITH_FEATURES value (6), is for the feature
set bits.

Devices have super block version equal to the new version will have
three new members for feature set bits in the on-disk super block,
/*078*/        __le64                  feature_compat;
/*080*/        __le64                  feature_incompat;
/*088*/        __le64                  feature_ro_compat;

They are used for further new features which may introduce on-disk
format change, and avoid unncessary super block version increase.

The very basic features handling code skeleton is also initialized in
this patch.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/features.h | 78 ++++++++++++++++++++++++++++++++++++
 drivers/md/bcache/super.c    | 25 ++++++++++--
 include/uapi/linux/bcache.h  | 29 ++++++++++----
 3 files changed, 121 insertions(+), 11 deletions(-)
 create mode 100644 drivers/md/bcache/features.h

diff --git a/drivers/md/bcache/features.h b/drivers/md/bcache/features.h
new file mode 100644
index 000000000000..69332ef7be5d
--- /dev/null
+++ b/drivers/md/bcache/features.h
@@ -0,0 +1,78 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _BCACHE_FEATURES_H
+#define _BCACHE_FEATURES_H
+
+#include <linux/bcache.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+
+#define BCH_FEATURE_COMPAT		0
+#define BCH_FEATURE_INCOMPAT		1
+#define BCH_FEATURE_RO_INCOMPAT		2
+#define BCH_FEATURE_TYPE_MASK		0x03
+
+#define BCH_FEATURE_COMPAT_SUUP		0
+#define BCH_FEATURE_INCOMPAT_SUUP	0
+#define BCH_FEATURE_RO_COMPAT_SUUP	0
+
+#define BCH_HAS_COMPAT_FEATURE(sb, mask) \
+		((sb)->feature_compat & (mask))
+#define BCH_HAS_RO_COMPAT_FEATURE(sb, mask) \
+		((sb)->feature_ro_compat & (mask))
+#define BCH_HAS_INCOMPAT_FEATURE(sb, mask) \
+		((sb)->feature_incompat & (mask))
+
+/* Feature set definition */
+
+#define BCH_FEATURE_COMPAT_FUNCS(name, flagname) \
+static inline int bch_has_feature_##name(struct cache_sb *sb) \
+{ \
+	return (((sb)->feature_compat & \
+		BCH##_FEATURE_COMPAT_##flagname) != 0); \
+} \
+static inline void bch_set_feature_##name(struct cache_sb *sb) \
+{ \
+	(sb)->feature_compat |= \
+		BCH##_FEATURE_COMPAT_##flagname; \
+} \
+static inline void bch_clear_feature_##name(struct cache_sb *sb) \
+{ \
+	(sb)->feature_compat &= \
+		~BCH##_FEATURE_COMPAT_##flagname; \
+}
+
+#define BCH_FEATURE_RO_COMPAT_FUNCS(name, flagname) \
+static inline int bch_has_feature_##name(struct cache_sb *sb) \
+{ \
+	return (((sb)->feature_ro_compat & \
+		BCH##_FEATURE_RO_COMPAT_##flagname) != 0); \
+} \
+static inline void bch_set_feature_##name(struct cache_sb *sb) \
+{ \
+	(sb)->feature_ro_compat |= \
+		BCH##_FEATURE_RO_COMPAT_##flagname; \
+} \
+static inline void bch_clear_feature_##name(struct cache_sb *sb) \
+{ \
+	(sb)->feature_ro_compat &= \
+		~BCH##_FEATURE_RO_COMPAT_##flagname; \
+}
+
+#define BCH_FEATURE_INCOMPAT_FUNCS(name, flagname) \
+static inline int bch_has_feature_##name(struct cache_sb *sb) \
+{ \
+	return (((sb)->feature_incompat & \
+		BCH##_FEATURE_INCOMPAT_##flagname) != 0); \
+} \
+static inline void bch_set_feature_##name(struct cache_sb *sb) \
+{ \
+	(sb)->feature_incompat |= \
+		BCH##_FEATURE_INCOMPAT_##flagname; \
+} \
+static inline void bch_clear_feature_##name(struct cache_sb *sb) \
+{ \
+	(sb)->feature_incompat &= \
+		~BCH##_FEATURE_INCOMPAT_##flagname; \
+}
+
+#endif
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a2283d182b71..59041e436fbd 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -13,6 +13,7 @@
 #include "extents.h"
 #include "request.h"
 #include "writeback.h"
+#include "features.h"
 
 #include <linux/blkdev.h>
 #include <linux/debugfs.h>
@@ -194,6 +195,7 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
 		sb->data_offset	= BDEV_DATA_START_DEFAULT;
 		break;
 	case BCACHE_SB_VERSION_BDEV_WITH_OFFSET:
+	case BCACHE_SB_VERSION_BDEV_WITH_FEATURES:
 		sb->data_offset	= le64_to_cpu(s->data_offset);
 
 		err = "Bad data offset";
@@ -207,6 +209,14 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
 		if (err)
 			goto err;
 		break;
+	case BCACHE_SB_VERSION_CDEV_WITH_FEATURES:
+		err = read_super_basic(sb, bdev, s);
+		if (err)
+			goto err;
+		sb->feature_compat = le64_to_cpu(s->feature_compat);
+		sb->feature_incompat = le64_to_cpu(s->feature_incompat);
+		sb->feature_ro_compat = le64_to_cpu(s->feature_ro_compat);
+		break;
 	default:
 		err = "Unsupported superblock version";
 		goto err;
@@ -241,7 +251,6 @@ static void __write_super(struct cache_sb *sb, struct cache_sb_disk *out,
 			offset_in_page(out));
 
 	out->offset		= cpu_to_le64(sb->offset);
-	out->version		= cpu_to_le64(sb->version);
 
 	memcpy(out->uuid,	sb->uuid, 16);
 	memcpy(out->set_uuid,	sb->set_uuid, 16);
@@ -257,6 +266,13 @@ static void __write_super(struct cache_sb *sb, struct cache_sb_disk *out,
 	for (i = 0; i < sb->keys; i++)
 		out->d[i] = cpu_to_le64(sb->d[i]);
 
+	if (sb->version >= BCACHE_SB_VERSION_CDEV_WITH_FEATURES) {
+		out->feature_compat    = cpu_to_le64(sb->feature_compat);
+		out->feature_incompat  = cpu_to_le64(sb->feature_incompat);
+		out->feature_ro_compat = cpu_to_le64(sb->feature_ro_compat);
+	}
+
+	out->version		= cpu_to_le64(sb->version);
 	out->csum = csum_set(out);
 
 	pr_debug("ver %llu, flags %llu, seq %llu\n",
@@ -313,17 +329,20 @@ void bcache_write_super(struct cache_set *c)
 {
 	struct closure *cl = &c->sb_write;
 	struct cache *ca;
-	unsigned int i;
+	unsigned int i, version = BCACHE_SB_VERSION_CDEV_WITH_UUID;
 
 	down(&c->sb_write_mutex);
 	closure_init(cl, &c->cl);
 
 	c->sb.seq++;
 
+	if (c->sb.version > version)
+		version = c->sb.version;
+
 	for_each_cache(ca, c, i) {
 		struct bio *bio = &ca->sb_bio;
 
-		ca->sb.version		= BCACHE_SB_VERSION_CDEV_WITH_UUID;
+		ca->sb.version		= version;
 		ca->sb.seq		= c->sb.seq;
 		ca->sb.last_mount	= c->sb.last_mount;
 
diff --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h
index afbd1b56a661..561032a070f2 100644
--- a/include/uapi/linux/bcache.h
+++ b/include/uapi/linux/bcache.h
@@ -141,11 +141,13 @@ static inline struct bkey *bkey_idx(const struct bkey *k, unsigned int nr_keys)
  * Version 3: Cache device with new UUID format
  * Version 4: Backing device with data offset
  */
-#define BCACHE_SB_VERSION_CDEV		0
-#define BCACHE_SB_VERSION_BDEV		1
-#define BCACHE_SB_VERSION_CDEV_WITH_UUID 3
-#define BCACHE_SB_VERSION_BDEV_WITH_OFFSET 4
-#define BCACHE_SB_MAX_VERSION		4
+#define BCACHE_SB_VERSION_CDEV			0
+#define BCACHE_SB_VERSION_BDEV			1
+#define BCACHE_SB_VERSION_CDEV_WITH_UUID 	3
+#define BCACHE_SB_VERSION_BDEV_WITH_OFFSET	4
+#define BCACHE_SB_VERSION_CDEV_WITH_FEATURES	5
+#define BCACHE_SB_VERSION_BDEV_WITH_FEATURES	6
+#define BCACHE_SB_MAX_VERSION			6
 
 #define SB_SECTOR			8
 #define SB_OFFSET			(SB_SECTOR << SECTOR_SHIFT)
@@ -173,7 +175,12 @@ struct cache_sb_disk {
 
 /*068*/	__le64			flags;
 /*070*/	__le64			seq;
-/*078*/	__le64			pad[8];
+
+/*078*/	__le64			feature_compat;
+/*080*/	__le64			feature_incompat;
+/*088*/	__le64			feature_ro_compat;
+
+/*090*/	__le64			pad[5];
 
 	union {
 	struct {
@@ -225,7 +232,12 @@ struct cache_sb {
 
 	__u64			flags;
 	__u64			seq;
-	__u64			pad[8];
+
+	__le64			feature_compat;
+	__le64			feature_incompat;
+	__le64			feature_ro_compat;
+
+	__u64			pad[5];
 
 	union {
 	struct {
@@ -263,7 +275,8 @@ struct cache_sb {
 static inline _Bool SB_IS_BDEV(const struct cache_sb *sb)
 {
 	return sb->version == BCACHE_SB_VERSION_BDEV
-		|| sb->version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET;
+		|| sb->version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET
+		|| sb->version == BCACHE_SB_VERSION_BDEV_WITH_FEATURES;
 }
 
 BITMASK(CACHE_SYNC,			struct cache_sb, flags, 0, 1);
-- 
2.26.2

