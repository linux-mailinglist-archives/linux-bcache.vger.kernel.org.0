Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBCD95BBD8C
	for <lists+linux-bcache@lfdr.de>; Sun, 18 Sep 2022 13:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiIRLOi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 18 Sep 2022 07:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiIRLOf (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 18 Sep 2022 07:14:35 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A818263A0;
        Sun, 18 Sep 2022 04:14:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3FB521FCFC;
        Sun, 18 Sep 2022 11:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663499672; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z88k5CFn028Q/g1oPy/rncoeIdJPuQy1sUIv/gjtf1Y=;
        b=mwz638S3jdVs9MXJ5erm1ZF7xdUyBjL0EHDGsvGf2X5icN64kxpi9BRUgxm8vYumObv+Ys
        2cRgh1Vs6EKScALtbXyNXCBbLxGjMHyZl6vSnceB9DLJNqF+J9PccnsL0Bn74TnHOYy/H3
        QXmvLDdCtZ56t5IkKuxv92h2WQVfWOk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663499672;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z88k5CFn028Q/g1oPy/rncoeIdJPuQy1sUIv/gjtf1Y=;
        b=9DM26iLHFB+yP/3hw4vrrzXamR3sGO1vfGHStPeZvzifc74I2ReW2GFPTUzDCE9M6jnGb0
        4LtQz47sbou2nOCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3CF601346B;
        Sun, 18 Sep 2022 11:14:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id XJ4vA5f9JmO1YgAAMHmgww
        (envelope-from <colyli@suse.de>); Sun, 18 Sep 2022 11:14:31 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH] bcache: fix repeated words in comments
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220918094549.17325-1-yuanjilin@cdjrlc.com>
Date:   Sun, 18 Sep 2022 19:14:28 +0800
Cc:     kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1D1C7BF6-80AD-40C7-BAD9-7FEB2C2A9E92@suse.de>
References: <20220918094549.17325-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B49=E6=9C=8818=E6=97=A5 17:45=EF=BC=8CJilin Yuan =
<yuanjilin@cdjrlc.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Delete the redundant word 'by'.
>=20
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> ---
> drivers/md/bcache/bset.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
> index 94d38e8a59b3..6a24a327dce2 100644
> --- a/drivers/md/bcache/bset.c
> +++ b/drivers/md/bcache/bset.c
> @@ -1264,7 +1264,7 @@ static void __btree_sort(struct btree_keys *b, =
struct btree_iter *iter,
> 		 *
> 		 * Don't worry event 'out' is allocated from mempool, it =
can
> 		 * still be swapped here. Because state->pool is a page =
mempool
> -		 * creaated by by mempool_init_page_pool(), which =
allocates
> +		 * creaated by mempool_init_page_pool(), which allocates
> 		 * pages by alloc_pages() indeed.
> 		 */
>=20
> --=20
> 2.36.1
>=20

Oops, the applying failed because Jules already posted a similar fix, =
and his version is better because the typo =E2=80=9Ccreaated=E2=80=9D =
also fixed to =E2=80=9Ccreated=E2=80=9D.

So this patch won=E2=80=99t go into my for-next. Just FYI.

Thanks.

Coly Li=
