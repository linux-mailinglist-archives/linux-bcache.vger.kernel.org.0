Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C8A706A44
	for <lists+linux-bcache@lfdr.de>; Wed, 17 May 2023 15:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbjEQN44 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 17 May 2023 09:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjEQN44 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 17 May 2023 09:56:56 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 815AC12F
        for <linux-bcache@vger.kernel.org>; Wed, 17 May 2023 06:56:54 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1EF1C22395;
        Wed, 17 May 2023 13:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1684331813; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AS1joZDyt/CmuC+0PLJCA/zkluXSl4O7sbRqR8rzpV0=;
        b=L7ubrObC9i+aF1hG0hC3MEDdadrts/WD/i7QZiMYFDwyjjmYonvdxyzaw3jh/jISyIUFo0
        O6PZq7OKbed8bFcJ6akppczHktixm2rsb9VFRNlWnwMiwakSUMD8qOzsRdtBQSWpy0koAt
        91ZbUj9j78tn+Avx5xFjIer9JSzj3h4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1684331813;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AS1joZDyt/CmuC+0PLJCA/zkluXSl4O7sbRqR8rzpV0=;
        b=/xB5CbxZlz5PyywVYCWXPyQjGlGM9zx81M0kStJFbYIN2s/Sh7s5uYLMSPurEZ6bSUUFeV
        zWYIB6H7DV3pT4DQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0B13513478;
        Wed, 17 May 2023 13:56:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id N2KQASXdZGSjVgAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 17 May 2023 13:56:53 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH] bcache: fix nbuckets lower limit checking in
 read_super_common
From:   Coly Li <colyli@suse.de>
In-Reply-To: <84456adb-2933-49a4-cf40-b58b19ddd178@wangsu.com>
Date:   Wed, 17 May 2023 15:56:42 +0200
Cc:     Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <DE163AE2-BC0A-4DFC-9987-24E5FFFAFCB0@suse.de>
References: <84456adb-2933-49a4-cf40-b58b19ddd178@wangsu.com>
To:     Lin Feng <linf@wangsu.com>
X-Mailer: Apple Mail (2.3731.500.231)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B45=E6=9C=8817=E6=97=A5 11:51=EF=BC=8CLin Feng =
<linf@wangsu.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> In fact due to this check in cache_alloc:
>    free =3D roundup_pow_of_two(ca->sb.nbuckets) >> 10;

This was introduced from commit 78365411b344d (=E2=80=9Cbcache: Rework =
allocator reserves=E2=80=9D).
-       free =3D roundup_pow_of_two(ca->sb.nbuckets) >> 9;
-       free =3D max_t(size_t, free, (prio_buckets(ca) + 8) * 2);
+       free =3D roundup_pow_of_two(ca->sb.nbuckets) >> 10;

>    if (!free) {
>        ret =3D -EPERM;
>        err =3D "ca->sb.nbuckets is too small";
>        goto err_free;
>    }
> we can only create bcache device with nbuckets greater than 512,
> so this patch is to make the codes logic consistent.
>=20
> Signed-off-by: Lin Feng <linf@wangsu.com>
> ---
> drivers/md/bcache/super.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 7e9d19fd21dd..681a7ea442b9 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -110,7 +110,7 @@ static const char *read_super_common(struct =
cache_sb *sb,  struct block_device *
> goto err;
>=20
> err =3D "Not enough buckets";
> - if (sb->nbuckets < 1 << 7)
> + if (sb->nbuckets <=3D 1 << 9)

if (roundup_pow_of_two(ca->sb.nbuckets) < 1<< 10)

Might be more clear?

> goto err;
>=20
> err =3D "Bad block size (not power of 2)";




In bcache-tools the minimum nbuckets is (1<<7) too. It is fine to modify =
it to 1<<10, I will modify bcache-tools too.

Nice catch, thanks!


Coly=
