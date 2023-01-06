Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B6D66016D
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Jan 2023 14:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbjAFNjq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 6 Jan 2023 08:39:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjAFNjd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Jan 2023 08:39:33 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0F96169;
        Fri,  6 Jan 2023 05:39:32 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DA6023F541;
        Fri,  6 Jan 2023 13:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673012370; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a3xS9J4Ev7cI3vqp+nZg9a5psmAQ7Jxm1E4l2JxtFMk=;
        b=XzuAEf49pLMJ03gIabASS5tus7Ya1yP5EgX8CqH0oX4iQr/e/FCXok+fh3B32S36SrZdsu
        o00yApTqHpak62hZa391Ylx0gtGz9bhEKQE+q8xb8gAi17QCCTBxKU1WdeK1wyi9KUqjjK
        NSmnMCOf+8+uFy+VwwtyobgORi4awAk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673012370;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a3xS9J4Ev7cI3vqp+nZg9a5psmAQ7Jxm1E4l2JxtFMk=;
        b=HOgZ557iqj0LmRSn5O93Zcy+M08NS+xwPrFKw1RF/BOiFbXk+N1CudPs37INCtlX3uFpY5
        /y/IUtkj5cSy1wAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 670E713596;
        Fri,  6 Jan 2023 13:39:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id rDcuDZEkuGOQYgAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 06 Jan 2023 13:39:29 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH] bcache: Silence memcpy() run-time false positive warnings
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230106060229.never.047-kees@kernel.org>
Date:   Fri, 6 Jan 2023 21:39:16 +0800
Cc:     Thorsten Leemhuis <linux@leemhuis.info>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <CBD781CA-342F-482A-A5B0-C4EE2D7FE11B@suse.de>
References: <20230106060229.never.047-kees@kernel.org>
To:     Kees Cook <keescook@chromium.org>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B41=E6=9C=886=E6=97=A5 14:02=EF=BC=8CKees Cook =
<keescook@chromium.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> struct bkey has internal padding in a union, but it isn't always named
> the same (e.g. key ## _pad, key_p, etc). This makes it extremely hard
> for the compiler to reason about the available size of copies done
> against such keys. Use unsafe_memcpy() for now, to silence the many
> run-time false positive warnings:
>=20

The keys is embedded in multiple data structures as a generalized model =
with some helpers, bkey_bytes() is one of them.

It is not surprised for such feeling when people read the code at first =
glance. And thank you for improving it :-)


>  memcpy: detected field-spanning write (size 264) of single field =
"&i->j" at drivers/md/bcache/journal.c:152 (size 240)
>  memcpy: detected field-spanning write (size 24) of single field =
"&b->key" at drivers/md/bcache/btree.c:939 (size 16)
>  emcpy: detected field-spanning write (size 24) of single field =
"&temp.key" at drivers/md/bcache/extents.c:428 (size 16)
>=20

How does the above information can be founded? Should I use llvm and =
enable FORTIFY_SOURCE?

I don=E2=80=99t say the bkey and bkey_bytes() stuffs are elegant, but =
why the compiler cannot find such situation? IMHO it is quite similar to =
something like =E2=80=9Cstruct foo *bar[0]=E2=80=9D at the end of a data =
structure.


> Reported-by: Thorsten Leemhuis <linux@leemhuis.info>
> Link: =
https://lore.kernel.org/all/19200730-a3ba-6f4f-bb81-71339bdbbf73@leemhuis.=
info/
> Cc: Coly Li <colyli@suse.de>
> Cc: Kent Overstreet <kent.overstreet@gmail.com>
> Cc: linux-bcache@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

The code comments as justification is informative. Thanks for this.

Acked-by: Coly Li <colyli@suse.de>


Coly Li


> ---
> drivers/md/bcache/bcache_ondisk.h | 3 ++-
> drivers/md/bcache/journal.c       | 3 ++-
> 2 files changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/bcache/bcache_ondisk.h =
b/drivers/md/bcache/bcache_ondisk.h
> index d086a0ce4bc2..6620a7f8fffc 100644
> --- a/drivers/md/bcache/bcache_ondisk.h
> +++ b/drivers/md/bcache/bcache_ondisk.h
> @@ -106,7 +106,8 @@ static inline unsigned long bkey_bytes(const =
struct bkey *k)
> return bkey_u64s(k) * sizeof(__u64);
> }
>=20
> -#define bkey_copy(_dest, _src) memcpy(_dest, _src, bkey_bytes(_src))
> +#define bkey_copy(_dest, _src) unsafe_memcpy(_dest, _src, =
bkey_bytes(_src), \
> + /* bkey is always padded */)
>=20
> static inline void bkey_copy_key(struct bkey *dest, const struct bkey =
*src)
> {
> diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
> index e5da469a4235..c182c21de2e8 100644
> --- a/drivers/md/bcache/journal.c
> +++ b/drivers/md/bcache/journal.c
> @@ -149,7 +149,8 @@ reread: left =3D ca->sb.bucket_size - offset;
>    bytes, GFP_KERNEL);
> if (!i)
> return -ENOMEM;
> - memcpy(&i->j, j, bytes);
> + unsafe_memcpy(&i->j, j, bytes,
> + /* "bytes" was calculated by set_bytes() above */);
> /* Add to the location after 'where' points to */
> list_add(&i->list, where);
> ret =3D 1;
> --=20
> 2.34.1
>=20

