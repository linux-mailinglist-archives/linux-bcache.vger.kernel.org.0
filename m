Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDF879342C
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Sep 2023 05:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbjIFDkX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 5 Sep 2023 23:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236931AbjIFDkV (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 5 Sep 2023 23:40:21 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37499E4D;
        Tue,  5 Sep 2023 20:40:15 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1E5C020290;
        Wed,  6 Sep 2023 03:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1693971613; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7xis7xzf+MVEaW/J7IjaVMaZEMI+aE1E/xv5ZFYMwsU=;
        b=bp9RLPiL+8jv5gUhapq7sDDEtGMf8TJnIwizNw9BLD5DeHgI83pL7GZ8tcZX2ZKob9m69M
        WxVTAC4nz11rO57uRM4Y11LWlAWw3bqXZ6WzzTcQuGjC7o6j4eX3v3kVy2jeMt7KHNsOMA
        h0bX0H96w4oiDLK5M2Dgr4Ms+jlaY1c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1693971613;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7xis7xzf+MVEaW/J7IjaVMaZEMI+aE1E/xv5ZFYMwsU=;
        b=FOSh83YPUAqr95CHWYDzc5yaDjlQByAITNAlCneRPczwvSA+u1i6+btuzHP85JWwHrR4EZ
        YD+NGv0ymiz1wxAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 93BCD13585;
        Wed,  6 Sep 2023 03:40:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 5AwrGZv092RqXAAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 06 Sep 2023 03:40:11 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.700.6\))
Subject: Re: [PATCH] bcache: prevent potential division by zero error
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230906012249.49203-1-rand.sec96@gmail.com>
Date:   Wed, 6 Sep 2023 11:39:59 +0800
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        linux-kernel@vger.kernel.org, deeb.rand@confident.ru,
        lvc-project@linuxtesting.org, voskresenski.stanislav@confident.ru
Content-Transfer-Encoding: quoted-printable
Message-Id: <12DB1EC7-28CA-4792-B411-E09918B9C828@suse.de>
References: <20230906012249.49203-1-rand.sec96@gmail.com>
To:     Rand Deeb <rand.sec96@gmail.com>
X-Mailer: Apple Mail (2.3731.700.6)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B49=E6=9C=886=E6=97=A5 09:22=EF=BC=8CRand Deeb =
<rand.sec96@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> In SHOW(), the variable 'n' is of type 'size_t.' While there is a
> conditional check to verify that 'n' is not equal to zero before
> executing the 'do_div' macro, concerns arise regarding potential
> division by zero error in 64-bit environments.
>=20
> The concern arises when 'n' is 64 bits in size, greater than zero, and
> the lower 32 bits of it are zeros. In such cases, the conditional =
check
> passes because 'n' is non-zero, but the 'do_div' macro casts 'n' to
> 'uint32_t,' effectively truncating it to its lower 32 bits.
> Consequently, the 'n' value becomes zero.
>=20
> To fix this potential division by zero error and ensure precise
> division handling, this commit replaces the 'do_div' macro with
> div64_u64(). div64_u64() is designed to work with 64-bit operands,
> guaranteeing that division is performed correctly.
>=20
> This change enhances the robustness of the code, ensuring that =
division
> operations yield accurate results in all scenarios, eliminating the
> possibility of division by zero, and improving compatibility across
> different 64-bit environments.
>=20
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>=20
> Signed-off-by: Rand Deeb <rand.sec96@gmail.com>

Thanks, added into my for-next queue.

Coly Li

> ---
> drivers/md/bcache/sysfs.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index 554e3afc9b68..ca3e2f000cd4 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -1078,7 +1078,7 @@ SHOW(__bch_cache)
> sum +=3D INITIAL_PRIO - cached[i];
>=20
> if (n)
> - do_div(sum, n);
> + sum =3D div64_u64(sum, n);
>=20
> for (i =3D 0; i < ARRAY_SIZE(q); i++)
> q[i] =3D INITIAL_PRIO - cached[n * (i + 1) /
> --=20
> 2.34.1
>=20

