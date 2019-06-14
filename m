Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B63945DD7
	for <lists+linux-bcache@lfdr.de>; Fri, 14 Jun 2019 15:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbfFNNPb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 14 Jun 2019 09:15:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:46242 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727918AbfFNNPa (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 14 Jun 2019 09:15:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B0F28AF7B;
        Fri, 14 Jun 2019 13:15:29 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 24/29] bcache: make bset_search_tree() be more understandable
Date:   Fri, 14 Jun 2019 21:13:53 +0800
Message-Id: <20190614131358.2771-25-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190614131358.2771-1-colyli@suse.de>
References: <20190614131358.2771-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The purpose of following code in bset_search_tree() is to avoid a branch
instruction,
 994         if (likely(f->exponent != 127))
 995                 n = j * 2 + (((unsigned int)
 996                               (f->mantissa -
 997                                bfloat_mantissa(search, f))) >> 31);
 998         else
 999                 n = (bkey_cmp(tree_to_bkey(t, j), search) > 0)
1000                         ? j * 2
1001                         : j * 2 + 1;

This piece of code is not very clear to understand, even when I tried to
add code comment for it, I made mistake. This patch removes the implict
bit operation and uses explicit branch to calculate next location in
binary tree search.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/bset.c | 30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index eedaf0f3e3f0..2722e7f83de3 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -965,25 +965,17 @@ static struct bset_search_iter bset_search_tree(struct bset_tree *t,
 		j = n;
 		f = &t->tree[j];
 
-		/*
-		 * Similar bit trick, use subtract operation to avoid a branch
-		 * instruction.
-		 *
-		 * n = (f->mantissa > bfloat_mantissa())
-		 *	? j * 2
-		 *	: j * 2 + 1;
-		 *
-		 * We need to subtract 1 from f->mantissa for the sign bit trick
-		 * to work  - that's done in make_bfloat()
-		 */
-		if (likely(f->exponent != 127))
-			n = j * 2 + (((unsigned int)
-				      (f->mantissa -
-				       bfloat_mantissa(search, f))) >> 31);
-		else
-			n = (bkey_cmp(tree_to_bkey(t, j), search) > 0)
-				? j * 2
-				: j * 2 + 1;
+		if (likely(f->exponent != 127)) {
+			if (f->mantissa >= bfloat_mantissa(search, f))
+				n = j * 2;
+			else
+				n = j * 2 + 1;
+		} else {
+			if (bkey_cmp(tree_to_bkey(t, j), search) > 0)
+				n = j * 2;
+			else
+				n = j * 2 + 1;
+		}
 	} while (n < t->size);
 
 	inorder = to_inorder(j, t);
-- 
2.16.4

