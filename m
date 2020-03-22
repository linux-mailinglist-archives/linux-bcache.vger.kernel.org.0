Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 434E318E70F
	for <lists+linux-bcache@lfdr.de>; Sun, 22 Mar 2020 07:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgCVGFA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 22 Mar 2020 02:05:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:49126 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726502AbgCVGFA (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 22 Mar 2020 02:05:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F13EBAB64;
        Sun, 22 Mar 2020 06:04:58 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 7/7] bcache: optimize barrier usage for atomic operations
Date:   Sun, 22 Mar 2020 14:03:05 +0800
Message-Id: <20200322060305.70637-8-colyli@suse.de>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200322060305.70637-1-colyli@suse.de>
References: <20200322060305.70637-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The idea of this patch is from Davidlohr Bueso, he posts a patch
for bcache to optimize barrier usage for read-modify-write atomic
bitops. Indeed such optimization can also apply on other locations
where smp_mb() is used before or after an atomic operation.

This patch replaces smp_mb() with smp_mb__before_atomic() or
smp_mb__after_atomic() in btree.c and writeback.c,  where it is used
to synchronize memory cache just earlier on other cores. Although
the locations are not on hot code path, it is always not bad to mkae
things a little better.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Davidlohr Bueso <dave@stgolabs.net>
---
 drivers/md/bcache/btree.c     | 6 +++---
 drivers/md/bcache/writeback.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 74d66b641169..72856e5f23a3 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1947,7 +1947,7 @@ static int bch_btree_check_thread(void *arg)
 				 */
 				atomic_set(&check_state->enough, 1);
 				/* Update check_state->enough earlier */
-				smp_mb();
+				smp_mb__after_atomic();
 				goto out;
 			}
 			skip_nr--;
@@ -1972,7 +1972,7 @@ static int bch_btree_check_thread(void *arg)
 out:
 	info->result = ret;
 	/* update check_state->started among all CPUs */
-	smp_mb();
+	smp_mb__before_atomic();
 	if (atomic_dec_and_test(&check_state->started))
 		wake_up(&check_state->wait);
 
@@ -2031,7 +2031,7 @@ int bch_btree_check(struct cache_set *c)
 	 */
 	for (i = 0; i < check_state->total_threads; i++) {
 		/* fetch latest check_state->enough earlier */
-		smp_mb();
+		smp_mb__before_atomic();
 		if (atomic_read(&check_state->enough))
 			break;
 
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 72ba6d015786..3f7641fb28d5 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -854,7 +854,7 @@ static int bch_dirty_init_thread(void *arg)
 			else {
 				atomic_set(&state->enough, 1);
 				/* Update state->enough earlier */
-				smp_mb();
+				smp_mb__after_atomic();
 				goto out;
 			}
 			skip_nr--;
@@ -873,7 +873,7 @@ static int bch_dirty_init_thread(void *arg)
 
 out:
 	/* In order to wake up state->wait in time */
-	smp_mb();
+	smp_mb__before_atomic();
 	if (atomic_dec_and_test(&state->started))
 		wake_up(&state->wait);
 
@@ -932,7 +932,7 @@ void bch_sectors_dirty_init(struct bcache_device *d)
 
 	for (i = 0; i < state->total_threads; i++) {
 		/* Fetch latest state->enough earlier */
-		smp_mb();
+		smp_mb__before_atomic();
 		if (atomic_read(&state->enough))
 			break;
 
-- 
2.25.0

