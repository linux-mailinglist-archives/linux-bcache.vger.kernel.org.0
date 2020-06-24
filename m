Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E29206D2C
	for <lists+linux-bcache@lfdr.de>; Wed, 24 Jun 2020 08:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387981AbgFXG7H (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 24 Jun 2020 02:59:07 -0400
Received: from smtp21.cstnet.cn ([159.226.251.21]:53872 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387606AbgFXG7H (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 24 Jun 2020 02:59:07 -0400
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jun 2020 02:59:06 EDT
Received: from ubuntu.localdomain (unknown [124.16.136.99])
        by APP-01 (Coremail) with SMTP id qwCowAAHwjBJ+PJeTHU5AA--.30479S2;
        Wed, 24 Jun 2020 14:52:58 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     colyli@suse.de, kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bcache: journel: use for_each_clear_bit() to simplify the  code
Date:   Wed, 24 Jun 2020 14:52:57 +0800
Message-Id: <20200624065257.4051-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: qwCowAAHwjBJ+PJeTHU5AA--.30479S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Jw4kGw18Cr4rKw15AF1DZFb_yoW3trcEkF
        12qF4Svr43Jr17Zw48Cry8urZIv3sxur1kZF4xt39IkF98Xas3Gr40vryUtr48Zry0yFyD
        J34UtrWFy3s0yjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb7AYjsxI4VWDJwAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4
        A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
        w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMc
        vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY02Avz4vE14v_GF1l42xK82IY
        c2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s
        026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF
        0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0x
        vE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2
        jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU0YXdUUUUUU==
X-Originating-IP: [124.16.136.99]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwIRA102YjeFPwAAsT
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Using for_each_clear_bit() to simplify the code.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/md/bcache/journal.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 90aac4e2333f..b01c953e214c 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -217,10 +217,7 @@ int bch_journal_read(struct cache_set *c, struct list_head *list)
 		 */
 		pr_debug("falling back to linear search\n");
 
-		for (l = find_first_zero_bit(bitmap, ca->sb.njournal_buckets);
-		     l < ca->sb.njournal_buckets;
-		     l = find_next_zero_bit(bitmap, ca->sb.njournal_buckets,
-					    l + 1))
+		for_each_clear_bit(l, bitmap, ca->sb.njournal_buckets)
 			if (read_bucket(l))
 				goto bsearch;
 
-- 
2.17.1

