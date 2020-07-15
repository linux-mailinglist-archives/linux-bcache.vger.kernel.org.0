Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B1622049A
	for <lists+linux-bcache@lfdr.de>; Wed, 15 Jul 2020 07:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgGOFq6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 15 Jul 2020 01:46:58 -0400
Received: from [195.135.220.15] ([195.135.220.15]:38762 "EHLO mx2.suse.de"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1728260AbgGOFq6 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 15 Jul 2020 01:46:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8C467AB7D;
        Wed, 15 Jul 2020 05:46:59 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH v2 17/17] bcache: avoid extra memory consumption in struct bbio for large bucket size
Date:   Wed, 15 Jul 2020 13:46:12 +0800
Message-Id: <20200715054612.6349-18-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715054612.6349-1-colyli@suse.de>
References: <20200715054612.6349-1-colyli@suse.de>
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
index 3d05f7f46b01..aba535ecc335 100644
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

