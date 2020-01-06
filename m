Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD7F913159E
	for <lists+linux-bcache@lfdr.de>; Mon,  6 Jan 2020 17:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgAFQFN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 6 Jan 2020 11:05:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:42650 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbgAFQFN (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 6 Jan 2020 11:05:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C39AAB02C
        for <linux-bcache@vger.kernel.org>; Mon,  6 Jan 2020 16:05:11 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>
Subject: [RFC PATCH 3/7] bcache: reap from tail of c->btree_cache in bch_mca_scan()
Date:   Tue,  7 Jan 2020 00:04:52 +0800
Message-Id: <20200106160456.45689-4-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200106160456.45689-1-colyli@suse.de>
References: <20200106160456.45689-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

When shrink btree node cache from c->btree_cache in bch_mca_scan(),
no matter the selected node is reaped or not, it will be rotated from
the head to the tail of c->btree_cache list. But in bcache journal
code, when flushing the btree nodes with oldest journal entry, btree
nodes are iterated and slected from the tail of c->btree_cache list in
btree_flush_write(). The list_rotate_left() in bch_mca_scan() will
make btree_flush_write() iterate more nodes in c->btree_list in reverse
order.

This patch just reaps the selected btree node cache, and not move it
from the head to the tail of c->btree_cache list. Then bch_mca_scan()
will not mess up c->btree_cache list to btree_flush_write().

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/btree.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index c3a314deb09d..fa872df4e770 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -747,19 +747,19 @@ static unsigned long bch_mca_scan(struct shrinker *shrink,
 		i++;
 	}
 
-	for (;  (nr--) && i < btree_cache_used; i++) {
-		if (list_empty(&c->btree_cache))
+	list_for_each_entry_safe_reverse(b, t, &c->btree_cache, list) {
+		if (nr <= 0 || i >= btree_cache_used)
 			goto out;
 
-		b = list_first_entry(&c->btree_cache, struct btree, list);
-		list_rotate_left(&c->btree_cache);
-
 		if (!mca_reap(b, 0, false)) {
 			mca_bucket_free(b);
 			mca_data_free(b);
 			rw_unlock(true, b);
 			freed++;
 		}
+
+		nr--;
+		i++;
 	}
 out:
 	mutex_unlock(&c->bucket_lock);
-- 
2.16.4

