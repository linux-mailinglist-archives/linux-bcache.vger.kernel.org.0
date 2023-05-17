Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFF3706490
	for <lists+linux-bcache@lfdr.de>; Wed, 17 May 2023 11:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjEQJvZ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 17 May 2023 05:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjEQJvY (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 17 May 2023 05:51:24 -0400
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3BDE85591
        for <linux-bcache@vger.kernel.org>; Wed, 17 May 2023 02:51:15 -0700 (PDT)
Received: from [10.8.148.37] (unknown [59.61.78.234])
        by app2 (Coremail) with SMTP id SyJltABXWxGPo2RkF_MBAA--.1186S2;
        Wed, 17 May 2023 17:51:11 +0800 (CST)
Message-ID: <84456adb-2933-49a4-cf40-b58b19ddd178@wangsu.com>
Date:   Wed, 17 May 2023 17:51:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From:   Lin Feng <linf@wangsu.com>
Subject: [PATCH] bcache: fix nbuckets lower limit checking in
 read_super_common
Content-Language: en-US
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linf@wangsu.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: SyJltABXWxGPo2RkF_MBAA--.1186S2
X-Coremail-Antispam: 1UD129KBjvdXoWrurWxJr15KF4fKr1kGryxGrg_yoWfXrX_ua
        1xXFZFgr45tr12vw13C3ySv3y7K3ZF9F40qF17tF4ayas8Zry3WrWkZr1xJFs8Jr1Uuasr
        CrWDXa15Aa1xCjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbaxFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kI
        II0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7
        xvwVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2
        z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4
        xG64xvF2IEw4CE5I8CrVC2j2WlYx0EF7xvrVAajcxG14v26r1j6r4UMcIj6x8ErcxFaVAv
        8VW8GwAv7VCY1x0262k0Y48FwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2
        IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0xIA0c2IEe2xFo4CEbIxvr21lc2xS
        Y4AK67AK6r4fMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_Gr4l4I8I3I0E4I
        kC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWU
        WwC2zVAF1VAY17CE14v26r1Y6r17MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr
        0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWU
        JVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYx
        BIdaVFxhVjvjDU0xZFpf9x0JUEoGQUUUUU=
X-CM-SenderInfo: holqwq5zdqw23xof0z/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In fact due to this check in cache_alloc:
    free = roundup_pow_of_two(ca->sb.nbuckets) >> 10;
    if (!free) {
        ret = -EPERM;
        err = "ca->sb.nbuckets is too small";
        goto err_free;
    }
we can only create bcache device with nbuckets greater than 512,
so this patch is to make the codes logic consistent.

Signed-off-by: Lin Feng <linf@wangsu.com>
---
 drivers/md/bcache/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 7e9d19fd21dd..681a7ea442b9 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -110,7 +110,7 @@ static const char *read_super_common(struct cache_sb *sb,  struct block_device *
 		goto err;
 
 	err = "Not enough buckets";
-	if (sb->nbuckets < 1 << 7)
+	if (sb->nbuckets <= 1 << 9)
 		goto err;
 
 	err = "Bad block size (not power of 2)";
-- 
2.40.1

