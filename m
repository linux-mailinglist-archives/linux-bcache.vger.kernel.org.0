Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E89C83132
	for <lists+linux-bcache@lfdr.de>; Tue,  6 Aug 2019 14:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfHFMNm (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 6 Aug 2019 08:13:42 -0400
Received: from smtpbg502.qq.com ([203.205.250.69]:34798 "EHLO smtpbg.qq.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726036AbfHFMNm (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 6 Aug 2019 08:13:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1565093614;
        bh=3V6rWXxmM/OlePAeX/UDZyePsIrXuVDvXORYA5Me/Zs=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=VS0e22flOQO3E5c/eJ4J4nsAmkkJ+dsNEOYB5ZZjKFlgRdMM4b/LCxjsDn4QnCA77
         L/op/hLT/sYx8BZzDXLSqmjq8ZBht0/I/C5JAFkdzBMquCWefDHsDTE14PpkRv8r25
         rrtWreZQHBIOSZ+UF6mpImh6DlIil+LrkgJFqFo4=
X-QQ-mid: esmtp5t1565093612t3rx9q351
Received: from localhost.localdomain (unknown [114.243.223.16])
        by esmtp4.qq.com (ESMTP) with 
        id ; Tue, 06 Aug 2019 20:13:28 +0800 (CST)
X-QQ-SSF: 01010000000000D0ZH4000000000000
X-QQ-FEAT: PQzrsoBMnqpYBe3pTwv2pn1LdPkBoA9fCGiegPIkDrlf8w6mHDYZMT2oaAx1B
        BVpRDZQrlmLaQr84ExyysRgkc/8f10+bQYOTpCIcCbNV3a7VKpQv+GOCIx/f7CVc8u5S0Fj
        hVPebdksmKsvk87VltxsE9m4+ochie+wMYBhkGR8gHdgmQzN+Z6XNjC8h2ttHMqPzAKWCDA
        C2vNuvYXGVMaC2XS4ScSL5KVokqlnaPYpN+z/Sm85w8YHiO77NIRwVwfxDffRamJ12/mIbW
        NpPKZqJHG/qSU2A8+ezaZCBUY=
X-QQ-GoodBg: 0
From:   Shenghui Wang <shhuiw@foxmail.com>
To:     colyli@suse.de, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org
Subject: [PATCH] bcache: move verify logic from bch_btree_node_write to bch_btree_init_next
Date:   Tue,  6 Aug 2019 20:13:28 +0800
Message-Id: <20190806121328.1963-1-shhuiw@foxmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtp:foxmail.com:bgweb:bgweb1
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

commit 2a285686c1098 ("bcache: btree locking rework") introduced
bch_btree_init_next(), and moved the sort logic into the function.
Before the commit introduced, __bch_btree_node_write() will do sort
first, then do possible verify. After the change, the verify will
run before any sort/change sets of btree node, and no verify will
run after sort done in bch_btree_init_next().

Move the verify code into bch_btree_init_next(), right after sort done.

Signed-off-by: Shenghui Wang <shhuiw@foxmail.com>
---
 drivers/md/bcache/btree.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index ba434d9ac720..b15878334a29 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -167,16 +167,24 @@ static inline struct bset *write_block(struct btree *b)
 
 static void bch_btree_init_next(struct btree *b)
 {
+	unsigned int nsets = b->keys.nsets;
+
 	/* If not a leaf node, always sort */
 	if (b->level && b->keys.nsets)
 		bch_btree_sort(&b->keys, &b->c->sort);
 	else
 		bch_btree_sort_lazy(&b->keys, &b->c->sort);
 
+	/*
+	 * do verify if there was more than one set initially (i.e. we did a
+	 * sort) and we sorted down to a single set:
+	 */
+	if (nsets && !b->keys.nsets)
+		bch_btree_verify(b);
+
 	if (b->written < btree_blocks(b))
 		bch_bset_init_next(&b->keys, write_block(b),
 				   bset_magic(&b->c->sb));
-
 }
 
 /* Btree key manipulation */
@@ -489,19 +497,9 @@ void __bch_btree_node_write(struct btree *b, struct closure *parent)
 
 void bch_btree_node_write(struct btree *b, struct closure *parent)
 {
-	unsigned int nsets = b->keys.nsets;
-
 	lockdep_assert_held(&b->lock);
 
 	__bch_btree_node_write(b, parent);
-
-	/*
-	 * do verify if there was more than one set initially (i.e. we did a
-	 * sort) and we sorted down to a single set:
-	 */
-	if (nsets && !b->keys.nsets)
-		bch_btree_verify(b);
-
 	bch_btree_init_next(b);
 }
 
-- 
2.22.0

