Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED13B507286
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Apr 2022 18:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354334AbiDSQHo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 19 Apr 2022 12:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354411AbiDSQHk (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 19 Apr 2022 12:07:40 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1D8BC0A;
        Tue, 19 Apr 2022 09:04:57 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id C15A421601;
        Tue, 19 Apr 2022 16:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1650384295; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z+3aAU9uNbVvLuEPmFtNeMNDyKnto7iqzKw2El8pJGI=;
        b=mmpajxKhkU1mnkmh056J11rsisif1Eat6AwlPyRLFPrb7mrHzwv4lHpiZeThKG6UZU95V3
        wDMDiQty0li4zSR3p1KaPqXH6neJbMD8LbycfAauuTF7K4za2xIu3tsVRQPxb1XasXN0LG
        qvdlZ1VwAy7Sosrhv7Kx8s0TPn/yukE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1650384295;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z+3aAU9uNbVvLuEPmFtNeMNDyKnto7iqzKw2El8pJGI=;
        b=y6L7axMSD8Kaa/ZGqcyY9exPvfiQ7wh8I1ICosqiKryY5B4GqQ6yJICZuJw0Pt4PJ3mr66
        cpVXEBL+by8moKBQ==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 0717F2C146;
        Tue, 19 Apr 2022 16:04:52 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     hch@lst.de, kch@nvidia.com, snitzer@redhat.com,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 2/2] bcache: fix wrong bdev parameter when calling bio_alloc_clone() in do_bio_hook()
Date:   Wed, 20 Apr 2022 00:04:25 +0800
Message-Id: <20220419160425.4148-3-colyli@suse.de>
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

Commit abfc426d1b2f ("block: pass a block_device to bio_clone_fast")
calls the modified bio_alloc_clone() in bcache code as:
	bio_init_clone(bio->bi_bdev, bio, orig_bio, GFP_NOIO);

But the first parameter is wrong, where bio->bi_bdev should be
orig_bio->bi_bdev. The wrong bi_bdev panics the kernel when submitting
cache bio.

This patch fixes the wrong bdev parameter usage and avoid the panic.

Fixes: abfc426d1b2f ("block: pass a block_device to bio_clone_fast")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/bcache/request.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index fdd0194f84dd..320fcdfef48e 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -685,7 +685,7 @@ static void do_bio_hook(struct search *s,
 {
 	struct bio *bio = &s->bio.bio;
 
-	bio_init_clone(bio->bi_bdev, bio, orig_bio, GFP_NOIO);
+	bio_init_clone(orig_bio->bi_bdev, bio, orig_bio, GFP_NOIO);
 	/*
 	 * bi_end_io can be set separately somewhere else, e.g. the
 	 * variants in,
-- 
2.34.1

