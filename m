Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 393B6599E5
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Jun 2019 14:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfF1MCH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 28 Jun 2019 08:02:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:54882 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726841AbfF1MCH (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 28 Jun 2019 08:02:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 80C5DB627;
        Fri, 28 Jun 2019 12:02:06 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 29/37] bcache: shrink btree node cache after bch_btree_check()
Date:   Fri, 28 Jun 2019 19:59:52 +0800
Message-Id: <20190628120000.40753-30-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190628120000.40753-1-colyli@suse.de>
References: <20190628120000.40753-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

When cache set starts, bch_btree_check() will check all bkeys on cache
device by calculating the checksum. This operation will consume a huge
number of system memory if there are a lot of data cached. Since bcache
uses its own mca cache to maintain all its read-in btree nodes, and only
releases the cache space when system memory manage code starts to shrink
caches. Then before memory manager code to call the mca cache shrinker
callback, bcache mca cache will compete memory resource with user space
application, which may have nagive effect to performance of user space
workloads (e.g. data base, or I/O service of distributed storage node).

This patch tries to call bcache mca shrinker routine to proactively
release mca cache memory, to decrease the memory pressure of system and
avoid negative effort of the overall system I/O performance.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a8ea4e2086a9..26e374fbf57c 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1880,6 +1880,23 @@ static int run_cache_set(struct cache_set *c)
 		if (bch_btree_check(c))
 			goto err;
 
+		/*
+		 * bch_btree_check() may occupy too much system memory which
+		 * has negative effects to user space application (e.g. data
+		 * base) performance. Shrink the mca cache memory proactively
+		 * here to avoid competing memory with user space workloads..
+		 */
+		if (!c->shrinker_disabled) {
+			struct shrink_control sc;
+
+			sc.gfp_mask = GFP_KERNEL;
+			sc.nr_to_scan = c->btree_cache_used * c->btree_pages;
+			/* first run to clear b->accessed tag */
+			c->shrink.scan_objects(&c->shrink, &sc);
+			/* second run to reap non-accessed nodes */
+			c->shrink.scan_objects(&c->shrink, &sc);
+		}
+
 		bch_journal_mark(c, &journal);
 		bch_initial_gc_finish(c);
 		pr_debug("btree_check() done");
-- 
2.16.4

