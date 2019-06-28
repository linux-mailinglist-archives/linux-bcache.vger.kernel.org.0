Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A48F6599EF
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Jun 2019 14:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbfF1MCY (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 28 Jun 2019 08:02:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:55192 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726807AbfF1MCY (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 28 Jun 2019 08:02:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0C863B62C;
        Fri, 28 Jun 2019 12:02:23 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 33/37] bcache: add comments for mutex_lock(&b->write_lock)
Date:   Fri, 28 Jun 2019 19:59:56 +0800
Message-Id: <20190628120000.40753-34-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190628120000.40753-1-colyli@suse.de>
References: <20190628120000.40753-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

When accessing or modifying BTREE_NODE_dirty bit, it is not always
necessary to acquire b->write_lock. In bch_btree_cache_free() and
mca_reap() acquiring b->write_lock is necessary, and this patch adds
comments to explain why mutex_lock(&b->write_lock) is necessary for
checking or clearing BTREE_NODE_dirty bit there.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/btree.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 88e5aa3fbb07..846306c3a887 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -659,6 +659,11 @@ static int mca_reap(struct btree *b, unsigned int min_order, bool flush)
 		up(&b->io_mutex);
 	}
 
+	/*
+	 * BTREE_NODE_dirty might be cleared in btree_flush_btree() by
+	 * __bch_btree_node_write(). To avoid an extra flush, acquire
+	 * b->write_lock before checking BTREE_NODE_dirty bit.
+	 */
 	mutex_lock(&b->write_lock);
 	if (btree_node_dirty(b))
 		__bch_btree_node_write(b, &cl);
@@ -782,6 +787,11 @@ void bch_btree_cache_free(struct cache_set *c)
 	while (!list_empty(&c->btree_cache)) {
 		b = list_first_entry(&c->btree_cache, struct btree, list);
 
+		/*
+		 * This function is called by cache_set_free(), no I/O
+		 * request on cache now, it is unnecessary to acquire
+		 * b->write_lock before clearing BTREE_NODE_dirty anymore.
+		 */
 		if (btree_node_dirty(b)) {
 			btree_complete_write(b, btree_current_write(b));
 			clear_bit(BTREE_NODE_dirty, &b->flags);
-- 
2.16.4

