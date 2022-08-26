Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73AE35A256F
	for <lists+linux-bcache@lfdr.de>; Fri, 26 Aug 2022 12:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343595AbiHZKHX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 26 Aug 2022 06:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245405AbiHZKGt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 26 Aug 2022 06:06:49 -0400
X-Greylist: delayed 235 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 26 Aug 2022 03:05:27 PDT
Received: from mxout.security-mail.net (mxout.security-mail.net [85.31.212.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D52DAA08
        for <linux-bcache@vger.kernel.org>; Fri, 26 Aug 2022 03:05:27 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by fx303.security-mail.net (Postfix) with ESMTP id 447A23237FF
        for <linux-bcache@vger.kernel.org>; Fri, 26 Aug 2022 12:01:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kalray.eu;
        s=sec-sig-email; t=1661508091;
        bh=uqvZnxQBV/rcNEj03e7Bo6OwdF47XDjBXAdquMG3k+I=;
        h=From:To:Cc:Subject:Date;
        b=iw8sJ7Tt23KHAA4RE4PHgUBB7FPytVAsxa6KtPrIJsMrXzaGaAIePMkXCe4pwk10/
         x4IeLf7YJedfe6Z/vENpuc8WeZ2kLVdEci2ExO1wzgOW5Pghfw+3GYCjRMa1MxEeJ6
         uK9q7qsnI0+24ojXcASQ6Ie/H6vA6oX0EkCy/ENU=
Received: from fx303 (localhost [127.0.0.1])
        by fx303.security-mail.net (Postfix) with ESMTP id 848E93237E2;
        Fri, 26 Aug 2022 12:01:30 +0200 (CEST)
X-Virus-Scanned: E-securemail
Secumail-id: <1362c.630899f9.e66f9.0>
Received: from zimbra2.kalray.eu (unknown [217.181.231.53])
        by fx303.security-mail.net (Postfix) with ESMTPS id E894D323819;
        Fri, 26 Aug 2022 12:01:29 +0200 (CEST)
Received: from zimbra2.kalray.eu (localhost [127.0.0.1])
        by zimbra2.kalray.eu (Postfix) with ESMTPS id CBBDD27E02FA;
        Fri, 26 Aug 2022 12:01:29 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by zimbra2.kalray.eu (Postfix) with ESMTP id B559327E0392;
        Fri, 26 Aug 2022 12:01:29 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra2.kalray.eu B559327E0392
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalray.eu;
        s=32AE1B44-9502-11E5-BA35-3734643DEF29; t=1661508089;
        bh=4HEYLEVgKpymk4SBrx8DGY44NHvVKzCZiJtvzBXd/6k=;
        h=From:To:Date:Message-Id;
        b=mmG6vCL1wrlNy9YazrAR5V2Q9A3z0cC0x6Zt1w5F8npTM8NEmZQJRelUyF9OOA9gg
         ibnwlBEt5rkjtueW5ImispqmR3+cM++mf3p+ebjagkVbD3iEFwgNN7WfX5CdFYbKPK
         cRXrqFKHScskxav+oqdfQBKTIGlRQeatwbruwH8c=
Received: from zimbra2.kalray.eu ([127.0.0.1])
        by localhost (zimbra2.kalray.eu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id sQtvS_Hls00e; Fri, 26 Aug 2022 12:01:29 +0200 (CEST)
Received: from tellis.lin.mbt.kalray.eu (unknown [192.168.36.206])
        by zimbra2.kalray.eu (Postfix) with ESMTPSA id A446E27E02FA;
        Fri, 26 Aug 2022 12:01:29 +0200 (CEST)
From:   Jules Maselbas <jmaselbas@kalray.eu>
To:     linux-kernel@vger.kernel.org
Cc:     Jules Maselbas <jmaselbas@kalray.eu>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Subject: [PATCH] bcache: bset: Fix comment typos
Date:   Fri, 26 Aug 2022 12:00:52 +0200
Message-Id: <20220826100052.22945-24-jmaselbas@kalray.eu>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: by Secumail
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Remove the redundant word `by`, correct the typo `creaated`.

CC: Kent Overstreet <kent.overstreet@gmail.com>
CC: linux-bcache@vger.kernel.org
Signed-off-by: Jules Maselbas <jmaselbas@kalray.eu>
---
 drivers/md/bcache/bset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index 94d38e8a59b3..2bba4d6aaaa2 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -1264,7 +1264,7 @@ static void __btree_sort(struct btree_keys *b, struct btree_iter *iter,
 		 *
 		 * Don't worry event 'out' is allocated from mempool, it can
 		 * still be swapped here. Because state->pool is a page mempool
-		 * creaated by by mempool_init_page_pool(), which allocates
+		 * created by mempool_init_page_pool(), which allocates
 		 * pages by alloc_pages() indeed.
 		 */
 
-- 
2.17.1

