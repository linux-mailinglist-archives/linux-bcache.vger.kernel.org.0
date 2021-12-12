Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D5C471BC7
	for <lists+linux-bcache@lfdr.de>; Sun, 12 Dec 2021 18:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbhLLRGn (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 12 Dec 2021 12:06:43 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:39808 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbhLLRGn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 12 Dec 2021 12:06:43 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 41CF31F3B7;
        Sun, 12 Dec 2021 17:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1639328802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Of8BpnxeTdxS6DuXQHQBD0OnVt5FNa4SMxRnCkQBAU4=;
        b=uZsR067gKivtpi2n0Vc74/kb33Jm075PQjRbcCQ3ZRb1OEfTk8SGrVJKARlKG/Wsl4PooN
        r9pNtNCmIutyEX8IbT5hb/fzN6aTLSFRB8mqXE4zN6s0fgrrLnsVp4PSirv/ajh2mFczaF
        CWXtAp5T1uVkB3VjRYGDNbNUHCqLL00=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1639328802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Of8BpnxeTdxS6DuXQHQBD0OnVt5FNa4SMxRnCkQBAU4=;
        b=7wiTpg7w7bY6N0DBb+OyHqhy30JPIEzzmCvT2QKpIMbe20z/sW+KFjwI2fwl8l71O2xgw1
        6n6roETwut7PWuAg==
Received: from suse.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 79637A3B88;
        Sun, 12 Dec 2021 17:06:39 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.de>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v13 09/12] bcache: initialize bcache journal for NVDIMM meta device
Date:   Mon, 13 Dec 2021 01:05:49 +0800
Message-Id: <20211212170552.2812-10-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211212170552.2812-1-colyli@suse.de>
References: <20211212170552.2812-1-colyli@suse.de>
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
will return the nvmpg_offset of NVDIMM pages for bcache journal,
- If there is previously allocated space, find it from nvm-pages owner
  list and return to bch_journal_init().
- If there is no previously allocated space, require a new NVDIMM range
  from the nvm-pages allocator, and return it to bch_journal_init().

And in bch_journal_init(), keys in sb.d[] store the corresponding nvmpg
offset from NVDIMM into sb.d[i].ptr[0] where 'i' is the bucket index to
iterate all journal buckets.

Later when bcache journaling code stores the journaling jset, the target
NVDIMM nvmpg offset stored (and updated) in sb.d[i].ptr[0] can be used
to calculate the linear address in memory copy from DRAM pages into
NVDIMM pages.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jianpeng Ma <jianpeng.ma@intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/journal.c | 113 ++++++++++++++++++++++++++++++++++++
 drivers/md/bcache/journal.h |   2 +-
 drivers/md/bcache/nvmpg.c   |   9 +++
 drivers/md/bcache/nvmpg.h   |   1 +
 drivers/md/bcache/super.c   |  18 +++---
 5 files changed, 132 insertions(+), 11 deletions(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 61bd79babf7a..d887557c718e 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -9,6 +9,8 @@
 #include "btree.h"
 #include "debug.h"
 #include "extents.h"
+#include "nvmpg.h"
+#include "features.h"
 
 #include <trace/events/bcache.h>
 
@@ -982,3 +984,114 @@ int bch_journal_alloc(struct cache_set *c)
 
 	return 0;
 }
+
+#if defined(CONFIG_BCACHE_NVM_PAGES)
+
+static unsigned long find_journal_nvmpg_base(struct bch_nvmpg_head *nvmpg_head,
+					     struct cache *ca)
+{
+	unsigned long jnl_offset, jnl_pgoff, jnl_ns_id;
+	unsigned long ret_offset = 0;
+	int i;
+
+	jnl_offset = (unsigned long)ca->sb.d[0];
+	jnl_ns_id = BCH_NVMPG_GET_NS_ID(jnl_offset);
+	jnl_pgoff = BCH_NVMPG_GET_OFFSET(jnl_offset) >> PAGE_SHIFT;
+
+	for (i = 0; i < BCH_NVMPG_NS_MAX; i++) {
+		struct bch_nvmpg_recs *recs;
+		struct bch_nvmpg_rec *rec;
+		unsigned long recs_offset = 0;
+		int j;
+
+		recs_offset = nvmpg_head->recs_offset[i];
+		recs = bch_nvmpg_offset_to_ptr(recs_offset);
+		while (recs) {
+			for (j = 0; j < recs->size; j++) {
+				rec = &recs->recs[j];
+				if ((rec->pgoff != jnl_pgoff) ||
+				    (rec->ns_id != jnl_ns_id))
+					continue;
+
+				ret_offset = jnl_offset;
+				goto out;
+			}
+			recs_offset = recs->next_offset;
+			recs = bch_nvmpg_offset_to_ptr(recs_offset);
+		}
+	}
+
+out:
+	return ret_offset;
+}
+
+static unsigned long get_journal_nvmpg_space(struct cache *ca)
+{
+	struct bch_nvmpg_head *head = NULL;
+	unsigned long nvmpg_offset;
+	int order;
+
+	head = bch_get_nvmpg_head(ca->sb.set_uuid);
+	if (head) {
+		nvmpg_offset = find_journal_nvmpg_base(head, ca);
+		if (nvmpg_offset)
+			goto found;
+	}
+
+	order = ilog2((ca->sb.bucket_size *
+		       ca->sb.njournal_buckets) / PAGE_SECTORS);
+	nvmpg_offset = bch_nvmpg_alloc_pages(order, ca->sb.set_uuid);
+	if (nvmpg_offset)
+		memset(bch_nvmpg_offset_to_ptr(nvmpg_offset),
+		       0, (1 << order) * PAGE_SIZE);
+found:
+	return nvmpg_offset;
+}
+
+#endif /* CONFIG_BCACHE_NVM_PAGES */
+
+static int __bch_journal_nvdimm_init(struct cache *ca)
+{
+	int ret = -1;
+
+#if defined(CONFIG_BCACHE_NVM_PAGES)
+	int i;
+	unsigned long jnl_base = 0;
+
+	jnl_base = get_journal_nvmpg_space(ca);
+	if (!jnl_base) {
+		pr_err("Failed to get journal space from nvdimm\n");
+		goto out;
+	}
+
+	/* Iniialized and reloaded from on-disk super block already */
+	if (ca->sb.d[0] != 0)
+		goto out;
+
+	for (i = 0; i < ca->sb.keys; i++)
+		ca->sb.d[i] = jnl_base + (bucket_bytes(ca) * i);
+
+	ret = 0;
+out:
+#endif /* CONFIG_BCACHE_NVM_PAGES */
+
+	return ret;
+}
+
+
+int bch_journal_init(struct cache_set *c)
+{
+	int i, ret = 0;
+	struct cache *ca = c->cache;
+
+	ca->sb.keys = clamp_t(int, ca->sb.nbuckets >> 7,
+			      2, SB_JOURNAL_BUCKETS);
+
+	if (!bch_has_feature_nvdimm_meta(&ca->sb)) {
+		for (i = 0; i < ca->sb.keys; i++)
+			ca->sb.d[i] = ca->sb.first_bucket + i;
+	} else
+		ret = __bch_journal_nvdimm_init(ca);
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
 
diff --git a/drivers/md/bcache/nvmpg.c b/drivers/md/bcache/nvmpg.c
index e26c7b578a62..1a3c6327b091 100644
--- a/drivers/md/bcache/nvmpg.c
+++ b/drivers/md/bcache/nvmpg.c
@@ -24,6 +24,15 @@
 
 struct bch_nvmpg_set *global_nvmpg_set;
 
+struct bch_nvmpg_ns *bch_nvmpg_id_to_ns(int ns_id)
+{
+	if ((ns_id >= 0) && (ns_id < BCH_NVMPG_NS_MAX))
+		return global_nvmpg_set->ns_tbl[ns_id];
+
+	pr_emerg("Invalid ns_id: %d\n", ns_id);
+	return NULL;
+}
+
 void *bch_nvmpg_offset_to_ptr(unsigned long offset)
 {
 	int ns_id = BCH_NVMPG_GET_NS_ID(offset);
diff --git a/drivers/md/bcache/nvmpg.h b/drivers/md/bcache/nvmpg.h
index 2361cabf18be..f7b7177cced3 100644
--- a/drivers/md/bcache/nvmpg.h
+++ b/drivers/md/bcache/nvmpg.h
@@ -95,6 +95,7 @@ void bch_nvmpg_exit(void);
 unsigned long bch_nvmpg_alloc_pages(int order, const char *uuid);
 void bch_nvmpg_free_pages(unsigned long nvmpg_offset, int order, const char *uuid);
 struct bch_nvmpg_head *bch_get_nvmpg_head(const char *uuid);
+struct bch_nvmpg_ns *bch_nvmpg_id_to_ns(int ns_id);
 
 #else
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 74d51a0b806f..a27fa65d8832 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -147,9 +147,11 @@ static const char *read_super_common(struct cache_sb *sb,  struct block_device *
 		goto err;
 
 	err = "Journal buckets not sequential";
-	for (i = 0; i < sb->keys; i++)
-		if (sb->d[i] != sb->first_bucket + i)
-			goto err;
+	if (!bch_has_feature_nvdimm_meta(sb)) {
+		for (i = 0; i < sb->keys; i++)
+			if (sb->d[i] != sb->first_bucket + i)
+				goto err;
+	}
 
 	err = "Too many journal buckets";
 	if (sb->first_bucket + sb->keys > sb->nbuckets)
@@ -2068,14 +2070,10 @@ static int run_cache_set(struct cache_set *c)
 		if (bch_journal_replay(c, &journal))
 			goto err;
 	} else {
-		unsigned int j;
-
 		pr_notice("invalidating existing data\n");
-		ca->sb.keys = clamp_t(int, ca->sb.nbuckets >> 7,
-					2, SB_JOURNAL_BUCKETS);
-
-		for (j = 0; j < ca->sb.keys; j++)
-			ca->sb.d[j] = ca->sb.first_bucket + j;
+		err = "error initializing journal";
+		if (bch_journal_init(c))
+			goto err;
 
 		bch_initial_gc_finish(c);
 
-- 
2.31.1

