Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7999F34BEC
	for <lists+linux-bcache@lfdr.de>; Tue,  4 Jun 2019 17:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbfFDPRS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 4 Jun 2019 11:17:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:39624 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728079AbfFDPRR (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 4 Jun 2019 11:17:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C6FE6ACF5;
        Tue,  4 Jun 2019 15:17:16 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 13/15] bcache: add more error message in bch_cached_dev_attach()
Date:   Tue,  4 Jun 2019 23:16:22 +0800
Message-Id: <20190604151624.105150-14-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190604151624.105150-1-colyli@suse.de>
References: <20190604151624.105150-1-colyli@suse.de>
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
index 1fa3f4e26d02..cf5673af3143 100644
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

