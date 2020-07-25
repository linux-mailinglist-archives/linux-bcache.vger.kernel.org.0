Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F6E22D75F
	for <lists+linux-bcache@lfdr.de>; Sat, 25 Jul 2020 14:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgGYMDm (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 25 Jul 2020 08:03:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:52674 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727086AbgGYMDl (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 25 Jul 2020 08:03:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2E05CAB55;
        Sat, 25 Jul 2020 12:03:48 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        Coly Li <colyli@suse.de>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 24/25] bcache: avoid extra memory consumption in struct bbio for large bucket size
Date:   Sat, 25 Jul 2020 20:00:38 +0800
Message-Id: <20200725120039.91071-25-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200725120039.91071-1-colyli@suse.de>
References: <20200725120039.91071-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Bcache uses struct bbio to do I/Os for meta data pages like uuids,
disk_buckets, prio_buckets, and btree nodes.

Example writing a btree node onto cache device, the process is,
- Allocate a struct bbio from mempool c->bio_meta.
- Inside struct bbio embedded a struct bio, initialize bi_inline_vecs
  for this embedded bio.
- Call bch_bio_map() to map each meta data page to each bv from the
  inlined  bi_io_vec table.
- Call bch_submit_bbio() to submit the bio into underlying block layer.
- When the I/O completed, only release the struct bbio, don't touch the
  reference counter of the meta data pages.

The struct bbio is defined as,
738 struct bbio {
739     unsigned int            submit_time_us;
	[snipped]
748     struct bio              bio;
749 };

Because struct bio is embedded at the end of struct bbio, therefore the
actual size of struct bbio is sizeof(struct bio) + size of the embedded
bio->bi_inline_vecs.

Now all the meta data bucket size are limited to meta_bucket_pages(), if
the bucket size is large than meta_bucket_pages()*PAGE_SECTORS, rested
space in the bucket is unused. Therefore the most used space in meta
bucket is (1<<MAX_ORDER) pages, or (1<<CONFIG_FORCE_MAX_ZONEORDER) if it
is configured.

Therefore for large bucket size, it is unnecessary to calculate the
allocation size of mempool c->bio_meta as,
	mempool_init_kmalloc_pool(&c->bio_meta, 2,
			sizeof(struct bbio) +
			sizeof(struct bio_vec) * bucket_pages(c))
It is too large, neither the Linux buddy allocator cannot allocate so
much continuous pages, nor the extra allocated pages are wasted.

This patch replace bucket_pages() to meta_bucket_pages() in two places,
- In bch_cache_set_alloc(), when initialize mempool c->bio_meta, uses
  sizeof(struct bbio) + sizeof(struct bio_vec) * bucket_pages(c) to set
  the allocating object size.
- In bch_bbio_alloc(), when calling bio_init() to set inline bvec talbe
  bi_inline_bvecs, uses meta_bucket_pages() to indicate number of the
  inline bio vencs number.

Now the maximum size of embedded bio inside struct bbio exactly matches
the limit of meta_bucket_pages(), no extra page wasted.

Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/bcache/io.c    | 2 +-
 drivers/md/bcache/super.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index b25ee33b0d0b..a14a445618b4 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -26,7 +26,7 @@ struct bio *bch_bbio_alloc(struct cache_set *c)
 	struct bbio *b = mempool_alloc(&c->bio_meta, GFP_NOIO);
 	struct bio *bio = &b->bio;
 
-	bio_init(bio, bio->bi_inline_vecs, bucket_pages(c));
+	bio_init(bio, bio->bi_inline_vecs, meta_bucket_pages(&c->sb));
 
 	return bio;
 }
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index d86b31722b41..5eba0b930e27 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1920,7 +1920,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 
 	if (mempool_init_kmalloc_pool(&c->bio_meta, 2,
 			sizeof(struct bbio) +
-			sizeof(struct bio_vec) * bucket_pages(c)))
+			sizeof(struct bio_vec) * meta_bucket_pages(&c->sb)))
 		goto err;
 
 	if (mempool_init_kmalloc_pool(&c->fill_iter, 1, iter_size))
-- 
2.26.2

