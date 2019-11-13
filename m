Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4434FA9B8
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Nov 2019 06:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfKMFer (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 13 Nov 2019 00:34:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:54224 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725976AbfKMFer (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 13 Nov 2019 00:34:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7F356B150;
        Wed, 13 Nov 2019 05:34:45 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 05/10] bcache: deleted code comments for dead code in bch_data_insert_keys()
Date:   Wed, 13 Nov 2019 13:33:41 +0800
Message-Id: <20191113053346.63536-6-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191113053346.63536-1-colyli@suse.de>
References: <20191113053346.63536-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In request.c:bch_data_insert_keys(), there is code comment for a piece
of dead code. This patch deletes the dead code and its code comment
since they are useless in practice.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/request.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 41adcd1546f1..73478a91a342 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -62,18 +62,6 @@ static void bch_data_insert_keys(struct closure *cl)
 	struct bkey *replace_key = op->replace ? &op->replace_key : NULL;
 	int ret;
 
-	/*
-	 * If we're looping, might already be waiting on
-	 * another journal write - can't wait on more than one journal write at
-	 * a time
-	 *
-	 * XXX: this looks wrong
-	 */
-#if 0
-	while (atomic_read(&s->cl.remaining) & CLOSURE_WAITING)
-		closure_sync(&s->cl);
-#endif
-
 	if (!op->replace)
 		journal_ref = bch_journal(op->c, &op->insert_keys,
 					  op->flush_journal ? cl : NULL);
-- 
2.16.4

