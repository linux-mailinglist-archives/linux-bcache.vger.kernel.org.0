Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1757743FC01
	for <lists+linux-bcache@lfdr.de>; Fri, 29 Oct 2021 14:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhJ2MJK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 29 Oct 2021 08:09:10 -0400
Received: from mail.wangsu.com ([123.103.51.227]:36553 "EHLO wangsu.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S230273AbhJ2MJJ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 29 Oct 2021 08:09:09 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Oct 2021 08:09:08 EDT
Received: from fedora33.wangsu.com (unknown [59.61.78.138])
        by app2 (Coremail) with SMTP id 4zNnewDX3i434nthxgcDAA--.1504S2;
        Fri, 29 Oct 2021 19:59:56 +0800 (CST)
From:   Lin Feng <linf@wangsu.com>
To:     colyli@suse.de, ent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linf@wangsu.com
Subject: [PATCH] bcache: remove unused struct member in cache_stats
Date:   Fri, 29 Oct 2021 19:59:39 +0800
Message-Id: <20211029115939.92309-1-linf@wangsu.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: 4zNnewDX3i434nthxgcDAA--.1504S2
X-Coremail-Antispam: 1UD129KBjvdXoW7JFy3GF47WFW8GFWkWrWrGrg_yoW3Zwc_Z3
        W0qF1xWr4YqrsIg3W3Xry3X3y0qa4DZFyv93Z2qr1SvryfZryxWF1Fgw17Ary5Zr4Yk3W2
        vryfX34rCw10kjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJ3UbIYCTnIWIevJa73UjIFyTuYvj4RJUUUUUUUU
X-CM-SenderInfo: holqwq5zdqw23xof0z/
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Commit 1616a4c2ab1a80893b6890ae93da40a2b1d0c691
("bcache: remove bcache device self-defined readahead")
remove stuffs for bcache self-defined readahead, but
cache_readaheads field in cache_stats is leftout, remove it.

Signed-off-by: Lin Feng <linf@wangsu.com>
---
 drivers/md/bcache/stats.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/bcache/stats.h b/drivers/md/bcache/stats.h
index ca4f435f7216..b6bfea66c01f 100644
--- a/drivers/md/bcache/stats.h
+++ b/drivers/md/bcache/stats.h
@@ -18,7 +18,6 @@ struct cache_stats {
 	unsigned long cache_misses;
 	unsigned long cache_bypass_hits;
 	unsigned long cache_bypass_misses;
-	unsigned long cache_readaheads;
 	unsigned long cache_miss_collisions;
 	unsigned long sectors_bypassed;
 
-- 
2.31.1

