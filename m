Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA017DB475
	for <lists+linux-bcache@lfdr.de>; Mon, 30 Oct 2023 08:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbjJ3Hi0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 30 Oct 2023 03:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjJ3Hi0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 30 Oct 2023 03:38:26 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FF3A7;
        Mon, 30 Oct 2023 00:38:23 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1C6791FEDD;
        Mon, 30 Oct 2023 07:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1698651502; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=POOUX/d8rILNu4kY0NehNla8wNVcSgPqGmuaJwG6QVM=;
        b=jUrdh3/4R7K4A92i22xlDUBdw2eLsqEQnrpPTseRqpJcHtqBpx6Pck/IAWiGnRK713jayu
        lePMtm7c22JlK5ojW/8NP313b+fPW9dwAjvbYCFx/xMPatUT6V4HNNFZ8kZ6Yv8n41FoWP
        qTLiByj1JVt65kAEkOCkJAi/qsNhwSA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1698651502;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=POOUX/d8rILNu4kY0NehNla8wNVcSgPqGmuaJwG6QVM=;
        b=sm4XNJ6sypINzyvdn2Ioc9TOg+IS7DwUrvRnGW2T09ld40zitJBgXufO3OpnsawWnwP482
        m7vS2E8gr3XeaiAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CE169138F8;
        Mon, 30 Oct 2023 07:38:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id P3wUJmxdP2V+UAAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 30 Oct 2023 07:38:20 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.200.91.1.1\))
Subject: Re: [PATCH] bcache: Optimize sysfs_hprint()
From:   Coly Li <colyli@suse.de>
In-Reply-To: <9b82413f1ca0b924cc139d945777e32dd22ffe41.1698575385.git.christophe.jaillet@wanadoo.fr>
Date:   Mon, 30 Oct 2023 15:38:08 +0800
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BF96F92E-B483-4FC7-B4DB-B9D76E44D9A7@suse.de>
References: <9b82413f1ca0b924cc139d945777e32dd22ffe41.1698575385.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
X-Mailer: Apple Mail (2.3774.200.91.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B410=E6=9C=8829=E6=97=A5 18:30=EF=BC=8CChristophe JAILLET =
<christophe.jaillet@wanadoo.fr> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> The size of what is in 'buf' is already computed by bch_hprint(), so =
skip
> these bytes when calling strcat().
>=20
> This easily saves a few cycles. (should it matter)
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Your change does save several cpu cycles, but hurts the readability. =
This is not hot code path, just let strcat to do what it was designed =
for.=20

Thanks.

Coly Li

> ---
> drivers/md/bcache/sysfs.h | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/bcache/sysfs.h b/drivers/md/bcache/sysfs.h
> index 65b8bd975ab1..798bcbeab0bb 100644
> --- a/drivers/md/bcache/sysfs.h
> +++ b/drivers/md/bcache/sysfs.h
> @@ -78,7 +78,7 @@ do { \
> do { \
> if (attr =3D=3D &sysfs_ ## file) { \
> ssize_t ret =3D bch_hprint(buf, val); \
> - strcat(buf, "\n"); \
> + strcat(buf + ret, "\n"); \
> return ret + 1; \
> } \
> } while (0)
> --=20
> 2.34.1
>=20

