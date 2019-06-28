Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3951599D7
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Jun 2019 14:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbfF1MBj (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 28 Jun 2019 08:01:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:54736 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726810AbfF1MBj (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 28 Jun 2019 08:01:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 09DB2B62B;
        Fri, 28 Jun 2019 12:01:38 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 22/37] bcache: stop writeback kthread and kworker when bch_cached_dev_run() failed
Date:   Fri, 28 Jun 2019 19:59:45 +0800
Message-Id: <20190628120000.40753-23-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190628120000.40753-1-colyli@suse.de>
References: <20190628120000.40753-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In bch_cached_dev_attach() after bch_cached_dev_writeback_start()
called, the wrireback kthread and writeback rate update kworker of the
cached device are created, if the following bch_cached_dev_run()
failed, bch_cached_dev_attach() will return with -ENOMEM without
stopping the writeback related kthread and kworker.

This patch stops writeback kthread and writeback rate update kworker
before returning -ENOMEM if bch_cached_dev_run() returns error.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index c4c4b2d99dc2..791cb930b353 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1189,6 +1189,14 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 	ret = bch_cached_dev_run(dc);
 	if (ret && (ret != -EBUSY)) {
 		up_write(&dc->writeback_lock);
+		/*
+		 * bch_register_lock is held, bcache_device_stop() is not
+		 * able to be directly called. The kthread and kworker
+		 * created previously in bch_cached_dev_writeback_start()
+		 * have to be stopped manually here.
+		 */
+		kthread_stop(dc->writeback_thread);
+		cancel_writeback_rate_update_dwork(dc);
 		pr_err("Couldn't run cached device %s",
 		       dc->backing_dev_name);
 		return ret;
-- 
2.16.4

