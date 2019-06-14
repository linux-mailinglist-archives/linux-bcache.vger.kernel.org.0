Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8603C45DD1
	for <lists+linux-bcache@lfdr.de>; Fri, 14 Jun 2019 15:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbfFNNPW (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 14 Jun 2019 09:15:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:46172 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727956AbfFNNPW (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 14 Jun 2019 09:15:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E2747AE07;
        Fri, 14 Jun 2019 13:15:20 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 21/29] bcache: add more error message in bch_cached_dev_attach()
Date:   Fri, 14 Jun 2019 21:13:50 +0800
Message-Id: <20190614131358.2771-22-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190614131358.2771-1-colyli@suse.de>
References: <20190614131358.2771-1-colyli@suse.de>
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

