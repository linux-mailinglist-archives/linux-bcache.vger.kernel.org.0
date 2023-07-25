Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC7D67618C2
	for <lists+linux-bcache@lfdr.de>; Tue, 25 Jul 2023 14:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbjGYMtf (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 25 Jul 2023 08:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjGYMtf (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 25 Jul 2023 08:49:35 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4997FC4;
        Tue, 25 Jul 2023 05:49:34 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CAEDD1F8D6;
        Tue, 25 Jul 2023 12:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1690289372; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zfxaBQKu9pFIm/CSy+E7ZH0ZFKwSyMdTppqUuWuzZK0=;
        b=ZMW4KhwS4YTYl+FNV2yCV2SSG41p47it3FrxFVbR/XWhq17vatqFq2tKkAhE/HsTr8QAnG
        CapZET8Je9swPUfnQvwTg865CY5pfsHFaGYsTC5W+8v0DA96Z6457nsq5IlLkV1GgiKFZW
        qWG+XwT/hlObMz9POHaegXsrQWHmyKs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1690289372;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zfxaBQKu9pFIm/CSy+E7ZH0ZFKwSyMdTppqUuWuzZK0=;
        b=jmc0w2TxfUsZ/vakyCbU30JoTCHxiH82j4PTfH38/9kRlQoZOgsX8U/VmK5C/w+VJFHuDP
        O8wUkSf6Tjc8TLCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B1E0813342;
        Tue, 25 Jul 2023 12:49:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id G63YINvEv2TbSwAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 25 Jul 2023 12:49:31 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [PATCH][next] bcache: remove redundant assignment to variable
 cur_idx
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230725114637.37073-1-colin.i.king@gmail.com>
Date:   Tue, 25 Jul 2023 20:49:19 +0800
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <DFEED6F9-45FE-48BA-BE50-51B780846DE3@suse.de>
References: <20230725114637.37073-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B47=E6=9C=8825=E6=97=A5 19:46=EF=BC=8CColin Ian King =
<colin.i.king@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Variable cur_idx is being initialized with a value that is never read,
> it is being re-assigned later in a while-loop. Remove the redundant
> assignment. Cleans up clang scan build warning:
>=20
> drivers/md/bcache/writeback.c:916:2: warning: Value stored to =
'cur_idx'
> is never read [deadcode.DeadStores]
>=20
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Looks good to me. Thanks.

Reviewed-by: Coly Li <colyli@suse.de>


Coly Li

> ---
> drivers/md/bcache/writeback.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/bcache/writeback.c =
b/drivers/md/bcache/writeback.c
> index 24c049067f61..c3e872e0a6f2 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -913,7 +913,7 @@ static int bch_dirty_init_thread(void *arg)
> int cur_idx, prev_idx, skip_nr;
>=20
> k =3D p =3D NULL;
> - cur_idx =3D prev_idx =3D 0;
> + prev_idx =3D 0;
>=20
> bch_btree_iter_init(&c->root->keys, &iter, NULL);
> k =3D bch_btree_iter_next_filter(&iter, &c->root->keys, bch_ptr_bad);
> --=20
> 2.39.2
>=20

