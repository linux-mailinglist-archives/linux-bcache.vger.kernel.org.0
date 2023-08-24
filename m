Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84745787568
	for <lists+linux-bcache@lfdr.de>; Thu, 24 Aug 2023 18:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbjHXQcI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 24 Aug 2023 12:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242579AbjHXQbs (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 24 Aug 2023 12:31:48 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058BAE4E
        for <linux-bcache@vger.kernel.org>; Thu, 24 Aug 2023 09:31:46 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A3BA81F388;
        Thu, 24 Aug 2023 16:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1692894705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lg/4DztaNj/Ag2D9sQ9nAQsMyZe00U3Hbp7slcVFM+Q=;
        b=ley6bNh/GVvsL/7FKRFQTOJJ7gduaIxFDXIh68dkcGouVK4K/STwLXfgNWvcDjdghCOLVH
        p8Kv3dcTDVBXc9FH6HHlulDdcjiP0gNv76/Y8tjh3GcmpCjDYQDInkSTCggP4sBiOQAZzp
        uNLLU5MVcdb59X2Hz03Rq3q3NRc7iuo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1692894705;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lg/4DztaNj/Ag2D9sQ9nAQsMyZe00U3Hbp7slcVFM+Q=;
        b=Dzw95qIyFcMa+XMawKWPoNcJpdqpPrRln9PiZActC2GdVxdrx4m9XNd7jUOiUYASQXVAkR
        GDF++W+Cnx6AkACg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0BDE3132F2;
        Thu, 24 Aug 2023 16:31:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wCzhL++F52RJYAAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 24 Aug 2023 16:31:43 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [PATCH v2] bcache: fixup init dirty data errors
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230824125730.3273-1-mingzhe.zou@easystack.cn>
Date:   Fri, 25 Aug 2023 00:31:31 +0800
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        Bcache Linux <linux-bcache@vger.kernel.org>, zoumingzhe@qq.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <29E994AF-48BB-42E1-819A-DD0F1B0C5343@suse.de>
References: <20230824125730.3273-1-mingzhe.zou@easystack.cn>
To:     Mingzhe Zou <mingzhe.zou@easystack.cn>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B48=E6=9C=8824=E6=97=A5 20:57=EF=BC=8CMingzhe Zou =
<mingzhe.zou@easystack.cn> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> We found that after long run, the dirty_data of the bcache device
> will have errors. This error cannot be eliminated unless re-register.
>=20
> We also found that reattach after detach, this error can accumulate.
>=20
> In bch_sectors_dirty_init(), all inode <=3D d->id keys will be =
recounted
> again. This is wrong, we only need to count the keys of the current
> device.
>=20

I will refine the commit log a bit.


> Fixes: b144e45fc576 ("bcache: make bch_sectors_dirty_init() to be =
multithreaded")
> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>

Added into my for-next directory.

Thanks for the fix up!

Coly Li


> ---
> drivers/md/bcache/writeback.c | 5 ++++-
> 1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/bcache/writeback.c =
b/drivers/md/bcache/writeback.c
> index 24c049067f61..4a1079da95b2 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -991,8 +991,11 @@ void bch_sectors_dirty_init(struct bcache_device =
*d)
> op.count =3D 0;
>=20
> for_each_key_filter(&c->root->keys,
> -    k, &iter, bch_ptr_invalid)
> +    k, &iter, bch_ptr_invalid) {
> + if (KEY_INODE(k) !=3D op.inode)
> + continue;
> sectors_dirty_init_fn(&op.op, c->root, k);
> + }
>=20
> rw_unlock(0, c->root);
> return;
> --=20
> 2.17.1.windows.2
>=20

