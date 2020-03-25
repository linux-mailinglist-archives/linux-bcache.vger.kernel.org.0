Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16D07191E97
	for <lists+linux-bcache@lfdr.de>; Wed, 25 Mar 2020 02:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbgCYBbF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 24 Mar 2020 21:31:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:46628 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727205AbgCYBbF (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 24 Mar 2020 21:31:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3E549ADDD;
        Wed, 25 Mar 2020 01:31:04 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, kbuild test robot <lkp@intel.com>
Subject: [PATCH 1/1] bcache: remove dupplicated declaration from btree.h
Date:   Wed, 25 Mar 2020 09:30:57 +0800
Message-Id: <20200325013057.114340-2-colyli@suse.de>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200325013057.114340-1-colyli@suse.de>
References: <20200325013057.114340-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Commit ab544165dc2d ("bcache: move macro btree() and btree_root()
into btree.h") makes two duplicated declaration into btree.h,
	typedef int (btree_map_keys_fn)();
	int bch_btree_map_keys();

The kbuild test robot <lkp@intel.com> detects and reports this
problem and this patch fixes it by removing the duplicated ones.

Fixes: ab544165dc2d ("bcache: move macro btree() and btree_root() into btree.h")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/btree.h | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/md/bcache/btree.h b/drivers/md/bcache/btree.h
index 7c884f278da8..257969980c49 100644
--- a/drivers/md/bcache/btree.h
+++ b/drivers/md/bcache/btree.h
@@ -282,13 +282,6 @@ void bch_initial_gc_finish(struct cache_set *c);
 void bch_moving_gc(struct cache_set *c);
 int bch_btree_check(struct cache_set *c);
 void bch_initial_mark_key(struct cache_set *c, int level, struct bkey *k);
-typedef int (btree_map_keys_fn)(struct btree_op *op, struct btree *b,
-				struct bkey *k);
-int bch_btree_map_keys_recurse(struct btree *b, struct btree_op *op,
-			       struct bkey *from, btree_map_keys_fn *fn,
-			       int flags);
-int bch_btree_map_keys(struct btree_op *op, struct cache_set *c,
-		       struct bkey *from, btree_map_keys_fn *fn, int flags);
 
 static inline void wake_up_gc(struct cache_set *c)
 {
@@ -402,6 +395,9 @@ typedef int (btree_map_keys_fn)(struct btree_op *op, struct btree *b,
 				struct bkey *k);
 int bch_btree_map_keys(struct btree_op *op, struct cache_set *c,
 		       struct bkey *from, btree_map_keys_fn *fn, int flags);
+int bch_btree_map_keys_recurse(struct btree *b, struct btree_op *op,
+			       struct bkey *from, btree_map_keys_fn *fn,
+			       int flags);
 
 typedef bool (keybuf_pred_fn)(struct keybuf *buf, struct bkey *k);
 
-- 
2.25.0

