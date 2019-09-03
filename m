Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76FAFA69C5
	for <lists+linux-bcache@lfdr.de>; Tue,  3 Sep 2019 15:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbfICNZ5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 3 Sep 2019 09:25:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:34402 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729117AbfICNZ4 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 3 Sep 2019 09:25:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 767B4AF38;
        Tue,  3 Sep 2019 13:25:55 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 1/3] bcache: add cond_resched() in __bch_cache_cmp()
Date:   Tue,  3 Sep 2019 21:25:43 +0800
Message-Id: <20190903132545.30059-2-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190903132545.30059-1-colyli@suse.de>
References: <20190903132545.30059-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Shile Zhang <shile.zhang@linux.alibaba.com>

Read /sys/fs/bcache/<uuid>/cacheN/priority_stats can take very long
time with huge cache after long run.

Signed-off-by: Shile Zhang <shile.zhang@linux.alibaba.com>
Tested-by: Heitor Alves de Siqueira <halves@canonical.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index e2059af90791..627dcea0f5b6 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -964,6 +964,7 @@ KTYPE(bch_cache_set_internal);
 
 static int __bch_cache_cmp(const void *l, const void *r)
 {
+	cond_resched();
 	return *((uint16_t *)r) - *((uint16_t *)l);
 }
 
-- 
2.16.4

