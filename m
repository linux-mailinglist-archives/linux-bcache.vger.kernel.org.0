Return-Path: <linux-bcache+bounces-839-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A0A4CA06C42
	for <lists+linux-bcache@lfdr.de>; Thu,  9 Jan 2025 04:31:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A85C1889471
	for <lists+linux-bcache@lfdr.de>; Thu,  9 Jan 2025 03:32:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6BA1176AB5;
	Thu,  9 Jan 2025 03:28:52 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-m127209.xmail.ntesmail.com (mail-m127209.xmail.ntesmail.com [115.236.127.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8681ACEBF
	for <linux-bcache@vger.kernel.org>; Thu,  9 Jan 2025 03:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.236.127.209
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736393332; cv=none; b=mr8aFUbRhjBeHMUNy5nsBMQaCNC4pU3NDlsO6w8naQq5mHDEXIkOmmXLZmIn2nxClAZrlRD0DImyctvDpkIHVayHkTz2qT77VYckasb0cwPh4m3NM8kEDfNxR34oT3wVdca+OK/qogQP3DztQ/cF9gvNG7YqV3EGcMN+8oQoo6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736393332; c=relaxed/simple;
	bh=xb1gAf8p4wCT12V+4JXPuk2fm34bRXkRSRMTMjS4eIE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WejBlahIZrkpEcurZ+SpGS5C8VAc/bveslHhFOPg2yfK3ifKFoFH4y8qGWTOL8/CY1D1WKgxVZmtU/sXPwYkQN6usgTDwZqT2NU5J55KcLZb+gA6rKdSlKOnRt9wuqzmRTBuQQ4JcgK0Oc+SGGAMEj6GGhQFmfo4Brz9ozu8zQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=easystack.cn; spf=none smtp.mailfrom=easystack.cn; arc=none smtp.client-ip=115.236.127.209
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=easystack.cn
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=easystack.cn
Received: from localhost.localdomain (unknown [122.96.136.62])
	by smtp.qiye.163.com (Hmail) with ESMTP id 3cd6dac3;
	Thu, 9 Jan 2025 11:23:26 +0800 (GMT+08:00)
From: mingzhe.zou@easystack.cn
To: colyli@suse.de
Cc: linux-bcache@vger.kernel.org,
	dongsheng.yang@easystack.cn,
	zoumingzhe@qq.com
Subject: [PATCH] bcache: fix journal full and c->root write not flushed
Date: Thu,  9 Jan 2025 11:23:04 +0800
Message-Id: <20250109032304.1040957-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlCSk4aVhlMHUlNQx0YTk1OHVYVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlKSUlVQk1VSkhNVU1JWVdZFhoPEhUdFFlBWU9LSFVKS0hKTkxKVUpLS1
	VKQktLWQY+
X-HM-Tid: 0a9449169d81022bkunm3cd6dac3
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NRA6Gio5QjcWIkIeDEIMFjwN
	P01PFB5VSlVKTEhNSEJIS0tMQktDVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
	C1lBWUpJSVVCTVVKSE1VTUlZV1kIAVlBT0NPTTcG

From: Mingzhe Zou <mingzhe.zou@easystack.cn>

When we use a new cache device for performance testing, the (bs=4k, iodepth=1)
write result is abnormal. With a cycle of 30 seconds, IOPS drop to 0 within 10
seconds, and then recover after 30 seconds.

After debugging, we found that journal is full and btree_node_write_work() runs
at least 30 seconds apart. However, when the journal is full, we expect to call
btree_flush_write() to release the oldest journal entry. Obviously, flush write
failed to release the journal.

View the code, we found that the btree_flush_write() only select flushing btree
node from c->btree_cache list. However, list_del_init(&b->list) will be called
in bch_btree_set_root(), so the c->root is not in the c->btree_cache list.

For a new cache, there was only one btree node before btree split. This patch
hopes to flush c->root write when the journal is full.

Fixes: 91be66e1 (bcache: performance improvement for btree_flush_write())
Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/journal.c | 86 ++++++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 40 deletions(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 7ff14bd2feb8..837073fe5e5a 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -413,13 +413,53 @@ void bch_journal_space_reserve(struct journal *j)
 
 /* Journalling */
 
+static inline bool btree_need_flush_write(struct btree *b, atomic_t *front)
+{
+	if (btree_node_journal_flush(b))
+		pr_err("BUG: flush_write bit should not be set here!\n");
+
+	mutex_lock(&b->write_lock);
+
+	if (!btree_node_dirty(b)) {
+		mutex_unlock(&b->write_lock);
+		return false;
+	}
+
+	if (!btree_current_write(b)->journal) {
+		mutex_unlock(&b->write_lock);
+		return false;
+	}
+
+	/*
+	 * Only select the btree node which exactly references
+	 * the oldest journal entry.
+	 *
+	 * If the journal entry pointed by fifo_front_p is
+	 * reclaimed in parallel, don't worry:
+	 * - the list_for_each_xxx loop will quit when checking
+	 *   next now_fifo_front_p.
+	 * - If there are matched nodes recorded in btree_nodes[],
+	 *   they are clean now (this is why and how the oldest
+	 *   journal entry can be reclaimed). These selected nodes
+	 *   will be ignored and skipped in the folowing for-loop.
+	 */
+	if ((btree_current_write(b)->journal - front) & b->c->journal.pin.mask) {
+		mutex_unlock(&b->write_lock);
+		return false;
+	}
+
+	set_btree_node_journal_flush(b);
+
+	mutex_unlock(&b->write_lock);
+	return true;
+}
+
 static void btree_flush_write(struct cache_set *c)
 {
 	struct btree *b, *t, *btree_nodes[BTREE_FLUSH_NR];
 	unsigned int i, nr;
 	int ref_nr;
 	atomic_t *fifo_front_p, *now_fifo_front_p;
-	size_t mask;
 
 	if (c->journal.btree_flushing)
 		return;
@@ -446,12 +486,14 @@ static void btree_flush_write(struct cache_set *c)
 	}
 	spin_unlock(&c->journal.lock);
 
-	mask = c->journal.pin.mask;
 	nr = 0;
 	atomic_long_inc(&c->flush_write);
 	memset(btree_nodes, 0, sizeof(btree_nodes));
 
 	mutex_lock(&c->bucket_lock);
+	if (btree_need_flush_write(c->root, fifo_front_p))
+		btree_nodes[nr++] = c->root;
+
 	list_for_each_entry_safe_reverse(b, t, &c->btree_cache, list) {
 		/*
 		 * It is safe to get now_fifo_front_p without holding
@@ -476,45 +518,9 @@ static void btree_flush_write(struct cache_set *c)
 		if (nr >= ref_nr)
 			break;
 
-		if (btree_node_journal_flush(b))
-			pr_err("BUG: flush_write bit should not be set here!\n");
-
-		mutex_lock(&b->write_lock);
-
-		if (!btree_node_dirty(b)) {
-			mutex_unlock(&b->write_lock);
-			continue;
-		}
-
-		if (!btree_current_write(b)->journal) {
-			mutex_unlock(&b->write_lock);
-			continue;
-		}
-
-		/*
-		 * Only select the btree node which exactly references
-		 * the oldest journal entry.
-		 *
-		 * If the journal entry pointed by fifo_front_p is
-		 * reclaimed in parallel, don't worry:
-		 * - the list_for_each_xxx loop will quit when checking
-		 *   next now_fifo_front_p.
-		 * - If there are matched nodes recorded in btree_nodes[],
-		 *   they are clean now (this is why and how the oldest
-		 *   journal entry can be reclaimed). These selected nodes
-		 *   will be ignored and skipped in the following for-loop.
-		 */
-		if (((btree_current_write(b)->journal - fifo_front_p) &
-		     mask) != 0) {
-			mutex_unlock(&b->write_lock);
-			continue;
-		}
-
-		set_btree_node_journal_flush(b);
-
-		mutex_unlock(&b->write_lock);
+		if (btree_need_flush_write(b, fifo_front_p))
+			btree_nodes[nr++] = b;
 
-		btree_nodes[nr++] = b;
 		/*
 		 * To avoid holding c->bucket_lock too long time,
 		 * only scan for BTREE_FLUSH_NR matched btree nodes
-- 
2.34.1


