Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B87515C026
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Feb 2020 15:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730078AbgBMOMe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 13 Feb 2020 09:12:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:50402 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729990AbgBMOMd (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 13 Feb 2020 09:12:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 54ECCAE34;
        Thu, 13 Feb 2020 14:12:32 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 3/3] bcache: remove macro nr_to_fifo_front()
Date:   Thu, 13 Feb 2020 22:12:07 +0800
Message-Id: <20200213141207.77219-4-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200213141207.77219-1-colyli@suse.de>
References: <20200213141207.77219-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Macro nr_to_fifo_front() is only used once in btree_flush_write(),
it is unncessary indeed. This patch removes this macro and does
calculation directly in place.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/journal.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 6730820780b0..0e3ff9745ac7 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -417,8 +417,6 @@ int bch_journal_replay(struct cache_set *s, struct list_head *list)
 
 /* Journalling */
 
-#define nr_to_fifo_front(p, front_p, mask)	(((p) - (front_p)) & (mask))
-
 static void btree_flush_write(struct cache_set *c)
 {
 	struct btree *b, *t, *btree_nodes[BTREE_FLUSH_NR];
@@ -510,9 +508,8 @@ static void btree_flush_write(struct cache_set *c)
 		 *   journal entry can be reclaimed). These selected nodes
 		 *   will be ignored and skipped in the folowing for-loop.
 		 */
-		if (nr_to_fifo_front(btree_current_write(b)->journal,
-				     fifo_front_p,
-				     mask) != 0) {
+		if (((btree_current_write(b)->journal - fifo_front_p) &
+		     mask) != 0) {
 			mutex_unlock(&b->write_lock);
 			continue;
 		}
-- 
2.16.4

