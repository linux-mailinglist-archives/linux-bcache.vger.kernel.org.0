Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7325D214DC3
	for <lists+linux-bcache@lfdr.de>; Sun,  5 Jul 2020 17:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgGEP4T (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 5 Jul 2020 11:56:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:38058 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727790AbgGEP4T (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 5 Jul 2020 11:56:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 49159AC37;
        Sun,  5 Jul 2020 15:56:18 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [RFC PATCH 04/16] bcache: disassemble the big if() checks in bch_cache_set_alloc()
Date:   Sun,  5 Jul 2020 23:55:49 +0800
Message-Id: <20200705155601.5404-5-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200705155601.5404-1-colyli@suse.de>
References: <20200705155601.5404-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In bch_cache_set_alloc() there is a big if() checks combined by 11 items
together. When this big if() statement fails, it is difficult to tell
exactly which item fails indeed.

This patch disassembles this big if() checks into 11 single if() checks,
which makes code debug more easier.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 52 ++++++++++++++++++++++++++++-----------
 1 file changed, 37 insertions(+), 15 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index d6082b68aa26..20cfd221c103 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1865,21 +1865,43 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 	iter_size = (sb->bucket_size / sb->block_size + 1) *
 		sizeof(struct btree_iter_set);
 
-	if (!(c->devices = kcalloc(c->nr_uuids, sizeof(void *), GFP_KERNEL)) ||
-	    mempool_init_slab_pool(&c->search, 32, bch_search_cache) ||
-	    mempool_init_kmalloc_pool(&c->bio_meta, 2,
-				sizeof(struct bbio) + sizeof(struct bio_vec) *
-				bucket_pages(c)) ||
-	    mempool_init_kmalloc_pool(&c->fill_iter, 1, iter_size) ||
-	    bioset_init(&c->bio_split, 4, offsetof(struct bbio, bio),
-			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER) ||
-	    !(c->uuids = alloc_bucket_pages(GFP_KERNEL, c)) ||
-	    !(c->moving_gc_wq = alloc_workqueue("bcache_gc",
-						WQ_MEM_RECLAIM, 0)) ||
-	    bch_journal_alloc(c) ||
-	    bch_btree_cache_alloc(c) ||
-	    bch_open_buckets_alloc(c) ||
-	    bch_bset_sort_state_init(&c->sort, ilog2(c->btree_pages)))
+	c->devices = kcalloc(c->nr_uuids, sizeof(void *), GFP_KERNEL);
+	if (!c->devices)
+		goto err;
+
+	if (mempool_init_slab_pool(&c->search, 32, bch_search_cache))
+		goto err;
+
+	if (mempool_init_kmalloc_pool(&c->bio_meta, 2,
+			sizeof(struct bbio) +
+			sizeof(struct bio_vec) * bucket_pages(c)))
+		goto err;
+
+	if (mempool_init_kmalloc_pool(&c->fill_iter, 1, iter_size))
+		goto err;
+
+	if (bioset_init(&c->bio_split, 4, offsetof(struct bbio, bio),
+			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
+		goto err;
+
+	c->uuids = alloc_bucket_pages(GFP_KERNEL, c);
+	if (!c->uuids)
+		goto err;
+
+	c->moving_gc_wq = alloc_workqueue("bcache_gc", WQ_MEM_RECLAIM, 0);
+	if (!c->moving_gc_wq)
+		goto err;
+
+	if (bch_journal_alloc(c))
+		goto err;
+
+	if (bch_btree_cache_alloc(c))
+		goto err;
+
+	if (bch_open_buckets_alloc(c))
+		goto err;
+
+	if (bch_bset_sort_state_init(&c->sort, ilog2(c->btree_pages)))
 		goto err;
 
 	c->congested_read_threshold_us	= 2000;
-- 
2.26.2

