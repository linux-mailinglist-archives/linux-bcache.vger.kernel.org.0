Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16D9C5BD203
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Sep 2022 18:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiISQRb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 19 Sep 2022 12:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiISQRa (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 19 Sep 2022 12:17:30 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559C62A41A;
        Mon, 19 Sep 2022 09:17:26 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 44B1B1F898;
        Mon, 19 Sep 2022 16:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663604244; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JqhEOb/kQQutjav9ogK3MpMbym9wqCbIlY6eT4QQ/ZQ=;
        b=HaQq64g8llGqgj8YQvR1UeAuIRtYsJ2LSJkYJ8EjM+jmKKTzhZA3ecCKjM3ldP6q676qta
        QG19z4aOPv9gxNh59/d0lEyRPLPAU2OOfNqqEWLqPSm6Ixq7AMbbZL/7w/jCjsxOWG54Rk
        ChPMI1+zjsp9BqgCIfD+MaIRpy9WK7U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663604244;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JqhEOb/kQQutjav9ogK3MpMbym9wqCbIlY6eT4QQ/ZQ=;
        b=u3VeEByyi1Q/avOZq89T3TJ6vUq+Yhwz6sPMbEBHJqexMq7ms5A0XPzrpHTq6i/VKW0Gq3
        Px8KFS9egjI+p4Dg==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 3FCE42C141;
        Mon, 19 Sep 2022 16:17:20 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Li Lei <lilei@szsandstone.com>, Coly Li <colyli@suse.de>
Subject: [PATCH 1/5] bcache: remove unnecessary flush_workqueue
Date:   Tue, 20 Sep 2022 00:16:43 +0800
Message-Id: <20220919161647.81238-2-colyli@suse.de>
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

From: Li Lei <lilei@szsandstone.com>

All pending works will be drained by destroy_workqueue(), no need to call
flush_workqueue() explicitly.

Signed-off-by: Li Lei <lilei@szsandstone.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/writeback.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 3f0ff3aab6f2..647661005176 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -801,10 +801,9 @@ static int bch_writeback_thread(void *arg)
 		}
 	}
 
-	if (dc->writeback_write_wq) {
-		flush_workqueue(dc->writeback_write_wq);
+	if (dc->writeback_write_wq)
 		destroy_workqueue(dc->writeback_write_wq);
-	}
+
 	cached_dev_put(dc);
 	wait_for_kthread_stop();
 
-- 
2.35.3

