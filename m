Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD0522D75D
	for <lists+linux-bcache@lfdr.de>; Sat, 25 Jul 2020 14:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgGYMDi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 25 Jul 2020 08:03:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:52650 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727086AbgGYMDh (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 25 Jul 2020 08:03:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 88B2AAB55;
        Sat, 25 Jul 2020 12:03:45 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        Coly Li <colyli@suse.de>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 23/25] bcache: avoid extra memory allocation from mempool c->fill_iter
Date:   Sat, 25 Jul 2020 20:00:37 +0800
Message-Id: <20200725120039.91071-24-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200725120039.91071-1-colyli@suse.de>
References: <20200725120039.91071-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Mempool c->fill_iter is used to allocate memory for struct btree_iter in
bch_btree_node_read_done() to iterate all keys of a read-in btree node.

The allocation size is defined in bch_cache_set_alloc() by,
  mempool_init_kmalloc_pool(&c->fill_iter, 1, iter_size))
where iter_size is defined by a calculation,
  (sb->bucket_size / sb->block_size + 1) * sizeof(struct btree_iter_set)

For 16bit width bucket_size the calculation is OK, but now the bucket
size is extended to 32bit, the bucket size can be 2GB. By the above
calculation, iter_size can be 2048 pages (order 11 is still accepted by
buddy allocator).

But the actual size holds the bkeys in meta data bucket is limited to
meta_bucket_pages() already, which is 16MB. By the above calculation,
if replace sb->bucket_size by meta_bucket_pages() * PAGE_SECTORS, the
result is 16 pages. This is the size large enough for the mempool
allocation to struct btree_iter.

Therefore in worst case every time mempool c->fill_iter allocates, at
most 4080 pages are wasted and won't be used. Therefore this patch uses
meta_bucket_pages() * PAGE_SECTORS to calculate the iter size in
bch_cache_set_alloc(), to avoid extra memory allocation from mempool
c->fill_iter.

Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/bcache/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index b7ef11da026c..d86b31722b41 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1908,7 +1908,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 	INIT_LIST_HEAD(&c->btree_cache_freed);
 	INIT_LIST_HEAD(&c->data_buckets);
 
-	iter_size = (sb->bucket_size / sb->block_size + 1) *
+	iter_size = ((meta_bucket_pages(sb) * PAGE_SECTORS) / sb->block_size + 1) *
 		sizeof(struct btree_iter_set);
 
 	c->devices = kcalloc(c->nr_uuids, sizeof(void *), GFP_KERNEL);
-- 
2.26.2

