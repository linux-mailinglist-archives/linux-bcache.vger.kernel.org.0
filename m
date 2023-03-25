Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 020986C8F50
	for <lists+linux-bcache@lfdr.de>; Sat, 25 Mar 2023 17:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbjCYQHb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 25 Mar 2023 12:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjCYQHa (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 25 Mar 2023 12:07:30 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EC6F976;
        Sat, 25 Mar 2023 09:07:30 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 88E841F88E;
        Sat, 25 Mar 2023 16:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1679760448; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/wrcKTOyKKLl4KxzViMJuBcOP/Htody2AvtKtxGcmFE=;
        b=zRFqn86bTnX6AKYZrJ7rBg3wTRJOuoZ9PWH0nkUPN3gyuk+BLtpZ3x8eFdOVKLDhxn4VxT
        wCBjq7/zd+EZ4MaWcRos2poVg5sTXcuXvyBBD59Gp0AiA5OwKlNrgwEERMPOXUp8y/kiKC
        nsrcKWBNFigH+uH7lcZ80azmf74RZzc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1679760448;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/wrcKTOyKKLl4KxzViMJuBcOP/Htody2AvtKtxGcmFE=;
        b=XqLb0blSKlrNnXCM+Fkw7orUi0ryWbaJar0TKnH+HDJ2Cniog8HFCjeZocGXZhg5DVFHzB
        X07C9ONzZLBPWRCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2639713413;
        Sat, 25 Mar 2023 16:07:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HZ3ANz4cH2RwSgAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 25 Mar 2023 16:07:26 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.400.51.1.1\))
Subject: Re: [PATCH v2] bcache: Fix exception handling in mca_alloc()
From:   Coly Li <colyli@suse.de>
In-Reply-To: <13b4a57a-5911-16db-2b6e-588e5137c3aa@web.de>
Date:   Sun, 26 Mar 2023 00:07:14 +0800
Cc:     kernel-janitors@vger.kernel.org, linux-bcache@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>, cocci@inria.fr,
        LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <BE6CEE57-E9AF-4F17-B281-1E00C5DC2A9C@suse.de>
References: <f9303bdc-b1a7-be5e-56c6-dfa8232b8b55@web.de>
 <e33f264a-7ee9-4ebc-d58e-bbb7fd567198@web.de>
 <d0381c8e-7302-b0ed-cf69-cbc8c3618106@web.de>
 <157b8db9-82f7-85e7-3bbd-7ef3a1797892@suse.de>
 <13b4a57a-5911-16db-2b6e-588e5137c3aa@web.de>
To:     Markus Elfring <Markus.Elfring@web.de>
X-Mailer: Apple Mail (2.3731.400.51.1.1)
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B43=E6=9C=8825=E6=97=A5 20:21=EF=BC=8CMarkus Elfring =
<Markus.Elfring@web.de> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Date: Sat, 25 Mar 2023 13:08:01 +0100
>=20
> The label =E2=80=9Cerr=E2=80=9D was used to jump to another pointer =
check despite of
> the detail in the implementation of the function =E2=80=9Cmca_alloc=E2=80=
=9D
> that it was determined already that a corresponding variable contained
> a null pointer because of a failed function call =
=E2=80=9Cmca_bucket_alloc=E2=80=9D.
>=20
> 1. Thus use more appropriate labels instead.

It is not convinced to me that the new added labels are more =
appropriate. IMHO, the change just makes the code to be more =
complicated.


>=20
> 2. Delete a repeated check (for the variable =E2=80=9Cb=E2=80=9D)
>   which became unnecessary with this refactoring.
>=20

To remove one line =E2=80=98if=E2=80=99 check, 13 lines are changed. =
IMHO this is not worthy. Yes the extra =E2=80=98if=E2=80=99 check can be =
avoided, but the code is more simple before adding labels unlock and =
cannibalize_mca.

The =E2=80=98if=E2=80=99 check is in error handling, which is not hot =
code path. Comparing to avoid an =E2=80=98if=E2=80=99 check, I prefer =
more for more simpler code. I am not supportive to this change.


Thanks.

Coly Li


>=20
> This issue was detected by using the Coccinelle software.
>=20
> Fixes: cafe563591446cf80bfbc2fe3bc72a2e36cf1060 ("bcache: A block =
layer cache")
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
> V2:
> Use another label.
>=20
> drivers/md/bcache/btree.c | 13 ++++++-------
> 1 file changed, 6 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 147c493a989a..c6a20595302f 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -921,18 +921,18 @@ static struct btree *mca_alloc(struct cache_set =
*c, struct btree_op *op,
> if (!mca_reap(b, 0, false)) {
> mca_data_alloc(b, k, __GFP_NOWARN|GFP_NOIO);
> if (!b->keys.set[0].data)
> - goto err;
> + goto unlock;
> else
> goto out;
> }
>=20
> b =3D mca_bucket_alloc(c, k, __GFP_NOWARN|GFP_NOIO);
> if (!b)
> - goto err;
> + goto cannibalize_mca;
>=20
> BUG_ON(!down_write_trylock(&b->lock));
> if (!b->keys.set->data)
> - goto err;
> + goto unlock;
> out:
> BUG_ON(b->io_mutex.count !=3D 1);
>=20
> @@ -955,10 +955,9 @@ static struct btree *mca_alloc(struct cache_set =
*c, struct btree_op *op,
>    &b->c->expensive_debug_checks);
>=20
> return b;
> -err:
> - if (b)
> - rw_unlock(true, b);
> -
> +unlock:
> + rw_unlock(true, b);
> +cannibalize_mca:
> b =3D mca_cannibalize(c, op, k);
> if (!IS_ERR(b))
> goto out;
> --
> 2.40.0
>=20

