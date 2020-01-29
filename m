Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9CEE14D046
	for <lists+linux-bcache@lfdr.de>; Wed, 29 Jan 2020 19:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgA2SSK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 29 Jan 2020 13:18:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:43660 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726823AbgA2SSK (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 29 Jan 2020 13:18:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 925F4B28E;
        Wed, 29 Jan 2020 18:18:08 +0000 (UTC)
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     colyli@suse.de, kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dave@stgolabs.net, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH] bcache: optimize barrier usage for Rmw atomic bitops
Date:   Wed, 29 Jan 2020 10:08:02 -0800
Message-Id: <20200129180802.24626-1-dave@stgolabs.net>
X-Mailer: git-send-email 2.16.4
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

We can avoid the unnecessary barrier on non LL/SC architectures,
such as x86. Instead, use the smp_mb__after_atomic().

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 drivers/md/bcache/writeback.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 4a40f9eadeaf..284ff10f480f 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -183,7 +183,7 @@ static void update_writeback_rate(struct work_struct *work)
 	 */
 	set_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
 	/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
-	smp_mb();
+	smp_mb__after_atomic();
 
 	/*
 	 * CACHE_SET_IO_DISABLE might be set via sysfs interface,
@@ -193,7 +193,7 @@ static void update_writeback_rate(struct work_struct *work)
 	    test_bit(CACHE_SET_IO_DISABLE, &c->flags)) {
 		clear_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
 		/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
-		smp_mb();
+		smp_mb__after_atomic();
 		return;
 	}
 
@@ -229,7 +229,7 @@ static void update_writeback_rate(struct work_struct *work)
 	 */
 	clear_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
 	/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
-	smp_mb();
+	smp_mb__after_atomic();
 }
 
 static unsigned int writeback_delay(struct cached_dev *dc,
-- 
2.16.4

