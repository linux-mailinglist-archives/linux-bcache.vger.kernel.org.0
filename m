Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 620D1688443
	for <lists+linux-bcache@lfdr.de>; Thu,  2 Feb 2023 17:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbjBBQX4 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 2 Feb 2023 11:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbjBBQXl (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 2 Feb 2023 11:23:41 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65CF6A312;
        Thu,  2 Feb 2023 08:23:26 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BC0412011C;
        Thu,  2 Feb 2023 16:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1675355001; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DuUnQiFQse3SiEKTHp7WSzRk+wVDvj4om774rJ+p9VE=;
        b=wRhfDI+giilTK6JU4B7KYoCpaiWuIsYN1ThNjE1UIUVuQJCnG8fYUL3WE994ALfVXNDGjd
        sxFdtKRJTPbBLFxgTkDiVQ6rF/1AdFVQtInx6b/oLCG4lnizx3EXgm1e0chSxX8P7GpYxo
        FjQZXyVR+DuU1LwOLcMpY+pgwmuCz0I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1675355001;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DuUnQiFQse3SiEKTHp7WSzRk+wVDvj4om774rJ+p9VE=;
        b=nQR9dFDug6ds6UtLBZMt+aLEGKHeJGMoIKVNHSNyYVLaQSHGz8maWlBsFLtz51OF24AVC0
        aAz7IMEqwZ58/4CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 311F5138E8;
        Thu,  2 Feb 2023 16:23:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id lFoWOnfj22ONBgAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 02 Feb 2023 16:23:19 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH] bcache: Fix __bch_btree_node_alloc to make the failure
 behavior consistent
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230202151504.542958-1-zyytlz.wz@163.com>
Date:   Fri, 3 Feb 2023 00:23:06 +0800
Cc:     Zheng Hacker <hackerzheng666@gmail.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        alex000young@gmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <965141BE-C3CB-4C15-9B12-381BB463325B@suse.de>
References: <20230202151504.542958-1-zyytlz.wz@163.com>
To:     Zheng Wang <zyytlz.wz@163.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B42=E6=9C=882=E6=97=A5 23:15=EF=BC=8CZheng Wang =
<zyytlz.wz@163.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> In some specific situation, the return value of __bch_btree_node_alloc =
may
> be NULL. This may lead to poential NULL pointer dereference in caller
> function like a calling chaion :
> btree_split->bch_btree_node_alloc->__bch_btree_node_alloc.
>=20
> Fix it by initialize return value in __bch_btree_node_alloc before =
return.
>=20
> Fixes: cafe56359144 ("bcache: A block layer cache")
> Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> ---
> drivers/md/bcache/btree.c | 10 ++++++----
> drivers/md/bcache/super.c |  2 +-
> 2 files changed, 7 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 147c493a989a..35346c1d7c3c 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -1090,10 +1090,12 @@ struct btree *__bch_btree_node_alloc(struct =
cache_set *c, struct btree_op *op,
>     struct btree *parent)
> {
> BKEY_PADDED(key) k;
> - struct btree *b =3D ERR_PTR(-EAGAIN);
> + struct btree *b;
>=20
> mutex_lock(&c->bucket_lock);
> retry:
> + /* return ERR_PTR(-EAGAIN) when it fails */
> + b =3D ERR_PTR(-EAGAIN);
> if (__bch_bucket_alloc_set(c, RESERVE_BTREE, &k.key, wait))
> goto err;
>=20


The above change can be a single patch.

And the rested change can be another cleanup patch.

> @@ -1138,7 +1140,7 @@ static struct btree =
*btree_node_alloc_replacement(struct btree *b,
> {
> struct btree *n =3D bch_btree_node_alloc(b->c, op, b->level, =
b->parent);
>=20
> - if (!IS_ERR_OR_NULL(n)) {
> + if (!IS_ERR(n)) {
> mutex_lock(&n->write_lock);
> bch_btree_sort_into(&b->keys, &n->keys, &b->c->sort);
> bkey_copy_key(&n->key, &b->key);
> @@ -1352,7 +1354,7 @@ static int btree_gc_coalesce(struct btree *b, =
struct btree_op *op,
>=20
> for (i =3D 0; i < nodes; i++) {
> new_nodes[i] =3D btree_node_alloc_replacement(r[i].b, NULL);
> - if (IS_ERR_OR_NULL(new_nodes[i]))
> + if (IS_ERR(new_nodes[i]))
> goto out_nocoalesce;
> }
>=20
> @@ -1669,7 +1671,7 @@ static int bch_btree_gc_root(struct btree *b, =
struct btree_op *op,
> if (should_rewrite) {
> n =3D btree_node_alloc_replacement(b, NULL);
>=20
> - if (!IS_ERR_OR_NULL(n)) {
> + if (!IS_ERR(n)) {
> bch_btree_node_write_sync(n);
>=20
> bch_btree_set_root(n);
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index ba3909bb6bea..92de714fe75e 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2088,7 +2088,7 @@ static int run_cache_set(struct cache_set *c)
>=20
> err =3D "cannot allocate new btree root";
> c->root =3D __bch_btree_node_alloc(c, NULL, 0, true, NULL);
> - if (IS_ERR_OR_NULL(c->root))
> + if (IS_ERR(c->root))
> goto err;
>=20
> mutex_lock(&c->root->write_lock);

And there will be 2 patches as I suggested.

Thanks.

Coly Li

