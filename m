Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7C35FCF71
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Oct 2022 02:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbiJMASO (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 12 Oct 2022 20:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiJMARn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 12 Oct 2022 20:17:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07035197F90;
        Wed, 12 Oct 2022 17:17:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4FBD616C3;
        Thu, 13 Oct 2022 00:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63019C433B5;
        Thu, 13 Oct 2022 00:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620222;
        bh=pyFqEjCsJm/B3AhoMs/+9UBXpGWPBTmE33Qm6IaChXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hb+x7ma/xB1r6VtzODtR8VRi7s1qktFY6oJAzH47PFN2psjHuFowCerhcFmL7WJGp
         B3EoDuhabEhwdNj70m8XCJAJ/pVgEcQWjXsG72XC3CYTrog5Bkd2ysHv0B+IBTj3/Z
         rOQwYuJeiRC+ZcGvGOqD+YhbBdsck66BKC2iT95WpfNwl8Twtn+fAuL0PpVD1Gku/n
         Y9eselOMMkQD2+ds8WWMu+NtWG0fJX7waoYuzIBD/hDKS96EOh1ezc/AV7FglCu8v7
         8Z6yl2PGnLi6AwbTFTarN0RLnJhoMq8/VpZxgUw9uTnmCeGL8JZzm0J4CeGqu3y8Xd
         K6TJVdpDKI8Nw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Mingzhe Zou <mingzhe.zou@easystack.cn>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 27/67] bcache: fix set_at_max_writeback_rate() for multiple attached devices
Date:   Wed, 12 Oct 2022 20:15:08 -0400
Message-Id: <20221013001554.1892206-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001554.1892206-1-sashal@kernel.org>
References: <20221013001554.1892206-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit d2d05b88035d2d51a5bb6c5afec88a0880c73df4 ]

Inside set_at_max_writeback_rate() the calculation in following if()
check is wrong,
	if (atomic_inc_return(&c->idle_counter) <
	    atomic_read(&c->attached_dev_nr) * 6)

Because each attached backing device has its own writeback thread
running and increasing c->idle_counter, the counter increates much
faster than expected. The correct calculation should be,
	(counter / dev_nr) < dev_nr * 6
which equals to,
	counter < dev_nr * dev_nr * 6

This patch fixes the above mistake with correct calculation, and helper
routine idle_counter_exceeded() is added to make code be more clear.

Reported-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
Signed-off-by: Coly Li <colyli@suse.de>
Acked-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
Link: https://lore.kernel.org/r/20220919161647.81238-6-colyli@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/writeback.c | 73 +++++++++++++++++++++++++----------
 1 file changed, 52 insertions(+), 21 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 3f0ff3aab6f2..9c227e4a8465 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -157,6 +157,53 @@ static void __update_writeback_rate(struct cached_dev *dc)
 	dc->writeback_rate_target = target;
 }
 
+static bool idle_counter_exceeded(struct cache_set *c)
+{
+	int counter, dev_nr;
+
+	/*
+	 * If c->idle_counter is overflow (idel for really long time),
+	 * reset as 0 and not set maximum rate this time for code
+	 * simplicity.
+	 */
+	counter = atomic_inc_return(&c->idle_counter);
+	if (counter <= 0) {
+		atomic_set(&c->idle_counter, 0);
+		return false;
+	}
+
+	dev_nr = atomic_read(&c->attached_dev_nr);
+	if (dev_nr == 0)
+		return false;
+
+	/*
+	 * c->idle_counter is increased by writeback thread of all
+	 * attached backing devices, in order to represent a rough
+	 * time period, counter should be divided by dev_nr.
+	 * Otherwise the idle time cannot be larger with more backing
+	 * device attached.
+	 * The following calculation equals to checking
+	 *	(counter / dev_nr) < (dev_nr * 6)
+	 */
+	if (counter < (dev_nr * dev_nr * 6))
+		return false;
+
+	return true;
+}
+
+/*
+ * Idle_counter is increased every time when update_writeback_rate() is
+ * called. If all backing devices attached to the same cache set have
+ * identical dc->writeback_rate_update_seconds values, it is about 6
+ * rounds of update_writeback_rate() on each backing device before
+ * c->at_max_writeback_rate is set to 1, and then max wrteback rate set
+ * to each dc->writeback_rate.rate.
+ * In order to avoid extra locking cost for counting exact dirty cached
+ * devices number, c->attached_dev_nr is used to calculate the idle
+ * throushold. It might be bigger if not all cached device are in write-
+ * back mode, but it still works well with limited extra rounds of
+ * update_writeback_rate().
+ */
 static bool set_at_max_writeback_rate(struct cache_set *c,
 				       struct cached_dev *dc)
 {
@@ -167,21 +214,8 @@ static bool set_at_max_writeback_rate(struct cache_set *c,
 	/* Don't set max writeback rate if gc is running */
 	if (!c->gc_mark_valid)
 		return false;
-	/*
-	 * Idle_counter is increased everytime when update_writeback_rate() is
-	 * called. If all backing devices attached to the same cache set have
-	 * identical dc->writeback_rate_update_seconds values, it is about 6
-	 * rounds of update_writeback_rate() on each backing device before
-	 * c->at_max_writeback_rate is set to 1, and then max wrteback rate set
-	 * to each dc->writeback_rate.rate.
-	 * In order to avoid extra locking cost for counting exact dirty cached
-	 * devices number, c->attached_dev_nr is used to calculate the idle
-	 * throushold. It might be bigger if not all cached device are in write-
-	 * back mode, but it still works well with limited extra rounds of
-	 * update_writeback_rate().
-	 */
-	if (atomic_inc_return(&c->idle_counter) <
-	    atomic_read(&c->attached_dev_nr) * 6)
+
+	if (!idle_counter_exceeded(c))
 		return false;
 
 	if (atomic_read(&c->at_max_writeback_rate) != 1)
@@ -195,13 +229,10 @@ static bool set_at_max_writeback_rate(struct cache_set *c,
 	dc->writeback_rate_change = 0;
 
 	/*
-	 * Check c->idle_counter and c->at_max_writeback_rate agagain in case
-	 * new I/O arrives during before set_at_max_writeback_rate() returns.
-	 * Then the writeback rate is set to 1, and its new value should be
-	 * decided via __update_writeback_rate().
+	 * In case new I/O arrives during before
+	 * set_at_max_writeback_rate() returns.
 	 */
-	if ((atomic_read(&c->idle_counter) <
-	     atomic_read(&c->attached_dev_nr) * 6) ||
+	if (!idle_counter_exceeded(c) ||
 	    !atomic_read(&c->at_max_writeback_rate))
 		return false;
 
-- 
2.35.1

