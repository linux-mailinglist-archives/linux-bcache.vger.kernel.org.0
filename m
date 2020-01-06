Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECF11315A1
	for <lists+linux-bcache@lfdr.de>; Mon,  6 Jan 2020 17:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgAFQFW (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 6 Jan 2020 11:05:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:42686 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbgAFQFW (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 6 Jan 2020 11:05:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 76006B02C
        for <linux-bcache@vger.kernel.org>; Mon,  6 Jan 2020 16:05:20 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>
Subject: [RFC PATCH 6/7] bcache: remove unnecessary mca_cannibalize()
Date:   Tue,  7 Jan 2020 00:04:55 +0800
Message-Id: <20200106160456.45689-7-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200106160456.45689-1-colyli@suse.de>
References: <20200106160456.45689-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

mca_cannibalize() is used to cannibalize a btree node cache in
mca_alloc() when,
- There is no available node from c->btree_cache_freeable list.
- There is no available node from c->btree_cache_freed list.
- mca_bucket_alloc() fails to allocate new in-memory node neither.
Then mca_cannibalize() will try to shrink one node from c->btree_cache
list and allocate it to new btree node in such cannibalized way.

Now with patch "bcache: limit bcache btree node cache memory consumption
by I/O throttle", the in-memory btree nodes can be shrunk from list
c->btree_cache proactively already, in most of time there will be enough
memory to allocate. So kzalloc() in mca_bucket_alloc() will always
success, and such cannibalized allocation is almost useless. Considering
the extra complication in mca_cannibalize_lock(), it is time to remove
the unnecessary mca_cannibalize() from bcache code.

NOTE: mca_cannibalize_lock() and mca_cannibalize_unlock() are still kept
in bcache code, they are referenced by other btree related code yet.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/btree.c | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index ada17113482f..48a097037da8 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -962,28 +962,6 @@ static int mca_cannibalize_lock(struct cache_set *c, struct btree_op *op)
 	return 0;
 }
 
-static struct btree *mca_cannibalize(struct cache_set *c, struct btree_op *op,
-				     struct bkey *k)
-{
-	struct btree *b;
-
-	trace_bcache_btree_cache_cannibalize(c);
-
-	if (mca_cannibalize_lock(c, op))
-		return ERR_PTR(-EINTR);
-
-	list_for_each_entry_reverse(b, &c->btree_cache, list)
-		if (!mca_reap(b, btree_order(k), false))
-			return b;
-
-	list_for_each_entry_reverse(b, &c->btree_cache, list)
-		if (!mca_reap(b, btree_order(k), true))
-			return b;
-
-	WARN(1, "btree cache cannibalize failed\n");
-	return ERR_PTR(-ENOMEM);
-}
-
 /*
  * We can only have one thread cannibalizing other cached btree nodes at a time,
  * or we'll deadlock. We use an open coded mutex to ensure that, which a
@@ -1072,10 +1050,6 @@ static struct btree *mca_alloc(struct cache_set *c, struct btree_op *op,
 	if (b)
 		rw_unlock(true, b);
 
-	b = mca_cannibalize(c, op, k);
-	if (!IS_ERR(b))
-		goto out;
-
 	return b;
 }
 
-- 
2.16.4

