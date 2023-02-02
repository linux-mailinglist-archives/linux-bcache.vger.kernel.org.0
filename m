Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D735A687D3B
	for <lists+linux-bcache@lfdr.de>; Thu,  2 Feb 2023 13:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjBBMWq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 2 Feb 2023 07:22:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbjBBMWp (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 2 Feb 2023 07:22:45 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B74E719BD;
        Thu,  2 Feb 2023 04:22:15 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A18731FE38;
        Thu,  2 Feb 2023 12:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1675340527; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7s887PXcrEEBLAv+jcmQ/g1QdFuKJpaS/1Q0bHletfI=;
        b=yrfm5apZrNVowloDvmSxiDYpn7uBHqWUxP/h1QSK2RuPZ+sKCLKy6wDvhulJeE5C8L3Ri4
        8ZGgm2EotNXinXiGpyzlmFzhUF/x6UvXrEycQqGrgevCdAtzvUKe8tC9n3h2RFek1e4eVo
        ZlJ0hJYy1KVEX/0ocS8nWy95S8KrsX4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1675340527;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7s887PXcrEEBLAv+jcmQ/g1QdFuKJpaS/1Q0bHletfI=;
        b=NF4eQGBYhc994GJPoUHxWrHkw2ImvVTtSPXGyz6wnF+LlFw38Ui1ymXEa3zMWCC22k8E64
        UUrkg+n20iMbVrCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 62580139D0;
        Thu,  2 Feb 2023 12:22:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 1t8nC+2q22O5DwAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 02 Feb 2023 12:22:05 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH] bcache: Fix a NULL or wild pointer dereference in
 btree_split
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230202110543.27548-1-zyytlz.wz@163.com>
Date:   Thu, 2 Feb 2023 20:21:52 +0800
Cc:     hackerzheng666@gmail.com,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        security@kernel.org, alex000young@gmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <50656A90-E0D4-4800-880C-406EBDD784FC@suse.de>
References: <20230202110543.27548-1-zyytlz.wz@163.com>
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



> 2023=E5=B9=B42=E6=9C=882=E6=97=A5 19:05=EF=BC=8CZheng Wang =
<zyytlz.wz@163.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> In btree_split, btree_node_alloc_replacement() is assigned to
> n1 and return error code or NULL on failure. n1->c->cache is
> passed to block_bytes. So there is a dereference of it
> without checks, which may lead to wild pointer dereference or
>  NULL pointer dereference depending on n1. The initial code only
>  judge the error code but igore the NULL pointer.
> So does n2 and n3.
>=20
> Fix this bug by adding IS_ERR_OR_NULL check of n1, n2 and n3.
>=20
> Note that, as a bug found by static analysis, it can be a false
> positive or hard to trigger.
>=20
> Fixes: cafe56359144 ("bcache: A block layer cache")
> Signed-off-by: Zheng Wang <zyytlz.wz@163.com>

Hmm, there should be something to be fixed, but not the non-exist NULL =
dereference.

If you look inside btree_node_alloc_replacement(), you may find =
__bch_btree_node_alloc() which does the real work indeed. And yes, I =
would suggest you to improve a bit inside __bch_btree_node_alloc().

1088 struct btree *__bch_btree_node_alloc(struct cache_set *c, struct =
btree_op *op,
[snipped]
1093         struct btree *b =3D ERR_PTR(-EAGAIN);
1094
1095         mutex_lock(&c->bucket_lock);
1096 retry:
1097         if (__bch_bucket_alloc_set(c, RESERVE_BTREE, &k.key, wait))
1098                 goto err;
[snipped]
1102
1103         b =3D mca_alloc(c, op, &k.key, level);
1104         if (IS_ERR(b))
1105                 goto err_free;
1106
1107         if (!b) {
1108                 cache_bug(c,
1109                         "Tried to allocate bucket that was in btree =
cache");
1110                 goto retry;
1111         }
1112

=46rom the above code, at line 1097 if __bch_bucket_alloc_set() returns =
non-zero value, the code will jump to label err: and returns =
ERR_PTR(-EAGAIN). But if the code fails at line 1103 and b is set to =
NULL, at line 1110 the code will jump back to label retry: and calls =
__bch_bucket_alloc_set() again. If the second time =
__bch_bucket_alloc_set() returns non-zero value and the code jumps to =
label err:, a NULL pointer other than ERR_PTR(-EAGAIN) will be returned. =
This inconsistent return value on same location at line 1097 seems =
incorrect, where ERR_PTR(-EAGAIN) should be returned IMHO.

Therefore I feel that =E2=80=9Cb =3D ERR_PTR(-EAGAIN)=E2=80=9D should be =
moved to the location after label retry:, then =
btree_node_alloc_replacement() will only return error code, and no NULL =
pointer returned.

After this change, all following IS_ERR_OR_NULL() checks to =
btree_node_alloc_replacement() are unnecessary and IS_ERR() just enough, =
because no NULL will be returned.

This is a nice catch. I=E2=80=99d like to have it to be fixed. I do =
appreciate if you want to compose two patches for the fix. Otherwise I =
can handle it myself.

Thanks.

Coly Li


> ---
> drivers/md/bcache/btree.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 147c493a989a..d5ed382fc43c 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -2206,7 +2206,7 @@ static int btree_split(struct btree *b, struct =
btree_op *op,
> }
>=20
> n1 =3D btree_node_alloc_replacement(b, op);
> - if (IS_ERR(n1))
> + if (IS_ERR_OR_NULL(n1))
> goto err;
>=20
> split =3D set_blocks(btree_bset_first(n1),
> @@ -2218,12 +2218,12 @@ static int btree_split(struct btree *b, struct =
btree_op *op,
> trace_bcache_btree_node_split(b, btree_bset_first(n1)->keys);
>=20
> n2 =3D bch_btree_node_alloc(b->c, op, b->level, b->parent);
> - if (IS_ERR(n2))
> + if (IS_ERR_OR_NULL(n2))
> goto err_free1;
>=20
> if (!b->parent) {
> n3 =3D bch_btree_node_alloc(b->c, op, b->level + 1, NULL);
> - if (IS_ERR(n3))
> + if (IS_ERR_OR_NULL(n3))
> goto err_free2;
> }
>=20
> --=20
> 2.25.1
>=20

