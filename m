Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B14D134BEE
	for <lists+linux-bcache@lfdr.de>; Tue,  4 Jun 2019 17:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbfFDPRV (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 4 Jun 2019 11:17:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:39656 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728079AbfFDPRV (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 4 Jun 2019 11:17:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1279CACF5;
        Tue,  4 Jun 2019 15:17:20 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 14/15] bcache: shrink btree node cache after bch_btree_check()
Date:   Tue,  4 Jun 2019 23:16:23 +0800
Message-Id: <20190604151624.105150-15-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190604151624.105150-1-colyli@suse.de>
References: <20190604151624.105150-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

When cache set starts, bch_btree_check() will check all bkeys on cache
device by calculating the checksum. This operation will consume a huge
number of system memory if there are a lot of data cached. Since bcache
uses its own mca cache to maintain all its read-in btree nodes, and only
releases the cache space when system memory manage code starts to shrink
caches. There is will be a delay between bch_btree_check() returns and
the bcache shrink code gets called, so following memory allocatiion
might fail after bch_btree_check() finished. The most frequent one is
failure of creating allocator kernel thread.

This patch tries to proactively call bcache mca shrinker routine to
release around 25% cache memory, to help following memory allocation
to success. 'Around 25% cache memory' means when mca shrnker tries to
release cache memory, it might have to skip some busy memory objects,
so the result might be a few less than the expected amount.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index cf5673af3143..4a6406b53de1 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1866,6 +1866,24 @@ static int run_cache_set(struct cache_set *c)
 		if (bch_btree_check(c))
 			goto err;
 
+		/*
+		 * bch_btree_check() may occupy too much system memory which
+		 * will fail memory allocation operations in the following
+		 * routines before kernel triggers memory shrinker call backs.
+		 * Shrinking 25% mca cache memory proactively here to avoid
+		 * potential memory allocation failure.
+		 */
+		if (!c->shrinker_disabled) {
+			struct shrink_control sc;
+
+			sc.gfp_mask = GFP_KERNEL;
+			sc.nr_to_scan =
+				c->shrink.count_objects(&c->shrink, &sc) / 4;
+			pr_debug("try to shrink %lu (25%%) cached btree node",
+				 sc.nr_to_scan);
+			c->shrink.scan_objects(&c->shrink, &sc);
+		}
+
 		bch_journal_mark(c, &journal);
 		bch_initial_gc_finish(c);
 		pr_debug("btree_check() done");
-- 
2.16.4

