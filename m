Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5255845DC9
	for <lists+linux-bcache@lfdr.de>; Fri, 14 Jun 2019 15:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbfFNNPI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 14 Jun 2019 09:15:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:46004 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728121AbfFNNPI (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 14 Jun 2019 09:15:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 86ED6AF7B;
        Fri, 14 Jun 2019 13:15:07 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 17/29] bcache: remove unncessary code in bch_btree_keys_init()
Date:   Fri, 14 Jun 2019 21:13:46 +0800
Message-Id: <20190614131358.2771-18-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190614131358.2771-1-colyli@suse.de>
References: <20190614131358.2771-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Function bch_btree_keys_init() initializes b->set[].size and
b->set[].data to zero. As the code comments indicates, these code indeed
is unncessary, because both struct btree_keys and struct bset_tree are
nested embedded into struct btree, when struct btree is filled with 0
bits by kzalloc() in mca_bucket_alloc(), b->set[].size and
b->set[].data are initialized to 0 (a.k.a NULL) already.

This patch removes the redundant code, and add comments in
bch_btree_keys_init() and mca_bucket_alloc() to explain why it's safe.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/bset.c  | 15 ++++++---------
 drivers/md/bcache/btree.c |  4 ++++
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index aa2e4ab0fab9..eedaf0f3e3f0 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -347,22 +347,19 @@ EXPORT_SYMBOL(bch_btree_keys_alloc);
 void bch_btree_keys_init(struct btree_keys *b, const struct btree_keys_ops *ops,
 			 bool *expensive_debug_checks)
 {
-	unsigned int i;
-
 	b->ops = ops;
 	b->expensive_debug_checks = expensive_debug_checks;
 	b->nsets = 0;
 	b->last_set_unwritten = 0;
 
-	/* XXX: shouldn't be needed */
-	for (i = 0; i < MAX_BSETS; i++)
-		b->set[i].size = 0;
 	/*
-	 * Second loop starts at 1 because b->keys[0]->data is the memory we
-	 * allocated
+	 * struct btree_keys in embedded in struct btree, and struct
+	 * bset_tree is embedded into struct btree_keys. They are all
+	 * initialized as 0 by kzalloc() in mca_bucket_alloc(), and
+	 * b->set[0].data is allocated in bch_btree_keys_alloc(), so we
+	 * don't have to initiate b->set[].size and b->set[].data here
+	 * any more.
 	 */
-	for (i = 1; i < MAX_BSETS; i++)
-		b->set[i].data = NULL;
 }
 EXPORT_SYMBOL(bch_btree_keys_init);
 
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 881dc238c7cb..c0dd8fde37af 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -613,6 +613,10 @@ static void mca_data_alloc(struct btree *b, struct bkey *k, gfp_t gfp)
 static struct btree *mca_bucket_alloc(struct cache_set *c,
 				      struct bkey *k, gfp_t gfp)
 {
+	/*
+	 * kzalloc() is necessary here for initialization,
+	 * see code comments in bch_btree_keys_init().
+	 */
 	struct btree *b = kzalloc(sizeof(struct btree), gfp);
 
 	if (!b)
-- 
2.16.4

