Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7F46C8675
	for <lists+linux-bcache@lfdr.de>; Fri, 24 Mar 2023 20:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbjCXT7M (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 24 Mar 2023 15:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbjCXT7L (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 24 Mar 2023 15:59:11 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EDAD2007B;
        Fri, 24 Mar 2023 12:58:38 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 45A6C46;
        Fri, 24 Mar 2023 12:57:56 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 9aUV60dFrDFY; Fri, 24 Mar 2023 12:57:52 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id CDC9B45;
        Fri, 24 Mar 2023 12:57:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net CDC9B45
Date:   Fri, 24 Mar 2023 12:57:49 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Yi Li <yili@winhong.com>
cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        yilikernel@gmail.com, guochao@winhong.com, colyli@suse.de,
        kent.overstreet@gmail.com
Subject: Re: [PATCH] bcache: fix wild pointer dereference in
 btree_gc_rewrite_node
In-Reply-To: <20230317104919.118125-1-yili@winhong.com>
Message-ID: <702e6bd9-2aae-8b76-b4a9-7236478832e9@ewheeler.net>
References: <20230317104919.118125-1-yili@winhong.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, 17 Mar 2023, Yi Li wrote:

> This causes a wild pointer dereference in the path:
> 
>   btree_gc_rewrite_node()
>   -> btree_node_alloc_replacement() // will return -EAGIN(-11)
>   -> bch_btree_node_write_sync(-EAGIN)
>      ...
>      -> mutex_lock(&b->write_lock)
>      ..write_lock Offset of structure btree is 152
>      ..b->write_lock addr is 000000000000008d (-11 + 152)
>      .. BUG!
> 
>   BUG: unable to handle kernel NULL pointer dereference at 000000000000008d
>   Caching disabled for sde2
>   PGD 0 P4D 0
>   Oops: 0002 [#1] SMP NOPTI
>   CPU: 32 PID: 5050 Comm: bcache_gc Kdump: loaded Tainted: G        W
>        4.19.90-22.0401.87d4c7a.ckv.x86_64 #1 Hardware name: XFUSION 2288H
>   V5/BC11SPSCB10, BIOS 8.27 03/08/2022
>   RIP: 0010:mutex_lock+0x19/0x30
>   Code: 90 0f 1f 44 00 00 be 02 00 00 00 e9 51 fb ff ff 90 0f 1f 44 00 00 53 48 89 fb e8
>    02 e4 ff ff 65 48 8b 14 25 80 5c 01 00 31 c0 <f0> 48 0f b1 13 75 02 5b c3 48
>    89 df 5b eb c8 0f 1f 84 00 00 00 00
>   RSP: 0018:ffffab1b0aba3b70 EFLAGS:
>   00010246 RAX: 0000000000000000 RBX: 000000000000008d RCX: 0000000000000000
>   RDX: ffff89d3a7060000 RSI: 0000000000000000 RDI: 000000000000008d RBP:
>   fffffffffffffff5 R08: ffff89e3a6860d70 R09: ffff89e3bcc32000 R10:
>   0000000000000001 R11: 000007ffffffffff R12: 000000000000008d R13:
>   ffff89e3bb2a8c00 R14: ffffab1b0aba3e08 R15: 0000000000000000 FS:
>   0000000000000000(0000) GS:ffff89d3bff00000(0000) knlGS:0000000000000000 CS:
>   0010 DS: 0000 ES: 0000 CR0: 0000000080050033 CR2: 000000000000008d CR3:
>   0000001bd1e0a001 CR4: 00000000007606e0 DR0: 0000000000000000 DR1:
>   0000000000000000 DR2: 0000000000000000 DR3: 0000000000000000 DR6:
>   00000000fffe0ff0 DR7: 0000000000000400 PKRU: 55555554
>   Call Trace:
>   bch_btree_node_write_sync+0x45/0xa0 [bcache]
>   btree_gc_rewrite_node+0x8f/0x160 [bcache]
>   ? btree_gc_mark_node+0x64/0x220 [bcache]
>   btree_gc_recurse+0x30a/0x3c0 [bcache]
>   ? call_rwsem_down_write_failed+0x13/0x20
>   ? bch_btree_gc+0x3e5/0x660 [bcache]
>   bch_btree_gc+0x3e5/0x660 [bcache]
>   ? finish_wait+0x80/0x80  ?
>   bch_btree_gc+0x660/0x660 [bcache]
>   Buffer I/O error on dev bcache1, logical block 468885310, lost async page write
>   bch_gc_thread+0x30/0x1e0 [bcache]
>   ? finish_wait+0x80/0x80
>   Buffer I/O error on dev bcache1, logical block 468885311, lost async page write
>   kthread+0x113/0x130  ?
>   kthread_create_worker_on_cpu+0x70/0x70
>   ret_from_fork+0x1f/0x4
> 
> Signed-off-by: Yi Li <yili@winhong.com>
> Signed-off-by: Guo Chao  <guochao@winhong.com>

Please add stable:

	Cc: stable@vger.kernel.org

Optionally, add:

	Reviewed-by: Eric Wheeler <bcache@linux.ewheeler.net>

-Eric

> ---
>  drivers/md/bcache/btree.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 147c493a989a..5d41331e96f2 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -1505,6 +1505,8 @@ static int btree_gc_rewrite_node(struct btree *b, struct btree_op *op,
>  
>  	n = btree_node_alloc_replacement(replace, NULL);
>  
> +	if (IS_ERR_OR_NULL(n))
> +		return -EINTR;
>  	/* recheck reserve after allocating replacement node */
>  	if (btree_check_reserve(b, NULL)) {
>  		btree_node_free(n);
> -- 
> 2.25.4
> 
> 
