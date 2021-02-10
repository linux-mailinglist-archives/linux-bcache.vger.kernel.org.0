Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1BD315EA5
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Feb 2021 06:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhBJFJc (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Feb 2021 00:09:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:40714 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230308AbhBJFJ1 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Feb 2021 00:09:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 22E37B062;
        Wed, 10 Feb 2021 05:08:12 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Joe Perches <joe@perches.com>, Coly Li <colyli@suse.de>
Subject: [PATCH 06/20] bcache: Avoid comma separated statements
Date:   Wed, 10 Feb 2021 13:07:28 +0800
Message-Id: <20210210050742.31237-7-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210210050742.31237-1-colyli@suse.de>
References: <20210210050742.31237-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Joe Perches <joe@perches.com>

Use semicolons and braces.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/bset.c  | 12 ++++++++----
 drivers/md/bcache/sysfs.c |  6 ++++--
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index 67a2c47f4201..94d38e8a59b3 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -712,8 +712,10 @@ void bch_bset_build_written_tree(struct btree_keys *b)
 	for (j = inorder_next(0, t->size);
 	     j;
 	     j = inorder_next(j, t->size)) {
-		while (bkey_to_cacheline(t, k) < cacheline)
-			prev = k, k = bkey_next(k);
+		while (bkey_to_cacheline(t, k) < cacheline) {
+			prev = k;
+			k = bkey_next(k);
+		}
 
 		t->prev[j] = bkey_u64s(prev);
 		t->tree[j].m = bkey_to_cacheline_offset(t, cacheline++, k);
@@ -901,8 +903,10 @@ unsigned int bch_btree_insert_key(struct btree_keys *b, struct bkey *k,
 	status = BTREE_INSERT_STATUS_INSERT;
 
 	while (m != bset_bkey_last(i) &&
-	       bkey_cmp(k, b->ops->is_extents ? &START_KEY(m) : m) > 0)
-		prev = m, m = bkey_next(m);
+	       bkey_cmp(k, b->ops->is_extents ? &START_KEY(m) : m) > 0) {
+		prev = m;
+		m = bkey_next(m);
+	}
 
 	/* prev is in the tree, if we merge we're done */
 	status = BTREE_INSERT_STATUS_BACK_MERGE;
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index eef15f8022ba..cc89f3156d1a 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -1094,8 +1094,10 @@ SHOW(__bch_cache)
 			--n;
 
 		while (cached < p + n &&
-		       *cached == BTREE_PRIO)
-			cached++, n--;
+		       *cached == BTREE_PRIO) {
+			cached++;
+			n--;
+		}
 
 		for (i = 0; i < n; i++)
 			sum += INITIAL_PRIO - cached[i];
-- 
2.26.2

