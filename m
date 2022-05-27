Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D055364B2
	for <lists+linux-bcache@lfdr.de>; Fri, 27 May 2022 17:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353202AbiE0Pbr (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 May 2022 11:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235167AbiE0Pbq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 May 2022 11:31:46 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57B41C12D;
        Fri, 27 May 2022 08:31:43 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 6418B21AC3;
        Fri, 27 May 2022 15:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653665502; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q9b3UkfsXgOJLlX+ZpfHRAeuybWo2jhFrZLCDQSKD1M=;
        b=lSrx0uP6frs7lPruV8j2ujl6mwG78gSr9tBGUiPp/fyDVmKreQ/TWWR4NjHAvIcUpxB9t6
        /kZL/HhF8lD2h65Y2xGAKdRDE4F7C2aW9cbhl+h94UMyY4ulHY+xP3c9Ftd6H2+Z2rz8KB
        ssZ259QUUqoq7ga1HnjITvq2ktb/h9A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653665502;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q9b3UkfsXgOJLlX+ZpfHRAeuybWo2jhFrZLCDQSKD1M=;
        b=abmQKrNLG7XSqF/t8SjMZzdT7VKzJDf1FhrXXyZ+9MuY7NbkyOMY8fk2bSX0byiQDYKxq4
        QxkDlcBfeWTMngDA==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 502B82C142;
        Fri, 27 May 2022 15:31:39 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 1/3] bcache: memset on stack variables in bch_btree_check() and bch_sectors_dirty_init()
Date:   Fri, 27 May 2022 23:28:16 +0800
Message-Id: <20220527152818.27545-2-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220527152818.27545-1-colyli@suse.de>
References: <20220527152818.27545-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The local variables check_state (in bch_btree_check()) and state (in
bch_sectors_dirty_init()) should be fully filled by 0, because before
allocating them on stack, they were dynamically allocated by kzalloc().

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/btree.c     | 1 +
 drivers/md/bcache/writeback.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 2362bb8ef6d1..e136d6edc1ed 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -2017,6 +2017,7 @@ int bch_btree_check(struct cache_set *c)
 	if (c->root->level == 0)
 		return 0;
 
+	memset(&check_state, 0, sizeof(struct btree_check_state));
 	check_state.c = c;
 	check_state.total_threads = bch_btree_chkthread_nr();
 	check_state.key_idx = 0;
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 75b71199800d..d138a2d73240 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -950,6 +950,7 @@ void bch_sectors_dirty_init(struct bcache_device *d)
 		return;
 	}
 
+	memset(&state, 0, sizeof(struct bch_dirty_init_state));
 	state.c = c;
 	state.d = d;
 	state.total_threads = bch_btre_dirty_init_thread_nr();
-- 
2.35.3

