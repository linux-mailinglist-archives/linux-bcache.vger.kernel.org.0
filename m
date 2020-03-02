Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13671175735
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Mar 2020 10:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbgCBJfG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 2 Mar 2020 04:35:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:35696 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727198AbgCBJfG (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 2 Mar 2020 04:35:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E9929AD77;
        Mon,  2 Mar 2020 09:35:03 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        hare@suse.de, mhocko@suse.com, mkoutny@suse.com,
        Coly Li <colyli@suse.de>
Subject: [PATCH 2/2] bcache: fix code comments for ignore pending signals
Date:   Mon,  2 Mar 2020 17:34:50 +0800
Message-Id: <20200302093450.48016-3-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200302093450.48016-1-colyli@suse.de>
References: <20200302093450.48016-1-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Commit 0b96da639a48 ("bcache: ignore pending signals when creating gc
and allocator thread") explains the ignoring signal is sent from OOM
killer, which was wrong. Michal Koutný, Michal Hocko and Hannes Reinecke
point out the bcache registration process might be killed by udevd other
than the OOM killer during the system boot time due to timeout.

After more diagnose, it turns out the registration process has pending
signal after exuected for 180 seconds. Now I believe the killing signal
is indeed from udevd by the following reasons,
- The signal is only received in system boot time. If register bcache
  device in command line after boot up, no pending signal received.
  the automatic bcache registration in boot up time is performed by
  udev rule only.
- The udevd has a default timeout as 180 seconds, if a rule execution
  is not finished within 180 seconds, it will try to kill the task.
  The timeout is exactly same as the seconds I observe when bcache
  registration process receives signal.

This patch does not change executable code, just changes code comments
for why flush_signals() should be called before creating bcache gc and
allocator kernel thread, to explain things in correct way.

Fixes: 0b96da639a48 ("bcache: ignore pending signals when creating gc and allocator thread")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
---
 drivers/md/bcache/alloc.c | 14 +++++++-------
 drivers/md/bcache/btree.c | 14 +++++++-------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 8bc1faf71ff2..2cb4db87bded 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -737,13 +737,13 @@ int bch_cache_allocator_start(struct cache *ca)
 	struct task_struct *k;
 
 	/*
-	 * In case previous btree check operation occupies too many
-	 * system memory for bcache btree node cache, and the
-	 * registering process is selected by OOM killer. Here just
-	 * ignore the SIGKILL sent by OOM killer if there is, to
-	 * avoid kthread_run() being failed by pending signals. The
-	 * bcache registering process will exit after the registration
-	 * done.
+	 * In case previous btree check operation takes too long time
+	 * for bcache btree node cache, if the registration process is
+	 * executed from a bcache udev rule and killed by udevd due to
+	 * timeout (default as 180s) in system boot time, here just
+	 * ignore the signal sent by udev if there is, to avoid
+	 * kthread_run() being failed by pending signals. The bcache
+	 * registering process will exit after the registration done.
 	 */
 	if (signal_pending(current))
 		flush_signals(current);
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index b12186c87f52..8c428e318990 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1915,13 +1915,13 @@ static int bch_gc_thread(void *arg)
 int bch_gc_thread_start(struct cache_set *c)
 {
 	/*
-	 * In case previous btree check operation occupies too many
-	 * system memory for bcache btree node cache, and the
-	 * registering process is selected by OOM killer. Here just
-	 * ignore the SIGKILL sent by OOM killer if there is, to
-	 * avoid kthread_run() being failed by pending signals. The
-	 * bcache registering process will exit after the registration
-	 * done.
+	 * In case previous btree check operation takes too long time
+	 * for bcache btree node cache, if the registration process is
+	 * executed from a bcache udev rule and killed by udevd due to
+	 * timeout (default as 180s) in system boot time, here just
+	 * ignore the signal sent by udev if there is, to avoid
+	 * kthread_run() being failed by pending signals. The bcache
+	 * registering process will exit after the registration done.
 	 */
 	if (signal_pending(current))
 		flush_signals(current);
-- 
2.16.4

