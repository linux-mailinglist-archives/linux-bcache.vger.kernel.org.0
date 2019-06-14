Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C365545DB7
	for <lists+linux-bcache@lfdr.de>; Fri, 14 Jun 2019 15:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbfFNNOo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 14 Jun 2019 09:14:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:45714 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727766AbfFNNOo (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 14 Jun 2019 09:14:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0CB1CAB8C;
        Fri, 14 Jun 2019 13:14:43 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 10/29] bcache: avoid flushing btree node in cache_set_flush() if io disabled
Date:   Fri, 14 Jun 2019 21:13:39 +0800
Message-Id: <20190614131358.2771-11-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190614131358.2771-1-colyli@suse.de>
References: <20190614131358.2771-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

When cache_set_flush() is called for too many I/O errors detected on
cache device and the cache set is retiring, inside the function it
doesn't make sense to flushing cached btree nodes from c->btree_cache
because CACHE_SET_IO_DISABLE is set on c->flags already and all I/Os
onto cache device will be rejected.

This patch checks in cache_set_flush() that whether CACHE_SET_IO_DISABLE
is set. If yes, then avoids to flush the cached btree nodes to reduce
more time and make cache set retiring more faster.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index eaaa046fd95d..da9d6a63b81a 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1553,13 +1553,17 @@ static void cache_set_flush(struct closure *cl)
 	if (!IS_ERR_OR_NULL(c->root))
 		list_add(&c->root->list, &c->btree_cache);
 
-	/* Should skip this if we're unregistering because of an error */
-	list_for_each_entry(b, &c->btree_cache, list) {
-		mutex_lock(&b->write_lock);
-		if (btree_node_dirty(b))
-			__bch_btree_node_write(b, NULL);
-		mutex_unlock(&b->write_lock);
-	}
+	/*
+	 * Avoid flushing cached nodes if cache set is retiring
+	 * due to too many I/O errors detected.
+	 */
+	if (!test_bit(CACHE_SET_IO_DISABLE, &c->flags))
+		list_for_each_entry(b, &c->btree_cache, list) {
+			mutex_lock(&b->write_lock);
+			if (btree_node_dirty(b))
+				__bch_btree_node_write(b, NULL);
+			mutex_unlock(&b->write_lock);
+		}
 
 	for_each_cache(ca, c, i)
 		if (ca->alloc_thread)
-- 
2.16.4

