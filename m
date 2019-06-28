Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4774599C6
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Jun 2019 14:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfF1MBL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 28 Jun 2019 08:01:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:54486 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726957AbfF1MBL (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 28 Jun 2019 08:01:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5E0E3B627;
        Fri, 28 Jun 2019 12:01:10 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 15/37] bcache: add more error message in bch_cached_dev_attach()
Date:   Fri, 28 Jun 2019 19:59:38 +0800
Message-Id: <20190628120000.40753-16-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190628120000.40753-1-colyli@suse.de>
References: <20190628120000.40753-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch adds more error message for attaching cached device, this is
helpful to debug code failure during bache device start up.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index d4d8d1300faf..a836910ef368 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1169,6 +1169,8 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 	down_write(&dc->writeback_lock);
 	if (bch_cached_dev_writeback_start(dc)) {
 		up_write(&dc->writeback_lock);
+		pr_err("Couldn't start writeback facilities for %s",
+		       dc->disk.disk->disk_name);
 		return -ENOMEM;
 	}
 
@@ -1182,6 +1184,8 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 	ret = bch_cached_dev_run(dc);
 	if (ret && (ret != -EBUSY)) {
 		up_write(&dc->writeback_lock);
+		pr_err("Couldn't run cached device %s",
+		       dc->backing_dev_name);
 		return ret;
 	}
 
-- 
2.16.4

