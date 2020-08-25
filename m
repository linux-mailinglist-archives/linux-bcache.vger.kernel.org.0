Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30AD1251147
	for <lists+linux-bcache@lfdr.de>; Tue, 25 Aug 2020 07:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725287AbgHYFFt (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 25 Aug 2020 01:05:49 -0400
Received: from smtprelay0197.hostedemail.com ([216.40.44.197]:44486 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728246AbgHYFFt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 25 Aug 2020 01:05:49 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave04.hostedemail.com (Postfix) with ESMTP id 65C461801195F
        for <linux-bcache@vger.kernel.org>; Tue, 25 Aug 2020 04:57:12 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id A19FF180A7FF2;
        Tue, 25 Aug 2020 04:57:06 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1311:1314:1345:1359:1437:1515:1534:1541:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3868:3870:3871:4321:4605:5007:6261:7875:7904:8603:10004:10848:11026:11473:11658:11914:12043:12296:12297:12438:12555:12895:13069:13311:13357:13894:14181:14384:14394:14721:21080:21627:30046:30054,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: bell57_2912de727059
X-Filterd-Recvd-Size: 2577
Received: from joe-laptop.perches.com (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf08.hostedemail.com (Postfix) with ESMTPA;
        Tue, 25 Aug 2020 04:57:05 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Jiri Kosina <trivial@kernel.org>, Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/29] bcache: Avoid comma separated statements
Date:   Mon, 24 Aug 2020 21:56:10 -0700
Message-Id: <99ba798329f7d957e75a22c8551e8bd22f70c626.1598331149.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1598331148.git.joe@perches.com>
References: <cover.1598331148.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Use semicolons and braces.

Signed-off-by: Joe Perches <joe@perches.com>
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
index ac06c0bc3c0a..1878c5ee53b6 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -1071,8 +1071,10 @@ SHOW(__bch_cache)
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
2.26.0

