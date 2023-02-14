Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17806695FC6
	for <lists+linux-bcache@lfdr.de>; Tue, 14 Feb 2023 10:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbjBNJvq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 14 Feb 2023 04:51:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbjBNJvZ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 14 Feb 2023 04:51:25 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20156C646;
        Tue, 14 Feb 2023 01:51:24 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CB94221B27;
        Tue, 14 Feb 2023 09:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1676368282; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kmEsisc8HGG/itaYQyOu7jAb/bBfc0A0mU8rTWWYPkc=;
        b=rp3cJ/B7qjS8tEc49d0gmLj52sE01hvL6rWlCCkLKPmqjnP4tZapwHW94/MgymWkiFcVvf
        XHjJh/Qjzmig1YxtS+qCkI8L8K47PECirKW4RrmilcMyspQi/RPpycXVbVkY3CEHSkkjX7
        voVxZx+EeMPdKlQcy32PdxH0+lOFGAE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1676368282;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kmEsisc8HGG/itaYQyOu7jAb/bBfc0A0mU8rTWWYPkc=;
        b=3xFPESwrcOSa9PyDtSqAeNvNAyyyDzAxuvU/usupyHfsH//pHWSV1gTfFJ05McEPbyyHkS
        hOdPRyDsLZmCHGAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C99AD13A21;
        Tue, 14 Feb 2023 09:51:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id cDyvJZlZ62PmTwAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 14 Feb 2023 09:51:21 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH] bcache: make kobj_type structures constant
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230214-kobj_type-bcache-v1-1-cf00ead7bee7@weissschuh.net>
Date:   Tue, 14 Feb 2023 17:51:09 +0800
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <125CA8D6-D3B7-42FB-83BE-DCA688F2ACAF@suse.de>
References: <20230214-kobj_type-bcache-v1-1-cf00ead7bee7@weissschuh.net>
To:     =?utf-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B42=E6=9C=8814=E6=97=A5 11:13=EF=BC=8CThomas Wei=C3=9Fschuh =
<linux@weissschuh.net> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Since commit ee6d3dd4ed48 ("driver core: make kobj_type constant.")
> the driver core allows the usage of const struct kobj_type.
>=20
> Take advantage of this to constify the structure definitions to =
prevent
> modification at runtime.
>=20

How the const structure definition can prevent modification at run time?

Thanks.

Coly Li


> Signed-off-by: Thomas Wei=C3=9Fschuh <linux@weissschuh.net>
> ---
> drivers/md/bcache/bcache.h | 10 +++++-----
> drivers/md/bcache/sysfs.h  |  2 +-
> 2 files changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index aebb7ef10e63..a522f4f1f992 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -1004,11 +1004,11 @@ extern struct workqueue_struct *bch_flush_wq;
> extern struct mutex bch_register_lock;
> extern struct list_head bch_cache_sets;
>=20
> -extern struct kobj_type bch_cached_dev_ktype;
> -extern struct kobj_type bch_flash_dev_ktype;
> -extern struct kobj_type bch_cache_set_ktype;
> -extern struct kobj_type bch_cache_set_internal_ktype;
> -extern struct kobj_type bch_cache_ktype;
> +extern const struct kobj_type bch_cached_dev_ktype;
> +extern const struct kobj_type bch_flash_dev_ktype;
> +extern const struct kobj_type bch_cache_set_ktype;
> +extern const struct kobj_type bch_cache_set_internal_ktype;
> +extern const struct kobj_type bch_cache_ktype;
>=20
> void bch_cached_dev_release(struct kobject *kobj);
> void bch_flash_dev_release(struct kobject *kobj);
> diff --git a/drivers/md/bcache/sysfs.h b/drivers/md/bcache/sysfs.h
> index a2ff6447b699..65b8bd975ab1 100644
> --- a/drivers/md/bcache/sysfs.h
> +++ b/drivers/md/bcache/sysfs.h
> @@ -3,7 +3,7 @@
> #define _BCACHE_SYSFS_H_
>=20
> #define KTYPE(type) \
> -struct kobj_type type ## _ktype =3D { \
> +const struct kobj_type type ## _ktype =3D { \
> .release =3D type ## _release, \
> .sysfs_ops =3D &((const struct sysfs_ops) { \
> .show =3D type ## _show, \
>=20
> ---
> base-commit: f6feea56f66d34259c4222fa02e8171c4f2673d1
> change-id: 20230214-kobj_type-bcache-6d2bd129b0fa
>=20
> Best regards,
> --=20
> Thomas Wei=C3=9Fschuh <linux@weissschuh.net>
>=20

