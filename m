Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD5A536CF2
	for <lists+linux-bcache@lfdr.de>; Sat, 28 May 2022 14:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235343AbiE1MqD (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 28 May 2022 08:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiE1MqC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 28 May 2022 08:46:02 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEF0F8;
        Sat, 28 May 2022 05:46:01 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 46ADA1F895;
        Sat, 28 May 2022 12:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653741960; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IqQyIL5+3r+0aJMqJCo/t/VtD8yTF0XmgPhW311VF4o=;
        b=mltqktQZh3Zc3I7Wen7ecMtaOTjj8m+Whdzcsm2IrBxV9v9fTdKlRGBVdbaxOo+0+egIUu
        4qj5j8Zt+R3CLu2NJVTCC4o+m4BYITPbc37/KMt9JCUxqndvYeEFh++YHf1A06y7lnaGZP
        XRjS/UyGqXhzxvrnm46M3yKq+15bwg8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653741960;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IqQyIL5+3r+0aJMqJCo/t/VtD8yTF0XmgPhW311VF4o=;
        b=AIa54PEm978USYp1CedMhEcOM7DDkYtuu7YXu9+IH0dDYxWb5yzfJ/ZibMhyO7xKV5MGSL
        izxmWhS48OGQahBg==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 480AA2C141;
        Sat, 28 May 2022 12:45:57 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 1/1] bcache: avoid unnecessary soft lockup in kworker update_writeback_rate()
Date:   Sat, 28 May 2022 20:45:50 +0800
Message-Id: <20220528124550.32834-2-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220528124550.32834-1-colyli@suse.de>
References: <20220528124550.32834-1-colyli@suse.de>
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

The kworker routine update_writeback_rate() is schedued to update the
writeback rate in every 5 seconds by default. Before calling
__update_writeback_rate() to do real job, semaphore dc->writeback_lock
should be held by the kworker routine.

At the same time, bcache writeback thread routine bch_writeback_thread()
also needs to hold dc->writeback_lock before flushing dirty data back
into the backing device. If the dirty data set is large, it might be
very long time for bch_writeback_thread() to scan all dirty buckets and
releases dc->writeback_lock. In such case update_writeback_rate() can be
starved for long enough time so that kernel reports a soft lockup warn-
ing started like:
  watchdog: BUG: soft lockup - CPU#246 stuck for 23s! [kworker/246:31:179713]

Such soft lockup condition is unnecessary, because after the writeback
thread finishes its job and releases dc->writeback_lock, the kworker
update_writeback_rate() may continue to work and everything is fine
indeed.

This patch avoids the unnecessary soft lockup by the following method,
- Add new member to struct cached_dev
  - dc->rate_update_retry (0 by default)
- In update_writeback_rate() call down_read_trylock(&dc->writeback_lock)
  firstly, if it fails then lock contention happens.
- If dc->rate_update_retry <= BCH_WBRATE_UPDATE_MAX_SKIPS (15), doesn't
  acquire the lock and reschedules the kworker for next try.
- If dc->rate_update_retry > BCH_WBRATE_UPDATE_MAX_SKIPS, no retry
  anymore and call down_read(&dc->writeback_lock) to wait for the lock.

By the above method, at worst case update_writeback_rate() may retry for
1+ minutes before blocking on dc->writeback_lock by calling down_read().
For a 4TB cache device with 1TB dirty data, 90%+ of the unnecessary soft
lockup warning message can be avoided.

When retrying to acquire dc->writeback_lock in update_writeback_rate(),
of course the writeback rate cannot be updated. It is fair, because when
the kworker is blocked on the lock contention of dc->writeback_lock, the
writeback rate cannot be updated neither.

This change follows Jens Axboe's suggestion to a more clear and simple
version.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/bcache.h    |  7 +++++++
 drivers/md/bcache/writeback.c | 31 +++++++++++++++++++++----------
 2 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 9ed9c955add7..2acda9cea0f9 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -395,6 +395,13 @@ struct cached_dev {
 	atomic_t		io_errors;
 	unsigned int		error_limit;
 	unsigned int		offline_seconds;
+
+	/*
+	 * Retry to update writeback_rate if contention happens for
+	 * down_read(dc->writeback_lock) in update_writeback_rate()
+	 */
+#define BCH_WBRATE_UPDATE_MAX_SKIPS	15
+	unsigned int		rate_update_retry;
 };
 
 enum alloc_reserve {
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index d138a2d73240..3f0ff3aab6f2 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -235,19 +235,27 @@ static void update_writeback_rate(struct work_struct *work)
 		return;
 	}
 
-	if (atomic_read(&dc->has_dirty) && dc->writeback_percent) {
-		/*
-		 * If the whole cache set is idle, set_at_max_writeback_rate()
-		 * will set writeback rate to a max number. Then it is
-		 * unncessary to update writeback rate for an idle cache set
-		 * in maximum writeback rate number(s).
-		 */
-		if (!set_at_max_writeback_rate(c, dc)) {
-			down_read(&dc->writeback_lock);
+	/*
+	 * If the whole cache set is idle, set_at_max_writeback_rate()
+	 * will set writeback rate to a max number. Then it is
+	 * unncessary to update writeback rate for an idle cache set
+	 * in maximum writeback rate number(s).
+	 */
+	if (atomic_read(&dc->has_dirty) && dc->writeback_percent &&
+	    !set_at_max_writeback_rate(c, dc)) {
+		do {
+			if (!down_read_trylock((&dc->writeback_lock))) {
+				dc->rate_update_retry++;
+				if (dc->rate_update_retry <=
+				    BCH_WBRATE_UPDATE_MAX_SKIPS)
+					break;
+				down_read(&dc->writeback_lock);
+				dc->rate_update_retry = 0;
+			}
 			__update_writeback_rate(dc);
 			update_gc_after_writeback(c);
 			up_read(&dc->writeback_lock);
-		}
+		} while (0);
 	}
 
 
@@ -1006,6 +1014,9 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
 	dc->writeback_rate_fp_term_high = 1000;
 	dc->writeback_rate_i_term_inverse = 10000;
 
+	/* For dc->writeback_lock contention in update_writeback_rate() */
+	dc->rate_update_retry = 0;
+
 	WARN_ON(test_and_clear_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags));
 	INIT_DELAYED_WORK(&dc->writeback_rate_update, update_writeback_rate);
 }
-- 
2.35.3

