Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F386687B7C
	for <lists+linux-bcache@lfdr.de>; Thu,  2 Feb 2023 12:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjBBLHB (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 2 Feb 2023 06:07:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjBBLGw (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 2 Feb 2023 06:06:52 -0500
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.214])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4980E1206E;
        Thu,  2 Feb 2023 03:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=5BWjL
        d1/jaEBccjludNTfPy3Z/B05OXtOx+r4AztbjY=; b=qdBYC9xRAg87mLEPd00qD
        9hXuyHGWQuuURF/BRRb3NHeWzBNMq2xVOGlGTjd8D4KfEFXYtq5xPoj5OT6BuCd2
        brWwhlKen3/gOhDp4qPfSursxccvyOmpm8Yyfj5L8EglB2yEJ3xCThMrDQWpIfl0
        9UMTDOmFJOn9hVs2+wO4Zk=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by zwqz-smtp-mta-g4-0 (Coremail) with SMTP id _____wDX0+8ImdtjYQxBCg--.48198S2;
        Thu, 02 Feb 2023 19:05:44 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     colyli@suse.de
Cc:     hackerzheng666@gmail.com, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        security@kernel.org, alex000young@gmail.com,
        Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH] bcache: Fix a NULL or wild pointer dereference in btree_split
Date:   Thu,  2 Feb 2023 19:05:43 +0800
Message-Id: <20230202110543.27548-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wDX0+8ImdtjYQxBCg--.48198S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF1UXF1xZw15CFWDJFW3GFg_yoW8Wr4xpF
        4xWFy3trW8Xr4jk3y5X3W0vF9Yv3WaqFWYk3s5ua48ZasxZr1fCFy0k34jvryUurs7Xa17
        tr1Fvw15XF1UtaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziaLv_UUUUU=
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/xtbBzg4KU2I0XNTkLgAAsN
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In btree_split, btree_node_alloc_replacement() is assigned to
n1 and return error code or NULL on failure. n1->c->cache is
passed to block_bytes. So there is a dereference of it
 without checks, which may lead to wild pointer dereference or
  NULL pointer dereference depending on n1. The initial code only
  judge the error code but igore the NULL pointer.
So does n2 and n3.

Fix this bug by adding IS_ERR_OR_NULL check of n1, n2 and n3.

Note that, as a bug found by static analysis, it can be a false
positive or hard to trigger.

Fixes: cafe56359144 ("bcache: A block layer cache")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
---
 drivers/md/bcache/btree.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 147c493a989a..d5ed382fc43c 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -2206,7 +2206,7 @@ static int btree_split(struct btree *b, struct btree_op *op,
 	}
 
 	n1 = btree_node_alloc_replacement(b, op);
-	if (IS_ERR(n1))
+	if (IS_ERR_OR_NULL(n1))
 		goto err;
 
 	split = set_blocks(btree_bset_first(n1),
@@ -2218,12 +2218,12 @@ static int btree_split(struct btree *b, struct btree_op *op,
 		trace_bcache_btree_node_split(b, btree_bset_first(n1)->keys);
 
 		n2 = bch_btree_node_alloc(b->c, op, b->level, b->parent);
-		if (IS_ERR(n2))
+		if (IS_ERR_OR_NULL(n2))
 			goto err_free1;
 
 		if (!b->parent) {
 			n3 = bch_btree_node_alloc(b->c, op, b->level + 1, NULL);
-			if (IS_ERR(n3))
+			if (IS_ERR_OR_NULL(n3))
 				goto err_free2;
 		}
 
-- 
2.25.1

