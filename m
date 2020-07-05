Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBEC6214DE9
	for <lists+linux-bcache@lfdr.de>; Sun,  5 Jul 2020 18:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbgGEQE4 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 5 Jul 2020 12:04:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:39552 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727090AbgGEQE4 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 5 Jul 2020 12:04:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0E888AFC0;
        Sun,  5 Jul 2020 16:04:53 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [RFC PATCH 3/4] bcache-tools: The new super block version BCACHE_SB_VERSION_BDEV_WITH_FEATURES
Date:   Mon,  6 Jul 2020 00:04:39 +0800
Message-Id: <20200705160440.5801-4-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200705160440.5801-1-colyli@suse.de>
References: <20200705160440.5801-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The new super block version BCACHE_SB_VERSION_BDEV_WITH_FEATURES value
is 5, both cache device and backing device share this version number.

Devices have super block version equal to the new version will have
three new members,
/*078*/ uint64_t                feature_compat;
/*080*/ uint64_t                feature_incompat;
/*088*/ uint64_t                feature_ro_compat;

They are used for further new features which may introduce on-disk
format change, the very basic features handling code skeleton is also
initialized in this patch.

Signed-off-by: Coly Li <colyli@suse.de>
---
 Makefile        |  2 +-
 bcache.h        | 83 +++++++++++++++++++++++++++++++++++++++++++++++--
 features.c      | 22 +++++++++++++
 make.c          |  8 +++++
 struct_offset.c |  2 +-
 5 files changed, 113 insertions(+), 4 deletions(-)
 create mode 100644 features.c

diff --git a/Makefile b/Makefile
index b352d21..b5b41e4 100644
--- a/Makefile
+++ b/Makefile
@@ -40,4 +40,4 @@ bcache-register: bcache-register.o
 bcache: CFLAGS += `pkg-config --cflags blkid uuid smartcols`
 bcache: LDLIBS += `pkg-config --libs blkid uuid smartcols`
 bcache: CFLAGS += -std=gnu99
-bcache: crc64.o lib.o make.o zoned.o
+bcache: crc64.o lib.o make.o zoned.o features.o
diff --git a/bcache.h b/bcache.h
index 3fcf187..3695712 100644
--- a/bcache.h
+++ b/bcache.h
@@ -27,12 +27,16 @@ static const char bcache_magic[] = {
  * Version 2: Seed pointer into btree node checksum
  * Version 3: Cache device with new UUID format
  * Version 4: Backing device with data offset
+ * Version 5: Cache adn backing devices with compat/incompat/ro_compat
+ *            feature sets
  */
 #define BCACHE_SB_VERSION_CDEV			0
 #define BCACHE_SB_VERSION_BDEV			1
 #define BCACHE_SB_VERSION_CDEV_WITH_UUID	3
 #define BCACHE_SB_VERSION_BDEV_WITH_OFFSET	4
-#define BCACHE_SB_MAX_VERSION			4
+#define BCACHE_SB_VERSION_CDEV_WITH_FEATURES	5
+#define BCACHE_SB_VERSION_BDEV_WITH_FEATURES	6
+#define BCACHE_SB_MAX_VERSION			6
 
 #define SB_SECTOR		8
 #define SB_LABEL_SIZE		32
@@ -57,7 +61,12 @@ struct cache_sb {
 
 /*068*/	uint64_t		flags;
 /*070*/	uint64_t		seq;
-/*078*/	uint64_t		pad[8];
+
+/*078*/	uint64_t		feature_compat;
+/*080*/	uint64_t		feature_incompat;
+/*088*/	uint64_t		feature_ro_compat;
+
+/*090*/	uint64_t		pad[5];
 
 	union {
 	struct {
@@ -127,4 +136,74 @@ uint64_t crc64(const void *data, size_t len);
 #define csum_set(i)							\
 	crc64(((void *) (i)) + 8, ((void *) end(i)) - (((void *) (i)) + 8))
 
+#define BCH_FEATURE_COMPAT	0
+#define BCH_FEATURE_INCOMPAT	1
+#define BCH_FEATURE_RO_INCOMPAT	2
+#define BCH_FEATURE_TYPE_MASK	0x03
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
 #endif
diff --git a/features.c b/features.c
new file mode 100644
index 0000000..013a5ca
--- /dev/null
+++ b/features.c
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Author: Coly Li <colyli@suse.de>
+ *
+ * Inspired by e2fsprogs features compat/incompat/ro_compat
+ * related code.
+ */
+#include <stdbool.h>
+#include <stdint.h>
+#include <sys/types.h>
+
+#include "bcache.h"
+
+struct feature {
+	int		compat;
+	unsigned int	mask;
+	const char	*string;
+};
+
+static struct feature feature_list[] = {
+	{0, 0, 0 },
+};
diff --git a/make.c b/make.c
index cc76863..6d37532 100644
--- a/make.c
+++ b/make.c
@@ -250,6 +250,14 @@ static void swap_sb(struct cache_sb *sb, int write_cdev_super)
 		/* Backing devices */
 		sb->data_offset	= cpu_to_le64(sb->data_offset);
 	}
+
+	/* Convert feature set and version at last */
+	if (sb->version >= BCACHE_SB_VERSION_CDEV_WITH_FEATURES) {
+		sb->feature_compat = cpu_to_le64(sb->feature_compat);
+		sb->feature_incompat = cpu_to_le64(sb->feature_incompat);
+		sb->feature_ro_compat = cpu_to_le64(sb->feature_ro_compat);
+	}
+	sb->version		= cpu_to_le64(sb->version);
 }
 
 static void write_sb(char *dev, unsigned int block_size,
diff --git a/struct_offset.c b/struct_offset.c
index 6061259..54d4a34 100644
--- a/struct_offset.c
+++ b/struct_offset.c
@@ -52,7 +52,7 @@ void print_cache_sb()
 	printf("/* %3.3lx */         	uint16_t	keys;\n", OFF_SB(keys));
 	printf("                  };\n");
 	printf("/* %3.3lx */         uint64_t		d[%u];\n", OFF_SB(d), SB_JOURNAL_BUCKETS);
-	printf("/* %3.3lx */ }\n", OFF_SB(d) + sizeof(uint64_t) * SB_JOURNAL_BUCKETS);
+	printf("/* %3.3lx */ }\n", sizeof(struct cache_sb));
 }
 
 int main(int argc, char *argv[])
-- 
2.26.2

