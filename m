Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28DA14F85B1
	for <lists+linux-bcache@lfdr.de>; Thu,  7 Apr 2022 19:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbiDGRSx (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 7 Apr 2022 13:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346031AbiDGRSw (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 7 Apr 2022 13:18:52 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D09BDB2EC
        for <linux-bcache@vger.kernel.org>; Thu,  7 Apr 2022 10:16:51 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2CA63212CA
        for <linux-bcache@vger.kernel.org>; Thu,  7 Apr 2022 17:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649351810; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=o+LL8NXWGZLt8qMZKoPcR9wjtAZqiZCTA3vH1xMmtPs=;
        b=bLG6G6glg3RMfnuwgywOWJMtNAcf9fLVRIir17vVBR3101Q+xdMg0LwtfnMhgksPWfvpCd
        QTljrw763XraMrxiOpI54DzJqIUhG/+JMFxaXMTH9+DVWLcsejJxd+HicWq98JfZBL9MNq
        8JygiXhm4WJw0k/K7sbCsnLb5aMy66E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649351810;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=o+LL8NXWGZLt8qMZKoPcR9wjtAZqiZCTA3vH1xMmtPs=;
        b=sTpnqVNEXDhIX9OWb5xdIl/BqFt62p2AcRmiehDB/B0QzTWo/V0la/RhCKQWCaDXjQCFXm
        G/02e6qppGIourBg==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id D0906A3B87;
        Thu,  7 Apr 2022 17:16:48 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>
Subject: [PATCH] bcache: avoid unnecessary soft lockup in kworker update_writeback_rate()
Date:   Fri,  8 Apr 2022 01:16:43 +0800
Message-Id: <20220407171643.65177-1-colyli@suse.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
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
- Add new members to struct cached_dev
  - dc->retry_nr (0 by default)
  - dc->retry_max (6 by default)
- In update_writeback_rate() call down_read_trylock(&dc->writeback_lock)
  firstly, if it fails then lock contention happens. If dc->retry_nr is
  smaller than dc->retry_max, increase 1 to dc->retry_nr, and reschedule
  the kworker to retry after a bit long time.
- If lock contention happens and dc->retry_nr is equal to dc->retry_max,
  no retry anymore and call down_read(&dc->writeback_lock) to wait for the
  lock.

By the above method, at worst case update_writeback_rate() may retry for
2+ minutes before blocking on dc->writeback_lock by calling down_read().
For a 4TB cache device with 1TB dirty data, 90%+ of the unnecessary soft
lockup warning message can be avoided.

When retrying to acquire dc->writeback_lock in update_writeback_rate(),
of course the writeback rate cannot be updated. It is fair, because when
the kworker is blocked on the lock contention of dc->writeback_lock, the
writeback rate cannot be updated neither.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/bcache.h    |  7 +++++
 drivers/md/bcache/writeback.c | 49 +++++++++++++++++++++++++++++++----
 2 files changed, 51 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 9ed9c955add7..82b86b874294 100644
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
+	unsigned int		retry_nr;
+	unsigned int		retry_max;
 };
 
 enum alloc_reserve {
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 9ee0005874cd..dbe90b9b2940 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -214,6 +214,7 @@ static void update_writeback_rate(struct work_struct *work)
 					     struct cached_dev,
 					     writeback_rate_update);
 	struct cache_set *c = dc->disk.c;
+	bool contention = false;
 
 	/*
 	 * should check BCACHE_DEV_RATE_DW_RUNNING before calling
@@ -235,6 +236,7 @@ static void update_writeback_rate(struct work_struct *work)
 		return;
 	}
 
+
 	if (atomic_read(&dc->has_dirty) && dc->writeback_percent) {
 		/*
 		 * If the whole cache set is idle, set_at_max_writeback_rate()
@@ -243,13 +245,44 @@ static void update_writeback_rate(struct work_struct *work)
 		 * in maximum writeback rate number(s).
 		 */
 		if (!set_at_max_writeback_rate(c, dc)) {
-			down_read(&dc->writeback_lock);
-			__update_writeback_rate(dc);
-			update_gc_after_writeback(c);
-			up_read(&dc->writeback_lock);
+			/*
+			 * When contention happens on dc->writeback_lock with
+			 * the writeback thread, this kwork may be blocked for
+			 * very long time if there are too many dirty data to
+			 * writeback, and kerne message will complain a (bogus)
+			 * software lockup kernel message. To avoid potential
+			 * starving, if down_read_trylock() fails, writeback
+			 * rate updating will be skipped for dc->retry_max times
+			 * at most while delay this worker a bit longer time.
+			 * If dc->retry_max times are tried and the trylock
+			 * still fails, then call down_read() to wait for
+			 * dc->writeback_lock.
+			 */
+			if (!down_read_trylock((&dc->writeback_lock))) {
+				contention = true;
+
+				if (dc->retry_nr < dc->retry_max) {
+					dc->retry_nr++;
+				} else {
+					down_read(&dc->writeback_lock);
+					dc->retry_nr = 0;
+				}
+			}
+
+			if (!dc->retry_nr) {
+				__update_writeback_rate(dc);
+				update_gc_after_writeback(c);
+				up_read(&dc->writeback_lock);
+			}
 		}
 	}
 
+	/*
+	 * In case no lock contention on dc->writeback_lock happens since
+	 * last retry, e.g. cache is clean or I/O idle for a while.
+	 */
+	if (!contention && dc->retry_nr)
+		dc->retry_nr = 0;
 
 	/*
 	 * CACHE_SET_IO_DISABLE might be set via sysfs interface,
@@ -257,8 +290,10 @@ static void update_writeback_rate(struct work_struct *work)
 	 */
 	if (test_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags) &&
 	    !test_bit(CACHE_SET_IO_DISABLE, &c->flags)) {
+		unsigned int scale = 1 + dc->retry_nr;
+
 		schedule_delayed_work(&dc->writeback_rate_update,
-			      dc->writeback_rate_update_seconds * HZ);
+			dc->writeback_rate_update_seconds * scale * HZ);
 	}
 
 	/*
@@ -1032,6 +1067,10 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
 	dc->writeback_rate_fp_term_high = 1000;
 	dc->writeback_rate_i_term_inverse = 10000;
 
+	/* For dc->writeback_lock contention in update_writeback_rate() */
+	dc->retry_nr = 0;
+	dc->retry_max = 6;
+
 	WARN_ON(test_and_clear_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags));
 	INIT_DELAYED_WORK(&dc->writeback_rate_update, update_writeback_rate);
 }
-- 
2.34.1

