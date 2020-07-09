Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3E32196C3
	for <lists+linux-bcache@lfdr.de>; Thu,  9 Jul 2020 05:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgGIDlN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 8 Jul 2020 23:41:13 -0400
Received: from smtp23.cstnet.cn ([159.226.251.23]:33098 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726122AbgGIDlN (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 8 Jul 2020 23:41:13 -0400
Received: from localhost (unknown [159.226.5.99])
        by APP-03 (Coremail) with SMTP id rQCowABn6fhZkQZfXF2pAw--.36772S2;
        Thu, 09 Jul 2020 11:39:06 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     colyli@suse.de, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Xu Wang <vulab@iscas.ac.cn>
Subject: [PATCH] bcache: writeback: Remove unneeded variable ret
Date:   Thu,  9 Jul 2020 03:39:04 +0000
Message-Id: <20200709033904.27391-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: rQCowABn6fhZkQZfXF2pAw--.36772S2
X-Coremail-Antispam: 1UD129KBjvdXoWrCr4fJw18uw4xXrW3uryDWrg_yoWxXrb_ur
        1Yqa1vkFWFk3WkXw17A3WfZrWj934DZF10q3WSkr9xKF1Fy34xXrW8Zr4kJr1S9Fy8uF4D
        Gw12qr4UAr1v9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb4xFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
        Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
        0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_
        Gr4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
        WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI
        7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
        1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8
        JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JU4MKZUUU
        UU=
X-Originating-IP: [159.226.5.99]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCAAMA102YRI8CwAAso
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Remove unneeded variable ret i.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/md/bcache/writeback.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 1cf1e5016cb9..71801c086b82 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -825,10 +825,8 @@ static int bch_dirty_init_thread(void *arg)
 	struct btree_iter iter;
 	struct bkey *k, *p;
 	int cur_idx, prev_idx, skip_nr;
-	int i;
 
 	k = p = NULL;
-	i = 0;
 	cur_idx = prev_idx = 0;
 
 	bch_btree_iter_init(&c->root->keys, &iter, NULL);
-- 
2.17.1

