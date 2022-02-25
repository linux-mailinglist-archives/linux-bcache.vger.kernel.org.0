Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C29A94C4014
	for <lists+linux-bcache@lfdr.de>; Fri, 25 Feb 2022 09:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbiBYI2z (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 25 Feb 2022 03:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235974AbiBYI2y (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 25 Feb 2022 03:28:54 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A37E2399C0;
        Fri, 25 Feb 2022 00:28:23 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id p9so3227307wra.12;
        Fri, 25 Feb 2022 00:28:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=1pk0WLnHXlhoL5oO4cTN7zI653+mY17exVAjVvxpGiI=;
        b=fPLc8XONsYkqIevb0UtKzISDb0EfV55898canwMM/Td3rcQ/VB+/LMFdc9559EOmPm
         Dg2TdxmhOmFp8bcq2DXXkaA2U9Gtopb1zwTTfELifE9MKyy4NP2XF6+1AfAuWarjDam+
         AQogKI1MejsGvGe7mOqhhyRDnTrtiH3Abo2i/HpetCT1lEdMcZkaJPjM19hb52pe0t0Q
         ZYqfFlAYn2GI1vVSkgKzJIR/6lZapU6gPh4rXcmcDy7MDocQfoTBgPaF5aXpMbiBnVuJ
         CdBKa1ClIlI8kd0yxb8E74wekx1fiytf0ao4J5oOu6M+RlKJ88Ckyey4UNTVZBliSGjr
         TmlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1pk0WLnHXlhoL5oO4cTN7zI653+mY17exVAjVvxpGiI=;
        b=8J3vhMRCFK9U37B8HyMCg2cSh0spfudCUV+Jmsh/CAl/hpzBs59F05idEQ1jcsGY9H
         5rt2m0MVH55b8rE3blygxHqq8bUexvoc5o8eRL/whBsIZ7/FJO/lSMVxV5dfOucqR8yS
         ZZgQYfHe5tUBvlUOjcfQrmpzk+3IwQ4Cd+pYnQ6uAfwNjgFiJPP6UwzzHFnt3QYD2v/a
         CtF1kwmzVNhyXwHbhH+O30Ja5vI3AYkJCSvoPg5wWou9P2t1T+U8C3qJvP7nORM/2kw7
         rmw6IGAOERvTLQ5NEHu0uPr9FsW8yCoWigApcaT0OCRd6Wi4Rcff2Sun37DAX8chIIx1
         Ihcg==
X-Gm-Message-State: AOAM533p5KESnAV8weRFyV8l3OVLxetvbVhEz/9lfi8QTEa29v5m72qh
        AeER3ZrO4JO+fCRW2haENC0=
X-Google-Smtp-Source: ABdhPJw7lM5U90Kcb5DDdxYcaKJG8VnYjOnuuVpkMln8V2MLvmT4afd29iRlybMgAEjP81FUXY0ugg==
X-Received: by 2002:a5d:6241:0:b0:1ed:b534:e04e with SMTP id m1-20020a5d6241000000b001edb534e04emr5393634wrv.68.1645777701838;
        Fri, 25 Feb 2022 00:28:21 -0800 (PST)
Received: from localhost.localdomain ([64.64.123.40])
        by smtp.gmail.com with ESMTPSA id o20-20020a05600c511400b0038133076da9sm1049613wms.25.2022.02.25.00.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 00:28:21 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     colyli@suse.de, kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] md: bcache: check the return value of mempool_alloc() in bch_btree_node_read_done()
Date:   Fri, 25 Feb 2022 00:28:04 -0800
Message-Id: <20220225082804.19793-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The function mempool_alloc() in bch_btree_node_read_done() can fail, so
its return value should be checked.

Fixes: d19936a26658 ("bcache: convert to bioset_init()/mempool_init()")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/md/bcache/btree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 88c573eeb598..fb8b7dd6bcc2 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -157,6 +157,8 @@ void bch_btree_node_read_done(struct btree *b)
 	 * See the comment arount cache_set->fill_iter.
 	 */
 	iter = mempool_alloc(&b->c->fill_iter, GFP_NOIO);
+	if (!iter)
+		return;
 	iter->size = b->c->cache->sb.bucket_size / b->c->cache->sb.block_size;
 	iter->used = 0;
 
-- 
2.17.1

