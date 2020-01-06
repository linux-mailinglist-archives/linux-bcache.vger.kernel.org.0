Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A24A51315A2
	for <lists+linux-bcache@lfdr.de>; Mon,  6 Jan 2020 17:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgAFQFY (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 6 Jan 2020 11:05:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:42694 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbgAFQFY (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 6 Jan 2020 11:05:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B26C8AD6F
        for <linux-bcache@vger.kernel.org>; Mon,  6 Jan 2020 16:05:22 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>
Subject: [RFC PATCH 7/7] bcache: add cond_resched() in bch_btree_node_get() if mca_alloc() fails
Date:   Tue,  7 Jan 2020 00:04:56 +0800
Message-Id: <20200106160456.45689-8-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200106160456.45689-1-colyli@suse.de>
References: <20200106160456.45689-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In bch_btree_node_get(), if mca_alloc() fails and returns NULL pointer,
it means no memory to allocate and the code will go to retry label to
call mca_alloc() again.

When few system memory to allocate, it takes time for in-memory btree
node cache shrink kthread to shrink the nodes, and same to the slab
memory shrinker callback routines. Therefore directly go to retry label
may just wast CPU cycles because the memory is still not available yet,
and the code has to jump to retry label again.

This patch adds cond_resched() before jumps to retry label, then there
will be much less re-jump to retry label when memory allocation fails.
it may relax the CPU cycles and give more time for shrink kthread and
other slab memory shrink callback routines.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/btree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 48a097037da8..bd42b0b1af27 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1081,8 +1081,10 @@ struct btree *bch_btree_node_get(struct cache_set *c, struct btree_op *op,
 		b = mca_alloc(c, op, k, level);
 		mutex_unlock(&c->bucket_lock);
 
-		if (!b)
+		if (!b) {
+			cond_resched();
 			goto retry;
+		}
 		if (IS_ERR(b))
 			return b;
 
-- 
2.16.4

