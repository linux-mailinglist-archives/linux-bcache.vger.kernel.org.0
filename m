Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75B75BD20B
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Sep 2022 18:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiISQRu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 19 Sep 2022 12:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiISQRr (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 19 Sep 2022 12:17:47 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAAE83AB0B;
        Mon, 19 Sep 2022 09:17:42 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id DA69621AC2;
        Mon, 19 Sep 2022 16:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663604260; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yavwVdcOwkRxq1Ojd2Q5m3eBvPT2tJIyu1OTolveTFg=;
        b=Id/6pHorgKV/uVLtSDuL6dNJbNYvLeDHqBhywBS5tKkRIvASI71aDhom3pbjo9ZlbUso33
        YFxLZ9bowWDIbenZWMf6NvZ8oJOSbzaOmYYp7PaSJw8fUEWospbUaeBafMfc0j4fPYUXHG
        IX7MfvOfFDAxf4NH5/nBPN3kanZ1neI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663604260;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yavwVdcOwkRxq1Ojd2Q5m3eBvPT2tJIyu1OTolveTFg=;
        b=QpPl8hDmepPD/m4FEGIjeV7ha0adbbyB5ysqmZUh+DyuE8cTfFWNUdpcihQ/CshDOK2Sl0
        cSppWng/hMtfpuCA==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 83DEE2C141;
        Mon, 19 Sep 2022 16:17:36 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>,
        Mingzhe Zou <mingzhe.zou@easystack.cn>
Subject: [PATCH 5/5] bcache: fix set_at_max_writeback_rate() for multiple attached devices
Date:   Tue, 20 Sep 2022 00:16:47 +0800
Message-Id: <20220919161647.81238-6-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220919161647.81238-1-colyli@suse.de>
References: <20220919161647.81238-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

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
---
 drivers/md/bcache/writeback.c | 73 +++++++++++++++++++++++++----------
 1 file changed, 52 insertions(+), 21 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 647661005176..c186bf55fe61 100644
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
2.35.3

