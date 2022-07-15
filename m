Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E549575C6C
	for <lists+linux-bcache@lfdr.de>; Fri, 15 Jul 2022 09:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiGOHdJ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 15 Jul 2022 03:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231998AbiGOHdJ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 15 Jul 2022 03:33:09 -0400
X-Greylist: delayed 976 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 15 Jul 2022 00:33:06 PDT
Received: from mail-m975.mail.163.com (mail-m975.mail.163.com [123.126.97.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8FCE57BE2A
        for <linux-bcache@vger.kernel.org>; Fri, 15 Jul 2022 00:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=UZLhA
        wegZuGsiS+LTErZqdFI4f9C9xq3JjczmxxEGR0=; b=TXmnagv1Vcgv/SZ0mR/Ie
        FvXAJdiEj/KQORrU+sKdlDQKdX0W2dkCN053+g6raFwmopO00Ck3qFh1T9rwX2lb
        7PIPg3V8e4q7x4DM64kVQ5hBPTi5KCUNuggM67Xmg5svorVzPEhq+UTzmmQJaI66
        fsujtxO9bpXM10fdSScN5Y=
Received: from localhost.localdomain (unknown [123.58.221.99])
        by smtp5 (Coremail) with SMTP id HdxpCgAHNq0XFNFiomgFOQ--.5973S2;
        Fri, 15 Jul 2022 15:15:39 +0800 (CST)
From:   williamsukatube@163.com
To:     colyli@suse.de, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     William Dean <williamsukatube@gmail.com>,
        Hacash Robot <hacashRobot@santino.com>
Subject: [PATCH -next] bcache: Fix spelling mistakes and cleanup code
Date:   Fri, 15 Jul 2022 15:15:33 +0800
Message-Id: <20220715071533.2729413-1-williamsukatube@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HdxpCgAHNq0XFNFiomgFOQ--.5973S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3JFWkXr13GFW8Zw48Jw4fZrb_yoWxur1UpF
        W7X34fAw4vqr4UAryDAa4UuFyrJ3srtFW7G3s7u34rZa4UZr1rCFWUKayDAr1UWFyfGFWx
        tr15tw1DWF15KaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jRnQUUUUUU=
X-Originating-IP: [123.58.221.99]
X-CM-SenderInfo: xzlozx5dpv3yxdwxuvi6rwjhhfrp/xtbB6AQ-g2BHJjqvuQAAs9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: William Dean <williamsukatube@gmail.com>

First, fix follow spelling misktakes:
	automatical  ==> automatic
	individial  ==> around
	embeddded  ==> embedded
	addionally  ==> addtionally
	unncessary  ==> unnecessary
	definitly  ==> definitely
Second, delete extra space or tab where
appropriate to make code format more standardized.

Reported-by: Hacash Robot <hacashRobot@santino.com>
Signed-off-by: William Dean <williamsukatube@gmail.com>
---
 drivers/md/bcache/bcache.h    | 2 +-
 drivers/md/bcache/bset.h      | 2 +-
 drivers/md/bcache/btree.c     | 6 +++---
 drivers/md/bcache/btree.h     | 2 +-
 drivers/md/bcache/journal.c   | 2 +-
 drivers/md/bcache/request.c   | 5 ++---
 drivers/md/bcache/stats.c     | 2 +-
 drivers/md/bcache/super.c     | 2 +-
 drivers/md/bcache/writeback.c | 2 +-
 drivers/md/bcache/writeback.h | 2 +-
 10 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 2acda9cea0f9..2b35c0a14d4d 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -635,7 +635,7 @@ struct cache_set {
 	struct bkey		gc_done;
 
 	/*
-	 * For automatical garbage collection after writeback completed, this
+	 * For automatic garbage collection after writeback completed, this
 	 * varialbe is used as bit fields,
 	 * - 0000 0001b (BCH_ENABLE_AUTO_GC): enable gc after writeback
 	 * - 0000 0010b (BCH_DO_AUTO_GC):     do gc after writeback
diff --git a/drivers/md/bcache/bset.h b/drivers/md/bcache/bset.h
index d795c84246b0..76f75bbcb731 100644
--- a/drivers/md/bcache/bset.h
+++ b/drivers/md/bcache/bset.h
@@ -45,7 +45,7 @@
  * 4 in memory - we lazily resort as needed.
  *
  * We implement code here for creating and maintaining auxiliary search trees
- * (described below) for searching an individial bset, and on top of that we
+ * (described below) for searching an individual bset, and on top of that we
  * implement a btree iterator.
  *
  * BTREE ITERATOR:
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index e136d6edc1ed..3d9fec07e862 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -154,7 +154,7 @@ void bch_btree_node_read_done(struct btree *b)
 	/*
 	 * c->fill_iter can allocate an iterator with more memory space
 	 * than static MAX_BSETS.
-	 * See the comment arount cache_set->fill_iter.
+	 * See the comment around cache_set->fill_iter.
 	 */
 	iter = mempool_alloc(&b->c->fill_iter, GFP_NOIO);
 	iter->size = b->c->cache->sb.bucket_size / b->c->cache->sb.block_size;
@@ -2529,8 +2529,8 @@ int __bch_btree_map_nodes(struct btree_op *op, struct cache_set *c,
 }
 
 int bch_btree_map_keys_recurse(struct btree *b, struct btree_op *op,
-				      struct bkey *from, btree_map_keys_fn *fn,
-				      int flags)
+			       struct bkey *from, btree_map_keys_fn *fn,
+			       int flags)
 {
 	int ret = MAP_CONTINUE;
 	struct bkey *k;
diff --git a/drivers/md/bcache/btree.h b/drivers/md/bcache/btree.h
index 1b5fdbc0d83e..b46bf6268aca 100644
--- a/drivers/md/bcache/btree.h
+++ b/drivers/md/bcache/btree.h
@@ -54,7 +54,7 @@
  * Btree nodes never have to be explicitly read in; bch_btree_node_get() handles
  * this.
  *
- * For writing, we have two btree_write structs embeddded in struct btree - one
+ * For writing, we have two btree_write structs embedded in struct btree - one
  * write in flight, and one being set up, and we toggle between them.
  *
  * Writing is done with a single function -  bch_btree_write() really serves two
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index e5da469a4235..c7f6d2611037 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -790,7 +790,7 @@ static void journal_write_unlocked(struct closure *cl)
 
 		atomic_long_add(sectors, &ca->meta_sectors_written);
 
-		bio_reset(bio, ca->bdev, REQ_OP_WRITE | 
+		bio_reset(bio, ca->bdev, REQ_OP_WRITE |
 			  REQ_SYNC | REQ_META | REQ_PREFLUSH | REQ_FUA);
 		bio->bi_iter.bi_sector	= PTR_OFFSET(k, i);
 		bio->bi_iter.bi_size = sectors << 9;
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index f2c5a7e06fa9..ceba536e0880 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -338,7 +338,6 @@ unsigned int bch_get_congested(const struct cache_set *c)
 		return 0;
 
 	i += CONGESTED_MAX;
-
 	if (i > 0)
 		i = fract_exp_two(i, 6);
 
@@ -1326,8 +1325,8 @@ static int flash_dev_ioctl(struct bcache_device *d, fmode_t mode,
 
 void bch_flash_dev_request_init(struct bcache_device *d)
 {
-	d->cache_miss				= flash_dev_cache_miss;
-	d->ioctl				= flash_dev_ioctl;
+	d->cache_miss	= flash_dev_cache_miss;
+	d->ioctl	= flash_dev_ioctl;
 }
 
 void bch_request_exit(void)
diff --git a/drivers/md/bcache/stats.c b/drivers/md/bcache/stats.c
index 68b02216033d..983d16822e53 100644
--- a/drivers/md/bcache/stats.c
+++ b/drivers/md/bcache/stats.c
@@ -11,7 +11,7 @@
 #include "sysfs.h"
 
 /*
- * We keep absolute totals of various statistics, and addionally a set of three
+ * We keep absolute totals of various statistics, and addtionally a set of three
  * rolling averages.
  *
  * Every so often, a timer goes off and rescales the rolling averages.
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 3563d15dbaf2..aca27386cca2 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -686,6 +686,7 @@ int bch_prio_write(struct cache *ca, bool wait)
 
 		ca->prio_last_buckets[i] = ca->prio_buckets[i];
 	}
+
 	return 0;
 }
 
@@ -2663,7 +2664,6 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	return ret;
 }
 
-
 struct pdev {
 	struct list_head list;
 	struct cached_dev *dc;
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 3f0ff3aab6f2..bd83a33b8a2f 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -238,7 +238,7 @@ static void update_writeback_rate(struct work_struct *work)
 	/*
 	 * If the whole cache set is idle, set_at_max_writeback_rate()
 	 * will set writeback rate to a max number. Then it is
-	 * unncessary to update writeback rate for an idle cache set
+	 * unnecessary to update writeback rate for an idle cache set
 	 * in maximum writeback rate number(s).
 	 */
 	if (atomic_read(&dc->has_dirty) && dc->writeback_percent &&
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index 31df716951f6..37f66bea522f 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -69,7 +69,7 @@ static inline int offset_to_stripe(struct bcache_device *d,
 	}
 
 	/*
-	 * Here offset is definitly smaller than INT_MAX,
+	 * Here offset is definitely smaller than INT_MAX,
 	 * return it as int will never overflow.
 	 */
 	return offset;
-- 
2.25.1

