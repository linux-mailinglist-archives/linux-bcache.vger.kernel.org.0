Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1186C471BCC
	for <lists+linux-bcache@lfdr.de>; Sun, 12 Dec 2021 18:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbhLLRGt (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 12 Dec 2021 12:06:49 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:39822 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbhLLRGt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 12 Dec 2021 12:06:49 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 811461F3B8;
        Sun, 12 Dec 2021 17:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1639328808; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EW1zqLubM+KcJjZzT90EuZMBY75jeWf2XI+GKdWS6lY=;
        b=sTuOjXY7THPx4r6RmnA5POeyvM7DzzFz3A73UFDEcgYQqYgqBwJ/s+Oh+aoLL1FldDlas5
        JcPbt/QKG8mxkW3Bb+1kS4XV8PxExu4bATuZCXUETrDAk2706KZ/C7vRu1fXdgUvo4k6V0
        nF9NaTm5sbV0J838xo+0p3gHJp+o5XY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1639328808;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EW1zqLubM+KcJjZzT90EuZMBY75jeWf2XI+GKdWS6lY=;
        b=4hk3B1iHIV1uRppjdD4EHT8qWKtW4TpKspoT8rZy1DI2q9zDsWCn47saR2286Wy+6iObQW
        IFfYtSgb0Wc0qWCQ==
Received: from suse.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id AA523A3B8B;
        Sun, 12 Dec 2021 17:06:45 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.de>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v13 11/12] bcache: read jset from NVDIMM pages for journal replay
Date:   Mon, 13 Dec 2021 01:05:51 +0800
Message-Id: <20211212170552.2812-12-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211212170552.2812-1-colyli@suse.de>
References: <20211212170552.2812-1-colyli@suse.de>
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

The code comments added in journal_read_bucket() is noticed by kernel
test robot and Dan Carpenter, it explains why it is safe to only check
!bch_has_feature_nvdimm_meta() condition in the if() statement when
CONFIG_BCACHE_NVM_PAGES is not configured. To avoid confusion from the
bogus warning message from static checking tool.

Signed-off-by: Coly Li <colyli@suse.de>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jianpeng Ma <jianpeng.ma@intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/journal.c | 88 ++++++++++++++++++++++++++++++-------
 1 file changed, 71 insertions(+), 17 deletions(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 7d5c5ed18890..902992be9191 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -34,18 +34,60 @@ static void journal_read_endio(struct bio *bio)
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
+
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
+#if defined(CONFIG_BCACHE_NVM_PAGES)
+
+static struct jset *__jnl_rd_nvm_bkt(struct cache *ca, unsigned int bkt_idx,
+				     unsigned int len, unsigned int offset)
+{
+	void *jset_addr;
+	struct jset *data;
+
+	jset_addr = bch_nvmpg_offset_to_ptr(ca->sb.d[bkt_idx]) + (offset << 9);
+	data = ca->set->journal.w[0].data;
+
+	memcpy(data, jset_addr, len << 9);
+
+	/* Indeed journal.w[0].data */
+	return data;
+}
+
+#endif /* CONFIG_BCACHE_NVM_PAGES */
+
 static int journal_read_bucket(struct cache *ca, struct list_head *list,
 			       unsigned int bucket_index)
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
 
@@ -55,26 +97,27 @@ static int journal_read_bucket(struct cache *ca, struct list_head *list,
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
+			j = __jnl_rd_bkt(ca, bucket_index, len, offset, &cl);
+		/*
+		 * If CONFIG_BCACHE_NVM_PAGES is not defined, the feature bit
+		 * BCH_FEATURE_INCOMPAT_NVDIMM_META won't in incompatible
+		 * support feature set, a cache device format with feature bit
+		 * BCH_FEATURE_INCOMPAT_NVDIMM_META will fail much earlier in
+		 * read_super() by bch_has_unknown_incompat_features().
+		 * Therefore when CONFIG_BCACHE_NVM_PAGES is not define, it is
+		 * safe to ignore the bch_has_feature_nvdimm_meta() condition.
+		 */
+#if defined(CONFIG_BCACHE_NVM_PAGES)
+		else
+			j = __jnl_rd_nvm_bkt(ca, bucket_index, len, offset);
+#endif
 
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
@@ -170,6 +213,8 @@ reread:		left = ca->sb.bucket_size - offset;
 	return ret;
 }
 
+static int __bch_journal_nvdimm_init(struct cache *ca);
+
 int bch_journal_read(struct cache_set *c, struct list_head *list)
 {
 #define read_bucket(b)							\
@@ -188,6 +233,15 @@ int bch_journal_read(struct cache_set *c, struct list_head *list)
 	unsigned int i, l, r, m;
 	uint64_t seq;
 
+	/*
+	 * Linear addresses of NVDIMM pages for journaling is not
+	 * initialized yet, do it before read jset from NVDIMM pages.
+	 */
+	if (bch_has_feature_nvdimm_meta(&ca->sb)) {
+		if (__bch_journal_nvdimm_init(ca) < 0)
+			return -ENXIO;
+	}
+
 	bitmap_zero(bitmap, SB_JOURNAL_BUCKETS);
 	pr_debug("%u journal buckets\n", ca->sb.njournal_buckets);
 
-- 
2.31.1

