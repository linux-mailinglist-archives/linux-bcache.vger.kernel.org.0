Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C294C3E9680
	for <lists+linux-bcache@lfdr.de>; Wed, 11 Aug 2021 19:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbhHKRFT (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 11 Aug 2021 13:05:19 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:48392 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbhHKRFT (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 11 Aug 2021 13:05:19 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id B45FE2220F;
        Wed, 11 Aug 2021 17:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628701494; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ecIa84cgTVNhRGYl/WBq7EpOun0kY/mYu4uzS76R8dA=;
        b=1E93cL6Djb7Mj1kctKms3Ce3R7RtTZy9SAwZ13NTD7ofkNNBmzaQZ7t0WubRJV5MeJ4x3Y
        UHzLaM5H6MxO2bkjSB7aKhpF0E4zfGVyj9P3Uu6nw1347w2aNVNU3zk+A3pPF3mk9NClAM
        A3jTbTSoNmhH4keaMtI1RQYlRWy9d+w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628701494;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ecIa84cgTVNhRGYl/WBq7EpOun0kY/mYu4uzS76R8dA=;
        b=GeRH1c7VyumFjaF2bxVkQP+D7dbHQICt82P1WZwIdaDuk2ox9DOGideAkyg2i1ZOJlV3Vf
        VXr0V00IERPBXnAg==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id A5519A3D5E;
        Wed, 11 Aug 2021 17:04:48 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-nvdimm@lists.linux.dev,
        axboe@kernel.dk, hare@suse.com, jack@suse.cz,
        dan.j.williams@intel.com, hch@lst.de, ying.huang@intel.com,
        Coly Li <colyli@suse.de>, Hannes Reinecke <hare@suse.de>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v12 09/12] bcache: initialize bcache journal for NVDIMM meta device
Date:   Thu, 12 Aug 2021 01:02:21 +0800
Message-Id: <20210811170224.42837-10-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210811170224.42837-1-colyli@suse.de>
References: <20210811170224.42837-1-colyli@suse.de>
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
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jianpeng Ma <jianpeng.ma@intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/journal.c   | 117 ++++++++++++++++++++++++++++++++++
 drivers/md/bcache/journal.h   |   2 +-
 drivers/md/bcache/nvm-pages.c |   9 +++
 drivers/md/bcache/nvm-pages.h |   1 +
 drivers/md/bcache/super.c     |  18 +++---
 5 files changed, 136 insertions(+), 11 deletions(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 61bd79babf7a..9fe6c1abfd84 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -9,6 +9,8 @@
 #include "btree.h"
 #include "debug.h"
 #include "extents.h"
+#include "nvm-pages.h"
+#include "features.h"
 
 #include <trace/events/bcache.h>
 
@@ -982,3 +984,118 @@ int bch_journal_alloc(struct cache_set *c)
 
 	return 0;
 }
+
+#if defined(CONFIG_BCACHE_NVM_PAGES)
+
+static void *find_journal_nvmpg_base(struct bch_nvmpg_head *nvmpg_head,
+				   struct cache *ca)
+{
+	void *addr = NULL;
+	unsigned long jnl_offset, jnl_pgoff, jnl_ns_id;
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
+				addr = bch_nvmpg_offset_to_ptr(jnl_offset);
+				goto out;
+			}
+			recs_offset = recs->next_offset;
+			recs = bch_nvmpg_offset_to_ptr(recs_offset);
+		}
+	}
+
+out:
+	return addr;
+}
+
+static void *get_journal_nvmpg_space(struct cache *ca)
+{
+	struct bch_nvmpg_head *head = NULL;
+	void *ret = NULL;
+	int order;
+
+	head = bch_get_nvmpg_head(ca->sb.set_uuid);
+	if (head) {
+		ret = find_journal_nvmpg_base(head, ca);
+		if (ret)
+			goto found;
+	}
+
+	order = ilog2((ca->sb.bucket_size *
+		       ca->sb.njournal_buckets) / PAGE_SECTORS);
+	ret = bch_nvmpg_alloc_pages(order, ca->sb.set_uuid);
+	if (ret)
+		memset(ret, 0, (1 << order) * PAGE_SIZE);
+found:
+	return ret;
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
+	void *jnl_base = NULL;
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
+	for (i = 0; i < ca->sb.keys; i++) {
+		unsigned long jnl_offset;
+
+		jnl_offset = bch_nvmpg_ptr_to_offset(bch_nvmpg_id_to_ns(0),
+					jnl_base + (bucket_bytes(ca) * i));
+		ca->sb.d[i] = jnl_offset;
+	}
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
 
diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index 497360c60f26..55f3f9b7fb0c 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
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
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
index 2f6f2ffbfd80..13cc6a532bda 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -94,6 +94,7 @@ void bch_nvmpg_exit(void);
 void *bch_nvmpg_alloc_pages(int order, const char *uuid);
 void bch_nvmpg_free_pages(void *addr, int order, const char *uuid);
 struct bch_nvmpg_head *bch_get_nvmpg_head(const char *uuid);
+struct bch_nvmpg_ns *bch_nvmpg_id_to_ns(int ns_id);
 
 #else
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 4326ffa0d21f..e66e1d6ef260 100644
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
@@ -2065,14 +2067,10 @@ static int run_cache_set(struct cache_set *c)
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
2.26.2

