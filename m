Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2EB13159D
	for <lists+linux-bcache@lfdr.de>; Mon,  6 Jan 2020 17:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgAFQFL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 6 Jan 2020 11:05:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:42642 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbgAFQFL (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 6 Jan 2020 11:05:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8D47CAD6F
        for <linux-bcache@vger.kernel.org>; Mon,  6 Jan 2020 16:05:09 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>
Subject: [RFC PATCH 2/7] bcache: reap c->btree_cache_freeable from the tail in bch_mca_scan()
Date:   Tue,  7 Jan 2020 00:04:51 +0800
Message-Id: <20200106160456.45689-3-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200106160456.45689-1-colyli@suse.de>
References: <20200106160456.45689-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In order to skip the most recently freed btree node cahce, currently
in bch_mca_scan() the first 3 caches in c->btree_cache_freeable list
are skipped when shrinking bcache node caches in bch_mca_scan(). The
related code in bch_mca_scan() is,

 737 list_for_each_entry_safe(b, t, &c->btree_cache_freeable, list) {
 738         if (nr <= 0)
 739                 goto out;
 740
 741         if (++i > 3 &&
 742             !mca_reap(b, 0, false)) {
             		lines free cache memory
 746         }
 747         nr--;
 748 }

The problem is, if virtual memory code calls bch_mca_scan() and
the calculated 'nr' is 1 or 2, then in the above loop, nothing will
be shunk. In such case, if slub/slab manager calls bch_mca_scan()
for many times with small scan number, it does not help to shrink
cache memory and just wasts CPU cycles.

This patch just selects btree node caches from tail of the
c->btree_cache_freeable list, then the newly freed host cache can
still be allocated by mca_alloc(), and at least 1 node can be shunk.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/btree.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 357535a5c89c..c3a314deb09d 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -734,17 +734,17 @@ static unsigned long bch_mca_scan(struct shrinker *shrink,
 
 	i = 0;
 	btree_cache_used = c->btree_cache_used;
-	list_for_each_entry_safe(b, t, &c->btree_cache_freeable, list) {
+	list_for_each_entry_safe_reverse(b, t, &c->btree_cache_freeable, list) {
 		if (nr <= 0)
 			goto out;
 
-		if (++i > 3 &&
-		    !mca_reap(b, 0, false)) {
+		if (!mca_reap(b, 0, false)) {
 			mca_data_free(b);
 			rw_unlock(true, b);
 			freed++;
 		}
 		nr--;
+		i++;
 	}
 
 	for (;  (nr--) && i < btree_cache_used; i++) {
-- 
2.16.4

