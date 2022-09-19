Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD7635BD207
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Sep 2022 18:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiISQRk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 19 Sep 2022 12:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiISQRj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 19 Sep 2022 12:17:39 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2932F31DFF;
        Mon, 19 Sep 2022 09:17:34 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 14E9621F33;
        Mon, 19 Sep 2022 16:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663604252; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rTTzeWtVjoMpEkFi4NHFASN9aM2ScMujKGpSxc8XlEk=;
        b=olTp75L7jrMIQRG6iKMxSvHw/sBah1SEHk7HYQFZmcia951OBGpvflOsraDYsYgdSJmZVE
        5mTW0z6a+gQNRLW8mdsQek/wBaIskr4o23KTSsMiQXeMw9LBHUlXyjgITzo+gNDdDiFTQQ
        AXUsbIxkPrNSwlPotluE9J+KQDTkNRc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663604252;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rTTzeWtVjoMpEkFi4NHFASN9aM2ScMujKGpSxc8XlEk=;
        b=AkmG3OP7Fg4syKa91O2n1Dn53YgsfWfNq1MI7W5FqmCCuORfi3hflSEOqOnDlO5NcKs2aT
        6/0EIH6j3euwx4DQ==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id C39022C142;
        Mon, 19 Sep 2022 16:17:28 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jules Maselbas <jmaselbas@kalray.eu>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 3/5] bcache: bset: Fix comment typos
Date:   Tue, 20 Sep 2022 00:16:45 +0800
Message-Id: <20220919161647.81238-4-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220919161647.81238-1-colyli@suse.de>
References: <20220919161647.81238-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Jules Maselbas <jmaselbas@kalray.eu>

Remove the redundant word `by`, correct the typo `creaated`.

CC: Kent Overstreet <kent.overstreet@gmail.com>
CC: linux-bcache@vger.kernel.org
Signed-off-by: Jules Maselbas <jmaselbas@kalray.eu>
Signed-off-by: Coly Li <colyli@suse.de>
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
2.35.3

