Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE1B35EC6C
	for <lists+linux-bcache@lfdr.de>; Wed, 14 Apr 2021 07:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347503AbhDNFr5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 14 Apr 2021 01:47:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:43354 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347501AbhDNFrz (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 14 Apr 2021 01:47:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4D3A0B039;
        Wed, 14 Apr 2021 05:47:33 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        jianpeng.ma@intel.com, qiaowei.ren@intel.com,
        Coly Li <colyli@suse.de>
Subject: [PATCH 11/13] bcache: read jset from NVDIMM pages for journal replay
Date:   Wed, 14 Apr 2021 13:46:46 +0800
Message-Id: <20210414054648.24098-12-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210414054648.24098-1-colyli@suse.de>
References: <20210414054648.24098-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch implements two methods to read jset from media for journal
replay,
- __jnl_rd_bkt() for block device
  This is the legacy method to read jset via block device interface.
- __jnl_rd_nvm_bkt() for NVDIMM
  This is the method to read jset from NVDIMM memory interface, a.k.a
  memcopy() from NVDIMM pages to DRAM pages.

If BCH_FEATURE_INCOMPAT_NVDIMM_META is set in incompat feature set,
during running cache set, journal_read_bucket() will read the journal
content from NVDIMM by __jnl_rd_nvm_bkt(). The linear addresses of
NVDIMM pages to read jset are stored in sb.d[SB_JOURNAL_BUCKETS], which
were initialized and maintained in previous runs of the cache set.

A thing should be noticed is, when bch_journal_read() is called, the
linear address of NVDIMM pages is not loaded and initialized yet, it
is necessary to call __bch_journal_nvdimm_init() before reading the jset
from NVDIMM pages.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Jianpeng Ma <jianpeng.ma@intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/journal.c | 93 +++++++++++++++++++++++++++----------
 1 file changed, 69 insertions(+), 24 deletions(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index e3785da10434..e5f7166e5d9b 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -34,60 +34,96 @@ static void journal_read_endio(struct bio *bio)
 	closure_put(cl);
 }
 
+static struct jset *__jnl_rd_bkt(struct cache *ca, unsigned int bkt_idx,
+				    unsigned int len, unsigned int offset,
+				    struct closure *cl)
+{
+	sector_t bucket = bucket_to_sector(ca->set, ca->sb.d[bkt_idx]);
+	struct bio *bio = &ca->journal.bio;
+	struct jset *data = ca->set->journal.w[0].data;
+
+	bio_reset(bio);
+	bio->bi_iter.bi_sector	= bucket + offset;
+	bio_set_dev(bio, ca->bdev);
+	bio->bi_iter.bi_size	= len << 9;
+	bio->bi_end_io	= journal_read_endio;
+	bio->bi_private = cl;
+	bio_set_op_attrs(bio, REQ_OP_READ, 0);
+	bch_bio_map(bio, data);
+
+	closure_bio_submit(ca->set, bio, cl);
+	closure_sync(cl);
+
+	/* Indeed journal.w[0].data */
+	return data;
+}
+
+#ifdef CONFIG_BCACHE_NVM_PAGES
+
+static struct jset *__jnl_rd_nvm_bkt(struct cache *ca, unsigned int bkt_idx,
+				     unsigned int len, unsigned int offset)
+{
+	void *jset_addr = (void *)ca->sb.d[bkt_idx] + (offset << 9);
+	struct jset *data = ca->set->journal.w[0].data;
+
+	memcpy(data, jset_addr, len << 9);
+
+	/* Indeed journal.w[0].data */
+	return data;
+}
+
+#else /* CONFIG_BCACHE_NVM_PAGES */
+
+static struct jset *__jnl_rd_nvm_bkt(struct cache *ca, unsigned int bkt_idx,
+				     unsigned int len, unsigned int offset)
+{
+	return NULL;
+}
+
+#endif /* CONFIG_BCACHE_NVM_PAGES */
+
 static int journal_read_bucket(struct cache *ca, struct list_head *list,
-			       unsigned int bucket_index)
+			       unsigned int bucket_idx)
 {
 	struct journal_device *ja = &ca->journal;
-	struct bio *bio = &ja->bio;
 
 	struct journal_replay *i;
-	struct jset *j, *data = ca->set->journal.w[0].data;
+	struct jset *j;
 	struct closure cl;
 	unsigned int len, left, offset = 0;
 	int ret = 0;
-	sector_t bucket = bucket_to_sector(ca->set, ca->sb.d[bucket_index]);
 
 	closure_init_stack(&cl);
 
-	pr_debug("reading %u\n", bucket_index);
+	pr_debug("reading %u\n", bucket_idx);
 
 	while (offset < ca->sb.bucket_size) {
 reread:		left = ca->sb.bucket_size - offset;
 		len = min_t(unsigned int, left, PAGE_SECTORS << JSET_BITS);
 
-		bio_reset(bio);
-		bio->bi_iter.bi_sector	= bucket + offset;
-		bio_set_dev(bio, ca->bdev);
-		bio->bi_iter.bi_size	= len << 9;
-
-		bio->bi_end_io	= journal_read_endio;
-		bio->bi_private = &cl;
-		bio_set_op_attrs(bio, REQ_OP_READ, 0);
-		bch_bio_map(bio, data);
-
-		closure_bio_submit(ca->set, bio, &cl);
-		closure_sync(&cl);
+		if (!bch_has_feature_nvdimm_meta(&ca->sb))
+			j = __jnl_rd_bkt(ca, bucket_idx, len, offset, &cl);
+		else
+			j = __jnl_rd_nvm_bkt(ca, bucket_idx, len, offset);
 
 		/* This function could be simpler now since we no longer write
 		 * journal entries that overlap bucket boundaries; this means
 		 * the start of a bucket will always have a valid journal entry
 		 * if it has any journal entries at all.
 		 */
-
-		j = data;
 		while (len) {
 			struct list_head *where;
 			size_t blocks, bytes = set_bytes(j);
 
 			if (j->magic != jset_magic(&ca->sb)) {
-				pr_debug("%u: bad magic\n", bucket_index);
+				pr_debug("%u: bad magic\n", bucket_idx);
 				return ret;
 			}
 
 			if (bytes > left << 9 ||
 			    bytes > PAGE_SIZE << JSET_BITS) {
 				pr_info("%u: too big, %zu bytes, offset %u\n",
-					bucket_index, bytes, offset);
+					bucket_idx, bytes, offset);
 				return ret;
 			}
 
@@ -96,7 +132,7 @@ reread:		left = ca->sb.bucket_size - offset;
 
 			if (j->csum != csum_set(j)) {
 				pr_info("%u: bad csum, %zu bytes, offset %u\n",
-					bucket_index, bytes, offset);
+					bucket_idx, bytes, offset);
 				return ret;
 			}
 
@@ -158,8 +194,8 @@ reread:		left = ca->sb.bucket_size - offset;
 			list_add(&i->list, where);
 			ret = 1;
 
-			if (j->seq > ja->seq[bucket_index])
-				ja->seq[bucket_index] = j->seq;
+			if (j->seq > ja->seq[bucket_idx])
+				ja->seq[bucket_idx] = j->seq;
 next_set:
 			offset	+= blocks * ca->sb.block_size;
 			len	-= blocks * ca->sb.block_size;
@@ -170,6 +206,8 @@ reread:		left = ca->sb.bucket_size - offset;
 	return ret;
 }
 
+static int __bch_journal_nvdimm_init(struct cache *ca);
+
 int bch_journal_read(struct cache_set *c, struct list_head *list)
 {
 #define read_bucket(b)							\
@@ -188,6 +226,13 @@ int bch_journal_read(struct cache_set *c, struct list_head *list)
 	unsigned int i, l, r, m;
 	uint64_t seq;
 
+	/*
+	 * Linear addresses of NVDIMM pages for journaling is not
+	 * initialized yet, do it before read jset from NVDIMM pages.
+	 */
+	if (bch_has_feature_nvdimm_meta(&ca->sb))
+		__bch_journal_nvdimm_init(ca);
+
 	bitmap_zero(bitmap, SB_JOURNAL_BUCKETS);
 	pr_debug("%u journal buckets\n", ca->sb.njournal_buckets);
 
-- 
2.26.2

