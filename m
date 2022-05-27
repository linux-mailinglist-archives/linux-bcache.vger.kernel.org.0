Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC465364B6
	for <lists+linux-bcache@lfdr.de>; Fri, 27 May 2022 17:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353616AbiE0PcD (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 May 2022 11:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353408AbiE0PcC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 May 2022 11:32:02 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E68F2A706;
        Fri, 27 May 2022 08:32:00 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 5D00E21A96;
        Fri, 27 May 2022 15:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653665519; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mGAm6XwUC21DZwBnhAQtATzQHpXHm4XfYMxwjjPoB3E=;
        b=ARz6kjuV/zV4yTRWaHhi1bUsAi/PwC5UeN3+/r8iNqtuT9D1J1efQkHNBbNRi5qhbv71Dm
        T04VNgs8TlKGqFECSOLC1GHo+7Zz17byVXMxtmFs6TANhAl8Wkoxw/DlNPgWYngbZQjgIt
        4OYLJx/T4DJ6hChNKQ9mzzzFkTtzpzA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653665519;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mGAm6XwUC21DZwBnhAQtATzQHpXHm4XfYMxwjjPoB3E=;
        b=6Zt0dnfUW3iKrp7BVuWN5a5MM44RHIci5cJBADHAIH2XjMMlruc7mcKBvnENjMVJ73OFdA
        TPxTpSPnXghvW5Cg==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 6927F2C141;
        Fri, 27 May 2022 15:31:44 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 2/3] bcache: avoid unnecessary soft lockup in kworker update_writeback_rate()
Date:   Fri, 27 May 2022 23:28:17 +0800
Message-Id: <20220527152818.27545-3-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220527152818.27545-1-colyli@suse.de>
References: <20220527152818.27545-1-colyli@suse.de>
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
- Add new members to struct cached_dev
  - dc->retry_nr (0 by default)
  - dc->retry_max (5 by default)
- In update_writeback_rate() call down_read_trylock(&dc->writeback_lock)
  firstly, if it fails then lock contention happens. Then dc->retry_nr
  adds 1, and mark contention as true
- If dc->retry_nr <= dc->retry_max, give up updating the writeback rate
  and reschedules the kworker to retry after a longer time.
- If dc->retry_nr > dc->retry_max, no retry anymore and call
  down_read(&dc->writeback_lock) to wait for the lock.

By the above method, at worst case update_writeback_rate() may retry for
1+ minutes before blocking on dc->writeback_lock by calling down_read().
For a 4TB cache device with 1TB dirty data, 90%+ of the unnecessary soft
lockup warning message can be avoided.

When retrying to acquire dc->writeback_lock in update_writeback_rate(),
of course the writeback rate cannot be updated. It is fair, because when
the kworker is blocked on the lock contention of dc->writeback_lock, the
writeback rate cannot be updated neither.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/bcache.h    |  7 ++++++
 drivers/md/bcache/writeback.c | 45 +++++++++++++++++++++++++++++++----
 2 files changed, 47 insertions(+), 5 deletions(-)

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
index d138a2d73240..c51671abe74e 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -214,6 +214,7 @@ static void update_writeback_rate(struct work_struct *work)
 					     struct cached_dev,
 					     writeback_rate_update);
 	struct cache_set *c = dc->disk.c;
+	bool contention = false;
 
 	/*
 	 * should check BCACHE_DEV_RATE_DW_RUNNING before calling
@@ -243,13 +244,41 @@ static void update_writeback_rate(struct work_struct *work)
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
+				dc->retry_nr++;
+				if (dc->retry_nr > dc->retry_max)
+					down_read(&dc->writeback_lock);
+			}
+
+			if (!contention || dc->retry_nr > dc->retry_max) {
+				__update_writeback_rate(dc);
+				update_gc_after_writeback(c);
+				up_read(&dc->writeback_lock);
+				dc->retry_nr = 0;
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
@@ -257,8 +286,10 @@ static void update_writeback_rate(struct work_struct *work)
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
@@ -1006,6 +1037,10 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
 	dc->writeback_rate_fp_term_high = 1000;
 	dc->writeback_rate_i_term_inverse = 10000;
 
+	/* For dc->writeback_lock contention in update_writeback_rate() */
+	dc->retry_nr = 0;
+	dc->retry_max = 5;
+
 	WARN_ON(test_and_clear_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags));
 	INIT_DELAYED_WORK(&dc->writeback_rate_update, update_writeback_rate);
 }
-- 
2.35.3

