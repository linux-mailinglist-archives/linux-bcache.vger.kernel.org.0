Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 199E35BBCE4
	for <lists+linux-bcache@lfdr.de>; Sun, 18 Sep 2022 11:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiIRJqO (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 18 Sep 2022 05:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiIRJqO (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 18 Sep 2022 05:46:14 -0400
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.154.221.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044CB23BCD;
        Sun, 18 Sep 2022 02:46:10 -0700 (PDT)
X-QQ-mid: bizesmtp87t1663494357t1v7w32q
Received: from localhost.localdomain ( [125.70.163.64])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sun, 18 Sep 2022 17:45:55 +0800 (CST)
X-QQ-SSF: 01000000002000E0G000B00A0000000
X-QQ-FEAT: y5ttDAKJaXNvXC2GOQxZsIIK7T21JzAKe9rgFGByFPtBn2HuAgOvKqAhH5NWG
        8j/T+hLmE4YEqRAwoSjyXLnxKsPGaGCx4M6h2H/gZMP9OL8SXvLQfj5MC0yFc2uXp+gF5Gx
        55IyJolJTHa6I8/nIg262If2RStlYXvEj0L6YHOo66NDlLMzLYm3gRDeeehvzePE8yCLuAD
        YJFbla+u6h0YCVAK7lqm0gBLmgcLnr8Yy4a46IYuTc8Lp7t3nPLLygir1xjrXD5w+fplJZy
        RIe3yVWjridnjGnKIlLJjJOHMcSWz+LIYZIlF9GZFyGaC++Uk8EOzqwkoAuVdr/G0Tuqgyx
        ShWLNoaSEpm7bxrkXVIZIYkhgitdnmO7bj39mDJ
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     colyli@suse.de, kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] bcache: fix repeated words in comments
Date:   Sun, 18 Sep 2022 17:45:49 +0800
Message-Id: <20220918094549.17325-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Delete the redundant word 'by'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/md/bcache/bset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index 94d38e8a59b3..6a24a327dce2 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -1264,7 +1264,7 @@ static void __btree_sort(struct btree_keys *b, struct btree_iter *iter,
 		 *
 		 * Don't worry event 'out' is allocated from mempool, it can
 		 * still be swapped here. Because state->pool is a page mempool
-		 * creaated by by mempool_init_page_pool(), which allocates
+		 * creaated by mempool_init_page_pool(), which allocates
 		 * pages by alloc_pages() indeed.
 		 */
 
-- 
2.36.1

