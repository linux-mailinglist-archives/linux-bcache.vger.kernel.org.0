Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0A65B9A50
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Sep 2022 14:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiIOMFx (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 15 Sep 2022 08:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiIOMFw (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 15 Sep 2022 08:05:52 -0400
Received: from mail-m31106.qiye.163.com (mail-m31106.qiye.163.com [103.74.31.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BCB74E1A
        for <linux-bcache@vger.kernel.org>; Thu, 15 Sep 2022 05:05:47 -0700 (PDT)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m31106.qiye.163.com (Hmail) with ESMTPA id 6C43FA140F;
        Thu, 15 Sep 2022 20:05:45 +0800 (CST)
From:   mingzhe.zou@easystack.cn
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     zoumingzhe@qq.com
Subject: [PATCH] bcache: set cool backing device to maximum writeback rate
Date:   Thu, 15 Sep 2022 20:05:44 +0800
Message-Id: <20220915120544.9086-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkZSE5OVkJLTEhOSk4fSRkfGFUZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hKTFVKS0tVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OBA6HDo5GDIKFTU5AyEuIgoc
        KwhPCh9VSlVKTU1ISU9ITk9OQ09NVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBTkNMSDcG
X-HM-Tid: 0a83410a6bbf00fekurm6c43fa140f
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: mingzhe <mingzhe.zou@easystack.cn>

If the data in the cache is dirty, gc thread cannot reclaim the space.
We need to writeback dirty data to backing, and then gc can reclaim
this area. So bcache will writeback dirty data more aggressively.

Currently, there is no io request within 30 seconds of the cache_set,
all backing devices in it will be set to the maximum writeback rate.

However, for multiple backings in the same cache_set, there maybe both
cold and hot devices. Since the cold device has no read or write requests,
dirty data should writeback as soon as possible.

This patch reduces the control granularity of set_at_max_writeback_rate()
from cache_set to cached_dev. Because even cache_set still has io requests,
writeback cold data can make more space for hot data.

Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/bcache.h    |  5 +++--
 drivers/md/bcache/request.c   | 10 +++++-----
 drivers/md/bcache/writeback.c | 16 +++++++---------
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index f4436229cd83..768bb217e156 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -330,6 +330,9 @@ struct cached_dev {
 	 */
 	atomic_t		has_dirty;
 
+	atomic_t		idle_counter;
+	atomic_t		at_max_writeback_rate;
+
 #define BCH_CACHE_READA_ALL		0
 #define BCH_CACHE_READA_META_ONLY	1
 	unsigned int		cache_readahead_policy;
@@ -520,8 +523,6 @@ struct cache_set {
 	struct cache_accounting accounting;
 
 	unsigned long		flags;
-	atomic_t		idle_counter;
-	atomic_t		at_max_writeback_rate;
 
 	struct cache		*cache;
 
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index f2c5a7e06fa9..f53b5831f500 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1141,7 +1141,7 @@ static void quit_max_writeback_rate(struct cache_set *c,
 	 * To avoid such situation, if mutext_trylock() failed, only writeback
 	 * rate of current cached device is set to 1, and __update_write_back()
 	 * will decide writeback rate of other cached devices (remember now
-	 * c->idle_counter is 0 already).
+	 * dc->idle_counter is 0 already).
 	 */
 	if (mutex_trylock(&bch_register_lock)) {
 		for (i = 0; i < c->devices_max_used; i++) {
@@ -1184,16 +1184,16 @@ void cached_dev_submit_bio(struct bio *bio)
 	}
 
 	if (likely(d->c)) {
-		if (atomic_read(&d->c->idle_counter))
-			atomic_set(&d->c->idle_counter, 0);
+		if (atomic_read(&dc->idle_counter))
+			atomic_set(&dc->idle_counter, 0);
 		/*
 		 * If at_max_writeback_rate of cache set is true and new I/O
 		 * comes, quit max writeback rate of all cached devices
 		 * attached to this cache set, and set at_max_writeback_rate
 		 * to false.
 		 */
-		if (unlikely(atomic_read(&d->c->at_max_writeback_rate) == 1)) {
-			atomic_set(&d->c->at_max_writeback_rate, 0);
+		if (unlikely(atomic_read(&dc->at_max_writeback_rate) == 1)) {
+			atomic_set(&dc->at_max_writeback_rate, 0);
 			quit_max_writeback_rate(d->c, dc);
 		}
 	}
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 3f0ff3aab6f2..40e10fd3552e 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -172,7 +172,7 @@ static bool set_at_max_writeback_rate(struct cache_set *c,
 	 * called. If all backing devices attached to the same cache set have
 	 * identical dc->writeback_rate_update_seconds values, it is about 6
 	 * rounds of update_writeback_rate() on each backing device before
-	 * c->at_max_writeback_rate is set to 1, and then max wrteback rate set
+	 * dc->at_max_writeback_rate is set to 1, and then max wrteback rate set
 	 * to each dc->writeback_rate.rate.
 	 * In order to avoid extra locking cost for counting exact dirty cached
 	 * devices number, c->attached_dev_nr is used to calculate the idle
@@ -180,12 +180,11 @@ static bool set_at_max_writeback_rate(struct cache_set *c,
 	 * back mode, but it still works well with limited extra rounds of
 	 * update_writeback_rate().
 	 */
-	if (atomic_inc_return(&c->idle_counter) <
-	    atomic_read(&c->attached_dev_nr) * 6)
+	if (atomic_inc_return(&dc->idle_counter) < 6)
 		return false;
 
-	if (atomic_read(&c->at_max_writeback_rate) != 1)
-		atomic_set(&c->at_max_writeback_rate, 1);
+	if (atomic_read(&dc->at_max_writeback_rate) != 1)
+		atomic_set(&dc->at_max_writeback_rate, 1);
 
 	atomic_long_set(&dc->writeback_rate.rate, INT_MAX);
 
@@ -195,14 +194,13 @@ static bool set_at_max_writeback_rate(struct cache_set *c,
 	dc->writeback_rate_change = 0;
 
 	/*
-	 * Check c->idle_counter and c->at_max_writeback_rate agagain in case
+	 * Check dc->idle_counter and dc->at_max_writeback_rate agagain in case
 	 * new I/O arrives during before set_at_max_writeback_rate() returns.
 	 * Then the writeback rate is set to 1, and its new value should be
 	 * decided via __update_writeback_rate().
 	 */
-	if ((atomic_read(&c->idle_counter) <
-	     atomic_read(&c->attached_dev_nr) * 6) ||
-	    !atomic_read(&c->at_max_writeback_rate))
+	if ((atomic_read(&dc->idle_counter) < 6) ||
+	    !atomic_read(&dc->at_max_writeback_rate))
 		return false;
 
 	return true;
-- 
2.17.1

