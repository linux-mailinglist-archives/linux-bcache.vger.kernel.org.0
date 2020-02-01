Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA5F14F81E
	for <lists+linux-bcache@lfdr.de>; Sat,  1 Feb 2020 15:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgBAOnI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 1 Feb 2020 09:43:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:59114 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726670AbgBAOnI (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 1 Feb 2020 09:43:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9337FAAFD;
        Sat,  1 Feb 2020 14:43:06 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 4/5] bcache: fix incorrect data type usage in btree_flush_write()
Date:   Sat,  1 Feb 2020 22:42:34 +0800
Message-Id: <20200201144235.94110-5-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200201144235.94110-1-colyli@suse.de>
References: <20200201144235.94110-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Dan Carpenter points out that from commit 2aa8c529387c ("bcache: avoid
unnecessary btree nodes flushing in btree_flush_write()"), there is a
incorrect data type usage which leads to the following static checker
warning:
	drivers/md/bcache/journal.c:444 btree_flush_write()
	warn: 'ref_nr' unsigned <= 0

drivers/md/bcache/journal.c
   422  static void btree_flush_write(struct cache_set *c)
   423  {
   424          struct btree *b, *t, *btree_nodes[BTREE_FLUSH_NR];
   425          unsigned int i, nr, ref_nr;
                                    ^^^^^^

   426          atomic_t *fifo_front_p, *now_fifo_front_p;
   427          size_t mask;
   428
   429          if (c->journal.btree_flushing)
   430                  return;
   431
   432          spin_lock(&c->journal.flush_write_lock);
   433          if (c->journal.btree_flushing) {
   434                  spin_unlock(&c->journal.flush_write_lock);
   435                  return;
   436          }
   437          c->journal.btree_flushing = true;
   438          spin_unlock(&c->journal.flush_write_lock);
   439
   440          /* get the oldest journal entry and check its refcount */
   441          spin_lock(&c->journal.lock);
   442          fifo_front_p = &fifo_front(&c->journal.pin);
   443          ref_nr = atomic_read(fifo_front_p);
   444          if (ref_nr <= 0) {
                    ^^^^^^^^^^^
Unsigned can't be less than zero.

   445                  /*
   446                   * do nothing if no btree node references
   447                   * the oldest journal entry
   448                   */
   449                  spin_unlock(&c->journal.lock);
   450                  goto out;
   451          }
   452          spin_unlock(&c->journal.lock);

As the warning information indicates, local varaible ref_nr in unsigned
int type is wrong, which does not matche atomic_read() and the "<= 0"
checking.

This patch fixes the above error by defining local variable ref_nr as
int type.

Fixes: 2aa8c529387c ("bcache: avoid unnecessary btree nodes flushing in btree_flush_write()")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/journal.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 33ddc5269e8d..6730820780b0 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -422,7 +422,8 @@ int bch_journal_replay(struct cache_set *s, struct list_head *list)
 static void btree_flush_write(struct cache_set *c)
 {
 	struct btree *b, *t, *btree_nodes[BTREE_FLUSH_NR];
-	unsigned int i, nr, ref_nr;
+	unsigned int i, nr;
+	int ref_nr;
 	atomic_t *fifo_front_p, *now_fifo_front_p;
 	size_t mask;
 
-- 
2.16.4

