Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 164C3688545
	for <lists+linux-bcache@lfdr.de>; Thu,  2 Feb 2023 18:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbjBBRUE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 2 Feb 2023 12:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232545AbjBBRUC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 2 Feb 2023 12:20:02 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A547B2B626;
        Thu,  2 Feb 2023 09:19:59 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id v3so1816141pgh.4;
        Thu, 02 Feb 2023 09:19:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LBhU5vxFQWiGkZ1Ym1DhxsTa46TKoDmY8TSwDgIfrcA=;
        b=j6ugQEAth2CJuXBVM7zd3QWC9vX/lDyxoKyO7dHeCODFaQ7aQ1A7I6yC2IlpzseVMH
         ovZ7teT3CLsK2B7Wny80ef/4Daq2zmpzjV2TTT0CbWlKYzYVEJGjLteG8p24AzMFcU/X
         hTrJK3Pl79UBXVpEPMMJ5CCINrf3/u01HAjyO/aukeZN0VRzMCcs90lHcVD5GRidMD/0
         0/dS23FBkB7LlYcTiKwq+K0srdfVdNXJuvVoxUd/IRVU395Yugz0Iup/YrhZ8bsx5IwH
         +3KrZPsFxgF+hL9FKmG/UNXE71cEx0/shvGaNF+Hjt0aW6WGOE2qzwQSjeDrWs+F/4UI
         g9UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LBhU5vxFQWiGkZ1Ym1DhxsTa46TKoDmY8TSwDgIfrcA=;
        b=lGgKgcKl9duKeu7hMoEXtUjjusX0oSJUOtwQ8bwHVgonKwgoUKxSGsa2WnSC/Jtcvl
         50MfZg9x1C6UrdIETaCv5RRIOJqn/UX8yzykX/pYTksOLK3I83qEEeQ7+1lr6UFr4ZcQ
         5Hlu79/ivu2Ag8tGwtcr79Iy9KxECvcGkq1vGp7w5tLOqqzTn06DAcRkzlZEmSIStQi9
         aSxWO7ikcKI4tgn6PyoVkErVBvZjintVRJZJpIbFYe4/KrViUDZHWd9ti41ZYcT6zzgh
         fHqzUdDWo4dTzBIXgd8oiW3oRvu7SqMoaW9hsVgOmybR3Vtenry6aIhCNyoRGx9/O8jv
         l7Fg==
X-Gm-Message-State: AO0yUKUAF1oO9VlRTGpZf9DMwY9G9Ssb/EPptnbK9KP++2UkgytEQLWb
        a8QePA4PfSOFwJMibwVxkgOffHf9CeOGPWZarG0=
X-Google-Smtp-Source: AK7set++U/x9d1ue4wwOlpibFnwGdM6lnb5yrJcbsm5Yidl4/qHjy7Rul6UOloTRu/EKfH5fmW6VPoCDmy/htze4SGo=
X-Received: by 2002:a63:5150:0:b0:4d0:370b:5027 with SMTP id
 r16-20020a635150000000b004d0370b5027mr1221968pgl.8.1675358398948; Thu, 02 Feb
 2023 09:19:58 -0800 (PST)
MIME-Version: 1.0
References: <20230202151504.542958-1-zyytlz.wz@163.com> <965141BE-C3CB-4C15-9B12-381BB463325B@suse.de>
In-Reply-To: <965141BE-C3CB-4C15-9B12-381BB463325B@suse.de>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Fri, 3 Feb 2023 01:19:46 +0800
Message-ID: <CAJedcCyXkUGGXwxXs8Q7u+x94ZH2MbKEBV-Fp557hESDuF0gbA@mail.gmail.com>
Subject: Re: [PATCH] bcache: Fix __bch_btree_node_alloc to make the failure
 behavior consistent
To:     Coly Li <colyli@suse.de>
Cc:     Zheng Wang <zyytlz.wz@163.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        alex000young@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Coly Li <colyli@suse.de> =E4=BA=8E2023=E5=B9=B42=E6=9C=883=E6=97=A5=E5=91=
=A8=E4=BA=94 00:23=E5=86=99=E9=81=93=EF=BC=9A
>
>
>
> > 2023=E5=B9=B42=E6=9C=882=E6=97=A5 23:15=EF=BC=8CZheng Wang <zyytlz.wz@1=
63.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > In some specific situation, the return value of __bch_btree_node_alloc =
may
> > be NULL. This may lead to poential NULL pointer dereference in caller
> > function like a calling chaion :
> > btree_split->bch_btree_node_alloc->__bch_btree_node_alloc.
> >
> > Fix it by initialize return value in __bch_btree_node_alloc before retu=
rn.
> >
> > Fixes: cafe56359144 ("bcache: A block layer cache")
> > Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> > ---
> > drivers/md/bcache/btree.c | 10 ++++++----
> > drivers/md/bcache/super.c |  2 +-
> > 2 files changed, 7 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> > index 147c493a989a..35346c1d7c3c 100644
> > --- a/drivers/md/bcache/btree.c
> > +++ b/drivers/md/bcache/btree.c
> > @@ -1090,10 +1090,12 @@ struct btree *__bch_btree_node_alloc(struct cac=
he_set *c, struct btree_op *op,
> >     struct btree *parent)
> > {
> > BKEY_PADDED(key) k;
> > - struct btree *b =3D ERR_PTR(-EAGAIN);
> > + struct btree *b;
> >
> > mutex_lock(&c->bucket_lock);
> > retry:
> > + /* return ERR_PTR(-EAGAIN) when it fails */
> > + b =3D ERR_PTR(-EAGAIN);
> > if (__bch_bucket_alloc_set(c, RESERVE_BTREE, &k.key, wait))
> > goto err;
> >
>
>
> The above change can be a single patch.
>
> And the rested change can be another cleanup patch.
>
> > @@ -1138,7 +1140,7 @@ static struct btree *btree_node_alloc_replacement=
(struct btree *b,
> > {
> > struct btree *n =3D bch_btree_node_alloc(b->c, op, b->level, b->parent)=
;
> >
> > - if (!IS_ERR_OR_NULL(n)) {
> > + if (!IS_ERR(n)) {
> > mutex_lock(&n->write_lock);
> > bch_btree_sort_into(&b->keys, &n->keys, &b->c->sort);
> > bkey_copy_key(&n->key, &b->key);
> > @@ -1352,7 +1354,7 @@ static int btree_gc_coalesce(struct btree *b, str=
uct btree_op *op,
> >
> > for (i =3D 0; i < nodes; i++) {
> > new_nodes[i] =3D btree_node_alloc_replacement(r[i].b, NULL);
> > - if (IS_ERR_OR_NULL(new_nodes[i]))
> > + if (IS_ERR(new_nodes[i]))
> > goto out_nocoalesce;
> > }
> >
> > @@ -1669,7 +1671,7 @@ static int bch_btree_gc_root(struct btree *b, str=
uct btree_op *op,
> > if (should_rewrite) {
> > n =3D btree_node_alloc_replacement(b, NULL);
> >
> > - if (!IS_ERR_OR_NULL(n)) {
> > + if (!IS_ERR(n)) {
> > bch_btree_node_write_sync(n);
> >
> > bch_btree_set_root(n);
> > diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> > index ba3909bb6bea..92de714fe75e 100644
> > --- a/drivers/md/bcache/super.c
> > +++ b/drivers/md/bcache/super.c
> > @@ -2088,7 +2088,7 @@ static int run_cache_set(struct cache_set *c)
> >
> > err =3D "cannot allocate new btree root";
> > c->root =3D __bch_btree_node_alloc(c, NULL, 0, true, NULL);
> > - if (IS_ERR_OR_NULL(c->root))
> > + if (IS_ERR(c->root))
> > goto err;
> >
> > mutex_lock(&c->root->write_lock);
>
> And there will be 2 patches as I suggested.
>

Got it. It's a little bit late now. I might make that tomorrow ^_^

Best regards,
Zheng Wang
