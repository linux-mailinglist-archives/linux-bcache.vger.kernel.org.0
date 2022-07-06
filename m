Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA004568019
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Jul 2022 09:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiGFHkE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 6 Jul 2022 03:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiGFHkE (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 6 Jul 2022 03:40:04 -0400
Received: from zg8tmtyylji0my4xnjqunzqa.icoremail.net (zg8tmtyylji0my4xnjqunzqa.icoremail.net [162.243.164.74])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 4A17122BC7;
        Wed,  6 Jul 2022 00:39:58 -0700 (PDT)
Received: from fedora33.wangsu.com (unknown [59.61.78.232])
        by app2 (Coremail) with SMTP id SyJltAAHDu47PMViQhcBAA--.1816S2;
        Wed, 06 Jul 2022 15:39:44 +0800 (CST)
From:   Lin Feng <linf@wangsu.com>
To:     colyli@suse.de, kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linf@wangsu.com
Subject: [PATCH] bcache: remove unused bch_mark_cache_readahead function def in stats.h
Date:   Wed,  6 Jul 2022 15:39:37 +0800
Message-Id: <20220706073937.148360-1-linf@wangsu.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: SyJltAAHDu47PMViQhcBAA--.1816S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Xw15Gw15Kw43AFW8ZrWrKrg_yoWfZwc_Z3
        WavF1xWrW3tr1xWw17Kr9aqFZYg3yDZFWqvFWqvF9avFn5Zry5Ww1Fvr17Jr97Wa10kF17
        AF1kZrWrAry8CjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbz8Fc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kI
        II0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7
        xvwVC0I7IYx2IY6xkF7I0E14v26F4UJVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28E
        F7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F4
        0EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1sIEY20_Gr4lYx0Ec7CjxVAajcxG14v26F4j
        6r4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5c
        I20VAGYxC7MxkIecxEwVAFwVW8CwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx2
        6r48MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
        xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xII
        jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
        0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
        67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfU2SfODUUUU
X-CM-SenderInfo: holqwq5zdqw23xof0z/
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This is a cleanup for
'Commit 1616a4c2ab1a ("bcache: remove bcache device self-defined readahead")',
currently no user for bch_mark_cache_readahead() since that commit.

Signed-off-by: Lin Feng <linf@wangsu.com>
---
 drivers/md/bcache/stats.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/bcache/stats.h b/drivers/md/bcache/stats.h
index ca4f435f7216..bd3afc856d53 100644
--- a/drivers/md/bcache/stats.h
+++ b/drivers/md/bcache/stats.h
@@ -54,7 +54,6 @@ void bch_cache_accounting_destroy(struct cache_accounting *acc);
 
 void bch_mark_cache_accounting(struct cache_set *c, struct bcache_device *d,
 			       bool hit, bool bypass);
-void bch_mark_cache_readahead(struct cache_set *c, struct bcache_device *d);
 void bch_mark_cache_miss_collision(struct cache_set *c,
 				   struct bcache_device *d);
 void bch_mark_sectors_bypassed(struct cache_set *c,
-- 
2.31.1

