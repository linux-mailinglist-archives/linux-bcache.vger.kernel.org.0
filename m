Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D5124545A
	for <lists+linux-bcache@lfdr.de>; Sun, 16 Aug 2020 00:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgHOWXv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 15 Aug 2020 18:23:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:37954 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728786AbgHOWXr (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 15 Aug 2020 18:23:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D4614B1D3;
        Sat, 15 Aug 2020 12:48:37 +0000 (UTC)
From:   colyli@suse.de
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH v1 14/14] bcache: move struct cache_sb out of uapi bcache.h
Date:   Sat, 15 Aug 2020 20:47:43 +0800
Message-Id: <20200815124743.115270-15-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200815124743.115270-1-colyli@suse.de>
References: <20200815124743.115270-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

struct cache_sb does not exactly map to cache_sb_disk, it is only for
in-memory super block and dosn't belong to uapi bcache.h.

This patch moves the struct cache_sb definition and other depending
macros and inline routines from include/uapi/linux/bcache.h to
drivers/md/bcache/bcache.h, this is the proper location to have them.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/bcache.h  | 99 +++++++++++++++++++++++++++++++++++++
 include/uapi/linux/bcache.h | 98 ------------------------------------
 2 files changed, 99 insertions(+), 98 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 1d57f48307e6..b755bf7832ac 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -279,6 +279,82 @@ struct bcache_device {
 		     unsigned int cmd, unsigned long arg);
 };
 
+/*
+ * This is for in-memory bcache super block.
+ * NOTE: cache_sb is NOT exactly mapping to cache_sb_disk, the member
+ *       size, ordering and even whole struct size may be different
+ *       from cache_sb_disk.
+ */
+struct cache_sb {
+	__u64			offset;	/* sector where this sb was written */
+	__u64			version;
+
+	__u8			magic[16];
+
+	__u8			uuid[16];
+	union {
+		__u8		set_uuid[16];
+		__u64		set_magic;
+	};
+	__u8			label[SB_LABEL_SIZE];
+
+	__u64			flags;
+	__u64			seq;
+
+	__u64			feature_compat;
+	__u64			feature_incompat;
+	__u64			feature_ro_compat;
+
+	union {
+	struct {
+		/* Cache devices */
+		__u64		nbuckets;	/* device size */
+
+		__u16		block_size;	/* sectors */
+		__u16		nr_in_set;
+		__u16		nr_this_dev;
+		__u32		bucket_size;	/* sectors */
+	};
+	struct {
+		/* Backing devices */
+		__u64		data_offset;
+
+		/*
+		 * block_size from the cache device section is still used by
+		 * backing devices, so don't add anything here until we fix
+		 * things to not need it for backing devices anymore
+		 */
+	};
+	};
+
+	__u32			last_mount;	/* time overflow in y2106 */
+
+	__u16			first_bucket;
+	union {
+		__u16		njournal_buckets;
+		__u16		keys;
+	};
+	__u64			d[SB_JOURNAL_BUCKETS];	/* journal buckets */
+};
+
+BITMASK(CACHE_SYNC,			struct cache_sb, flags, 0, 1);
+BITMASK(CACHE_DISCARD,			struct cache_sb, flags, 1, 1);
+BITMASK(CACHE_REPLACEMENT,		struct cache_sb, flags, 2, 3);
+#define CACHE_REPLACEMENT_LRU		0U
+#define CACHE_REPLACEMENT_FIFO		1U
+#define CACHE_REPLACEMENT_RANDOM	2U
+
+BITMASK(BDEV_CACHE_MODE,		struct cache_sb, flags, 0, 4);
+#define CACHE_MODE_WRITETHROUGH		0U
+#define CACHE_MODE_WRITEBACK		1U
+#define CACHE_MODE_WRITEAROUND		2U
+#define CACHE_MODE_NONE			3U
+BITMASK(BDEV_STATE,			struct cache_sb, flags, 61, 2);
+#define BDEV_STATE_NONE			0U
+#define BDEV_STATE_CLEAN		1U
+#define BDEV_STATE_DIRTY		2U
+#define BDEV_STATE_STALE		3U
+
 struct io {
 	/* Used to track sequential IO so it can be skipped */
 	struct hlist_node	hash;
@@ -840,6 +916,13 @@ static inline bool ptr_available(struct cache_set *c, const struct bkey *k,
 	return (PTR_DEV(k, i) < MAX_CACHES_PER_SET) && PTR_CACHE(c, k, i);
 }
 
+static inline _Bool SB_IS_BDEV(const struct cache_sb *sb)
+{
+	return sb->version == BCACHE_SB_VERSION_BDEV
+		|| sb->version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET
+		|| sb->version == BCACHE_SB_VERSION_BDEV_WITH_FEATURES;
+}
+
 /* Btree key macros */
 
 /*
@@ -958,6 +1041,22 @@ static inline void wait_for_kthread_stop(void)
 	}
 }
 
+/* generate magic number */
+static inline __u64 jset_magic(struct cache_sb *sb)
+{
+	return sb->set_magic ^ JSET_MAGIC;
+}
+
+static inline __u64 pset_magic(struct cache_sb *sb)
+{
+	return sb->set_magic ^ PSET_MAGIC;
+}
+
+static inline __u64 bset_magic(struct cache_sb *sb)
+{
+	return sb->set_magic ^ BSET_MAGIC;
+}
+
 /* Forward declarations */
 
 void bch_count_backing_io_errors(struct cached_dev *dc, struct bio *bio);
diff --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h
index 52e8bcb33981..18166a3d8503 100644
--- a/include/uapi/linux/bcache.h
+++ b/include/uapi/linux/bcache.h
@@ -216,89 +216,6 @@ struct cache_sb_disk {
 	__le16			bucket_size_hi;
 };
 
-/*
- * This is for in-memory bcache super block.
- * NOTE: cache_sb is NOT exactly mapping to cache_sb_disk, the member
- *       size, ordering and even whole struct size may be different
- *       from cache_sb_disk.
- */
-struct cache_sb {
-	__u64			offset;	/* sector where this sb was written */
-	__u64			version;
-
-	__u8			magic[16];
-
-	__u8			uuid[16];
-	union {
-		__u8		set_uuid[16];
-		__u64		set_magic;
-	};
-	__u8			label[SB_LABEL_SIZE];
-
-	__u64			flags;
-	__u64			seq;
-
-	__u64			feature_compat;
-	__u64			feature_incompat;
-	__u64			feature_ro_compat;
-
-	union {
-	struct {
-		/* Cache devices */
-		__u64		nbuckets;	/* device size */
-
-		__u16		block_size;	/* sectors */
-		__u16		nr_in_set;
-		__u16		nr_this_dev;
-		__u32		bucket_size;	/* sectors */
-	};
-	struct {
-		/* Backing devices */
-		__u64		data_offset;
-
-		/*
-		 * block_size from the cache device section is still used by
-		 * backing devices, so don't add anything here until we fix
-		 * things to not need it for backing devices anymore
-		 */
-	};
-	};
-
-	__u32			last_mount;	/* time overflow in y2106 */
-
-	__u16			first_bucket;
-	union {
-		__u16		njournal_buckets;
-		__u16		keys;
-	};
-	__u64			d[SB_JOURNAL_BUCKETS];	/* journal buckets */
-};
-
-static inline _Bool SB_IS_BDEV(const struct cache_sb *sb)
-{
-	return sb->version == BCACHE_SB_VERSION_BDEV
-		|| sb->version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET
-		|| sb->version == BCACHE_SB_VERSION_BDEV_WITH_FEATURES;
-}
-
-BITMASK(CACHE_SYNC,			struct cache_sb, flags, 0, 1);
-BITMASK(CACHE_DISCARD,			struct cache_sb, flags, 1, 1);
-BITMASK(CACHE_REPLACEMENT,		struct cache_sb, flags, 2, 3);
-#define CACHE_REPLACEMENT_LRU		0U
-#define CACHE_REPLACEMENT_FIFO		1U
-#define CACHE_REPLACEMENT_RANDOM	2U
-
-BITMASK(BDEV_CACHE_MODE,		struct cache_sb, flags, 0, 4);
-#define CACHE_MODE_WRITETHROUGH		0U
-#define CACHE_MODE_WRITEBACK		1U
-#define CACHE_MODE_WRITEAROUND		2U
-#define CACHE_MODE_NONE			3U
-BITMASK(BDEV_STATE,			struct cache_sb, flags, 61, 2);
-#define BDEV_STATE_NONE			0U
-#define BDEV_STATE_CLEAN		1U
-#define BDEV_STATE_DIRTY		2U
-#define BDEV_STATE_STALE		3U
-
 /*
  * Magic numbers
  *
@@ -310,21 +227,6 @@ BITMASK(BDEV_STATE,			struct cache_sb, flags, 61, 2);
 #define PSET_MAGIC			0x6750e15f87337f91ULL
 #define BSET_MAGIC			0x90135c78b99e07f5ULL
 
-static inline __u64 jset_magic(struct cache_sb *sb)
-{
-	return sb->set_magic ^ JSET_MAGIC;
-}
-
-static inline __u64 pset_magic(struct cache_sb *sb)
-{
-	return sb->set_magic ^ PSET_MAGIC;
-}
-
-static inline __u64 bset_magic(struct cache_sb *sb)
-{
-	return sb->set_magic ^ BSET_MAGIC;
-}
-
 /*
  * Journal
  *
-- 
2.26.2

