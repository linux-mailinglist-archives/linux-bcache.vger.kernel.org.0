Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6A8D7BC7AB
	for <lists+linux-bcache@lfdr.de>; Sat,  7 Oct 2023 14:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343867AbjJGMmO (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 7 Oct 2023 08:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343882AbjJGMmN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 7 Oct 2023 08:42:13 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37CDBC
        for <linux-bcache@vger.kernel.org>; Sat,  7 Oct 2023 05:42:11 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 347392187B;
        Sat,  7 Oct 2023 12:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696682530; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kEHTwT3/InJKpf/kooIJVzDTGkwvh6DLha/Wkt+GLd0=;
        b=Y5EMtcs++jYfySwv/0PIRFezqYsFn7tHGtnBqhhderIOgq5VemPKzr1B1GAt8KkV4oIDSQ
        EBI73xw9Zm2nQ2o96skYAG8D+ujy48y7awLFPq5EEv82s2Pd0UV2f8jrd9zDEEpCok53Us
        P6HRRKZije/IUpSoqU5oXE5DZpkJhPo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696682530;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kEHTwT3/InJKpf/kooIJVzDTGkwvh6DLha/Wkt+GLd0=;
        b=F8j4hoVRqruLCpG6k7lMhfKTLHeT5E3E4QVmho8G3VFmDakqSo/EWPlvwL/bCB7nKd7vaZ
        ooHlhQFmgOlR0HCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6E02C13479;
        Sat,  7 Oct 2023 12:42:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id eduECiBSIWUgagAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 07 Oct 2023 12:42:08 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.700.6\))
Subject: Re: [PATCH] bcache: Fixup error handling in register_cache()
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20231004093757.11560-1-jack@suse.cz>
Date:   Sat, 7 Oct 2023 20:41:55 +0800
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <82ACE5AB-5FDB-4598-A384-EF904F394821@suse.de>
References: <20231004093757.11560-1-jack@suse.cz>
To:     Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>
X-Mailer: Apple Mail (2.3731.700.6)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B410=E6=9C=884=E6=97=A5 17:37=EF=BC=8CJan Kara =
<jack@suse.cz> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Coverity has noticed that the printing of error message in
> register_cache() uses already freed bdev_handle to get to bdev. In =
fact
> the problem has been there even before commit "bcache: Convert to
> bdev_open_by_path()" just a bit more subtle one - cache object itself
> could have been freed by the time we looked at ca->bdev and we don't
> hold any reference to bdev either so even that could in principle go
> away (due to device unplug or similar). Fix all these problems by
> printing the error message before closing the bdev.
>=20
> Fixes: dc893f51d24a ("bcache: Convert to bdev_open_by_path()")
> Signed-off-by: Jan Kara <jack@suse.cz>

Asked-by: Coly Li <colyli@suse.de <mailto:colyli@suse.de>>

Thanks.

Coly Li

> ---
> drivers/md/bcache/super.c | 23 ++++++++++-------------
> 1 file changed, 10 insertions(+), 13 deletions(-)
>=20
> Hello Christian!
>=20
> Can you please add this to patch to the bdev_handle conversion series? =
Either
> append it at the end of the series or just fold it into the bcache =
conversion.
> Whatever looks better for you.
>=20
>=20
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index c11ac86be72b..a30c8d4f2ac8 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2354,6 +2354,13 @@ static int register_cache(struct cache_sb *sb, =
struct cache_sb_disk *sb_disk,
>=20
> ret =3D cache_alloc(ca);
> if (ret !=3D 0) {
> + if (ret =3D=3D -ENOMEM)
> + err =3D "cache_alloc(): -ENOMEM";
> + else if (ret =3D=3D -EPERM)
> + err =3D "cache_alloc(): cache device is too small";
> + else
> + err =3D "cache_alloc(): unknown error";
> + pr_notice("error %pg: %s\n", bdev_handle->bdev, err);
> /*
> * If we failed here, it means ca->kobj is not initialized yet,
> * kobject_put() won't be called and there is no chance to
> @@ -2361,17 +2368,12 @@ static int register_cache(struct cache_sb *sb, =
struct cache_sb_disk *sb_disk,
> * we explicitly call bdev_release() here.
> */
> bdev_release(bdev_handle);
> - if (ret =3D=3D -ENOMEM)
> - err =3D "cache_alloc(): -ENOMEM";
> - else if (ret =3D=3D -EPERM)
> - err =3D "cache_alloc(): cache device is too small";
> - else
> - err =3D "cache_alloc(): unknown error";
> - goto err;
> + return ret;
> }
>=20
> if (kobject_add(&ca->kobj, bdev_kobj(bdev_handle->bdev), "bcache")) {
> - err =3D "error calling kobject_add";
> + pr_notice("error %pg: error calling kobject_add\n",
> +  bdev_handle->bdev);
> ret =3D -ENOMEM;
> goto out;
> }
> @@ -2389,11 +2391,6 @@ static int register_cache(struct cache_sb *sb, =
struct cache_sb_disk *sb_disk,
>=20
> out:
> kobject_put(&ca->kobj);
> -
> -err:
> - if (err)
> - pr_notice("error %pg: %s\n", ca->bdev_handle->bdev, err);
> -
> return ret;
> }
>=20
> --=20
> 2.35.3
>=20

