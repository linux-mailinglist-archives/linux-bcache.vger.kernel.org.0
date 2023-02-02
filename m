Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89BB768816B
	for <lists+linux-bcache@lfdr.de>; Thu,  2 Feb 2023 16:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjBBPP2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 2 Feb 2023 10:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbjBBPP0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 2 Feb 2023 10:15:26 -0500
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.214])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D111C3D098;
        Thu,  2 Feb 2023 07:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=wSfRI
        j362vJ0u/qgNuMrq21yZt2+hGp46cOVRkgR3GM=; b=M5iWNZym1pAhAlsXW/vIm
        VRhr+DpzCptnvi9DYlCfh81Ko+GUpd1nyj9rUZ7Fpi3tfkjxOXq72vQUo2w++wA9
        /0mX0N3qsLQuTLhaRokiq89IltvvDZUmEqyBijZvLJGy1Gu535ineFHrZ7n9u8OL
        piRKF4WsyBJ/6BIPjSWAJ4=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by zwqz-smtp-mta-g0-0 (Coremail) with SMTP id _____wDHxV1509tjVlJaCg--.49388S2;
        Thu, 02 Feb 2023 23:15:06 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     colyli@suse.de
Cc:     hackerzheng666@gmail.com, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex000young@gmail.com, Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH] bcache: Fix __bch_btree_node_alloc to make the failure behavior consistent
Date:   Thu,  2 Feb 2023 23:15:04 +0800
Message-Id: <20230202151504.542958-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wDHxV1509tjVlJaCg--.49388S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxArykKw15Ar4fWr13WryfJFb_yoW5Gr45pF
        W29ryYyr93Xw4UCF95G3WqvF9Yvw1jvFWUKas3u3WSvr9rAr1fCFWj9ry8ZryUCrWxWF4a
        vr48tw1UXr1jkF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziJUU8UUUUU=
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/1tbiGh0KU1aEEJG6+AAAsP
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In some specific situation, the return value of __bch_btree_node_alloc may
be NULL. This may lead to poential NULL pointer dereference in caller
 function like a calling chaion :
 btree_split->bch_btree_node_alloc->__bch_btree_node_alloc.

Fix it by initialize return value in __bch_btree_node_alloc before return.

Fixes: cafe56359144 ("bcache: A block layer cache")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
---
 drivers/md/bcache/btree.c | 10 ++++++----
 drivers/md/bcache/super.c |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 147c493a989a..35346c1d7c3c 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1090,10 +1090,12 @@ struct btree *__bch_btree_node_alloc(struct cache_set *c, struct btree_op *op,
 				     struct btree *parent)
 {
 	BKEY_PADDED(key) k;
-	struct btree *b = ERR_PTR(-EAGAIN);
+	struct btree *b;
 
 	mutex_lock(&c->bucket_lock);
 retry:
+	/* return ERR_PTR(-EAGAIN) when it fails */
+	b = ERR_PTR(-EAGAIN);
 	if (__bch_bucket_alloc_set(c, RESERVE_BTREE, &k.key, wait))
 		goto err;
 
@@ -1138,7 +1140,7 @@ static struct btree *btree_node_alloc_replacement(struct btree *b,
 {
 	struct btree *n = bch_btree_node_alloc(b->c, op, b->level, b->parent);
 
-	if (!IS_ERR_OR_NULL(n)) {
+	if (!IS_ERR(n)) {
 		mutex_lock(&n->write_lock);
 		bch_btree_sort_into(&b->keys, &n->keys, &b->c->sort);
 		bkey_copy_key(&n->key, &b->key);
@@ -1352,7 +1354,7 @@ static int btree_gc_coalesce(struct btree *b, struct btree_op *op,
 
 	for (i = 0; i < nodes; i++) {
 		new_nodes[i] = btree_node_alloc_replacement(r[i].b, NULL);
-		if (IS_ERR_OR_NULL(new_nodes[i]))
+		if (IS_ERR(new_nodes[i]))
 			goto out_nocoalesce;
 	}
 
@@ -1669,7 +1671,7 @@ static int bch_btree_gc_root(struct btree *b, struct btree_op *op,
 	if (should_rewrite) {
 		n = btree_node_alloc_replacement(b, NULL);
 
-		if (!IS_ERR_OR_NULL(n)) {
+		if (!IS_ERR(n)) {
 			bch_btree_node_write_sync(n);
 
 			bch_btree_set_root(n);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index ba3909bb6bea..92de714fe75e 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2088,7 +2088,7 @@ static int run_cache_set(struct cache_set *c)
 
 		err = "cannot allocate new btree root";
 		c->root = __bch_btree_node_alloc(c, NULL, 0, true, NULL);
-		if (IS_ERR_OR_NULL(c->root))
+		if (IS_ERR(c->root))
 			goto err;
 
 		mutex_lock(&c->root->write_lock);
-- 
2.25.1

