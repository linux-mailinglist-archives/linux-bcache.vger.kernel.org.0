Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34ECE35B4F0
	for <lists+linux-bcache@lfdr.de>; Sun, 11 Apr 2021 15:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235936AbhDKNo0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 11 Apr 2021 09:44:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:47554 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235787AbhDKNoI (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 11 Apr 2021 09:44:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 62EC5ABD0;
        Sun, 11 Apr 2021 13:43:51 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 5/7] md: bcache: Trivial typo fixes in the file journal.c
Date:   Sun, 11 Apr 2021 21:43:14 +0800
Message-Id: <20210411134316.80274-6-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210411134316.80274-1-colyli@suse.de>
References: <20210411134316.80274-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Bhaskar Chowdhury <unixbhaskar@gmail.com>

s/condidate/candidate/
s/folowing/following/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/journal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index de2c0d7699cf..61bd79babf7a 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -111,7 +111,7 @@ reread:		left = ca->sb.bucket_size - offset;
 			 * Check from the oldest jset for last_seq. If
 			 * i->j.seq < j->last_seq, it means the oldest jset
 			 * in list is expired and useless, remove it from
-			 * this list. Otherwise, j is a condidate jset for
+			 * this list. Otherwise, j is a candidate jset for
 			 * further following checks.
 			 */
 			while (!list_empty(list)) {
@@ -498,7 +498,7 @@ static void btree_flush_write(struct cache_set *c)
 		 * - If there are matched nodes recorded in btree_nodes[],
 		 *   they are clean now (this is why and how the oldest
 		 *   journal entry can be reclaimed). These selected nodes
-		 *   will be ignored and skipped in the folowing for-loop.
+		 *   will be ignored and skipped in the following for-loop.
 		 */
 		if (((btree_current_write(b)->journal - fifo_front_p) &
 		     mask) != 0) {
-- 
2.26.2

