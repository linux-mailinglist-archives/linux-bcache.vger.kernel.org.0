Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F72A507281
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Apr 2022 18:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354331AbiDSQHn (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 19 Apr 2022 12:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354393AbiDSQHg (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 19 Apr 2022 12:07:36 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF695BC2B;
        Tue, 19 Apr 2022 09:04:53 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 65D721F752;
        Tue, 19 Apr 2022 16:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1650384292; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=suTXyimM3RuxwOZfem+9Jfn70HGUAVc4SO+4D+kIats=;
        b=J/LX8G/qDy/5h3cXNDfs9Gschcz2BnO1TsLtkROYh4Mg7VohBkbSeEhNOKTr1duOWtHWSY
        UXQYcTingvUUXBVL0+97Jc7AKfjXPNvsczfpq2blekW6kakTZNwCnp4+RKPinQu9I5qR1X
        YtfjK//iUZehkHWKlK+QK7Sl1ijIHks=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1650384292;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=suTXyimM3RuxwOZfem+9Jfn70HGUAVc4SO+4D+kIats=;
        b=WWJN2bUMzSjIcxgKXWhoR0fjcaNTw2m2/axUgL81gtM4TjM30HRjsJzt+7vWOyvjzosm+N
        6vvWQRbvWmjMpBDQ==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 8BC6A2C142;
        Tue, 19 Apr 2022 16:04:43 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     hch@lst.de, kch@nvidia.com, snitzer@redhat.com,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 1/2] bcache: put bch_bio_map() back to correct location in journal_write_unlocked()
Date:   Wed, 20 Apr 2022 00:04:24 +0800
Message-Id: <20220419160425.4148-2-colyli@suse.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220419160425.4148-1-colyli@suse.de>
References: <20220419160425.4148-1-colyli@suse.de>
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

Commit a7c50c940477 ("block: pass a block_device and opf to bio_reset")
moves bch_bio_map() inside journal_write_unlocked() next to the location
where the modified bio_reset() was called.

This change is wrong because calling bch_bio_map() immediately after
bio_reset(), a BUG_ON(!bio->bi_iter.bi_size) inside bch_bio_map() will
be triggered and panic the kernel.

This patch puts bch_bio_map() back to its original correct location in
journal_write_unlocked() and avoid the BUG_ON().

Fixes: a7c50c940477 ("block: pass a block_device and opf to bio_reset")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/md/bcache/journal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 7c2ca52ca3e4..df5347ea450b 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -771,12 +771,12 @@ static void journal_write_unlocked(struct closure *cl)
 
 		bio_reset(bio, ca->bdev, REQ_OP_WRITE | 
 			  REQ_SYNC | REQ_META | REQ_PREFLUSH | REQ_FUA);
-		bch_bio_map(bio, w->data);
 		bio->bi_iter.bi_sector	= PTR_OFFSET(k, i);
 		bio->bi_iter.bi_size = sectors << 9;
 
 		bio->bi_end_io	= journal_write_endio;
 		bio->bi_private = w;
+		bch_bio_map(bio, w->data);
 
 		trace_bcache_journal_write(bio, w->data->keys);
 		bio_list_add(&list, bio);
-- 
2.34.1

