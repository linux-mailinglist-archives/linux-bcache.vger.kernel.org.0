Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7593A3E9682
	for <lists+linux-bcache@lfdr.de>; Wed, 11 Aug 2021 19:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhHKRFg (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 11 Aug 2021 13:05:36 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:48414 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbhHKRFe (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 11 Aug 2021 13:05:34 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id D971C22233;
        Wed, 11 Aug 2021 17:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628701509; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1EDZ1BeYl/GOojhFFjp2dFeR3vjBss5L/uK7qG8U+L8=;
        b=Npd/2RjVwQ9puTJSuaXQ2goz31Gd9p4NB3NkGJF88LLWiGfyFwKLDGehnGVslyl/GovdOL
        Zwwk0l7Btrbgz6j7kt0Aj4aqVmLxP7dVtDmKEsL20fXFIyg7+VGib2F1xusb8uLQ56AzgQ
        wO3hcu6pZJtYO5Qbj+z7SgtJHy/0lQ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628701509;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1EDZ1BeYl/GOojhFFjp2dFeR3vjBss5L/uK7qG8U+L8=;
        b=ArrpR2eYPpi2tfsvYNWcj1gTPGH8VwVwpXIl9TXz/xF5LXbeKx5Da9eY2wQdPJndvxW0PD
        oyKfoT2oZJUvCACw==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 53690A3D5E;
        Wed, 11 Aug 2021 17:04:55 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-nvdimm@lists.linux.dev,
        axboe@kernel.dk, hare@suse.com, jack@suse.cz,
        dan.j.williams@intel.com, hch@lst.de, ying.huang@intel.com,
        Coly Li <colyli@suse.de>, Hannes Reinecke <hare@suse.de>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v12 10/12] bcache: support storing bcache journal into NVDIMM meta device
Date:   Thu, 12 Aug 2021 01:02:22 +0800
Message-Id: <20210811170224.42837-11-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210811170224.42837-1-colyli@suse.de>
References: <20210811170224.42837-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch implements two methods to store bcache journal to,
1) __journal_write_unlocked() for block interface device
   The latency method to compose bio and issue the jset bio to cache
   device (e.g. SSD). c->journal.key.ptr[0] indicates the LBA on cache
   device to store the journal jset.
2) __journal_nvdimm_write_unlocked() for memory interface NVDIMM
   Use memory interface to access NVDIMM pages and store the jset by
   memcpy_flushcache(). c->journal.key.ptr[0] indicates the linear
   address from the NVDIMM pages to store the journal jset.

For legacy configuration without NVDIMM meta device, journal I/O is
handled by __journal_write_unlocked() with existing code logic. If the
NVDIMM meta device is used (by bcache-tools), the journal I/O will
be handled by __journal_nvdimm_write_unlocked() and go into the NVDIMM
pages.

And when NVDIMM meta device is used, sb.d[] stores the linear addresses
from NVDIMM pages (no more bucket index), in journal_reclaim() the
journaling location in c->journal.key.ptr[0] should also be updated by
linear address from NVDIMM pages (no more LBA combined by sectors offset
and bucket index).

Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jianpeng Ma <jianpeng.ma@intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/journal.c | 120 +++++++++++++++++++++++++-----------
 drivers/md/bcache/super.c   |   3 +-
 2 files changed, 85 insertions(+), 38 deletions(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 9fe6c1abfd84..8cd0c4dc9137 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -596,6 +596,8 @@ static void do_journal_discard(struct cache *ca)
 		return;
 	}
 
+	BUG_ON(bch_has_feature_nvdimm_meta(&ca->sb));
+
 	switch (atomic_read(&ja->discard_in_flight)) {
 	case DISCARD_IN_FLIGHT:
 		return;
@@ -661,9 +663,16 @@ static void journal_reclaim(struct cache_set *c)
 		goto out;
 
 	ja->cur_idx = next;
-	k->ptr[0] = MAKE_PTR(0,
-			     bucket_to_sector(c, ca->sb.d[ja->cur_idx]),
-			     ca->sb.nr_this_dev);
+	if (!bch_has_feature_nvdimm_meta(&ca->sb))
+		k->ptr[0] = MAKE_PTR(0,
+			bucket_to_sector(c, ca->sb.d[ja->cur_idx]),
+			ca->sb.nr_this_dev);
+#if defined(CONFIG_BCACHE_NVM_PAGES)
+	else
+		k->ptr[0] = (unsigned long)bch_nvmpg_offset_to_ptr(
+						ca->sb.d[ja->cur_idx]);
+#endif
+
 	atomic_long_inc(&c->reclaimed_journal_buckets);
 
 	bkey_init(k);
@@ -729,46 +738,21 @@ static void journal_write_unlock(struct closure *cl)
 	spin_unlock(&c->journal.lock);
 }
 
-static void journal_write_unlocked(struct closure *cl)
+
+static void __journal_write_unlocked(struct cache_set *c)
 	__releases(c->journal.lock)
 {
-	struct cache_set *c = container_of(cl, struct cache_set, journal.io);
-	struct cache *ca = c->cache;
-	struct journal_write *w = c->journal.cur;
 	struct bkey *k = &c->journal.key;
-	unsigned int i, sectors = set_blocks(w->data, block_bytes(ca)) *
-		ca->sb.block_size;
-
+	struct journal_write *w = c->journal.cur;
+	struct closure *cl = &c->journal.io;
+	struct cache *ca = c->cache;
 	struct bio *bio;
 	struct bio_list list;
+	unsigned int i, sectors = set_blocks(w->data, block_bytes(ca)) *
+		ca->sb.block_size;
 
 	bio_list_init(&list);
 
-	if (!w->need_write) {
-		closure_return_with_destructor(cl, journal_write_unlock);
-		return;
-	} else if (journal_full(&c->journal)) {
-		journal_reclaim(c);
-		spin_unlock(&c->journal.lock);
-
-		btree_flush_write(c);
-		continue_at(cl, journal_write, bch_journal_wq);
-		return;
-	}
-
-	c->journal.blocks_free -= set_blocks(w->data, block_bytes(ca));
-
-	w->data->btree_level = c->root->level;
-
-	bkey_copy(&w->data->btree_root, &c->root->key);
-	bkey_copy(&w->data->uuid_bucket, &c->uuid_bucket);
-
-	w->data->prio_bucket[ca->sb.nr_this_dev] = ca->prio_buckets[0];
-	w->data->magic		= jset_magic(&ca->sb);
-	w->data->version	= BCACHE_JSET_VERSION;
-	w->data->last_seq	= last_seq(&c->journal);
-	w->data->csum		= csum_set(w->data);
-
 	for (i = 0; i < KEY_PTRS(k); i++) {
 		ca = c->cache;
 		bio = &ca->journal.bio;
@@ -793,7 +777,6 @@ static void journal_write_unlocked(struct closure *cl)
 
 		ca->journal.seq[ca->journal.cur_idx] = w->data->seq;
 	}
-
 	/* If KEY_PTRS(k) == 0, this jset gets lost in air */
 	BUG_ON(i == 0);
 
@@ -805,6 +788,71 @@ static void journal_write_unlocked(struct closure *cl)
 
 	while ((bio = bio_list_pop(&list)))
 		closure_bio_submit(c, bio, cl);
+}
+
+#if defined(CONFIG_BCACHE_NVM_PAGES)
+
+static void __journal_nvdimm_write_unlocked(struct cache_set *c)
+	__releases(c->journal.lock)
+{
+	struct journal_write *w = c->journal.cur;
+	struct cache *ca = c->cache;
+	unsigned int sectors;
+
+	sectors = set_blocks(w->data, block_bytes(ca)) * ca->sb.block_size;
+	atomic_long_add(sectors, &ca->meta_sectors_written);
+
+	memcpy_flushcache((void *)c->journal.key.ptr[0], w->data, sectors << 9);
+
+	c->journal.key.ptr[0] += sectors << 9;
+	ca->journal.seq[ca->journal.cur_idx] = w->data->seq;
+
+	atomic_dec_bug(&fifo_back(&c->journal.pin));
+	bch_journal_next(&c->journal);
+	journal_reclaim(c);
+
+	spin_unlock(&c->journal.lock);
+}
+
+#endif /* CONFIG_BCACHE_NVM_PAGES */
+
+static void journal_write_unlocked(struct closure *cl)
+{
+	struct cache_set *c = container_of(cl, struct cache_set, journal.io);
+	struct cache *ca = c->cache;
+	struct journal_write *w = c->journal.cur;
+
+	if (!w->need_write) {
+		closure_return_with_destructor(cl, journal_write_unlock);
+		return;
+	} else if (journal_full(&c->journal)) {
+		journal_reclaim(c);
+		spin_unlock(&c->journal.lock);
+
+		btree_flush_write(c);
+		continue_at(cl, journal_write, bch_journal_wq);
+		return;
+	}
+
+	c->journal.blocks_free -= set_blocks(w->data, block_bytes(ca));
+
+	w->data->btree_level = c->root->level;
+
+	bkey_copy(&w->data->btree_root, &c->root->key);
+	bkey_copy(&w->data->uuid_bucket, &c->uuid_bucket);
+
+	w->data->prio_bucket[ca->sb.nr_this_dev] = ca->prio_buckets[0];
+	w->data->magic		= jset_magic(&ca->sb);
+	w->data->version	= BCACHE_JSET_VERSION;
+	w->data->last_seq	= last_seq(&c->journal);
+	w->data->csum		= csum_set(w->data);
+
+	if (!bch_has_feature_nvdimm_meta(&ca->sb))
+		__journal_write_unlocked(c);
+#if defined(CONFIG_BCACHE_NVM_PAGES)
+	else
+		__journal_nvdimm_write_unlocked(c);
+#endif
 
 	continue_at(cl, journal_write_done, NULL);
 }
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index e66e1d6ef260..24734250d005 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1676,7 +1676,7 @@ void bch_cache_set_release(struct kobject *kobj)
 static void cache_set_free(struct closure *cl)
 {
 	struct cache_set *c = container_of(cl, struct cache_set, cl);
-	struct cache *ca;
+	struct cache *ca = c->cache;
 
 	debugfs_remove(c->debug);
 
@@ -1688,7 +1688,6 @@ static void cache_set_free(struct closure *cl)
 	bch_bset_sort_state_free(&c->sort);
 	free_pages((unsigned long) c->uuids, ilog2(meta_bucket_pages(&c->cache->sb)));
 
-	ca = c->cache;
 	if (ca) {
 		ca->set = NULL;
 		c->cache = NULL;
-- 
2.26.2

