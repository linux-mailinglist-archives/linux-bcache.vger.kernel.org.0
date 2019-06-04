Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A948C34CA5
	for <lists+linux-bcache@lfdr.de>; Tue,  4 Jun 2019 17:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbfFDPxn (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 4 Jun 2019 11:53:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:60984 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728030AbfFDPxn (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 4 Jun 2019 11:53:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 07B3CAE8A;
        Tue,  4 Jun 2019 15:53:42 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 17/18] bcache: make bset_search_tree() be more understandable
Date:   Tue,  4 Jun 2019 23:53:29 +0800
Message-Id: <20190604155330.107927-2-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190604155330.107927-1-colyli@suse.de>
References: <20190604151624.105150-1-colyli@suse.de>
 <20190604155330.107927-1-colyli@suse.de>
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
 drivers/md/bcache/bset.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index eedaf0f3e3f0..32e2e4d8fa6c 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -965,21 +965,10 @@ static struct bset_search_iter bset_search_tree(struct bset_tree *t,
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
 		if (likely(f->exponent != 127))
-			n = j * 2 + (((unsigned int)
-				      (f->mantissa -
-				       bfloat_mantissa(search, f))) >> 31);
+			n = (f->mantissa >= bfloat_mantissa(search, f))
+				? j * 2
+				: j * 2 + 1;
 		else
 			n = (bkey_cmp(tree_to_bkey(t, j), search) > 0)
 				? j * 2
-- 
2.16.4

