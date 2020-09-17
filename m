Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B22326D63F
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Sep 2020 10:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgIQISv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 17 Sep 2020 04:18:51 -0400
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:43668 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726153AbgIQISu (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 17 Sep 2020 04:18:50 -0400
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 04:18:46 EDT
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id E625EE0224C;
        Thu, 17 Sep 2020 16:13:38 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     colyli@suse.de
Cc:     linux-bcache@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH] bcache: check c->root with IS_ERR_OR_NULL() in mca_reserve()
Date:   Thu, 17 Sep 2020 08:13:26 +0000
Message-Id: <1600330406-2484-1-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZSUxDGk9MQhpJQk8fVkpNS0tISEtPSkJKSkxVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0JITVVKS0tZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mwg6DDo5Hz5JCRY4Ix03OBE1
        TR5PCklVSlVKTUtLSEhLT0pCSEtLVTMWGhIXVR8UFRwIEx4VHFUCGhUcOx4aCAIIDxoYEFUYFUVZ
        V1kSC1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSU5CSDcG
X-HM-Tid: 0a749b204b6c20bdkuqye625ee0224c
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In mca_reserve(c) macro, we are checking root whether is NULL or not.
But that's not enough, when we read the root node in run_cache_set(),
if we got an error in bch_btree_node_read_done(), we will return ERR_PTR(-EIO)
to c->root.

And then we will go continue to unregister, but before unregister_shrinker(&c->shrink);
there is a possibility to call bch_mca_count(), and we would get a crash with call trace like that:

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
---
 drivers/md/bcache/btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index d45a1dd..36cae5c 100644
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
1.8.3.1

