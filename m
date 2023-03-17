Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1946BE75B
	for <lists+linux-bcache@lfdr.de>; Fri, 17 Mar 2023 11:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjCQK4i (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 17 Mar 2023 06:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCQK4h (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 17 Mar 2023 06:56:37 -0400
Received: from mail-m11879.qiye.163.com (mail-m11879.qiye.163.com [115.236.118.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C91E918C
        for <linux-bcache@vger.kernel.org>; Fri, 17 Mar 2023 03:56:35 -0700 (PDT)
Received: from localhost.localdomain (unknown [183.6.116.60])
        by mail-m11879.qiye.163.com (Hmail) with ESMTPA id 949DB680C6D;
        Fri, 17 Mar 2023 18:49:35 +0800 (CST)
From:   Yi Li <yili@winhong.com>
To:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     yilikernel@gmail.com, yili@winhong.com, guochao@winhong.com,
        colyli@suse.de, kent.overstreet@gmail.com
Subject: [PATCH] bcache: fix wild pointer dereference in btree_gc_rewrite_node
Date:   Fri, 17 Mar 2023 18:49:19 +0800
Message-Id: <20230317104919.118125-1-yili@winhong.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlDTklLVhkYQxlPTx1MGE5OSFUTARMWGhIXJBQOD1
        lXWRgSC1lBWUpDSFVNVUpKTVVNS1lXWRYaDxIVHRRZQVlPS0hVSkpLSEpDVUpLS1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Nj46Sww4PT0XOR0PAisPCB46
        LDIaFCFVSlVKTUxCS05LSkxNSE5CVTMWGhIXVQISFxI7DBIVExQVHFUYFBZFWVdZEgtZQVlKQ0hV
        TVVKSk1VTUtZV1kIAVlBSEJNSjcG
X-HM-Tid: 0a86ef3075812eb5kusn949db680c6d
X-HM-MType: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SPF_PERMERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This causes a wild pointer dereference in the path:

  btree_gc_rewrite_node()
  -> btree_node_alloc_replacement() // will return -EAGIN(-11)
  -> bch_btree_node_write_sync(-EAGIN)
     ...
     -> mutex_lock(&b->write_lock)
     ..write_lock Offset of structure btree is 152
     ..b->write_lock addr is 000000000000008d (-11 + 152)
     .. BUG!

  BUG: unable to handle kernel NULL pointer dereference at 000000000000008d
  Caching disabled for sde2
  PGD 0 P4D 0
  Oops: 0002 [#1] SMP NOPTI
  CPU: 32 PID: 5050 Comm: bcache_gc Kdump: loaded Tainted: G        W
       4.19.90-22.0401.87d4c7a.ckv.x86_64 #1 Hardware name: XFUSION 2288H
  V5/BC11SPSCB10, BIOS 8.27 03/08/2022
  RIP: 0010:mutex_lock+0x19/0x30
  Code: 90 0f 1f 44 00 00 be 02 00 00 00 e9 51 fb ff ff 90 0f 1f 44 00 00 53 48 89 fb e8
   02 e4 ff ff 65 48 8b 14 25 80 5c 01 00 31 c0 <f0> 48 0f b1 13 75 02 5b c3 48
   89 df 5b eb c8 0f 1f 84 00 00 00 00
  RSP: 0018:ffffab1b0aba3b70 EFLAGS:
  00010246 RAX: 0000000000000000 RBX: 000000000000008d RCX: 0000000000000000
  RDX: ffff89d3a7060000 RSI: 0000000000000000 RDI: 000000000000008d RBP:
  fffffffffffffff5 R08: ffff89e3a6860d70 R09: ffff89e3bcc32000 R10:
  0000000000000001 R11: 000007ffffffffff R12: 000000000000008d R13:
  ffff89e3bb2a8c00 R14: ffffab1b0aba3e08 R15: 0000000000000000 FS:
  0000000000000000(0000) GS:ffff89d3bff00000(0000) knlGS:0000000000000000 CS:
  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 CR2: 000000000000008d CR3:
  0000001bd1e0a001 CR4: 00000000007606e0 DR0: 0000000000000000 DR1:
  0000000000000000 DR2: 0000000000000000 DR3: 0000000000000000 DR6:
  00000000fffe0ff0 DR7: 0000000000000400 PKRU: 55555554
  Call Trace:
  bch_btree_node_write_sync+0x45/0xa0 [bcache]
  btree_gc_rewrite_node+0x8f/0x160 [bcache]
  ? btree_gc_mark_node+0x64/0x220 [bcache]
  btree_gc_recurse+0x30a/0x3c0 [bcache]
  ? call_rwsem_down_write_failed+0x13/0x20
  ? bch_btree_gc+0x3e5/0x660 [bcache]
  bch_btree_gc+0x3e5/0x660 [bcache]
  ? finish_wait+0x80/0x80  ?
  bch_btree_gc+0x660/0x660 [bcache]
  Buffer I/O error on dev bcache1, logical block 468885310, lost async page write
  bch_gc_thread+0x30/0x1e0 [bcache]
  ? finish_wait+0x80/0x80
  Buffer I/O error on dev bcache1, logical block 468885311, lost async page write
  kthread+0x113/0x130  ?
  kthread_create_worker_on_cpu+0x70/0x70
  ret_from_fork+0x1f/0x4

Signed-off-by: Yi Li <yili@winhong.com>
Signed-off-by: Guo Chao  <guochao@winhong.com>
---
 drivers/md/bcache/btree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 147c493a989a..5d41331e96f2 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1505,6 +1505,8 @@ static int btree_gc_rewrite_node(struct btree *b, struct btree_op *op,
 
 	n = btree_node_alloc_replacement(replace, NULL);
 
+	if (IS_ERR_OR_NULL(n))
+		return -EINTR;
 	/* recheck reserve after allocating replacement node */
 	if (btree_check_reserve(b, NULL)) {
 		btree_node_free(n);
-- 
2.25.4

