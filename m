Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24C4B7781F
	for <lists+linux-bcache@lfdr.de>; Sat, 27 Jul 2019 12:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbfG0KUf (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 27 Jul 2019 06:20:35 -0400
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:2580 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfG0KUe (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 27 Jul 2019 06:20:34 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.7]) by rmmx-syy-dmz-app03-12003 (RichMail) with SMTP id 2ee35d3c255ec16-4f2f5; Sat, 27 Jul 2019 18:20:14 +0800 (CST)
X-RM-TRANSID: 2ee35d3c255ec16-4f2f5
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.novalocal (unknown[112.25.65.41])
        by rmsmtp-syy-appsvr04-12004 (RichMail) with SMTP id 2ee45d3c255db6c-ef1e5;
        Sat, 27 Jul 2019 18:20:14 +0800 (CST)
X-RM-TRANSID: 2ee45d3c255db6c-ef1e5
From:   Yaowei Bai <baiyaowei@cmss.chinamobile.com>
To:     colyli@suse.de, kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        baiyaowei@cmss.chinamobile.com
Subject: [PATCH 1/3] bcache: drop obsolete comments
Date:   Sat, 27 Jul 2019 18:19:57 +0800
Message-Id: <1564222799-10603-1-git-send-email-baiyaowei@cmss.chinamobile.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Unused list was killed by commit 2531d9ee61fa ("bcache: Kill unused freelist")
but left these comments, let's drop them.

This patch doesn't introduce functional change.

Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
---
 drivers/md/bcache/alloc.c | 13 +++----------
 drivers/md/bcache/super.c |  3 ---
 2 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 6f77682..c22c260 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -33,13 +33,6 @@
  * If we've got discards enabled, that happens when a bucket moves from the
  * free_inc list to the free list.
  *
- * There is another freelist, because sometimes we have buckets that we know
- * have nothing pointing into them - these we can reuse without waiting for
- * priorities to be rewritten. These come from freed btree nodes and buckets
- * that garbage collection discovered no longer had valid keys pointing into
- * them (because they were overwritten). That's the unused list - buckets on the
- * unused list move to the free list, optionally being discarded in the process.
- *
  * It's also important to ensure that gens don't wrap around - with respect to
  * either the oldest gen in the btree or the gen on disk. This is quite
  * difficult to do in practice, but we explicitly guard against it anyways - if
@@ -323,9 +316,9 @@ static int bch_allocator_thread(void *arg)
 
 	while (1) {
 		/*
-		 * First, we pull buckets off of the unused and free_inc lists,
-		 * possibly issue discards to them, then we add the bucket to
-		 * the free list:
+		 * First, we pull buckets off of the free_inc list, possibly
+		 * issue discards to them, then we add the bucket to the free
+		 * list:
 		 */
 		while (1) {
 			long bucket;
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 26e374f..eba38aa 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -544,9 +544,6 @@ void bch_prio_write(struct cache *ca)
 	atomic_long_add(ca->sb.bucket_size * prio_buckets(ca),
 			&ca->meta_sectors_written);
 
-	//pr_debug("free %zu, free_inc %zu, unused %zu", fifo_used(&ca->free),
-	//	 fifo_used(&ca->free_inc), fifo_used(&ca->unused));
-
 	for (i = prio_buckets(ca) - 1; i >= 0; --i) {
 		long bucket;
 		struct prio_set *p = ca->disk_buckets;
-- 
1.8.3.1



