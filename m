Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12BC46BEA3A
	for <lists+linux-bcache@lfdr.de>; Fri, 17 Mar 2023 14:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjCQNi0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 17 Mar 2023 09:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbjCQNiX (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 17 Mar 2023 09:38:23 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3194ECD67D;
        Fri, 17 Mar 2023 06:38:16 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id BEF922199B;
        Fri, 17 Mar 2023 13:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1679060294; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iIzCYOxhPdB2RLuSFuafc3TAfEqe6WZaJsEMEMOF87E=;
        b=HPWP6Gc+bzLXPXiPvDSd8flDkw446zLzu7LUnLHiG0QDtryRBG/cM+iOcJmtCFjKLsZvEB
        nkX+riii1JBFeuFhl+LcgsuJCYON7nx9W/hfbH0HkcwhrylrpiVwVEt2SGsB5rWz9wkwFw
        gCwi0gn1JTv+702t5qXw5TVoN+aQwMI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1679060294;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iIzCYOxhPdB2RLuSFuafc3TAfEqe6WZaJsEMEMOF87E=;
        b=sS9YFdsf5mrCS8mzRZrqhh2Bs9xzTSOS7Q1tCShcbNmoTNDD7IACaoctI6yff/xyO/VgSk
        dPOVISniD8JFXtAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BF01113428;
        Fri, 17 Mar 2023 13:38:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id bxbcIERtFGT3XAAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 17 Mar 2023 13:38:12 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.400.51.1.1\))
Subject: Re: [PATCH] bcache: fix wild pointer dereference in
 btree_gc_rewrite_node
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230317104919.118125-1-yili@winhong.com>
Date:   Fri, 17 Mar 2023 21:37:59 +0800
Cc:     linux-bcache@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        yilikernel@gmail.com, guochao@winhong.com,
        kent.overstreet@gmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <CFD1126D-F897-49BB-8581-BAC356644CBA@suse.de>
References: <20230317104919.118125-1-yili@winhong.com>
To:     Yi Li <yili@winhong.com>
X-Mailer: Apple Mail (2.3731.400.51.1.1)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Added in my test directory. Thanks.

Coly Li

> 2023=E5=B9=B43=E6=9C=8817=E6=97=A5 18:49=EF=BC=8CYi Li =
<yili@winhong.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> This causes a wild pointer dereference in the path:
>=20
>  btree_gc_rewrite_node()
>  -> btree_node_alloc_replacement() // will return -EAGIN(-11)
>  -> bch_btree_node_write_sync(-EAGIN)
>     ...
>     -> mutex_lock(&b->write_lock)
>     ..write_lock Offset of structure btree is 152
>     ..b->write_lock addr is 000000000000008d (-11 + 152)
>     .. BUG!
>=20
>  BUG: unable to handle kernel NULL pointer dereference at =
000000000000008d
>  Caching disabled for sde2
>  PGD 0 P4D 0
>  Oops: 0002 [#1] SMP NOPTI
>  CPU: 32 PID: 5050 Comm: bcache_gc Kdump: loaded Tainted: G        W
>       4.19.90-22.0401.87d4c7a.ckv.x86_64 #1 Hardware name: XFUSION =
2288H
>  V5/BC11SPSCB10, BIOS 8.27 03/08/2022
>  RIP: 0010:mutex_lock+0x19/0x30
>  Code: 90 0f 1f 44 00 00 be 02 00 00 00 e9 51 fb ff ff 90 0f 1f 44 00 =
00 53 48 89 fb e8
>   02 e4 ff ff 65 48 8b 14 25 80 5c 01 00 31 c0 <f0> 48 0f b1 13 75 02 =
5b c3 48
>   89 df 5b eb c8 0f 1f 84 00 00 00 00
>  RSP: 0018:ffffab1b0aba3b70 EFLAGS:
>  00010246 RAX: 0000000000000000 RBX: 000000000000008d RCX: =
0000000000000000
>  RDX: ffff89d3a7060000 RSI: 0000000000000000 RDI: 000000000000008d =
RBP:
>  fffffffffffffff5 R08: ffff89e3a6860d70 R09: ffff89e3bcc32000 R10:
>  0000000000000001 R11: 000007ffffffffff R12: 000000000000008d R13:
>  ffff89e3bb2a8c00 R14: ffffab1b0aba3e08 R15: 0000000000000000 FS:
>  0000000000000000(0000) GS:ffff89d3bff00000(0000) =
knlGS:0000000000000000 CS:
>  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 CR2: 000000000000008d =
CR3:
>  0000001bd1e0a001 CR4: 00000000007606e0 DR0: 0000000000000000 DR1:
>  0000000000000000 DR2: 0000000000000000 DR3: 0000000000000000 DR6:
>  00000000fffe0ff0 DR7: 0000000000000400 PKRU: 55555554
>  Call Trace:
>  bch_btree_node_write_sync+0x45/0xa0 [bcache]
>  btree_gc_rewrite_node+0x8f/0x160 [bcache]
>  ? btree_gc_mark_node+0x64/0x220 [bcache]
>  btree_gc_recurse+0x30a/0x3c0 [bcache]
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? bch_btree_gc+0x3e5/0x660 [bcache]
>  bch_btree_gc+0x3e5/0x660 [bcache]
>  ? finish_wait+0x80/0x80  ?
>  bch_btree_gc+0x660/0x660 [bcache]
>  Buffer I/O error on dev bcache1, logical block 468885310, lost async =
page write
>  bch_gc_thread+0x30/0x1e0 [bcache]
>  ? finish_wait+0x80/0x80
>  Buffer I/O error on dev bcache1, logical block 468885311, lost async =
page write
>  kthread+0x113/0x130  ?
>  kthread_create_worker_on_cpu+0x70/0x70
>  ret_from_fork+0x1f/0x4
>=20
> Signed-off-by: Yi Li <yili@winhong.com>
> Signed-off-by: Guo Chao  <guochao@winhong.com>
> ---
> drivers/md/bcache/btree.c | 2 ++
> 1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 147c493a989a..5d41331e96f2 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -1505,6 +1505,8 @@ static int btree_gc_rewrite_node(struct btree =
*b, struct btree_op *op,
>=20
> n =3D btree_node_alloc_replacement(replace, NULL);
>=20
> + if (IS_ERR_OR_NULL(n))
> + return -EINTR;
> /* recheck reserve after allocating replacement node */
> if (btree_check_reserve(b, NULL)) {
> btree_node_free(n);
> --=20
> 2.25.4
>=20

