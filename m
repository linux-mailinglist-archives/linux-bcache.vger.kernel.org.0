Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6FBB34CA7
	for <lists+linux-bcache@lfdr.de>; Tue,  4 Jun 2019 17:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbfFDPxq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 4 Jun 2019 11:53:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:32790 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728030AbfFDPxq (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 4 Jun 2019 11:53:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 442EFACD4;
        Tue,  4 Jun 2019 15:53:45 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 18/18] bcache: add code comments for journal_read_bucket()
Date:   Tue,  4 Jun 2019 23:53:30 +0800
Message-Id: <20190604155330.107927-3-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190604155330.107927-1-colyli@suse.de>
References: <20190604151624.105150-1-colyli@suse.de>
 <20190604155330.107927-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch adds more code comments in journal_read_bucket(), this is an
effort to make the code to be more understandable.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/journal.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index d4b9817f2237..d3f2331fc559 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -100,6 +100,20 @@ reread:		left = ca->sb.bucket_size - offset;
 
 			blocks = set_blocks(j, block_bytes(ca->set));
 
+			/*
+			 * Nodes in 'list' are in linear increasing order of
+			 * i->j.seq, the node on head has the smallest (oldest)
+			 * journal seq, the node on tail has the biggest
+			 * (latest) journal seq.
+			 */
+
+			/*
+			 * Check from the oldest jset for last_seq. If
+			 * i->j.seq < j->last_seq, it means the oldest jset
+			 * in list is expired and useless, remove it from
+			 * this list. Otherwise, j is a condidate jset for
+			 * further following checks.
+			 */
 			while (!list_empty(list)) {
 				i = list_first_entry(list,
 					struct journal_replay, list);
@@ -109,13 +123,22 @@ reread:		left = ca->sb.bucket_size - offset;
 				kfree(i);
 			}
 
+			/* iterate list in reverse order (from latest jset) */
 			list_for_each_entry_reverse(i, list, list) {
 				if (j->seq == i->j.seq)
 					goto next_set;
 
+				/*
+				 * if j->seq is less than any i->j.last_seq
+				 * in list, j is an expired and useless jset.
+				 */
 				if (j->seq < i->j.last_seq)
 					goto next_set;
 
+				/*
+				 * 'where' points to first jset in list which
+				 * is elder then j.
+				 */
 				if (j->seq > i->j.seq) {
 					where = &i->list;
 					goto add;
@@ -129,6 +152,7 @@ reread:		left = ca->sb.bucket_size - offset;
 			if (!i)
 				return -ENOMEM;
 			memcpy(&i->j, j, bytes);
+			/* Add to the location after 'where' points to */
 			list_add(&i->list, where);
 			ret = 1;
 
-- 
2.16.4

