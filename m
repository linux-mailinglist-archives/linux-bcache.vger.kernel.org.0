Return-Path: <linux-bcache+bounces-29-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 72D487F7765
	for <lists+linux-bcache@lfdr.de>; Fri, 24 Nov 2023 16:14:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27D242820DA
	for <lists+linux-bcache@lfdr.de>; Fri, 24 Nov 2023 15:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4588F2E653;
	Fri, 24 Nov 2023 15:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gekmihesg.de header.i=@gekmihesg.de header.b="i0aTYYjO"
X-Original-To: linux-bcache@vger.kernel.org
Received: from vsrv.gekmihesg.de (vsrv.gekmihesg.de [IPv6:2a01:4f8:c17:74cc::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62F21727;
	Fri, 24 Nov 2023 07:14:40 -0800 (PST)
Message-ID: <c47d3540ece151a2fb30e1c7b5881cb8922db915.camel@gekmihesg.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gekmihesg.de;
	s=201901; t=1700838878; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zM6/fUk0rJdOH5EFD8vEbULY8RybL+qMHsTdcrITXSg=;
	b=i0aTYYjO2rovw4TCdihadQUQyTdJv1/OKn6WurEMPqhuSjRBeIWKj0bM9Df0gjCAMSOLUR
	4uP7YSt0SS/j4bycc03OVfBVs5VEls9l+08MmwQPMG96ir1b1m3xYmOxWqrsqKPIc9Ih6b
	eXveoQs5DFbko80Af2hu7gZz3xoLApw=
Subject: [PATCH] bcache: revert replacing IS_ERR_OR_NULL with IS_ERR
From: Markus Weippert <markus@gekmihesg.de>
To: Bcache Linux <linux-bcache@vger.kernel.org>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>, Zheng Wang
	 <zyytlz.wz@163.com>, linux-kernel@vger.kernel.org, Stefan
	=?ISO-8859-1?Q?F=F6rster?=
	 <cite@incertum.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"stable@vger.kernel.org"
	 <stable@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Linux kernel
	regressions list <regressions@lists.linux.dev>, Coly Li <colyli@suse.de>
Date: Fri, 24 Nov 2023 16:14:37 +0100
In-Reply-To: <3DF4A87A-2AC1-4893-AE5F-E921478419A9@suse.de>
References: <ZV9ZSyDLNDlzutgQ@pharmakeia.incertum.net>
	 <be371028-efeb-44af-90ea-5c307f27d4c6@leemhuis.info>
	 <71576a9ff7398bfa4b8c0a1a1a2523383b056168.camel@gekmihesg.de>
	 <989C39B9-A05D-4E4F-A842-A4943A29FFD6@suse.de>
	 <1c2a1f362d667d36d83a5ba43218bad199855b11.camel@gekmihesg.de>
	 <3DF4A87A-2AC1-4893-AE5F-E921478419A9@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=markus smtp.mailfrom=markus@gekmihesg.de

Commit 028ddcac477b ("bcache: Remove unnecessary NULL point check in
node allocations") replaced IS_ERR_OR_NULL by IS_ERR. This leads to a
NULL pointer dereference.

BUG: kernel NULL pointer dereference, address: 0000000000000080
Call Trace:
 ? __die_body.cold+0x1a/0x1f
 ? page_fault_oops+0xd2/0x2b0
 ? exc_page_fault+0x70/0x170
 ? asm_exc_page_fault+0x22/0x30
 ? btree_node_free+0xf/0x160 [bcache]
 ? up_write+0x32/0x60
 btree_gc_coalesce+0x2aa/0x890 [bcache]
 ? bch_extent_bad+0x70/0x170 [bcache]
 btree_gc_recurse+0x130/0x390 [bcache]
 ? btree_gc_mark_node+0x72/0x230 [bcache]
 bch_btree_gc+0x5da/0x600 [bcache]
 ? cpuusage_read+0x10/0x10
 ? bch_btree_gc+0x600/0x600 [bcache]
 bch_gc_thread+0x135/0x180 [bcache]

The relevant code starts with:

    new_nodes[0] =3D NULL;

    for (i =3D 0; i < nodes; i++) {
        if (__bch_keylist_realloc(&keylist, bkey_u64s(&r[i].b->key)))
            goto out_nocoalesce;
    // ...
out_nocoalesce:
    // ...
    for (i =3D 0; i < nodes; i++)
        if (!IS_ERR(new_nodes[i])) {  // IS_ERR_OR_NULL before
028ddcac477b
            btree_node_free(new_nodes[i]);  // new_nodes[0] is NULL
            rw_unlock(true, new_nodes[i]);
        }

This patch replaces IS_ERR() by IS_ERR_OR_NULL() to fix this.

Fixes: 028ddcac477b ("bcache: Remove unnecessary NULL point check in
node allocations")
Link:
https://lore.kernel.org/all/3DF4A87A-2AC1-4893-AE5F-E921478419A9@suse.de/
Cc: stable@vger.kernel.org
Cc: Zheng Wang <zyytlz.wz@163.com>
Cc: Coly Li <colyli@suse.de>
Signed-off-by: Markus Weippert <markus@gekmihesg.de>

---
 drivers/md/bcache/btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index de3019972..261596791 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1522,7 +1522,7 @@ static int btree_gc_coalesce(struct btree *b,
struct btree_op *op,
        bch_keylist_free(&keylist);
=20
        for (i =3D 0; i < nodes; i++)
-               if (!IS_ERR(new_nodes[i])) {
+               if (!IS_ERR_OR_NULL(new_nodes[i])) {
                        btree_node_free(new_nodes[i]);
                        rw_unlock(true, new_nodes[i]);
                }
--

