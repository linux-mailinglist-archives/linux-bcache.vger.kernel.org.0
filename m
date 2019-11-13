Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05A44FA9B0
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Nov 2019 06:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbfKMFeV (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 13 Nov 2019 00:34:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:54086 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725976AbfKMFeV (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 13 Nov 2019 00:34:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 961E5B150;
        Wed, 13 Nov 2019 05:34:19 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 01/10] bcache: fix fifo index swapping condition in journal_pin_cmp()
Date:   Wed, 13 Nov 2019 13:33:37 +0800
Message-Id: <20191113053346.63536-2-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191113053346.63536-1-colyli@suse.de>
References: <20191113053346.63536-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Fifo structure journal.pin is implemented by a cycle buffer, if the back
index reaches highest location of the cycle buffer, it will be swapped
to 0. Once the swapping happens, it means a smaller fifo index might be
associated to a newer journal entry. So the btree node with oldest
journal entry won't be selected in bch_btree_leaf_dirty() to reference
the dirty B+tree leaf node. This problem may cause bcache journal won't
protect unflushed oldest B+tree dirty leaf node in power failure, and
this B+tree leaf node is possible to beinconsistent after reboot from
power failure.

This patch fixes the fifo index comparing logic in journal_pin_cmp(),
to avoid potential corrupted B+tree leaf node when the back index of
journal pin is swapped.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/btree.c   | 26 ++++++++++++++++++++++++++
 drivers/md/bcache/journal.h |  4 ----
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index ba434d9ac720..00523cd1db80 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -528,6 +528,32 @@ static void btree_node_write_work(struct work_struct *w)
 	mutex_unlock(&b->write_lock);
 }
 
+/* return true if journal pin 'l' is newer than 'r' */
+static bool journal_pin_cmp(struct cache_set *c,
+			    atomic_t *l,
+			    atomic_t *r)
+{
+	int l_idx, r_idx, f_idx, b_idx;
+	bool ret = false;
+
+	l_idx = fifo_idx(&(c)->journal.pin, (l));
+	r_idx = fifo_idx(&(c)->journal.pin, (r));
+	f_idx = (c)->journal.pin.front;
+	b_idx = (c)->journal.pin.back;
+
+	if (l_idx > r_idx)
+		ret = true;
+	/* in case fifo back pointer is swapped */
+	if (b_idx < f_idx) {
+		if (l_idx <= b_idx && r_idx >= f_idx)
+			ret = true;
+		else if (l_idx >= f_idx && r_idx <= b_idx)
+			ret = false;
+	}
+
+	return ret;
+}
+
 static void bch_btree_leaf_dirty(struct btree *b, atomic_t *journal_ref)
 {
 	struct bset *i = btree_bset_last(b);
diff --git a/drivers/md/bcache/journal.h b/drivers/md/bcache/journal.h
index f2ea34d5f431..06b3eaab7d16 100644
--- a/drivers/md/bcache/journal.h
+++ b/drivers/md/bcache/journal.h
@@ -157,10 +157,6 @@ struct journal_device {
 };
 
 #define BTREE_FLUSH_NR	8
-
-#define journal_pin_cmp(c, l, r)				\
-	(fifo_idx(&(c)->journal.pin, (l)) > fifo_idx(&(c)->journal.pin, (r)))
-
 #define JOURNAL_PIN	20000
 
 #define journal_full(j)						\
-- 
2.16.4

