Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE2327F9AF
	for <lists+linux-bcache@lfdr.de>; Thu,  1 Oct 2020 08:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730972AbgJAGvL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 1 Oct 2020 02:51:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:33458 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgJAGvL (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 1 Oct 2020 02:51:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4BFEBABBE;
        Thu,  1 Oct 2020 06:51:09 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 02/15] bcache: check c->root with IS_ERR_OR_NULL() in mca_reserve()
Date:   Thu,  1 Oct 2020 14:50:43 +0800
Message-Id: <20201001065056.24411-3-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001065056.24411-1-colyli@suse.de>
References: <20201001065056.24411-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Dongsheng Yang <dongsheng.yang@easystack.cn>

In mca_reserve(c) macro, we are checking root whether is NULL or not.
But that's not enough, when we read the root node in run_cache_set(),
if we got an error in bch_btree_node_read_done(), we will return
ERR_PTR(-EIO) to c->root.

And then we will go continue to unregister, but before calling
unregister_shrinker(&c->shrink), there is a possibility to call
bch_mca_count(), and we would get a crash with call trace like that:

[ 2149.876008] Unable to handle kernel NULL pointer dereference at virtual address 00000000000000b5
... ...
[ 2150.598931] Call trace:
[ 2150.606439]  bch_mca_count+0x58/0x98 [escache]
[ 2150.615866]  do_shrink_slab+0x54/0x310
[ 2150.624429]  shrink_slab+0x248/0x2d0
[ 2150.632633]  drop_slab_node+0x54/0x88
[ 2150.640746]  drop_slab+0x50/0x88
[ 2150.648228]  drop_caches_sysctl_handler+0xf0/0x118
[ 2150.657219]  proc_sys_call_handler.isra.18+0xb8/0x110
[ 2150.666342]  proc_sys_write+0x40/0x50
[ 2150.673889]  __vfs_write+0x48/0x90
[ 2150.681095]  vfs_write+0xac/0x1b8
[ 2150.688145]  ksys_write+0x6c/0xd0
[ 2150.695127]  __arm64_sys_write+0x24/0x30
[ 2150.702749]  el0_svc_handler+0xa0/0x128
[ 2150.710296]  el0_svc+0x8/0xc

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 3d8bd0692af3..ae7611fa42bf 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -514,7 +514,7 @@ static void bch_btree_leaf_dirty(struct btree *b, atomic_t *journal_ref)
  * mca -> memory cache
  */
 
-#define mca_reserve(c)	(((c->root && c->root->level)		\
+#define mca_reserve(c)	(((!IS_ERR_OR_NULL(c->root) && c->root->level) \
 			  ? c->root->level : 1) * 8 + 16)
 #define mca_can_free(c)						\
 	max_t(int, 0, c->btree_cache_used - mca_reserve(c))
-- 
2.26.2

