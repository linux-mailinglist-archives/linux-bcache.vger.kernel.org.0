Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3FD3599C0
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Jun 2019 14:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfF1MBC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 28 Jun 2019 08:01:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:54388 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726524AbfF1MBA (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 28 Jun 2019 08:01:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3A2A5B62B;
        Fri, 28 Jun 2019 12:00:59 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 12/37] bcache: check CACHE_SET_IO_DISABLE in allocator code
Date:   Fri, 28 Jun 2019 19:59:35 +0800
Message-Id: <20190628120000.40753-13-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190628120000.40753-1-colyli@suse.de>
References: <20190628120000.40753-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

If CACHE_SET_IO_DISABLE of a cache set flag is set by too many I/O
errors, currently allocator routines can still continue allocate
space which may introduce inconsistent metadata state.

This patch checkes CACHE_SET_IO_DISABLE bit in following allocator
routines,
- bch_bucket_alloc()
- __bch_bucket_alloc_set()
Once CACHE_SET_IO_DISABLE is set on cache set, the allocator routines
may reject allocation request earlier to avoid potential inconsistent
metadata.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/alloc.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index f8986effcb50..6f776823b9ba 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -393,6 +393,11 @@ long bch_bucket_alloc(struct cache *ca, unsigned int reserve, bool wait)
 	struct bucket *b;
 	long r;
 
+
+	/* No allocation if CACHE_SET_IO_DISABLE bit is set */
+	if (unlikely(test_bit(CACHE_SET_IO_DISABLE, &ca->set->flags)))
+		return -1;
+
 	/* fastpath */
 	if (fifo_pop(&ca->free[RESERVE_NONE], r) ||
 	    fifo_pop(&ca->free[reserve], r))
@@ -484,6 +489,10 @@ int __bch_bucket_alloc_set(struct cache_set *c, unsigned int reserve,
 {
 	int i;
 
+	/* No allocation if CACHE_SET_IO_DISABLE bit is set */
+	if (unlikely(test_bit(CACHE_SET_IO_DISABLE, &c->flags)))
+		return -1;
+
 	lockdep_assert_held(&c->bucket_lock);
 	BUG_ON(!n || n > c->caches_loaded || n > MAX_CACHES_PER_SET);
 
-- 
2.16.4

