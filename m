Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B7C315EC6
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Feb 2021 06:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhBJFKP (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Feb 2021 00:10:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:41484 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230242AbhBJFKL (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Feb 2021 00:10:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 91724B0BA;
        Wed, 10 Feb 2021 05:08:32 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH 16/20] bcache: initialize bcache journal for NVDIMM meta device
Date:   Wed, 10 Feb 2021 13:07:38 +0800
Message-Id: <20210210050742.31237-17-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210210050742.31237-1-colyli@suse.de>
References: <20210210050742.31237-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The nvm-pages allocator may store and index the NVDIMM pages allocated
for bcache journal. This patch adds the initialization to store bcache
journal space on NVDIMM pages if BCH_FEATURE_INCOMPAT_NVDIMM_META bit is
set by bcache-tools.

If BCH_FEATURE_INCOMPAT_NVDIMM_META is set, get_nvdimm_journal_space()
will return the linear address of NVDIMM pages for bcache journal,
- If there is previously allocated space, find it from nvm-pages owner
  list and return to bch_journal_init().
- If there is no previously allocated space, require a new NVDIMM range
  from the nvm-pages allocator, and return it to bch_journal_init().

And in bch_journal_init(), keys in sb.d[] store the corresponding linear
address from NVDIMM into sb.d[i].ptr[0] where 'i' is the bucket index to
iterate all journal buckets.

Later when bcache journaling code stores the journaling jset, the target
NVDIMM linear address stored (and updated) in sb.d[i].ptr[0] can be used
directly in memory copy from DRAM pages into NVDIMM pages.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Jianpeng Ma <jianpeng.ma@intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/journal.c | 97 +++++++++++++++++++++++++++++++++++++
 drivers/md/bcache/journal.h |  2 +-
 drivers/md/bcache/super.c   | 16 +++---
 3 files changed, 107 insertions(+), 8 deletions(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index c6613e817333..1f16d8e497cf 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -9,6 +9,8 @@
 #include "btree.h"
 #include "debug.h"
 #include "extents.h"
+#include "nvm-pages.h"
+#include "features.h"
 
 #include <trace/events/bcache.h>
 
@@ -982,3 +984,98 @@ int bch_journal_alloc(struct cache_set *c)
 
 	return 0;
 }
+
+static void *find_journal_nvm_base(struct bch_extent *list, struct cache *ca)
+{
+	void *ret = NULL;
+	struct bch_extent *cur, *next;
+
+	next = list;
+	do {
+		cur = next;
+		/* Match journal area's nvdimm address */
+		if (cur->kaddr == (void *)ca->sb.d[0]) {
+			ret = cur->kaddr;
+			break;
+		}
+		next = list_entry(cur->list.next, struct bch_extent, list);
+	} while (next != list);
+
+	return ret;
+}
+
+static void bch_release_nvm_extent_list(struct bch_extent *list)
+{
+	struct bch_extent *ext;
+	struct list_head *cur, *next;
+
+	list_for_each_safe(cur, next, &list->list) {
+		ext = list_entry(cur, struct bch_extent, list);
+		kfree(ext);
+	}
+}
+
+static void *get_nvdimm_journal_space(struct cache *ca)
+{
+	struct bch_extent *allocated_list = NULL;
+	void *ret = NULL;
+
+	allocated_list = bch_get_allocated_pages(ca->sb.set_uuid);
+	if (allocated_list) {
+		ret = find_journal_nvm_base(allocated_list, ca);
+		bch_release_nvm_extent_list(allocated_list);
+	}
+
+	if (!ret) {
+		int order = ilog2(ca->sb.bucket_size * ca->sb.njournal_buckets /
+				  PAGE_SECTORS);
+
+		ret = bch_nvm_alloc_pages(order, ca->sb.set_uuid);
+		if (ret)
+			memset(ret, 0, (1 << order) * PAGE_SIZE);
+	}
+
+	return ret;
+}
+
+static int __bch_journal_nvdimm_init(struct cache *ca)
+{
+	int i, ret = 0;
+	void *journal_nvm_base = NULL;
+
+	journal_nvm_base = get_nvdimm_journal_space(ca);
+	if (!journal_nvm_base) {
+		pr_err("Failed to get journal space from nvdimm\n");
+		ret = -1;
+		goto out;
+	}
+
+	/* Iniialized and reloaded from on-disk super block already */
+	if (ca->sb.d[0] != 0)
+		goto out;
+
+	for (i = 0; i < ca->sb.keys; i++)
+		ca->sb.d[i] =
+			(u64)(journal_nvm_base + (ca->sb.bucket_size * i));
+
+out:
+	return ret;
+}
+
+int bch_journal_init(struct cache_set *c)
+{
+	int i, ret = 0;
+	struct cache *ca = c->cache;
+
+	ca->sb.keys = clamp_t(int, ca->sb.nbuckets >> 7,
+				2, SB_JOURNAL_BUCKETS);
+
+	if (!bch_has_feature_nvdimm_meta(&ca->sb)) {
+		for (i = 0; i < ca->sb.keys; i++)
+			ca->sb.d[i] = ca->sb.first_bucket + i;
+	} else {
+		ret = __bch_journal_nvdimm_init(ca);
+	}
+
+	return ret;
+}
diff --git a/drivers/md/bcache/journal.h b/drivers/md/bcache/journal.h
index f2ea34d5f431..e3a7fa5a8fda 100644
--- a/drivers/md/bcache/journal.h
+++ b/drivers/md/bcache/journal.h
@@ -179,7 +179,7 @@ void bch_journal_mark(struct cache_set *c, struct list_head *list);
 void bch_journal_meta(struct cache_set *c, struct closure *cl);
 int bch_journal_read(struct cache_set *c, struct list_head *list);
 int bch_journal_replay(struct cache_set *c, struct list_head *list);
-
+int bch_journal_init(struct cache_set *c);
 void bch_journal_free(struct cache_set *c);
 int bch_journal_alloc(struct cache_set *c);
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 915f1ea4dfd9..57c96c16ee16 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -146,10 +146,15 @@ static const char *read_super_common(struct cache_sb *sb,  struct block_device *
 		goto err;
 
 	err = "Journal buckets not sequential";
+#ifdef CONFIG_BCACHE_NVM_PAGES
+	if (!bch_has_feature_nvdimm_meta(sb)) {
+#endif
 	for (i = 0; i < sb->keys; i++)
 		if (sb->d[i] != sb->first_bucket + i)
 			goto err;
-
+#ifdef CONFIG_BCACHE_NVM_PAGES
+	} /* bch_has_feature_nvdimm_meta */
+#endif
 	err = "Too many journal buckets";
 	if (sb->first_bucket + sb->keys > sb->nbuckets)
 		goto err;
@@ -2072,14 +2077,11 @@ static int run_cache_set(struct cache_set *c)
 		if (bch_journal_replay(c, &journal))
 			goto err;
 	} else {
-		unsigned int j;
-
 		pr_notice("invalidating existing data\n");
-		ca->sb.keys = clamp_t(int, ca->sb.nbuckets >> 7,
-					2, SB_JOURNAL_BUCKETS);
 
-		for (j = 0; j < ca->sb.keys; j++)
-			ca->sb.d[j] = ca->sb.first_bucket + j;
+		err = "error initializing journal";
+		if (bch_journal_init(c))
+			goto err;
 
 		bch_initial_gc_finish(c);
 
-- 
2.26.2

