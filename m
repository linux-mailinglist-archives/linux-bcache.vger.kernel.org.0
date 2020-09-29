Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A290E27BD47
	for <lists+linux-bcache@lfdr.de>; Tue, 29 Sep 2020 08:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbgI2Gqz (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 29 Sep 2020 02:46:55 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14701 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725826AbgI2Gqy (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 29 Sep 2020 02:46:54 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A8B1CDE4CE59BB406201
        for <linux-bcache@vger.kernel.org>; Tue, 29 Sep 2020 14:46:51 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Tue, 29 Sep 2020
 14:46:43 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <colyli@suse.de>, <kent.overstreet@gmail.com>,
        <yanaijie@huawei.com>, <linux-bcache@vger.kernel.org>
Subject: [PATCH] bcache: remove unused function closure_set_ret_ip()
Date:   Tue, 29 Sep 2020 14:47:41 +0800
Message-ID: <20200929064741.3604133-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This function has no caller after commit e4bf791937d8 ("bcache: Fix,
improve efficiency of closure_sync()").

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/md/bcache/closure.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/md/bcache/closure.h b/drivers/md/bcache/closure.h
index c88cdc4ae4ec..35f3f87f74e4 100644
--- a/drivers/md/bcache/closure.h
+++ b/drivers/md/bcache/closure.h
@@ -205,13 +205,6 @@ static inline void closure_set_ip(struct closure *cl)
 #endif
 }
 
-static inline void closure_set_ret_ip(struct closure *cl)
-{
-#ifdef CONFIG_BCACHE_CLOSURES_DEBUG
-	cl->ip = _RET_IP_;
-#endif
-}
-
 static inline void closure_set_waiting(struct closure *cl, unsigned long f)
 {
 #ifdef CONFIG_BCACHE_CLOSURES_DEBUG
-- 
2.25.4

